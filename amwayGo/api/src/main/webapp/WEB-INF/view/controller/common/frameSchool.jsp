<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="domainWww" value="${aoffn:config('domain.www')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
};
</script>
</head>

<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>
	
	<iframe src="<c:out value="${aoffn:config('domain.web')}"/>/common/html/sample/koreaUniv/koreaUnivSample.htm" id="schoolFrame" name="schoolFrame" frameborder="no" scrolling="no" style="padding:0px; width:100%; height: 600px " onload="UT.noscrollIframe(this)"></iframe>
</body>
</html>