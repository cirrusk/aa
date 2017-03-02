<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>
<c:set var="CD_SCORE_TYPE_002"       value="${aoffn:code('CD.SCORE_TYPE.002')}"/>
<c:set var="CD_SCORE_TYPE_003"       value="${aoffn:code('CD.SCORE_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_H"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.H')}"/>

<c:set var="appFormatDbDatetime" value="${aoffn:config('format.dbdatetime')}"/>
<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="${appFormatDbDatetime}"/></c:set>

<c:set var="completeYn" value="N" scope="request"/>
<c:if test="${detailCourseApplyElement.applyElement.completeYn eq 'Y'}">
	<c:set var="completeYn" value="Y" scope="request"/>
</c:if>

<html decorator="learning">
<head>
<script type="text/javascript">
var SUB = {
	swfu : null,
	forAnswer : null,
	forSessionAjax : null,
	runningTime : {
		timer : null,
		value : null,
		$element : null
	},
	remainTime : {
		timer : null,
		value : null,
		$element : null,
		$display : null
	},
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
		
		var ready = "<c:out value="${empty listExamAnswer ? 'false' : 'true'}"/>";
		if (ready === "false") {
			$.alert({
				message : "<spring:message code="글:시험:시험지가준비되지않았습니다"/>",
				button1 : {
					callback : function() {
						SUB.doClose();
					}
				}
			});
			return;
		}
		
		<c:if test="${completeYn eq 'Y'}">
		$.alert({
			message : "<spring:message code="글:시험:이미응시하였습니다"/>",
			button1 : {
				callback : function() {
					SUB.doClose();
				}
			}
		});
		return;
		</c:if>
		
		<c:if test="${today gt detailCourseExamPaper.courseActiveExamPaper.endDtime}">
		$.alert({
			message : "<spring:message code="글:시험:응시기간이지났습니다화면을종료합니다"/>",
			button1 : {
				callback : function() {
					SUB.doClose();
				}
			}
		});
		return;
		</c:if>
		
		// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
		SUB.doInitializeLocal();
		
		var uploaders = [];
		jQuery(".uploader").each(function() {
			uploaders.push({
				elementId : jQuery(this).attr("id"),
				postParams : {},
				options : {
					uploadUrl : "<c:url value="/attach/file/save.do"/>",
					fileTypes : "*.*",
					fileTypesDescription : "All Files",
					fileSizeLimit : "10 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputWidth : 120, // default : 350
					inputHeight : 20, // default : 20
					inputStyleClass : "file",
					immediatelyUpload : false,
					successCallback : function(id, file) {
						SUB.doSuccessCallback(id, file);
					}
				}
			});
		});
		
		// uploader
		SUB.swfu = UI.uploader.create(function() {
				SUB.forAnswer.run("continue");
			}, // completeCallback
			uploaders
		);
		
		// 남은시간 타이머
		if (SUB.doSetRemainTime() == true) {
			SUB.remainTime.timer = setInterval(function() {
				SUB.doRemainTimer();
			}, 1000);
		}
		
		// 실행시간 타이머
		SUB.runningTime.timer = window.setInterval(function() {
			SUB.doRunningTimer();
		}, 3000);
		
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
		SUB.forAnswer.config.url             = "<c:url value="/usr/classroom/exampaper/answer/update.do"/>";
		SUB.forAnswer.config.target          = "hiddenframe";
		SUB.forAnswer.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
		SUB.forAnswer.config.fn.validate     = SUB.doValidateAnswer;
		SUB.forAnswer.config.fn.before       = SUB.doStartUpload;
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
		$form.find(":input[name='choiceAnswers']").each(function(index) {
			if (jQuery(this).hasClass("notedit") == false && this.value.trim() == "") {
				noAnswerIndex = index;
				return false; // each break
			}
		});
		if (noAnswerIndex > -1) {
			$.alert({
				message : "<spring:message code="글:시험:X번문제의답을선택하십시오"/>".format({0:(noAnswerIndex + 1)})
			});
			return false;
		}
		jQuery(":input[name='attachKeys']").each(function(index) {
			if (jQuery(this).hasClass("notedit") == false && (this.value.trim() == "0" || this.value.trim() == "")) {
				var id = jQuery(this).siblings(".uploader").attr("id");
		 		if (UI.uploader.isAppendedFiles(SUB.swfu, id) == false) {
					noAnswerIndex = index;
					return false; // each break
				}
			}
		});
		if (noAnswerIndex > -1) {
			$.alert({
				message : "<spring:message code="글:시험:X번문제의파일을첨부하십시오"/>".format({0:(noAnswerIndex + 1)})
			});
			return false;
		}
		jQuery(":input[name='shortAnswers']").each(function(index) {
			if (jQuery(this).hasClass("notedit") == false && this.value.trim() == "") {
				noAnswerIndex = index;
				return false; // each break
			}
		});
		if (noAnswerIndex > -1) {
			$.alert({
				message : "<spring:message code="글:시험:X번문제의답을입력하십시오"/>".format({0:(noAnswerIndex + 1)})
			});
			return false;
		}
		jQuery(":input[name='essayAnswers']").each(function(index) {
			if (jQuery(this).hasClass("notedit") == false && this.value.trim() == "") {
				noAnswerIndex = index;
				return false; // each break
			}
		});
		if (noAnswerIndex > -1) {
			$.alert({
				message : "<spring:message code="글:시험:X번문제의답을입력하십시오"/>".format({0:(noAnswerIndex + 1)})
			});
			return false;
		}
		return true;
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
	* 파일업로드 시작
	*/
	doStartUpload : function() {
		var isAppendedFiles = false;
		jQuery(".uploader").each(function() {
	 		var id = jQuery(this).attr("id");
	 		if (UI.uploader.isAppendedFiles(SUB.swfu, id) == true) {
				isAppendedFiles = true;				
			}
	 	});
		if (isAppendedFiles == true) {
			UI.uploader.runUpload(SUB.swfu);
			return false;
			
		} else {
			return true;
		}
	},
	/**
	 * 파일업로드 완료 Callback
	 */
	doSuccessCallback : function(id, file) {
		var $element = jQuery("#" + id);
		var $uploader = $element.closest(".uploader");
		var $attachUploadInfos = $uploader.siblings(":input[name='attachUploadInfos']");
		$attachUploadInfos.val(UI.uploader.getUploadedData(SUB.swfu, id)); //$attachUploadInfos.val(file.serverData.fileInfo.attachUploadInfo);
	},
	/**
	 * 파일삭제
	 */
	doDeleteFile : function(element, seq) {
		var $element = jQuery(element);
		var $file = $element.closest("div");
		var $otherFiles = $file.siblings(".previousFile");
		var $uploader = $element.closest(".uploader");
		var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfos']");
		var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
		seqs.push(seq);
		$attachDeleteInfo.val(seqs.join(","));
		if ($otherFiles.length == 0) {
			$uploader.siblings(":input[name='attachKeys']").val("0");
		}
		$file.remove();
	},
	/**
	 * 제출 / 임시저장
	 */
	doAnswer : function(completeYn) {
		var form = UT.getById(SUB.forAnswer.config.formId);
		form.elements["completeYn"].value = completeYn;
		if (completeYn === "Y") {
			form.elements["answerCount"].value = "1";
			SUB.forAnswer.config.message.confirm = "<spring:message code="글:시험:제출하시겠습니까"/>"; 
			SUB.forAnswer.config.message.success = "<spring:message code="글:시험:제출되었습니다"/>";
		} else {
			form.elements["answerCount"].value = "0";
			SUB.forAnswer.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
			SUB.forAnswer.config.message.success = "<spring:message code="글:저장되었습니다"/>";
			SUB.forAnswer.config.fn.validate = function() {
				return true;
			};
		}
		SUB.forAnswer.run();
	},
	/**
	 * 자동 제출
	 */
	doAutoAnswer : function(completeYn) {
		var form = UT.getById(SUB.forAnswer.config.formId);
		form.elements["completeYn"].value = completeYn;
		SUB.forAnswer.config.fn.validate = function() {
			return true;
		};
		if (completeYn === "Y") {
			form.elements["answerCount"].value = "1";
			SUB.forAnswer.config.message.confirm = ""; 
			SUB.forAnswer.config.message.success = "<spring:message code="글:시험:제출되었습니다"/>";
		} else {
			form.elements["answerCount"].value = "0";
			SUB.forAnswer.config.message.confirm = ""; 
			SUB.forAnswer.config.message.success = "";
		}
		SUB.forAnswer.run();
	},
	/**
	 * 객관식 답 선택
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
		var seq = $element.attr("seq");
		var $exampleItem = jQuery("#example-item-" + seq);
		if ($element.hasClass("answer-selected")) {
			$exampleItem.addClass("answer-selected");
			if ($element.hasClass("answer-radio")) {
				$exampleItem.siblings(".example-item").removeClass("answer-selected");
			}
		} else {
			$exampleItem.removeClass("answer-selected");
		}
		
		var choiceValue = [];
		var $parent = $element.parent();
		if ($element.hasClass("answer-radio")) {
			$parent.find(".answer-radio").each(function() {
				var $this = jQuery(this);
				if ($this.hasClass("answer-selected")) {
					choiceValue.push($this.attr("seq"));
				}
			});
		} else if ($element.hasClass("answer-checkbox")) {
			$parent.find(".answer-checkbox").each(function() {
				var $this = jQuery(this);
				if ($this.hasClass("answer-selected")) {
					choiceValue.push($this.attr("seq"));
				}
			});
		}
		var $hidden = $parent.find(".answer-hidden");

		$hidden.find(":input[name='choiceAnswers']").val(choiceValue.join(","));
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
	 * 남은시간 계산
	 */
	doSetRemainTime : function() {
		var $form = jQuery("#" + SUB.forAnswer.config.formId);
		var today = $form.find(":input[name='today']").val();
		var endday = $form.find(":input[name='endday']").val();
		var examTime = $form.find(":input[name='examTime']").val();
		var runningTime = $form.find(":input[name='runningTime']").val();
		
		examTime = examTime == "" ? 0 : parseInt(examTime, 10); 
		runningTime = runningTime == "" ? 0 : parseInt(runningTime, 10); 

		if (examTime == 0) {
			jQuery(".timer").hide();
			return false;
		}
		var todayDate = SUB.doGetDate(today);
		var enddayDate = SUB.doGetDate(endday);
		var gap = (enddayDate.getTime() - todayDate.getTime()) / 1000;
		$form.find(":input[name='remainTime']").val(gap < (examTime - runningTime) ? gap : examTime - runningTime);
		return true;
	},
	/**
	 * 스트링 -> Date
	 */
	doGetDate : function(s) {
		return new Date(s.substring(0,4), s.substring(4,6), s.substring(6,8), s.substring(8,10), s.substring(10,12), s.substring(12,14));
	},
	/**
	 * 남은시간 타이머
	 */
	doRemainTimer : function() {
		var $form = jQuery("#" + SUB.forAnswer.config.formId);
		var today = $form.find(":input[name='today']").val();
		var endday = $form.find(":input[name='endday']").val();

		if (SUB.remainTime.$element == null) {
			SUB.remainTime.$element = $form.find(":input[name='remainTime']");
		}
		if (SUB.remainTime.$display == null) {
			SUB.remainTime.$display = jQuery("#remainTimer");
		}
		if (SUB.remainTime.value == null) {
			SUB.remainTime.value = SUB.remainTime.$element.val();
			SUB.remainTime.value = SUB.remainTime.value == "" ? 0 : parseInt(SUB.remainTime.value, 10);
		}
		SUB.remainTime.$element.val(SUB.remainTime.value--);
		
		var h = parseInt((SUB.remainTime.value / 3600), 10);
		if (h < 10) {
			h = "0" + h;
		}
		var m = parseInt(((SUB.remainTime.value % 3600) / 60), 10);
		if (m < 10) {
			m = "0" + m;
		}
		var s = (SUB.remainTime.value % 60);
		if (s < 10) {
			s = "0" + s;
		}
		var time = h + ":" + m + ":" + s;
		SUB.remainTime.$display.text(time);

		var $parent = SUB.remainTime.$display.parent();
		if (SUB.remainTime.value <= 300 && $parent.hasClass("warning") == false) { // 5분
			$parent.addClass("warning");
		}
		if (SUB.remainTime.value <= 0 || endday < today) {
			clearInterval(SUB.remainTime.timer);
			$.alert({message : "<spring:message code="글:시험:시험시간이종료되었습니다자동으로제출합니다"/>",
				button1 : {
					callback : function() {
						SUB.doAutoAnswer("Y");
					}
				}
			});
		}
	},
	/**
	 * 실행시간 타이머
	 */
	doRunningTimer : function() {
		if (SUB.runningTime.$element == null) {
			SUB.runningTime.$element = jQuery("#" + SUB.forAnswer.config.formId).find(":input[name='runningTime']");
		}
		if (SUB.runningTime.value == null) {
			SUB.runningTime.value = SUB.runningTime.$element.val();
			SUB.runningTime.value = SUB.runningTime.value == "" ? 0 : parseInt(SUB.runningTime.value, 10);
		}
		SUB.runningTime.$element.val(SUB.runningTime.value++);
	},
	/**
	 * 미디어 보이기
	 */
	doShowMedia : function(element) {
		var $element = jQuery(element).children().clone();
		var $overlay = jQuery(".section-overlay");
		var $section = jQuery(".section-media");
		var $sectionClose = jQuery("<div class='close'></div>");
		var $sectionMedia = jQuery("<div class='media'></div>");
		
		$section.empty();
		$section.append($sectionClose);
		$section.append($sectionMedia);
		
		var player = null;
		if ($element.hasClass("video")) {
			$sectionMedia.append($element);
			player = $element.media({width:400, height: 300, autoStart:false});	
		} else if ($element.hasClass("audio")) {
			$sectionMedia.append($element);
			player = $element.media({width:400, height: 30, autoStart:false});
		} else if ($element.hasClass("image")) {
			var $img = jQuery("<img class='image' src='" + $element.attr("src").replace(/.thumb.jpg$/,"") + "'>");
			$sectionMedia.append($img);
		}
		var $parentOverlay = $overlay.parent(); 
		$overlay.css({
			width : $parentOverlay.width() + "px",
			height : $parentOverlay.height() + "px"
		});
		$overlay.addClass("section-overlay-visible");
		$section.addClass("section-media-visible").position({of : $overlay, at : "center", my : "center"});
		$section.draggable({containment : "parent"});

		$sectionClose.on("click", function() {
			var object = $sectionMedia.find("object").get(0);
			if (typeof object === "object") {
				player.stop(object);
			}
			$section.empty();
			$section.removeClass("section-media-visible");
			$overlay.removeClass("section-overlay-visible");
		});
	},
	/**
	 * 탭 보기기/감추기
	 */
	doToggleTab : function(element, targetId) {
		var $element = jQuery(element);
		var $target = jQuery("#" + targetId);
		if ($target.is(":visible")) {
			$element.removeClass("tab-on");
			$target.removeClass("tab-section-visible");
		} else {
			jQuery(".tabs-bottom-left > .tab").removeClass("tab-on");
			$element.addClass("tab-on");
			$target.addClass("tab-section-visible");
			$target.siblings(".tab-section").removeClass("tab-section-visible");
		}
	},
	/**
	 * 탭 닫기
	 */
	doCloseTab : function(element) {
		jQuery(".tabs-bottom-left > .tab").removeClass("tab-on");
		jQuery(element).closest(".tab-section").removeClass("tab-section-visible");
	},
	/**
	* 세션 타임아웃 체크
	*/
	doCheckSession : function() {
		forSessionAjax.run();
	}
};
</script>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>
	<div class="learning" style="height:738px;">
		
		<c:if test="${completeYn ne 'Y'}">
			<div class="pop-header">
				<h3><span class="pop-header-test"></span><c:out value="${detailExamPaper.courseExamPaper.examPaperTitle}"/></h3>
				<div class="timer">
					<span><spring:message code="필드:시험:남은시간"/> : </span><span id="remainTimer">00:00:00</span>
				</div>
			</div>
			
			<div class="section-contents">
				<div class="data scroller" style="width:735px; height:673px;">
					<c:set var="questionCount" value="1"/>
					<c:set var="prevExamSeq" value=""/>
					
					<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
						<c:set var="itemIndex"             value="${i.index}"                  />
						<c:set var="itemSize"              value="${row.courseExam.examCount}" />
						<c:set var="courseExam"            value="${row.courseExam}"           />
						<c:set var="courseExamItem"        value="${row.courseExamItem}"       />
						<c:set var="courseExamAnswer"      value="${row.courseExamAnswer}"     />
						<c:set var="listCourseExamExample" value="${row.listCourseExamExample}"/>
						
						<c:if test="${itemSize gt 1 and courseExam.examSeq ne prevExamSeq}">
							<c:set var="prevExamSeq" value="${courseExam.examSeq}" />
							<div class="question">
								<div class="question-head">※</div>
								<div class="question-title">
									<spring:message code="필드:시험:문제"/>[
										<c:forEach var="x" begin="1" end="${itemSize}" varStatus="iX">
											<c:if test="${iX.first eq true }">
												<c:out value="${aoffn:toInt(questionCount) + x - 1}"/> ~
											</c:if>
											<c:if test="${iX.last eq true }">
												<c:out value="${aoffn:toInt(questionCount) + x - 1}"/>
											</c:if>
										</c:forEach>
									]	
									<aof:text type="text" value="${courseExam.examTitle}"/>
								</div>
								<div class="question-body" style="margin-bottom:5px;">
									<table>
									<tr>
										<c:if test="${!empty courseExam.filePath}">
											<td class="question-item">
												<c:choose>
													<c:when test="${courseExam.filePathType eq 'upload'}">
														<c:choose>
															<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																<div class="question-media" onclick="SUB.doShowMedia(this)">
																	<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${courseExam.filePath}.thumb.jpg"/>">
																</div>
															</c:when>
															<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>" title="video"></div>
																</div>
															</c:when>
															<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>" title="audio"></div>
																</div>
															</c:when>
														</c:choose>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																<div class="question-media" onclick="SUB.doShowMedia(this)">
																	<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>">
																</div>
															</c:when>
															<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>" title="video"></div>
																</div>
															</c:when>
															<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>" title="audio"></div>
																</div>
															</c:when>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</td>
										</c:if>
										<td class="question-example">
											<aof:text type="text" value="${courseExam.description}"/>
										</td>
									</tr>
									</table>
								</div>
							</div>
						</c:if>
						
						<div class="question" id="question-<c:out value="${i.count}"/>">
							<div class="question-head">
								<c:out value="${questionCount}"/>. 
							</div>
							<div class="question-title">
								<aof:text type="text" value="${courseExamItem.examItemTitle}"/>
								<span class="question-type">
									[<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" ref="1" selected="${courseExamItem.examItemTypeCd}"/>]
								</span>
							</div>
						
						
							<div class="question-body">
								<c:set var="alignType" value="vertical" scope="request"/>
								<c:if test="${courseExamItem.examItemAlignCd eq CD_EXAM_ITEM_ALIGN_H}">
									<c:set var="alignType" value="2column" scope="request"/>
								</c:if>
								<c:set var="className" value="example-${alignType}"/>
								<table class="<c:out value="${className}"/>">
									<tr>
										<c:if test="${!empty courseExamItem.filePath}">
											<td class="question-item">
												<c:choose>
													<c:when test="${courseExamItem.filePathType eq 'upload'}">
														<c:choose>
															<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																<div class="question-media" onclick="SUB.doShowMedia(this)">
																	<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${courseExamItem.filePath}.thumb.jpg"/>">
																</div>
															</c:when>
															<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>" title="video"></div>
																</div>
															</c:when>
															<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>" title="audio"></div>
																</div>
															</c:when>
														</c:choose>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																<div class="question-media" onclick="SUB.doShowMedia(this)">
																	<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>">
																</div>
															</c:when>
															<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>" title="video"></div>
																</div>
															</c:when>
															<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																	<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>" title="audio"></div>
																</div>
															</c:when>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</td>
										</c:if>
										
										<td class="question-example">
											<c:choose>
												<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_004}">
													<div class="example-item"><spring:message code="글:시험:답을입력하십시오"/></div>
												</c:when>
												<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_005}">
													<div class="example-item"><spring:message code="글:시험:서술하십시오"/></div>
												</c:when>
												<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_006}">
													<div class="example-item">
														<fmt:message key="글:시험:X이하의파일을첨부하십시오">
															<fmt:param value="10M Byte"/>
														</fmt:message>
													</div>
												</c:when>
											<c:otherwise>
												
												<c:set var="input" value="radio"/>
												<c:if test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_002}">
													<c:set var="input" value="checkbox"/>
												</c:if>
												
												<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
													<c:set var="selected" value=""/>
													<c:if test="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSub.courseExamExample.examExampleSeq, ',') eq true}">
														<c:set var="selected" value="answer-selected"/>
													</c:if>
													<div class="example-item <c:out value="${selected}"/> example-item-<c:out value="${fn:length(listCourseExamExample)}"/>" id="example-item-<c:out value="${rowSub.courseExamExample.examExampleSeq}"/>">
														<span class="number"><spring:message code="글:시험:${iSub.count}"/></span>
														<div><aof:text type="text" value="${rowSub.courseExamExample.examItemExampleTitle}"/></div>
														
														<c:if test="${!empty rowSub.courseExamExample.filePath}">
															<c:choose>
																<c:when test="${rowSub.courseExamExample.filePathType eq 'upload'}">
																	<c:choose>
																		<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																			<div class="example-media" onclick="SUB.doShowMedia(this)">
																				<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${rowSub.courseExamExample.filePath}.thumb.jpg"/>">
																			</div>
																		</c:when>
																		<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																			<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																				<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${rowSub.courseExamExample.filePath}"/>" title="video"></div>
																			</div>
																		</c:when>
																		<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																			<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																				<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${rowSub.courseExamExample.filePath}"/>" title="audio"></div>
																			</div>
																		</c:when>
																	</c:choose>
																</c:when>
																<c:otherwise>
																	<c:choose>
																		<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																			<div class="example-media" onclick="SUB.doShowMedia(this)">
																				<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>">
																			</div>
																		</c:when>
																		<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																			<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																				<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>" title="video"></div>
																			</div>
																		</c:when>
																		<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																			<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																				<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>" title="audio"></div>
																			</div>
																		</c:when>
																	</c:choose>
																</c:otherwise>
															</c:choose>
														</c:if>
														
													</div>
												</c:forEach>
											
											</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</table>
								
								<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}"/>
							</div>
						</div>
						
						<div class="question-space"></div>
					</c:forEach>
				</div>
				
				<div class="section-overlay">
				</div>
				<div class="section-media">
				</div>
			</div>
			
			<div class="section-answer">
				<div class="scroller" style="height:627px; overflow-x:hidden; overflow-y:auto;">
					<form id="SubFormAnswer" name="SubFormAnswer" method="post" onsubmit="return false;">
						<input type="hidden" name="courseMasterSeq"  value="<c:out value="${detailCourseApply.apply.courseMasterSeq}"/>">
						<input type="hidden" name="courseActiveSeq"  value="<c:out value="${detailCourseApply.apply.courseActiveSeq}"/>">
						<input type="hidden" name="courseApplySeq"   value="<c:out value="${detailCourseApply.apply.courseApplySeq}"/>">
						<input type="hidden" name="examPaperSeq"     value="<c:out value="${detailExamPaper.courseExamPaper.examPaperSeq}"/>">
						<input type="hidden" name="activeElementSeq" value="<c:out value="${detailCourseApplyElement.applyElement.activeElementSeq}"/>">
						<input type="hidden" name="memberSeq"        value="<c:out value="${memberSeq}"/>">
						<input type="hidden" name="completeYn"       value="Y">
						<input type="hidden" name="answerCount"  	 value="0">
						<input type="hidden" name="courseActiveExamPaperSeq"  	 value="${detailCourseExamPaper.courseActiveExamPaper.courseActiveExamPaperSeq}">
						
						<c:set var="endDtime" value=""/>
						<c:set var="endDtime" value="${detailCourseExamPaper.courseActiveExamPaper.endDtime}"/>
						<input type="hidden" name="today"       value="<c:out value="${today}"/>"/>
						<input type="hidden" name="endday"      value="<c:out value="${endDtime}"/>"/>
						<input type="hidden" name="examTime"    value="<c:out value="${detailCourseExamPaper.courseActiveExamPaper.examTime * 60}"/>"/>
						<input type="hidden" name="runningTime" value="<c:out value="${detailCourseApplyElement.applyElement.runningTime}"/>"/>
						<input type="hidden" name="remainTime"  value="0"/>
						
						<c:set var="questionCount" value="1"/>
						<c:set var="prevExamSeq" value=""/>
						<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
							<c:set var="itemIndex"             value="${i.index}"                  />
							<c:set var="itemSize"              value="${row.courseExam.examCount}" />
							<c:set var="courseExam"            value="${row.courseExam}"           />
							<c:set var="courseExamItem"        value="${row.courseExamItem}"       />
							<c:set var="courseExamAnswer"      value="${row.courseExamAnswer}"     />
							<c:set var="listCourseExamExample" value="${row.listCourseExamExample}"/>
							
							<c:if test="${itemSize gt 1 and courseExam.examSeq ne prevExamSeq}">
								<c:set var="prevExamSeq" value="${courseExam.examSeq}" />
							</c:if>
							
							<div class="answer" title="<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" ref="1" selected="${courseExamItem.examItemTypeCd}"/>">
								<div class="answer-head" onclick="SUB.doScroll('<c:out value="${i.count}"/>')">
									<input type="hidden" name="examSeqs"  value="<c:out value="${courseExam.examSeq}"/>">
									<input type="hidden" name="examItemSeqs" value="<c:out value="${courseExamItem.examItemSeq}"/>"/>
									<c:out value="${questionCount}"/>.
								</div>
								<ul class="answer-body">
									<c:choose>
										<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_004}">
											<li class="answer-item answer-hidden">
												<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
												<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
												<input type="hidden" name="correctAnswers" class="notedit" value="<c:out value="${aoffn:encrypt(courseExamItem.correctAnswer)}"/>">
												<input type="hidden" name="similarAnswers" class="notedit" value="<c:out value="${aoffn:encrypt(courseExamItem.similarAnswer)}"/>">
												<input type="hidden" name="choiceAnswers" class="notedit">
												<input type="hidden" name="essayAnswers" class="notedit">
												<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
												<input type="hidden" name="attachKeys" class="notedit">
												<input type="hidden" name="attachUploadInfos" class="notedit">
												<input type="hidden" name="attachDeleteInfos" class="notedit">
											</li>
											<li class="answer-item answer-text">
												<input name="shortAnswers" class="input" value="<c:out value="${courseExamAnswer.shortAnswer}"/>"/>
											</li>
										</c:when>
										<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_005}">
											<li class="answer-item answer-hidden">
												<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
												<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
												<input type="hidden" name="correctAnswers" class="notedit">
												<input type="hidden" name="similarAnswers" class="notedit">
												<input type="hidden" name="choiceAnswers" class="notedit">
												<input type="hidden" name="shortAnswers" class="notedit">
												<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
												<input type="hidden" name="attachKeys" class="notedit">
												<input type="hidden" name="attachUploadInfos" class="notedit">
												<input type="hidden" name="attachDeleteInfos" class="notedit">
											</li>
											<li class="answer-item answer-text">
												<textarea name="essayAnswers" class="textarea"><c:out value="${courseExamAnswer.essayAnswer}"/></textarea>
											</li>
										</c:when>
										<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_006}">
											<li class="answer-item answer-hidden">
												<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
												<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
												<input type="hidden" name="correctAnswers" class="notedit">
												<input type="hidden" name="similarAnswers" class="notedit">
												<input type="hidden" name="choiceAnswers" class="notedit">
												<input type="hidden" name="shortAnswers" class="notedit">
												<input type="hidden" name="essayAnswers" class="notedit">
												<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
											</li>
											<li class="answer-item answer-file" style="width:195px;">
												<input type="hidden" name="attachUploadInfos">
												<input type="hidden" name="attachDeleteInfos">
												<div id="uploader-<c:out value="${questionCount}"/>" class="uploader">
												<c:if test="${!empty courseExamAnswer.attachList}">
													<c:forEach var="rowSub" items="${courseExamAnswer.attachList}" varStatus="iSub">
														<div onclick="SUB.doDeleteFile(this, '<c:out value="${rowSub.attachSeq}"/>')" class="previousFile">
															<c:out value="${rowSub.realName}"/>
														</div>
													</c:forEach>
												</c:if>
											</div>
											</li>
										</c:when>
										<c:otherwise>
											<c:set var="corrects" value=""/>
											<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
												<c:if test="${rowSub.courseExamExample.correctYn eq 'Y'}">
													<c:if test="${fn:length(corrects) gt 0}">
														<c:set var="corrects" value="${corrects},"/>
													</c:if>
													<c:set var="corrects" value="${corrects}${rowSub.courseExamExample.examExampleSeq}"/>
												</c:if>
											</c:forEach>
											<li class="answer-item answer-hidden">
												<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
												<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
												<input type="hidden" name="correctAnswers" value="<c:out value="${aoffn:encrypt(corrects)}"/>">
												<input type="hidden" name="similarAnswers" class="notedit">
												<input type="hidden" name="choiceAnswers" value="<c:out value="${courseExamAnswer.choiceAnswer}"/>">
												<input type="hidden" name="shortAnswers" class="notedit">
												<input type="hidden" name="essayAnswers" class="notedit">
												<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
												<input type="hidden" name="attachKeys" class="notedit">
												<input type="hidden" name="attachUploadInfos" class="notedit">
												<input type="hidden" name="attachDeleteInfos" class="notedit">
											</li>
											<c:set var="input" value="radio"/>
											<c:if test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_002}">
												<c:set var="input" value="checkbox"/>
											</c:if>
											
											<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
												<c:set var="selected" value=""/>
												<c:if test="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSub.courseExamExample.examExampleSeq, ',') eq true}">
													<c:set var="selected" value="answer-selected"/>
												</c:if>
												<li class="answer-item <c:out value="${selected}"/> answer-<c:out value="${input}"/>"
													seq="<c:out value="${rowSub.courseExamExample.examExampleSeq}"/>" onclick="SUB.doChoice(this)">
													<spring:message code="글:시험:${iSub.count}"/>
												</li>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</ul>
							</div>
							<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}"/>
						</c:forEach>
					</form>
				</div>
				
				<ul class="buttons" style="padding:5px; border-top:solid 1px #fff;">
					<li class="align-c">
						<a class="btn black" 
						    onclick="SUB.doAnswer('Y')" 
						    title="<spring:message code="버튼:시험:제출"/>"><span class="small"><spring:message code="버튼:시험:제출"/></span></a>
						<a class="btn black" 
						    onclick="SUB.doAnswer('N');"
							title="<spring:message code="버튼:시험:임시저장"/>"><span class="small"><spring:message code="버튼:시험:임시저장"/></span></a>
					</li>
				</ul>
				
			</div>
			
			<div class="tabs-bottom-left">
				<a class="tab" onclick="SUB.doToggleTab(this, 'exam-info')"><spring:message code="필드:시험:시험지정보"/></a>
			</div>
			
			<div class="tabs-content">
				<div id="exam-info" class="tab-section tab-section-bottom" >
					<div class="close" onclick="SUB.doCloseTab(this)"></div>
					<div class="data" style="width:725px;">
						<c:set var="sumScore" value="0"/>
						<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
							<c:set var="sumScore" value="${sumScore + row.courseExamAnswer.takeScore}"/>
						</c:forEach>
						
						<div style="padding:5px;">
							<strong><spring:message code="필드:시험:총점"/> : </strong>
							<span style="margin-right:20px;">
								<c:choose>
									<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
										<c:out value="${detailExamPaper.courseExamPaper.examPaperScore}"/>
									</c:when>
									<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_002}">
										<c:set var="totalExamPaperScore" value="0"/>
										<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
											<c:set var="totalExamPaperScore" value="${totalExamPaperScore + row.courseExamItem.examItemScore}"/>
										</c:forEach>
										<c:out value="${totalExamPaperScore}"/>
									</c:when>
									<c:otherwise>
										<c:out value="${detailExamPaper.courseExamPaper.examPaperScore * aoffn:size(listExamAnswer)}"/>
									</c:otherwise>
								</c:choose>
							</span>
							
							<strong><spring:message code="필드:시험:문항수"/> : </strong>
							<span style="margin-right:20px;"><c:out value="${aoffn:size(listExamAnswer)}"/></span>
						
							<strong><spring:message code="필드:시험:문항당점수"/> : </strong>
							<c:choose>
								<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
									<c:choose>
										<c:when test="${aoffn:size(listExamAnswer) gt 0}">
											<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore / aoffn:size(listExamAnswer)}"/>
										</c:when>
										<c:otherwise><c:set var="scorePerItem" value="0"/></c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore}"/>
								</c:otherwise>
							</c:choose>
							<span style="margin-right:20px;"><c:out value="${aoffn:trimDouble(scorePerItem)}"/></span>
						</div>

						<div style="padding:5px;"><strong><spring:message code="필드:시험:시험지설명"/> : </strong></div>
						<div style="padding-left:20px;"><aof:text type="text" value="${detailExamPaper.courseExamPaper.description}"/></div>
					</div>
				</div>
			</div>
			
		</c:if>
	</div>
	
</body>
</html>