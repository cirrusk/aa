<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	var selectMode = {};

	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

		//저장
		$("#saveBtn").on("click", function (mode, item, idx){
			if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
				return;
			}

			// 저장전 Validation
			if(!confirm("저장하시겠습니까?")){
				return;
			}
			selectMode.mode = "I";
			notePop.doSave(selectMode.mode);
		});

		//수정
		$("#updateBtn").on("click",function(){
			if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
				return;
			}

			if(isNull($("#notecontent").val())) {
				alert("안내문구 값이 없습니다. \n안내문구은(는) 필수 입력값입니다.");
				$("#notecontent").focus();
				return;
			}

			if(!confirm("수정하시겠습니까?")){
				return;
			}
			selectMode.mode = "U";
			notePop.doSave(selectMode.mode);
		});

		// 삭제
		$("#btnDelete").on("click", function(){
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			selectMode.mode = "D";
			notePop.doSave(selectMode.mode);
		});
	});

	var notePop = {
		doSave : function(mode, item, idx){
			if(mode == "I") {
				var sUrl = "<c:url value="/manager/common/noteSet/noteSetInsert.do"/>";
				var sMsg = "등록하였습니다.";
			}else if(mode == "U"){
				sUrl = "<c:url value="/manager/common/noteSet/noteSetUpdate.do"/>";
				sMsg = "수정하였습니다.";
			} else if(mode == "D"){
				sUrl = "<c:url value="/manager/common/noteSet/noteSetDelete.do"/>";
				sMsg = "삭제하였습니다.";
			}

			var param = {
				notesetseq : $("#notesetseq").val(),
				noteservice : $("#noteservice").val(),
				noteitem : $("#noteitem").val(),
				sendtime : $("#sendtime").val(),
				notecontent : $("#notecontent").val()
			};

			$.ajaxCall({
				url: sUrl
				, data: param
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						//return;
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
	<input type="hidden" id="notesetseq" value="${codeDetail.notesetseq}"/>
	<input type="hidden" name="frmId" value="${layerMode.frmId}"/>
	<!--pop_title //-->
	<div class="title clear">
		<h2 class="fl">
			쪽지설정
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
					<c:if test="${layerMode.mode eq 'I' }">쪽지설정등록</c:if>
					<c:if test="${layerMode.mode eq 'U' }">쪽지설정수정/삭제</c:if>
				</h3>
			</div>
			<!--// Sub Title -->
			<form id="saveItem">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th scope="row">서비스 구분</th>
							<td>
								<select id="noteservice" class="required" title="서비스구분">
									<option value="">전체</option>
									<option value="3" ${ codeDetail.noteservice eq "3" ? "selected=\"selected\"" : "" }>쇼핑</option>
									<option value="2" ${ codeDetail.noteservice eq "2" ? "selected=\"selected\"" : "" }>비즈니스</option>
									<option value="1" ${ codeDetail.noteservice eq "1" ? "selected=\"selected\"" : "" }>아카데미</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">발송시기</th>
							<td>
								<input type="text" id="sendtime" value="${codeDetail.sendtime }" class="AXInput required" title="발송시기" maxlength="333" style="min-width:303px;" oninput="maxLengthCheck(this)"/>
								<br/>발송시기를 기입해 주세요. 예시)예약완료시점. 취소완료시점. 1일전. 8일전
							</td>
						</tr>
						<tr>
							<th scope="row">안내문구</th>
							<td>
								<textarea id="notecontent" class="AXTextarea W300" style="height: 100px;" maxlength="666" oninput="maxLengthCheck(this)">${codeDetail.notecontent }</textarea>
							</td>
						</tr>
					</table>
				</div>
			</form>
			<div class="btnwrap mb10">
                <c:if test="${layerMode.mode eq 'I' }">
				    <a href="javascript:;" id="saveBtn" class="btn_green">저장</a>
					&nbsp;
					<button id="closebTn" class="btn_close close-layer" >닫기</button>
				</c:if>
				<c:if test="${layerMode.mode eq 'U' }">
					<a href="javascript:;" id="updateBtn" class="btn_green authWrite">수정</a>
					<a href="javascript:;" id="btnDelete" class="btn_gray authWrite">삭제</a>
					&nbsp;
					<button id="closebTn" class="btn_close close-layer" >닫기</button>
				</c:if>
			</div>
		</div>
	</div>
</div>
