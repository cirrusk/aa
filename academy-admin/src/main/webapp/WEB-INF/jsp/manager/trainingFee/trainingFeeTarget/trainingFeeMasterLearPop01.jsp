<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	

$(document).ready(function(){
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	
	var getDate = new Date();
	
	if(getDate.getMonth()+1>10) {
		getDate = $.datepicker.formatDate("yy-mm-dd", new Date(getDate.getFullYear()+1,getDate.getMonth(),getDate.getDate()));
	}
	
	//Axisj 달력(yyyy-mm)
	$(".setLayerDateMon").val(setToDay().substring(0,7));
	
	// code
	$("#popCode").on("change", function(item){
		if( $("#popCode").val() == "txt" ) {
			$("#popInputCode").attr("disabled",false);
		} else {
			$("#popInputCode").attr("disabled",true);
			$("#popInputCode").val("");
		}
	});
	
	//deposit_code기타 선택시 input창 오픈
	$("#popDepositcode").on("change", function(item){
		if($("#popDepositcode").val() == "txt"){
			$("#popInputDepositcode").attr("disabled", false);
		}else{
			$("#popInputDepositcode").attr("disabled", true);
			$("#popInputDepositcode").val();
		}
	})
	
	// br
	$("#popBR").on("change", function(item){
		if( $("#popBR").val() == "txt" ) {
			$("#popInputBR").attr("disabled",false);
		} else {
			$("#popInputBR").attr("disabled",true);
			$("#popInputBR").val("");
		}
	});
	
	// dept
	$("#popDept").on("change", function(item){
		if( $("#popDept").val() == "txt" ) {
			$("#popInputDept").attr("disabled",false);
		} else {
			$("#popInputDept").attr("disabled",true);
			$("#popInputDept").val("");
		}
	});
	
	// dept
	$("#popGroupcode").on("change", function(item){
		if( $("#popGroupcode").val() == "txt" ) {
			$("#popInputGrp").attr("disabled",false);
		} else {
			$("#popInputGrp").attr("disabled",true);
			$("#popInputGrp").val("");
		}
	});
	
	$("#aboSearch").aboSearch("popAboname","btnABOSearch","popTxtABOSearchType","${param.frmId}");
	$("#aboSearch1").aboSearch("popDepositaboname","btndABOSearch","popTxtdABOSearchType","${param.frmId}");
});

function doReturnValue(param) {
	if(param.rtnInputNm=="popAboname" || param.rtninputnm=="popAboname") {
		$("select[name='popTxtABOSearchType']").val("1");
		$("input[name='popIabono']").val(param.uid);
		$("input[name='popAboname']").val(param.name);
	} else {
		$("select[name='popTxtdABOSearchType']").val("1");
		$("input[name='popDepositabo_no']").val(param.uid);
		$("input[name='popDepositaboname']").val(param.name);
	}
}

function itemValidation(selId, inpId) {
	var item="";
	var msg="";
	
	if( (isNull($("#"+selId+" option:selected").val()) && isNull($("#"+inpId).val())) || ($("#"+selId+" option:selected").val()=="txt" && isNull($("#"+inpId).val()) ) ) {
		msg = $("#"+selId).attr("title") + " 값이 없습니다. \n" + $("#"+selId).attr("title") +"은(는) 필수 입력값입니다." ;
		alert(msg);
		return false;
	} else {
		if( !isNull($("#"+selId+" option:selected").val()) && $("#"+selId+" option:selected").val()!="txt" ) {
			item = $("#"+selId+" option:selected").val();
		} else {
			item = $("#"+inpId).val();
		}
	}
	return item;
}

