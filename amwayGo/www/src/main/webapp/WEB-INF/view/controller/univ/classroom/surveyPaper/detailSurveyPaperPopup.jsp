<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_TYPE_GENERAL"                 value="${aoffn:code('CD.SURVEY_TYPE.GENERAL')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE" value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.MULTIPLE_CHOICE')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER"    value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.ESSAY_ANSWER')}"/>

<html decorator="learning">
<head>
<title></title>
<script type="text/javascript">
var SUB = {
	forAnswer : null,
	forSessionAjax : null,
	initPage : function() {
		var error = "<c:out value="${empty errorCode ? 'false' : 'true'}"/>";
		if (error === "true") {
			$.alert({
				message : "<spring:message code="글:비정상적인접근입니다"/>",
				button1 : {
					callback : function() {
						SUB.doClose();
					}
				}
			});
			return;
		}
		
		var ready = "<c:out value="${empty listElement ? 'false' : 'true'}"/>";
		if (ready === "false") {
			$.alert({
				message : "<spring:message code="글:설문:설문지가준비되지않았습니다"/>",
				button1 : {
					callback : function() {
						SUB.doClose();
					}
				}
			});
			return;
		}
		
		// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
		SUB.doInitializeLocal();
		
		// 세션 10분마다 체크
		var sessionTimer = setInterval(function() {
			SUB.doCheckSession();
		}, 15 * 60 * 1000);
	},
	/**
	 * 설정
	 */
	doInitializeLocal : function() {
		SUB.forAnswer = $.action("submit", {formId : "SubFormAnswer"}); // validator를 사용하는 action은 formId를 생성시 setting한다
		SUB.forAnswer.config.url             = "<c:url value="/usr/classroom/surveypaper/answer/insert.do"/>";
		SUB.forAnswer.config.target          = "hiddenframe";
		SUB.forAnswer.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
		SUB.forAnswer.config.message.success = "<spring:message code="글:저장되었습니다"/>";
		SUB.forAnswer.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
		SUB.forAnswer.config.fn.validate     = SUB.doValidateAnswer;
		SUB.forAnswer.config.fn.complete     = function() {
			SUB.doClose();
		};
		
		forSessionAjax = $.action("ajax");
		forSessionAjax.config.type = "json";
		forSessionAjax.config.formId = "SubFormAnswer";
		forSessionAjax.config.url  = "<c:url value="/usr/classroom/ping/ajax.do"/>";
		forSessionAjax.config.fn.complete     = function() {
			
		};
	},
	/**
	 * validate
	 */
	doValidateAnswer : function() {
		var noAnswerIndex = -1;
		var $form = jQuery("#" + SUB.forAnswer.config.formId);
		$form.find(".answer-hidden").not(".notedit").each(function(index) {
			var $this = jQuery(this);
			var selected = false;
			$this.find(":input[name^='surveyAnswer']").each(function() {
				if (this.value == "Y") {
					selected = true;
				}
			});
			if (selected == false) {
				noAnswerIndex = $this.find(":input[name='countNumber']").val();
				return false;  // each break;
			}
		});
		if (noAnswerIndex > -1) {
			$.alert({
				message : "<spring:message code="글:설문:X번문제의답을선택하십시오"/>".format({0:(noAnswerIndex)})
			});
			return false;
		}
		jQuery(":input[name='essayAnswers']").each(function(index) {
			if (noAnswerIndex > -1) {
				return;
			}
			if (jQuery(this).hasClass("notedit") == false && this.value.trim() == "") {
				noAnswerIndex = index;
			}
		});
		if (noAnswerIndex > -1) {
			$.alert({
				message : "<spring:message code="글:설문:X번문제의답을입력하십시오"/>".format({0:(noAnswerIndex + 1)})
			});
			return false;
		}
		return true;
	},
	/**
	 * 저장
	 */
	doAnswer : function() {
		SUB.forAnswer.run();
	},
	/**
	 * 답 선택
	 */
	doChoice : function(element) {
		var $element = jQuery(element);

		if ($element.hasClass("answer-selected")) {
			$element.removeClass("answer-selected");
		} else {
			$element.addClass("answer-selected");
			if ($element.hasClass("answer-radio")) {
				$element.siblings(".answer-item").removeClass("answer-selected");
			}
		}

		// 문제영역에서 체크하기
		var exampleIndex = $element.attr("example-index");
		var questionIndex = $element.attr("question-index");
		var $exampleItem = jQuery("#example-item-" + questionIndex + "-" + exampleIndex);
		if ($element.hasClass("answer-selected")) {
			$exampleItem.addClass("answer-selected");
			if ($element.hasClass("answer-radio")) {
				$exampleItem.siblings(".example-item").removeClass("answer-selected");
			}
		} else {
			$exampleItem.removeClass("answer-selected");
		}
		
		var $parent = $element.parent();
		var $selected = $parent.find(".answer-selected");
		var $hidden = $parent.find(".answer-hidden");
		$hidden.find(":input[name^='surveyAnswer']").val("0"); // surveyAnswer로 시작하는 element를 모두 0으로 초기화.
		$selected.each(function() {
			var $this = jQuery(this);
			var exIndex = $this.attr("example-index");
			$hidden.find(":input[name='surveyAnswer" + exIndex + "Yns']").val("Y");
		});
	},
	/**
	 * 창 닫기
	 */
	doClose : function() {
		if ($layer != null) {
			$layer.dialog("close");
		}
	},
	/**
	 * 문제 스크롤
	 */
	doScroll : function(index) {
		var $question = jQuery("#question-" + index);
		var $scroller = $question.closest(".scroller"); 
		$scroller.scrollTop($scroller.scrollTop() + ($question.offset().top - $scroller.offset().top));
	},
	/**
	* 세션 타임아웃 체크
	*/
	doCheckSession : function() {
		forSessionAjax.run();
	}
};
</script>
</head>

<body>

	<div class="learning" style="height:738px;">
		<div class="pop-header">
			<h3><span class="pop-header-survey"></span><c:out value="${detailSurveyPaper.surveyPaper.surveyPaperTitle}"/></h3>
			<a href="javascript:void(0)" onclick="SUB.doClose()" class="close"><aof:img src="common/pop_close.gif" alt="버튼:닫기" /></a>
		</div>
	
	<div class="section-contents">
		<div class="data scroller" style="width:735px; height:701px;">
			<c:forEach var="row" items="${listElement}" varStatus="i">
				<div class="question" id="question-<c:out value="${i.count}"/>">
					<div class="question-head">
						<c:out value="${i.count}"/>. 
					</div>
					
					<div class="question-title">
						<c:out value="${row.univSurvey.surveyTitle}"/>
						<span class="question-type">
							<c:choose>
								<c:when test="${row.univSurvey.surveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
									[<aof:code type="print" codeGroup="SURVEY_GENERAL_TYPE" selected="${row.univSurvey.surveyItemTypeCd}"/>]
								</c:when>
								<c:otherwise>
									[<aof:code type="print" codeGroup="SURVEY_SATISFY_TYPE" selected="${row.univSurvey.surveyItemTypeCd}"/>]
								</c:otherwise>
							</c:choose>
						</span>
					</div>
					
					<ul class="question-body">
						<c:choose>
							<c:when test="${row.univSurvey.surveyItemTypeCd eq CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER}">
								<li class="example-item"><spring:message code="글:설문:서술하십시오"/></li>
							</c:when>
							<c:otherwise>
								<c:forEach var="rowSub" items="${row.listSurveyExample}" varStatus="iSub">
									<li class="example-item" id="example-item-<c:out value="${i.count}"/>-<c:out value="${iSub.count}"/>" >
										<span style="margin-right:3px;"><spring:message code="글:설문:${iSub.count}"/></span>
										<c:out value="${rowSub.univSurveyExample.surveyExampleTitle}"/>
									</li>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</ul>
				</div>	
			</c:forEach>
		</div>
	</div>
	
	<div class="section-answer">
		<div class="scroller" style="height:637px; overflow-x:hidden; overflow-y:auto;">
			<form id="SubFormAnswer" name="SubFormAnswer" method="post" onsubmit="return false;">
				<input type="hidden" name="courseActiveSurveySeq"  value="${detailSurveyPaper.courseActiveSurvey.courseActiveSurveySeq}">
				<input type="hidden" name="courseActiveSeq"  value="${detailSurveyPaper.courseActiveSurvey.courseActiveSeq}">
				<input type="hidden" name="surveyPaperSeq"   value="${detailSurveyPaper.courseActiveSurvey.surveyPaperSeq}">
				<input type="hidden" name="courseApplySeq"   value="${courseApply.courseApplySeq}">
				<input type="hidden" name="memberSeq"        value="${ssMemberSeq}">
				<input type="hidden" name="questionCount"    value="<c:out value="${aoffn:size(listElement)}"/>">
				
				<c:forEach var="row" items="${listElement}" varStatus="i">
					<div class="answer"
						<c:choose>
							<c:when test="${row.univSurvey.surveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
								title="<aof:code type="print" codeGroup="COURSE_SURVEY_GENERAL_TYPE" selected="${row.univSurvey.surveyItemTypeCd}"/>"
							</c:when>
							<c:otherwise>
								title="<aof:code type="print" codeGroup="COURSE_SURVEY_SATISFY_TYPE" selected="${row.univSurvey.surveyItemTypeCd}"/>"
							</c:otherwise>
						</c:choose>
					>
					
					<div class="answer-head" onclick="SUB.doScroll('<c:out value="${i.count}"/>')">
						<input type="hidden" name="surveySeqs"  value="<c:out value="${row.univSurvey.surveySeq}"/>">
						<input type="hidden" name="surveyItemTypeCds"  value="<c:out value="${row.univSurvey.surveyItemTypeCd}"/>">
						<c:out value="${i.count}"/>
					</div>
					<ul class="answer-body">
						<c:choose>
							<c:when test="${row.univSurvey.surveyItemTypeCd eq CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER}">
								<li class="answer-item answer-hidden notedit">
									<input type="hidden" name="surveyAnswer1Yns" value="N" class="notedit">
									<input type="hidden" name="surveyAnswer2Yns" value="N" class="notedit">
									<input type="hidden" name="surveyAnswer3Yns" value="N" class="notedit">
									<input type="hidden" name="surveyAnswer4Yns" value="N" class="notedit">
									<input type="hidden" name="surveyAnswer5Yns" value="N" class="notedit">
									<input type="hidden" name="surveyAnswer6Yns" value="N" class="notedit">
									<input type="hidden" name="surveyAnswer7Yns" value="N" class="notedit">
									<input type="hidden" name="countNumber" value="${i.count}">
								</li>
								<li class="answer-item answer-text">
									<textarea name="essayAnswers"></textarea>
								</li>
							</c:when>
							<c:otherwise>
								<li class="answer-item answer-hidden">
									<input type="hidden" name="essayAnswers" class="notedit">
									<input type="text" name="surveyAnswer1Yns" value="N">
									<input type="text" name="surveyAnswer2Yns" value="N">
									<input type="text" name="surveyAnswer3Yns" value="N">
									<input type="text" name="surveyAnswer4Yns" value="N">
									<input type="text" name="surveyAnswer5Yns" value="N">
									<input type="text" name="surveyAnswer6Yns" value="N">
									<input type="text" name="surveyAnswer7Yns" value="N">
									<input type="hidden" name="countNumber" value="${i.count}">
								</li>
								
								<c:set var="input" value="radio"/>
								<c:if test="${row.univSurvey.surveyItemTypeCd eq CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE}">
									<c:set var="input" value="checkbox"/>
								</c:if>
					
								<c:forEach var="rowSub" items="${row.listSurveyExample}" varStatus="iSub">
									<li class="answer-item answer-<c:out value="${input}"/>" onclick="SUB.doChoice(this)" 
										example-index="<c:out value="${iSub.count}"/>" question-index="<c:out value="${i.count}"/>" >
										<spring:message code="글:설문:${iSub.count}"/>
									</li>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</ul>
					
					</div>
				</c:forEach>
			</form>
		</div>
		
		<c:if test="${!empty listElement}">
			<ul class="buttons" style="padding:5px; border-top:solid 1px #fff;">
				<a href="javascript:void(0)" onclick="SUB.doAnswer();" class="btn black">
					<span class="small">
						<spring:message code="버튼:저장"/>
					</span>
				</a>
				<a href="javascript:void(0)" onclick="SUB.doClose();" class="btn black">
					<span class="small">
						<spring:message code="버튼:취소"/>
					</span>
				</a>
			</ul>
		</c:if>
		
	</div>
	</div>
</body>
</html>