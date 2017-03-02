<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata 	= null;
var forSurveyAjax 	= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/result/survey/list.do"/>";

	forSurveyAjax = $.action("ajax");
	forSurveyAjax.config.formId 		= "FormAjax";
	forSurveyAjax.config.url    		= "<c:url value="/univ/course/active/result/survey/detail/ajax.do"/>";
	forSurveyAjax.config.type        	= "html";
	forSurveyAjax.config.fn.complete 	= function() {
	};
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 상세보기
 */
doDetailSurvey = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forSurveyAjax.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forSurveyAjax.config.formId);
	
	var $row = jQuery("#row-" + mapPKs.surveySeq);
	if ($row.is(":visible")) {
		$row.hide();
	} else {
		$row.show();
		forSurveyAjax.config.containerId = "result-" + mapPKs.surveySeq;
		forSurveyAjax.run();
	}
}; 
</script>
</head>

<body>

<c:set var="madatoryCd">Y=<spring:message code="글:설문:필수"/>,N=<spring:message code="글:설문:필수아님"/></c:set>
<c:set var="accessPlace">calssroom=<spring:message code="글:설문:강의실"/>,gradeReview=<spring:message code="글:설문:성적조회"/></c:set>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
<c:import url="srchCourseActiveSurveyResult.jsp" />

<div class="lybox-title">
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<div class="vspace"></div>

<div id="tabContainer">

	<div class="lybox-title">
		<h4 class="section-title">
			<spring:message code="글:설문:설문조회" />
		</h4>
	</div>

	<c:set var="totalMemberCount" 	   value="0"/>
	<c:set var="totalAnswerCount" 	   value="0"/>
	<table class="tbl-detail">
		<colgroup>
		<col style="width: 150px" />
		<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:설문:설문제목"/></th>
				<td>
					<c:out value="${detail.surveyPaper.surveyPaperTitle}"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:설문:설문기간"/></th>
				<td>
					<c:choose>
            		<c:when test="${courseType eq 'period'}">
			         	<aof:date datetime="${detail.surveySubject.startDtime}" />&nbsp;
					    <aof:date datetime="${detail.surveySubject.startDtime}" pattern="HH:mm:ss"/>
		                <spring:message code="글:설문:부터" /> ~
		                <aof:date datetime="${detail.surveySubject.endDtime}" />&nbsp;
					    <aof:date datetime="${detail.surveySubject.endDtime}" pattern="HH:mm:ss"/>
					    <spring:message code="글:설문:까지" />
            		</c:when>
            		<c:otherwise>
            			<spring:message code="글:수강시작"/><c:out value="${detail.surveySubject.startDay}" /><spring:message code="글:일부터"/> ~
           				<c:out value="${detail.surveySubject.endDay}" /><spring:message code="글:일까지"/>
            		</c:otherwise>
           		</c:choose>
				</td>
			</tr>
			<tr>
				<th>
					<spring:message code="필드:설문:설문문항수"/>
				</th>
				<td>
					<c:out value="${aoffn:size(listElement)}" /><spring:message code="필드:설문:문항" />
				</td>
			</tr>
			<tr>
				<th>
					<spring:message code="필드:설문:필수여부"/>
				</th>
				<td>
					<aof:code type="print" name="mandatoryYn" codeGroup="${madatoryCd}" selected="${detail.surveySubject.mandatoryYn}"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:설문:참여" />|<spring:message code="필드:설문:미참여" />|<spring:message code="필드:설문:대상인원" /></th>
				<td>
					<c:set var="totalMemberCount" value="${detail.courseActiveSurvey.totalMemberCount}" />
					<c:set var="totalAnswerCount" value="${detail.courseActiveSurvey.totalAnswerCount}" />
					<c:out value="${totalAnswerCount}" />&nbsp;&nbsp;|&nbsp;&nbsp;<c:out value="${totalMemberCount - totalAnswerCount}" />&nbsp;&nbsp;|&nbsp;&nbsp;<c:out value="${totalMemberCount}" />
				</td>
			</tr>
		</tbody>
	</table>
 
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<div id="elementContainer">
		<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
			<table id="listTable" class="tbl-list">
				<colgroup>
					<col style="width: 40px" />
					<col style="width: auto" />
					<col style="width: 90px" />
					<col style="width: 90px" />
				</colgroup>
				<thead>
				<tr>
					<th><spring:message code="필드:번호" /></th>
					<th colspan="3"><spring:message code="필드:설문:설문내용" /></th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${listElement}" varStatus="i">
					<tr>
						<td>
							<c:out value="${i.count}"/>
						</td>
						<td class="align-l" colspan="3">
							<a href="javascript:void(0)" onclick="doDetailSurvey({'surveySeq' : '<c:out value="${row.univSurvey.surveySeq}" />', 'surveyItemTypeCd' : '<c:out value="${row.univSurvey.surveyItemTypeCd}" />'})">
								<c:out value="${row.univSurvey.surveyTitle}" />
							</a>
						</td>
					</tr>
					<tr id="row-<c:out value="${row.univSurvey.surveySeq}" />"  style="display:none;">
						<td colspan="4" id="result-<c:out value="${row.univSurvey.surveySeq}" />">
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty listElement}">
					<tr>
						<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</tbody>
			</table>
		</form>
	</div>
</div>
<form name="FormAjax" id="FormAjax" method="post" onsubmit="return false;">
	<input type="hidden" name="surveySeq" />
	<input type="hidden" name="surveyItemTypeCd" />
	<input type="hidden" name="courseActiveSurveySeq" value="<c:out value="${detail.courseActiveSurvey.courseActiveSurveySeq}"/>"/>
	<input type="hidden" name="totalMemberCount" value="<c:out value="${totalMemberCount}"/>"/>
	<input type="hidden" name="totalAnswerCount" value="<c:out value="${totalAnswerCount}"/>"/>
</form>
</body>
</html>