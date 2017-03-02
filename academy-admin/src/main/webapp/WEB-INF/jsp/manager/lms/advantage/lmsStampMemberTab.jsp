<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

var stampGrid = new AXGrid(); // instance 상단그리드

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.offline.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	
	stampList.init();
	stampList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		var searchstartdate = $("#searchstartdate").val();
		var searchenddate = $("#searchenddate").val();
		if(searchstartdate != "" && searchenddate != ""){
			if( searchenddate < searchstartdate ){
				alert("스탬프 획득일  종료일 조건인 시작일 보다 크거나 같아야 합니다.");
				return;
			}
		}
		stampList.doSearch();
	});
	
	$("#rowPerPage").on("change", function(){
		stampList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
});


			/* Stamp 회원탭 구성 */
			var stampList = {
					/** init : 초기 화면 구성 (Grid)
					*/		
					init : function() {
						var idx = 0; // 정렬 Index 
						var _colGroup = [
											 {key:"rank", label:"랭킹", width:"50", align:"center", formatter:"money", sort:false}
											, {key:"uid", label:"ABO 번호", width:"200", align:"center"}
											, {
												key:"name", label:"이름", width:"150", align:"center", formatter:function()
												{
													if(this.item.partnerinfoname != null && this.item.partnerinfoname !="")
														{
															return this.item.name+"&"+this.item.partnerinfoname;
														}
													else
														{
															return this.item.name;
														}
												}
											}
											, {key:"pincode", label:"핀레벨", width:"150", align:"center"}
											, {key:"stampcnt", label:"스탬프수", width:"150", align:"center"}
										]
						var gridParam = {
								colGroup : _colGroup
								, fitToWidth: false
			 					//, fixedColSeq: 3
								, colHead : { heights: [25,25]}
								, targetID : "AXGridTarget"
								, sortFunc : stampList.doSortSearch
								, doPageSearch : stampList.doPageSearch
							}

						fnGrid.initGrid(stampGrid, gridParam);
					}, doPageSearch : function(pageNo) {
						// Grid Page List
						stampList.doSearch({page:pageNo});
					}, doSortSearch : function(){
						var sortParam = getParamObject(stampGrid.getSortParam()+"&page=1");
						defaultParam.sortOrder = sortParam.sortWay; 
						// 리스트 갱신(검색)
						stampList.doSearch(sortParam);
					}, doSearch : function(param) {
						
						// Param 셋팅(검색조건)
						 var initParam = {
								searchstartdate : $("#searchstartdate").val()	
							  , searchenddate : $("#searchenddate").val()
							  , searchstampid : $("#searchstampid").val()
							  , searchtype : $("#searchtype").val()
							  , searchtext : $("#searchtext").val()
						}; 
						
						 $.extend(defaultParam, param);
							$.extend(defaultParam, initParam);
							$.ajaxCall({
						   		url: "<c:url value="/manager/lms/advantage/lmsStampMemberListAjax.do"/>"
						   		, data: defaultParam
						   		, success: function( data, textStatus, jqXHR){
						   			if(data.result < 1){
						        		alert("<spring:message code="errors.load"/>");
						        		alert("success"+data);
						        		return;
									} else {
										$("#stampCnt").text(data.stampcnt);
										$("#memberCnt").text(data.membercnt);
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
						   		stampGrid.setData(gridData);
					   		 
					   	}
			}
}

</script>
</head>

<body class="bgw">
			<!-- axisGrid -->
				<div class="contents_title clear">
					<div class="fl">
						<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
							<option value="20" >20</option>
							<option value="50">50</option>
							<option value="500">500</option>
							<option value="1000">1000</option>
						</select>
						
						<span> Total : <span id="totalcount"></span>건</span>
					</div>
				</div>
				<div id="AXGrid">
					<div id="AXGridTarget"></div>
				</div>
</body>