<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: auto" />
        <col style="width: 200px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:설문:설문제목" /></th>
            <th><spring:message code="필드:설문:시작기간" />|<spring:message code="필드:설문:종료기간" /></th>
            <th><spring:message code="필드:설문:상태" /></th>
        </tr>
    </thead>
    <tbody>
        <c:set var="index"     value="0"/>
        <c:forEach var="row" items="${surveyList}" varStatus="i">
            <tr>
                <td class="align-l">
                    <c:out value="${row.surveyPaper.surveyPaperTitle}"/>
                </td> 
                <td>
                	<c:choose>
               			<c:when test="${not empty courseActive.courseTypeCd && courseActive.courseTypeCd ne CD_COURSE_TYPE_PERIOD}">
               				<spring:message code="글:수강시작"/>
               				<c:out value="${row.surveySubject.startDay}" /><spring:message code="글:일부터"/> ~
	            			<c:out value="${row.surveySubject.endDay}" /><spring:message code="글:일까지"/>
               			</c:when>
	               		<c:otherwise>
	               			<aof:date datetime="${row.surveySubject.startDtime}" /> ~
	                    	<aof:date datetime="${row.surveySubject.endDtime}" />
	               		</c:otherwise>
	               	</c:choose>
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
                <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
</table>