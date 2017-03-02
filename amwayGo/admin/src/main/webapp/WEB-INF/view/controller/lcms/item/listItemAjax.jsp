<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
</script>
</head>

<body>

	<c:forEach var="row" items="${itemList}" varStatus="i">
		<li style="border-top:#d1d1d1 1px dotted;">[<c:out value="${i.count}"/>]. <c:out value="${row.item.title}"/></li>
	</c:forEach>
	
</body>
</html>