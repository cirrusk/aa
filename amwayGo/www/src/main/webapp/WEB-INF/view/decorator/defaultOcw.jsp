<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<!doctype html>
<!--[if IE 7]><html lang="ko" class="old ie7"><![endif]-->
<!--[if IE 8]><html lang="ko" class="old ie8"><![endif]-->
<!--[if IE 9]><html lang="ko" class="modern ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="ko" class="modern">
<!--<![endif]--><head>
<title><c:out value="${aoffn:config('system.name')}"/></title>
<c:import url="/WEB-INF/view/include/meta.jsp"/>
<c:import url="/WEB-INF/view/include/css.jsp"/>
<c:import url="/WEB-INF/view/include/javascript.jsp"/>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/www/layout.css" type="text/css"/>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/www/ocw.css" type="text/css" />
<decorator:head />

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

<script type="text/javascript">

var menuInfo = null;
jQuery(document).ready(function(){
	jQuery(document).keydown(function(event) {
		UT.preventBackspace(event); // backspace 막기.
		UT.preventF5(event); // F5 막기.
	});
	Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터
	
	UI.inputComment("p_username", "lab");
	UI.inputComment("p_password", "lab");
	
	initPage();
	
});

/**
 * 로그인 성공 또는 세션이 있을 경우 시작 페이지로 이동.
 */
startPage = function(error) {
	
	switch (error) {
	case "failure" :
		$.alert({message : "<spring:message code="글:로그인:아이디또는비밀번호가정확하지않습니다"/>"});
		break;
	case "accessRole" :
		$.alert({message : "<spring:message code="글:로그인:접근권한이없습니다"/>"});
		break;
	case "concurrent" :
		$.alert({message : "<spring:message code="글:로그인:다른곳에서로그인되었습니다"/>"});
		break;
	case "concurrentConfirm" :
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
		break;
	case "logout" :
		doLogoutSuccess();
		break;
	case "success" :
		doLoginSuccess();
		break;
	}
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

};

/**
 * 로그아웃
 */
doLogout = function(){
	var action 			  = $.action();
	action.config.formId  = "FormLogout";
	action.config.target = "hiddenframe";
	action.config.url 	  = "<c:url value="/security/logout"/>";
	action.run();
}

/**
 * 로그인 성공
 */
doLoginSuccess = function(){
	doNowPageSubmit();
};

/**
 * 학사서비스 이동
 */
doDegreeMain = function(){
	var action = $.action();
	action.config.formId      = "FormDegreeMain";
	action.config.url     = "<c:out value="${appSystemDomain}"/><c:url value="/index.jsp"/>";
	action.run();
};

/**
 * 로그아웃 이동
 */
doLogoutSuccess = function(){
	
	var action = $.action();
	action.config.formId      = "FormLogoutSuccess";
	action.config.url = "<c:out value="${appSystemDomain}"/><c:url value="/univ/ocw/about.do"/>";
	action.run();
};

</script>
</head>

<body onload="<decorator:getProperty property="body.onload" />">

<c:import url="/WEB-INF/view/include/header.jsp"/>
<c:import url="/WEB-INF/view/include/nowPageSubmit.jsp"/>

<!-- 로그인 성공시 폼 -->
<form id="FormLoginSuccess" name="FormLoginSuccess" method="post" onsubmit="return false;">
	<input type="hidden" name="currentMenuId" value="<c:out value="${param['currentMenuId']}"/>">
</form>

<!-- 로그아웃 성공시 폼 -->
<form id="FormLogoutSuccess" name="FormLogoutSuccess" method="post" onsubmit="return false;">
	<input type="hidden" name="currentMenuId" value="001">
</form>

<!-- 학사서비스 바로가기 폼 -->
<form id="FormDegreeMain" name="FormDegreeMain" method="post" onsubmit="return false;">
	<input type="hidden" name="currentMenuId" value="">
</form>

<!-- skip -->
<div id="skip">
	<a href="#lnb"><spring:message code="필드:OCW:메인메뉴바로가기"/></a>
	<a href="#snb"><spring:message code="필드:OCW:좌측메뉴바로가기"/></a>
	<a href="#content"><spring:message code="필드:OCW:본문바로가기"/></a>
</div>
<!-- //skip -->
<div class="ocw">
	<!-- header -->
	<div class="header">
		<div class="section">
			<div class="gnb">
				<ul class="service">
					<li><a href="javascript:void(0)" onclick="doDegreeMain();" class="grad"><spring:message code="필드:OCW:학사서비스"/></a></li>
					<c:if test="${not empty ssMemberName}">
						<%-- <li><a href="#" class="favor" onclick="alert('준비중입니다.');"><spring:message code="필드:OCW:즐겨찾기"/></a></li> --%>
					</c:if>
				</ul>
				<div class="log">
					<%-- 로그인 전 --%>
					<c:if test="${empty ssMemberName}">
						<form id="FormLogin" name="FormLogin" method="post" onsubmit="return false;">
							<input type="hidden" name="ocwYn" value="Y">
							<fieldset>
								<legend><spring:message code="필드:OCW:로그인"/></legend>
								<p class="enter" id="p_username">
									<label class="lab" for="user-id"><spring:message code="필드:OCW:아이디"/></label>
									<input name="j_username" id="user-id" type="text" class="text" />
								</p>
								<p class="enter" id="p_password">
									<label class="lab" for="user-pw"><spring:message code="필드:OCW:비밀번호"/></label>
									<input name="j_password" id="user-pw" type="password" class="text" onkeyup="UT.callFunctionByEnter(event, doLogin)"/>
								</p>
								<button type="submit" class="btn-log" alt="<spring:message code="필드:OCW:로그인"/>" onclick="doLogin();"><spring:message code="필드:OCW:로그인"/></button>
							</fieldset>
						</form>
					</c:if>
					<%-- 로그인 전 --%>
					<%-- 로그인 후 --%>
					<c:if test="${not empty ssMemberName}">
						<form id="FormLogout" name="FormLogout" method="post" onsubmit="return false;">
							<input type="hidden" name="ocwYn" value="Y">
						</form>
						<spring:message code="글:로그인:X님안녕하세요" arguments="${ssMemberName}"/>
						<button type="submit" class="btn-log" alt="<spring:message code="필드:OCW:로그아웃"/>" onclick="doLogout();"><spring:message code="필드:OCW:로그아웃"/></button>
					</c:if>
					<%-- 로그인 후 --%>
				</div>
			</div>
			
			<h1 class="logo"><a href="#"><img src="<c:out value="${appDomainWeb}"/>/common/images/www/common/logo_ocw.gif" alt="4CSoft" /></a></h1>
			
			<c:import url="/WEB-INF/view/decorator/menuOcw.jsp">
				<c:param name="location">main</c:param>
			</c:import>
		</div>
	</div>
	<!-- //haeder -->
	<!--container-->
	<div id="container">
		
		<c:import url="/WEB-INF/view/decorator/menuOcw.jsp">
			<c:param name="location">left</c:param>
		</c:import>
		
		<div id="content">
			<decorator:body/>
		</div>
		
		<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;"></iframe>
	</div>
	<!-- //container -->
	<!-- footer -->
	<c:import url="/WEB-INF/view/include/footer.jsp"/>
	<!-- //footer -->
</div>
</body>
</html>