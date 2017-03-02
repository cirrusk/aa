<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	
	roomInfoSessionListAjax();
	
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
function roomInfoSessionListAjax() {
	$.ajaxCall({
		method : "POST",
		url : "<c:url value='/manager/reservation/roomInfo/roomInfoSessionListAjax.do'/>",
		dataType : "json",
		data : $("#roomInfoForm").serialize(),
		success : function(data, textStatus, jqXHR) {
			if (data.result.errCode < 0) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}else{
				roomInfoSessionListRender(data.roomInfoSessionList, data.partitionRoomFirstSessionList, data.partitionRoomSecondSessionList);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* session list table rendering */
function roomInfoSessionListRender(roomInfoSessionList, partitionRoomFirstSessionList, partitionRoomSecondSessionList) {
	
	$(".roomInfoSessionList").empty();
	
	var html = "<tr  style=\"text-align: center; vertical-align: middle;\">"
			+ "<th style=\"text-align: center; vertical-align: middle;\">세션</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">예약 시간</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">회원 구분</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">예약자</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">ABO NO.</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">PIN</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">시설 타입</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">예약 상태</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">등록 일시</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">사유</th>"
			+ "<th style=\"text-align: center; vertical-align: middle;\">운영자 예약</th>"
			+ "</tr>";
	
	var checkDate = null;
	var ymd = "";
	var weekDay = "";
	for(var num in roomInfoSessionList){
		/* 마지막주 일요일 처리 */
		if(ymd != roomInfoSessionList[num].ymd){
			ymd = roomInfoSessionList[num].ymd;
			weekDay = roomInfoSessionList[num].weekday;
		}
		if(roomInfoSessionList[num].rsvsessionseq != null
				&& weekDay == roomInfoSessionList[num].weekday){
			if(roomInfoSessionList[num].settypecode == 'S02'
				&& roomInfoSessionList[num].sessiontime != null){
				checkDate = roomInfoSessionList[num].ymd;
				if(roomInfoSessionList[num].worktypecode == 'S02'){
					alert("휴무일은 예약이 없습니다.");
					closeManageLayerPopup("searchPopup");
				}else if(roomInfoSessionList[num].worktypecode == 'S01'){
					
					var sessionname = "";
					var sessiontime = ""
					
					var typename = "";
					var reservationstatus = "";
					var purchasedate = "";
					
					var membertype = "";
					var rsvname = "";
					var abono = "";
					var pin = "";
					var adminfirstreason = "";
					
					var btn = "";
					
					/* 파티션룸에 대하여 나누어진 룸을 각각 A, B 합쳐진 룸을 A+B라고 가정함*/
					if(partitionRoomFirstSessionList == null
						|| partitionRoomFirstSessionList.length == 0){
						/* 파티션룸이 아닌 일반룸인 경우 */
						sessionname = roomInfoSessionList[num].sessionname;
						sessiontime = roomInfoSessionList[num].sessiontime;
						
						typename = roomInfoSessionList[num].rsvseq != null ? roomInfoSessionList[num].typename : "-";
						reservationstatus = roomInfoSessionList[num].rsvseq != null ? roomInfoSessionList[num].reservationstatus : "-";
						purchasedate = roomInfoSessionList[num].rsvseq != null ? roomInfoSessionList[num].purchasedate : "-";
						
						membertype = roomInfoSessionList[num].membertype != null ? roomInfoSessionList[num].membertype : "-";
						rsvname = roomInfoSessionList[num].rsvname != null ? roomInfoSessionList[num].rsvname : "-";
						abono = roomInfoSessionList[num].abono != null ? roomInfoSessionList[num].abono : "-";
						pin = roomInfoSessionList[num].pin != null ? roomInfoSessionList[num].pin : "-";
						adminfirstreason = roomInfoSessionList[num].adminfirstreason != null ? roomInfoSessionList[num].adminfirstreason : "-";
						
						if(roomInfoSessionList[num].adminfirstcode == null){
							
							/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
							btn = "";
							/*
							btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
								+ "'" + roomInfoSessionList[num].ppseq + "', "
								+ "'" + roomInfoSessionList[num].roomseq + "', "
								+ "'" + roomInfoSessionList[num].ymd + "', "
								+ "'" + roomInfoSessionList[num].rsvsessionseq + "', "
								+ "'" + roomInfoSessionList[num].startdatetime + "', "
								+ "'" + roomInfoSessionList[num].enddatetime + "'"
								+ ");\" class=\"btn_green authWrite\">예약</a>";
							*/
								
						}else if(roomInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + roomInfoSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
						}else{
							btn = "-";
						}
						
					}else if((partitionRoomSecondSessionList == null
								|| partitionRoomSecondSessionList.length == 0)
							&& partitionRoomFirstSessionList != null
							&& partitionRoomFirstSessionList.length != 0){
						/* 파티션룸이고 나누어진 룸인 경우 */
						
						if(roomInfoSessionList[num].adminfirstcode 	!= null){
							/* A 혹은 B룸에 예약건이 있는경우 */
							sessionname = roomInfoSessionList[num].sessionname;                                                                    
							sessiontime = roomInfoSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = roomInfoSessionList[num].typename;                          
							reservationstatus = roomInfoSessionList[num].reservationstatus;        
							purchasedate = roomInfoSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = roomInfoSessionList[num].membertype;                  
							rsvname = roomInfoSessionList[num].rsvname != null ? roomInfoSessionList[num].rsvname : "-";
							abono = roomInfoSessionList[num].abono;                                 
							pin = roomInfoSessionList[num].pin;                                       
							
							
							if(roomInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + roomInfoSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = roomInfoSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
							
						}else if(partitionRoomFirstSessionList[num].adminfirstcode != null){
							/* A+B룸에 예약건이 있는경우*/
							sessionname = partitionRoomFirstSessionList[num].sessionname;                                                                    
							sessiontime = partitionRoomFirstSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = partitionRoomFirstSessionList[num].typename;                          
							reservationstatus = partitionRoomFirstSessionList[num].reservationstatus;        
							purchasedate = partitionRoomFirstSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = partitionRoomFirstSessionList[num].membertype;                  
							rsvname = partitionRoomFirstSessionList[num].rsvname != null ? partitionRoomFirstSessionList[num].rsvname : "-";
							abono = partitionRoomFirstSessionList[num].abono;                                 
							pin = partitionRoomFirstSessionList[num].pin;                                       
							
							if(partitionRoomFirstSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + partitionRoomFirstSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = partitionRoomFirstSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
							
						}else{
							/* 예약건이 없는경우*/
							sessionname = roomInfoSessionList[num].sessionname;                                                                    
							sessiontime = roomInfoSessionList[num].sessiontime;
							
							typename = "-";
							reservationstatus = "-";
							purchasedate = "-";
							
							membertype = "-";
							rsvname = "-";
							abono = "-";
							pin = "-";
							adminfirstreason = "-";
							
							/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
							btn = "";
							/*
							btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
								+ "'" + roomInfoSessionList[num].ppseq + "', "
								+ "'" + roomInfoSessionList[num].roomseq + "', "
								+ "'" + roomInfoSessionList[num].ymd + "', "
								+ "'" + roomInfoSessionList[num].rsvsessionseq + "', "
								+ "'" + roomInfoSessionList[num].startdatetime + "', "
								+ "'" + roomInfoSessionList[num].enddatetime + "'"
								+ ");\" class=\"btn_green authWrite\">예약</a>";
							*/
						}
						
					}else{
						/* 파티션룸이고 합쳐진 룸인 경우 */
						if(partitionRoomFirstSessionList[num].adminfirstcode != null){
							/* A룸에 예약건이 있는경우*/
							sessionname = partitionRoomFirstSessionList[num].sessionname;                                                                    
							sessiontime = partitionRoomFirstSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = partitionRoomFirstSessionList[num].typename;                          
							reservationstatus = partitionRoomFirstSessionList[num].reservationstatus;        
							purchasedate = partitionRoomFirstSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = partitionRoomFirstSessionList[num].membertype;                  
							rsvname = partitionRoomFirstSessionList[num].rsvname != null ? partitionRoomFirstSessionList[num].rsvname : "-";
							abono = partitionRoomFirstSessionList[num].abono;                                 
							pin = partitionRoomFirstSessionList[num].pin;                                       
							
							if(partitionRoomFirstSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + partitionRoomFirstSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = partitionRoomFirstSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
						}else if(partitionRoomSecondSessionList[num].adminfirstcode != null){
							/* B룸에 예약건이 있는경우*/
							sessionname = partitionRoomSecondSessionList[num].sessionname;                                                                    
							sessiontime = partitionRoomSecondSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = partitionRoomSecondSessionList[num].typename;                          
							reservationstatus = partitionRoomSecondSessionList[num].reservationstatus;        
							purchasedate = partitionRoomSecondSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = partitionRoomSecondSessionList[num].membertype;                  
							rsvname = partitionRoomSecondSessionList[num].rsvname != null ? partitionRoomSecondSessionList[num].rsvname : "-";
							abono = partitionRoomSecondSessionList[num].abono;                                 
							pin = partitionRoomSecondSessionList[num].pin;                                       
							
							if(partitionRoomSecondSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + partitionRoomSecondSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = partitionRoomSecondSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
						}else if(roomInfoSessionList[num].adminfirstcode != null){
							/* A+B룸에 예약건이 있는 경우*/
							sessionname = roomInfoSessionList[num].sessionname;                                                                    
							sessiontime = roomInfoSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = roomInfoSessionList[num].typename;                          
							reservationstatus = roomInfoSessionList[num].reservationstatus;        
							purchasedate = roomInfoSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = roomInfoSessionList[num].membertype;                  
							rsvname = roomInfoSessionList[num].rsvname != null ? roomInfoSessionList[num].rsvname : "-";
							abono = roomInfoSessionList[num].abono;                                 
							pin = roomInfoSessionList[num].pin;                                       
							
							if(roomInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + roomInfoSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = roomInfoSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
						}else if(partitionRoomFirstSessionList[num].adminfirstcode != null
								&& partitionRoomSecondSessionList[num].adminfirstcode != null){
							/* A와 B룸에 예약건이 있는경우*/
							sessionname = partitionRoomFirstSessionList[num].sessionname;                                                                    
							sessiontime = partitionRoomFirstSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = partitionRoomFirstSessionList[num].typename;                          
							reservationstatus = partitionRoomFirstSessionList[num].reservationstatus;        
							purchasedate = partitionRoomFirstSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = partitionRoomFirstSessionList[num].membertype;                  
							rsvname = partitionRoomFirstSessionList[num].rsvname != null ? partitionRoomFirstSessionList[num].rsvname : "-";
							abono = partitionRoomFirstSessionList[num].abono;                                 
							pin = partitionRoomFirstSessionList[num].pin;                                       
							
							if(partitionRoomFirstSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + partitionRoomFirstSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = partitionRoomFirstSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
							
							html += "<tr>"
								+ "<td>"
								+ sessionname
								+ "</td>"
								+ "<td>"
								+ sessiontime
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
								
							sessionname = partitionRoomSecondSessionList[num].sessionname;                                                                    
							sessiontime = partitionRoomSecondSessionList[num].sessiontime;                                                                    
							                                                                                                                       
							typename = partitionRoomSecondSessionList[num].typename;                          
							reservationstatus = partitionRoomSecondSessionList[num].reservationstatus;        
							purchasedate = partitionRoomSecondSessionList[num].purchasedate;                  
							                                                                                                                       
							membertype = partitionRoomSecondSessionList[num].membertype;                  
							rsvname = partitionRoomSecondSessionList[num].rsvname != null ? partitionRoomSecondSessionList[num].rsvname : "-";
							abono = partitionRoomSecondSessionList[num].abono;                                 
							pin = partitionRoomSecondSessionList[num].pin;                                       
							
							if(partitionRoomSecondSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
								btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
									+ "'" + partitionRoomSecondSessionList[num].rsvseq + "'"
									+ ");\" class=\"btn_gray\">취소</a>";
								adminfirstreason = partitionRoomSecondSessionList[num].adminfirstreason;
							}else{
								btn = "-";
								adminfirstreason = "-";
							}
							
							
						}else{
							/* 예약건이 없는경우 */
							sessionname = roomInfoSessionList[num].sessionname;                                                                    
							sessiontime = roomInfoSessionList[num].sessiontime;
							
							typename = "-";
							reservationstatus = "-";
							purchasedate = "-";
							
							membertype = "-";
							rsvname = "-";
							abono = "-";
							pin = "-";
							adminfirstreason = "-";
							
							/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
							btn = "";
							/*
							btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
								+ "'" + roomInfoSessionList[num].ppseq + "', "
								+ "'" + roomInfoSessionList[num].roomseq + "', "
								+ "'" + roomInfoSessionList[num].ymd + "', "
								+ "'" + roomInfoSessionList[num].rsvsessionseq + "', "
								+ "'" + roomInfoSessionList[num].startdatetime + "', "
								+ "'" + roomInfoSessionList[num].enddatetime + "'"
								+ ");\" class=\"btn_green authWrite\">예약</a>";
							*/
						}
					}
					
					html += "<tr>"
							+ "<td>"
							+ sessionname
							+ "</td>"
							+ "<td>"
							+ sessiontime
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
			}else if(checkDate != roomInfoSessionList[num].ymd
					&& roomInfoSessionList[num].sessiontime != null){
				
				var sessionname = "";
				var sessiontime = ""
				
				var typename = "";
				var reservationstatus = "";
				var purchasedate = "";
				
				var membertype = "";
				var rsvname = "";
				var abono = "";
				var pin = "";
				var adminfirstreason = "";
				
				var btn = "";
				
				/* 파티션룸에 대하여 나누어진 룸을 각각 A, B 합쳐진 룸을 A+B라고 가정함*/
				if(partitionRoomFirstSessionList == null
					|| partitionRoomFirstSessionList.length == 0){
					/* 파티션룸이 아닌 일반룸인 경우 */
					sessionname = roomInfoSessionList[num].sessionname;
					sessiontime = roomInfoSessionList[num].sessiontime;
					
					typename = roomInfoSessionList[num].rsvseq != null ? roomInfoSessionList[num].typename : "-";
					reservationstatus = roomInfoSessionList[num].rsvseq != null ? roomInfoSessionList[num].reservationstatus : "-";
					purchasedate = roomInfoSessionList[num].rsvseq != null ? roomInfoSessionList[num].purchasedate : "-";
					
					membertype = roomInfoSessionList[num].membertype != null ? roomInfoSessionList[num].membertype : "-";
					rsvname = roomInfoSessionList[num].rsvname != null ? roomInfoSessionList[num].rsvname : "-";
					abono = roomInfoSessionList[num].abono != null ? roomInfoSessionList[num].abono : "-";
					pin = roomInfoSessionList[num].pin != null ? roomInfoSessionList[num].pin : "-";
					adminfirstreason = roomInfoSessionList[num].adminfirstreason != null ? roomInfoSessionList[num].adminfirstreason : "-";
					
					if(roomInfoSessionList[num].adminfirstcode == null){
						
						/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
						btn = "";
						/*
						btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
							+ "'" + roomInfoSessionList[num].ppseq + "', "
							+ "'" + roomInfoSessionList[num].roomseq + "', "
							+ "'" + roomInfoSessionList[num].ymd + "', "
							+ "'" + roomInfoSessionList[num].rsvsessionseq + "', "
							+ "'" + roomInfoSessionList[num].startdatetime + "', "
							+ "'" + roomInfoSessionList[num].enddatetime + "'"
							+ ");\" class=\"btn_green authWrite\">예약</a>";
						*/
					}else if(roomInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
						btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
							+ "'" + roomInfoSessionList[num].rsvseq + "'"
							+ ");\" class=\"btn_gray\">취소</a>";
					}else{
						btn = "-";
					}
					
				}else if((partitionRoomSecondSessionList == null
							|| partitionRoomSecondSessionList.length == 0)
						&& partitionRoomFirstSessionList != null
						&& partitionRoomFirstSessionList.length != 0){
					/* 파티션룸이고 나누어진 룸인 경우 */
					
					if(roomInfoSessionList[num].adminfirstcode 	!= null){
						/* A 혹은 B룸에 예약건이 있는경우 */
						sessionname = roomInfoSessionList[num].sessionname;                                                                    
						sessiontime = roomInfoSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = roomInfoSessionList[num].typename;                          
						reservationstatus = roomInfoSessionList[num].reservationstatus;        
						purchasedate = roomInfoSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = roomInfoSessionList[num].membertype;                  
						rsvname = roomInfoSessionList[num].rsvname != null ? roomInfoSessionList[num].rsvname : "-";
						abono = roomInfoSessionList[num].abono;                                 
						pin = roomInfoSessionList[num].pin;                                       
						
						
						if(roomInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + roomInfoSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = roomInfoSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
						
					}else if(partitionRoomFirstSessionList[num].adminfirstcode != null){
						/* A+B룸에 예약건이 있는경우*/
						sessionname = partitionRoomFirstSessionList[num].sessionname;                                                                    
						sessiontime = partitionRoomFirstSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = partitionRoomFirstSessionList[num].typename;                          
						reservationstatus = partitionRoomFirstSessionList[num].reservationstatus;        
						purchasedate = partitionRoomFirstSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = partitionRoomFirstSessionList[num].membertype;                  
						rsvname = partitionRoomFirstSessionList[num].rsvname != null ? partitionRoomFirstSessionList[num].rsvname : "-";
						abono = partitionRoomFirstSessionList[num].abono;                                 
						pin = partitionRoomFirstSessionList[num].pin;                                       
						
						if(partitionRoomFirstSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + partitionRoomFirstSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = partitionRoomFirstSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
						
					}else{
						/* 예약건이 없는경우*/
						sessionname = roomInfoSessionList[num].sessionname;                                                                    
						sessiontime = roomInfoSessionList[num].sessiontime;
						
						typename = "-";
						reservationstatus = "-";
						purchasedate = "-";
						
						membertype = "-";
						rsvname = "-";
						abono = "-";
						pin = "-";
						adminfirstreason = "-";
						
						/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
						btn = "";
						/*
						btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
							+ "'" + roomInfoSessionList[num].ppseq + "', "
							+ "'" + roomInfoSessionList[num].roomseq + "', "
							+ "'" + roomInfoSessionList[num].ymd + "', "
							+ "'" + roomInfoSessionList[num].rsvsessionseq + "', "
							+ "'" + roomInfoSessionList[num].startdatetime + "', "
							+ "'" + roomInfoSessionList[num].enddatetime + "'"
							+ ");\" class=\"btn_green authWrite\">예약</a>";
						*/
					}
					
				}else{
					/* 파티션룸이고 합쳐진 룸인 경우 */
					if(partitionRoomFirstSessionList[num].adminfirstcode != null){
						/* A룸에 예약건이 있는경우*/
						sessionname = partitionRoomFirstSessionList[num].sessionname;                                                                    
						sessiontime = partitionRoomFirstSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = partitionRoomFirstSessionList[num].typename;                          
						reservationstatus = partitionRoomFirstSessionList[num].reservationstatus;        
						purchasedate = partitionRoomFirstSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = partitionRoomFirstSessionList[num].membertype;                  
						rsvname = partitionRoomFirstSessionList[num].rsvname != null ? partitionRoomFirstSessionList[num].rsvname : "-";
						abono = partitionRoomFirstSessionList[num].abono;                                 
						pin = partitionRoomFirstSessionList[num].pin;                                       
						
						if(partitionRoomFirstSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + partitionRoomFirstSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = partitionRoomFirstSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
					}else if(partitionRoomSecondSessionList[num].adminfirstcode != null){
						/* B룸에 예약건이 있는경우*/
						sessionname = partitionRoomSecondSessionList[num].sessionname;                                                                    
						sessiontime = partitionRoomSecondSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = partitionRoomSecondSessionList[num].typename;                          
						reservationstatus = partitionRoomSecondSessionList[num].reservationstatus;        
						purchasedate = partitionRoomSecondSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = partitionRoomSecondSessionList[num].membertype;                  
						rsvname = partitionRoomSecondSessionList[num].rsvname != null ? partitionRoomSecondSessionList[num].rsvname : "-";
						abono = partitionRoomSecondSessionList[num].abono;                                 
						pin = partitionRoomSecondSessionList[num].pin;                                       
						
						if(partitionRoomSecondSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + partitionRoomSecondSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = partitionRoomSecondSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
					}else if(roomInfoSessionList[num].adminfirstcode != null){
						/* A+B룸에 예약건이 있는 경우*/
						sessionname = roomInfoSessionList[num].sessionname;                                                                    
						sessiontime = roomInfoSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = roomInfoSessionList[num].typename;                          
						reservationstatus = roomInfoSessionList[num].reservationstatus;        
						purchasedate = roomInfoSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = roomInfoSessionList[num].membertype;                  
						rsvname = roomInfoSessionList[num].rsvname != null ? roomInfoSessionList[num].rsvname : "-";
						abono = roomInfoSessionList[num].abono;                                 
						pin = roomInfoSessionList[num].pin;                                       
						
						if(roomInfoSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + roomInfoSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = roomInfoSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
					}else if(partitionRoomFirstSessionList[num].adminfirstcode != null
							&& partitionRoomSecondSessionList[num].adminfirstcode != null){
						/* A와 B룸에 예약건이 있는경우*/
						sessionname = partitionRoomFirstSessionList[num].sessionname;                                                                    
						sessiontime = partitionRoomFirstSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = partitionRoomFirstSessionList[num].typename;                          
						reservationstatus = partitionRoomFirstSessionList[num].reservationstatus;        
						purchasedate = partitionRoomFirstSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = partitionRoomFirstSessionList[num].membertype;                  
						rsvname = partitionRoomFirstSessionList[num].rsvname != null ? partitionRoomFirstSessionList[num].rsvname : "-";
						abono = partitionRoomFirstSessionList[num].abono;                                 
						pin = partitionRoomFirstSessionList[num].pin;                                       
						
						if(partitionRoomFirstSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + partitionRoomFirstSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = partitionRoomFirstSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
						
						html += "<tr>"
							+ "<td>"
							+ sessionname
							+ "</td>"
							+ "<td>"
							+ sessiontime
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
							
						sessionname = partitionRoomSecondSessionList[num].sessionname;                                                                    
						sessiontime = partitionRoomSecondSessionList[num].sessiontime;                                                                    
						                                                                                                                       
						typename = partitionRoomSecondSessionList[num].typename;                          
						reservationstatus = partitionRoomSecondSessionList[num].reservationstatus;        
						purchasedate = partitionRoomSecondSessionList[num].purchasedate;                  
						                                                                                                                       
						membertype = partitionRoomSecondSessionList[num].membertype;                  
						rsvname = partitionRoomSecondSessionList[num].rsvname != null ? partitionRoomSecondSessionList[num].rsvname : "-";
						abono = partitionRoomSecondSessionList[num].abono;                                 
						pin = partitionRoomSecondSessionList[num].pin;                                       
						
						if(partitionRoomSecondSessionList[num].adminfirstcode == "R01" && $("input[name='menuAuth']").val() == "W"){
							btn = "<a href=\"javascript:roomInfoAdminReservationCancelUpdateAjax("
								+ "'" + partitionRoomSecondSessionList[num].rsvseq + "'"
								+ ");\" class=\"btn_gray\">취소</a>";
							adminfirstreason = partitionRoomSecondSessionList[num].adminfirstreason;
						}else{
							btn = "-";
							adminfirstreason = "-";
						}
						
						
					}else{
						/* 예약건이 없는경우 */
						sessionname = roomInfoSessionList[num].sessionname;                                                                    
						sessiontime = roomInfoSessionList[num].sessiontime;
						
						typename = "-";
						reservationstatus = "-";
						purchasedate = "-";
						
						membertype = "-";
						rsvname = "-";
						abono = "-";
						pin = "-";
						adminfirstreason = "-";
						
						/* 운영자 우선 예약 버튼은 다른곳을 통해서 하도록 협의 */
						btn = "";
						/*
						btn = "<a href=\"javascript:roomInfoAdminReservationInsertAjax(" 
							+ "'" + roomInfoSessionList[num].ppseq + "', "
							+ "'" + roomInfoSessionList[num].roomseq + "', "
							+ "'" + roomInfoSessionList[num].ymd + "', "
							+ "'" + roomInfoSessionList[num].rsvsessionseq + "', "
							+ "'" + roomInfoSessionList[num].startdatetime + "', "
							+ "'" + roomInfoSessionList[num].enddatetime + "'"
							+ ");\" class=\"btn_green authWrite\">예약</a>";
						*/
					}
				}
				
				html += "<tr>"
						+ "<td>"
						+ sessionname
						+ "</td>"
						+ "<td>"
						+ sessiontime
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
	
	$(".roomInfoSessionList").append(html);
}

/* 운영자 예약 */
function roomInfoAdminReservationInsertAjax(ppseq, roomseq, reservationdate, rsvsessionseq, startdatetime, enddatetime) {
	
	//console.log("ppseq="+ppseq+" roomseq="+roomseq+" reservationdate="+reservationdate+" rsvsessionseq="+rsvsessionseq+" startdatetime="+startdatetime+" enddatetime="+enddatetime);
	
	var result = confirm("해당 세션을 운영자 예약 하시겠습니까?");
	
	if(result){
		$.ajaxCall({
			method : "POST",
			url : "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationInsertAjax.do"/>",
			dataType : "json",
			data : {
				"ppSeq" : ppseq,
				"roomSeq" : roomseq,
				"reservationDate" : reservationdate,
				"rsvSessionSeq" : rsvsessionseq,
				"startDateTime" : startdatetime,
				"endDateTime" : enddatetime
			},
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
				}else{
					roomInfoSessionListAjax();
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
function roomInfoAdminReservationCancelUpdateAjax(rsvseq) {
	
	//console.log("rsvseq="+rsvseq);
	
	var result = confirm("해당 운영자 예약을 취소하시겠습니까?");
	
	if(result){
		$.ajaxCall({
			method : "POST",
			url : "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationCancelUpdateAjax.do"/>",
			dataType : "json",
			data : {"rsvSeq" : rsvseq},
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
				}else{
					roomInfoSessionListAjax();
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
	document.getElementById('ifrm_main_'+$("input[name='frmId']").val()).contentWindow.roomInfoListAjax(null);
}
</script>

<form id="roomInfoForm" name="roomInfoForm" method="POST">
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
							<th style="text-align: center; vertical-align: middle;">시설명</th>
							<td>
								${data.roomname}
								<input type="hidden" name="roomSeq" value="${data.roomseq}">
							</td>
							<th style="text-align: center; vertical-align: middle;">시설타입</th>
							<td>
								${data.typename}
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
					<table id="tblSearch" class="roomInfoSessionList" width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: center; vertical-align: middle;">
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
