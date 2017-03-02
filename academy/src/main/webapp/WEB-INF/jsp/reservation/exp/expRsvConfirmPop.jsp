<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">
var today;
$(document.body).ready(function(){

	/* 캘린더 그리기 & 하단 예약 현황 상세 테이블 그리는 함수 호출 */
	searchCal();
	
	setToday();
	
	$(".btnBasicBL").on("click", function(){
		try{
			self.close();
		}catch(e){
			//console.log(e);
		}
		
	});
	
});

function setToday(){
	var yymm = $("#getYear option:selected").val();
	yymm += $("#getMonth option:selected").val();
	yymm += $("#getDay").val();
	
	var tempDay = $("#getDay").val();
	
	this.today = yymm;

	
	$("#calTbody").children().find("td").each(function(){
		
		if($(this).is(".weekSun") === true){
			$(this).removeClass();
			$(this).addClass("weekSun");
			
		}else if($(this).is(".weekSat") === true){
			$(this).removeClass();
			$(this).addClass("weekSat");
		}else{
			$(this).removeClass();
		}
		
	});
	
// 	console.log(this.today);
	$("#"+yymm).parent().parent().addClass("on");
	
	rsvExpDetailInfo(tempDay);
}

/* 선택된 년, 월 기준으로  캘린더, 예약 현황 상세 테이블 데이터 조회 */
function searchCal(){
	var param = {
		  getYear : $("#getYear option:selected").val()
		, getMonth : $("#getMonth option:selected").val()
		, rsvtypecode : "R02"
	};
	
	$.ajax({
		url: "<c:url value='/reservation/expSearchCalAjax.do'/>"
		, type : "POST"
		, data: param
		, async : false
		, success: function(data, textStatus, jqXHR){
			
			/* 선택된 년, 월의 날짜 데이터 */
			var calList = data.nowMonthCalList;
			
			/* 선택된 년, 월에 예약된 처험 데이터 */
			var expRsvDetailList = data.expReservationInfoDetailList;
			
			var searchMonthRsvCount = data.searchMonthRsvCount;
			
			$("#rsvCalTotalCnt").empty();
			$("#rsvCalTotalCnt").append("<strong>총 "+searchMonthRsvCount.thismonthcnt+" 개</strong>의 체험예약 내역이 있습니다.");
			
			/**선택 년도, 월에 대한 달력 그리기 */
			gridCalendar(calList, expRsvDetailList);
			
			/* 선택 년도, 월에 대한 하단 예약 현황 상세 테이블 그리기 */
// 			rsvExpDetailInfoList(expRsvDetailList);
		
			monthPrePostCntCheck(searchMonthRsvCount);
			
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/**선택 년도, 월에 대한 달력 그리기 */
function gridCalendar(calList, expRsvDetailList){
	//console.log(expRsvDetailList);
	
	
	var yymm = $("#getYear option:selected").val();
	yymm += $("#getMonth option:selected").val()
	
	$("#calTbody").empty();
	
	var calHtml = "";

	for(var i = 0; i < calList.length; i++){
		calHtml += "<tr>"
		calHtml += "	<td class='weekSun'>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekSun+"'>"+calList[i].weekSun.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekMon+"'>"+calList[i].weekMon.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekTue+"'>"+calList[i].weekTue.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekWed+"'>"+calList[i].weekWed.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekThur+"'>"+calList[i].weekThur.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekFri+"'>"+calList[i].weekFri.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "	<td class='weekSat'>"
		calHtml += "		<div onclick='javascript:detailRsvInfo(this)'><em id ='"+yymm+calList[i].weekSat+"'>"+calList[i].weekSat.replace(/(^0+)/, "");+"</em></div>"
		calHtml += "	</td>"
		calHtml += "</tr>"
	}
	$("#calTbody").append(calHtml);
	
	
	/* 날짜 하단에 들어갈 데이터 그리기 */
	calendarSetData(expRsvDetailList);
}

function monthPrePostCntCheck(searchMonthRsvCount){
	
	if(Number(searchMonthRsvCount.postmonthcnt) == 0){
		$(".monthNext").removeClass("on");
	}else if(Number(searchMonthRsvCount.postmonthcnt) != 0){
		$(".monthNext").removeClass("on");
		$(".monthNext").addClass("on");
	}
	
	if(Number(searchMonthRsvCount.premonthcnt) == 0){
		$(".monthPrev").removeClass("on");
	}else if(Number(searchMonthRsvCount.premonthcnt) != 0){
		$(".monthPrev").removeClass("on");
		$(".monthPrev").addClass("on");
	}
}

/* 날짜 하단에 들어갈 데이터 그리기 */
function calendarSetData(expRsvDetailList){
	
	var html = "";
	var typeName = "";
	var tempI = "";
	var yymm = "";
	yymm = $("#getYear").val();
	yymm += $("#getMonth").val();
	
	for(var i = 1; i <= 31; i++){
		if(i < 10){
			tempI = "0"+i;
		}else{
			tempI = i;
		}
		html = "<div class='roomRerv'>"
		for(var j = 0; j < expRsvDetailList.length; j++){
			if($("#"+yymm+tempI).text() == Number(expRsvDetailList[j].reservationday)){
				if(typeName != expRsvDetailList[j].typename
						&& 'P03' != expRsvDetailList[j].paymentstatuscode){
					typeName = expRsvDetailList[j].typename;
					if(expRsvDetailList[j].typename.substr(0, 1) == "체"){
						html += "<span class='calIcon2 blueL'><em>체성분측정</em></span>"
					}else if(expRsvDetailList[j].typename.substr(0, 1) == "피"){
						html += "<span class='calIcon2 greenL'><em>피부측정</em></span>"
					}else if(expRsvDetailList[j].typename.substr(0, 1) == "브"){
						html += "<span class='calIcon2 redL'><em>브랜드체험</em></span>"
					}else{
						html += "<span class='calIcon2 grayL'><em>문화체험</em></span>"
					}
				}
			}
		}
		html += "</div>"
		$("#"+yymm+tempI).parent().append(html);
		typeName = "";
	}
}

/* 선택 년도, 월에 대한 하단 예약 현황 상세 테이블 그리기 */
function rsvExpDetailInfoList(expRsvDetailList){
	
	var expRsvHtml = "";
	
	$("#rsvExpTbody").empty();
	
	
	if(expRsvDetailList.length > 0){
		for(var i = 0; i < expRsvDetailList.length; i++){
			expRsvHtml	+= "<tr>"
			expRsvHtml	+= "	<td>"+expRsvDetailList[i].rsvdate + expRsvDetailList[i].week + '<br/>' + expRsvDetailList[i].sessiontime + "</td>"
			expRsvHtml	+= "	<td>"+expRsvDetailList[i].typename+"</td>"
			expRsvHtml	+= "	<td>"+expRsvDetailList[i].productname+"</td>"
			expRsvHtml	+= "	<td>"+expRsvDetailList[i].ppname+"</td>"
			expRsvHtml	+= "	<td>"+expRsvDetailList[i].partnertype+"</td>"
			expRsvHtml	+= "	<td>"+expRsvDetailList[i].paymentname+"</td>"
			expRsvHtml	+= "</tr>"
		}
	}else{
		expRsvHtml	+= "<tr>"
		expRsvHtml	+= "	<td colspan='6'>예약내역이 없습니다.</td>"
		expRsvHtml	+= "</tr>"
	}
	
	$("#rsvExpTbody").append(expRsvHtml);
}

function setMonth(flag){
	var tempYear;
	var tempMonth;
	var tempDay;
	
	if(flag == "post"){
		if($("#getMonth").val() == "12"){
			tempYear = Number($("#getYear").val())+1;
			tempMonth = "01";
			
			$("#getYear").val(tempYear);
			$("#getMonth").val(tempMonth);
		}else if($("#getMonth").val() != "12"){
			tempYear = $("#getYear").val();
			tempMonth = Number($("#getMonth").val())+1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#getYear").val(tempYear);
				$("#getMonth").val(tempMonth);
			}else if(tempMonth > 10){
				$("#getYear").val(tempYear);
				$("#getMonth").val(tempMonth);
			}
		}
		
		
	}else if(flag == "pre"){
		if($("#getMonth").val() == "01"){
			tempYear = Number($("#getYear").val())-1;
			tempMonth = "12";
			
			$("#getYear").val(tempYear);
			$("#getMonth").val(tempMonth);
		}else if($("#getMonth").val() != "01"){
			tempYear = $("#getYear").val();
			tempMonth = Number($("#getMonth").val())-1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#getYear").val(tempYear);
				$("#getMonth").val(tempMonth);
			}else if(tempMonth > 10){
				$("#getYear").val(tempYear);
				$("#getMonth").val(tempMonth);
			}
		}
	}
	
	$("#getYear").val(tempYear);
	$("#getMonth").val(tempMonth);
	
	$("#rsvExpTbody").empty();
	
	
	tempDay = tempYear + tempMonth;
// 	console.log(tempDay);
	
	if(tempDay == this.today.substr(0,6)){
		searchCal();
		setToday();
	}else{
		searchCal();
		$("#rsvExpTbody").empty();
		
		$("#rsvExpTbody").append("<tr><td colspan='6'>예약내역이 없습니다.</td></tr>");
		
	}
}

function detailRsvInfo(obj){
	var yymm = $("#getYear option:selected").val();
	yymm += $("#getMonth option:selected").val();
	
	var tempDay = ""
	
	if($.trim($(obj).find("em").text()).length == "0" || $(obj).find("em").text() == null || $(obj).find("em").text() == ""){
		return false;
	}else{
		
		$("#calTbody").children().find("td").each(function(){
			
			if($(this).is(".weekSun") === true){
				$(this).removeClass();
				$(this).addClass("weekSun");
				
			}else if($(this).is(".weekSat") === true){
				$(this).removeClass();
				$(this).addClass("weekSat");
			}else{
				$(this).removeClass();
			}
			
		});
		
		$(obj).parent().addClass("on");
		
		tempDay = $(obj).children("em").prop("id");
		tempDay = tempDay.substr(6, 2);
			
	}
		
	rsvExpDetailInfo(tempDay);
}

function rsvExpDetailInfo(tempDay){
	var param;
	
	if(tempDay != "N"){
		param = {
			  getYear : $("#getYear option:selected").val()
			, getMonth : $("#getMonth option:selected").val()
			, getDay : tempDay
			, rsvtypecode : "R02"
		};
	}else{
		param = {
				  getYear : $("#getYear option:selected").val()
				, getMonth : $("#getMonth option:selected").val()
				, rsvtypecode : "R02"
			};
	}
	
	
	
	$.ajax({
		url: "<c:url value="/reservation/rsvExpDetailInfoAjax.do"/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var expRsvInfoList = data.expReservationInfoDetailList;
			
			//하단
			rsvExpDetailInfoList(expRsvInfoList);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}
</script>
</head>
<body>
<form id="expHealthForm" name="expHealthForm" method="post">
<!-- 	<input type="text" id="getYear" name="getYear"> -->
	<input type="hidden" id="getDay" name="getDay" value="${getDay}">
	<div id="pbPopWrap">
		<!-- 20161028 -->
		<header id="pbPopHeader">
			<h1><img src="/_ui/desktop/images/academy/h1_w020500181.gif" alt="체험예약 현황확인"></h1>
		</header>
		<!-- //20161028 -->
		<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
		<section id="pbPopContent" class="pdNone">
				
			<div class="bizroomStateBox">
			
				<!-- 캘린더형 -->
				<div class="viewCalendar">
					<p class="topText" id="rsvCalTotalCnt"></p>
<!-- 					<p class="topText"><strong>총 00 개</strong>의 체험예약 내역이 있습니다.</p> -->
					<div class="calendarWrapper">
						<div class="monthlyNum">
							<strong>
<%-- 								<c:out value="${getDay}"/> --%>
								<select title="년도" class="year" id="getYear" onchange="javascript:searchCal()">
									<c:forEach items="${reservationYearCodeList}" var="item">
										<option value="${item}" ${item == getYear ? "selected" :""}>${item}</option>
									</c:forEach>
								</select>
								<select title="월" class="month" id="getMonth" onchange="javascript:searchCal('C')">
									<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
										<option value="${item}" ${item == getMonth ? "selected" :""}>${item}</option>
									</c:forEach>
								</select>
							</strong>
							<a href="javascript:void(0);" class="monthPrev" onclick="javascript:setMonth('pre')"><span>이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
							<a href="javascript:void(0);" class="monthNext" onclick="javascript:setMonth('post')"><span>다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
						</div>
						
						<table class="tblCalendar">
							<caption>캘린더형 - 체험예약 내역</caption>
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
							<tbody id="calTbody">
								<!-- 날짜 append -->
							</tbody>
						</table>
						
						<div class="tblCalendarBottom">
							<div class="orderState"> 
								<span class="calIcon2 blue"></span>체성분측정
								<span class="calIcon2 green"></span>피부측정
								<span class="calIcon2 red"></span>브랜드체험
								<span class="calIcon2 gray"></span>문화체험
								<!-- @edit 20160701 툴팁 제거 텍스트로 변경 -->
								<span class="fcG">(체험종류 별 예약완료된 아이콘 표시)</span>
							</div>
							<div class="btnR"><a href="javascript:void(0);" class="btnCont" onclick="javascript:rsvExpDetailInfo('N');"><span>월 예약 전체보기</span></a></div>
						</div>
					</div>
					
					<!-- 해당 월 상세 테이블 -->
					<table class="tblList lineLeft tblBizroomState">
						<caption>해당 월 상세 테이블</caption>
						<colgroup>
							<col width="20%" />
							<col width="15%" />
							<col width="auto" />
							<col width="12%" />
							<col width="15%" />
							<col width="12%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">체험일자 </th>
								<th scope="col">체험종류 </th>
								<th scope="col">프로그램</th>
								<th scope="col">지역 </th>
								<th scope="col">비고</th>
								<th scope="col">상태 </th>
							</tr>
						</thead>
						<tbody id="rsvExpTbody">

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
</form>

		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>