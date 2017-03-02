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
	
	/* 패널티 유형에 따른 폼 변경 이벤트 */
	$(".cencelPenalty").find("input,button,textarea,select").prop("disabled", false);
	$(".cencelPenalty").show();
	$(".noShowPenalty").find("input,button,textarea,select").prop("disabled", true);
	$(".noShowPenalty").hide();
	
	$("input[name=typeCode]").change(function(){
		if($(".cencelPenalty").css("display") == "none"){
			$(".cencelPenalty").find("input,button,textarea,select").prop("disabled", false);
			$(".cencelPenalty").show();
			$(".noShowPenalty").find("input,button,textarea,select").prop("disabled", true);
			$(".noShowPenalty").hide();
			$("#typeDetailCode").val("P01");
		}else{
			$(".cencelPenalty").find("input,button,textarea,select").prop("disabled", true);
			$(".cencelPenalty").hide();
			$(".noShowPenalty").find("input,button,textarea,select").prop("disabled", false);
			$(".noShowPenalty").show();
			$("#typeDetailCode").val("P02");
		}
	});
	
	$("input[name=typeValue]").change(function(){
		$("#typeValue").val($(this).val());
	});
	
	$("select[name=periodValue]").change(function(){
		$("#periodValue").val($(this).val());
	});
	
	$("input[name=applyTypeValue]").change(function(){
		$("#applyTypeValue").val($(this).val());
	});
});

/* 취소 패널티 등록 */
function planSave (){
	
	var penaltyType = $(":radio[name=typeCode]:checked").val();
	
	/* 정수만 통과 */
	if(!this.numCheckPattern.test($("#typeValue").val())){
		alert("취소 기준 값은 정수만 입력 가능합니다.");
		return;
	}
	
	if("P03" == penaltyType){
		if("" == $("#cancel_typevalue").val()) {
			alert("취소 기준값은 필수입니다.");
			return;
		}
		if("" == $("#cancel_applyTypeValue").val()) {
			alert("차감횟수 값은 필수입니다.");
			return;
		}	
		/* 정수만 통과 */
		if(!this.numCheckPattern.test($("#cancel_applyTypeValue").val())){
			alert("차감횟수 값은 정수만 입력 가능합니다.");
			return;
		}
	}
	
	if("P04" == penaltyType){
		if("" == $("#noshow_typevalue").val()) {
			alert("취소 기준값은 필수입니다.");
			return;
		}
		if("" == $("#noshow_applyTypeValue").val()) {
			alert("차감횟수 값은 필수입니다.");
			return;
		}		
		/* 정수만 통과 */
		if(!this.numCheckPattern.test($("#noshow_applyTypeValue").val())){
			alert("차감횟수 값은 정수만 입력 가능합니다.");
			return;
		}
	}
	
	
	var param = {
			typeCode : $("input[name=typeCode]:checked").val(),
			typeDetailCode : $("#typeDetailCode").val(),
			typeValue : $("#typeValue").val(),
			periodCode : "P03",
			periodValue : $("#periodValue").val(),
			applyTypeCode : "P03",
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
	<input type="hidden" id="typeDetailCode" value="P01">
	<input type="hidden" id="typeValue">
	<input type="hidden" id="periodValue" value="0">
	<input type="hidden" id="applyTypeValue">
	<input type="hidden" name="frmId" value="${listtype.frmId}"/>
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">요리명장 패널티 등록</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<input type="radio" id="typeCode" name="typeCode" value="P03" checked="checked">
				<c:out value="취소패널티"/>
				<input type="radio" id="typeCode" name="typeCode" value="P04">
				<c:out value="No Show 패널티"/>
				<div class="tbl_write">
					<table id="tblSearch" class="cencelPenalty" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="30%" />
							<col width="50%" />
							<col width="20%" />
						</colgroup>
						<tr>
							<th style="text-align: center; vertical-align: middle;">
								<c:out value="취소 기준"/>
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
								<input type="text" id="cancel_typevalue" name="typeValue" style="width:50px;">
								<c:out value="일 이내 취소시"/>
							</td>
							<td style="text-align: center; vertical-align: middle;">
								<select name="periodValue" style="min-width:10px;">
									<option value="0"><c:out value="당월"/></option>
									<option value="1"><c:out value="명월"/></option>
								</select>
								<c:out value="무료횟수 차감 "/>
								<input type="text" id="cancel_applyTypeValue" name="applyTypeValue" style="width:50px;">
								<c:out value="회"/>
							</td>
							<td style="text-align: center; vertical-align: middle;">
								<select id="statusCode" name="statusCode">
									<option value="B01">사용</option>
									<option value="B02">미사용</option>
								</select>
							</td>
						</tr>
					</table>
					<table id="tblSearch" class="noShowPenalty" width="100%" border="0" cellspacing="0" cellpadding="0">
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
								<input type="text" id="noshow_typevalue" name="typeValue" style="width:50px;">
								<c:out value="회 불참시"/>
							</td>
							<td style="text-align: center; vertical-align: middle;">
								<select name="periodValue" style="min-width:10px;">
									<option value="0"><c:out value="당월"/></option>
									<option value="1"><c:out value="명월"/></option>
								</select>
								<c:out value="무료횟수 차감 "/>
								<input type="text" id="noshow_applyTypeValue" name="applyTypeValue" style="width:50px;">
								<c:out value="회"/>
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
