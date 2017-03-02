<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata     = null;
var forDetail 		= null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forListdata = $.action();
    forListdata.config.formId = "FormData";
    forListdata.config.url    = "<c:url value="/univ/course/active/result/survey/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/active/result/survey/detail.do"/>";
    
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
};
/**
 * 상세보기 화면을 호출하는 함수 
 */
doDetail = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetail.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    // 상세화면 실행
    forDetail.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
    <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
 
 <c:import url="srchCourseActiveSurveyResult.jsp" />
 
 <div class="vspace"></div>
 
    <div class="lybox-title">
        <h4 class="section-title"><spring:message code="필드:설문:설문결과" /></h4>
        <div class="right">
           <c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
				<a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/survey/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:설정" /></span></a>
	    	</c:if>
        </div>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 50px" />
	        <col style="width: auto" />
	        <col style="width: 350px" />
	        <col style="width: 70px" />
	        <col style="width: 70px" />
	        <col style="width: 70px" />
	        <col style="width: 100px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><spring:message code="필드:설문:설문제목" /></th>
	            <th><spring:message code="필드:설문:설문기간" /></th>
	            <th><spring:message code="필드:설문:참여" /></th>
	            <th><spring:message code="필드:설문:미참여" /></th>
	            <th><spring:message code="필드:설문:대상인원" /></th>
	            <th><spring:message code="필드:설문:상태" /></th>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:set var="totalMemberCount" 	   value="0"/>
	    	<c:set var="totalAnswerCount" 	   value="0"/>
	    	<c:forEach var="row" items="${surveyList}" varStatus="i">
		    	<tr>
		    		<td>
	    				<c:out value="${i.count}"/>
		            </td>
		            <td class="align-l">
		                <a href="javascript:doDetail({'courseActiveSurveySeq' : '<c:out value="${row.courseActiveSurvey.courseActiveSurveySeq}" />'});">
		                	<c:out value="${row.surveySubject.surveyTitle}"/>
	                	</a>
		            </td>
		            <td>
		                <c:choose>
	            			<c:when test="${courseType eq 'period'}">
				                <aof:date datetime="${row.surveySubject.startDtime}" />&nbsp;
							    <aof:date datetime="${row.surveySubject.startDtime}" pattern="HH:mm:ss"/>
				                <spring:message code="글:설문:부터" /> ~
				                <aof:date datetime="${row.surveySubject.endDtime}" />&nbsp;
							    <aof:date datetime="${row.surveySubject.endDtime}" pattern="HH:mm:ss"/>
							    <spring:message code="글:설문:까지" />
	            			</c:when>
	            			<c:otherwise>
	            				<spring:message code="글:수강시작"/><c:out value="${row.surveySubject.startDay}" /><spring:message code="글:일부터"/> ~
	            				<c:out value="${row.surveySubject.endDay}" /><spring:message code="글:일까지"/>
	            			</c:otherwise>
            			</c:choose>
		            </td>
		            <td>
		            	<c:set var="totalMemberCount" value="${row.courseActiveSurvey.totalMemberCount}" />
		            	<c:set var="totalAnswerCount" value="${row.courseActiveSurvey.totalAnswerCount}" />
		            	<c:out value="${totalAnswerCount}" />
		            </td>
		            <td>
		            	<c:out value="${totalMemberCount - totalAnswerCount}" />
		            </td>
		            <td>
		            	<c:out value="${totalMemberCount}" />
		            </td>
		            <td>
		            	<c:choose>
		            		<c:when test="${appToday ge row.surveySubject.startDtime and appToday le row.surveySubject.endDtime}">
		            			<spring:message code="글:설문:진행중" />
		            		</c:when>
		            		<c:when test="${appToday gt row.surveySubject.endDtime}">
		            			<spring:message code="글:설문:종료" />
		            		</c:when>
		            		<c:when test="${appToday lt row.surveySubject.startDtime}">
		            			<spring:message code="글:설문:진행전" />
		            		</c:when>
		            	</c:choose>
		            </td>
		    	</tr>
	    	</c:forEach>
	        <c:if test="${empty surveyList}">
	            <tr>
	                <td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
    
</div>
</body>
</html>