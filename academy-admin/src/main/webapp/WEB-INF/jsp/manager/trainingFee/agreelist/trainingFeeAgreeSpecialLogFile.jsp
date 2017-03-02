<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">	

$(document).ready(function(){
	
});
function fileUpLoad(){
	showLoading();
	
	var result = confirm("Special 위임 파일을 저장 하시겠습니까?");
	
	if(result){
		$("#fileUpload").ajaxForm({
		  	  url : "<c:url value="/manager/trainingFee/agreelist/fileUpLoad.do"/>"
		  	, type : "json"
		    , method : "post"
			, async : false
			, success : function(data){
				hideLoading();	//로딩 끝
				alert("파일 저장 완료");
				eval($('#ifrm_main_'+"${lyData.frmId}").get(0).contentWindow.trainingFeeSpecialLog.doSearch({page:1}));
				closeManageLayerPopup("searchPopup");
			}
			, error : function(data){
				hideLoading();	//로딩 끝
				alert("[파일업로드] 처리도중 오류가 발생하였습니다.");
			}
		}).submit();
	} else {
		hideLoading();	//로딩 끝
	}
}
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">Special 위임 Proposal 파일업로드</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer">
			<div id="popcontent">
				<form id="fileUpload" name="fileUpload" method="post" enctype="multipart/form-data">
				<div class="tbl_write1">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="10%" />
							<col width="*"  />
						</colgroup>
						<tr>
							<th>회계연도</th>
							<td><input type="text" id="searchGiveYear" name="fiscalyear" class="AXInput datepYear setFiscalYear" readonly="readonly">
							</td>
						</tr>
						<tr>
							<th>파일등록</th>
							<td><input type="file" name="attachfile" value="" accept="image/*;capture=camera" />
							</td>
						</tr>
					</table>
				</div>
				<div class="btnwrap clear">
					<a href="javascript:fileUpLoad();" id="aInsert" class="btn_green">등록</a>
					<a href="javascript:;" class="btn_gray close-layer" >닫기</a>
				</div>
				</form>
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
