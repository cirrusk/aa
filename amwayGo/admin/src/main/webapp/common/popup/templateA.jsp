<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="nodesign">
<head>
<title></title>
<script type="text/javascript">
jQuery(document).ready(function(){
	if (UT.isPopup()) {

	} else {

	}
});
</script>
</head>
<body>
template A
<br>	
popupTitle=<c:out value="${param['popupTitle']}"/>
<br>
description=<c:out value="${param['description']}"/>
<br>
popupConfirmTypeCd=<c:out value="${param['popupConfirmTypeCd']}"/>
<br>
	
</body>
</html>