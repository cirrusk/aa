<%@ page pageEncoding="UTF-8"          %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@
	page isErrorPage="true"            %><%@
	page buffer="8kb" autoFlush="true" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<c:set var="errorCode"    value="${requestScope['javax.servlet.error.status_code']}" scope="request"/>
<c:set var="errorUrl"     value="${requestScope['javax.servlet.error.servlet_path']}" scope="request"/>
<c:set var="errorDetail"  value="${requestScope['javax.servlet.error.exception']}"   scope="request"/>
<c:set var="errorMessage" scope="request"><spring:message code="글:빠른시간안에정상운영될수있도록조치하겠습니다"/></c:set>

<c:if test="${empty errorCode}">
	<c:if test="${!empty requestScope['SPRING_SECURITY_403_EXCEPTION']}"> <%-- security 에서 접근 권한 없을 경우. --%>
		<c:set var="errorCode"    value="403" scope="request"/>
		<c:set var="errorUrl"     value="${requestScope['javax.servlet.forward.servlet_path']}" scope="request"/>
		<c:set var="errorMessage" scope="request"><spring:message code="exception.access.denied"/></c:set>
	</c:if>
</c:if>
<c:if test="${errorCode eq '404'}">
	<c:set var="errorMessage" scope="request"><spring:message code="exception.notfound.page"/></c:set>
</c:if>

<c:if test="${empty errorUrl}">
	<c:set var="errorUrl" value="${requestScope['javax.servlet.error.request_uri']}" scope="request"/>
</c:if>
<c:if test="${empty errorUrl}">
	<c:set var="errorUrl" value="${requestScope['javax.servlet.forward.servlet_path']}" scope="request"/>
</c:if>
<c:if test="${empty errorUrl}">
	<c:set var="errorUrl" value="${requestScope['javax.servlet.forward.request_uri']}" scope="request"/>
</c:if>

<c:if test="${!empty requestScope['XSS_EXCEPTION']}">
	<c:set var="errorMessage" scope="request"><spring:message code="${requestScope['XSS_EXCEPTION']}"/></c:set>
</c:if>

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

<page:applyDecorator name="${decorator}">
<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
<c:if test="${decorator eq 'script'}">
	<c:choose>
		<c:when test="${aoffn:config('system.code') eq 'D'}">
			var errorCode = "<c:out value="${errorCode}"/>";
			var errorUrl = "<c:out value="${errorUrl}"/>";
			var errorMessage = "<c:out value="${errorMessage}"/>";
			alert(errorCode + "\n" + errorUrl + "\n" + errorMessage);
		</c:when>
		<c:otherwise>
			var error = "<spring:message code="글:이용에불편을드려죄송합니다" />";
			var errorMessage = "<c:out value="${errorMessage}"/>";
			alert(error + "\n" + errorMessage);
		</c:otherwise>
	</c:choose>
</c:if>
};
</script>
</head>
<body onload="initPage()">
	
	<c:choose>
		<c:when test="${aoffn:config('system.code') eq 'D'}">
			<div class="lybox-nobg">
				<div class="strong"><c:out value="${errorCode}"/></div>
				<div class="strong"><c:out value="${errorUrl}"/></div>
				<c:if test="${!empty errorMessage}">
					<div class="mt10"><c:out value="${errorMessage}"/></div>
				</c:if>
				<c:if test="${!empty errorDetail}">
					<div class="mt10"><c:out value="${errorDetail}"/></div>
				</c:if>
			</div>
		</c:when>
		<c:otherwise>
			<div class="lybox-nobg align-c" style="width:400px;">
				<div class="strong mt20 mb20"><spring:message code="글:이용에불편을드려죄송합니다" /></div>
				<!--<c:if test="${!empty errorMessage}">
					<div class="mt10 mb20"><c:out value="${errorMessage}"/></div>
				</c:if>
				-->
				<a href="javascript:history.back()" class="btn black mb20"><span class="small"><spring:message code="버튼:뒤로가기" /></span></a>
			</div>
		</c:otherwise>
	</c:choose>

</body>
</html>
</page:applyDecorator>
