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
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/www/layout.css" type="text/css"/>
<decorator:head />
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery(document).keydown(function(event) {
		UT.preventBackspace(event); // backspace 막기.
		UT.preventF5(event); // F5 막기.
	});
	Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터
	
	initPage();
});
</script>
</head>

<body onload="<decorator:getProperty property="body.onload" />">

<c:import url="/WEB-INF/view/include/header.jsp"/>

<c:set var="startPage"><c:url value="${aoffn:config('system.startPage')}"/></c:set>

<div id="wrap" class="main"><!--wrap-->
    <c:import url="/WEB-INF/view/decorator/head.jsp"/>

    <div class="visual"><!--visual-->
        <aof:img src="main/visual_txt.png" alt="더 나은 미래를 생각합니다. 4csoft가 당신의 내일을 밝혀 드립니다!" />
    </div><!--//visual-->

    <c:import url="/WEB-INF/view/decorator/menu.jsp">
        <c:param name="location">main</c:param>
    </c:import>

    <!-- container -->
    <div id="content"><!--content-->
        <decorator:body/>
    </div>
    <!-- //container -->

    <!-- footer -->
    <c:import url="/WEB-INF/view/include/footer.jsp"/>
    <!-- //footer -->
    
    <iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;"></iframe>
</div>

</body>
</html>