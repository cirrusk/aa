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
// 	$(".cencelPenalty").find("input,button,textarea,select").prop("disabled", false);
// 	$(".cencelPenalty").show();
// 	$(".noShowPenalty").find("input,button,textarea,select").prop("disabled", true);
// 	$(".noShowPenalty").hide();
	
	$("input[name=typeCode]").change(function(){
		if($(".cencelPenalty").css("display") == "none"){
// 			$(".cencelPenalty").find("input,button,textarea,select").prop("disabled", false);
			$(".cencelPenalty").show();
// 			$(".noShowPenalty").find("input,button,textarea,select").prop("disabled", true);
			$(".noShowPenalty").hide();
			$("#typeDetailCode").val("P01");
		}else{
// 			$(".cencelPenalty").find("input,button,textarea,select").prop("disabled", true);
			$(".cencelPenalty").hide();
// 			$(".noShowPenalty").find("input,button,textarea,select").prop("disabled", false);
			$(".noShowPenalty").show();
			$("#typeDetailCode").val("P02");
		}
	});
	
	$(":radio[name=applyTypeCode]").change(function name() {
		$("#applyTypeCode").val($(":radio[name=applyTypeCode]:checked").val());
		$("#applyTypeValue").val((":radio[name=applyTypeCode]:checked").parent("td").parent("tr").children("td").children("input[name=applyTypeValue").val());
	});
	
	$("input[name=applyTypeValue").change(function () {
		/* 해당하는 applyTypeCode가 체크되어있으면 */
		if($("#typeCode").val() == 'P01' && $(this).parents("tr").find(":radio[name=applyTypeCode]").prop("checked")){
			$("#applyTypeValue").val($(this).val());
		}else if($("#typeCode").val() == 'P02' || $("#typeCode").val() == 'P03' || $("#typeCode").val() == 'P04'){
			$("#applyTypeValue").val($(this).val());
		}
	});
	
	$("input[name=typeValue").change(function () {
		$("#typeValue").val($(this).val());
	});
	
	$("select[name=periodValue]").change(function(){
		$("#periodValue").val($(this).val());
	});
});

