<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

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
			fOnBeforeUnload : function(){
			}
		}, //boolean
		fOnAppLoad : function(){
			//예제 코드
// 			oEditors.getById["ir1"].exec("PASTE_HTML", ["${dtlData.agreetext }"]);
		},
		fCreator: "createSEditor2"
	});
	
});

$("#aInsert").on("click", function(){

	var result = confirm("저장 하시겠습니까?");
	
	//입력여부 체크
	if(!chkValidation({chkId:"#popcontent", chkObj:"hidden|input|select"}) ){
		return;
	}
	
	// console.log($("#ir1").val().trim().length);
	// console.log($("#ir1").val());

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
	
	if(result) {
		$("#reservationType").ajaxForm({
			  url     : "<c:url value="/manager/reservation/baseType/reservationTypeInsertAjax.do"/>"
			, method  : "post"
			, async   : false
			, beforeSend: function(xhr, settings) { showLoading(); }
			, complete: function (xhr, textStatus) { hideLoading(); }
			, success : function(data){
				var frmId = $("input[name='frmId']").val();
				eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
				alert("저장 완료 되었습니다.")
				$(".btn_close").click();
			}, error : function(data){
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		}).submit();
	}

});

</script>

<form id="reservationType" name="reservationType" method="POST">
	
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">타입 등록</h2>
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
							<th>타입 분류</th>
							<td colspan="3">
								<select id="popRsvTypeClassify" name="popRsvTypeClassify" style="width:auto; min-width:100px" class="required" title="타입 분류" >
									<option value="">선택</option>
									<c:forEach var="item" items="${typeClassifyList}">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>타입코드</th>
							<td colspan="3">
								<c:out value="자동생성"/>
							</td>
						</tr>
						
						<tr>
							<th>타입 명</th>
							<td colspan="3">
								<input type="text" id="popRsvTypeName" name="popRsvTypeName" class="required" title="타입명">
							</td>
						</tr>
						
						<tr>
							<th>상태</th>
							<td colspan="3">
								<select id="popRsvUseState" name="popRsvUseState" style="width:auto; min-width:100px" class="required" title="상태">
									<option value="">선택</option>
									<c:forEach var="item" items="${useStateCodeList}">
										<option value="${item.commonCodeSeq}">${item.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</table>
				</div>
				
				<!-- smart edit 2.0 -->
				<div >
					<input type="hidden" name="frmId" value="${layPopData.frmId}" />
					<textarea name="popRsvInfo" id="ir1" style="width:100%; height:250px" ></textarea>
				</div>
<!-- 						<tr> -->
<!-- 							<th>예약 필수 안내</th> -->
<!-- 							<td colspan="3"> -->
<!-- 								<textarea rows="" cols="" id="popRsvInfo" name="popRsvInfo" style="width:799px; height: 275px; min-width:100px" class="required" title="안내 내용"></textarea> -->
<!-- 							</td> -->
<!-- 						</tr> -->
						
						
					
				<div class="btnwrap clear">
					<a href="javascript:;" id="aInsert" class="btn_green">저장</a>
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</form>