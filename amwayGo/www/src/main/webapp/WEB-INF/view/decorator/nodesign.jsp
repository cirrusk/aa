<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
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
<decorator:head />
</head>
<body onload="<decorator:getProperty property="body.onload" />" >

<div id="layout" class="wrap">

	<c:import url="/WEB-INF/view/include/header.jsp"/>

	<decorator:body />
	
	<c:import url="/WEB-INF/view/include/footer.jsp"/>
	
	<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;" title="hidden"></iframe>
</div>

</body>
</html>