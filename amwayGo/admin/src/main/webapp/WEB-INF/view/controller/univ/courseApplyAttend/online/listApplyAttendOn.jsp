<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSubApply           = null;
var forSubWeek           = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	doSub('apply');
	
	UI.tabs("#tabs");
};
	
doInitializeLocal = function() {
	forSubApply = $.action();
	forSubApply.config.formId = "FormSub";
	forSubApply.config.url    = "<c:url value="/univ/course/online/attend/result/apply/list/iframe.do"/>";
	forSubApply.config.target = "listFrame";
	forSubApply.config.fn.complete = function() {};
	
	forSubWeek = $.action();
	forSubWeek.config.formId = "FormSub";
	forSubWeek.config.url    = "<c:url value="/univ/course/online/attend/result/week/list/iframe.do"/>";
	forSubWeek.config.target = "listFrame";
	forSubWeek.config.fn.complete = function() {};
};

doSub = function(type){
	if(type == 'apply'){
		forSubApply.run();
	}else{
		forSubWeek.run();
	}
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

	<c:import url="../../include/commonCourseActive.jsp"></c:import>
		
	<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
		<input type="hidden" name="srchActiveLecturerTypeCd" />
		<input type="hidden" name="srchCourseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="courseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
			
	<div id="tabs"> 
		<ul class="ui-widget-header-tab-custom">
			<li><a href="#listFrame" 
				onclick="doSub('apply');"><spring:message code="필드:출석결과:학습자별"/></a>
			</li>
			<li><a href="#listFrame" 
				onclick="doSub('week');"><spring:message code="필드:출석결과:주차별"/></a>
			</li>
		</ul>
		
	   	<c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R') and param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
	   		<a href="#" class="btn gray tab-btn" onclick="FN.doGoMenu('<c:url value="/univ/course/active/online/edit.do"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:설정" /></span></a> 
	   	</c:if>
	    
		<iframe id="listFrame" name="listFrame" frameborder="no" scrolling="no" style="padding:0px; width:100%; height: 600px " onload="UT.noscrollIframe(this)"></iframe>
	</div>
	
</body>
</html>