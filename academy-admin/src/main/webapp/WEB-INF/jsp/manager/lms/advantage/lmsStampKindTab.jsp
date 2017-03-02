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
	
	// 엑셀다운 버튼 클릭시
 	$("#aExcdlDown").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			// Param 셋팅(검색조건)
			 var initParam = {
					searchstartdate : $("#searchstartdate").val()	
				  , searchenddate : $("#searchenddate").val()
				  , searchstamptype : $("#searchstamptype").val()
				  , searchtype : $("#searchtype").val()
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/advantage/lmsStampKindExcelDownload.do"/>", defaultParam);
			hideLoading();
		}
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
											, {key:"stampname", label:"스탬프명", width:"200", align:"center"											}
											, {
												key:"stamptype", label:"구분", width:"150", align:"center",formatter:function()
												{
													var stamptype = "";
													
													if(this.item.stamptype == 'N')
														{
															stamptype = "일반"
														}
													else if(this.item.stamptype == 'C')
														{
															stamptype = "정규과정"
														}
													if(this.item.stamptype == 'U')
														{
															stamptype = "목표달성"
														}
													
													return stamptype;
												}
											}
											, {key:"obtaincnt", label:"획득자수", width:"150", align:"center"}
											, {
												key:"obtainmember", label:"획득자", width:"150", align:"center", formatter:function(){
													return "<input type='button' value='조회' onclick=\"goObtainMember('"+this.item.stampid+"','"+this.item.stampname+"','"+this.item.obtaincnt+"')\"/>";
												}
											}
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
							  , searchstamptype : $("#searchstamptype").val()
							  , searchtype : $("#searchtype").val()
							  , searchtext : $("#searchtext").val()
						}; 
						
						 $.extend(defaultParam, param);
							$.extend(defaultParam, initParam);
							$.ajaxCall({
						   		url: "<c:url value="/manager/lms/advantage/lmsStampKindListAjax.do"/>"
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
			
function goObtainMember(stampId,stampName,obtainCnt)
			{
				var popParam = {
						url : "/manager/lms/advantage/lmsStampObtainMemberPop.do"
						, width : 1024
						, height : 900
						, maxHeight : 900
						, params : {stampid : stampId , stampname : stampName , obtaincnt : obtainCnt}
						, targetId : "stampPop"
				}
				window.parent.openManageLayerPopup(popParam);
			}

</script>
</head>
<body>
			<!-- axisGrid -->
			<br/>
				<div class="contents_title clear">
					<div class="fl">
						<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
							<option value="20" >20</option>
							<option value="50">50</option>
							<option value="500">500</option>
							<option value="1000">1000</option>
						</select>
						<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
						
						<span> Total : <span id="totalcount"></span>건</span>
					</div>
				</div>
				<div id="AXGrid">
					<div id="AXGridTarget"></div>
				</div>
</body>
</html>