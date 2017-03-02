<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<style>
.brselectAreaBrand{position:relative;width:522px}
.brselectAreaBrand:after{content:"";display:block;clear:both}
.brselectAreaBrand a{float:left;display:inline-block;margin:0 5px 5px 0;border:1px solid #d5d5d5;box-sizing:border-box;;width:82px;height:36px;line-height:36px;background:#f3f3f3;text-align:center;color:#666;font-weight:bold;letter-spacing:-0.02em;text-decoration:none}
.brselectAreaBrand span a:last-child{margin-right:0}
.brselectAreaBrand a:hover, .selectArea a:active, .brselectAreaBrand a.on{border:2px solid #1572b1;color:#1572b1;line-height:35px;}
.brselectAreaBrand.sizeM a{width:169px}
.brselectAreaBrand.sizeL a{width:125px;height:45px;line-height:45px}
.brselectAreaBrand.sizeL a.line2{padding-top:6px;line-height:16px}
/* 20160923 */
.brselectAreaBrand.room >span{display:inline-block;padding-bottom:5px;vertical-align:top;}
.brselectAreaBrand.room >span a{display:table-cell;float:none;line-height:120%;padding:0;vertical-align:middle}

.programWrap .brselectAreaBrand a{width:125px;margin:0 5px 0 0}
#pbPopContent .programWrap .brselectAreaBrand a:last-child{margin-right:0}
</style>
<script type="text/javascript">
var tempWeekDay;
var sessionCnt = 0;
var step1Clk = 0;

$(document.body).ready(function (){
	/* step1에 class명 으로 사용될 데이터 조회 */
	searchNextYearMonth();
	
	/* 캘린더상에 날짜함수 호출 */
	nextMonthCalendar();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	$("#stepDone").hide();
	
	/* 프로그램 먼저 선택 페이지 이동 */
	$("#choiceProgram").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expBrandProgramForm.do'/>";
	});
	
	/* 예약계속하기 */
	$(".btnBasicGL").on("click", function(){
		$("#expHealthForm").attr("action", "${pageContext.request.contextPath}/reservation/expBrandForm.do");
		$("#expHealthForm").submit();

	});
	
	/* 이전 버튼 */
	$(".btnBasicGS").on("click", function(){
		$("#tempResult").show();
		
		$("#viewTempMonth").children("span").each(function(){
			if($(this).children().text() == $("#getMonth").val()+"월"){
				
				$(this).children().addClass("on");
			}
		});
		
		sessionCnt = 0;
		
	});
	
	/* 예약계속하기 버튼 */
	$(".btnBasicGL").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expBrandForm.do'/>";
	});

});

