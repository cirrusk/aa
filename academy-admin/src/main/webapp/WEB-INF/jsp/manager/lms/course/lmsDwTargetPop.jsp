<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
	
<script type="text/javascript">	
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
var defaultParam = {
	page: 1
};
var saveClick = false;
$(document).ready(function(){
	$("#aExcdlDown").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
				exceltype : "testpool"
			};
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/course/lmsDwTargetPopSampleExcelDownload.do"/>", defaultParam);
			hideLoading();
		}
	});	
	
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
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
		
		if( !confirm("추천조건을 엑셀파일로 등록하겠습니까?") ) {
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
	
	$("#selectLogButton").on("click", function(){
		$("#logcontent_area").show();
	});
	
	$("#closeBtn").on("click", function(){
		if( saveClick ){
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.reSearch();
		}
		closeManageLayerPopup("searchPopup");
	});
	
});
function saveSubmit(){
	var param = $("#frm").serialize();
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/course/lmsDwTargetPopupExcelSaveAjax.do"/>"
   		, data : param
   		, timeout : 1000 * 60 * 10
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
			if( data.result == "E" ) {
				alert("<spring:message code="errors.load"/>");
				return;
			} else if( data.result == "F" ) {
				if( data.logresult == "fail" ) {
					alert("로그를 저장하는 중 오류가 발생하였습니다.");
				} else {
					alert("데이터를 처리하는 중 오류가 발견되었습니다.\n로그를 확인하세요.");
					
					//로그결과 화면에 뿌려주기
					$("#resultArea").show();
					
					$("#successcount").html( data.successcount );
					$("#failcount").html( data.failcount );
					$("#logid").val( data.logid );
					$("#logcontent").val( data.logcontent );
				}
			} else {
				if( data.logresult == "fail" ) {
					alert("로그를 저장하는 중 오류가 발생하였습니다.");
				} else {
					saveClick = true;
					alert("저장이 완료되었습니다.");
					
					//로그결과 화면에 뿌려주기
					$("#resultArea").show();
					
					$("#successcount").html( data.successcount );
					$("#failcount").html( data.failcount );
					$("#logid").val( data.logid );
					$("#logcontent").val( data.logcontent );
				}
			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	});
}
</script>
</head>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">추천조건 엑셀등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer" style="height:150px">
			<form id="frm" name="fileform" method="post" enctype="multipart/form-data">
			<input type="hidden" id="dwtargetexcelfile" name="dwtargetexcelfile" value="" title="" />
			
			<input type="hidden" id="logid" name="logid" title="" value="${logid}" >
			
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>								
							<th>입력연월</th>
							<td>
								<select id="dwyear" name="dwyear" style="width:auto; min-width:100px" >
									<c:forEach var="item" varStatus="status" begin="${baseyear}" end="${endyear}">
										<option value="${status.index}" <c:if test="${thisyear == status.index}">selected</c:if>>${status.index}</option>
									</c:forEach>
								</select>
								<select id="dwmonth" name="dwmonth" style="width:auto; min-width:60px" >
									<c:forEach var="item" varStatus="status" begin="1" end="12">
										<c:set var="monthVal" value="${status.index}"/>
										<c:if test="${status.index < 10}">
											<c:set var="monthVal" value="0${status.index}"/>
										</c:if>
										<option value="${monthVal}" <c:if test="${thismonth == status.index}">selected</c:if>>${monthVal}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>								
							<th>엑셀파일</th>
							<td>
								<input type="file" id="dwtargetexcel" name="dwtargetexcel" title="첨부파일" class="required" accept=".xlsx,.xls" title="첨부파일"/>
								<a href="javascript:;" id="insertBtn" class="btn_excel">엑셀 업로드</a>
								<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">샘플 다운</a>
							</td>
						</tr>
						<tr>								
							<th>업로드결과</th>
							<td style="height:25px;">
								<span id="resultArea" style="display:none;">
									성공: <span id="successcount"></span>, 실패: <span id="failcount"></span>
									<a href="javascript:;" id="selectLogButton" class="btn_green" >로그보기</a>
								</span>
							</td>
						</tr>
						<tr>								
							<th>추천조건</th>
							<td style="height:25px;">
								추천조건 : Y예 / N아니오 
							</td>
						</tr>
						<tr id="logcontent_area" style="display:none;">								
							<th>로그내역</th>
							<td style="height:150px;">
								<textarea id="logcontent" name="logcontent" class="AXInput" style="width:90%;height:150px;" ></textarea>
							</td>
						</tr>
					</table>
					* 입력 데이터가 많은 경우 5만건씩 나누어서 같은 연월을 선택하여 여러번 등록하시기 바랍니다.
				</div>	
				<div align="center">
					<a href="javascript:;" id="closeBtn" class="btn_green">닫기</a>
				</div>						
			</div>
			</form>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</body>