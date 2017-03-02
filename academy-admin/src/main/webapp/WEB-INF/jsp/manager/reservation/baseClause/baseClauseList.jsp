<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.comon.BaseClause"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
    param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
    
    if(param.menuAuth == "W"){
        $(".authWrite").show();
    }else{
        $(".authWrite").hide();
    }

	baseClauseList.init();
	baseClauseList.doSearch({page:1});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		baseClauseList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		baseClauseList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 추가 버튼 클릭시
	$("#aBaseClausInsert").on("click", function(){
		
		var param = {
			frmId : "${param.frmId}"
		};
		
		var popParam = {
				url : "<c:url value="/manager/reservation/baseClause/baseClauseInsertPop.do" />"
				, width : "1024"
				, height : "1050"
				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});
});

function baseClauseDetail(clauseseq){
   	var param = {
		  frmId : "${param.frmId}"
		, clauseseq : clauseseq
	};
	
	var popParam = {
			url : "<c:url value="/manager/reservation/baseClause/baseClauseDetailPop.do" />"
			, width : "1024"
			, height : "1050"
			, params : param
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}
	

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

//Grid Init
var baseClauseListGrid = new AXGrid(); // instance 상단그리드
var baseClauseList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
							, {key:"typename", label:"약관 타입", width:"100", align:"center", sort:false}
							, {key:"title", addClass:idx++, label:"약관 제목", width:"500", align:"center", sort:false, formatter:function(){
								return "<a href=\"javascript:;\" onclick=\"javascript:baseClauseDetail('" + this.item.clauseseq + "');\">"+this.item.title+"</a>";
							}}
							, {key:"mandatoryname", addClass:idx++, label:"필수여부", width:"100", align:"center"}
							, {key:"version", addClass:idx++, label:"버전", width:"100", align:"center"}
							, {key:"insertuser", addClass:idx++, label:"등록자", width:"100", align:"center"}
							, {key:"insertdate", addClass:idx++, label:"등록일시", width:"150", align:"center"}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, colHead : { heights: [20,20],
						 rows : [
			                     [
									  {colSeq: 0, rowspan: 2, valign:"middle"}
									, {colSeq: 1, rowspan: 2, valign:"middle"}
									, {colSeq: 2, rowspan: 2, valign:"middle"}
									, {colSeq: 3, rowspan: 2, valign:"middle"}
									, {colSeq: 4, rowspan: 2, valign:"middle"}
									, {colSeq: 5, rowspan: 2, valign:"middle"}
									, {colSeq: 6, rowspan: 2, valign:"middle"}
			                  	]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : baseClauseList.doSortSearch
					, doPageSearch : baseClauseList.doPageSearch
				}
			
			fnGrid.initGrid(baseClauseListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			baseClauseList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			baseClauseList.doSearch(param);
			
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				searchStateCode : $("#searchStateCode option:selected").val()
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/reservation/baseClause/baseClauseListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		           		alert("처리도중 오류가 발생하였습니다.");
		           		return;
		   			} else {
		   				callbackList(data);
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
		   		}
		   	});			
 		   	
 		   	

		   	function callbackList(data) {
		   		
		   		var obj = data; //JSON.parse(data);
// 		   		console.log(obj);

		   		// Grid Bind
		   		var gridData = {
			   			list: obj.dataList,
			   			page:{
			   				pageNo: obj.page,
			   				pageSize: defaultParam.rowPerPage,
			   				pageCount: obj.totalPage,
			   				listCount: obj.totalCount
			   			}
			   		};
		   		
		   		// Grid Bind Real
		   		baseClauseListGrid.setData(gridData);
		   	}
		}
	}
function doReturn() {
	baseClauseList.doSearch({page : 1});
}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">약관 관리</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="200px"/>
				<col width="*"/>
				<col width="200px"/>
			</colgroup>
			<tr>
				<th>약관타입</th>
				<td scope="row">
					<select id="searchStateCode" name="searchStateCode" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" items="${clauseTypeCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				
				<th>
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
				
			</tr>
		</table>
	</div>

	<div class="contents_title clear">
		<br/>
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" id="aBaseClausInsert" class="btn_green authWrite">등록</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
		
</body>