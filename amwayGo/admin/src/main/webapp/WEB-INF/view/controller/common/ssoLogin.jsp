<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<script type="text/javascript">
var forLogin = null;
initPage = function() {
	doInitializeLocal();
	
	doLogin();
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forLogin = $.action();
	forLogin.config.formId = "_FormLogin";
	forLogin.config.url    = "http://www.4csoft.co.kr" + "<c:url value="/security/login"/>";
};

doLogin = function() {
	var form = UT.getById(forLogin.config.formId); 
<c:if test="${loginType eq 'ADMIN'}">
	forLogin.config.url    = "http://admin.4csoft.co.kr" + "<c:url value="/security/login"/>";
</c:if>
	forLogin.run();
};
</script>
<form name="_FormLogin" id="_FormLogin" method="post" onsubmit="return false;">
	<input type="hidden" name="j_username" value="<c:out value="${signature}" />" />
	<input type="hidden" name="j_password" value="<c:out value="${password}" />" />
	<input type="hidden" name="j_rolegroup" value="<c:out value="${rolegroup }" />" />
	<input type="hidden" name="j_roleCfString" value="<c:out value="${roleCfString }" />" />
	<input type="hidden" name="memberId" value="<c:out value="${memberid}" />" />
</form>
