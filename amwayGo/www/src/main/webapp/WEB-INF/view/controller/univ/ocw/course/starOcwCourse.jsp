<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="checkPoint" value="0.0"></c:set>
<c:set var="ocwAvgResult"><c:out value="${param['ocwAvgResult']}"/></c:set>

<c:choose>
	<c:when test="${param['type'] eq 'small'}">
		<c:forEach var="row" begin="0" end="4">
			<a href="javascript:void(0);">
				<c:choose>
					<c:when test="${checkPoint >= ocwAvgResult}"><aof:img src="icon/rating_star_empty.png"/></c:when>
					<c:otherwise><aof:img src="icon/rating_star_full.png"/></c:otherwise>
				</c:choose>
			</a>
			<c:set var="checkPoint" value="${checkPoint + 1.0}"></c:set>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<c:forEach var="row" begin="0" end="4">
			<c:choose>
				<c:when test="${checkPoint >= ocwAvgResult}"><aof:img src="icon/icon_stars_empty.png" /></c:when>
				<c:when test="${checkPoint < ocwAvgResult and  (checkPoint + 1.0) > ocwAvgResult}"><aof:img src="icon/icon_stars_half.png" /></c:when>
				<c:otherwise><aof:img src="icon/icon_stars_full.png" /></c:otherwise>
			</c:choose>
			<c:set var="checkPoint" value="${checkPoint + 1.0}"></c:set>
		</c:forEach>
	</c:otherwise>
</c:choose>