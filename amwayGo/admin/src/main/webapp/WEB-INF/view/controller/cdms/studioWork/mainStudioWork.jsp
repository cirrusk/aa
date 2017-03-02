<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_STUDIO_STATUS_TYPE_CANCEL"   value="${aoffn:code('CD.STUDIO_STATUS_TYPE.CANCEL')}"/>
<c:set var="CD_STUDIO_STATUS_TYPE_END"      value="${aoffn:code('CD.STUDIO_STATUS_TYPE.END')}"/>
<c:set var="CD_STUDIO_STATUS_TYPE_PUNCTURE" value="${aoffn:code('CD.STUDIO_STATUS_TYPE.PUNCTURE')}"/>

<c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdate')}"/></c:set>
<aof:code type="set" codeGroup="CDMS_SHOOTING" var="cdmsShooting"/>
<html>
<head>
<title></title>
<c:import url="/WEB-INF/view/include/calendar.jsp"/>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_STUDIO_STATUS_TYPE_END = "<c:out value="${CD_STUDIO_STATUS_TYPE_END}"/>";
var CD_STUDIO_STATUS_TYPE_PUNCTURE = "<c:out value="${CD_STUDIO_STATUS_TYPE_PUNCTURE}"/>";

var forCreate = null;
var forEdit = null;
var forDetail = null;
var forListdata = null;
var forCalendar = null;
var $calendar = null;
var ssMemberSeq = "<c:out value="${ssMemberSeq}"/>";
var today = "<c:out value="${appToday}"/>";
var mapWeekClass = {
	0 : "fc-sun", 1 : "fc-mon", 2 : "fc-tue", 3 : "fc-wed", 4 : "fc-thu", 5 : "fc-fri", 6 : "fc-sat"	
};
var mapShootingCd = {};
<c:forEach var="row" items="${cdmsShooting}" varStatus="i">
mapShootingCd['<c:out value="${row.code}"/>'] = "<c:out value="${row.codeName}"/>";
</c:forEach>

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doCalendar();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forCalendar = $.action("ajax");
	forCalendar.config.formId = "FormSrchCalendar";
	forCalendar.config.url    = "<c:url value="/cdms/studio/work/calendar/ajax.do"/>";
	forCalendar.config.type   = "html";
	forCalendar.config.containerId = "calendar"; 
	forCalendar.config.fn.complete = function(action, data) {};

	forListdata = $.action("ajax");
	forListdata.config.formId = "FormSrchWork";
	forListdata.config.url    = "<c:url value="/cdms/studio/work/list/json.do"/>";
	forListdata.config.type   = "json";
	forListdata.config.containerId = "containerWork"; 
	forListdata.config.fn.complete = function(action, data) {
		if (data != null) {
			var workEvents = [];
			for (var index in data.listStudioWork) {
				var work = data.listStudioWork[index];
				var startDate = doStringToDate(work.studioWork.startDtime); 
				var endDate = doStringToDate(work.studioWork.endDtime);
				var color = "#3DB7CC";
				if(work.studioWork.studioStatusTypeCd == CD_STUDIO_STATUS_TYPE_END){
					color = "#4374D9";
				} else if (work.studioWork.studioStatusTypeCd == CD_STUDIO_STATUS_TYPE_PUNCTURE) {
					color = "#FF007F";
				}
				
				if (work.studioWork.cancelDtime == null || work.studioWork.cancelDtime == "") {
					workEvents.push({
						id : "work-" + work.studioWork.workSeq,
						workSeq : work.studioWork.workSeq, // 작업 일련번호
						memberSeq : work.studioWork.regMemberSeq, // 등록자
						title : mapShootingCd[work.studioWork.shootingCd] + "-" + work.regMember.memberName,
						start : startDate,
						end : endDate,
						backgroundColor : color,
						textColor : "#000000",
						allDay : false,
						editable : false
					});
				} else { // 취소작업
					
				}
			}
			doAddWork(workEvents);
		}
	};

	forCreate = $.action("layer");
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/cdms/studio/work/create/popup.do"/>";
	forCreate.config.options.width  = 700;
	forCreate.config.options.height = 450;
	forCreate.config.options.title  = "<spring:message code="글:CDMS:스튜디오예약"/>";

	forEdit = $.action("layer");
	forEdit.config.formId = "FormEdit";
	forEdit.config.url    = "<c:url value="/cdms/studio/work/edit/popup.do"/>";
	forEdit.config.options.width  = 700;
	forEdit.config.options.height = 450;
	forEdit.config.options.title  = "<spring:message code="글:CDMS:스튜디오예약"/>";
	
	forDetail = $.action("layer");
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/studio/work/detail/popup.do"/>";
	forDetail.config.options.width  = 700;
	forDetail.config.options.height = 450;
	forDetail.config.options.title  = "<spring:message code="글:CDMS:스튜디오예약"/>";
	
};
/**
 * 달력 가져오기
 */
