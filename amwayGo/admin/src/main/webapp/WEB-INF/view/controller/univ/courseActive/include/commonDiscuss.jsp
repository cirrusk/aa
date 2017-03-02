<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<%-- Popup 과 Include 경우 스크립트 오류 방지 --%>
<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: auto" />
        <col style="width: 220px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:토론:토론주제" /></th>
            <th><spring:message code="필드:토론:토론기간" /></th>
            <th><spring:message code="필드:토론:평가비율" /></th>
        </tr>
    </thead>
    <tbody>
    <c:set var="totalRate" value="0"></c:set>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td class="align-l">
                <div class="text-ellipsis">
                    <c:out value="${row.discuss.discussTitle}"/>
                </div>
            </td>
            <td>
            	<c:choose>
               		<c:when test="${not empty courseActive.courseTypeCd && courseActive.courseTypeCd ne CD_COURSE_TYPE_PERIOD}">
               			<span><spring:message code="글:수강시작" /></span> <c:out value="${row.discuss.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${row.discuss.endDay}" /> <spring:message code="글:일까지" />
               		</c:when>
               		<c:otherwise>
               			<aof:date datetime="${row.discuss.startDtime}"/>
		                ~
		                <aof:date datetime="${row.discuss.endDtime}"/>
               		</c:otherwise>
               	</c:choose>
            </td>
            <td>
                <c:out value="${row.discuss.rate}"/>%
            </td>
        </tr>
        <c:set var="totalRate" value="${totalRate + row.discuss.rate}"></c:set>
    </c:forEach>
    <c:choose>
        <c:when test="${empty itemList}">
            <tr>
                <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="2" class="align-r"><spring:message code="필드:토론:합계비율" /></td>
                <td id="totalRate"><c:out value='${totalRate}'/>%</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </table>
