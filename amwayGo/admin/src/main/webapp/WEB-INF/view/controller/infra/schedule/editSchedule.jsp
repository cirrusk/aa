<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_YEAR"  value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.YEAR')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_MONTH" value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.MONTH')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_WEEK"  value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.WEEK')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_DAY"   value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.DAY')}"/>
<c:set var="CD_SCHEDULE_TYPE_05"           value="${aoffn:code('CD.SCHEDULE_TYPE.05')}"/>

<html decorator="popup">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/calendar.jsp"/>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_SCHEDULE_REPEAT_TYPE_YEAR = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_YEAR}"/>";
var CD_SCHEDULE_REPEAT_TYPE_MONTH = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_MONTH}"/>";
var CD_SCHEDULE_REPEAT_TYPE_WEEK = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_WEEK}"/>";
var CD_SCHEDULE_REPEAT_TYPE_DAY = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_DAY}"/>";

var forUpdate = null;
var forDelete = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.datepicker("#pickerStart");
	UI.datepicker("#pickerEnd");
	UI.datepicker("#repeatEndDate");
	
	doSetDatetime();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/schedule/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before = function() {
		var $form = jQuery("#" + forUpdate.config.formId);
		var $unlimitedYn = $form.find(":input[name='unlimitedYn']").filter(":checked"); 
		if ($unlimitedYn.val() == "Y") {
			$form.find(":input[name='repeatEndDate']").val("<aof:date datetime="99991231"/>").attr("disabled", false);
		}
		var $repeatTypeCd = $form.find(":input[name='repeatTypeCd']").filter(":checked");
		if ($repeatTypeCd.val() != CD_SCHEDULE_REPEAT_TYPE_WEEK) {
			$form.find(":input[name='repeatWeek']").attr("checked", false);
		}
		return true;
	};
	forUpdate.config.fn.complete = function() {
		doCallback();
		doClose();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/schedule/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doCallback();
		doClose();
	};
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:제목"/>",
		name : "scheduleTitle",
		data : ["!null"],
		check : {
			maxlength : 30
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:시작일시"/>",
		name : "startDtime",
		data : ["!null"],
		check : {
			fixlength : 14
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:종료일시"/>",
		name : "endDtime",
		data : ["!null"],
		check : {
			fixlength : 14
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:시작일시"/>",
		name : "startDtime",
		check : {
			lt : {name : "endDtime", title : "<spring:message code="필드:일정:종료일시"/>"}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:일정구분"/>",
		name : "displayColor",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:반복여부"/>",
		name : "repeatYn",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:반복구분"/>",
		name : "repeatTypeCd",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forUpdate.config.formId);
			if ($form.find(":input[name='repeatYn']").filter(":checked").val() == "Y") {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:반복요일"/>",
		name : "repeatWeek",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forUpdate.config.formId);
			if ($form.find(":input[name='repeatTypeCd']").filter(":checked").val() == CD_SCHEDULE_REPEAT_TYPE_WEEK) {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:반복종료일"/>",
		name : "repeatEndDate",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forUpdate.config.formId);
			if ($form.find(":input[name='repeatYn']").filter(":checked").val() == "Y" && $form.find(":input[name='unlimitedYn']").filter(":checked").val() != "Y") {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:일정:반복종료일"/>",
		name : "repeatEndDate",
		check : {
			gt : {name : "pickerEnd", title : "<spring:message code="필드:일정:종료일시"/>"}
		}
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 콜백함수 호출
 */
doCallback = function() {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this);
	}
};
/**
 * 취소
 */
doClose = function() {
	$layer.dialog("close");
};
/**
 * 일자시간 세팅
 */
doSetDatetime = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var $startDtime = $form.find(":input[name='startDtime']");
	var $endDtime   = $form.find(":input[name='endDtime']");
	
	var pickerStart = $form.find(":input[name='pickerStart']").val().replace(/[-\.\/\s]/g,"");
	var pickerEnd   = $form.find(":input[name='pickerEnd']").val().replace(/[-\.\/\s]/g,"");
	var timeStart   = $form.find(":input[name='timeStart']").val();
	var timeEnd     = $form.find(":input[name='timeEnd']").val();
	$startDtime.val(pickerStart + timeStart + "00");
	$endDtime.val(pickerEnd + timeEnd + (timeEnd == "2359" ? "59" : "00"));
	
	if ($startDtime.val() >= $endDtime.val()) {
		$startDtime.parent().addClass("warning");
	} else {
		$startDtime.parent().removeClass("warning");
	}
	
	doSetRepeatType();
};
/**
 * 반복구분 설정
 */
doSetRepeatType = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var $repeatType = $form.find(":input[name='repeatTypeCd']");
	$repeatType.hide().next("label").hide();

	var day = doGetDays();
	if (day < 1) { // 일 반복
		$repeatType.filter("[value='" + CD_SCHEDULE_REPEAT_TYPE_DAY + "']").show().next("label").show();
	}
	if (day <= 7) { // 주(요일) 반복
		$repeatType.filter("[value='" + CD_SCHEDULE_REPEAT_TYPE_WEEK + "']").show().next("label").show();
	} 
	if (day <= 30) { // 월 반복
		$repeatType.filter("[value='" + CD_SCHEDULE_REPEAT_TYPE_MONTH + "']").show().next("label").show();
	}
	// 년반복
	$repeatType.filter("[value='" + CD_SCHEDULE_REPEAT_TYPE_YEAR + "']").show().next("label").show();
	doChangeRepeatYn();
};
/**
 * 반복여부 변경
 */
