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
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/www/login.css" type="text/css"/>
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
	case "findPw" :
        initPage();
        doResetPassword();
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

/**
 * 회원가입
 */
doJoin = function() {
	var action = $.action("layer");
	action.config.formId = "FormParameters";
	action.config.formEmpty = true;
	action.config.url = "<c:url value="/member/terms/popup.do"/>";
	action.config.options.width = 500;
	action.config.options.height = 500;
	action.config.options.title = "<spring:message code="글:멤버:회원가입"/>";
	action.run();
};

/**
 * 비밀번호 찾기
 */
doFindPassword = function() {
	var action = $.action("layer");
	action.config.formId = "FormParameters";
	action.config.formEmpty = true;
	action.config.url = "<c:url value="/member/find/password/popup.do"/>";
	action.config.options.width = 500;
	action.config.options.height = 200;
	action.config.options.title = "<spring:message code="글:로그인:비밀번호찾기"/>";
	action.run();
};

/**
 * 비밀번호 재설정
 */
doResetPassword = function() {
    var action = $.action("layer");
	action.config.formId = "FormParameters";
	action.config.parameters = "signature=" + "<c:out value="${param['signature']}"/>";
	action.config.url = "<c:url value="/member/reset/password/popup.do"/>";
	action.config.options.width = 500;
	action.config.options.height = 500;
	action.config.options.title = "<spring:message code="글:로그인:비밀번호변경"/>";
	action.run();
};

/**
 * OCW 메인으로 이동
 */
doOcw = function(){
	var action = $.action();
	action.config.formId = "FormOcw";
	action.config.url = "<c:url value="/univ/ocw/about.do"/>";
	action.config.target  = "_top";
	action.run();
}
</script>
</head>
<body>
<!-- OCW 메인용 폼 -->
<form id="FormOcw" name="FormOcw" method="post" onsubmit="return false;">
	<input type="hidden" name="currentMenuId" value="001">
</form>

<div id="security" style="display:none">
        <form id="FormLogin" name="FormLogin" method="post" onsubmit="return false;">
	<div id="mlogin">
        <div id="wrap_login">
            <div id="header_login">
                <h1><aof:img src="common/login_logo.gif" alt="4csoft"/></h1>
            </div>
            <div id="container_login">
                <div id="m_content_login">
                    <div class="m_visual">
                        <p class="welcome"><aof:img src="common/login_welcome.png" alt="4csoft"  /></p>
                    </div>
                    <div class="loginBox">
                        <div class="loginform">
                            <h2><aof:img src="common/login_tit.png"/></h2>
                            <dl>
                                <dt><aof:img src="common/login_tit_id.png" alt="아이디"  /></dt>
                                <dd><input name="j_username" type="text" class="login_input"  value=""/></dd>
                                <dt><aof:img src="common/login_tit_pw.png" alt="비밀번호"  /></dt>
                                <dd><input name="j_password" type="password" class="login_input" onkeyup="UT.callFunctionByEnter(event, doLogin)" value=""/></dd>
                            </dl>
                            <div class="logBtn"><a href="#"><aof:img src="btn/btn_login.png" alt="버튼:로그인" onclick="doLogin();" style="cursor:pointer;" /></a></div>
                        </div>
                        <div class="loginLink">
                            <dl>
                                <dt><spring:message code="글:로그인:아이디또는비밀번호를잊으셨나요"/></dt>
                                <dd><a class="btn_login01" href="javascript:void(0);" onclick="doFindPassword();"><strong><spring:message code="버튼:멤버:비밀번호찾기"/></strong></a></dd>
                                <dt><spring:message code="글:로그인:아직회원이아니신가요회원가입을하셔야사이트이용이가능합니다"/></dt>
                                <dd><a class="btn_login01" href="javascript:void(0);" onclick="doJoin();"><strong><spring:message code="버튼:멤버:회원가입하기"/></strong></a></dd>
                            </dl>
                        </div>
                    </div>
                    <c:import url="/WEB-INF/view/include/plugins.jsp">
                        <c:param name="type" value="installedHidden"/>
                    </c:import>
                </div>
        </div>
    </div>
	<noscript><c:import url="/WEB-INF/view/include/noscript.jsp"/></noscript>
    </div>
</div>

</body>
</html>

