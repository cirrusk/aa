<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_ORGANIZATION" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ORGANIZATION')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_QUIZ"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.QUIZ')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_JOIN"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.JOIN')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ONLINE"       value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ONLINE')}"/>
<c:set var="CD_EVALUATE_METHOD_TYPE_ABSOLUTE"    value="${aoffn:code('CD.EVALUATE_METHOD_TYPE.ABSOLUTE')}"/>
<c:set var="CD_GRADE_LEVEL_999"                  value="${aoffn:code('CD.GRADE_LEVEL.999')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_EVALUATE_METHOD_TYPE_ABSOLUTE = "<c:out value="${CD_EVALUATE_METHOD_TYPE_ABSOLUTE}"/>";
var CD_GRADE_LEVEL_999 = "<c:out value="${CD_GRADE_LEVEL_999}"/>";

var forSearch			= null;
var forListdata			= null;
var forEvaluate			= null;
var forUpdatelist		= null;
var forScript 			= null;
var forUpdate			= null;
var forExcelDown		= null;
var forDetailPopup		= null;
var forGradeLevelPopup	= null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
	// [2] sorting 설정
    FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action();
    forSearch.config.formId = "FormSrch";
    forSearch.config.url    = "<c:url value="/univ/course/apply/completion/list.do"/>";

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/course/apply/completion/list.do"/>";
    
    forEvaluate = $.action("ajax");
	forEvaluate.config.type = "json";
	forEvaluate.config.formId = "FormEvaluate";
	forEvaluate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forEvaluate.config.url  = "<c:url value="/univ/course/apply/completion/degree/evaluate.do"/>";
	
	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/univ/course/apply/completion/degree/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	forUpdatelist.validator.set({
		title : "<spring:message code="글:성적관리:저장할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	forUpdatelist.validator.set({
		title : "<spring:message code="필드:성적관리:가산"/><spring:message code="필드:성적관리:점수"/>",
		name : "addScores",
		data : ["decimalnumber"],
		check : {
			maxlength : 5
			<c:if test="${ssCurrentRoleCfString ne 'ADM'}">
			, ge : 3
			</c:if>
		}
	});
	
	forScript = $.action("script", {formId : "FormScript"});
	forScript.config.fn.exec = function() {
		var $scriptform = jQuery("#" + forScript.config.formId);
		var value = $scriptform.find(":input[name='addScore']").val(); 
		var $listform = jQuery("#" + forUpdatelist.config.formId);
		$listform.find(":input[name='checkkeys']").filter(":checked").each(function(){
			var $tr = jQuery(this).closest("tr");
			$tr.find(":input[name='addScores']").val(value);
			doCheckLimitValue($tr,"Y");
		});
	};
	forScript.validator.set({
		title : "<spring:message code="필드:성적관리:가산"/><spring:message code="필드:성적관리:점수"/>",
		name : "addScore",
		data : ["!null", "decimalnumber"],
		check : {
			maxlength : 5
			<c:if test="${ssCurrentRoleCfString ne 'ADM'}">
			, ge : 3
			</c:if>
		}
	});
	forScript.validator.set(function() {
		var $form = jQuery("#" + forUpdatelist.config.formId);
		if ($form.find(":input[name='checkkeys']").filter(":checked").length == 0) {
			$.alert({
				message : "<spring:message code="글:성적처리:적용할데이타를선택하십시오"/>"
			});
			return false;
		}
		return true;
	});
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/apply/complete/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:성적관리:성적확정시성적수정및총점재산출이불가능합니다현재정보로성적을확정하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:성적관리:성적확정처리되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	forExcelDown = $.action();
	forExcelDown.config.formId = "FormSrch";
	forExcelDown.config.target = "hiddenframe";
	forExcelDown.config.url    = "<c:url value="/univ/course/apply/completion/excel.do"/>";
	
	forDetailPopup = $.action("layer", {formId : "FormDetail"});
	forDetailPopup.config.url = "<c:url value="/univ/course/apply/completion/degree/popup.do"/>";
	forDetailPopup.config.options.width  = 700;
	forDetailPopup.config.options.height = 550;
	forDetailPopup.config.options.position = "middle";
	forDetailPopup.config.options.title  = "<spring:message code="글:성적관리:개인별세부성적"/>";
	
	forGradeLevelPopup = $.action("layer", {formId : "FormPopup"});
	forGradeLevelPopup.config.url = "<c:url value="/univ/gradelevel/popup.do"/>";
	forGradeLevelPopup.config.options.width  = 600;
	forGradeLevelPopup.config.options.height = 450;
	forGradeLevelPopup.config.options.position = "middle";
	forGradeLevelPopup.config.options.title  = "<spring:message code="글:성적관리:평가등급"/>";
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
    var form = UT.getById(forSearch.config.formId);
    
    // 목록갯수 셀렉트박스의 값을 변경 했을 때
    if (rows != null && form.elements["perPage"] != null) {  
        form.elements["perPage"].value = rows;
    }
    form.elements["currentPage"].value = 0;
    
    forSearch.run();
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
    var form = UT.getById(forListdata.config.formId);
    if(form.elements["currentPage"] != null && pageno != null) {
        form.elements["currentPage"].value = pageno;
    }
    doList();
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
};

/**
 * 저장완료
 */
doCompleteUpdatelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가수정되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
};

/**
 * 과락 검사
 */
