<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp"%>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<style type="text/css">
.detailSns.btmLine+.tabWrapLogicalBrand {
	border-top: 1px solid #c7c7c7;
}

/* 논리적인구조 */
.tabWrapLogicalBrand { /*overflow:hidden;*/
	position: relative;
	padding-top: 41px;
}

.tabWrapLogicalBrand section>div {
	display: none;
}

.tabWrapLogicalBrand h2 {
	position: absolute;
	top: 0;
	text-align: center;
	background: #fff;
	border-bottom: 3px solid #444;
}

.tabWrapLogicalBrand h2 a {
	display: block;
	height: 38px;
	font-weight: bold;
	border-left: 1px solid #b2b5b8;
	line-height: 38px;
}

.tabWrapLogicalBrand h2 a:hover, .tabWrapLogicalBrand h2 a:visited {
	color: #444444;
	text-decoration: none
}

.tabWrapLogicalBrand section.on h2 a {
	background: #444;
	color: #fff;
	border-left: 0
}

.tabWrapLogicalBrand section.on>div {
	display: block
}

.tabWrapLogicalBrand.tLine {
	border-top: 1px solid #c7c7c7;
}

div[class$="Line"].tabWrapLogicalBrand h2 a {
	border-top: 1px solid #b2b5b8;
}

div[class$="Line"].tabWrapLogicalBrand section.on h2 a {
	border: 1px solid #444;
	border-width: 1px 1px 0 0;
}

div[class$="Line"].tabWrapLogicalBrand section:last-child h2 a {
	border-right: 1px solid #b2b5b8;
}

div[class$="Line"].tabWrapLogicalBrand section:last-child.on h2 a {
	border-width: 1px 0 0 0;
}

.tabWrapLogicalBrand.tNum2 section>h2, .tabWrapLogicalBrand.tNum2Line section>h2
	{
	width: 50%;
}

.tabWrapLogicalBrand.tNum2 .tab01, .tabWrapLogicalBrand.tNum2Line .tab01
	{
	left: 0;
	width: 50%;
}

.tabWrapLogicalBrand.tNum2 .tab02, .tabWrapLogicalBrand.tNum2Line .tab02
	{
	left: 50%
}

.tabWrapLogicalBrand.tNum3 section>h2, .tabWrapLogicalBrand.tNum3Line section>h2
	{
	width: 33.3%;
}

.tabWrapLogicalBrand.tNum3 .tab01, .tabWrapLogicalBrand.tNum3Line .tab01
	{
	left: 0;
	width: 33.4%;
}

.tabWrapLogicalBrand.tNum3 .tab02, .tabWrapLogicalBrand.tNum3Line .tab02
	{
	left: 33.4%
}

.tabWrapLogicalBrand.tNum3 .tab03, .tabWrapLogicalBrand.tNum3Line .tab03
	{
	left: 66.7%
}

.tabWrapLogicalBrand.tNum4 section>h2, .tabWrapLogicalBrand.tNum4 section>h2
	{
	width: 25%;
}

.tabWrapLogicalBrand.tNum4 .tab01, .tabWrapLogicalBrand.tNum4Line .tab01
	{
	left: 0;
}

.tabWrapLogicalBrand.tNum4 .tab02, .tabWrapLogicalBrand.tNum4Line .tab02
	{
	left: 25%
}

.tabWrapLogicalBrand.tNum4 .tab03, .tabWrapLogicalBrand.tNum4Line .tab03
	{
	left: 50%
}

.tabWrapLogicalBrand.tNum4 .tab04, .tabWrapLogicalBrand.tNum4Line .tab04
	{
	left: 75%
}

.brandReserv .tabWrapLogicalBrand {
	margin-top: -10px;
	padding-top: 50px
}

.brandReserv .tabWrapLogicalBrand h2 {
	border-top: 1px solid #777;
	border-bottom: 0
}

.brandReserv .tabWrapLogicalBrand .on h2 {
	border: 1px solid #c7c7c7;
	border-bottom: 1px solid #fff
}

.brandReserv .tabWrapLogicalBrand h2 a {
	height: 34px;
	line-height: 34px;
	background: #777;
	color: #fff;
	border: 0
}

.brandReserv .tabWrapLogicalBrand .on h2 a {
	color: #666;
	background: #fff
}

#uiLayerPop_personal .tabWrapLogicalBrand h2 a {
	height: auto;
	line-height: 18px;
	padding: 5px 0
}

#uiLayerPop_personal .tabWrapLogicalBrand {
	padding-top: 60px
}

#uiLayerPop_personal .tabWrapLogicalBrand .borderbox {
	padding: 10px;
	border: 1px solid #c7c7c7
}

.tabWrapLogicalBrand.tNum1 .tab01, .tabWrapLogicalBrand.tNum1Line .tab01
	{
	width: 100%;
}

/* 교육비 동의 전체보기 */
.tabWrapLogicalBrand.mtabStyle h2, .tabWrapLogicalBrand.mtabStyle h2 a {
	height: auto
}

.tabWrapLogicalBrand.mtabStyle .tab02 {
	top: 30px
}

.tabWrapLogicalBrand.mtabStyle .tab03 {
	top: 60px
}

.tabWrapLogicalBrand.mtabStyle section.on>div {
	margin-top: 90px
}

.detailSns.btmLine+.tabWrapLogicalBrand {
	border-top: 1px solid #c7c7c7;
}

/* 논리적인구조 */
.tabWrapLogicalBrand {
	overflow: hidden;
	position: relative;
	padding-top: 41px;
}

.tabWrapLogicalBrand section>div {
	display: none;
}

.tabWrapLogicalBrand h2 {
	position: absolute;
	top: 0;
	text-align: center;
	background: #fff;
	border-bottom: 3px solid #444;
}

.tabWrapLogicalBrand h2 a {
	display: block;
	height: 38px;
	font-weight: bold;
	border-left: 1px solid #b2b5b8;
	line-height: 38px;
}

.tabWrapLogicalBrand h2 a:hover, .tabWrapLogicalBrand h2 a:visited {
	color: #444444;
	text-decoration: none
}

.tabWrapLogicalBrand section.on h2 a {
	background: #444;
	color: #fff;
	border-left: 0
}

.tabWrapLogicalBrand section.on>div {
	display: block
}

.tabWrapLogicalBrand.tLine {
	border-top: 1px solid #c7c7c7;
}

div[class$="Line"].tabWrapLogicalBrand h2 a {
	border-top: 1px solid #b2b5b8;
}

div[class$="Line"].tabWrapLogicalBrand section.on h2 a {
	border: 1px solid #444;
	border-width: 1px 1px 0 0;
}

div[class$="Line"].tabWrapLogicalBrand section:last-child h2 a {
	border-right: 1px solid #b2b5b8;
}

div[class$="Line"].tabWrapLogicalBrand section:last-child.on h2 a {
	border-width: 1px 0 0 0;
}

.tabWrapLogicalBrand.tNum2 section>h2, .tabWrapLogicalBrand.tNum2Line section>h2
	{
	width: 50%;
}

.tabWrapLogicalBrand.tNum2 .tab01, .tabWrapLogicalBrand.tNum2Line .tab01
	{
	left: 0;
	width: 50%;
}

.tabWrapLogicalBrand.tNum2 .tab02, .tabWrapLogicalBrand.tNum2Line .tab02
	{
	left: 50%
}

.tabWrapLogicalBrand.tNum3 section>h2, .tabWrapLogicalBrand.tNum3Line section>h2
	{
	width: 33.3%;
}

.tabWrapLogicalBrand.tNum3 .tab01, .tabWrapLogicalBrand.tNum3Line .tab01
	{
	left: 0;
	width: 33.4%;
}

.tabWrapLogicalBrand.tNum3 .tab02, .tabWrapLogicalBrand.tNum3Line .tab02
	{
	left: 33.4%
}

