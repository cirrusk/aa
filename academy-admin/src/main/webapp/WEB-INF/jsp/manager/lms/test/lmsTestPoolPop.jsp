<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>
<script type="text/javascript">	
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
$(document).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		//입력여부 체크
		if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
			return;
		}
		
		if( !confirm("저장 하겠습니까?") ) {
			return;
		}
		
		var param = {
			categoryid :  $("#categoryid").val()
			, categoryname : $("#categoryname").val()
			, inputtype : $("#inputtype").val()
       	};
		
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/test/lmsTestPoolSaveAjax.do"/>"
	   		, data: param
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
   	           		alert("<spring:message code="errors.load"/>");
   	           		return;
   	   			} else {
   	   				alert("저장이 완료되었습니다.");
   	   				
					$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.listRefresh();
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

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">문제분류 등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:150px">
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
							<th>분류코드명 </th>
							<td>
								<input type="hidden" id="categoryid" name="categoryid" title="" value="${detail.categoryid}" >
								<input type="hidden" id="inputtype" name="inputtype" title="" value="${detail.inputtype}" >
								
								<input type="text" class="required" id="categoryname" name="categoryname" title="분류코드명" maxlength="50" style="width:330px;" value="${detail.categoryname}" >
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
	</div>
	<!--// Edu Part Cd Info -->
