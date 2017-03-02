<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_YEAR"  value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.YEAR')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_MONTH" value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.MONTH')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_WEEK"  value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.WEEK')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_DAY"   value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.DAY')}"/>

<html decorator="default">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/calendar.jsp"/>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_SCHEDULE_REPEAT_TYPE_YEAR = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_YEAR}"/>";
var CD_SCHEDULE_REPEAT_TYPE_MONTH = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_MONTH}"/>";
var CD_SCHEDULE_REPEAT_TYPE_WEEK = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_WEEK}"/>";
var CD_SCHEDULE_REPEAT_TYPE_DAY = "<c:out value="${CD_SCHEDULE_REPEAT_TYPE_DAY}"/>";

var forCreate = null;
var forEdit = null;
var forDetail = null;
var forUpdate = null;
var forListdata = null;
var $calendar = null;
var referenceType = "<c:out value="${referenceType}"/>";
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// 달력 그리기
	doCreateCalendar();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	forCreate = $.action("layer");
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/schedule/${referenceType}/create.do"/>";
	forCreate.config.options.width  = 600;
	forCreate.config.options.height = 360;
	forCreate.config.options.title  = "<spring:message code="글:일정:일정관리"/>&nbsp;<spring:message code="글:신규등록" />";

	forEdit = $.action("layer");
	forEdit.config.formId = "FormEdit";
	forEdit.config.url    = "<c:url value="/schedule/${referenceType}/edit.do"/>";
	forEdit.config.options.width  = 600;
	forEdit.config.options.height = 360;
	forEdit.config.options.title  = "<spring:message code="글:일정:일정관리"/>&nbsp;<spring:message code="글:수정" />";

	forDetail = $.action("layer");
	forDetail.config.formId = "FormEdit";
	forDetail.config.url    = "<c:url value="/schedule/detail.do"/>";
	forDetail.config.options.width  = 600;
	forDetail.config.options.height = 360;
	forDetail.config.options.title  = "<spring:message code="글:일정:일정관리"/>";

	forListdata = $.action("ajax");
	forListdata.config.formId = "FormList";
	forListdata.config.type   = "json";
	forListdata.config.url    = "<c:url value="/schedule/${referenceType}/list.do"/>";
	forListdata.config.fn.complete = function(action, data) {
		if (data != null) {
			var arrayData = [];
			for (var index in data.listSystemNormal) {
				arrayData.push(data.listSystemNormal[index].schedule);
			}
			doAddSchedule(arrayData, "system-normal", referenceType == "personal" ? false : true); // 개인일정관리인 경우 시스템 일정은 이동시킬 수 없다
			
			arrayData = [];
			for (var index in data.listSystemRepeat) {
				arrayData.push(data.listSystemRepeat[index].schedule);
			}
			doAddSchedule(arrayData, "system-repeat");

			<c:if test="${referenceType eq 'personal'}">
			arrayData = [];
			for (var index in data.listPersonalNormal) {
				arrayData.push(data.listPersonalNormal[index].schedule);
			}
			doAddSchedule(arrayData, "personal-normal", true);
			
			arrayData = [];
			for (var index in data.listPersonalRepeat) {
				arrayData.push(data.listPersonalRepeat[index].schedule);
			}
			doAddSchedule(arrayData, "personal-repeat");
			</c:if>
		}
	};
	
	forUpdate = $.action("ajax");
	forUpdate.config.formId = "FormUpdate";
	forUpdate.config.type   = "json";
	forUpdate.config.url             = "<c:url value="/schedule/date/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete = function(action, data) {
	}
};
/**
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	UT.getById(forCreate.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	forCreate.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	UT.getById(forEdit.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	forEdit.run();
};
/**
 * 상세화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};
/**
 * 일정 목록
 */
doListdata = function(yearMonth) {
	var loading = false;
	if (typeof yearMonth === "string") { 
		var form = UT.getById(forListdata.config.formId);
		var srchYearMonth = form.elements["srchYearMonth"].value;
		if (srchYearMonth != yearMonth) {
			form.elements["srchYearMonth"].value = yearMonth;
			loading = true;
		}
	} else { // refresh
		loading = true;
	}
	if (loading == true) {
		UI.calendar.removeEvent($calendar);
		forListdata.run();
	}
};
/**
 * 일정 일자 수정
 */
doUpdate = function(mapPKs) {
	UT.getById(forUpdate.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forUpdate.config.formId);
	forUpdate.run();
};
/**
 * 달력 생성
 */
