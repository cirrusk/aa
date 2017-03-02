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
 	, sortColKey: "lms.stamp.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	
	stampList.init();
	stampList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
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
											 {key:"no", label:"NO", width:"50", align:"center", formatter:"money", sort:false}
											, {key:"uid", label:"ABO 번호", width:"200", align:"center"}
											, {
												key:"name", label:"성명", width:"150", align:"center", formatter:function()
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
											, {key:"obtaindate", label:"획득일시", width:"150", align:"center"}
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
							   searchtype : $("#searchtype").val()
							  , searchtext : $("#searchtext").val()
							  , stampid : "${param.stampid}"
						}; 
						
						 $.extend(defaultParam, param);
							$.extend(defaultParam, initParam);
							$.ajaxCall({
						   		url: "<c:url value="/manager/lms/advantage/lmsStampObtainMemberPopAjax.do"/>"
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
						   		stampGrid.setData(gridData);
					   		 
					   	}
			}
}

</script>
</head>

<body class="bgw">

<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
		<h2 class="fl">스탬프 획득자 조회</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
		
				<div class="tbl_write">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="20%" />
								<col width="40%"  />
								<col width="20%" />
								<col width="20%" />
							</colgroup>
							<tr>
								<th>스탬프명</th>
								<td>${param.stampname }</td>
								<th>획득인원</th>
								<td>${param.obtaincnt }</td>
							</tr>
						</table>
					</div>
		<br/>
				<div class="tbl_write">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="20%" />
								<col width="60%"  />
								<col width="20%" />
							</colgroup>
							<tr>
								<th>조회</th>
								<td>
									<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
										<option value="">전체</option>
										<option value="1">ABO번호</option>
										<option value="2">이름</option>
									</select>
									<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
								</td>
								<th>
									<div class="btnwrap mb10">
										<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
									</div>
								</th>
							</tr>
						</table>
					</div>
		
		
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
						
				<div class="contents_title clear">
					<div class="fr">
						<a href="javascript:;" id="closeBtn" class="btn_green close-layer"> 닫기</a>
					</div>
				</div>
		</div>
	</div>
</div>
`
</body>