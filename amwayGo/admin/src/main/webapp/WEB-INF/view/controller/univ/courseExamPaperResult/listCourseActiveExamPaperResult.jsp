<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

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
var forSubList        = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    <c:choose>
    	<c:when test="${examType eq 'final'}">
		    doSub('final');
		    UI.tabs("#tabs").tabs("select", 1);
    	</c:when>
    	<c:otherwise>
		    doSub('middle');
		    UI.tabs("#tabs").tabs("select", 0);
    	</c:otherwise>
    </c:choose>
    
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSubList = $.action();
	forSubList.config.formId = "FormSub";
	forSubList.config.target = "listFrame";
	forSubList.config.fn.complete = function() {};

};
/**
 * 목록보기 가져오기 실행.
 */
doSub = function(examType) {
	if (examType == 'middle') {
		forSubList.config.url    = "<c:url value="/univ/course/active/middle/exampaper/result/list/iframe.do"/>";
	} else {
		forSubList.config.url    = "<c:url value="/univ/course/active/final/exampaper/result/list/iframe.do"/>";
	}
	forSubList.run();
};
/**
 * 구성정보로 이동
 */
goActiveMenu = function(examType) {
	if (examType == 'middle') {
		FN.doGoMenu('<c:url value="/univ/course/active/middle/exampaper/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');
	} else {
		FN.doGoMenu('<c:url value="/univ/course/active/final/exampaper/list.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');
	}
};
</script>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
	
	<c:if test="${menuSystemMywork.menuId ne appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이 아니면 --%>
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </c:if>
    
<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	
	<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<div id="tabs">
	<ul class="ui-widget-header-tab-custom">
		<li>
			<a href="#listFrame" onclick="doSub('middle');"><spring:message code="필드:시험:중간고사" /></a>
		</li>
		<li>
			<a href="#listFrame" onclick="doSub('final');"><spring:message code="필드:시험:기말고사" /></a>
		</li>
	</ul>
	
	<iframe id="listFrame" name="listFrame" frameborder="yes" scrolling="no" style="padding:0px; width:100%; height: 600px" onload="UT.noscrollIframe(this)"></iframe>
</div>

    <c:if test="${menuSystemMywork.menuId eq appCurrentMenu.menu.menuId}"> <%-- 마이페이지의 '나의할일'이면 --%>
        <c:import url="../include/myworkInc.jsp"></c:import>
    </c:if>

</body>
</html>