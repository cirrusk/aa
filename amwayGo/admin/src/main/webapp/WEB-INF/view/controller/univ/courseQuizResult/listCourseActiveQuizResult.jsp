<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS" value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
    <c:if test="${row.menu.url eq '/mypage/course/active/lecturer/mywork/list.do'}"> <%-- 마이페이지의 '나의할일' 메뉴를 찾는다 --%>
        <c:set var="menuSystemMywork" value="${row.menu}" scope="request"/>
    </c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forDetailQuiz = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forDetailQuiz = $.action();
	forDetailQuiz.config.formId = "FormDetail";
	forDetailQuiz.config.url    = "<c:url value="/univ/course/active/quiz/result/detail.do"/>";

};
/**
 * 상세보기 화면을 호출하는 함수
 */
doDetailQuiz = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetailQuiz.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailQuiz.config.formId);
    // 상세화면 실행
    forDetailQuiz.run();
};
</script>
</head>

<body>
	
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<c:if test="${menuSystemMywork.menuId ne appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이 아니면 --%>
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
		 <div class="lybox-title">
	        <div class="right">
	           <c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
					<a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/quiz/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:설정" /></span></a>
		    	</c:if>
	        </div>
	    </div>       
    </c:if>
    
<div id="tabContainer">
    
 <c:import url="srchCourseActiveQuizResult.jsp" />
 
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 50px" />
	        <col style="width: auto" />
	        <col style="width: 200px" />
	        <col style="width: 200px" />
	        <col style="width: 100px" />
	        <col style="width: 80px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><spring:message code="필드:퀴즈:퀴즈제목" /></th>
	            <th><spring:message code="필드:퀴즈:응시기간" /></th>
	            <th>
	            	<spring:message code="필드:퀴즈:응시" />(<spring:message code="필드:퀴즈:채점" />)|<spring:message code="필드:퀴즈:미응시" />|<spring:message code="필드:퀴즈:대상자" />
	            </th>
	            <th><spring:message code="필드:시험:평가비율" /></th>
	            <th><spring:message code="필드:퀴즈:상태" /></th>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:forEach var="row" items="${examPaperList}" varStatus="i">
		    	<tr>
		    		<td>
		    			<c:out value="${i.count}" />
		    		</td>
		            <td class="align-l">
		                <a href="javascript:doDetailQuiz({'courseActiveExamPaperSeq' : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}" />'});"><c:out value="${row.courseExamPaper.examPaperTitle}"/></a>
		            </td>
		            <td>
		                <c:choose>
	            			<c:when test="${courseType eq 'period'}">
				                <aof:date datetime="${row.courseActiveExamPaper.startDtime}" />&nbsp;
							    <aof:date datetime="${row.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
				                <spring:message code="글:퀴즈:부터" /> 
				                <div class="vspace"></div>
				                <aof:date datetime="${row.courseActiveExamPaper.endDtime}" />&nbsp;
							    <aof:date datetime="${row.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
							    <spring:message code="글:퀴즈:까지" />
	            			</c:when>
	            			<c:otherwise>
	            				<spring:message code="글:수강시작"/><c:out value="${row.courseActiveExamPaper.startDay}" /><spring:message code="글:일부터"/> ~
	            				<c:out value="${row.courseActiveExamPaper.endDay}" /><spring:message code="글:일까지"/>
	            			</c:otherwise>
            			</c:choose>
		            </td>
		            <td>
            			<c:out value="${row.courseActiveExamPaper.answerCount}" />
            			(<c:out value="${row.courseActiveExamPaper.scoredCount}" />)&nbsp;&nbsp;|&nbsp;&nbsp;
            			<c:out value="${row.courseActiveSummary.memberCount - row.courseActiveExamPaper.answerCount}"/>&nbsp;&nbsp;|&nbsp;&nbsp;
            			<c:out value="${row.courseActiveSummary.memberCount}" />
		            </td>
		            <td>
		            	<c:out value="${row.courseActiveExamPaper.rate}" />
		            </td>
		            <td>
		            	<c:choose>
		            		<c:when test="${appToday ge row.courseActiveExamPaper.startDtime and appToday le row.courseActiveExamPaper.endDtime}">
		            			<spring:message code="글:퀴즈:진행중" />
		            		</c:when>
		            		<c:when test="${appToday gt row.courseActiveExamPaper.endDtime}">
		            			<spring:message code="글:퀴즈:종료" />
		            		</c:when>
		            		<c:when test="${appToday lt row.courseActiveExamPaper.startDtime}">
		            			<spring:message code="글:퀴즈:진행전" />
		            		</c:when>
		            	</c:choose>
		            </td>
		    	</tr>
	    	</c:forEach>
	        <c:if test="${empty examPaperList}">
	            <tr>
	                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
    
 </div>

    <c:if test="${menuSystemMywork.menuId eq appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이면 --%>
        <c:import url="../include/myworkInc.jsp"></c:import>
    </c:if>

</body>
</html>