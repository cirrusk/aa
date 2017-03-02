<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<c:set var="domainAdmin" value="${aoffn:config('system.domain')}"/>
<c:set var="domainWww" value="${aoffn:config('domain.www')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var defaultMinute = 30;
var activeMembers = {
	forAdmin : {
		action : null,
		timer : null,
		$minute : null
	},
	forWww : {
		action : null,
		timer : null,
		$minute : null
	}	
};
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	jQuery("#defaultMemberList").show();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	activeMembers.forAdmin.action = $.action("ajax");
	activeMembers.forAdmin.action.config.formId = "FormActiveMemberAdmin";
	activeMembers.forAdmin.action.config.type = "json";
	activeMembers.forAdmin.action.config.asynchronous = false;
	activeMembers.forAdmin.action.config.url  = "<c:out value="${domainAdmin}"/>" + "<c:url value="/common/active/member.do"/>";
	activeMembers.forAdmin.action.config.containerId = "activeMemberAdmin";
	activeMembers.forAdmin.action.config.fn.complete = function(action, data) {
		if (data != null && data.activeMember != null) {
			var html = [];
			var count = 0;
			for (var i = 0; i < data.activeMember.length; i++) {
				var member = data.activeMember[i];
				html.push("<li>");
				html.push(" - " + member.memberName + "(" + member.memberId + ")");
				html.push(" - " + member.ip + " - " + getUserAgent(member.userAgent));
				html.push("</li>");
				count++;
			}
			var $container = jQuery("#" + activeMembers.forAdmin.action.config.containerId); 
			$container.html(html.join(""));
			jQuery("#totalAdmin").html(count);
		}
		doActiveMemberAdmin();
	};
	
	activeMembers.forWww.action = $.action("ajax");
	activeMembers.forWww.action.config.formId = "FormActiveMemberWww";
	activeMembers.forWww.action.config.type = "json";
	activeMembers.forWww.action.config.asynchronous = false;
	activeMembers.forWww.action.config.url  = "<c:out value="${domainWww}"/>" + "/common/active/member.do?callback=?";
	activeMembers.forWww.action.config.containerId = "activeMemberWww";
	activeMembers.forWww.action.config.fn.complete = function(action, data) {
		if (data != null && data.activeMember != null) {
			var html = [];
			var count = 0;
			for (var i = 0; i < data.activeMember.length; i++) {
				var member = data.activeMember[i];
				html.push("<li>");
				html.push(" - " + member.memberName + "(" + member.memberId + ")");
				html.push(" - " + member.ip + " - " + getUserAgent(member.userAgent));
				html.push("</li>");
				count++;
			}
			var $container = jQuery("#" + activeMembers.forWww.action.config.containerId); 
			$container.html(html.join(""));
			jQuery("#totalWww").html(count);
		}
		doActiveMemberWww();	
	};
};
/**
 * admin 접속자 목록 시작
 */
doActiveMemberAdmin = function(minute) {
	if (typeof minute === "number" && activeMembers.forAdmin.timer != null) {
		clearTimeout(activeMembers.forAdmin.timer);
	}
	activeMembers.forAdmin.timer = setTimeout(function() {
		if (activeMembers.forAdmin.$minute == null) {
			activeMembers.forAdmin.$minute = jQuery("#" + activeMembers.forAdmin.action.config.formId).find(":input[name='minute']");
		}
		if (typeof minute !== "number") {
			minute = activeMembers.forAdmin.$minute.val() == "" ? 10 : parseInt(activeMembers.forAdmin.$minute.val(), 10);
		}
		if (minute > 0) {
			activeMembers.forAdmin.$minute.val(minute - 1);
			doActiveMemberAdmin();
		} else {
			activeMembers.forAdmin.action.run();
			activeMembers.forAdmin.$minute.val(defaultMinute);
		}
	}, 1000);
};
/**
 * www 접속자 목록 시작
 */
