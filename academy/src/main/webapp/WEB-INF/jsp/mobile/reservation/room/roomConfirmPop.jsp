<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script type="text/javascript">

$(document.body).ready(function(){
	/* 년도 변경시 */
	$("#year").change(function () {
		calenderInfoAjax($("#year").val(), $("#month").val());
	});
	
	/* 월 변경시 */
	$("#month").change(function () {
		calenderInfoAjax($("#year").val(), $("#month").val());
	});
	
});

/* 달력 정보 조회 */
function calenderInfoAjax(year, month){
	var param = {
			  "year" : year
			, "month" : month
			
			/* 이전달, 현재달, 다음달 예약정보 카운트 조회 파라미터 */
			, "getYear" : year
			, "getMonth" : month
			, "account" : "tt" /* session 적용 후 삭제 예정 */
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
			
			/* 월(3개월)별 예약건수 */
			var monthRsvCount = data.monthRsvCount;
			
			/* 달련 렌더링 */
			calenderRenderPop(calendar, today, reservationInfoList);
			
			/* 이전달, 다음달 예약정보 유무 렌더링 */
			var strArray = $("#monthNext").prop("class").split(" ");
			var newClassName = ""
			$("#monthNext").prop("class", "");
			for(var i in strArray){
				if(strArray[i] != "on"){
					$("#monthNext").addClass(strArray[i]);
				}
			}
			strArray = $("#monthPrev").prop("class").split(" ");
			newClassName = ""
			$("#monthPrev").prop("class", "");
			for(var i in strArray){
				if(strArray[i] != "on"){
					$("#monthPrev").addClass(strArray[i]);
				}
			}
			
			if(monthRsvCount.postmonthcnt != 0){
				$("#monthNext").addClass("on");
			}
			if(monthRsvCount.premonthcnt != 0){
				$("#monthPrev").addClass("on");
			}
			
			/* 총 xx개의 시설예약 내역이 있습니다. */
			if(monthRsvCount.thismonthcnt){
				$("#thisMonthReserveCount").text("총 " + monthRsvCount.thismonthcnt + "개");
			}
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 달력 그리기 */
function calenderRenderPop(calendar, today, reservationInfoList){
	
	var html = "";
	
	$("#tblBookCalendar2").empty();
	
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
					html += "<td>"
							+ "<a href=\"javascript:void(0);\">"
							+ calendar[cnt].day
							+ "</a>"
							+ "</td>";
				}else{
					html += " <td class=\""+calendar[cnt].engweekday+"\">"
						+ " <a href=\"#none\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"+calendar[cnt].day;
				}
				
				var tempTypeName = "";
				html += "<span>";
				for(var j in reservationInfoList){
					if(reservationInfoList[j].ymd == calendar[cnt].ymd
							&& reservationInfoList[j].paymentstatuscode != null
							&& reservationInfoList[j].paymentstatuscode != "p03"
							&& reservationInfoList[j].typename != tempTypeName){
						tempTypeName = reservationInfoList[j].typename;
						if(reservationInfoList[j].typename == "교육장"){
							html += "<em class=\"calIcon2 blue\">교육장</em>";
						}else if(reservationInfoList[j].typename == "비즈룸"){
							html += "<em class=\"calIcon2 green\">비즈룸</em>";
						}else if(reservationInfoList[j].typename == "퀸룸, 파티룸"){
							html += "<em class=\"calIcon2 red\">퀸룸/파티룸</em>";
						}
					}
				}
				
				html += "</span>";
				html += "</a>";

				html += " </div>"
					+ " </td>";
				
				cnt++;
			}else{
				html += "<td></td>";
			}
		}
		html += "</tr>";
	}
	
	html += "</tbody>";
	
	$("#tblBookCalendar2").append(html);
	
	$("#reservationList").empty();
	$(".days").each(function () {
		var strArray = $(this).prop("class").split(" ");
		for(var i in strArray){
			if(strArray[i] == "on"){
				roomDayReservationListAjax(today.ymd);
				return;
			}
		}
	});
	/* 세션 정보 삭제 */
// 	$(".tblSession").remove();
	
}

/* 기존 날짜 선택 리셋, 해당 날짜 선택 */
function dayCheckReset(obj, reservationDate) {

	$("#tblBookCalendar2").find(".selcOn").removeClass("selcOn");
	
	$(obj).addClass("selcOn");
	
	roomDayReservationListAjax(reservationDate);
}

