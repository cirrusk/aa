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
	if($("#coursetype").val() == "V"){
		$("#coursetypenametitle").text("설문명");
		$("#edudatetitle").html("설문기간<i>*</i>");
	}
	
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		//입력여부 체크
		if(!chkValidation({chkId:"#frm", chkObj:"hidden|input|select"}) ){
			return;
		}
		if( !confirm("저장 하겠습니까?") ) {
			return;
		}
		var startdateyymmdd = $("#startdateyymmdd").val(); 
		var startdatehh = $("#startdatehh").val();
		var startdatemm = $("#startdatemm").val();
		var enddateyymmdd = $("#enddateyymmdd").val(); 
		var enddatehh = $("#enddatehh").val();
		var enddatemm = $("#enddatemm").val();
		
		var startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm + ":00"; 
		var enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm + ":00";
		
		if(startdateyymmdd == ""){
			alert("시작일을 선택해 주세요.");
			return;
		}
		if(enddateyymmdd == ""){
			alert("종료일을 선택해 주세요.");
			return;
		}
		if(startdate > enddate){
			alert("시작일시가 종료일시보다 이후입니다. \n기간을 확인해 주세요.");
			return;
		}
		$("#startdate").val(startdate);
		$("#enddate").val(enddate);
		var param = {
				courseid :  $("#courseid").val()
				, copyId : $("#copyId").val()
				, coursetype : $("#coursetype").val()
				, startdate : $("#startdate").val()
				, enddate : $("#enddate").val()
				, startdateyymmdd : $("#startdateyymmdd").val()
				, enddateyymmdd : $("#enddateyymmdd").val()
		};
		$.ajaxCall({
	   		url: "/manager/lms/course/lmsRegularCourseEditSaveAjax.do"
	   		, data: param
	   		, async : false
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
   	           		alert("<spring:message code="errors.load"/>");
   	           		return;
   	   			} else {
   	   				alert("저장이 완료되었습니다.");
					$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.editStepUnitReturn(param);
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
			<h2 class="fl">${detail.coursetypename } 수정</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:350px">
			<div id="popcontent">
				<!-- Sub Title -->
				<!-- 
				<div class="poptitle clear">
					<h3>교육분류 등록</h3>
				</div>
				 -->
				<!--// Sub Title -->
				<div class="tbl_write">
<form id="frm" name="frm">
<input type="hidden" id="courseid" name="courseid" value="${detail.courseid }">
<input type="hidden" id="copyId" name="copyId" value="${param.copyId }">
<input type="hidden" id="coursetype" name="coursetype" value="${detail.coursetype}">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th>과정유형</th>
							<td>
								${detail.coursetypename }
							</td>
						</tr>
						<tr>
							<th id="coursetypenametitle">과정명</th>
							<td>
								${detail.coursename }
							</td>
						</tr>				
						<tr>
							<th id="edudatetitle">교육기간</th>
							<td>
								<input type="hidden" id="startdate" name="startdate"> 
								<input type="hidden" id="enddate" name="enddate">
								<input type="text" id="startdateyymmdd" name="startdateyymmdd"  value="${detail.startdateyymmdd}" title="교육시작일" class="AXInput datepDay required">
								<select id="startdatehh" name="startdatehh" style="width:auto; min-width:80px"  title="교육시작시" >
									<c:forEach items="${ hourList}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>	
								<select id="startdatemm" name="startdatemm" style="width:auto; min-width:80px"  title="교육시작분" >
									<c:forEach items="${ minute2List}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>	
								 ~  
								<input type="text" id="enddateyymmdd" name="enddateyymmdd"  value="${detail.enddateyymmdd}" title="교육종료일" class="AXInput datepDay">
								<select id="enddatehh" name="enddatehh" style="width:auto; min-width:80px"  title="교육종료시" >
									<c:forEach items="${ hourList}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>
								<select id="enddatemm" name="enddatemm" style="width:auto; min-width:80px"  title="교육종료분" >
									<c:forEach items="${ minute2List}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>
							</td>
						</tr>									

					</table>
</form>
				</div>	
 		
				<div align="center">
					<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
				</div>						
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
