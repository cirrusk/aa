<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<script type="text/javascript">	
setBaseRuleData();
$(document).ready(function(){
	
	$(".specialTarget").hide();
	$(".specialPP").hide();
	
	$("#C01").on("change", function(item){
		if($("#C01").is(":checked")){
			$(".ruleRequire").show();
			$(".specialTarget").hide();
			$(".specialPP").hide();
			
			/* 자격조건 이외의 데이터 초기화 */
			$("#popRoleGroupCode").val("");
			$("#popPpSeq").val("");
			$("input:checkbox[name='typeseq']").each(function() {
				this.checked = false; 
			});
			
			$("#afterConstrainttype").val("C01");

		}
	});
	
	$("#C02").on("change", function(item){
		if($("#C02").is(":checked")){
			$(".specialTarget").show();
			$(".ruleRequire").hide();
			$(".specialPP").hide();
			
			/* 특정대상자 이외의 데이터 초기화 */
			$("#popPinTreatRange").val("");
			$("#popCityTreatCode").val("");
			$("#popAgeTreatCode").val("");
			$("#popPpSeq").val("");
			$("input:checkbox[name='typeseq']").each(function() {
				this.checked = false; 
			});
			
			$("#afterConstrainttype").val("C02");
		}
	});
	
	$("#C03").on("change", function(item){
		if($("#C03").is(":checked")){
			$(".specialPP").show();
			$(".specialTarget").hide();
			$(".ruleRequire").hide();
			
			/* 특정 pp 이외의 데이터 초기화 */
			$("#popPinTreatRange").val("");
			$("#popCityTreatCode").val("");
			$("#popAgeTreatCode").val("");
			$("#popRoleGroupCode").val("");
			
			$("#afterConstrainttype").val("C03");
		}
	});
});

