<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Error</title>

	<script type="text/javascript">
		var targettype = "";
		
		$(document.body).ready(function(){
				var postUrl = parent.document.URL.split("kr");
				var fullUrl = postUrl[0]+"kr/account/login";
				
				parent.location.href = fullUrl;
		});
		
	</script>

</head>

<body>
    <%--<spring:message code='fail.common.msg' />--%>
</body>
</html>