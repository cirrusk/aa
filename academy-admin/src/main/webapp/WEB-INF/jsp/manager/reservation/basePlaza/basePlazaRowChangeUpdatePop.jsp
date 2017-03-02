<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	

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
	
	var param = $("#basePlaza").serialize();
	
	sUrl = "<c:url value="/manager/reservation/basePlaza/basePlazaRowChangeUpdateAjax.do"/>";
	
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

/* 노출 순번 중복 여부 검사 */
function sort(){
	var orderNumArray = new Array();
	var flag = true;
	
	$("input[name='tempOrderNumber']").each(function(){
		orderNumArray.push(Number($(this).val()));
	});
	
	orderNumArray.sort();
	for(var i = 0; i < orderNumArray.length; i++){
		if(i > 0){
			if(orderNumArray[i] == orderNumArray[i-1]){
				flag = false;
			}
		}
	}
	
	
	if(flag == false){
		alert("중복된 신규 노출 순번이 존재합니다.")
		return false;
	}else{
		planSave ();
	}
}

</script>

<form id="basePlaza" name="basePlaza" method="POST">
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">노출 순번 지정</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="40%" />
							<col width="20%" />
							<col width="20%" />
							<col width="20%" />
						</colgroup>
						<tr>
							<th>pp명</th>
							<th>pp코드</th>
							<th>기존노출순번</th>
							<th>신규노출순번</th>
						</tr>
						<c:forEach var="result" items="${dataList}" varStatus="status">
						<tr>
							<td>
								<c:out value="${result.ppname}"/>
							</td>
							<td>
								<c:out value="${result.ppseq}"/>
								<input type="hidden" id="ppSeq" name="tempPpSeq" value="${result.ppseq}">
							</td>
							<td>
								<c:out value="${result.ordernumber}"/>
							</td>
							<td>
								<input type="text" id="orderNumber" name="tempOrderNumber" value="${result.ordernumber}">
							</td>
						</tr>
						</c:forEach>
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:sort();" id="aInsert" class="btn_green">저장</a>
<!-- 					<a href="javascript:planSave();" id="aInsert" class="btn_orange">저장</a> -->
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
