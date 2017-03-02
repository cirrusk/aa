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
function changeApSeq(obj){
	var val = obj.value;
	var targetObj = "roomseq";
	var targetInput = "apname";
	if(val==""){
		setLmsRoomSelectBox(null, targetObj, "roomseq", "roomname");
		$("#"+targetInput).hide();
	}else if(val=="0"){
		setLmsRoomSelectBox(null, targetObj, "roomseq", "roomname");
		$("#"+targetInput).show();
	}else{
		$("#"+targetInput).hide();
		$("#"+targetInput).val(obj[obj.selectedIndex].text);
		$.ajaxCall({
	   		url: "/manager/lms/common/lmsRoomCodeListAjax.do"
	   		, data: {apseq: val}
	   		, async : false
	   		, success: function( data, textStatus, jqXHR){
	   			setLmsRoomSelectBox(data, targetObj, "roomseq", "roomname");
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	   		}
	   	});
	}
}

function setLmsRoomSelectBox(data, targetObj, codefield, codenamefield){
	var HTML = "<option value='__CODE_VALUE__'>__CODE_TEXT__</option>";
	var realHTML = "<option value=''>선택</option>";
	if(data != null){
		var dataList = "data.dataList";
		var len = data.dataList.length;
		if(len > 0){
			for(var i = 0; i < len; i++){
				tmpHtml = HTML;
				tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, eval(dataList+"[i]."+codefield));
				tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, eval(dataList+"[i]."+codenamefield));
				realHTML += tmpHtml;
			}
		}
	}
	realHTML += "<option value='0'>직접입력</option>";
	$("#" + targetObj + " option").remove();
	$("#" + targetObj).append(realHTML);
}

function changeRoomSeq(obj){
	var val = obj.value;
	var targetInput = "roomname";
	if(val==""){
		$("#"+targetInput).hide();
	}else if(val=="0"){
		$("#"+targetInput).show();
	}else{
		$("#"+targetInput).hide();
		$("#"+targetInput).val(obj[obj.selectedIndex].text);
	}
}

$(document).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		//입력여부 체크
		if(!chkValidation({chkId:"#frm", chkObj:"hidden|input|select|textarea"}) ){
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
				, apseq : $("#apseq").val()
				, apname : $("#apname").val()
				, roomseq : $("#roomseq").val()
				, roomname : $("#roomname").val()
				, limitcount : $("#limitcount").val()
				, detailcontent : $("#detailcontent").val()
				
		};
		$.ajaxCall({
	   		url: "/manager/lms/course/lmsRegularCourseEditOffSaveAjax.do"
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
					</table>
					<br>
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="150px" />
							<col width="150px" />
							<col width="250px" />
							<col width="50px" />
							<col width="*" />
						</colgroup>
						<tr>
							<th>교육장소</th>
							<th>강의실</th>
							<th>교육기간</th>
							<th>정원</th>
							<th>상세정보</th>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="apTr" name="apTr" value="">
								<select id="apseq" name="apseq"  style="width:auto; min-width:100px" title="교육장소" onchange="changeApSeq(this);">
									<option value="">선택</option>
									<c:forEach items="${ apCodeList}" var="data" varStatus="status">
										<option value="${data.apseq }" <c:if test="${detail2.apseq eq data.apseq }"> selected</c:if>>${data.apname }</option>
									</c:forEach>
									<option value="0" <c:if test="${detail2.apseq eq 0 }"> selected</c:if>>직접입력</option>
								</select>
								<br />
								<input type="text" id="apname" name="apname"  value="${detail2.apname }" style="width:100px;display:<c:if test="${detail2.apseq ne 0 }">none</c:if>;"  class="AXInput required" maxlength="25" title="교육장소">
							</td>
							<td>
								<select id="roomseq" name="roomseq"  style="width:auto; min-width:100px" title="강의실" onchange="changeRoomSeq(this);">
									<option value="">선택</option>
									<c:forEach items="${ roomCodeList}" var="data" varStatus="status">
										<option value="${data.roomseq }" <c:if test="${detail2.roomseq eq data.roomseq }"> selected</c:if>>${data.roomname }</option>
									</c:forEach>
									<option value="0" <c:if test="${detail2.roomseq eq 0 }"> selected</c:if>>직접입력</option>
								</select>
								<br />
								<input type="text" id="roomname" name="roomname" value="${detail2.roomname }"  style="width:100px;display:<c:if test="${detail2.roomseq ne 0 }">none</c:if>;"  class="AXInput required" maxlength="25" title="강의실">				
							</td>
							<td>
								<input type="hidden" id="startdate" name="startdate"> 
								<input type="hidden" id="enddate" name="enddate">
								<input type="text" id="startdateyymmdd" name="startdateyymmdd"  value="${detail.startdateyymmdd}" title="교육시작일" class="AXInput datepDay required" style="width:80px">
								<select id="startdatehh" name="startdatehh" style="width:auto; min-width:50px"  title="교육시작시" >
									<c:forEach items="${ hourList}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>	
								<select id="startdatemm" name="startdatemm" style="width:auto; min-width:50px"  title="교육시작분" >
									<c:forEach items="${ minute2List}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>	
								 ~  <br />
								<input type="text" id="enddateyymmdd" name="enddateyymmdd"  value="${detail.enddateyymmdd}" title="교육종료일" class="AXInput datepDay required" style="width:80px">
								<select id="enddatehh" name="enddatehh" style="width:auto; min-width:50px"  title="교육종료시" >
									<c:forEach items="${ hourList}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>
								<select id="enddatemm" name="enddatemm" style="width:auto; min-width:50px"  title="교육종료분" >
									<c:forEach items="${ minute2List}" var="data" varStatus="status">
										<option value="${data.value }" <c:if test="${detail.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input type="text" id="limitcount" name="limitcount" value="${detail2.limitcount }" style="width:50px;"  class="AXInput required isNum" maxlength="6" title="정원">
							</td>
							<td>
								<textarea id="detailcontent" name="detailcontent" class="AXInput  required" style="width:90%;height:50px;" title="상세정보">${detail2.detailcontent}</textarea>
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