doCreateCalendar = function() {
	$calendar = UI.calendar.create("calendar", {
		height : 600,
		selectable : true,
		defaultView : "month",
		disableResizing : false,
		select: function(startDate, endDate, allDay, jsEvent, view) {
			doCreate({
				startDtime : doDateToString(startDate),
				endDtime : doDateToString(endDate, allDay)
			});
		},
		eventDrop : function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
			var id = event.id.split("-");
			doUpdate({
				scheduleSeq : id[1],
				startDtime : doDateToString(event.start),
				endDtime : doDateToString(event.end, event.allDay)
			});
		},
		eventResize : function(event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) {
			var id = event.id.split("-");
			doUpdate({
				scheduleSeq : id[1],
				startDtime : doDateToString(event.start),
				endDtime : doDateToString(event.end, event.allDay)
			});
		},
		eventClick : function (event, jsEvent, view) {
			var id = event.id.split("-");
			if (referenceType == "personal") {
				if (event.className == "schedule-personal-normal" || event.className == "schedule-personal-repeat") {
					doEdit({
						scheduleSeq : id[1]
					});
				} else {
					doDetail({
						scheduleSeq : id[1]
					});
				}
				
			} else { // 시스템
				doEdit({
					scheduleSeq : id[1]
				});
			}
			
		},
		viewDisplay: function(view) {
			if ($calendar != null) {
				var viewDate = UI.calendar.get($calendar, "getDate");
				var str = [];
				str.push(viewDate.getFullYear());
				var month = viewDate.getMonth() + 1;
				str.push(month < 10 ? "0" + month : month);
				
				// 일정데이터.
				doListdata(str.join(""));
			}
	    }
	});

	// 일정데이터.
	doListdata();
};
/**
 * 날짜 -> 스트링
 */
