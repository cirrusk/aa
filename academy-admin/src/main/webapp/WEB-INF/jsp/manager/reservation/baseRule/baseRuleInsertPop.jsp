<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	
	$(".specialTarget").hide();
	$(".specialPP").hide();
	
	$("#C01").on("change", function(item){
		if($("#C01").is(":checked")){
			$("#C02").removeAttr("checked");
			$("#C03").removeAttr("checked");
			
			$("#C01").attr("checked", true);
			
			$(".ruleRequire").show();
			$(".specialTarget").hide();
			$(".specialPP").hide();
			
			/* 자격조건 이외의 데이터 초기화 */
			$("#popRoleGroupCode").val("");
			$("#ppSeq").val("");
			$("input:checkbox[name='typeseq']").each(function() {
				this.checked = false; 
			});
		}
	});
	
	$("#C02").on("change", function(item){
		if($("#C02").is(":checked")){
			$("#C01").removeAttr("checked");
			$("#C03").removeAttr("checked");
			
			$("#C02").attr("checked", true);
			
			$(".specialTarget").show();
			$(".ruleRequire").hide();
			$(".specialPP").hide();
			
			/* 특정대상자 이외의 데이터 초기화 */
			$("#popPinTreatRange").val("");
			$("#popCityTreatCode").val("");
			$("#popAgeTreatCode").val("");
			$("#ppSeq").val("");
			$("input:checkbox[name='typeseq']").each(function() {
				this.checked = false; 
			});
		}
	});
	
	$("#C03").on("change", function(item){
		if($("#C03").is(":checked")){
			
			$("#C01").removeAttr("checked");
			$("#C02").removeAttr("checked");
			
			$("#C03").attr("checked", true);
			
			$(".specialPP").show();
			$(".specialTarget").hide();
			$(".ruleRequire").hide();
			
			/* 특정 pp 이외의 데이터 초기화 */
			$("#popPinTreatRange").val("");
			$("#popCityTreatCode").val("");
			$("#popAgeTreatCode").val("");
			$("#popRoleGroupCode").val("");
		}
	});
});