doChangeRepeatYn = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var value = $form.find(":input[name='repeatYn']").filter(":checked").val();
	if (value == "Y") {
		jQuery(".repeat").attr("disabled", false).removeClass("disabled");
		jQuery(".repeat").find(":input").attr("disabled", false).removeClass("disabled");
		var unlimitedYn = $form.find(":input[name='unlimitedYn']").filter(":checked").val();
		if (unlimitedYn == "Y") {
			jQuery("#repeatEndDate").attr("disabled", true).addClass("disabled");
		}
	} else {
		jQuery(".repeat").attr("disabled", true).addClass("disabled");
		jQuery(".repeat").find(":input").attr("disabled", true).addClass("disabled");
	}
	doChangeRepeatType();
};
/**
 * 반복구분 변경
 */
doChangeRepeatType = function() {
	var $comment = jQuery("#commentRepeatType");
	jQuery("#week").hide();
	
	var $form = jQuery("#" + forUpdate.config.formId);
	var repeatYn = $form.find(":input[name='repeatYn']").filter(":checked").val();
	if (repeatYn == "Y") {
		var repeatType = $form.find(":input[name='repeatTypeCd']").filter(":checked").val();
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
		case CD_SCHEDULE_REPEAT_TYPE_YEAR:
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X년마다"/>", {0:cycle}) : "<spring:message code="글:일정:매년"/>");
			html.push(sMonth + sDate + sHour + sMinute + "~" + eMonth + eDate + eHour + eMinute);
			break;			
		case CD_SCHEDULE_REPEAT_TYPE_MONTH:
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X개월마다"/>", {0:cycle}) : "<spring:message code="글:일정:매월"/>");
			html.push(sDate + sHour + sMinute + "~" + eDate + eHour + eMinute);
			break;
		case CD_SCHEDULE_REPEAT_TYPE_WEEK:
			jQuery("#week").show();
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X주마다"/>", {0:cycle}) : "<spring:message code="글:일정:매주"/>");
			
			var $week = $form.find(":input[name='repeatWeek']");
			var w = [];
			$week.filter(":checked").each(function() {
				var $this = jQuery(this);
				w.push($this.next("label").text());
			});
			html.push(w.join(","));
			html.push(sHour + sMinute + "~" + eHour + eMinute);
			break;
		case CD_SCHEDULE_REPEAT_TYPE_DAY:
			html.push(cycle > 1 ? UT.formatString("<spring:message code="글:일정:X일마다"/>", {0:cycle}) : "<spring:message code="글:일정:매일"/>");
			html.push(sHour + sMinute + "~" + eHour + eMinute);
			break;
		}

		if ($form.find(":input[name='unlimitedYn']").filter(":checked").val() == "Y") {
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
 * 반복종료일
 */
doChangeRepeatEndDate = function(element) {
	if (element.checked == true) {
		jQuery(element).siblings(":input").attr("disabled", true).addClass("disabled").val("");
	} else {
		jQuery(element).siblings(":input").attr("disabled", false).removeClass("disabled").val("");
	}
	jQuery(element).siblings("label").removeClass("disabled");
};
/**
 * 일자수 계산.
 */
doGetDays = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var $startDtime = $form.find(":input[name='startDtime']");
	var $endDtime   = $form.find(":input[name='endDtime']");

	var sDate = doStringToDate($startDtime.val());
	var eDate = doStringToDate($endDtime.val());
	
	var term = eDate.getTime() - sDate.getTime();
	var oneDay = 86400000;
	var day = parseInt(term / oneDay, 10);
	if (day > 0 && term % oneDay > 0) {
		day += 1;
	}
	return day;
};
/**
 * 기간내의 요일
 */
