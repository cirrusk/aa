<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>
<%-- 
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %> --%>

<script type="text/javascript">
//Grid Init
var listGrid2 = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";
var copyId = "${param.copyId}";
//Grid Default Param
var defaultParam = {
	page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.regular.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

var list2 = {
		/** init : 초기 화면 구성 (Grid)
		*/
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							 {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
							 , {key:"coursetype", label:"교육구분", width:"200", align:"center", sort:false, display:false}
							 , {key:"coursetypename", label:"교육구분명", width:"200", align:"center", sort:false, display:false}
							, {key:"categorytreename", label:"교육분류", width:"200", align:"center", sort:false}
							, {key:"coursename", label:"과정명", width:"400", align:"center", sort:false}
							, {key:"edudate", label:"교육기간", width:"160", align:"center", sort:false}
							,{
								key:"edit", label:"선택", width:"84", align:"center", sort:false, formatter: function () {
									return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:selectUnit(" + this.index + ");\">선택</a>";
								}
							}
						]
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
 					//, fixedColSeq: 3
					, colHead : { heights: [25,25]}
					, targetID : "AXGridTarget2"
					, sortFunc : list2.doSortSearch
					, doPageSearch : list2.doPageSearch
				}
			
			fnGrid.initGrid(listGrid2, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			list2.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(listGrid2.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			list2.doSearch(sortParam);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			var initParam = {
					searchcategoryid : $("#searchcategoryid").val()	
				  , searchcoursetype :$("#searchcoursetype").val()
				  , searchstartdate :$("#searchstartdate").val()
				  , searchenddate :$("#searchenddate").val()
				  , searchtype :$("#searchtype").val()
				  , searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
			$.ajaxCall({
		   		url: "/manager/lms/course/lmsRegularCourseSearchAjax.do"
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
		   		listGrid2.setData(gridData);
		   		
		   	}
			
		}
	}

function changedCourseType(obj){
	setLmsCategoryOptions(obj.value,"0", "searchcategoryid", 1);
}
function selectUnit(index){
	if(!confirm("선택된 과정을 정규과정에 적용하겠습니까?")){return;}
	//list에서 정보 읽기
	var item = listGrid2.list[index];
	item.copyId = copyId;
	item.coursemustflag = "N";
	$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.addStepUnitReturn(item);
	closeManageLayerPopup("searchPopup");
}

$(document.body).ready(function(){
	
	list2.init();
	
	// 페이지당 보기수 변경 이벤트
	$("#rowPerPage").on("change", function(){
		list2.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		var searchstartdate = $("#searchstartdate").val();
		var searchenddate = $("#searchenddate").val();
		if(searchstartdate != "" && searchenddate != ""){
			if( searchenddate, searchstartdate ){
				alert("교육기간 검색 종료일이 시작일 보다 크거나 같아야 합니다.");
				return;
			}
		}
		list2.doSearch({page:1});
	});
	
	// 검색버튼 클릭 효과주기
	$("#btnSearch").trigger("click");
});

</script>

<div id="popwrap">
	<!--pop_title //-->
	<div class="title clear">
		<h2 class="fl">구성과정 추가</h2>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	<!--// pop_title -->
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
			<!-- Sub Title -->
			<!-- 
			<div class="poptitle clear">
				<h3>교육분류 등록</h3>
			</div>
			 -->
			<!--// Sub Title -->
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="10%" />
						<col width="*"  />
						<col width="160px" />
					</colgroup>
					<tr>
						<th>구분</th>
						<td>
							<select id="searchcoursetype" name="searchcoursetype" onchange="changedCourseType(this);" style="width:auto; min-width:100px" >
							<c:forEach items="${courseTypeList}" var="items">
								<option value="${items.value}" >${items.name}</option>
							</c:forEach>
							</select>
						</td>
						<th rowspan="4">
							<div class="btnwrap mb10">
								<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
							</div>
						</th>
					</tr>
					<tr>
						<th>교육분류</th>
						<td>
							<c:set var="courseTypeCode" value="O"/>
							<%@ include file="/WEB-INF/jsp/manager/lms/include/lmsSearchCategory.jsp" %>
						</td>
					</tr>
					<tr>
						<th>기간</th>
						<td>
							<input type="text" id="searchstartdate" name="searchstartdate" class="AXInput datepDay"> ~ 
							<input type="text" id="searchenddate" name="searchenddate" class="AXInput datepDay">
						</td>
					</tr>
					<tr>
						<th>조회</th>
						<td>
							<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
								<option value="">전체</option>
								<option value="1">정규과정명</option>
								<option value="4">테마명</option>
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
					<span> Total : <span id="totalcount"></span>건</span>
				</div>
			</div>
	
			<!-- grid -->
			<div id="AXGrid2">
				<div id="AXGridTarget2"></div>
			</div>
			<br />
			<div align="center">
				<a href="javascript:;" id="closeBtn" class="btn_green close-layer">닫기</a>
			</div>
			<!-- Board List -->
		</div>
	</div>
</div>