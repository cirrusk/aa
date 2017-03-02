<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<!doctype html>
<!--[if IE 7]><html lang="ko" class="old ie7"><![endif]-->
<!--[if IE 8]><html lang="ko" class="old ie8"><![endif]-->
<!--[if IE 9]><html lang="ko" class="modern ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="ko" class="modern">
<!--<![endif]--><head>
<title><c:out value="${aoffn:config('system.name')}"/></title>
<c:import url="/WEB-INF/view/include/meta.jsp"/>
<c:import url="/WEB-INF/view/include/css.jsp"/>
<c:import url="/WEB-INF/view/include/javascript.jsp"/>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/www/layout.css" type="text/css"/>
<decorator:head />

<script type="text/javascript">
var menuInfo = null;
jQuery(document).ready(function(){
	jQuery(document).keydown(function(event) {
		UT.preventBackspace(event); // backspace 막기.
		UT.preventF5(event); // F5 막기.
	});
	Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터
	
	initPage();
	
	doMenuInfoAjax();
	
	doUnreadMemoAjax();	
});
doMenuInfoAjax = function() {
	menuInfo = $.action("ajax");
	menuInfo.config.type        = "html";
	menuInfo.config.formId      = "FormMenuInfo";
	menuInfo.config.containerId = "underMenuInfo";
	menuInfo.config.url         = "<c:url value="/univ/course/apply/menuinfo/ajax.do"/>";
	menuInfo.config.fn.complete = function() {};
	menuInfo.run();
};
doUnreadMemoAjax = function() {
	if($("#unreadMessage").length > 0){
		var action = $.action("ajax");
		action.config.type = "json";
		action.config.formId = "FormFavoriteList";
		action.config.url  = "<c:url value="/message/receive/unread.do"/>";
		action.config.fn.complete = function(action, data) {
			if (data != null && data.unreadMessage != null) {
				if(data.unreadMessage != 0){
					jQuery("#unreadMessage").html(data.unreadMessage);
				}else{
					jQuery("#unreadMessage").html(0);
				}
			}else{
				jQuery("#unreadMessage").html(0);
			}
			
		};
		action.run();
	};
};
</script>
</head>

<body onload="<decorator:getProperty property="body.onload" />">

<c:import url="/WEB-INF/view/include/header.jsp"/>

<c:set var="startPage" scope="request"><c:url value="${aoffn:config('system.startPage')}"/></c:set>
<c:set var="currentTopMenu" value="${fn:substring(appCurrentMenu.menu.menuId, 0, 3)}" scope="request"/>

<div id="wrap" class="main"><!--wrap-->
    <c:import url="/WEB-INF/view/decorator/head.jsp"/>

	<!-- container -->
	<div id="container">
		<c:import url="/WEB-INF/view/decorator/menu.jsp">
			<c:param name="location">left</c:param>
		</c:import>

        <div class="right-area"><!-- right-area -->
			<decorator:body/>
		</div><!-- //right-area -->

	</div>
	<!-- //container -->

	<!-- footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp"/>
	<!-- //footer -->
	
	<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;"></iframe>
</div>
<form name="FormMenuInfo" id="FormMenuInfo" method="post" onsubmit="return false;">
</form>

</body>
</html>