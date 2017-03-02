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
	
});

// function planSave (){
	
// 	var param = {
// 			ppSeq : $("#ppSeq").val(),
// 			ppName : $("#ppName").val(),
// 			warehouseCode : $("#warehouseCode").val(),
// 			statusCode : $("#statusCode option:selected").val(),
// 		};
	
// 	sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaUpdateAjax.do"/>";
	
// // 	if($("#flag").val() == "I"){
// // 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaInsertAjax.do"/>";
// // 	} else {
// // 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaUpdateAjax.do"/>";
// // 	}
	
// 	var result = confirm("저장 하시겠습니까?");
	
// 	if(result) {
// 		$.ajaxCall({
// 			method : "POST",
// 			url : sUrl,
// 			dataType : "json",
// 			data : param,
// 			success : function(data, textStatus, jqXHR) {
// 				if (data.result.errCode < 0) {
// 					alert("처리도중 오류가 발생하였습니다.");
// 				}else{
// 					alert("저장 완료 하였습니다.");
// 				}
// 				closeManageLayerPopup("searchPopup");
// 			},
// 			error : function(jqXHR, textStatus, errorThrown) {
// 				alert("처리도중 오류가 발생하였습니다.");
// 			}
// 		});
// 	}
// }

</script>

<form id="expPenalty" name="expPenalty" method="POST">
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">패널티 내용 상세보기</h2>
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
							<th>예약내용</th>
							<td>
								<c:out value="${dataDetail.typename}"/>
							</td>
						</tr>
						<tr>
							<th>사용일</th>
							<td>
								<c:out value="${dataDetail.reservationdate}"/>
							</td>
						</tr>
						<tr>
							<th>취소일</th>
							<td>
								<c:out value="${dataDetail.grantdate}"/>
							</td>
						</tr>
						<tr>
							<th>패널티 내용</th>
							<td>
								<c:out value="${dataDetail.applytypecode}"/>
							</td>
						</tr>
						
						<tr>
							<th>비고</th>
							<td>
								<c:out value="${dataDetail.reason}"/>
							</td>
						</tr>
						
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
