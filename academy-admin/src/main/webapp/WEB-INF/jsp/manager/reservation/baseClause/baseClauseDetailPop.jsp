<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<!-- naver smart editor -->
<script type="text/javascript" src="/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
		
<script type="text/javascript">	
var oEditors = [];
$(document).ready(function(){
	// 추가 글꼴 목록
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "ir1",
		sSkinURI: "/se2/SmartEditor2Skin.html",	
		htParams : {
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
// 			aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
			contenteditable : false,
			fOnBeforeUnload : function(){
			}
		}, //boolean
		fOnAppLoad : function(){
			//예제 코드
// 			oEditors.getById["ir1"].exec("PASTE_HTML", ["${dtlData.agreetext }"]);
		},
		fCreator: "createSEditor2"
	});
	$("#aInsert").on("click", function(){
		
		//입력여부 체크
		if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		// 에디터의 내용이 textarea에 적용된다.
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

		var sTxt = $("#ir1").val();
		
		sTxt = sTxt.replace(/<p>/g, "");
		sTxt = sTxt.replace(/<\/p>/g, "");
		sTxt = sTxt.replace(/&nbsp;/g, "");
		sTxt = sTxt.replace(/ /g, '');
	    
		if ( sTxt.length == 0 ) {
			alert("입력 한 내용이 없습니다.");
			return;
		}
		
		
		var result = confirm("수정 하시겠습니까?");
		
// 		var param = $("#baseClause").serialize();
		
		//console.log(param);
		
		if(result) {
			
			$("#baseClause").ajaxForm({
				  url     : "<c:url value="/manager/reservation/baseClause/baseClauseUpdateAjax.do"/>"
				, method  : "post"
				, async   : false
				, beforeSend: function(xhr, settings) { showLoading(); }
				, complete: function (xhr, textStatus) { hideLoading(); }
				, success : function(data){
					var frmId = $("input[name='frmId']").val();
					eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
					alert("수정이 완료 되었습니다.")
					$(".btn_close").click();
				}, error : function(data){
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}
			}).submit();
		}
	});
});

// function baseClauseInsert(){
	
// 	//입력여부 체크
// 	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
// 		return;
// 	}
	
// 	// 에디터의 내용이 textarea에 적용된다.
// 	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

// 	var sTxt = $("#ir1").val();
	
// 	sTxt = sTxt.replace(/<p>/g, "");
// 	sTxt = sTxt.replace(/<\/p>/g, "");
// 	sTxt = sTxt.replace(/&nbsp;/g, "");
// 	sTxt = sTxt.replace(/ /g, '');
    
// 	if ( sTxt.length == 0 ) {
// 		alert("입력 한 내용이 없습니다.");
// 		return;
// 	}
	
	
// 	var result = confirm("수정 하시겠습니까?");
	
// 	var param = $("#baseClause").serialize();
	
// 	//console.log(param);
	
// 	if(result) {
		
// 		$("#baseClause").ajaxForm({
// 			  url     : "<c:url value="/manager/reservation/baseType/baseClauseUpdateAjax.do"/>"
// 			, method  : "post"
// 			, async   : false
// 			, beforeSend: function(xhr, settings) { showLoading(); }
// 			, complete: function (xhr, textStatus) { hideLoading(); }
// 			, success : function(data){
// 				var frmId = $("input[name='frmId']").val();
// 				eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
// 				alert("수정이 완료 되었습니다.")
// 				$(".btn_close").click();
// 			}, error : function(data){
// 				alert("처리도중 오류가 발생하였습니다.");
// 			}
// 		}).submit();
// 	}
// }

</script>

<form id="baseClause" name="baseClause" method="POST">

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">약관 등록</h2>
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
							<th>약관 타입</th>
							<td colspan="3">
								<select id="popClauseTypeCode" name="popClauseTypeCode" style="width:auto; min-width:100px" class="required" title="약관타입" >
									<option value="">선택</option>
									<c:forEach var="item" items="${clauseTypeCodeList}">
										<option value="${item.commonCodeSeq}"  ${item.commonCodeSeq == baseClauseDatail.typecode ? "selected":""}>${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<th>필수 여부</th>
							<td colspan="3">
								<select id="popMandatoryCode" name="popMandatoryCode" style="width:auto; min-width:100px" class="required" title="필수여부" >
									<option value="">선택</option>
									<c:forEach var="item" items="${mandatoryCodeList}">
										<option value="${item.commonCodeSeq}" ${item.commonCodeSeq == baseClauseDatail.mandatorycode ? "selected":""}>${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<th>제목</th>
							<td colspan="3">
								<input type="text" id="popClauseTitle" name="popClauseTitle" class="required" title="약관제목" value="${baseClauseDatail.title}">
							</td>
						</tr>
					</table>	
				</div>
				<div>
					<input type="hidden" name="frmId" value="${layPopData.frmId}" />
					<input type="hidden" name="clauseseq" value="${layPopData.clauseseq}" />
					<textarea name="popClauseContent" id="ir1" style="width:100%; height:250px" readonly="readonly">${baseClauseDatail.content}</textarea>
				</div>
				
				<div class="btnwrap clear">
<!-- 					<a href="javascript:;" id="aInsert" class="btn_orange">저장</a> -->
					<a href="javascript:;" id="aInsertEnd" class="btn_green close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>
