<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SCORE_TYPE_001"  value="${aoffn:code('CD.SCORE_TYPE.001')}"/>
<c:set var="CD_SCORE_TYPE_002"  value="${aoffn:code('CD.SCORE_TYPE.002')}"/>
<c:set var="CD_SCORE_TYPE_003"  value="${aoffn:code('CD.SCORE_TYPE.003')}"/>

<html decolator="learing">
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

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
};
</script>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/admin/learning.css" type="text/css"/>
</head>

<body>

	<div class="learning" style="height:740px; padding:0;">
		<div class="section-contents">
			<div class="data scroller" style="padding:3px;margin-bottom:10px;">
				<table width="100%" class="tbl-detail" style="margin-bottom:10px;">
				<colgroup>
					<col style="width:100px" />
					<col style="width:auto" />
					<col style="width:80px" />
					<col style="width:auto" />
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:시험:시험지설명"/></th>
						<td colspan="3"><aof:text type="text" value="${detailExamPaper.courseExamPaper.description}"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:시험:총점"/></th>
						<td>
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
							<c:out value="${totalScore}" /><spring:message code="글:시험:점"/>
						</td>
						<th><spring:message code="필드:시험:문항수"/></th>
						<td><c:out value="${aoffn:size(listExam)}"/></td>
					</tr>
				</tbody>
				</table>
					
				<c:set var="questionCount" value="1" scope="request"/>
				<c:set var="prevExamSeq"   value=""  scope="request"/>
				<c:forEach var="row" items="${listExam}" varStatus="i">
					<c:set var="itemIndex"             value="${i.index}"                   scope="request"/>
					<c:set var="itemSize"              value="${row.courseExam.examCount}"  scope="request"/>
					<c:set var="courseExam"            value="${row.courseExam}"            scope="request"/>

					<c:import url="../courseExamPaperResult/include/courseExam.jsp"/>
					
				 	<c:forEach var="rowSub" items="${row.listCourseExamItem}" varStatus="iSub">
						<c:set var="courseExamItem"        value="${rowSub.courseExamItem}"        scope="request"/>
						<c:set var="listCourseExamExample" value="${rowSub.listCourseExamExample}" scope="request"/>
	
						<c:import url="../courseExamPaperResult/include/courseExamItem.jsp"/>
						
						<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}" scope="request"/>
					</c:forEach>
				</c:forEach>

				<c:if test="${empty listExam}">
					<div class="question">
						<div class="question-title"><spring:message code="글:시험:시험지가준비되지않았습니다"/></div>
					</div>
				</c:if>
			</div>

			<div class="section-overlay">
			</div>
			<div class="section-media">
			</div>
			
		</div>
	</div>
	
</body>
</html>