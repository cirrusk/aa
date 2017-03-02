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
	
	/* 선택한 운영자 예약 취소 */
	$("#aUpdateReservationCancel").click(function () {
		var cnt = 0;
		$("input[name=rsvCancelCheck]").each(function () {
			if($(this).val() == "true"){
				cnt++;
			}
		});
		if(cnt == 0){
			alert("취소하고자 하는 예약을 선택하시기 바랍니다.");
			return;
		}
		planSave();
	});
	
	/* 예약 선택 */
	$("input[type=checkbox]").click(function () {
		$(this).next("input[name=rsvCancelCheck]").val($(this).prop("checked"));
	});
	
});

function planSave (){
	
	var param = $("#roomInfoForm").serialize();
	
	sUrl = "<c:url value="/manager/reservation/roomInfo/roomInfoAdminReservationListCancelUpdateAjax.do"/>";
	
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
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">관리자 우선예약 취소</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<div class="tbl_write">
					<div class="fr">
						<a href="javascript:;" id="aUpdateReservationCancel" class="btn_green">선택한 운영자 예약 취소</a>
					</div>
					</br>
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="5%" />
							<col width="20%" />
							<col width="15%" />
							<col width="20%" />
							<col width="20%" />
							<col width="20%" />
						</colgroup>
						<tr>
							<th></th>
							<th>사용일자</th>
							<th>세션</th>
							<th>예약시간</th>
							<th>예약자</th>
							<th>등록일시</th>
						</tr>
						<c:forEach var="items" items="${dataList}" varStatus="status">
							<tr>
								<td>
									<input type="checkbox">
									<input type="hidden" name="rsvCancelCheck" value="false">
									<input type="hidden" name="tempRsvSeq" value="${items.rsvseq}">
								</td>
								<td><c:out value="${items.reservationdate}"/></td>
								<td><c:out value="${items.sessionname}"/></td>
								<td><c:out value="${items.sessiontime}"/></td>
								<td><c:out value="${items.account}"/></td>
								<td><c:out value="${items.purchasedate}"/></td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
