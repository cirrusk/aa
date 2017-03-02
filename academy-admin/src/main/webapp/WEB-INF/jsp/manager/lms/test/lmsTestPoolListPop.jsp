<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>
<script type="text/javascript">	
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
function fn_change( typeVal ) {
	for(var i=1; i<=10; i++) {
		if( typeVal == "1" ) {
			$("#testpoolanswerseqRadio_"+i).show();	
			$("#testpoolanswerseqCheckbox_"+i).hide();
		} else {
			$("#testpoolanswerseqRadio_"+i).hide();	
			$("#testpoolanswerseqCheckbox_"+i).show();
		}
	}
}
function imageSubmit(){
	// 저장전 Validation
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
		return;
	}
	if( isNull($("#testpoolnote").val()) ){
		alert("문제지문을 입력하세요.");
		return;
	}
	
	//보기 확인 및 보기 답안 확인
	//선일, 선다형의 경우 보기 입력여부 확인 및 정답 체크 여부 확인
	//주관식의 경우 모범답안 입력 여부 확인
	if( $("#answertype").val() == "1" || $("#answertype").val() == "2" ) {
		var answercount = $("#answercount").val();
		for(var i=1; i<=answercount; i++) {
			if( isNull($("#testpoolanswername_"+i).val()) ){
				alert("보기를 입력하세요.");
				return;
			}
		}
		
		var answerChkCnt = 0;
		if( $("#answertype").val() == "1" ) {
			for(var i=1; i<=answercount; i++) {
				if( $("#testpoolanswerseqRadio_"+i+":checked").val() ) {
					answerChkCnt ++;
				}
			}
		} else {
			for(var i=1; i<=answercount; i++) {
				if( $("#testpoolanswerseqCheckbox_"+i+":checked").val() ) {
					answerChkCnt ++;
				}
			}
		}
		
		if(answerChkCnt<1) {
			alert("정답을 선택하세요.");
			return;
		}
		
	}  else {
		if( isNull($("#subjectanswer").val()) ){
			alert("모범답안을 입력하세요.");
			return;
		}
	}
	
	var fileYn = false;
	var fileChk = true;
	$( "input:file" ).each(function( index ){
		if($( this ).val().length>0 ){
			fileYn = true;
			var _lastDot = $( this ).val().lastIndexOf('.');
			var fileExt = $( this ).val().substring(_lastDot+1, $( this ).val().length).toLowerCase();
			if( fileExt != "jpg" && fileExt != "gif" && fileExt != "png" ) {
				fileChk = false;
				alert("이미지 파일(jpg,gif,png)만 입력하세요.");
				return;
			}
		}
	});
	
	if( !fileChk ) {
		return;
	}
	
	if(!confirm("문제를 저장하겠습니까?")){
		return;
	}
	
	if(!fileYn){
		saveSubmit();
		return;
	}
	
	$("#frm").ajaxForm({
		dataType:"json",
		data:{mode:"test"},
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
}
function saveSubmit(){
	var param = $("#frm").serialize();
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/test/lmsTestPoolListSaveAjax.do"/>"
   		, data : param
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
   			if(data.cnt < 1){
           		alert("처리도 중 오류가 발생하였습니다.");
           		return;
   			} else {
				alert("저장이 완료되었습니다.");
				$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.listRefresh();
				closeManageLayerPopup("searchPopup");
				return;
   			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	});
}


