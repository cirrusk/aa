<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<aof:text type="whiteTag" value="${detailPlan.courseActivePlan.courseActivePlan}"/>
<c:if test="${empty detailPlan.courseActivePlan.courseActivePlan}">
    <table class="tbl-detail-row">
        <colgroup>
            <col/>
        </colgroup>
        <tbody>
        <tr>
            <td><spring:message code="글:데이터가없습니다" /></td>
        </tr>
        </tbody>
    </table>
</c:if>