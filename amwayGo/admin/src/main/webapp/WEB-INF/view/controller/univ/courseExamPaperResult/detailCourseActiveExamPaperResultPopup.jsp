<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_ITEM_TYPE_001"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.001')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_003"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>
<c:set var="CD_SCORE_TYPE_001"       value="${aoffn:code('CD.SCORE_TYPE.001')}"/>
<c:set var="CD_SCORE_TYPE_002"       value="${aoffn:code('CD.SCORE_TYPE.002')}"/>
<c:set var="CD_SCORE_TYPE_003"       value="${aoffn:code('CD.SCORE_TYPE.003')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_EXAM_ITEM_TYPE_001 = "<c:out value="${CD_EXAM_ITEM_TYPE_001}"/>";
var CD_EXAM_ITEM_TYPE_002 = "<c:out value="${CD_EXAM_ITEM_TYPE_002}"/>";
var CD_EXAM_ITEM_TYPE_003 = "<c:out value="${CD_EXAM_ITEM_TYPE_003}"/>";
var CD_EXAM_ITEM_TYPE_004 = "<c:out value="${CD_EXAM_ITEM_TYPE_004}"/>";
var CD_EXAM_ITEM_TYPE_005 = "<c:out value="${CD_EXAM_ITEM_TYPE_005}"/>";
var CD_EXAM_ITEM_TYPE_006 = "<c:out value="${CD_EXAM_ITEM_TYPE_006}"/>";

var forUpdate   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	doSetTakeTotalScore();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url = "<c:url value="/course/exam/answer/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this);
		}
		$layer.dialog("close");
	};
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:점수"/>",
		name : "takeScores",
		data : ["!null", "decimalnumber"],
		check : {
			maxlength : 6
		}
	});
	forUpdate.validator.set(function() {
		var $form = jQuery("#" + forUpdate.config.formId);
		var scorePerItem = $form.find(":input[name='scorePerItem']").val();
		scorePerItem = scorePerItem == "" ? 0 : parseInt(scorePerItem, 10);

		var result = true;
		$form.find(":input[name='takeScores']").each(function() {
			var value = this.value == "" ? 0 : parseInt(this.value, 10); 
			if (scorePerItem < value) {
				$.alert({message : "<spring:message code="글:시험:문항당점수보다획득점수가클수없습니다"/>"});
				result = false;
				return false;
			}
		});
		return result;
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 점수변경
 */
doChangeScore = function(element) {
	var $element = jQuery(element);
	var $hidden = $element.closest(".question").find(".input-hidden");
	
	if($element.val() == $hidden.find(":input[name='oldTakeScores']").val()) {
		$hidden.find(":input[name='changedTakeScores']").val("N");
	} else {
		$hidden.find(":input[name='changedTakeScores']").val("Y");
	}
	if ($hidden.find(":input[name='changedTakeScores']").val() == "Y" || $hidden.find(":input[name='changedComments']").val() == "Y") {
		$hidden.find(":input[name='checkkeys']").attr("checked", true);
	} else {
		$hidden.find(":input[name='checkkeys']").attr("checked", false);
	}
	doSetTakeTotalScore();
};
/**
 * 첨삭변경
 */
doChangeComment = function(element) {
	var $element = jQuery(element);
	var $hidden = $element.closest(".question").find(".input-hidden");
	
	if($element.val() == $hidden.find(":input[name='oldComments']").val()) {
		$hidden.find(":input[name='changedComments']").val("N");
	} else {
		$hidden.find(":input[name='changedComments']").val("Y");
	}
	if ($hidden.find(":input[name='changedTakeScores']").val() == "Y" || $hidden.find(":input[name='changedComments']").val() == "Y") {
		$hidden.find(":input[name='checkkeys']").attr("checked", true);
	} else {
		$hidden.find(":input[name='checkkeys']").attr("checked", false);
	}
};
/**
 * 획득점수 총점계산
 */
doSetTakeTotalScore = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var choiceScore = 0;
	var shortScore = 0;
	var essayScore = 0;

	$form.find(":input[name='takeScores']").each(function() {
		var $this = jQuery(this);
		var value = $this.val();
		value = value == "" ? 0 : parseFloat(value);
		switch (this.className) {
		case CD_EXAM_ITEM_TYPE_001:
		case CD_EXAM_ITEM_TYPE_002:
		case CD_EXAM_ITEM_TYPE_003:
			choiceScore += value;
			break;
		case CD_EXAM_ITEM_TYPE_004:
			shortScore += value;
			break;
		case CD_EXAM_ITEM_TYPE_005:
		case CD_EXAM_ITEM_TYPE_006:
			essayScore += value;
			break;
		}
	});	
	$form.find(":input[name='choiceScore']").val(choiceScore);
	$form.find(":input[name='shortScore']").val(shortScore);
	$form.find(":input[name='essayScore']").val(essayScore);
	$form.find(":input[name='takeScore']").val(choiceScore + shortScore + essayScore);
};
/**
 * 미채점문항만 보기
 */
doUnEvaluate = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var checked = $form.find(":input[name='unEvaluate']").filter(":checked");
	if (checked.length > 0) {
		$form.find(".question").each(function() {
			var $this = jQuery(this);
			var done = true;
			$this.find(":input[name='takeScores']").each(function() {
				if (this.value == "") {
					done = false;
				}
			});
			if (done == false) {
				$this.show();
			} else {
				$this.hide();
			}
		});
	} else {
		$form.find(".question").show();
	}
	
};
/**
 * 미디어 보이기
 */