.tabWrapLogicalBrand.tNum3 .tab03, .tabWrapLogicalBrand.tNum3Line .tab03
	{
	left: 66.7%
}

.tabWrapLogicalBrand.tNum4 section>h2, .tabWrapLogicalBrand.tNum4 section>h2
	{
	width: 25%;
}

.tabWrapLogicalBrand.tNum4 .tab01, .tabWrapLogicalBrand.tNum4Line .tab01
	{
	left: 0;
}

.tabWrapLogicalBrand.tNum4 .tab02, .tabWrapLogicalBrand.tNum4Line .tab02
	{
	left: 25%
}

.tabWrapLogicalBrand.tNum4 .tab03, .tabWrapLogicalBrand.tNum4Line .tab03
	{
	left: 50%
}

.tabWrapLogicalBrand.tNum4 .tab04, .tabWrapLogicalBrand.tNum4Line .tab04
	{
	left: 75%
}
</style>

<script type="text/javascript">
	var tempWeekDay;
	var remaindYear;
	var remaindMonth;

	$(document.body).ready(
		function() {
			var brandIntroLayerFlag;

			/* step1에 class명 으로 사용될 데이터 조회 */
			searchNextYearMonth();

			/* 캘린더상에 날짜함수 호출 */
			nextMonthCalendar();

			$("#stepDone").hide();

			/* 프로그램 먼저 선택 페이지 이동 */
			$("#choiceProgram").on("click",function() {
					location.href = "<c:url value='${pageContext.request.contextPath}/mobile/reservation/expBrandProgramForm.do'/>";
			});
	});

	/* step1상에 사용될 년월 클래스명, 현재달~2개월 후 달 조회 */
	function searchNextYearMonth() {
		$.ajaxCall({
			url : "<c:url value="/mobile/reservation/brandCalenderNextYearMonth.do"/>",
			type : "POST",
			async : false,
			success : function(data, textStatus, jqXHR) {
				var setYearMonthData = data.searchNextYearMonth;

				/**-----------------------캘린더의 필요한 현재 년,월 파라미터  셋팅-----------------------------*/
				var getMonth;
				var getYear;
				if (setYearMonthData[0].month < 10) {
					getMonth = "0" + setYearMonthData[0].month;
					getYear = setYearMonthData[0].year;
				} else {
					getMonth = setYearMonthData[0].month;
					getYear = setYearMonthData[0].year;
				}

				$("#getYear").val("");
				$("#getMonth").val("");

				$("#getYear").val(getYear);
				$("#getMonth").val(getMonth);

				$("#getYearPop").val(getYear);
				$("#getMonthPop").val(getMonth);

				$("#targetcodeorder").val(
						setYearMonthData[0].targetcodeorder);
				/**-----------------------------------------------------------------------------*/

				/* step1에 사용될 년월 셋팅 */
				setYearMonth(setYearMonthData);

			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}

	/* step1에 사용될 년월 셋팅 */
	function setYearMonth(setYearMonthData) {
		var html = "";
		var tempYear = "";
		var tempMonth = "";

// 		html += "<span class='year'>" + setYearMonthData[0].year + "</span>";
		html += "<div class='monthlyWrap' id='viewTempMonth'>";

		for (var i = 0; i < setYearMonthData.length; i++) {

			if(i >= 7){
				break;
			}
// 			if (i == 0) {
// 				html += "<a href='javascript:void(0);' class='on' onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\">"
// 						+ setYearMonthData[i].month
// 						+ "<span>月</span></a><em>|</em>";
// 			} else {
// 				html += "<a href='javascript:void(0);' onclick=\"javascript:changeMonth(this, '"
// 						+ setYearMonthData[i].year
// 						+ "', '"
// 						+ setYearMonthData[i].month
// 						+ "');\">"
// 						+ setYearMonthData[i].month
// 						+ "<span>月</span></a><em>|</em>";
// 			}
			
			if(i == 0){
				tempYear = setYearMonthData[i].year;
				tempMonth = setYearMonthData[i].month;
				
				html += "<span><span class=\"year\">"+setYearMonthData[i].year+"</span>";
				html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\" class=\"on\">"+setYearMonthData[i].month+"<span>月</span></a></span>";

			}else if(setYearMonthData[i].year != tempMonth && setYearMonthData[i].month == 1){
				
				html += "<span><span class=\"year\">"+setYearMonthData[i].year+"</span>";
				html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\">"+setYearMonthData[i].month+"<span>月</span></a></span>";
				
			}else{
				html += "<a href=\"javascript:void(0);\" onclick=\"javascript:changeMonth(this, '"+ setYearMonthData[i].year+ "', '"+ setYearMonthData[i].month+ "');\">"+setYearMonthData[i].month+"<span>月</span></a></span>";
			}
			
			if(setYearMonthData.length != i + 1){
				html += "<em>|</em>";
			}
		}

		html += "</div>";

		$(".calenderHeader").empty();
		$(".calenderHeader").append(html);

		/*-----------------------체험 예약 현황 확인시 필요한 년월 셋팅---------------------------------------*/
		$("#getYearPop").val(setYearMonthData[0].year);

		if (setYearMonthData[0].month < 10) {
			$("#getMonthPop").val("0" + setYearMonthData[0].month);
		} else {
			$("#getMonthPop").val(setYearMonthData[0].month);
		}

		$("#getDayPop").val(setYearMonthData[0].todaypop);

		/*----------------------------------------------------------------------------------*/
	}

	/* 다음달 캘린더의 날짜 호출 한다. */
	function nextMonthCalendar() {
		var param = {
			getYear : $("#getYear").val(),
			getMonth : $("#getMonth").val(),
			ppSeq : $("#ppseq").val()
		};

		$.ajaxCall({
			url : "<c:url value="/mobile/reservation/searchNextMonthCalendarAjax.do"/>",
			type : "POST",
			data : param,
			success : function(data, textStatus, jqXHR) {

				/* 다음달 날짜 리스트 */
				var calList = data.nextMonthCalendar;

				/* 캘린더에 해당 pp의 휴무일의 정보를 담기 위한 휴무일 데이터 */
				var holiDayList = data.expHealthHoliDayList;

				var rsvAbleSession = data.searchRsvAbleSessionList;

				/* 다음달 캘린더를 그리는 함수 호출 */
				gridNextMonth(calList, holiDayList);

				setRsvAbleSession(rsvAbleSession);

				setTimeout(function() { abnkorea_resize(); }, 500);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}

	/* 캘린더상에 날짜 셋팅 */
	function gridNextMonth(calList, holiDayList) {

		var html = "";
		var yymm = "";
		yymm = $("#getYear").val();
		yymm += $("#getMonth").val();

		$("#montCalTbody").empty();

		for (var i = 0; i < calList.length; i++) {
			html += "<tr>"
			html += "		<td class='weekSun'><a href='javascript:void(0);' id='cal"
					+ yymm
					+ calList[i].weekSun
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekSun
					+ "');\">"
					+ calList[i].weekSun.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekMon
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekMon + "');\">"
					+ calList[i].weekMon.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekTue
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekTue + "');\">"
					+ calList[i].weekTue.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekWed
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekWed + "');\">"
					+ calList[i].weekWed.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekThur
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekThur + "');\">"
					+ calList[i].weekThur.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekFri
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekFri + "');\">"
					+ calList[i].weekFri.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class='weekSat'><a href='javascript:void(0);' id='cal"
					+ yymm
					+ calList[i].weekSat
					+ "' onclick=\"javascript:selectOnCal('"
					+ calList[i].weekSat
					+ "');\">"
					+ calList[i].weekSat.replace(/(^0+)/, "");
			+"</a></td>"
			html += "</tr>";
		}
		$("#montCalTbody").append(html);

		/* 캘린더상에 표현할 휴무일 셋팅 */
		calendarSetData(holiDayList);
	}

	/* 캘린더상에 표현할 휴무일 셋팅 */
	function calendarSetData(holiDayList) {

		var html = "";
		var tempI = "";
		var yymm = "";
		yymm = $("#getYear").val();
		yymm += $("#getMonth").val();

		for (var i = 1; i < 32; i++) {
			if (i < 10) {
				tempI = "0" + i;
			} else {
				tempI = i;
			}
			for (var j = 0; j < holiDayList.length; j++) {
				if ($("#cal" + yymm + tempI).text() == Number(holiDayList[j].setdate)) {

					$("#cal" + yymm + tempI).parent().addClass("late");
					$("#cal" + yymm + tempI).removeAttr("onclick");
					html = "<span>휴무</span>";

					$("#cal" + yymm + tempI).append(html);
				}
			}
		}
	}

/* 캘린더상에 예약 가능 여부를 아이콘으로 표현 */
function setRsvAbleSession(rsvAbleSession) {
	//console.log(rsvAbleSession);

	var tempDate;
	var html = "";
	var yymm = $("#getYear").val();
	yymm += $("#getMonth").val();

	if (rsvAbleSession.length == 0) {
		$("#montCalTbody").find("td").each(function() {
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");

		});
		return false;
	}

// 	$("#getDayPop").val(rsvAbleSession[0].gettoday.substr(6, 2));

	var rsvResult = new Array();
	var ymdFilterArray = ymdFilter(rsvAbleSession, "ymd");
	
	for(var idx = 0; idx < ymdFilterArray.length; idx++){
		var expSeqFilterArray = ymdFilter(ymdFilterArray[idx], "expseq");
		
		for(var jdx = 0; jdx < expSeqFilterArray.length; jdx++) {
			
			if(expSeqFilterArray[jdx][0].settypecode == "S02") {
				for(var kdx = 0; kdx < expSeqFilterArray[jdx].length; kdx++) {
					if(expSeqFilterArray[jdx][kdx].settypecode == "S02") {
						rsvResult.push(expSeqFilterArray[jdx][kdx]);
					}
				}
			}
			else if(expSeqFilterArray[jdx][0].weekday == "W08") {
				for(var kdx = 0; kdx < expSeqFilterArray[jdx].length; kdx++) {
					if(expSeqFilterArray[jdx][kdx].weekday == "W08") {
						rsvResult.push(expSeqFilterArray[jdx][kdx]);
					}
				}
			}
			else {
				for(var kdx = 0; kdx < expSeqFilterArray[jdx].length; kdx++) {
					rsvResult.push(expSeqFilterArray[jdx][kdx]);
				}
			}
		}
	}
	
var viewList = ymdFilter(rsvResult, "ymd");
	
	for(var idx = 0; idx < viewList.length; idx++) {
		var isRsvFlag = 0;
		var isSeatcount1 = false;
		var isSeatcount2 = false;
		
		for(var jdx = 0; jdx < viewList[idx].length; jdx++) {
			if(viewList[idx][jdx].rsvflag == "300") {
				isRsvFlag++;
			}
			else if(viewList[idx][jdx].seatcount1 != null && viewList[idx][jdx].seatcount1 != "") {
				isSeatcount1 = true;
			}
			else if(viewList[idx][jdx].seatcount2 != null && viewList[idx][jdx].seatcount2 != "") {
				isSeatcount2 = true;
			}
		}
		
		var html = "<span>";
		var calYmd = $("#cal"+ viewList[idx][0].ymd);
		if($(calYmd).children("span").text() == "") {
			// 예약 마감
			if(isRsvFlag == viewList[idx].length) {
				html += "예약마감";
// 				html += "<em>예약마감</em>";
				$(calYmd).parent().addClass("late");
				$(calYmd).removeAttr("onclick");
			}
			else if(isSeatcount1 == true || isSeatcount2 == true){
				html += isSeatcount1 ? "<em  class='calIcon2 personal'>개별</em>" : "";
				html += isSeatcount2 ? "<em class='calIcon2 group'>그룹</em>" : "";
				
// 				html += isSeatcount1 ? "<span class='calIcon2 personal'><em>개별</em></span>" : "";
// 				html += isSeatcount2 ? "<span class='calIcon2 group'><em>그룹</em></span>" : "";
			}
			else {
				$(calYmd).parent().addClass("late");
	 			$(calYmd).removeAttr("onclick");
			}
		}
		html += "</span>";
		$(calYmd).append(html);
		
	}
	
	$("#montCalTbody").find("td").each(function() {
		if ($(this).find("span").length == 0) {
			$(this).removeClass();
			$(this).addClass("late");
			$(this).children().removeAttr("onclick");
		}

	});

}

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
	function changeMonth(obj, year, month) {

		var msg = "해당월에 선택된 세션리스트는 삭제됩니다.";

		/* 선택된 세션이 없음  */
		$("#getYear").val("");
		$("#getMonth").val("");

		if (month < 10) {
			$("#getMonth").val("0" + month);
			$("#getYear").val(year);
		} else {
			$("#getYear").val(year);
			$("#getMonth").val(month);
		}

		$("#viewTempMonth").find("a").each(function() {
			if ($(this).is(".on") === true) {
				$(this).removeClass("on");
			}
		});
		$(obj).addClass("on");

		/* 캘린더 날짜 데이터 호출 */
		nextMonthCalendar();
	}

	/* 캘린더상에 날짜 클릭시 테두리 활성화&비활성화 */
	function selectOnCal(date) {
		var yymm = $("#getYear").val();
		yymm += $("#getMonth").val();

		if (date == null || date == "") {
			return false;
		} else if (date != null || date != "undefined") {
			$("#montCalTbody").children().find("td").each(function() {
				if ($(this).children().is(".selcOn") === true) {
					$(this).children().removeClass("selcOn");
				} else {
					$("#cal" + yymm + date).addClass("selcOn");
					$("#getDay").val(date);
				}
			});

		}
	}

	function showStep2() {
		var cnt = 0;

		/* 선택된 날짜가 있을경우 cnt증가 */
		$("#montCalTbody").children().find("td").each(function() {
			if ($(this).children().is(".selcOn") == true) {
				cnt++;
			}
		});

		if (cnt != 0) {

			/* 해당 타입 코드 클릭시 카테고리별 예약가능 테이블 호출 */
			nextStep("P");

			$("#step1Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
			$("#step1Btn").parents('.bizEduPlace').find('.result').show();
			$("#step1Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();

			$("#step2Btn").parents("dd").show();
			$("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
			$("#step2Btn").parents(".bizEduPlace").find(".result").hide();

			$("#step2Btn").hide();

		} else {
			alert("날짜를 선택해주십시오");
		}

	}

	/* 해당일에 예약가능한 프로그램 조회(카테고리별) */
	function nextStep(flag) {
		param = {
			getYear : $("#getYear").val(),
			getMonth : $("#getMonth").val(),
			getDay : $("#getDay").val(),
			ppseq : $("#ppseq").val(),
			accounttype : $("#accounttype").val()
		}

		$.ajaxCall({
			url : "<c:url value="/mobile/reservation/searchBrandProgramListAjax.do"/>",
			type : "POST",
			data : param,
			success : function(data, textStatus, jqXHR) {
				//console.log(data.searchBrandProgramList);
				var brandProgramList = data.searchBrandProgramList;
				var listCnt = data.listCnt;

				/* 해당일에 예약가능한 프로그램 테이블 셋팅 */
				setProgramTable(brandProgramList, listCnt, flag);

				setTimeout(function() {
					abnkorea_resize();
				}, 500);
				
				/* move to top */
				var $pos = $("#pbContent > section.mWrap > div:nth-child(4) > div.selectDiv");
	   			var iframeTop = parent.$("#IframeComponent").offset().top
	   			parent.$('html, body').animate({
	   			    scrollTop:$pos.offset().top + iframeTop
	   			}, 300);
				
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}

	/* 해당일에 예약가능한 프로그램 테이블 셋팅 */
	function setProgramTable(brandProgramList, listCnt, flag) {
		/* 
			rsvflag
				- 300 : 예약마감
				- 200 : 예약대기
				- 100 : 예약가능
		 */
		var html = "";
		var html1 = "";

		$("#personHText").empty();
		$("#groupHText").empty();
		for (var i = 0; i < listCnt; i++) {

			var expseq = '';
			var settypecode = '';
			var worktypecode = '';

			$.each(brandProgramList[i], function(index, value) {
				if (expseq != value.expseq) {
					expseq = value.expseq;
					settypecode = value.settypecode;
					worktypecode = value.worktypecode;
				}

				if (index == 0) {
					/* 카테고리 3이 존재할경우 카테고리 3이름이 타이틀이됨*/
					if (value.categorytype3name != "N") {
						tempWeekDay = value.weekday;
						html = "<table class='tblSession'>"
								+ "	<caption>프로그램 선택</caption>"
								+ "	<colgroup>"
								+ "		<col width='5%' />"
								+ "		<col width='auto' />"
								+ "	</colgroup>"
								+ "	<thead>"
								+ "		<tr>"
								+ "			<th scope='col' colspan='2'>["
								+ value.categorytype2name
								+ "] "
								+ value.categorytype3name
								+ "</th>"
								+ "		</tr>"
								+ "	</thead>"
								+ "	<tbody id = '"+value.categorytype3+"'>"
								+ "	</tbody>" + "</table>";
					} else {
						/* 카테고리3이 존재 하지 않을경우 카테고리 2가 타이틀명이 됨 */
						html = "<table class='tblSession'>"
								+ "	<caption>프로그램 선택</caption>"
								+ "	<colgroup>"
								+ "		<col width='5%' />"
								+ "		<col width='auto' />"
								+ "	</colgroup>"
								+ "	<thead>"
								+ "		<tr>"
								+ "			<th scope='col' colspan='2'>["
								+ value.categorytype2name
								+ "]</th>"
								+ "		</tr>"
								+ "	</thead>"
								+ "	<tbody id = '"+value.categorytype2+"'>"
								+ "	</tbody>" + "</table>";

					}
					if (flag == "P") {
						$("#groupHText").empty();
						$("#personHText").append(html);
					} else {
						$("#personHText").empty();
						$("#groupHText").append(html);
					}
				}
				if (settypecode == value.settypecode
						&& worktypecode != 'S02') {
					/* 카테고리3이 존재할경우,  300 -> 예약 마감 [예약마감은 테이블상에 표현하지 않는다] */
					if ($("#" + value.categorytype3name == value.categorytype3)) {
						html1 = "<tr>"
						if (value.rsvflag == 300){
							html1 += "<td class='vt'><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='programcheck' onclick='javascript:setCheckBox(this);' disabled/></td>";
						}else{
							html1 += "<td class='vt'><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='programcheck' onclick='javascript:setCheckBox(this);'/></td>";
						}
						html1 += "<td class='programTitle'><a href='javascript:void(0);' onclick=\"javascript:showBrandIntro('"
								+ value.categorytype2
								+ "', '"
								+ value.categorytype3
								+ "','"
								+ value.expseq
								+ "', 'D');\">"
								+ value.productname
								+ "</a><br/>";
						html1 += "<em class='iconGray'>"
								+ value.accounttypename
								+ "</em>" + value.session;
						/* 준비물이 있을 경우  */
						if (value.preparation != null
								|| value.preparation != "") {
							html1 += "<span class='prepare' style='display:none'>★준비물 : "
									+ value.preparation
									+ "</span>";
						}
						if (value.rsvflag == 100) {
							html1 += "<span class='able'>예약가능";
						} else if (value.rsvflag == 200) {
							html1 += "<span>대기신청";
						} else if (value.rsvflag == 300){
							html1 += "<span>예약마감";
						}
						html1 += "<input type='hidden' name='tempCategorytype2' value="+value.categorytype2+">";
						html1 += "<input type='hidden' name='tempCategorytype3' value="+value.categorytype3+">";
						html1 += "<input type='hidden' name='tempExpseq' value="+value.expseq+">";
						html1 += "<input type='hidden' name='tempExpsessionseq' value="+value.expsessionseq+">";
						html1 += "<input type='hidden' name='tempStartDateTime' value="+value.startdatetime+">";
						html1 += "<input type='hidden' name='tempEndDateTime' value="+value.enddatetime+">";
						html1 += "<input type='hidden' name='tempSessionTime' value="+value.session+">";
						html1 += "<input type='hidden' name='tempRsvflag' value="+value.rsvflag+"></span>";

						html1 += "</tr>";
						$("#" + value.categorytype3).append(
								html1);
					}
					/* 카테고리 3이 존재 하지 않을경우, 300 -> 예약마감은 테이블사에 표현하지 않는다 */
					if (value.categorytype3name == "N"
							&& $("#" + value.categorytype2 == value.categorytype2)) {
						html1 = "<tr>"
						if (value.rsvflag == 300){
							html1 += "<td class='vt'><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='programcheck' onclick='javascript:setCheckBox(this);' disabled/></td>";
						}else{
							html1 += "<td class='vt'><input type='checkbox' id='"+value.idvalue+"_"+value.expsessionseq+"' name='programcheck' onclick='javascript:setCheckBox(this);'/></td>";
						}
						html1 += "<td class='programTitle'><a href='javascript:void(0);' onclick=\"javascript:showBrandIntro('"
								+ value.categorytype2
								+ "','"
								+ value.categorytype3
								+ "','"
								+ value.expseq
								+ "', 'D');\">"
								+ value.productname
								+ "</a><br/>";
						html1 += "<em class='iconGray'>"
								+ value.accounttypename
								+ "</em>" + value.session;

						/* 준비물이 있을 경우  */
						if (value.preparation != null
								|| value.preparation != "") {
							html1 += "<span class='prepare' style='display:none;'>★준비물 : "
									+ value.preparation
									+ "</span>";
						}
						if (value.rsvflag == 100) {
							html1 += "<span class='able'>예약가능";
						} else if (value.rsvflag == 200) {
							html1 += "<span>대기신청";
						} else if (value.rsvflag == 300){
							html1 += "<span>예약마감";
						}
						html1 += "<input type='hidden' name='tempCategorytype2' value="+value.categorytype2+">";
						html1 += "<input type='hidden' name='tempCategorytype3' value="+value.categorytype3+">";
						html1 += "<input type='hidden' name='tempExpseq' value="+value.expseq+">";
						html1 += "<input type='hidden' name='tempExpsessionseq' value="+value.expsessionseq+">";
						html1 += "<input type='hidden' name='tempStartDateTime' value="+value.startdatetime+">";
						html1 += "<input type='hidden' name='tempEndDateTime' value="+value.enddatetime+">";
						html1 += "<input type='hidden' name='tempSessionTime' value="+value.session+">";
						html1 += "<input type='hidden' name='tempRsvflag' value="+value.rsvflag+"></span>";

						html1 += "</tr>";
						$("#" + value.categorytype2).append(html1);
					}
				}
			});
		}

		$("#personHText").find("table").find("tbody").each(function() {
			if ($(this).children().length == 0) {
				$(this).parent().remove();
			}
		});

		$("#groupHText").find("table").find("tbody").each(function() {
			if ($(this).children().length == 0) {
				$(this).parent().remove();
			}
		});

		//console.log(tempWeekDay);
		$("#appendPpAndRsvDate").empty();
		$("#appendPpAndRsvDate").append(
				"분당 ABC<em class='bar'>|</em>" + $("#getYear").val() + "-"
						+ $("#getMonth").val() + "-" + $("#getDay").val()
						+ tempWeekDay);

	}

	/* step2에서 개별/그룹 탭 클릭시 타입 코드 변경 */
	function setAccountType(flag) {
		/* 개별 */
		if (flag == "P") {
			$("#accounttype").val("A01");
			$("#groupClass").removeClass("on");
			$("#personClass").addClass("on");

			/* 해당 타입 코드 클릭시 카테고리별 예약가능 테이블 호출 */
			nextStep(flag);
		} else {
			/* 그룹 */

			if (3 > $("#targetcodeorder").val()) {
				var msg = "PT이상부터 그룹신청이 가능합니다.";
				alert(msg);

				$("#groupClass").removeClass("on");
				$("#personClass").addClass("on");

				return false;
			} else {
				$("#accounttype").val("A02");
				$("#groupClass").addClass("on");
				$("#personClass").removeClass("on");

				/* 해당 타입 코드 클릭시 카테고리별 예약가능 테이블 호출 */
				nextStep(flag);
			}

		}

	}

	function setCheckBox(obj) {

		/* 선택 영역 활성화 */
		$("input[name='programcheck']").each(function() {

			if ($(this).is(":checked") === true) {
				$(this).parent().parent().addClass("select");

			} else {
				$(this).parent().parent().removeClass("select");
			}
		});

		if ($(obj).is(":checked") == true) {
			if ($(obj).parent().next().children().is(".prepare") == true) {
				$(obj).parent().next().children(".prepare").attr("style",
						"display: block;");
			}
		} else {
			$(obj).parent().next().children(".prepare").attr("style",
					"display: none;");
		}

		if ($("input[name='programcheck']:checked").length > 0) {
			$("#step2Btn").show();
		} else {
			$("#step2Btn").hide();
		}
	}

	/* 예액요청 팝업 호출 */
	function reservationReq() {
		var cnt = 0;
		var tempRsvDate;

		$("#expBrandReqForm").empty();
		$("#checkLimitCount").empty();

		$("input[name='programcheck']:checked").each(function() {
			$($(this).parent().next().children()).each(function(index) {
				if (index == 0) {
					$("#expBrandReqForm").append("<input type='hidden' name ='productName' value ='"+ $(this).text()+ "'>");
				} else if (index == 1) {
					if (index[1] == "" && index[1] == null) {
						$("#expBrandReqForm").append("<input type='hidden' name ='preparation' value ='N'>");
					} else {
						$("#expBrandReqForm").append("<input type='hidden' name ='preparation' value ='"+ $(this).text()+ "'>");
					}
				}
			});

			$("#expBrandReqForm").append("<input type='hidden' name ='expseq' value ='"+ $(this).parent().next().find("input[name='tempExpseq']").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='checkExpseq' value ='"+ $(this).parent().next().find("input[name='tempExpseq']").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='expsessionseq' value ='"+ $(this).parent().next().find("input[name='tempExpsessionseq']").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='startdatetime' value ='"+ $(this).parent().next().find("input[name='tempStartDateTime']").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='enddatetime' value ='"+ $(this).parent().next().find("input[name='tempEndDateTime']").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='rsvflag' value ='"+ $(this).parent().next().find("input[name='tempRsvflag']").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='getYear' value ='"+ $("#getYear").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='getMonth' value ='"+ $("#getMonth").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='getDay' value ='"+ $("#getDay").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='accountType' value ='"+ $("#accounttype").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='ppSeq' value ='"+ $("#ppseq").val() + "'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='weekDay' value ='"+tempWeekDay+"'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='sessionTime' value ='"+ $(this).parent().next().find("input[name='tempSessionTime']").val() + "'>");

			tempRsvDate = $("#getYear").val()+ $("#getMonth").val() + $("#getDay").val();

			$("#expBrandReqForm").append("<input type= 'hidden' name = 'reservationDate' value = '"+tempRsvDate+"'>");
			
			$("#checkLimitCount").append("<input type= 'hidden' name = 'reservationDate' value = '"+tempRsvDate+"'>");
			$("#checkLimitCount").append("<input type= 'hidden' name = 'typeSeq' value = '"+ $("#typeseq").val() + "'>");
			$("#checkLimitCount").append("<input type=\"hidden\" name=\"expseq\" value=\""+ $(this).parent().next().find("input[name='tempExpseq']").val() + "\">");

			cnt++;
		});

		if (cnt == 0) {
			alert("프로그램을 선택해 주십시오.");
			return false;
		} else {
			/* 패널티 유효성 중간 검사 */
			if (middlePenaltyCheck()) {
				$("#checkLimitCount").append("<input type=\"hidden\" name=\"typeseq\" value=\""+ $("#typeseq").val() + "\">");
				$("#checkLimitCount").append("<input type=\"hidden\" name=\"ppseq\" value=\""+ $("#ppseq").val() + "\">");

				$.ajaxCall({
					url : "<c:url value='/mobile/reservation/expBrandRsvAvailabilityCheckAjax.do'/>",
					type : "POST",
					data : $("#checkLimitCount").serialize(),
					success : function(data, textStatus, jqXHR) {
						if (data.rsvAvailabilityCheck) {
							duplicateCheck();
						} else {
							alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
						}

					},
					error : function(jqXHR, textStatus, errorThrown) {
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

	function middlePenaltyCheck() {

		var penaltyCheck = true;
		$.ajaxCall({
			url : "<c:url value='/reservation/rsvMiddlePenaltyCheckAjax.do'/>",
			type : "POST",
			data : $("#checkLimitCount").serialize(),
			async : false,
			success : function(data, textStatus, jqXHR) {
				if (!data.middlePenaltyCheck) {
					alert("패널티로 인해서 예약이 불가 합니다.");
					penaltyCheck = false;

					/* move to top */
					var $pos = $("#step2Btn");
					var iframeTop = parent.$("#IframeComponent").offset().top
					parent.$('html, body').animate({
					    scrollTop:$pos.offset().top + iframeTop
					}, 300);
					
				}
				
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
		return penaltyCheck;
	}

	function expBrandCalendarRsvRequestPop() {

		/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
		var param = $("#expBrandReqForm").serialize();

		$.ajaxCall({
			url : "<c:url value="/mobile/reservation/expBrandRsvRequestPopAjax.do"/>",
			type : "POST",
			data : param,
			success : function(data, textStatus, jqXHR) {

				var expBrandRsvInfoList = data.expBrandRsvInfoList;
				var totalCnt = data.totalCnt;
				var partnerTypeCodeList = data.partnerTypeCodeList;

				setReservationReq(expBrandRsvInfoList, totalCnt,
						partnerTypeCodeList);

			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
	
	function expBrandDisablePop(cancelDataList){
		
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
		
		rsvConfirmPop_resize();
	}

	function setReservationReq(expBrandRsvInfoList, totalCnt,
			partnerTypeCodeList) {

		var html = "";
		$(".tblResrConform").empty();

		html = "<colgroup><col width='30%' /><col width='70%' /></colgroup>";
		html += "<thead>";
		html += "	<tr><th scope='col' colspan='2'>분당ABC <em>|</em>"
				+ expBrandRsvInfoList[0].getYear + "-"
				+ expBrandRsvInfoList[0].getMonth + "-"
				+ expBrandRsvInfoList[0].getDay + " "
				+ expBrandRsvInfoList[0].weekDay + "</th></tr>";
		html += "</thead>";
		html += "<tfoot>";
		html += "	<tr>";
		html += "		<td colspan='2'>총 " + totalCnt + "건</td>";
		html += "	</tr>";
		html += "</tfoot>";
		html += "<tbody>";
		for (var i = 0; i < expBrandRsvInfoList.length; i++) {

			$("#expBrandReqForm").append("<input type='hidden' name ='typeseq' value ='"+expBrandRsvInfoList[i].typeseq+"'>");
			$("#expBrandReqForm").append("<input type='hidden' name ='reservationDate' value ='"+expBrandRsvInfoList[i].getYear+expBrandRsvInfoList[i].getMonth+expBrandRsvInfoList[i].getDay+"'>");

			html += "<tr>";
			html += "	<th class='bdTop'>구분</th>";
			/* 그룹코드 A01 -> 개인 */
			if (expBrandRsvInfoList[i].accountType == "A01") {
				html += "<td class='bdTop'>개별</td>";
			} else {
				html += "<td class='bdTop'>그룹</td>";
			}
			html += "</tr>";
			html += "	<tr>";
			html += "		<th>프로그램</th>";
			html += "		<td>" + expBrandRsvInfoList[i].productName + "</td>";
			html += "	</tr>";
			html += "	<tr>";
			html += "		<th>체험시간</th>";
			html += "		<td>" + expBrandRsvInfoList[i].sessionTime + "</td>";
			html += "	</tr>";
			html += "	<tr>";
			html += "		<th>동반여부</th>";
			if (expBrandRsvInfoList[i].accountType == "A01") {
				html += "	<td>";
				html += "		<select title='동반여부' name='partnerTypeCode'>";
				html += "		<option value=''>선택해주세요</option>";
				for (var j = 0; j < partnerTypeCodeList.length; j++) {
					html += "<option value="+partnerTypeCodeList[j].commonCodeSeq+">"
						 +   partnerTypeCodeList[j].codeName + "</option>"
				}
				html += "		</select>";
				html += "	<td>";
			} else {
				html += "	<td>-</td>";
			}
			html += "	</tr>";
		}

		html += "</tbody>";

		$(".tblResrConform").append(html);

		layerPopupOpen("<a href='#uiLayerPop_confirm' class='btnBasicBL'>예약요청</a>");
		$($("#uiLayerPop_confirm").find(".btnBasicBL")).attr("onclick", "javascript:expBrandReservation(this);");
		
		rsvConfirmPop_resize();

	}

	/*
	 * 필수 입력값 체크 및 확인
	 */
	var mendatoryCheck = {

		partnerSelectbox : function() {

			var mendatoryCheckForSelectBox = false;

			$("select[name=partnerTypeCode]").each(function() {

				if (0 == $(this).val().length) {
					mendatoryCheckForSelectBox = true;
				}
			});

			if (mendatoryCheckForSelectBox) {
				alert("동반여부는필수 선택 입니다.");
				return false;
			} else {
				return true;
			}
		}
	};

	function expBrandReservation(obj) {
		if (!mendatoryCheck.partnerSelectbox()) {
			return;
		}
		
		$(obj).removeAttr("onclick");
		
		$("#stepDone").show();

		$("select[name=partnerTypeCode]").each(function() {
			$("#expBrandReqForm").append("<input type= 'hidden' name = 'partnerTypeCode' value = '"+ $(this).children("option:selected").val()+ "'>")
		});

		var param = $("#expBrandReqForm").serialize();

		$.ajaxCall({
			url : "<c:url value='/mobile/reservation/expBrandCalendarInsertAjax.do' />",
			type : "POST",
			data : param,
			success : function(data, textStatus, jqXHR) {

				if ("false" == data.possibility) {
					alert(data.reason);
					return false;
				} else {
					$("#transactionTime").val(data.transactionTime);
					var expBrandRsvInfoList = data.expBrandCalendarRsvInfoList;
					var totalCnt = data.totalCnt;
					
					if(expBrandRsvInfoList[0].msg == "false"){
						alert(expBrandRsvInfoList[0].reason);
						return false;
					}else{
						setExpBrandReservation(expBrandRsvInfoList, totalCnt);

						$("#step2Btn").parents('.bizEduPlace').removeClass('current').addClass('finish');
						$("#step2Btn").parents('.bizEduPlace').find('.result').show();
						$("#step2Btn").parents('.bizEduPlace').find('.selectDiv').slideUp();
						$("#stepDone").show();
					}
				}

				setTimeout(function() {abnkorea_resize();}, 500);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
				$(obj).attr("onclick", "javascript:expBrandReservation(this);");
			}
		});

	}

	function setExpBrandReservation(expBrandRsvInfoList, totalCnt) {
		$("#uiLayerPop_confirm").css("display", "none");
		$("#layerMask").remove();

		var snsHtml = "[한국암웨이]시설/체험 예약내역 (총 " + totalCnt + "건) \n";
		var html = "";
		html = "<em class='bizIcon step04'></em><strong class='step'>STEP2/ 프로그램</strong>";
		html += "<span>총" + totalCnt + "건</span>";
		html += "<div class='resultDetail'>";
		for (var i = 0; i < expBrandRsvInfoList.length; i++) {
			if (expBrandRsvInfoList[i].accountType == "A01") {
				if (expBrandRsvInfoList[i].partnerTypeCode == "R01") {
					if (expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0") {
						html += "<span>개별<em class='bar'>|</em><br/>"
								+ expBrandRsvInfoList[i].productName
								+ "<em class='bar'>|</em>"
								+ expBrandRsvInfoList[i].sessionTime
								+ "<em class='bar'>|</em>ABO</span>";

						snsHtml += "■ 개별 | 분당 ABC ("
								+ expBrandRsvInfoList[i].productName + ") "
								+ $("#getYear").val() + "-"
								+ $("#getMonth").val() + "-"
								+ $("#getDay").val() + tempWeekDay + " | \n"
								+ expBrandRsvInfoList[i].sessionTime
								+ "| ABO\n";

					} else{
						html += "<span>개별<em class='bar'>|</em><br/>"
								+ expBrandRsvInfoList[i].productName
								+ "<em class='bar'>|</em>"
								+ expBrandRsvInfoList[i].sessionTime
								+ "(예약 대기)<em class='bar'>|</em>ABO</span>";

						snsHtml += "■ 개별 | 분당 ABC ("
								+ expBrandRsvInfoList[i].productName + ") "
								+ $("#getYear").val() + "-"
								+ $("#getMonth").val() + "-"
								+ $("#getDay").val() + tempWeekDay + " | \n"
								+ expBrandRsvInfoList[i].sessionTime
								+ "(예약 대기) | ABO\n";
					}
				} else if (expBrandRsvInfoList[i].partnerTypeCode == "R02") {
					if (expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0") {
						html += "<span>개별<em class='bar'>|</em><br/>"
								+ expBrandRsvInfoList[i].productName
								+ "<em class='bar'>|</em>"
								+ expBrandRsvInfoList[i].sessionTime
								+ "<em class='bar'>|</em>일반인</span>";

						snsHtml += "■ 개별 | 분당 ABC ("
								+ expBrandRsvInfoList[i].productName + ") "
								+ $("#getYear").val() + "-"
								+ $("#getMonth").val() + "-"
								+ $("#getDay").val() + tempWeekDay + " | \n"
								+ expBrandRsvInfoList[i].sessionTime
								+ "| 일반인\n";

					} else {
						html += "<span>개별<em class='bar'>|</em><br/>"
								+ expBrandRsvInfoList[i].productName
								+ "<em class='bar'>|</em>"
								+ expBrandRsvInfoList[i].sessionTime
								+ "(예약 대기)<em class='bar'>|</em>일반인</span>";

						snsHtml += "■ 개별 | 분당 ABC ("
								+ expBrandRsvInfoList[i].productName + ") "
								+ $("#getYear").val() + "-"
								+ $("#getMonth").val() + "-"
								+ $("#getDay").val() + tempWeekDay + " | \n"
								+ expBrandRsvInfoList[i].sessionTime
								+ "(예약 대기) | 일반인\n";

					}
				} else if (expBrandRsvInfoList[i].partnerTypeCode == "R03") {
					if (expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0") {
						html += "<span>개별<em class='bar'>|</em><br/>"
								+ expBrandRsvInfoList[i].productName
								+ "<em class='bar'>|</em>"
								+ expBrandRsvInfoList[i].sessionTime
								+ "<em class='bar'>|</em>비동반</span>";

						snsHtml += "■ 개별 | 분당 ABC ("
								+ expBrandRsvInfoList[i].productName + ") "
								+ $("#getYear").val() + "-"
								+ $("#getMonth").val() + "-"
								+ $("#getDay").val() + tempWeekDay + " | \n"
								+ expBrandRsvInfoList[i].sessionTime
								+ " | 비동반\n";

					} else {
						html += "<span>개별<em class='bar'>|</em><br/>"
								+ expBrandRsvInfoList[i].productName
								+ "<em class='bar'>|</em>"
								+ expBrandRsvInfoList[i].sessionTime
								+ "(예약 대기)<em class='bar'>|</em>비동반</span>";

						snsHtml += "■ 개별 | 분당 ABC ("
								+ expBrandRsvInfoList[i].productName + ") "
								+ $("#getYear").val() + "-"
								+ $("#getMonth").val() + "-"
								+ $("#getDay").val() + tempWeekDay + " | \n"
								+ expBrandRsvInfoList[i].sessionTime
								+ "(예약 대기) | 비동반\n";

					}
				}
			} else {
				if (expBrandRsvInfoList[i].rsvflag == "100" && expBrandRsvInfoList[i].standbynumber == "0") {
					html += "<span>그룹<em class='bar'>|</em><br/>"
							+ expBrandRsvInfoList[i].productName
							+ "<em class='bar'>|</em>"
							+ expBrandRsvInfoList[i].sessionTime
							+ "<em class='bar'>";

					snsHtml += "■ 그룹 | 분당 ABC ("
							+ expBrandRsvInfoList[i].productName + ") "
							+ $("#getYear").val() + "-" + $("#getMonth").val()
							+ "-" + $("#getDay").val() + tempWeekDay + " | \n"
							+ expBrandRsvInfoList[i].sessionTime + "\n";

				} else {
					html += "<span>그룹<em class='bar'>|</em><br/>"
							+ expBrandRsvInfoList[i].productName
							+ "<em class='bar'>|</em>"
							+ expBrandRsvInfoList[i].sessionTime
							+ "(예약 대기)<em class='bar'>";

					snsHtml += "■ 그룹 | 분당 ABC ("
							+ expBrandRsvInfoList[i].productName + ") "
							+ $("#getYear").val() + "-" + $("#getMonth").val()
							+ "-" + $("#getDay").val() + tempWeekDay + " | \n"
							+ expBrandRsvInfoList[i].sessionTime + "(예약 대기)\n";

				}
			}
		}
		html += "";
		html += "";
		html += "</div>";

		$("#appendResultDetail").append(html);

		$("#snsText").empty();
		$("#snsText").val(snsHtml);

	}

	function closePop() {
		$("#uiLayerPop_confirm").css("display", "none");
		$(".brandReserv").css("display", "block");
		$(".brandReserv").parent().parent().css("display", "block");
		$(".brandReserv").parent().parent().prev().css("display", "none");

		setTimeout(function() {abnkorea_resize();}, 500);
	}

	function showBrandIntro(categorytype2, categorytype3, expseq, flag) {
		$("#categorytype3Pop").val("");
		$("#categorytype2Pop").val("");
		$("#expseqPop").val("");

		$("#categorytype3Pop").val(categorytype3);
		$("#categorytype2Pop").val(categorytype2);
		$("#expseqPop").val(expseq);

		//falg -> I: 프로그램 소개 버튼/ flag->D : 해당프로그램 디테일

		if (flag == "I") {
			$("#appendBradnCategoryLayer").css("display", "none");
			//카테고리 3셋팅

			$("#selectArea").children().removeClass("active");

			// 		setCategorytype3Layer('I', '');
		} else {
			//카테고리 3셋팅
			setCategorytype3Layer('D', $("#categorytype2Pop").val());

		}

		layerPopupOpen("<a href='#uiLayerPop_brandExp' class='btnTbl'>예약요청</a>");
		return false;
	}

	function showExpRsvComfirmPop() {

		$("#getYearLayer").val($("#getYearPop").val());
		$("#getMonthLayer").val($("#getMonthPop").val());

		searchCalLayer();
		setToday();

		layerPopupOpen("<a href='#uiLayerPop_calender2' class='btnTbl'>체험예약 현황확인</a>");
		return false;

		setTimeout(function() {abnkorea_resize();}, 500);
	}

	/* 잔여일 표시 - 달력의 '월'을 클릭 후 우상단에 남은 잔여일을 쿼리 하는 기능 */
	function getRemainDayByMonth() {
		var param = {
			reservationdate : $("#getYearPop").val() + $("#getMonthPop").val()
					+ "01",
			rsvtypecode : "R02",
			ppseq : $("#ppseq").val(),
			typeseq : $("#typeseq").val(),
			expseq : expseq
		};

		$.ajaxCall({
			url : "<c:url value='/reservation/getRemainDayByMonthAjax.do'/>",
			type : "GET",
			data : param,
			async : false,
			success : function(data, textStatus, jqXHR) {
				if (data) {
					$("#remainDay").empty();
					$("#remainDay").append(data.remainDay);
				} else {
					$("#remainDay").empty();
					$("#remainDay").append("0");
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}

	function closeBrandRsvLayer() {

		$("#uiLayerPop_confirm").hide();
		$("#layerMask").remove();

		setTimeout(function() {
			abnkorea_resize();
		}, 500);
	}

	
	function tempSharing(url, sns){
		
		if (sns == 'facebook'){
			
			var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
			var title = "abnKorea - 브랜드체험 예약";
			var content = $("#snsText").val();
			var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
			
			sharing(currentUrl, title, sns, content);
			
		}else{
			
			var title = "abnKorea";
			var content = $("#snsText").val();
			
			sharing(url, title, sns, content);
		}
		
	}
	
	

	/* 예약불가 팝업 확인 이벤트 */
	function eduCultureDisabledConfirm(){
		
		var selectChoice = $("input:radio[name='resConfirm']:checked").val();
		
		if( selectChoice == "sessionSelect1"){
			
			/* 발견된 중복건수를 opener 페이지의 세션선택 상자에서 찾은 후 해제 시키는 기능 */
			$("#uiLayerPop_cannot input[type='hidden']").each(function(){
				$("#" + $(this).val()).prop("checked", false);
				$("#" + $(this).val()).parent().parent().removeClass("select")
			});
		
			/* 세션 갱신 후 재예약 요청 */
			reservationReq();
			
		}
		
		cannotClosePop();
	}
	
	/* 레이어 팝업 닫기 */
	function cannotClosePop(){
		$("#uiLayerPop_cannot").fadeOut();
//	 	 $("#step2Btn").parents("dd").show();
//	 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
//	 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
		$("#layerMask").remove();
		 
		$('html, body').css({
			overflowX:'',
			overflowY:''
		});
	}
	
	/* move to top */
	function moveTop(){
		/* move to top */
		var $pos = $("#pbContent > section.mWrap > div:nth-child(4) > div.selectDiv");
		var iframeTop = parent.$("#IframeComponent").offset().top
		parent.$('html, body').animate({
		    scrollTop:$pos.offset().top + iframeTop
		}, 300);
	}

	
</script>
<!-- </head> -->
<!-- <body class="uiGnbM3"> -->

<form id="expBrandCalendarForm" name="expBrandCalendarForm"
	method="post">
	<input type="hidden" id="getYear" name="getYear"> <input
		type="hidden" id="getMonth" name="getMonth"> <input
		type="hidden" id="getDay" name="getDay"> <input type="hidden"
		id="accounttype" name="accounttype" value="A01"> <input
		type="hidden" id="ppseq" name="ppseq"
		value="${searchBrandPpInfo.ppseq}"> <input type="hidden"
		id="typeseq" name="typeseq" value="${searchBrandPpInfo.typeseq}">
	<input type="hidden" id="targetcodeorder" name="targetcodeorder">

	<!-- 예약현황 확인 팝업에 필요한 년, 월 셋팅 -->
	<input type="hidden" id="getMonthPop" name="getMonthPop"> <input
		type="hidden" id="getYearPop" name="getYearPop"> <input
		type="hidden" id="getDayPop" name="getDayPop">

</form>
<form id="expBrandReqForm" name="expBrandReqForm" method="post"></form>

<form id="expInfoForm" name="expInfoForm" method="post">
	<input type="hidden" id="categorytype3" name="categorytype3"> <input
		type="hidden" id="categorytype2" name="categorytype2"> <input
		type="hidden" id="expseq" name="expseq"> <input type="hidden"
		id="categorytype2Pop" name="categorytype2Pop"> <input
		type="hidden" id="categorytype3Pop" name="categorytype3Pop"> <input
		type="hidden" id="expseqPop" name="expseq">
</form>
<form id="checkLimitCount" name="checkLimitCount" method="post"></form>


<div id="pbContainer">
	<section id="pbContent" class="bizroom">

		<input type="hidden" id="transactionTime" />
		<input type="hidden" id="snsText" name="snsText">

		<section class="brIntro">
			<h2>
				<a href="#uiToggle_01">브랜드체험 예약 필수 안내</a>
			</h2>
			<div id="uiToggle_01" class="toggleDetail">

				<c:out value="${reservationInfo}" escapeXml="false" />
			</div>
		</section>

		<section class="mWrap">
			<ul class="tabDepth1 tNum2">
				<li class="on"><strong>날짜 먼저선택</strong></li>
				<li><a href="#none" id="choiceProgram">프로그램 먼저선택</a></li>
			</ul>
			<div class="blankR">
				<a href="#" class="btnTbl"
					onclick="javscript:showBrandIntro('E0301', 'E030101', '', 'I');">브랜드체험
					소개</a>
			</div>
			<!-- 스텝1 -->
			<div class="bizEduPlace">
				<div class="result">
					<div class="tWrap">
						<em class="bizIcon step02"></em><strong class="step">STEP1/
							날짜</strong> <span id="appendPpAndRsvDate"></span>
						<%
							//<button class="bizIcon showHid">수정</button>
						%>

					</div>
				</div>
				<!-- 펼쳤을 때 -->
				<div class="selectDiv">
					<dl class="selcWrap">
						<dt>
							<div class="tWrap">
								<em class="bizIcon step02"></em><strong class="step">STEP1/
									날짜</strong><span>날짜를 선택하세요.</span>
							</div>
						</dt>
						<dd>
							<div class="hWrap">
								<p class="tit">날짜 선택</p>
								<a href="#" class="btnTbl"
									onclick="javascript:showExpRsvComfirmPop();">체험예약 현황확인</a>
							</div>
							<section class="calenderBookWrap">
								<div class="calenderHeader"></div>

								<table class="tblBookCalendar">
									<caption>캘린더형 - 날짜별 체험예약가능 시간</caption>
									<colgroup>
										<col style="width: 13.5%">
										<col style="width: 14.5%" span="5">
										<col style="width: auto">
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
								<div class="tblCalendarBottom pdbNone">
									<div class="resrState">
										<span class="calIcon2 personal"></span>개인 <span
											class="calIcon2 group"></span>그룹
									</div>
								</div>
							</section>
							<div class="btnWrap">
								<a href="#none" class="btnBasicBL" id="step1Btn"
									onclick="javascript:showStep2();">다음</a>
							</div>
						</dd>
					</dl>
				</div>
				<!-- //펼쳤을 때 -->
			</div>
			<!-- 스텝2 -->
			<div class="bizEduPlace">
				<div class="result">
					<div class="tWrap" id="appendResultDetail"></div>
				</div>
				<!-- 펼쳤을 때 -->
				<div class="selectDiv">
					<dl class="selcWrap">
						<dt>
							<div class="tWrap">
								<em class="bizIcon step04"></em><strong class="step">STEP2/
									프로그램</strong><span>프로그램을 선택해 주세요.</span>
							</div>
						</dt>
						<dd class="brandReserv">

							<div class="tabWrapLogicalBrand tNum2">
								<section class="on" id="personClass">
									<h2 class="tab01">
										<a href="#none" onclick="javascript:setAccountType('P');">개별</a>
									</h2>
									<div>
										<!-- 										<div class="hText" id="remaindCntPer"> -->
										<!-- 										<span>5월 예약가능 잔여회수 4회</span> -->
										<!-- 										</div> -->

										<div id="personHText"></div>

										<ul class="listWarning">
<!-- 											<li>※ 예약은 월 5회까지 가능합니다.</li> -->
											<li>※ 특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여
												3개월간 예약이 불가합니다.</li>
											<li>※ PT이상부터 그룹신청이 가능합니다.</li>
										</ul>

									</div>
								</section>
								<section id="groupClass">
									<h2 class="tab02">
										<a href="#none" onclick="javascript:setAccountType('G');">그룹</a>
									</h2>
									<div>
										<!-- 										<div class="hText" id="remaindCntGro"> -->
										<!-- 										<span>5월 예약가능 잔여회수 4회</span> -->
										<!-- 										</div> -->

										<div id="groupHText"></div>

										<ul class="listWarning">
<!-- 											<li>※ 예약은 월 5회까지 가능합니다.</li> -->
											<li>※ 특정 브랜드 체험 취소 없이 참여하지 않는 경우, 해당 브랜드 체험 프로그램에 대하여
												3개월간 예약이 불가합니다.</li>
											<li>※ PT이상부터 그룹신청이 가능합니다.</li>
										</ul>
									</div>
								</section>
							</div>

							<div class="btnWrap aNumb2">
								<a href="#none" class="btnBasicGL" onclick="javascript:moveTop();">이전</a> 
								<a href="#" class="btnBasicBL" id="step2Btn" onclick="javscript:reservationReq();">예약요청</a>
								<!-- <a href="#uiLayerPop_confirm" class="btnBasicBL" onclick="layerPopupOpen(this);return false;">예약요청</a> -->
							</div>

						</dd>
					</dl>
				</div>
				<!-- //펼쳤을 때 -->
			</div>

			<!-- 예약완료 -->
			<div class="stepDone selcWrap" id="stepDone">
				<div class="doneText">
					<strong class="point1">예약</strong><strong class="point3">이
						완료 되었습니다.</strong><br /> 이용해 주셔서 감사합니다.
				</div>

				<div class="detailSns">
					<a href="#none" id="snsKt"onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"title="새창열림">
						<img src= "/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡">
					</a> 
					<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림">
						<img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리">
					</a>
					<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');" title="새창열림">
						<img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드">
					</a>
					<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');" title="새창열림">
						<img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북">
					</a>
				</div>
				<span class="doneText">예약내역공유</span>

				<div class="btnWrap aNumb2">
					<a href="/mobile/reservation/expBrandForm.do" class="btnBasicGL">예약계속하기</a>
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

				<table class="tblResrConform">

				</table>

				<div class="grayBox">
					위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br /> <span class="point3">[예약확정]
						하셔야 정상적으로 예약이 완료됩니다.</span>
				</div>

				<div class="btnWrap aNumb2">
					<span><a href="#" class="btnBasicGL" onclick="javascript:closeBrandRsvLayer();">예약취소</a></span> 
					<span><a href="#" class="btnBasicBL">예약확정</a></span>
				</div>
				<!-- 				<div class="btnWrap bNumb1"> -->
				<!-- 					<a href="#none" class="btnBasicBL" onclick="javascript:expBrandReservation();">다음</a> -->
				<!-- 				</div> -->
			</div>
			<a href="#none" class="btnPopClose" onclick="javascript:closePop();"><img
				src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
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
		<%@ include
			file="/WEB-INF/jsp/mobile/reservation/exp/expBrandIntroPop.jsp"%>
		<%@ include
			file="/WEB-INF/jsp/mobile/reservation/exp/expRsvConfirmPop.jsp"%>
	</section>
</div>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
