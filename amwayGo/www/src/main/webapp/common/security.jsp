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
		<c:if test="${param['ocwYn'] ne 'Y'}"><%-- 학사 --%>
			var action = $.action("submit", {formId : "FormSecurity"});
			action.config.target  = "_top";
			action.config.url     = "<c:out value="${appSystemDomain}"/><c:url value="/index.jsp"/>";
			action.run();
		</c:if>
		<c:if test="${param['ocwYn'] eq 'Y'}"><%-- OCW --%>
			parent.startPage("<c:out value="${param['param']}"/>");
		</c:if>
	}
});
</script>
</head>
<body>
	
<form id="FormSecurity" name="FormSecurity">
	<input type="hidden" name="error" value="<c:out value="${param['param']}"/>">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>">
	<input type="hidden" name="courseApplySeq" value="<c:out value="${courseApplySeq}"/>">
	<input type="hidden" name="signature" value="<c:out value="${param['signature']}"/>">
</form>
	
</body>
</html>