<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
var frmid = "${param.frmId}";
var height = $("#ifrm_main_W010500100", parent.document).height();
var getYearMonthHtml = "";


$(document.body).ready(function(){
	

	
	//현재날짜 가져오기
	var now = new Date();
	var getYear = now.getFullYear();
	var getMonth = now.getMonth()+1;
	//기준날짜 셋팅
	var standardYear = 2016;
	var standardMonth = 8;
	//selectBox조립 for문 용Count
	var dateCount = 0;
	
	//검색용 seletBox조립하기
	if(getYear >= standardYear)
		{	
					dateCount = (getYear-standardYear)*12+1 - (standardMonth-getMonth);
		}
	for(var i = 0; i<dateCount; i++)
		{	
			if(standardMonth<10)
				{
					getYearMonthHtml = "<option value="+standardYear+"0"+standardMonth+">"+standardYear+"-0"+standardMonth+"</option>";
				}
			else
				{
					getYearMonthHtml = "<option value="+standardYear+""+standardMonth+">"+standardYear+"-"+standardMonth+"</option>";
				}
			
			$("#getYearMonth").prepend(getYearMonthHtml);
			
			standardMonth ++;
			if(standardMonth==13)
				{
					standardMonth = 1;
					standardYear ++;
				}
		}
	
	$("#getYearMonthTr").hide();
		
	$("#selectType").on("change",function(){
		if($("#selectType").val()=="1")
			{
				$("#getYearTr").show();
				$("#getYearMonthTr").hide();
			}
		else
			{
				$("#getYearTr").hide();
				$("#getYearMonthTr").show();
			}
	});
	
	
	$(".searchBtn").on("click",function(){
		
		var getDate = "";
		var getType = $("#selectType").val();
		if(getType=="1")
			{	
				getDate = $("#getYear").val();
			}
		else
			{
				getDate = $("#getYearMonth").val();
			}
		searchStatistics(getType,getDate);
	});
	
});	

function searchStatistics(getType,getDate)
{	
	var param = {
			type : getType
			,date : getDate
	};
	
	$.ajax({
		url: "<c:url value="/manager/lms/statistics/lmsStatisticsEduPerMonthSelectChange.do"/>"
			, data: param
			, dataType : "text"
			, type : "post"
			, success: function(data)
				{
					$("#addTable").html(data);
					$("#ifrm_main_W010500100", parent.document).height(height+$("#addTable").height());
				}
			, error: function()
				{
		           	alert("<spring:message code="errors.load"/>");
				}
	});
}

function excelDownload(getType,getDate)
{
	var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
	if(result) {
		showLoading();
		var param = {
				type : getType
				,date : getDate
		};
		postGoto("/manager/lms/statistics/lmsStatisticsEduPerMonthExcelDownload.do", param);
		hideLoading();
	}
}

</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">월별 교육 현황</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="20%" />
				<col width="*"  />
				<col width="20%" />
			</colgroup>
			<tr id="getYearTr">
				<th>검색년도</th>
				<td>
					<select id="getYear">
						<option value="${year }">${year }</option>
						<c:forEach begin="1" end="5" var="cnt" step="1">
							<option value="${year - cnt }">${year - cnt }</option>
			          	</c:forEach>
			         </select>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" class="btn_gray btn_big searchBtn" style="width:auto; min-width:30px">검색</a>
					</div>
				</th>
			</tr>
			<tr id="getYearMonthTr">
				<th>검색월</th>
				<td>
					<select id="getYearMonth"></select>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" class="btn_gray btn_big searchBtn" style="width:auto; min-width:30px">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th>구분</th>
				<td>
					<select id="selectType">
						<option value="1">월별 아카데미 현황</option>
						<option value="2">교육자료 조회수 상위 20</option>
						<option value="3">온라인과정 조회수 상위 20</option>
						<option value="4">교육자료 좋아요 상위 20</option>
						<option value="5">온라인과정 좋아요 상위 20</option>
						<option value="6">오프라인과정 참석자 상위 10</option>
					</select>
				</td>
			</tr>
		</table>
	</div>

	<div id="addTable"></div>
		
</body>
</html>