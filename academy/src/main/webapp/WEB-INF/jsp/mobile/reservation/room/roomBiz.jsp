<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>

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

$(document).ready(function () {
	
	$("#stepDone").hide();
	
	setPpInfoList();
	
	$("#step1Btn").click(function () {
		step1ResultRender();
		
		/* 달력을 그려! */
		calendar2(year, month);
		
		/* step2 다음 버튼 hide */
		$("#step2Btn").hide();
	});
	
	
	$("#step2Btn").click(function () {
		/* 선택된 데이터 정리해! */
		sessionCheck();
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
	
	$("#step3Btn").click(function () {
		paymentCheck();
	});
	
	/* 예약가능만 보기 */
	$("#checkAvail").change(function () {
		if($(this).prop("checked")){
			$(".fullBook").each(function () {
				$(this).hide();
			});
		}else{
			$(".fullBook").each(function () {
				$(this).show();
			});
		}
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
	
});


function setPpInfoList(){
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomBizPpInfoListAjax.do'/>"
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
					html += "<a href='javascript:void(0);' class = 'active' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:setRoomInfoList('"+ ppList[i].ppseq +"','"+ ppList[i].ppname +"');\">"+ppList[i].ppname+"</a>";
					
					this.ppSeq = ppList[i].ppseq;
					this.ppName = ppList[i].ppname;
					
					setRoomInfoList(ppList[i].ppseq, ppList[i].ppname);
					
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:setRoomInfoList('"+ ppList[i].ppseq +"','"+ ppList[i].ppname +"');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$("#ppAppend").empty();
			$("#ppAppend").append(html);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setRoomInfoList(getPpseq, getPpname){
	
	/* 선택 pp카운트 */
	this.ppCnt++;
	this.roomCnt = 0;
	
	$(".roomInfo").hide();
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".selectArea.local>a").each(function () {
		$(this).removeClass("active");
	});
	this.ppSeq = "";
	this.ppName = "";
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+getPpseq).addClass("active");
	this.ppSeq = getPpseq;
	this.ppName = getPpname;
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomEduRoomInfoListAjax.do' />"
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
					html += "<a href=\"javascript:void(0);\" class=\"active\" id=\"detailRoomSeq"+roomList[i].roomseq+"\" naem=\"detailRoomSeq\" onclick=\"javascript:detailRoom('"+roomList[i].roomseq+"', '"+roomList[i].roomname+"', '"+roomList[i].seatcount+"');\">"+roomList[i].roomname+" ("+roomList[i].seatcount+")</a>";
					detailRoom(roomList[i].roomseq, roomList[i].roomname, roomList[i].seatcount);
				}else{
					html += "<a href=\"javascript:void(0);\" id=\"detailRoomSeq"+roomList[i].roomseq+"\" naem=\"detailRoomSeq\" onclick=\"javascript:detailRoom('"+roomList[i].roomseq+"', '"+roomList[i].roomname+"', '"+roomList[i].seatcount+"');\">"+roomList[i].roomname+" ("+roomList[i].seatcount+")</a>";
				}
			}
			
			$(".selectArea.room").empty();
			$(".selectArea.room").append(html);
			
// 			$(".selectArea.room").parent().next().slideUp();
			$(".selectArea.local").parent().next().hide();
			$(".selectArea.local").parent().next().slideDown();
			
			/* resize */
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			/* move */
			moveStep.stepOneRoom();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 pp의 준비물, 이용자격 등을 조회 */
function detailRoom(getRoomseq, getRoomName, seatCount){
	
	/* 시설 선택 카운트 */
	this.roomCnt++;
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".room > a").each(function () {
		$(this).removeClass("active");
	});
	this.roomSeq = "";
	this.roomName = "";
	this.seatCount = "";
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailRoomSeq"+getRoomseq).addClass("active");
	this.roomSeq = getRoomseq;
	this.roomName = getRoomName;
	this.seatCount = seatCount;
	
	var param = {"roomseq" : this.roomSeq};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomEduRsvRoomDetailInfoAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var detailCode = data.roomEduRsvRoomDetailInfo;
			
			$(".selectArea.room").parent().next().find(".tit").empty();
			$(".selectArea.room").parent().next().find(".tit").append(detailCode.ppname + " " + detailCode.roomname);
			$(".selectArea.room").parent().next().find(".roomSubText").empty();
			$(".selectArea.room").parent().next().find(".roomSubText").append(detailCode.intro);
			
			var html = "<dt class=\"noneBdT\"><span class=\"bizIcon icon1\"></span>정원</dt>"
		         + "<dd class=\"noneBdT\">"+detailCode.seatcount+"</dd>"
		         + "<dt><span class=\"bizIcon icon2\"></span>이용시간</dt>"
		         + "<dd>"+detailCode.usetime+"</dd>"
		         + "<dt><span class=\"bizIcon icon3\"></span>예약자격</dt>"
		         + "<dd>"+detailCode.role+"<br/><span class=\"fsS\">("+detailCode.rolenote+")</span></dd>"
		         + "<dt><span class=\"bizIcon icon4\"></span>부대시설</dt>"
		         + "<dd>"+detailCode.facility+"</dd>";
		$(".selectArea.room").parent().next().find(".roomTbl").empty();
		$(".selectArea.room").parent().next().find(".roomTbl").append(html);
		
		
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
			/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
			
			$(".selectArea.room").parent().next().css("display", "block");
			$(".roomInfo").css("display", "block");
			
//				$(".selectArea.room").parent().next().slideDown(function(){
//				});
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
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
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 시설 이미지 파일 조회 */
function roomImageListAjax(fileKeys) {
	var param = {"fileKeys" : fileKeys};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomImageUrlListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var urlList = data.roomImageUrlList;
			
			var html = "";
			if(0 < urlList.length){
				for(var num in urlList){
					html += "<li><img src='/reservation/imageView.do?file="+urlList[num].storefilename+"&mode=RESERVATION' alt='"+urlList[num].roomname+"'></li>";
				}
			}else{
				html = "<li></li>";
			}
			$("#touchSlider ul").empty();
			$("#touchSlider ul").append(html);
			
			/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
			$(".selectArea.room").parent().next().show();
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			touchsliderFn();
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function step1ResultRender(){
	
	var html = this.ppName+"<em class=\"bar\">|</em>"+this.roomName+"("+this.seatCount+")";
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").empty();
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").append(html);
}


/* 다음달 캘린더의 날짜 호출 한다. */
function calendar2(year, month){
	var date = new Date();
	var year = date.getFullYear();
	var month = new String(date.getMonth()+1);

	this.year = year;
	this.month = month;

	var param = {
		"year" : this.year
		, "month" : this.month < 10 ? "0" + this.month : this.month
		, "typeseq" : this.typeSeq
		, "roomseq" : this.roomSeq
	};

	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomEduCalendarAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){

			/* 달력 년, 월 랜더링 */
			var yearMonthList = data.roomEduYearMonth;

			/* 해당 월 달력 정보 */
			var calendar = data.roomEduCalendar;

			/* 오늘 날짜 정보 (yyyymmdd) */
			var today = data.roomEduToday;

			var reservationInfoList = data.roomEduReservationInfoList;
			/*  */
			calenderHeaderRender(yearMonthList);

			/*  */
			calenderRender(calendar, today, reservationInfoList);

			this.toYear = today.ymd.substring(0, 4);
			this.toMonth = today.ymd.substring(4, 6);

			getRsvAvailabilityCount();

			moveStep.stepTwo();

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});

}

/* 다음달 캘린더의 날짜 호출 한다. */
function calendar(year, month){
		
	this.year = year;
	this.month = month;
	
	var param = {
		  "year" : this.year
		, "month" : this.month < 10 ? "0" + this.month : this.month
		, "typeseq" : this.typeSeq
		, "roomseq" : this.roomSeq
	};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomEduCalendarAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 달력 년, 월 랜더링 */
			var yearMonthList = data.roomEduYearMonth;
			
			/* 해당 월 달력 정보 */
			var calendar = data.roomEduCalendar;
			
			/* 오늘 날짜 정보 (yyyymmdd) */
			var today = data.roomEduToday;
			
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
			
			moveStep.stepTwo();

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
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

/* 캘린더 헤더 설정 */
function calenderHeaderRender(yearMonthList){
	
	var html = "";
	var tempMonth = "";
	var tempYear = "";
	
	html += "<div class=\"monthlyWrap\">";
		
	for(var num in yearMonthList){
		/* 5개월 넘어가면 stop */
		if(7 <= num){
			break;
		}
		
		if(num == 0){
			tempMonth = yearMonthList[num].month;
			tempYear = yearMonthList[num].year;
			html += "<span><span class=\"year\">"+yearMonthList[num].year+"</span>"
				 
		}else if(tempYear != yearMonthList[num].year && yearMonthList[num].month == 1){
			html += "<span><span class=\"year\">"+yearMonthList[num].year+"</span>"
		}
		
		if(this.month == yearMonthList[num].month){
			tempMonth = yearMonthList[num].month;
			
			html += "<a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"');\" class=\"on\">"+yearMonthList[num].month+"<span>月</span></a></span>";
		}else{
			html += "<a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"');\">"+yearMonthList[num].month+"<span>月</span></a></span>";
		}

		if(yearMonthList.length != num + 1){
			html += "<em>|</em>";
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
		+ "	<col style=\"width:13.5%\">"
		+ "	<col style=\"width:14.5%\" span=\"5\">"
		+ "	<col style=\"width:auto\">"
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
							+ "<span>휴무</span>";
					}else if(setCode == null || totalCnt == 0){
						html += "<td class=\"late\">"
							+ "<a href=\"javascript:void(0);\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day;
					}else if(totalCnt == rsvCnt){
						html += "<td class=\"late\">"
							+ "<a href=\"javascript:void(0);\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day
							+ "<span>예약마감</span>";
					}else{
						html += "<td class=\""+calendar[cnt].engweekday+"\">"
							+ "<a href=\"javascript:deleteSelcOnCal('"+calendar[cnt].day+"', '"+this.year+"', '"+this.month+"');\" id=\"cal"+calendar[cnt].ymd+"\">"
							+ calendar[cnt].day
							+ "<span>("+(totalCnt - rsvCnt)+")</span>";
							
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
	$(".brSessionWrap").empty();
	
	if(calendarCnt == 0){
		
		var months = $(".monthlyWrap > a").length;
		
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
		
		$("#cal"+year+tempMonth+tempDay).removeClass("selcOn");
		$("#"+year+tempMonth+tempDay).remove();
		
	/* 캘린더에 새로운 날짜를 선택한 경우 */
	}else{
		
		$("#cal"+year+tempMonth+tempDay).addClass("selcOn");
// 		$(".brSessionWrap").show();
		
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
		url: "<c:url value='/mobile/reservation/roomEduSeesionListAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var html = "";
			var seesionList = data.roomEduSeesionList;
			
			html += "<table id=\""+year+tempMonth+tempDay+"\" class=\"tblSession\">"
				+ "<caption>세션 선택</caption>"
				+ "<colgroup>"
				+ "<col width=\"5%\"/>"
				+ "<col width=\"40%\"/>"
				+ "<col width=\"auto\"/>"
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
							+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionCheckLoop(this);\"/>"
							+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
							+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
							+ "<input type=\"hidden\" class=\"sessionPrice\" value=\"무료\"/>"
							+ "<input type=\"hidden\" class=\"price\" value=\""+0+"\"/>"
							+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
							+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
							+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
							+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/></td>"
							+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\"><span class=\"able\">예약가능</span></td>"
							+ "</tr>";
					}else if(seesionList[num].standbynumber == 0
							&& renderCnt == 0
							&& 'R01' != seesionList[num].adminfirstcode){
						
						rsvsessionseq = seesionList[num].rsvsessionseq;
						
						tempStr = "<tr>"
							+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionCheckLoop(this);\"/>"
							+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
							+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"(대기신청)\"/>"
							+ "<input type=\"hidden\" class=\"sessionPrice\" value=\"무료\"/>"
							+ "<input type=\"hidden\" class=\"price\" value=\""+0+"\"/>"
							+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
							+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
							+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
							+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/></td>"
							+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\"><span class=\"able\">대기신청</span></td>"
							+ "</tr>";
							
					}else if(seesionList[num].standbynumber == 1
							 || 'R01' == seesionList[num].adminfirstcode){
						
						rsvsessionseq = seesionList[num].rsvsessionseq;
						
						tempStr += "<tr class=\"fullBook\">"
							+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"\" disabled/></td>"
							+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\"><span class=\"able\">예약마감</span></td>"
							+ "</tr>";
							
						renderCnt++;
					}
				}
			}

			if(tempStr != ""){
				html += tempStr;
			}
			
			html += "</tbody>";
			
			$(".brSessionWrap").append(html);
			
			$("#checkAvail").change();
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 세션 선택 체크  이전, 다음 버튼 on off */
function sessionCheckLoop(obj) {
	
	if($(obj).prop("checked")){
		$(obj).parents("tr").addClass("select");
	}else{
		$(obj).parents("tr").removeClass("select");
	}
	
	var cnt = 0;
	$(obj).parents(".brSessionWrap").find("input[name=sessionCheck]").each(function () {
		if($(this).prop("checked")){
			cnt++;
		}
	});
	if(cnt != 0){
		/* 이전 다음 버튼 show */
		$("#step2Btn").show();
	}else{
		/* 이전 다음 버튼 hide */
		$("#step2Btn").hide();
	}
	
}

/* 세션 선택 step3으로 이동하기 전 데이터 정리*/
function sessionCheck(){
	
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").empty();
	
	/* 예약 완료후 포커스 상단 유지 */
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	var html = "";
	var formHtml = ""
	var cnt = 0;
	var totalPrice = 0;

	var snsTitle = "";
	var snsHtml = ""; 
	
	$("input[name=sessionCheck]").each(function () {
		if($(this).prop("checked")){
			$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").append(
						"<span>"+$(this).parent("td").children(".sessionYmd").val()
						+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionName").val()
						+"<em class=\"bar\">|</em>"+$(this).parent("td").children(".sessionPrice").val()
						+"</span>"
					);
			
			snsHtml += "■"+ppName+"("+roomName+")"
				+ $(this).parent("td").children(".sessionYmd").val() + "| \n" 
				+ $(this).parent("td").children(".sessionName").val() + "\n";
			
			cnt++;
			totalPrice += parseInt($(this).parent("td").children(".price").val());
			
			if($(this).parents("tr").find(".able").text() == "대기신청"){
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
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap").children("span").empty();
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap").children("span").append(
			"총"+cnt+"건<em class=\"bar\">|</em>결제예정금액  : 무료"
		);
	
	/*------------------ sns 내용----------------------------- */
	snsTitle = "[한국암웨이]시설/체험 예약내역 (총 "+cnt+"건) \n" + snsHtml;
	
	$("#snsText").empty();
	$("#snsText").val(snsTitle);
	/*------------------------------------------------------ */
	
	$("#roomEduForm").empty();
	$("#roomEduForm").append(formHtml);


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
	
					$("#step2Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
					$("#step2Btn").parents('.bizEduPlace').find('.result').show();
					$("#step2Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
					
					//다음 섹션열기
					var $nextStep = $("#step2Btn").parents('.bizEduPlace').next();
					$nextStep.addClass('current').find('.selectDiv').slideDown();
					$nextStep.find('.result').hide();
					$nextStep.find('.selectDiv').show();
					$nextStep.find('.selcWrap>dd').show();
					
					/* resize */
					setTimeout(function(){ abnkorea_resize(); }, 500);
					
					/* move step */
					setTimeout(function(){ moveStep.stepThree(); }, 1000);
					
				}else{
					alert("예약가능 범위 또는 잔여 횟수를 초과 하였습니다. 예약가능 범위 및 잔여횟수를 확인하시고 선택해 주세요.");
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
	
	var param = $("#roomEduForm").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomBizPaymentCheckAjax.do'/>"
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

/* 예약정보 확인 (정상 진행) */
function roomBizInfoPop(){
	
	layerPopupOpen("<a href=\"#uiLayerPop_confirm\">");
	$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:roomEduReservationInsert(this);");
	
	rsvConfirmPop_resize();
	parent.$("html, body").animate({ scrollTop: 0 }, 600);
	
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform thead th").empty();
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform thead th").append($("#roomEduForm input[name=ppName]").val()+" <em>|</em> "+$("#roomEduForm input[name=roomName]").val());
	
	var html = "";
	var className = "";
	var cnt = 0;
	
	$("#roomEduForm").find("input").each(function () {
		if(className != $(this).prop("class") 
				&& null != $(this).prop("class")
				&& '' != $(this).prop("class")) {
			
			className = $(this).prop("class");
			cnt++;
			
			$("."+className).each(function () {
				if($(this).prop("name") == 'sessionYmd'){
					html += "<tr>"
						  + "	<th scope=\"row\" class=\"bdTop\">날짜</th>"
						  + "	<td class=\"bdTop\">"+$(this).val()+"</td>"
						  + "</tr>";
				}else if($(this).prop("name") == 'sessionName'){
					html += "<tr>"
						  + "	<th scope=\"row\">세션(시간)</th>"
						  + "	<td>"+$(this).val()+"</td>"
						  + "</tr>"
				}else if($(this).prop("name") == 'sessionPrice'){
					html += "<tr>"
						 +  "<th scope=\"row\">금액</th>"
						 +  "<td>무료</td>"
						 +  "</tr>";
				}else{
					
				}
			});
		}
		
		$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tbody").empty();
		$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tbody").append(html);

		$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tfoot td").empty();
		$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tfoot td").append("총 "+cnt+"건 <em>|</em> <span class=\"point1\">무료</span>");
		
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
}

/* 예약 불가 알림 팝업 노출 */
function roomBizDisablePop(cancelDataList) {
	/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
	layerPopupOpen("<a href=\"#uiLayerPop_cannot\">");
	/* 중복 데이터 삭제 */
	var html = "";
	for(var num in cancelDataList){
		var standByNumber = "";
		if(cancelDataList[num].standByNumber == "1"){
			standByNumber = "(대기신청)";
		}
		html += "<span class=\"point1\">";
		html += cancelDataList[num].ppName + " <em>|</em> ";
		html += cancelDataList[num].roomName + " <em>|</em> ";
		html += cancelDataList[num].reservationdate + " <em>|</em> ";
		html += cancelDataList[num].sessionName + standByNumber + "<br/>"
		html += "</span>";
		
		html += "<input type='hidden' name='cancelKey' value='" + cancelDataList[num].reservationdate + '_' + cancelDataList[num].rsvsessionseq + "'>";
		
		$("."+cancelDataList[num].reservationdate + cancelDataList[num].rsvsessionseq).each(function () {
			$(this).remove();
		});
		
	}
	$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").empty();
	$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").append(html);
}

/* 예약불가 팝업 확인 이벤트 */
function eduCultureDisabledConfirm(){
	
	var selectChoice = $("input:radio[name='resConfirm']:checked").val();
	
	if( selectChoice == "sessionSelect1"){
		
		/* 발견된 중복건수를 opener 페이지의 세션선택 상자에서 찾은 후 해제 시키는 기능 */
		$("#uiLayerPop_cannot input[type='hidden']").each(function(){
			$(".brSessionWrap input[type='checkbox'][id='" + $(this).val() + "'] ").prop("checked", false);
		});
	
		/* 세션 갱신 */
		sessionCheck();
		
		/* 예약 진행 */
		paymentCheck();
	}else{
		/* step2로 돌아감 */
		$("#step3Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
		$("#step3Btn").parents('.bizEduPlace').find('.result').show();
		$("#step3Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
		
		$("#step2Btn").parents("dd").show();
		$("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
		$("#step2Btn").parents(".bizEduPlace").find(".result").hide();

	}
	cannotClosePop();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 레이어 팝업 닫기 */
function cannotClosePop(){
	$("#uiLayerPop_cannot").fadeOut();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 비즈룸 등록 */
function roomEduReservationInsert(obj){
	
	$(obj).removeAttr("onclick");
	
	$("#roomEduForm").append("<input type=\"hidden\" name=\"interfaceChannel\" 	value=\"MOBILE\" />");
	$("#roomEduForm").append("<input type=\"hidden\" name=\"paymentmode\" 	value=\"normal\" />");
	
	var param = $("#roomEduForm").serialize();
	
	$.ajax({
		  url: "<c:url value='/mobile/reservation/roomEduReservationInsertAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			if ("false" == data.possibility){
				
				alert(data.reason);
				return false;
				
			} else {
				
				var totalCnt = data.totalCnt;
				if (totalCnt){
					try{

						$("#transactionTime").val(data.transactionTime);
						
						/* 팝업창 닫기 */
						confirmClosePop();
						
						/* 결과창 */
						$("#step3Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
						$("#step3Btn").parents('.bizEduPlace').find('.result').show();
						$("#step3Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
						$("#stepDone").show();
						
						setTimeout(function(){ abnkorea_resize(); }, 500);
					}catch(e){
//							console.log(e);
					}
				} else {
					alert("처리도중 오류가 발생하였습니다.");
					$(obj).attr("onclick", "javascript:roomEduReservationInsert(this);");
				}
			}

		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			$(obj).attr("onclick", "javascript:roomEduReservationInsert(this);");
		}
	});
}


/* 레이어 팝업 닫기 */
function confirmClosePop(){
	$("#uiLayerPop_confirm").hide();
	 $("#step3Btn").parents("dd").show();
	 $("#step3Btn").parents(".bizEduPlace").find(".selectDiv").show();
	 $("#step3Btn").parents(".bizEduPlace").find(".result").hide();
	 $("#layerMask").remove();
	 
		$('html, body').css({
			overflowX:'',
			overflowY:''
		});
}


/* 팝업 캘린더 기준정보 셋팅 */
function popCalenderSettingAjax() {
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/popCalenderSettingAjax.do'/>"
		, type : "POST"
		, success: function(data, textStatus, jqXHR){
			
			var yearCodeList = data.yearCodeList;
			var monthCodeList = data.monthCodeList;
			var yearMonthDay = data.yearMonthDay;
			
			/* 기준년도 생성 */
			var yearHtml = "";
			$("#year").empty();
			for(var num in yearCodeList){
				if(yearMonthDay.ymd.substring(0, 4) == yearCodeList[num]){
					yearHtml += "<option value=\""+yearCodeList[num]+"\" selected=\"selected\">"+yearCodeList[num]+"</option>";
				}else{
					yearHtml += "<option value=\""+yearCodeList[num]+"\">"+yearCodeList[num]+"</option>";
				}
			}
			$("#year").append(yearHtml);
			
			/* 기준 월 생성 */
			var monthHtml = "";
			var tempMonth = "";
			$("#month").empty();
			for(var num in monthCodeList){
				if(yearMonthDay.ymd.substring(4, 6) == monthCodeList[num]){
					monthHtml += "<option value=\""+monthCodeList[num]+"\" selected=\"selected\">"+monthCodeList[num]+"</option>";
				}else{
					monthHtml += "<option value=\""+monthCodeList[num]+"\">"+monthCodeList[num]+"</option>";
				}
			}
			$("#month").append(monthHtml);
			
			popCalenderInfoAjax($("#year").val(), $("#month").val());
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


/* 시설예약 현황확인 레이어 팝업  */
function popCalenderInfoAjax(year, month) {
	
	var param = {
			  "year" : year
			, "month" : month
			
			/* 이전달, 현재달, 다음달 예약정보 카운트 조회 파라미터 */
			, "getYear" : year
			, "getMonth" : month
			, "rsvtypecode" : "R01"
		};
		
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomCalenderInfoAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 해당 월 달력 정보 */
			var calendar = data.roomCalendar;
			
			/* 오늘 날짜 정보 (yyyymmdd) */
			var today = data.roomToday;
			
			var reservationInfoList = data.roomReservationInfoList;
			
			var monthRsvCount = data.monthRsvCount;
			
			/* 달련 렌더링 */
			popCalenderRender(calendar, today, reservationInfoList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


/* 달력 그리기 */
function popCalenderRender(calendar, today, reservationInfoList){
	
	var html = "";
	
	$("#uiLayerPop_calender").find(".tblBookCalendar tbody").empty();
	
	var cnt = 0;
	var selectYmd = "";
	for(var num = 0; num < Math.ceil((calendar.length + (calendar[0].weekday - 1))/7); num++){
		html += "<tr>";
		for(var i = 0; i < 7; i++){
			if(cnt == calendar.length){
				html += "<td></td>";
				continue;
			}
			if(calendar[cnt].weekday == (i+1+(num*7)) || cnt > 0){
				
				if(calendar[cnt].ymd == today.ymd && $("#popDay").val() == ""){
					html += " <td class=\""+calendar[cnt].engweekday+"\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <a href=\"#none\" class=\"selcOn\">"+calendar[cnt].day;
						
					$("#popDay").val("");
					$("#popDay").val(calendar[cnt].day);
					selectYmd = calendar[cnt].ymd;
				}else if(calendar[cnt].day == $("#popDay").val()){
					html += " <td class=\""+calendar[cnt].engweekday+"\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <a href=\"#none\" class=\"selcOn\">"+calendar[cnt].day;
						
					$("#popDay").val("");
					$("#popDay").val(calendar[cnt].day);
					selectYmd = calendar[cnt].ymd;
				}
				else{
					html += " <td class=\""+calendar[cnt].engweekday+"\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <a href=\"#none\">"+calendar[cnt].day;
				}
				
				var tempTypeName = "";
				var tempHtml = "";
				for(var j in reservationInfoList){
					if(reservationInfoList[j].ymd == calendar[cnt].ymd
							&& reservationInfoList[j].paymentstatuscode != null
							&& reservationInfoList[j].paymentstatuscode != "P03"
							&& reservationInfoList[j].typename != tempTypeName){
						tempTypeName = reservationInfoList[j].typename;
						if(reservationInfoList[j].typename.substring(0, 2) == "교육"){
							tempHtml += "	<em class=\"calIcon2 blue\">예약</em>";
						}else if(reservationInfoList[j].typename.substring(0, 2) == "비즈"){
							tempHtml += "	<em class=\"calIcon2 green\">예약</em>";
						}else if(reservationInfoList[j].typename.substring(0, 2) == "퀸룸"){
							tempHtml += "	<em class=\"calIcon2 red\">예약</em>";
						}
					}
				}
				if(tempHtml != ""){
					html += "<span>"+tempHtml+"<span>";
				}

				html += " </a>"
					+ " </td>";
				
				cnt++;
			}else{
				html += "<td></td>";
			}
		}
		html += "</tr>";
	}
	
	$("#uiLayerPop_calender").find(".tblBookCalendar tbody").append(html);
	
	/* 세션 정보 empty */
	$(".tblBizroomState").empty();
	
	/* 선택된 날짜 확인 후 세션 정보 조회 */
	if(selectYmd != ""){
		roomDayReservationListAjax(selectYmd);
	}else{
		roomMonthReservationListAjax();
	}
	/* 세션 정보 삭제 */
// 	$(".tblSession").remove();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
}


/* 기존 날짜 선택 리셋, 해당 날짜 선택 */
function dayCheckReset(obj, reservationDate) {
	$(".selcOn").removeClass("selcOn");
	
	$(obj).find("a").addClass("selcOn");
	$("#popDay").val($(obj).children("a").prop("innerText"));
// 	$("#popDay").val("");
// 	$("#popDay").val(calendar[cnt].day);
// 	console.log($(obj).children("div").children("em").text());
	
	roomDayReservationListAjax(reservationDate);
}

/* 예약 현황 특정 날짜 본인 예약 정보 조회 */
function roomDayReservationListAjax(reservationDate) {
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomDayReservationListAjax.do'/>"
		, type : "POST"
		, data: {"reservationDate" : reservationDate}
		, success: function(data, textStatus, jqXHR){
			
			var reservationList = data.roomReservationList;
			
			reservationRender(reservationList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


/* 예약 현황 특정 년, 월 본인 예약 정보 조회 */
function roomMonthReservationListAjax() {
	
	$(".selcOn").removeClass("selcOn");
	
	$("#popDay").val("");
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomMonthReservationListAjax.do'/>"
		, type : "POST"
		, data: {"year" : $("#year").val()
				, "month" : $("#month").val()}
		, success: function(data, textStatus, jqXHR){
			
			var reservationList = data.roomReservationList;
			
			reservationRender(reservationList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 날짜 본인 전체 예약 정보  렌더링 */
function reservationRender(reservationList) {
	
	$(".tblBizroomState").empty();
	
	var html = "";
	
	if(reservationList.length == 0){
		html = "<dt>예약내역이 없습니다.</dt>";
	}else{
		for(var num in reservationList){
			
// 			var temp = "";
			
// 			if(reservationList[num].paymentstatuscode == 'P07'
// 					|| reservationList[num].paymentstatuscode == 'P01'
// 					|| reservationList[num].paymentstatuscode == 'P02'){
// 				temp = "<a href=\"javascript:void(0);\" class=\"btnTbl\" "
// 					+ "onclick=\"javascript:roomInfoRsvCancel('"
// 					+ reservationList[num].rsvseq+"', '"+reservationList[num].roomseq+"', '"+reservationList[num].standbynumber+"');\">"
// 					+ "예약취소</a>";
// 			}
			
			html += "<dt>사용일자"
				 +  "<br/>"+reservationList[num].reservationdate.substring(0, 4)
				 +	"-"+reservationList[num].reservationdate.substring(4, 6)
				 +	"-"+reservationList[num].reservationdate.substring(6, 8)
				 +	"("+reservationList[num].weekname
				 +	") "+reservationList[num].sessionname
				 +  "("+reservationList[num].startdatetime.substring(0, 2)
				 +  ":"+reservationList[num].startdatetime.substring(2, 4)
				 +  "~"+reservationList[num].enddatetime.substring(0, 2)
				 +	":"+reservationList[num].enddatetime.substring(2, 4)
				 +	")"
// 				 +	")" + temp
			     +  "<dd>"+reservationList[num].typename+" | "
			     +  reservationList[num].ppname+" – "
			     +  reservationList[num].roomname+" <br/>상태 : "
				 +  reservationList[num].paymentname+"</dd>";
		}
	}
	
	$(".tblBizroomState").append(html);
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

function setMonth(flag){
	var tempYear;
	var tempMonth;
	
	if(flag == "post"){
		if($("#month").val() == "12"){
			tempYear = Number($("#year").val())+1;
			tempMonth = "01";
			
			$("#year").val(tempYear);
			$("#month").val(tempMonth);
		}else if($("#month").val() != "12"){
			tempYear = $("#year").val();
			tempMonth = Number($("#month").val())+1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#year").val(tempYear);
				$("#month").val(tempMonth);
			}else if(tempMonth >= 10){
				$("#year").val(tempYear);
				$("#month").val(tempMonth);
			}
		}
		
		
	}else if(flag == "pre"){
		if($("#month").val() == "01"){
			tempYear = Number($("#year").val())-1;
			tempMonth = "12";
			
			$("#year").val(tempYear);
			$("#month").val(tempMonth);
		}else if($("#month").val() != "01"){
			tempYear = $("#year").val();
			tempMonth = Number($("#month").val())-1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#year").val(tempYear);
				$("#month").val(tempMonth);
			}else if(tempMonth >= 10){
				$("#year").val(tempYear);
				$("#month").val(tempMonth);
			}
		}
	}
	
	popCalenderInfoAjax($("#year").val(), $("#month").val());
}

/* 캘린더 취소*/
function roomInfoRsvCancel(rsvseq, roomseq, standbynumber){
	var param = {"rsvseq" : rsvseq
				, "roomseq" : roomseq
				, "standbynumber" : standbynumber};
	
	if(confirm("예약을 취소 하시겠습니까?") == true){
		$.ajax({
			url: "<c:url value='/mobile/reservation/updateRoomCancelCodeAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				try{
					alert("예약이 취소되었습니다.");
					popCalenderInfoAjax($("#year").val(), $("#month").val());
				}catch(e){
//						console.log(e);
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}else{
		return false;
	}
}

/* 레이어 팝업 닫기 */
function personalClosePop(){
	$("#uiLayerPop_personal").fadeOut();
// 	 $("#step2Btn").parents("dd").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 레이어 팝업 닫기 */
function calenderClosePop(){
	$("#uiLayerPop_calender").fadeOut();
// 	 $("#step2Btn").parents("dd").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* ap 안내 */
function showApInfo(thisObj){
	
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
	
	layerPopupOpen(thisObj);

	abnkoreaApInfoPop_resize();

}

function closeApInfo(){	
	$("#uiLayerPop_apInfo").hide();
	$("#layerMask").remove();
	
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 비즈룸 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}

/**
 * 각 단계로의 이동
 */
var moveStep = {

	moveFunction : function(arg){
		/* move function */
		var $pos = eval(arg); //$("#step1OpenSelectDiv");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
	},
	
	top : function(){
		this.moveFunction("$('#pbContent')");
	},
		
	stepOne : function(){
		 this.moveFunction("$('#selectStepOne')");
	},
		
	stepOneRoom : function(){
		this.moveFunction("$('#selectStepOneRoom')");
	},
	
	stepTwo : function(){
		this.moveFunction("$('#selectStepTwo')");
	},
	
	stepThree : function(){
		this.moveFunction("$('#selectStepThree')");
	}
	
}

</script>
<div id="pbContainer">
<section id="pbContent" class="bizroom">
	<form id="roomEduForm" name="roomEduForm" method="post">
	</form>
	<input type="hidden" id="transactionTime" />
	<input type="hidden" id="snsText" name="snsText">
	<section class="brIntro">
		<h2><a href="#uiToggle_01">비즈룸 예약 필수 안내</a></h2>
		<div id="uiToggle_01" class="toggleDetail">
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</section>

	<section class="mWrap">
		<!-- 스텝1 -->
		<div class="bizEduPlace" id="selectStepOne">
			<div class="result" style="display: none;">
				<div class="tWrap">
					<em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 룸</strong>
					<span><!-- AP 설명 remdering --></span>
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 룸</strong><span>지역 선택 후 룸 타입을 선택하세요.</span></div></dt>
					<dd>
						<div class="hWrap">
							<p class="tit">지역 선택</p>
<!-- 							<a href="#none" class="btnTbl">AP안내</a> -->
							<a href="#uiLayerPop_apInfo" onclick="javascript:showApInfo(this); return false;" class="btnTbl uiApBtnOpen">
								<span>AP 안내</span>
							</a>
						</div>
						<div class="selectArea local" id="ppAppend">
						
						</div>
					</dd>
					<dd>
						<p class="tit" id="selectStepOneRoom">룸 선택</p>
						<div class="selectArea sizeM room">
						
						</div>
					</dd>
					<dd class="dashed">
						<p class="tit">강서 AP 컨퍼런스 룸 2</p>
						<div class="roomInfo">
							<!-- @edit 2016.07.18 갤러리 형태로 수정-->
							<div class="roomImg touchSliderWrap">
								<a href="#none" class="btnPrev"><img src="/_ui/mobile/images/common/ico_slidectrl_prev2.png" alt="이전"></a>
								<a href="#none" class="btnNext"><img src="/_ui/mobile/images/common/ico_slidectrl_next2.png" alt="다음"></a>
								<div class="touchSlider" id="touchSlider">
									<ul>
										<li><img src="/_ui/desktop/images/academy/ap/study_A_gs_001.jpg" alt="강서 AP 퀸룸"></li>
										<li><img src="/_ui/desktop/images/academy/ap/study_A_gs_002.jpg" alt="강서 AP 퀸룸"></li>
									</ul>
								</div>
								<div class="sliderPaging"></div>
							</div>
							<!-- //@edit 2016.07.18 갤러리 형태로 수정-->
							
							<div class="roomSubText"><!-- AP 설명 rendering --></div>
							<dl class="roomTbl">
								<!-- 시설 상세 내용 설명 rendering -->
							</dl>
						</div>
						<div class="btnWrap">
							<a href="#none" class="btnBasicBL stepBtn" id="step1Btn">다음</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- 스텝2 -->
		<div class="bizEduPlace" id="selectStepTwo">
			<div class="result" style="display: none;">
				<div class="tWrap">
					<em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜, 세션</strong>
					<span><!-- 예약건수 및 금액 rendering --></span>
					<div class="resultDetail">
						<!-- 세션 명/세션 금액 rendering -->
					</div>
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜, 세션</strong><span>날짜와 세션을 선택해 주세요.</span></div></dt>
					<dd class="" style="display: none;">
						<div class="hWrap">
							<p class="tit">날짜 선택</p>
							<a href="#uiLayerPop_calender" class="btnTbl" onclick="layerPopupOpen(this);popCalenderSettingAjax();return false;">시설예약 현황확인</a>
						</div>
						<section class="calenderBookWrap">
							<div class="calenderHeader">
							<!-- 
								<span class="year">2016</span>
								<span class="monthlyWrap">
									<a href="#none" class="on">5<span>月</span></a><em>|</em><a href="#none">6<span>月</span></a><em>|</em><a href="#none">7<span>月</span></a>
								</span>
								<div class="hText">
									잔여 횟수 rendering
								</div>
							 -->	
							</div>
							
							<table class="tblBookCalendar">

							</table>
							<ul class="listWarning mgWrap">
								<li>※ 날짜를 선택하시면 예약가능 시간(세션)을 확인 할 수 있습니다.</li>
								<li>※ 날짜 아래 괄호안 숫자는 예약 가능 세션 수 입니다.</li>
							</ul>
						</section>
						
					</dd>
					<dd style="display: none;">
						<div class="hWrap dashed">
							<p class="tit">세션 선택</p>
							<span class="hText"><input type="checkbox" id="checkAvail" name=""><label for="checkAvail">예약가능만 보기</label></span>
						</div>
						<div class="tblWrap brSessionWrap">
						
						</div>
						<div class="btnWrap aNumb2">
							<a href="#none" class="btnBasicGL" onclick="javascript:moveStep.stepOne();">이전</a>
							<a href="#none" class="btnBasicBL" id="step2Btn">다음</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- 스텝3 -->
		<div class="bizEduPlace" id="selectStepThree">
			<div class="result" style="display: none;">
				<div class="tWrap">
					<em class="bizIcon step03"></em><strong class="step">STEP3/ 동의</strong>
					<span>동의완료</span>
					<% /* <button class="bizIcon showHid">수정</button> */ %>
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step03"></em><strong class="step">STEP3/ 동의</strong><span>예약 동의를 진행해 주세요.</span></div></dt>
					<dd style="display: none;">
						<div class="hWrap personal">
							<p class="tit">약관 및 동의</p>
							<a href="#uiLayerPop_personal" class="btnTbl" onclick="layerPopupOpen(this);return false;">약관 및 동의 전체보기</a>
						</div>
						<p class="tit mgtSM">시설교육 규정 동의</p>
						<div class="agreeDiv" style="height : 45px; overflow : auto; word-wrap : break-word;">
							<c:out value="${clause05}" escapeXml="false" />
						</div>
						<div class="agreeBoxYN mgWrap">
							운영 규정을 숙지하였으며, 규정에 동의하십니까? <span class="floatR"><input type="checkbox" name="" id="check1"><label for="check1">동의합니다.</label></span>
						</div>
						<p class="tit mgtSM">시설교육 제품 교육 시 주의 사항</p>
						<div class="agreeDiv" style="height : 45px; overflow : auto; word-wrap : break-word;">
							<c:out value="${clause02}" escapeXml="false" />
						</div>
						<div class="agreeBoxYN mgWrap">
							주의사항을 충분히 숙지 하였으며, AP교육장 제품 교육시 상기원칙을 준수합니다.<span class="floatR"><input type="checkbox" name="" id="check2"><label for="check2">동의합니다.</label></span>
						</div>
						
						<div class="tblWrap">
							<ul class="listWarning mgtS">
								<li>※ 예약하신 시간에 예약자는 반드시 참석하셔야 사용이 가능하고, 타인에게 양도는 불가합니다.</li>
								<li>※ 미사용 혹은 사용 당일 취소 시, 취소일로부터 2주간 예약을 제한 받게 됩니다.</li>
							</ul>
						</div>
						
						<div class="btnWrap aNumb2">
							<a href="#none" class="btnBasicGL" onclick="javascript:moveStep.stepTwo();" >이전</a>
							<a href="#uiLayerPop_confirm" class="btnBasicBL" id="step3Btn">예약요청</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- //스텝3 -->
		
		<!-- 예약완료 -->
		<div class="stepDone selcWrap" id="stepDone">
			<div class="doneText"><strong class="point1">예약</strong><strong class="point3">이 완료 되었습니다.</strong><br>
			이용해 주셔서 감사합니다.</div>
			
			<div class="detailSns">
				<a href="#none" id="snsKt" onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"  title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
				<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
				<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');"       title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
				<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');"   title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
			</div>
			<span class="doneText">예약내역공유</span>

			<div class="btnWrap aNumb2">
				<a href="/mobile/reservation/roomBizForm.do" class="btnBasicGL">예약계속하기</a>
				<a href="/mobile/reservation/roomInfoList.do" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</section>

	<!-- layer popoup -->

	<!-- 예약정보 확인 -->
	<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_confirm">
		<div class="pbLayerHeader">
			<strong>예약정보 확인</strong>
		</div>
		<div class="pbLayerContent" style="overflow: auto;">
		
			<table class="tblResrConform">
				<colgroup><col width="30%"><col width="70%"></colgroup>
				<thead>
					<tr><th scope="col" colspan="2"><!-- PP정보 rendering --></th></tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="2"><!-- 예약건수 및 가격 rendering --></td>
					</tr>
				</tfoot>
				<tbody>
					<!-- 예약 상세 내역 rendering -->
				</tbody>
			</table>
			
			<div class="grayBox">
				위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br>
				<span class="point3">[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</span>
			</div>
			
			<div class="btnWrap aNumb2">
				<span><a href="#" class="btnBasicGL" onclick="javascript:confirmClosePop();">예약취소</a></span>
				<span><a href="#" class="btnBasicBL">예약확정</a></span>
			</div>

		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약정보 확인 -->
	
	<!-- 예약불가 알림 -->
	<div class="pbLayerPopup" id="uiLayerPop_cannot">
		<div class="pbLayerHeader">
			<strong>예약불가 알림</strong>
		</div>
		<div class="pbLayerContent">
		
			<div class="cancelWrap">
				예약 진행 중 다른 사용자가 실시간으로 <br/>아래 예약건을 이미 완료하였습니다.
				<div class="bdBox textL">
					<!--  강서 AP <em>|</em> 비전센타 1 <em>|</em> 2016-05-25 (수) <em>|</em> Session 2 (14:00~17:00)
					<strong>예약불가 항목 : </strong>
					 -->
					<span class="point1"></span>
				</div>
			</div>
			<div class="radioList">
				<span><input type="radio" id="sessionSelect1" name="resConfirm" value="sessionSelect1" checked="checked"/><label for="sessionSelect1">예약불가 세션 제외 후 예약 진행</label></span>
				<span><input type="radio" id="sessionSelect2" name="resConfirm" value="sessionSelect2" /><label for="sessionSelect2">날짜 및 세션 다시 선택 후 진행</label></span>
			</div>
			<div class="btnWrap bNumb1">
				<a href="#" class="btnBasicBL" onclick="javascript:eduCultureDisabledConfirm();">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약불가 알림 -->
		
	<!-- 시설예약 현황보기 -->
		<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_calender">
			<div class="pbLayerHeader">
				<strong>시설예약 현황확인</strong>
			</div>
			<div class="pbLayerContent">
			
				<!-- 캘린더형 -->
				<div class="viewCalendar">
					<p class="topText"><strong>총 00 개</strong>의 시설예약 내역이 있습니다.</p>
					<div class="calendarWrapper">
						
						<div class="inputBox monthlyNum">
							<p class="selectBox">
								<select id="year" class="year" title="년도">
									<option>2016</option>
								</select>
								<select id="month" class="month" title="월">
									<option>06</option>
									<option>05</option>
									<option>04</option>
								</select>
								<input type="hidden" id="popDay">
							</p>
							<a href="#" class="monthPrev" onclick="javascript:setMonth('pre')"><span class="hide">이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
							<a href="#" class="monthNext" onclick="javascript:setMonth('post')"><span class="hide">다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
						</div>
						
						<table class="tblBookCalendar">
							<caption>캘린더형 - 날짜별 시설예약가능 시간</caption>
							<colgroup>
								<col style="width:13.5%">
								<col style="width:14.5%" span="5">
								<col style="width:auto">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="weekSun">일</th>
									<th scope="col" class="weekMon">월</th>
									<th scope="col" class="weekTue">화</th>
									<th scope="col" class="weekWed">수</th>
									<th scope="col" class="weekThur">목</th>
									<th scope="col" class="weekFri">금</th>
									<th scope="col" class="weekSat">토</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="weekSun"></td>
									<td><a href="#none"></a></td>
									<td><a href="#none"></a></td>
									<td><a href="#none"></a></td>
									<td><a href="#none"></a></td>
									<td><a href="#none">1</a></td>
									<td class="weekSat"><a href="#none">2</a></td>
								</tr>
								<tr>
									<td class="weekSun">
										<a href="#none">3</a>
									</td>
									<td>
										<a href="#none">4</a>
									</td>
									<td>
										<a href="#none">5</a>
									</td>
									<td>
										<a href="#none">6</a>
									</td>
									<td>
										<a href="#none">7</a>
									</td>
									<td>
										<a href="#none">8</a>
									</td>
									<td class="weekSat">
										<a href="#none">9</a>
									</td>
								</tr>
								<tr>
									<td class="weekSun">
										<a href="#none">10</a>
									</td>
									<td>
										<a href="#none" class="selcOn">11</a>
									</td>
									<td>
										<a href="#none">12</a>
									</td>
									<td>
										<a href="#none">13</a>
									</td>
									<td>
										<a href="#none">14
										<span><em class="calIcon2 blue">예약</em></span>
										</a>
									</td>
									<td>
										<a href="#none">15
										<span><em class="calIcon2 blue">예약</em><em class="calIcon2 green">예약</em><em class="calIcon2 red">예약</em></span>
										</a>
									</td>
									<td class="weekSat">
										<a href="#none" class="selcOn">16
										<span><em class="calIcon2 blue">예약</em><em class="calIcon2 red">예약</em></span>
										</a>
									</td>
								</tr>
								<tr>
									<td class="weekSun">
										<a href="#none">17</a>
									</td>
									<td>
										<a href="#none">18</a>
									</td>
									<td>
										<a href="#none">19</a>
									</td>
									<td>
										<a href="#none">20</a>
									</td>
									<td>
										<a href="#none">21</a>
									</td>
									<td>
										<a href="#none">22</a>
									</td>
									<td class="weekSat">
										<a href="#none">23</a>
									</td>
								</tr>
								<tr>
									<td class="weekSun">
										<a href="#none" class="selcOn">24
										<span><em>예약</em></span></a>
									</td>
									<td>
										<a href="#none">25</a>
									</td>
									<td>
										<a href="#none">26</a>
									</td>
									<td>
										<a href="#none">27</a>
									</td>
									<td>
										<a href="#none">28</a>
									</td>
									<td>
										<a href="#none">29</a>
									</td>
									<td class="weekSat">
										<a href="#none">30</a>
									</td>
								</tr>
							</tbody>
						</table>
						
						<div class="tblCalendarBottom">
							<div class="resrState"> 
								<span class="calIcon2 blue"></span>교육장
								<span class="calIcon2 green"></span>비즈룸
								<span class="calIcon2 red"></span>퀸룸/파티룸
							</div>
							<div class="btnR"> <a href="#none" class="btnTbl" onclick="javascript:roomMonthReservationListAjax();">월 예약 전체보기</a></div>
						</div>
					</div>
		
					<dl class="tblBizroomState">
					</dl>
				</div>
				<!-- //캘린더형 -->
				
				<div class="btnWrap bNumb1">
					<a href="#" class="btnBasicGL" onclick="javascript:calenderClosePop();">닫기</a>
				</div>
			</div>
			<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
		<!-- //시설예약 현황보기 -->
	
	<!-- 약관 및 동의 전체보기 -->
		<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_personal">
			<div class="pbLayerHeader">
				<strong>약관 및 동의 전체보기</strong>
			</div>
			<div class="pbLayerContent">
			
				<div class="tabWrapLogical tNum2Line">
					<section class="on">
						<h2 class="tab01"><a href="#none">교육장(퀸룸)<br/> 규정 동의</a></h2>
						<div>
							<div class="borderbox">
								<div class="termsWrapper pdNone" tabindex="0">
									<c:out value="${clause05}" escapeXml="false" />
								</div>
							</div>
						</div>
					</section>
					<section class="">
						<h2 class="tab02"><a href="#none">교육장(퀸룸)<br/> 제품 교육 시 주의사항</a></h2>
						<div>
							<div class="borderbox">
								<div class="termsWrapper pdNone" tabindex="0">
									<c:out value="${clause02}" escapeXml="false" />
								</div>
							</div>
							<p class="listDot mgtS fsS">한국암웨이 뉴트리라이트 제품은 의약품이 아닌 건강기능식품으로, 제품 판매 또는 권유시 세심한 주의가 요구됩니다.</p>
						</div>
					</section>
				</div>
				
				<div class="btnWrap bNumb1">
					<a href="#" class="btnBasicGL" onclick="javascript:personalClosePop();">닫기</a>
				</div>
			</div>
			<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
		<!-- //약관 및 동의 전체보기 -->
		
		<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/apInfoPop.jsp" %>
		<!-- //layer popoup -->
		
	<!-- //layer popoup -->

</section>
</div>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
