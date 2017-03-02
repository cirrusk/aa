<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table id="listTable" class="tbl-list mt10">
    <colgroup>
        <col style="width: auto" />
        <col style="width: 300px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:시험:시험제목" /></th>
            <th><spring:message code="필드:시험:응시기간" /></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${examList}" varStatus="i">
            <tr>
                <td class="align-l">
                    <c:out value="${row.courseExamPaper.examPaperTitle}"/>
                </td>
                <td>
                	<c:choose>
	               		<c:when test="${not empty courseActive.courseTypeCd && courseActive.courseTypeCd ne CD_COURSE_TYPE_PERIOD}">
               				<spring:message code="글:수강시작"/>
               				<c:out value="${row.courseActiveExamPaper.startDay}" /><spring:message code="글:일부터"/> ~
            				<c:out value="${row.courseActiveExamPaper.endDay}" /><spring:message code="글:일까지"/>
	               		</c:when>
	               		<c:otherwise>
	               			<aof:date datetime="${row.courseActiveExamPaper.startDtime}" /> ~
                    		<aof:date datetime="${row.courseActiveExamPaper.endDtime}" />
	               		</c:otherwise>
	               	</c:choose>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty examList}">
            <tr>
                <td colspan="2" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
</table>