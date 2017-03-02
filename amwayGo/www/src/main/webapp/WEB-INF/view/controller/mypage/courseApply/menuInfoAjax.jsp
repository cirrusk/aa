<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<dd class="h">
    <c:out value="${menuNowYearTerm.yearTermName}" />
</dd>
<dt class="h">수강중인 과목</dt>
<dd class="h">
    <select id="courseSelect" onchange="goSelectedCourse(this.value)">
        <option value="">수강중인목록</option>
        <c:forEach var="row" items="${menuApplyList.itemList}" varStatus="i">
        	<option value="${row.apply.courseApplySeq}"><c:out value="${row.active.courseActiveTitle}"/></option>
        </c:forEach>
    </select>
</dd>