<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>


<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">	

$(document.body).ready(function(){
	
	param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
    
    if(param.menuAuth == "W"){
        $(".authWrite").show();
    }else{
        $(".authWrite").hide();
    }
	
	/* 해당 pp 체험/측정 타입 정보 조회 */
// 	expTypeListAjax($("#searchPpSeq").val());
	
	/* pp정보 변경 */
	$("#searchPpSeq").change(function () {
		expProgramListAjax($(this).val());
	});
	$("#searchPpSeq").change();
	
	$("#searchTypeSeq").change(function () {
		expProgramListAjax($("#searchPpSeq").val());
	});
	
	$("#searchExpSeq").change(function () {
		expInfoListAjax();
	});
	
	/* 년도 변경 */
	$("#searchYear").change(function () {
		expInfoListAjax();
	});

	/* 월 변경 */
	$("#searchMonth").change(function () {
		expInfoListAjax();
	});
	
	/* 운영자 예약버튼 */
	$("#aExpOperatorReservation").click(function () {
		expInfoAdminReservationInsertPop();
	});
	
	/* 운영자 예약 취소 버튼 */
	$("#aExpOperatorReservationCancel").click(function () {
		expInfoAdminReservationCancelPop();
	});
	
});

/* 시설 예약현황 운영자 예약 */
function expInfoAdminReservationInsertPop() {
	
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
			url : "<c:url value="/manager/reservation/expInfo/expInfoAdminReservationInsertPop.do" />"
			, width : "512"
			, height : "800"
			, params : $("#expInfoForm").serialize()
			, targetId : "searchPopup"
	}
	
	window.parent.openManageLayerPopup(popParam);
}