doCheckLimitValue = function($tr,addScore) {
	var $listform = jQuery("#" + forUpdatelist.config.formId);
	
	var evaluateOnlineScore = $listform.find(":input[name='evaluateOnlineScore']").val();
	var evaluateProgressScore = $listform.find(":input[name='evaluateProgressScore']").val();
	var evaluateMidExamScore = $listform.find(":input[name='evaluateMidExamScore']").val();
	var evaluateFinalExamScore = $listform.find(":input[name='evaluateFinalExamScore']").val();
	var evaluateHomeworkScore = $listform.find(":input[name='evaluateHomeworkScore']").val();
	var evaluateTeamprojectScore = $listform.find(":input[name='evaluateTeamprojectScore']").val();
	var evaluateDiscussScore = $listform.find(":input[name='evaluateDiscussScore']").val();
	var evaluateQuizScore = $listform.find(":input[name='evaluateQuizScore']").val();
	var evaluateJoinScore = $listform.find(":input[name='evaluateJoinScore']").val();
	var evaluateOfflineScore = $listform.find(":input[name='evaluateOfflineScore']").val();
	
	evaluateOnlineScore = evaluateOnlineScore == "" ? 0 : parseInt(evaluateOnlineScore, 10);
	evaluateProgressScore = evaluateProgressScore == "" ? 0 : parseInt(evaluateProgressScore, 10);
	evaluateMidExamScore = evaluateMidExamScore == "" ? 0 : parseInt(evaluateMidExamScore, 10);
	evaluateFinalExamScore = evaluateFinalExamScore == "" ? 0 : parseInt(evaluateFinalExamScore, 10);
	evaluateHomeworkScore = evaluateHomeworkScore == "" ? 0 : parseInt(evaluateHomeworkScore, 10);
	evaluateTeamprojectScore = evaluateTeamprojectScore == "" ? 0 : parseInt(evaluateTeamprojectScore, 10);
	evaluateDiscussScore = evaluateDiscussScore == "" ? 0 : parseInt(evaluateDiscussScore, 10);
	evaluateQuizScore = evaluateQuizScore == "" ? 0 : parseInt(evaluateQuizScore, 10);
	evaluateJoinScore = evaluateJoinScore == "" ? 0 : parseInt(evaluateJoinScore, 10);
	evaluateOfflineScore = evaluateOfflineScore == "" ? 0 : parseInt(evaluateOfflineScore, 10);
	
	var limitFlag = false; // 하나라도 과락 일 경우 무조건 F
	var sum = 0;
	var $form = jQuery("#" + forUpdatelist.config.formId);
	
	// 온라인출석
	if(evaluateOnlineScore > 0){
		var onlineLimitValue = $form.find(":input[name='limitOnlineScore']").val();
		if (jQuery.isNumeric(onlineLimitValue) == true) {
			var limit = parseInt(onlineLimitValue, 10);
			$tr.find(":input[name='onAttendScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateOnlineScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 진도율
	if(evaluateProgressScore > 0){
		var progressLimitValue = $form.find(":input[name='limitProgressScore']").val();
		if (jQuery.isNumeric(progressLimitValue) == true) {
			var limit = parseInt(progressLimitValue, 10);
			$tr.find(":input[name='progressScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateProgressScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 중간고사
	if(evaluateMidExamScore > 0){
		var midExamLimitValue = $form.find(":input[name='limitMidExamScore']").val();
		if (jQuery.isNumeric(midExamLimitValue) == true) {
			var limit = parseInt(midExamLimitValue, 10);
			$tr.find(":input[name='middleExamScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateMidExamScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 기말고사
	if(evaluateFinalExamScore > 0){
		var finalExamLimitValue = $form.find(":input[name='limitFinalExamScore']").val();
		if (jQuery.isNumeric(finalExamLimitValue) == true) {
			var limit = parseInt(finalExamLimitValue, 10);
			$tr.find(":input[name='finalExamScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateFinalExamScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 과제
	if(evaluateHomeworkScore > 0){
		var homeworkLimitValue = $form.find(":input[name='limitHomeworkScore']").val();
		if (jQuery.isNumeric(homeworkLimitValue) == true) {
			var limit = parseInt(homeworkLimitValue, 10);
			$tr.find(":input[name='homeworkScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateHomeworkScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 팀프로젝트
	if(evaluateTeamprojectScore > 0){
		var teamprojectLimitValue = $form.find(":input[name='limitTeamprojectScore']").val();
		if (jQuery.isNumeric(teamprojectLimitValue) == true) {
			var limit = parseInt(teamprojectLimitValue, 10);
			$tr.find(":input[name='teamprojectScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateTeamprojectScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}

	// 토론
	if(evaluateDiscussScore > 0){
		var discussLimitValue = $form.find(":input[name='limitDiscussScore']").val();
		if (jQuery.isNumeric(discussLimitValue) == true) {
			var limit = parseInt(discussLimitValue, 10);
			$tr.find(":input[name='discussScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateDiscussScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 퀴즈
	if(evaluateQuizScore > 0){
		var quizLimitValue = $form.find(":input[name='limitQuizScore']").val();
		if (jQuery.isNumeric(quizLimitValue) == true) {
			var limit = parseInt(quizLimitValue, 10);
			$tr.find(":input[name='quizScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateQuizScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 참여
	if(evaluateJoinScore > 0){
		var joinLimitValue = $form.find(":input[name='limitJoinScore']").val();
		if (jQuery.isNumeric(joinLimitValue) == true) {
			var limit = parseInt(joinLimitValue, 10);
			$tr.find(":input[name='joinScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateJoinScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 오프라인출석
	if(evaluateOfflineScore > 0){
		var offlineLimitValue = $form.find(":input[name='limitOfflineScore']").val();
		if (jQuery.isNumeric(offlineLimitValue) == true) {
			var limit = parseInt(offlineLimitValue, 10);
			$tr.find(":input[name='offAttendScores']").each(function() {
				var $this = jQuery(this);
				if (jQuery.isNumeric(this.value) == false) {
					$this.addClass("limit");
					limitFlag = true;
				} else {
					var value = parseFloat(this.value);
					var origin = value * 100 / evaluateOfflineScore;
					sum += value;
					if (parseFloat(origin) < limit) {
						$this.addClass("limit");
						limitFlag = true;
					} else {
						$this.removeClass("limit");
					}
				}
			});
		}
	}
	
	// 성적합계
	$tr.find(":input[name='takeScores']").each(function() {
		this.value = sum;
	});
	
	// 가산점
	$tr.find(":input[name='addScores']").each(function() {
		var $this = jQuery(this);
		if (jQuery.isNumeric(this.value) == false) {
			//$this.addClass("limit");
		} else {
			var value = parseFloat(this.value);
			
			if((sum + value) > 100){
				value = 100 - sum;
				this.value = value;
			}
			
			sum += value;
			$this.removeClass("limit");
		}
	});
	
	// 최종점수
	$tr.find(":input[name='finalScores']").each(function() {
		var $this = jQuery(this);
		if(limitFlag){
			$this.addClass("limit");
		} else {
			$this.removeClass("limit");
		}
		
		this.value = sum;
	});
	
	
	if(addScore == 'Y'){
		doRank();
	}
	doCheckChangedValue();
};

/**
 * 순위
 */
doRank = function() {
	// 등수구하기
	doSortRelative();
	
	// 환산학점 : 시스템관리 > 성적등급관리 해당학기 성적등급
	
	var $listform = jQuery("#" + forUpdatelist.config.formId);	
	var $checked = $listform.find(":input[name='checkkeys']").filter(":checked");
	
	$checked.each(function() {
		var $this = jQuery(this);
		setTimeout(function() {
			var $tr = $this.closest("tr");
			var limitFlag = $tr.find(":input[name='finalScores']").hasClass("limit");
			var evalAbsoluteScore = 100;
			var evelRelativeScore = 1;
			
			if(limitFlag == false) {
				var sum = $tr.find(":input[name='finalScores']").val();
				if('<c:out value="${getDetail.courseActive.evaluateMethodTypeCd}" />' == CD_EVALUATE_METHOD_TYPE_ABSOLUTE) {	// 절대평가
				<c:forEach var="row" items="${listGradeLevel.itemList}" varStatus="i">
					if(evalAbsoluteScore >= sum && '<c:out value="${row.univGradeLevel.evalAbsoluteScore}" />' <= sum ) {
						$tr.find(":input[name='gradeLevelCds']").val("<c:out value="${row.univGradeLevel.gradeLevelCd }" />");
						$tr.find("#gradeLevel").html('<aof:code type="print" codeGroup="GRADE_LEVEL" selected="${row.univGradeLevel.gradeLevelCd }" />');
						
						<c:choose>
							<c:when test="${row.univGradeLevel.gradeLevelCd eq CD_GRADE_LEVEL_999 }">
								$tr.addClass("highlight");
							</c:when>
							<c:otherwise>
								$tr.removeClass("highlight");
							</c:otherwise>
						</c:choose>
					}
					
					evalAbsoluteScore = '<c:out value="${row.univGradeLevel.evalAbsoluteScore}" />';
				</c:forEach>
				} else {	// 상대평가
					var memberCount = jQuery("#listTable").find("tbody").find("tr").length;
					var rank = $tr.find(":input[name='rankings']").val();
					<c:forEach var="row" items="${listGradeLevel.itemList}" varStatus="i">
						if(Math.round((evelRelativeScore / 100) * memberCount) <= rank && Math.round(('<c:out value="${row.univGradeLevel.evelRelativeScore}" />'/ 100) * memberCount) > rank) {
							$tr.find(":input[name='gradeLevelCds']").val("<c:out value="${row.univGradeLevel.gradeLevelCd }" />");
							$tr.find("#gradeLevel").html('<aof:code type="print" codeGroup="GRADE_LEVEL" selected="${row.univGradeLevel.gradeLevelCd }" />');
							
							<c:choose>
								<c:when test="${row.univGradeLevel.gradeLevelCd eq CD_GRADE_LEVEL_999 }">
									$tr.addClass("highlight");
								</c:when>
								<c:otherwise>
									$tr.removeClass("highlight");
								</c:otherwise>
							</c:choose>
						}
					
					evelRelativeScore = '<c:out value="${row.univGradeLevel.evelRelativeScore}" />';
					</c:forEach>
				}
			} else {	// 가산점에 상관없이 하나라도 과락 일 경우 무조건 F
				$tr.find(":input[name='gradeLevelCds']").val(CD_GRADE_LEVEL_999);
				$tr.find("#gradeLevel").html('F');
				$tr.addClass('highlight');
			}
		}, 10);
	});
}

/**
 * 합계 값이 변경 되었는지 검사 
 */
doCheckChangedValue = function() {
	jQuery("#listTable").find(":checkbox").attr("checked", false);

	var changed = false;
	var $oldData = jQuery("#listTable").find(".oldData");
	$oldData.each(function(){
		var $this = jQuery(this);
		var newValue = $this.siblings(":input").val();
		if ($this.val() != newValue) {
			changed = true;
			$this.closest("tr").find(":checkbox").attr("checked", true);
		}
	});
	if (changed == true) {
		jQuery("#notsaved").show();
	} else {
		jQuery("#notsaved").hide();
	}
};

/**
 * 평가하기
 */
doEvaluate = function(EvaluateYn) {
	
	if(EvaluateYn){
		var $evalform = jQuery("#" + forEvaluate.config.formId);	
		var $listform = jQuery("#" + forUpdatelist.config.formId);	
		var $checked = $listform.find(":input[name='checkkeys']").filter(":checked");
		if ($checked.length > 0) {
			var $loadingbar = $.loadingbar();
			$loadingbar.show(forEvaluate.config.message.waiting);
			// 평가기준
			var evaluateOnlineScore = $listform.find(":input[name='evaluateOnlineScore']").val(); 
			var evaluateProgressScore = $listform.find(":input[name='evaluateProgressScore']").val();
			var evaluateMidExamScore = $listform.find(":input[name='evaluateMidExamScore']").val();
			var evaluateFinalExamScore = $listform.find(":input[name='evaluateFinalExamScore']").val();
			var evaluateHomeworkScore = $listform.find(":input[name='evaluateHomeworkScore']").val();
			var evaluateTeamprojectScore = $listform.find(":input[name='evaluateTeamprojectScore']").val();
			var evaluateDiscussScore = $listform.find(":input[name='evaluateDiscussScore']").val();
			var evaluateQuizScore = $listform.find(":input[name='evaluateQuizScore']").val();
			var evaluateJoinScore = $listform.find(":input[name='evaluateJoinScore']").val();
			var evaluateOfflineScore = $listform.find(":input[name='evaluateOfflineScore']").val();
			
			evaluateOnlineScore = evaluateOnlineScore == "" ? 0 : parseInt(evaluateOnlineScore, 10);
			evaluateProgressScore = evaluateProgressScore == "" ? 0 : parseInt(evaluateProgressScore, 10);
			evaluateMidExamScore = evaluateMidExamScore == "" ? 0 : parseInt(evaluateMidExamScore, 10);
			evaluateFinalExamScore = evaluateFinalExamScore == "" ? 0 : parseInt(evaluateFinalExamScore, 10);
			evaluateHomeworkScore = evaluateHomeworkScore == "" ? 0 : parseInt(evaluateHomeworkScore, 10);
			evaluateTeamprojectScore = evaluateTeamprojectScore == "" ? 0 : parseInt(evaluateTeamprojectScore, 10);
			evaluateDiscussScore = evaluateDiscussScore == "" ? 0 : parseInt(evaluateDiscussScore, 10);
			evaluateQuizScore = evaluateQuizScore == "" ? 0 : parseInt(evaluateQuizScore, 10);
			evaluateJoinScore = evaluateJoinScore == "" ? 0 : parseInt(evaluateJoinScore, 10);
			evaluateOfflineScore = evaluateOfflineScore == "" ? 0 : parseInt(evaluateOfflineScore, 10);
			
			// 참여평가기준
			var boardHighScore = $listform.find(":input[name='boardHighScore']").val();
			var boardHighFromCount = $listform.find(":input[name='boardHighFromCount']").val();
			var boardMiddleScore = $listform.find(":input[name='boardMiddleScore']").val();
			var boardMiddleFromCount = $listform.find(":input[name='boardMiddleFromCount']").val();
			var boardMiddleToCount = $listform.find(":input[name='boardMiddleToCount']").val();
			var boardLowScore = $listform.find(":input[name='boardLowScore']").val();
			var boardLowToCount = $listform.find(":input[name='boardLowToCount']").val();
			
			boardHighScore = boardHighScore == "" ? 0 : parseInt(boardHighScore, 10);
			boardHighFromCount = boardHighFromCount == "" ? 0 : parseInt(boardHighFromCount, 10);
			boardMiddleScore = boardMiddleScore == "" ? 0 : parseInt(boardMiddleScore, 10);
			boardMiddleFromCount = boardMiddleFromCount == "" ? 0 : parseInt(boardMiddleFromCount, 10);
			boardMiddleToCount = boardMiddleToCount == "" ? 0 : parseInt(boardMiddleToCount, 10);
			boardLowScore = boardLowScore == "" ? 0 : parseInt(boardLowScore, 10);
			boardLowToCount = boardLowToCount == "" ? 0 : parseInt(boardLowToCount, 10);
			
			var count = 0;
			$checked.each(function() {
				var $this = jQuery(this);
				var $tr = $this.closest("tr");
				$tr.addClass("notedit");
				setTimeout(function() {
					$evalform.find(":input[name='courseApplySeq']").val($this.siblings(":input[name='courseApplySeqs']").val());
					forEvaluate.config.fn.complete = function(action, data) {
						
						// 온라인출석
						if(evaluateOnlineScore > 0){
							var resultOnline = 0;
							if(data.resultOnline > 0){
								resultOnline = data.resultOnline;
							}
							
							if (data.resultOnline != null) {
								$tr.find(":input[name='onAttendScores']").val((Math.round(resultOnline)) * evaluateOnlineScore / 100);
							} else {
								$tr.find(":input[name='onAttendScores']").val(0);
								$tr.find(":input[name='onAttendScores']").addClass("selected");
							}	
						}
						
						// 주차
						if(evaluateProgressScore > 0){
							if (data.resultProgress != null && data.resultProgress.avgProgressMeasure != null) {
								$tr.find(":input[name='progressScores']").val((Math.round(data.resultProgress.avgProgressMeasure)) * evaluateProgressScore / 100);
							} else {
								$tr.find(":input[name='progressScores']").val(0);
								$tr.find(":input[name='progressScores']").addClass("selected");
							}
						}
						
						// 중간고사
						if(evaluateMidExamScore > 0){
							if (data.resultScoreMidExam != null) {
								$tr.find(":input[name='middleExamScores']").val(data.resultScoreMidExam * evaluateMidExamScore / 100 );
							} else {
								$tr.find(":input[name='middleExamScores']").val(0);
								$tr.find(":input[name='middleExamScores']").addClass("selected");
								
							}
						}
						
						// 기말고사
						if(evaluateFinalExamScore > 0){
							if (data.resultScoreFinalExam != null) {
								$tr.find(":input[name='finalExamScores']").val(data.resultScoreFinalExam * evaluateFinalExamScore / 100 );
							} else {
								$tr.find(":input[name='finalExamScores']").val(0);
								$tr.find(":input[name='finalExamScores']").addClass("selected");
							}
						}
						
						// 과제
						if(evaluateHomeworkScore > 0){
							if (data.resultScoreHomework != null) {
								$tr.find(":input[name='homeworkScores']").val(data.resultScoreHomework * evaluateHomeworkScore / 100);
							} else {
								$tr.find(":input[name='homeworkScores']").val(0);
								$tr.find(":input[name='homeworkScores']").addClass("selected");
							}
						}
						
						// 팀프로젝트
						if(evaluateTeamprojectScore > 0){
							if (data.resultScoreTeamproject != null) {
								$tr.find(":input[name='teamprojectScores']").val(data.resultScoreTeamproject * evaluateTeamprojectScore / 100);
							} else {
								$tr.find(":input[name='teamprojectScores']").val(0);
								$tr.find(":input[name='teamprojectScores']").addClass("selected");
							}
						}
	
						// 토론
						if(evaluateDiscussScore > 0){
							if (data.resultScoreDiscuss != null) {
								$tr.find(":input[name='discussScores']").val(data.resultScoreDiscuss * evaluateDiscussScore / 100);
							} else {
								$tr.find(":input[name='discussScores']").val(0);
								$tr.find(":input[name='discussScores']").addClass("selected");
							}
						}
						
						// 퀴즈
						if(evaluateQuizScore > 0){
							if (data.resultScoreQuiz != null) {
								$tr.find(":input[name='quizScores']").val(data.resultScoreQuiz * evaluateQuizScore / 100);
							} else {
								$tr.find(":input[name='quizScores']").val(0);
								$tr.find(":input[name='quizScores']").addClass("selected");
							}
						}
						
						// 참여
						if(evaluateJoinScore > 0){
							if (data.resultJoin != null) {
								var count = 0;
								for(var i = 0; i < data.resultJoin.length; i++) {
									count += data.resultJoin[i].bbsCount;
								}
								var value = 0;
								if (boardHighFromCount <= count) {
									value = boardHighScore;
								} else if (boardMiddleFromCount <= count && count <= boardMiddleToCount) {
									value = boardMiddleScore;
								} else if (count <= boardLowToCount) {
									value = boardLowScore;
								}
								
								$tr.find(":input[name='joinScores']").val(value * evaluateJoinScore / 100);
							} else {
								$tr.find(":input[name='joinScores']").val(0);
								$tr.find(":input[name='joinScores']").addClass("selected");
							}
						}
						
						// 오프라인출석
						if(evaluateOfflineScore > 0){
							var resultOffline = 0;
							if(data.resultOffline > 0){
								resultOffline = data.resultOffline;
							}
							
							if (data.resultOffline != null) {
								$tr.find(":input[name='offAttendScores']").val((Math.round(resultOffline)) * evaluateOfflineScore / 100);
							} else {
								$tr.find(":input[name='offAttendScores']").val(0);
								$tr.find(":input[name='offAttendScores']").addClass("selected");
							}
						}
						$loadingbar.hide();
						$tr.removeClass("notedit");
						
						doCheckLimitValue($tr);
					};
					forEvaluate.run();
					count++;
					if(count == $checked.length){
						doRank();
					}
				}, 10);
				
			});
			
		} else {
			$.alert({
				message : "<spring:message code="글:성적관리:채점할데이타를선택하십시오"/>"
			});
		}
	} else {
		$.alert({
			message : "<spring:message code="글:성적관리:성적산출기간이아닙니다"/>"
		});
	}
};

/**
 * 가산점변경
 */
doAddScore = function(element) {
	doCheckLimitValue(jQuery(element).closest("tr"),"Y");
};

/**
 * 가산점일괄적용
 */
doScript = function() {
	forScript.run();	
};

/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doUpdatelist = function() { 
	forUpdatelist.run();
};

/**
 * 상대평가목록 가져오기
 */
doListRelative = function() {
	doSearchReset(); // 검색조건 초기화
	var form = UT.getById(forSearch.config.formId);
	form.elements["currentPage"].value = "0";
	forSearch.run();
};

/**
 * 상대평가 정렬하기
 */
doSortRelative = function() {
	var $table = jQuery("#listTable");
	var $tbody = $table.find("tbody");
	var $tr = $tbody.find("tr");
	
	if ($tr.length >= 2) {
		var list = [];
		$tr.each(function() {
			var $this = jQuery(this);
			list.push({
				value : $this.find(":input[name='finalScores']").val(),
				$object : $this
			});			
		});
		
		list.sort(function(a, b){
			var aVal = parseFloat(a.value, 10);
			var $aLimit = a.$object.find(".limit");
			var bVal = parseFloat(b.value, 10);
			var $bLimit = b.$object.find(".limit");
			
			if (($aLimit.length > 0 && $bLimit.length > 0) || ($aLimit.length == 0 && $bLimit.length == 0)) {
				return aVal - bVal;
			} else if ($aLimit.length == 0 && $bLimit.length > 0) {
				return 1;
			} else if ($aLimit.length > 0 && $bLimit.length == 0) {
				return -1;
			}
		});
		
		list.reverse();
		$tbody.empty();
		for (var index in list) {
			list[index].$object.find(":checkbox").val(index);
			list[index].$object.appendTo($tbody);
		}
		
		var $prev = null;
		$tbody.find("tr").each(function(index) {
			var $this = jQuery(this);
			var rank = index + 1;
			var valThis = $this.find(":input[name='finalScores']").val();

			if ($prev != null) {
				var valPrev = $prev.find(":input[name='finalScores']").val();
				// 점수 동점이면 같은 순위이다.
				if (valThis == valPrev) {
					rank = $prev.find(".rank").text();
				}
			}
			$this.find(".rank").text(rank);
			$this.find(":input[name='rankings']").val(rank);
			$prev = $this;
		});
		$tbody.show(); // 정렬이 끝나면 보여줌
	}
};

/**
 * 성적 확정
 */
doGradeDecide = function(){
	var EvaluateYn = '<c:out value="${isGradeMakeDtime }" />';
	
	if(EvaluateYn){
		forUpdate.run();
	} else {
		$.alert({
			message : "<spring:message code="글:성적관리:성적산출기간이아닙니다"/>"
		});
	}
};

/**
 * 엑셀다운로드
 */
doExcel = function() {
	forExcelDown.run();
};

/**
 * 개인별 세부 성적팝업
 */
doDetailCompletionPopup = function(seq) {
	var form = UT.getById(forDetailPopup.config.formId);
	form.elements["courseApplySeq"].value = seq;

	forDetailPopup.run();
};

/**
 * 평가등급 팝업
 */
doEvaluatePopup = function() {
	forGradeLevelPopup.run();
};

/*
 * 개인정보관리 팝업
 */
doDetailPopup = function(memberSeq){
	FN.doDetailMemberPopup({url:"<c:url value="/member/detail/popup.do"/>", title: "<spring:message code="필드:맴버:개인정보관리"/>", memberSeq:memberSeq});
};

/*
 * 쪽지발송완료
 */
doCreateMemoComplete = function(){
	forListdata.run();
};

/**
 * 가산점 수정시 체크박스 체크 되도록
 */
doCheckIndex = function(){
	jQuery(":input[name='checkkeys']").attr('checked', true);
};

</script>
<style type="text/css">
.notedit {background-color:#d1d1d1;border:1px #d1d1d1 solid;}
.selected {background-color:yellow;}
.highlight {background-color:#d1d1d1;}
.limit {border:1px #ff0000 dotted;}
.limitsum {border:#ffffff;}
.warning {border:1px #ff0000 dotted; color:#ff0000; line-height:24px;}
</style>
</head>

<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:목록" /></c:param>
    </c:import>

    <div class="lybox-title"><!-- lybox-title -->
        <div class="right">
            <!-- 년도학기 / 개설과목 Shortcut Area Start -->
            <c:import url="../include/commonCourseActive.jsp"></c:import>
            <!-- 년도학기 / 개설과목 Shortcut Area End -->
        </div>
    </div>
    
     <!-- 평가기준 Start Area -->
    <c:import url="../courseActiveElement/include/commonCourseActiveEvaluate.jsp">
    	<c:param name="completionYn" value="Y"/>
    </c:import>
    <!-- 평가기준 Start End -->
    <div class="vspace"></div>
	<c:set var="srchKey">memberName=<spring:message code="필드:수강신청:이름"/>,memberId=<spring:message code="필드:수강신청:아이디"/></c:set>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	    <div class="lybox search">
	        <fieldset>
		        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
		        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	            
	            <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	            <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	            <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	            <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	            
		        <spring:message code="필드:교과목:학부"/> : 
	            <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;"/>
	            
	            <div class="vspace"></div>
	            <select name="srchKey" class="select">
	                <aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
	            </select>
	           
		        <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
		        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
	        </fieldset>
	    </div>
	</form>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(menuActiveList.menu.menuId)}"/>">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />

    <input type="hidden" name="srchApplyStatusCd"  value="<c:out value="${condition.srchApplyStatusCd}"/>" />
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
</form>
    
    <form id="FormEvaluate" name="FormEvaluate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseApplySeq">
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	</form>
    
    <form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
		<input type="hidden" name="gradeCompleteYn" value="Y"/>
	</form>
	
	<form id="FormDetail" name="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="courseApplySeq">
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	</form>
	
	<form id="FormPopup" name="FormPopup" method="post" onsubmit="return false;">
		<input type="hidden" name="srchYearTerm" value="${getDetail.courseActive.yearTerm}" />
		<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	</form>
	
	<c:set var="onlineEvaluateScore" value="0"/>
	<c:set var="onlineLimitScore" value="0"/>
	<c:set var="organizationEvaluateScore" value="0"/>
	<c:set var="organizationLimitScore" value="0"/>
	<c:set var="midExamEvaluateScore" value="0"/>
	<c:set var="midExamLimitScore" value="0"/>
	<c:set var="finalExamEvaluateScore" value="0"/>
	<c:set var="finalExamLimitScore" value="0"/>
	<c:set var="homeworkEvaluateScore" value="0"/>
	<c:set var="homeworkLimitScore" value="0"/>
	<c:set var="teamprojectEvaluateScore" value="0"/>
	<c:set var="teamprojectLimitScore" value="0"/>
	<c:set var="discussEvaluateScore" value="0"/>
	<c:set var="discussLimitScore" value="0"/>
	<c:set var="quizEvaluateScore" value="0"/>
	<c:set var="quizLimitScore" value="0"/>
	<c:set var="joinEvaluateScore" value="0"/>
	<c:set var="joinLimitScore" value="0"/>
	<c:set var="offlineEvaluateScore" value="0"/>
	<c:set var="offlineLimitScore" value="0"/>
	<c:forEach var="row" items="${listActiveEvaluate}" varStatus="i">
		<c:choose>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ONLINE}">
				<c:set var="onlineEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="onlineLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_ORGANIZATION}">
				<c:set var="organizationEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="organizationLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_MIDEXAM}">
				<c:set var="midExamEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="midExamLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_FINALEXAM}">
				<c:set var="finalExamEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="finalExamLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_HOMEWORK}">
				<c:set var="homeworkEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="homeworkLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}">
				<c:set var="teamprojectEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="teamprojectLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_DISCUSS}">
				<c:set var="discussEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="discussLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_QUIZ}">
				<c:set var="quizEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="quizLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
			<c:when test="${row.evaluate.evaluateTypeCd eq CD_COURSE_ELEMENT_TYPE_JOIN}">
				<c:set var="joinEvaluateScore" value="${row.evaluate.score}"/>
				<c:set var="joinLimitScore" value="${row.evaluate.limitScore}"/>
			</c:when>
		</c:choose>
	</c:forEach>
	
	<c:set var="boardHighScore" value="0"/>
	<c:set var="boardHighFromCount" value="0"/>
	<c:set var="boardMiddleScore" value="0"/>
	<c:set var="boardMiddleFromCount" value="0"/>
	<c:set var="boardMiddleToCount" value="0"/>
	<c:set var="boardLowScore" value="0"/>
	<c:set var="boardLowToCount" value="0"/>
	<c:forEach var="row" items="${listBoardEvaluate}" varStatus="i">
		<c:choose>
			<c:when test="${row.coursePostEvaluate.sortOrder eq 1}">
				<c:set var="boardHighScore" value="${row.coursePostEvaluate.score}"/>
				<c:set var="boardHighFromCount" value="${row.coursePostEvaluate.fromCount}"/>
			</c:when>
			<c:when test="${row.coursePostEvaluate.sortOrder eq 2}">
				<c:set var="boardMiddleScore" value="${row.coursePostEvaluate.score}"/>
				<c:set var="boardMiddleFromCount" value="${row.coursePostEvaluate.fromCount}"/>
				<c:set var="boardMiddleToCount" value="${row.coursePostEvaluate.toCount}"/>
			</c:when>
			<c:when test="${row.coursePostEvaluate.sortOrder eq 3}">
				<c:set var="boardLowScore" value="${row.coursePostEvaluate.score}"/>
				<c:set var="boardLowToCount" value="${row.coursePostEvaluate.toCount}"/>
			</c:when>
		</c:choose>
	</c:forEach>
			
    <c:set var="colspan" value="11" />
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <%-- 평가기준 --%>
    <input type="hidden" name="evaluateOnlineScore"			value="${onlineEvaluateScore}" />
	<input type="hidden" name="limitOnlineScore"			value="${onlineLimitScore}" />
    <input type="hidden" name="evaluateProgressScore"		value="${organizationEvaluateScore}" />
	<input type="hidden" name="limitProgressScore"			value="${organizationLimitScore}" />
	<input type="hidden" name="evaluateMidExamScore"		value="${midExamEvaluateScore}" />
	<input type="hidden" name="limitMidExamScore"			value="${midExamLimitScore}" />
	<input type="hidden" name="evaluateFinalExamScore"  	value="${finalExamEvaluateScore}" />
	<input type="hidden" name="limitFinalExamScore"     	value="${finalExamLimitScore}" />
	<input type="hidden" name="evaluateHomeworkScore"		value="${homeworkEvaluateScore}" />
	<input type="hidden" name="limitHomeworkScore"			value="${homeworkLimitScore}" />
	<input type="hidden" name="evaluateTeamprojectScore"	value="${teamprojectEvaluateScore}" />
	<input type="hidden" name="limitTeamprojectScore"		value="${teamprojectLimitScore}" />
	<input type="hidden" name="evaluateDiscussScore"		value="${discussEvaluateScore}" />
	<input type="hidden" name="limitDiscussScore"			value="${discussLimitScore}" />
	<input type="hidden" name="evaluateQuizScore"			value="${quizEvaluateScore}" />
	<input type="hidden" name="limitQuizScore"				value="${quizLimitScore}" />
	<input type="hidden" name="evaluateJoinScore"			value="${joinEvaluateScore}" />
	<input type="hidden" name="limitJoinScore"				value="${joinLimitScore}" />
	<input type="hidden" name="evaluateOfflineScore"		value="${offlineEvaluateScore}" />
	<input type="hidden" name="limitOfflineScore"			value="${offlineLimitScore}" />
	
	<%-- 참여게시판 평가기준 --%>
	<input type="hidden" name="boardHighScore" value="${boardHighScore}">
	<input type="hidden" name="boardHighFromCount" value="${boardHighFromCount}">
	<input type="hidden" name="boardMiddleScore" value="${boardMiddleScore}">
	<input type="hidden" name="boardMiddleFromCount" value="${boardMiddleFromCount}">
	<input type="hidden" name="boardMiddleToCount" value="${boardMiddleToCount}">
	<input type="hidden" name="boardLowScore" value="${boardLowScore}">
	<input type="hidden" name="boardLowToCount" value="${boardLowToCount}">
	
	<div class="modify">
		<strong><spring:message code="글:성적관리:성적확정이후에는성적수정및반영총점재산출이불가능합니다" /></strong> 
	</div> 
	<div style="width: 100%; overflow: auto;">			
    <table id="listTable" class="tbl-list">
    <colgroup>
		<col style="width: 50px" />
		<col style="width: 50px" />
		<col style="width: 70px" />
		<col style="width: 80px" />
		<c:if test="${onlineEvaluateScore > 0 }">
		<c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${organizationEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${midExamEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${finalExamEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${homeworkEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${teamprojectEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${discussEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${quizEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${joinEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if>
        <c:if test="${offlineEvaluateScore > 0 }">
        <c:set var="colspan" value="${colspan + 1 }" />
        <col style="width: 80px" />
        </c:if> 
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
	</colgroup>
    <thead>
        <tr>
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys');" /></th>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:성적관리:이름" /></span></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:성적관리:아이디" /></span></th>
			<c:if test="${onlineEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:온라인출석" /></th>
            </c:if>
            <c:if test="${organizationEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:진도" /></th>
            </c:if>
            <c:if test="${midExamEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:중간" /></th>
            </c:if>
            <c:if test="${finalExamEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:기말" /></th>
            </c:if>
            <c:if test="${homeworkEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:과제" /></th>
            </c:if>
            <c:if test="${teamprojectEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:팀플" /></th>
            </c:if>
            <c:if test="${discussEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:토론" /></th>
            </c:if>
            <c:if test="${quizEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:퀴즈" /></th>
            </c:if>
            <c:if test="${joinEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:참여" /></th>
            </c:if>
            <c:if test="${offlineEvaluateScore > 0 }">
            <th><spring:message code="필드:성적관리:오프라인출석" /></th>
            </c:if>            
            <th><spring:message code="필드:성적관리:합계" /></th>
            <th><spring:message code="필드:성적관리:가산점" /></th>
            <th><spring:message code="필드:성적관리:최종점수" /></th>
            <th><span class="sort" sortid="3"><spring:message code="필드:성적관리:환산학점" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:성적관리:등수" /></span></th>
            <th><spring:message code="필드:성적관리:산출일자" /></th>
            <th><spring:message code="필드:성적관리:상세" /></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr <c:if test="${row.apply.gradeLevelCd eq CD_GRADE_LEVEL_999 }">class="highlight"</c:if>>
                <td>
                    <input type="checkbox" name="checkkeys" id="checkkeys<c:out value="${i.index}"/>" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this)">
                    <input type="hidden" name="courseApplySeqs" value="<c:out value="${row.apply.courseApplySeq}" />">
					<input type="hidden" name="memberSeqs" value="<c:out value="${row.apply.memberSeq}" />">
					<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
					<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
                </td>
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td>
                    <a href="javascript:void(0);" onclick="doDetailPopup('<c:out value="${row.apply.memberSeq}" />')">
                        <c:out value="${row.member.memberName}"/>
                    </a>
                </td>
                <td><c:out value="${row.member.memberId}"/></td>
                <c:if test="${onlineEvaluateScore > 0 }">
            	<td>
                	<input type="text" name="onAttendScores" value="<c:out value="${aoffn:trimDouble(row.apply.onAttendScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${organizationEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="progressScores" value="<c:out value="${aoffn:trimDouble(row.apply.progressScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${midExamEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="middleExamScores" value="<c:out value="${aoffn:trimDouble(row.apply.middleExamScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${finalExamEvaluateScore > 0 }">
                <td>
                	<input type="text" name="finalExamScores" value="<c:out value="${aoffn:trimDouble(row.apply.finalExamScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${homeworkEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="homeworkScores" value="<c:out value="${aoffn:trimDouble(row.apply.homeworkScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${teamprojectEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="teamprojectScores" value="<c:out value="${aoffn:trimDouble(row.apply.teamprojectScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${discussEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="discussScores" value="<c:out value="${aoffn:trimDouble(row.apply.discussScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${quizEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="quizScores" value="<c:out value="${aoffn:trimDouble(row.apply.quizScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${joinEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="joinScores" value="<c:out value="${aoffn:trimDouble(row.apply.joinScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>
	            <c:if test="${offlineEvaluateScore > 0 }">
	            <td>
                	<input type="text" name="offAttendScores" value="<c:out value="${aoffn:trimDouble(row.apply.offAttendScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
	            </c:if>  
                <td>
                	<input type="text" name="takeScores" value="<c:out value="${aoffn:trimDouble(row.apply.takeScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
                <td>
                	<input type="text" name="addScores" value="<c:out value="${aoffn:trimDouble(row.apply.addScore)}"/>" style="width:45px;text-align:center;" onchange="doCheckIndex(<c:out value="${i.index}"/>); doAddScore(this);" />
                </td>
                <td>
                	<input type="hidden" name="oldFinalScores" value="<c:out value="${aoffn:trimDouble(row.apply.finalScore)}"/>" class="oldData">
                	<input type="text" name="finalScores" value="<c:out value="${aoffn:trimDouble(row.apply.finalScore)}"/>" style="width:45px;text-align:center;" readonly="readonly" />
                </td>
                <td>
                	<input type="hidden" name="gradeLevelCds" value="<c:out value="${row.apply.gradeLevelCd}"/>" />
                	<span id="gradeLevel"><aof:code type="print" codeGroup="GRADE_LEVEL" selected="${row.apply.gradeLevelCd}" /></span>
                </td>
                <td>
                	<span class="rank"><c:out value="${row.apply.ranking }" /></span>
                	<input type="hidden" name="rankings" value="<c:out value="${row.apply.ranking }" />" />
                </td>
                <td><aof:date datetime="${row.apply.gradeMakeDtime }" /></td>
                <td>
                	<a href="javascript:void(0)" onclick="doDetailCompletionPopup('<c:out value="${row.apply.courseApplySeq }" />');" class="btn gray">
	                    <span class="mid"><spring:message code="버튼:성적관리:보기" /></span>
	                </a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
            <tr>
                <td colspan="<c:out value="${colspan }"/>" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
    </table>
    </div>
    </form>
    
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>

    <div class="lybox-btn">
    <c:if test="${getDetail.courseActive.gradeCompleteYn eq 'N' }">
        <div class="lybox-btn-l">
        <form name="FormScript" id="FormScript" method="post" onsubmit="return false;">
        	<input type="text" name="addScore" id="addScore" value="<c:out value="${aoffn:trimDouble(row.courseApply.addScore)}"/>" style="width:45px;text-align:center;" />
        	<a href="javascript:void(0)" onclick="doScript()" class="btn blue">
                <span class="mid"><spring:message code="버튼:성적관리:가산점적용" /></span>
            </a>
        </form>
        </div>
     </c:if>

        <div class="lybox-btn-r" >
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
        		<c:if test="${getDetail.courseActive.gradeCompleteYn eq 'N' }">
        		<span class="warning" id="notsaved" style="display:none;"><spring:message code="글:성적관리:저장되지않은데이타가존재합니다"/></span>
                <a href="javascript:void(0)" onclick="doEvaluate(<c:out value="${isGradeMakeDtime }" />);" class="btn blue">
                    <span class="mid"><spring:message code="버튼:성적관리:총점산출" /></span>
                </a>
                </c:if>
                <a href="javascript:void(0)" onclick="doExcel();" class="btn blue">
                    <span class="mid"><spring:message code="버튼:엑셀" /></span>
                </a>
                <%--
                <a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue">
                	<span class="mid"><spring:message code="버튼:쪽지" /></span>
                </a>
				<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue">
					<span class="mid"><spring:message code="버튼:SMS" /></span>
				</a>
				<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue">
					<span class="mid"><spring:message code="버튼:이메일" /></span>
				</a>
				 --%>
                <c:if test="${getDetail.courseActive.gradeCompleteYn eq 'N' }">
                <a href="javascript:void(0)" onclick="doGradeDecide();" class="btn blue">
                    <span class="mid"><spring:message code="버튼:성적관리:성적확정" /></span>
                </a>
                <a href="javascript:void(0)" onclick="doUpdatelist();" class="btn blue">
                    <span class="mid"><spring:message code="버튼:성적관리:저장" /></span>
                </a>
                </c:if>
            </c:if>
        </div>
    </div>
    
</body>
</html>