/* step1상에 사용될 년월 클래스명, 현재달~2개월 후 달 조회 */
function searchNextYearMonth(){
	$.ajaxCall({
		url: "<c:url value="/reservation/brandCalenderNextYearMonth.do"/>"
		, type : "POST"
		, async : false
		, bLoading : "Y"
		, success: function(data, textStatus, jqXHR){
			var setYearMonthData = data.searchNextYearMonth;
			
			/**-----------------------캘린더의 필요한 현재 년,월 파라미터  셋팅-----------------------------*/
			var getMonth;
			var getYear;
			if(setYearMonthData[0].month < 10){
				getMonth  = "0"+setYearMonthData[0].month;
				getYear = setYearMonthData[0].year;
			}else{
				getMonth  = setYearMonthData[0].month;
				getYear = setYearMonthData[0].year;
			}
			
			$("#getYear").val("");
			$("#getMonth").val("");
			
			$("#getYear").val(getYear);
			$("#getMonth").val(getMonth);
			
			$("#getYearPop").val("");
			$("#getMonthPop").val("");

			$("#getYearPop").val(getYear);
			$("#getMonthPop").val(getMonth);
			
			$("#targetcodeorder").val(setYearMonthData[0].targetcodeorder);
			
			/**-----------------------------------------------------------------------------*/

			var meInfo = data.info;

			$("#pinvalue").val(meInfo.pinvalue);
			$("#infoage").val(meInfo.age);
			$("#citygroupcode").val(meInfo.citygroupcode);
			/* step1에 사용될 년월 셋팅 */
			setYearMonth(setYearMonthData);

// 			nextMonthCalendar();
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* step1에 사용될 년월 셋팅 */
function setYearMonth(setYearMonthData){
	var html = "";
	
	//html += "<span class='year'><img src='/_ui/desktop/images/academy/img_2016.gif' alt="+setYearMonthData[0].year+"년/></span>";
	html += "<div class='monthlyWrap' id='viewTempMonth'>";
	for(var i = 0; i < setYearMonthData.length; i++){
		
		if(i >= 7){
			break;
		}
		
		if(i == 0){
			html += "	<span><a href='javascript:void(0);' class='"+setYearMonthData[i].engmonth+" on' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[i].year+"', '"+setYearMonthData[i].month+"');\">"+setYearMonthData[i].month+"월</a></span>";
		}else{
			html += "	<span><a href='javascript:void(0);' class='"+setYearMonthData[i].engmonth+"' onclick=\"javascript:changeMonth(this, '"+setYearMonthData[i].year+"', '"+setYearMonthData[i].month+"');\">"+setYearMonthData[i].month+"월</a></span>";
		}
	}
	html += "</div>";
	
	
	$(".calenderHeader").empty();
	$(".calenderHeader").append(html);
	
	
	/*-----------------------체험 예약 현황 확인시 필요한 년월 셋팅---------------------------------------*/
	$("#getYearPop").val(setYearMonthData[0].year);
	
	if(setYearMonthData[0].month < 10){
		$("#getMonthPop").val("0"+setYearMonthData[0].month);
	}else{
		$("#getMonthPop").val(setYearMonthData[0].month);
	}

	$("#getDayPop").val(setYearMonthData[0].todaypop);
	/*----------------------------------------------------------------------------------*/
	
// 	getRemainDayByMonth();
}

/* 다음달 캘린더의 날짜 호출 한다. */
function nextMonthCalendar(){

	this.sessionCnt = 0;
	
	var param = {
		  getYear :  $("#getYear").val()
		, getMonth : $("#getMonth").val()
		, ppSeq : $("#ppseq").val()
		, pinvalue : $("#pinvalue").val()
		, infoage : $("#infoage").val()
		, citygroupcode : $("#citygroupcode").val()
	};
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchNextMonthCalendarAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
		
			/* 다음달 날짜 리스트 */
			var calList = data.nextMonthCalendar;
			
			/* 캘린더에 해당 pp의 휴무일의 정보를 담기 위한 휴무일 데이터 */
			var holiDayList = data.expHealthHoliDayList;
			
			var rsvAbleSession = data.searchRsvAbleSessionList;
		
			/* 다음달 캘린더를 그리는 함수 호출 */
			gridNextMonth(calList, holiDayList);
			
			setRsvAbleSession(rsvAbleSession);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 캘린더상에 날짜 셋팅 */
function gridNextMonth(calList, holiDayList){
	
	var html = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
// 	console.log(calList);
	
	$("#montCalTbody").empty();
	
	for(var i = 0; i < calList.length; i++){
		html += "<tr>"
		html += "		<td class='weekSun'><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekSun+"' onclick=\"javascript:selectOnCal('"+calList[i].weekSun+"');\">"+calList[i].weekSun.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekMon+"' onclick=\"javascript:selectOnCal('"+calList[i].weekMon+"');\">"+calList[i].weekMon.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekTue+"' onclick=\"javascript:selectOnCal('"+calList[i].weekTue+"');\">"+calList[i].weekTue.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekWed+"' onclick=\"javascript:selectOnCal('"+calList[i].weekWed+"');\">"+calList[i].weekWed.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekThur+"' onclick=\"javascript:selectOnCal('"+calList[i].weekThur+"');\">"+calList[i].weekThur.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class=''><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekFri+"' onclick=\"javascript:selectOnCal('"+calList[i].weekFri+"');\">"+calList[i].weekFri.replace(/(^0+)/, "");+"</a></td>"
		html += "		<td class='weekSat'><a href='javascript:void(0);' id='cal"+yymm+calList[i].weekSat+"' onclick=\"javascript:selectOnCal('"+calList[i].weekSat+"');\">"+calList[i].weekSat.replace(/(^0+)/, "");+"</a></td>"
		html += "</tr>";
	}
	$("#montCalTbody").append(html);
	
	/* 캘린더상에 표현할 휴무일 셋팅 */
	calendarSetData(holiDayList);
// 	getRemainDayByMonth();
}

/* 캘린더상에 표현할 휴무일 셋팅 */
function calendarSetData(holiDayList){
	
	//console.log(holiDayList);
	
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
// 		console.log(holiDayList.length);
		for(var j = 0; j < holiDayList.length; j++){
			if($("#cal"+yymm+tempI).text().replace(/\s/gi, '') == Number(holiDayList[j].setdate)){
				
				$("#cal"+yymm+tempI).parent().addClass("late");
				$("#cal"+yymm+tempI).removeAttr("onclick");
				html = "<span><em>휴무</em></span>";
				
				$("#cal"+yymm+tempI).append(html);
				
				sessionCnt++;
			}
		}
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 캘린더상에 예약 가능 여부를 아이콘으로 표현 */
function setRsvAbleSession(rsvAbleSession){
// 	console.log(rsvAbleSession);
	
	var tempDate;
	var html = "";
	var yymm = $("#getYear").val();
	yymm += $("#getMonth").val();

	/* 예약 가능일이 있는지 확인 */
	if(rsvAbleSession.length == 0){
		$("#montCalTbody").find("td").each(function(){
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
			
		});
		
		//var msg = "이번 달에 예약 가능한 일자가 없습니다.";
		var msg = "";
		var months = $(".monthlyWrap > span").length;
		
		if( 1 < months ) {
			msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
		} else {
			msg = "예약 자격/조건이 맞지 않습니다.";
		}
			
		alert(msg);
		return false;
	}
	
	
	var rsvResult = new Array();
	var ymdFilterArray = ymdFilter(rsvAbleSession, "ymd");
	
	/* rsvAbleSession(해당월의 전체 프로그램별 세션)으로부터 rsvResult에 세션을 구성 (우선운영일 세션> 마지막주일요일 세션 > 일반 세션) 우선순위 */
	for(var idx = 0; idx < ymdFilterArray.length; idx++){
		
		/* 'expseq'만 담는 array */
		var expSeqFilterArray = ymdFilter(ymdFilterArray[idx], "expseq");

		/* 우선순위 별로 rsvResult를 구성 */
		for(var jdx = 0; jdx < expSeqFilterArray.length; jdx++) {
			
			if(expSeqFilterArray[jdx][0].settypecode == "S02") { /* 우선운영일 세션 */
				for(var kdx = 0; kdx < expSeqFilterArray[jdx].length; kdx++) {
					if(expSeqFilterArray[jdx][kdx].settypecode == "S02") {
						rsvResult.push(expSeqFilterArray[jdx][kdx]);
					}
				}
			} else if(expSeqFilterArray[jdx][0].weekday == "W08") { /* 마지막주 일요일 세션 */
				for(var kdx = 0; kdx < expSeqFilterArray[jdx].length; kdx++) {
					if(expSeqFilterArray[jdx][kdx].weekday == "W08") {
						rsvResult.push(expSeqFilterArray[jdx][kdx]);
					}
				}
			} else { /* 일반 세션 */
				for(var kdx = 0; kdx < expSeqFilterArray[jdx].length; kdx++) {
					rsvResult.push(expSeqFilterArray[jdx][kdx]);
				}
			}
		}
	}
	
	/* 'ymd'만 담는 array */
	var viewList = ymdFilter(rsvResult, "ymd");
	
	/* ymd(일자)별로 예약가능여부 표현 */
	for(var idx = 0; idx < viewList.length; idx++) {
		var isRsvFlag = 0;
		var isSeatcount1 = false;
		var isSeatcount2 = false;
		
		/* 예약마감 처리 */
		for(var jdx = 0; jdx < viewList[idx].length; jdx++) {
			if(viewList[idx][jdx].rsvflag == "300") { /* 300 : 예약마감인지 판별 */
				isRsvFlag++;
			}
			else if(viewList[idx][jdx].seatcount1 != null && viewList[idx][jdx].seatcount1 != "") {
				isSeatcount1 = true; /* 개별 */
			}
			else if(viewList[idx][jdx].seatcount2 != null && viewList[idx][jdx].seatcount2 != "") {
				isSeatcount2 = true; /* 그룹 */
			}
		}
		
		var html = "<span>";
		var calYmd = $("#cal"+ viewList[idx][0].ymd);
		if($(calYmd).children("span").text() == "") {
			// 예약 마감
			if(isRsvFlag == viewList[idx].length) {
				html += "<em>예약마감</em>";
				$(calYmd).parent().addClass("late");
				$(calYmd).removeAttr("onclick");
			}
			else if(isSeatcount1 == true || isSeatcount2 == true){
				html += isSeatcount1 ? "<span class='calIcon2 personal'><em>개별</em></span>" : "";
				html += isSeatcount2 ? "<span class='calIcon2 group'><em>그룹</em></span>" : "";
			}
			else {
				$(calYmd).parent().addClass("late");
	 			$(calYmd).removeAttr("onclick");
			}
		}
		html += "</span>";
		$(calYmd).append(html);
		
	}
	
	$("#montCalTbody").find("td").each(function(){
		if($(this).find("span").length == 0){
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
		}
		
	});
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}


/* 특정 key'field' 의 array를 반환 */
function ymdFilter(list, field) {
	var tempResult = new Array();
	var tempList = new Array();
	var tempVar = eval("list[0]."+ field);
	
	for(var idx = 0; idx < list.length; idx++){
		if(tempVar == eval("list[idx]."+ field)){
			tempList.push(list[idx]);
// 			console.log("true "+ tempVar);
		}
		else {
			tempResult.push(tempList.slice());
			tempList = new Array();
			tempList.push(list[idx]);
			tempVar = eval("list[idx]."+ field);
// 			console.log("false "+ tempVar);
		}
	}
	
	tempResult.push(tempList.slice());
	
	return tempResult;
}

/* setp1상에 다른 월 클릭시 새로 캘린더 그리주기 */
function changeMonth(obj, year, month){
	
	var  msg = "해당월에 선택된 세션리스트는 삭제됩니다.";
	
	
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
	
	$("#viewTempMonth").each(function(){
		if($(this).children().children().is(".on") === true){
			$(this).children().children().removeClass("on");
		}
	});
	$(obj).addClass("on");
	
	$("#calMonth").empty();
	$("#calMonth").append(month+"월 예약가능 잔여회수");
	
	sessionCnt = 0;
	
	/* 캘린더 날짜 데이터 호출 */
	nextMonthCalendar();
}

/* 캘린더상에 날짜 클릭시 테두리 활성화&비활성화 */
function selectOnCal(date){
	step1Clk = 1;
	
	var yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	//console.log(date);
	
	if(date == null || date == ""){
		return false;
	}else if(date != null || date != "undefined"){
		$("#montCalTbody").children().find("td").each(function(){
			if($(this).children().is(".selcOn") === true){
				$(this).children().removeClass("selcOn");
			}
				$("#cal"+yymm+date).addClass("selcOn");
				$("#getDay").val(date);
			
		});
		
	}
}

/* step2에서 개별/그룹 탭 클릭시 타입 코드 변경 */
function setAccountType(flag){
	/* 개별 */
	if(flag == "P"){
		$("#accounttype").val("A01");
		
		$("#accountP").addClass("on");
		$("#accountG").removeClass();
		
		nextStep();
	}else{
	/* 그룹 */
	
		var msg = "PT이상부터 그룹신청이 가능합니다.";
		if(3 > Number($("#targetcodeorder").val())){
			alert(msg);
			
			$("#setAccountType > a").each(function () {
				$(this).removeClass("on");
			});
			
			/* pp버튼 클릭시 선택 테두리 활성화*/
			$("#accountP").addClass("on");
			
			return false;
		}else{
			$("#accountP").removeClass();
			$("#accountG").addClass("on");
			
			$("#accounttype").val("A02");
			
			/* 해당 타입 코드 클릭시 카테고리별 예약가능 테이블 호출 */
			nextStep();
		}
	
	
		
	}
	
	
}

/* step1에서 step2로 변경시 날짜 선택유무 판별 */
function showStep2(){
	var cnt = 0;
	/* 선택된 날짜가 있을경우 cnt증가 */
	$("#montCalTbody").children().find("td").each(function(){
		if($(this).children().is(".selcOn") == true){
			cnt ++;
		}
		
	});
	
	/* 선택딘 날짜가 있을경우 다음 탭 오픈 */
	if(cnt != 0){
		
		
		var $groupTap = $('.programWrap .brselectAreaBrand > a');
		
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
		
		/* 해당 타입 코드 클릭시 카테고리별 예약가능 테이블 호출 */
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		if(step1Clk == 1){
			nextStep();
		}
		
	}else{
	/* 선택한 날짜가 없을경우 step1유지 */
		alert("날짜를  선택해주십시오.");
		
		/* step2 열기 */
		$("#step1Btn").parents('.brWrap').find('.modifyBtn').hide();
		$("#step1Btn").parents('.brWrap').find('.result').hide();
		$("#step1Btn").parents('.brWrap').find('.sectionWrap').stop().slideDown(function(){
			$("#step1Btn").parents('.brWrap').find('.stepTit').find('.close').hide();
			$("#step1Btn").parents('.brWrap').find('.stepTit').find('.open').show();
			$("#step1Btn").parents('.brWrap').removeClass('finish').addClass('current');
		});
	}
}

/* 해당일에 예약가능한 프로그램 조회(카테고리별) */
function nextStep(){
	param = {
		  getYear : $("#getYear").val()
		, getMonth : $("#getMonth").val()
		, getDay : $("#getDay").val()
		, ppseq : $("#ppseq").val()
		, accounttype : $("#accounttype").val()

		, pinvalue : $("#pinvalue").val()
		, infoage : $("#infoage").val()
		, citygroupcode : $("#citygroupcode").val()
	}
	
	$.ajaxCall({
		url: "<c:url value="/reservation/searchBrandProgramListAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			//console.log(data.searchBrandProgramList);
			var brandProgramList = data.searchBrandProgramList;
			var listCnt = data.listCnt;
			
			/* 해당일에 예약가능한 프로그램 테이블 셋팅 */
			setProgramTable(brandProgramList, listCnt);
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	step1Clk = 0;
}

/* 해당일에 예약가능한 프로그램 테이블 셋팅 */
function setProgramTable(brandProgramList, listCnt){
	/* 
		rsvflag
			- 300 : 예약마감
			- 200 : 예약대기
			- 100 : 예약가능
	*/
	var html = "";
	var html1 = "";
	
	var preCategory3;
	
// 	$(".brselectAreaBrand").next().empty();
	$("#programList").empty();
	
	for(var i = 0; i < listCnt; i++){
		
		var expseq = '';
		var settypecode = '';
		var worktypecode = '';
		
		$.each(brandProgramList[i], function(index, value){
			if(expseq != value.expseq){
				expseq = value.expseq;
				settypecode = value.settypecode;
				worktypecode = value.worktypecode;
			}
			
			if(index == 0){
				/* 카테고리 3이 존재할경우 카테고리 3이름이 타이틀이됨*/
				if(value.categorytype3name != "N" ){
					tempWeekDay =value.weekday;
					
					html = "<table class='tblProgram'>"
			 		+ "	<caption>프로그램 선택</caption>"
			 		+ "	<colgroup>"
			 		+ "		<col width='14%' />"
			 		+ "		<col width='*' />"
			 		+ "		<col width='15%' />"
			 		+ "		<col width='15%' />"
			 		+ "	</colgroup>"
			 		+ "	<thead>"
			 		+ "		<tr>"
			 		+ "			<th scope='col' colspan='4'>["+value.categorytype2name+"] "+value.categorytype3name+"</th>"
			 		+ "		</tr>"
			 		+ "	</thead>"
			 		+ "	<tbody id = '"+value.categorytype3+"'>"
			 		+ "	</tbody>"
					+"</table>";
				}else{
				/* 카테고리3이 존재 하지 않을경우 카테고리 2가 타이틀명이 됨 */
					tempWeekDay =value.weekday;
				
					html = "<table class='tblProgram'>"
			 		+ "	<caption>프로그램 선택</caption>"
			 		+ "	<colgroup>"
			 		+ "		<col width='14%' />"
			 		+ "		<col width='*' />"
			 		+ "		<col width='15%' />"
			 		+ "		<col width='15%' />"
			 		+ "	</colgroup>"
			 		+ "	<thead>"
			 		+ "		<tr>"
			 		+ "			<th scope='col' colspan='4'>["+value.categorytype2name+"]</th>"
			 		+ "		</tr>"
			 		+ "	</thead>"
			 		+ "	<tbody id = '"+value.categorytype2+"'>"
			 		+ "	</tbody>"
					+"</table>";
				}
// 		 		$(".brselectAreaBrand").next().append(html);
		 		$("#programList").append(html);
			}
			
// 			console.log(value);
			if(settypecode == value.settypecode && worktypecode != 'S02'){
			/* 카테고리3이 존재할경우,  300 -> 예약 마감 [예약마감은 테이블상에 표현하지 않는다] */
			if($("#"+value.categorytype3name == value.categorytype3)){
				
// 				if(value.settypecode == "S02"){
					
// 				}
				
				html1 = "<tr>"
				if (value.rsvflag == 300){
					html1+="<td><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='chkBox' onclick='javascript:showImportant(this);' disabled/> "+value.accounttypename+"</td>";
				}else{
					html1+="<td><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='chkBox' onclick='javascript:showImportant(this);'/> "+value.accounttypename+"</td>";
				}
				/* 준비물이 없을경우  */
				if(value.preparation == null || value.preparation == ""){
					html1+="<td class='programTitle'><a href='javascript:void(0);'onclick=\"javascript:showBrandIntro('"+value.categorytype2+"', '"+value.categorytype3+"','"+value.expseq+"', 'D');\" title='새창 열림'>"+value.productname+"</a>";
				}else{
				/* 준비물이 있을 경우  */
					html1+="<td class='programTitle'><a href='javascript:void(0);'onclick=\"javascript:showBrandIntro('"+value.categorytype2+"', '"+value.categorytype3+"','"+value.expseq+"', 'D');\" title='새창 열림'>"+value.productname+"</a><span class='prepare'>★ 준비물 : "+value.preparation+"</span>";
// 					html1+="<td class='programTitle'><a href='javascript:void(0);'onclick=\"javascript:showBrandIntro('"+value.categorytype2+"', '"+value.categorytype3+"','"+value.expseq+"', 'D');\" title='새창 열림'>"+value.productname+"</a><span class='prepare' style='display: block;'>★ 준비물 : "+value.preparation+"</span>";
				}
				html1+="<input type='hidden' name='tempCategorytype2' value="+value.categorytype2+">";
				html1+="<input type='hidden' name='tempCategorytype3' value="+value.categorytype3+">";
				html1+="<input type='hidden' name='tempExpseq' value="+value.expseq+">";
				html1+="<input type='hidden' name='tempExpsessionseq' value="+value.expsessionseq+">";
				html1+="<input type='hidden' name='tempStartDateTime' value="+value.startdatetime+">";
				html1+="<input type='hidden' name='tempEndDateTime' value="+value.enddatetime+">";
				html1+="<input type='hidden' name='tempRsvflag' value="+value.rsvflag+"></td>";
				html1+="<td>"+value.session+"</td>";
				if(value.rsvflag == 100){
					html1+= "<td class='able'>예약가능</td>";
				}else if(value.rsvflag == 200){
					html1+="<td class=''>예약대기</td>";
				}else if(value.rsvflag == 300){
					html1+="<td class=''>예약마감</td>";
				}
				html1+= "</tr>";
				$("#"+value.categorytype3).append(html1);
			}
			
			/* 카테고리 3이 존재 하지 않을경우, 300 -> 예약마감은 테이블사에 표현하지 않는다 */
			if(value.categorytype3name == "N" && $("#"+value.categorytype2 == value.categorytype2)){
				html1 = "<tr>"
				if (value.rsvflag == 300){
					html1+="<td><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='chkBox' onclick='javascript:showImportant(this);' disabled/> "+value.accounttypename+"</td>";
				}else{
					html1+="<td><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='chkBox' onclick='javascript:showImportant(this);'/> "+value.accounttypename+"</td>";
				}
				if(value.preparation == null || value.preparation == ""){
					html1+="<td class='programTitle'><a href='javascript:void(0);'onclick=\"javascript:showBrandIntro('"+value.categorytype2+"', '"+value.categorytype3+"','"+value.expseq+"', 'D');\" title='새창 열림'>"+value.productname+"</a>";
				}else{
					html1+="<td class='programTitle'><a href='javascript:void(0);'onclick=\"javascript:showBrandIntro('"+value.categorytype2+"', '"+value.categorytype3+"','"+value.expseq+"', 'D');\" title='새창 열림'>"+value.productname+"</a><span class='prepare'>★ 준비물 : "+value.preparation+"</span>";
// 					html1+="<td class='programTitle'><a href='javascript:void(0);'onclick=\"javascript:showBrandIntro('"+value.categorytype2+"', '"+value.categorytype3+"','"+value.expseq+"', 'D');\" title='새창 열림'>"+value.productname+"</a><span class='prepare' style='display: block;'>★ 준비물 : "+value.preparation+"</span>";
				}
				html1+="<input type='hidden' name='tempCategorytype2' value="+value.categorytype2+">";
				html1+="<input type='hidden' name='tempCategorytype3' value="+value.categorytype3+">";
				html1+="<input type='hidden' name='tempExpseq' value="+value.expseq+">";
				html1+="<input type='hidden' name='tempExpsessionseq' value="+value.expsessionseq+">";
				html1+="<input type='hidden' name='tempStartDateTime' value="+value.startdatetime+">";
				html1+="<input type='hidden' name='tempEndDateTime' value="+value.enddatetime+">";
				html1+="<input type='hidden' name='tempRsvflag' value="+value.rsvflag+"></td>";
				html1+="<td>"+value.session+"</td>";
				//console.log(value.standbynumber);
				if(value.rsvflag == 100){
					html1+= "<td class='able'>예약가능</td>";
				}else if(value.rsvflag == 200){
					html1+= "<td class=''>예약대기</td>";
				}else if(value.rsvflag == 300){
					html1+="<td class=''>예약마감</td>";
				}
					
				html1+= "</tr>";
				$("#"+value.categorytype2).append(html1);
			}
			}
		});
	}
	
	/* 테이블 데이터에 자식데이터가 없을경우 table삭제 */
	$("#programList").find("table").find("tbody").each(function(){
		if($(this).children().length == 0){
			$(this).parent().remove();
		}
	});
	
// 	$(".brselectAreaBrand").next().append("<li>※ 특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 3개월간 예약이 불가합니다.</li>");
// 	$(".brselectAreaBrand").next().append("<li>※ PT이상부터 그룹신청이 가능합니다.</li>");
	
	//console.log(tempWeekDay);
	$("#appendRsvDate").empty();
	if(isNull(tempWeekDay)) {
		var week = ['일', '월', '화', '수', '목', '금', '토'];
		var dayOfWeek = "("+week[new Date($("#getYear").val()+"-"+$("#getMonth").val()+"-"+$("#getDay").val()).getDay()]+")";

		$("#appendRsvDate").append("<p>분당ABC<em>|</em>"+$("#getYear").val()+"-"+$("#getMonth").val()+"-"+$("#getDay").val()+dayOfWeek+"</p>");
	} else {
		$("#appendRsvDate").append("<p>분당ABC<em>|</em>"+$("#getYear").val()+"-"+$("#getMonth").val()+"-"+$("#getDay").val()+tempWeekDay+"</p>");
	}


}

function showImportant(obj){
	
	if($(obj).is(":checked") == true){
		if($(obj).parent().next().children().is(".prepare") == true){
			$(obj).parent().next().children(".prepare").attr("style", "display: block;");
		}
	}else{
		$(obj).parent().next().children(".prepare").attr("style", "display: none;");
	}
	
}

/* 예액요청 팝업 호출 */
function reservationReq(){
	var cnt = 0;
	var tempRsvDate;
	
	$("#expBrandReqForm").empty();
	$("#checkLimitCount").empty();
	
	$("input[name='chkBox']:checked").each(function(){
		
		$($(this).parent().next().children()).each(function(index){
			if(index == 0){
				$("#expBrandReqForm").append("<input type='hidden' name ='productName' value ='"+$(this).text()+"'>");
				
			}else if(index == 1){
				
				if(index[1] == "" && index[1] == null){
					$("#expBrandReqForm").append("<input type='hidden' name ='preparation' value ='N'>");
				}else{
					$("#expBrandReqForm").append("<input type='hidden' name ='preparation' value ='"+$(this).text()+"'>");
					
				}
			}
			
		});
		
		$("#expBrandReqForm").append("<input type='hidden' name ='expseq' value ='"+$(this).parent().next().find("input[name='tempExpseq']").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='expsessionseq' value ='"+$(this).parent().next().find("input[name='tempExpsessionseq']").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='startdatetime' value ='"+$(this).parent().next().find("input[name='tempStartDateTime']").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='enddatetime' value ='"+$(this).parent().next().find("input[name='tempEndDateTime']").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='rsvflag' value ='"+$(this).parent().next().find("input[name='tempRsvflag']").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='getYear' value ='"+$("#getYear").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='getMonth' value ='"+$("#getMonth").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='getDay' value ='"+$("#getDay").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='accountType' value ='"+$("#accounttype").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='ppSeq' value ='"+$("#ppseq").val()+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='weekDay' value ='"+tempWeekDay+"'>");
		$("#expBrandReqForm").append("<input type='hidden' name ='sessionTime' value ='"+$(this).parent().next().next().text()+"'>");
		
		tempRsvDate = $("#getYear").val() + $("#getMonth").val() + $("#getDay").val();
		
		$("#expBrandReqForm").append("<input type='hidden' name ='reservationDate' value ='"+tempRsvDate+"'>");
		
		$("#checkLimitCount").append("<input type= 'hidden' name = 'reservationDate' value = '"+tempRsvDate+"'>");
		$("#checkLimitCount").append("<input type= 'hidden' name = 'typeSeq' value = '"+$("#typeseq").val()+"'>");
		$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+$(this).parent().next().find("input[name='tempExpseq']").val()+"\">");
		
		cnt++;
	});
	
	if(cnt == 0){
		alert("프로그램을 선택해 주십시오.");
		return false;
	}else{
		
		/* 패널티 유효성 중간 검사 */
		if(middlePenaltyCheck()){
		
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeseq\" value=\""+$("#typeseq").val()+"\">");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"ppseq\" value=\""+$("#ppseq").val()+"\">");
			
			$.ajaxCall({
				  url: "<c:url value='/reservation/expBrandRsvAvailabilityCheckAjax.do'/>"
				, type : "POST"
				, data: $("#checkLimitCount").serialize()
				, success: function(data, textStatus, jqXHR){
				if(data.rsvAvailabilityCheck){
					
					duplicateCheck();
	
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
	
}

function duplicateCheck(){
	
	var url = "";
	if("A01" == $("#accounttype").val()){
		url = "<c:url value='/reservation/expBrandCalendarIndividualDuplicateCheckAjax.do'/>"
	}else{
		url = "<c:url value='/reservation/expBrandCalendarGroupDuplicateCheckAjax.do'/>"
	}
	var param = $("#expBrandReqForm").serialize();
	
	$.ajaxCall({
		url: url
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var cancelDataList = data.cancelDataList;
			
			if(cancelDataList.length == 0){
				/* 예약정보 확인 팝업 */
				expBrandCalendarRsvRequestPop();
			}else{
				/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
				expBrandDisablePop(cancelDataList);
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


/* 예약불가 알림 팝업(중복체크) */
function expBrandDisablePop(cancelDataList) {
	var url = "<c:url value='/reservation/expBrandCalendarDisablePop.do'/>";
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
		$form.append("<input type= 'hidden' name = 'reservationdate' value = '"+cancelDataList[num].reservationdate+"'>");
		$form.append("<input type= 'hidden' name = 'expsessionseq' value = '"+cancelDataList[num].expsessionseq+"'>");
		$form.append("<input type= 'hidden' name = 'reservationweek' value = '"+cancelDataList[num].reservationweek+"'>");
		$form.append("<input type= 'hidden' name = 'ppname' value = '"+cancelDataList[num].ppname+"'>");
		$form.append("<input type= 'hidden' name = 'programname' value = '"+cancelDataList[num].programname+"'>");
		$form.append("<input type= 'hidden' name = 'sessionname' value = '"+cancelDataList[num].sessionname+"'>");
		$form.append("<input type= 'hidden' name = 'starttime' value = '"+cancelDataList[num].starttime+"'>");
		$form.append("<input type= 'hidden' name = 'endtime' value = '"+cancelDataList[num].endtime+"'>");
		$form.append("<input type= 'hidden' name = 'standbynumber' value = '"+cancelDataList[num].standbynumber+"'>");
	}
	
	$form.submit();
	
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

/* 브랜드 체험 소개 버튼, step2에 제목 클릭시 브랜드 체험 소개 팝업 호출 */
function showBrandIntro(categorytype2, categorytype3, expseq, flag){
	$("#expBrandIntroForm").empty();
	
	if(categorytype3 == "N"){
		$("#expBrandIntroForm").append("<input type='hidden' id='categorytype2' name='categorytype2' value='"+categorytype2+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='categorytype3' name='categorytype3' value=''>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popExpseq' name='popExpseq' value='"+expseq+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popPpseq' name='popPpseq' value='"+$("#ppseq").val()+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popTypeseq' name='popTypeseq' value='"+$("#typeseq").val()+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popFlag' name='popFlag' value='"+flag+"'>");
	}else{
		$("#expBrandIntroForm").append("<input type='hidden' id='categorytype2' name='categorytype2' value='"+categorytype2+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='categorytype3' name='categorytype3' value='"+categorytype3+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popExpseq' name='popExpseq' value='"+expseq+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popPpseq' name='popPpseq' value='"+$("#ppseq").val()+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popTypeseq' name='popTypeseq' value='"+$("#typeseq").val()+"'>");
		$("#expBrandIntroForm").append("<input type='hidden' id='popFlag' name='popFlag' value='"+flag+"'>");
	}
	
	
	
	var frm = document.expBrandIntroForm
	var url = "<c:url value="/reservation/expBrandIntroPop.do"/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=700, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 예약 요청 팝업에서 등록후 반환된 데이터 셋팅 */
function expBrandCalendarRsvDetail(expBrandRsvInfoList, totalCnt){
	
	$('#pbContent').each(function(){
		this.scrollIntoView(true);
	});
	
	/* show box & hide box */
	var $brWrap = $("#step2Btn").parents('.brWrap');
	var stepTit = $brWrap.find('.stepTit');
	var result = $brWrap.find('.result');
	
	$("#stepDone").show();
	
	$brWrap.find('.sectionWrap').stop().slideUp(function(){
		$brWrap.find(stepTit).find('.close').show();
		$brWrap.find(stepTit).find('.open').hide();
		
		$brWrap.find('.modifyBtn').show();
		$brWrap.find('.req').show(); //결과값 보기
		$brWrap.removeClass('current').addClass('finish');
	});
	
	
// 	console.log(expBrandRsvInfoList);
	
	
	var snsHtml = "";
	
	$("#expBrandConfrirm").append("<p class='total'>총  "+totalCnt+" 건</p>");
	for(var i =0; i < expBrandRsvInfoList.length; i++){
		
		var html = "";
		
		if(i == 0){
			snsHtml += "[한국암웨이]시설/체험 예약내역 (총 "+totalCnt+"건) \n";
		}
		
		/* 개별 예약자 일경우 */
		if(expBrandRsvInfoList[i].accountType == "A01"){
			/* 동반자가 ABO일경우 */
			if(expBrandRsvInfoList[i].partnerTypeCode == "R01"){
				if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em>|</em>ABO</p>";
					
					snsHtml += "■ 개별 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
							+ expBrandRsvInfoList[i].sessionTime + "| ABO\n";
				}else{
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime+" (대기신청)<em>|</em>ABO</p>";
					
					snsHtml += "■ 개별 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
							+ expBrandRsvInfoList[i].sessionTime + " (대기신청)| ABO\n";
				}
			}else if(expBrandRsvInfoList[i].partnerTypeCode == "R02"){
			/* 동반자가 일반동반자일경우 */
				if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em>|</em>일반인동반</p>";
					
					snsHtml += "■ 개별 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
						+ expBrandRsvInfoList[i].sessionTime + "| 일반인동반\n";
				}else{
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime+" (대기신청)<em>|</em>일반인동반</p>";
					
					snsHtml += "■ 개별 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
						+ expBrandRsvInfoList[i].sessionTime + " (대기신청)| 일반인동반\n";
				}
				
			}else if(expBrandRsvInfoList[i].partnerTypeCode == "R03"){
				if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime+"<em>|</em>비동반</p>";
				
					snsHtml += "■ 개별 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
							+ expBrandRsvInfoList[i].sessionTime + "| 비동반\n";
				}else{
					html += "<p class='program'><span class='t'>개별</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime+" (대기신청)<em>|</em>비동반</p>";
				
					snsHtml += "■ 개별 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
							+ expBrandRsvInfoList[i].sessionTime + " (대기신청)| 비동반\n";
				}
				
			}
			
			$("#expBrandConfrirm").append(html);
		}else{
		/* 그룹 예약자 일경우 */
			if(expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0"){
				html += "<p class='program'><span class='t'>그룹</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime;
				
				snsHtml += "■ 그룹 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
						+ expBrandRsvInfoList[i].sessionTime;
			}else{
				html += "<p class='program'><span class='t'>그룹</span><em>|</em>"+expBrandRsvInfoList[i].productName+"<em>|</em>"+expBrandRsvInfoList[i].sessionTime + "(대기신청)";
				
				snsHtml += "■ 그룹 | 분당 ABC ("+expBrandRsvInfoList[i].productName+") " + $("#getYear").val() + "-" + $("#getMonth").val() + "-" + $("#getDay").val() + tempWeekDay + " | \n" 
						+ expBrandRsvInfoList[i].sessionTime + "(대기신청)";
			}
			
			$("#expBrandConfrirm").append(html);
		}
		
	}
	

	$("#snsText").empty();
	$("#snsText").val(snsHtml);

	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 예약 현황 확인 팝업 호출 */
function viewRsvConfirm(){
	
	var frm = document.expBrandCalendarForm
	var url = "<c:url value="/reservation/expHealthRsvConfirmPop.do"/>";
	var title = "testpop";
	var status = "toolbar=no, width=754, height=900, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

function expBrandCalendarRsvRequestPop(){
	
	var frm = document.expBrandReqForm
	var url = "<c:url value="/reservation/expBrandRsvRequestPop.do"/>";
	var title = "expBrandRequestPop";
	var status = "toolbar=no, width=650, height=500, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
	
}


function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 브랜드 체험 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}


/* 예약 현황 확인 페이지 이동 */
function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}
</script>
</head>
<body>
<form id="expBrandCalendarForm" name="expBrandCalendarForm" method="post">
	<input type="hidden" id="getYear" name="getYear">
	<input type="hidden" id="getMonth" name="getMonth">
	<input type="hidden" id="getDay" name="getDay">
	<input type="hidden" id="accounttype" name="accounttype" value="A01">
	<input type="hidden" id="ppseq" name="ppseq" value="${searchBrandPpInfo.ppseq}">
	<input type="hidden" id="typeseq" name="typeseq" value="${searchBrandPpInfo.typeseq}">
	<input type="hidden" id="targetcodeorder" name="targetcodeorder">
	<input type="hidden" id="transactionTime" value="" />
	
	<!-- 예약현황 확인 팝업에 필요한 년, 월 셋팅 -->
	<input type="hidden" id="getMonthPop" name="getMonthPop">
	<input type="hidden" id="getYearPop" name="getYearPop">
	<input type="hidden" id="getDayPop" name="getDayPop">

	<input type="hidden" id="pinvalue" name="pinvalue">
	<input type="hidden" id="infoage" name="infoage">
	<input type="hidden" id="citygroupcode" name="citygroupcode">

</form>
<form id="expBrandReqForm" name="expBrandReqForm" method="post"></form>
<form id="expBrandIntroForm" name="expBrandIntroForm" method="post">
</form>
<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
<form id="cancelList" name="cancelList" method="post"></form>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">

	<input type="hidden" id="snsText" name="snsText">

	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500220.gif" alt="브랜드체험 예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500220.gif" alt="암웨이 브랜드 체험센터 에서 진행하는 브랜드 체험을 예약하실 수 있습니다."></p>
	</div>
	<div class="brIntro">
		<!-- @edit 20160701 인트로 토글 링크영역 변경 -->
		<h2 class="hide">브랜드체험 예약 필수 안내</h2>
		<a href="#uiToggle_01" class="toggleTitle"><strong>브랜드체험 예약 필수 안내</strong> <span class="btnArrow"><em class="hide">내용보기</em></span></a>
		<div id="uiToggle_01" class="toggleDetail"> <!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</div>
	<div class="tabWrap">
		<span class="hide">탭 메뉴</span>
		<ul class="tabDepth1 widthL">
			<li class="on"><strong>날짜 먼저선택</strong></li>
			<li><a href="javascript:void(0);" id="choiceProgram">프로그램 먼저선택</a></li>
		</ul>
		<span class="btnR"><a href="javascript:void(0);" class="btnCont" onclick="javascript:showBrandIntro('E0301', 'E030101', '', 'P')"><span>브랜드체험 소개</span></a></span>
	</div>
	<div class="brWrapAll">
		<span class="hide">브랜드체험 예약 스텝</span>
		<!-- 스텝1 -->
		<div class="brWrap current" id="step1">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_apexp_03.gif" alt="Step1/날짜" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_apexp_03_current.gif" alt="Step1/날짜-날짜를 선택하세요." /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="calenderBookWrap">
						<div class="hWrap">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_04.gif" alt="날짜선택"></h3>
							<span class="btnR"><a href="javascript:void(0);" title="새창 열림" class="btnCont"  onclick="javascript:viewRsvConfirm();"><span>체험예약 현황확인</span></a></span>
						</div>
						<!-- 1월 jan, 2월 feb, 3월 mar, 4월 apr, 5월 may, 6월 june, 7월 july, 8월 aug, 9월 sep, 10월 oct, 11월 nov, 12월 dec -->
						<div class="calenderHeader">
						</div>
						<table class="tblBookCalendar">
							<caption>캘린더형 - 날짜별 체험예약가능 시간</caption>
							<colgroup>
								<col style="width:15%" span="2">
								<col style="width:14%" span="5">
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
							<tbody id="montCalTbody">

							</tbody>
						</table>
						<div class=" tblCalendarBottom">
							<div class="orderState"> 
								<span class="calIcon2 personal"></span>개별
								<span class="calIcon2 group"></span>그룹
								<!-- @edit 20160701 툴팁 제거/텍스트로 변경 -->
								<span class="fcG">(개별/그룹 예약가능 아이콘 표시)</span>
							</div>
						</div>
					</section>
					
					<div class="btnWrapR">
						<a href="javascript:void(0);" class="btnBasicBS" id="step1Btn" onclick="javascript:showStep2();">다음</a>
					</div>
				</div>
				<div class="result req" id="appendRsvDate"></div>
			</div>
			<%//<div class="modifyBtn"><a href="javascript:void(0);"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
			
		</div>
		<!-- //스텝1 -->
		<!-- 스텝2 -->
		<div class="brWrap" id="step2">
			<h2 class="stepTit">
				<span class="close"><img src="/_ui/desktop/images/academy/h2_w02_apexp_04.gif" alt="Step2/프로그램" /></span>
				<span class="open"><img src="/_ui/desktop/images/academy/h2_w02_apexp_04_current.gif" alt="Step2/프로그램-프로그램을 선택하세요." /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="sectionWrap">
					<section class="programWrap">
						<div class="hWrap">
							<h3 class="mgNone"><img src="/_ui/desktop/images/academy/h3_w020500290.gif" alt="프로그램 선택" /></h3>
							<span class="textR" id="rsvCnt"></span>
						</div>
						<div class="brselectAreaBrand" id="setAccountType">
							<a href="#" class="on" onclick="javascript:setAccountType('P');" id="accountP">개별</a>
							<a href="#" class="" onclick="javascript:setAccountType('G');" id="accountG">그룹</a>
						</div>
						<div id="programList"></div>
						<ul class="listWarning">
<!-- 							<li>※ 예약은 월 5회까지 가능합니다.</li> -->
							<li>※ 특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여 3개월간 예약이 불가합니다.</li>
							<li>※ PT이상부터 그룹신청이 가능합니다.</li>
						</ul>
					</section>
					<div class="btnWrapR">
						<a href="javascript:void(0);" class="btnBasicGS">이전</a>
						<a href="javascript:void(0);" id="step2Btn" class="btnBasicBS" onclick="javscript:reservationReq();">예약요청</a>
					</div>
				</div>
				<div class="result" id="tempResult"><p>프로그램을 선택해 주세요.</p></div>
				<div class="result lines req" style="display:none" id="expBrandConfrirm">
<!-- 					<p class="total">총 2 건</p> -->
<!-- 					<p class="program"><span class="t">그룹</span><em>|</em>우리아이 식생활 변화 프로젝트2 (두뇌 성장)<em>|</em>13:30~14:00<em>|</em>비동반</p> -->
<!-- 					<p class="program"><span class="t">개별</span><em>|</em>BrandTour<em>|</em>13:30~14:00<em>|</em>ABO동반</p> -->
				</div>
			</div>
			
			<%//<div class="modifyBtn"><a href="javascript:void(0);"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div> %>
			
		</div>
		<!-- //스텝2 -->
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
				<a href="javascript:void(0);" class="btnBasicGL">예약계속하기</a>
				<a href="javascript:void(0);" onclick="javascript:accessParentPage();" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</div>
	
</section>

<!-- //content area | ### academy IFRAME End ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