/* 시설 예약현황 운영자 예약 취소 */
function expInfoAdminReservationCancelPop() {
	var popParam = {
			url : "<c:url value="/manager/reservation/expInfo/expInfoAdminReservationCancelPop.do"/>"
			, width : "1024"
			, height : "512"
			, params : {"ppSeq" : $("#searchPpSeq").val(),
				"expSeq" : $("#searchExpSeq").val(),
				"year" : $("#searchYear").val(),
				"month" : $("#searchMonth").val() < 10 ? '0' + $("#searchMonth").val() : $("#searchMonth").val(),
				"frmId" : $("input[name=frmId]").val()}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

/* 시설 예약현황 */
function expInfoAdminReservationDetailPop(day) {
	
// 	if(param.menuAuth != "W"){
// 		return;
// 	}

	var popParam = {
			url : "<c:url value="/manager/reservation/expInfo/expInfoSessionSelectPop.do" />"
			, width : "1024"
			, height : "512"
			, params : {"ppSeq" : $("#searchPpSeq").val(),
				"expSeq" : $("#searchExpSeq").val(),
				"year" : $("#searchYear").val(),
				"month" : $("#searchMonth").val() < 10 ? '0' + $("#searchMonth").val() : $("#searchMonth").val(),
				"day" : day < 10 ? '0' + day : day,
				"menuAuth" : param.menuAuth,
				"frmId" : $("input[name=frmId]").val()}
			, targetId : "searchPopup"
	}
	
	console.log(popParam);
	
	window.parent.openManageLayerPopup(popParam);
}

/* 체험/측정 타입 목록 조회 */
// function expTypeListAjax(ppSeq) {
// 	$.ajaxCall({
// 		url: "<c:url value="/manager/reservation/expInfo/expTypeListAjax.do"/>"
// 		, data: {"ppSeq" : ppSeq
// 				, "typeSeq" : $("#searchTypeSeq").val()}
// 		, success: function( data, textStatus, jqXHR){
// 			if(data.result < 1){
//        			alert("처리도중 오류가 발생하였습니다.");
//        		return;
// 			} else {
// 				expProgramListAjax(ppSeq);
// 				expTypeRender(data.expTypeList);
// 			}
// 		},
// 		error: function( jqXHR, textStatus, errorThrown) {
//        		alert("처리도중 오류가 발생하였습니다.");
// 		}
// 	});
// }

/* 체험/측정 타이보 목록 생성 */
// function expTypeRender(expTypeList) {
// 	$("#searchTypeSeq").empty();
	
// 	var html = "";
	
// 	for(var num in expTypeList){
// 		if(expTypeList[num].typeseq != null){
// 			html += "<option value=\"" + expTypeList[num].typeseq + "\">" + expTypeList[num].typename + "</option>"
// 		}
// 	}
// 	$("#searchTypeSeq").append(html);
	
// 	expProgramListAjax($("#searchTypeSeq").val());
// }

/* 프로그램 목록 조회 */
function expProgramListAjax(ppSeq){
	$.ajaxCall({
		url: "<c:url value="/manager/reservation/expInfo/expProgramListAjax.do"/>"
		, data: {"ppSeq" : ppSeq
				, "typeSeq" : $("#searchTypeSeq").val()}
		, success: function( data, textStatus, jqXHR){
			if(data.result < 1){
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
       		return;
			} else {
				expProgramRender(data.expProgramList);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 측정/체험 타입 목록 생성 */
function expProgramRender(expProgramList){
	
	$("#searchExpSeq").empty();
	
	var html = "";
	
	var expSeq = "";
	for(var num in expProgramList){
		if(expProgramList[num].expseq != null){
			if(num == 0){
				$("#searchYear").val(expProgramList[num].toyear);
				$("#searchMonth").val(expProgramList[num].tomonth);
			}
			html += "<option value=\"" + expProgramList[num].expseq + "\">" + expProgramList[num].productname + "</option>"
		}
	}
	$("#searchExpSeq").append(html);
	
	expInfoListAjax();
}

/* 해당 pp 해당 프로그램 별 예약 현황 조회 */
function expInfoListAjax(){
	
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
	
	var reqData = {"ppSeq" : $("#searchPpSeq").val(),
				"expSeq" : $("#searchExpSeq").val(),
				"year" : $("#searchYear").val(),
				"month" : $("#searchMonth").val() < 10 ? '0' + $("#searchMonth").val() : $("#searchMonth").val()};
	
	$.ajaxCall({
		url: "<c:url value="/manager/reservation/expInfo/expInfoListAjax.do"/>"
		, data: reqData
		, success: function( data, textStatus, jqXHR){
			if(data.result < 1){
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
       		return;
			} else {
				calendar(data.expInfoCalendar, data.expInfoList);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 달력 */
function calendar(expInfoCalendar, expInfoList) {
	
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
	for(var num = 0; num < Math.ceil((expInfoCalendar.length + (expInfoCalendar[0].weekday - 1))/7); num++){
		html += "<tr height=\"20px;\">";
		for(var i = 0; i < 7; i++){
			if(firstCnt == expInfoCalendar.length){
				html += "<td style=\"text-align: center; vertical-align: middle;\" rowspan=\"2\"></td>";
				continue;
			}
			if(expInfoCalendar[firstCnt].weekday == (i+1+(num*7)) || firstCnt > 0){
				html += "<td style=\"text-align: center; vertical-align: middle;\">"
						+ "<a href=\"javascript:expInfoAdminReservationDetailPop(" + expInfoCalendar[firstCnt].day + ");\">"
						+ expInfoCalendar[firstCnt].day
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
			if(secondCnt == expInfoCalendar.length){
				continue;
			}
			if(expInfoCalendar[secondCnt].weekday == (i+1+(num*7)) || secondCnt > 0){
				html += "<td style=\"text-align: center; vertical-align: middle;\">";
				
				var checkDate = null;
				var checkWork = null;
				var setWeek = 0;
				var weekCnt = 0;
				for(var j in expInfoList){
					if(expInfoCalendar[secondCnt].ymd == expInfoList[j].ymd
							&& null != expInfoList[j].sessiontime){
						if(0 == weekCnt){
							setWeek = expInfoList[j].setweek;
							checkWork = expInfoList[j].worktypecode;
							weekCnt++;
						}
						if(expInfoList[j].settypecode == 'S02' 
							&& checkWork == expInfoList[j].worktypecode
							&& setWeek == expInfoList[j].setweek){
							checkDate = expInfoList[j].ymd;
							if(expInfoList[j].worktypecode == 'S02'){
								html += "<div style=\"color:gray;\">"
										+ "휴   무"
										+ "</div>";
							}else if(expInfoList[j].worktypecode == 'S01'){
								var str = "";
								if(expInfoList[j].adminfirstcode == "R01"){
									str = "<div style=\"color:gray;\">"
										+ expInfoList[j].sessiontime
										+ " (A)";
								}else if(expInfoList[j].adminfirstcode == "R02"){
									if(expInfoList[j].standbynumber == 1){
										str = "<div style=\"color:gray;\">"
											+ expInfoList[j].sessiontime
											+ " (W)";
									}else{
										str = "<div style=\"color:gray;\">"
											+ expInfoList[j].sessiontime;
									}
								}else{
									str = "<div style=\"color:black;\">" + expInfoList[j].sessiontime;
									
									if(param.menuAuth == "W"){
										str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" />";
									} else {
										str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" disabled />";
									}
								}
								
								html += str
										+ "<input type=\"hidden\" name=\"tempSessionDateTime\" value=\"" + expInfoList[j].ymd + "\"/>"
										+ "<input type=\"hidden\" name=\"tempPpSeq\" value=\"" + expInfoList[j].ppseq + "\"/>"
										+ "<input type=\"hidden\" name=\"tempExpSeq\" value=\"" + expInfoList[j].expseq + "\"/>"
										+ "<input type=\"hidden\" name=\"tempExpSessionSeq\" value=\"" + expInfoList[j].expsessionseq + "\"/>"
										+ "<input type=\"hidden\" name=\"sessionCheck\" value=\"false\"/>"
										+ "</div>"
										+ "<br/>";
							}
						}else if(expInfoList[j].ymd != checkDate && setWeek == expInfoList[j].setweek){
							var str = "";
							if(expInfoList[j].adminfirstcode == "R01"){
								str = "<div style=\"color:gray;\">"
									+ expInfoList[j].sessiontime
									+ " (A)";
							}else if(expInfoList[j].adminfirstcode == "R02"){
								if(expInfoList[j].standbynumber == 1){
									str = "<div style=\"color:gray;\">"
										+ expInfoList[j].sessiontime
										+ " (W)";
								}else{
									str = "<div style=\"color:gray;\">"
										+ expInfoList[j].sessiontime;
								}
							}else{
								str = "<div style=\"color:black;\">" + expInfoList[j].sessiontime;
							
								if(param.menuAuth == "W"){
									str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" />";
								} else {
									str += "<input type=\"checkbox\"  onclick=\"javascript:sessionCheckBox(this);\" disabled />";
								}
							}
							
							html += str
									+ "<input type=\"hidden\" name=\"tempSessionDateTime\" value=\"" + expInfoList[j].ymd + "\"/>"
									+ "<input type=\"hidden\" name=\"tempPpSeq\" value=\"" + expInfoList[j].ppseq + "\"/>"
									+ "<input type=\"hidden\" name=\"tempExpSeq\" value=\"" + expInfoList[j].expseq + "\"/>"
									+ "<input type=\"hidden\" name=\"tempExpSessionSeq\" value=\"" + expInfoList[j].expsessionseq + "\"/>"
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
	
// 	alert($("#calendarDiv").parents(".contents_title").height());
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
	expInfoListAjax();
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
	expInfoListAjax();
}

/* 세션 체크박스 클릭 */
function sessionCheckBox(check) {
	$(check).parent("div").children("input[name=sessionCheck]").val($(check).prop("checked"));
}
</script>
</head>

<body class="bgw">
	<input type="hidden" id="toYear" value="${reservationToday.year}"/>
	<input type="hidden" id="toMonth" value="${reservationToday.month}"/>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">체험 예약 현황</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tr>
				<th>PP 선택</th>
				<td scope="row">
					<select id="searchPpSeq" name="searchPpSeq" style="width:auto; min-width:100px;">
						<c:forEach var="item" items="${ppCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				<th>프로그램 타입</th>
				<td scope="row">
					<select id="searchTypeSeq" name="searchTypeSeq" style="width:auto; min-width:100px;">
						<option value="">전체</option>
						<c:forEach var="item" items="${expTypeCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>프로그램 명</td>
				<td colspan="3">
					<select id="searchExpSeq" name="searchExpSeq" style="width:auto; min-width:100px;">
					</select>
				</td>
			</tr>
		</table>
	</div>

	<div class="contents_title clear">
		<div class="fl">
			<a href="javascript:;" id="aExpOperatorReservation" class="btn_green authWrite">운영자예약</a>
			<a href="javascript:;" id="aExpOperatorReservationCancel" class="btn_green authWrite">운영자예약취소</a>
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
		<form id="expInfoForm" name="expInfoForm" method="POST">
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