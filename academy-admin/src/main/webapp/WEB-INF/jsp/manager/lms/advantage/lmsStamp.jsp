<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//권한 변수
var managerMenuAuth ="${managerMenuAuth}";

//Grid Init
var listGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
//Grid Default Param
var defaultParam = {
	page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.stamp.list"
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
	
	// 검색버튼 클릭 효과주기
	$("#btnSearch").trigger("click");
	
	// 추가 버튼 클릭시
	$("#insertButton").on("click", function(){
		//권한 체크 함수
		if(checkManagerAuth(managerMenuAuth)){return;}
		
		goWrite('I','');
		return;
	});
	
	// 삭제 버튼 클릭시
	$("#deleteButton").on("click", function(){
		//권한 체크 함수
		if(checkManagerAuth(managerMenuAuth)){return;}
		
		gridEvent.chkDelete();
	});
	
	// 엑셀다운 버튼 클릭시
	$("#aExcdlDown").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
				searchstamptype : $("#searchstamptype").val()	
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/advantage/lmsStampExcelDownload.do"/>", defaultParam);
			hideLoading();
		}
	});	
});

var list = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
				{key:"stampid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
                        return this.item.___checked && this.item.___checked["1"];
             	}}	
				, {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
				, {key:"stampname", label:"스탬프명", width:"300", align:"center", sort:false, formatter: function () {
					return "<a href=\"javascript:;\" onclick=\"javascript:goWrite('U', '" + this.item.stampid + "');\">"+this.item.stampname+"</a>";
				} }
				, {key:"stampcondition", label:"조건", width:"300", align:"center", sort:false}
				, {key:"stamptypename", label:"구분", width:"100", align:"center", sort:false}
				,{
					key:"edit", label:"수정", width:"100", align:"center", sort:false, formatter: function () {
						return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goWrite('U', '" + this.item.stampid + "');\">수정</a>";
					}
				}
			]
			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: true
				, colHead : { heights: [25,25]}
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : list.doSortSearch
				, doPageSearch : list.doPageSearch
			}
			
			fnGrid.initGrid(listGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			list.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(listGrid.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			list.doSearch(sortParam);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			var initParam = {
				searchstamptype : $("#searchstamptype").val()	
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/advantage/lmsStampListAjax.do"/>"
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
	
var gridEvent = {
	chkDelete : function() {
		// 선택 정보 삭제전 메세지 출력
		var checkedList = listGrid.getCheckedParams(0, false);// colSeq
		var len = checkedList.length;
		if(len == 0){
			alert("선택된 스탬프가 없습니다.");
			return;
		}
		var result = confirm("선택한 스탬프를 삭제 하시겠습니까?"); 
		
		if(result) {
			$.ajaxCall({
				url: "<c:url value="/manager/lms/advantage/lmsStampDeleteAjax.do"/>"
				, data: jQuery.param(checkedList)
				, success: function(data, textStatus, jqXHR){
					alert(data.cnt + "건이 삭제 되었습니다.");
					list.doSearch();
				},
				error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
				}
			});
		}
	}
}
function goWrite(mode, stampid){
	var param = {
			mode : mode ,
			stampid : stampid
	};
	var popParam = {
			url : "<c:url value="/manager/lms/advantage/lmsStampWrite.do" />"
			, width : 1024
			, height : 800
			, maxHeight : 800
			, params : param
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}
function listRefresh(){
	var pageNo = $(".AXgridPageNo").val();
	list.doSearch({page:pageNo});
}

</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">스탬프 관리</h2>
	</div>
	
	<!--search table // -->

	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="10%"  />
				<col width="10%" />
				<col width="* />
				<col width="10%" />
			</colgroup>
			<tr>
				<th>구분</th>
				<td>
					<select id="searchstamptype" name="searchstamptype" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="N">일반</option>
						<option value="C">정규과정</option>
						<!-- <option value="U">목표달성</option> -->
					</select>
				</td>
				<th>조회</th>
				<td>
					<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
						<option value="">전체</option>
						<option value="1">스탬프명</option>
						<option value="2">조건</option>
						<option value="3">설명</option>
					</select>
					<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:100px" >
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
				<option value="20">20</option>
				<option value="50">50</option>
				<option value="500">500</option>
				<option value="1000">1000</option>
			</select>
			<a href="javascript:;" id="deleteButton" class="btn_green">삭제</a>
			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
			
			
			<span> Total : <span id="totalcount"></span>건</span>
		</div>
		
		<div class="fr">
			<div style="float:right;">
				<a href="javascript:;" id="insertButton" class="btn_green">등록</a>
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