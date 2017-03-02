<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<spring:message var="appLanguage" code="language"/>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/jquery/jquery-ui-1.8.23.custom.min.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/lib/jquery.aos.i18n.${appLanguage}.min.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/lib/jquery.aos.min.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/lib/jquery.aos.ui.min.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/lib/jquery.aos.util.min.js"></script>
<script type="text/javascript" src="<c:url value="/common/js/functions.jsp"/>"></script>
<!--[if IE 7]><script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/3rdparty/json2/json2.js"></script><![endif]-->
