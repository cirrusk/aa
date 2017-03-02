<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

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
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	/* move function */
	var $pos = $("#pbContent");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 500);
	
	$(".btnBasicBL").on("click", function(){
		
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
	
	$(".icolist").click(function () {
		setTimeout(function(){ abnkorea_resize(); }, 500);
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
			
			var monthRsvCount = data.monthRsvCount;
			
			/* 캘린더 상단 해당월의 총 예약 건수  */
			$(".topText").empty();
			$(".topText").append("총 <strong>"+monthRsvCount.thismonthcnt+"개</strong>의 시설예약 내역이 있습니다.");
			
			/* 달련 렌더링 */
			calenderRender(calendar, today, reservationInfoList);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 달력 그리기 */
function calenderRender(calendar, today, reservationInfoList){
	
	var html = "";
	
	$(".tblBookCalendar tbody").empty();
	
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
							tempHtml += "	<em class=\"calIcon2 blue\">교육장</em>";
						}else if(reservationInfoList[j].typename.substring(0, 2) == "비즈"){
							tempHtml += "	<em class=\"calIcon2 green\">비즈룸</em>";
						}else if(reservationInfoList[j].typename.substring(0, 2) == "퀸룸"){
							tempHtml += "	<em class=\"calIcon2 red\">퀸룸파티룸</em>";
						}
					}
				}
				
				if(tempHtml != ""){
					html += "<span>"+tempHtml+"</span>";
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
	
	
	$(".tblBookCalendar tbody").append(html);
	
	$("#viewTypeCalendar .stateWrap .tblBizroomState").empty();
	if(selectYmd != ""){
		roomDayReservationListAjax(selectYmd);
	}
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
	
	$(".tblBookCalendar tbody").find("a").each(function () {
		$(this).removeClass("selcOn")
	});
	$(obj).find("a").addClass("selcOn");
	
	$("#popDay").val($(obj).find("a").prop("innerText"));
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
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 예약 현황 특정 년, 월 본인 예약 정보 조회 */
function roomMonthReservationListAjax() {
	
	$(".tblBookCalendar tbody").find("a").each(function () {
		$(this).removeClass("selcOn")
	});
	$("#popDay").val("");
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomMonthReservationListAjax.do'/>"
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
	
	$("#viewTypeCalendar .stateWrap .tblBizroomState").empty();
	
	var html = "";
	
	if(reservationList.length == 0){
		html = "<dt>예약내역이 없습니다.</dt>";
	}else{
		for(var num in reservationList){
			
			var temp = "";
			
			if((reservationList[num].paymentstatuscode == 'P07'
					|| reservationList[num].paymentstatuscode == 'P01'
					|| reservationList[num].paymentstatuscode == 'P02')
					&& reservationList[num].gettoday != reservationList[num].reservationdate){
				temp = "<a href=\"#uiLayerPop_cancel\" class=\"btnTbl\" "
					+ "onclick=\"layerPopupOpen(this);roomInfoRsvCancelData('"
					+ reservationList[num].rsvseq+"', '"
					+reservationList[num].roomseq+"', '"
					+reservationList[num].standbynumber+"', '"
					+reservationList[num].typecode+"', '"
					+reservationList[num].paymentamount+"', '"
					+reservationList[num].reservationdate.substring(0, 4)
					+"-"+reservationList[num].reservationdate.substring(4, 6)
					+"-"+reservationList[num].reservationdate.substring(6, 8)
					+"', '"
					+reservationList[num].purchasedate+"', '"
					+reservationList[num].virtualpurchasenumber+"');return false;\">"
					+ "예약취소</a>";
			}
			
			html += "<dt><span class=\"block\">사용일자</span> "
				 +  reservationList[num].reservationdate.substring(0, 4)
				 +	"-"+reservationList[num].reservationdate.substring(4, 6)
				 +	"-"+reservationList[num].reservationdate.substring(6, 8)
				 +	"("+reservationList[num].weekname
				 +	")"+reservationList[num].sessionname
				 +  "("+reservationList[num].startdatetime.substring(0, 2)
				 +  ":"+reservationList[num].startdatetime.substring(2, 4)
				 +  "~"+reservationList[num].enddatetime.substring(0, 2)
				 +	":"+reservationList[num].enddatetime.substring(2, 4)
				 +	")"+temp
			     +  "<dd><p>"+reservationList[num].typename+" | "
			     +  reservationList[num].ppname+" - "
			     +  reservationList[num].roomname+"</p>"
				 +  "<p>상태 : "+reservationList[num].paymentname+"</p>"
				 +  "</dd>";
		}
	}
	
	$("#viewTypeCalendar .stateWrap .tblBizroomState").append(html);
	
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

//더보기 
function nextPage(){
	
	var urlVal = "/mobile/reservation/roomInfoMoreListAjax.do";
	
	var rowPerPageVal = $("#roomInfoForm > input[name='rowPerPage']").val();
	var totalCountVal = $("#roomInfoForm > input[name='totalCount']").val();
	var firstIndexVal = $("#roomInfoForm > input[name='firstIndex']").val();
	var totalPageVal = $("#roomInfoForm > input[name='totalPage']").val();
	var pageVal = $("#roomInfoForm > input[name='page']").val();
	
	var nextPage = Number(pageVal) + 1;
	$("#roomInfoForm > input[name='page']").val(nextPage);
	if(nextPage >= totalPageVal){ $("#nextPage").hide(); }
	
	var searchRoomType = new Array();
	
// 	$("input[name=expType]:checked").each(function(){
// 		searchRoomType.push($(this).val());
// 	});
	
	$("input[name=roomType]:checked").each(function(){
		searchRoomType.push($(this).val());
	});
	
// 	var params = $("#roomInfoForm").serialize();
	var params = {
		  page : nextPage
		, rowPerPage : rowPerPageVal
		, totalCount : totalCountVal
		, firstIndex : firstIndexVal
		, totalPage : totalPageVal
		, searchStrDateMobile : $("#searchStrDateMobile").val()
		, searchEndDateMobile : $("#searchEndDateMobile").val()
		, searchPpSeq : $("#ppCode option:selected").val()
		, searchRoomType : searchRoomType
	};

	
	$.ajaxCall({
   		url: urlVal
   		, data: params
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){
			
   			$("#rsvInfoTable").append($(data).filter("#rsvInfoTable").html());
//    			$("#articleSection").append($.parseHTML(data)).find("#articleSection");
   			setTimeout(function(){ abnkorea_resize(); }, 500);
   		}
   	});
}

//시설 예약 현황 목록 상세 보기
function roomInfoDetailList(purchasedate, roomseq, virtualpurchasenumber, rsvseq){
	$("input[name = purchasedate]").val(purchasedate);
	$("input[name = roomseq]").val(roomseq);
	$("input[name = virtualpurchasenumber]").val(virtualpurchasenumber);
	$("input[name = rsvseq]").val(rsvseq);
	
	$("#roomInfoForm").attr("action", "${pageContext.request.contextPath}/mobile/reservation/roomInfoDetailList.do");
	$("#roomInfoForm").submit();
}

//검색호출
function doSearch() {
	$("#roomInfoForm").find("input[name=searchStrDateMobile]").remove();
	$("#roomInfoForm").find("input[name=searchEndDateMobile]").remove();
	$("#roomInfoForm").find("input[name=searchPpSeq]").remove();
	$("#roomInfoForm").find("input[name=searchRoomType]").each(function(){
		$(this).remove();
	});
	$("#roomInfoForm").find("input[name=searchStrDateMobile]").remove();
	$("#roomInfoForm").append("<input type='hidden' name='searchStrDateMobile'  value='"+ $("#searchStrDateMobile").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchEndDateMobile'  value='"+ $("#searchEndDateMobile").val() +"'>");
	$("#roomInfoForm").append("<input type='hidden' name='searchPpSeq'  value='"+ $("#ppCode option:selected").val() +"'>");
	
	var cnt = 0;
	$("input[name=roomType]:checked").each(function(){
		$("#roomInfoForm").append("<input type='text' name='searchRoomType' value='"+$(this).val()+"'>");
		cnt++;
	});
	
	if(cnt != 0 || $("#ppCode").val() != "" || $("#ppCode").val() != null){
		$("input[name='page']").val("");
		$("input[name='page']").val("0");
		
		$("input[name='rowPerPage']").val("");
		
		$("input[name='totalCount']").val("");
		$("input[name='totalCount']").val("0");
	}
	
	$("#roomInfoForm").attr("action", "/mobile/reservation/roomInfoList.do");
	$("#roomInfoForm").submit();
}

//페이지 이동
function doPage(page) {
	$("#roomInfoForm > input[name='page']").val(page);  // 
	$("#roomInfoForm").submit();
}

/* 캘린더 취소 팝업 */
function roomInfoRsvCancelData(rsvseq, roomseq, standbynumber, typecode, paymentamount, reservationdate, purchasedate, virtualpurchasenumber){
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	
	$("input[name = roomseq]").val("");
	$("input[name = roomseq]").val(roomseq);
	
	$("input[name = standbynumber]").val("");
	$("input[name = standbynumber]").val(standbynumber);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	var param = {
			  "rsvseq" : rsvseq
			, "roomseq" : roomseq
			, "standbynumber" : standbynumber
			, "typecode" : typecode
	}
	
	/* 해당 패널티 정보 조회 */
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomInfoRsvCancelAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var tempTypeCode = data.roomInfoRsvCancelPenalty.applytypevalue != null ? data.roomInfoRsvCancelPenalty.typecode : 'N';
			$("input[name = typecode]").val(tempTypeCode);
			$("input[name = paymentamount]").val(paymentamount);
			$("input[name = reservationdate]").val(reservationdate);
			$("input[name = purchasedate]").val(purchasedate);
			$("input[name = virtualpurchasenumber]").val(virtualpurchasenumber);

			var applytypevalue = data.roomInfoRsvCancelPenalty.applytypevalue;
			if(!isNull(applytypevalue)) {
				if(typecode == "P"){
					$("#typecodeP").show();
					$("#typecodeF").hide();
					$("#typecodeC").hide();
					$("#penaltyvalue").text(applytypevalue);
				} else if(typecode == "F"){
					$("#typecodeP").hide();
					$("#typecodeF").show();
					$("#typecodeC").hide();
				} else if(typecode == "C"){
					$("#typecodeP").hide();
					$("#typecodeF").hide();
					$("#typecodeC").show();
				} else {
					$("#typecodeP").hide();
					$("#typecodeF").hide();
					$("#typecodeC").hide();
				}
			} else {
				$("#typecodeP").hide();
				$("#typecodeF").hide();
				$("#typecodeC").hide();
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 예약 취소 */
function roomInfoRsvCancel(){
	var param = {
			  "rsvseq" : $("input[name=rsvseq]").val()
			, "roomseq" : $("input[name=roomseq]").val()
			, "standbynumber" : $("input[name=standbynumber]").val()
			, "typecode" : $("input[name=typecode]").val()
			, "paymentamount" : $("input[name=paymentamount]").val()
			, "reservationdate" : $("input[name=reservationdate]").val()
			, "purchasedate" : $("input[name=purchasedate]").val()
			, "virtualpurchasenumber" : $("input[name=virtualpurchasenumber]").val()
			, "interfaceChannel" : $("input[name=interfaceChannel]").val()
	}

	var year = "";
	var month = "";

	if($("input[name=reservationdate]").val() != "") {
		year = $("input[name=reservationdate]").val().substring(0, 4);
		month = $("input[name=reservationdate]").val().substring(5, 7);
	}
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/updateRoomCancelCodeAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			alert("예약이 취소되었습니다.");
			/* 분기태워서 리프레쉬 */
			alert(year+"<,"+month);
			calenderInfoAjax(year, month);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	cancelClosePop();
}

/* 캘린더 예약 취소 리턴 호출 함수 */
function viewTypeCalendar(popYear, popMonth, popDay) {
	$("#popDay").val(popDay);
	$("#year").val(popYear);
	$("#month").val(popMonth);
	
	calenderInfoAjax(popYear, popMonth);
}

/* 레이어 팝업 닫기 */
function cancelClosePop(){
	$("#uiLayerPop_cancel").hide();
// 	 $("#step2Btn").parents("dd").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 시설 <-> 체험 */
function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisUrl}"+newUrl;
}

</script>
<form id="roomInfoForm" name="roomInfoForm" method="post">
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	
	
	<!-- 취소 팝업 에서 사용될 파라미터 -->
	<input type="hidden" name="interfaceChannel" value="WEB" >
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="roomseq">
	<input type="hidden" name="standbynumber">
	<input type="hidden" name="typecode">
	<input type="hidden" name="paymentamount">
	<input type="hidden" name="purchasedate">
	<input type="hidden" name="reservationdate">
	<input type="hidden" name="virtualpurchasenumber">
	
<!-- 취소 팝업(부모창 호출시 필요) 에서 사용될 파라미터 -->
<!-- 	<input type="hidden" name="rsvseq"> -->
	<input type="hidden" id="parentInfo" name="parentInfo" value="">
	<input type="hidden" id="popYear" name="popYear" value="">
	<input type="hidden" id="popMonth" name="popMonth" value="">
	<input type="hidden" id="popDay" name="popDay" value="">
	
</form>
	<!-- container -->
	<div id="pbContainer">
		<!-- content -->
		<section id="pbContent" class="bizroom">
		
			<div class="bizroomSwitchBox">					
				<div class="listType viewTypeSwitch">
					<a href="#viewTypeList" class="icolist on"><span>리스트형 목록보기</span></a>
					<a href="#viewTypeCalendar" class="icoCalendar calendar"><span>캘린더형 목록보기</span></a>
					<span><a href="#" class="btnTbl" onclick="javascript:accessParentPage();">체험예약 현황확인</a></span>
				</div>
				
				<section class="wrapperListType" id="viewTypeList">
					<h2 class="hide">조회결과 - 리스트형</h2>
					
					<div class="topBox">
						<div class="mInputWrapper">
							<div class="inputWrap">
								<strong class="labelBlock">등록일자</strong>
								<div class="textBox">
									<div class="inputNum2">
										<span class="bgNone">
											<input type="date" title="등록일자 시작일" id="searchStrDateMobile" name="searchStrDateMobile" class="inputDate" value="${scrData.searchStrDateMobile}">
										</span>
										<span>
											<input type="date" title="등록일자 종료일" id="searchEndDateMobile" name="searchEndDateMobile" class="inputDate" value="${scrData.searchEndDateMobile}">
										</span>
									</div>
								</div>
							</div>
							<div class="inputWrap">
								<strong class="labelBlock">시설종류</strong>
								<div class="textBox">
									<div class="inputNum2">
										<c:if test="${!empty scrData.searchRoomType}">
											<c:forEach items="${roomRsvTypeInfoCodeList}" var="item">
												<c:set value="0" var="cnt"/>
												<c:forEach items="${scrData.searchRoomType}" var="roomType">
													<c:if test="${roomType eq item.commonCodeSeq}">
														<input type="checkbox" name="roomType" value="${item.commonCodeSeq}" checked="checked"/><label for="room1">${item.codeName}</label>
													</c:if>
													<c:if test="${roomType ne item.commonCodeSeq}">
														<c:set value="${cnt + 1}" var="cnt"/>
													</c:if>
												</c:forEach>
												<c:if test="${cnt eq fn:length(scrData.searchRoomType)}">
													<input type="checkbox" name="roomType" value="${item.commonCodeSeq}"/><label for="room1">${item.codeName}</label>
												</c:if>
											</c:forEach>
										</c:if>
										<c:if test="${empty scrData.searchRoomType}">
											<c:forEach items="${roomRsvTypeInfoCodeList}" var="item">
												<input type="checkbox" name="roomType" value="${item.commonCodeSeq}"/><label for="room1">${item.codeName}</label>
											</c:forEach>
										</c:if>
									</div>
								</div>
							</div>
							<div class="inputWrap nobrd">
								<strong class="labelSizeXS">지역</strong>
								<div class="textBox">
									<select title="지역 선택" id="ppCode" class="sizeM">
										<option value="">전체</option>
										<c:forEach items="${ppCodeList}" var="item">
												<option value="${item.commonCodeSeq}" ${item.commonCodeSeq == scrData.searchPpSeq ? "selected" :""}>${item.codeName}</option>
										</c:forEach>
									</select>
								</div>
							</div>
							<div class="btnWrap">
								<a href="/mobile/reservation/roomInfoList.do" class="btnBasicGL">초기화</a>
								<a href="#none" class="btnBasicBL" onclick="javascript:doSearch();">조회</a>
							</div>							
						</div>
					</div><!-- //.topBox -->
					
					<p class="totalMsg">총 <strong>${scrData.totalCount }개</strong>의 등록내역이 있습니다.</p>
					<div class="stateWrap">
						<!-- @edit 160627 예약내역 없을 때 영역 추가  -->
						<c:if test="${scrData.totalCount eq 0}">
						<p class="noMsg">예약내역이 없습니다.</p>
						</c:if>
						<dl class="tblBizroomState" id="rsvInfoTable">
						<c:forEach items="${roomInfoList}" var="item">
							<dt>등록일자 : ${fn:substring(item.purchasedate,0,4)}-${fn:substring(item.purchasedate,4,6)}-${fn:substring(item.purchasedate,6,8)}
								<em>|</em>${item.roomrsvtotalcounnt}건 예약
								<em>|</em>
								<c:if test="${item.cancelcodecount eq 0}">
									<td>0건 취소</td>
								</c:if>
								<c:if test="${item.cancelcodecount ne 0}">
									<td>${item.cancelcodecount}건 취소</td>
								</c:if>
								<a href="#none" class="btnTbl" onclick="javascript:roomInfoDetailList('${item.purchasedate}', '${item.roomseq}', '${item.virtualpurchasenumber}', '${item.rsvseq}');">상세보기</a>
							</dt>
							<dd>${item.typename}<em>|</em>${item.ppname} - ${item.roomname}</dd>
						</c:forEach>
						</dl>
						<div class="more">
							<c:if test="${scrData.page eq scrData.totalPage}">
							<a href="#none" id="nextPage" style="display: none;" onclick="javascript:nextPage();">20개 <span>더보기</span></a>
							</c:if>
							<c:if test="${scrData.page ne scrData.totalPage}">
							<a href="#none" id="nextPage" style="display: block;" onclick="javascript:nextPage();">20개 <span>더보기</span></a>
							</c:if>
						</div>
					</div>
				</section>
				
				<section class="wrapperCalendarType" id="viewTypeCalendar">
					<h2 class="hide">조회결과- 캘린더형</h2>
					<div class="viewCalendar">
						<p class="topText">총 <strong>00개</strong>의 시설예약 내역이 있습니다.</p>
						<div class="calendarWrapper">
							
							<div class="inputBox monthlyNum">
								<p class="selectBox">
									<select id="year" class="year" title="년도">
										<c:forEach var="item" items="${yearCodeList}">
											<c:if test="${item eq fn:substring(yearMonthDay.ymd, 0, 4)}">
												<option value="${item}" selected="selected">${item}</option>									
											</c:if>
											<c:if test="${item ne fn:substring(yearMonthDay.ymd, 0, 4)}">
												<option value="${item}">${item}</option>									
											</c:if>
										</c:forEach>
									</select>
									<select id="month" class="month" title="월">
										<c:forEach var="item" items="${monthCodeList}">
											<c:if test="${item eq fn:substring(yearMonthDay.ymd, 4, 6)}">
												<option value="${item}" selected="selected">${item}</option>									
											</c:if>
											<c:if test="${item ne fn:substring(yearMonthDay.ymd, 4, 6)}">
												<option value="${item}">${item}</option>									
											</c:if>
										</c:forEach>
									</select>
								</p>
								<a href="#" class="monthPrev" onclick="javascript:setMonth('pre');"><span class="hide">이전달</span></a><!-- 이전목록이 있으면 .on 활성화 -->
								<a href="#" class="monthNext" onclick="javascript:setMonth('post');"><span class="hide">다음달</span></a><!-- 다음 목록이 있으면 .on 활성화 -->
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
					</div>
				
				
					<div class="stateWrap">
						<dl class="tblBizroomState">
						</dl>
					</div>
				</section>
			</div>
			<!-- //시설예약 현황확인 -->
			
			<!-- layer popoup -->
			
			<!-- 예약취소 알림 -->
			<div class="pbLayerPopup" id="uiLayerPop_cancel">
				<div class="pbLayerHeader">
					<strong>예약취소</strong>
				</div>
				<div class="pbLayerContent">
					<!-- 20160714 페널티 수정 -->
					<div class="cancelWrap">
						<p>예약을 취소하시겠습니까?</p>
						<div class="lineBox msgBox" id="typecodeP" style="display:none">
							<p class="textC">취소 시 결제 금액의 <span id="penaltyvalue"></span>%의 취소 수수료 제외후 환불 처리됩니다.</p>
						</div>
						<!-- 무료예약인 경우 -->
						<div class="lineBox msgBox" id="typecodeF" style="display:none">
							<p class="textC">취소 시 패널티가 적용됩니다.</p>
						</div>
						<!-- 요리명장 무료예약인 경우 -->
						<div class="lineBox msgBox" id="typecodeC" style="display:none">
							<p class="textC">취소 시 패널티가 적용됩니다.</p>
						</div>
					</div>
					
					<div class="btnWrap aNumb2">
						<span><a href="#none" class="btnBasicGL" onclick="javascript:cancelClosePop();">취소</a></span>
						<span><a href="#none" class="btnBasicBL" onclick="javascript:roomInfoRsvCancel();">확인</a></span>
					</div>
				</div>
				
				<a href="#none" class="btnPopClose" onclick="javascript:cancelClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //예약취소 알림 -->
			
			<!-- //layer popoup -->

		</section>
		<!-- //content -->
	</div>
	<!-- //container -->
<!-- 	<div class="skipNaviReturn"> -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/mobile/footer.jsp" %>