doGetDayofweek = function(start, end) {
	var sDate = doStringToDate(start.replace(/[-\.\/\s]/g,"") + "000000");
	var eDate = doStringToDate(end.replace(/[-\.\/\s]/g,"") + "000000");
	var days = [];
	if (sDate.getDay() < eDate.getDay()) {
		for (var i = sDate.getDay(); i <= eDate.getDay(); i++) {
			days.push(i);
		}
	} else if (sDate.getDay() > eDate.getDay()) {
		for (var i = sDate.getDay(); i <= 6; i++) {
			days.push(i);
		}
		for (var i = 0; i <= eDate.getDay(); i++) {
			days.push(i);
		}
	} else {
		days.push(sDate.getDay());
	}
	return days;
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
<style type="text/css">
.disabled, .disabled th, .disabled input, .disabled label {color:#cdcdcd !important; border-color:#cdcdcd !important; }
.color-item {width:13px;height:13px;display:inline-block; vertical-align:middle;}
.warning {background-color:rgb(252, 248, 227);}
.warning input, .warning select{border-color:#ff0000;}
</style>
</head>

<body>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="scheduleSeq" value="<c:out value="${detail.schedule.scheduleSeq}"/>">
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
			<td colspan="3">
				<input type="hidden" name="startDtime">
				<input type="hidden" name="endDtime">
				<input type="text" name="pickerStart" id="pickerStart" value="<aof:date datetime="${detail.schedule.startDtime}"/>" class="datepicker" style="width:80px;text-align:center;" readonly="readonly" onchange="doSetDatetime()">
				<select name="timeStart" onchange="doSetDatetime()" style="width:90px;">
					<c:set var="timeStart"><aof:date datetime="${detail.schedule.startDtime}" pattern="HHmm"/></c:set>
					<aof:code type="option" codeGroup="TIME" selected="${timeStart}" removeCodePrefix="true"/>
				</select>
				-
				<input type="text" name="pickerEnd" id="pickerEnd" value="<aof:date datetime="${detail.schedule.endDtime}"/>" class="datepicker" style="width:80px;text-align:center;" readonly="readonly" onchange="doSetDatetime()">
				<select name="timeEnd" onchange="doSetDatetime()" style="width:90px;">
					<c:set var="timeEnd"><aof:date datetime="${detail.schedule.endDtime}" pattern="HHmm"/></c:set>
					<aof:code type="option" codeGroup="TIME" selected="${timeEnd}" removeCodePrefix="true"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:일정:제목"/></th>
			<td colspan="3"><input type="text" name="scheduleTitle" value="<c:out value="${detail.schedule.scheduleTitle}"/>" style="width:90%;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:일정:일정구분"/></th>
			<td colspan="3">
				<c:choose>
					<c:when test="${referenceType eq 'system'}">
						<aof:code type="radio" codeGroup="SCHEDULE_TYPE" name="scheduleTypeCd" selected="${detail.schedule.scheduleTypeCd}" defaultSelected="${CD_SCHEDULE_TYPE_01}" except="${CD_SCHEDULE_TYPE_05}"/> <%-- 개인일정 제외 --%>
					</c:when>
					<c:otherwise>
						<input type="hidden" name="scheduleTypeCd" value="<c:out value="${CD_SCHEDULE_TYPE_05}"/>"> <%-- 개인일정 --%>
						<aof:code type="print" codeGroup="SCHEDULE_TYPE" selected="${CD_SCHEDULE_TYPE_05}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:일정:반복여부"/></td>
			<td><aof:code type="radio" codeGroup="YESNO" name="repeatYn" selected="${detail.schedule.repeatYn}" onclick="doChangeRepeatYn()" removeCodePrefix="true"/></td>
			<th class="repeat"><spring:message code="필드:일정:반복주기"/></td>
			<td class="repeat">
				<select name="repeatCycle" onchange="doChangeRepeatType()" style="width:50px;">
					<c:forEach var="row" begin="1" end="10">
						<option value="<c:out value="${row}"/>" <c:out value="${detail.schedule.repeatCycle eq row ? 'selected' : ''}"/>><c:out value="${row}"/></option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr class="repeat">
			<th><spring:message code="필드:일정:반복구분"/></td>
			<td colspan="3" style="position:relative;">
				<aof:code type="radio" codeGroup="SCHEDULE_REPEAT_TYPE" name="repeatTypeCd" selected="${detail.schedule.repeatTypeCd}" onclick="doChangeRepeatType()"/>

				<c:set var="week">0=<spring:message code="글:일정:일"/>,1=<spring:message code="글:일정:월"/>,2=<spring:message code="글:일정:화"/>,3=<spring:message code="글:일정:수"/>,4=<spring:message code="글:일정:목"/>,5=<spring:message code="글:일정:금"/>,6=<spring:message code="글:일정:토"/></c:set>
				<span style="position:absolute;right:0px;display:none;" id="week">
					<aof:code type="checkbox" codeGroup="${week}" name="repeatWeek" selected="${detail.schedule.repeatWeek}" onclick="doChangeRepeatType()"/>
				</span>
			</td>
		</tr>
		<tr class="repeat">
			<th><spring:message code="필드:일정:반복종료일"/></td>
			<td colspan="3">
				<c:set var="repeatDate"><aof:date datetime="${detail.schedule.repeatEndDate}"/></c:set>
				<input type="text" name="repeatEndDate" id="repeatEndDate" value="<c:out value="${fn:startsWith(repeatDate, '9999') ? '' : repeatDate}"/>" class="datepicker" style="width:80px;text-align:center;" readonly="readonly">
				<input type="checkbox" name="unlimitedYn" value="Y" onclick="doChangeRepeatEndDate(this)" <c:out value="${fn:startsWith(repeatDate, '9999') ? 'checked' : ''}"/>>
				<label><spring:message code="글:일정:무제한"/></label> 
				<div id="commentRepeatType" class="comment"></div>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="scheduleSeq" value="<c:out value="${detail.schedule.scheduleSeq}"/>">
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<c:choose>
					<c:when test="${referenceType eq 'personal'}">
						<c:if test="${ssMemberSeq eq detail.schedule.memberSeq}"> <%-- 개인일정 삭제 가능 --%>
							<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
						</c:if>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
					</c:otherwise>
				</c:choose>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<c:choose>
					<c:when test="${referenceType eq 'personal'}">
						<c:if test="${ssMemberSeq eq detail.schedule.memberSeq}"> <%-- 개인일정 수정 가능 --%>
							<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</c:otherwise>
				</c:choose>
			
			</c:if>
			<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>