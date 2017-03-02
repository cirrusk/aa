<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>


<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<style type="text/css">
a.btn_blueWhite {
	display: inline-block;
	height: 28px;
	line-height: 28px;
	background: #FFF;
	padding: 0 15px;
	margin-left: 5px;
	border: 1px solid #cccccc;
	color: #0000FF;
	vertical-align: middle
}
a.btn_blueWhite:hover,a.btn_blueWhite:active{color:#00008B}
</style>
<script type="text/javascript">	

$(document.body).ready(function(){
	
	param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
    
    if(param.menuAuth == "W"){
        $(".authWrite").show();
    }else{
        $(".authWrite").hide();
    }

	/* pp정보 변경 */
	$("#searchPpSeq").change(function () {
		roomTypeListAjax($(this).val());
	});
	$("#searchPpSeq").change();
	
	$("#searchTypeSeq").change(function () {
		roomTypeListAjax($("#searchPpSeq").val());
	});
	
	/* 년도 변경 */
	$("#searchYear").change(function () {
		roomInfoListAjax();
	});

	/* 월 변경 */
	$("#searchMonth").change(function () {
		roomInfoListAjax();
	});
	
	/* 운영자 예약버튼 */
	$("#aRoomOperatorReservation").click(function () {
		roomInfoAdminReservationInsertPop();
	});
	
	/* 운영자 예약 취소 버튼 */
	$("#aRoomOperatorReservationCancel").click(function () {
		roomInfoAdminReservationCancelPop();
	});
	
});

/* 시설 예약현황 운영자 예약 */
function roomInfoAdminReservationInsertPop() {
	
	var cnt = 0;
	$("input[type=checkbox]").each(function () {
		if($(this).prop("checked")){
			cnt++;
		}
	});
	
	if(cnt == 0){
		alert("예약하고자 하는 세션을 선택 후 버튼을 누르시기 바랍니다.");
		return;
	}
	
	var popParam = {
			url : "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationInsertPop.do" />"
			, width : "512"
			, height : "800"
			, params : $("#roomInfoForm").serialize()
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

/* 시설 예약현황 운영자 예약 취소 */
function roomInfoAdminReservationCancelPop() {
	var popParam = {
			url : "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationCancelPop.do" />"
			, width : "1024"
			, height : "512"
			, params : {"ppSeq" : $("#searchPpSeq").val(),
				"roomSeq" : $("#roomSeq").val(),
				"year" : $("#searchYear").val(),
				"month" : $("#searchMonth").val() < 10 ? '0' + $("#searchMonth").val() : $("#searchMonth").val(), 
				"frmId" : $("input[name=frmId]").val()}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

/* 시설 예약현황 */
function roomInfoAdminReservationDetailPop(day) {
	
// 	if(param.menuAuth != "W"){
// 		return;
// 	}

	var popParam = {
			url : "<c:url value="/manager/reservation/roomInfo/roomInfoSessionSelectPop.do" />"
			, width : "1024"
			, height : "512"
			, params : {"ppSeq" : $("#searchPpSeq").val(),
				"roomSeq" : $("#roomSeq").val(),
				"year" : $("#searchYear").val(),
				"month" : $("#searchMonth").val() < 10 ? '0' + $("#searchMonth").val() : $("#searchMonth").val(),
				"day" : day < 10 ? '0' + day : day, 
				"menuAuth" : param.menuAuth,
				"frmId" : $("input[name=frmId]").val()}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

/* 시설 타입 조회 */
function roomTypeListAjax(ppSeq){
	$.ajaxCall({
		url: "<c:url value="/manager/reservation/roomInfo/roomTypeListAjax.do"/>"
		, data: {"ppSeq" : ppSeq
				, "typeSeq" : $("#searchTypeSeq").val()}
		, success: function( data, textStatus, jqXHR){
			if(data.result < 1){
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
       		return;
			} else {
				roomTypeRender(data.roomTypeList);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 시설 타입 버튼 생성 */
function roomTypeRender(roomTypeList){
	
	$("#roomTypeList").empty();
	
	var html = "";
	
// 	var cnt = 0;
// 	var width = 100;
	
// 	for(var num in roomTypeList){
// 		if(roomTypeList[num].roomseq != null){
// 			cnt += 1;
// 		}
// 	}
	
// 	width = Math.floor(width / cnt) - (cnt + 1);
	
	var roomSeq = "";
	for(var num in roomTypeList){
		if(roomTypeList[num].roomseq != null){
			if(num == 0){
				$("#searchYear").val(roomTypeList[num].toyear);
				$("#searchMonth").val(roomTypeList[num].tomonth);
				roomSeq = roomTypeList[num].roomseq;
			}
			var str = "<a href=\"javascript:roomInfoListAjax("+roomTypeList[num].roomseq+");\" id=\""+roomTypeList[num].roomseq+"\" class=\"btn_gray\" "
					+ "style=\"width: 250px; height: 70px; margin-bottom: 5px; text-align: center; vertical-align: middel;\">"
					+ roomTypeList[num].roomname + "</br> (" + roomTypeList[num].typename +")</a>";
			html += str;
		}
	}
	
	$("#roomTypeList").append(html);
	roomInfoListAjax(roomSeq);
}

/* 해당 pp 해당 시설타입 별 예약 현황 조회 */
function roomInfoListAjax(roomSeq){
	
	/*
	  case1 선택된 년이 이번년도보다 작은경우
	  case2 선택된 년이 이번년도와 같고 선택된 월이 이번월도다 작은경우
	*/
	if($("#toYear").val() > $("#searchYear").val()
		|| ($("#toYear").val() == $("#searchYear").val() 
			&& $("#toMonth").val() > $("#searchMonth").val())){
		
		$("#searchYear").val($("#toYear").val());
		$("#searchMonth").val($("#toMonth").val());
		
		alert("과거 예약내역은 예약자관리에서 확인 바랍니다.");
		return;
	}
	
	if(roomSeq != null){
		$("#roomSeq").val(roomSeq);

		/* 해당 룸 버튼 색 변경 */
		$(".btn_blueWhite").each(function () {
			$(this).removeClass("btn_blueWhite");
			$(this).addClass("btn_gray");
		});
		$("#"+roomSeq).removeClass("btn_gray");
		$("#"+roomSeq).addClass("btn_blueWhite");
	}
	
	var reqData = {"ppSeq" : $("#searchPpSeq").val(),
				"roomSeq" : $("#roomSeq").val(),
				"year" : $("#searchYear").val(),
				"month" : $("#searchMonth").val() < 10 ? '0' + $("#searchMonth").val() : $("#searchMonth").val()};
	
	$.ajaxCall({
		url: "<c:url value="/manager/reservation/roomInfo/roomInfoListAjax.do"/>"
		, data: reqData
		, success: function( data, textStatus, jqXHR){
			if(data.result < 1){
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
       		return;
			} else {
				/* 달력 */
				calendar(data.roomInfoCalendar, data.roomInfoList, data.partitionRoomFirstRsvList, data.partitionRoomSecondRsvList);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 달력 */
function calendar(roomInfoCalendar, roomInfoList, partitionRoomFirstRsvList, partitionRoomSecondRsvList) {
	
	$("#calendarDiv").empty();
	
	var html = "<table border=\"1\" style=\"width: 100%;\">"
				+"<tr height=\"20px;\">"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">일</th>"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">월</th>"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">화</th>"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">수</th>"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">목</th>"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">금</th>"
				+"<th style=\"text-align: center; vertical-align: middle; min-width: 80px\">토</th>"
				+"</tr>";
	
	var firstCnt = 0;
	var secondCnt = 0;
	
	for(var num = 0; num < Math.ceil((roomInfoCalendar.length + (roomInfoCalendar[0].weekday - 1))/7); num++){
		html += "<tr height=\"20px;\">";
		for(var i = 0; i < 7; i++){
			if(firstCnt == roomInfoCalendar.length){
				html += "<td style=\"text-align: center; vertical-align: middle;\" rowspan=\"2\"></td>";
				continue;
			}
			if(roomInfoCalendar[firstCnt].weekday == (i+1+(num*7)) || firstCnt > 0){
				html += "<td style=\"text-align: center; vertical-align: middle;\">"
						+ "<a href=\"javascript:roomInfoAdminReservationDetailPop(" + roomInfoCalendar[firstCnt].day + ");\">"
						+ roomInfoCalendar[firstCnt].day
						+ "</a>"
						+ "</td>";
				firstCnt++;
			}else{
				html += "<td style=\"text-align: center; vertical-align: middle;\" rowspan=\"2\"></td>";
			}
		}
		html += "</tr>";
		
		html += "<tr height=\"80px;\">";
		for(var i = 0; i < 7; i++){
			if(secondCnt == roomInfoCalendar.length){
				continue;
			}
			if(roomInfoCalendar[secondCnt].weekday == (i+1+(num*7)) || secondCnt > 0){
				html += "<td style=\"text-align: center; vertical-align: middle;\">";
				
				var checkDate = null;
				var checkWork = null;
				var temp = "";
				for(var j in roomInfoList){
					if(roomInfoCalendar[secondCnt].ymd == roomInfoList[j].ymd
						&& temp == ""){
						temp = roomInfoList[j].temp;
						checkWork = roomInfoList[j].worktypecode;
					}
					if(roomInfoCalendar[secondCnt].ymd == roomInfoList[j].ymd
							&& null != roomInfoList[j].sessiontime
							&& temp == roomInfoList[j].temp){
						if(roomInfoList[j].settypecode == 'S02'
							&& checkWork == roomInfoList[j].worktypecode){
							checkDate = roomInfoList[j].ymd;
							if(roomInfoList[j].worktypecode == 'S02'){
								html += "<div style=\"color:gray;\">"
										+ "휴   무"
										+ "</div>";
							}else if(roomInfoList[j].worktypecode == 'S01'){
								var str = "";
								if((roomInfoList[j].adminfirstcode == "R01"
									&& (partitionRoomFirstRsvList == null 
										|| partitionRoomFirstRsvList.length == 0))
								|| ((partitionRoomSecondRsvList == null 
										|| partitionRoomSecondRsvList.length == 0)
									&& partitionRoomFirstRsvList != null 
									&& partitionRoomFirstRsvList.length != 0
									&& (roomInfoList[j].adminfirstcode == "R01" 
										|| partitionRoomFirstRsvList[j].adminfirstcode == "R01"))
								|| (partitionRoomSecondRsvList != null 
									&& partitionRoomSecondRsvList.length != 0
									&& (roomInfoList[j].adminfirstcode == "R01" 
										|| partitionRoomFirstRsvList[j].adminfirstcode == "R01"
										|| partitionRoomSecondRsvList[j].adminfirstcode == "R01"))){
									str = "<div style=\"color:gray;\">" 
										+ roomInfoList[j].sessiontime 
										+ " (A)";
								}else if((roomInfoList[j].adminfirstcode == "R02"
									&& (partitionRoomFirstRsvList == null 
											|| partitionRoomFirstRsvList.length == 0))
									|| ((partitionRoomSecondRsvList == null 
											|| partitionRoomSecondRsvList.length == 0)
										&& partitionRoomFirstRsvList != null 
										&& partitionRoomFirstRsvList.length != 0
										&& (roomInfoList[j].adminfirstcode == "R02" 
											|| partitionRoomFirstRsvList[j].adminfirstcode == "R02"))
									|| (partitionRoomSecondRsvList != null 
										&& partitionRoomSecondRsvList.length != 0
										&& (roomInfoList[j].adminfirstcode == "R02" 
											|| partitionRoomFirstRsvList[j].adminfirstcode == "R02"
											|| partitionRoomSecondRsvList[j].adminfirstcode == "R02"))){
									if(roomInfoList[j].standbynumber == 1){
										str = "<div style=\"color:gray;\">"
											+ roomInfoList[j].sessiontime
											+ " (W)";
									}else{
										str = "<div style=\"color:gray;\">"
											+ roomInfoList[j].sessiontime;
									}
								}else{
									str = "<div style=\"color:black;\">" + roomInfoList[j].sessiontime;
									
									if(param.menuAuth == "W"){
										str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" />";
									}else{
										str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" disabled />";
									}
								}
								
								html +=  str
										+ "<input type=\"hidden\" name=\"tempSessionDateTime\" value=\"" + roomInfoList[j].ymd + "\"/>"
										+ "<input type=\"hidden\" name=\"tempPpSeq\" value=\"" + roomInfoList[j].ppseq + "\"/>"
										+ "<input type=\"hidden\" name=\"tempRoomSeq\" value=\"" + roomInfoList[j].roomseq + "\"/>"
										+ "<input type=\"hidden\" name=\"tempRsvSessionSeq\" value=\"" + roomInfoList[j].rsvsessionseq + "\"/>"
										+ "<input type=\"hidden\" name=\"sessionCheck\" value=\"false\"/>"
										+ "</div>"
										+ "<br/>";
							}
						}else if(roomInfoList[j].ymd != checkDate){
							var str = "";
							if((roomInfoList[j].adminfirstcode == "R01"
									&& (partitionRoomFirstRsvList == null 
										|| partitionRoomFirstRsvList.length == 0))
								|| ((partitionRoomSecondRsvList == null 
										|| partitionRoomSecondRsvList.length == 0)
									&& partitionRoomFirstRsvList != null 
									&& partitionRoomFirstRsvList.length != 0
									&& (roomInfoList[j].adminfirstcode == "R01" 
										|| partitionRoomFirstRsvList[j].adminfirstcode == "R01"))
								|| (partitionRoomSecondRsvList != null 
									&& partitionRoomSecondRsvList.length != 0
									&& (roomInfoList[j].adminfirstcode == "R01" 
										|| partitionRoomFirstRsvList[j].adminfirstcode == "R01"
										|| partitionRoomSecondRsvList[j].adminfirstcode == "R01"))){
								str = "<div style=\"color:gray;\">" + roomInfoList[j].sessiontime 
									+ " (A)";
							}else if((roomInfoList[j].adminfirstcode == "R02"
									&& (partitionRoomFirstRsvList == null 
										|| partitionRoomFirstRsvList.length == 0))
								|| ((partitionRoomSecondRsvList == null 
										|| partitionRoomSecondRsvList.length == 0)
									&& partitionRoomFirstRsvList != null 
									&& partitionRoomFirstRsvList.length != 0
									&& (roomInfoList[j].adminfirstcode == "R02" 
										|| partitionRoomFirstRsvList[j].adminfirstcode == "R02"))
								|| (partitionRoomSecondRsvList != null 
									&& partitionRoomSecondRsvList.length != 0
									&& (roomInfoList[j].adminfirstcode == "R02" 
										|| partitionRoomFirstRsvList[j].adminfirstcode == "R02"
										|| partitionRoomSecondRsvList[j].adminfirstcode == "R02"))){
								if(roomInfoList[j].standbynumber == 1){
									str = "<div style=\"color:gray;\">"
										+ roomInfoList[j].sessiontime
										+ " (W)";
								}else{
									str = "<div style=\"color:gray;\">"
										+ roomInfoList[j].sessiontime;
								}
							}else{
								str = "<div style=\"color:black;\">" + roomInfoList[j].sessiontime
								
								if(param.menuAuth == "W") {
									str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" />";
								} else {
									str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" disabled />";
								}
									
							}
							
							html += str
									+ "<input type=\"hidden\" name=\"tempSessionDateTime\" value=\"" + roomInfoList[j].ymd + "\"/>"
									+ "<input type=\"hidden\" name=\"tempPpSeq\" value=\"" + roomInfoList[j].ppseq + "\"/>"
									+ "<input type=\"hidden\" name=\"tempRoomSeq\" value=\"" + roomInfoList[j].roomseq + "\"/>"
									+ "<input type=\"hidden\" name=\"tempRsvSessionSeq\" value=\"" + roomInfoList[j].rsvsessionseq + "\"/>"
									+ "<input type=\"hidden\" name=\"sessionCheck\" value=\"false\"/>"
									+ "</div>"
									+ "<br/>";
						}
					}
				}
				html += "</td>";
				secondCnt++;
			}
		}
		html += "</tr>";
	}
	
	html += "</table>";
	
	$("#calendarDiv").append(html);
	
// 	myIframeResizeHeight("${param.frmId}");
// 	$("#pbContent").height()
// 	alert($("#roomTypeList").parents(".contents_title").height() + 50);
	$("#ifrm_main_${param.frmId}", parent.document).height($("#calendarDiv").parents(".contents_title").height() + 300);
	
}

/* 이전달 해당 pp 해당 시설타입 별 예약 현황 조회 */
function prevMonth() {
	if($("#searchMonth").val() == "1" 
			&& $("#searchYear").val() != $("#searchYear option:first").val()){
		$("#searchYear").val($("#searchYear").val() - 1);
		$("#searchMonth").val("12");
	}else if($("#searchMonth").val() != "1"){
		$("#searchMonth").val($("#searchMonth").val() - 1);
	}
	roomInfoListAjax();
}

/* 다음달 해당 pp 해당 시설타입 별 예약 현황 조회 */
function nextMonth() {
	if($("#searchMonth").val() == "12" 
			&& $("#searchYear").val() != $("#searchYear option:last").val()){
		$("#searchYear").val(parseInt($("#searchYear").val()) + 1);
		$("#searchMonth").val("1");
	}else if($("#searchMonth").val() != "12"){
		$("#searchMonth").val(parseInt($("#searchMonth").val()) + 1);
	}
	roomInfoListAjax();
}

/* 세션 체크박스 클릭 */
function sessionCheckBox(check) {
	$(check).parent("div").children("input[name=sessionCheck]").val($(check).prop("checked"));
}
</script>
</head>

<body class="bgw" id="pbContent">
	<input type="hidden" id="roomSeq" name="roomSeq"/>
	<input type="hidden" id="toYear" value="${reservationToday.year}"/>
	<input type="hidden" id="toMonth" value="${reservationToday.month}"/>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">시설 예약 현황</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*"  />
				<col width="10%"  />
				<col width="*"  />
			</colgroup>
			<tr>
				<th>PP 선택</th>
				<td scope="row">
					<select id="searchPpSeq" name="searchPpSeq" style="width:auto; min-width:100px;" >
						<c:forEach var="item" items="${ppCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				<th>시설 타입</th>
				<td scope="row">
					<select id="searchTypeSeq" name="searchTypeSeq" style="width:auto; min-width:100px;" >
						<option value="">전체</option>
						<c:forEach var="item" items="${roomTypeCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</div>

	<div class="contents_title clear">
		<br/>
		<div id="roomTypeList">
		</div>
		<br/>
		<div class="fl">
			<a href="javascript:;" id="aRoomOperatorReservation" class="btn_green authWrite">운영자예약</a>
			<a href="javascript:;" id="aRoomOperatorReservationCancel" class="btn_green authWrite">운영자예약취소</a>
		</div>
	
		<div style="text-align: center;">
			<a href="javascript:prevMonth();" id="prevMonth">&lt;</a>&nbsp; &nbsp; &nbsp; &nbsp;
			<select id="searchYear">
				<c:forEach var="item" items="${reservationYearCodeList}">
					<option value="${item}">${item}</option>
				</c:forEach>
			</select>
			<c:out value="년"/>&nbsp; &nbsp; &nbsp; &nbsp;
			<select id="searchMonth">
				<c:forEach var="item" items="${reservationMonthCodeList}">
					<option value="${item}">${item}</option>
				</c:forEach>
			</select>
			<c:out value="월"/>&nbsp; &nbsp; &nbsp; &nbsp;
			<a href="javascript:nextMonth();" id="nextMonth">&gt;</a>
		</div>
		<div class="fl"></div>
		<br/>
		<form id="roomInfoForm" name="roomInfoForm" method="POST">
		<input type="hidden" name="frmId" value="${param.frmId}" />
			<div id="calendarDiv">
			</div> 
		</form>
		<br/>
		<div class="fr">
			<c:out value="(A)는 운영자가 우선 예약한 것을 말합니다. (W)는 예약대기자가 존재함을 말합니다"/>
		</div>
	</div>
</body>