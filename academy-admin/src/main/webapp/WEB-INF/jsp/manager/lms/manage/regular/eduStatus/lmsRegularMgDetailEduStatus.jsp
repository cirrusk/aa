<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
var frmid = "${param.frmId}";

var copyId = "1";
$(document).ready(function(){
	
	//단계별 자료 조회해오기
	$.ajaxCall({
   		url: "/manager/lms/manage/regular/eduStatus/lmsRegularMgDetailEduStatusListAjax.do"
   		, data: {courseid : $("#courseid").val() }
   		, async : false
   		, success: function( data, textStatus, jqXHR){
   			if(data.result < 1){
        		alert("<spring:message code="errors.load"/>");
        		return;
			} else {
				for(var i = 0; i<data.stepList.length; i++){
					addStep(data.stepList[i]);	
				}
			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
   		}
   	});
	
	
});

//No. 재설정
function trOrderNumSet(copyId){
	$(".trOrderNum"+copyId).each(function(index){
		$(this).text(index+1);
	});	
}

//순서 재설정
function resetStepOrderSelect(){
	var len = $("input[name=stepseq]").length;
	$("input[name=stepseq]").each(function(index){
		createStepOrderSelect($(this).val());
	});	
}

//단계 콤보 생성
function createStepOrderSelect(copyId, selectedVal){
	var targetObj = "steporder"+copyId;
	var endCnt = $("input[name=stepseq]").length;
	var realHTML = "";
	for(var i = 1; i <= endCnt; i++){
		realHTML += "<option value='"+i+"'>"+i+" 단계</option>";
	}
	$("#" + targetObj + " option").remove();
	$("#" + targetObj).append(realHTML);
	if(selectedVal == null || selectedVal == ""){
		$("input[name=stepseq]").each(function(index){
			if($(this).val() == copyId){
				selectedVal = index+1;
			}
		});
	}
	$("#" + targetObj).val(selectedVal);
}

//단계 추가
function addStep(param){
	var html = $("#stepDiv").html();
	html = html.replace(/CopyId/g,copyId);
	html = html.replace(/CopyName/g,"");
	html = html.replace(/stepOrder/g,param.steporder);
	html = html.replace(/stepName/g,param.stepname);
	$("#stepDivTarget").append(html);
	
	if(param != null){
		$("#stepname"+copyId).val(param.stepname);
		$("#stepcount"+copyId).html(param.stepcount);
		$("#spanStepUnitCount"+copyId).html(param.unitlist.length);
		if(param.unitlist != null){
			for(var i=0; i < param.unitlist.length; i++){
				param.unitlist[i].copyId = copyId; 
				addStepUnitReal(param.unitlist[i])
			}
		}
	}
	copyId = Number(copyId)+1; 
	myIframeResizeHeight(frmid);
}

//과정  로우 추가
function addStepUnitReal(param){
	var copyId = param.copyId;
	var courseId = param.courseid;
	
	var html = $("#stepUnitCopyTable").html();
	html = html.replace(/CopyId/g,copyId);
	html = html.replace(/CourseId/g,courseId);
	html = html.replace(/CopyName/g,"");
	html = html.replace(/courseTypeName/g,param.coursetypename);
	html = html.replace(/courseName/g,param.coursename);
	html = html.replace(/eduDate/g,param.edudate);
	html = html.replace(/courseMustFlag/g,param.coursemustflag);
	html = html.replace(/requestCount/g,param.requestcount);
	html = html.replace(/finishCount/g,param.finishcount);
	html = html.replace(/eduStatus/g,param.edustatus);
	
	$("#stepUnitTable"+copyId).append(html);
	trOrderNumSet(copyId);

} 

function detail(stepSeq,stepCourseId)
{ 	
	
	  $.ajax({
			url: "/manager/lms/manage/regular/course/lmsRegularMgDetailCourse.do"
				, data: "courseid="+$("#courseid").val()+"&frmId=W010200203&stepseq="+stepSeq+"&stepcourseid="+stepCourseId
				, dataType : "text"
				, type : "post"
				, success: function(data)
					{
						
						$("#tabLayer").html(data);
						$("#ifrm_main_W010200200_W", parent.document).height($(document).height()+$("#tabLayer").filter("#AXGrid").height());
					}
				, error: function()
					{
			           	alert("<spring:message code="errors.load"/>");
					}
		}) ;  
	}


</script>
<body>
<input type="hidden" id="courseid" value="${courseid }"/>
	<br/>
	<div id="stepDivTarget"></div>
		
	<div id="stepDiv" style="display:none">

		<table id="stepTableCopyId" style="margin-bottom: 40px;" width="100%" border="0" cellspacing="0" cellpadding="0" class="tbl_write2">
			<colgroup>
				<col width="10%" />
				<col width="*" />
				<col width="20%" />
				<col width="15%" />
			</colgroup>		
			<tr>
				<th>단계</th>
				<td>[<span>stepOrder</span>단계] &nbsp;&nbsp;&nbsp;<span>stepName</span></td>
				<th>수료과정수</th>
				<td><span id="stepcountCopyId">0</span>/<span id="spanStepUnitCountCopyId">0</span></td>
			</tr>
			<tr>
				<th>구성과정</th>
				<td class="tbl_write2" colspan="3">
					<table id="stepUnitTableCopyId" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="50px" />
							<col width="80px" />
							<col width="*" />
							<col width="180px" />
							<col width="80px" />
							<col width="80px" />
							<col width="80px" />
							<col width="100px" />
							<col width="80px" />
						</colgroup>
						<tr>
							<!-- <th><input type="checkbox"  onclick="checkStepUnit(this, 'CopyId')"></th> -->
							<th>No</th>
							<th>과정구분</th>
							<th>과정명</th>
							<th>교육기간</th>
							<th>필수여부</th>
							<th>신청</th>
							<th>수료</th>
							<th>상태</th>
							<th>수정</th>
						</tr>

					</table>
				</td>
			</tr>
		</table>
	</div>
	<table id="stepUnitCopyTable" style="display:none;">
		<tr>
			<input type="hidden" class="stepcourseidCopyName"  name="stepcourseidCopyIdCopyName" value="CourseId">
			<td class="trOrderNumCopyId" style="text-align:center;">1</td>
			<td id="categorytreenameCopyId_CourseId" style="text-align:center;">courseTypeName</td>
			<td id="coursenameCopyId_CourseId">courseName</td>
			<td id="edudateCopyId_CourseId">eduDate</td>
			<td id="coursemustflagCopyId_CourseId" >courseMustFlag</td>
			<td id="requestcountCopyId_CourseId">requestCount</td>
			<td id="finishCountCopyId_CourseId">finishCount</td>
			<td id="edustatusCopyId_CourseId">eduStatus</td>
			<td><a href="javascript:;" class="btn_green" onclick="detail('CopyId','CourseId')">상세</a></td>
		</tr>
	</table>
</body>
</html>