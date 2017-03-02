<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	var selectMode = {};

	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

		$("#commoncodeseq").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
				var inputVal = $(this).val();
				$(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
			}
		});

		//저장
		$("#saveBtn").on("click", function (mode, item, idx){
			// 저장전 Validation
			if(!confirm("저장하시겠습니까?")){
				return;
			}
			if(isNull($("#codename").val())) {
				alert("코드명 값이 없습니다. \n코드명은 필수 입력값입니다.");
				$("#codename").focus();
				return;
			}
			if(isNull($("#commoncodeseq").val())) {
				alert("코드번호 값이 없습니다. \n코드번호는 필수 입력값입니다.");
				$("#commoncodeseq").focus();
				return;
			}
			if(isNull($("input[name='useyn']:checked").val())) {
				alert("사용유무를 선택해 주세요.");
				$("input[name='useyn']").focus();
				return;
			}
			selectMode.mode = "I";
			ststemDePop.doSave(selectMode.mode);
		});

		//수정
		$("#updateBtn").on("click",function(){
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			if(isNull($("#codename").val())) {
				alert("코드명 값이 없습니다. \n코드명은 필수 입력값입니다.");
				$("#codename").focus();
				return;
			}
			if(isNull($("#commoncodeseq").val())) {
				alert("코드번호 값이 없습니다. \n코드번호는 필수 입력값입니다.");
				$("#commoncodeseq").focus();
				return;
			}
			if(isNull($("input[name='useyn']:checked").val())) {
				alert("사용유무를 선택해 주세요.");
				return;
			}
			selectMode.mode = "U";
			ststemDePop.doSave(selectMode.mode);
		});

		// 삭제
		$("#deleteBtn").on("click", function(){
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			selectMode.mode = "D";
			ststemDePop.doSave(selectMode.mode);
		});
	});

	var ststemDePop = {
		doSave : function(mode, item, idx){
			if(mode == "I") {
				var sUrl = "<c:url value="/manager/common/systemCode/systemCodeDetailInsert.do"/>";
				var sMsg = "등록하였습니다.";
			}else if(mode == "U"){
				sUrl = "<c:url value="/manager/common/systemCode/systemCodeDetailUpdate.do"/>";
				sMsg = "수정하였습니다.";
			} else if(mode == "D"){
				sUrl = "<c:url value="/manager/common/systemCode/systemCodeDetailDelete.do"/>";
				sMsg = "삭제하였습니다.";
			}

			var param = {
				codemasterseq : $("#codemasterseq").val(),
				commoncodeseq : $("#commoncodeseq").val(),
				codename : $("#codename").val(),
				codeaccount : $("#codeaccount").val(),
				useyn : $("input[name='useyn']:checked").val(),
				caseone : $("#caseone").val(),
				casetwo : $("#casetwo").val()
			};

			$.ajaxCall({
				url: sUrl
				, data: param
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
					} else if(data.result.errCode == 2) {
						alert("이미 등록된 코드번호가 있습니다.");
					} else {
						var frmId = $("input[name='frmId']").val();
						alert(sMsg);
						eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
						closeManageLayerPopup("searchPopup");
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});
		}
	}

</script>

<div id="popwrap">
	<input type="hidden" id="codemasterseq" name="codemasterseq" value="${layerMode.codemasterseq}">
	<input type="hidden" name="frmId" value="${layerMode.frmId}"/>

	<!--pop_title //-->
	<div class="title clear">
		<h2 class="fl">
			Window
		</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	<!--// pop_title -->

	<!-- Contents -->
	<div id="popcontainer"  style="height:270px">
		<div id="popcontent">
			<!-- Sub Title -->
			<div class="poptitle clear">
				<h3>
					<c:if test="${layerMode.mode eq 'I' }">하위코드등록</c:if>
					<c:if test="${layerMode.mode eq 'U' }">하위코드수정/삭제</c:if>
				</h3>
			</div>
			<!--// Sub Title -->
			<form id="saveItem">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="30%" />
							<col width="70%"  />
						</colgroup>
						<tr>
							<th scope="row">하위코드명</th>
							<td>
								<input type="text" id="codename" value="${codeDetail.codename}"  class="AXInput" maxlength="16" style="min-width:303px;" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">하위코드</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<input type="text" id="commoncodeseq" class="AXInput" style="min-width:303px;" maxlength="20" oninput="maxLengthCheck(this)"/>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${codeDetail.commoncodeseq}
									<input type="hidden" id="commoncodeseq" value="${codeDetail.commoncodeseq}" />
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row">코드설명</th>
							<td>
								<input type="text" id="codeaccount" value="${codeDetail.codeaccount}" class="AXInput" style="min-width:303px;" maxlength="666" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">사용유무</th>
							<td>
								<input type="radio" name="useyn" value="Y" ${ codeDetail.useyn eq "Y" ? "checked=\"checked\"" : "" }/>사용
								<input type="radio" name="useyn" value="N" ${ codeDetail.useyn eq "N" ? "checked=\"checked\"" : "" }/>미사용
							</td>
						</tr>
						<tr>
							<th scope="row">케이스1</th>
							<td>
								<input type="text" id="caseone" value="${codeDetail.caseone}" class="AXInput" style="min-width:203px;" maxlength="16" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">케이스2</th>
							<td>
								<input type="text" id="casetwo" value="${codeDetail.casetwo}" class="AXInput" style="min-width:203px;" maxlength="16" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
					</table>
				</div>
			</form>
			<div class="btnwrap mb10">
				<c:if test="${layerMode.mode eq 'I' }">
					<a href="javascript:;" id="saveBtn" class="btn_green authWrite">저장</a>
					&nbsp;
					<button id="closebTn"  class="btn_close close-layer" >닫기</button>
				</c:if>
				<c:if test="${layerMode.mode eq 'U' }">
					<a href="javascript:;" id="updateBtn" class="btn_green authWrite">수정</a>
					<%--<a href="javascript:;" id="deleteBtn" class="btn_gray">삭제</a>--%>
					&nbsp;
					<button id="closebTn"  class="btn_close close-layer" >닫기</button>
				</c:if>
			</div>
		</div>
	</div>
</div>
