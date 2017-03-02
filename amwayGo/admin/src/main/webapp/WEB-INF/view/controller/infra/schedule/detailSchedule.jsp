<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="popup">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/calendar.jsp"/>
<script type="text/javascript">
var weeks = {
	0 : "<spring:message code="글:일정:일"/>",
	1 : "<spring:message code="글:일정:월"/>",
	2 : "<spring:message code="글:일정:화"/>",
	3 : "<spring:message code="글:일정:수"/>",
	4 : "<spring:message code="글:일정:목"/>",
	5 : "<spring:message code="글:일정:금"/>",
	6 : "<spring:message code="글:일정:토"/>"
};
initPage = function() {
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	doDisplayRepeatType();
};
/**
 * 반복내용 출력
 */
doDisplayRepeatType = function() {
	var $comment = jQuery("#commentRepeatType");
	var $form = jQuery("#FormDetail");
	var repeatYn = $form.find(":input[name='repeatYn']").val();
	if (repeatYn == "Y") {
		var repeatType = $form.find(":input[name='repeatTypeCd']").val();
		var cycle = $form.find(":input[name='repeatCycle']").val();
		var startDate = doStringToDate($form.find(":input[name='startDtime']").val());
		var endDate = doStringToDate($form.find(":input[name='endDtime']").val());

		var sYear = startDate.getFullYear() + "<spring:message code="글:년"/>";
		var sMonth = (startDate.getMonth() + 1) + "<spring:message code="글:월"/>";
		var sDate = startDate.getDate() + "<spring:message code="글:일"/>";
		var sHour = startDate.getHours() + "<spring:message code="글:시"/>";
		var sMinute = startDate.getMinutes() + "<spring:message code="글:분"/>";
		var eYear = endDate.getFullYear() + "<spring:message code="글:년"/>";
		var eMonth = (endDate.getMonth() + 1) + "<spring:message code="글:월"/>";
		var eDate = endDate.getDate() + "<spring:message code="글:일"/>";
		var eHour = endDate.getHours() + "<spring:message code="글:시"/>";
		var eMinute = endDate.getMinutes() + "<spring:message code="글:분"/>";

		var html = [];
		switch (repeatType) {
		case "year":
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X년마다"/>", {0:cycle}) : "<spring:message code="글:일정:매년"/>");
			html.push(sMonth + sDate + sHour + sMinute + "~" + eMonth + eDate + eHour + eMinute);
			break;			
		case "month":
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X개월마다"/>", {0:cycle}) : "<spring:message code="글:일정:매월"/>");
			html.push(sDate + sHour + sMinute + "~" + eDate + eHour + eMinute);
			break;
		case "week":
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X주마다"/>", {0:cycle}) : "<spring:message code="글:일정:매주"/>");
			var week = $form.find(":input[name='repeatWeek']").val().split(",");
			var w = [];
			for (var index in week) {
				w.push(weeks[week[index]]);
			};
			html.push(w.join(","));
			html.push(sHour + sMinute + "~" + eHour + eMinute);
			break;
		case "day":
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X일마다"/>", {0:cycle}) : "<spring:message code="글:일정:매일"/>");
			html.push(sHour + sMinute + "~" + eHour + eMinute);
			break;
		}
		
		if ($form.find(":input[name='unlimitedYn']").val() == "Y") {
			html.push("<spring:message code="글:일정:무제한"/>");
			html.push("<spring:message code="글:일정:반복"/>");
		} else {
			html.push(UT.formatString("<spring:message code="글:일정:X까지"/>", {0: $form.find(":input[name='repeatEndDate']").val()}));
			html.push("<spring:message code="글:일정:반복"/>");
		}
		
		$comment.html(html.join(",&nbsp;"));
	} else {
		$comment.html("");
	}
};
/**
 * 스트링 -> 날짜
 */
doStringToDate = function(str) {
	var year = parseInt(str.substring(0, 4), 10);
	var month = parseInt(str.substring(4, 6), 10);
	var day = parseInt(str.substring(6, 8), 10);
	var hour = parseInt(str.substring(8, 10), 10);
	var minute = parseInt(str.substring(10, 12), 10);
	var second = parseInt(str.substring(12, 14), 10);
	return new Date(year, month - 1, day, hour, minute, second);
};
</script>
</head>

<body>

	<div style="display:none;">
		<form id="FormDetail" name="FormDetail" method="post" onsubmit="return false;">
			<input type="hidden" name="startDtime"    value="<c:out value="${detail.schedule.startDtime}"/>">
			<input type="hidden" name="endDtime"      value="<c:out value="${detail.schedule.endDtime}"/>">
			<input type="hidden" name="repeatYn"      value="<c:out value="${detail.schedule.repeatYn}"/>">
			<input type="hidden" name="repeatCycle"   value="<c:out value="${detail.schedule.repeatCycle}"/>">
			<input type="hidden" name="repeatTypeCd"  value="<c:out value="${detail.schedule.repeatTypeCd}"/>">
			<input type="hidden" name="repeatWeek"    value="<c:out value="${detail.schedule.repeatWeek}"/>">
			<input type="hidden" name="repeatEndDate" value="<aof:date datetime="${detail.schedule.repeatEndDate}"/>">
			<input type="hidden" name="unlimitedYn"   value="<c:out value="${fn:startsWith(detail.schedule.repeatEndDate, '9999') ? 'Y' : ''}"/>">
		</form>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:일정:일자"/></th>
			<td>
				<aof:date datetime="${detail.schedule.startDtime}" pattern="${aoffn:config('format.datetime')}"/>
				~
				<aof:date datetime="${detail.schedule.endDtime}" pattern="${aoffn:config('format.datetime')}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:일정:제목"/></th>
			<td><c:out value="${detail.schedule.scheduleTitle}"/></td>
		</tr>
		<c:if test="${detail.schedule.repeatYn eq 'Y'}">
			<tr>
				<th><spring:message code="글:일정:반복"/></th>
				<td><div id="commentRepeatType"></div></td>
			</tr>
		</c:if>
	</tbody>
	</table>

</body>
</html>