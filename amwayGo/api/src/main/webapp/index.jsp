<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<!-- https(ssl) 사용여부에 따른 분기 -->
<c:set var="loginURL" value=""/>
<c:choose>
	<c:when test="${aoffn:config('https.use') eq 'TRUE'}">
		<c:set var="serverName" value="<%=request.getServerName() %>"/>
		<c:set var="loginURL">https://<c:out value="${serverName}"/>:<c:out value="${aoffn:config('https.port')}"/><c:url value="/security/login"/></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="loginURL"><c:url value="/security/login"/></c:set>
	</c:otherwise>
</c:choose>

<html decorator="nodesign">
<head>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/admin/login.css" type="text/css"/>
<title><c:out value="${aoffn:config('system.name')}"/></title>
<script type="text/javascript">
var error = "<c:out value="${param['error']}"/>";
var sessionAlive = "<c:out value="${ssMemberName}"/>" != "" ? true : false;
jQuery(document).ready(function() {
	
	switch (error) {
	case "failure" :
		initPage();
		$.alert({message : "<spring:message code="글:로그인:아이디또는비밀번호가정확하지않습니다"/>"});
		break;
	case "accessRole" :
		initPage();
		$.alert({message : "<spring:message code="글:로그인:접근권한이없습니다"/>"});
		break;
	case "concurrent" :
		initPage();
		$.alert({message : "<spring:message code="글:로그인:다른곳에서로그인되었습니다"/>"});
		break;
	case "concurrentConfirm" :
		initPage();
		var retry = "<c:out value="${aoffn:encrypt(sessionScope['retryConcurrent'])}"/>";
		if (retry != "") {
			$.confirm({
				message : "<spring:message code="글:로그인:다른곳에서로그인되어있습니다"/><br><spring:message code="글:로그인:다른사용자의접속을끊고로그인하시겠습니까"/>",
				button1 : {
					callback : function() {
						doLogin("retryConcurrent=Y");
					}
				},
				button2 : {
					callback : function() {
						// no action
					}
				}
			});
		} else {
			$.alert({message : "<spring:message code="글:로그인:요청가능시간이초과되었습니다"/>"});
		}
		break;
	case "logout" :
		initPage();
		break;
	case "success" :
		startPage();
		break;
	default :
		if (sessionAlive == true) {
			startPage();
		} else {
			initPage();
		}
		break;
	}
});
initPage = function() {
	jQuery("#security").show();
	
	var form = UT.getById("FormLogin");
	var username = UT.getCookie("username");
	if (username != "") {
		form.elements["j_username"].value = username;
		form.elements["j_password"].focus();
	} else {
		form.elements["j_username"].focus();
	}
};
/**
 * 로그인 성공 또는 세션이 있을 경우 시작 페이지로 이동.
 */
startPage = function() {
	var action = $.action();
	action.config.url = "<c:out value="${appSystemDomain}"/><c:url value="${aoffn:config('system.startPage')}"/>";
	action.run();
};
/**
 * 로그인
 */
doLogin = function(param) {
	if( $("#aiTftCheck").is(":checked") ) {
		$("#tftCheck").val("Y");
	}
	
	var action = $.action("submit", {formId : "FormLogin"});
	action.config.target = "hiddenframe";
	action.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	action.config.url = "<c:out value="${loginURL}"/>";
	action.config.url += typeof param === "string" ? "?" + param : "";
	action.validator.set({
		title : "<spring:message code="필드:로그인:아이디"/>",
		name : "j_username",
		data : ["!null"]
	});
 	if (typeof param === "undefined") {
		action.validator.set({
			title : "<spring:message code="필드:로그인:비밀번호"/>",
			name : "j_password",
			data : ["!null"]
		});
	}
	action.run();

	var form = UT.getById(action.config.formId);
	UT.setCookie("username", form.elements["j_username"].value, 60*60*24*30, "/", "", "");
};
</script>
</head>
<body>
<div id="layout">
    <div class="login" id="security" style="display:none">
    	<div class="input">
    		<form id="FormLogin" name="FormLogin" method="post" onsubmit="return false;">
                <table cellpadding="0" cellspacing="0">
                    <tr valign="top">
                        <td width="62" height="22"><aof:img src="common/txt_id.gif" alt="필드:멤버:아이디" /></td>
                        <td width="145"><input type="text" name="j_username" tabindex="1"></td>
                        <td width="60" valign="middle" rowspan="2"><aof:img src="btn/login.gif" alt="버튼:로그인" onclick="doLogin();" style="cursor:pointer;"/></td>
                    </tr>
                    <tr>
                        <td><aof:img src="common/txt_pw.gif" alt="필드:멤버:비밀번호"  /></td>
                        <td><input type="password" name="j_password" tabindex="2" onkeyup="UT.callFunctionByEnter(event, doLogin)" /></td>
                    </tr>
                    <tr>
                    	<input type="hidden" id="tftCheck" name="tftCheck" value="N">
                    	<td>Ldap 패스</td>
                    	<td><input type="checkbox" id="aiTftCheck" value=""></td>
                    </tr>                    
                </table>
    		</form>
    	</div>
    	<noscript><c:import url="/WEB-INF/view/include/noscript.jsp"/></noscript>
    </div>
</div>
</body>
</html>