doShowMedia = function(element) {
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
}
</script>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/admin/learning.css" type="text/css"/>
</head>
<body>
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseMasterSeq"  value="<c:out value="${detailCourseExamPaper.courseActiveExamPaper.courseMasterSeq}"/>">
		<input type="hidden" name="courseActiveSeq"  value="<c:out value="${detailCourseExamPaper.courseActiveExamPaper.courseActiveSeq}"/>">
		<input type="hidden" name="courseApplySeq"   value="<c:out value="${courseApplyElement.courseApplySeq}"/>">
		<input type="hidden" name="examPaperSeq"     value="<c:out value="${detailExamPaper.courseExamPaper.examPaperSeq}"/>">
		<input type="hidden" name="activeElementSeq" value="<c:out value="${courseApplyElement.activeElementSeq}"/>">
		<input type="hidden" name="courseActiveExamPaperSeq"  	 value="${detailCourseExamPaper.courseActiveExamPaper.courseActiveExamPaperSeq}">
		<input type="hidden" name="scoreYn"  	 value="${courseActiveExamPaperTarget.scoreYn}">
		<input type="hidden" name="onOffCd"  	 value="${detailCourseExamPaper.courseActiveExamPaper.onOffCd}">
		
		<input type="hidden" name="choiceScore">
		<input type="hidden" name="shortScore">
		<input type="hidden" name="essayScore">
		
<!-- 		총점 계산 -->
		<c:set var="totalScore" value="0"/>
		<c:choose>
			<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_001}">
				<c:set var="totalScore" value="${detailExamPaper.courseExamPaper.examPaperScore * aoffn:size(listExamAnswer)}"/>
			</c:when>
			<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_002}">
				<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
					<c:set var="totalScore" value="${totalScore + row.courseExamItem.examItemScore}"/>
				</c:forEach>
			</c:when>
			<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
				<c:set var="totalScore" value="${detailExamPaper.courseExamPaper.examPaperScore}"/>
			</c:when>
		</c:choose>
		
		<input type="hidden" name="totalScore" value="${totalScore}">
		
		<c:choose>
			<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
				<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore / aoffn:size(listExamAnswer)}" scope="request"/>
			</c:when>
			<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_001}">
				<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore}" scope="request"/>
			</c:when>
		</c:choose>
		
		<div class="learning" style="height:745px; height:743px; padding:0;">
			
			<div class="section-head">
				<div class="title" style="width:690px;"><c:out value="${detailCourseExamPaper.courseExamPaper.examPaperTitle}"/></div>
			</div>
			
			<div style="height:25px; padding:5px; text-align : center; color:#000; background-color:#fff; border-bottom:solid 1px #cdcdcd; overflow: hidden;">
				<div style="float: left;">
					<input type="checkbox" name="unEvaluate" value="Y" onclick="doUnEvaluate()">
					<span class="margin-r-10"><spring:message code="글:시험:미채점문항만보기" /></span>
					
					<span style="padding-left: 15px;"><spring:message code="필드:시험:문항당점수" /></span>
					<input type="text" name="scorePerItem" value="<c:out value="${scorePerItem}"/>" class="notedit" style="width:50px;" readonly="readonly"/>
							
					<span style="padding-left: 15px;"><spring:message code="필드:시험:획득점수" /></span>
					<input type="text" name="takeScore" value="" class="notedit" style="width:50px;" readonly="readonly"/>
				</div>
				<div style="float: right;">
					<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
						<a href="#" onclick="doUpdate();" class="btn black"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</c:if>
				</div>
				<div style="clear: both;"></div>
			</div>
			
			<div class="section-contents">
				<div class="data scroller" style="height:655px;*height:656px; padding:3px;">
					<c:set var="questionCount" value="1" scope="request"/>
					<c:set var="prevExamSeq"   value=""  scope="request"/>
					
					<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
						<c:set var="itemIndex"             value="${i.index}"                   scope="request"/>
						<c:set var="itemSize"              value="${row.courseExam.examCount}"  scope="request"/>
						<c:set var="courseExam"            value="${row.courseExam}"            scope="request"/>
						<c:set var="courseExamItem"        value="${row.courseExamItem}"        scope="request"/>
						<c:set var="courseExamAnswer"      value="${row.courseExamAnswer}"      scope="request"/>
						<c:set var="listCourseExamExample" value="${row.listCourseExamExample}" scope="request"/>
						<c:if test="${detailCourseExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_002}">
							<c:set var="scorePerItem" value="${row.courseExamItem.examItemScore}" scope="request"/>
						</c:if>
						
						<c:import url="./include/courseExam.jsp"/>

						<c:import url="./include/courseExamItem.jsp"/>
						
						<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}" scope="request"/>
					</c:forEach>
				</div>
				<div class="section-overlay">
				</div>
				<div class="section-media">
				</div>
			</div>
			
		</div>
	</form>
</body>
</html>