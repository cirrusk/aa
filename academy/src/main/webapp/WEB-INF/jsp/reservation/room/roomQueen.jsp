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

var sessionId = "";

var ppCnt = 0;
var roomCnt = 0;

var typeSeqSecond = "";

var step1Clk = 0;

$(document).ready(function () {
	
	if( "localhost" != document.domain){
		document.domain="abnkorea.co.kr";
	}
	
	refreshOrderPage();
	
	$(".brSelectWrap").show();
	$(".roomInfo").hide();
	$("#stepDone").hide();
	
	setPpInfoList();
	
	setMaxlengthSupport();
	
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
	
	$("#roomConfirmPop").click(function () {
		roomConfirmPop();
	});

	$("#cookMasterConfirm").click(function () {
		cookMasterConfirm();
	});
	$(".btnBasicGL").click(function () {
// 		$("#roomEduForm").attr("action", "<c:url value='/reservation/roomEduForm.do'/>");
// 		$("#roomEduForm").submit();
		
// 		$("#roomEduForm").attr("action", "${pageContext.request.contextPath}/reservation/roomEduForm.do");
// 		$("#roomEduForm").submit();
		
		location.href = "<c:url value='/reservation/roomQueenForm.do'/>";
	});
	
	$("#eduApply").click(function () {
		
		closeLayerPopup($($("#uiLayerPop_w02")));
	});
	
	$("#queenApply").click(function () {
		
		/* 교육장 typeseq 초기화 */
		typeSeqSecond = typeSeq;
		
		closeLayerPopup($($("#uiLayerPop_w02")));
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
	
	$("#birthday").parent("td").parent("tr").show();
	$("#biznumber").parent("td").parent("tr").hide();
	
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

});

/* according handler */
var accordingNavagate = {
	
	done : function () {
		$("#step3 > div > div.result.req > p").show();
	},
		
	from3to2 :function(){
		if( '0원' == $("#amountText").text() ) {
			$("#step3 > div > div:nth-child(2)").show();
			$("#step3 > div > div.result.req > p").hide();
		}
	},
	
	from2to1 :function(){
		if( 0 == $("#sessionCheckResult > p.total").text().length ) {
			$("#step2Btn").parents('.brWrap').find('.result').show();
			$("#sessionCheckResult").hide();
		}
	}
};

function setMaxlengthSupport(){
	$("#cardnumber1").attr("maxLength",4);
	$("#cardnumber2").attr("maxLength",4);
	$("#cardnumber3").attr("maxLength",4);
	$("#cardnumber4").attr("maxLength",4);
	
	$("#cardmonth").attr("maxLength",2);
	$("#cardyear").attr("maxLength",2);
	$("#cardpassword").attr("maxLength",2);
	
	$("#birthday").attr("maxLength",6);
	$("#biznumber").attr("maxLength",10);
}

function setPpInfoList(){
	
	$.ajaxCall({
		url: "<c:url value='/reservation/roomQueenPpInfoListAjax.do'/>"
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
	
	/* 다목적룸 설정 값 초기화 */
	this.typeSeqSecond = "";
	
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
	
	/* 다목적룸 설정 값 초기화 */
	this.typeSeqSecond = "";
	
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
			
			/* 다목적 룸 확인 */
			multipurposeRoomCheck();
			
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
				
				/* 교육장 typeseq 전역변수에 저장 */
				for(var num in multipurposeRoomTypeList){
					if(multipurposeRoomTypeList[num].typeflag == 'E'){
						typeSeqSecond = multipurposeRoomTypeList[num].typeseq;
					}
				}
				
				/* 레이어팝업 오픈 */
				layerPopOpen("#uiLayerPop_w02", '25%');
			}
		}
		, error: function( jqXHR, textStatus, errorThrown) {
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
	var date = new Date();
	var year = date.getFullYear();
	var month = new String(date.getMonth()+1);

	/* 선택된 세션 체크 */
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
			if($("#cookMaster").val() == 'true' && ("" == typeSeqSecond || typeSeq == typeSeqSecond)){
				getCookMasterCoupon(year, month < 10 ? "0" + month : month);
			}
			
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
				
				/* 세션 선택 갯수 */
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
	
	/* html += "<span class=\"year\">"
		+ "<img src=\"/_ui/desktop/images/academy/img_"+yearMonthList[0].year+".gif\" "
		+ " alt=\""+yearMonthList[0].year+"년\" /></span>"
		+ "<div class=\"monthlyWrap\">"; */

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
	
	/* 잔여횟수 표시 */
// 	getRemainDayByMonth();
	
}

/* 달력 그리기 */
function calenderRender(calendar, today, reservationInfoList, partitionRoomFirstRsvList, partitionRoomSecondRsvList){
	
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
							
							if(partitionRoomFirstRsvList != null && partitionRoomFirstRsvList.length != 0){
								if(partitionRoomFirstRsvList != null
										&& partitionRoomFirstRsvList[j].ymd == calendar[cnt].ymd
										&& partitionRoomFirstRsvList[j].settypecode == setCode
										&& partitionRoomFirstRsvList[j].worktypecode == workCode
										&& partitionRoomFirstRsvList[j].temp == temp){
									rsvCnt += partitionRoomFirstRsvList[j].rsvcnt;
								}
							}
							
							if(partitionRoomSecondRsvList != null && partitionRoomSecondRsvList.length != 0){
								if(partitionRoomSecondRsvList != null
										&& partitionRoomSecondRsvList[j].ymd == calendar[cnt].ymd
										&& partitionRoomSecondRsvList[j].settypecode == setCode
										&& partitionRoomSecondRsvList[j].worktypecode == workCode
										&& partitionRoomSecondRsvList[j].temp == temp){
									rsvCnt += partitionRoomSecondRsvList[j].rsvcnt;
								}
							}
							rsvCnt += reservationInfoList[j].rsvcnt;
							totalCnt++;
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
					}else if(totalCnt <= rsvCnt){
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
		url: "<c:url value="/reservation/roomEduSeesionListAjax.do"/>"
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
						if(seesionList[num].queendiscountprice == 0 
								|| seesionList[num].queendiscountprice == null){
							html += "<tr class=\"fullBook\">"
								+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].queenprice)+"원</td>"
								+ "<td class=\"able\">예약마감</td>"
								+ "</tr>";
						}else{
							html += "<tr class=\"fullBook\">"
								+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].queenprice)+"원</span><span><em>할인</em>"+setComma(seesionList[num].queendiscountprice)+"원</span></td>"
								+ "<td class=\"able\">예약마감</td>"
								+ "</tr>";
						}
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
								+	seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].queenprice)+"원</td>"
								+ "<td class=\"able\">예약가능</td>"
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
								+	seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].queenprice)+"원</span><span><em>할인</em>"+setComma(seesionList[num].queendiscountprice)+"원</span></td>"
								+ "<td class=\"able\">예약가능</td>"
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
						if(seesionList[num].queendiscountprice == 0 
								|| seesionList[num].queendiscountprice == null){
							html += "<tr class=\"fullBook\">"
								+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].queenprice)+"원</td>"
								+ "<td class=\"able\">예약마감</td>"
								+ "</tr>";
						}else{
							html += "<tr class=\"fullBook\">"
								+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].queenprice)+"원</span><span><em>할인</em>"+setComma(seesionList[num].queendiscountprice)+"원</span></td>"
								+ "<td class=\"able\">예약마감</td>"
								+ "</tr>";
						}
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
								+	seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].queenprice)+"원</td>"
								+ "<td class=\"able\">예약가능</td>"
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
								+	seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].queenprice)+"원</span><span><em>할인</em>"+setComma(seesionList[num].queendiscountprice)+"원</span></td>"
								+ "<td class=\"able\">예약가능</td>"
								+ "</tr>";
						}
					}
				}else if(seesionList[num].settypecode == settypecode
						&& seesionList[num].temp == temp
						&& typeSeqSecond != ''
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
						if(seesionList[num].discountprice == 0 
								|| seesionList[num].discountprice == null){
							html += "<tr class=\"fullBook\">"
								+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].price)+"원</td>"
								+ "<td class=\"able\">예약마감</td>"
								+ "</tr>";
						}else{
							html += "<tr class=\"fullBook\">"
								+ "<td><input type=\"checkbox\" id=\"\" name=\"\" disabled/>"+seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].price)+"원</span><span><em>할인</em>"+setComma(seesionList[num].discountprice)+"원</span></td>"
								+ "<td class=\"able\">예약마감</td>"
								+ "</tr>";
						}
					}else{
						if(seesionList[num].discountprice == 0 
								|| seesionList[num].discountprice == null){
							html += "<tr id=\""+year+tempMonth+tempDay+seesionList[num].rsvsessionseq+"\">"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionClick(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].price)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].price+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].price+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].discountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"flag\" value=\"true\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+	seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\">"+setComma(seesionList[num].price)+"원</td>"
								+ "<td class=\"able\">예약가능</td>"
								+ "</tr>";
						}else{
							html += "<tr id=\""+year+tempMonth+tempDay+seesionList[num].rsvsessionseq+"\">"
								+ "<td><input type=\"checkbox\" id=\"" + seesionList[num].ymd + "_" + seesionList[num].rsvsessionseq + "\" name=\"sessionCheck\" onclick=\"javascript:sessionClick(this);\"/>"
								+ "<input type=\"hidden\" class=\"sessionYmd\" value=\""+year+"-"+tempMonth+"-"+tempDay+" ("+seesionList[0].krweekday+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionName\" value=\""+seesionList[num].sessionname+" ("+seesionList[num].sessiontime+")"+"\"/>"
								+ "<input type=\"hidden\" class=\"sessionPrice\" value=\""+setComma(seesionList[num].discountprice)+"원\"/>"
								+ "<input type=\"hidden\" class=\"price\" value=\""+seesionList[num].discountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"tempPrice\" value=\""+seesionList[num].price+"\"/>"
								+ "<input type=\"hidden\" class=\"discountPrice\" value=\""+seesionList[num].discountprice+"\"/>"
								+ "<input type=\"hidden\" class=\"flag\" value=\"true\"/>"
								+ "<input type=\"hidden\" class=\"rsvSessionSeq\" value=\""+seesionList[num].rsvsessionseq+"\"/>"
								+ "<input type=\"hidden\" class=\"reservationdate\" value=\""+seesionList[num].ymd+"\"/>"
								+ "<input type=\"hidden\" class=\"startDateTime\" value=\""+seesionList[num].startdatetime+"\"/>"
								+ "<input type=\"hidden\" class=\"endDateTime\" value=\""+seesionList[num].enddatetime+"\"/>"
								+	seesionList[num].sessionname+"</td>"
								+ "<td>"+seesionList[num].sessiontime+"</td>"
								+ "<td class=\"price\"><span class=\"throught\">"+setComma(seesionList[num].price)+"원</span><span><em>할인</em>"+setComma(seesionList[num].discountprice)+"원</span></td>"
								+ "<td class=\"able\">예약가능</td>"
								+ "</tr>";
						}
					}
				}
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
	
	/* 예약 완료후 포커스 상단 유지 */
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	$("#sessionCheckResult").empty();
	$("#roomEduForm").empty();
	
	var html = "";
	var tempHtml = "";
	var formHtml = "";
	var cnt = 0;	/* 세션 선택 갯수 */
	var totalPrice = 0;
	
	var snsTitle = "";
	var snsHtml = ""; 
	
	$("input[name=sessionCheck]").each(function () {
		if($(this).prop("checked")){
			if(typeSeqSecond == "" || typeSeqSecond == typeSeq){
				if($(this).parent("td").children(".flag").val() == "false"){
					tempHtml += "<p>"+$(this).parent("td").children(".sessionYmd").val()
							+" <em>|</em> "+$(this).parent("td").children(".sessionName").val()
							+" <em>|</em><span> 무료</span></p>";
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
					tempHtml += "<p>"+$(this).parent("td").children(".sessionYmd").val()
							+" <em>|</em> "+$(this).parent("td").children(".sessionName").val()
							+" <em>|</em><span> "+$(this).parent("td").children(".sessionPrice").val()
							+"</span></p>";
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
					tempHtml += "<p>"+$(this).parent("td").children(".sessionYmd").val()
							+" <em>|</em> "+$(this).parent("td").children(".sessionName").val()
							+" <em>|</em><span> 무료</span></p>";
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
					tempHtml += "<p>"+$(this).parent("td").children(".sessionYmd").val()
							+" <em>|</em> "+$(this).parent("td").children(".sessionName").val()
							+" <em>|</em><span> "+$(this).parent("td").children(".sessionPrice").val()
							+"</span></p>";
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
	
	html = "<p class=\"total\">총 "+cnt+"건<em>|</em>결제예정금액 : <span>"+setComma(totalPrice)+"원</span></p>"
		+ tempHtml;
	
	/*------------------ sns 내용----------------------------- */
	snsTitle = "[한국암웨이]시설/체험 예약내역 (총 "+cnt+"건) \n" + snsHtml;
	
	$("#snsText").empty();
	$("#snsText").val(snsTitle);
	/*------------------------------------------------------ */
	
	$("#sessionCheckResult").append(html);
	$("#roomEduForm").append(formHtml);
	
	$("#totalPrice").text("");
	$("#totalPrice").text(setComma(totalPrice)+"원(VAT포함)");
	
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
					$("#typeValue").val(data.searchRoomPayPenalty.typevalue);
					$("#applyTypeValue").val(data.searchRoomPayPenalty.applytypevalue);
				}

			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
	
	latestTotalPrice = totalPrice;
	$("#currentAmount").val(latestTotalPrice);
	
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
								
								/* step2 닫기 */
								$("#step2Btn").parents('.brWrap').find('.sectionWrap').stop().slideUp(function(){
									$("#step2Btn").parents('.brWrap').find('.stepTit').find('.close').show();
									$("#step2Btn").parents('.brWrap').find('.stepTit').find('.open').hide();
									
									$("#step2Btn").parents('.brWrap').find('.modifyBtn').show();
									$("#sessionCheckResult").show();
	//						 		$("#step2Btn").parents('.brWrap').find('.req').show(); //결과값 보기
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
					
				}else{
					alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.(요리명장)");
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
				
			} else if (4 != $("#cardnumber1").val().replace( /(\s*)/g, "" ).length
		 				|| 4 != $("#cardnumber2").val().replace( /(\s*)/g, "" ).length
		 				|| 4 != $("#cardnumber3").val().replace( /(\s*)/g, "" ).length ) {
				
	 				alert('카드번호를 4자리씩 정확히 입력해 주세요');
	 				return;
	 				
	 		} else if ( 4 < $("#cardnumber4").val().replace( /(\s*)/g, "" ).length ) {
	 			
	 			alert('1~4자리를 입력해 주세요');
	 			$("#cardnumber4").focus();
 				return;
 				
	 		}
			
	 		if ( '' == $("#cardmonth").val() ) {
	 			alert("유효기간-(월)을 입력해 주세요.");
	 			return;
	 		} else if ( 2 != $("#cardmonth").val().replace( /(\s*)/g, "" ).length){
				alert("유효기간(월)은 2자리 입니다.");
				return;
			}
			
	 		if( '' == $("#cardyear").val() ) {
	 			alert("유효기간-(년)을 입력해 주세요.");
	 			return;
	 		}else if ( 2 != $("#cardyear").val().replace( /(\s*)/g, "" ).length){
				alert("유효기간(년)은 2자리 입니다.");
				return;
			}
			
	 		if ( '' == $("#cardpassword").val() ) {
	 			alert("카드 비밀번호를 입력해 주세요.");
				return;
	 		} else if ( 2 != $("#cardpassword").val().replace( /(\s*)/g, "" ).length){
				alert("비밀번호는 2자리 입니다.");
				return;
			}
			
			var cardowner = $("input:radio[name='cardowner']:checked").val();
			
			if( 'personal' == cardowner){
				if ( '' == $("#birthday").val() ) {
					alert("생년월일 값은 필수입니다.");
					return;
				} else if (6 != $("#birthday").val().replace( /(\s*)/g, "" ).length){
					alert("생년월일은 6자리 입니다.");
					return;
				}
				
			}else if ( $(".radio4").prop("checked", true) ){
				if ( '' == $("#biznumber").val() ) {
					alert("사업자등록번호 값은 필수입니다.");
					return;
				} else if ( 10 != $("#biznumber").val().replace( /(\s*)/g, "" ).length ) {
					alert("사업자등록번호는 10자리 입니다.");
					return;
				}
			}
			
		} else {	/* 안심결제 입력폼 유효성 체크 */
			
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
		
		/* 무료 */
		
		$("#roomEduAppendCardForm").empty();
		
		$("#roomEduForm").find("input[type=hidden]").each(function() {
	        var el_name = $(this).attr('name');
	        var el_value = $(this).val();
	        $("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name +"' value='" + el_value + "' />");
	    })
		
		$("#roomEduAppendCardForm").append(formHtml);
		$("#roomEduAppendCardForm").append("<input type='hidden' name='costNoCost' value='nocost' />");
		
		var param = $("#roomEduAppendCardForm").serialize();
		
		/* 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인 */
		$.ajaxCall({
			url: "<c:url value='/reservation/roomEduPaymentCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var cancelDataList = data.canceDataList;
				
				if(cancelDataList.length == 0){
					/* 결제정보 확인 팝업 */
					roomEduPaymentInfoPop();
				}else{
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
					roomEduPaymentDisablePop(cancelDataList);
				}
				
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
		$("#roomEduAppendCardForm").append("<input type='hidden' name='costNoCost' value='nocost' />");
		
		var param = $("#roomEduAppendCardForm").serialize();
		
		/* 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인 */
		$.ajaxCall({
			url: "<c:url value='/reservation/roomEduPaymentCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var cancelDataList = data.canceDataList;
				
				if(cancelDataList.length == 0){
					/* 안심결제 */
					doEasypayProcess();
				}else{
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
					roomEduPaymentDisablePop(cancelDataList);
				}
				
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
					+ "<input type=\"hidden\" name=\"biznumber\" 	value=\""+ biznumber +"\" />";
		
		/* roomEduAppendCardForm = roomEduForm + 결제정보 */				
		$("#roomEduAppendCardForm").empty();
		
		$("#roomEduForm").find("input[type=hidden]").each(function() {
	        var el_name = $(this).attr('name');
	        var el_value = $(this).val();
	        $("#roomEduAppendCardForm").append("<input type='hidden' name='" + el_name +"' value='" + el_value + "' />");
	    })
		
		$("#roomEduAppendCardForm").append(formHtml);
		
		var param = $("#roomEduAppendCardForm").serialize();
		
		/* 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인 */
		$.ajaxCall({
			url: "<c:url value='/reservation/roomEduPaymentCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var cancelDataList = data.canceDataList;
				
				if(cancelDataList.length == 0){
					/* 결제정보 확인 팝업 */
					roomEduPaymentInfoPop();
				}else{
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
					roomEduPaymentDisablePop(cancelDataList);
				}
				
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
	}
}


function refreshOrderPage(){
	$("#paymentFrame").attr("src", "${currentDomain}/easypay/order.do");
}

/* 안심결제 결제 진행 */
function doEasypayProcess(){
	
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
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='interfaceChannel' value='WEB' />");
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='paymentmode' value='easypay' />");
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='totalPrice' value='" + totalPrice + "' />");
				
				var bankid = $("#bankid :selected").val();
				var bankname = $("#bankid :selected").text();;
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='bankid' value='" + bankid + "' />");
				$("#paymentFrame").contents().find("#reservationElements").append("<input type='hidden' name='bankname' value='" + bankname + "' />");
			}
		}
		, error : function(jqXHR, textStatus, errorThrown){
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
    });
    
    // set : kicc parameter
	paymentFrame.frm_pay.EP_product_nm_tmp.value = "교육장";
	paymentFrame.frm_pay.EP_user_nm_tmp.value = "${getMemberInformation.accountname}";
	paymentFrame.frm_pay.EP_product_amt.value = $("#currentAmount").val();
    paymentFrame.frm_pay.usedcard_code.value = $("#bankid").val();
	paymentFrame.frm_pay.EP_quota.value = $("#einstallment").val();
	
	paymentFrame.f_start_pay();	
}

/* 예약불가 팝업 호출 (예약 충돌)*/
function roomEduPaymentDisablePop(cancelDataList){
	
	var url = "<c:url value='/reservation/roomEduPaymentDisablePop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
	$("#cancelList").empty();
    var $form = $("#cancelList");
    $form.attr('action', url);
    $form.attr('method', 'post');
    $form.attr('target', title);
    $form.appendTo('body');

	// 중복 데이터 삭제
	for(var num in cancelDataList){
		$("."+cancelDataList[num].reservationdate+cancelDataList[num].rsvsessionseq).each(function () {
			$form.append($(this).prop("outerHTML"));
			$(this).remove();
		});
	}

	$form.submit();
}

/* 예약취소 팝업 호출(결제 실패) */
function roomEduPaymentCancelPop(){
	
	var frm = document.roomEduForm;
	var url = "<c:url value='/reservation/roomEduPaymentCancelPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 예약정보 확인 (정상 진행) */
function roomEduPaymentInfoPop(){
	
	//var frm = document.roomEduForm
	var frm = document.roomEduAppendCardForm;
	var url = "<c:url value='/reservation/roomEduPaymentInfoPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=821, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 예약정보 현황 팝업 */
function roomConfirmPop(){
	
	$("#tempForm").empty();
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
	var title = "allowClause";
	var status = "toolbar=no, width=600, height=660, directories=no, status=no, scrollbars=yes, resizable=no";
	
	url += "?clauseType=eduroom";
	
	window.open("", title, status);
	
    var frm = document.clauseForm;
    frm.action = url;
    frm.method = 'post';
    frm.target = title;
    frm.submit();
    
}


/* 예약 결제 후 팝업 창에서 전달 받은 예약한 데이터를 보여줌  */
function roomEduRsvDetail(){

	var currentAmount = $("#currentAmount").val();
	
	$("#amountText").text( setComma(currentAmount) + "원" );
	
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

/* 요리명장 사용가능 무료쿠폰 갯수 조회 */
function getCookMasterCoupon(year, month) {
	var param = {
			  "year" : year
			, "month" : month
		};
		
		$.ajaxCall({
			url: "<c:url value='/reservation/getCookMasterCouponAjax.do'/>"
			, type : "POST"
			, data : param
			, success: function(data, textStatus, jqXHR){
				
				$("#couponCount").val(data.getCookMasterCoupon.couponcount);
				
			}, error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
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
		
		layerPopOpen("#uiLayerPop_w03");
		
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
	}else{
		if($(obj).prop("checked")){
			$(obj).parents("tr").addClass("select");
		}else{
			$(obj).parents("tr").removeClass("select");
		}
	}
	
// 	alert($(obj).prop("checked"));
	
}

/* 요리명장 유료, 무료  예약 체크  */
function cookMasterConfirm() {
	
	closeLayerPopup($($("#uiLayerPop_w03")));
	
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
	//console.log($("input[name=rado1]:checked").prop("id"));
	
}

function layerPopOpen(e, yPosition){
	var target = $(e);
	var $target = $($(e));	

	var positionTop = '50%';
	if (yPosition) {
		positionTop = yPosition;
	}
	
	$target.show();
	$target.attr('tabindex','0');
	
	// 암막
	var layerM =$('<div class="layerMask" id="layerMask" style="display:block"></div>');
	$target.before(layerM);
	$(document).scrollTop();
	$target.css({ 
					'display':'block', 
					'position':'fixed', 
					'top': positionTop, 
					'left':'50%', 
					'marginTop': - $target.height()/2,
					'marginLeft': - $target.width()/2
	});

	$('#pbHeader').css({'z-index':'-1'});
	$('#pbFooter').css({'z-index':'-1'});

	if(target=="#uiLayerPop_prodDetail"){
		$('#pbAside').css({'z-index':'-1'});
	}

	// layerPop center align - Close button
	$(document).on('click', 'div[id^="uiLayerPop_"] .btnPopClose,.layerPopClose', function(){closeLayerPopup($target);return false;});
	return false;	
}

function closeLayerPopup($target){
	var $layerPop = $('div[id^="uiLayerPop_"]');
	$layerPop.find('.btnPopClose, .layerPopClose').unbind('click');
	$target.unbind('keydown');
	$target.fadeOut(200);
	var targetId=$target.attr('id');
	$('.layerMask').fadeOut(200).remove();
	$('a[href="#'+targetId+'').focus();
	$target.attr('aria-hidden','true');
	return false;
};


/* 카드사 혜택 목록 받아오는 기능 */
function benefitCardList(){

	$("#tempForm").empty();
	var url = "https://qa2.abnkorea.co.kr/shop/order/checkout/orderCreatingCardBenefitsPopup";
	var title = "testpop";
	var status = "toolbar=no, width=540, height=536, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title, status);
	
    var frm = document.tempForm;
	frm.target = title;
	frm.action = url;
	frm.method = "get";

    frm.submit();
}

function tempSharing(url, sns){
	
	var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
	var title = "예약 - 퀸룸/파티룸";
	var content = $("#snsText").val();
	var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
	
	sharing(currentUrl, title, sns, content, imageUrl);
}

/* 예약 현황 확인 페이지 이동 */
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
	<form id="roomEduForm" name="roomEduForm" method="post"></form>
	<form id="roomEduAppendCardForm" name="roomEduAppendCardForm" method="post"></form>
	<input type="hidden" id="transactionTime" value="" />
	<input type="hidden" id="currentAmount" value="0"; />
	<input type="hidden" id="cookMaster" value="${getMemberInformation.cookmaster}">
	<input type="hidden" id="couponCount" value="0">
	<input type="hidden" id="snsText" name="snsText">
	<input type="hidden" id="resultKiccProcess" name="resultKiccProcess" value="false">
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500100.gif" alt="퀸룸/파티룸예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500100.gif" alt="요리 시연을 위한 AP 퀸룸의 내역을 확인하실 수 있습니다."></p>
	</div>
	<div class="brIntro">
		<!-- @edit 20160701 인트로 토글 링크영역 변경 -->
		<h2 class="hide">퀸룸/파티룸 예약 필수 안내</h2>
		<a href="#uiToggle_01" class="toggleTitle"><strong>퀸룸/파티룸 예약 필수 안내</strong> <span class="btnArrow"><em class="hide">내용보기</em></span></a>				
		<div id="uiToggle_01" class="toggleDetail"> <!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</div>
	<div class="brWrapAll">
		<span class="hide">퀸룸/파티룸 예약 스텝</span>
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
							<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen"><span>AP 안내</span></a></span>
						</div>
						
						<!-- layer popup -->
						<%@ include file="/WEB-INF/jsp/reservation/exp/apInfoPop.jsp" %>
						<!--// layer popup -->
				
						<div class="brselectArea" id="ppAppend">
						</div>
						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_02.gif" alt="룸 선택"></h3>
						<div class="brselectArea sizeM" id="roomAppend">
						</div>
					</section>
					<section class="brSelectWrap">
						
						<!-- layer popup -->
						<div class="pbLayerWrap" id="uiLayerPop_w02" style="width:450px;display:none;">
							<div class="pbLayerHeader">
								<strong><img src="/_ui/desktop/images/academy/h1_w020500100_pop.gif" alt="안내"></strong>
								<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 상세보기 닫기"></a>
							</div>
							<div class="pbLayerContent">
								<p class="ptxt">선택하신 룸은 다목적 룸입니다.<br/>
								일반 교육장으로 사용시에는 [교육장 예약신청]을 선택하시고, 요리시연 목적으로 퀸쿡웨어를 사용시에는 [퀸룸/파티룸 예약신청] 을 선택하시기 바랍니다.</p>
								<div class="btnWrapC">
									<input type="button" id="eduApply" class="btnBasicBL" value="교육장 예약신청" />
									<input type="button" id="queenApply" class="btnBasicBL btnL" value="퀸룸/파티룸 예약신청" />
								</div>
							</div>
						</div>
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
			<% //<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
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
							<span class="btnR"><a href="javascript:void(0);" onclick="javascript:roomConfirmPop();" title="새창 열림" class="btnCont"><span>시설예약 현황확인</span></a></span>
						</div>
						<!-- 1월 jan, 2월 feb, 3월 mar, 4월 apr, 5월 may, 6월 june, 7월 july, 8월 aug, 9월 sep, 10월 oct, 11월 nov, 12월 dec -->
						<div class="calenderHeader">
						</div>
						<!-- @edit 20160701 달력 Session 삭제 및 예약가능날짜  -->
						<table class="tblBookCalendar">
						</table>
						<!-- @edit 20160701 문구추가 -->
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
						<!-- layer popup -->
						<div class="pbLayerWrap" id="uiLayerPop_w03" style="width:400px;">
							<div class="pbLayerHeader">
								<strong><img src="/_ui/desktop/images/academy/h1_w020500100_pop.gif" alt="안내"></strong>
								<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 상세보기 닫기"></a>
							</div>
							<div class="pbLayerContent">
								<p class="ptxt">요리명장으로 선정되어 월2회 무료사용이 가능합니다.<br /> 무료 또는 유료 예약여부를 선택해 주세요.<br /><br />※ 무료로 예약하는 경우, 사용예정일 1~7일 전까지 취소의 경우, 시설 이용한 것으로 간주하고 해당월 예약 횟수에 산정합니다.</p><br/>
								<div class="inputList">
									<span><input type="radio" id="rado1" name="rado1" value="nocost" /><label for="rado1">무료로 예약</label></span>
									<span><input type="radio" id="rado2" name="rado1" value="cost" /><label for="rado2">유료로 예약</label></span>
								</div>
								<div class="btnWrapC">
									<a href="#none" id="cookMasterConfirm" class="btnBasicBL">확인</a>
								</div>
							</div>
						</div>
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
			<% //<div class="modifyBtn"><a href="#none"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
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
							<span class="btnR"><a href="javascript:void(0);" onClick="javascript:roomIntroduceInfoPop();" title="새창 열림" class="btnCont" ><span>약관 및 동의 전체보기</span></a></span>
						</div>
						<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_06.gif" alt="교육장(퀸룸) 규정 동의" /></h3>
						<div class="agreeBox" style="height: 40px;">
							<div class="termsWrapper" tabindex="0">
								<c:out value="${clause01}" escapeXml="false" />
							</div>
						</div>
						<!-- @edit 20160701 문구 및 동의형식 변경 -->
						<div class="agreeBoxYN">
							<span>교육장(퀸룸) 운영 규정을 숙지하였으며, 규정에 동의하십니까?</span> <span class="inputR"><input type="checkbox" id="agreement1" name="agreement1" /><label for="agreement1">동의합니다.</label></span>
						</div>
						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_07.gif" alt="교육장(퀸룸) 제품 교육 시 주의사항" /></h3>
						<div class="agreeBox" style="height: 40px;">
							<div class="termsWrapper" tabindex="0">
								<c:out value="${clause02}" escapeXml="false" />
							</div>
						</div>
						<!-- @edit 20160701 문구 및 동의형식 변경 -->
						<div class="agreeBoxYN">
							<p>주의사항을 충분히 숙지 하였으며, 교육장(퀸룸) 제품 교육시 상기원칙을 준수합니다.</p>
							<span class="inputR"><input type="checkbox" id="agreement2" name="agreement2" /><label for="agreement2">동의합니다.</label></span>
						</div>
					</section>
					<section  class="creditWrap">
						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_08.gif" alt="신용카드" /></h3>
						<table class="tblInput">
							<caption>신용카드</caption>
							<colgroup>
								<col style="width:23%" />
								<col style="width:auto" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="thVerticalT">결제 요청 금액</th>
									<td id="totalPrice">0원(VAT 포함)</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">카드종류</th>
									<td><select id="bankid" name="bankid" title="카드종류">
											<c:forEach var="item" items="${bankInfo.list}" varStatus="status">
											<option value="${item.code}">${item.bank}</option>
											</c:forEach>
										</select>
										<a href="javascript:void(0);" onclick="javascript:benefitCardList();" class="btnCard">카드사 혜택 보기</a>
									</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">결제방식</th>
									<td>
										<input type="radio" class="radio1" id="radio1" name="paymentmode" value="easypay" class="radio1" /><label for="radio1">안심결제</label>
										<input type="radio" class="radio2" id="radio2" name="paymentmode" value="normal" checked="checked" class="radio2" /><label id="paymentMode-2" for="radio2">일반결제</label>
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
									<th scope="row" class="thVerticalT">카드구분</th>
									<td>
										<input type="radio" id="radio3" name="cardowner" value="personal" checked="checked"/><label for="radio3">개인카드</label>
										<input type="radio" id="radio4" name="cardowner" value="business" /><label for="radio4">법인카드</label>
									</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">카드번호</th>
									<td>
										<input type="text"     id="cardnumber1" name="cardnumber1" size="4" maxlength="4" title="카드번호 첫번째 4자리 입력" 
											style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope" /> -
											
										<input type="password" id="cardnumber2" name="cardnumber2" size="4" maxlength="4" title="카드번호 두번째 4자리 입력" 
											style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="new-password" /> -
											
										<input type="password" id="cardnumber3" name="cardnumber3" size="4" maxlength="4" title="카드번호 세번째 4자리 입력" 
											style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="new-password" /> -
											
										<input type="text"     id="cardnumber4" name="cardnumber4" size="4" maxlength="4" title="카드번호 네번째 4자리 입력" 
											style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">유효기간</th>
									<td>
										<input type="text" size="2" maxlength="2" id="cardmonth" name="cardmonth" style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope" /> <label for="cardmonth">월</label>
										<input type="text" size="2" maxlength="2" id="cardyear" name="cardyear" style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope" /> <label for="cardyear">년</label>
									</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">카드비밀번호</th>
									<td><label for="cardpw">비밀번호 앞 2자리</label> 
									<input type="password" size="2" maxlength="2" id="cardpassword" name="cardpassword" 
										style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="new-password" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">할부기간</th>
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
									<th scope="row" class="thVerticalT">생년월일</th>
									<td>
										<input type="text" size="6" maxlength="6" id="birthday" name="birthday" 
											style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope" /> <label for="birthday">(생년월일은 주민번호 앞 6자리와 동일하게 입력)</label>
									</td>
								</tr>
								<tr>
									<th scope="row" class="thVerticalT">사업자등록번호</th>
									<td>
										<input type="text" size="10" maxlength="10" id="biznumber" name="biznumber"
											style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope" /> <label for="biznumber">(사업자등록번호 10자리 '-'없이 입력)</label>
									</td>
								</tr>
							</tbody>
						</table>
						<!-- @edit 20160701 약관관련 전반적인 구성 변경 -->
						<div class="txtBtnBox">
							<span>소비자피해보상보험 가입 안내 : 전자상거래등에서의 소비자보호에관한 법률에 따라<br /> 직접판매공제조합에 가입하여 고객님의 결제금액에 대해 안전거래를 보장하고 있습니다.</span>
							<span class="btn"><a href="https://www.macco.or.kr/ko/cn/KOCNMC01.action" target="_blank" title="직접판매공제조합 새창열림" class="btnCont"><span>보험가입사실 확인</span></a></span>
						</div>
						
						<div class="agreeBoxYN">
							<span>주문하실 상품의 내용, 가격, 사용기간 등을 확인하였으며, 이에 동의하십니까?<br />(전자상거래법 제8조 제2항)</span>
							<span class="inputR"><input type="checkbox" id="agreement3" name="agreement3" /><label for="agreement3">동의합니다.</label></span>
						</div>
						<!-- //@edit 20160701 약관관련 전반적인 구성 변경 -->
						
						<h3><img src="/_ui/desktop/images/academy/h3_w02_aproom_09.gif" alt="[필수] 개인정보 수집/이용에 대한 동의" /></h3>
						<table class="tblList lineLeft">
							<caption>[필수] 개인정보 수집/이용에 대한 동의</caption>
							<colgroup>
								<col style="width:24%" />
								<col style="width:22%" />
								<col style="width:auto" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">목적</th>
									<th scope="col">항목</th>
									<th scope="col">이용&middot;보유기간</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>대금결제 서비스</td>
									<td>생년월일,<br />신용카드 정보</td>
									<td>계약 또는 청약철회 등에 관한 기록 5년<br />
									대금결제 및 재화 등의 공급에 관한 기록 5년</td>
								</tr>
							</tbody>
						</table>
						<!-- @edit 20160701 문구 및 동의형식 변경 -->
						<div class="agreeBoxYN">
							<span>위 결제정보 수집 및 이용 약관을 확인하였으며 이에 동의하십니까?</span>
							<span class="inputR"><input type="checkbox" id="agreement4" name="agreement4" /><label for="agreement4">동의합니다.</label></span>
						</div>
						<!-- @edit 20160627 문구 수정 -->
						<ul class="listWarning mgtS">
							<li>※ 개인정보 수집 및 이용에 대한 동의를 거부하실 수 있으나, 거부 시 상품의 구매, 대금 결제가 제한됩니다.</li>
							<li id="penaltyInfo">※ 사용일 <span id="typeValue">7</span>일 전 취소 시 결제 금액의 <strong style="color: red;"><span id="applyTypeValue">10</span>%의 취소 수수료</strong> 제외 후 환불 처리됩니다. (단 예약 당일취소 시 페널티가 적용되지 않습니다.)</li>
						</ul>
						<!-- //@edit 20160627 문구 수정 -->
					</section>
					<div class="btnWrapR">
						<a href="#step2" class="btnBasicGS" onclick="javascript:accordingNavagate.from3to2();" >이전</a>
						<a href="#step3" id="step3Btn" class="btnBasicBS">결제요청</a>
					</div>
				</div>
				<div class="result">
					<p>결제를 진행해 주세요.</p>
				</div>
				<div class="result req" style="display:none">
					<p>신용카드<em>|</em><span id="amountText">0원</span></p>
				</div>
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
				<a href="javascript:void(0);" onclick="javascript:accessParentPage();" class="btnBasicBL reservationCalendar">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</div>
	
</section>
<form id="tempForm" name="tempForm"></form>
<form id="clauseForm" name="clauseForm"></form>

<iframe id="paymentFrame" name="paymentFrame" src="" style="width:0; height:0; border:0;" />

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
<!-- //content area | ### academy IFRAME End ### -->
