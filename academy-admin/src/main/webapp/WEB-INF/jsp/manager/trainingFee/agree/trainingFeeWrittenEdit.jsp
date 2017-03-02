<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

$(document).ready(function(){
	if($("#type").val()=="insert") {
		var oEditors = [];
		// 추가 글꼴 목록
	// 	var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
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
			},
			fCreator: "createSEditor2"
		});
	}
	
	$("#aInsert").on("click", function(){
		if(!chkValidation({chkId:"#popcontent", chkObj:"hidden|input|select"}) ){
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
		
	    $("#editor").ajaxForm({
			  url     : "<c:url value="/manager/trainingFee/agree/saveWrittenEdit.do"/>"
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
				alert("처리도중 오류가 발생하였습니다.");
			}
		}).submit();
	});
	
});
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">교육비 약관</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<div id="popcontainer">
			<div id="popcontent">
				<form id="editor" name="editor" method="post">
				<div class="tbl_write">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<tr>
							<th scope="row">회계연도</th>
							<td>
								<span>${layPopData.fiscalyear }</span>
							</td>
							<th scope="row">약관종류</th>
							<td scope="row">
								<span>${layPopData.agreetypename }</span>
							</td>
						</tr>
						<tr>
							<th scope="row">약관제목</th>
							<td colspan="3">
								<c:if test="${layPopData.type eq 'list' }">
									<span>${dtlData.agreetitle }</span>
								</c:if>
								<c:if test="${layPopData.type eq 'insert' }">
									<input type="text" title="약관제목" name="agreetitle" class="required" style="width:90%; min-width:100px" value="${dtlData.agreetitle }" />
								</c:if>
							</td>
						</tr>
					</table>
				</div>
				<!-- smart edit 2.0 -->
				<div>
					<input type="hidden" id="type" name="type" value="${layPopData.type }" />
					<input type="hidden" name="fiscalyear" value="${layPopData.fiscalyear }" />
					<input type="hidden" name="delegtypecode" value="${layPopData.delegtypecode }" />
					<input type="hidden" name="frmId" value="${layPopData.frmId }" />
					<input type="hidden" name="agreetypecode" style="width:auto; min-width:100px" value="${layPopData.agreetypecode }" />
					<c:if test="${layPopData.type eq 'insert' }">
						<textarea name="agreetext" id="ir1" style="width:100%; height:250px" ></textarea>
					</c:if>
					<c:if test="${layPopData.type eq 'list' }">
						<p>${dtlData.agreetext }</p>
					</c:if>
				</div>
			</form>
			</div>
			
			<div class="btnwrap clear">
				<c:if test="${layPopData.type eq 'insert' }">
				<a href="javascript:;" id="aInsert" class="btn_green">등록</a>
				</c:if>
				<a href="javascript:;" class="btn_gray close-layer" >닫기</a>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
