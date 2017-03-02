<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var frmid = "${param.frmId}";
var tab = new AXTabClass();

var g_params = {showTab:"U1"};
	 
//tab초기 설정
var iniObject = {
		optionValue : "U1"
		,optionText : "교육현황"
		,tabId : "U1"
}

$(document.body).ready(function(){
	
	layer.init();
	layer.setViewTab("U1",iniObject);
});


var layer = {
		init : function(){
			// 상단 탭
			$("#divLmsRegularMgDetailTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value: "U1"
				, options:[
					  {optionValue:"U1", optionText:"교육현황", tabId:"U1"} 
					, {optionValue:"U2", optionText:"교육신청자", tabId:"U2"}
					, {optionValue:"U3", optionText:"교육과정", tabId:"U3"}
					, {optionValue:"U4", optionText:"수료처리", tabId:"U4"}
				]
				, onchange : function(selectedObject, value){
					layer.setViewTab(value, selectedObject);
				}
			});
		}, setViewTab : function(value, selectedObject){
			g_params.showTab = value;
		
			// Grid Bind Real
			if(g_params.showTab=="U1") {
				
				//교육현황 탭페이지 불러오기
			 	$.ajax({
					url: "<c:url value="/manager/lms/manage/regular/eduStatus/lmsRegularMgDetailEduStatus.do"/>"
						, data: "courseid="+$("#courseid").val()+"&frmId=W010200201"
						, dataType : "text"
						, type : "post"
						, success: function(data)
							{
								$("#tabLayer").html(data);
								$("#ifrm_main_W010200200_W", parent.document).height($(document).height()+$("#tabLayer").filter("#stepDivTarget").height());
							}
						, error: function()
							{
					           	alert("<spring:message code="errors.load"/>");
							}
				}) ; 
				
			} else if(g_params.showTab=="U2") {
				
				//교육신청자 탭페이지 불러오기
			 	$.ajax({
					url: "<c:url value="/manager/lms/manage/regular/applicant/lmsRegularMgDetailApplicant.do"/>"
						, data: "courseid="+$("#courseid").val()+"&frmId=W010200202"
						, dataType : "text"
						, type : "post"
						, success: function(data)
							{
								$("#tabLayer").html(data);
							}
						, error: function()
							{
					           	alert("<spring:message code="errors.load"/>");
							}
				}) ;
				
			} else if(g_params.showTab=="U3"){
				//교육과정 탭페이지 불러오기
			 	 $.ajax({
					url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailCourse.do"/>"
						, data: "courseid="+$("#courseid").val()+"&frmId=W010200203&stepseq="
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
			} else if(g_params.showTab=="U4"){
				$.ajax({
					url: "<c:url value="/manager/lms/manage/regular/finish/lmsRegularMgDetailFinishHandle.do"/>"
						, data: "courseid="+$("#courseid").val()+"&frmId=W010200204"
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
				});
			}
		} // end func setViewTab
	}


//신청자수,수료자수 변경 다시 읽기
function studentNumRefresh(){
 	$.ajax({
		url: "<c:url value="/manager/lms/manage/regular/lmsRegularMgDetailAjax.do"/>"
			, data: "courseid="+$("#courseid").val()+"&frmId=W010200201"
			, dataType : "json"
			, type : "post"
			, success: function(data)
				{
					$("#requestcountNum").html(data.requestcount);
					$("#finishcountNum").html(data.finishcount);
					$("#finishcoutrequestcountNum").html("수료자 : " + data.finishcount + " / " + data.requestcount + "");
				}
			, error: function()
				{
		           	alert("<spring:message code="errors.load"/>");
				}
	}) ; 
}
//구성과정 신청자수,수료자수 변경 다시 읽기
function studentNumRefreshStep(){
	studentNumRefresh()
 	$.ajax({
		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgChangeStepCourseAjax.do"/>"
			, data: "stepcourseid="+$("#stepcourseid").val()+"&frmId=W010200201"
			, dataType : "json"
			, type : "post"
			, success: function(data)
				{
					$("#requestcountNumStep").html(data.requestcount);
					$("#finishcountNumStep").html(data.finishcount);
				}
			, error: function()
				{
		           	alert("<spring:message code="errors.load"/>");
				}
	}) ; 
}
</script>
</head>

<body class="bgw">
<input type="hidden" id="courseid" value="${detail.courseid }">

<!-- 권한 변수 -->
<input type="hidden" id="managerMenuAuth" value="${managerMenuAuth}">

<div class="contents_title clear">
		<h2 class="fl">정규 과정 운영 상세</h2>
</div>
	
	<!--search table // -->

	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="15%" />
				<col width="25%"  />
				<col width="10%" />
				<col width="20%" />
				<col width="10%" />
				<col width="20%" />
			</colgroup>
			<tr>
				<th>정규과정명</th>
				<td colspan="5">	${detail.coursename }	</td>
			</tr>
			<tr>
				<th>교육기간</th>
				<td>	${detail.edudate }	</td>
				<th>신청자수</th>
				<td id="requestcountNum">	${detail.requestcount }</td>
				<th>수료자수</th>
				<td id="finishcountNum">	${detail.finishcount }</td>
			</tr>
		</table>
	</div>
	
	<div id="divLmsRegularMgDetailTab"></div>
	
	<div id="tabLayer"></div>

</body>