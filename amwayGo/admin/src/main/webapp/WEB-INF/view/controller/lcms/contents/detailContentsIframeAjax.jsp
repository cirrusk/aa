<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
</head>

<body>

	<c:forEach var="row" items="${contentsList}" varStatus="i">
		<ul>
			<li class="align-l">
				<a href="javascript:doSelect('<c:out value="${row.organization.organizationSeq}" />','<c:out value="${row.organization.title}" />');" title="<spring:message code="글:선택"/>"><c:out value="${i.count}"/>. <c:out value="${row.organization.title}"/></a>
			</li>
		</ul>
	</c:forEach>
	
</body>
</html>