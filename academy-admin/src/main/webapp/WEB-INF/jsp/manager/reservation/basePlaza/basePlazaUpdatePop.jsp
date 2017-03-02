<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<script type="text/javascript">	
var txt = "최대 6글자 입니다.";
$(document).ready(function(){
	
// 	$("#giveyear").bindDate({separator:"-", selectType:"m"});
// 	$("#startdt").bindDate({align:"center", valign:"middle"});
// 	$("#enddt").bindDate({align:"center", valign:"middle"});
	
	/* 시작일시, 종료일시 셋팅 */
// 	if($("#flag").val() == "U"){
// 		if("${planDetail.smsSendFlag}"=="Y") $("#smsSendFlag").is("checked");
// 	}

});

function planSave (){
	
	//입력여부 체크
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
		return;
	}
	
	var param = {
			ppSeq : $("#ppSeq").val(),
			ppName : $("#ppName").val(),
			warehouseCode : $("#warehouseCode").val(),
			statusCode : $("#statusCode option:selected").val(),
		};
	
	sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaUpdateAjax.do"/>";
	
// 	if($("#flag").val() == "I"){
// 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaInsertAjax.do"/>";
// 	} else {
// 		sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaUpdateAjax.do"/>";
// 	}
	
	var result = confirm("저장 하시겠습니까?");
	
	if(result) {
		$.ajaxCall({
			method : "POST",
			url : sUrl,
			dataType : "json",
			data : param,
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
					alert("처리도중 오류가 발생하였습니다.");
				}else{
					alert("저장 완료 하였습니다.");
				}
				eval($('#ifrm_main_'+"${lyData.frmId}").get(0).contentWindow.doReturn());
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

<form id="basePlaza" name="basePlaza" method="POST">
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">pp정보 수정</h2>
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
							<col width="70%" />
						</colgroup>
						<tr>
							<th>pp 코드</th>
							<td colspan="3">
								<c:out value="${dataDetail.ppseq}"/>
								<input type="hidden" id="ppSeq" name="ppSeq" value="${dataDetail.ppseq}">
							</td>
						</tr>
						<tr>
							<th>pp 명</th>
							<td colspan="3">
								<input type="text" id="ppName" name="ppName" value="${dataDetail.ppname}" class="required" title="pp명" maxlength="6">
						</tr>
						
						<tr>
							<th>웨어하우스 코드</th>
							<td colspan="3">
								<input type="text" id="warehouseCode" name="warehouseCode" value="${dataDetail.warehousecode}" class="required" title="웨어하우스 코드">
							</td>
						</tr>
						
						<tr>
							<th>상태</th>
							<td colspan="3">
								<select id=statusCode name="statusCode" style="width:auto; min-width:100px" class="required" title="상태">
									<option value="">선택</option>
									<c:forEach var="item" items="${useStateCodeList}">
										<c:if test="${dataDetail.statuscode eq item.commonCodeSeq}">
											<option value="${item.commonCodeSeq}" selected="selected">${item.codeName}</option>
										</c:if>
										<c:if test="${dataDetail.statuscode ne item.commonCodeSeq}">
											<option value="${item.commonCodeSeq}">${item.codeName}</option>
										</c:if>
									</c:forEach>
								</select>
							</td>
						</tr>
						
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:planSave();" id="aInsert" class="btn_green">저장</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
