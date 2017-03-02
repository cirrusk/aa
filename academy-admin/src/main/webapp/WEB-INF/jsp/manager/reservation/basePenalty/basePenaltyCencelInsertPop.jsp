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

	var applyTypeCode = $(":radio[name=applyTypeCode]:checked").val();
	
	if(applyTypeCode == "P01" && $(":radio[name=applyTypeCode]:checked").parent("td").parent("tr").children("td").children("#applyTypeValue").val() == "") {
		alert("수수료 기준값은 필수입니다.");
		$(":radio[name=applyTypeCode]:checked").parent("td").parent("tr").children("td").children("#applyTypeValue").focus();
		return;
	}
	if(applyTypeCode == "P02" && $(":radio[name=applyTypeCode]:checked").parent("td").parent("tr").children("td").children("#applyTypeValue").val() == "") {
		alert("예약제한 기준값은 필수입니다.");
		$(":radio[name=applyTypeCode]:checked").parent("td").parent("tr").children("td").children("#applyTypeValue").focus();
		return;
	}		
	
	/* 정수만 통과 */
	if(!this.numCheckPattern.test($("#typeValue").val())){
		alert("취소 기준 값은 정수만 입력 가능합니다.");
		return;
	}
	
	/* 정수만 통과 */
	if(!this.numCheckPattern.test($(":radio[name=applyTypeCode]:checked").parents("tr").find("#applyTypeValue").val())){
		alert("패널티 기준 값은 정수만 입력 가능합니다.");
		return;
	}
	
	var param = {
			typeCode : "P01",
			typeDetailCode : "P01",
			typeValue : $("#typeValue").val(),
			applyTypeCode : $(":radio[name=applyTypeCode]:checked").val(),
			applyTypeValue : $(":radio[name=applyTypeCode]:checked").parent("td").parent("tr").children("td").children("#applyTypeValue").val(),
			statusCode : $("#statusCode").val()
		};
	
	sUrl = "<c:url value='/manager/reservation/basePenalty/basePenaltyCencelInsertAjax.do'/>";
	
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
			<h2 class="fl">취소 패널티 등록</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="35%" />
							<col width="25%" />
							<col width="25%" />
							<col width="10%" />
						</colgroup>
						<tr>
							<th style="text-align: center; vertical-align: middle;">
								<c:out value="취소 기준"/>
							</th>
							<th style="text-align: center; vertical-align: middle;" colspan="2">
								<c:out value="패널티"/>
							</th>
							<th style="text-align: center; vertical-align: middle;">
								<c:out value="상태"/>
							</th>
						</tr>
						<tr>
							<td style="text-align: center; vertical-align: middle;" rowspan="2">
								<input type="hidden" id="typeCode" name="typeCode" value="P01">
								<input type="hidden" id="typeDetailCode" name="typeDetailCode" value="P01">
								<input type="text" id="typeValue" name="typeValue" style="width:50px;" class="required" title="취소기준">
								<c:out value="일 이내 취소시"/>
							</td>
							<td style="text-align: left; vertical-align: middle; border-right: hidden; border-bottom: hidden;">
								<input type="radio" id="applyTypeCode" name="applyTypeCode" value="P01" checked="checked">
								<c:out value="수수료"/>
							</td>
							<td style="text-align: left; vertical-align: middle; border-bottom: hidden;">
								<input type="text" id="applyTypeValue" name="applyTypeValue" style="width:50px;">
								<c:out value="%"/>
							</td>
							<td style="text-align: center; vertical-align: middle;" rowspan="2">
								<select id="statusCode" name="statusCode">
									<option value="B01">사용</option>
									<option value="B02">미사용</option>
								</select>
							</td>
						</tr>
						<tr>
							<td style="text-align: left; vertical-align: middle; border-right: hidden;">
								<input type="radio" id="applyTypeCode" name="applyTypeCode" value="P02">
								<c:out value="예약 제한"/>
							</td>
							<td style="text-align: left; vertical-align: middle;">
								<input type="text" id="applyTypeValue" name="applyTypeValue" style="width:50px;">
								<c:out value="일"/>
							</td>
						</tr>
					</table>
				</div>
				<div>
					<c:out value="단, 당일 예약건 취소는 패널티가 면제됩니다."/>
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