doDateToString = function(date, endOfAllday) {
	var str = [];
	str.push(date.getFullYear());
	var month = date.getMonth() + 1;
	str.push(month < 10 ? "0" + month : month);
	var day = date.getDate();
	str.push(day < 10 ? "0" + day : day);
	if (endOfAllday == true) {
		str.push("235959");		
	} else {
		var hour = date.getHours();
		str.push(hour < 10 ? "0" + hour : hour);
		var minute = date.getMinutes();
		str.push(minute < 10 ? "0" + minute : minute);
		var second = date.getSeconds();
		str.push(second < 10 ? "0" + second : second);
	}
	return str.join("");
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
/**
 * 종일일정인지 검사 
 */
isAllday = function(start, end) {
	return end.getTime() - start.getTime() >= 86399000 ? true : false; // 23시간 59분 59초
};
/**
 * 일정데이터 달력에 넣기
 */
doAddSchedule = function(arrayData, scheduleType, editable) {
	if ($calendar != null && arrayData != null) {
		var events = [];
		if (scheduleType == "system-normal" || scheduleType == "personal-normal" || scheduleType == "course-normal") {
			for (var index in arrayData) {
				var schedule = arrayData[index];
				var startDate = doStringToDate(schedule.startDtime); 
				var endDate = doStringToDate(schedule.endDtime);
				events.push({
					id : "schedule-" + schedule.scheduleSeq,
					title : schedule.scheduleTitle,
					start : startDate,
					end : endDate,
					backgroundColor : scheduleColors[schedule.scheduleTypeCd].bgcolor,
					textColor : scheduleColors[schedule.scheduleTypeCd].text,
					allDay : isAllday(startDate, endDate),
					className : "schedule-" + scheduleType,
					editable : editable
				});
			}
		} else if (scheduleType == "system-repeat" || scheduleType == "personal-repeat" || scheduleType == "course-repeat") {
			var month = doGetScheduleDate();
			for (var index in arrayData) {
				var schedule = arrayData[index];
				var startDate = doStringToDate(schedule.startDtime); 
				var endDate = doStringToDate(schedule.endDtime);
				var repeatEndDate = doStringToDate(schedule.repeatEndDate);
				
				var cycleStartDate = new Date(startDate.getTime());
				var cycleEndDate = new Date(endDate.getTime());
	
				while (cycleStartDate.getTime() <= month.next.getTime() && cycleStartDate.getTime() <= repeatEndDate.getTime()) {
					if (schedule.repeatTypeCd == CD_SCHEDULE_REPEAT_TYPE_WEEK) {
						var week = schedule.repeatWeek.split(",");
						for (var i = 0; i < 7; i++) {
							var weekStartDate = new Date(cycleStartDate.getTime());
							var weekEndDate = new Date(cycleStartDate.getTime());
							weekEndDate.setHours(cycleEndDate.getHours());
							weekEndDate.setMinutes(cycleEndDate.getMinutes());
							weekStartDate.setDate(weekStartDate.getDate() + i);
							weekEndDate.setDate(weekEndDate.getDate() + i);
							if (jQuery.inArray("" + weekStartDate.getDay(), week) > -1 && weekStartDate.getTime() <= repeatEndDate.getTime()) {
								if (isInTerms(weekStartDate, month.prev, month.next) || isInTerms(weekEndDate, month.prev, month.next)) {
									events.push({
										id : "schedule-" + schedule.scheduleSeq,
										title : schedule.scheduleTitle,
										start : new Date(weekStartDate.getTime()),
										end : new Date(weekEndDate.getTime()),
										backgroundColor : scheduleColors[schedule.scheduleTypeCd].bgcolor,
										textColor : scheduleColors[schedule.scheduleTypeCd].text,
										allDay : isAllday(weekStartDate, weekEndDate),
										className : "schedule-" + scheduleType,
										editable : false // 반복일정은 이동 시킬수 없다
									});
								}
							}
						}
						cycleStartDate.setDate(cycleStartDate.getDate() + schedule.repeatCycle * 7);
						cycleEndDate.setDate(cycleEndDate.getDate() + schedule.repeatCycle * 7);
					} else {
						if (isInTerms(cycleStartDate, month.prev, month.next) || isInTerms(cycleEndDate, month.prev, month.next)) {
							events.push({
								id : "schedule-" + schedule.scheduleSeq,
								title : schedule.scheduleTitle,
								start : new Date(cycleStartDate.getTime()),
								end : new Date(cycleEndDate.getTime()),
								backgroundColor : scheduleColors[schedule.scheduleTypeCd].bgcolor,
								textColor : scheduleColors[schedule.scheduleTypeCd].text,
								allDay : isAllday(cycleStartDate, cycleEndDate),
								className : "schedule-" + scheduleType,
								editable : false // 반복일정은 이동 시킬수 없다
							});
						}
						switch(schedule.repeatTypeCd) {
						case CD_SCHEDULE_REPEAT_TYPE_YEAR:
							cycleStartDate.setFullYear(cycleStartDate.getFullYear() + schedule.repeatCycle);
							cycleEndDate.setFullYear(cycleEndDate.getFullYear() + schedule.repeatCycle);
							break;
						case CD_SCHEDULE_REPEAT_TYPE_MONTH:
							cycleStartDate.setMonth(cycleStartDate.getMonth() + schedule.repeatCycle);
							cycleEndDate.setMonth(cycleEndDate.getMonth() + schedule.repeatCycle);
							break;
						case CD_SCHEDULE_REPEAT_TYPE_DAY:
							cycleStartDate.setDate(cycleStartDate.getDate() + schedule.repeatCycle);
							cycleEndDate.setDate(cycleEndDate.getDate() + schedule.repeatCycle);
							break;
						}
					}
				}
			}
		}
		UI.calendar.addEvent($calendar, events);
	}
};
/**
 * 달력에 표시할 시작일과 종료일을 계산한다.(기준월의 앞뒤를 포함한 3달)
 */
doGetScheduleDate = function() {
	var form = UT.getById(forListdata.config.formId);
	var date = doStringToDate(form.elements["srchYearMonth"].value + "01000000");
	var prevMonth = new Date(date.getTime());
	prevMonth.setMonth(prevMonth.getMonth() - 1); // 이전달 첫일
	var nextMonth = new Date(date.getTime());
	nextMonth.setMonth(nextMonth.getMonth() + 2);
	nextMonth.setDate(nextMonth.getDate() - 1); // 다음달 말일
	return {
		prev : prevMonth, 
		next : nextMonth 
	};
};
/**
 * 날짜 범위에 있는지
 */
isInTerms = function(target, start, end) {
	return (start.getTime() <= target.getTime() && target.getTime() <= end.getTime()) ? true : false;
};
</script>
</head>
<body>
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"></c:param>
	</c:import>

	<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
		<input type="hidden" name="startDtime" />
		<input type="hidden" name="endDtime" />
		<input type="hidden" name="allDayYn" />
		<input type="hidden" name="callback" value="doListdata"/>
	</form>

	<form name="FormEdit" id="FormEdit" method="post" onsubmit="return false;">
		<input type="hidden" name="scheduleSeq" />
		<input type="hidden" name="callback" value="doListdata"/>
	</form>

	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="srchYearMonth" value="<c:out value="${srchYearMonth}"/>"/>
	</form>

	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="scheduleSeq" />
		<input type="hidden" name="startDtime" />
		<input type="hidden" name="endDtime" />
	</form>

	<div id="calendar"></div>
	
</body>
</html>