/* 취소 패널티 등록 */
function planSave (){
	
	/* 정수만 통과 */
	if(!this.numCheckPattern.test($("#typeValue").val())){
		alert("취소 기준 값은 정수만 입력 가능합니다.");
		return;
	}
	if(!this.numCheckPattern.test($("#applyTypeValue").val())){
		alert("패널티 기준 값은 정수만 입력 가능합니다.");
		return;
	}

	if($("#typeCode").val() == 'P01' || $("#typeCode").val() == 'P02'){
		
		var param = {
				penaltySeq : $("#penaltySeq").val(),
				typeCode : $("#typeCode").val(),
				typeDetailCode : $("#typeDetailCode").val(),
				typeValue : $("#typeValue").val(),
				applyTypeCode : $("#applyTypeCode").val(),
				applyTypeValue : $("#applyTypeValue").val(),
				statusCode : $("#statusCode").val()
			};
	}else if($("#typeCode").val() == 'P03'){

		var param = {
				penaltySeq : $("#penaltySeq").val(),
				typeCode : $("#typeCode").val(),
				typeDetailCode : $("#typeDetailCode").val(),
				typeValue : $("#typeValue").val(),
				periodCode : $("#periodCode").val() != '' ? $("#periodCode").val() : null,
				periodValue : $("#periodValue").val() != '' ? $("#periodValue").val() : '2',
				applyTypeCode : $("#applyTypeCode").val(),
				applyTypeValue : $("#applyTypeValue").val(),
				statusCode : $(".cencelPenalty").find("#statusCode").val()
			};
	}else{
		var param = {
				penaltySeq : $("#penaltySeq").val(),
				typeCode : $("#typeCode").val(),
				typeDetailCode : $("#typeDetailCode").val(),
				typeValue : $("#typeValue").val(),
				periodCode : $("#periodCode").val() != '' ? $("#periodCode").val() : null,
				periodValue : $("#periodValue").val() != '' ? $("#periodValue").val() : '2',
				applyTypeCode : $("#applyTypeCode").val(),
				applyTypeValue : $("#applyTypeValue").val(),
				statusCode : $(".noShowPenalty").find("#statusCode").val()
			};
	}
	
	if($("input[name=typeValue]").val() == ""){
		alert("취소 기준은 필수값 입니다.");
		return;
	}
	
	if($("#typeCode").val() == 'P01'){
		var applyTypeCode = $(":radio[name=applyTypeCode]:checked").val();
		if(applyTypeCode == "P01" && $(":radio[name=applyTypeCode]:checked").parents("tr").find("input[name=applyTypeValue]").val() == "") {
			alert("수수료 기준값은 필수입니다.");
			$(":radio[name=applyTypeCode]:checked").parents("tr").find("input[name=applyTypeValue]").focus();
			return;
		}
		if(applyTypeCode == "P02" && $(":radio[name=applyTypeCode]:checked").parents("tr").find("input[name=applyTypeValue]").val() == "") {
			alert("예약제한 기준값은 필수입니다.");
			$(":radio[name=applyTypeCode]:checked").parents("tr").find("input[name=applyTypeValue]").focus();
			return;
		}		
	}
	
	sUrl = "<c:url value="/manager/reservation/basePenalty/basePenaltyUpdateAjax.do"/>";
	
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
			<c:if test="${dataDetail.typecode eq 'P01'}">
				<h2 class="fl">취소 패널티 수정</h2>
			</c:if>
			<c:if test="${dataDetail.typecode eq 'P02'}">
				<h2 class="fl">No Show 패널티 수정</h2>
			</c:if>
			<c:if test="${dataDetail.typecode eq 'P03' || dataDetail.typecode eq 'P04'}">
				<h2 class="fl">요리명장 패널티 수정</h2>
			</c:if>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<input type="hidden" id="penaltySeq" value="${dataDetail.penaltyseq}">
					<input type="hidden" id="typeCode" value="${dataDetail.typecode}">
					<input type="hidden" id="typeDetailCode" value="${dataDetail.typedetailcode}">
					<input type="hidden" id="typeValue" value="${dataDetail.typevalue}">
					<input type="hidden" id="periodCode" value="${dataDetail.periodcode}">
					<input type="hidden" id="periodValue" value="${dataDetail.periodvalue}">
					<input type="hidden" id="applyTypeCode" value="${dataDetail.applytypecode}">
					<input type="hidden" id="applyTypeValue" value="${dataDetail.applytypevalue}">
					
					<c:if test="${dataDetail.typecode eq 'P01'}">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="30%" />
								<col width="25%" />
								<col width="25%" />
								<col width="20%" />
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
									<input type="text" name="typeValue" value="${dataDetail.typevalue}" style="width:50px;">
									<c:out value="일 이내 취소시"/>
								</td>
								<td style="text-align: left; vertical-align: middle; border-right: hidden; border-bottom: hidden;">
									<c:if test="${dataDetail.applytypecode eq 'P01'}">
										<input type="radio" name="applyTypeCode" value="P01" checked="checked">
									</c:if>
									<c:if test="${dataDetail.applytypecode ne 'P01'}">
										<input type="radio" name="applyTypeCode" value="P01">
									</c:if>
									<c:out value="수수료"/>
								</td>
								<td style="text-align: left; vertical-align: middle; border-bottom: hidden;">
									<c:if test="${dataDetail.applytypecode eq 'P01'}">
										<input type="text" name="applyTypeValue" value="${dataDetail.applytypevalue}" style="width:50px;">
									</c:if>
									<c:if test="${dataDetail.applytypecode ne 'P01'}">
										<input type="text" name="applyTypeValue" style="width:50px;">
									</c:if>
									<c:out value="%"/>
								</td>
								<td style="text-align: center; vertical-align: middle;" rowspan="2">
									<select id="statusCode" name="statusCode">
										<c:if test="${dataDetail.statuscode eq 'B01'}">
										<option value="B01" selected="selected">사용</option>
										<option value="B02">미사용</option>
										</c:if>
										<c:if test="${dataDetail.statuscode eq 'B02'}">
										<option value="B01">사용</option>
										<option value="B02" selected="selected">미사용</option>
										</c:if>
									</select>
								</td>
							</tr>
							<tr>
								<td style="text-align: left; vertical-align: middle; border-right: hidden;">
									<c:if test="${dataDetail.applytypecode eq 'P02'}">
										<input type="radio" name="applyTypeCode" value="P02" checked="checked">
									</c:if>
									<c:if test="${dataDetail.applytypecode ne 'P02'}">
										<input type="radio" name="applyTypeCode" value="P02">
									</c:if>
									<c:out value="예약 제한"/>
								</td>
								<td style="text-align: left; vertical-align: middle;">
									<c:if test="${dataDetail.applytypecode eq 'P02'}">
										<input type="text" name="applyTypeValue" value="${dataDetail.applytypevalue}" style="width:50px;">
									</c:if>
									<c:if test="${dataDetail.applytypecode ne 'P02'}">
										<input type="text" name="applyTypeValue" style="width:50px;">
									</c:if>
									<c:out value="일"/>
								</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${dataDetail.typecode eq 'P02'}">
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
									<input type="text" name="typeValue" value="${dataDetail.typevalue}" style="width:50px;">
									<c:out value="회 불참시"/>
								</td>
								<td style="text-align: center; vertical-align: middle;">
									<c:out value="예약 제한"/>
									<input type="text" name="applyTypeValue" value="${dataDetail.applytypevalue}" style="width:50px;">
									<c:out value="일"/>
								</td>
								<td style="text-align: center; vertical-align: middle;">
									<select id="statusCode" name="statusCode">
										<c:if test="${dataDetail.statuscode eq 'B01'}">
										<option value="B01" selected="selected">사용</option>
										<option value="B02">미사용</option>
										</c:if>
										<c:if test="${dataDetail.statuscode eq 'B02'}">
										<option value="B01">사용</option>
										<option value="B02" selected="selected">미사용</option>
										</c:if>
									</select>
								</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${dataDetail.typecode eq 'P03' || dataDetail.typecode eq 'P04'}">
						<c:if test="${dataDetail.typecode eq 'P03'}">
							<input type="radio" name="typeCode" value="P03" checked="checked">
							<c:out value="취소패널티"/>
							<input type="radio" name="typeCode" value="P04" disabled="disabled">
							<c:out value="No Show 패널티"/>
						</c:if>
						<c:if test="${dataDetail.typecode eq 'P04'}">
							<input type="radio" name="typeCode" value="P03" disabled="disabled">
							<c:out value="취소패널티"/>
							<input type="radio" name="typeCode" value="P04" checked="checked">
							<c:out value="No Show 패널티"/>
						</c:if>
						<c:if test="${dataDetail.typecode eq 'P03'}">
							<table id="tblSearch" class="cencelPenalty" width="100%" border="0" cellspacing="0" cellpadding="0">
						</c:if>
						<c:if test="${dataDetail.typecode eq 'P04'}">
							<table id="tblSearch" class="cencelPenalty" width="100%" border="0" cellspacing="0" cellpadding="0" style="display: none;">
						</c:if>
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
									<c:if test="${dataDetail.typecode eq 'P03'}">
										<input type="text" name="typeValue" value="${dataDetail.typevalue}" style="width:50px;">
									</c:if>
									<c:if test="${dataDetail.typecode eq 'P04'}">
										<input type="text" style="width:50px;">
									</c:if>
									<c:out value="일 이내 취소시"/>
								</td>
								<td style="text-align: center; vertical-align: middle;">
									<select name="periodValue" style="min-width:10px;">
										<c:if test="${dataDetail.typecode eq 'P03'}">
											<c:if test="${dataDetail.periodvalue eq '0'}">
												<option value="0" selected="selected"><c:out value="당월"/></option>
												<option value="1"><c:out value="명월"/></option>
											</c:if>
											<c:if test="${dataDetail.periodvalue eq '1'}">
												<option value="0"><c:out value="당월"/></option>
												<option value="1" selected="selected"><c:out value="명월"/></option>
											</c:if>
										</c:if>
										<c:if test="${dataDetail.typecode eq 'P04'}">
											<option value="0"><c:out value="당월"/></option>
											<option value="1"><c:out value="명월"/></option>
										</c:if>
									</select>
									<c:out value="무료횟수 차감 "/>
									<c:if test="${dataDetail.typecode eq 'P03'}">
										<input type="text" name="applyTypeValue" value="${dataDetail.applytypevalue}" style="width:50px;">
									</c:if>
									<c:if test="${dataDetail.typecode eq 'P04'}">
										<input type="text" style="width:50px;">
									</c:if>
									<c:out value="회"/>
								</td>
								<td style="text-align: center; vertical-align: middle;">
									<select id="statusCode" name="statusCode">
										<c:if test="${dataDetail.statuscode eq 'B01'}">
										<option value="B01" selected="selected">사용</option>
										<option value="B02">미사용</option>
										</c:if>
										<c:if test="${dataDetail.statuscode eq 'B02'}">
										<option value="B01">사용</option>
										<option value="B02" selected="selected">미사용</option>
										</c:if>
									</select>
								</td>
							</tr>
						</table>
						<c:if test="${dataDetail.typecode eq 'P03'}">
							<table id="tblSearch" class="noShowPenalty" width="100%" border="0" cellspacing="0" cellpadding="0" style="display: none;">
						</c:if>
						<c:if test="${dataDetail.typecode eq 'P04'}">
							<table id="tblSearch" class="noShowPenalty" width="100%" border="0" cellspacing="0" cellpadding="0">
						</c:if>
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
									<c:out value="상테"/>
								</th>
							</tr>
							<tr>
								<td style="text-align: center; vertical-align: middle;">
									<c:if test="${dataDetail.typecode eq 'P03'}">
										<input type="text" style="width:50px;">
									</c:if>
									<c:if test="${dataDetail.typecode eq 'P04'}">
										<input type="text" name="typeValue" value="${dataDetail.typevalue}" style="width:50px;">
									</c:if>
									<c:out value="회 불참시"/>
								</td>
								<td style="text-align: center; vertical-align: middle;">
									<select name="periodValue" style="min-width:10px;">
										<c:if test="${dataDetail.typecode eq 'P03'}">
											<option value="0"><c:out value="당월"/></option>
											<option value="1"><c:out value="명월"/></option>
										</c:if>
										<c:if test="${dataDetail.typecode eq 'P04'}">
											<c:if test="${dataDetail.periodvalue eq '0'}">
												<option value="0" selected="selected"><c:out value="당월"/></option>
												<option value="1"><c:out value="명월"/></option>
											</c:if>
											<c:if test="${dataDetail.periodvalue eq '1'}">
												<option value="0"><c:out value="당월"/></option>
												<option value="1" selected="selected"><c:out value="명월"/></option>
											</c:if>
										</c:if>
									</select>
									<c:out value="무료횟수 차감 "/>
									<c:if test="${dataDetail.typecode eq 'P03'}">
										<input type="text" style="width:50px;">
									</c:if>
									<c:if test="${dataDetail.typecode eq 'P04'}">
										<input type="text" name="applyTypeValue" value="${dataDetail.applytypevalue}" style="width:50px;">
									</c:if>
									<c:out value="회"/>
								</td>
								<td style="text-align: center; vertical-align: middle;">
									<select id="statusCode" name="statusCode">
										<c:if test="${dataDetail.statuscode eq 'B01'}">
										<option value="B01" selected="selected">사용</option>
										<option value="B02">미사용</option>
										</c:if>
										<c:if test="${dataDetail.statuscode eq 'B02'}">
										<option value="B01">사용</option>
										<option value="B02" selected="selected">미사용</option>
										</c:if>
									</select>
								</td>
							</tr>
						</table>
					</c:if>

				</div>
				<div>
					<c:out value="단, 당일 예약건 취소는 패널티가 면제됩니다."/>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:planSave();" id="aInsert" class="btn_green">수정</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_green close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
