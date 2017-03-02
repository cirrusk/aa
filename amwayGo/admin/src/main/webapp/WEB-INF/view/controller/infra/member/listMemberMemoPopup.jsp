<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	//[2]. 기본 설정 그룹
	onChange('<c:out value="${choice}" />');
	doClick('individual');
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
	forSearch.config.formId = "FormMain";
	forSearch.config.target = "frame-List";
};

/*
 * 변경될때 진행되는 ajax
 */
onChange = function(value){
	if(value == "add"){
		forSearch.config.url    = "<c:url value="/member/memo/list/Iframe.do"/>";
	}else{
		forSearch.config.url    = "<c:url value="/message/group/list/Iframe.do"/>";	
	}
	forSearch.run();
};

doCallBack = function(returnValue) {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
	}
	$layer.dialog("close");
};

doClick = function(value){
	var form = UT.getById(forSearch.config.formId);	
	if(value == 'individual'){
		onChange(form.elements['changeSelect'].value);
	} else {
		forSearch.config.url = "<c:url value="/category/member/list/iframe.do"/>";
		forSearch.run();
	}
};
</script>
</head>

<body>
	<c:set var="radio">individual= ,party=<spring:message code="필드:쪽지:단체발송"/></c:set>
	<c:set var="Select">add=<spring:message code="필드:쪽지:개별"/>,group=<spring:message code="필드:쪽지:그룹"/></c:set>
	<form name="FormMain" id="FormMain" method="post" onsubmit="return false;">
	<input type="hidden" name="srchMessageType" value="${param['messageType']}" />
		<div class="lybox search">
			<fieldset class="align-l">
				<spring:message code="필드:쪽지:대상선택"/>	
				<aof:code type="radio" codeGroup="${radio}" name="srchType" selected="${srchType}" except="party" onclick="doClick(this.value)" />
				<select name="changeSelect" onchange="onChange(this.value)" id="changeSelect">
					<aof:code type="option" codeGroup="${Select}" selected="${choice}"/>
				</select>
				<aof:code type="radio" codeGroup="${radio}" name="srchType" selected="${srchType}" except="individual" onclick="doClick(this.value)" />
			</fieldset>
		</div>
	</form>
	
	<iframe id="frame-List" name="frame-List" frameborder="no" scrolling="no" style="width:100%; height: 300px" onload="UT.noscrollIframe(this)"></iframe>

</body>
</html>