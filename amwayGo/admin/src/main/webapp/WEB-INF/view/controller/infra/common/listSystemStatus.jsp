<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<c:set var="domainNodejs" value="${aoffn:config('domain.nodejs')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSystemInfo = null;
var timer = null;
var defaultSecond = 60;
var $second = null;
var servers = [];
var started = false;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doSystemInfo();

	doSystemStatus(defaultSecond);
};
/**
 * 설정
 */
doInitializeLocal = function() {
	var options = {
		chartCss : {
			width : "100%",
			height : "300px"
		},
		plot : { // 차트영역
			margin : {left : 50, right : 20, top : 20, bottom : 40},
			overflow : "scroll",
			scrollBuffers : 100 
		},
		domain : { // 기준축
			label : {
				name : "<spring:message code="글:시간"/>",
				position : "right",
				margin : "20"
			},
			tick : {
				visibleStep : 0,
				count : 30
			}
		},
		range : { // 값 축
			label : {
				name : "<spring:message code="글:시스템:사용률"/>",
				position : "top"
			}
		},
		data : {
			label : {
				visible : false
			}
		}
	};

	forSystemInfo = $.action("ajax");
	forSystemInfo.config.type = "jsonp";
	forSystemInfo.config.url  = "<c:out value="${domainNodejs}/system/info/list"/>";
	forSystemInfo.config.fn.complete = function(action, data) {
		if (data != null) {
			var $detail = jQuery("#detail-data"); 
			$detail.show();

			for (var i = 0; i < data.length; i++) {
				var serverInfo = data[i];
				var id = serverInfo["_id"];
				var html = UT.formatString(doGetTemplate(), {
					"id" : id,
					"serverName" : serverInfo.serverName,
					"totalMemory" : UT.getFilesize(serverInfo.totalMemory)
				});
				$detail.append(jQuery(html));

				var server = {
					"id" : id,
					"serverName" : serverInfo.serverName
				};
				
				server.chart = jQuery.linechart(id + "-chart", options);
				server.chart.appendGroup("<spring:message code="글:시스템:시스템메모리"/>");
				server.chart.appendGroup("<spring:message code="글:시스템:CPU"/>");
				
				server.action = $.action("ajax");
				server.action.config.type = "jsonp";
				server.action.config.url  = "<c:out value="${domainNodejs}/system/status/lately"/>";
				server.action.index = i;
				server.action.config.fn.complete = function(action, data) {
					if (data != null) {
						if (started == false) {
							data.reverse();
						}
						for (var x = 0; x < data.length; x++) {
							var chart = servers[action.index].chart;
							chart.appendTickname(" ");
							chart.append(data[x].memoryUsage, data[x].cpuUsage);
						}
					}
					if (started == true) {
						doSystemStatusLatelyOne(action.index + 1);
					} else {
						doSystemStatusLatelyList(action.index + 1);
					}
				};

				servers.push(server);
			}
			if (servers.length > 0) {
				doSystemStatusLatelyList(0);
			}

		} else {
			jQuery("#no-data").show();
		}
	};
};
/**
 * 시스템 정보 
 */
doSystemInfo = function() {
	forSystemInfo.run();
};
/**
 * 시스템 상태 최근 30개
 */
doSystemStatusLatelyList = function(index) {
	if (index < servers.length) {
		var server = servers[index];
		var param = [];
		param.push("srchServerName=" + server.serverName);
		param.push("srchLimit=30");
		server.action.config.parameters = param.join("&");
		server.action.run();
	} else {
		started = true;
	}
};
/**
 * 시스템 상태 최근 1개 
 */
doSystemStatusLatelyOne = function(index) {
	if (index < servers.length) {
		var server = servers[index];
		var param = [];
		param.push("srchServerName=" + server.serverName);
		param.push("srchLimit=1");
		server.action.config.parameters = param.join("&");
		server.action.run();
	}
};
/**
 * 시스템 상황 시작
 */
doSystemStatus = function(second) {
	if (typeof second === "number" && timer != null) {
		clearTimeout(timer);
	}
	timer = setTimeout(function() {
		if ($second == null) {
			$second = jQuery("#FormTimer").find(":input[name='second']");
		}
		if (typeof second !== "number") {
			second = $second.val() == "" ? defaultSecond : parseInt($second.val(), 10);
		}
		if (second > 0) {
			$second.val(second - 1);
		} else {
			doSystemStatusLatelyOne(0);
			$second.val(defaultSecond);
		}
		doSystemStatus();
	}, 1000);
};
/**
 * 템플릿
 */
doGetTemplate = function() {
	var html = [];
	html.push("<div class='lybox-title'>");
	html.push("<h4 class='section-title'>{serverName}</h4>");
	html.push("</div>");
	html.push("<div class='lybox-nobg'>");
	html.push("<span><spring:message code="글:시스템:시스템메모리"/><spring:message code="글:시스템:크기"/> : </span>");
	html.push("<span>{totalMemory}</span>");
	html.push("<div id='{id}-chart'></div>");
	html.push("</div>");
	html.push("<div class='vspace'></div>");
	return html.join("");
};
</script>
<c:import url="/WEB-INF/view/include/chart.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>

	<div id="detail-data" style="display:none;">
		<form name="FormTimer" id="FormTimer" method="post" onsubmit="return false;">
			<div class="align-r">
				<input type="text" name="second" value="0" class="align-c" style="width:50px;" readonly="readonly"/>
				<span><spring:message code="글:초"/></span>
			</div>	
		</form>
		<div class="vspace"></div>
	</div>
	
	<div id="no-data" class="lybox align-c" style="display:none;">
		<spring:message code="글:데이터가없습니다"/>
	</div>
	
</body>
</html>