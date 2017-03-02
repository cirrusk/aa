<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
var ppSeq = "";
var ppName = "";
var expseq = "";
var typeseq = "";
var sessionCnt = 0;

$(document.body).ready(function() {

	setPpInfoList();
	
// 	touchsliderFn();
	$("#stepDone").hide();
	$("#step2Btn").hide();
});



function setPpInfoList(){
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/searchExpSkinPpInfoListAjax.do'/>"
		, type : "POST"
		, async : false
		, success: function(data, textStatus, jqXHR){
			
			var ppList = data.ppCodeList;
			var lastPp = data.searchLastRsvPp;
			
			if(null == ppList || "" == ppList){
				alert("아직 프로그램이 등록되지 않았습니다. 운영자에 의해 프로그램이 등록 된 이후 사용 바랍니다.");
				return;
			}
			
			/**-----------------------캘린더의 필요한 현재 년,월 파라미터  셋팅-----------------------------*/
			
			var getMonth;
			var getYear;
			if(data.ppCodeList[0].getmonth < 10){
				getMonth  = "0"+data.ppCodeList[0].getmonth;
				getYear = data.ppCodeList[0].getyear;
			}else{
				getMonth  = data.ppCodeList[0].getmonth;
				getYear = data.ppCodeList[0].getyear;
			}
			
			
			$("#getYear").val(getYear);
			$("#getMonth").val(getMonth);
			
			$("#getYearPop").val("");
			$("#getMonthPop").val("");

			$("#getYearPop").val(getYear);
			$("#getMonthPop").val(getMonth);
			
			/**-----------------------------------------------------------------------------*/
			
			var html = "";
			
			for(var i = 0; i < ppList.length; i++){
				if(ppList[i].ppseq == lastPp.ppseq){
					html += "<a href='javascript:void(0);' class = 'active' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:detailPp('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', '"+ppList[i].expseq+"');\">"+ppList[i].ppname+"</a>";
					
					ppSeq = ppList[i].ppseq;
					ppName = ppList[i].ppname;
					expseq = ppList[i].expseq;
					
				}else{
					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:detailPp('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', '"+ppList[i].expseq+"');\">"+ppList[i].ppname+"</a>";
				}
			}
			
			$("#ppAppend").empty();
			$("#ppAppend").append(html);
// 			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 해당 pp의 준비물, 이용자격 등을 조회 */
function detailPp(getPpseq, getPpname, getExpseq){
	
	/* getPpseq : 사용자가 선택한 ppSeq, ppSeq : 기존 전역 변수에 저장 되었던 ppSeq  */
	if(getPpseq != ppSeq){
		/* 이전 pp선택 한것과 현재 선택한 pp가 다를 경우  해당 날짜에 세션 정보 삭제  */
		$("#appendSessionTable").empty();
		
		/* 전역 변수  ppSeq에 새로운  ppSeq를 삽입  */
		ppSeq = getPpseq;
		ppName = getPpname;
		expseq = getExpseq;
		
		$("#getMonth").val($("#getMonthPop").val());
		$("#getYear").val($("#getYearPop").val());
		
		/* 이전 pp선택 한것과 현재 선택한 pp가 다를 경우 캘린더 다시그리기  */
// 		nextMonthCalendar("F");
		
		$("#step2Btn").hide();
		
	}
	
	
	/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
	$(".active").attr("class", "");
	ppSeq = "";
	ppName = "";
	
	/* pp버튼 클릭시 선택 테두리 활성화*/
	$("#detailPpSeq"+getPpseq).attr("class", "active");
	ppSeq = getPpseq;
	ppName = getPpname;
	expseq = getExpseq;

	
	/* 해당 pp선택시 준비물&사진등 을 담고있는 화면 활성화 */
	$(".brSelectWrap").show();
	
	var param = {"commoncodeseq" : getPpseq};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expSkinDetailInfoAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var detailCode = data.expSkinDetailInfo;
			setDetailPp(detailCode);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


function setDetailPp(detailCode){
	
	var html = "";
	var nextBtnHtml = "";
	$("#roomImg").nextAll().remove();
	$(".roomSubText").remove();
	$("#step1Btn").remove();
	
	$("#skinIntro").css("display", "block");
	
	
	var tmpPreparation = detailCode.preparation.split(",");
	

	html  = "	<div class='roomSubText'>"+detailCode.productname+" - "+detailCode.content+"</div>";
	html += "	<dl class='roomTbl'>";
	html += "		<dt class='noneBdT'><span class='bizIcon icon1'></span>정원</dt>";
	html += "		<dd class='noneBdT'>"+detailCode.seatcount1+"</dd>";
	html += "		<dt><span class='bizIcon icon2'></span>체험시간</dt>";
	
	if (detailCode.usetimenote == null || detailCode.usetimenote == "" || detailCode.usetimenote == "undefined") {
		html += "		<dd>"+detailCode.usetime+"<br />("+detailCode.usetimenote+")</dd>";
	} else {
		html += "		<dd>"+detailCode.usetime+"</dd>";
	}

	html += "		<dt><span class='bizIcon icon3'></span>예약자격</dt>";
	html += "		<dd>"+detailCode.role+"이상<br/><span class='fsS'>("+detailCode.rolenote+")</span></dd>";
	html += "		<dt><span class='bizIcon icon5'></span>준비물</dt>";
	if(tmpPreparation.length > 1){
		html += "	<dd>"+tmpPreparation[0]+"<br />"+tmpPreparation[1]+"</dd>";
	}else{
		html += "	<dd>"+tmpPreparation[0]+"</dd>";
	}

	nextBtnHtml += "<div class='btnWrap'>";
	nextBtnHtml += "	<a href='javascript:void(0);' id='step1Btn' class='btnBasicBL stepButton' onclick='javascript:nextStep();'>다음</a>";
	nextBtnHtml += "</div>";
	
	$("#afterUseTimeTip").empty();	/* 이용시간(달력밑의 팁) */
	$("#afterUseTimeTip").append(detailCode.usetime);
	
	$(".roomInfo").append(html);
	$("#skinIntro").append(nextBtnHtml);
	
	$("#getDayPop").val(detailCode.gettoday.substr(6,2));
	
	expseq = detailCode.expseq;
	typeseq = detailCode.typeseq;
	
	if(
			(detailCode.filekey1 == null || detailCode.filekey1 == 0)
			&& (detailCode.filekey2 == null || detailCode.filekey2 == 0)
			&& (detailCode.filekey3 == null || detailCode.filekey3 == 0)
			&& (detailCode.filekey4 == null || detailCode.filekey4 == 0)
			&& (detailCode.filekey5 == null || detailCode.filekey5 == 0)
			&& (detailCode.filekey6 == null || detailCode.filekey6 == 0)
			&& (detailCode.filekey7 == null || detailCode.filekey7 == 0)
			&& (detailCode.filekey8 == null || detailCode.filekey8 == 0)
			&& (detailCode.filekey9 == null || detailCode.filekey9 == 0)
			&& (detailCode.filekey10 == null || detailCode.filekey10 == 0)
			){
			
			var html = "";
			$("#touchSlider ul").empty();
			html ="<li></li>";
			$("#touchSlider ul").append(html);
// 			touchsliderFn();
		}else{
			
			var filekey =[
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
			
			setFileKeyList(filekey);
		}
	
}

function setFileKeyList(filekey){
	
var param = {filekey : filekey};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/searchExpSkinFileKeyListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var imageFileKeyList = data.expImageFileKeyList;
			
			$("#touchSlider ul").empty();
		
			var html = "";
			
			for(var i = 0; i < imageFileKeyList.length; i++){
				html +="	<li style='float: none; display: block; position: absolute; top: 0px; left: 0px; width: 228px; height: 148px;'>";
// 				html +="		<img src='/mobile/reservation/imageView.do?filefullurl="+imageFileKeyList[i].filefullurl+"&storefilename="+imageFileKeyList[i].storefilename+"'>";
				html +="		<img src='/mobile/reservation/imageView.do?file="+imageFileKeyList[i].storefilename+"&mode=RESERVATION'>";
				html +="	</li>";
			}
			
			$("#touchSlider ul").append(html);
			
			touchsliderFn();
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setCalendarClassName(yearMonthList) {
	
	var html = "";
	var tempYear = "";
	var tempMonth = "";
	
// 	html += "<span class='year'>"+yearMonthList[0].year+"</span>";
	html += "<div class='monthlyWrap' id='viewTempMonth'>";
	for(var i = 0; i < yearMonthList.length; i++){

		if(i >= 7){
			break;
		}
		
		if(i == 0){
			tempYear = yearMonthList[i].year;
			tempMonth = yearMonthList[i].month;
			
			html += "<span><span class=\"year\">"+yearMonthList[i].year+"</span>";
			html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+yearMonthList[i].year+"', '"+yearMonthList[i].month+"');\" class=\"on\">"+yearMonthList[i].month+"<span>月</span></a></span>";

		}else if(yearMonthList[i].year != tempMonth && yearMonthList[i].month == 1){
			
			html += "<span><span class=\"year\">"+yearMonthList[i].year+"</span>";
			html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+yearMonthList[i].year+"', '"+yearMonthList[i].month+"');\">"+yearMonthList[i].month+"<span>月</span></a></span>";
			
		}else{
			html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+yearMonthList[i].year+"', '"+yearMonthList[i].month+"');\">"+yearMonthList[i].month+"<span>月</span></a></span>";
		}
		
		if(yearMonthList.length != i + 1){
			html += "<em>|</em>";
		}
		
// 		if( i == 0){
// 			html += "	<span><a href='javascript:void(0);' onclick=\"javascript:changeMonth(this, '"+yearMonthList[i].year+"', '"+yearMonthList[i].month+"');\" class='on'>"+yearMonthList[i].month+"<span>月</span></a></span>";
// 		}else{
// 			html += "	<span><a href='javascript:void(0);' onclick=\"javascript:changeMonth(this, '"+yearMonthList[i].year+"', '"+yearMonthList[i].month+"');\">"+yearMonthList[i].month+"<span>月</span></a></span>";
// 		}
	}
	
	html += "</div>";
	html += "<div class='hText availabilityCount'>";
	html += "</div>";
	
	$("#getYearPop").val(yearMonthList[0].year);
	
	if(yearMonthList[0].month < 10){
		$("#getMonthPop").val("0"+yearMonthList[0].month);
	}else{
		$("#getMonthPop").val(yearMonthList[0].month);
		
	}
	
 	$("#ppName").empty();
 	$("#ppName").append(ppName);
 	
 	$("#appendYYMM").empty();
 	$("#appendYYMM").append(html);
 	
 	
}

function searchExpPenalty(){
	var param = {
		expseq : this.expseq
	}
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchExpPenaltyAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){

		var expPenalty = data.searchExpPenalty;
		
		if(null == data.searchExpPenalty){
			$("#penaltyInfo").hide();
		}else{
			$("#penaltyInfo").show();
			$("#penaltyInfo").empty();
			$("#penaltyInfo").append("※ 측정 예약 후, 사전 취소 없이 불참하실 경우  <strong id='applyTypeValue'>"+expPenalty.applytypevalue+"일</strong>간 패널티가 적용됩니다.");
		}
		
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}


/* 다음달 캘린더의 날짜 호출 한다. */
function nextMonthCalendar(flag){
	var param = {
		  getYear :  $("#getYear").val()
		, getMonth : $("#getMonth").val()
		, ppSeq : ppSeq
		, expseq : expseq
	};
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/expSkinNextMonthCalendarAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){

		
			/* 다음달 날짜 리스트 */
			var calList = data.nextMonthCalendar;
			
			/* 캘린더에 해당 pp의 휴무일의 정보를 담기 위한 휴무일 데이터 */
			var hoilDayList = data.searchExpSkinHoliDayList;
			
			/* 예약 가능한 세션의 수  */
			var rsvAbleCntList = data.rsvAbleCntList;
			
			/* 클래스 명으로 사용될 영어 월, 월, 년도 리스트 */
			var yearMonthList = data.nextYearMonth;
			
			/* 다음달 캘린더를 그리는 함수 호출 */
			gridNextMonth(calList, hoilDayList);
			
			/* 예약 가능한 세션의 수  */
			setRsvAbleCnt(rsvAbleCntList);
			
// 			if(flag == "F"){
			if($("#getMonthPop").val() == $("#getMonth").val()){
				setCalendarClassName(yearMonthList);
			}
			
			getRsvAvailabilityCount();
			
			setTimeout(function(){ abnkorea_resize(); }, 700);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}


/* 누적 예약 가능 횟수 (월, 주, 일) 조회 */
function getRsvAvailabilityCount() {
	var param = {
			  ppseq : ppSeq
			, typeseq : typeseq
			, expseq : expseq
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

/* 달력 그리기 */
function gridNextMonth(calList, hoilDayList){
	/* 
		1. 달력을 먼저 그린다.
		2. 그려진 달력에 데이터를 삽입한다.
	*/
	
	var html = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	
	$("#nextMontCalTbody").empty();
	
	for(var i = 0; i < calList.length; i++){
		html += "<tr>";
		html += "		<td class='weekSun'><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekSun+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekSun+"');\">"+calList[i].weekSun.replace(/(^0+)/, "");+"</a></td>";
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekMon+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekMon+"');\">"+calList[i].weekMon.replace(/(^0+)/, "");+"</a></td>";
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekTue+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekTue+"');\">"+calList[i].weekTue.replace(/(^0+)/, "");+"</a></td>";
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekWed+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekWed+"');\">"+calList[i].weekWed.replace(/(^0+)/, "");+"</a></td>";
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekThur+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekThur+"');\">"+calList[i].weekThur.replace(/(^0+)/, "");+"</a></td>";
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekFri+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekFri+"');\">"+calList[i].weekFri.replace(/(^0+)/, "");+"</a></td>";
		html += "		<td class='weekSat'><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekSat+"' onclick=\"javascript:deleteSelcOnCal('"+calList[i].weekSat+"');\">"+calList[i].weekSat.replace(/(^0+)/, "");+"</a></td>";
		html += "</tr>";
	}
	$("#nextMontCalTbody").append(html);
	
	/* 해당 pp의 휴무일을 캘린더상에 표현한다.  */
	calendarSetData(hoilDayList);
	
//  	getRemainDayByMonth();
	
}


/* 잔여일 표시 - 달력의 '월'을 클릭 후 우상단에 남은 잔여일을 쿼리 하는 기능 */
function getRemainDayByMonth(){
	var param = {
		  reservationdate : $("#getYear").val() + $("#getMonth").val() + "01"
		, rsvtypecode : "R02"
		, ppseq : ppSeq
		, typeseq : typeseq
		, expseq : expseq
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


/* 해당 pp의 휴무일을 캘린더상에 표현한다. */
function calendarSetData(hoilDayList){
	var html = "";
	var tempI = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	for(var i = 1; i < 32; i++){
		if(i < 10){
			tempI = "0"+i;
		}else{
			tempI = i;
		}
		for(var j = 0; j < hoilDayList.length; j++){
			if($("#cal"+yymm+tempI).text() == Number(hoilDayList[j].setdate)){
				
				$("#cal"+yymm+tempI).parent().addClass("late");
				$("#cal"+yymm+tempI).removeAttr("onclick");
				html = "<span>휴무</span>";
				
				$("#cal"+yymm+tempI).append(html);
				
				sessionCnt ++;
			}
		}
	}
}



function setRsvAbleCnt(rsvAbleCntList){
	
	var html = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();

	var tempSettypecode = "";
	var tempWorktypecode = "";
	var tempSetdate = "";
	var tempGetYmd = "";
	
	if(rsvAbleCntList.length == 0){
		$("#nextMontCalTbody").find("td").each(function(){
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
			
		});
		
		var months = $(".monthlyWrap > a").length;
		
        if( 1 < months ) {
			msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
        
        alert(msg);
		
		return false;
	}
	

	
	for(var i = 0; i < rsvAbleCntList.length; i++){
		
		if(tempGetYmd != rsvAbleCntList[i].getymd){
			tempSettypecode = rsvAbleCntList[i].settypecode;
			tempWorktypecode = rsvAbleCntList[i].worktypecode;
			tempSetdate = rsvAbleCntList[i].setdate;
			tempGetYmd = rsvAbleCntList[i].getymd;
		}
		
	
		if(rsvAbleCntList[i].settypecode == tempSettypecode){
// 			if(rsvAbleCntList[i].gettoday < rsvAbleCntList[i].getymd && $("#cal"+rsvAbleCntList[i].getymd).children("span").text() == ""){
			if($("#cal"+rsvAbleCntList[i].getymd).children("span").text() == ""){
				if(rsvAbleCntList[i].rsvsessiontotalcnt != 0){
					html = "<span style='color: #666;'> ("+rsvAbleCntList[i].rsvsessiontotalcnt+")</span>";
					$("#cal"+rsvAbleCntList[i].getymd).append(html);
				}else if(rsvAbleCntList[i].rsvsessiontotalcnt == 0){
					if(rsvAbleCntList[i].rsvsessioncnt == 0 && rsvAbleCntList[i].rsvsessiontotalcnt == 0 && rsvAbleCntList[i].totalsessioncnt == 0){
						$("#cal"+rsvAbleCntList[i].getymd).parent().addClass("late");
			 			$("#cal"+rsvAbleCntList[i].getymd).removeAttr("onclick");
			 			
			 			sessionCnt ++;
			 			
					}else{
						$("#cal"+rsvAbleCntList[i].getymd).parent().addClass("late");
			 			$("#cal"+rsvAbleCntList[i].getymd).removeAttr("onclick");
			 			html = "<span>예약마감</span>";
			 			$("#cal"+rsvAbleCntList[i].getymd).append(html);
					}
				}
			}else if(rsvAbleCntList[i].gettoday >= rsvAbleCntList[i].getymd){
				$("#cal"+rsvAbleCntList[i].getymd).parent().addClass("late");
	 			$("#cal"+rsvAbleCntList[i].getymd).removeAttr("onclick");
	 			
	 			sessionCnt ++;
			}
		}
	}
	
	if(sessionCnt == Number(rsvAbleCntList[0].getlastday)){
		
		var months = $(".monthlyWrap > span").length;
		
        if( 1 < months ) {
			msg = "이번 달에 예약 가능한 일자가 없습니다.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
        
        alert(msg);
        
		return true;
	}
	
	$("#nextMontCalTbody").find("td").each(function(){
		if($(this).find("span").length == 0){
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
		}
		
	});
}


/* 캘린더 에서 선택한 세션 & 날짜 삭제 */
function deleteSelcOnCal(date){
	var tempDate = date;
	var year = $("#getYear").val();
	var month = $("#getMonth").val();
	
	/* 데이터가 없을 경우  */
	if( date == ""){
		return false;
	}else{
		
		/* 캘린더에서 날짜가  이미 선택이 된 경우  해당 날짜의 세션과 캘린의 선택을 지워줌 */
		if($("#cal"+year+month+date).attr("class") == "selcOn"){
			$("#cal"+year+month+date).removeAttr("class");
			$("#"+year+month+tempDate).parent().remove();
			
		/* 캘린더에 새로운 날짜를 선택한 경우 */
		}else{
			$("#cal"+year+month+date).attr("class", "selcOn");
			//$(".brSessionWrap").show();
			
			/* 선택 날짜의 세션 정보 상세보기 */
			showSession(tempDate, year, month);
		}
	}
	
	$(".ddCon").children().each(function(){
		
		if($(".active").length <= 1){
			$("#step2Btn").hide();
		}else{
			$("#step2Btn").show();
		}
	});
	
	if($("#appendSessionTable").children().length == 0){
		$("#step2Btn").hide();
	}
}



/* 선택 날짜의 세션 상세보기 */
function showSession(tempDate, year, month){
	
	var param = {
		  ppSeq : ppSeq
		, year : year
		, month : month
		, date : tempDate
		, expseq : expseq
	};
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/searchSkinSeesionListAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var html = "";
			var sessionTime = data.searchStartSeesionTimeListAjax;
			
			html = "<div class='selDateBox'>";
			html +=	"<div class='dtTit' id="+sessionTime[0].idvalue+">"+sessionTime[0].date+"<a href='javascript:void(0);' class='btnDel' onclick='javascript:deleteSessionDetail(this)'>삭제</a></div>";
			html +=		"<div class='ddCon'>";
			html +=			"<div class='selectArea'>";
			
			for(var i = 0 ; i < sessionTime.length; i++){
				/* 대기자는 없고 신청된 예약이 존재하면 예약 대기 */
				if(sessionTime[i].rsvflag == 200){
					html +=	"<a href= 'javascript:void(0);' id='"+sessionTime[i].idvalue+"_"+sessionTime[i].expsessionseq+"' name = 'startSession' onclick='javascript:selectedSession(this)' class='line2'>"+sessionTime[i].tempstartdatetime+"<span>(대기신청)</span>";
					html +=	"<input type= 'hidden' name ='tempExpSessionseq' value = '"+sessionTime[i].expsessionseq+"'>";
					html +=	"<input type= 'hidden' name ='tempSessionTime' value = '"+sessionTime[i].session+"'>";
					html +=	"<input type= 'hidden' name ='tempRsvflag' value = '"+sessionTime[i].rsvflag+"'>";
					html +=	"<input type= 'hidden' name ='tempStartdatetime' value = '"+sessionTime[i].startdatetime+"'>";
					html +=	"<input type= 'hidden' name ='tempEnddatetime' value = '"+sessionTime[i].enddatetime+"'>";
					
					html +=	"<input type= 'hidden' name ='tempDateFormat' value = '"+sessionTime[i].date+"'>";
					html +=	"<input type= 'hidden' name ='tempReservationDate' value = '"+sessionTime[i].idvalue+"'></a>";
				}else if(sessionTime[i].rsvflag == 300){
				/* 대기자도 있고 신청된 예약도 있음 예약 마감 */
					html +=	"<a href= 'javascript:void(0);' id='"+sessionTime[i].idvalue+"_"+sessionTime[i].expsessionseq+"' name = 'startSession' class='line2'>"+sessionTime[i].tempstartdatetime+"<span>(예약마감)</span>"
				}else if(sessionTime[i].rsvflag == 100){
				/* 대기자도 없고 신청된 예약도 없음 */
					html +=	"<a href= 'javascript:void(0);' id='"+sessionTime[i].idvalue+"_"+sessionTime[i].expsessionseq+"' name = 'startSession' onclick='javascript:selectedSession(this)'>"+sessionTime[i].tempstartdatetime;
					html +=	"<input type= 'hidden' name ='tempExpSessionseq' value = '"+sessionTime[i].expsessionseq+"'>";
					html +=	"<input type= 'hidden' name ='tempSessionTime' value = '"+sessionTime[i].session+"'>";
					html +=	"<input type= 'hidden' name ='tempRsvflag' value = '"+sessionTime[i].rsvflag+"'>";
					html +=	"<input type= 'hidden' name ='tempStartdatetime' value = '"+sessionTime[i].startdatetime+"'>";
					html +=	"<input type= 'hidden' name ='tempEnddatetime' value = '"+sessionTime[i].enddatetime+"'>";
					
					html +=	"<input type= 'hidden' name ='tempDateFormat' value = '"+sessionTime[i].date+"'>";
					html +=	"<input type= 'hidden' name ='tempReservationDate' value = '"+sessionTime[i].idvalue+"'></a>";
				}
			}
			html +=			"</div>";
			html +=		"</div>";
			html +=	"</div>";
			$("#appendSessionTable").append(html);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	
}

function selectedSession(obj){
	if($(obj).is(".active") === true){
		if($(obj).children().find("line2 active") == true){
			$(obj).removeClass("active");
		}else{
			$(obj).removeClass("active");
		}
	}else if($(obj).children().find("line2") === true){
		$(obj).addClass("active line2");
	}else{
		$(obj).addClass("active");
	}
	
	$(".ddCon").children().each(function(){
		
		if($(".active").length <= 1){
			$("#step2Btn").hide();
		}else{
			$("#step2Btn").show();
		}
	});
}

/* 세션 테이블에서 삭제 버튼 클릭  */
function deleteSessionDetail(obj){
	/* 세션 테이블에 id값이 년 월 일 이기 때문에 세션테이블에 id값과 캘린더 상에 날짜(캘린더 속 날짜 또한 날짜가 id값) 매칭 시켜 삭제함 */
	
	/* 세션 테이블에 id값 가져오기  */
	var selectedDate = $(obj).parent().attr("id");
	
	$("#cal"+selectedDate).removeAttr("class");
	$(obj).parent().parent().remove();
	
	if($("#appendSessionTable").children().length == 0){
		$("#step2Btn").hide();
	}

	$(".ddCon").children().each(function(){
		
		if($(".active").length <= 1){
			$("#step2Btn").hide();
		}else{
			$("#step2Btn").show();
		}
	});
}


function nextStep(){
	
	
	sessionCnt = 0;

	if($("#appendSessionTable").children().length == 0){
		/* 패널티 정보 조회 */
		searchExpPenalty();	
	
		nextMonthCalendar("F");
	}
	
	$("#appendPPName").empty();
	$("#appendPPName").append(ppName);
	
	var stepWrap = $('.bizEduPlace');
	var stepResult = $('.bizEduPlace').find('.result'); //결과값
	var selectDiv = $('.bizEduPlace').find('.selectDiv'); //펼쳤을때 전체영역
	var selcWrapDt = $('.selcWrap>dt');
	var selcWrapDd = $('.selcWrap>dd');
	var stepButton = $('.btnWrap > .btnBasicBL');
	var prevButton = $('.btnWrap > .btnBasicGL');
	
	stepResult.hide();
	selcWrapDd.hide();
	selcWrapDt.show();
	//selectDiv.eq(0).find(selcWrapDd).show();
	selcWrapDd.eq(2).show();
	selcWrapDd.eq(3).show();
	
	
	$('.selectArea.local>a').each(function(){
		$(this).click(function(){
			$(this).parent().parent().next().slideDown();
		})
	});
	$('.selectArea.room>a').each(function(){
		$(this).click(function(){
			$(this).parent().parent().next().slideDown(function(){
				touchsliderFn();
			});
		})
	});
	
	
	$("#step1Btn").parents('.bizEduPlace').find('.result').show();
	$("#step1Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
	
	//다음 버튼 클릭 시
	$(stepButton).each(function(){
		$("#step1Btn").click(function(){
			$("#step2SelectDiv").parents('.bizEduPlace').find('.result').show();
			$(this).parents('.bizEduPlace').find('.selectDiv').slideUp();
			
			//다음 섹션열기
			var $nextStep = $(this).parents('.bizEduPlace').next();
			$nextStep.addClass('current').find('.selectDiv').slideDown();
			$nextStep.find(stepResult).hide();
			$nextStep.find(selectDiv).show();
			$nextStep.find(selcWrapDd).show();
		});
	});
	
	/* move to... */
	var $pos = $("#step2SelectDiv");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 300);

}


/* 피부 측정 예약 요청(선텍된 값들을 팝업 으로 보낸다) */
function reservationReq(){
	
	$("#expSkinFormForPopup").empty();
	$("#checkLimitCount").empty();
	
	var currentMonth = $("#expSkinForm > #getMonth").val();
	var currentYear = $("#expSkinForm > #getYear").val();
	
	$("#expSkinFormForPopup").html("");
	
	$("#expSkinFormForPopup").append("<input type='hidden' name='getMonth' value='" + currentMonth + "' > ");
	$("#expSkinFormForPopup").append("<input type='hidden' name='getYear' value='" + currentYear + "' > ");
	
	var cnt = 0;
	$("a[name=startSession]").each(function(index) {
		
		if($(this).is(".active") === true){
			
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'expsessionseq' value = '"+$(this).find("input[name='tempExpSessionseq']").val()+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'sessionTime' value = '"+$(this).find("input[name='tempSessionTime']").val()+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'rsvflag' value = '"+$(this).find("input[name='tempRsvflag']").val()+"'>");
			
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'startdatetime' value = '"+$(this).find("input[name='tempStartdatetime']").val()+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'enddatetime' value = '"+$(this).find("input[name='tempEnddatetime']").val()+"'>");
			
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'dateFormat' value = '"+$(this).find("input[name='tempDateFormat']").val()+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'reservationDate' value = '"+$(this).find("input[name='tempReservationDate']").val()+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'ppSeq' value = '"+ppSeq+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'ppName' value = '"+ppName+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'expseq' value = '"+expseq+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'typeSeq' value = '"+typeseq+"'>");
			$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'accounttype' value = 'A01'>");
			
			$("#checkLimitCount").append("<input type= 'hidden' name = 'reservationDate' value = '"+$(this).find("input[name='tempReservationDate']").val()+"'>");
			$("#checkLimitCount").append("<input type= 'hidden' name = 'typeSeq' value = '"+typeseq+"'>");
			
			
			cnt ++;
		}
		
	});
	
	/* 세션 선택이 없을 경우 step2의 달력을 오픈한다 */
	if(cnt == 0){
		
		$("#step2SelectDiv").parent().removeClass("finish");

		alert("세션을 선택해 주십시오.");
		
		$("#step2SelectDiv").slideDown();
		
		//$("#step2SelectDiv").css("display","block");
		
	}else{
		
		/* 패널티 유효성 중간 검사 */
		if(middlePenaltyCheck()){
			/* typeseq, ppseq, roomseq 일, 주, 월 예약 가능 횟수 조회 변수*/
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeseq\" value=\""+typeseq+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"ppseq\" value=\""+ppSeq+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+expseq+"\">");
			 
			$.ajaxCall({
				  url: "<c:url value='/reservation/rsvAvailabilityCheckAjax.do'/>"
				, type : "POST"
				, data: $("#checkLimitCount").serialize()
				, success: function(data, textStatus, jqXHR){
				if(data.rsvAvailabilityCheck){
					
					duplicateCheck();
					
	// 				setTimeout(function(){ abnkorea_resize(); }, 500);
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
}

function middlePenaltyCheck() {
	
	var penaltyCheck = true;
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/rsvMiddlePenaltyCheckAjax.do'/>"
		, type : "POST"
		, data: $("#checkLimitCount").serialize()
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

/* 예약 가능 체크 */
function duplicateCheck() {
	
	var param = $("#expSkinFormForPopup").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expSkinDuplicateCheckAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var cancelDataList = data.cancelDataList;
			
			if(cancelDataList.length == 0){
				/* 예약정보 확인 팝업 */
				expSkinRsvRequestPop();
			}else{
				/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
				expSkinDisablePop(cancelDataList);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 정상 예약 호출*/
function expSkinRsvRequestPop(){
	
	/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
	var param = $("#expSkinFormForPopup").serialize();
	
	$.ajaxCall({
		url: "<c:url value="/mobile/reservation/expSkinRsvRequestPop.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){

			var expSkinRsvInfoList = data.expSkinRsvInfoList;
			var totalCnt = data.totalCnt;
			var partnerTypeCodeList = data.partnerTypeCodeList;
			
			setReservationReq(expSkinRsvInfoList, totalCnt, partnerTypeCodeList);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 예약불가 알림 팝업(중복체크) */
function expSkinDisablePop(cancelDataList) {
	/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
	layerPopupOpen("<a href=\"#uiLayerPop_cannot\">");
	/* 중복 데이터 삭제 */
	var html = "";
	for(var num in cancelDataList){
		var standByNumber = "";
		if(cancelDataList[num].standbynumber == "1"){
			standByNumber = "(대기신청)";
		}
		html += "<span class=\"point1\">";
		html += cancelDataList[num].ppname + " <em>|</em> ";
		html += cancelDataList[num].programname + " <em>|</em> ";
		html += cancelDataList[num].reservationdate + " <em>|</em> ";
		html += cancelDataList[num].sessionname + standByNumber + "<br/>"
		html += "</span>";
		
		html += "<input type='hidden' name='cancelKey' value='" + cancelDataList[num].reservationdate + '_' + cancelDataList[num].expsessionseq + "'>";
		
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
			$("#" + $(this).val()).removeClass("active");
		});
	
		/* 세션 갱신 후 재예약 요청 */
		reservationReq();
		
	}
	
	cannotClosePop();
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

function setReservationReq(expSkinRsvInfoList, totalCnt, partnerTypeCodeList){
	var html = "";
	
	$("#uiLayerPop_confirm").css("display", "block");
	$("#rsvConform").empty();
	
	html  = "<thead>";
	html += "	<tr><th scope='col' colspan='2'>"+expSkinRsvInfoList[0].ppName+"<em>|</em> 피부측정</th></tr>";
	html += "</thead>";
	html += "<tfoot>";
	html += "	<tr>";
	html += "		<td colspan='2'>총 "+totalCnt+"건</td>";
	html += "	</tr>";
	html += "</tfoot>";
	html += "<tbody>";
	
	for(var i = 0; i < expSkinRsvInfoList.length; i++){
		html += "<tr>";
		html += "	<th scope='row' class='bdTop'>날짜</th>";
		html += "	<td class='bdTop'>"+expSkinRsvInfoList[i].dateFormat+"</td>";
		html += "</tr>";
		html += "<tr>";
		html += "	<th scope='row'>체험시간</th>";
		
		if(expSkinRsvInfoList[i].rsvflag == "100"){
			html += "	<td>"+expSkinRsvInfoList[i].sessionTime+"</td>";
		}else if(expSkinRsvInfoList[i].rsvflag == "200"){
			html += "	<td>"+expSkinRsvInfoList[i].sessionTime+" (대기신청)</td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "	<th scope='row'>동반여부</th>";
		html += "	<td>";
		html += "		<select title='동반여부 선택' name='partnerTypeCode'>";
		html += "			<option value=''>선택해주세요</option>";
		for(var j = 0; j < partnerTypeCodeList.length; j++){
			html += "		<option value='"+partnerTypeCodeList[j].commonCodeSeq+"'>"+partnerTypeCodeList[j].codeName+"</option>";
		}
		html += "		</select>";
		html += "	</td>";
		html += "</tr>";
	}
	html += "</tbody>";
	
	
	$("#rsvConform").append(html);
	
	layerPopupOpen("<a href='#uiLayerPop_confirm' class='btnBasicBL'>예약요청</a>");
	$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:expSkinReservation(this)");
	
	rsvConfirmPop_resize();
}

function prvStep(){

	$("#step2Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
	$("#step2Btn").parents('.bizEduPlace').find('.result').show();
	$("#step2Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
	
	$("#step1Btn").parents("dd").show();
	$("#step1Btn").parents(".bizEduPlace").find(".selectDiv").show();
	$("#step1Btn").parents(".bizEduPlace").find(".result").hide();
}

function closePop(){
	
	$("#uiLayerPop_confirm").css("display", "none");
	$("#step2Result").css("display", "none");
	$("#step2SelectDiv").css("display", "block");
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

function setExpSkinReservation(expSkinRsvList, totalCnt){
	
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	$("#stepDone").show();
	
	var html = "";
	var snsHtml = "";
	
	$("#step2tWrap").empty();
	
	$("#uiLayerPop_confirm").hide();
	$("#layerMask").remove();
	
	html  = "<em class='bizIcon step02'></em><strong class='step'>STEP2/ 날짜, 시간</strong>";
	html += "<span>총"+totalCnt+"건</span>";
	html += "<div class='resultDetail'>";
	
	
	snsHtml = "[한국암웨이]시설/체험 예약내역 (총 "+totalCnt+"건) \n";
	
	for(var i = 0; i < expSkinRsvList.length; i++){
		
		/* 동반자 여부가 R01 -> ABO */
		if(expSkinRsvList[i].partnerTypeCode == "R01"){
			/* 대기 여부 100 -> 예약  신청 */
			if(expSkinRsvList[i].rsvflag == "100" && expSkinRsvList[i].standbynumber == "0" ){
				html += "<span>"+expSkinRsvList[i].dateFormat+"<em class='bar'>|</em><br />"+expSkinRsvList[i].sessionTime+"<em class='bar'>|</em>ABO동반</span>";
				
				snsHtml += "■"+expSkinRsvList[i].ppName+"(피부측정)"+expSkinRsvList[i].dateFormat + "| \n" 
						+ expSkinRsvList[i].sessionTime + "| ABO동반\n";
			}else if(expSkinRsvList[i].rsvflag == "200" || expSkinRsvList[i].standbynumber == "1"){
			/* 대기 여부 200 -> 예약대기 */
				html += "<span>"+expSkinRsvList[i].dateFormat+"<em class='bar'>|</em><br />"+expSkinRsvList[i].sessionTime+"(대기신청)<em class='bar'>|</em>ABO동반</span>";
				
				snsHtml += "■"+expSkinRsvList[i].ppName+"(피부측정)"+expSkinRsvList[i].dateFormat + "| \n" 
						+ expSkinRsvList[i].sessionTime + "(대기신청) | ABO동반\n";
			}
		}else if(expSkinRsvList[i].partnerTypeCode == "R02"){
		/* 동반자 여부 R02 -> 일반인 */
		
			/* 대기 여부 100 -> 예약  신청 */
			if(expSkinRsvList[i].rsvflag == "100" && expSkinRsvList[i].standbynumber == "0"){
				html += "<span>"+expSkinRsvList[i].dateFormat+"<em class='bar'>|</em><br />"+expSkinRsvList[i].sessionTime+"<em class='bar'>|</em>일반인동반</span>";
			
				snsHtml += "■"+expSkinRsvList[i].ppName+"(피부측정)"+expSkinRsvList[i].dateFormat + "| \n" 
						+ expSkinRsvList[i].sessionTime + "| 일반인동반\n";
				
			}else if(expSkinRsvList[i].rsvflag == "200" || expSkinRsvList[i].standbynumber == "1"){
			/* 대기 여부 200 -> 예약대기 */
				html += "<span>"+expSkinRsvList[i].dateFormat+"<em class='bar'>|</em><br />"+expSkinRsvList[i].sessionTime+"(대기신청)<em class='bar'>|</em>일반인동반</span>";
				
				snsHtml += "■"+expSkinRsvList[i].ppName+"(피부측정)"+expSkinRsvList[i].dateFormat + "| \n" 
						+ expSkinRsvList[i].sessionTime + "(대기신청) | 일반인동반\n";
			}
		
		}else{
			/* 대기 여부 100 -> 예약  신청 */
			if(expSkinRsvList[i].rsvflag == "100" && expSkinRsvList[i].standbynumber == "0"){
				html += "<span>"+expSkinRsvList[i].dateFormat+"<em class='bar'>|</em><br />"+expSkinRsvList[i].sessionTime+"<em class='bar'>|</em>비동반</span>";
			
				snsHtml += "■"+expSkinRsvList[i].ppName+"(피부측정)"+expSkinRsvList[i].dateFormat + "| \n" 
						+ expSkinRsvList[i].sessionTime +  "| 비동반\n";
				
			}else if(expSkinRsvList[i].rsvflag == "200" || expSkinRsvList[i].standbynumber == "1"){
			/* 대기 여부 200 -> 예약대기 */
				html += "<span>"+expSkinRsvList[i].dateFormat+"<em class='bar'>|</em><br />"+expSkinRsvList[i].sessionTime+"(대기신청)<em class='bar'>|</em>비동반</span>";
				
				snsHtml += "■"+expSkinRsvList[i].ppName+"(피부측정)"+expSkinRsvList[i].dateFormat + "| \n" 
						+ expSkinRsvList[i].sessionTime +  "(대기신청) | 비동반\n";
				
			}
		}
		
		
	}
	html += "</div>";
	
	
	$("#step2tWrap").append(html);
	
	$("#snsText").empty();
	$("#snsText").val(snsHtml);
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}


function expSkinReservation(obj){
	
	if(!mendatoryCheck.partnerSelectbox()){
		return;
	}
	
	$(obj).removeAttr("onclick");
	
	$("select[name=partnerTypeCode]").each(function(){
		$("#expSkinFormForPopup").append("<input type= 'hidden' name = 'partnerTypeCode' value = '"+$(this).val()+"'>");
	});
	
	var param = $("#expSkinFormForPopup").serialize();
	
		$.ajaxCall({
			url: "<c:url value='/mobile/reservation/expSkinInsertAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
			
				if("false" == data.possibility){
					alert(data.reason);
					return false;
				}else{
					
					$("#transactionTime").val(data.transactionTime);

					var expSkinRsvList = data.expSkinRsvInfoList;
					var totalCnt = data.totalCnt;
					
					if(expSkinRsvList[0].msg == "false"){
						alert(expSkinRsvList[0].reason);
						return false;
					}else{
						setExpSkinReservation(expSkinRsvList, totalCnt);
						
						$("#step2Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
						$("#step2Btn").parents('.bizEduPlace').find('.result').show();
						$("#step2Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
						$("#stepDone").show();
					}
				}
				
				setTimeout(function(){ abnkorea_resize(); }, 500);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
				$(obj).attr("onclick", "javascript:expSkinReservation(this);");
			}
		});
	
}

/*
* 필수 입력값 체크 및 확인
*/
var mendatoryCheck = {
		
	partnerSelectbox : function(){
		
		var mendatoryCheckForSelectBox = false;
		
		$("select[name=partnerTypeCode]").each(function(){
			
			if(0 == $(this).val().length){
				mendatoryCheckForSelectBox = true;
			}
		});
		
		if(mendatoryCheckForSelectBox){
			alert("동반여부는필수 선택 입니다.");
			return false;
		}else{
			return true;
		}
	}
};

/* 월 변경시 on클래스 먹이기,  파라미터값 셋팅  */
function changeMonth(obj, year, month){
	
	sessionCnt = 0;
	
	var  msg = "해당월에 선택된 세션리스트는 삭제됩니다.";
	
	/* 해당 날짜의 세션리스트 가 있음 경고창 */
	if($("#appendSessionTable").children().hasClass("selDateBox") == true){
		
		if(confirm(msg) == true){
			/* 해딩 세션 리스트 삭제 */
			$("#appendSessionTable").empty();

			/* 파라미터로 쓰일 년월 초기화 */
			$("#getYear").val("");
			$("#getMonth").val("");
			
			/* 월 두 자릿수 맞추기 */
			if(month < 10){
				$("#getMonth").val("0"+month);
				$("#getYear").val(year);
			}else{
				$("#getYear").val(year);
				$("#getMonth").val(month);
			}
			

			$("#viewTempMonth").find("a").each(function(){
				if($(this).is(".on") === true){
					$(this).removeClass("on");
					
				}
			});
			$(obj).addClass("on");
			
			/* 선택한 월로 셋팅 */
			$("#calMonth").empty();
			$("#calMonth").append(month+"월 예약가능 잔여회수");
			
			/* 달력 다시 그리는 함수 호출 */
			nextMonthCalendar("C");
			
		}else{
			return false;
		}
	}else{
	/* 선택된 세션이 없음  */
		$("#getYear").val("");
		$("#getMonth").val("");
		
		if(month < 10){
			$("#getMonth").val("0"+month);
			$("#getYear").val(year);
		}else{
			$("#getYear").val(year);
			$("#getMonth").val(month);
		}
		
		
		$("#viewTempMonth").find("a").each(function(){
			if($(this).is(".on") === true){
				$(this).removeClass("on");
				
			}
		});
		$(obj).addClass("on");
		
		nextMonthCalendar("C");
	}
	
}

/* ap 안내 */
function showApInfo(thisObj){

	layerPopupOpen(thisObj);
	
	abnkoreaApInfoPop_resize();
}


function closeApInfo(){	
	$("#uiLayerPop_apInfo").hide();
	$("#layerMask").remove();
}

function showExpRsvComfirmPop(){
	
	var tempYear = $("#getYearPop").val();
	var tempMonth = $("#getYearPop").val();
	
	$("#getYearLayer").val($("#getYearPop").val()).attr("selected", "selected");
	$("#getMonthLayer").val($("#getMonthPop").val()).attr("selected", "selected");

	searchCalLayer();
	setToday();
	
	layerPopupOpen("<a href='#uiLayerPop_calender2' class='btnTbl'>체험예약 현황확인</a>");return false;
}


function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 피부측정 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}


function closePop(){
	
	$("#uiLayerPop_confirm").css("display", "none");
	$("#layerMask").remove();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/**
 * 이전 버튼 클릭시 화면 이동
 */
function backStep(destStep){
	
	if('1' == destStep ){

		/* move to step 1 */
		var $pos = $("#step1OpenSelectDiv");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
		
	}
		
}
</script>
<!-- </head> -->
<!-- <body class="uiGnbM3"> -->
<form id="expSkinForm" name="expSkinForm" method="post">
	<input type="hidden" id="getMonth" name="getMonth"/>
	<input type="hidden" id="getYear" name="getYear"/>
	
	<input type="hidden" id="getMonthPop" name="getMonthPop"/>
	<input type="hidden" id="getYearPop" name="getYearPop"/>
	<input type="hidden" id="getDayPop" name="getDayPop">
</form>
<form id="expSkinFormForPopup" name="expSkinFormForPopup" method="post"></form>
<form id="checkLimitCount" name="checkLimitCount" method="post"></form>

<div id="pbContainer">
	<section id="pbContent" class="bizroom">
	
	<input type="hidden" id="transactionTime" />
	<input type="hidden" id="snsText" name="snsText">
	
	<section class="brIntro">
		<h2><a href="#uiToggle_01">피부측정 예약 필수 안내</a></h2>
		<div id="uiToggle_01" class="toggleDetail"> <!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
<!-- 			<ul class="listDotFS mgtS"> -->
<!-- 			<li>아티스트리 피부 측정은 본인의 현재 피부상태를 파악하고 효과적인 개선방법을 전문 상담원을 통해 <br />받아 보실 수 있습니다. -->
<!-- 				<strong>※ 반드시 노메이크업 상태로 방문해주셔야 측정이 가능합니다.</strong></li> -->
<!-- 			</ul> -->
			
<!-- 			<p class="pTit">예약 안내</p> -->
<!-- 			<ul class="listDotFS"> -->
<!-- 			<li>예약 시간 - 평일 오전 11시~19시30분 / 주말 오전 11시~17시30분</li> -->
<!-- 			<li>매주 일요일 휴무, 단 마지막 일요일은 주말시간과 동일 운영 (김포-월요일 / ABC-일요일 휴무)</li> -->
<!-- 			<li>측정 예약은 매월 24일부터 SP이상, 25일 부터 ABO분들께서 다음달 일정 예약이 가능합니다.</li> -->
<!-- 			<li>피부/체성분 측정은 예약시간 30분 동안, 동반인 (ABO 또는 소비자) 포함 총 2명까지 예약이 가능합니다.<br /> -->
<!-- 			 (단, 2인 측정의 경우, 1인 상담시간은 15분으로 진행 됩니다.)</li> -->
			
<!-- 			</ul> -->
			
<!-- 			<p class="pTit">패널티 프로그램 안내</p> -->
<!-- 			<p class="listDotFS">측정 예약 후, 사전 취소 없이 불참하실 경우 2개월간 패널티가 적용됩니다.</p> -->
<!-- 			<p class="tiptextR">2015년 9월1일 최종 업데이트 되었습니다.</p> -->
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</section>
		
	<section class="mWrap">
	<!-- 스텝1 -->
		<div class="bizEduPlace">
			<div class="result" id="step1CloseSelectDiv">
				<div class="tWrap">
					<em class="bizIcon step01"></em><strong class="step">STEP1/ 지역</strong>
					<span id="appendPPName"></span>
					<%//<button class="bizIcon showHid">수정</button> %>
					
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv" id="step1OpenSelectDiv">
				<dl class="selcWrap">
					<dt>
						<div class="tWrap" >
							<em class="bizIcon step01"></em>
							<strong class="step">STEP1/ 지역</strong>
							<span>지역을 선택하세요.</span>
						</div>
					</dt>
					<dd>
						<div class="hWrap">
							<p class="tit">지역 선택</p>
							<a href="#uiLayerPop_apInfo" onclick="javascript:showApInfo(this); return false;" class="btnTbl uiApBtnOpen">
								<span>AP 안내</span>
							</a>
						</div>
						<div class="selectArea" id="ppAppend" >
							<!-- append AP -->
						</div>
					</dd>
					<dd class="dashed" id="skinIntro" style="display: none;">
						<p class="tit">피부측정 예약</p>
						<div class="roomInfo" id="appendRoomInfo">
							<div class="roomImg touchSliderWrap" id="roomImg">
								<a href="#none" class="btnPrev" style="display: inline-block;">
									<img src="/_ui/mobile/images/common/ico_slidectrl_prev2.png" alt="이전">
								</a>
								<a href="#none" class="btnNext" style="display: inline-block;">
									<img src="/_ui/mobile/images/common/ico_slidectrl_next2.png" alt="다음">
								</a>
	
								<div class="touchSlider" id="touchSlider">
									<ul style="width: 1710px; height: 908px; overflow: visible;" id="imageUl">
										<li style="float: none; display: block; position: absolute; top: 0px; left: 0px; width: 1710px; height: 908px;"><img src="/_ui/mobile/images/academy/@img_room3.jpg" alt="룸 사진"></li>
										<li style="float: none; display: block; position: absolute; top: 0px; left: 1710px; width: 1710px; height: 908px;"><img src="/_ui/mobile/images/academy/@img_room3.jpg" alt="룸 사진"></li>
									</ul>
								</div>
								<div class="sliderPaging">
									<a href="#none" class="btnPage on">
										<img src="/_ui/mobile/images/common/btn_slideb_on.png" alt="룸 사진">
									</a>
									<a href="#none" class="btnPage">
										<img src="/_ui/mobile/images/common/btn_slideb_off.png" alt="룸 사진">
									</a>
								</div>
							</div>
						</div>
					</dd>
				</dl>
			</div>
			<!-- //펼쳤을 때 -->
		</div>
		<!-- 스텝2 -->
		<div class="bizEduPlace">
			<div class="result" id="step2Result">
				<div class="tWrap" id="step2tWrap">
				</div>
			</div>
			<!-- 펼쳤을 때 -->
			<div class="selectDiv" id="step2SelectDiv">
				<dl class="selcWrap">
					<dt>
						<div class="tWrap"><em class="bizIcon step02"></em>
							<strong class="step">STEP2/ 날짜, 시간</strong><span>날짜와 시간을 선택해 주세요.</span>
						</div>
					</dt>
					<dd class="">
						<div class="hWrap">
							<p class="tit">날짜 선택</p>
							<span class="btnR">
								<a href="#" class="btnTbl" onclick="javascript:showExpRsvComfirmPop();">체험예약 현황확인</a>
							</span>
						</div>
						<section class="calenderBookWrap">
							<div class="calenderHeader" id="appendYYMM"></div>
							
							<table class="tblBookCalendar">
								<caption>캘린더형 - 날짜별 체험예약가능 시간</caption>
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
								<tbody id="nextMontCalTbody">
									
								</tbody>
							</table>
							<ul class="listWarning mgWrap">
								<li>※ 날짜를 선택하시면 예약가능 시간(세션)을 확인 할 수 있습니다.</li>
								<li>※ 날짜 아래 괄호안 숫자는 예약 가능 세션 수 입니다.</li>
							</ul>
						</section>
					</dd>
					<dd>
						<div class="hWrap dashed personal">
							<p class="tit">시간 선택</p>
							<span class="hText lts">프로그램은  <span id="afterUseTimeTip">30분</span> 단위로 진행됩니다.</span>
						</div>
						<div class="selDateWrap">
							
							<div id="appendSessionTable"></div>
							
							<ul class="listWarning">
								<li>※ 함께 체험하실 동반 인원이 있으시면 체크해 주세요.<br />(동반인 포함 총 2명)</li>
								<li>※ 평일은 오전 11시부터 오후 20시 00분까지, 토요일/일요일은 오전 11시부터 오후 18시 00분 까지만 이용이 가능합니다.</li>
								<li>※ 2인 측정의 경우, 1인 상담시간은 15분으로 진행 됩니다.</li>
<!-- 								<li>※ 측정 예약 후, 사전 취소 없이 불참하실 경우 2개월간 패널티가 적용됩니다.</li> -->
								<li id="penaltyInfo">※  측정 예약 후, 사전 취소 없이 불참하실 경우 <strong id="applyTypeValue">2개월</strong>간 패널티가 적용됩니다.</li>
							</ul>
								
						</div>
						<div class="btnWrap aNumb2">
							<a href="javascript:void(0);" class="btnBasicGL" onclick="javascript:backStep(1);" >이전</a>
							<a href="#" id="step2Btn" class="btnBasicBL" onclick="javascript:reservationReq();">예약요청</a>
						</div>
					</dd>
				</dl>
			</div>
				<!-- //펼쳤을 때 -->
		</div>
			
		<!-- 예약완료 -->
		<div class="stepDone selcWrap current" id="stepDone">
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
				<a href="/mobile/reservation/expSkinForm.do" class="btnBasicGL">예약계속하기</a>
				<a href="/mobile/reservation/expInfoList.do" class="btnBasicBL">예약현황확인</a>
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
		<div class="pbLayerContent">
		
			<table class="tblResrConform" id="rsvConform">
				<colgroup><col style="width:30%" /><col style="width:70%" /></colgroup>
			</table>
		
			<div class="grayBox">
				위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>
				<span class="point3">[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</span>
			</div>
			
			<div class="btnWrap aNumb2">
				<span><a href="#" class="btnBasicGL" onclick="javascript:closePop();">예약취소</a></span>
				<span><a href="#" class="btnBasicBL">예약확정</a></span>
<!-- 				<span><a href="#" class="btnBasicBL" onclick="javascript:expSkinReservation(this);">예약확정</a></span> -->
			</div>
		</div>
		<a href="#none" class="btnPopClose" onclick="javascript:closePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약 및 결제정보 확인 -->
	
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
		
	<!-- //layer popoup -->
	
	<!-- ap안내 -->
	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/apInfoPop.jsp" %>
	
	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expRsvConfirmPop.jsp" %>
	</section>
</div>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
