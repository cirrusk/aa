<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- https 에서 save 했을때 http 로 바꿔주는 페이지 --%>
<html decorator="script">
<head>
<script type="text/javascript">
initPage = function() {
	parent.Global.runningAction.run("complete", "<c:out value="${param['result']}"/>");
};
</script>
</head>
<body onload="initPage()">
</body>
</html>