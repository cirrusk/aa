<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	
// 	$("#giveyear").bindDate({separator:"-", selectType:"m"});
// 	$("#startdt").bindDate({align:"center", valign:"middle"});
// 	$("#enddt").bindDate({align:"center", valign:"middle"});
	
	/* 시작일시, 종료일시 셋팅 */
// 	if($("#flag").val() == "U"){
// 		if("${planDetail.smsSendFlag}"=="Y") $("#smsSendFlag").is("checked");
// 	}
	
	/* 예약하기 */
	$("#aInsertReservation").click(function () {
		planSave();
	});
	
});

function planSave (){
	
	if( 0 == $("#adminfirstreasoncode2").val().length && 0 == $("#adminfirstreason").val().length ){
		alert("사유를 입력해 주세요");
		return;
	}
	
// 	$("#adminfirstreasoncode")

	$("#firstreason").val("");
	$("#firstreason").val($("#adminfirstreasoncode option:selected").text());
	
	var param = $("#roomInfoForm").serialize();
	
	sUrl = "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationListInsertAjax.do"/>";
	
// 	if($("#flag").val() == "I"){
// 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaInsertAjax.do"/>";
// 	} else {
// 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaUpdateAjax.do"/>";
// 	}
	
	var result = confirm("예약 하시겠습니까?");
	
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
					alert("예약 완료 하였습니다.");
				}
				document.getElementById('ifrm_main_'+$("input[name='frmId']").val()).contentWindow.roomInfoListAjax(null);
				closeManageLayerPopup("searchPopup");
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

</script>

<form id="roomInfoForm" name="roomInfoForm" method="POST">
<input type="hidden" name="frmId" value="${listtype.frmId}"/>
<input type="text" name="firstreason" id="firstreason">
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">관리자 우선예약</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="30%" />
							<col width="60%" />
						</colgroup>
						<tr>
							<th>PP명</th>
							<td>
								<c:out value="${dataList[0].ppname}"/>
							</td>
						</tr>
						<tr>
							<th>시설타입</th>
							<td>
								<c:out value="${dataList[0].typename}"/>
							</td>
						</tr>
						<tr>
							<th>시설명</th>
							<td>
								<c:out value="${dataList[0].roomname}"/>
							</td>
						</tr>
						<tr>
							<th>사용일/시간</th>
							<td>
								<c:forEach var="items" items="${dataList}" varStatus="status">
									<c:out value="${items.weekname} ${items.sessiontime}"/><br/>
									<input type="hidden" name="tempPpSeq" value="${items.ppseq}">
									<input type="hidden" name="tempRoomSeq" value="${items.roomseq}">
									<input type="hidden" name="tempReservationDate" value="${items.reservationdate}">
									<input type="hidden" name="tempRsvSessionSeq" value="${items.rsvsessionseq}">
									<input type="hidden" name="tempStartDateTime" value="${items.startdatetime}">
									<input type="hidden" name="tempEndDateTime" value="${items.enddatetime}">
								</c:forEach>
							</td>
						</tr>
						
						<tr>
							<th>예약자</th>
							<td>
								<c:out value="${dataList[0].managename}"/>
							</td>
						</tr>
						<tr>
							<th>사유</th>
							<td>
								<select id="adminfirstreasoncode" name="adminfirstreasoncode" style="width:97%;" >
									<option value="">선택</option>
									<option value="0">AP 행사</option>
									<option value="1">AKL APSD</option>
									<option value="2">AKL 영업부</option>
									<option value="3">AKL 교육부</option>
									<option value="4">AKL 마케팅</option>
									<option value="5">AKL 기타</option>
									<option value="6">ABO 요청</option>
									<option value="7">Others</option>
								</select>
								<select id="adminfirstreasoncode2" name="adminfirstreasoncode2" style="width:97%;" >
									<option value="">선택</option>
								</select>
								<input id="adminfirstreason" name= "adminfirstreason" type="text" style="width:90%;" >
							</td>
						</tr>
						
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:;" id="aInsertReservation" class="btn_green">예약하기</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">취소</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
<script>
$(document).ready(function(){
	var reasonArray = new Array(new Array(6),
								new Array(4),
								new Array(4),
								new Array(6),
								new Array(3),
								new Array(4),
								new Array(3),
								new Array(1));
	
	reasonArray[0][0] = "SP 세미나";
	reasonArray[0][1] = "투어";
	reasonArray[0][2] = "칠드런스 데이";
	reasonArray[0][3] = "영웨이 데이";
	reasonArray[0][4] = "쿠킹클래스";
	reasonArray[0][5] = "기타";
	
	reasonArray[1][0] = "지점장 미팅";
	reasonArray[1][1] = "부스 워크샵";
	reasonArray[1][2] = "ABO 인터뷰";
	reasonArray[1][3] = "기타";
	
	reasonArray[2][0] = "비즈니스코칭";
	reasonArray[2][1] = "다이아몬드간담회";
	reasonArray[2][2] = "FC 미팅";
	reasonArray[2][3] = "기타";
	
	reasonArray[3][0] = "일반 오프라인 교육";
	reasonArray[3][1] = "퀸요리 오프라인 교육";
	reasonArray[3][2] = "요리명장 교육";
	reasonArray[3][3] = "뷰티 클래스";
	reasonArray[3][4] = "큐레이터";
	reasonArray[3][5] = "기타";
	
	reasonArray[4][0] = "시음회 & 시식회";
	reasonArray[4][1] = "바디키";
	reasonArray[4][2] = "기타";
	
	reasonArray[5][0] = "세무교육";
	reasonArray[5][1] = "윤리강령교육";
	reasonArray[5][2] = "HAT 상담";
	reasonArray[5][3] = "기타";
	
	reasonArray[6][0] = "헌혈행사";
	reasonArray[6][1] = "당일현장예약";
	reasonArray[6][2] = "기타";
	
	reasonArray[7][0] = "기타";
	
	$("#adminfirstreasoncode").change(function(){
		
		/* init */
		$("#adminfirstreason").attr("readonly",true);
		$("#adminfirstreason").val("");
		$("#adminfirstreasoncode2").find("option").remove().end().append("<option value='''>선택</option>");
		
		var opt = $("#adminfirstreasoncode").val();
		
		if("" != opt){
			
			for(var i = 0 ; i < reasonArray[opt].length ; i++ ){
				if( "" != reasonArray[opt][i]){
					$("#adminfirstreasoncode2").append("<option value='" + reasonArray[opt][i] + "'>" + reasonArray[opt][i] + "</option>");
				}
			}
		}
		
	});
	
	$("#adminfirstreason").attr("readonly",true);
	
	$("#adminfirstreasoncode2").change(function(){
		
		$("#adminfirstreason").val("");
		
		if("기타" == $(this).val()){
			$("#adminfirstreason").attr("readonly",false);
		}else{
			$("#adminfirstreason").attr("readonly",true);
		}
		
	});
	
});
</script>
