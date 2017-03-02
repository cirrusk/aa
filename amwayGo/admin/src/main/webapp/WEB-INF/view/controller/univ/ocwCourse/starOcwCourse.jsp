<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="checkPoint" value="0.0"></c:set>
<c:set var="ocwAvgResult"><c:out value="${param['ocwAvgResult']}"/></c:set>

<c:forEach var="row" begin="0" end="4">
	<c:choose>
		<c:when test="${checkPoint >= ocwAvgResult}"><aof:img src="ocw/star_img_01.png" /></c:when>
		<c:when test="${checkPoint < ocwAvgResult and  (checkPoint + 1.0) > ocwAvgResult}"><aof:img src="ocw/star_img_02.png" /></c:when>
		<c:otherwise><aof:img src="ocw/star_img_03.png" /></c:otherwise>
	</c:choose>
	<c:set var="checkPoint" value="${checkPoint + 1.0}"></c:set>
</c:forEach>