/* 누적예약 횟수 수정 */
function baseRuleUpdate(){
	
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
	 var result = confirm("수정 하시겠습니까?");
	
	 /* 기존 제한 기준 타입이 C03이고, 새로 선택한 제한 기준 타입이 C01 or C2일경우 */
	if($("#beforConstrainttype").val() == "C03" && ($("#afterConstrainttype").val() == "C02" || $("#afterConstrainttype").val() == "C01")){
		url = "<c:url value='/manager/reservation/baseRule/ppToRoomTypeUpdateAjax.do'/>"
		
	}else if($("#afterConstrainttype").val() == "C03" && $("#beforConstrainttype").val() != "C03"){
	/* 기존 제한 기준 타입이 C03이고, 새로 선택한 제한 기준타입이 C03이 아닐경우 */
		url = "<c:url value='/manager/reservation/baseRule/baseRuleUpdateAndInsertAjax.do'/>"
	}else{
		/* 기존 제한 기준 타입과 새로선택한 제한 기준 타입이 동일할 경우 */
		url = "<c:url value='/manager/reservation/baseRule/baseRuleUpdateAjax.do'/>"
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

/* detail정보 조회 */
function setBaseRuleData(){
	
	var param = {
		settingseq : $("#settingseq").val()
	};

	$.ajaxCall({
		method : "POST",
		url : "<c:url value="/manager/reservation/baseRule/baseRuleDetailInfoAjax.do"/>",
		dataType : "json",
		data : param,
		success : function(data, textStatus, jqXHR) {
			
			/* 해당 seq의 detail정보 */
			var baseRuleDetail = data.baseRuleDetail;
			/* 공통(룸정보) */
			var roomTypeList = data.roomTypeInfoCodeList;
			
			/* detail정보 셋팅 */
			baseRuleSetData(baseRuleDetail, roomTypeList);
		},
		error : function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* detail 정보 셋팅 */
function baseRuleSetData(baseRuleDetail, roomTypeList){
	
	$("#popGlobalDalyCount").val(baseRuleDetail.globaldailycount);
	$("#popGlobalWeeklyCount").val(baseRuleDetail.globalweeklycount);
	$("#popGlobalMonthlyCount").val(baseRuleDetail.globalmonthlycount);
	
	$("#popPpDalyCount").val(baseRuleDetail.ppdailycount);
	$("#popPpWeeklyCount").val(baseRuleDetail.ppweeklycount);
	$("#popPpMonthlyCount").val(baseRuleDetail.ppmonthlycount);
	
	$("#statuscode").val(baseRuleDetail.statuscode);
	
	/* 제한기준 타입이 C01일경우 */
	if(baseRuleDetail.constrainttype == "C01"){
		$("input:radio[id='C01']").prop("checked", true);
		$("input:radio[id='C02']").prop("checked", false);
		$("input:radio[id='C03']").prop("checked", false);
		
		$(".ruleRequire").show();
		$(".specialTarget").hide();
		$(".specialPP").hide();
		
		$("#popPinTreatRange").val(baseRuleDetail.pintreatrange);
		$("#popCityTreatCode").val(baseRuleDetail.citytreatcode);
		$("#popAgeTreatCode").val(baseRuleDetail.agetreatcode);
		
		$("#afterConstrainttype").val("C01");
		$("#beforConstrainttype").val("C01");
		
	}else if(baseRuleDetail.constrainttype == "C02"){
	/* 제한 기준 타입이 C02일 경우 */
		$("input:radio[id='C01']").prop("checked", false);
		$("input:radio[id='C02']").prop("checked", true);
		$("input:radio[id='C03']").prop("checked", false);
		
		$(".specialTarget").show();
		$(".ruleRequire").hide();
		$(".specialPP").hide();
		
		$("#popRoleGroupCode").val(baseRuleDetail.groupseq);
		
		$("#afterConstrainttype").val("C02");
		$("#beforConstrainttype").val("C02");
	}else{
	/* 제한 기준 타입이 C03일경우 */
		var html= "";
		var typeSeqArray = baseRuleDetail.typeseq.split(',');
		var flag;
		
		//console.log(typeSeqArray);
		
		$("#afterConstrainttype").val("C03");
		$("#beforConstrainttype").val("C03");
		
		$("input:radio[id='C01']").prop("checked", false);
		$("input:radio[id='C02']").prop("checked", false);
		$("input:radio[id='C03']").prop("checked", true);
		
		$(".specialPP").show();
		$(".specialTarget").hide();
		$(".ruleRequire").hide();
		
		$("#popPpSeq").val(baseRuleDetail.ppseq);
		
		for(var i = 0; i < roomTypeList.length; i++){
			for(var j = 0; j < typeSeqArray.length; j++){
				if(roomTypeList[i].typeseq == typeSeqArray[j]){
					html += "<input type='checkbox' id='' name='typeseq' value='"+roomTypeList[i].typeseq+"'  checked='checked'>"+roomTypeList[i].typename;
					flag = "true";
				}
			}
			if(flag == "false"){
				//console.log(roomTypeList[i].commonCodeSeq + ":" + roomTypeList[i].codeName);
				html += "<input type='checkbox' id='' name='typeseq' value='"+roomTypeList[i].typeseq+"'>"+roomTypeList[i].typename;
			}
			flag = "false"; 
		}
		$("#appendRoomType").empty();
		$("#appendRoomType").append(html);
		
	}
}

/* pp선택시 해당 룸타입 정보 조회 */
function setRoomType(){
	var param = {
		ppseq : $("#popPpSeq option:selected").val()
	};
	
	//console.log(param);
	//console.log($("#popPpSeq").val());
	
	$.ajaxCall({
		method : "POST",
		url : "<c:url value="/manager/reservation/baseRule/searchPpToRoomTypeListAjax.do"/>",
		dataType : "json",
		data : param,
		success : function(data, textStatus, jqXHR) {
			
			/* 해당 pp의 룸타입 조회 */
			var ppToRoomTypeList = data.searchPpToRoomTypeList;
			var roomTypeCodeList = data.roomTypeCodeList;
			
			setRoomTypeList(ppToRoomTypeList, roomTypeCodeList);
			
		},
		error : function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 룸타입 셋팅  */
function setRoomTypeList(ppToRoomTypeList, roomTypeCodeList){
	
	var html = "";
	$("#appendRoomType").empty();
	
	if(ppToRoomTypeList.length == 0){
		for(var i = 0; i < roomTypeCodeList.length; i++){
			html += "<input type='checkbox' id='' name='' value='"+roomTypeCodeList[i].commonCodeSeq+"' disabled='disabled'>"+roomTypeCodeList[i].codeName+"";
		}
		
	}else{
		for(var i = 0; i < ppToRoomTypeList.length; i++){
			html += "<input type='checkbox' id='typeseqtypeseq' name='typeseq' value='"+ppToRoomTypeList[i].typeseq+"'>"+ppToRoomTypeList[i].typename+"";
		}
	}
	
	
	$("#appendRoomType").append(html);
}
</script>

<form id="baseRule" name="baseRule" method="POST">
	<input type="hidden" id="settingseq" name="settingseq" value="${settingSeq}"> 
	<input type="hidden" id="beforConstrainttype" name="beforConstrainttype"> 
	<input type="hidden" id="afterConstrainttype" name="afterConstrainttype"> 
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
							<input type="radio" id="${item.commonCodeSeq}" name="popConstraintType" value="${item.commonCodeSeq}"><c:out value="${item.codeName}"/>
						</c:forEach>
<%-- 						<input type ="hidden" name = "popSettingSeq" value="${baseRuleDatail.settingseq}"> --%>
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
						5	<td colspan="3">
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
								<select id="popPpSeq" name="popPpSeq" style="width:auto;">
									<option value="">선택</option>
									<c:forEach var="item" items="${ppCodeList}" >
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="specialPP">
							<th>룸타입 선택</th>
							<td id="appendRoomType">
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
					<a href="javascript:baseRuleUpdate();" id="aInsert" class="btn_green">수정</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
