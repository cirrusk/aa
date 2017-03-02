<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SCORE_TYPE_003"    value="${aoffn:code('CD.SCORE_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_H" value="${aoffn:code('CD.EXAM_ITEM_ALIGN.H')}"/>

<c:set var="appFormatDbDatetime" value="${aoffn:config('format.dbdatetime')}"/>
<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="${appFormatDbDatetime}"/></c:set>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="resultYn" value="N" scope="request"/>
<c:if test="${!empty detailCourseApplyElement.applyElement.scoreDtime and detailCourseApplyElement.applyElement.completeYn eq 'Y'}">
	<c:set var="resultYn" value="Y" scope="request"/>
</c:if>

<html>
<head>
<script type="text/javascript">
var forAnswer = null;
var forAnswerForce = null;
var remainTimer = null;
var runningTimer = null;
var openerTimer = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2]. uploader
	swfu = UI.uploader.create(function() { // completeCallback
		forAnswer.run("continue");
	});	
	
	doCreateUploader();
	
	<c:if test="${resultYn ne 'Y' and count ne '0'}">
		
		
		// [3]. 남은시간 타이머
		if (doSetRemainTime() == true) {
			remainTimer = setInterval("doRemainTimer()", 1000);
		}
		// [4]. 실행시간 타이머
		runningTimer = setInterval("doRunningTimer()", 1000);
		// [5]. opener 검사 타이머
		openerTimer = setInterval("doOpenerTimer()", 1000);
		
	</c:if>

	// [6] F5키 막기.		
	jQuery(document).bind("keydown", UT.preventF5);
	document.oncontextmenu = function() {
		return false;
	};
	
	// [7] 창닫힘
	
	// firefox , chrome
	<c:if test="${isIE ne 'ie'}">
	jQuery(window).bind('beforeunload', function() {
		jQuery(".uploader").each(function() { // uploader 가 있으면 지워준다.(ie9에서 에러남)
			jQuery(this).html("");
		});
		// 저장되지 않았으면 저장하게 한다.
		doAnswerForce();
	});
	</c:if>
	
	// internet exploror 9
	<c:if test="${isIE eq 'ie'}">
	jQuery(window).unload(function() {
		// 저장되지 않았으면 저장하게 한다.
		doAnswerForce();
	});
	</c:if>
	jQuery(".button-delete-icon").button({icons : {primary : "ui-icon-circle-close"}});
	
	jQuery(".video").media({width:250, height:250, autoplay : false});
	jQuery(".audio").media({autoplay : false});

	doAdjust();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	forAnswer = $.action("submit", {formId : "FormAnswer"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forAnswer.config.url             = "<c:url value="/usr/classroom/exampaper/answer/update.do"/>";
	forAnswer.config.target          = "hiddenframe";
	forAnswer.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forAnswer.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forAnswer.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forAnswer.config.fn.before       = doStartUpload;
	forAnswer.config.fn.complete     = function() {
		doClose();
	};
	
	forAnswerForce = $.action("submit", {formId : "FormAnswer"});
	forAnswerForce.config.url         = "<c:url value="/usr/classroom/exampaper/answer/update.do"/>";
	forAnswerForce.config.target      = "hiddenframe";

};
/**
 * 제출 / 임시저장
 */
doAnswer = function(completeYn) {
	var form = UT.getById(forAnswer.config.formId);
	form.elements["check"].value = "Y";
	form.elements["completeYn"].value = completeYn;
	if(completeYn == "Y"){
		form.elements["answerCount"].value = 1;
	} else {
		form.elements["answerCount"].value = 0;
	}
	forAnswer.run();
};
/**
 * 강제저장
 */
doAnswerForce = function() {
	var form = UT.getById(forAnswerForce.config.formId);
	if(form.elements["listExamAnswer"].value != '[]'){
		if(form.elements["check"].value == 'N' && form.elements["resultYn"].value == 'N') {
			form.elements["check"].value = "Y";
			form.elements["completeYn"].value = "N";
			form.elements["answerCount"].value = 0;
			forAnswerForce.run();
			alert("강제로 시험을 종료해 자동임시저장 처리합니다.");
		}
	}
	doClose();
};
/**
 * opener 페이지가 이동되었는지 검사. - opener 가 존재하지 않거나 페이지 이동을 하였을 경우 강제저장 시킨다
 */
doOpenerTimer = function() {
// 	if (typeof window.opener.UT.getById("takeAnExam") === "undefined" || 'Y' != window.opener.UT.getById("takeAnExam").value) {
// 		doAnswerForce();
// 	}
};       
/**
 * 닫기 : 창을 닫고, opener 목록 페이지 refresh
 */
var closed = false;
doClose = function() {
	if (closed == false) {
		closed = true;
		self.close();
		if (typeof window.opener.UT.getById("takeAnExam") !== "undefined" && window.opener.doList) {
			window.opener.doList();
		}
		
		clearInterval(remainTimer);
		clearInterval(runningTimer);
		clearInterval(openerTimer);
	}
};
/**
 * uploader 생성
 */
 doCreateUploader = function() {
	
	 var upload = [];
	 
	 //문제 갯수 맞춰서 업로드 생성할 값 세팅
 	 jQuery(".uploader").each(function() {
 		var id = jQuery(this).attr("id");
		 upload.push({
			 elementId : id,
			 postParams : {},
				options : {
					uploadUrl : "<c:url value="/attach/file/save.do"/>",
					fileTypes : "*.*",
					fileTypesDescription : "All Files",
					fileSizeLimit : "10 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputHeight : 22, // default : 22
					immediatelyUpload : false,
					successCallback : function(id, file) {
						doSuccessCallback(id, file);
					}
				}
		 });
 	});
		 
	 //업로더 생성
	 swfu = UI.uploader.generate(swfu, upload);
};
 
/**
* 파일업로드 시작
*/
doStartUpload = function() {
	var isAppendedFiles = false;
	jQuery(".uploader").each(function() {
 		var id = jQuery(this).attr("id");
 		if (UI.uploader.isAppendedFiles(swfu,id) == true) {
			isAppendedFiles = true;				
		}
 	});
	
	if (isAppendedFiles == true) {
		UI.uploader.runUpload(swfu);
		return false;
		
	} else {
		return true;
	}
};
/**
 * 파일업로드 완료 Callback
 */
doSuccessCallback = function(id, file) {
	var $element = jQuery("#"+id);
	var $uploader = $element.closest(".uploader");
	var $attachUploadInfos = $uploader.siblings(":input[name='attachUploadInfos']");
	var fileInfo = file.serverData.fileInfo;
	var inputData = fileInfo.fileType +"|"+ fileInfo.fileSize +"|"+ fileInfo.realName +"|"+ fileInfo.saveName +"|"+ fileInfo.savePath;
	
	$attachUploadInfos.val(inputData);
};
/**
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $parentDiv = $element.closest("div");
	$parentDiv.siblings(":input[name='deleteAttachSeqs']").val(seq);
	$parentDiv.siblings(".uploader").show();
	$parentDiv.remove();
};
/**
 * 객관식보기선택
 */
doChoice = function(element) {
	var $choiceAnswer = jQuery(element).closest("td").find(":input[name='choiceAnswers']");
	$choiceAnswer.val(UT.getCheckedValue(forAnswer.config.formId, element.name, ","));
};
/**
 * 남은시간 계산
 */
doSetRemainTime = function() {
	var $form = jQuery("#" + forAnswer.config.formId);
	var examTime = $form.find(":input[name='examTime']").val();
	examTime = examTime == "" ? 0 : parseInt(examTime, 10); 
	if (examTime == 0) {
		jQuery("#watch").hide();
		return false;
	}
	var today = $form.find(":input[name='today']").val();
	var endday = $form.find(":input[name='endday']").val();
	if (endday.startsWith("0") == true) {
		endday = $form.find(":input[name='studyEndDate']").val();
	}
	var runningTime = $form.find(":input[name='runningTime']").val();
	runningTime = runningTime == "" ? 0 : parseInt(runningTime, 10); 
	var todayDate = doGetDate(today);
	var enddayDate = doGetDate(endday);
	var gap = (enddayDate.getTime() - todayDate.getTime()) / 1000;
	var value = gap < (examTime - runningTime) ? gap : examTime - runningTime;
	$form.find(":input[name='remainTime']").val(value);
	return true;
};
doGetDate = function(s) {
	return new Date(s.substring(0,4), s.substring(4,6), s.substring(6,8), s.substring(8,10), s.substring(10,12), s.substring(12,14));
};
/**
 * 실행시간 타이머
 */
var runningTime = null;
var $runningWatch = null;
doRunningTimer = function() {
	if (runningTime == null) {
		runningTime = jQuery("#" + forAnswer.config.formId).find(":input[name='runningTime']").val();
		runningTime = runningTime == "" ? 0 : parseInt(runningTime, 10);
	}
	if ($runningWatch == null) {
		$runningWatch = jQuery("#runningWatch");
	}
	$runningWatch.val(runningTime++);
};
/**
 * 남은시간 타이머
 */
var remainTime = null;
var $remainWatch = null;
doRemainTimer = function() {
//	var examEndDtime = jQuery("#" + forAnswer.config.formId).find(":input[name='examEndDtime']").val();
	var examEndDtime = jQuery("#" + forAnswer.config.formId).find(":input[name='endday']").val();
	var today = new Date();
	
	var now = leadingZeros(today.getFullYear(),4)+leadingZeros(today.getMonth()+1,2)+leadingZeros(today.getDate(),2)+
	leadingZeros(today.getHours(),2)+leadingZeros(today.getMinutes(),2)+leadingZeros(today.getSeconds(),2);
	document.getElementById("now").value = now;
	
	var nowTime = jQuery("#" + forAnswer.config.formId).find(":input[name='now']").val();

	
	if (remainTime == null) {
		remainTime = jQuery("#" + forAnswer.config.formId).find(":input[name='remainTime']").val();
		remainTime = remainTime == "" ? 0 : parseInt(remainTime, 10);
	}
	if ($remainWatch == null) {
		$remainWatch = jQuery("#remainWatch");
	}
	remainTime--;

	
	var h = parseInt((remainTime / 3600), 10);
	var m = parseInt(((remainTime % 3600) / 60), 10);
	if (m < 10) {
		m = "0" + m;
	}
	var s = (remainTime % 60);
	if (s < 10) {
		s = "0" + s;
	}
	var time = h + " : " + m + " : " + s;
	$remainWatch.html(time);
	
	if (remainTime <= 300) { // 5분
		var $watch = jQuery("#watch");
		if ($watch.hasClass("warning") == false) {
			$watch.addClass("warning");
		}
	}
	if (examEndDtime <= nowTime) {
			clearInterval(remainTimer);
			$.alert({message : "<spring:message code="글:시험:시험시간이종료되었습니다자동으로제출합니다"/>",
				button1 : {
					callback : function() {
						forAnswer.config.message.confirm = "";
						doAnswer('Y');
					}
				}
			});
	}
	if (remainTime <= 0) {
		clearInterval(remainTimer);
		$.alert({message : "<spring:message code="글:시험:시험시간이종료되었습니다자동으로제출합니다"/>",
			button1 : {
				callback : function() {
					forAnswer.config.message.confirm = "";
					doAnswer('Y');
				}
			}
		});
	}
};

function leadingZeros(n, digits) {
	var zero='';
	n = n.toString();
	if (n.length<digits) {
		for(var i = 0; i < digits - n.length; i++) zero += '0';
	}
	return zero + n;
}
/**
 * 보기정렬 
 */
doAdjust = function() {
	jQuery(".examExample").each(function() {
		var $this = jQuery(this);
		var $examples = $this.find(".example");
		var exampleLength = $examples.length;

		var width = 90;
		if ($this.hasClass("horizontal")) {
			width = width / exampleLength; 
		} else if ($this.hasClass("2column")) {
			width = width / 2;
		}
		$examples.css("width", width + "%");
		var childWidth = 0;
		$examples.find(".video, .audio").each(function() {
			var w = jQuery(this).width();
			childWidth = w > childWidth ? w : childWidth;
		});
		if (childWidth > $examples.width()) {
			$examples.css("width", childWidth + "px");
		}
		
		if ($this.hasClass("horizontal") || $this.hasClass("2column")) {
			var height = 0;
			$examples.each(function() {
				var h = parseInt(jQuery(this).css("height"), 10);
				height = h > height ? h : height;
			});
			$examples.css("height", height + "px");
		}
	});
};
</script>
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/www/learning.css" type="text/css"/>
<c:import url="./include/courseExamStyle.jsp"/>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
<style type="text/css">
body {padding:0px !important;}
</style>
</head>

<body>
	<form id="FormAnswer" name="FormAnswer" method="post" onsubmit="return false;">
	<input type="hidden" name="courseMasterSeq"  value="<c:out value="${detailCourseApply.apply.courseMasterSeq}"/>">
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${detailCourseApply.apply.courseActiveSeq}"/>">
	<input type="hidden" name="courseApplySeq"   value="<c:out value="${detailCourseApply.apply.courseApplySeq}"/>">
	<input type="hidden" name="examPaperSeq"     value="<c:out value="${detailExamPaper.courseExamPaper.examPaperSeq}"/>">
	<input type="hidden" name="activeElementSeq" value="<c:out value="${detailCourseApplyElement.applyElement.activeElementSeq}"/>">
	<input type="hidden" name="memberSeq"        value="<c:out value="${memberSeq}"/>">
	<input type="hidden" name="completeYn"       value="Y">
	<input type="hidden" name="check"    		 value="N">
	<input type="hidden" name="resultYn"    	 value="${resultYn}">
	<input type="hidden" name="listExamAnswer"   	 value="${listExamAnswer}">
	<input type="hidden" name="count"  			 value="${count}">
	<input type="hidden" name="answerCount"  	 value="0">
	<input type="hidden" name="courseActiveExamPaperSeq"  	 value="${detailCourseExamPaper.courseActiveExamPaper.courseActiveExamPaperSeq}">
	
	<c:if test="${resultYn ne 'Y' and count ne '0'}">
		<table class="tbl-detail">
		<colgroup>
			<col style="width:140px" />
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:시험:남은시간" /></th>
				<td>
					<span id="remainWatch" class="input_time">
				</td>
			</tr>
		</tbody>
		</table>
	</c:if>
	
	<table class="tbl-detail mt20">
	<colgroup>
		<col style="width:140px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:시험지제목" /></th>
			<td>
				<c:out value="${detailExamPaper.courseExamPaper.examPaperTitle}" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:시험지설명" /></th>
			<td>
				<c:out value="${detailExamPaper.courseExamPaper.description}" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:총점"/></th>
			<td class="align-l">
				<c:choose>
					<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
						<c:out value="${detailExamPaper.courseExamPaper.examPaperScore}"/>
					</c:when>
					<c:otherwise>
						<c:out value="${detailExamPaper.courseExamPaper.examPaperScore * aoffn:size(listExamAnswer)}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문항수"/></th>
			<td class="align-l"><c:out value="${aoffn:size(listExamAnswer)}"/></td>
		</tr>
	</tbody>
	</table>
	
	<!-- 시간설정 -->
	<c:if test="${resultYn ne 'Y'}">
		<c:set var="endDtime" value=""/>
		<c:set var="endDtime" value="${detailCourseExamPaper.courseActiveExamPaper.endDtime}"/>
		<input type="hidden" name="today" value="<c:out value="${today}"/>"/>
		<input type="hidden" name="endday" value="<c:out value="${endDtime}"/>"/>
		<input type="hidden" name="now" id="now" />
		<input type="hidden" name="examEndDtime" value="<c:out value="${detailCourseActiveElement.applyElement.endDtime}"/>"/>
		<input type="hidden" name="examTime" value="<c:out value="${detailCourseExamPaper.courseActiveExamPaper.examTime * 60}"/>"/>
		<input type="hidden" name="runningTime" id="runningWatch" value="<c:out value="${detailCourseApplyElement.applyElement.runningTime}"/>"/>
		<input type="hidden" name="remainTime" value="0"/>
	</c:if>
	<c:choose>
		<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
			<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore / aoffn:size(listExamAnswer)}" scope="request"/>
		</c:when>
		<c:otherwise>
			<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore}" scope="request"/>
		</c:otherwise>
	</c:choose>
	<c:set var="questionCount" value="1" scope="request"/>
	<c:set var="prevExamSeq" value="" scope="request"/>
	
	<div class="learning">
		<div class="section-contents">
		<div class="vspace mt20"></div>
			<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
				<div class="question">
					<c:set var="itemIndex"             value="${i.index}"                   scope="request"/>
					<c:set var="itemSize"              value="${row.courseExam.examCount}"  scope="request"/>
					<c:set var="courseExam"            value="${row.courseExam}"            scope="request"/>
					<c:set var="courseExamItem"        value="${row.courseExamItem}"        scope="request"/>
					<c:set var="courseExamAnswer"      value="${row.courseExamAnswer}"      scope="request"/>
					<c:set var="listCourseExamExample" value="${row.listCourseExamExample}" scope="request"/>
					<c:set var="alignType" value="vertical" scope="request"/>
					<c:if test="${courseExamItem.examItemAlignCd eq CD_EXAM_ITEM_ALIGN_H}">
						<c:set var="alignType" value="2column" scope="request"/>
					</c:if>				
				
				
					<c:if test="${resultYn eq 'Y' and !empty courseExamAnswer}">
						<c:if test="${aoffn:trimDouble(courseExamAnswer.takeScore) ne 0}">
							<c:choose>
								<c:when test="${scoreTypeCd eq CD_SCORE_TYPE_003}">
									<c:choose>
										<c:when test="${courseExamAnswer.takeScore eq (score/count) or (score/count) lt courseExamAnswer.takeScore}"><div class="marking"><aof:img src="content/online_score_O.gif"/></div></c:when>
										<c:when test="${0 lt courseExamAnswer.takeScore and courseExamAnswer.takeScore lt (score/count)}"><div class="marking"><aof:img src="content/online_score_A.gif"/></div></c:when>
										<c:otherwise><div class="marking"><aof:img src="content/online_score_X.gif"/></div></c:otherwise>	
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${aoffn:trimDouble(courseExamAnswer.takeScore) eq score or score lt aoffn:trimDouble(courseExamAnswer.takeScore)}"><div class="marking"><aof:img src="content/online_score_O.gif"/></div></c:when>
										<c:when test="${0 lt aoffn:trimDouble(courseExamAnswer.takeScore) and aoffn:trimDouble(courseExamAnswer.takeScore) lt score}"><div class="marking"><aof:img src="content/online_score_A.gif"/></div></c:when>
										<c:otherwise><div class="marking"><aof:img src="content/online_score_X.gif"/></div></c:otherwise>	
									</c:choose>
								</c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${aoffn:trimDouble(courseExamAnswer.takeScore) eq 0}">
							<div class="marking"><aof:img src="content/online_score_X.gif"/></div>
						</c:if>
					</c:if>
						<c:if test="${itemSize gt 1 and courseExam.examSeq ne prevExamSeq}">
							<c:set var="prevExamSeq" value="${courseExam.examSeq}"  scope="request"/>
							<c:import url="./include/courseExam.jsp"/>
						</c:if>
						<c:import url="./include/courseExamItem.jsp"/>
						<c:import url="./include/courseExamExample.jsp"/>
						<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}" scope="request"/>
				</div>
			</c:forEach>
		</div>	
	</div>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${resultYn ne 'Y' and !empty listExamAnswer}">
				<a href="javascript:void(0)" onclick="doAnswer('N');" class="btn blue"><span class="mid"><spring:message code="버튼:시험:임시저장"/></span></a>
				<a href="javascript:void(0)" onclick="doAnswer('Y');" class="btn blue"><span class="mid"><spring:message code="버튼:시험:제출"/></span></a>
			</c:if>
			<c:if test="${resultYn eq 'Y'}">
				<spring:message code="필드:시험:획득점수"/> : <c:out value="${aoffn:trimDouble(sumScore)}"/><spring:message code="글:시험:점"/>
			</c:if>
		</div>
	</div>
	
</body>
</html>