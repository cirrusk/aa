<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var listGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
//Grid Default Param
var defaultParam = {
	page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.regular.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};
var baseRow =  [
				  {colSeq: 0, rowspan: 2, valign:"middle"}
					, {colSeq: 1, rowspan: 2, valign:"middle"}
					, {colSeq: 2, rowspan: 2, valign:"middle"}
					, {colSeq: 3, rowspan: 2, valign:"middle"}
					, {colSeq: 4, rowspan: 2, valign:"middle"}
					, {colSeq: 5, rowspan: 2, valign:"middle"}
					, {colSeq: 6, rowspan: 2, valign:"middle"}
					, {colSeq: 7, rowspan: 2, valign:"middle"}
					, {colSeq: 8, rowspan: 2, valign:"middle"}
            	];
var tmpBaseRow =  [
				  {colSeq: 0, rowspan: 2, valign:"middle"}
					, {colSeq: 1, rowspan: 2, valign:"middle"}
					, {colSeq: 2, rowspan: 2, valign:"middle"}
					, {colSeq: 3, rowspan: 2, valign:"middle"}
					, {colSeq: 4, rowspan: 2, valign:"middle"}
					, {colSeq: 5, rowspan: 2, valign:"middle"}
					, {colSeq: 6, rowspan: 2, valign:"middle"}
					, {colSeq: 7, rowspan: 2, valign:"middle"}
					, {colSeq: 8, rowspan: 2, valign:"middle"}
            	];
var subRow = [];
var tmpSubRow = [];

var step = [
  					  {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
						, {key:"categorytreename", label:"교육분류", width:"120", align:"center", sort:false}
						, {key:"themename", label:"정규과정테마", width:"150", align:"center", sort:false}
						, {key:"coursename", label:"과정명", width:"460", align:"center", sort:false}
						, {key:"openflag", label:"상태", width:"80", align:"center", sort:false}
						, {key:"stepcoursecount", label:"과정수", width:"80", align:"center", sort:false}
						, {key:"requestcount", label:"신청자", width:"80", align:"center", sort:false}
						, {key:"finishcount", label:"이수자", width:"80", align:"center", sort:false}
						, {key:"finishpercent", label:"이수율", width:"80", align:"center", sort:false}
					];
var tmpStep = [  					  
  					  {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
, {key:"categorytreename", label:"교육분류", width:"120", align:"center", sort:false}
, {key:"themename", label:"정규과정테마", width:"150", align:"center", sort:false}
, {key:"coursename", label:"과정명", width:"460", align:"center", sort:false}
, {key:"openflag", label:"상태", width:"80", align:"center", sort:false}
, {key:"stepcoursecount", label:"과정수", width:"80", align:"center", sort:false}
, {key:"requestcount", label:"신청자", width:"80", align:"center", sort:false}
, {key:"finishcount", label:"이수자", width:"80", align:"center", sort:false}
, {key:"finishpercent", label:"이수율", width:"80", align:"center", sort:false}
];

$(document.body).ready(function(){
	//검색 조건에 따른 stepCount가져오기
	fnStepCount();
	// 페이지당 보기수 변경 이벤트
	$("#rowPerPage").on("change", function(){
		list.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		var searchstartdate = $("#searchstartdate").val();
		var searchenddate = $("#searchenddate").val();
		if(searchstartdate != "" && searchenddate != ""){
			if( searchenddate < searchstartdate ){
				alert("교육기간 검색 종료일이 시작일 보다 크거나 같아야 합니다.");
				return;
			}
		}
		
		fnStepCount();
	});
	
	// 엑셀다운 버튼 클릭시
 	$("#aExcdlDown").on("click", function(){

 		var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
					searchcategoryid : $("#searchcategoryid").val()	
				  , searchedustatus :$("#searchedustatus").val()
				  , searchstartdate :$("#searchstartdate").val()
				  , searchenddate :$("#searchenddate").val()
				  , searchtype :$("#searchtype").val()
				  , searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/statistics/lmsReportRegularCurseExcelDownload.do"/>", defaultParam);
			hideLoading();
		}  
	});	
});

var list = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var gridParam = {
					colGroup : tmpStep
					, fitToWidth: true
					, colHead : { 
						heights: [20,20]
						,rows : [tmpBaseRow ,tmpSubRow]
						}
					, targetID : "AXGridTarget"
					, doPageSearch : list.doPageSearch
				}
			
			fnGrid.initGrid(listGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			list.doSearch({page:pageNo});
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			var initParam = {
					searchcategoryid : $("#searchcategoryid").val()	
				  , searchedustatus :$("#searchedustatus").val()
				  , searchstartdate :$("#searchstartdate").val()
				  , searchenddate :$("#searchenddate").val()
				  , searchtype :$("#searchtype").val()
				  , searchtext :$("#searchtext").val()
				  , stepcount : $("#stepCount").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/statistics/lmsReportRegularCourseListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		alert("success"+data);
		        		return;
					} else {
						callbackList(data);
					}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
		           	alert("error"+textStatus);
		   		}
		   	});

		   	function callbackList(data) {
		   		 
		   		var obj = data; //JSON.parse(data);
		   		// Grid Bind
		   		var gridData = {
					list: obj.dataList
					, page:{
						pageNo: obj.page,
						pageSize: defaultParam.rowPerPage,
						pageCount: obj.totalPage,
						listCount: obj.totalCount
					}
				};			   		
		   		$("#totalcount").text(obj.totalCount);
		   		// Grid Bind Real
		   		listGrid.setData(gridData);
		   		
		   	}
			
		}
	}

