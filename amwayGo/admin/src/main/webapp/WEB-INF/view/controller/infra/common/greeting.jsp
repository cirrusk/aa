<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_YEAR"  value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.YEAR')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_MONTH" value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.MONTH')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_WEEK"  value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.WEEK')}"/>
<c:set var="CD_SCHEDULE_REPEAT_TYPE_DAY"   value="${aoffn:code('CD.SCHEDULE_REPEAT_TYPE.DAY')}"/>
<c:forEach var="row" items="${appMenuList}">
    <c:choose>
	    <c:when test="${row.menu.url eq '/mypage/system/bbs/qna/list.do'}"> <%-- 마이페이지의 '시스템QnA' 메뉴를 찾는다 --%>
	        <c:set var="menuSystemQna" value="${row.menu}" scope="request"/>
	    </c:when>
	    <c:when test="${row.menu.url eq '/mypage/system/bbs/notice/list.do'}"> <%-- 마이페이지의 '시스템공지사항' 메뉴를 찾는다 --%>
	        <c:set var="menuSystemNotice" value="${row.menu}" scope="request"/>
	    </c:when>
	    <c:when test="${row.menu.url eq '/mypage/system/bbs/staff/list.do'}"> <%-- 마이페이지의 '교직원게시판' 메뉴를 찾는다 --%>
	        <c:set var="menuSystemStaff" value="${row.menu}" scope="request"/>
	    </c:when>
    </c:choose>
</c:forEach>

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

var menuIds = {
    "qna" : "<c:out value="${aoffn:encrypt(menuSystemQna.menuId)}"/>",
    "notice" : "<c:out value="${aoffn:encrypt(menuSystemNotice.menuId)}"/>",
    "staff" : "<c:out value="${aoffn:encrypt(menuSystemStaff.menuId)}"/>"
};
var forListdata = null;
var forMemberEdit = null;
var forPasswordEdit = null;
var forCreateReply = null;
var forMoveBoard = null;
var forDetail = null;
var forMoveSchedule = null;
var $calendar = null;
var referenceType = "<c:out value="${referenceType}"/>";
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] 달력 그리기
	//doCreateCalendar();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
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
		
	forMemberEdit = $.action();
	forMemberEdit.config.formId = "FormData";
	forMemberEdit.config.url    = "<c:url value="/mypage/member/edit.do"/>";
	
	forPasswordEdit = $.action();
	forPasswordEdit.config.formId = "FormData";
	forPasswordEdit.config.url    = "<c:url value="/mypage/member/password.do"/>";
	
	forCreateReply = $.action();
	forCreateReply.config.formId = "FormCreate";
	forCreateReply.config.url    = "<c:url value="/mypage/system/bbs/qna/create.do"/>";
	
	forMoveBoard = $.action();
	forMoveBoard.config.formId = "FormData";
	
	forDetail = $.action();
	forDetail.config.formId = "FormData";
	
	forMoveSchedule = $.action();
	forMoveSchedule.config.formId = "FormData";
	forMoveSchedule.config.url    = "<c:url value="/schedule/personal.do"/>";
	
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
 * 달력 생성
 */
