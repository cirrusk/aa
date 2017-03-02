<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->


<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//권한 변수
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;

$(document).ready(function(){

	$("#insertBtn").on("click", function(){
		//권한 체크 함수
		if(checkManagerAuth(managerMenuAuth)){return;}
		
		imageSubmit();
	});
	
	$(".stamptype").on("click", function(){
		stampTypeChanged($(this).val());
	});
	var stamptypeVal = $("input:radio[name='stamptype']:checked").val();
	stampTypeChanged(stamptypeVal);
	
	$(".pintype").on("click", function(){
		pinTypeChanged($(this).val());
	});
});
function stampTypeChanged(str){
	if(str == "U"){
		$("#pintypeTr").show();
		var pinptypeVal = $("input:radio[name='pintype']:checked").val();
		pinTypeChanged(pinptypeVal);
	}else{
		$("#pintypeTr").hide();
		$("#bonuslevelTr").hide();
		$("#pinlevelTr").hide();
	}
}
function pinTypeChanged(str){
	if(str == "B"){
		$("#bonuslevelTr").show();
		$("#pinlevelTr").hide();
	}else{
		$("#bonuslevelTr").hide();
		$("#pinlevelTr").show();
	}
}
function imageSubmit(){
	// 저장전 Validation
	if(!confirm("스탬프정보를 저장하시겠습니까?")){
		return;
	}
	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
		return;
	}
	if($("#onimagefile").val().length<1 && $("#onimage").val().length<1){
		alert("스탬프이미지를 등록해 주세요.");
		return;
	}	
	if($("#offimagefile").val().length<1 && $("#offimage").val().length<1){
		alert("스탬프이미지(배경)을 등록해 주세요.");
		return;
	}	
	if($("#stampcontent").val().length>100){
		alert("속성을 100자 이내로 입력해 주세요.");
		return;
	}
	
	var fileYn = false;
	$( "input:file" ).each(function( index ){
		if($( this ).val().length>0 ){
			fileYn = true;
		}
	});
	if(!fileYn){
		saveSubmit();
		return;
	}
	$("#frm").ajaxForm({
		dataType:"json",
		data:{mode:"stamp"},
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
   		url : "<c:url value="/manager/lms/advantage/lmsStampSaveAjax.do"/>"
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
</script>
</head>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">스탬프 등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->

		<!-- Contents -->
		<div id="popcontainer"  style="height:800px">
			<div id="popcontent">
				<div class="tbl_write">
					<form id="frm" name="frm" method="post">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<input type="hidden" id="stampid" name="stampid" value="${detail.stampid}" />
						<input type="hidden" id="onimagefile" name="onimagefile" value="${detail.onimage}" title="스탬프이미지" />
						<input type="hidden" id="offimagefile" name="offimagefile" value="${detail.offimage}" title="스탬프이미지(배경)" />
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th>구분</th>
							<td>
								<label class="required"><input type="radio" id="stamptype1" name="stamptype" value="N"  class="AXInput required stamptype" title="구분" <c:if test="${ detail.stamptype eq 'N' or empty detail.stamptype}">checked</c:if>> 일반</label> &nbsp;&nbsp;
								<label><input type="radio" id="stamptype2" name="stamptype" value="C"  class="AXInput required stamptype" title="구분" <c:if test="${ detail.stamptype eq 'C' }">checked</c:if>> 정규과정</label> &nbsp;&nbsp;
								<%-- <label><input type="radio" id="stamptype3" name="stamptype" value="U"  class="AXInput required stamptype" title="구분" <c:if test="${ detail.stamptype eq 'U' }">checked</c:if>> 목표달성</label> --%>
							</td>
						</tr>				
						<tr id="pintypeTr" style="display:none">
							<th>핀구분</th>
							<td>
								<label class="required"><input type="radio" id="pintype1" name="pintype" value="B"  class="AXInput required pintype" title="핀구분" <c:if test="${ detail.pintype eq 'B' or empty detail.pintype }">checked</c:if>> 보너스</label> &nbsp;&nbsp;
								<label><input type="radio" id="pintype2" name="pintype" value="P"  class="AXInput required pintype" title="핀구분" <c:if test="${ detail.pintype eq 'P' }">checked</c:if>> 핀</label>
							</td>
						</tr>	
						<tr id="bonuslevelTr" style="display:none">
							<th>보너스레벨</th>
							<td>
								<select id="bonuscode" name="bonuscode" style="width:auto; min-width:160px" title="보너스레벨">
									<option value="">선택</option>
									<c:forEach items="${bonusList}" var="items">
										<option value="${items.commoncodeseq}" <c:if test="${bonuscode == items.commoncodeseq}">selected</c:if>>${items.codename}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr id="pinlevelTr" style="display:none">
							<th>핀레벨</th>
							<td>
								<select id="pincode" name="pincode" style="width:auto; min-width:160px"  title="핀레벨" >
									<option value="">선택</option>
									<c:forEach items="${pinList}" var="items">
										<option value="${items.commoncodeseq}" <c:if test="${pincode == items.commoncodeseq}">selected</c:if>>${items.codename}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>스탬프명</th>
							<td><input type="text" id="stampname" name="stampname" style="width:90%;" value="${detail.stampname}" class="AXInput required" maxlength="50" title="스탬프명"></td>
						</tr>
						<tr>
							<th>획득조건</th>
							<td><input type="text" id="stampcondition" name="stampcondition" style="width:90%;" value="${detail.stampcondition}" class="AXInput required" maxlength="50" title="획득조건"></td>
						</tr>
						<tr>
							<th>스탬프이미지</th>
							<td>
								<div id="onimageView" style="width:140px;height:80px;float:left;">
								<c:if test="${empty detail.onimage}">이미지</c:if>
								<c:if test="${not empty detail.onimage}"><img src="/manager/lms/common/imageView.do?file=${detail.onimage}&mode=stamp" width="120" style="max-height:80px;"></c:if>
								</div>
								<input type="file" id="onimage" name="onimage" accept="image/*" onchange="getThumbnailPrivew(this,$('#onimageView'), 120 );" title="스탬프이미지">
								<input type="text" id="onimagenote" name="onimagenote" style="width:60%;" value="${detail.onimagenote}" class="AXInput required" maxlength="25" title="스탬프이미지제목">
							</td>
						</tr>
						<tr>
							<th>스탬프이미지(배경)</th>
							<td>
								<div id="offimageView" style="width:140px;height:80px;float:left;">
								<c:if test="${empty detail.offimage}">이미지</c:if>
								<c:if test="${not empty detail.offimage}"><img src="/manager/lms/common/imageView.do?file=${detail.offimage}&mode=stamp" width="120" style="max-height:80px;"></c:if>
								</div>
								<input type="file" id="offimage" name="offimage" accept="image/*" onchange="getThumbnailPrivew(this,$('#offimageView'), 120 );" title="스탬프이미지(배경)">
								<input type="text" id="offimagenote" name="offimagenote" style="width:60%;" value="${detail.offimagenote}" class="AXInput required" maxlength="25" title="스탬프이미지(배경)제목">
							</td>
						</tr>
						<tr>
							<th>속성</th>
							<td><textarea id="stampcontent" name="stampcontent" class="AXInput" style="width:90%;height:100px;" title="속성">${detail.stampcontent}</textarea></td>
						</tr>						
					</table>
				</form>
				</div>	
 		
				<div align="center">
					<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>&nbsp;&nbsp;
					<a href="javascript:;" id="cancelBtn" class="btn_green close-layer">취소</a>
				</div>						
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
</body>