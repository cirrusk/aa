<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">

var typeSeq = "";
var ppSeq = "";
var ppName = "";
var roomSeq = "";
var roomName = "";
var year = "";
var month = "";

var toYear = "";
var toMonth = "";

var ppCnt = 0;
var roomCnt = 0;

var step1Clk = 0;
$(document).ready(function () {
// 	$('#IframeComponent', parent.document).height($('.bizroom').height()+50);
// 	$('#IframeComponent', parent.document).height(3000);
	$(".brSelectWrap").show();
	$(".roomInfo").hide();
	$("#stepDone").hide();
	setPpInfoList();
	
	$("#step1Btn").click(function () {
		if(ppCnt != 0 && roomCnt != 0){
			/* step1 닫기 */
			$("#step1Btn").parents('.brWrap').find('.sectionWrap').stop().slideUp(function(){
				$("#step1Btn").parents('.brWrap').find('.stepTit').find('.close').show();
				$("#step1Btn").parents('.brWrap').find('.stepTit').find('.open').hide();
				
				$("#step1Btn").parents('.brWrap').find('.modifyBtn').show();
				$("#step1Btn").parents('.brWrap').find('.req').show(); //결과값 보기
				$("#step1Btn").parents('.brWrap').removeClass('current').addClass('finish');
			});

			/* step2 열기 */
			$("#step2Btn").parents('.brWrap').find('.modifyBtn').hide();
			$("#step2Btn").parents('.brWrap').find('.result').hide();
			$("#step2Btn").parents('.brWrap').find('.sectionWrap').stop().slideDown(function(){
				$("#step2Btn").parents('.brWrap').find('.stepTit').find('.close').hide();
				$("#step2Btn").parents('.brWrap').find('.stepTit').find('.open').show();
				$("#step2Btn").parents('.brWrap').removeClass('finish').addClass('current');
			});

			calendar2(year, month);
		}else{
			alert("지역과 시설을 선택해야 진행 가능합니다.");
		}
	});
	
	$("#step2Btn").click(function () {
		sessionCheck();
	});
	
	$("#step3Btn").click(function () {
		paymentCheck();
	});
	
	$(".radio1").click(function () {
		paymentChange($(this));
	});
	
	$(".radio2").click(function () {
		paymentChange($(this));
	});
	
	$("#radio3").click(function () {
		cardChange($(this));
	});
	
	$("#radio4").click(function () {
		cardChange($(this));
	});
	
// 	$(".btnBasicBL").click(function () {
// 		roomConfirmPop();
// 	});

	$(".btnBasicGL").click(function () {
// 		$("#roomEduForm").attr("action", "<c:url value='/reservation/roomEduForm.do'/>");
// 		$("#roomEduForm").submit();
		
// 		$("#roomEduForm").attr("action", "${pageContext.request.contextPath}/reservation/roomEduForm.do");
// 		$("#roomEduForm").submit();
		
		location.href = "<c:url value='/reservation/roomBizForm.do'/>";
	});
	
	$("#onlyPossibleCheck").change(function () {
		if($(this).prop("checked")){
			$(".fullBook").each(function () {
				$(this).hide();
			});
		}else{
			$(".fullBook").each(function () {
				$(this).show();
			});
		}
	});
});

/* according handler */
var accordingNavagate = {
	
	done : function () {
		$("#step3 > div > div.result.req > p").show();
	},
		
	from3to2 :function(){
		//nothing to do
	},
	
	from2to1 :function(){
		if( 0 == $("#sessionCheckResult > p.total").text().length ) {
			$("#step2Btn").parents('.brWrap').find('.result').show();
			$("#sessionCheckResult").hide();
		}
	}
};

