<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>
<%-- 
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
	 --%>
<script type="text/javascript">	
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
$(document).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		//입력여부 체크
		if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
			return;
		}
		if(!isEngNumber($("#categorycode").val())){
			alert("분류코드는 영문과 숫자만 가능합니다.");
			return;
		}
		
		if( !confirm("저장 하겠습니까?") ) {
			return;
		}
		
		var param = {
			categoryid :  $("#categoryid").val()
			, categorytype : $("#categorytype").val()
			, categoryname : $("#categoryname").val()
			, categorycode : $("#categorycode").val()
			, categoryupid : $("#categoryupid").val()
			, categorylevel : $("#categorylevel").val()
			, categoryorder : $("#categoryorder").val()
			, openflag : $("input[name='openflag']:checked").val()
			, complianceflag : $("input[name='complianceflag']:checked").val()
			, copyrightflag : $("input[name='copyrightflag']:checked").val()
			, hybrismenu : $("#hybrismenu").val()
			, inputtype : $("#inputtype").val()
       	};
		
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/course/lmsCategorySaveAjax.do"/>"
	   		, data: param
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
   	           		alert("<spring:message code="errors.load"/>");
   	           		return;
   	   			} else if(data.result == 2){
		   			alert("입력한 코드값은 이미 사용중입니다.");
   	   			} else {
   	   				alert("저장이 완료되었습니다.");
   	   				
					$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.fn_selectList();
					closeManageLayerPopup("searchPopup");
   	   			}
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	   		}
	   	});
	});
	
});
</script>
</head>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">교육분류 등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:430px">
			<div id="popcontent">
				<!-- Sub Title -->
				<!-- 
				<div class="poptitle clear">
					<h3>교육분류 등록</h3>
				</div>
				 -->
				<!--// Sub Title -->
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th>분류레벨</th>
							<td>
								LEVEL ${categoryDetail.categorylevel}
								<input type="hidden" id="categorylevel" name="categorylevel" value="${categoryDetail.categorylevel}" /> 
								<input type="hidden" id="categoryid" name="categoryid" value="${categoryDetail.categoryid}" />
								<input type="hidden" id="categorytype" name="categorytype" value="${categoryDetail.categorytype}" />
								<input type="hidden" id="categoryupid" name="categoryupid" value="${categoryDetail.categoryupid}" />
								<input type="hidden" id="inputtype" name="inputtype" value="${categoryDetail.inputtype}" />
								<input type="hidden" id="categoryorder" name="categoryorder" value="${categoryDetail.categoryorder}" />
							</td>
						</tr>				
						<tr>
							<th>분류코드</th>
							<td>
								<input type="text" class="required" id="categorycode" name="categorycode" title="분류코드" style="width:60px;" maxlength="5" value="${categoryDetail.categorycode}"/>
								 * 영문,숫자만 가능하며 중복값을 사용할 수 없습니다.
							</td>
						</tr>									
						<tr>
							<th>분류코드명 </th>
							<td><input type="text" class="required" id="categoryname" name="categoryname" title="분류코드명" maxlength="50" style="width:330px;" value="${categoryDetail.categoryname}"></td>
						</tr>
						<tr>
							<th>상위코드명</th>
							<td>${categoryDetail.upcategoryname} (${categoryDetail.upcategorycode})</td>
						</tr>						
						<tr>
							<th>공개여부</th>
							<td>
								<label class="required"><input name="openflag" type="radio" value="N" <c:if test="${categoryDetail.openflag == 'N'}">checked</c:if> /> 비공개</label>
								<label><input name="openflag" type="radio" value="Y" <c:if test="${categoryDetail.openflag == 'Y'}">checked</c:if> /> 공개</label>
							</td>
						</tr>	
						<tr>
							<th>Compliance</th>
							<td>
								<label class="required"><input name="complianceflag" type="radio" value="N" <c:if test="${categoryDetail.complianceflag=='N'}">checked</c:if> /> 비적용</label>
								<label><input name="complianceflag" type="radio" value="Y" <c:if test="${categoryDetail.complianceflag=='Y'}">checked</c:if> /> 적용</label>
							</td>
						</tr>
						<tr>
							<th>저작권동의</th>
							<td>
								<label class="required"><input name="copyrightflag" type="radio" value="N" <c:if test="${categoryDetail.copyrightflag=='N'}">checked</c:if> /> 비적용</label>
								<label><input name="copyrightflag" type="radio" value="Y" <c:if test="${categoryDetail.copyrightflag=='Y'}">checked</c:if> /> 적용</label>
							</td>
						</tr>
						<tr>
							<th>하이브리스메뉴</th>
							<td><input type="text" id="hybrismenu" name="hybrismenu" style="width:330px;" value="${categoryDetail.hybrismenu}" maxlength="50"></td>
						</tr>
					</table>
				</div>	
 		
				<div align="center">
					<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
				</div>						
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
