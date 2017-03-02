<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<style>
.gray {
  background-color: #bcc1c7;
}
</style>
<script type="text/javascript">	
var managerMenuAuth ="${managerMenuAuth}";
//Grid Init
var listGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
//Grid Default Param
var defaultParam = {
	page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.banner.list"
 	, sortIndex: 0
 	, sortOrder:"ASC"
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
		if(checkManagerAuth(managerMenuAuth)){return;}
		goWrite('I','');
		return;
	});
	
	// 순서 저장 버튼 클릭시
	$("#saveOrderButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		goSaveOrder();
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
				searchposition : $("#searchposition").val()	
				, searchopenflag :$("#searchopenflag").val()
				, searchstartregistrantdate :$("#searchstartregistrantdate").val()
				, searchendregistrantdate :$("#searchendregistrantdate").val()
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, initParam);
			postGoto("<c:url value="/manager/lms/banner/lmsBannerExcelDownload.do"/>", defaultParam);
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
			{key:"bannerid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
				return this.item.___checked && this.item.___checked["1"];
            }}	
			, {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
			, {key:"positionname", label:"출력위치", width:"90", align:"center", sort:false}
			, {key:"bannername", label:"배너명", width:"400", align:"center", sort:false, formatter: function () {
				return "<a href=\"javascript:;\" onclick=\"javascript:goWrite('U', '" + this.item.bannerid + "');\">"+this.item.bannername+"</a>";
			}}
			, {key:"bannerdate", label:"노출일", width:"300", align:"center", sort:false, 
				addClass: function () {
                    if (this.item.bannerdateyn == 'N' && this.item.openflag == 'Y') {
                        return "gray";
                    }  
                }	
			}
			, {key:"registrantdate2", label:"등록일", width:"160", align:"center", sort:false}
			, {key:"modifydate2", label:"최종수정일", width:"160", align:"center", sort:false}
			, {key:"openflagname", label:"상태", width:"80", align:"center", sort:false}
			, {key:"openflag", label:"공개여부", width:"80", align:"center", sort:false, display:false}
			, {key:"bannerorder", label:"출력순서", width:"80", align:"center", sort:false, formatter: function () {
					var selectTag = "";
					selectTag += "<select id='bannerorder_"+this.item.no.number()+"' name='bannerorders' onchange='changeBannerOrder(this.value, "+this.index+")'>";
					for(var i = 1; i<=100; i++){
						selected = "";
						if(this.item.bannerorder == i){
							selected = "selected";
						}
						selectTag += "<option value='"+i+"' "+selected+">"+i+"</option>                             ";
					}
					selectTag += "</select>  ";
					return selectTag;
				}
			}
			, {key:"beforebannerorder", label:"이전출력순서", width:"80", align:"center", sort:false, display:false}
			,{
				key:"edit", label:"수정", width:"80", align:"center", sort:false, formatter: function () {
					return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goWrite('U', '" + this.item.bannerid + "');\">수정</a>";
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
				searchposition : $("#searchposition").val()	
				, searchopenflag :$("#searchopenflag").val()
				, searchstartregistrantdate :$("#searchstartregistrantdate").val()
				, searchendregistrantdate :$("#searchendregistrantdate").val()
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
		};
		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);
		
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/banner/lmsBannerListAjax.do"/>"
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
		// 공개인 경우 체크
		var listIdx = listGrid.getCheckedListWithIndex(0);
		for(var i = 0; i<listIdx.length;i++) {
			if( listIdx[i].item.openflag != "N") {
				if( !confirm(listIdx[i].item.bannername + " 배너가 공개 설정 되어 있습니다.\n삭제하시겠습니까?")){
					return;	
				}
			}
		}
	// 선택 정보 삭제전 메세지 출력
		var checkedList = listGrid.getCheckedParams(0, false);// colSeq
		var len = checkedList.length;
		if(len == 0){
			alert("선택된 배너가 없습니다.");
			return;
		}
		var result = confirm("선택한 배너를 삭제 하겠습니까?"); 
		
		if(result) {
			$.ajaxCall({
				url: "<c:url value="/manager/lms/banner/lmsBannerDeleteAjax.do"/>"
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
function goWrite(mode, bannerid){
	// 상세 tabpage
	var strMenuCd   = frmid + "_W";
	var strMenuText = "배너등록";
	var strLinkurl = "/manager/lms/banner/lmsBannerWrite.do";
	// 탭이동시 열려있으면 닫고 이동한다.
	if(window.parent.g_managerLayerMenuId.sessionOnBannerid != null && window.parent.g_managerLayerMenuId.sessionOnBannerid != bannerid){
		window.parent.closeTabMenu(strMenuCd);
	}
	// 전역변수 처리
	window.parent.g_managerLayerMenuId.sessionOnBannerid  = bannerid;
	
	var item = { 
		menuCd   : strMenuCd
		, menuText : strMenuText
		, linkurl  : strLinkurl
		, menuYn   : 'Y'
		, callFn   : 'reloadFrame' 
		, funcData : ''
		, urlParam : "mode="+mode+"&bannerid="+bannerid+"&prefrmId="+frmid
	};
	window.parent.addTabMenu(Object.toJSON(item));
	return;
}
function changeBannerOrder(val, index){
	listGrid.list[index].bannerorder = val;
}
function goSaveOrder(){
	//권한체크함수
	if(checkManagerAuth(managerMenuAuth)){return;}
	if( !confirm("순서 정보를 저장하겠습니까?") ) {
		return;
	}
	
	var bannerids = [];
	var bannerorders = [];
	var beforebannerorders = [];
	for(var i = 0; i < listGrid.list.length; i++){
		bannerids[i] = listGrid.list[i].bannerid + "";
		bannerorders[i] = listGrid.list[i].bannerorder + "";
		beforebannerorders[i] = listGrid.list[i].beforebannerorder + "";
	}
	var param = {
			courseid : $("#courseid").val()
			, bannerids : bannerids
			, bannerorders : bannerorders
			, beforebannerorders : beforebannerorders
	}
	$.ajaxCall({
   		url: "<c:url value="/manager/lms/banner/lmsBannerOrderUpdateAjax.do"/>"
   		, data: param
   		, success: function( data, textStatus, jqXHR){
        		alert("저장완료하였습니다.");
        		list.doSearch({page:1});
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
   		}
   	});
	
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
		<h2 class="fl">배너</h2>
	</div>
	
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
				<th>출력위치</th>
				<td>
					<select id="searchposition" name="searchposition" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach items="${bannerPostionList}" var="items">
							<option value="${items.value}">${items.name}</option>
						</c:forEach>
					</select>
				</td>
				<th>상태</th>
				<td>
					<select id="searchopenflag" name="searchopenflag" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="N">비공개</option>
						<option value="Y">공개</option>
					</select>
				</td>
				<th rowspan="4">
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
						<option value="1">배너명</option>
						<option value="2">이미지설명</option>
					</select>
					<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
				</td>
			</tr>
		</table>
		* 사용자 화면에 20개 이상 노출 시 디자인이 깨질 수 있습니다.
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
				<a href="javascript:;" id="saveOrderButton" class="btn_green">순서저장</a>
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