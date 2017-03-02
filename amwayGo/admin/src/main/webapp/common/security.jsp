<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="nodesign">
<head>
<title></title>
<script type="text/javascript">
jQuery(document).ready(function(){
	if (UT.isPopup()) {
		self.close();
		opener.location.href = self.location.href;
	} else {
		//alert("Security : " + "<c:out value="${param['param']}"/>");
		var action = $.action("submit", {formId : "FormSecurity"});
		action.config.target  = "_top";
		action.config.url     = "<c:url value="/index.jsp"/>";
		action.run();
	}
});
</script>
</head>
<body>
	
<form id="FormSecurity" name="FormSecurity">
	<input type="hidden" name="error" value="<c:out value="${param['param']}"/>">
</form>
	
</body>
</html>