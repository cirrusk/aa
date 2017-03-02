<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<body>

<c:set var="studioMembers" value=""/>
<c:forEach var="row" items="${detailStudio.listStudioMember}" varStatus="iSub">
	<c:if test="${!empty studioMembers}">
		<c:set var="studioMembers" value="${studioMembers},"/>
	</c:if>
	<c:set var="studioMembers" value="${studioMembers}${row.member.memberSeq}"/>
</c:forEach>

<c:choose>
	<c:when test="${param['viewType'] eq 'week'}">

		<c:set var="minTime" value=""/>
		<c:set var="maxTime" value=""/>
		<c:forEach var="row" items="${listStudioTime}" varStatus="i">
			<c:if test="${i.first}">
				<c:set var="minTime" value="20000101${row.studioTime.startTime}00"/>
			</c:if>
			<c:if test="${i.last}">
				<c:set var="maxTime" value="20000101${row.studioTime.endTime}00"/>
			</c:if>
		</c:forEach>

		<script type="text/javascript">
		var params = {};
		params.charge = "<c:out value="${studioMembers}"/>";
		params.weekDay = "<c:out value="${detailStudio.studio.weekDay}"/>";
		params.minTime = "<aof:date datetime="${minTime}" pattern="HH:mm"/>";
		params.maxTime = "<aof:date datetime="${maxTime}" pattern="HH:mm"/>";
		doCreateCalendar("week", params);
		</script>
	

	</c:when>
	<c:when test="${param['viewType'] eq 'month'}">
		<script type="text/javascript">
		var params = {};
		params.charge = "<c:out value="${studioMembers}"/>";
		params.weekDay = "<c:out value="${detailStudio.studio.weekDay}"/>";
		doCreateCalendar("month", params);
		</script>

	</c:when>
</c:choose>
	
</body>
</html>