$(document).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		imageSubmit();
	});
	
	$("#answertype").on("change", function(){
		//주관식은 모범답안 보이도록 처리함
		if( $("#answertype").val() == "1" ) {
			$("#tblObj").show();
			$("#tblSub").hide();
			
			fn_change("1");
		} else if( $("#answertype").val() == "2" ) {
			$("#tblObj").show();
			$("#tblSub").hide();
			
			fn_change("2");
		} else {
			$("#tblObj").hide();
			$("#tblSub").show();
		}
	});
	
	$("#answercount").on("change", function(){
		var answercountVal = $("#answercount").val(); 
		for(var i=1; i<=10; i++) {
			if( i <= answercountVal ) {
				$("#answerlist_"+i).show();
			} else {
				$("#answerlist_"+i).hide();
			}
		}
	});
});
</script>
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">문제등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
<form id="frm" name="frm" method="post">
<input type="hidden" id="testpoolimagefile" name="testpoolimagefile" value="${detail.testpoolimage}" title="스탬프이미지" />
		<div id="popcontainer"  style="height:800px">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3>문제 기본정보</h3>
				</div>
				<!--// Sub Title -->
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th>문제유형 </th>
							<td>
								<input type="hidden" id="testpoolid" name="testpoolid" title="" value="${detail.testpoolid}" >
								<input type="hidden" id="categoryid" name="categoryid" title="" value="${detail.categoryid}" >
								<input type="hidden" id="inputtype" name="inputtype" title="" value="${detail.inputtype}" >
								
								<select id="answertype" name="answertype" class="required" style="width:auto; min-width:100px" >
									<c:forEach var="codeList" items="${answerTypeList}" varStatus="idx">
										<option value="${codeList.value}" <c:if test="${codeList.value == detail.answertype}">selected</c:if> >${codeList.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>상태</th>
							<td>
								<select id="useflag" name="useflag" class="required" style="width:auto; min-width:100px" >
									<c:forEach var="codeList" items="${useList}" varStatus="idx">
										<option value="${codeList.value}" <c:if test="${codeList.value == detail.useflag}">selected</c:if> >${codeList.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>문제명(관리용)</th>
							<td>
								<input type="text" id="testpoolname" name="testpoolname" class="required" title="문제명(관리용)" style="width:auto; min-width:500px" maxlength="50" value="${detail.testpoolname}">
							</td>
						</tr>
						<tr>
							<th>문제지문</th>
							<td>
								<textarea id="testpoolnote" name="testpoolnote" class="required AXInput" style="width:90%;height:100px;" title="문제지문">${detail.testpoolnote}</textarea>
							</td>
						</tr>
						<tr>
							<th>문제이미지</th>
							<td>
								<div id="testpoolimageView" style="width:140px;height:80px;float:left;">
								<c:if test="${empty detail.testpoolimage}">이미지</c:if>
								<c:if test="${not empty detail.testpoolimage}"><img src="/manager/lms/common/imageView.do?file=${detail.testpoolimage}&mode=test" width="120" style="max-height:80px;"></c:if>
								</div>
								<input type="file" id="testpoolimage" name="testpoolimage" accept=".jpg,.gif,.png" onchange="getThumbnailPrivew(this,$('#testpoolimageView'), 120, 80 );" title="문제이미지">
								<br><span style="padding-right:5px;">이미지설명</span><input type="text" id="testpoolimagenote" name="testpoolimagenote" style="width:60%;" value="${detail.testpoolimagenote}" class="AXInput" maxlength="25" title="문제이미지설명">
							</td>
						</tr>
					</table>
				</div>
				
				<div class="poptitle clear">
					<h3>문제 답변정보</h3>
				</div>
				<div class="tbl_write">
					<table id="tblObj" <c:if test="${detail.answertype == '3'}">style="display:none;"</c:if> width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th>보기수</th>
							<td>
								<select id="answercount" name="answercount" class="required" style="width:auto; min-width:80px" >
									<c:forEach var="codeList" varStatus="idx" begin="2" end="10">
										<option value="${codeList}" <c:if test="${codeList == detail.answercount}">selected</c:if> >${codeList}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>보기</th>
							<td>
								<table id="tblObjAnswer" class="required" width="100%" border="0" cellspacing="0" cellpadding="0">
									<colgroup>
										<col width="10%" />
										<col width="90%"  />
									</colgroup>
									<tr>
										<th style="text-align:center;">정답</th>
										<th style="text-align:center;">보기</th>
									</tr>
									<c:forEach var="dataList" items="${dataList}" varStatus="idx">
									<tr id="answerlist_${idx.count}" <c:if test="${dataList.testpoolanswerdisplay == 'N'}">style="display:none;"</c:if> >
										<td style="text-align:center;">
											<input type="radio" id="testpoolanswerseqRadio_${idx.count}" name="testpoolanswerseqRadio" value="${dataList.testpoolanswerseq}" <c:if test="${detail.answertype != '1' }">style="display:none;"</c:if> <c:if test="${dataList.answercheck == 'Y' }">checked</c:if> />
											<input type="checkbox" id="testpoolanswerseqCheckbox_${idx.count}" name="testpoolanswerseqCheckbox" value="${dataList.testpoolanswerseq}" <c:if test="${detail.answertype != '2' }">style="display:none;"</c:if> <c:if test="${dataList.answercheck == 'Y' }">checked</c:if> />
										</td>
										<td>
											<input type="text" id="testpoolanswername_${idx.count}" name="testpoolanswername" style="width:auto; min-width:500px" maxlength="50" value="${dataList.testpoolanswername}" />
										</td>
									</tr>
									</c:forEach>
								</table>
							</td>
						</tr>
					</table>
					
					<table id="tblSub" <c:if test="${detail.answertype != '3'}">style="display:none;"</c:if> width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th>모범답안</th>
							<td>
								<textarea id="subjectanswer" name="subjectanswer" class="required AXInput" style="width:90%;height:100px;" title="모범답안">${detail.subjectanswer}</textarea>
							</td>
						</tr>
					</table>
				</div>	
 		
				<div align="center">
					<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
				</div>						
			</div>
		</div>
</form>		
	</div>
	<!--// Edu Part Cd Info -->
