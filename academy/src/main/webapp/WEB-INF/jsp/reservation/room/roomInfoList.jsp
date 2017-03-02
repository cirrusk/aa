<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
/* 뒤로가기 제어 */
history.pushState(null, null, location.href); 
window.onpopstate = function(event) { 
	history.go(1);
}

$(document.body).ready(function(){
	// 	$('#IframeComponent', parent.document).height(3000);
	
	$(".btnBasicBL").on("click", function(){
		try{
			self.close();
		}catch(e){
// 			console.log(e);
		}
		
	});
	
	/* 캘린더 호출 */
	$(".calendar").click(function () {
		/* 캘린더 그리기 & 하단 예약 현황 상세 테이블 그리는 함수 호출 */
		calenderInfoAjax($("#year").val(), $("#month").val());
	});
	
	/* 년도 변경시 */
	$("#year").change(function () {
		calenderInfoAjax($("#year").val(), $("#month").val());
	});
	
	/* 월 변경시 */
	$("#month").change(function () {
		calenderInfoAjax($("#year").val(), $("#month").val());
	});
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	/* 조회 버튼 활성화 delay */
	setTimeout(function(){
	    $('#searchBtn').addClass("btnBasicRS");
	    $('#searchBtn').click(doSearch);
	 }, 1000); 
	
});

/* 달력 정보 조회 */
function calenderInfoAjax(year, month){
	var param = {
			  "year" : year
			, "month" : month
			
			/* 이전달, 현재달, 다음달 예약정보 카운트 조회 파라미터 */
			, "getYear" : year
			, "getMonth" : month
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
			
			var monthRsvCount = data.monthRsvCount;
			
			$("#calTopText").empty();
			$("#calTopText").append("총 <strong>"+monthRsvCount.thismonthcnt+"개</strong>의 시설예약 내역이 있습니다.");
			
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
					html += " <td class=\""+calendar[cnt].engweekday+" days on\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <div><em>"+calendar[cnt].day+"</em>"
						+ " <div class=\"roomRerv\">";
						
					$("#popDay").val("");
					$("#popDay").val(calendar[cnt].day);
					selectYmd = calendar[cnt].ymd;
				}else if(calendar[cnt].day == $("#popDay").val()){
					html += " <td class=\""+calendar[cnt].engweekday+" days on\" onclick=\"javascript:dayCheckReset(this, '"+calendar[cnt].ymd+"');\">"
						+ " <div><em>"+calendar[cnt].day+"</em>"
						+ " <div class=\"roomRerv\">";
						
					$("#popDay").val("");
					$("#popDay").val(calendar[cnt].day);
					selectYmd = calendar[cnt].ymd;
				}
				else{
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
				roomDayReservationListAjax(selectYmd);
				return;
			}
		}
	});
	/* 세션 정보 삭제 */
// 	$(".tblSession").remove();
	
	/* 예약 취소시 리턴 파라미터 선언 */
	$("#parentInfo").val("");
	$("#parentInfo").val("CAL");
	$("#popYear").val("");
	$("#popYear").val($("#year").val());
	$("#popMonth").val("");
	$("#popMonth").val($("#month").val());
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
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
	
	$("#popDay").val($(obj).children("div").children("em").text());
// 	$("#popDay").val("");
// 	$("#popDay").val(calendar[cnt].day);
// 	console.log($(obj).children("div").children("em").text());
	
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
	$("#popDay").val("");
	
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
			+  "<td colspan=\"6\">예약내역이 없습니다.</td>"
			+  "</tr>";
	}else{
		for(var num in reservationList){
			
			var temp = "";
			
			var paymentName = "";
			
			if((reservationList[num].paymentstatuscode == 'P07'
					|| reservationList[num].paymentstatuscode == 'P01'
					|| reservationList[num].paymentstatuscode == 'P02')
					&& reservationList[num].gettoday != reservationList[num].reservationdate){
				temp = "<a href=\"javascript:void(0);\" class=\"btnTbl\" "
					+ "onclick=\"javascript:roomInfoRsvCancel('"
					+ reservationList[num].rsvseq+"', '"+reservationList[num].roomseq+"', '"+reservationList[num].standbynumber+"', '"+reservationList[num].typecode+"');\">"
					+ "<span>예약취소</span></a>";
					
				paymentName = reservationList[num].paymentname;
				
			}else if(reservationList[num].paymentstatuscode == 'P03'){
				temp = "-";
				
				paymentName = reservationList[num].paymentname + "</br>(" + reservationList[num].canceldatetime + ")";
			}else{
				temp = "-";
				
				paymentName = reservationList[num].paymentname;
			}
			
			
			
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
				 +  "<td>"+paymentName+"</td>"
				 +  "<td>"+temp+"</td>"
				 +  "</tr>";
		}
	}
	
	$("#reservationList").append(html);
	
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
	
	calenderInfoAjax($("#year").val(), $("#month").val());
}