function setPpInfoList(){
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomBizPpInfoListAjax.do'/>"
		, type : "POST"
		, async : false
		, success: function(data, textStatus, jqXHR){
			var ppList = data.ppRsvRoomCodeList;
			var lastPp = data.searchLastRsvRoomPp;
			
			if(null == ppList || "" == ppList){
				alert("아직 시설이 등록되지 않았습니다. 운영자에 의해 시설이 등록 된 이후 사용 바랍니다.");
				return;
			}
			
			typeSeq = ppList[0].typeseq;
			
			var html = "";
			
			for(var i = 0; i < ppList.length; i++){
				if(ppList[i].ppseq == lastPp.ppseq){
					html += "<a href='javascript:void(0);' class = 'on' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:setRoomInfoList('"+ ppList[i].ppseq +"','"+ ppList[i].ppname +"');\">"+ppList[i].ppname+"</a>";
					
					this.ppSeq = ppList[i].ppseq;
					this.ppName = ppList[i].ppname;
					
					setRoomInfoList(ppList[i].ppseq, ppList[i].ppname);
					
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:setRoomInfoList('"+ ppList[i].ppseq +"','"+ ppList[i].ppname +"');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$("#ppAppend").empty();
			$("#ppAppend").append(html);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setRoomInfoList(getPpseq, getPpname){
	$("#step2Btn").parents('.brWrap').find('.result').show();
	$("#sessionCheckResult").hide();
	$("#sessionCheckResult").empty();
	
	step1Clk = 1;
	
	/* 선택 pp카운트 */
	this.ppCnt++;
	this.roomCnt = 0;
	
	$(".roomInfo").hide();
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".on").attr("class", "");
	this.ppSeq = "";
	this.ppName = "";
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+getPpseq).attr("class", "on");
	this.ppSeq = getPpseq;
	this.ppName = getPpname;
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomEduRoomInfoListAjax.do' />"
		, type : "POST"
		, data: {"typeseq" : typeSeq
				, "ppseq" : ppSeq}
		, success: function(data, textStatus, jqXHR){
			var roomList = data.rsvRoomInfoList;
			var lastRoom = data.searchLastRsvRoom;
			
			year = roomList[0].year;
			month = roomList[0].month;
			
			$("#roomAppend").empty();
			
			var  html = "";
			
			for(var i = 0; i < roomList.length; i++){
				if(roomList[i].roomseq == lastRoom.roomseq){
					html += "<a href=\"javascript:void(0);\" class=\"on\" id=\"detailRoomSeq"+roomList[i].roomseq+"\" naem=\"detailRoomSeq\" onclick=\"javascript:detailRoom('"+roomList[i].roomseq+"', '"+roomList[i].roomname+"');\">"+roomList[i].roomname+" ("+roomList[i].seatcount+")</a>";
					detailRoom(roomList[i].roomseq, roomList[i].roomname);
				}else{
					html += "<a href=\"javascript:void(0);\" id=\"detailRoomSeq"+roomList[i].roomseq+"\" naem=\"detailRoomSeq\" onclick=\"javascript:detailRoom('"+roomList[i].roomseq+"', '"+roomList[i].roomname+"');\">"+roomList[i].roomname+" ("+roomList[i].seatcount+")</a>";
				}
			}
			
			$("#roomAppend").append(html);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 pp의 준비물, 이용자격 등을 조회 */
function detailRoom(getRoomseq, getRoomName){
	
	$("#step2Btn").parents('.brWrap').find('.result').show();
	$("#sessionCheckResult").hide();
	$("#sessionCheckResult").empty();
	
	step1Clk = 1;
	
	
	/* 시설 선택 카운트 */
	this.roomCnt++;
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$("#roomAppend > a").each(function () {
		$(this).removeClass("on");
	});
	this.roomSeq = "";
	this.roomName = "";
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailRoomSeq"+getRoomseq).addClass("on");
	this.roomSeq = getRoomseq;
	this.roomName = getRoomName;
	
	var param = {"roomseq" : roomSeq};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomEduRsvRoomDetailInfoAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var detailCode = data.roomEduRsvRoomDetailInfo;
			$("#ppName").empty();/* (pp + room) name */
			$("#afterRoomName").empty();/* (pp + room) name */
			$("#afterIntro").empty();/* 시설소개 */
			$("#afterSeatcount").empty(); /* 정원 */
			$("#afterUseTime").empty(); /* 이용시간 */
			$("#afterRoleNote").empty(); /* 이용자격  */
			$("#afterFacility").empty(); /* 부대시설 */
			
			$("#afterRoomName").append(detailCode.ppname + " <em>|</em> " + detailCode.roomname);
			$("#afterIntro").append(detailCode.intro);
			$("#afterSeatcount").append(detailCode.seatcount);
			$("#afterUseTime").append(detailCode.usetime);
			$("#afterRoleNote").append(detailCode.role + "<br/><span class=\"normal\">"+detailCode.rolenote+"</span>");
			$("#afterFacility").append(detailCode.facility);
			
			$("#ppName").append("<p>"+detailCode.ppname + " <em>|</em> " + detailCode.roomname+"</p>");
			
			if(detailCode.filekey1 == null
					&& detailCode.filekey2 == null
					&& detailCode.filekey3 == null
					&& detailCode.filekey4 == null
					&& detailCode.filekey5 == null
					&& detailCode.filekey6 == null
					&& detailCode.filekey7 == null
					&& detailCode.filekey8 == null
					&& detailCode.filekey9 == null
					&& detailCode.filekey10 == null
				){
				/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
				$("#touchSlider ul").empty();
				$("#touchSlider ul").append("<li></li>");
				$(".roomInfo").show();
				touchsliderFn();
			}else{
				var fileKeys = [
	                  detailCode.filekey1
	                , detailCode.filekey2
	                , detailCode.filekey3
	                , detailCode.filekey4
	                , detailCode.filekey5
	                , detailCode.filekey6
	                , detailCode.filekey7
	                , detailCode.filekey8
	                , detailCode.filekey9
	                , detailCode.filekey10
                ];
				
				/* 해당 시설 이미지 파일 조회 */
				roomImageListAjax(fileKeys);
			}
			
			/* 잔여횟수 표시 */
// 			getRemainDayByMonth();
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 시설 이미지 파일 조회 */
function roomImageListAjax(fileKeys) {
	var param = {"fileKeys" : fileKeys};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomImageUrlListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var urlList = data.roomImageUrlList;
			
			var html = "";
			if(0 < urlList.length){
				for(var num in urlList){
// 					html += "<li><img src=\"/reservation/imageView.do?filefullurl="+urlList[num].filefullurl+"&storefilename="+urlList[num].storefilename+"\" alt="+urlList[num].roomname+" /></li>";
					html += "<li><img src='/reservation/imageView.do?file="+urlList[num].storefilename+"&mode=RESERVATION' alt='"+urlList[num].roomname+"'  title='"+urlList[num].altdesc+"' /></li>";
				}
			}else{
				html = "<li></li>";
			}
			$("#touchSlider ul").empty();
			$("#touchSlider ul").append(html);
			
			
			/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
			$(".roomInfo").show();

			touchsliderFn();
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 다음달 캘린더의 날짜 호출 한다. */
function calendar(year, month){
	alert("해당월에 선택된 세션리스트는 삭제됩니다.");
	calendarCase(year, month);
}

/* 다음달 캘린더의 날짜 호출 한다. */
function calendar2(year, month){
	/* 선택된 세션 체크 */
	var date = new Date();
	var year = date.getFullYear();
	var month = new String(date.getMonth()+1);

	var cnt = 0;
	$("input[name=sessionCheck]").each(function () {
		if($(this).prop("checked")){
			cnt++;
		}
	});
	
	if(cnt == 0  ){
		alert("해당월에 선택된 세션리스트는 삭제됩니다.");
		calendarCase(year, month);
	}
	
	if(cnt != 0 && step1Clk == 1){
		alert("해당월에 선택된 세션리스트는 삭제됩니다.");
		calendarCase(year, month);
	}
}

function calendarCase(year, month){
	this.year = year;
	this.month = month;
	
	var param = {
		  "year" : this.year
		, "month" : this.month < 10 ? "0" + this.month : this.month
		, "typeseq" : this.typeSeq
		, "roomseq" : this.roomSeq
	};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomEduCalendarAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 달력 년, 월 랜더링 */
			var yearMonthList = data.roomEduYearMonth;
			
			/* 해당 월 달력 정보 */
			var calendar = data.roomEduCalendar;
			
			/* 오늘 날짜 정보 (yyyymmdd) */
			var today = data.roomEduToday;
			
			/* 예약 정보 */
			var reservationInfoList = data.roomEduReservationInfoList;
			/*  */
			calenderHeaderRender(yearMonthList);
			
			/*  */
			calenderRender(calendar, today, reservationInfoList);
			
			this.toYear = today.ymd.substring(0, 4);
			this.toMonth = today.ymd.substring(4, 6);
			
// 			/*----------------클래스 명으로 사용될 년,월 데이터를 전역 변수에 저장------------------- */
// 			classNameEngMonth = data.nextYearMonth.engMonth;
// 			classNameMonth = data.nextYearMonth.month;
// 			classNameYear = data.nextYearMonth.year;
// 			/*------------------------------------------------------------ */
			
// 			/* 다음달 날짜 리스트 */
// 			var calList = data.nextMonthCalendar;
			
// 			/* 캘린더에 해당 pp의 휴무일의 정보를 담기 위한 휴무일 데이터 */
// 			var hoilDayList = data.searchExpHealthHoilDayList;
			
// 			/* 다음달 캘린더를 그리는 함수 호출 */
// 			gridNextMonth(calList, hoilDayList);

			getRsvAvailabilityCount();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	step1Clk = 0;
}

/* 누적 예약 가능 횟수 (월, 주, 일) 조회 */
function getRsvAvailabilityCount() {
	var param = {
			  ppseq : ppSeq
			, typeseq : typeSeq
			, roomseq : roomSeq
		};

		$.ajaxCall({
			url: "<c:url value='/reservation/getRsvAvailabilityCountAjax.do'/>"
			, type : "POST"
			, data : param
			, async : false
			, success: function(data, textStatus, jqXHR){
				var getRsvAvailabilityCount = data.getRsvAvailabilityCount;
				
				var cnt = 0;
				
				var html = "<div class=\"hText availabilityCount\">"
					+ "<span>";
				
				if(null != getRsvAvailabilityCount){
					if(null != getRsvAvailabilityCount.ppdailycount
							&& null != getRsvAvailabilityCount.globaldailycount){
						var dailyCount = getRsvAvailabilityCount.ppdailycount > getRsvAvailabilityCount.globaldailycount ? getRsvAvailabilityCount.globaldailycount : getRsvAvailabilityCount.ppdailycount;
						html += "일 <strong>" + dailyCount + "</strong>회 ";
						cnt++;
					}else if(null == getRsvAvailabilityCount.ppdailycount
							&& null != getRsvAvailabilityCount.globaldailycount){
						html += "일 <strong>" + getRsvAvailabilityCount.globaldailycount + "</strong>회 ";
						cnt++;
					}else if(null != getRsvAvailabilityCount.ppdailycount
							&& null == getRsvAvailabilityCount.globaldailycount){
						html += "일 <strong>" + getRsvAvailabilityCount.ppdailycount + "</strong>회 ";
						cnt++;
					}
					
					if(null != getRsvAvailabilityCount.ppweeklycount
							&& null != getRsvAvailabilityCount.globalweeklycount){
						var weeklyCount = getRsvAvailabilityCount.ppweeklycount > getRsvAvailabilityCount.globalweeklycount ? getRsvAvailabilityCount.globalweeklycount : getRsvAvailabilityCount.ppweeklycount;
						html += "주 <strong>" + weeklyCount + "</strong>회 ";
						cnt++;
					}else if(null == getRsvAvailabilityCount.ppweeklycount
							&& null != getRsvAvailabilityCount.globalweeklycount){
						html += "주 <strong>" + getRsvAvailabilityCount.globalweeklycount + "</strong>회 ";
						cnt++;
					}else if(null != getRsvAvailabilityCount.ppweeklycount
							&& null == getRsvAvailabilityCount.globalweeklycount){
						html += "주 <strong>" + getRsvAvailabilityCount.ppweeklycount + "</strong>회 ";
						cnt++;
					}
					
					if(null != getRsvAvailabilityCount.ppmonthlycount
							&& null != getRsvAvailabilityCount.globalmonthlycount){
						var monthlyCount = getRsvAvailabilityCount.ppmonthlycount > getRsvAvailabilityCount.globalmonthlycount ? getRsvAvailabilityCount.globalmonthlycount : getRsvAvailabilityCount.ppmonthlycount;
						html += "월 <strong>" + monthlyCount + "</strong>회 ";
						cnt++;
					}else if(null == getRsvAvailabilityCount.ppmonthlycount
							&& null != getRsvAvailabilityCount.globalmonthlycount){
						html += "월 <strong>" + getRsvAvailabilityCount.globalmonthlycount + "</strong>회 ";
						cnt++;
					}else if(null != getRsvAvailabilityCount.ppmonthlycount
							&& null == getRsvAvailabilityCount.globalmonthlycount){
						html += "월 <strong>" + getRsvAvailabilityCount.ppmonthlycount + "</strong>회 ";
						cnt++;
					}
					
				}
				
				html += "예약가능</span>"
					+ "</div>";
					
				$(".availabilityCount").remove();
				
				if(cnt != 0){
					$(".calenderHeader").append(html);
				}else if(null == getRsvAvailabilityCount){
					$(".calenderHeader").append("<div class=\"hText availabilityCount\"></div>");
				}else{
					$(".calenderHeader").append("<div class=\"hText availabilityCount\">-</div>");
				}
				
			}
			, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
}

/* 잔여일 표시 - 달력의 '월'을 클릭 후 우상단에 남은 잔여일을 쿼리 하는 기능 */
function getRemainDayByMonth(){
	var param = {
		  reservationdate : this.year + (this.month < 10 ? "0" + this.month : this.month) + "01"
		, rsvtypecode : "R01"
		, ppseq : ppSeq
		, typeseq : typeSeq
		, roomseq : roomSeq
	};

	$.ajaxCall({
		url: "<c:url value='/reservation/getRemainDayByMonthAjax.do'/>"
		, type : "GET"
		, data : param
		, async : false
		, success: function(data, textStatus, jqXHR){
			if(data){
				$("#remainDay").empty();
				$("#remainDay").append(data.remainDay);
			}else{
				$("#remainDay").empty();
				$("#remainDay").append("0");
			}
		}
		, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});		
}

function calenderHeaderRender(yearMonthList){
	
	var html = "";
	var tempMonth = "";
		
	html += "<div class=\"monthlyWrap\">";
		
	for(var num in yearMonthList){
		/* 5개월 넘어가면 stop */
		if(7 <= num){
			break;
		}
		
		if(this.month == yearMonthList[num].month){
			tempMonth = yearMonthList[num].month;
			html += "<span><a href=\"javascript:void(0);\" class=\""+yearMonthList[num].engmonth+" on\">"+yearMonthList[num].month+"월</a></span>";
		}else{
			html += "<span><a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"');\" class=\""+yearMonthList[num].engmonth+"\">"+yearMonthList[num].month+"월</a></span>";
		}
	}
	
	html += "</div>"
		+ "<div class=\"hText availabilityCount\">"
		+ "</div>";
	
	
	$(".calenderHeader").empty();
	$(".calenderHeader").append(html);
	
}

/* 달력 그리기 */
function calenderRender(calendar, today, reservationInfoList){
	
	var html = "";
	
	var calendarCnt = 0;
	
	$(".tblBookCalendar").empty();
	
	html += "<caption>캘린더형 - 날짜별 시설예약가능 시간</caption>"
		+ "<colgroup>"
		+ "	<col style=\"width:15%\" span=\"2\">"
		+ "	<col style=\"width:14%\" span=\"5\">"
		+ "</colgroup>"
		+ "<thead>"
		+ "	<tr>"
		+ "		<th scope=\"col\" class=\"weekSun\">일</th>"
		+ "		<th scope=\"col\" class=\"weekMon\">월</th>"
		+ "		<th scope=\"col\" class=\"weekTue\">화</th>"
		+ "		<th scope=\"col\" class=\"weekWed\">수</th>"
		+ "		<th scope=\"col\" class=\"weekThur\">목</th>"
		+ "		<th scope=\"col\" class=\"weekFri\">금</th>"
		+ "		<th scope=\"col\" class=\"weekSat\">토</th>"
		+ "	</tr>"
		+ "</thead>"
		+ "<tbody>";
	
	var cnt = 0;
	for(var num = 0; num < Math.ceil((calendar.length + (calendar[0].weekday - 1))/7); num++){
		html += "<tr>";
		for(var i = 0; i < 7; i++){
			if(cnt == calendar.length){
				html += "<td></td>";
				continue;
			}
			if(calendar[cnt].weekday == (i+1+(num*7)) || cnt > 0){
				if(today.ymd > calendar[cnt].ymd){
					html += "<td class=\"late\">"
							+ "<a href=\"javascript:void(0);\">"
							+ calendar[cnt].day
							+ "</a>"
							+ "</td>";
				}else{
					
					var totalCnt = 0;
					var rsvCnt = 0;
					var setCode = "";
					var workCode = "";
					var temp = "";
					for(var j in reservationInfoList){
						if(reservationInfoList[j].ymd == calendar[cnt].ymd
								&& setCode == ""){
							setCode = reservationInfoList[j].settypecode;
							workCode = reservationInfoList[j].worktypecode;
							temp = reservationInfoList[j].temp;
						}
						if(reservationInfoList[j].ymd == calendar[cnt].ymd
								&& reservationInfoList[j].settypecode == setCode
								&& reservationInfoList[j].worktypecode == workCode
								&& reservationInfoList[j].temp == temp){
							if(reservationInfoList[j].standbynumber == 1){
								rsvCnt += reservationInfoList[j].rsvcnt;
							}else if('R01' == reservationInfoList[j].adminfirstcode){
								
							}else{
								totalCnt++;
							}
						}
					}
					
					if(workCode == "S02"){
						html += "<td class=\"late\">"
							+ "<a href=\"javascript:void(0);\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day
							+ "<span><em>휴무</em></span>";
					}else if(setCode == null || totalCnt == 0){
						html += "<td class=\"late\">"
							+ "<a href=\"javascript:void(0);\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day;
					}else if(totalCnt == rsvCnt){
						html += "<td class=\"late\">"
							+ "<a href=\"javascript:void(0);\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day
							+ "<span><em>예약마감</em></span>";
					}else{
						html += "<td class=\""+calendar[cnt].engweekday+"\">"
							+ "<a href=\"javascript:deleteSelcOnCal('"+calendar[cnt].day+"', '"+this.year+"', '"+this.month+"');\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day
							+ "<em class=\"reserv\">("+(totalCnt - rsvCnt)+")</em>";
							
						calendarCnt++;
					}
					
					html += "</a>"
						+ "</td>";
				}
				cnt++;
			}else{
				html += "<td></td>";
			}
		}
		html += "</tr>";
	}
	
	html += "</tbody>";
	
	$(".tblBookCalendar").append(html);
	
	/* 세션 정보 삭제 */
	$(".tblSession").remove();
	/* '상단 캘린더에서 날짜를 선택해 주세요' 문구 적용 */
	$(".noSelectDate").remove();
	$(".brSessionWrap").append(
			  "<div class=\"noSelectDate\">"
			+ "<span>상단 캘린더에서 날짜를 선택해 주세요.</span>"
			+ "</div>"
	);
	
	/* 잔여횟수 표시 */
// 	getRemainDayByMonth();

	if(calendarCnt == 0){
		
		var months = $(".monthlyWrap > span").length;
		
		if( 1 < months ) {
			msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
		
		alert(msg);
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}


/* 캘린더 에서 선택한 세션 & 날짜 삭제 */
function deleteSelcOnCal(day, year, month){
	
	var tempDay = day < 10 ? "0" + day : day;
	var tempMonth = month < 10 ? "0" + month : month;
	
	/* 캘린더에서 날짜가  이미 선택이 된 경우  해당 날짜의 세션과 캘린의 선택을 지워줌 */
	if($("#cal"+year+tempMonth+tempDay).attr("class") == "selcOn"){
		
		var cnt = 0;
		$("#"+year+tempMonth+tempDay).find("input[name=sessionCheck]").each(function () {
			if($(this).prop("checked")){
				cnt++;
			}
		});
		
		if(cnt != 0){
			/* confirm 창 */
			if(!confirm("선택하신 날짜에 체크된 세션이 존재합니다. 삭제 하시겠습니까?")){
				return;
			}
			
		};
		
		$("#cal"+year+tempMonth+tempDay).removeAttr("class");
		$("#"+year+tempMonth+tempDay).remove();
		
		/* 선택된 세션이 없는 경우 '상단 캘린더에서 날짜를 선택해 주세요' 문구 적용 */
		cnt = 0;
		$(".tblSession").each(function () {
			cnt++;
		});
		if(cnt == 0){
			$(".brSessionWrap").append(
					 "<div class=\"noSelectDate\">"
					+"<span>상단 캘린더에서 날짜를 선택해 주세요.</span>"
					+"</div>"
			);
		}
		
	/* 캘린더에 새로운 날짜를 선택한 경우 */
	}else{
		
		$("#cal"+year+tempMonth+tempDay).attr("class", "selcOn");
// 		$(".brSessionWrap").show();
		
		/* '선택된 세션이 없습니다' 문구 삭제 */
		$(".noSelectDate").remove();
				
		/* 선택 날짜의 세션 정보 상세보기 */
		showSession(day, year, month);
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 선택 날짜의 세션 상세보기 */
function showSession(day, year, month){
	
	var tempMonth = month < 10 ? "0" + month : month;
	var tempDay = day < 10 ? "0" + day : day;
	
	var param = {
		  "typeseq" : this.typeSeq
		, "roomseq" : this.roomSeq
		, "year" : year
		, "month" : tempMonth
		, "day" : tempDay
	};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomEduSeesionListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var html = "";
			var seesionList = data.roomEduSeesionList;
			
			html += "<table id=\""+year+tempMonth+tempDay+"\" class=\"tblSession\">"
				+ "<caption>세션 선택</caption>"
				+ "<colgroup>"
				+ "<colgroup>"
				+ "<col style=\"width:130px\"/>"
				+ "<col style=\"width:130px\"/>"
				+ "<col style=\"width:*\"/>"
				+ "<col style=\"width:100px\"/>"
				+ "</colgroup>"
				+ "<thead>"
				+ "<tr>"
				+ "<th scope=\"col\" colspan=\"4\">"+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")<a href=\"javascript:deleteSelcOnCal('"+day+"', '"+year+"', '"+month+"')\" class=\"btnDel\">삭제</a></th>"
				+ "</tr>"
				+ "</thead>"
				+ "<tbody>";
			
			var rsvsessionseq = "";
			var tempStr = "";
			var temp = "";
			var settypecode = "";
			var renderCnt = 0;
			for(var num in seesionList){
				if(settypecode == "" && seesionList[num].settypecode != null){
					temp = seesionList[num].temp;
					settypecode = seesionList[num].settypecode;
				}
				if(tempStr != ""
					&& seesionList[num].rsvsessionseq != rsvsessionseq){
					html += tempStr;
					tempStr = "";
					renderCnt = 0;
				}
				if(seesionList[num].settypecode == settypecode
					&& seesionList[num].temp == temp
					&& renderCnt == 0){
					
					if(seesionList[num].standbynumber == null
							 && 'R01' != seesionList[num].adminfirstcode){
						html += "<tr>"
							+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionClick(this);\"/>"
							+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
							+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
							+ "<input type=\"hidden\" class=\"sessionPrice\" value=\"무료\"/>"
							+ "<input type=\"hidden\" class=\"price\" value=\""+0+"\"/>"
							+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
							+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
							+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
							+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
							+	seesionList[num].sessionname+"</td>"
							+ "<td>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\">무료</td>"
							+ "<td class=\"able\">예약가능</td>"
							+ "</tr>";
					}else if(seesionList[num].standbynumber == 0
								&& renderCnt == 0
								&& 'R01' != seesionList[num].adminfirstcode){
						
						rsvsessionseq = seesionList[num].rsvsessionseq;
						
						tempStr = "<tr>"
							+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionClick(this);\"/>"
							+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
							+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"(대기신청)\"/>"
							+ "<input type=\"hidden\" class=\"sessionPrice\" value=\"무료\"/>"
							+ "<input type=\"hidden\" class=\"price\" value=\""+0+"\"/>"
							+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
							+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
							+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
							+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
							+	seesionList[num].sessionname+"</td>"
							+ "<td>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\">무료</td>"
							+ "<td class=\"able\">대기신청</td>"
							+ "</tr>";
					}else if(seesionList[num].standbynumber == 1
							 || 'R01' == seesionList[num].adminfirstcode){
						
						rsvsessionseq = seesionList[num].rsvsessionseq;
						
						tempStr = "<tr class=\"fullBook\">"
							+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
							+ "<td>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\">무료</td>"
							+ "<td class=\"able\">예약마감</td>"
							+ "</tr>";
						renderCnt++;
					}
				}
			}

			if(tempStr != ""){
				html += tempStr;
			}
			
			html += "</tbody>";
			
			$(".brSessionWrap").append(html)
			
			$("#onlyPossibleCheck").change();
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 세션 체크시 해당 로우 select */
function sessionClick(obj) {
	if($(obj).prop("checked")){
		$(obj).parents("tr").addClass("select");
	}else{
		$(obj).parents("tr").removeClass("select");
	}
}

/* 세션 선택 step3으로 이동하기 전 데이터 정리*/
function sessionCheck(){
	
	var html = "";
	var tempHtml = "";
	var formHtml = ""
	var cnt = 0;
	var totalPrice = 0;
	
	var snsTitle = "";
	var snsHtml = ""; 
	
	/* 예약 완료후 포커스 상단 유지 */
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	$("input[name=sessionCheck]").each(function () {
		if($(this).prop("checked")){
			
			tempHtml += "<p>"+$(this).parent("td").children(".sessionYmd").val()
					+" <em>|</em> "+$(this).parent("td").children(".sessionName").val()
					+"</span></p>";
					
			
			snsHtml += "■"+ppName+"("+roomName+")"
					+ $(this).parent("td").children(".sessionYmd").val() + "| \n" 
					+ $(this).parent("td").children(".sessionName").val() + "\n";
							
			cnt++;
			totalPrice += parseInt($(this).parent("td").children(".price").val());
			
			if($(this).parent("td").parent("tr").children(".able").text() == "대기신청"){
				formHtml += "<input type=\"hidden\" name=\"typeSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+typeSeq+"\"/>"
						+ "<input type=\"hidden\" name=\"ppSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppSeq+"\"/>"
						+ "<input type=\"hidden\" name=\"ppName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppName+"\"/>"
						+ "<input type=\"hidden\" name=\"roomSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomSeq+"\"/>"
						+ "<input type=\"hidden\" name=\"roomName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomName+"\"/>"
						+ "<input type=\"hidden\" name=\"sessionYmd\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionYmd").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"sessionName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionName").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"sessionPrice\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionPrice").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"reservationDate\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".reservationdate").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"rsvSessionSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".rsvSessionSeq").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"startDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".startDateTime").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"endDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".endDateTime").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"price\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".price").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"cookMasterCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"R02\"/>"
						+ "<input type=\"hidden\" name=\"standByNumber\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"1\"/>"
						+ "<input type=\"hidden\" name=\"paymentStatusCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"P01\"/>";
			}else{
				formHtml += "<input type=\"hidden\" name=\"typeSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+typeSeq+"\"/>"
						+ "<input type=\"hidden\" name=\"ppSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppSeq+"\"/>"
						+ "<input type=\"hidden\" name=\"ppName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppName+"\"/>"
						+ "<input type=\"hidden\" name=\"roomSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomSeq+"\"/>"
						+ "<input type=\"hidden\" name=\"roomName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomName+"\"/>"
						+ "<input type=\"hidden\" name=\"sessionYmd\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionYmd").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"sessionName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionName").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"sessionPrice\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionPrice").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"reservationDate\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".reservationdate").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"rsvSessionSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".rsvSessionSeq").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"startDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".startDateTime").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"endDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".endDateTime").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"price\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".price").val()+"\"/>"
						+ "<input type=\"hidden\" name=\"cookMasterCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"R02\"/>"
						+ "<input type=\"hidden\" name=\"standByNumber\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"0\"/>"
						+ "<input type=\"hidden\" name=\"paymentStatusCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"P02\"/>";
			}
		}
	});
	if(cnt == 0){
		alert("세션을 선택 후 다음으로 진행 가능합니다.");
		return;
	}
	
	html = "<p class=\"total\">총 "+cnt+"건<em>|</em>결제예정금액 : <span>무료</span></p>"
	+ tempHtml;
	
	/*------------------ sns 내용----------------------------- */
	snsTitle = "[한국암웨이]시설/체험 예약내역 (총 "+cnt+"건) \n" + snsHtml;
	
	$("#snsText").empty();
	$("#snsText").val(snsTitle);
	/*------------------------------------------------------ */
	
	
	$("#sessionCheckResult").empty();
	$("#roomEduForm").empty();
	$("#sessionCheckResult").append(html);
	$("#roomEduForm").append(formHtml);
	
	$("#totalPrice").text("");
	$("#totalPrice").text(totalPrice+"원(VAT포함)");
	
	/* 안심결제 기본값 */
	$("#normalPayment").hide();
	$("#securityPayment").show();
	$("#comnum").parent("td").parent("tr").hide();
	$("#birth").parent("td").parent("tr").show();
	
	/* 누적 예약 잔여 횟수 유효성 검사*/
	/* typeseq, ppseq, roomseq 일, 주, 월 예약 가능 횟수 조회 변수*/
	$("#roomEduForm").append("<input type=\"hidden\" name=\"typeseq\" value=\""+typeSeq+"\">");
	$("#roomEduForm").append("<input type=\"hidden\" name=\"ppseq\" value=\""+ppSeq+"\">");
	$("#roomEduForm").append("<input type=\"hidden\" name=\"roomseq\" value=\""+roomSeq+"\">");
	
	/* 패널티 유효성 중간 검사 */
	if(middlePenaltyCheck()){
		
		$.ajaxCall({
			  url: "<c:url value='/reservation/rsvAvailabilityCheckAjax.do'/>"
			, type : "POST"
			, data: $("#roomEduForm").serialize()
			, success: function(data, textStatus, jqXHR){
				if(data.rsvAvailabilityCheck){
					/* step2 닫기 */
					$("#step2Btn").parents('.brWrap').find('.sectionWrap').stop().slideUp(function(){
						$("#step2Btn").parents('.brWrap').find('.stepTit').find('.close').show();
						$("#step2Btn").parents('.brWrap').find('.stepTit').find('.open').hide();
						
						$("#step2Btn").parents('.brWrap').find('.modifyBtn').show();
						$("#sessionCheckResult").show();
	//			 		$("#step2Btn").parents('.brWrap').find('.req').show(); //결과값 보기
						$("#step2Btn").parents('.brWrap').removeClass('current').addClass('finish');
					});
	
					/* step3 열기 */
					$brWrap = $("#step3Btn").parents('.brWrap');
					stepTit = $brWrap.find('.stepTit');
					
					$("#step3Btn").parents('.brWrap').find('.modifyBtn').hide();
					$("#step3Btn").parents('.brWrap').find('.result').hide();
					$("#step3Btn").parents('.brWrap').find('.sectionWrap').stop().slideDown(function(){
						$("#step3Btn").parents('.brWrap').find('.stepTit').find('.close').hide();
						$("#step3Btn").parents('.brWrap').find('.stepTit').find('.open').show();
						$("#step3Btn").parents('.brWrap').removeClass('finish').addClass('current');
					});
					
					setTimeout(function(){ abnkorea_resize(); }, 500);
				}else{
					alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
				}
	
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

function middlePenaltyCheck() {
	
	var penaltyCheck = true;
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/rsvMiddlePenaltyCheckAjax.do'/>"
		, type : "POST"
		, data: $("#roomEduForm").serialize()
		, async: false
		, success: function(data, textStatus, jqXHR){
			if(!data.middlePenaltyCheck){
				alert("패널티로 인해서 예약이 불가 합니다.");
				penaltyCheck = false;
			}

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	return penaltyCheck;
}

function paymentChange(obj){
	if($(obj).prop("class") == "radio1"){
		$("#normalPayment").hide();
		$("#securityPayment").show();
		$("#securityPayment").find(".radio1").prop("checked", "checked");
	}else{
		$("#normalPayment").show();
		$("#securityPayment").hide();
		$("#normalPayment").find(".radio2").prop("checked", "checked");
	}
}

function cardChange(obj) {
	if($(obj).prop("id") == "radio3"){
		$("#birth").parent("td").parent("tr").show();
		$("#comnum").parent("td").parent("tr").hide();
		$("#birth").prop("checked", "checked");
	}else{
		$("#birth").parent("td").parent("tr").hide();
		$("#comnum").parent("td").parent("tr").show();
		$("#comnum").prop("checked", "checked");
	}
}

function paymentCheck(){
	
	/* 예약 충돌의 로직이 본문의 내용을 삭제 하게 되어 예약건수가 0개 생기는 경우에 대한 방어 */
	if( 0 >= $("#roomEduForm input[type=hidden][name='rsvSessionSeq']").length ){
		alert("예약할 시설이 없습니다.");
		return;
	}
	
	/* 시설교육 규정 동의 체크 확인 */
	if ( !$("#check1").is(":checked") ){
		alert("시설교육 규정 동의를 체크하여 주세요.");
		return;
	}
	
	/* 시설교육 제품 교육시 주의 사항 동의 체크 확인 */
	if ( !$("#check2").is(":checked") ){
		alert("시설교육 제품 교육시 주의 사항 동의를 체크하여 주세요.");
		return;
	}
	
	/* 시설교육 규정 동의 체크 확인 */
	if ( !$("#check1").is(":checked") ){
		alert("시설교육 규정 동의를 체크하여 주세요.");
		return;
	}
	
	/* 시설교육 제품 교육시 주의 사항 동의 체크 확인 */
	if ( !$("#check2").is(":checked") ){
		alert("시설교육 제품 교육시 주의 사항 동의를 체크하여 주세요.");
		return;
	}
	
	var param = $("#roomEduForm").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomBizPaymentCheckAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var cancelDataList = data.cancelDataList;
			
			if(cancelDataList.length == 0){
				/* 결제정보 확인 팝업 */
				roomBizInfoPop();
			}else{
				/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
				roomBizDisablePop(cancelDataList);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 예약불가 팝업 호출 (예약 충돌)*/
function roomBizDisablePop(cancelDataList){
	
	var url = "<c:url value='/reservation/roomBizDisablePop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
	$("#cancelList").empty();
    var $form = $('#cancelList');
    $form.attr('action', url);
    $form.attr('method', 'post');
    $form.attr('target', title);
    $form.appendTo('body');
    
	/* 중복 데이터 삭제 */
	for(var num in cancelDataList){
		$("."+cancelDataList[num].reservationdate+cancelDataList[num].rsvsessionseq).each(function () {
			$form.append($(this).prop("outerHTML"));
			$(this).remove();
		});
	}

	$form.submit();
	
}

/* 예약정보 확인 (정상 진행) */
function roomBizInfoPop(){
	
	var $frm = document.roomEduForm
	var url = "<c:url value='/reservation/roomBizInfoPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
	$frm.target = title;
	$frm.action = url;
	$frm.method = "post";
	$frm.submit();
}

/* 예약정보 현황 팝업 */
function roomConfirmPop(){
	
	var url = "<c:url value='/reservation/roomConfirmPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=754, height=900, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
    var frm = document.tempForm;
    frm.target = title;
    frm.action = url;
    frm.method = 'post';
    
    $("#tempForm").append("<input type=\"hidden\" name=\"rsvtypecode\" value=\"R01\"/>");
    $("#tempForm").append("<input type=\"hidden\" name=\"getYear\" value=\""+this.toYear+"\"/>");
    $("#tempForm").append("<input type=\"hidden\" name=\"getMonth\" value=\""+this.toMonth+"\"/>");
    
    frm.submit();

}


/* 약관 및 동의 전체보기 팝업 */
function roomIntroduceInfoPop(){
	
	var url = "<c:url value='/reservation/roomIntroduceInfoPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=660, directories=no, status=no, scrollbars=yes, resizable=no";
	
	url += "?clauseType=bizroom";
	
	window.open("", title, status);
	
    var frm = document.clauseForm;
    frm.action = url;
    frm.method = 'post';
    frm.target = title;
    frm.submit();
    
}

/* 팝업 창에서 전달 받은 예약한 데이터를 보여줌  */
function roomBizRsvDetail(){
	
	accordingNavagate.done();
	$("#stepDone").show();
	/* show box & hide box */
	var $brWrap = $("#step3Btn").parents('.brWrap');
	var stepTit = $brWrap.find('.stepTit');
	var result = $brWrap.find('.result');
	
	$brWrap.find('.sectionWrap').stop().slideUp(function(){
		$brWrap.find(stepTit).find('.close').show();
		$brWrap.find(stepTit).find('.open').hide();
		
		$brWrap.find('.modifyBtn').show();
		$brWrap.find('.req').show(); //결과값 보기
		$brWrap.removeClass('current').addClass('finish');
	});
	
	/* rendering html */
// 	$("#expHealthConfirm").append("<p class='total'>총  "+totalCnt+" 건</p>");
// 	for(var i =0; i < expHealthRsvList.length; i++){
		
// 		var html = "";
		
// 		if(expHealthRsvList[i].partnerTypeCode == "R01"){
// 			html += "<p>"+expHealthRsvList[i].reservationDate+"<em>|</em>"+expHealthRsvList[i].sessionTime+"<em>|</em>ABO</p>"
// 		}else if(expHealthRsvList[i].partnerTypeCode == "R02"){
// 			html += "<p>"+expHealthRsvList[i].reservationDate+"<em>|</em>"+expHealthRsvList[i].sessionTime+"<em>|</em>일반인동반</p>"
// 		}
		
// 		$("#expHealthConfirm").append(html);
// 	}
}

function tempSharing(url, sns){
	
	var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
	var title = "예약 - 비즈룸";
	var content = $("#snsText").val();
	var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
	
	sharing(currentUrl, title, sns, content, imageUrl);
}

function accessParentPage(){
	var newUrl = "/reservation/roomInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}
</script>
</head>
<body>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<form id="cancelList"></form>
	<form id="roomEduForm" name="roomEduForm" method="post">
	</form>
	
	<input type="hidden" id="transactionTime" value="" />	
	<input type="hidden" id="snsText" name="snsText">
	
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500070.gif" alt="비즈룸예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500070.gif" alt="전국 Amway Plaza내에서 미팅룸으로 운영되고 있는 비즈룸을 신청하실 수 있습니다."></p>
	</div>
	<div class="brIntro">
		<!-- @edit 20160701 인트로 토글 링크영역 변경 -->
		<h2 class="hide">비즈룸 예약 필수 안내</h2>
		<a href="#uiToggle_01" class="toggleTitle"><strong>비즈룸 예약 필수 안내</strong> <span class="btnArrow"><em class="hide">내용보기</em></span></a>
		<div id="uiToggle_01" class="toggleDetail"> <!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</div>
	<div class="brWrapAll">
		<span class="hide">교육장 예약 스텝</span>
		<!-- 스텝1 -->
		<div class="brWrap current" id="step1">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_aproom_01.gif" alt="Step1/지역,룸" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_aproom_01_current.gif" alt="Step1/지역,룸-지역 선택 후 룸 타입을 선택하세요." /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="brSelectWrap">
						<div class="relative">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_01.gif" alt="지역 선택"></h3>
<!-- 							<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen" onclick="javascript:showApInfo();"><span>AP 안내</span></a></span> -->
								<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen"><span>AP 안내</span></a></span>
<!-- 								<span class="btnR"><a href="#" class="btnCont uiApBtnOpen"><span>AP 안내</span></a></span> -->
						</div>
						
						<!-- layer popup -->
						<%@ include file="/WEB-INF/jsp/reservation/exp/apInfoPop.jsp" %>
						<!--// layer popup -->
				
						<div class="brselectArea" id="ppAppend">
<!-- 							<a href="#none">송도BSC</a><a href="#none">강남</a><a href="#none">강서</a><a href="#none">대전</a><a href="#none">천안</a><a href="#none">청주</a> -->
<!-- 							<a href="#none">부산</a><a href="#none">대구</a><a href="#none">창원</a><a href="#none">울산</a><a href="#none">광주</a><a href="#none">전주</a> -->
<!-- 							<a href="#none">강릉</a><a href="#none" class="on">제주</a><a href="#none">분당ABC</a> -->
						</div>
						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_02.gif" alt="룸 선택"></h3>
						<div class="brselectArea sizeM" id="roomAppend">
<!-- 							<a href="#uiLayerPop_w02" class="on btnCont">오디토리움 (300명)</a><a href="#none">비전센타 1 (170명)</a><a href="#none">비전센타 2 (70명)</a> -->
						</div>
					</section>
					<section class="brSelectWrap">
<!-- 						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_02.gif" alt="룸 선택"></h3> -->
<!-- 						<div class="brselectArea sizeM" id="roomAppend"> -->
<!-- 							<a href="#uiLayerPop_w02" class="on btnCont">오디토리움 (300명)</a><a href="#none">비전센타 1 (170명)</a><a href="#none">비전센타 2 (70명)</a> -->
<!-- 						</div> -->
						
						<!-- layer popup -->
<!-- 						<div class="pbLayerWrap" id="uiLayerPop_w02" style="width:450px"> -->
<!-- 							<div class="pbLayerHeader"> -->
<!-- 								<strong><img src="/_ui/desktop/images/academy/h1_w020500100_pop.gif" alt="안내"></strong> -->
<!-- 								<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 상세보기 닫기"></a> -->
<!-- 							</div> -->
<!-- 							<div class="pbLayerContent"> -->
<!-- 								<p class="ptxt">선택하신 룸은 다목적 룸입니다.<br/> -->
<!-- 								일반 교육장으로 사용시에는 [교육장 예약신청]을 선택하시고, 요리시연 목적으로 퀸쿡웨어를 사용시에는 [퀸쿡/파티룸 예약신청] 을 선택하시기 바랍니다.</p> -->
<!-- 								<div class="btnWrapC"> -->
<!-- 									<input type="button" class="btnBasicBL" value="교육장 예약신청" /> -->
<!-- 									<input type="button" class="btnBasicBL btnL" value="퀸쿡/파티룸 예약신청" /> -->
<!-- 								</div> -->
<!-- 							</div> -->
<!-- 						</div> -->
						<!--// layer popup -->

						<div class="roomInfo">
							<dl>
								<dt>
									<p class="tit" id="afterRoomName"></p>
									<p id="afterIntro"></p>
								</dt>
								<dd>
									<!-- @edit 2016.07.18 갤러리 형태로 수정-->
									<div class="roomImg touchSliderWrap">
										<a href="#none" class="btnPrev">이전</a>
										<a href="#none" class="btnNext">다음</a>
										<div class="touchSlider" id="touchSlider">
											<ul>
												<li>
													<img src="/_ui/desktop/images/academy/@aproom1.gif" alt="강서 AP 퀸룸" />
												</li>
												<li>
													<img src="/_ui/desktop/images/academy/@aproom1.gif" alt="강서 AP 퀸룸" />
												</li>
											</ul>
										</div>
										<div class="sliderPaging">
										</div>
									</div>
									<!-- //@edit 2016.07.18 갤러리 형태로 수정-->
								</dd>
							</dl>
							<table class="roomInfoDetail">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tr>
									<td class="title"><span class="icon1">정원</span></td>
									<td id="afterSeatcount"></td>
									<td class="title"><span class="icon2">이용시간</span></td>
									<td id="afterUseTime"></td>
								</tr>
								<tr>
									<td class="title"><span class="icon3">예약자격</span></td>
									<td id="afterRoleNote"></td>
									<td class="title"><span class="icon4">부대시설</span></td>
									<td id="afterFacility"></td>
								</tr>
							</table>
						</div>
					</section>
					<div class="btnWrapR">
						<a href="#step1" id="step1Btn" class="btnBasicBS">다음</a>
					</div>
				</div>
				<div class="result req" id="ppName"><p>강서 AP<em>|</em>비전센타 1 (170명)</p></div>
			</div>
			<% // <div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div>  %>
		</div>
		<!-- //스텝1 -->
		<!-- 스텝2 -->
		<div class="brWrap" id="step2">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_aproom_02.gif" alt="Step2/날짜, 세션" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_aproom_02_current.gif" alt="Step2/날짜, 세션-날짜 선택 후 세션을 선택하세요." /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="calenderBookWrap">
						<div class="hWrap">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_04.gif" alt="날짜선택"></h3>
							<span class="btnR"><a href="javascript:roomConfirmPop();" title="새창 열림" class="btnCont"><span>시설예약 현황확인</span></a></span>
						</div>
						<!-- 1월 jan, 2월 feb, 3월 mar, 4월 apr, 5월 may, 6월 june, 7월 july, 8월 aug, 9월 sep, 10월 oct, 11월 nov, 12월 dec -->
						<div class="calenderHeader">
						</div>
						<!-- @edit 20160701 달력 Session 삭제 및 예약가능날짜  -->
						<table class="tblBookCalendar">
						</table>
						<ul class="listWarning">
							<li>※ 날짜를 선택하시면 예약가능 시간(세션)을 확인 할 수 있습니다.</li>
							<li>※ 날짜 옆 괄호안 숫자는 예약 가능 세션 수 입니다.</li>
						</ul>
					</section>
					<section class="brSessionWrap">
						<div class="relative">
							<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_05.gif" alt="세션 선택"></h3>
							<span class="hText"><input type="checkbox" id="onlyPossibleCheck" name="" /><label for="onlyPossibleCheck">예약가능만 보기</label></span>
						</div>
						<!-- @edit 20160701 문구변경: 예약대기를 대기신청으로 변경 -->
					</section>
					<div class="btnWrapR">
						<a href="#step1" class="btnBasicGS" onclick="javascript:accordingNavagate.from2to1();">이전</a>
						<a href="#step2" id="step2Btn" class="btnBasicBS">다음</a>
					</div>
				</div>
				<div class="result"><p>날짜와 세션을 선택해 주세요.</p></div>
				<div id="sessionCheckResult" class="result lines req" style="display:none">
				</div>
			</div>
			<% // <div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
		</div>
		<!-- //스텝2 -->
		<!-- 스텝3 -->
		<div class="brWrap" id="step3">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_aproom_03.gif" alt="Step3/동의, 결제" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_aproom_03_current.gif" alt="Step3/동의, 결제 - 규정 및 주의사항에 동의해주시면 예약 및 결제가 진행됩니다." /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="brpolicyWrap">
						<div class="hWrap">
							<h2><img src="/_ui/desktop/images/academy/h2_w02_aproom_0301.gif" alt="약관 및 동의" /></h2>
							<span class="btnR"><a href="javascript:void(0);" onClick="javascript:roomIntroduceInfoPop();" title="새창 열림" class="btnCont"><span>약관 및 동의 전체보기</span></a></span>
						</div>
						<!-- @edit 20160705 이미지타이틀 교체 -->
						<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_10.gif" alt="시설교육 규정 동의" /></h3>
						<div class="agreeBox" style="height: 40px;">
							<div class="termsWrapper" tabindex="0">
								<c:out value="${clause05}" escapeXml="false" />
							</div>
						</div>
						<!-- @edit 20160701 문구 및 동의형식 변경 -->
						<div class="agreeBoxYN">
							<span>교육장(퀸룸) 운영 규정을 숙지하였으며, 규정에 동의하십니까?</span> <span class="inputR"><input type="checkbox" id="check1" name="" /><label for="check1">동의합니다.</label></span>
						</div>
						<!-- @edit 20160705 이미지타이틀 교체 -->
						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_11.gif" alt="시설교육 제품 교육 시 주의사항" /></h3>
						<div class="agreeBox" style="height: 40px;">
							<div class="termsWrapper" tabindex="0">
								<c:out value="${clause02}" escapeXml="false" />
							</div>
						</div>
						<!-- @edit 20160701 문구 및 동의형식 변경 -->
						<div class="agreeBoxYN">
							<p>주의사항을 충분히 숙지 하였으며, AP교육장 제품 교육시 상기원칙을 준수합니다.</p>
							<span class="inputR"><input type="checkbox" id="check2" name="" /><label for="check2">동의합니다.</label></span>
						</div>
						<ul class="listWarning mgtS">
							<li>※ 예약하신 시간에 예약자는 반드시 참석하셔야 사용이 가능하고, 타인에게 양도는 불가합니다.</li>
							<li>※ 미사용 혹은 사용 당일 취소 시, 취소일로부터 2주간 예약을 제한 받게 됩니다.</li>
						</ul>
					</section>
					<div class="btnWrapR">
						<a href="#step2" class="btnBasicGS" onclick="javascript:accordingNavagate.from3to2();" >이전</a>
						<a href="#step3" id="step3Btn" class="btnBasicBS">예약요청</a>
					</div>
				</div>
				<div class="result">
					<p>결제를 진행해 주세요.</p>
				</div>
				<div class="result req" style="display:none"><p>동의 완료</p></div>
			</div>
			<% //<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
		</div>
		<!-- //스텝3 -->
		<!-- 예약완료 -->
		<div class="brWrap" id="stepDone">
			<p><img src="/_ui/desktop/images/academy/brTextDone.gif" alt="예약이 완료 되었습니다. 이용해 주셔서 감사합니다." /></p>
			<div class="snsWrap">
				<!-- 20150313 : SNS영역 수정 -->
				<span class="snsLink">
					<!-- @eidt 20160627 URL 복사 삭제 -->
					<a href="#" id="snsKs" class="snsCs" onclick="javascript:tempSharing('${httpDomain}', 'kakaoStory');" title="새창열림"><span class="hide">카카오스토리</span></a>
					<a href="#" class="snsBand" onclick="javascript:tempSharing('${httpDomain}', 'band');" title="새창열림"><span class="hide">밴드</span></a>
					<a href="#" id="snsFb" class="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');" title="새창열림"><span class="hide">페이스북</span></a>
				</span>
				<!-- //20150313 : SNS영역 수정 -->
				<span class="snsText"><img src="/_ui/desktop/images/academy/sns_text.gif" alt="예약내역공유" /></span>
			</div>
			<div class="btnWrapC">
				<a href="#none" class="btnBasicGL">예약계속하기</a>
				<a href="#" onclick="javascript:accessParentPage();" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</div>
	
</section>
<form id="tempForm" name="tempForm"></form>
<form id="clauseForm" name="clauseForm"></form>
<!-- //content area | ### academy IFRAME End ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
