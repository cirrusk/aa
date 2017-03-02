<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:forEach var="yearRow" items="${years}" varStatus="i">
    <option value="<c:out value='${yearRow}'/>" <c:if test="${yearRow eq condition.srchYear}">selected="selected"</c:if>>
        <c:out value='${yearRow}'/><spring:message code="필드:년도학기:년"/>
    </option>
</c:forEach>