<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	

	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
		
		$("#txtLen").text($("#popMasterMemo").val().length);
// 		$("#popMasterMemo").alphanumericWithSpace();
		
		$("#popMasterMemo").on("keydown", function(e){
			if($("#popMasterMemo").val().length>2000) {
				if(e.keyCode == 8 || e.keyCode == 46) {
					$("#txtLen").text($("#popMasterMemo").val().length);
					return true;
				}
					
				alert("2,000자 내외로 작성 해 주세요.");
				return false;	
			}
			
			$("#txtLen").text($("#popMasterMemo").val().length);
			return true;
		});
	});
	
	function masterMemoSave(){
		var param = {};
		
	 	param = {
	 		 memo   : $("#popMasterMemo").val()
	 		,abo_no : $("#lyAbo_no").val()
	 		,mode   : $("#lyMode").val()
	 	};
	 	
	 	if($("#lyMode").val()=="reference") {
	 		$.extend(param, {giveyear:""
	 			            ,givemonth:""});
				
	 	} else {
	 		$.extend(param, {giveyear:$("#lyGiveYear").val()
	                         ,givemonth:$("#lyGiveMonth").val()});
	 	}
	 	
	 	if(isNull($("#popMasterMemo").val())) {
	 		alert("내용을 입력해 주십시오.")
	 		return;
	 	}
		
	 	$.ajaxCall({
	 		url : "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterMemoUpdateAjax.do"/>",
	 		data : param,
	 		success : function(data, textStatus, jqXHR) {
	 			if (data.result.errCode < 0) {
	 				alert("처리도중 오류가 발생하였습니다.");
	 			}else{
	 				alert("저장 완료 하였습니다.");
	 				$(".btn_close").click();
	 			}
	 		},
	 		error : function(jqXHR, textStatus, errorThrown) {
	 			alert("처리도중 오류가 발생하였습니다.");
	 		}
	 	});
	}
	
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				<c:if test="${layerMode.mode eq 'note'}">메모장</c:if>
				<c:if test="${layerMode.mode ne 'note'}">참고사항</c:if>
			</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<form id="saveItem">
				<input type="hidden" id="lyMode" value="${layerMode.mode}" />
				<input type="hidden" id="lyGiveYear" value="${layerMode.giveyear}" />
				<input type="hidden" id="lyGiveMonth" value="${layerMode.givemonth}" />
				<div class="tbl_write1">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="10%" />
							<col width="40"  />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
 						<c:if test="${layerMode.mode ne 'reference'}">
 						<tr>
 							<th>지급연도</th>
 							<td><span>${memoDetail.giveyear}</span>연도</td> 
 							<th>지급 월</th>
 							<td><span>${memoDetail.givemonth}</span>월</td> 
 						</tr> 
 						</c:if> 
						<tr>
							<th>ABO 번호</th>
							<td>
								<span>
									<c:out value="${memoDetail.abo_no}"/>
									<input type="hidden" id="lyAbo_no" value="${memoDetail.abo_no}">
								</span>
							</td>
							<th scope="row">ABO 성명</th>
							<td>
								<span>
									<c:out value="${memoDetail.abo_name}"/>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">BR</th>
							<td>
								<span>
									<c:out value="${memoDetail.br}"/>
								</span>
							</td>
							<th scope="row">운영그룹</th>
							<td>
								<span>
									<c:out value="${memoDetail.groupcode}"/>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">Code</th>
							<td>
								<span>
									<c:out value="${memoDetail.code}"/>
								</span>
							</td>
							<th scope="row">LOA</th>
							<td>
								<span>
									<c:out value="${memoDetail.loanamekor}"/>
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">C.Pin</th>
							<td>
								<span>
									<c:out value="${memoDetail.groupsname}"/>
								</span>
							</td>
							<th scope="row">Dept</th>
							<td>
								<span>
									<c:out value="${memoDetail.department}"/>
								</span>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<div style="float:right;font-color:red;"><span id="txtLen"></span>/2,000</div>
								<c:if test="${layerMode.mode eq 'reference'}">
 									<textarea id="popMasterMemo" name="popMasterMemo" style="width:100%; height:250px" maxlength="2000" oninput="maxLengthCheck(this)" >${memoDetail.reference}</textarea> 
 								</c:if> 
 								<c:if test="${layerMode.mode ne 'reference'}"> 
 									<textarea id="popMasterMemo" name="popMasterMemo" style="width:100%; height:250px" maxlength="2000" oninput="maxLengthCheck(this)" >${memoDetail.note}</textarea> 
 								</c:if>
							</td>
						</tr>
					</table>
				</div>	
				<div class="btnwrap clear">
					<a href="javascript:masterMemoSave();" id="aInsert" class="btn_green authWrite">등록</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
				</form>	
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
