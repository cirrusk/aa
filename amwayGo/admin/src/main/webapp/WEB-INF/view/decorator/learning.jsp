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
	<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/admin/learning.css" type="text/css"/>
	<c:import url="/WEB-INF/view/include/javascript.jsp"/>
	<decorator:head />
	<script type="text/javascript">
	var $layer = null;
	jQuery(document).ready(function(){
		Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터
		jQuery(document).keydown(function(event) {
			UT.preventBackspace(event); // backspace 막기.
			UT.preventF5(event); // F5 막기.
		});
		document.oncontextmenu = function() { // 오른쪽마우스 막기
			return false;
		};
		SUB.initPage();
	});
	</script>
</head>

<body style="overflow:hidden; padding:0;">
	<c:import url="/WEB-INF/view/include/header.jsp"/>
	<decorator:body />
	<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;" title="hidden"></iframe>
</body>
</html>