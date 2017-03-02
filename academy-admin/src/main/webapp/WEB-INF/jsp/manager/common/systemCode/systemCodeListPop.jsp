<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	var selectMode = {};

	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

		$("#codemasterseq").keyup(function(event){
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
			if(!$("[name=gubun]").is(":checked")){
				alert("업무구분 값이 없습니다. \n업무구분은 필수 입력값입니다.");
				return;
			}
			if(isNull($("#codemasterseq").val())) {
				alert("코드분류 값이 없습니다. \n코드분류는 필수 입력값입니다.");
				$("#codemasterseq").focus();
				return;
			}
			if(isNull($("#codemastername").val())) {
				alert("코드분류명 값이 없습니다. \n코드분류명은 필수 입력값입니다.");
				$("#codemastername").focus();
				return;
			}

			selectMode.mode = "I";
			systemPop.doSave(selectMode.mode);
		});

		//수정
		$("#updateBtn").on("click",function(){
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			if(!$("[name=gubun]").is(":checked")){
				alert("업무구분 값이 없습니다. \n업무구분은 필수 입력값입니다.");
				return;
			}
			if(isNull($("#codemasterseq").val())) {
				alert("코드분류 값이 없습니다. \n코드분류는 필수 입력값입니다.");
				$("#codemasterseq").focus();
				return;
			}
			if(isNull($("#codemastername").val())) {
				alert("코드분류명 값이 없습니다. \n코드분류명은 필수 입력값입니다.");
				$("#codemastername").focus();
				return;
			}
			selectMode.mode = "U";
			systemPop.doSave(selectMode.mode);
		});

		// 삭제
		$("#btnDelete").on("click", function(){
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			selectMode.mode = "D";
			systemPop.doSave(selectMode.mode);
		});
	});

	var systemPop = {
		doSave : function(mode, item, idx){
			if(mode == "I") {
				var sUrl = "<c:url value="/manager/common/systemCode/systemCodeInsert.do"/>";
				var sMsg = "등록하였습니다.";
			}else if(mode == "U"){
				sUrl = "<c:url value="/manager/common/systemCode/systemCodeUpdate.do"/>";
				sMsg = "수정하였습니다.";
			} else if(mode == "D"){
				sUrl = "<c:url value="/manager/common/systemCode/systemCodeDelete.do"/>";
				sMsg = "삭제하였습니다.";
			}

			var workscope = "";
			if($("#workcmm").is(':checked')){
				workscope = $("#workcmm").val();
			}
			if($("#worklms").is(':checked')){
				if($("#workcmm").is(':checked')) {
					workscope += ',' + $("#worklms").val();
				} else {
					workscope = $("#worklms").val();
				}
			}
			if($("#workrsv").is(':checked')){
				if($("#worklms").is(':checked') || $("#workcmm").is(':checked')) {
					workscope += ',' + $("#workrsv").val();
				} else {
					workscope = $("#workrsv").val();
				}
			}
			if($("#workfee").is(':checked')){
				if($("#workrsv").is(':checked') || $("#worklms").is(':checked') || $("#workcmm").is(':checked')) {
					workscope += ',' + $("#workfee").val();
				} else {
					workscope = $("#workfee").val();
				}
			}

			var param = {
				codemasterseq : $("#codemasterseq").val(),
				codemastername : $("#codemastername").val(),
				workscope : workscope,
				codemasteraccount : $("#codemasteraccount").val()
			};

			$.ajaxCall({
				url: sUrl
				, data: param
				, success: function( data, textStatus, jqXHR){
					if(data.result.errCode < 0){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
					} else if(data.result.errCode == 2) {
						alert("이미 등록된 하위코드가 있습니다.");
					} else {
						var frmId = $("input[name='frmId']").val();
						alert(sMsg);
						eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
						closeManageLayerPopup("searchPopup");
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
				}
			});
		}
	}

</script>

<div id="popwrap">
	<form:form id="listForm" name="listForm" method="post">
		<input type="hidden" name="frmId" value="${layerMode.frmId}"/>
	</form:form>
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
					<c:if test="${layerMode.mode eq 'I' }">코드분류등록</c:if>
					<c:if test="${layerMode.mode eq 'U' }">코드분류수정/삭제</c:if>
				</h3>
			</div>
			<!--// Sub Title -->
			<form id="saveItem">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="30%" />
							<col width="70%" />
						</colgroup>
						<tr>
							<th scope="row">업무구분</th>
							<td>
								<label>
									<input type="checkbox" id="workcmm" name="gubun" value="CMM" ${ codeDetail.workcmm eq "CMM" ? "checked=\"checked\"" : "" }/>
									공통
								</label>
							   	<label>
									<input type="checkbox" id="worklms" name="gubun" value="LMS" ${ codeDetail.worklms eq "LMS" ? "checked=\"checked\"" : "" }/>
								   	교육
							   	</label>
							   	<label>
									<input type="checkbox" id="workrsv" name="gubun" value="RSV" ${ codeDetail.workrsv eq "RSV" ? "checked=\"checked\"" : "" }/>
								   	교육장예약
							   	</label>
							   	<label>
								   	<input type="checkbox" id="workfee" name="gubun" value="FEE" ${ codeDetail.workfee eq "FEE" ? "checked=\"checked\"" : "" }/>
								   	교육비
							   	</label>
							</td>
						</tr>
						<tr>
							<th scope="row">코드분류</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<input type="text" id="codemasterseq" class="AXInput" style="min-width:303px;" maxlength="20" oninput="maxLengthCheck(this)"/>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${codeDetail.codemasterseq }
									<input type="hidden" id="codemasterseq" value="${codeDetail.codemasterseq }"/>
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row">코드분류명</th>
							<td>
								<input type="text" id="codemastername" value="${codeDetail.codemastername }" class="AXInput" style="min-width:303px;" maxlength="16" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">코드분류설명</th>
							<td>
								<input type="text" id="codemasteraccount" value="${codeDetail.codemasteraccount }" class="AXInput" style="min-width:303px;" maxlength="666" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
					</table>
				</div>
			</form>
			<div class="btnwrap mb10">
                <c:if test="${layerMode.mode eq 'I' }">
				    <a href="javascript:;" id="saveBtn" class="btn_green authWrite">저장</a>
					&nbsp;
					<button id="closebTn" class="btn_close close-layer" >닫기</button>
				</c:if>
				<c:if test="${layerMode.mode eq 'U' }">
					<a href="javascript:;" id="updateBtn" class="btn_green authWrite">수정</a>
					<%--<a href="javascript:;" id="btnDelete" class="btn_gray">삭제</a>--%>
					&nbsp;
					<button id="closebTn" class="btn_close close-layer" >닫기</button>
				</c:if>
			</div>
		</div>
	</div>
</div>
