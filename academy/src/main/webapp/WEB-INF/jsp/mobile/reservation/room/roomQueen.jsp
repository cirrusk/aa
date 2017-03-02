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

var sessionId = "";

var ppCnt = 0;
var roomCnt = 0;

var typeSeqSecond = "";

$(document.body).ready(function() {
	
	if( "localhost" != document.domain){
		document.domain="abnkorea.co.kr";
	}
	
	refreshOrderPage();
	
	$("#stepDone").hide();
	
	setPpInfoList();
	
	$("#step1Btn").click(function () {
		/* step1 결과 정리해! */
		step1ResultRender();

		/* 달력을 그려! */
		calendar2(year, month);
		
		/* step2 다음 버튼 hide */
		$("#step2Btn").hide();
		
	});
	
	$("#step2Btn").click(function () {
		/* 선택된 데이터 정리해! */
		sessionCheck();
		
		/* step3 다음 버튼 hide */
// 		$("#step3Btn").hide();
		setTimeout(function(){ abnkoreaCard_resize(); }, 500);
	});
	
	$("#step3Btn").click(function () {
		/* 중복예약 확인 ajax */
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
	
	/* 예약현황 레이어 팝업 년도 변경*/
	$("#year").change(function () {
		popCalenderInfoAjax($("#year").val(), $("#month").val());
	});
	
	/* 예약현황 레이어 팝업 월 변경*/
	$("#month").change(function () {
		popCalenderInfoAjax($("#year").val(), $("#month").val());
	});
	
	/* 예약가능만 보기 */
	$("#check1").change(function () {
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
	
	$("#eduApply").click(function () {
		
		/* 퀸룸 typeseq 초기화 */
		typeSeqSecond = "";
		
		visionCenterClosePop();
	});
	
	$("#queenApply").click(function () {
		
		/* 퀸룸 선택 */
		typeSeqSecond = typeSeq;
		
		visionCenterClosePop();
	});
	
	$("#cookMasterConfirm").click(function () {
		cookMasterConfirm();
	});
	
	/* 일반결제 - show  */
	//$("#normalPayment").show();
	//$("#securityPayment").hide();
	//$("#biznumber").parent("td").parent("tr").hide();
	//$("#birthday").parent("td").parent("tr").show();
	
	/* 안심결제  - show */
	$("#normalPayment").hide();
	$("#securityPayment").show();
	$("#biznumber").parent("td").parent("tr").hide();
	$("#birthday").parent("td").parent("tr").show();

	/* 안심결제 화면으로 구성 */
	$("input:radio[name='paymentmode']:input[value='easypay']").prop("checked", "checked");

	setTimeout(function(){ abnkorea_resize(); }, 500);
});

function setPpInfoList(){
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomQueenPpInfoListAjax.do'/>"
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
					html += "<a href='javascript:void(0);' class='active' id='detailPpSeq" + ppList[i].ppseq +"' naem=\"detailPpSeq\" onclick=\"javascript:setRoomInfoList('"+ ppList[i].ppseq +"','"+ ppList[i].ppname +"');\">"+ppList[i].ppname+"</a>";
					//<a href="#none" class="active">송도BSC</a>
					this.ppSeq = ppList[i].ppseq;
					this.ppName = ppList[i].ppname;
					
					setRoomInfoList(ppList[i].ppseq, ppList[i].ppname);
					
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' naem=\"detailPpSeq\" onclick=\"javascript:setRoomInfoList('"+ ppList[i].ppseq +"','"+ ppList[i].ppname +"');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$(".selectArea.local").empty();
			$(".selectArea.local").append(html);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setRoomInfoList(getPpseq, getPpname){
	
	/* 다목적룸 설정 값 초기화 */
	this.typeSeqSecond = "";
	
	/* 선택 pp카운트 */
	this.ppCnt++;
	this.roomCnt = 0;
	
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
	
	var farm = {"typeseq" : this.typeSeq
			, "ppseq" : this.ppSeq};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomEduRoomInfoListAjax.do' />"
		, type : "POST"
		, data: farm
		, success: function(data, textStatus, jqXHR){
			var roomList = data.rsvRoomInfoList;
			var lastRoom = data.searchLastRsvRoom;
			
			year = roomList[0].year;
			month = roomList[0].month;
			
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
			
			/* move to step */
			moveStep.stepOneRoom();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 pp의 준비물, 이용자격 등을 조회 */
function detailRoom(getRoomseq, getRoomName, seatCount){
	
	/* 다목적룸 설정 값 초기화 */
	this.typeSeqSecond = "";
	
	/* 시설 선택 카운트 */
	this.roomCnt++;
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".selectArea.room>a").each(function () {
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
	
	$.ajaxCall({
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
				$(".selectArea.room").parent().next().show();
// 				$(".selectArea.room").parent().next().slideDown(function(){
// 				});
				
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
			
			/* 다목적 룸 확인 */
			multipurposeRoomCheck();
			
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
		url: "<c:url value='/mobile/reservation/roomImageUrlListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var urlList = data.roomImageUrlList;
			
			var html = "";
			if(0 < urlList.length){
				for(var num in urlList){
// 					html += "<li><img src=\"/reservation/imageView.do?file="+urlList[num].storefilename+"&mode=RESERVATION+"\" alt="+urlList[num].roomname+" /></li>";
					html += "<li><img src='/reservation/imageView.do?file="+urlList[num].storefilename+"&mode=RESERVATION' alt="+urlList[num].roomname+" /></li>";
				}
			}else{
				html = "<li></li>";
			}
			$("#touchSlider ul").empty();
			$("#touchSlider ul").append(html);
			
			/* 해당 시설선택시 중비물&사진등 을 담고있는 화면 활성화 */
			$(".selectArea.room").parent().next().show();
// 			$(".selectArea.room").parent().next().slideDown(function(){
// 			});
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
			
			touchsliderFn();
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 다목적 룸 확인 */
function multipurposeRoomCheck(){
	
	var param = {"roomseq" : this.roomSeq};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/multipurposeRoomCheckAjax.do'/>"
		, type : "POST"
		, data : param
		, async : false
		, success: function(data, textStatus, jqXHR){
			multipurposeRoomTypeList = data.multipurposeRoomTypeList;
			if(1 == multipurposeRoomTypeList.length){
				
			}else if(2 == multipurposeRoomTypeList.length){
				
				/* 퀸룸 typeseq 전역변수에 저장 */
				for(var num in multipurposeRoomTypeList){
					if(multipurposeRoomTypeList[num].typeflag == 'E'){
						typeSeqSecond = multipurposeRoomTypeList[num].typeseq;
					}
				}
				
				/* 레이어팝업 오픈 */
				layerPopupOpen("<a href=\"#uiLayerPop_visionCenter\">", "150px");
				moveStep.top();
			}
		}
		, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* step1Btn 닫기 버튼 클릭시 step1의 결과값 렌더링 */
function step1ResultRender() {
	
	var html = this.ppName+"<em class=\"bar\">|</em>"+this.roomName+"("+this.seatCount+")";
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").empty();
	$("#step1Btn").parents(".bizEduPlace").find(".result > .tWrap > span").append(html);
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}


/* 다음달 캘린더의 날짜 호출 한다. */
function calendar(year, month){
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
			var partitionRoomFirstRsvList = data.partitionRoomFirstRsvList;
			var partitionRoomSecondRsvList = data.partitionRoomSecondRsvList;
			/*  */
			calenderHeaderRender(yearMonthList);

			/*  */
			calenderRender(calendar, today, reservationInfoList, partitionRoomFirstRsvList, partitionRoomSecondRsvList);

			this.toYear = today.ymd.substring(0, 4);
			this.toMonth = today.ymd.substring(4, 6);

			/* 요리명장 무료쿠폰 갯수 조회 */
			if($("#cookMaster").val() && (typeSeqSecond == "" || typeSeqSecond == typeSeq)){
				getCookMasterCoupon(year, month < 10 ? "0" + month : month);
			}

			getRsvAvailabilityCount();

			/* move to step */
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
			var partitionRoomFirstRsvList = data.partitionRoomFirstRsvList;
			var partitionRoomSecondRsvList = data.partitionRoomSecondRsvList;
			/*  */
			calenderHeaderRender(yearMonthList);
			
			/*  */
			calenderRender(calendar, today, reservationInfoList, partitionRoomFirstRsvList, partitionRoomSecondRsvList);
			
			this.toYear = today.ymd.substring(0, 4);
			this.toMonth = today.ymd.substring(4, 6);
			
			/* 요리명장 무료쿠폰 갯수 조회 */
			if($("#cookMaster").val() && (typeSeqSecond == "" || typeSeqSecond == typeSeq)){
				getCookMasterCoupon(year, month < 10 ? "0" + month : month);
			}
			
			getRsvAvailabilityCount();
			
			/* move to step */
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
	
// 	html += "<span class=\"year\">"
// 		+ yearMonthList[0].year
// 		+ "</span>"
// 		+ "<span class=\"monthlyWrap\">";
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
		
		
// 		if(this.month == yearMonthList[num].month){
// 			tempMonth = yearMonthList[num].month;
// 			html += "<a href=\"javascript:void(0);\" class=\"on\">"+yearMonthList[num].month+"<span>월</span></a>";
// 		}else{
// 			html += "<a href=\"javascript:calendar('"+yearMonthList[num].year+"', '"+yearMonthList[num].month+"');\">"+yearMonthList[num].month+"<span>월</span></a>";
// 		}
		
		if(yearMonthList.length != num + 1){
			html += "<em>|</em>";
		}
	}
	
	html += "</div>"
		+ "<div class=\"hText availabilityCount\">"
		+ "</div>";
	
	
	$(".calenderHeader").empty();
	$(".calenderHeader").append(html);
	
// 	getRemainDayByMonth();
	
}

/* 달력 그리기 */
function calenderRender(calendar, today, reservationInfoList, partitionRoomFirstRsvList, partitionRoomSecondRsvList){
	
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
	
// 	for(var i = 0; i < calendar.length; i++){
// 		html += "<tr>"
// 			+ "		<td class=\"weekSun\">"
// 			+ "			<a href=\"javascript:void(0);\" id=\"cal"+calendar[i].weekSun+"\""
// 			+ "			onclick=\"javascript:deleteSelcOnCal('"+this.year+"', '"+this.month+"', '"+calList[i].weekSun"');\">"
// 			+ 			calList[i].weekSun+"</a>"
// 			+ "		</td>"
// 			+ "</tr>";
// 	}

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
							
							if(partitionRoomFirstRsvList != null && partitionRoomFirstRsvList.length != 0) {
								if(partitionRoomFirstRsvList != null
										&& partitionRoomFirstRsvList.length != 0
										&& partitionRoomFirstRsvList[j].ymd == calendar[cnt].ymd
										&& partitionRoomFirstRsvList[j].settypecode == setCode
										&& partitionRoomFirstRsvList[j].worktypecode == workCode
										&& partitionRoomFirstRsvList[j].temp == temp){
									rsvCnt += partitionRoomFirstRsvList[j].rsvcnt;
								}
							}
							
							if(partitionRoomSecondRsvList != null && partitionRoomSecondRsvList.length != 0) {
								if(partitionRoomSecondRsvList != null
										&& partitionRoomSecondRsvList.length != 0
										&& partitionRoomSecondRsvList[j].ymd == calendar[cnt].ymd
										&& partitionRoomSecondRsvList[j].settypecode == setCode
										&& partitionRoomSecondRsvList[j].worktypecode == workCode
										&& partitionRoomSecondRsvList[j].temp == temp
										&& partitionRoomSecondRsvList[j].rsvcnt == 0){
									rsvCnt += partitionRoomSecondRsvList[j].rsvcnt;
								}
							}
							
							
							rsvCnt += reservationInfoList[j].rsvcnt;
							totalCnt++;
						}
					}
					
// 					console.log("ymd="+calendar[cnt].ymd+" totalCnt="+totalCnt+" rsvCnt="+rsvCnt+" setCode="+setCode+" workCode="+workCode);
					
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

/* 요리명장 사용가능 무료쿠폰 갯수 조회 */
function getCookMasterCoupon(year, month) {
	var param = {
			  "year" : year
			, "month" : month
		};
		
		$.ajaxCall({
			url: "<c:url value='/reservation/getCookMasterCouponAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				$("#couponCount").val(data.getCookMasterCoupon.couponcount);
				
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
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
			var partitionRoomFirstSessionList = data.partitionRoomFirstSessionList;
			var partitionRoomSecondSessionList = data.partitionRoomSecondSessionList;
			
			html += "<table id=\""+year+tempMonth+tempDay+"\" class=\"tblSession\">"
				+ "<caption>세션 선택</caption>"
				+ "<colgroup>"
				+ "<col width=\"5%\"/>"
				+ "<col width=\"auto\"/>"
				+ "<col width=\"140px\"/>"
				+ "</colgroup>"
				+ "<thead>"
				+ "<tr>"
				+ "<th scope=\"col\" colspan=\"4\">"+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")<a href=\"javascript:deleteSelcOnCal('"+day+"', '"+year+"', '"+month+"')\" class=\"btnDel\">삭제</a></th>"
				+ "</tr>"
				+ "</thead>"
				+ "<tbody>";
			
			var temp = "";
			var settypecode = "";
			for(var num in seesionList){
				if(settypecode == "" && seesionList[num].settypecode != null){
					temp = seesionList[num].temp;
					settypecode = seesionList[num].settypecode;
				}
				if(seesionList[num].settypecode == settypecode
					&& seesionList[num].temp == temp
					&& typeSeqSecond == ""){
					if((seesionList[num].paymentstatuscode != null
							&& (partitionRoomFirstSessionList == null
								|| partitionRoomFirstSessionList.length == 0)
							&& (partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0))
						||(partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0
							&& (partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0)
							&& (partitionRoomFirstSessionList[num].paymentstatuscode != null
								|| seesionList[num].paymentstatuscode != null))
						||(partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0
							&& partitionRoomSecondSessionList != null
							&& partitionRoomSecondSessionList.length != 0
							&& (seesionList[num].paymentstatuscode != null
								|| partitionRoomFirstSessionList[num].paymentstatuscode != null
								|| partitionRoomSecondSessionList[num].paymentstatuscode != null))){
						html += "<tr class=\"fullBook\">"
							+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/></td>"
							+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\"><span>예약마감</span></td>"
							+ "</tr>";
					}else{
						if(seesionList[num].queendiscountprice == 0 
								|| seesionList[num].queendiscountprice == null){
							html += "<tr id=\""+year+tempMonth+tempDay+seesionList[num].rsvsessionseq+"\">"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:cookMasterCheck(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].queenprice)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].queenprice+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].queenprice+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].queendiscountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"flag\" value=\"true\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+ "</td>"
								+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].queenprice)+"원</td>"
								+ "</tr>";
						}else{
							html += "<tr id=\""+year+tempMonth+tempDay+seesionList[num].rsvsessionseq+"\">"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:cookMasterCheck(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].queendiscountprice)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].queendiscountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].queenprice+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].queendiscountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"flag\" value=\"true\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+ "</td>"
								+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].queenprice)+"원</span><span><em>할인</em>"+setComma(seesionList[num].queendiscountprice)+"원</span></td>"
								+ "</tr>";
						}
					}
				}else if(seesionList[num].settypecode == settypecode
					&& seesionList[num].temp == temp
					&& typeSeqSecond == typeSeq){
					if((seesionList[num].paymentstatuscode != null
							&& (partitionRoomFirstSessionList == null
								|| partitionRoomFirstSessionList.length == 0)
							&& (partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0))
						||(partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0
							&& (partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0)
							&& (partitionRoomFirstSessionList[num].paymentstatuscode != null
								|| seesionList[num].paymentstatuscode != null))
						||(partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0
							&& partitionRoomSecondSessionList != null
							&& partitionRoomSecondSessionList.length != 0
							&& (seesionList[num].paymentstatuscode != null
								|| partitionRoomFirstSessionList[num].paymentstatuscode != null
								|| partitionRoomSecondSessionList[num].paymentstatuscode != null))){
						html += "<tr class=\"fullBook\">"
							+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/></td>"
							+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\"><span>예약마감</span></td>"
							+ "</tr>";
					}else{
						if(seesionList[num].queendiscountprice == 0 
								|| seesionList[num].queendiscountprice == null){
							html += "<tr id=\""+year+tempMonth+tempDay+seesionList[num].rsvsessionseq+"\">"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:cookMasterCheck(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].queenprice)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].queenprice+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].queenprice+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].queendiscountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"flag\" value=\"true\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+ "</td>"
								+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].queenprice)+"원</td>"
								+ "</tr>";
						}else{
							html += "<tr id=\""+year+tempMonth+tempDay+seesionList[num].rsvsessionseq+"\">"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:cookMasterCheck(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].queendiscountprice)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].queendiscountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].queenprice+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].queendiscountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"flag\" value=\"true\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+ "</td>"
								+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].queenprice)+"원</span><span><em>할인</em>"+setComma(seesionList[num].queendiscountprice)+"원</span></td>"
								+ "</tr>";
						}
					}
				}else if(seesionList[num].settypecode == settypecode
						&& seesionList[num].temp == temp
						&& typeSeqSecond != ""
						&& typeSeqSecond != typeSeq){
					if((seesionList[num].paymentstatuscode != null
							&& (partitionRoomFirstSessionList == null
								|| partitionRoomFirstSessionList.length == 0)
							&& (partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0))
						||(partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0
							&& (partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0)
							&& (partitionRoomFirstSessionList[num].paymentstatuscode != null
								|| seesionList[num].paymentstatuscode != null))
						||(partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0
							&& partitionRoomSecondSessionList != null
							&& partitionRoomSecondSessionList.length != 0
							&& (seesionList[num].paymentstatuscode != null
								|| partitionRoomFirstSessionList[num].paymentstatuscode != null
								|| partitionRoomSecondSessionList[num].paymentstatuscode != null))){
						html += "<tr class=\"fullBook\">"
							+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/></td>"
							+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
							+ "<td class=\"price\"><span>예약마감</span></td>"
							+ "</tr>";
					}else{
						if(seesionList[num].discountprice == 0 
								|| seesionList[num].discountprice == null){
							html += "<tr>"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionCheckLoop(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].price)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].price+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].price+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].discountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+ "</td>"
								+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].price)+"원</td>"
								+ "</tr>";
						}else{
							html += "<tr>"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionCheckLoop(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].discountprice)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].discountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].price+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].discountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+ "</td>"
								+ "<td>"+seesionList[num].sessionname+"<br/>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].price)+"원</span><span><em>할인</em>"+setComma(seesionList[num].discountprice)+"원</span></td>"
								+ "</tr>";
						}
					}
				}
			}

			html += "</tbody>"
				+ "</table>";
			
			$(".brSessionWrap").append(html);
			
			$("#check1").change();
			
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


