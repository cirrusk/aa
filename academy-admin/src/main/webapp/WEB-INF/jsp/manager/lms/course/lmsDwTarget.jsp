<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
var managerMenuAuth ="${managerMenuAuth}";
//Grid Init
var listGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
//Grid Default Param
var defaultParam = {
	page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.test.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	list.init();
	
	// 페이지당 보기수 변경 이벤트
	$("#rowPerPage").on("change", function(){
		list.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		list.doSearch({page:1});
	});
	
	$("#insertExcel").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		goExcelPopup();
	});

});

var list = {
	/** init : 초기 화면 구성 (Grid)
	*/		
	init : function() {
		var idx = 0; // 정렬 Index 
		var _colGroup = [
			{key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
			, {key:"uid", label:"ABO번호", width:"200", align:"center", sort:false}
			, {key:"name", label:"이름", width:"200", align:"center", sort:false}
			, {key:"businessstatuscode1", label:"전년 매출 성장율 대비 성장", width:"160", align:"center", sort:false}
			, {key:"businessstatuscode2", label:"전년 매출 성장율 대비 하락", width:"160", align:"center", sort:false}
			, {key:"businessstatuscode3", label:"전년 신규 성장율 대비 성장", width:"160", align:"center", sort:false}
			, {key:"businessstatuscode4", label:"전년 신규 성장율 대비 하락", width:"160", align:"center", sort:false}
		]
		var gridParam = {
			colGroup : _colGroup
			, fitToWidth: false
			, colHead : { heights: [25,25]}
			, targetID : "AXGridTarget_${param.frmId}"
			, sortFunc : list.doSortSearch
			, doPageSearch : list.doPageSearch
		}
		
		fnGrid.initGrid(listGrid, gridParam);
	}, doPageSearch : function(pageNo) {
		// Grid Page List
		list.doSearch({page:pageNo});
	}, doSortSearch : function() {
		var sortParam = getParamObject(listGrid.getSortParam()+"&page=1");
		defaultParam.sortOrder = sortParam.sortWay; 
		// 리스트 갱신(검색)
		list.doSearch(sortParam);
	}, doSearch : function(param) {
		//검색어 없으면 입력 요구
		if( $("#searchyear").val() == "" || $("#searchmonth").val() == "" ) {
			//alert("검색연월을 선택하세요.");
			//return;
		}
		if( $("#searchtext").val() == "" ) {
			//alert("검색어를 입력하세요.");
			//return;
		}
		
		// Param 셋팅(검색조건)
		var initParam = {
			searchdwmonth : $("#searchyear").val() + $("#searchmonth").val()
			,searchtype :$("#searchtype").val()
			,searchtext :$("#searchtext").val()
		};
		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);
		
		$.ajaxCall({
			url: "<c:url value='/manager/lms/course/lmsDwTargetAjax.do'/>"
	   		, data: defaultParam
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
	        		alert("<spring:message code="errors.load"/>");
	        		return;
				} else {
					callbackList(data);
				}
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
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
var goExcelPopup = function() {
	var param = {
	};
	var popParam = {
		url : "<c:url value="/manager/lms/course/lmsDwTargetPop.do" />"
		, width : 800
		, height : 500
		, maxHeight : 500
		, params : param
		, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

function reSearch(){
	list.doSearch({page:1});
}
</script>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">추천조건 등록</h2>
	</div>
	
	<!--search table // -->

	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th scope="row">검색연월</th>
				<td>
					<select id="searchyear" name="searchyear" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" varStatus="status" begin="${baseyear}" end="${endyear}">
							<option value="${status.index}">${status.index}</option>
						</c:forEach>
					</select>
					<select id="searchmonth" name="searchmonth" style="width:auto; min-width:60px" >
						<option value="">선택</option>
						<c:forEach var="item" varStatus="status" begin="1" end="12">
							<c:set var="monthVal" value="${status.index}"/>
							<c:if test="${status.index < 10}">
								<c:set var="monthVal" value="0${status.index}"/>
							</c:if>
							<option value="${monthVal}">${monthVal}</option>
						</c:forEach>
					</select>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>	
				</th>
			</tr>
			<tr>
				<th scope="row">조회</th>
				<td>
					<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
						<option value="">전체</option>
						<option value="1">ABO번호</option>
						<option value="2">이름</option>
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
			
			<span> Total : <span id="totalcount">0</span>건</span>
		</div>
		
		<div class="fr">
			<div style="float:right;">
				<a href="javascript:;" id="insertExcel" class="btn_green">엑셀 등록</a>
			</div>
		</div>
	</div>
	
	<!-- grid -->	
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
</body>
</html>