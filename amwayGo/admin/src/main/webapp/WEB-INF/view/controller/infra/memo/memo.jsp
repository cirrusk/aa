<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forMemoRecv = null;
var forMemoSend = null;
var forMemoCreate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.tabs("#tabs").show();
	
	doTab(0);
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forMemoRecv = $.action();
	forMemoRecv.config.formId = "FormMemoCreate";
	forMemoRecv.config.url = "<c:url value="/message/receive/list/iframe.do"/>";
	forMemoRecv.config.target = "frame-memo-receive";
	
	forMemoSend = $.action();
	forMemoSend.config.formId = "FormMemoCreate";
	forMemoSend.config.url = "<c:url value="/message/send/list/iframe.do"/>";
	forMemoSend.config.target = "frame-memo-send";
	
	forMemoCreate = $.action("layer");
	forMemoCreate.config.formId = "FormMemoCreate";
	forMemoCreate.config.url = "<c:url value="/message/send/create/popup.do"/>";
	forMemoCreate.config.options.width  = 700;
	forMemoCreate.config.options.height = 500;
	forMemoCreate.config.options.callback = doMemoSendComplete;
	
	forMemoGroup = $.action();
	forMemoGroup.config.formId = "FormMemoCreate";
	forMemoGroup.config.url = "<c:url value="/message/group/list/iframe.do"/>";
	forMemoGroup.config.target = "frame-memo-group";
};
/**
 * 받은쪽지
 */
doMemoRecv = function() {
	forMemoRecv.run();
};
/**
 * 보낸쪽지
 */
doMemoSend = function() {
	forMemoSend.run();
};
/*
 * 주소록 그룹
 */
doMemoGroup = function(){
	forMemoGroup.run();
};
/**
 * 쪽지보내기 
 */
doMemoCreate = function() {
	var form = UT.getById(forMemoCreate.config.formId);
	form.elements['receiveMemberSeq'].value = "";
	form.elements['receiveMemberName'].value = "";
	form.elements['receiveMemberId'].value = "";
	forMemoCreate.run();
};
/**
 * 쪽지보내기 완료
 */
doMemoSendComplete = function() {
	var $tabs = $('#tabs').tabs();
	var selected = $tabs.tabs('option', 'selected');
	$tabs.tabs('select', selected);
};
/**
 * 탭열기
 */
doTab = function(index) {
	$('#tabs').tabs({selected : index});
};
/**
 * 프레임 리사이징
 */
 onLoadIframe = function(frameId) {
	var frame = UT.getById(frameId);
	UT.noscrollIframe(frame);
}; 
/**
 * 보낸사람에게 쪽지쓰기(답장하기)
 */
doMemoCreateReply = function(mapPKs) {
	UT.getById(forMemoCreate.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forMemoCreate.config.formId);
	forMemoCreate.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="image"><aof:img src="common/myclassroom.gif"/></c:param>
		<c:param name="name"><spring:message code="메뉴:쪽지"/></c:param>
	</c:import>

	<form name="FormMemoCreate" id="FormMemoCreate" method="post" onsubmit="return false;">
		<input type="hidden" name="receiveMemberSeq">
		<input type="hidden" name="receiveMemberName">
		<input type="hidden" name="receiveMemberId">
	</form>
	
	<div class="clear"></div>

	<div id="tabs" style="display:none;">
		<ul class="ui-widget-header-tab-custom">
			<li><a href="#tabContainer1" onclick="doMemoRecv()"><spring:message code="글:쪽지:받은쪽지"/></a></li>
			<li><a href="#tabContainer2" onclick="doMemoSend()"><spring:message code="글:쪽지:보낸쪽지"/></a></li>
		</ul>
		<div id="tabContainer1">
			<iframe id="frame-memo-receive" name="frame-memo-receive" 
				frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</div>
		<div id="tabContainer2">
			<iframe id="frame-memo-send" name="frame-memo-send" 
					frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
		</div>
	</div>
		
</body>
</html>