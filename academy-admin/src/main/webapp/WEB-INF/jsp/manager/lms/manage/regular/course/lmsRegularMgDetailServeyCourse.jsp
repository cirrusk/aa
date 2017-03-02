<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init

var d_params = {showTab:"D1"};
	
$(document.body).ready(function(){

	
	var responseCnt = "${courseData.finishcount}";
	var studentCnt = "${courseData.requestcount}";
	
	var percent = 0 ;
	if(studentCnt != 0)
		{
			percent = ((responseCnt / studentCnt).toFixed(2))*100;
			percent += "%";
		}
	
	
	$("#percent").text(percent);
	
	//tab초기 설정
	var iniObjectD = {
			optionValue : "D1"
			,optionText : "설문결과"
			,tabId : "D1"
	}
	
	layerD.init();
	layerD.setViewTab("D1",iniObjectD);
});


var layerD = {
		init : function(){
			// 상단 탭
			$("#regularSurveyTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value:"D1"
				, options:[
					  {optionValue:"D1", optionText:"설문결과", tabId:"D1"} 
					, {optionValue:"D2", optionText:"설문대상자", tabId:"D2"}
				]
				, onchange : function(selectedObject, value){
					layerD.setViewTab(value, selectedObject);
				}
			});
		}, setViewTab : function(value, selectedObject){
			d_params.showTab = value;
			
			// Grid Bind Real
			if(d_params.showTab=="D1") {
				//설문결과 탭페이지 불러오기
			 	$.ajax({
					url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyCourseResult.do"/>"
						, data: "stepcourseid="+$("#stepcourseid").val()
						, dataType : "text"
						, type : "post"
						, success: function(data)
							{
								$("#surveyTabLayer").html(data);
								$("#ifrm_main_W010200200_W", parent.document).height($(document).height()+$("#surveyTabLayer").height());
							}
						, error: function()
							{
					           	alert("<spring:message code="errors.load"/>");
							}
				}) ; 
			} else if(d_params.showTab=="D2") {
				$.ajax({
				url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyCourseStudent.do"/>"
					, data: "stepcourseid="+$("#stepcourseid").val()
					, dataType : "text"
					, type : "post"
					, success: function(data)
						{
							$("#surveyTabLayer").html(data);
							$("#ifrm_main_W010200200_W", parent.document).height($(document).height()+$("#surveyTabLayer").height());
						}
					, error: function()
						{
				           	alert("<spring:message code="errors.load"/>");
						}
			}); 
		} // end func setViewTab
	}
}


	
</script>
</head>

<body class="bgw">
<input type="hidden" id="stepcourseid"  name="stepcourseid" value="${stepcourseid }">
<input type="hidden" id="stepseq"  name="stepseq" value="${stepseq }">
<div id="addTag" style="display:none;">
	<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
				<col width="30%" />
				<col width="15%" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th>과정유형</th>
				<td>설문</td>
				<th>설문기간</th>
				<td>${courseData.edudate}</td>
				<th>응답자/대상자</th>
				<td>${courseData.finishcount} / ${courseData.requestcount } (<span id="percent"></span>)</td>
			</tr>
		</table>
</div>
	
	<div id="regularSurveyTab"></div>
	
	<div id="surveyTabLayer"></div>

</body>