/* 등록 */
function baseRuleInsert(){

	//입력여부 체크
	var constraintType = $("input[name='popConstraintType']:checked").val();
	
 	if("C01" == constraintType){
		if("" == $("#popPinTreatRange").val()
				&& "" == $("#popCityTreatCode").val()
				&& "" == $("#popAgeTreatCode").val()){
			
			alert("자격조건이 선택되지 않았습니다.");
			return;
		}
	}
	
 	if("C02" == constraintType){
		if("" == $("#popRoleGroupCode").val()){
			alert("대상자 그룹이 선택되지 않았습니다.");
			return;
		}
	}
	
 	if("C03" == constraintType){
		if("" == $("#ppSeq").val()){
			alert("대상자 그룹이 선택되지 않았습니다.");
			return;
		}
		
		if(0 == $("input:checkbox[name='typeseq']:checked").length){
			alert("룸타입이 선택되지 않았습니다.");
			return;
		}
	}
 	
 	if("" == $("#statuscode").val()){
 		alert("사용여부가 선택되지 않았습니다.");
 		return;
 	}
 	
 	if( "" == $("#popGlobalDalyCount").val()
 			&& "" == $("#popGlobalWeeklyCount").val()
 			&& "" == $("#popGlobalMonthlyCount").val()
			&& "" == $("#popPpDalyCount").val()
 			&& "" == $("#popPpWeeklyCount").val()
 			&& "" == $("#popPpMonthlyCount").val() 			
 			
 		){
 		alert("예약 가능 횟수가 선택 되지 않았습니다.");
 		return;
 	}
 	
	var url;
	
	var result = confirm("저장 하시겠습니까?");
	
	/* 제한기준 타입 코드가 C03일 경우 */
	if($("#C03").is(":checked") === true){
		url = "<c:url value='/manager/reservation/baseRule/ppToRoomTypeInsertAjax.do'/>"
	}else{
	/* 제한기준 타입 코드가 C01 C02일 경우 */
		url = "<c:url value='/manager/reservation/baseRule/baseRuleInsertAjax.do'/>";
	}	
	var param = $("#baseRule").serialize();
	
	if(result) {
		$.ajaxCall({
			method : "POST",
			url : url,
			dataType : "json",
			data : param,
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}else{
					alert("저장 완료 하였습니다.");
					//팝업창 닫기
					closeManageLayerPopup("searchPopup");
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

</script>

<form id="baseRule" name="baseRule" method="POST">

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">누적 예약 가능 횟수</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<h2 class="fl">1.예약 자격</h2>
					<p>적용할 우대 예약 조건을 선택해 주세요.</p>
					<div style="margin-bottom: 1%; margin-top: 1%">
					
						<c:forEach var="item" items="${constraintTypeCodeList}">
							<input type="radio" id="${item.commonCodeSeq}" name="popConstraintType" value="${item.commonCodeSeq}" ${item.commonCodeSeq == "C01" ? "checked" :""}><c:out value="${item.codeName}"/>
						</c:forEach>
				
					</div>
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="15%" />
							<col width="40"  />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<!-- 자격 조건 select box -->
						<tr class="ruleRequire">
							<th>Pin 구간</th>
							<td colspan="3">
								<select id="popPinTreatRange" name="popPinTreatRange" style="width:auto;" >
									<option value="">선택</option>
									<c:forEach var="item" items="${pinCodeList}">
										<option value="${item.commonCodeSeq}">${item.codeName}(이상)</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="ruleRequire">
							<th>지역 우대 여부</th>
							<td colspan="3">
								<select id="popCityTreatCode" name="popCityTreatCode" style="width:auto;" >
									<option value="">선택</option>
									<c:forEach var="item" items="${cityGroupCodeList}">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="ruleRequire">
							<th>나이 우대</th>
							<td colspan="3">
								<select id="popAgeTreatCode" name="popAgeTreatCode" style="width:auto;" >
									<option value="">선택</option>
									<c:forEach var="item" items="${ageCodeList}">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<!-- 특정 대상자 select box -->
						<tr class="specialTarget">
							<th>특정대상자 그룹</th>
							<td colspan="3">
								<select id="popRoleGroupCode" name="popRoleGroupCode" style="width:auto;" >
									<option value="">선택</option>
									<c:forEach items="${roleGroupCodeList}" var="item">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<!-- 특정 PP select box -->
						<tr class="specialPP">
							<th>PP선택</th>
							<td colspan="3">
								<select id="ppSeq" name="ppSeq" style="width:auto;">
									<option value="">선택</option>
									<c:forEach var="item" items="${ppCodeList}" >
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="specialPP">
							<th>룸타입 선택</th>
							<td colspan="3" id="appendRoomType">
								<c:forEach var="item" items="${searchPpToRoomTypeList}">
									<input type="checkbox" id="typeseq" name="typeseq" value="${item.typeseq}"><c:out value="${item.typename}"/>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<th>사용여부</th>
							<td>
								<select style="width:auto;" id="statuscode" name="statuscode">
									<option value="">선택</option>
									<c:forEach items="${stateCodeList}" var="item">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</table>
					
					<h2 class="fl" style="margin-top: 2%; margin-bottom: 1%">2.누적 예약 가능 횟수</h2>
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th colspan="3" style="width: 50%;">전국PP 예약 가능 횟수</th>
							<th colspan="3" style="width: 50%;">PP별 예약 가능 횟수</th>
						</tr>
						<tr>
							<th style="width: 16.6%;">일</th>
							<th style="width: 16.6%;">주</th>
							<th style="width: 16.6%;">월</th>
							<th style="width: 16.6%;">일</th>
							<th style="width: 16.6%;">주</th>
							<th style="width: 16.6%;">월</th>
						</tr>
						<tr>
							<td>
								<select id="popGlobalDalyCount" name="popGlobalDalyCount" style="width:auto; min-width:100px" >
									<option value="">선택</option>
									<option value="1">01</option>
									<option value="2">02</option>
									<option value="3">03</option>
									<option value="4">04</option>
									<option value="5">05</option>
									<option value="6">06</option>
									<option value="7">07</option>
									<option value="8">08</option>
									<option value="9">09</option>
									<option value="10">10</option>
								</select>회
							</td>
							<td>
								<select id="popGlobalWeeklyCount" name="popGlobalWeeklyCount" style="width:auto; min-width:100px" >
									<option value="">선택</option>
									<option value="1">01</option>
									<option value="2">02</option>
									<option value="3">03</option>
									<option value="4">04</option>
									<option value="5">05</option>
									<option value="6">06</option>
									<option value="7">07</option>
									<option value="8">08</option>
									<option value="9">09</option>
									<option value="10">10</option>
								</select>회
							</td>
							<td>
								<select id="popGlobalMonthlyCount" name="popGlobalMonthlyCount" style="width:auto; min-width:100px" >
									<option value="">선택</option>
									<option value="1">01</option>
									<option value="2">02</option>
									<option value="3">03</option>
									<option value="4">04</option>
									<option value="5">05</option>
									<option value="6">06</option>
									<option value="7">07</option>
									<option value="8">08</option>
									<option value="9">09</option>
									<option value="10">10</option>
								</select>회
							</td>
							<td>
								<select id="popPpDalyCount" name="popPpDalyCount" style="width:auto; min-width:100px" >
									<option value="">선택</option>
									<option value="1">01</option>
									<option value="2">02</option>
									<option value="3">03</option>
									<option value="4">04</option>
									<option value="5">05</option>
									<option value="6">06</option>
									<option value="7">07</option>
									<option value="8">08</option>
									<option value="9">09</option>
									<option value="10">10</option>
								</select>회
							</td>
							<td>
								<select id="popPpWeeklyCount" name="popPpWeeklyCount" style="width:auto; min-width:100px" >
									<option value="">선택</option>
									<option value="1">01</option>
									<option value="2">02</option>
									<option value="3">03</option>
									<option value="4">04</option>
									<option value="5">05</option>
									<option value="6">06</option>
									<option value="7">07</option>
									<option value="8">08</option>
									<option value="9">09</option>
									<option value="10">10</option>
								</select>회
							</td>
							<td>
								<select id="popPpMonthlyCount" name="popPpMonthlyCount" style="width:auto; min-width:100px" >
									<option value="">선택</option>
									<option value="1">01</option>
									<option value="2">02</option>
									<option value="3">03</option>
									<option value="4">04</option>
									<option value="5">05</option>
									<option value="6">06</option>
									<option value="7">07</option>
									<option value="8">08</option>
									<option value="9">09</option>
									<option value="10">10</option>
								</select>회
							</td>
						</tr>
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:baseRuleInsert();" id="aInsert" class="btn_green">저장</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