/* 세션 체크 
	- 요리명장 체크
	- 남은 횟수 체크
	- 무료, 유료 선택 팝업 open
*/
function cookMasterCheck(obj) {
	
	var flagCnt = 0;
	
	$(".brSessionWrap .flag").each(function () {
		if($(this).val() == "false"){
			flagCnt++;
		}
	});
	
	if($("#cookMaster").val() == "true" 
			&& $("#couponCount").val() - flagCnt > 0
			&& $(obj).prop("checked")){
		
		this.sessionId = $(obj).parent("td").parent("tr").prop("id");
		
		$(obj).prop("checked", false);
		
		$("#rado1").prop("checked", true);
		
		layerPopupOpen("<a href=\"#uiLayerPop_w03\">");
		
	}else if($("#cookMaster").val() == "true" 
		&& !($(obj).prop("checked"))
		&& $(obj).parent("td").children(".flag").val() == "false"){
		/* 요리명장 true, 체크박스 false, obj.parent.children flag true */
		
		/* price 금액 text 원상복구 , flag true 
		setComma(seesionList[num].price)*/
		if($(obj).parent("td").children(".discountPrice").val() != 0 && $(obj).parent("td").children(".discountPrice").val() != null){
			$(obj).parent("td").parent("tr").children(".price").html(
					"<span class=\"throught\">"+setComma($(obj).parent("td").children(".tempPrice").val())+"원</span><span><em>할인</em>"+setComma($(obj).parent("td").children(".discountPrice").val())+"원</span>"
				);
		}else{
			$(obj).parent("td").parent("tr").children(".price").html(setComma($(obj).parent("td").children(".price").val()) + "원");
		}
		$(obj).parent("td").children(".flag").val("true")
		
		$(obj).parents("tr").removeClass("select");
		
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
	}else{
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
	
// 	alert($(obj).prop("checked"));
	
}

/* 요리명장 유료, 무료  예약 체크  */
function cookMasterConfirm() {
	w03ClosePop();
	
	/* 체크박스 true */
	$("#"+this.sessionId).children("td").children("input[name=sessionCheck]").prop("checked", true);
	
	/* 무료, 유료 체크 */
	if($("input[name=rado1]:checked").prop("id") == "rado1"){
		/* 무료 - 금액 text "무료" */
		$("#"+this.sessionId).children(".price").text("무료");
		/* 무료 - flag false */
		$("#"+this.sessionId).find(".flag").val("false");
	}else{
		/* 유료 - 금액 text 변동없음 */
		/* 유료 - flag 변동없음 */
	}
	
	$("#"+this.sessionId).addClass("select");
	
	var cnt = 0;
	$("#"+this.sessionId).parents(".brSessionWrap").find("input[name=sessionCheck]").each(function () {
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
	/* 예약 완료후 포커스 상단 유지 */
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").empty();
	
	var html = "";
	var formHtml = ""
	var cnt = 0;
	var totalPrice = 0;

	var snsTitle = "";
	var snsHtml = ""; 
	
	$("input[name=sessionCheck]").each(function () {
		if($(this).prop("checked")){
			if(typeSeqSecond == "" || typeSeqSecond == typeSeq){
				if($(this).parent("td").children(".flag").val() == "false"){
					$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").append(
							"<span>"+$(this).parent("td").children(".sessionYmd").val()
							+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionName").val()
							+"<em class=\"bar\">|</em>무료</span>"
						);
					cnt++;
					
					formHtml += "<input type=\"hidden\" name=\"typeSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+typeSeq+"\"/>"
							+ "<input type=\"hidden\" name=\"ppSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppSeq+"\"/>"
							+ "<input type=\"hidden\" name=\"ppName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppName+"\"/>"
							+ "<input type=\"hidden\" name=\"roomSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomSeq+"\"/>"
							+ "<input type=\"hidden\" name=\"roomName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomName+"\"/>"
							+ "<input type=\"hidden\" name=\"sessionYmd\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionYmd").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"sessionName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionName").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"sessionPrice\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"무료\"/>"
							+ "<input type=\"hidden\" name=\"reservationDate\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".reservationdate").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"rsvSessionSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".rsvSessionSeq").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"startDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".startDateTime").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"endDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".endDateTime").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"price\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+0+"\"/>"
							+ "<input type=\"hidden\" name=\"cookMasterCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"R01\"/>"
							+ "<input type=\"hidden\" name=\"standByNumber\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"0\"/>"
							+ "<input type=\"hidden\" name=\"paymentStatusCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"P07\"/>";
				}else{
					$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").append(
							"<span>"+$(this).parent("td").children(".sessionYmd").val()
							+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionName").val()
							+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionPrice").val()+"</span>"
						);
					cnt++;
					totalPrice += parseInt($(this).parent("td").children(".price").val());
					
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
							+ "<input type=\"hidden\" name=\"paymentStatusCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"P07\"/>";
				}

			}else{
				if($(this).parent("td").children(".flag").val() == "false"){
					$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").append(
							"<span>"+$(this).parent("td").children(".sessionYmd").val()
							+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionName").val()
							+"<em class=\"bar\">|</em>무료</span>"
						);
					cnt++;
					
					formHtml += "<input type=\"hidden\" name=\"typeSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+typeSeqSecond+"\"/>"
							+ "<input type=\"hidden\" name=\"ppSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppSeq+"\"/>"
							+ "<input type=\"hidden\" name=\"ppName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+ppName+"\"/>"
							+ "<input type=\"hidden\" name=\"roomSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomSeq+"\"/>"
							+ "<input type=\"hidden\" name=\"roomName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+roomName+"\"/>"
							+ "<input type=\"hidden\" name=\"sessionYmd\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionYmd").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"sessionName\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".sessionName").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"sessionPrice\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"무료\"/>"
							+ "<input type=\"hidden\" name=\"reservationDate\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".reservationdate").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"rsvSessionSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".rsvSessionSeq").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"startDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".startDateTime").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"endDateTime\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+$(this).parent("td").children(".endDateTime").val()+"\"/>"
							+ "<input type=\"hidden\" name=\"price\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+0+"\"/>"
							+ "<input type=\"hidden\" name=\"cookMasterCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"R01\"/>"
							+ "<input type=\"hidden\" name=\"standByNumber\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"0\"/>"
							+ "<input type=\"hidden\" name=\"paymentStatusCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"P07\"/>";
				}else{
					$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap .resultDetail").append(
							"<span>"+$(this).parent("td").children(".sessionYmd").val()
							+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionName").val()
							+"<em class=\"bar\">|</em> "+$(this).parent("td").children(".sessionPrice").val()+"</span>"
						);
					cnt++;
					totalPrice += parseInt($(this).parent("td").children(".price").val());
					
					formHtml += "<input type=\"hidden\" name=\"typeSeq\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\""+typeSeqSecond+"\"/>"
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
							+ "<input type=\"hidden\" name=\"paymentStatusCode\" class=\""+$(this).parent("td").children(".reservationdate").val()+$(this).parent("td").children(".rsvSessionSeq").val()+"\" value=\"P07\"/>";
				}
			}
			
			snsHtml += "■"+ppName+"("+roomName+")"
				+ $(this).parent("td").children(".sessionYmd").val() + "| \n" 
				+ $(this).parent("td").children(".sessionName").val() + "\n";
			
		}
	});
	
	if(cnt == 0){
		alert("세션을 선택 후 다음으로 진행 가능합니다.");
		return;
	}
	
	/* order 주문 페이지에 넘길 금액 파라미터 */
	$("#currentAmount").val(totalPrice);
	
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap").children("span").empty();
	$("#step2Btn").parents(".bizEduPlace").find(".result .tWrap").children("span").append(
			"총"+cnt+"건<em class=\"bar\">|</em>결제예정금액  : "+setComma(totalPrice)+"원"
		);
	
	/*------------------ sns 내용----------------------------- */
	snsTitle = "[한국암웨이]시설/체험 예약내역 (총 "+cnt+"건) \n" + snsHtml;
	
	$("#snsText").empty();
	$("#snsText").val(snsTitle);
	/*------------------------------------------------------ */
	
	
	$("#roomEduForm").empty();
	$("#roomEduForm").append(formHtml);
	
	$("#totalPrice").text("");
	$("#totalPrice").text( setComma(totalPrice)+"원(VAT포함)");
	
	/* 결제금액 30만원 넘는 경우 일반결재 disabled */
	if(totalPrice >= 300000){
		$("#radio2").prop("disabled", true);
		$("#paymentMode-2").css("text-decoration", "line-through");
	}else{
		$("#radio2").prop("disabled", false);
		$("#paymentMode-2").css("text-decoration", "none");
	}
	
	/* 결제 예정 금액이 0이면 결제 태그 숨김 */
	if(totalPrice == 0){
		$(".creditWrap").hide();
	}else{
		$(".creditWrap").show();
		/* 해당 시설 패널티 정보 조회 */
		$.ajaxCall({
			  url: "<c:url value='/reservation/searchRoomPayPenaltyAjax.do'/>"
			, type : "POST"
			, data: {"roomseq" : roomSeq}
			, success: function(data, textStatus, jqXHR){
				
				if(null == data.searchRoomPayPenalty){
					$("#penaltyInfo").hide();
				}else{
					$("#penaltyInfo").show();
					$("#penaltyInfo").empty();
					$("#penaltyInfo").append("※ 사용일 "+data.searchRoomPayPenalty.typevalue+"일 이내 취소 시 결제 금액의 <strong style=\"color: red;\">"+data.searchRoomPayPenalty.applytypevalue+"%의 취소 수수료</strong> 제외 후 환불 처리됩니다.");
				}

			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
	
 	$("#totalPrice").text("");
 	$("#totalPrice").text( setComma(totalPrice)+"원(VAT포함)");

	/* 누적 예약 잔여 횟수 유효성 검사*/
	/* typeseq, ppseq, roomseq 일, 주, 월 예약 가능 횟수 조회 변수*/
	if('' == typeSeqSecond || typeSeq == typeSeqSecond){
		$("#roomEduForm").append("<input type=\"hidden\" name=\"typeseq\" value=\""+typeSeq+"\">");
	}else{
		$("#roomEduForm").append("<input type=\"hidden\" name=\"typeseq\" value=\""+typeSeqSecond+"\">");
	}
	$("#roomEduForm").append("<input type=\"hidden\" name=\"ppseq\" value=\""+ppSeq+"\">");
	$("#roomEduForm").append("<input type=\"hidden\" name=\"roomseq\" value=\""+roomSeq+"\">");
	
	/* 패널티 유효성 중간 검사 */
	if(middlePenaltyCheck()){
		
		$.ajaxCall({
			  url: "<c:url value='/reservation/cookMasterRsvAvailabilityCheckAjax.do'/>"
			, type : "POST"
			, data: $("#roomEduForm").serialize()
			, success: function(data, textStatus, jqXHR){
				if(data.cookMasterRsvAvailabilityCheck){
					
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
								
								/* resizing */
								setTimeout(function(){ abnkorea_resize(); }, 500);
								
								/* move */
								setTimeout(function(){ moveStep.stepThree(); }, 1000);
								
							}else{
								alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
							}
	
						}, error: function( jqXHR, textStatus, errorThrown) {
							var mag = '<spring:message code="errors.load"/>';
							alert(mag);
						}
					});
					
				}else{
					alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.(요리명장)");
				}
	
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
	
	/* resizing */
 	setTimeout(function(){ abnkorea_resize(); }, 500);
 	moveStep.stepThree();
	
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

/**
 * 결제방식 변경
 */
function paymentChange(obj){
	if($(obj).prop("class") == "radio1"){
		$("#normalPayment").hide();
		$("#securityPayment").show();
		$("#securityPayment").find(".radio1").prop("checked", "checked");
	}else{
		$("#normalPayment").show();
		$("#securityPayment").hide();
		$("#normalPayment").find(".radio2").prop("checked", "checked");
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
	}
}

/**
 * 개인카드, 법인카드 선택시 항목 변경
 */
function cardChange(obj) {
	if($(obj).prop("id") == "radio3"){
		$("#birthday").parent("td").parent("tr").show();
		$("#biznumber").parent("td").parent("tr").hide();
	}else{
		$("#birthday").parent("td").parent("tr").hide();
		$("#biznumber").parent("td").parent("tr").show();
	}
}

function paymentCheck(){
	
	/* 예약 충돌의 로직이 본문의 내용을 삭제 하게 되어 예약건수가 0개 생기는 경우에 대한 방어 */
	if( 0 >= $("#roomEduForm input[type=hidden][name='rsvSessionSeq']").length ){
		alert("예약할 시설이 없습니다.");
		return;
	}
		
	/* 약관동의 체크 확인 */
	if ( !$("#agreement1").is(":checked") ){
		alert("교육장(퀸룸) 규정 동의를 체크하여 주세요.");
		return;
	}
	
	if ( !$("#agreement2").is(":checked") ){
		alert("교육장(퀸룸) 제품 교육 시 주의 사항을 체크하여 주세요.");
		return;
	}
	
	/* 결재금액이 0이 아닌경우에만 체크 */
	if('block' == $(".creditWrap").css("display")){
		if ( !$("#agreement3").is(":checked") ){
				alert("결제정보에 대한 동의를 체크하여 주세요.");
			return;
		}
		
		if ( !$("#agreement4").is(":checked") ){
			alert("개인정보 수집/이용에 대한 동의를 체크하여 주세요.");
			return;
		}
		
		var paymentMode = $("input:radio[name='paymentmode']:checked").val();
        
        moveStep.top();
		
		/* 일반결제 입력폼 유효성 체크 */
		if ( "normal" == paymentMode ){
			
			if ( '' == $("#bankid").val() ) {
				alert("카드종류를 입력해 주세요.");
				return;
			}
			
	 		if ( '' == $("#cardnumber1").val()
					|| '' == $("#cardnumber2").val()
					|| '' == $("#cardnumber3").val()
					|| '' == $("#cardnumber4").val() ) {
	 			
				alert('카드번호를 입력해 주세요.');
				return;
				
			} else if (4 != $("#cardnumber1").val().length
	 				|| 4 != $("#cardnumber2").val().length
	 				|| 4 != $("#cardnumber3").val().length ){
				
 				alert('카드번호는 4자리 입니다.');
 				return;
 				
 			} else if ( 4 < $("#cardnumber4").val().replace( /(\s*)/g, "" ).length ) {
	 			
	 			alert('1~4자리를 입력해 주세요');
	 			$("#cardnumber4").focus();
 				return;
 				
	 		}
			
			if ( '' == $("#cardmonth").val() ) {
				if (2 != $("#cardmonth").val().length){
					alert("유효기간은 2자리 입니다.");
					return;
				}
				alert("유효기간-(월)을 입력해 주세요.");
				return;
			}
			
			if ( '' == $("#cardmonth").val() ) {
				if (2 != $("#cardmonth").val().length){
					alert("유효기간은 2자리 입니다.");
					return;
				}
				alert("유효기간-(년)을 입력해 주세요.");
				return;
			}
			
			if ( '' == $("#cardpassword").val() ) {
				if (2 != $("#cardmonth").val().length){
					alert("비밀번호는 2자리 입니다.");
					return;
				}
				alert("카드 비밀번호를 입력해 주세요.");
				return;
			}
			
			var cardowner = $("input:radio[name='cardowner']:checked").val();
			
			if( 'personal' == cardowner){
				if ( '' == $("#birthday").val() ) {
					if (6 != $("#birthday").val().length){
						alert("생년월일은 6자리 입니다.");
						return;
					}
					alert("생년월일 값은 필수입니다.");
					return;
				}
			}else if ( $(".radio4").prop("checked", true) ){
				if ( '' == $("#biznumber").val() ) {
					if (10 != $("#biznumber").val().length){
						alert("사업자등록번호는 10자리 입니다.");
						return;
					}
					alert("사업자등록번호 값은 필수입니다.");
					return;
				}
			}
			
		} else if ("easypay" == paymentMode) {	/* 안심결제 입력폼 유효성 체크 */
			
		} else {
			// 결제가 없는 경우
		}
		
	}

	//var costNoCost = $("input:radio[name='rado1']:checked").val();
	var costNoCost = '';
	var currentAmout = parseInt( $("#currentAmount").val() );
	
	if( currentAmout == 0 || currentAmout == '') {
		costNoCost = "nocost";
	}
	
	var paymentMode = $("input:radio[name='paymentmode']:checked").val();
	
	
	if("nocost" == costNoCost) {
		
		/* 무료 예약 */
		var formHtml = ""
			formHtml +="<input type=\"hidden\" name=\"interfaceChannel\" 	value=\"MOBILE\" />";
		
		/* roomEduAppendCardForm = roomEduForm + 결제정보 */
		$("#roomEduAppendCardForm").empty();
		
		$("#roomEduForm").find("input[type=hidden]").each(function() {
	        var el_name = $(this).attr('name');
	        var el_value = $(this).val();
	        $("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name +"' value='" + el_value + "' />");
	    })
		
		$("#roomEduAppendCardForm").append(formHtml);
		//console.log($("#roomEduAppendCardForm").html());
		
		var param = $("#roomEduAppendCardForm").serialize();
	
		/* 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인 */
		//$.ajaxCall({
		$.ajaxCall({
			url: "<c:url value='/mobile/reservation/roomEduPaymentCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				var cancelDataList = data.canceDataList;
				
				if(cancelDataList.length == 0){
					/* 결제정보 확인 팝업 */
					roomEduPaymentInfo();
					layerPopupOpen("<a href=\"#uiLayerPop_confirm\">");
					$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:roomEduReservationInsert(this);");
					rsvConfirmPop_resize();
				}else{
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
	// 				roomEduPaymentDisablePop(cancelDataList);
					layerPopupOpen("<a href=\"#uiLayerPop_cannot\">");
					/* 중복 데이터 삭제 */
					var html = "<strong>예약불가 항목 : </strong>";
					for(var num in cancelDataList){
						
						html += "<span class=\"point1\">";
						html += cancelDataList[num].ppName + " <em>|</em> ";
						html += cancelDataList[num].roomName + " <em>|</em> ";
						html += cancelDataList[num].reservationdate + " <em>|</em> ";
						html += cancelDataList[num].sessionName; + "<br/>"
						html += "</span>";
						
						html += "<input type='hidden' name='cancelKey' value='" + cancelDataList[num].reservationdate + '_' + cancelDataList[num].rsvsessionseq + "'>";
					
						$("."+cancelDataList[num].reservationdate+cancelDataList[num].rsvsessionseq).each(function () {
	// 						$form.append($(this).prop("outerHTML"));
							/*
							if($(this).name == 'ppName'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'roomName'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'sessionYmd'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'sessionName'){
								html += $(this).val();
							}
							*/
							$(this).remove();
						});

					}
					$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").empty();
					$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").append(html);
				}
				
				setTimeout(function(){ abnkorea_resize(); }, 500);

			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
	} else if ( "easypay" == paymentMode ){

		/* 안심결제 process */
		
		$("#roomEduAppendCardForm").empty();
		
		$("#roomEduForm").find("input[type=hidden]").each(function() {
	        var el_name = $(this).attr('name');
	        var el_value = $(this).val();
	        $("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name +"' value='" + el_value + "' />");
	    })
		
		$("#roomEduAppendCardForm").append(formHtml);
		//console.log($("#roomEduAppendCardForm").html());
		
		var param = $("#roomEduAppendCardForm").serialize();
	
		/* 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인 */
		$.ajaxCall({
			url: "<c:url value='/mobile/reservation/roomEduPaymentCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				var cancelDataList = data.canceDataList;
				
				if(cancelDataList.length == 0){
					/* 안심결제 */
					doEasypayProcess();
				}else{
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
					layerPopupOpen("<a href=\"#uiLayerPop_cannot\">");
					/* 중복 데이터 삭제 */
					var html = "<strong>예약불가 항목 : </strong>";
					for(var num in cancelDataList){

						html += "<span class=\"point1\">";
						html += cancelDataList[num].ppName + " <em>|</em> ";
						html += cancelDataList[num].roomName + " <em>|</em> ";
						html += cancelDataList[num].reservationdate + " <em>|</em> ";
						html += cancelDataList[num].sessionName; + "<br/>"
						html += "</span>";
						html += "<input type='hidden' name='cancelKey' value='" + cancelDataList[num].reservationdate + '_' + cancelDataList[num].rsvsessionseq + "'>";

						$("."+cancelDataList[num].reservationdate+cancelDataList[num].rsvsessionseq).each(function () {
							/*
							if($(this).name == 'ppName'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'roomName'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'sessionYmd'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'sessionName'){
								html += $(this).val();
							}
							*/
							$(this).remove();
						});

					}
					$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").empty();
					$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").append(html);
				}
				
				setTimeout(function(){ abnkorea_resize(); }, 500);

			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
	} else {
	
		// 일반결제 && 무료
		
		/* 신용카드 정보 추가 */
		var bankid		 = (null == $("#bankid").val()) ? 'A' : $("#bankid").val();
		var bankname	 = $("#bankid :selected").text();
		var paymentmode	 = $("input:radio[name='paymentmode']:checked").val();
		var cardowner	 = $("input:radio[name='cardowner']:checked").val();
		var cardnumber1  = $("#cardnumber1").val();
		var cardnumber2  = $("#cardnumber2").val();
		var cardnumber3  = $("#cardnumber3").val();
		var cardnumber4  = $("#cardnumber4").val();
		var cardmonth	 = $("#cardmonth").val();
		var cardyear	 = $("#cardyear").val();
		var cardpassword = $("#cardpassword").val();
		var einstallment = $("#einstallment").val();
		var ninstallment = $("#ninstallment").val();
		var birthday     = $("#birthday").val();
		var biznumber    = $("#biznumber").val();
		
		var formHtml = "";
	
		formHtml +=   "<input type=\"hidden\" name=\"bankid\" 		value=\""+ bankid +"\" />"
					+ "<input type=\"hidden\" name=\"bankname\" 	value=\""+ bankname +"\" />"
					+ "<input type=\"hidden\" name=\"paymentmode\" 	value=\""+ paymentmode +"\" />"
					+ "<input type=\"hidden\" name=\"cardowner\" 	value=\""+ cardowner +"\" />"
					+ "<input type=\"hidden\" name=\"cardnumber1\" 	value=\""+ cardnumber1 +"\" />"
					+ "<input type=\"hidden\" name=\"cardnumber2\" 	value=\""+ cardnumber2 +"\" />"
					+ "<input type=\"hidden\" name=\"cardnumber3\" 	value=\""+ cardnumber3 +"\" />"
					+ "<input type=\"hidden\" name=\"cardnumber4\" 	value=\""+ cardnumber4 +"\" />"
					+ "<input type=\"hidden\" name=\"cardmonth\" 	value=\""+ cardmonth +"\" />"
					+ "<input type=\"hidden\" name=\"cardyear\" 	value=\""+ cardyear +"\" />"
					+ "<input type=\"hidden\" name=\"cardpassword\" value=\""+ cardpassword +"\" />"
					+ "<input type=\"hidden\" name=\"einstallment\" value=\""+ einstallment +"\" />"
					+ "<input type=\"hidden\" name=\"ninstallment\" value=\""+ ninstallment +"\" />"
					+ "<input type=\"hidden\" name=\"birthday\" 	value=\""+ birthday +"\" />"
					+ "<input type=\"hidden\" name=\"biznumber\" 	value=\""+ biznumber +"\" />"
					+ "<input type=\"hidden\" name=\"interfaceChannel\" 	value=\"MOBILE\" />";
		
		/* roomEduAppendCardForm = roomEduForm + 결제정보 */
		$("#roomEduAppendCardForm").empty();
		
		$("#roomEduForm").find("input[type=hidden]").each(function() {
	        var el_name = $(this).attr('name');
	        var el_value = $(this).val();
	        $("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name +"' value='" + el_value + "' />");
	    })
		
		$("#roomEduAppendCardForm").append(formHtml);
		//console.log($("#roomEduAppendCardForm").html());
		
		var param = $("#roomEduAppendCardForm").serialize();
	
		/* 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인 */
		$.ajaxCall({
			url: "<c:url value='/mobile/reservation/roomEduPaymentCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				var cancelDataList = data.canceDataList;
				
				if(cancelDataList.length == 0){
					/* 결제정보 확인 팝업 */
					roomEduPaymentInfo();
					layerPopupOpen("<a href=\"#uiLayerPop_confirm\">");
					$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:roomEduReservationInsert(this);");
					rsvConfirmPop_resize();
				}else{
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
	// 				roomEduPaymentDisablePop(cancelDataList);
					layerPopupOpen("<a href=\"#uiLayerPop_cannot\">");
					/* 중복 데이터 삭제 */
					var html = "<strong>예약불가 항목 : </strong>";
					for(var num in cancelDataList){
						
						html += "<span class=\"point1\">";
						html += cancelDataList[num].ppName + " <em>|</em> ";
						html += cancelDataList[num].roomName + " <em>|</em> ";
						html += cancelDataList[num].reservationdate + " <em>|</em> ";
						html += cancelDataList[num].sessionName; + "<br/>"
						html += "</span>";
						html += "<input type='hidden' name='cancelKey' value='" + cancelDataList[num].reservationdate + '_' + cancelDataList[num].rsvsessionseq + "'>";

						/*
						html += "<span class=\"point1\">";
						$("."+cancelDataList[num].reservationdate+cancelDataList[num].rsvsessionseq).each(function () {
	// 						$form.append($(this).prop("outerHTML"));
							if($(this).name == 'ppName'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'roomName'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'sessionYmd'){
								html += $(this).val() + " <em>|</em> ";
							}else if($(this).name == 'sessionName'){
								html += $(this).val();
							}
							
							$(this).remove();
						});
						*/

					}
					$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").empty();
					$("#uiLayerPop_cannot").find(".cancelWrap .bdBox span").append(html);
				}
				
				setTimeout(function(){ abnkorea_resize(); }, 500);
				
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}


function refreshOrderPage(){
	$("#paymentFrame").attr("src", "${currentDomain}/easypay/orderMobile.do");
}

/* 예약  정보 렌더링 */
function roomEduPaymentInfo() {
	
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform thead th").empty();
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform thead th").append($("#roomEduAppendCardForm input[name=ppName]").val()+" <em>|</em> "+$("#roomEduAppendCardForm input[name=roomName]").val());

	var html = "";
	var className = "";
	var cnt = 0;
	var totalPrice = 0;
	$("#roomEduForm").find("input").each(function () {
		if(className != $(this).prop("class") 
				&& null != $(this).prop("class")
				&& '' != $(this).prop("class")){

			className = $(this).prop("class");
			cnt++;

			$("#roomEduForm ."+className).each(function () {
				
				if($(this).prop("name") == 'sessionYmd'){
					html += "<tr>"
					     +  "<th scope=\"row\" class=\"bdTop\">날짜</th>"
					     +  "<td class=\"bdTop\">"+$(this).val()+"</td>"
					     +  "</tr>";
				}else if($(this).prop("name") == 'sessionName'){
					html += "<tr>"
						 +  "<th scope=\"row\">세션(시간)</th>"
						 +  "<td>"+$(this).val()+"</td>"
						 +  "</tr>";
				}else if($(this).prop("name") == 'sessionPrice'){
					html += "<tr>"
						 +  "<th scope=\"row\">금액</th>"
						 +  "<td>"+$(this).val()+"</td>"
						 +  "</tr>";
				}else if($(this).prop("name") == 'price'){
					totalPrice += parseInt($(this).val());
				}
				
			});

			
		}
	});
	
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tbody").empty();
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tbody").append(html);

	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tfoot td").empty();
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tfoot td").attr("colspan","2");
	$("#uiLayerPop_confirm").find(".pbLayerContent .tblResrConform tfoot td").append("총 "+cnt+"건 <em>|</em> <span class=\"point1\">"+setComma(totalPrice)+"원</span>");
	
	/* 결제시 카드정보 노출 tblCredit creditWrap */
	$("#readyCardNumber").text( $("#cardnumber1").val() + " - **** - **** - " + $("#cardnumber4").val() );
	$("#readyCardYearMonth").text( "20" + $("#cardyear").val() + "년 " + $("#cardmonth").val() + "월" );
	$("#readyNinstallment").text( ( $("#ninstallment").val() == '00' ) ? '일시불' : ($("#ninstallment").val() + "개월") );
	$("#readyTotalPrice").text( setComma(totalPrice) );
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 안심결제 결제 진행 */
function doEasypayProcess() {

	// ui block
	showLoading();
	$("#resultKiccProcess").val('false');
	
	// set : session information
	$("#roomEduAppendCardForm").empty();
	$("#roomEduForm").find("input[type=hidden]").each(function() {
		var el_name = $(this).attr('name');
		var el_value = $(this).val();
		//$("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name.toLowerCase() +"' value='" + el_value + "' />");
		$("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name +"' value='" + el_value + "' />");
	})
	
	// form element copy to order-form
	$("#tempForm").empty();
	var inputNode = $("#roomEduAppendCardForm").clone().find(":input");
	$("#tempForm").append(inputNode);
	
	var tempFormParam = $("#tempForm").serialize();
	
	$.ajax({
		url: "<c:url value='/reservation/roomEduPaymentInfoAjax.do'/>"
		, type : "POST"
		, data : tempFormParam
		, dataType: "json"
		, success: function(data, textStatus, jqXHR){
			if(data){
				var paymentElememtJson = data.roomEduPaymentInfoList;
				var paymentElememtInput = "";
				var totalPrice = 0;
				
				for (var cnt = 0; cnt < paymentElememtJson.length ; cnt++){
					
					paymentElememtInput = ""
						+"<input type='hidden' name='ppseq' 			value='" + paymentElememtJson[cnt].ppSeq			 + "' />"
						+"<input type='hidden' name='typeseq'			value='" + paymentElememtJson[cnt].typeSeq			 + "' />"
						+"<input type='hidden' name='ppname' 			value='" + paymentElememtJson[cnt].ppName			 + "' />"
						+"<input type='hidden' name='cookmastercode'	value='" + paymentElememtJson[cnt].cookMasterCode	 + "' />"
						+"<input type='hidden' name='sessionname' 		value='" + paymentElememtJson[cnt].sessionName		 + "' />"
						+"<input type='hidden' name='reservationdate' 	value='" + paymentElememtJson[cnt].reservationDate	 + "' />"
						+"<input type='hidden' name='enddatetime' 		value='" + paymentElememtJson[cnt].endDateTime		 + "' />"
						+"<input type='hidden' name='roomname' 			value='" + paymentElememtJson[cnt].roomName			 + "' />"
						+"<input type='hidden' name='rsvsessionseq' 	value='" + paymentElememtJson[cnt].rsvSessionSeq	 + "' />"
						+"<input type='hidden' name='paymentstatuscode' value='" + paymentElememtJson[cnt].paymentStatusCode + "' />"
						+"<input type='hidden' name='startdatetime' 	value='" + paymentElememtJson[cnt].startDateTime	 + "' />"
						+"<input type='hidden' name='price' 			value='" + paymentElememtJson[cnt].price			 + "' />"
						+"<input type='hidden' name='sessionymd' 		value='" + paymentElememtJson[cnt].sessionYmd		 + "' />"
						+"<input type='hidden' name='sessionprice' 		value='" + paymentElememtJson[cnt].sessionPrice		 + "' />"
						+"<input type='hidden' name='roomseq' 			value='" + paymentElememtJson[cnt].roomSeq			 + "' />"
						+"<input type='hidden' name='standbynumber' 	value='" + paymentElememtJson[cnt].standByNumber	 + "' />";

						totalPrice += parseInt(paymentElememtJson[cnt].price);
				}
				
				$("#paymentFrame").contents().find("#reservationElements").empty();
				$("#paymentFrame").contents().find("#reservationElements").append(paymentElememtInput);
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='interfaceChannel' value='MOBILE' />");
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='paymentmode' value='easypay' />");
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='totalPrice' value='" + totalPrice + "' />");
				
				var bankid = $("#bankid :selected").val();
				var bankname = $("#bankid :selected").text();;
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='bankid' value='" + bankid + "' />");
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='bankname' value='" + bankname + "' />");
				
				// set : kicc parameter
				$("#paymentFrame").contents().find("#product_nm").val("퀸룸/파티룸");
				$("#paymentFrame").contents().find("#user_nm").val("${getMemberInformation.accountname}");
				$("#paymentFrame").contents().find("#usedcard_code").val($("#bankid :selected").val());
				
				$("#paymentFrame").contents().find("#sp_pay_mny").val($("#currentAmount").val());
				$("#paymentFrame").contents().find("#sp_quota").val($("#einstallment").val());
				
				var jsonObj = [];
				var $revElem = $("#paymentFrame").contents().find("#reservationElements");
				
				$revElem.find("input").each(function(){
					
					var name = $(this).attr("name");
					var value = $(this).attr("value");
					
					item = {}
					item ["name"] = name;
					item ["value"] = encodeURIComponent(value);
					
					jsonObj.push(item);
				});
				
				$("#paymentFrame").contents().find("#reserved1").val("");
				$("#paymentFrame").contents().find("#reserved1").val(JSON.stringify(jsonObj));
				$("#paymentFrame").contents().find("#reserved2").val("");
				$("#paymentFrame").contents().find("#reserved2").val("queen");
				
				paymentFrame.f_start_pay();
			}
		}
		, error : function(jqXHR, textStatus, errorThrown){
			// console.log('easypay creation form : ' + textStatus);
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 일반결제 결제 진행 */
function roomEduReservationInsert(obj){
	
	
	$(obj).removeAttr("onclick");
	
	var param = $("#roomEduAppendCardForm").serialize();
	
	$.ajaxCall({
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
						
						/* 예약 완료 */
						var totalAmount = data.totalPrice;
						if( 0 < totalAmount ){
							$("#pbContent > section.mWrap > div:nth-child(3) > div.result > div > span").empty();
							$("#pbContent > section.mWrap > div:nth-child(3) > div.result > div").append("<span>신용카드<em class='bar'>|</em>" + setComma(totalAmount) + " 원</span>");
						}
						
						$("#stepDone").show();
						
						setTimeout(function(){ abnkorea_resize(); }, 500);
					}catch(e){
//							console.log(e);
					}
				} else {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
					$(obj).attr("onclick", "javascript:roomEduReservationInsert(this);");
				}
			}

			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
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
}

/* 레이어 팝업 닫기 */
function confirmClosePop(){
	$("#uiLayerPop_confirm").fadeOut();
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
function cannotClosePop(){
	$("#uiLayerPop_cannot").fadeOut();
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

/* 팝업 캘린더 기준정보 셋팅 */
function popCalenderSettingAjax() {
	
	$.ajaxCall({
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
		
	$.ajaxCall({
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
	
	$.ajaxCall({
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
	
	$.ajaxCall({
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
			     +  "<dd>"+reservationList[num].typename+" | "
			     +  reservationList[num].ppname+" – "
			     +  reservationList[num].roomname+" <br/>상태 : "
				 +  reservationList[num].paymentname+"</dd>";
		}
	}
	
	$(".tblBizroomState").append(html);
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	moveStep.top();
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
		$.ajaxCall({
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
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 레이어 팝업 닫기 */
function visionCenterClosePop(){
	$("#uiLayerPop_visionCenter").fadeOut();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 레이어 팝업 닫기 */
function w03ClosePop(){
	$("#uiLayerPop_w03").fadeOut();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* ap 안내 */
function showApInfo(thisObj){
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

/* 카드사 혜택 목록 받아오는 기능 */
function benefitCardList(){

	$("#tempForm").empty();

	var url = "https://mobile.abnkorea.co.kr/shop/order/checkout/orderCreatingCardBenefitsPopup";
	var title = "testpop";
	var status = "toolbar=no, width=540, height=536, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
    var frm = document.tempForm;
	frm.target = title;
	frm.action = url;
	frm.method = "get";

    frm.submit();
}

/* KICC 결제 완료로부터의 종료 화면 렌더링 */
function roomEduRsvDetail(){
	refreshOrderPage();
	
	/* 결과창 */
	$("#step3Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
	$("#step3Btn").parents('.bizEduPlace').find('.result').show();
	$("#step3Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
	
	/* 예약 완료 */
	var totalAmount = $("#currentAmount").val();

	if( 0 < totalAmount ){
		$("#pbContent > section.mWrap > div:nth-child(3) > div.result > div > span").empty();
		$("#pbContent > section.mWrap > div:nth-child(3) > div.result > div").append("<span>신용카드<em class='bar'>|</em>" + setComma(totalAmount) + " 원</span>");
	}
	
	$("#stepDone").show();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 퀸룸/파티룸 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}

//maxlength 체크
function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
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
<form id="roomEduForm" name="roomEduForm" method="post"></form>
<form id="roomEduAppendCardForm" name="roomEduAppendCardForm" method="post"></form>
<input type="hidden" id="currentAmount" value="0" />
<input type="hidden" id="cookMaster" value="${getMemberInformation.cookmaster}">
<input type="hidden" id="couponCount" value="0">
<input type="hidden" id="transactionTime" />
<input type="hidden" id="snsText" name="snsText">
	<section id="pbContent" class="bizroom">
			<section class="brIntro">
				<h2><a href="#uiToggle_01">퀸룸/파티룸 예약 필수 안내</a></h2>
				<div id="uiToggle_01" class="toggleDetail">
					<c:out value="${reservationInfo}" escapeXml="false" />
				</div>
			</section>

	<section class="mWrap">
		<!-- 스텝1 -->
		<div class="bizEduPlace" id="selectStepOne" >
			<div class="result">
				<div class="tWrap">
					<em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 룸</strong>
					<span>강서 AP<em class="bar">|</em>비전센타 1 (170명)</span>
					
					<%//<button class="bizIcon showHid">수정</button> %>
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
						<div class="selectArea local">
						</div>
					</dd>
					<dd>
						<p class="tit" id="selectStepOneRoom">룸 선택</p>
						<div class="selectArea sizeM room">
						</div>
					</dd>
					<dd class="dashed">
						<p class="tit">강서 AP 비전센타 1</p>
						<div class="roomInfo">
							<!-- @edit 2016.07.18 갤러리 형태로 수정-->
							<div class="roomImg touchSliderWrap">
								<a href="#none" class="btnPrev"><img src="/_ui/mobile/images/common/ico_slidectrl_prev2.png" alt="이전"></a>
								<a href="#none" class="btnNext"><img src="/_ui/mobile/images/common/ico_slidectrl_next2.png" alt="다음"></a>
								<div class="touchSlider" id="touchSlider">
									<ul>
										<li><img src="/_ui/desktop/images/academy/ap/study_A_gs_001.jpg" alt="강서 AP 퀸룸" /></li>
										<li><img src="/_ui/desktop/images/academy/ap/study_A_gs_002.jpg" alt="강서 AP 퀸룸" /></li>
									</ul>
								</div>
								<div class="sliderPaging"></div>
							</div>
							<!-- //@edit 2016.07.18 갤러리 형태로 수정-->
							<div class="roomSubText">강서 AP 비전 센터에 대한 간략한 설명 문구 및 안내 사항 입력하는 영역입니다.
							교육장에서는 기본적인 장비만 제공되며, 자세한 사항은 예약하실 AP로 문의해주시기 바랍니다. </div>
							<dl class="roomTbl">
								<dt class="noneBdT"><span class="bizIcon icon1"></span>정원</dt>
								<dd class="noneBdT">150명</dd>
								<dt><span class="bizIcon icon2"></span>이용시간</dt>
								<dd>180분</dd>
								<dt><span class="bizIcon icon3"></span>예약자격</dt>
								<dd>PT이상<br/><span class="fsS">(핀별 예약일자 차등적용)</span></dd>
								<dt><span class="bizIcon icon4"></span>부대시설</dt>
								<dd>퀸(대형프라이펜 *2), 인덕션 *2, 도마, 가위, 슬라이서나이프, 에이프런, 키친타올, 접시</dd>
							</dl>
						</div>
						<div class="btnWrap">
							<a href="#none" id="step1Btn" class="btnBasicBL stepBtn">다음</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- 스텝2 -->
		<div class="bizEduPlace" id="selectStepTwo">
			<div class="result">
				<div class="tWrap">
					<em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜, 세션</strong>
					<span>총2건<em class="bar">|</em>결제예정금액 : 0원</span>
					<div class="resultDetail">
						<span>2016-01-01 (x)<em class="bar">|</em>Session 1 (00:00~01:00)<em class="bar">|</em>0원</span>
					</div>
					
					<%//<button class="bizIcon showHid">수정</button> %>
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv">
				<dl class="selcWrap">
					<dt><div class="tWrap"><em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜, 세션</strong><span>날짜와 세션을 선택해 주세요.</span></div></dt>
					<dd class="">
						<div class="hWrap">
							<p class="tit">날짜 선택</p>
							<a href="#uiLayerPop_calender" class="btnTbl" onclick="layerPopupOpen(this);popCalenderSettingAjax();return false;">시설예약 현황확인</a>
						</div>
						<section class="calenderBookWrap">
							<div class="calenderHeader">
								<span class="year">2016</span>
								<span class="monthlyWrap">
									<a href="#none" class="on">5<span>月</span></a><em>|</em><a href="#none">6<span>月</span></a><em>|</em><a href="#none">7<span>月</span></a>
								</span>
								<div class="hText">
									<span>5월 예약가능 잔여회수</span><strong> 4회</strong>
								</div>
							</div>
							
							<table class="tblBookCalendar">
							</table>
							<ul class="listWarning mgWrap">
								<li>※ 날짜를 선택하시면 예약가능 시간(세션)을 확인 할 수 있습니다.</li>
								<li>※ 날짜 아래 괄호안 숫자는 예약 가능 세션 수 입니다.</li>
							</ul>
						</section>
					</dd>
					<dd>
						<div class="hWrap dashed">
							<p class="tit">세션 선택</p>
							<span class="hText"><input type="checkbox" id="check1" name="" /><label for="check1">예약가능만 보기</label></span>
						</div>
						<div class="tblWrap brSessionWrap">
						</div>
						<div class="btnWrap aNumb2">
							<a href="#none" class="btnBasicGL" onclick="javascript:moveStep.stepOne();">이전</a>
							<a href="#none" id="step2Btn" class="btnBasicBL">다음</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- 스텝3 -->
		<div class="bizEduPlace" id="selectStepThree">
			<div class="result">
				<div class="tWrap">

					<em class="bizIcon step03"></em><strong class="step">STEP3/ 동의, 결제</strong>
					<span>신용카드<em class="bar">|</em>0원</span>
											
						<%//<button class="bizIcon showHid">수정</button> %>
					</div>
				</div>
				<!-- 펼쳤을 때 -->
				<div class="selectDiv">
					<dl class="selcWrap">
						<dt><div class="tWrap"><em class="bizIcon step03"></em><strong class="step">STEP3/ 동의, 결제</strong><span>결제를 진행해 주세요.</span></div></dt>
						<dd>
							<div class="hWrap personal">
								<p class="tit">약관 및 동의</p>
								<a href="#uiLayerPop_personal" class="btnTbl" onclick="layerPopupOpen(this);return false;">약관 및 동의 전체보기</a>
							</div>
							<p class="tit mgtSM">교육장(퀸룸) 규정 동의</p>
							<div class="agreeDiv" style="height : 45px; overflow : auto; word-wrap : break-word;">
								<c:out value="${clause01}" escapeXml="false" />
							</div>
							<div class="agreeBoxYN mgWrap">
								교육장(퀸룸) 운영 규정을 숙지하였으며, 규정에 동의합니까? <span class="floatR"><input type="checkbox" name="" id="agreement1" /><label for="agreement1">동의합니다.</label></span>
							</div>
							
							<p class="tit mgtSM">교육장(퀸룸) 제품 교육 시 주의 사항</p>
							<div class="agreeDiv" style="height : 45px; overflow : auto; word-wrap : break-word;">
								<c:out value="${clause02}" escapeXml="false" />
							</div>
							<div class="agreeBoxYN mgWrap">
								주의사항을 충분히 숙지 하였으며, 교육장(퀸룸) 제품 교육시 상기원칙을 준수합니다.<span class="floatR"><input type="checkbox" name="" id="agreement2" /><label for="agreement2">동의합니다.</label></span>
							</div>
						</dd>
						<dd>
							<p class="tit credit creditWrap">신용카드 결제</p>
							<div class="tblWrap creditWrap">
								<table class="creditTbl">
									<colgroup><col width="110px" /><col width="auto" /></colgroup>
									<tbody>
										<tr>
											<th>결제 요청 금액</th>
											<td id="totalPrice">0원(VAT 포함)</td>
										</tr>
										<tr>
											<th>카드종류</th>
											<td><select id="bankid" title="카드종류선택">
													<c:forEach var="item" items="${bankInfo.list}" varStatus="status">
													<option value="${item.code}">${item.bank}</option>
													</c:forEach>
												</select>
												<a href="javascript:void(0);" onclick="javascript:benefitCardList();" class="btnContL">카드사 혜택 보기</a>
											</td>
										</tr>
										<tr>
											<th>결제방식</th>
											<td>
												<input type="radio" id="radio1" name="paymentmode" value="easypay" class="radio1" /><label for="radio1">안심결제</label>
												<input type="radio" id="radio2" name="paymentmode" value="normal" class="radio2" checked="checked" /><label id="paymentMode-2" for="radio2">일반결제</label>
											</td>
										</tr>
									</tbody>
									<tbody id="securityPayment">
										<tr>
											<th scope="row" class="thVerticalT">할부기간</th>
											<td><select id="einstallment" name="einstallment" title="할부기간">
													<option value="00" selected="selected">일시불</option>
													<option value="02">2개월</option>
													<option value="03">3개월</option>
													<option value="04">4개월</option>
													<option value="05">5개월</option>
													<option value="06">6개월</option>
													<option value="07">7개월</option>
													<option value="08">8개월</option>
													<option value="09">9개월</option>
													<option value="10">10개월</option>
													<option value="11">11개월</option>
													<option value="12">12개월</option>
												</select>
											</td>
										</tr>
									</tbody>
									<tbody id="normalPayment">
										<tr>
											<th>카드구분</th>
											<td>
												<input type="radio" id="radio3" name="cardowner" value="personal" checked="checked" /><label for="radio3">개인카드</label>
												<input type="radio" id="radio4" name="cardowner" value="business" /><label for="radio4">법인카드</label>
											</td>
										</tr>	
										<tr>
											<th colspan="2">카드번호
												<div class="inputBoxBlock">
                                                    <div class="inputNum4">
														<span>
															<input type="number" title="카드번호 첫번째 1자리" id="cardnumber1" name="cardnumber1" maxlength="4" pattern="[0-9]*" oninput="maxLengthCheck(this)" />
														</span>
														<span>
															<input type="number" title="카드번호 두번째 2자리" id="cardnumber2" name="cardnumber2" maxlength="4" pattern="[0-9]*" oninput="maxLengthCheck(this)" style="-webkit-text-security:disc;" />
														</span>
														<span>
															<input type="number" title="카드번호 세번째 3자리" id="cardnumber3" name="cardnumber3" maxlength="4" pattern="[0-9]*" oninput="maxLengthCheck(this)" style="-webkit-text-security:disc;" />
														</span>
														<span>
															<input type="number" title="카드번호 네번째 4자리" id="cardnumber4" name="cardnumber4" maxlength="4" pattern="[0-9]*" oninput="maxLengthCheck(this)" />
														</span>
													</div>
												</div>
											</div>
										</th>
									</tr>
									<tr>
										<th>유효기간</th>
										<td>
                                            <input type="number" title="유효기간 월" id="cardmonth" name="cardmonth" maxlength="2" pattern="[0-9]*" oninput="maxLengthCheck(this)" style="width:30px;" /> 월 
                                            <input type="number" title="유효기간 년" id="cardyear" name="cardyear" maxlength="2" pattern="[0-9]*" oninput="maxLengthCheck(this)" style="width:30px;" /> 년
										</td>
									</tr>
									<tr>
										<th>카드비밀번호</th>
										<td>
                                            <input type="number" title="비밀번호 앞 2자리" id="cardpassword" name="cardpassword" maxlength="2" pattern="[0-9]*" oninput="maxLengthCheck(this)" style="width:30px; -webkit-text-security:disc;" />
											<label for="cardid">비밀번호 앞 2자리</label>
										</td>
									</tr>
									<tr>
										<th>할부기간</th>
										<td><select id="ninstallment" name="ninstallment" title="할부기간">
												<option value="00" selected="selected">일시불</option>
												<option value="02">2개월</option>
												<option value="03">3개월</option>
												<option value="04">4개월</option>
												<option value="05">5개월</option>
												<option value="06">6개월</option>
												<option value="07">7개월</option>
												<option value="08">8개월</option>
												<option value="09">9개월</option>
												<option value="10">10개월</option>
												<option value="11">11개월</option>
												<option value="12">12개월</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>생년월일</th>
										<td>
                                            <input type="number" title="생년월일" id="birthday" name="birthday" maxlength="6" oninput="maxLengthCheck(this)" pattern="[0-9]*" style="width:90px;" />
											<p class="subText">주민번호 앞 6자리와 동일하게 입력</p>
										</td>
									</tr>
									<tr>
										<th>사업자등록번호</th>
										<td>
                                            <input type="number" title="사업자등록번호" id="biznumber" name="biznumber" maxlength="10" oninput="maxLengthCheck(this)" pattern="[0-9]*" style="width:90px;" />
											<p class="subText">사업자등록번호 10자리 '-'없이 입력</p>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="agreeBoxYN mgtS">
								소비자피해보상보험 가입 안내 : 전자상거래등에서의 소비자보호에관한 법률에 따라 직접판매공제조합에 가입하여 고객님의 결제금액에 대해 안전거래를 보장하고 있습니다.  
								<span class="floatR mgtS"><a href="https://www.macco.or.kr/ko/cn/KOCNMC01.action" target="_blank" title="직접판매공제조합 새창열림" class="btnCont">보험가입사실확인</a></span>
							</div>
							<div class="agreeBoxYN">
								주문하실 상품의 내용, 가격, 사용기간 등을 확인하였으며, 이에 동의하십니까? (전자상거래법 제8조 제2항)
								<span class="floatR"><input type="checkbox" id="agreement3" /><label for="agreement3">동의합니다.</label></span>
							</div>
						</div>

						<p class="tit mgtM creditWrap"><strong class="colorB">[필수]</strong> 개인정보 수집/이용에 대한 동의</p>
						<div class="tblWrap creditWrap">
							<table class="tblDetail">
								<caption>[필수] 개인정보 수집/이용에 대한 동의</caption>
								<colgroup>
									<col style="width:70px" />
									<col style="width:auto" />
								</colgroup>
								<tbody>
									<tr>
										<th>목적</th>
										<td>대금결제 서비스</td>
									</tr>
									<tr>
										<th>항목</th>
										<td>생년월일, 신용카드 정보</td>
									</tr>
									<tr>
										<th>이용 <br/>보유기간</th>
										<td>계약 또는 청약철회 등에 관한 기록 5년<br />
										대금결제 및 재화 등의 공급에 관한 기록 5년</td>
									</tr>
								</tbody>
							</table>
							
							<div class="agreeBoxYN">
								위 결제정보 수집 및 이용 약관을 확인하였으며 이에 동의하십니까?
								<span class="floatR"><input type="checkbox" id="agreement4" /><label for="agreement4">동의합니다.</label></span>
							</div>
							
							<ul class="listWarning mgtS">
								<li>※ 개인정보 수집 및 이용에 대한 동의를 거부하실 수 있으나, 거부 시 상품의 구매, 대금 결제가 제한됩니다.</li>
								<li id="penaltyInfo"></li>
							</ul>
						</div>
						<div class="btnWrap aNumb2">
							<a href="#none" class="btnBasicGL" onclick="javascript:moveStep.stepTwo();">이전</a>
							<a href="#" id="step3Btn" class="btnBasicBL" >결제요청</a>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- //스텝3 -->
		
		<!-- 예약완료 -->
		<div class="stepDone selcWrap" id="stepDone">
			<div class="doneText"><strong class="point1">예약</strong><strong class="point3">이 완료 되었습니다.</strong><br/>
			이용해 주셔서 감사합니다.</div>
			
			<div class="detailSns">
				<a href="#none" id="snsKt" onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"  title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
				<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
				<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');"       title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
				<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');"   title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
			</div>
			<span class="doneText">예약내역공유</span>
				
			<div class="btnWrap aNumb2">
				<a href="/mobile/reservation/roomQueenForm.do" class="btnBasicGL">예약계속하기</a>
<!-- 				<a href="/mobile/reservation/expInfoList.do" class="btnBasicBL">예약현황확인</a> -->
				<a href="/mobile/reservation/roomInfoList.do" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</section>

	<!-- layer popoup -->
	<!-- 룸 안내 -->
	<div class="pbLayerPopup" id="uiLayerPop_visionCenter">
		<div class="pbLayerHeader">
			<strong>안내</strong>
		</div>
		<div class="pbLayerContent">
		
			<p>선택하신 룸은 다목적 룸입니다.<br />
			일반 교육장으로 사용시에는 [교육장 예약신청]을 선택하시고, 
			요리시연 목적으로 퀸쿡웨어를 사용시에는 [퀸룸/파티룸 예약신청] 을 선택하시기 바랍니다.</p>
			<div class="btnWrap bNumb1">
				<a href="#" id="eduApply" class="btnBasicBL">교육장 예약신청</a>
			</div>
			<div class="btnWrap bNumb1 mgtS">
				<a href="#" id="queenApply" class="btnBasicBL">퀸룸/파티룸 예약신청</a>
			</div>
			<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
		</div>
	</div>
	<!-- // 룸 안내 -->
		
	<div class="pbLayerPopup" id="uiLayerPop_w03">
		<div class="pbLayerHeader">
			<strong>안내</strong>
		</div>
		<div class="pbLayerContent" style="overflow: auto;">
			<p class="ptxt">요리명장으로 선정되어 월2회 무료사용이 가능합니다.<br /> 무료 또는 유료 예약여부를 선택해 주세요.</p><br/>
			<ul class="uiLayerPop_cookingGuide mgbM">
						<li>※ 무료로 예약하는 경우, 사용예정일 1~7일 전까지 취소의 경우, 시설 이용한 것으로 간주하고 해당월 예약 횟수에 산정합니다.</li>
			</ul>
			<div class="radioList">
				<span><input type="radio" id="rado1" name="rado1" value="nocost" /><label for="rado1">무료로 예약</label></span>
				<span><input type="radio" id="rado2" name="rado1" value="cost" /><label for="rado2">유료로 예약</label></span>
			</div>
			<div class="btnWrap bNumb1">
				<a href="#" id="cookMasterConfirm" class="btnBasicBL">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
		
	<!-- 예약실패 알림 -->
	<div class="pbLayerPopup" id="uiLayerPop_fail">
		<div class="pbLayerHeader">
			<strong>예약실패 알림</strong>
		</div>
		<div class="pbLayerContent">
		
			<div class="cancelWrap">예약에 실패하였습니다.
				<div class="bdBox"><strong>원인: </strong><span class="point1">카드번호 오류</span></div>
			</div>
			<div class="btnWrap bNumb1">
				<a href="#" class="btnBasicBL">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약실패 알림 -->

	<!-- 예약불가 알림 -->
	<div class="pbLayerPopup" id="uiLayerPop_cannot">
		<div class="pbLayerHeader">
			<strong>예약불가 알림</strong>
		</div>
		<div class="pbLayerContent">
		
			<div class="cancelWrap">
				예약 진행 중 다른 사용자가 실시간으로 <br/>아래 예약건을 이미 완료하였습니다.
				<div class="bdBox textL">
					<!-- 강서 AP <em>|</em> 비전센타 1 <em>|</em> 2016-05-25 (수) <em>|</em> Session 2 (14:00~17:00)
					<strong>예약불가 항목 : </strong>
					 -->
					<span class="point1"></span>
				</div>
			</div>
			<div class="radioList">
				<span><input type="radio" id="sessionSelect1" name="resConfirm" value="sessionSelect1" checked="checked"/><label for="sessionSelect1">예약불가 세션 제외 후 결제 진행</label></span>
				<span><input type="radio" id="sessionSelect2" name="resConfirm" value="sessionSelect2" /><label for="sessionSelect2">날짜 및 세션 다시 선택 후 진행</label></span>
			</div>
			<div class="btnWrap bNumb1">
				<a href="#" class="btnBasicBL" onclick="javascript:eduCultureDisabledConfirm();">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약불가 알림 -->
	
	<!-- 예약 및 결제정보 확인 -->
	<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_confirm">
		<div class="pbLayerHeader">
			<strong>예약 및 결제정보 확인</strong>
		</div>
		<div class="pbLayerContent">
		
			<table class="tblResrConform">
				<colgroup><col width="30%" /><col width="70%" /></colgroup>
				<thead>
					<tr><th scope="col" colspan="2">&nbsp;</th></tr>
				</thead>
				<tfoot>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</tbody>
			</table>
			
			<table class="tblCredit creditWrap">
				<colgroup><col width="30%" /><col width="auto" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">카드번호</th>
						<td id="readyCardNumber">0000 - **** - **** - 0000</td>
					</tr>
					<tr>
						<th scope="row">유효기간</th>
						<td id="readyCardYearMonth">0000년 00월</td>
					</tr>
					<tr>
						<th scope="row">할부기간</th>
						<td id="readyNinstallment">00개월</td>
					</tr>
					<tr>
						<th scope="row">카드결제금액</th>
						<td id="readyTotalPrice">0원</td>
					</tr>
				</tbody>
			</table>
			
			<ul class="listWarning">
				<li>※ 결제완료까지 시간이 지연될 수 있습니다.조금만 기다려 주세요.</li>
				<li>※ [예약확정] 버튼은 한 번만 선택하세요.</li>
				<li>※ 여러 번 선택하시면 예약이 중복 생성될 수 있습니다.</li>
				<li>※ 사용 예정일 1~7일 전 취소한 경우, 해당 시설 임대 금액의 10%를 취소 수수료로 공제 후 환급됩니다.</li>
			</ul>
			<div class="grayBox">
				위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>
				<span class="point3">[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</span>
			</div>
			
			<div class="btnWrap aNumb2">
				<span><a href="#" class="btnBasicGL" onclick="javascript:confirmClosePop();">예약취소</a></span>
				<span><a href="#" class="btnBasicBL">예약확정</a></span>
			</div>
<!-- 			<div class="btnWrap bNumb1">
				<a href="#none" class="btnBasicBL">다음</a>
			</div> -->
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약 및 결제정보 확인 -->

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
					<dt>사용일자<br/>2016-05-31 (화)  14:00~17:00 <a href="#none" class="btnTbl">예약취소</a></dt>
					<dd>퀸룸/파티룸 | 강서AP – 비전센타 1 <br/>상태 : 사용완료</dd>
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
								<c:out value="${clause01}" escapeXml="false" />
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
	
	<div class="pbLayerWrap" id="uiLayerPop_w03" style="width:400px;">
		<div class="pbLayerHeader">
			<strong><img src="/_ui/desktop/images/academy/h1_w020500100_pop.gif" alt="안내"></strong>
			<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 상세보기 닫기"></a>
		</div>
		<div class="pbLayerContent">
			<p class="ptxt">요리명장으로 선정되어 월2회 무료사용이 가능합니다.<br /> 무료 또는 유료 예약여부를 선택해 주세요.</p><br/>
			<ul class="uiLayerPop_cookingGuide mgbM">
						<li>※ 무료로 예약하는 경우, 사용예정일 1~7일 전까지 취소의 경우, 시설 이용한 것으로 간주하고 해당월 예약 횟수에 산정합니다.</li>
			</ul>			
			<div class="inputList">
				<span><input type="radio" id="rado1" name="rado1" /><label for="rado1">무료로 예약</label></span>
				<span><input type="radio" id="rado2" name="rado1" /><label for="rado2">유료로 예약</label></span>
			</div>
			<div class="btnWrapC">
				<a href="#none" id="cookMasterConfirm" class="btnBasicBL">확인</a>
			</div>
		</div>
	</div>
	<!-- //layer popoup -->
	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/apInfoPop.jsp" %>
</section>
<form id="tempForm" name="tempForm"></form>
<!-- //content -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>

<iframe id="paymentFrame" name="paymentFrame" src="" style="width:0; height:0; border:0;" />