//정규과정보고서 검색 조건에 따라 나오는 정규과정 중 가장 큰 단계값 가져오기
//및 initGrid용 변수 셋팅
function fnStepCount()
{
	var initParam = {
			searchcategoryid : $("#searchcategoryid").val()	
		  , searchedustatus :$("#searchedustatus").val()
		  , searchstartdate :$("#searchstartdate").val()
		  , searchenddate :$("#searchenddate").val()
		  , searchtype :$("#searchtype").val()
		  , searchtext :$("#searchtext").val()
	};
	
	$.ajaxCall({
   		url: "<c:url value="/manager/lms/statistics/lmsReportRegularStepCount.do"/>"
   		, data: initParam
   		, success: function( data, textStatus, jqXHR){
   			
   			
   			$("#stepCount").val(data);
   			
   			//변수 초기화
   			tmpStep =  $.extend([],step);
   			tmpSubRow = $.extend([],subRow);
   			tmpBaseRow = $.extend([],baseRow);
   			
   			for(var i=1; i<=data; i++)
   				{
   					tmpStep.push({key:"step"+i, label:i+"단계", width:"80", align:"center", sort:false});
   					tmpSubRow.push({colSeq: 8+i});
   				}
   			
   			var endBaseRow =[
								       		{colseq:null, colspan: data, label: "단계별 이수현황", align: "center", valign:"middle"}
											, {colSeq: 9+data, rowspan: 2, valign:"middle"}
											, {colSeq: 10+data, rowspan: 2, valign:"middle"}
											, {colSeq: 11+data, rowspan: 2, valign:"middle"}
										];
   			
   			var endStep = [
								{key:"likecount", label:"좋아요", width:"80", align:"center", sort:false}
								, {key:"snscount", label:"SNS공유", width:"80", align:"center", sort:false}
								,{
									key:"detail", label:"수료자", width:"120", align:"center", sort:false, formatter: function () {
										return "<a href='javascript:;' class='btn_green' onclick='javascript:goDetail("+this.item.courseid+");'>조회</a>";
									}
								}
   			               ];
   			
   			$.merge(tmpStep,endStep);
   			$.merge(tmpBaseRow,endBaseRow);
   			
   			list.init();
   			list.doSearch({page:1});
   			
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	alert("error"+textStatus);
   		}
   	});
}
//수료자 조회 팝업
 function goDetail(courseId)
{
		//교육신청자 추가 버튼 클릭
			var popParam = {
					url : "/manager/lms/statistics/lmsReportDetailPop.do"
					, width : 1024
					, height : 900
					, maxHeight : 900
					, params : {courseid : courseId, coursetype : "R"}
					, targetId : "reportPop"
			}
			window.parent.openManageLayerPopup(popParam);

}
	
	

</script>
</head>

<body class="bgw">
<input type="hidden"  id="stepCount"/>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">정규과정보고서</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*"  />
				<col width="10%" />
				<col width="20%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th>교육기간</th>
				<td>
					<input type="text" id="searchstartdate" name="searchstartdate" class="AXInput datepDay"> ~ 
					<input type="text" id="searchenddate" name="searchenddate" class="AXInput datepDay">
				</td>
				<th>상태</th>
				<td>
					<select id="searchedustatus" name="searchedustatus" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="N">비공개</option>
						<option value="Y">공개</option>
					</select>
				</td>
				<th rowspan="3">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th>교육분류</th>
				<td colspan="3">
					<c:set var="courseTypeCode" value="R"/>
					<%@ include file="/WEB-INF/jsp/manager/lms/include/lmsSearchCategory.jsp" %>
				</td>
			</tr>
			<tr>
				<th>조회</th>
				<td colspan="3">
					<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
						<option value="">전체</option>
						<option value="1">과정명</option>
						<option value="2">과정소개</option>
						<option value="3">검색어</option>
					</select>
					<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
				</td>
			</tr>
		</table>
	</div>
			
	<div class="contents_title clear">
		<div class="fl">
			<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
				<option value="20">20</option>
				<option value="50">50</option>
				<option value="500">500</option>
				<option value="1000">1000</option>
			</select>
			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
			
			<span> Total : <span id="totalcount"></span>건</span>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget"></div>
	</div>
			
	<!-- Board List -->
		
</body>
</html>