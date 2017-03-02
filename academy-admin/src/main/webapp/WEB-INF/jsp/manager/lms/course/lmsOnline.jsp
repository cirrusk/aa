<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var managerMenuAuth ="${managerMenuAuth}";
var listGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
//Grid Default Param
var defaultParam = {
	page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.online.list"
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
		var searchstartregistrantdate = $("#searchstartregistrantdate").val();
		var searchendregistrantdate = $("#searchendregistrantdate").val();
		if(searchstartregistrantdate != "" && searchendregistrantdate != ""){
			if( searchendregistrantdate < searchstartregistrantdate ){
				alert("등록일 검색 종료일이 시작일 보다 크거나 같아야 합니다.");
				return;
			}
		}
		list.doSearch({page:1});
	});
	
	// 검색버튼 클릭 효과주기
	$("#btnSearch").trigger("click");
	
	// 등록 버튼 클릭시
	$("#insertButton").on("click", function(){
		goWrite('I','');
		return;
	});
	
	// 삭제 버튼 클릭시
	$("#deleteButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		gridEvent.chkDelete();
	});
	
	// 엑셀다운 버튼 클릭시
	$("#aExcdlDown").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var initParam = {
				searchcategoryid : $("#searchcategoryid").val()	
				, searchopenflag :$("#searchopenflag").val()
				, searchstartregistrantdate :$("#searchstartregistrantdate").val()
				, searchendregistrantdate :$("#searchendregistrantdate").val()
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/course/lmsOnlineExcelDownload.do"/>", defaultParam);
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
				{key:"courseid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
                        return this.item.___checked && this.item.___checked["1"];
             	}}	
				, {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
				, {key:"categorytreename", label:"교육분류", width:"200", align:"center", sort:false}
				, {key:"coursename", label:"과정명", width:"500", align:"center", sort:false, formatter: function () {
					return "<a href=\"javascript:;\" onclick=\"javascript:goWrite('U', '" + this.item.courseid + "');\">"+this.item.coursename+"</a>";
				} }
				, {key:"registrantdate", label:"등록일", width:"120", align:"center", sort:false}
				, {key:"openflagname", label:"상태", width:"80", align:"center", sort:false}
				, {key:"openflag", label:"공개여부", width:"80", align:"center", sort:false, display:false}
				, {key:"unitcount", label:"정규과정구성수", width:"80", align:"center", sort:false, display:false}
				,{
					key:"edit", label:"수정", width:"80", align:"center", sort:false, formatter: function () {
						return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goWrite('U', '" + this.item.courseid + "');\">수정</a>";
					}
				}
			]
			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
					//, fixedColSeq: 3
				, colHead : { heights: [25,25]}
				, targetID : "AXGridTarget"
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
				searchcategoryid : $("#searchcategoryid").val()	
				, searchopenflag :$("#searchopenflag").val()
				, searchstartregistrantdate :$("#searchstartregistrantdate").val()
				, searchendregistrantdate :$("#searchendregistrantdate").val()
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/course/lmsOnlineListAjax.do"/>"
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
		// 수강생이 있는 경우 체크
		var listIdx = listGrid.getCheckedListWithIndex(0);
		for(var i = 0; i<listIdx.length;i++) {
			if( listIdx[i].item.openflag != "N") {
				if( !confirm(listIdx[i].item.coursename + " 과정이 공개 설정 되어 있습니다.\n삭제하시겠습니까?")){
					return;	
				}
			}
		}
		for(var i = 0; i<listIdx.length;i++) {
			if( listIdx[i].item.unitcount != "0") {
				if( !confirm(listIdx[i].item.coursename + " 과정이 정규과정에 설정 되어 있습니다.\n삭제하시겠습니까?")){
					return;	
				}
			}
		}
		
		// 선택 정보 삭제전 메세지 출력
		var checkedList = listGrid.getCheckedParams(0, false);// colSeq
		var len = checkedList.length;
		if(len == 0){
			alert("선택된 과정이 없습니다.");
			return;
		}
		var result = confirm("선택한 과정을 삭제 하시겠습니까?"); 
		
		if(result) {
			$.ajaxCall({
				url: "<c:url value="/manager/lms/course/lmsOnlineDeleteAjax.do"/>"
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
function goWrite(mode, courseid){
	if(courseid == ""){
		if(checkManagerAuth(managerMenuAuth)){return;}
	}
	// 상세 tabpage
	var strMenuCd   = frmid + "_W";
	var strMenuText = "온라인과정등록";
	var strLinkurl = "/manager/lms/course/lmsOnlineWrite.do";
	// 탭이동시 열려있으면 닫고 이동한다.
	if(window.parent.g_managerLayerMenuId.sessionOnOncourseid != null && window.parent.g_managerLayerMenuId.sessionOnOncourseid != courseid){
		window.parent.closeTabMenu(strMenuCd);
	}
	// 전역변수 처리
	window.parent.g_managerLayerMenuId.sessionOnOncourseid  = courseid;
	
	var item = { 
		menuCd   : strMenuCd
		, menuText : strMenuText
		, linkurl  : strLinkurl
		, menuYn   : 'Y'
		, callFn   : 'reloadFrame' 
		, funcData : ''
		, urlParam : "mode="+mode+"&courseid="+courseid+"&prefrmId="+frmid
	};
	window.parent.addTabMenu(Object.toJSON(item));
	return;
	
	//본창에서 등록
	location.href="/manager/lms/course/lmsOnlineWrite.do?mode="+mode+"&courseid="+courseid;
	return;
	//팝업창등록
	var param = {
			mode : mode ,
			courseid : courseid
	};
	var popParam = {
			url : "<c:url value="/manager/lms/course/lmsOnlineWrite.do" />"
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
		<h2 class="fl">온라인과정</h2>
	</div>
	
	<!--search table // -->

	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*"  />
				<col width="10%" />
				<col width="20%" />
				<col width="140" />
			</colgroup>
			<tr>
				<th>교육분류</th>
				<td>
					<c:set var="courseTypeCode" value="O"/>
					<%@ include file="/WEB-INF/jsp/manager/lms/include/lmsSearchCategory.jsp" %>
				</td>
				<th>상태</th>
				<td>
					<select id="searchopenflag" name="searchopenflag" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="N">비공개</option>
						<option value="Y">공개</option>
						<option value="C">정규과정</option>
					</select>
				</td>
				<th rowspan="3">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th>등록일</th>
				<td colspan="3">
					<input type="text" id="searchstartregistrantdate" name="searchstartregistrantdate" class="AXInput datepDay"> ~ 
					<input type="text" id="searchendregistrantdate" name="searchendregistrantdate" class="AXInput datepDay">
				</td>
			</tr>
			<tr>
				<th>조회</th>
				<td colspan="3">
					<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
						<option value="">전체</option>
						<option value="1">과정명</option>
						<option value="2">교육소개</option>
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
		<div id="AXGridTarget"></div>
	</div>
			
	<!-- Board List -->
		
</body>
</html>