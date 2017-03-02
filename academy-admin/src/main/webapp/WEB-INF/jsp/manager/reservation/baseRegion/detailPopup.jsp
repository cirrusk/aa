<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	

$(document).ready(function(){

	gridFunctionList.init(function(){
		var param = {
				page : 1,
				cityGroupCode : '${seqNumber}'
		};
		gridFunctionList.doSearch(param);
	});
	
});

/** Grid Default Param */
var defaultParam = {
		page: 1
		, rowPerPage: 30
		, sortColKey: "Rsv.common.list"
		, sortIndex: 1
		, sortOrder:"DESC"
};

/** 그리드 object 생성 */
var mainGrid = new AXGrid(); // instance 상단그리드

/**
* grid functions
*/
var gridFunctionList = {
		
	/** init : 초기 화면 구성 (Grid) */
	init : function(callbackSearch) {
		var idx = 0; // 정렬 Index 
		var _colGroup = [
							{key:"regionname",		label:"시도",		width:"200", 	align:"center",		sort:false	},
							{key:"cityname",	label:"군구",		width:"320", 	align:"center",		sort:false	}
						]
		var gridParam = {
				colGroup : _colGroup
				, colHead : { 
					heights: [20,20],
					rows : [
								[
								  {colSeq: 0, rowspan: 2, valign: "middle"}
								, {colSeq: 1, rowspan: 2, valign: "middle"}
								]
							]
					}
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : gridFunctionList.doSortSearch
				, doPageSearch : gridFunctionList.doPageSearch
		}
		
		fnGrid.initGrid(mainGrid, gridParam);
		
		if (typeof callbackSearch === "function" ){
			callbackSearch();
		}
		
	}, 
	
	/** 페이지 이동 */
	doPageSearch : function(pageNo) {
		// Grid Page List
		gridFunctionList.doSearch({page:pageNo});
	},
	
	/** 컬럼 정렬 검색 */
	doSortSearch : function(sortKey){
		// Grid Sort
		defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
		var param = {
				sortIndex : sortKey
				, page : 1
		};
		
		// 리스트 갱신(검색)
		gridFunctionList.doSearch(param);
		
	}, 
	
	doSearch : function(param) {
		
		// search parameters
		var initParam = {
		};
		
		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);
		
		$.ajaxCall({
	   		url: "<c:url value = '/manager/reservation/baseRegion/regionDetailListAjax.do' />"
	   		, data: defaultParam
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.cityGroupDetailList){
	   				callbackList(data);
	   			}else{
	   				var mag = '<spring:message code="errors.load"/>';
	   				alert(mag);
	           		return;
	   			}
	   			
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
	   		}
	   	});

	   	function callbackList(data) {
	   		
	   		var obj = data; //JSON.parse(data);
	   		//console.log(obj);

	   		// Grid Bind
	   		var gridData = {
		   			list: obj.cityGroupDetailList,
		   			page:{
		   				pageNo: obj.page,
		   				pageSize: defaultParam.rowPerPage,
		   				pageCount: obj.totalPage,
		   				listCount: obj.totalCount
		   			}
		   		};
	   		
	   		// Grid Bind Real
	   		mainGrid.setData(gridData);
	   	}
	   	
	}
	
}

</script>
</head>

<body>
	<div id="popwrap">
	
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">행정구역 상세</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<div class="tbl_write">
				
					<!-- grid // -->
					<div id="AXGrid">
						<div id="AXGridTarget_${param.frmId}"></div>
					</div>
					<!-- // grid -->
				
				</div>
				<div class="btnwrap clear">
					<a href="javascript:;" id="aInsertEnd" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
		
	</div>
</body>