doCalendar = function() {
	forCalendar.run();
};
/**
 * 작업 목록 가져오기
 */
doListdata = function() {
	if ($calendar != null) {
		var viewDate = UI.calendar.get($calendar, "getView");
		var form = UT.getById(forListdata.config.formId);
		form.elements["srchStudioSeq"].value = jQuery("#" + forCalendar.config.formId).find(":input[name='studioSeq']").val();
		form.elements["srchStartDate"].value = doDateToStringShort(viewDate.start) + "000000"; 
		form.elements["srchEndDate"].value = doDateToStringShort(new Date(viewDate.end.getTime() - 1)) + "235959"; 
		UI.calendar.removeEvent($calendar);
		forListdata.run();
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
 * 보기 형식 변경
 */
doChangeViewType = function(element) {
	var form = UT.getById(forCalendar.config.formId);
	var prevViewType = form.elements["prevViewType"].value;
	if (prevViewType != element.value) {
		form.elements["prevViewType"].value = element.value;
		doCalendar();
	}
};
/**
 * 달력 생성
 */
doCreateCalendar = function(viewName, params) {
	var weekDay = typeof params.weekDay === "string" ? params.weekDay.split(",") : []; // 가용 요일
	var charge = typeof params.charge === "string" ? params.charge.split(",") : []; // 스튜디오 담당자
	var options = {
		header: {
			left: "",
			center: "prev, title, next",
			right: "" 
		},
		contentHeight : 700,
		selectable : true,
		disableResizing : false,
		allDaySlot : false,
		select: function(startDate, endDate, allDay, jsEvent, view) {
			var possible = false;
			if ($.inArray(ssMemberSeq, charge) > -1) { // 스튜디오 담당자이면 
				possible = true;
			} else { // 스튜디오 담당자가 아니면
				var day = startDate.getDay();
				if ($.inArray(String(day), weekDay) > -1) { // 가용 요일 이면
					possible = true;	
				}
			}
			
			var workDate = doDateToStringShort(startDate);
			var workTime = doDateToTimeString(startDate);
			if (workDate < today) {
				possible = false;
			}
			if (possible == true) {
				doCreate({
					workDate : workDate,
					workTime : workTime,
					studioSeq : jQuery("#" + forCalendar.config.formId).find(":input[name='studioSeq']").val()
				});
			}
		},
		eventClick : function (event, jsEvent, view) {
			var type = "";
			if (ssMemberSeq == event.memberSeq) {
				var startDate = doDateToStringShort(event.start);
				if (startDate < today) {
					type = "detail";
				} else {
					type = "edit";
				}
				
			} else {
				if ($.inArray(ssMemberSeq, charge) > -1) { // 스튜디오 담당자이면 
					type = "detail";
				} else { // 스튜디오 담당자가 아니면
					type = "";
				}				
			}
			
			if (type == "detail") { // 상세보기
				doDetail({
					workSeq : event.workSeq
				});
				
			} else if (type == "edit") { // 수정
				doEdit({
					workSeq : event.workSeq
				});
			}
		},
		viewDisplay: function(view) {
			for (var i = 0; i < 7; i++) {
				if ($.inArray(String(i), weekDay) == -1) {
					jQuery("." + mapWeekClass[i]).addClass("cdms-studio-disabled");
				}
			}
			if ($calendar != null) {
				doListdata();
			}
	    }
	};
	if (viewName == "week") {
		options.defaultView = "agendaWeek";
		if (typeof params.minTime === "string" && params.minTime != "") {
			options.minTime = params.minTime;
		}
		if (typeof params.maxTime === "string" && params.maxTime != "") {
			options.maxTime = params.maxTime;
		}
	} else if (viewName == "month") {
		options.defaultView = "month";
		options.weekMode = "variable";
		
	}
	$calendar = null;
	$calendar = UI.calendar.create("calendar", options);

	doListdata();
};
/**
 * 날짜 -> 스트링 (yyyyMMdd)
 */
doDateToStringShort = function(date) {
	var str = [];
	str.push(date.getFullYear());
	var month = date.getMonth() + 1;
	str.push(month < 10 ? "0" + month : month);
	var day = date.getDate();
	str.push(day < 10 ? "0" + day : day);
	return str.join("");
};
/**
 * 날짜 -> 스트링 (HHmm)
 */
doDateToTimeString = function(date) {
	var str = [];
	var hours = date.getHours();
	var minutes = date.getMinutes();
	str.push(hours < 10 ? "0" + hours : hours);
	str.push(minutes < 10 ? "0" + minutes : minutes);
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
 * 작업일정 추가
 */
doAddWork = function(arrayData) {
	if ($calendar != null && arrayData != null) {
		UI.calendar.addEvent($calendar, arrayData);
	}
};
</script>
<style type="text/css">
.studio-type-color-0  {background-color:#3DB7CC !important; color:#ffffff !important;}
.studio-type-color-1  {background-color:#4374D9 !important; color:#ffffff !important;}
.studio-type-color-2  {background-color:#FF007F !important; color:#ffffff !important;}
.studio-type-color-3  {background-color:#ffffff !important; color:#000000 !important; border:1px solid #777;}
.studio-point {display:inline-block; *display:inline; *zoom:1; width:13px; height:13px; margin-left:5px; vertical-align:middle; border-radius:7px; -moz-border-radius:7px; -webkit-border-radius:7px; }
</style>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>

	<div style="display:none;">
		<form name="FormSrchWork" id="FormSrchWork" method="post" onsubmit="return false;">
			<input type="hidden" name="srchStudioSeq"/>
			<input type="hidden" name="srchStartDate"/>
			<input type="hidden" name="srchEndDate"/>
		</form>
		<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
			<input type="hidden" name="studioSeq"/>
			<input type="hidden" name="workDate"/>
			<input type="hidden" name="workTime"/>
			<input type="hidden" name="callback" value="doCalendar"/>
		</form>
		<form name="FormEdit" id="FormEdit" method="post" onsubmit="return false;">
			<input type="hidden" name="workSeq"/>
			<input type="hidden" name="callback" value="doCalendar"/>
		</form>
		<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
			<input type="hidden" name="workSeq"/>
		</form>
	</div>

	<form name="FormSrchCalendar" id="FormSrchCalendar" method="post" onsubmit="return false;">
		<input type="hidden" name="prevViewType" value="week">
		<div class="lybox-tbl">
			<h4 class="title">
				<spring:message code="글:CDMS:스튜디오선택" />
				<select name="studioSeq" onchange="doCalendar()" style="width: 100px">
					<c:forEach var="row" items="${listStudio}" varStatus="i">
						<option value="<c:out value="${row.studio.studioSeq}"/>"><c:out value="${row.studio.studioName}"/></option>
					</c:forEach>
				</select>
			</h4>
			<div class="right">
				<input type="radio" name="viewType" value="week" checked="checked" onclick="doChangeViewType(this)"><label><spring:message code="글:CDMS:주차별보기" /></label>
				<input type="radio" name="viewType" value="month" onclick="doChangeViewType(this)"><label><spring:message code="글:CDMS:월별보기" /></label>
			</div>
		</div>
	</form>
	<aof:code type="set" codeGroup="STUDIO_STATUS_TYPE" var="studioStatus" except="${CD_STUDIO_STATUS_TYPE_CANCEL}" />
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<div class="lybox-btn-r">
			<c:forEach var="row" items="${studioStatus}" varStatus="i">
				<span class="studio-point studio-type-color-<c:out value="${i.index}"/>">&nbsp;</span>
				<span><c:out value="${row.codeName}"/></span>
			</c:forEach>
		</div>
		
		</div>
	</div>

	<div id="calendar" class="mt10"></div>

</body>
</html>