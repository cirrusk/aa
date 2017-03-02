<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	
	expInfoSessionListAjax();
	
	param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
    
    if(param.menuAuth == "W"){
        $(".authWrite").show();
    }else{
        $(".authWrite").hide();
    }
	
});

function planSave (){
	
	var param = $("#roomInfoForm").serialize();
	
	sUrl = "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationCancelUpdateAjax.do"/>";
	
// 	if($("#flag").val() == "I"){
// 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaInsertAjax.do"/>";
// 	} else {
// 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaUpdateAjax.do"/>";
// 	}
	
	var result = confirm("선택된 예약을 취소 하시겠습니까?");
	
	if(result) {
		$.ajaxCall({
			method : "POST",
			url : sUrl,
			dataType : "json",
			data : param,
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}else{
					alert("취소 되었습니다.");
				}
				closeManageLayerPopup("searchPopup");
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

/* pp, 시설, 예약일 별 세선 정보 조회 */
function expInfoSessionListAjax() {
	$.ajaxCall({
		method : "POST",
		url : "<c:url value="/manager/reservation/expInfo/expInfoSessionListAjax.do"/>",
		dataType : "json",
		data : $("#expInfoForm").serialize(),
		success : function(data, textStatus, jqXHR) {
			if (data.result.errCode < 0) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}else{
				expInfoSessionListRender(data.expInfoSessionList);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* session list table rendering */
function expInfoSessionListRender(expInfoSessionList) {
	
	$(".expInfoSessionList").empty();
	
	var html = "<tr  style=\"text-align: center; vertical-align: middle;\">"
			+ "<th style=\"text-align: center; vertical-align: middle;\">세션</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">예약 시간</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">회원 구분</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">예약자</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">ABO NO.</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">PIN</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">동반자</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">시설 타입</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">예약 상태</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">등록 일시</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">사유</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">운영자 예약</th>"
			+ "</tr>";
	
	var checkDate = null;
	var ymd = "";
	var weekDay = "";
	for(var num in expInfoSessionList){
		/* 마지막주 일요일 처리 */
		if(ymd != expInfoSessionList[num].ymd){
			ymd = expInfoSessionList[num].ymd;
			weekDay = expInfoSessionList[num].weekday;
		}
		if(expInfoSessionList[num].expsessionseq != null
				&& weekDay == expInfoSessionList[num].weekday){
			if(expInfoSessionList[num].settypecode == 'S02'
				&& expInfoSessionList[num].sessiontime != null){
				checkDate = expInfoSessionList[num].ymd;
				if(expInfoSessionList[num].worktypecode == 'S02'){
					alert("휴무일은 예약이 없습니다.");
					closeManageLayerPopup("searchPopup");
				}else if(expInfoSessionList[num].worktypecode == 'S01'){
					var typename = expInfoSessionList[num].rsvseq != null ? expInfoSessionList[num].typename : "-";
					var reservationstatus = expInfoSessionList[num].rsvseq != null ? expInfoSessionList[num].reservationstatus : "-";
					var purchasedate = expInfoSessionList[num].rsvseq != null ? expInfoSessionList[num].purchasedate : "-";
					
					var membertype = expInfoSessionList[num].membertype != null ? expInfoSessionList[num].membertype : "-";
					var rsvname = expInfoSessionList[num].rsvname != null ? expInfoSessionList[num].rsvname : "-";
					var abono = expInfoSessionList[num].abono != null ? expInfoSessionList[num].abono : "-";
					var pin = expInfoSessionList[num].pin != null ? expInfoSessionList[num].pin : "-";
					var partner = expInfoSessionList[num].partner != null ? expInfoSessionList[num].partner : "-";
					var adminfirstreason = expInfoSessionList[num].adminfirstreason != null ? expInfoSessionList[num].adminfirstreason : "-";
					
					var btn = "";
					if(expInfoSessionList[num].adminfirstcode == null){
						/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
						/*
						btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
							+ "'" + expInfoSessionList[num].ppseq + "', "
							+ "'" + expInfoSessionList[num].expseq + "', "
							+ "'" + expInfoSessionList[num].ymd + "', "
							+ "'" + expInfoSessionList[num].expsessionseq + "', "
							+ "'" + expInfoSessionList[num].startdatetime + "', "
							+ "'" + expInfoSessionList[num].enddatetime + "'"
							+ ");\" class=\"btn_green authWrite\">예약</a>";
						*/
					}else if(expInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
						btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
							+ "'" + expInfoSessionList[num].rsvseq + "'"
							+ ");\" class=\"btn_gray authWrite\">취소</a>";
					}else{
						btn = "-";
					}
					
					html += "<tr>"
							+ "<td>"
							+ expInfoSessionList[num].sessionname
							+ "</td>"
							+ "<td>"
							+ expInfoSessionList[num].sessiontime
							+ "</td>"
							+ "<td>"
							+ membertype
							+ "</td>"
							+ "<td>"
							+ rsvname
							+ "</td>"
							+ "<td>"
							+ abono
							+ "</td>"
							+ "<td>"
							+ pin
							+ "</td>"
							+ "<td>"
							+ partner
							+ "</td>"
							+ "<td>"
							+ typename
							+ "</td>"
							+ "<td>"
							+ reservationstatus
							+ "</td>"
							+ "<td>"
							+ purchasedate
							+ "</td>"
							+ "<td>"
							+ adminfirstreason
							+ "</td>"
							+ "<td>"
							+ btn
							+ "</td>"
							+ "</tr>";
				}
			}else if(checkDate != expInfoSessionList[num].ymd
					&& expInfoSessionList[num].sessiontime != null){
				var typename = expInfoSessionList[num].rsvseq != null ? expInfoSessionList[num].typename : "-";
				var reservationstatus = expInfoSessionList[num].rsvseq != null ? expInfoSessionList[num].reservationstatus : "-";
				var purchasedate = expInfoSessionList[num].rsvseq != null ? expInfoSessionList[num].purchasedate : "-";
				
				var membertype = expInfoSessionList[num].membertype != null ? expInfoSessionList[num].membertype : "-";
				var rsvname = expInfoSessionList[num].rsvname != null ? expInfoSessionList[num].rsvname : "-";
				var abono = expInfoSessionList[num].abono != null ? expInfoSessionList[num].abono : "-";
				var pin = expInfoSessionList[num].pin != null ? expInfoSessionList[num].pin : "-";
				var partner = expInfoSessionList[num].partner != null ? expInfoSessionList[num].partner : "-";
				if(partner == "1"){
					partner = "없음";
				}else if(partner == "2"){
					partner = "있음";
				}
				var adminfirstreason = expInfoSessionList[num].adminfirstreason != null ? expInfoSessionList[num].adminfirstreason : "-";
				
				var btn = "";
				if(expInfoSessionList[num].adminfirstcode == null){
					/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
					/*
					btn = "<a href=\"javascript:expInfoAdminReservationInsertAjax(" 
						+ "'" + expInfoSessionList[num].ppseq + "', "
						+ "'" + expInfoSessionList[num].expseq + "', "
						+ "'" + expInfoSessionList[num].ymd + "', "
						+ "'" + expInfoSessionList[num].expsessionseq + "', "
						+ "'" + expInfoSessionList[num].startdatetime + "', "
						+ "'" + expInfoSessionList[num].enddatetime + "'"
						+ ");\" class=\"btn_green authWrite\">예약</a>";
					*/
				}else if(expInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
					btn = "<a href=\"javascript:expInfoAdminReservationCancelUpdateAjax("
						+ "'" + expInfoSessionList[num].rsvseq + "'"
						+ ");\" class=\"btn_gray authWrite\">취소</a>";
				}else{
					btn = "-";
				}
				
				html += "<tr>"
						+ "<td>"
						+ expInfoSessionList[num].sessionname
						+ "</td>"
						+ "<td>"
						+ expInfoSessionList[num].sessiontime
						+ "</td>"
						+ "<td>"
						+ membertype
						+ "</td>"
						+ "<td>"
						+ rsvname
						+ "</td>"
						+ "<td>"
						+ abono
						+ "</td>"
						+ "<td>"
						+ pin
						+ "</td>"
						+ "<td>"
						+ partner
						+ "</td>"
						+ "<td>"
						+ typename
						+ "</td>"
						+ "<td>"
						+ reservationstatus
						+ "</td>"
						+ "<td>"
						+ purchasedate
						+ "</td>"
						+ "<td>"
						+ adminfirstreason
						+ "</td>"
						+ "<td>"
						+ btn
						+ "</td>"
						+ "</tr>";
			}
		}
	}
	
	$(".expInfoSessionList").append(html);
}

/* 운영자 예약 */
function expInfoAdminReservationInsertAjax(ppseq, expseq, reservationdate, expsessionseq, startdatetime, enddatetime) {
	
	var result = confirm("해당 세션을 운영자 예약 하시겠습니까?");
	
	if(result){
		$.ajaxCall({
			method : "POST",
			url : "<c:url value="/manager/reservation/expInfo/expInfoAdminReservationInsertAjax.do"/>",
			dataType : "json",
			data : {
				"ppSeq" : ppseq,
				"expSeq" : expseq,
				"reservationDate" : reservationdate,
				"expSessionSeq" : expsessionseq,
				"startDateTime" : startdatetime,
				"endDateTime" : enddatetime
			},
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}else{
					expInfoSessionListAjax();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

/* 운영자 예약 취소 */
function expInfoAdminReservationCancelUpdateAjax(rsvseq) {
	
	var result = confirm("해당 운영자 예약을 취소하시겠습니까?");
	
	if(result){
		$.ajaxCall({
			method : "POST",
			url : "<c:url value="/manager/reservation/expInfo/expInfoAdminReservationCancelUpdateAjax.do"/>",
			dataType : "json",
			data : {"rsvSeq" : rsvseq},
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}else{
					expInfoSessionListAjax();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
	
}

function closePop() {
	document.getElementById('ifrm_main_'+$("input[name='frmId']").val()).contentWindow.expInfoListAjax(null);
}
</script>

<form id="expInfoForm" name="expInfoForm" method="POST">
<input type="hidden" name="frmId" value="${listtype.frmId}"/>
<input type="hidden" name="menuAuth" value="${listtype.menuAuth}"/>
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">예약 현황</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: center; vertical-align: middle;">
						<tr style="text-align: center; vertical-align: middle;">
							<th style="text-align: center; vertical-align: middle;">PP명</th>
							<td>
								${data.ppname}
								<input type="hidden" name="ppSeq" value="${data.ppseq}">
							</td>
							<th style="text-align: center; vertical-align: middle;">프로그램 명</th>
							<td>
								${data.typename} ${data.productname}
								<input type="hidden" name="expSeq" value="${data.expseq}">
							</td>
							<th style="text-align: center; vertical-align: middle;">사용일</th>
							<td>
								${data.reservationdate}
								<input type="hidden" name="year" value="${data.year}">
								<input type="hidden" name="month" value="${data.month}">
								<input type="hidden" name="day" value="${data.day}">
							</td>
						</tr>
					</table>
				</div>
				
				<div class="tbl_write">
					</br>
					<table id="tblSearch" class="expInfoSessionList" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: center; vertical-align: middle;">
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer" onclick="javascript:closePop();">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
