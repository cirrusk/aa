<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:forEach var="termRow" items="${yearTerms}" varStatus="i">
    <option value="<c:out value='${termRow.yearTerm}'/>" <c:if test="${termRow.yearTerm eq condition.srchYearTerm}">selected="selected"</c:if>>
        <c:out value='${termRow.yearTermName}'/>
    </option>
</c:forEach>