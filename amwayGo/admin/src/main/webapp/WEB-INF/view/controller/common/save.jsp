<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="script">
<head>
<script type="text/javascript">
initPage = function() {
	if (self.location.protocol == "https:") {
		self.location.href = "<c:url value="/common/saveRedirect.jsp"/>?result=<c:out value="${result}"/>"; // /common/saveRedirect.jsp는 https 방식으로 등록 되어있지 않기 때문에 http로 변환된다
	} else {
		parent.Global.runningAction.run("complete", "<c:out value="${result}"/>");
	}
};
</script>
</head>
<body onload="initPage()">
</body>
</html>