//시설 예약 현황 목록 상세 보기
function roomInfoDetailList(purchasedate, roomseq, virtualpurchasenumber, rsvseq){
	$("input[name = purchasedate]").val(purchasedate);
	$("input[name = roomseq]").val(roomseq);
	$("input[name = virtualpurchasenumber]").val(virtualpurchasenumber);
	$("input[name = rsvseq]").val(rsvseq);
	
	$("#roomInfoForm").attr("action", "${pageContext.request.contextPath}/reservation/roomInfoDetailList.do");
	$("#roomInfoForm").submit();
}

//초기화
function clearBtn() {
	$("#strYear").val("");
	$("#strMonth").val("");
	$("#endYear").val("");
	$("#endMonth").val("");
	$("#ppCode").val("");
	
	$('input:checkbox[name="roomType"]').each(function() {
	      this.checked = false;
	 });
}

//검색호출
function doSearch() {
	
	$('#searchBtn').unbind("click");
	
	$("#roomInfoForm").append("<input type='hidden' name='searchStrYear'  value='"+ $("#strYear option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchStrMonth'  value='"+ $("#strMonth option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchEndYear'  value='"+ $("#endYear option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchEndMonth'  value='"+ $("#endMonth option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchPpSeq'  value='"+ $("#ppCode option:selected").val() +"'>");
	
	$("input[name=roomType]:checked").each(function(){
		$("#roomInfoForm").append("<input type='text' name='searchRoomType'  value='"+$(this).val()+"'>");
	});
	
	$("#roomInfoForm").attr("action", "/reservation/roomInfoList.do");
	$("#roomInfoForm").submit();
}

//페이지 이동
function doPage(page) {
	
	$('#searchBtn').unbind("click");
	
	$("#roomInfoForm").append("<input type='hidden' name='searchStrYear'  value='"+ $("#strYear option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchStrMonth'  value='"+ $("#strMonth option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchEndYear'  value='"+ $("#endYear option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchEndMonth'  value='"+ $("#endMonth option:selected").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchPpSeq'  value='"+ $("#ppCode option:selected").val() +"'>");
	
	$("input[name=roomType]:checked").each(function(){
		$("#roomInfoForm").append("<input type='text' name='searchRoomType'  value='"+$(this).val()+"'>");
	});
	
	$("#roomInfoForm > input[name='page']").val(page);  // 
	$("#roomInfoForm").submit();
}

/* 캘린더 취소 팝업 */						
function roomInfoRsvCancel(rsvseq, roomseq, standbynumber, typecode){
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	
	$("input[name = roomseq]").val("");
	$("input[name = roomseq]").val(roomseq);
	
	$("input[name = standbynumber]").val("");
	$("input[name = standbynumber]").val(standbynumber);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	var frm = document.roomInfoForm
	var url = "<c:url value='/reservation/roomInfoRsvCancelPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 캘린더 예약 취소 리턴 호출 함수 */
function viewTypeCalendar(popYear, popMonth, popDay) {
	$("#popDay").val(popDay);
	$("#year").val(popYear);
	$("#month").val(popMonth);
	
	calenderInfoAjax(popYear, popMonth);
}

/* 시설 <-> 체험 */
function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}
</script>
</head>
<body>
<form id="roomInfoForm" name="roomInfoForm" method="post">
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	
	
	
	<!-- 취소 팝업 에서 사용될 파라미터 -->
	<input type="hidden" name="typecode"/>
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="purchasedate">
	<input type="hidden" name="roomseq">
	<input type="hidden" name="virtualpurchasenumber">
	
<!-- 취소 팝업(부모창 호출시 필요) 에서 사용될 파라미터 -->
<!-- 	<input type="hidden" name="rsvseq"> -->
	<input type="hidden" id="parentInfo" name="parentInfo" value="">
	<input type="hidden" id="popYear" name="popYear" value="">
	<input type="hidden" id="popMonth" name="popMonth" value="">
	<input type="hidden" id="popDay" name="popDay" value="">
	
</form>

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="bizroom">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w020500110.gif" alt="시설예약 현황확인"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w020500110.gif" alt="시설예약 현황을 확인할 수 있습니다."></p>
			</div>

			<div class="bizroomStateBox">
				<div class="viewTypeBox">
					<div class="viewTypeSet">
						<a href="#viewTypeList" class="list on">리스트보기</a>
						<a href="#viewTypeCalendar" class="calendar">캘린더보기</a>
					</div>
					<div class="btnR"><a href="#" class="btnCont" onclick="javascript:accessParentPage();"><span>체험예약 현황확인</span></a></div>
				</div>
				
				<!-- 목록 -->
				<!-- 목록형 -->
				<div class="viewWrapper viewList" id="viewTypeList">
					<!-- 조회 -->
					<table class="tblInput searchTbl">
						<caption>조회옵션설정</caption>
						<colgroup>
							<col style="width:18%">
							<col style="width:42%">
							<col style="width:18%">
							<col style="width:22%">
						</colgroup>
						<tbody>
							<tr>
								<th><label for="periodStartY">등록일자</label></th>
								<td colspan="3">
									<select id="strYear" name="strYear" title="등록시작 년도 선택">
										<option value="">선택</option>
										<c:forEach items="${reservationYearCodeList}" var="item">
											<option value="${item}" ${item == scrData.searchStrYear ? "selected" :""}>${item}</option>
										</c:forEach>
									</select>
									년
									<select title="등록시작 월 선택" class="mglSs" id="strMonth" name="strMonth">
										<option value="">선택</option>
										<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
											<option value="${item}" ${item == scrData.searchStrMonth ? "selected" :""}>${item}</option>
										</c:forEach>
									</select>
									월 ~
									<select title="등록종료 년도 선택" class="mglSs" id="endYear" name="endYear">
										<option value="">선택</option>
										<c:forEach items="${reservationYearCodeList}" var="item">
											<option value="${item}" ${item == scrData.searchEndYear ? "selected" :""}>${item}</option>
										</c:forEach>
									</select>
									년
									<select title="등록종료 월 선택" class="mglSs" id="endMonth" name="endMonth">
										<option value="">선택</option>
										<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
											<option value="${item}" ${item == scrData.searchEndMonth ? "selected" :""}>${item}</option>
										</c:forEach>
									</select>
									월
								</td>
							</tr>
							<tr>
								<th><label for="progressState">시설종류</label></th>
								<td class="roomCheck">
									<c:if test="${!empty scrData.searchRoomType}">
										<c:forEach items="${roomRsvTypeInfoCodeList}" var="item">
											<c:set value="0" var="cnt"/>
											<c:forEach items="${scrData.searchRoomType}" var="roomType">
												<c:if test="${roomType eq item.commonCodeSeq}">
													<label for="room1"><input type="checkbox" name="roomType" value="${item.commonCodeSeq}" checked="checked"/>${item.codeName}</label>
												</c:if>
												<c:if test="${roomType ne item.commonCodeSeq}">
													<c:set value="${cnt + 1}" var="cnt"/>
												</c:if>
											</c:forEach>
											<c:if test="${cnt eq fn:length(scrData.searchRoomType)}">
												<label for="room1"><input type="checkbox" name="roomType" value="${item.commonCodeSeq}"/>${item.codeName}</label>
											</c:if>
										</c:forEach>
									</c:if>
									<c:if test="${empty scrData.searchRoomType}">
										<c:forEach items="${roomRsvTypeInfoCodeList}" var="item">
											<label for="room1"><input type="checkbox" name="roomType" value="${item.commonCodeSeq}"/>${item.codeName}</label>
										</c:forEach>
									</c:if>
								</td>
								<th><label for="paymentState">지역</label></th>
								<td>
									<select id="ppCode" name="ppCode" class="selMinSize">
										<option value="">전체</option>
										<c:forEach items="${ppCodeList}" var="item">
												<option value="${item.commonCodeSeq}" ${item.commonCodeSeq == scrData.searchPpSeq ? "selected" :""}>${item.codeName}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="btnWrapC">
						<a href="javascript:void(0);" class="btnBasicGS" onclick="javascript:clearBtn()">초기화</a>
						<a href="javascript:void(0);" class="btnBasicGS" id="searchBtn" >조회</a>
					</div>
					<!-- //조회 -->
			<p class="topText"><strong>총 ${scrData.totalCount} 개</strong>의 등록내역이 있습니다.</p>
			<table class="tblList lineLeft">
						<caption>목록형 - 시설예약 등록내역</caption>
						<colgroup>
							<col style="width:15%">
							<col style="width:auto">
							<col style="width:15%">
							<col style="width:18%">
							<col style="width:11%">
							<col style="width:11%">
							<col style="width:13%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col">등록일자</th>
								<th scope="col">시설종류</th>
								<th scope="col">지역</th>
								<th scope="col">Room명</th>
								<th scope="col">예약건수</th>
								<th scope="col">취소건수</th>
								<th scope="col">상세보기</th>
							</tr>
						</thead>
				<tbody>
				<c:forEach items="${roomInfoList}" var="item">
					<tr> 
						<td>${fn:substring(item.purchasedate,0,4)}-${fn:substring(item.purchasedate,4,6)}-${fn:substring(item.purchasedate,6,8)}</td>
						<td>${item.typename}</td>
						<td>${item.ppname}</td>
						<td>${item.roomname}</td>
						<td>${item.roomrsvtotalcounnt}건</td>
						<c:if test="${item.cancelcodecount eq 0}">
							<td>-</td>
						</c:if>
						<c:if test="${item.cancelcodecount ne 0}">
							<td>${item.cancelcodecount}건</td>
						</c:if>
						<td>
							<a href="#" class="btnTbl" onclick="javascript:roomInfoDetailList('${item.purchasedate}', '${item.roomseq}', '${item.virtualpurchasenumber}', '${item.rsvseq}');">
							<span>상세보기</span>
							</a>
						</td>
					</tr>
				</c:forEach>

				</tbody>
			</table>
					<!-- //페이지처리 -->
					<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
						<jsp:param name="rowPerPage" value="${scrData.rowPerPage}"/>
						<jsp:param name="totalCount" value="${scrData.totalCount}"/>
						<jsp:param name="colNumIndex" value="10"/>
						<jsp:param name="thisIndex" value="${scrData.page}"/>
						<jsp:param name="totalPage" value="${scrData.totalPage}"/>
					</jsp:include>
				</div>
				<!-- //목록형 -->
				
				<!-- 캘린더형 -->
				<div class="viewWrapper viewCalendar" id="viewTypeCalendar">
					<p class="topText" id="calTopText"><strong>총 00 개</strong>의 시설예약 내역이 있습니다.</p>
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
							<a href="#" id="monthPrev" class="monthPrev" onclick="javascript:setMonth('pre');"><span>이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
							<a href="#" id="monthNext" class="monthNext" onclick="javascript:setMonth('post');"><span>다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
						</div>
						
						<table class="tblCalendar">
						</table>
						
						<div class="tblCalendarBottom">
							<div class="orderState"> 
								<span class="calIcon2 blue"></span>교육장
								<span class="calIcon2 green"></span>비즈룸
								<span class="calIcon2 red"></span>퀸룸/파티룸
								<!-- @edit 20160701 툴팁 제거/텍스트로 변경 -->
								<span class="fcG">(시설종류 별 예약완료된 아이콘 표시)</span>
							</div>
							<div class="btnR"><a href="#none" class="btnCont" onclick="javascript:roomMonthReservationListAjax();"><span>월 예약 전체보기</span></a></div>
						</div>
					</div>
					
					<!-- 해당 월 상세 테이블 -->
					<table class="tblList lineLeft tblBizroomState">
						<caption>해당 월 상세 테이블</caption>
						<colgroup>
							<col width="25%" />
							<col width="18%" />
							<col width="15%" />
							<col width="18%" />
							<col width="12%" />
							<col width="*" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">사용일자 </th>
								<th scope="col">시설종류 </th>
								<th scope="col">지역 </th>
								<th scope="col">Room명 </th>
								<th scope="col">상태 </th>
								<th scope="col"></th>
							</tr>
						</thead>
						<tbody id="reservationList">
<!-- 							<tr>
								<td colspan="6">예약내역이 없습니다.</td>
							</tr>
							<tr>
								<td>2016-05-05 (수)<br/>Session 2(14:00~17:00)</td>
								<td>퀸룸/파티룸</td>
								<td>강서 AP</td>
								<td>비전센타 1</td>
								<td>사용완료</td>
								<td><a href="#" class="btnTbl"><span>예약취소</span></a></td>
							</tr> -->
						</tbody>
					</table>
					<!-- //해당 월 상세 테이블 -->
				</div>
				<!-- //캘린더형 -->
			</div>
		
		</section>
		<!-- //content area | ### academy IFRAME End ### -->
		
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>