function masterUpdateGetParam() {
	if( itemValidation("popCode", "popInputCode") == false ) {
		return;
	} else {
		var tmpCode       = itemValidation("popCode", "popInputCode");		
	}
	if( itemValidation("popBR", "popInputBR") == false ) {
		return;
	} else {
		var tmpBr         = itemValidation("popBR", "popInputBR");		
	}
	if( itemValidation("popDept", "popInputDept") == false ) {
		return;
	} else {
		var tmpDepartment = itemValidation("popDept", "popInputDept");		
	}
	if( itemValidation("popGroupcode", "popInputGrp") == false ) {
		return;
	} else {
		var tmpGroupcode  = itemValidation("popGroupcode", "popInputGrp");		
	}	
	if( itemValidation("popDepositcode", "popInputDepositcode") == false ) {
		return;
	} else {
		var tmpDepositcode  = itemValidation("popDepositcode", "popInputDepositcode");		
	}
	
	/*-------------------------*/
	
	if(!chkValidation({chkId:"#popcontent", chkObj:"hidden|input|select"}) ){
		return;
	}
	
	var param = {
			 popGiveyear:"${layerMode.giveyear}"
			,popGivemonth:"${layerMode.givemonth}"
			,popAbono:"${targetInfo.abo_no }"
			,popCode : tmpCode
			,popBr : tmpBr
			,popDepartment : tmpDepartment
			,popSalesfee : $("#popSalesfee").val()
			,popTrainingfee : $("#popTrainingfee").val()
			,popGroupcode : tmpGroupcode
			,popAuthorizetypecode : $("#popCbSearchPass option:selected").val()
			,popAuthperson : $("#popTxtSearchAuthperson option:selected").val()
			,popAuthgroup : $("#popTxtSearchAuthgroup  option:selected").val()
			,popAuthmanagerflag :$("input[name = 'popManager']:checked").val()
			,popDepositabo_no : $("#popDepositabo_no").val()
			,popDepositcode : tmpDepositcode
// 			,popInputCode : $("#popInputCode").val()
// 			,popInputBR : $("#popInputBR").val()
// 			,popInputDept : $("#popInputDept").val()
// 			,popInputGrp : $("#popInputGrp").val()
// 			,popInputDepositcode : $("#popInputDepositcode").val()
	};
	
	masterUpdate(param);
}

/* 수정& 등록 관련 파라미터 보관 */
function masterInsertGetParam(){
	/*--------abo, DepositABO 텍스트박스 '(' 기준으로 abo 번호 분리-----------*/
	var temppopSearchGiveYear = $("#popSearchGiveYear").val().split("-");
	var tempPopGiveyear = temppopSearchGiveYear[0];
	var tempPopGivemonth = temppopSearchGiveYear[1];
	
	if( itemValidation("popCode", "popInputCode") == false ) {
		return;
	} else {
		var tmpCode       = itemValidation("popCode", "popInputCode");		
	}
	if( itemValidation("popBR", "popInputBR") == false ) {
		return;
	} else {
		var tmpBr         = itemValidation("popBR", "popInputBR");		
	}
	if( itemValidation("popDept", "popInputDept") == false ) {
		return;
	} else {
		var tmpDepartment = itemValidation("popDept", "popInputDept");		
	}
	if( itemValidation("popGroupcode", "popInputGrp") == false ) {
		return;
	} else {
		var tmpGroupcode  = itemValidation("popGroupcode", "popInputGrp");		
	}	
	if( itemValidation("popDepositcode", "popInputDepositcode") == false ) {
		return;
	} else {
		var tmpDepositcode  = itemValidation("popDepositcode", "popInputDepositcode");		
	}	
	
	/*-------------------------*/
	
	if(!chkValidation({chkId:"#popcontent", chkObj:"hidden|input|select"}) ){
		return;
	}	
	
	var param = {
			 popGiveyear : tempPopGiveyear
			,popGivemonth : tempPopGivemonth
			,popAbono : $("#popIabono").val()
			,popCode : tmpCode
			,popBr : tmpBr
			,popDepartment : tmpDepartment
			,popSalesfee : $("#popSalesfee").val()
			,popTrainingfee : $("#popTrainingfee").val()
			,popGroupcode : tmpGroupcode
			,popAuthorizetypecode : $("#popCbSearchPass option:selected").val()//위임구분
			,popAuthperson : $("#popTxtSearchAuthperson option:selected").val()
			,popAuthgroup : $("#popTxtSearchAuthgroup  option:selected").val()
			,popAuthmanagerflag : $("input[name = 'popManager']:checked").val()
			,popDepositabo_no : $("#popDepositabo_no").val()
			,popDepositcode : tmpDepositcode
// 			,popInputCode : $("#popInputCode").val()
// 			,popInputBR : $("#popInputBR").val()
// 			,popInputDept : $("#popInputDept").val()
// 			,popInputGrp : $("#popInputGrp").val()
// 			,popInputDepositcode : $("#popInputDepositcode").val()
			,mode:"I"
	};
	masterUpdate(param);
}

