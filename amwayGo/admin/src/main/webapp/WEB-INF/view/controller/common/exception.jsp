<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@
	page isErrorPage="true"            %><%@
	page buffer="8kb" autoFlush="true" %>

<c:set var="errorUrl" value="${requestScope['javax.servlet.error.servlet_path']}" scope="request"/>
<c:set var="errorMessage" value="${requestScope['javax.servlet.error.message']}" scope="request"/>
	
<c:choose>
	<c:when test="${aoffn:matchAntPathPattern('/**/*.jsp', errorUrl)}">
		<c:set var="decorator" value="nodesign"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/response*', errorUrl)}">
		<c:set var="decorator" value="nodesign"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/insert*', errorUrl)}">
		<c:set var="decorator" value="script"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/update*', errorUrl)}">
		<c:set var="decorator" value="script"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/delete*', errorUrl)}">
		<c:set var="decorator" value="script"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/save*', errorUrl)}">
		<c:set var="decorator" value="script"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/ajax.*', errorUrl)}">
		<c:set var="decorator" value="ajax"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/json.*', errorUrl)}">
		<c:set var="decorator" value="ajax"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/iframe.*', errorUrl)}">
		<c:set var="decorator" value="iframe"/>
	</c:when>
	<c:when test="${aoffn:matchAntPathPattern('/**/popup.*', errorUrl)}">
		<c:set var="decorator" value="popup"/>
	</c:when>
	<c:otherwise>
		<c:set var="decorator" value="default"/>
	</c:otherwise>
</c:choose>

<html decorator="<c:out value="${decorator}"/>">
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
<c:if test="${decorator eq 'script'}">
	<c:choose>
		<c:when test="${aoffn:config('system.code') eq 'D'}">
			var errorUrl = "<c:out value="${errorUrl}"/>";
			var errorMessage = "<spring:message code="${errorMessage}" text="${errorMessage}" javaScriptEscape="true"/>";
			alert(errorMessage + "\n" + errorUrl);
		</c:when>
		<c:otherwise>
			var error = "<spring:message code="글:이용에불편을드려죄송합니다" />";
			var errorMessage = "<spring:message code="${errorMessage}" text="${errorMessage}" javaScriptEscape="true"/>";
			alert(error + "\n" + errorMessage);
		</c:otherwise>
	</c:choose>
</c:if>
};
initPage();
</script>
</head>
<body>

	<c:choose>
		<c:when test="${aoffn:config('system.code') eq 'D'}">
			<div class="lybox-nobg">
				<div class="strong"><c:out value="${errorUrl}"/></div>
				<c:if test="${!empty errorMessage}">
					<div class="mt10 mb10"><spring:message code="${errorMessage}" text="${errorMessage}"/></div>
				</c:if>
				<c:forEach var="row" items="${exception.stackTrace}">
				    <div><c:out value="${row}"/></div>
				</c:forEach>
			</div>
		</c:when>
		<c:otherwise>
			<div class="lybox-nobg align-c" style="width:400px;">
				<div class="strong mt20 mb20"><spring:message code="글:이용에불편을드려죄송합니다" /></div>
				<%--
				<c:if test="${!empty errorMessage}">
					<div class="mt10 mb20"><spring:message code="${errorMessage}" text="${errorMessage}"/></div>
				</c:if>
				 --%>
				<a href="javascript:history.back()" class="btn black mb20"><span class="small"><spring:message code="버튼:뒤로가기" /></span></a>
			</div>
		</c:otherwise>
	</c:choose>

</body>
</html>
