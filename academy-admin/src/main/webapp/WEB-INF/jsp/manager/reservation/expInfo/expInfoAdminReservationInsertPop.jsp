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
	
	$("#firstreason").val("");
	$("#firstreason").val($("#adminfirstreasoncode option:selected").text());
	
	var param = $("#expInfoForm").serialize();
	
	sUrl = "<c:url value="/manager/reservation/expInfo/expInfoAdminReservationListInsertAjax.do"/>";
	
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
				document.getElementById('ifrm_main_'+$("input[name='frmId']").val()).contentWindow.expInfoListAjax(null);
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

<form id="expInfoForm" name="expInfoForm" method="POST">
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
<!-- 						<tr> -->
<!-- 							<th>시설명</th> -->
<!-- 							<td> -->
<%-- 								<c:out value="${dataList[0].roomname}"/> --%>
<!-- 							</td> -->
<!-- 						</tr> -->
						<tr>
							<th>사용일/시간</th>
							<td>
								<c:forEach var="items" items="${dataList}" varStatus="status">
									<c:out value="${items.weekname} ${items.sessiontime}"/><br/>
									<input type="hidden" name="tempPpSeq" value="${items.ppseq}">
									<input type="hidden" name="tempExpSeq" value="${items.expseq}">
									<input type="hidden" name="tempReservationDate" value="${items.reservationdate}">
									<input type="hidden" name="tempExpSessionSeq" value="${items.expsessionseq}">
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
									<option value="0">측정 | 인력운영</option>
									<option value="1">측정 | 이벤트</option>
									<option value="2">측정 | 교육 & 행사</option>
									<option value="3">측정 | Others</option>
									<option value="4">체험 | 교육 & 행사</option>
									<option value="5">체험 | Others</option>
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
	var reasonArray = new Array(new Array(4),
								new Array(4),
								new Array(8),
								new Array(1),
								new Array(4),
								new Array(1));
	
	reasonArray[0][0] = "식사교대";
	reasonArray[0][1] = "피크타임 일반상담";
	reasonArray[0][2] = "휴무";
	reasonArray[0][3] = "신제품 & 프로모션 출시 홍보";

	reasonArray[1][0] = "신제품 & 프로모션 출시 이벤트";
	reasonArray[1][1] = "AP 차체 이벤트";
	reasonArray[1][2] = "MBE  진행";
	reasonArray[1][3] = "AP Tour 진행";

	reasonArray[2][0] = "본사교육 참관";
	reasonArray[2][1] = "워크샵";
	reasonArray[2][2] = "협력사 미팅";
	reasonArray[2][3] = "AKL 요청에 의한 행사 지원";
	reasonArray[2][4] = "바디키드림팀 프로모션 측정";
	reasonArray[2][5] = "뷰티 클래스";
	reasonArray[2][6] = "아카데미";
	reasonArray[2][7] = "큐레이터";

	reasonArray[3][0] = "기타";

	reasonArray[4][0] = "타부서와 미팅";
	reasonArray[4][1] = "타부서 직원 체험 프로그램";
	reasonArray[4][2] = "타부서 행사";
	reasonArray[4][3] = "행사(타부서 제외)";

	reasonArray[5][0] = "기타";
	
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
