<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
});

function planSave (){
	var tempGiveyear;
	var tempGivemonth;
	var strArray = $("#giveyear").val().split("-");
	var sUrl = "";
	
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
		return;
	}
	
	tempGiveyear = strArray[0];
	tempGivemonth = strArray[1];
	
	var chk = "N";
	
	if( $('input:checkbox[id="smsSendFlag"]').is(':checked') ) {
		var result = confirm("SMS발송 예약 후 발송 취소를 할 수 없습니다.\nSMS 발송진행을 하시겠습니까?");
		
		if(result){
			chk = "Y";
		} else {
			return;
		}
	}
	
	var startdt = $("#startdt").val();
	var starttime = $("#starttime").val();
	var enddt = $("#enddt").val();
	var endtime = $("#endtime").val();
	
	if( startdt +" "+starttime >= enddt +" "+endtime ) {
		alert("시작일자(시간)은(는) 종료일자(시간) 보다 커야 합니다.");
		return;
	}
		
	var param = {
			giveyear : tempGiveyear,
			givemonth : tempGivemonth,
			startdt : $("#startdt").val(),
			starttime : $("#starttime option:selected").val(),
			enddt : $("#enddt").val(),
			endtime : $("#endtime option:selected").val(),
			smssendflag : chk
		};
	
	if($("#flag").val() == "I"){
		sUrl = "<c:url value="/manager/trainingFee/proof/trainingFeePlanInsertAjax.do"/>";
	} else {
		sUrl = "<c:url value="/manager/trainingFee/proof/trainingFeePlanUpdateAjax.do"/>";
	}
	
	var result = confirm("저장 하시겠습니까?\nPT그룹 생성시 오류가 발생 할 수 있습니다. 오류 발생시 담당자에게 문의 해 주세요.");
	
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
					if (data.result.errCode == 100) {
						alert(data.result.errMsg);
					} else {
						var rtnFrmId = $("#callFrmId").val();
						alert("저장 완료 하였습니다.");
						
						$(".close-layer").click();
						eval($("#ifrm_main_"+rtnFrmId).get(0).contentWindow.trainingFeePlan.doSearch({page : 1}));						
					}
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다." + errorThrown);
			}
		});
	}
}

function reset() {
	$("#startdt").val("");
	$("#enddt").val("");
	$("#starttime").val("10");
	$("#endtime").val("18");
}

</script>
</head>

<form id="trainingFeePlan" name="trainingFeePlan" method="POST">
	<input type="hidden" id="callFrmId" value="${layerMode.frmId }" />
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				<c:if test="${layerMode.mode eq 'I' }">일정 등록</c:if>
				<c:if test="${layerMode.mode eq 'U' }">일정 수정</c:if>
			</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="15%" />
							<col width="40"  />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<tr>
							<th>지급연도/월</th>
							<td colspan="3">
								<div style="float:left;">
									<input type="text" id="giveyear" name="giveyear" class="AXInput datepMon required" title="지급연도/월" value="${layerMode.giveyear}-${layerMode.givemonth}" style="width:120px; min-width:100px;" readonly="readonly"/>
									<input type="hidden" id="flag" value="${layerMode.mode}" />
								</div>
								<div style="float:left;margin-left:20px;">
									<input type="checkbox" id="smsSendFlag" value="Y" <c:if test="${planDetail.smssendflag eq 'Y'}">checked="checked"</c:if> /><span style="margin-left:5px;font-weight:bold;font-size:14px;">SMS 발송예약</span>
								</div>
							</td>
						</tr>
						<tr>
							<th>일정</th>
							<td colspan="3">
								<input type="text" id="startdt" name="startdt" class="AXInput datepDay required" title="시작일자" value="${planDetail.startdt}" style="width:120px; min-width:100px;" readonly="readonly"/>
								<select id="starttime" name="starttime" style="width:auto; min-width:60px;" >
									<ct:code type="option" majorCd="timeList" selectAll="false" allText="선택" selected="${planDetail.starttime}" />
								</select>
								~
								<input type="text" id="enddt" name="enddt" class="AXInput datepDay required" title="종료일자" value="${planDetail.enddt}" style="width:120px; min-width:100px;" readonly="readonly"/>
								<select id="endtime" name="endtime" style="width:auto; min-width:60px;" >
									<c:if test="${layerMode.mode eq 'I' }">
									<ct:code type="option" majorCd="timeList" selectAll="false" allText="선택" selected="18" />
									</c:if>
									<c:if test="${layerMode.mode eq 'U' }">
									<ct:code type="option" majorCd="timeList" selectAll="false" allText="선택" selected="${planDetail.endtime}" />
									</c:if>
								</select>
								<a href="javascript:reset();" class="btn_green" >Reset</a>
							</td>
						</tr>
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:planSave();" id="aInsert" class="btn_green authWrite">
						<c:if test="${layerMode.mode eq 'I' }">일정등록</c:if>
						<c:if test="${layerMode.mode eq 'U' }">일정수정</c:if></a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
</body>