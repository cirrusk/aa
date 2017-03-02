<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forEdit = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.tabs("#tabs").tabs('select', 0).show();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forEdit = $.action("ajax");
	forEdit.config.formId = "FormDetail";
	forEdit.config.url = "<c:url value="/setting/edit/ajax.do"/>";
	forEdit.config.type = "html";
	forEdit.config.containerId = "tabContainer";
	forEdit.config.fn.complete = function() {}
	
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
/**
 * 새로고침 
 */
doRefresh = function() {
	var $tabs = $('#tabs').tabs();
	var selected = $tabs.tabs('option', 'selected');
	$tabs.tabs('select', selected);
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div id="tabs" style="display:none;">
		<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
			<input type="hidden" name="settingTypeCd" />
		</form>
		
		<aof:code type="set" var="settingType" codeGroup="SETTING_TYPE" except="${aoffn:config('migration.code')}"/>
		
		<ul class="ui-widget-header-tab-custom">
			<c:forEach var="row" items="${settingType}" varStatus="i">
				<c:if test="${row.useYn eq 'Y'}">
					<li><a href="#tabContainer" onclick="doEdit({'settingTypeCd' : '<c:out value="${row.code}"/>'});"><c:out value="${row.codeName}"/></a></li>
				</c:if>
			</c:forEach>
		</ul>
		<div id="tabContainer"></div>
	</div>
	
</body>
</html>