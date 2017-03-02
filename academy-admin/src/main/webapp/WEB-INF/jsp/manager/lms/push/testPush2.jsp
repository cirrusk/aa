<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

$(document.body).ready(function(){
	
});
	
	

</script>
</head>

<body class="bgw">
test2
	<h1>${data.status }</h1>
	<h1>${data.errorcode }</h1>
	<h1>${data.errormsg }</h1>
	<div>${data.msg }</div>
	<div>${data.msgType }</div>
	<div>${data.title }</div>
	<div>${data.uid }</div>
</body>
</html>