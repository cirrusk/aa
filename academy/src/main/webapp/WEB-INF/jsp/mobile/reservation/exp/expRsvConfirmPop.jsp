<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
var today;

function setToday(){
	var yymm = $("#getYearLayer option:selected").val();
	yymm += $("#getMonthLayer option:selected").val();
	yymm += $("#getDayPop").val();
	
	var tempDay = $("#getDayPop").val();
	
	this.today = yymm;
	
	$("#temp").children().find("td").each(function(){
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
	
	$("#L"+yymm).addClass("selcOn");
	
	rsvExpDetailInfoLayer(tempDay);
}

/* 선택된 년, 월 기준으로  캘린더, 예약 현황 상세 테이블 데이터 조회 */
function searchCalLayer(){
	var param = {
		  getYear : $("#getYearLayer option:selected").val()
		, getMonth : $("#getMonthLayer option:selected").val()
		, rsvtypecode : "R02"
	};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/expSearchCalAjax.do'/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			/* 선택된 년, 월의 날짜 데이터 */
			var calList = data.nowMonthCalList;
			
			/* 선택된 년, 월에 예약된 처험 데이터 */
			var expRsvDetailList = data.expReservationInfoDetailList;
			
			var searchMonthRsvCount = data.searchMonthRsvCount;
			
// 			console.log(searchMonthRsvCount.thismonthcnt);
			
			$("#rsvCalTotalCnt").empty();
			$("#rsvCalTotalCnt").append("<strong>총"+searchMonthRsvCount.thismonthcnt+" 개</strong>의 체험예약 내역이 있습니다.");
			
			/**선택 년도, 월에 대한 달력 그리기 */
			gridCalendarLayer(calList, expRsvDetailList);
			
			/* 선택 년도, 월에 대한 하단 예약 현황 상세 테이블 그리기 */
// 			rsvExpDetailInfoList(expRsvDetailList);
		
			monthPrePostCntCheckLayer(searchMonthRsvCount);
			
// 			setTimeout(function(){ abnkorea_resize(); }, 500);
			abnkoreaConfirmPop_resize();
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}

function gridCalendarLayer(calList, expRsvDetailList){
	var yymm = $("#getYearLayer option:selected").val();
	yymm += $("#getMonthLayer option:selected").val()
	
	$("#calTbodyLayer").empty();
	
	var calHtml = "";
	
	for(var i = 0; i < calList.length; i++){
		calHtml += "<tr>"
		calHtml += "	<td class='weekSun'>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekSun+"'>"+calList[i].weekSun.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekMon+"'>"+calList[i].weekMon.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekTue+"'>"+calList[i].weekTue.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekWed+"'>"+calList[i].weekWed.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekThur+"'>"+calList[i].weekThur.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "	<td>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekFri+"'>"+calList[i].weekFri.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "	<td class='weekSat'>"
		calHtml += "		<a href='#none' onclick='javascript:detailRsvInfoLayer(this)' id ='L"+yymm+calList[i].weekSat+"'>"+calList[i].weekSat.replace(/(^0+)/, "");+"</a>"
		calHtml += "	</td>"
		calHtml += "</tr>"
	}
	
	$("#calTbodyLayer").append(calHtml);
	
	/* 날짜 하단에 들어갈 데이터 그리기 */
	calendarSetDataLayer(expRsvDetailList);
}

function monthPrePostCntCheckLayer(searchMonthRsvCount){
	

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



function calendarSetDataLayer(expRsvDetailList){
	
	var yymm = $("#getYearLayer").val();
	yymm += $("#getMonthLayer").val();
	
	var html = "";
	var tempI = "";
	var typeName = "";
	
	for(var i = 1; i <= 31; i++){
		
		if(i < 10){
			tempI = "0"+i;
		}else{
			tempI = i;
		}
		
		html = "<span>";
		for(var j = 0; j < expRsvDetailList.length; j++){
			if($("#L"+yymm+tempI).text() == Number(expRsvDetailList[j].reservationday)){
				if(typeName != expRsvDetailList[j].typename
						&& 'P03' != expRsvDetailList[j].paymentstatuscode){
					
					typeName = expRsvDetailList[j].typename;
					
					if(expRsvDetailList[j].typename.substr(0, 1) == "체"){
						html += "<em class='calIcon2 blue'>체성분측정</em>";
					}else if(expRsvDetailList[j].typename.substr(0, 1) == "피"){
						html += "<em class='calIcon2 green'>피부측정</em>";
					}else if(expRsvDetailList[j].typename.substr(0, 1) == "브"){
						html += "<em class='calIcon2 gray'>브랜드체험</em>";
					}else{
						html += "<em class='calIcon2 red'>문화체험</em>";
					}
				}
			}
// 			$("#L"+expRsvDetailList[j].reservationdate).append(html);
		}
		html += "</span>"
		$("#L"+yymm+tempI).append(html);
		typeName = "";
	}
}

function setMonthLayer(flag){
	
	var tempYear;
	var tempMonth;
	var tempDay;
	
	if(flag == "post"){
		if($("#getMonthLayer").val() == "12"){
			tempYear = Number($("#getYearLayer").val())+1;
			tempMonth = "01";
			
			$("#getYearLayer").val(tempYear);
			$("#getMonthLayer").val(tempMonth);
		}else if($("#getMonthLayer").val() != "12"){
			tempYear = $("#getYearLayer").val();
			tempMonth = Number($("#getMonthLayer").val())+1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#getYearLayer").val(tempYear);
				$("#getMonthLayer").val(tempMonth);
			}else if(tempMonth > 10){
				$("#getYearLayer").val(tempYear);
				$("#getMonthLayer").val(tempMonth);
			}
		}
		
		
	}else if(flag == "pre"){
		if($("#getMonthLayer").val() == "01"){
			tempYear = Number($("#getYearLayer").val())-1;
			tempMonth = "12";
			
			$("#getYearLayer").val(tempYear);
			$("#getMonthLayer").val(tempMonth);
		}else if($("#getMonthLayer").val() != "01"){
			tempYear = $("#getYearLayer").val();
			tempMonth = Number($("#getMonthLayer").val())-1;
			
			if(tempMonth < 10){
				tempMonth = "0"+tempMonth;
				$("#getYearLayer").val(tempYear);
				$("#getMonthLayer").val(tempMonth);
			}else if(tempMonth > 10){
				$("#getYearLayer").val(tempYear);
				$("#getMonthLayer").val(tempMonth);
			}
		}
	}
	
	$("#getYearLayer").val(tempYear);
	$("#getMonthLayer").val(tempMonth);
	
	$("#temp").empty();
	
	tempDay = tempYear + tempMonth;
	
	if(tempDay == this.today.substr(0,6)){
		searchCalLayer();
		setToday();
	}else{
		searchCalLayer();
	}
}

function detailRsvInfoLayer(obj){
	
	var yymm = $("#getYearLayer option:selected").val();
	yymm += $("#getMonthLayer option:selected").val();
	
	var tempDay = ""
	
	
	if($.trim($(obj).text()).length == "0" || $(obj).text() == null || $(obj).text() == ""){
		return false;
	}else{
		
		$("#calTbodyLayer").children().find("td").each(function(){
			
			$(this).children().removeClass("selcOn");
			
		});
		
		$(obj).addClass("selcOn");	
		
		tempDay = $(obj).prop("id");
		tempDay = tempDay.substr(7, 2);
		
	}
		
	rsvExpDetailInfoLayer(tempDay);
}

function rsvExpDetailInfoLayer(tempDay){
	var param;
	
	if(tempDay != "N"){
		param = {
			  getYear : $("#getYearLayer option:selected").val()
			, getMonth : $("#getMonthLayer option:selected").val()
			, getDay : tempDay
			, rsvtypecode : "R02"
		};
	}else{
		param = {
			  getYear : $("#getYearLayer option:selected").val()
			, getMonth : $("#getMonthLayer option:selected").val()
			, rsvtypecode : "R02"
		};
	}
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/rsvExpDetailInfoAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var expRsvInfoList = data.expReservationInfoDetailList;
			
			//하단
			rsvExpDetailInfoListLayer(expRsvInfoList);
			
// 			setTimeout(function(){ abnkorea_resize(); }, 500);
			abnkoreaConfirmPop_resize();
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}

function rsvExpDetailInfoListLayer(expRsvInfoList){
	
	var expRsvHtml = "";
	
// 	$(".calendarWrapper").next().empty();
	$("#temp").empty();
	
	if(expRsvInfoList.length > 0){
		for(var i = 0; i < expRsvInfoList.length; i++){
			expRsvHtml	+= "<dl class='tblBizroomState'>"
			expRsvHtml	+= "	<dt>체험일자<br>"+expRsvInfoList[i].rsvdate + expRsvInfoList[i].week + expRsvInfoList[i].sessiontime + "</dt>"
			expRsvHtml	+= "	<dd>"+expRsvInfoList[i].typename+"<em>|</em>"+expRsvInfoList[i].productname+"<em>|</em>"+expRsvInfoList[i].ppname+"<em>|</em>"+expRsvInfoList[i].partnertype+"<br>"
// 			expRsvHtml	+= "	상태 : "+expRsvInfoList[i].rsvcancel+"</dd>"
			expRsvHtml	+= "	상태 : "+expRsvInfoList[i].paymentname+"</dd>"
			expRsvHtml	+= "</dl>"
		}
	}else{
		expRsvHtml = "<p class='noMsg'>예약내역이 없습니다.<!-- 조회결과가 없습니다. --></p>";
	}

	
	$("#temp").append(expRsvHtml);
}

function closeRsvConfirmLayer(){
	$("#uiLayerPop_calender2").hide();
	$("#layerMask").remove();
}
</script>
<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_calender2" tabindex="0" style="display: block; top: 0px;">
	<div class="pbLayerHeader">
		<strong>체험예약 현황확인</strong>
	</div>
	<div class="pbLayerContent" style="height: 816px; overflow: auto;">
	
		<!-- 캘린더형 -->
		<div class="viewCalendar">
			<p class="topText" id="rsvCalTotalCnt"></p>
<!-- 			<p class="topText"><strong>총 00 개</strong>의 체험예약 내역이 있습니다.</p> -->
			<div class="calendarWrapper">
				
				<div class="inputBox monthlyNum">
					<p class="selectBox">
						<select title="년도" class="year" id="getYearLayer" onchange="javascript:searchCalLayer()">
							<c:forEach items="${reservationYearCodeList}" var="item">
								<option value="${item}">${item}</option>
							</c:forEach>
						</select>
						
						<select title="월" class="month" id="getMonthLayer" onchange="javascript:searchCalLayer();">
							<c:forEach items="${reservationFormatingMonthCodeList}" var="item">
								<option value="${item}">${item}</option>
							</c:forEach>
						</select>
					</p>
					<a href="#" class="monthPrev" onclick="javascript:setMonthLayer('pre');"><span class="hide">이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
					<a href="#" class="monthNext" onclick="javascript:setMonthLayer('post');"><span class="hide">다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
				</div>
				
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
					<tbody id="calTbodyLayer">
						
					</tbody>
				</table>
				
				<div class="tblCalendarBottom">
					<div class="resrState"> 
						<p>
							<span class="calIcon2 blue"></span>체성분측정
							<span class="calIcon2 green"></span>피부측정
							<span class="calIcon2 gray"></span>브랜드체험
							<span class="calIcon2 red"></span>문화체험
						</p>
					</div>
					<div class="btnR"> <a href="#none" class="btnTbl" onclick="javascript:rsvExpDetailInfoLayer('N');">월 예약 전체보기</a></div>
				</div>
			</div>
			<div id="temp"></div>
			<!--  -->
		</div>
		
		<!-- //캘린더형 -->
		
		<div class="btnWrap bNumb1">
			<a href="#" class="btnBasicGL" onclick="javascript:closeRsvConfirmLayer()">닫기</a>
		</div>
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>