<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE"    value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_OCW"       value="${aoffn:code('CD.CATEGORY_TYPE.OCW')}"/>
<c:set var="CD_CATEGORY_TYPE_CONTENTS"  value="${aoffn:code('CD.CATEGORY_TYPE.CONTENTS')}"/>
<c:set var="CD_CATEGORY_TYPE_MOOC"      value="${aoffn:code('CD.CATEGORY_TYPE.MOOC')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_DEGREE = "<c:out value="${CD_CATEGORY_TYPE_DEGREE}"/>";
var CD_CATEGORY_TYPE_NONDEGREE = "<c:out value="${CD_CATEGORY_TYPE_NONDEGREE}"/>";
var CD_CATEGORY_TYPE_OCW = "<c:out value="${CD_CATEGORY_TYPE_OCW}"/>";
var CD_CATEGORY_TYPE_MOOC = "<c:out value="${CD_CATEGORY_TYPE_MOOC}"/>";

var forTab   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. tab
	var index = "<c:out value="${param['tabIndex']}"/>";
	index = (index == "") ? 0 : parseInt(index, 10);
	UI.tabs("#tabs").tabs('select', index).show();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forTab = $.action();
	forTab.config.formId = "FormTab";
	forTab.config.target = "iframe-category";
};
/*
 * 
 */
doTab = function(type) {
	switch(type) {
	case CD_CATEGORY_TYPE_DEGREE:
		forTab.config.url = "<c:url value="/category/degree/list/iframe.do"/>";
		break;
	case CD_CATEGORY_TYPE_NONDEGREE:
		forTab.config.url = "<c:url value="/category/nondegree/list/iframe.do"/>";
		break;
	case CD_CATEGORY_TYPE_OCW:
		forTab.config.url = "<c:url value="/category/ocw/list/iframe.do"/>";
		break;
    case CD_CATEGORY_TYPE_MOOC:
        forTab.config.url = "<c:url value="/category/mooc/list/iframe.do"/>";
        break;
	}
	forTab.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<form name="FormTab" id="FormTab" method="post" onsubmit="return false;">
	</form>

	<aof:code type="set" var="categoryTypeCode" codeGroup="CATEGORY_TYPE" except="${CD_CATEGORY_TYPE_CONTENTS},${CD_CATEGORY_TYPE_DEGREE},${CD_CATEGORY_TYPE_OCW},${CD_CATEGORY_TYPE_MOOC}"/>
	<div id="tabs" style="display:none;">
		<ul class="ui-widget-header-tab-custom">
			<c:forEach var="row" items="${categoryTypeCode}" varStatus="i">
				<li><a href="javascript:void(0)" onclick="doTab('<c:out value="${row.code}"/>')"><c:out value="${row.codeName}"/></a></li>
			</c:forEach>
		</ul>
		<iframe id="iframe-category" name="iframe-category" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
	</div>

</body>
</html>