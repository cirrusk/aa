<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	

$(document).ready(function(){
	$("#btnReject").on("click", function() {
		if(!chkValidation({chkId:"#rejectFrom", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		var msg = "";
		if($("input:radio[name=giveRadio]:checked").val()=="1") {
			msg = "[개인] 지급 반려 처리 하시겠습니까?";
		} else {
			msg = "[그룹] 지급 반려 처리 하시겠습니까?";
		}
		
		var result = confirm(msg); 
		
		if(result) {
			$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeSpendReject.do"/>"
		   		, data: $("#rejectFrom").serialize()
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result.errCode < 0) {
		   				alert(data.result.errMsg);
		   			} else {
		   				alert("지급 반려 처리가 완료 되었습니다.");
		   				eval($('#ifrm_main_'+"${lyData.frmId}").get(0).contentWindow.fn_init());
		   				$(".close-layer").click();
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});
		}
	});
	$("#btnRejectP").on("click", function() {
		if(!chkValidation({chkId:"#rejectFrom", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		var result = confirm("지급 반려 하시겠습니까?"); 
		
		if(result) {
			$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeSpendRejectP.do"/>"
		   		, data: $("#rejectFrom").serialize()
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result.errCode < 0) {
		   				alert(data.result.errMsg);
		   			} else {
		   				alert("지급 반려 처리가 완료 되었습니다.");
		   				eval($('#ifrm_main_'+"${lyData.frmId}").get(0).contentWindow.fn_init());
		   				$(".close-layer").click();
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});
		}
	});
	$("#btnRejectM").on("click", function() {
		if(!chkValidation({chkId:"#rejectFrom", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		var result = confirm("지급 반려 하시겠습니까?"); 
		
		if(result) {
			$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeSpendRejectM.do"/>"
		   		, data: $("#rejectFrom").serialize()
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result.errCode < 0) {
		   				alert(data.result.errMsg);
		   			} else {
		   				alert("지급 반려 처리가 완료 되었습니다.");
		   				eval($('#ifrm_main_'+"${lyData.frmId}").get(0).contentWindow.fn_init());
		   				$(".close-layer").click();
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});
		}
	});
});
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">지급 반려</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<form id="rejectFrom">
				<div class="tbl_write1">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="30%"  />
							<col width="20%" />
							<col width="30%"  />
						</colgroup>
						<tr>
							<th>지급연도</th>
							<td scope="row">
								<span>${targetInfo.giveyear }</span>년도 
								<input type="hidden" name="giveyear" value="${targetInfo.giveyear }" />
							</td>
							<th>지급 월</th>
							<td scope="row">
								<span>${targetInfo.givemonth }</span>월
								<input type="hidden" name="givemonth" value="${targetInfo.givemonth }" />
							</td>
						</tr>
						<tr>
							<th>ABO No</th>
							<td scope="row">
								<span>${targetInfo.abo_no }</span>
								<input type="hidden" name="abono" value="${targetInfo.abo_no }" />
							</td>
							<th>ABO Name</th>
							<td scope="row">
								<span>${targetInfo.abo_name }</span>
							</td>
						</tr>
						<tr>
							<th>Dept</th>
							<td scope="row">
								<span>${targetInfo.department }</span>
							</td>
							<th>운영그룹</th>
							<td scope="row">
								<span>${targetInfo.groupcode }</span>
							</td>
						</tr>
						<tr>
							<th>연락처</th>
							<td scope="row">
								<span>${targetInfo.abotel }</span>
							</td>
							<th>메모</th>
							<td scope="row">
								<span>${targetInfo.note }</span>
							</td>
							
						</tr>
					</table>
				</div>
				<div style="padding:5px;">
					<input type="radio" name="giveRadio" value="1" checked><span>개인반려</span>
					<input type="radio" name="giveRadio" value="2"><span>그룹반려</span>
				</div>
				<div class="tbl_write1">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="*"  />
						</colgroup>
						<tr>
							<th>사유</th>
							<td scope="row">
								<input type="text" name="rejecttext" title="지급반려 사유" class="required" style="width:95%;min-width:30%" maxlength="100" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th>SMS</th>
							<td scope="row">
								<input type="checkbox" name="smsyn" title="SMS발송여부" value="Y" checked /> SMS 발송여부
								<input type="text" name="smstext" title="SMS" class="AXInput required" value="[한국암웨이] 안녕하세요 리더님. 등록하신 교육비 지급이 반려되었으므로, 자세한 내용은 ABN 사이트를 통해 재 확인 바랍니다. 감사합니다." readonly="readonly" style="width:95%;min-width:30%" />
							</td>
						</tr>
					</table>
				</div>
				</form>
				<div class="btnwrap clear"> 
					<a href="javascript:;" id="btnReject" class="btn_green">지급반려</a>
					<a href="javascript:;" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