/* 지급 대상자 수정 */
function masterUpdate(param){
	$.ajaxCall({
		url : "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterSaveAjax.do"/>",
		data : param,
		bLoading : "Y",
		success : function(data, textStatus, jqXHR) {
			var sErrMsg = data.result.errMsg;
			
			if (data.result.errCode < 0) {
				alert(sErrMsg);
			}else{
				alert(sErrMsg);
				$(".close-layer").click();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			hideLoading();	//로딩 끝
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				<c:if test="${layerMode.mode eq 'I'}">교육비 대상자 추가</c:if>
				<c:if test="${layerMode.mode ne 'I' }">교육비 대상자 수정</c:if>
			</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3>Calculation</h3>
				</div>
				<!--// Sub Title -->
				<form id="saveItem" name="saveItem" method="post">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="10%" />
							<col width="40"  />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<tr> 
							<c:if test="${layerMode.mode eq 'I' }">
							<th>지급연도/월</th>
							<td colspan="3">
									<input type="text" id="popSearchGiveYear" name="popSearchGiveYear" class="AXInput datepMon setLayerDateMon required" title="지급연도/월" readonly="readonly">
									<input type="hidden" id="popFlag" value="${layerMode.mode}">
							</td>		
							</c:if>
							<c:if test="${layerMode.mode ne 'I' }">
							<th>지급연도</th>
							<td>
								<span>${targetInfo.giveyear }년도</span>
								<input type="hidden" id="popSearchGiveYear" name="popSearchGiveYear" value="${targetInfo.giveyear }">
								<input type="hidden" id="popSearchGiveMonth" name="popSearchGiveMonth" value="${targetInfo.givemonth }">
							</td>
							<th>지급 월</th>
							<td>
								<span>${targetInfo.givemonth }월</span>
							</td>									
							</c:if>							
						</tr>
						<tr>
							<th>ABO</th>
							<td>
								<div id="aboSearch">
								<c:if test="${layerMode.mode eq 'I' }">
									<select id="popTxtABOSearchType" name="popTxtABOSearchType" style="width:auto; min-width:70px;" >
										<option value="1">ABO 번호</option>
										<option value="2">ABO 성명</option>
									</select>
									<input type="text" id="popIabono" name="popIabono" style="width:50px; min-width:30px;" title="ABO 번호" class="AXInput required" readonly="readonly" />
									<input type="text" id="popAboname" name="popAboname" class="AXInput required" title="ABO 성명" style="width:auto; min-width:100px;" />
									<a href="javascript:;" id="btnABOSearch" name="btnABOSearch" class="btn_gray btn_mid">검색</a>
								</c:if>
								<c:if test="${layerMode.mode ne 'I' }">
									<span>${targetInfo.abo_no } ( ${targetInfo.abo_name } )</span>
								</c:if>
								</div>
							</td>
							<th scope="row">Code</th>
							<td>
								<select id="popCode" name="popCode" title="Code" style="min-width:100px;">
									<option value="">선택</option>
									<option value="txt">기타</option>
									<c:forEach var="items" items="${searchCode }">
										<option value="${items.code }" ${items.code == targetInfo.code ? "selected" :""}>${items.name }</option>
									</c:forEach>
								</select>
								<input type="text" id="popInputCode" name="popInputCode" class="AXInput" style="min-width:200px;" placeHolder="기타 선택시 입력 가능 합니다." Disabled maxlength="8" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">BR</th>
							<td>
								<select id="popBR" name="popBR" title="BR" style="min-width:100px;">
									<option value="">선택</option>
									<option value="txt">기타</option>
										<c:forEach var="items" items="${searchBR }">
											<option value="${items.code}" ${items.code == targetInfo.br ? "selected" :""}>${items.name }</option>
										</c:forEach>
								</select>
								<input type="text" id="popInputBR" name="popInputBR" class="AXInput" style="min-width:200px;" placeHolder="기타 선택시 입력 가능 합니다." Disabled maxlength="8" oninput="maxLengthCheck(this)"/>
							</td>
							<th scope="row">Dept</th>
							<td>
								<select id="popDept" name="popDept" title="department" style="min-width:100px;">
									<option value="">선택</option>
									<option value="txt">기타</option>
									<c:forEach var="items" items="${searchDept}">
										<option value="${items.code}" ${items.code == targetInfo.department ? "selected" :""}>${items.name }</option>
									</c:forEach>
								</select>
								<input type="text" id="popInputDept" name="popInputDept" class="AXInput" style="min-width:200px;" placeHolder="기타 선택시 입력 가능 합니다." Disabled maxlength="8" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">매출액</th>
							<td>
								<input type="text" name="popSalesfee" id="popSalesfee" value="${targetInfo.sales}" title="매출액" class="AXInput AXInputMoney required" style="min-width:303px;"/>
							</td>
							<th scope="row">교육비</th>
							<td>
								<input type="text" id="popTrainingfee" name="popTrainingfee" value="${targetInfo.trfee}" title="교육비" class="AXInput AXInputMoney required" style="min-width:303px;"/>
							</td>
						</tr>
						<tr>
							<th scope="row">운영그룹</th>
							<td>
								<select id="popGroupcode" name="popGroupcode" title="운영그룹" style="min-width:100px;">
									<option value="">선택</option>
									<option value="txt">기타</option>
									<c:forEach var="items" items="${searchGrpCd}">
										<option value="${items.code}" ${items.code == targetInfo.groupcode ? "selected" :""}>${items.name }</option>
									</c:forEach>
								</select>
								<input type="text" id="popInputGrp" name="popInputGrp" class="AXInput" style="min-width:200px;" placeHolder="기타 선택시 입력 가능 합니다." Disabled maxlength="8" oninput="maxLengthCheck(this)"/>
							</td>
							<th scope="row">위임구분</th>
							<td>
								<select id="popCbSearchPass" name="popCbSearchPass" style="min-width:325px;">
									<option value="0">없음</option>
									<c:choose>
										<c:when test="${targetInfo.delegtypecode eq null}">
											<ct:code type="option" majorCd="TR5" selectAll="false" />
										</c:when>
										<c:otherwise>
											<ct:code type="option" majorCd="TR5" selectAll="false" selected="${targetInfo.delegtypecode }" />
										</c:otherwise>
									</c:choose>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">권한</th>
							<td>
								<label>개인:</label>
								<select id="popTxtSearchAuthperson" name="popTxtSearchAuthperson" class="required" title="권한(개인)" style="min-width:100px;">
									<option value="">선택</option>
									<option value="1"  ${'1' == targetInfo.authperson ? "selected" :""}>개인</option>
									<option value="2"  ${'2' == targetInfo.authperson ? "selected" :""}>상세</option>
								</select>
								<label>운영그룹:</label>
								<select id="popTxtSearchAuthgroup" name="popTxtSearchAuthgroup" style="min-width:100px;">
									<option value="0" ${'0' == targetInfo.authgroup ? "selected" :""}>없음</option>
									<option value="1" ${'1' == targetInfo.authgroup ? "selected" :""}>개인</option>
									<option value="2" ${'2' == targetInfo.authgroup ? "selected" :""}>상세</option>
								</select>
							</td>
							<th scope="row">총무</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
								<input type="radio" name="popManager" value="Y" />Y
								<input type="radio" name="popManager" value="N" checked />N
								</c:if>
								<c:if test="${layerMode.mode ne 'I' }">
								<input type="radio" name="popManager" value="Y" ${'Y' == targetInfo.authmanageflag ? "checked" :""} />Y
								<input type="radio" name="popManager" value="N" ${'N' == targetInfo.authmanageflag ? "checked" :""} />N
								</c:if>
							</td>
						</tr>
					</table>
				</div>	
				
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3>Deposit</h3>
				</div>
				<!--// Sub Title -->
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="10%" />
							<col width="40"  />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<tr>
							<th>ABO</th>
							<td colspan="3">
								<div id="aboSearch1">
									<select id="popTxtdABOSearchType" name="popTxtdABOSearchType" style="width:auto; min-width:70px;" >
										<option value="1">ABO 번호</option>
										<option value="2">ABO 이름</option>
									</select>
									<c:if test="${layerMode.mode ne 'I' }">
										<input type="text" id="popDepositabo_no" name="popDepositabo_no" class="AXInput required" title="Deposit ABO 번호" style="width:50px; min-width:30px;" value="${targetInfo.depabo_no}" readonly="readonly" />
										<input type="text" id="popDepositaboname" name="popDepositaboname" style="width:auto; min-width:100px;" value="${targetInfo.depositaboname}" />
									</c:if>
									
									<c:if test="${layerMode.mode eq 'I' }">
										<input type="text" id="popDepositabo_no" name="popDepositabo_no" class="AXInput required" title="Deposit ABO 번호" style="width:50px; min-width:30px;" readonly="readonly" />
										<input type="text" id="popDepositaboname" name="popDepositaboname" style="width:auto; min-width:90px;">
									</c:if>
									
									<a href="javascript:;" id="btndABOSearch" name="btndABOSearch" class="btn_gray btn_mid">검색</a>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">Code</th>
							<td colspan="3">
								<select id="popDepositcode" name="popDepositcode" title="Deposit Code" style="min-width:100px;">
									<option value="">선택</option>
									<c:forEach var="items" items="${searchCode }">
										<option value="${items.code }" ${items.code == targetInfo.depcode ? "selected" :""}>${items.name }</option>
									</c:forEach>
									<option value="txt">기타</option>
								</select>								
								<input type="text" id="popInputDepositcode" name="textDepositcode"  class="AXInput" style="min-width:200px;" placeHolder="기타 선택시 입력 가능 합니다." Disabled maxlength="8" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
					</table>
				</div>
				<div class="btnwrap clear">
					<c:if test="${layerMode.mode ne 'I' }">
						<a href="javascript:masterUpdateGetParam();" id="aInsert" class="btn_green authWrite">수정</a>
					</c:if>
					<c:if test="${layerMode.mode eq 'I' }">
						<a href="javascript:masterInsertGetParam();" id="aInsert" class="btn_green authWrite">등록</a>
					</c:if>
						<a href="javascript:;" class="btn_gray close-layer" >닫기</a>
				</div>
				</form>	
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
