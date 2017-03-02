<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<c:set var="srchEndDate" value="${aoffn:today()}"/>
<c:set var="srchStartDate"><aof:date datetime="${srchEndDate}" pattern="${aoffn:config('format.dbdatetimeStart')}" addDate="-30"/></c:set>
<c:set var="domainNodejs" value="${aoffn:config('domain.nodejs')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forLog = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.datepicker("#srchStartDate");
	UI.datepicker("#srchEndDate");
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forLog = $.action("ajax", {formId : "FormSrch"});
	forLog.config.type = "jsonp";
	forLog.config.url  = "<c:url value="${domainNodejs}/log/list"/>";
	forLog.config.containerId = "logList";
	forLog.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forLog.config.fn.complete = function(action, data) {
		if (data != null) {
			var summary = {};
			for (var i = 0; i < data.length; i++) {
				var row = data[i];
				var id = row.target;
				if (typeof summary[id] === "undefined") {
					summary[id] = {
						target : "",
						count : 0,
						sum : 0,
						average : 0,
						big : []
					};
				}
				summary[id].target = row.target;
				summary[id].count += 1;
				summary[id].sum += row.executeTime;
				summary[id].average = Math.round(summary[id].sum / summary[id].count);
				if (row.executeTime > 2000) {
					summary[id].big.push(row.executeTime);
				}
			}
			var analysis = [];
			for (var id in summary) {
				analysis.push(summary[id]);
			}
			doDisplayData(analysis, 1);

			jQuery(".sort").each(function() {
				var $this = jQuery(this);
				var $parent = $this.parent();
				$parent.unbind("click");
			});
			jQuery(".sort").each(function() {
				var $this = jQuery(this);
				var $parent = $this.parent();
				$parent.css("cursor", "pointer");

				$parent.click(function(){
					var sortid = parseInt($this.attr("sortid"), 10) * (-1);
					jQuery(".sort").removeClass("sort_asc").removeClass("sort_desc");
					if (sortid > 0) {
						$this.addClass("sort_asc");
					} else {
						$this.addClass("sort_desc");
					}
					$this.attr("sortid", sortid);
					doDisplayData(analysis, sortid);
				});
			});

			jQuery("#no-data").hide();
			jQuery("#list-data").show();
		} else {
			jQuery("#list-data").hide();
			jQuery("#no-data").show();
		}
	};
};
/**
 * 검색
 */
doSearch = function() {
	forLog.run();
};
/**
 * 목록 출력, sorting
 */
doDisplayData = function(arr, orderby) {
	var $container = jQuery("#" + forLog.config.containerId);
	$container.empty();

	var compare = null;
	switch(Math.abs(orderby)) {
	case 2:
		compare = function(a, b) {
			if (a.count > b.count) {
				return 1;
			} else if (a.count < b.count) {
				return -1;
			} else {
				return 0;
			}
		};
		break;
	case 3:
		compare = function(a, b) {
			if (a.average > b.average) {
				return 1;
			} else if (a.average < b.average) {
				return -1;
			} else {
				return 0;
			}
		};
		break;
	case 1:
	default:
		compare = function(a, b) {
			if (a.target > b.target) {
				return 1;
			} else if (a.target < b.target) {
				return -1;
			} else {
				return 0;
			}
		};
		break;
	}
	arr.sort(compare);
	if (orderby < 0) {
		arr.reverse();
	}
	
	var html = [];
	for (var index in arr) {
		html.push("<tr>");
		html.push("<td class='align-l'>" + arr[index].target + "</td>");
		html.push("<td>" + arr[index].count + "</td>");
		html.push("<td>" + arr[index].average + "</td>");
		html.push("<td>" + arr[index].big.join(",") + "</td>");
		html.push("</tr>");
	}
	jQuery(html.join("")).appendTo($container);
	
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>

	<c:set var="logType">trace=TRACE,sql=SQL</c:set>

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<select name="srchLogType">
					<aof:code type="option" codeGroup="${logType}" defaultSelected="trace"/>
				</select>
				
				<strong><spring:message code="글:시스템:기간"/></strong>
				<input type="text" name="srchStartDate" value="<aof:date datetime="${srchStartDate}"/>" id="srchStartDate" class="datepicker" readonly="readonly"/>
				~
				<input type="text" name="srchEndDate" value="<aof:date datetime="${srchEndDate}"/>" id="srchEndDate" class="datepicker" readonly="readonly"/>
				
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>

	<div class="vspace"></div>
		
	<table id="list-data" class="tbl-list" style="display:none;">
	<colgroup>
		<col style="width:auto" />
		<col style="width:100px" />
		<col style="width:150px" />
		<col style="width:auto" />
	</colgroup>
	<thead>
		<tr>
			<th><span class="sort" sortid="1"><spring:message code="글:시스템:대상" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="글:시스템:요청횟수" /></span></th>
			<th><span class="sort" sortid="3"><spring:message code="글:시스템:평균응답시간" />(ms)</span></th>
			<th><fmt:message key="글:시스템:X초이상응답"><fmt:param>2</fmt:param></fmt:message>(ms)</th>
		</tr>
	</thead>
	<tbody id="logList">
	</tbody>
	</table>
	
	<div id="no-data" class="lybox align-c" style="display:none;">
		<spring:message code="글:데이터가없습니다"/>
	</div>
	
</body>
</html>