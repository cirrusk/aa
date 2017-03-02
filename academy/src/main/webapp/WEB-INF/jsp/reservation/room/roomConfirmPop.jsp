<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){

	/* 캘린더 그리기 & 하단 예약 현황 상세 테이블 그리는 함수 호출 */
	calenderInfoAjax($("#year").val(), $("#month").val());
	
	$(".btnBasicBL").on("click", function(){
		try{
			self.close();
		}catch(e){
// 			console.log(e);
		}
		
	});
	
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
		url: "<c:url value='/reservation/roomCalenderInfoAjax.do'/>"
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
			calenderRender(calendar, today, reservationInfoList);
			
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
			}else{
				$("#thisMonthReserveCount").text("총 0개");
			}

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 달력 그리기 */
function calenderRender(calendar, today, reservationInfoList){
	
	var html = "";
	
	$(".tblCalendar").empty();
	
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
				
				if(calendar[cnt].ymd == today.ymd){
					html += " <td class=\""+calendar[cnt].engweekday+" days on\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <div><em>"+calendar[cnt].day+"</em>"
						+ " <div class=\"roomRerv\">";
				}else{
					html += " <td class=\""+calendar[cnt].engweekday+" days\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <div><em>"+calendar[cnt].day+"</em>"
						+ " <div class=\"roomRerv\">";
				}
				
				var tempTypeName = "";
				for(var j in reservationInfoList){
					if(reservationInfoList[j].ymd == calendar[cnt].ymd
							&& reservationInfoList[j].paymentstatuscode != null
							&& reservationInfoList[j].paymentstatuscode != "P03"
							&& reservationInfoList[j].typename != tempTypeName){
						tempTypeName = reservationInfoList[j].typename;
						if(reservationInfoList[j].typename.substring(0, 2) == "교육"){
							html += "	<span class=\"calIcon2 blueL\"><em>교육장</em></span>";
						}else if(reservationInfoList[j].typename.substring(0, 2) == "비즈"){
							html += "	<span class=\"calIcon2 greenL\"><em>비즈룸</em></span>";
						}else if(reservationInfoList[j].typename.substring(0, 2) == "퀸룸"){
							html += "	<span class=\"calIcon2 redL\"><em>퀸룸파티룸</em></span>";
						}
					}
				}

				html += " </div>"
					+ " </div>"
					+ " </td>"
				
				cnt++;
			}else{
				html += "<td></td>";
			}
		}
		html += "</tr>";
	}
	
	html += "</tbody>";
	
	$(".tblCalendar").append(html);
	
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
	$(obj).addClass("on");
	
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
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
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
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
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
			
			html += "<tr>"
				 +  "<td>"+reservationList[num].reservationdate.substring(0, 4)
				 +	"-"+reservationList[num].reservationdate.substring(4, 6)
				 +	"-"+reservationList[num].reservationdate.substring(6, 8)
				 +	"("+reservationList[num].weekname
				 +	")<br/>"+reservationList[num].sessionname
				 +  "("+reservationList[num].startdatetime.substring(0, 2)
				 +  ":"+reservationList[num].startdatetime.substring(2, 4)
				 +  "~"+reservationList[num].enddatetime.substring(0, 2)
				 +	":"+reservationList[num].enddatetime.substring(2, 4)
				 +	")</td>"
			     +  "<td>"+reservationList[num].typename+"</td>"
			     +  "<td>"+reservationList[num].ppname+"</td>"
			     +  "<td>"+reservationList[num].roomname+"</td>"
				 +  "<td>"+reservationList[num].paymentname+"</td>"
				 +  "</tr>";
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
</head>
<body>
<div id="pbPopWrap">
	<!-- 20161028 -->
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500051.gif" alt="시설예약 현황확인"></h1>
	</header>
	<!-- //20161028 -->
	<a href="#" onclick="javascrip:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent" class="pdNone">
			
		<div class="bizroomStateBox">
			<!-- 캘린더형 -->
			<div class="viewCalendar">
				<p class="topText"><strong id="thisMonthReserveCount">총 0개</strong>의 시설예약 내역이 있습니다.</p>
				<div class="calendarWrapper">
					<div class="monthlyNum">
						<strong>
							<select title="년도" id="year" class="year">
								<c:forEach var="item" items="${yearCodeList}">
									<c:if test="${item eq fn:substring(yearMonthDay.ymd, 0, 4)}">
										<option value="${item}" selected="selected">${item}</option>									
									</c:if>
									<c:if test="${item ne fn:substring(yearMonthDay.ymd, 0, 4)}">
										<option value="${item}">${item}</option>									
									</c:if>
								</c:forEach>
							</select>
							<select title="월" id="month" class="month">
								<c:forEach var="item" items="${monthCodeList}">
									<c:if test="${item eq fn:substring(yearMonthDay.ymd, 4, 6)}">
										<option value="${item}" selected="selected">${item}</option>									
									</c:if>
									<c:if test="${item ne fn:substring(yearMonthDay.ymd, 4, 6)}">
										<option value="${item}">${item}</option>									
									</c:if>
								</c:forEach>
							</select>
						</strong>
						<a href="#" id="monthPrev" class="monthPrev" onclick="javascript:setMonth('pre')"><span>이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
						<a href="#" id="monthNext" class="monthNext" onclick="javascript:setMonth('post')"><span>다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
					</div>
					
					<table class="tblCalendar">
					</table>
					
					<div class="tblCalendarBottom">
						<div class="orderState"> 
							<span class="calIcon2 blue"></span>교육장
							<span class="calIcon2 green"></span>비즈룸
							<span class="calIcon2 red"></span>퀸룸/파티룸
							<!-- @edit 20160701 툴팁 제거 텍스트로 변경 -->
							<span class="fcG">(시설종류 별 예약완료된 아이콘 표시)</span>
						</div>
						<div class="btnR"><a href="#none" class="btnCont" onclick="javascript:roomMonthReservationListAjax();"><span>월 예약 전체보기</span></a></div>
					</div>
				</div>
				
				<!-- 해당 월 상세 테이블 -->
				<table class="tblList lineLeft tblBizroomState">
					<caption>해당 월 상세 테이블</caption>
					<colgroup>
						<col style="width:auto" />
						<col style="width:22%" />
						<col style="width:18%" />
						<col style="width:20%" />
						<col style="width:14%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">사용일자 </th>
							<th scope="col">시설종류 </th>
							<th scope="col">지역 </th>
							<th scope="col">Room명</th>
							<th scope="col">상태 </th>
						</tr>
					</thead>
					<tbody id="reservationList">
					</tbody>
				</table>
				<!-- //해당 월 상세 테이블 -->
			</div>
			<!-- //캘린더형 -->
		</div>
		
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicBL" value="닫기" />
		</div>
	
	</section>
</div>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>