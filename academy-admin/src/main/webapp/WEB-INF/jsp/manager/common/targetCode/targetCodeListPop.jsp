<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	var selectMode = {};

	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

		$("#targetmasterseq").keyup(function(event){
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
			if(isNull($("#targetmasterseq").val())) {
				alert("코드분류 값이 없습니다. \n코드분류는 필수 입력값입니다.");
				$("#targetmasterseq").focus();
				return;
			}
			if(isNull($("#targetmastername").val())) {
				alert("코드분류명 값이 없습니다. \n코드분류명은 필수 입력값입니다.");
				$("#targetmastername").focus();
				return;
			}

			selectMode.mode = "I";
			targetDePop.doSave(selectMode.mode);
		});

		//수정
		$("#updateBtn").on("click",function(){
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			if(isNull($("#targetmasterseq").val())) {
				alert("코드분류 값이 없습니다. \n코드분류는 필수 입력값입니다.");
				$("#targetmasterseq").focus();
				return;
			}
			if(isNull($("#targetmastername").val())) {
				alert("코드분류명 값이 없습니다. \n코드분류명은 필수 입력값입니다.");
				$("#targetmastername").focus();
				return;
			}
			selectMode.mode = "U";
			targetDePop.doSave(selectMode.mode);
		});

		// 삭제
		$("#deleteBtn").on("click", function(){
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			selectMode.mode = "D";
			targetDePop.doSave(selectMode.mode);
		});
	});

  	var targetDePop = {
		doSave : function(mode, item, idx){
			if(mode == "I") {
				var sUrl = "<c:url value="/manager/common/targetCode/targetCodeInsert.do"/>";
				var sMsg = "등록하였습니다.";
			}else if(mode == "U"){
				sUrl = "<c:url value="/manager/common/targetCode/targetCodeUpdate.do"/>";
				sMsg = "수정하였습니다.";
			} else if(mode == "D"){
				sUrl = "<c:url value="/manager/common/targetCode/targetCodeDelete.do"/>";
				sMsg = "삭제하였습니다.";
			}

			var param = {
				targetmasterseq : $("#targetmasterseq").val(),
				targetmastername : $("#targetmastername").val(),
				targetmasteraccount : $("#targetmasteraccount").val()
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
						alert("이미 등록된 하위코드가 있습니다.");
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
						<tr>
							<th scope="row">업무구분</th>
							<td>
							<label>
                                대상자
                            </label>
							</td>
						</tr>
						<tr>
							<th scope="row">코드분류</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<input type="text" id="targetmasterseq" class="AXInput" style="min-width:303px;" maxlength="20" oninput="maxLengthCheck(this)"/>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${targetDetail.targetmasterseq }
									<input type="hidden" id="targetmasterseq" value="${targetDetail.targetmasterseq }" class="AXInput" style="min-width:303px;"/>
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row">코드분류명</th>
							<td>
								<input type="text" id="targetmastername" value="${targetDetail.targetmastername }" class="AXInput" style="min-width:303px;" maxlength="16" oninput="maxLengthCheck(this)"/>
							</td>
						</tr>
						<tr>
							<th scope="row">코드분류설명</th>
							<td>
								<input type="text" id="targetmasteraccount" value="${targetDetail.targetmasteraccount }" class="AXInput" style="min-width:303px;" maxlength="666" oninput="maxLengthCheck(this)"/>
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