doActiveMemberWww = function(minute) {
	if (typeof minute === "number" && activeMembers.forWww.timer != null) {
		clearTimeout(activeMembers.forWww.timer);
	}
	activeMembers.forWww.timer = setTimeout(function() {
		if (activeMembers.forWww.$minute == null) {
			activeMembers.forWww.$minute = jQuery("#" + activeMembers.forWww.action.config.formId).find(":input[name='minute']");
		}
		if (typeof minute !== "number") {
			minute = activeMembers.forWww.$minute.val() == "" ? 10 : parseInt(activeMembers.forWww.$minute.val(), 10);
		}
		if (minute > 0) {
			activeMembers.forWww.$minute.val(minute - 1);
			doActiveMemberWww();
		} else {
			activeMembers.forWww.action.run();
			activeMembers.forWww.$minute.val(defaultMinute);
		}
	}, 1000);
};
/**
 * 접속단말(브라우저 체크하는 부분 jquery-1.8.2.js 의 소스를 이용함)
 */
getUserAgent = function(userAgent) {
	var uaMatch = function (ua) {
		ua = ua.toLowerCase();
		var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
			/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
			/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
			/(msie) ([\w.]+)/.exec( ua ) ||
			ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
			[];
		return {
			browser: match[ 1 ] || "",
			version: match[ 2 ] || "0"
		};
	};

	var matched = uaMatch(userAgent);
	var browser = {};
	if (matched.browser) {
		browser[matched.browser] = true;
		browser.version = matched.version;
	}

	// Chrome is Webkit, but Webkit is also Safari.
	if (browser.chrome) {
		browser.webkit = true;
	} else if ( browser.webkit ) {
		browser.safari = true;
	}
	var s = [];
	for (var p in browser) {
		if (typeof browser[p] === "boolean") {
			s.push(p);
		} else if (typeof browser[p] === "string") {
			s.push(browser[p]);
		}
	}
	return s.join(" ");
};
</script>
<style type="text/css">
.console {padding:5px;text-align:left;overflow:auto;height:500px;width:100%;}
.console li {width:300px;float:left;}
</style>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>
	
	<table class="tbl-detail" id="defaultMemberList" style="display:none;">
	<colgroup>
		<col style="width:auto;"/>
		<col style="width:100px;"/>
		<col style="width:120px;"/>
		<col style="width:auto;"/>
		<col style="width:100px;"/>
		<col style="width:120px;"/>
	</colgroup>
	<tr>
		<th><c:out value="${domainAdmin}"/></th>
		<th><span id="totalAdmin">0</span><span><spring:message code="글:명"/></span></th>
		<th>
			<form name="FormActiveMemberAdmin" id="FormActiveMemberAdmin" method="post" onsubmit="return false;">
			<input type="text" name="minute" value="30" style="width:50px;text-align:center;border:none;" readonly="readonly"/>
			<span><spring:message code="글:초"/></span>
			<a href="javascript:void(0)" onclick="doActiveMemberAdmin(0)" class="btn blue"><span class="mid"><spring:message code="버튼:새로고침"/></span></a>
			</form>
		</th>
		
		<th><c:out value="${domainWww}"/></th>
		<th><span id="totalWww">0</span><span><spring:message code="글:명"/></span></th>
		<th>
			<form name="FormActiveMemberWww" id="FormActiveMemberWww" method="post" onsubmit="return false;">
			<input type="text" name="minute" value="30" style="width:50px;text-align:center;border:none;" readonly="readonly"/>
			<span><spring:message code="글:초"/></span>
			<a href="javascript:void(0)" onclick="doActiveMemberWww(0)" class="btn blue"><span class="mid"><spring:message code="버튼:새로고침"/></span></a>
			</form>
		</th>
		
	</tr>
	<tr>
		<td colspan="3">
			<ul id="activeMemberAdmin" class="console"></ul>
		</td>
		<td colspan="3">
			<ul id="activeMemberWww" class="console"></ul>
		</td>
	</tr>
	</table>
	
</body>
</html>