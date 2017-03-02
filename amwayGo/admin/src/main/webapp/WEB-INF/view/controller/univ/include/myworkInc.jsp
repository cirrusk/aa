<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- '나의할일'메뉴일 경우 --%>
<script type="text/javascript">
doListdataMywork = function() {
	var action = $.action();
	action.config.formId = "FormListMywork";
	action.config.url    = "<c:url value="/mypage/course/active/lecturer/mywork/list.do"/>";
	action.run();
};
</script>
<c:set var="myworkCurrentPage" value="${param['myworkCurrentPage']}"/>
<c:set var="myworkPerPage"     value="${param['myworkPerPage']}"/>
<c:set var="myworkOrderby"     value="${param['myworkOrderby']}"/>
<c:if test="${empty param['myworkCurrentPage']}">
    <c:set var="myworkCurrentPage" value="1"/>
</c:if>
<c:if test="${empty param['myworkPerPage']}">
    <c:set var="myworkPerPage" value="${aoffn:config('system.defaultPerPage')}"/>
</c:if>
<c:if test="${empty param['myworkOrderby']}">
    <c:set var="myworkOrderby" value="1"/>
</c:if>
<form name="FormListMywork" id="FormListMywork" method="post" onsubmit="return false;">
    <input type="hidden" name="currentPage"  value="<c:out value="${myworkCurrentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${myworkPerPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${myworkOrderby}"/>" />
</form>
<div class="lybox-btn">
    <div class="lybox-btn-r">
        <a href="javascript:void(0)" onclick="doListdataMywork()" class="btn blue">
            <span class="mid"><spring:message code="버튼:목록" /></span> 
        </a>
    </div>
</div>