/* 예약 현황 특정 날짜 본인 예약 정보 조회 */
function roomDayReservationListAjax(reservationDate) {
	
	$.ajax({
		url: "<c:url value='/reservation/roomDayReservationListAjax.do'/>"
		, type : "POST"
		, data: {"reservationDate" : reservationDate}
		, success: function(data, textStatus, jqXHR){
			
			var reservationList = data.roomReservationList;
			
			reservationRender(reservationList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 예약 현황 특정 년, 월 본인 예약 정보 조회 */
function roomMonthReservationListAjax() {
	
	$(".days").each(function () {
		var strArray = $(this).prop("class").split(" ");
		var newClassName = ""
		$(this).prop("class", "");
		for(var i in strArray){
			if(strArray[i] != "on"){
				$(this).addClass(strArray[i]);
			}
		}
	});
	
	$.ajax({
		url: "<c:url value='/reservation/roomMonthReservationListAjax.do'/>"
		, type : "POST"
		, data: {"year" : $("#year").val()
				, "month" : $("#month").val()}
		, success: function(data, textStatus, jqXHR){
			
			var reservationList = data.roomReservationList;
			
			reservationRender(reservationList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 해당 날짜 본인 전체 예약 정보  렌더링 */
function reservationRender(reservationList) {
	
	$("#reservationList").empty();
	
	var html = "";
	
	if(reservationList.length == 0){
		html = "<tr>"
			+  "<td colspan=\"5\">예약내역이 없습니다.</td>"
			+  "</tr>";
	}else{
		for(var num in reservationList){
			
			html  += '<dl class="tblBizroomState">';
			html  += '<dt>사용일자<br/>'
					+ reservationList[num].reservationdate.substring(0,4)
					+	"-"+reservationList[num].reservationdate.substring(4, 6)
					+	"-"+reservationList[num].reservationdate.substring(6, 8)
					+	"("+reservationList[num].weekname+")"
					+  reservationList[num].startdatetime.substring(0, 2)
					+  ":"+reservationList[num].startdatetime.substring(2, 4)
					+  "~"+reservationList[num].enddatetime.substring(0, 2)
					+	":"+reservationList[num].enddatetime.substring(2, 4);
			html  += '</dt>';
			html  += '<dd>';
			html  += reservationList[num].typename +' | '+reservationList[num].ppname +' - '+reservationList[num].roomname+'<br/>상태 : '+reservationList[num].paymentname;
			html  += '</dd>';

		}
	}
	
	$("#reservationList").append(html);
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
	
	calenderInfoAjax($("#year").val(), $("#month").val());
}
</script>

<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_calender2" tabindex="0" style="display: block; top: 0px;">
	<div class="pbLayerContent" style="height: 816px; overflow: auto;">	
				
					<!-- 캘린더형 -->
					<div class="viewCalendar">
						<p class="topText"><strong id="thisMonthReserveCount">총 0개</strong>의 시설예약 내역이 있습니다.</p>
						<div class="calendarWrapper">
							
							<div class="inputBox monthlyNum">
								<p class="selectBox">
										<select title="년도" class="year" id="year">
											<c:forEach items="${reservationYearCodeList}" var="item">
												<option value="${item}">${item}</option>
											</c:forEach>
										</select>
										
										<select title="월" class="month" id="month" >
											<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
												<option value="${item}">${item}</option>
											</c:forEach>
										</select>
								</p>
							
								<a href="#" class="monthPrev"  onclick="javascript:setMonth('pre')"><span class="hide">이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
								<a href="#" class="monthNext" onclick="javascript:setMonth('post')"><span class="hide">다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
							</div>
							
							<table class="tblBookCalendar" id="tblBookCalendar2">
							</table>
							
							<div class="tblCalendarBottom">
								<div class="resrState"> 
									<span class="calIcon2 blue"></span>교육장
									<span class="calIcon2 green"></span>비즈룸
									<span class="calIcon2 red"></span>퀸룸/파티룸
								</div>
								<div class="btnR"><a href="#none" class="btnTbl" onclick="javascript:roomMonthReservationListAjax();"><span>월 예약 전체보기</span></a></div>
							</div>
						</div>
						
						<aa id="reservationList"></aa>
					<!-- //캘린더형 -->
					
					<div class="btnWrap aNumb1">
						<a href="#" class="btnBasicGL2" onclick="javascript:closePop();">닫기</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
