<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init

var d_params = {showTab:"D1"};
	
$(document.body).ready(function(){
	
	//tab초기 설정
	var iniObjectD = {
			optionValue : "D1"
			,optionText : "좌석등록"
			,tabId : "D1"
	}
	
	layerD.init();
	layerD.setViewTab("D1",iniObjectD);
});


var layerD = {
		init : function(){
			// 상단 탭
			$("#regularOfflineTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value:"D1"
				, options:[
					  {optionValue:"D1", optionText:"좌석등록", tabId:"D1"} 
					, {optionValue:"D2", optionText:"출석처리", tabId:"D2"}
				]
				, onchange : function(selectedObject, value){
					layerD.setViewTab(value, selectedObject);
				}
			});
		}, setViewTab : function(value, selectedObject){
			d_params.showTab = value;
			
			// Grid Bind Real
			if(d_params.showTab=="D1") {
				
				//좌석등록 탭페이지 불러오기
			 	$.ajax({
					url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineCourseSeat.do"/>"
						, data: "stepcourseid="+$("#stepcourseid").val()
						, dataType : "text"
						, type : "post"
						, success: function(data)
							{
								$("#offlineTabLayer").html(data);
							}
						, error: function()
							{
					           	alert("<spring:message code="errors.load"/>");
							}
				}) ; 
				
			} else if(d_params.showTab=="D2") {
				 $.ajax({
						url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineAttendHandle.do"/>"
							, data: "stepcourseid="+$("#stepcourseid").val()+"&stepseq="+$("#stepseq").val()+"&courseid="+$("#courseid").val()
							, dataType : "text"
							, type : "post"
							, success: function(data)
								{
									$("#offlineTabLayer").html(data);
								}
							, error: function()
								{
						           	alert("<spring:message code="errors.load"/>");
								}
					}) ;
			} 
		} // end func setViewTab
	}


	
</script>
</head>

<body class="bgw">
<input type="hidden" id="stepcourseid"  name="stepcourseid" value="${stepcourseid }">
<input type="hidden" id="stepseq"  name="stepseq" value="${stepseq }">
<div id="addTag" style="display:none;">
	<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="8%" />
				<col width="16%" />
				<col width="8%" />
				<col width="12%" />
				<col width="8%" />
				<col width="16%" />
				<col width="8%" />
				<col width="8%" />
				<col width="8%" />
				<col width="8%" />
			</colgroup>
			<tr>
				<th>오프라인테마명</th>
				<td>${offlineCourse.coursename }</td>
				<th>과정유형</th>
				<td>오프라인</td>
				<th>교육기간</th>
				<td>${offlineCourse.edudate}</td>
				<th>신청자</th>
				<td id="requestcountNumStep">${offlineCourse.requestcount }</td>
				<th>수료자</th>
				<td id="finishcountNumStep">${offlineCourse.finishcount}</td>
			</tr>
		</table>
</div>
	
	<div id="regularOfflineTab"></div>
	
	<div id="offlineTabLayer"></div>

</body>