<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	var selectMode = {};

	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

		$("#targetcodeseq").keyup(function(event){
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
			if(isNull($("#targetcodename").val())) {
				alert("코드명 값이 없습니다. \n코드명은 필수 입력값입니다.");
				$("#targetcodename").focus();
				return;
			}
			if(isNull($("#targetcodeseq").val())) {
				alert("코드번호 값이 없습니다. \n코드번호는 필수 입력값입니다.");
				$("#targetcodeseq").focus();
				return;
			}
			if(isNull($("input[name='useyn']:checked").val())) {
				alert("사용유무를 선택해 주세요.");
				$("input[name='useyn']").focus();
				return;
			}
			selectMode.mode = "I";
			targetPop.doSave(selectMode.mode);
		});

		//수정
		$("#updateBtn").on("click",function(){
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			if(isNull($("#targetcodename").val())) {
				alert("코드명 값이 없습니다. \n코드명은 필수 입력값입니다.");
				$("#targetcodename").focus();
				return;
			}
			if(isNull($("#targetcodeseq").val())) {
				alert("코드번호 값이 없습니다. \n코드번호는 필수 입력값입니다.");
				$("#targetcodeseq").focus();
				return;
			}
			if(isNull($("input[name='useyn']:checked").val())) {
				alert("사용유무를 선택해 주세요.");
				return;
			}
			selectMode.mode = "U";
			targetPop.doSave(selectMode.mode);
		});

		// 삭제
		$("#deleteBtn").on("click", function(){
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			selectMode.mode = "D";
			targetPop.doSave(selectMode.mode);
		});
	});

    var targetPop = {
		doSave : function(mode, item, idx){
			if(mode == "I") {
				var sUrl = "<c:url value="/manager/common/targetCode/targetCodeDetailInsert.do"/>";
				var sMsg = "등록하였습니다.";
			}else if(mode == "U"){
				sUrl = "<c:url value="/manager/common/targetCode/targetCodeDetailUpdate.do"/>";
				sMsg = "수정하였습니다.";
			} else if(mode == "D"){
				sUrl = "<c:url value="/manager/common/targetCode/targetCodeDetailDelete.do"/>";
				sMsg = "삭제하였습니다.";
			}

			var param = {
				targetmasterseq : $("#targetmasterseq").val(),
				targetcodeseq : $("#targetcodeseq").val(),
				targetcodename : $("#targetcodename").val(),
				targetcodeaccount : $("#targetcodeaccount").val(),
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
						//return;
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
		<input type="hidden" id="targetmasterseq" value="${layerMode.targetmasterseq}"/>
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
							<th scope="row">하위코드명</th>
							<td>
								<input type="text" id="targetcodename" value="${detail.targetcodename }" class="AXInput" style="min-width:303px;" maxlength="16" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">하위코드</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<input type="text" id="targetcodeseq" value="" class="AXInput" style="min-width:303px;" maxlength="20" oninput="maxLengthCheck(this)"/>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${detail.targetcodeseq}
									<input type="hidden" id="targetcodeseq" value="${detail.targetcodeseq}" />
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row">코드설명</th>
							<td>
								<input type="text" id="targetcodeaccount" value="${detail.targetcodeaccount }" class="AXInput" style="min-width:303px;" maxlength="666" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">사용유무</th>
							<td>
								<input type="radio" name="useyn" value="Y" ${ detail.useyn eq "Y" ? "checked=\"checked\"" : "" }/>사용
								<input type="radio" name="useyn" value="N" ${ detail.useyn eq "N" ? "checked=\"checked\"" : "" }/>미사용
							</td>
						</tr>
						<tr>
							<th scope="row">케이스1</th>
							<td>
								<input type="text" id="caseone" value="${detail.caseone}" class="AXInput" style="min-width:203px;" maxlength="16" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">케이스2</th>
							<td>
								<input type="text" id="casetwo" value="${detail.casetwo}" class="AXInput" style="min-width:203px;" maxlength="16" oninput="maxLengthCheck(this)"/>
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
