<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>


<script type="text/javascript">	
//엑셀파일 등록 로직
function saveSubmit(){
	var param = $("#frm").serialize();
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/manage/offline/attend/lmsOfflineMgAttendRegisterExcelAjax.do"/>"
   		, data : param
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
			alert(data.logcontent);
			$("#resultArea").show();
			$("#successCount").html(data.successcount);
			$("#failCount").html(data.failcount);
			$("#logcontent").val( data.logcontent );
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	});
}

	
$(document.body).ready(function(){
	
	
	
	//샘플파일다운 클릭시
	$("#sampleBtn").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
				exceltype : "attendresult"		
			};
			postGoto("<c:url value="/manager/lms/manage/offline/attend/lmsAttendResultSampleExcelDownload.do"/>", initParam);
			hideLoading();
		}
	});	
	
	//등록버튼 클릭시
	$("#btnRegister").on("click", function(){
		
		
		var fileYn = false;
		var fileExt = "";
		$( "input:file" ).each(function( index ){
			if($( this ).val().length>0 ){
				fileYn = true;
				var _lastDot = $( this ).val().lastIndexOf('.');
				fileExt = $( this ).val().substring(_lastDot+1, $( this ).val().length).toLowerCase();
			}
		});
		
		if(!fileYn){
			alert("등록할 엑셀파일을 선택하세요.");
			return;
		}
		if( fileExt != "xlsx" && fileExt != "xls" ) {
			alert("엑셀파일만 입력하세요.");
			return;
		}
		
		if( !confirm("등록한 엑셀파일로 출석결과를 저장하시겠습니까?") ) {
			return;
		}
		
		$("#frm").ajaxForm({
			dataType:"json",
			data:{mode:"excel"},
			url:'/manager/lms/common/lmsFileUploadAjax.do',
			beforeSubmit:function(data, form, option){
				return true;
			},
	        success: function(result, textStatus){
	        	
	        	for(i=0; i<result.length;i++){
	        		$("#"+result[i].fieldName+"file").val(result[i].FileSavedName);
	        	}
	        	saveSubmit();
	        },
	        error: function(){
	           	alert("파일업로드 중 오류가 발생하였습니다.");
	           	return;
	        }
		}).submit();
	});
	
	
	//로그보기 버튼 클릭시
	$("#logBtn").on("click", function(){
		$("#logcontent_area").show();
	});
	
	$("#closeBtn").on("click", function(){
		if( $("#successCount").html() != "0" && $("#successCount").html() != "" ) {
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.reSearch();
		}
		closeManageLayerPopup("attendResultPop");
	});
	
});	
</script>

<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
		<h2 class="fl">출석결과엑셀업로드</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
	
	
	<form id="frm" name="fileform" method="post" enctype="multipart/form-data">
		<input type="hidden" id="courseid"  name="courseid" value="${detail.courseid }">
		<input type="hidden" id="attendregisterexcelfile" name="attendregisterexcelfile" value="" title="" />
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="25%"  />
						<col width="75%" />
					</colgroup>
					<tr>
						<th>과정명</th>
						<td>
							${detail.coursename }
						</td>
					</tr>
					<tr>
						<th>엑셀파일</th>
						<td>
							<input type="file" id="attendregisterexcel" name="attendregisterexcel"  class="required"  accept=".xlsx,.xls" title="첨부파일" style="width:auto; min-width:200px" required="required">
							<a href="javascript:;" id="btnRegister" class="btn_excel">엑셀 업로드</a>
							<a href="javascript:;" id="sampleBtn" class="btn_excel">샘플 다운</a>
						</td>
					</tr>
					<tr>
						<th>업로드 결과</th>
						<td style="height:25px;">
							<span id="resultArea" style="display:none;">
							성공 : <span id="successCount"></span>건, 오류: <span id="failCount"></span>건  <a href="javascript:;" id="logBtn" class="btn_green"> 로그보기</a>
							</span>
						</td>
					</tr>
					<tr id="logcontent_area" style="display:none;">								
						<th>로그내역</th>
						<td style="height:150px;">
							<textarea id="logcontent" name="logcontent" class="AXInput" style="width:90%;height:150px;" readonly="readonly"></textarea>
						</td>
					</tr>
				</table>
				<br/>
				<div align="center">
					<a href="javascript:;" id="closeBtn" class="btn_green">닫기</a>
				</div>
			</div>	
	</form>
	</div>
</div>
</div>
</div>
