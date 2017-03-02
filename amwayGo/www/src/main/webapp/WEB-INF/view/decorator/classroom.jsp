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
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/www/classroom.css" type="text/css"/>
<decorator:head />
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery(document).keydown(function(event) {
		UT.preventBackspace(event); // backspace 막기.
		UT.preventF5(event); // F5 막기.
	});
	Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터
// 	document.oncontextmenu = function() { // 오른쪽마우스 막기
// 		return false;
// 	};
	initPage();
	
});
</script>
</head>

<body onload="<decorator:getProperty property="body.onload" />">

<c:import url="/WEB-INF/view/include/header.jsp"/>

<div class="classroom">

	<decorator:body/>
		
	<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;"></iframe>

</div>
</body>
</html>