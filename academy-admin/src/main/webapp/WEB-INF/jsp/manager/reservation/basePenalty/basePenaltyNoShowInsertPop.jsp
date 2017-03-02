<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

var numCheckPattern = /^[0-9]*$/;

$(document).ready(function(){
	
// 	$("#giveyear").bindDate({separator:"-", selectType:"m"});
// 	$("#startdt").bindDate({align:"center", valign:"middle"});
// 	$("#enddt").bindDate({align:"center", valign:"middle"});
	
	/* 시작일시, 종료일시 셋팅 */
// 	if($("#flag").val() == "U"){
// 		if("${planDetail.smsSendFlag}"=="Y") $("#smsSendFlag").is("checked");
// 	}
	
});

/* 취소 패널티 등록 */
function planSave (){
	
	//입력여부 체크
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
		return;
	}
	/* 정수만 통과 */
	if(!this.numCheckPattern.test($("#typeValue").val())){
		alert("취소 기준 값은 정수만 입력 가능합니다.");
		return;
	}
	/* 정수만 통과 */
	if(!this.numCheckPattern.test($("#applyTypeValue").val())){
		alert("취소 기준 값은 정수만 입력 가능합니다.");
		return;
	}
	
	var param = {
			typeCode : "P02",
			typeDetailCode : "P02",
			typeValue : $("#typeValue").val(),
			applyTypeCode : $("#applyTypeCode").val(),
			applyTypeValue : $("#applyTypeValue").val(),
			statusCode : $("#statusCode").val()
		};
	
	sUrl = "<c:url value="/manager/reservation/basePenalty/basePenaltyCencelInsertAjax.do"/>";
	
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
				document.getElementById('ifrm_main_'+$("input[name='frmId']").val()).contentWindow.basePenaltyList.doSearch();
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

<form id="basePenalty" name="basePenalty" method="POST">
	<input type="hidden" name="frmId" value="${listtype.frmId}"/>
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">No Show 패널티 등록</h2>
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
							<col width="50%" />
							<col width="20%" />
						</colgroup>
						<tr>
							<th style="text-align: center; vertical-align: middle;">
								<c:out value="No Show 기준"/>
							</th>
							<th style="text-align: center; vertical-align: middle;">
								<c:out value="패널티"/>
							</th>
							<th style="text-align: center; vertical-align: middle;">
								<c:out value="상태"/>
							</th>
						</tr>
						<tr>
							<td style="text-align: center; vertical-align: middle;">
								<input type="hidden" id="typeCode" name="typeCode" value="P02">
								<input type="hidden" id="typeDetailCode" name="typeDetailCode" value="P02">
								<input type="text" id="typeValue" name="typeValue" style="width:50px;" class="required" title="불참 횟수">
								<c:out value="회 불참시"/>
							</td>
							<td style="text-align: center; vertical-align: middle;">
								<input type="hidden" id="applyTypeCode" name="applyTypeCode" value="P02">
								<c:out value="예약 제한"/>
								<input type="text" id="applyTypeValue" name="applyTypeValue" style="width:50px;" class="required" title="예약제한일">
								<c:out value="일"/>
							</td>
							<td style="text-align: center; vertical-align: middle;">
								<select id="statusCode" name="statusCode">
									<option value="B01">사용</option>
									<option value="B02">미사용</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:planSave();" id="aInsert" class="btn_green">등록</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_green close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