doCreateCalendar = function() {
	$calendar = UI.calendar.create("calendar", {
		height : 600,
		selectable : true,
		defaultView : "month",
		disableResizing : false,
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

/*
 * 회원수정
 */
doMemberEdit = function() {
	forMemberEdit.run();
};

/*
 * 패스워드변경
 */
doPasswordEdit = function() {
	forPasswordEdit.run();
};

/**
 * 답변화면을 호출하는 함수
 */
doReply = function(mapPKs) {
    var form = UT.getById(forCreateReply.config.formId);
    form.reset();
	UT.copyValueMapToForm(mapPKs, forCreateReply.config.formId);
	form.elements["currentMenuId"].value = menuIds["qna"];
	forCreateReply.run();
};

/*
 * 게시판이동
 */
doMoveBoard = function(boardType) {
	var form = UT.getById(forMoveBoard.config.formId);
	form.elements["currentMenuId"].value = menuIds[boardType];
	if(boardType == "qna"){
		forMoveBoard.config.url    = "<c:url value="/mypage/system/bbs/qna/list.do"/>";	
	} else if(boardType == "notice") {
		forMoveBoard.config.url    = "<c:url value="/mypage/system/bbs/notice/list.do"/>";
	} else if(boardType == "staff") {
		forMoveBoard.config.url    = "<c:url value="/mypage/system/bbs/staff/list.do"/>";
	}
	forMoveBoard.run();
};

/**
 * 게시글 상세보기
 */
doDetail = function(mapPKs, boardType) {
    var form = UT.getById(forDetail.config.formId);
	form.reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);

    form.elements["currentMenuId"].value = menuIds[boardType];
	if(boardType == "notice") {
		forDetail.config.url    = "<c:url value="/mypage/system/bbs/notice/detail.do"/>";
	} else if(boardType == "staff") {
		forDetail.config.url    = "<c:url value="/mypage/system/bbs/staff/detail.do"/>";
	}
	forDetail.run();
};

/*
 * 스케쥴 이동
 */
doMoveSchedule = function() {
	forMoveSchedule.run();
};
</script>
</head>
<body>
<%-- <div class="section-info"> 
	<div class="photo photo-40"><img src="http://aof5.web.active4c.4csoft.com:8188/images/admin/common/blank.gif" alt="" /></div> 
	<div class="info"> 
		<strong class=""><c:out value="${detail.member.memberName }" /> (<c:out value="${detail.member.memberId }" />)</strong> 
		<p><c:out value="${detail.category.categoryString }" /> ㅣ <c:out value="${detail.member.phoneMobile }" /> ㅣ<c:out value="${detail.member.phoneHome }" /> ㅣ<c:out value="${detail.member.email }" /></p> 
	</div> 
	<div class="regist"> 
		<a href="javascript:void(0);" onclick="doMemberEdit();" class="btn black"><span class="small"><spring:message code="버튼:마이페이지:기본정보수정"/></span></a> 
		<a href="javascript:void(0);" onclick="doPasswordEdit();" class="btn black"><span class="small"><spring:message code="버튼:마이페이지:비밀번호변경"/></span></a> 
	</div> 
</div>  --%>
<%-- 
<div class="vspace"></div>
<div class="lybox-title">
	<h4 class="section-title"><spring:message code="글:마이페이지:사이트QNA"/></h4>
	<div class="right">
		<a href="javascript:void(0);" onclick="doMoveBoard('qna');">+<spring:message code="글:마이페이지:더보기"/></a>
	</div>
</div>

<div class="scroll-y mb20" style="height:160px;">	 
	<table id="" class="tbl-board"><!-- tbl-board --> 
		<colgroup> 
			<col style="width:8%;" /><!-- width 값은 각 화면 ui 에 따라 수정 --> 
			<col style="" /> 
			<col style="width:10%;" /> 
			<col style="width:12%;" /> 
			<col style="width:12%;" /> 
		</colgroup> 
		<tbody>
		<c:forEach var="row" items="${qna }" varStatus="i">
			<c:if test="${row.bbs.replyCount == 0 }">
			<tr> 
				<td><aof:code type="print" codeGroup="BBS_TYPE_QNA" selected="${row.bbs.bbsTypeCd}"/></td> 
				<td class="subject"><a href="javascript:void(0);" onclick="doReply({'parentSeq' : '<c:out value="${row.bbs.bbsSeq}"/>'});"><c:out value="${row.bbs.bbsTitle}" /></a></td><!-- subject --> 
				<td><a href="#"><c:out value="${row.bbs.regMemberName}"/></a></td> 
				<td>[<aof:date datetime="${row.bbs.regDtime}"/>]</td> 
				<td><a href="javascript:void(0);" onclick="doReply({'parentSeq' : '<c:out value="${row.bbs.bbsSeq}"/>'});" class="btn black"><span class="small"><spring:message code="버튼:마이페이지:답변하기"/></span></a></td> 
			</tr>
			</c:if>
		</c:forEach>
		</tbody> 
	</table>
</div>

<table class="tbl-layout"><!-- table-layout --> 
	<colgroup> 
		<col style="width:50%;" /> 
		<col style="width:auto;" /><!-- IE7 버그로 50% 으로 지정하면 우측 라인이 잘림, auto 로 설정 --> 
	</colgroup> 
	<tbody> 
		<tr> 
			<td class="first">
				<div class="lybox-title">
					<h4 class="section-title"><spring:message code="글:마이페이지:사이트공지사항"/></h4>
					<div class="right">
						<a href="javascript:void(0);" onclick="doMoveBoard('notice');">+<spring:message code="글:마이페이지:더보기"/></a>
					</div>
				</div>
				<div class="scroll-y mb20" style="height:160px;">	 
					<table id="" class="tbl-board"><!-- tbl-board --> 
						<colgroup> 
							<col style="width:10%;" /><!-- width 값은 각 화면 ui 에 따라 수정 --> 
							<col style="" /> 
							<col style="width:20%;" /> 
						</colgroup> 
						<tbody>
					<c:forEach var="row" items="${notice }" varStatus="i">
						<tr> 
							<td><aof:code type="print" codeGroup="BBS_TYPE_NOTICE" selected="${row.bbs.bbsTypeCd}"/></td> 
							<td class="subject"><a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'},'notice');"><c:out value="${row.bbs.bbsTitle}" /></a></td><!-- subject --> 
							<td>[<aof:date datetime="${row.bbs.regDtime}"/>]</td> 
						</tr> 
					</c:forEach>
						</tbody> 
					</table>
				</div>
			</td> 
			<td>
				<div class="lybox-title">
					<h4 class="section-title"><spring:message code="글:마이페이지:교직원게시판"/></h4>
					<div class="right">
						<a href="javascript:void(0);" onclick="doMoveBoard('staff');">+<spring:message code="글:마이페이지:더보기"/></a>
					</div>
				</div>
				<div class="scroll-y mb20" style="height:160px;">	 
					<table id="" class="tbl-board"><!-- tbl-board --> 
						<colgroup> 
							<col style="width:10%;" /><!-- width 값은 각 화면 ui 에 따라 수정 --> 
							<col style="" /> 
							<col style="width:20%;" /> 
						</colgroup> 
						<tbody>
					<c:forEach var="row" items="${staff }" varStatus="i">
						<tr> 
							<td><aof:code type="print" codeGroup="BBS_TYPE_STAFF" selected="${row.bbs.bbsTypeCd}"/></td> 
							<td class="subject"><a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'},'staff');"><c:out value="${row.bbs.bbsTitle}" /></a></td><!-- subject --> 
							<td>[<aof:date datetime="${row.bbs.regDtime}"/>]</td> 
						</tr> 
					</c:forEach>
						</tbody> 
					</table>
				</div>
			</td> 
		</tr> 
	</tbody> 
</table>
<div class="vspace"></div>
<div class="lybox-title">
	<h4 class="section-title"><spring:message code="글:마이페이지:나의일정"/></h4>
	<div class="right">
		<a href="javascript:void(0);" onclick="doMoveSchedule();">+<spring:message code="글:마이페이지:더보기"/></a>
	</div>
</div>
<div id="calendar"></div>
--%>
<form name="FormData" id="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="bbsSeq" />
	<input type="hidden" name="currentMenuId" />
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="srchYearMonth" value="<c:out value="${srchYearMonth}"/>"/>
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="parentSeq" />
	<input type="hidden" name="currentMenuId" />
</form>
</body>
</html>