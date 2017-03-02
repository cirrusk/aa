<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>


<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.common.list"
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
	
	basePenaltyList.init();
	basePenaltyList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		basePenaltyList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		basePenaltyList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 취소 패널티 추가 버튼 클릭시
	$("#aBasePenaltyCencelInsert").on("click", function(){
		var popParam = {
				url : "<c:url value="/manager/reservation/basePenalty/basePenaltyCencelInsertPop.do" />"
				, width : "778"
				, height : "300"
				, params : {"frmId" : $("input[name=frmId]").val()}
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});
	
	// No Show 패널티 등록 버튼 클릭시
	$("#aBasePenaltyNoShowInsert").on("click", function(){
		var popParam = {
				url : "<c:url value="/manager/reservation/basePenalty/basePenaltyNoShowInsertPop.do" />"
				, width : "778"
				, height : "300"
				, params : {"frmId" : $("input[name=frmId]").val()}
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});

	// 요리명장 패널티 등록 버튼 클릭시
	$("#aBasePenaltyCookingInsert").on("click", function(){
		var popParam = {
				url : "<c:url value="/manager/reservation/basePenalty/basePenaltyCookingInsertPop.do" />"
				, width : "778"
				, height : "300"
				, params : {"frmId" : $("input[name=frmId]").val()}
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});
	
});

/* 패널티 정책 수정 */
function basePenaltyUpdatePop(penaltyseq) {
	var popParam = {
			url : "<c:url value="/manager/reservation/basePenalty/basePenaltyUpdatePop.do" />"
			, width : "778"
			, height : "400"
			, params : {"penaltySeq" : penaltyseq
				, "frmId" : $("input[name=frmId]").val()}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

//Grid Init
var basePenaltyListGrid = new AXGrid(); // instance 상단그리드
var basePenaltyList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"NO.", width:"100", align:"center", formatter:"money", sort:false}
							, {key:"typecode", label:"구분", width:"200", align:"center", sort:false}
							, {key:"typedetailcode", label:"취소 기준", width:"150", align:"center", sort:false}
							, {key:"applytypecode", addClass:idx++, label:"패널티", width:"200", align:"center"}
							, {key:"updatedate", addClass:idx++, label:"최종수정일시", width:"200", align:"center"}
							, {key:"updateuser", addClass:idx++, label:"최종수정자", width:"100", align:"center"}
							, {key:"statuscode", addClass:idx++, label:"상태", width:"100", align:"center"}
							, {key:"btns", addClass:idx++, label:"수정", width:"100", align:"center", formatter: function(){
								if(param.menuAuth == "W"){
									return "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javasctipt:basePenaltyUpdatePop('"+this.item.penaltyseq+"')\">수정</a>";
								}else{
									return "";
								}
							  }}
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
									, {colSeq: 7, rowspan: 2, valign:"middle"}
			                  	]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : basePenaltyList.doSortSearch
					, doPageSearch : basePenaltyList.doPageSearch
				}
			
			fnGrid.initGrid(basePenaltyListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			basePenaltyList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			basePenaltyList.doSearch(param);
			
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				searchStatusCode : $("#searchStatusCode option:selected").val()
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/reservation/basePenalty/basePenaltyListAjax.do"/>"
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
		   		basePenaltyListGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">패널티정책</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*"  />
				<col width="20%" />
			</colgroup>
			<tr>
				<th>상태</th>
				<td scope="row">
					<select id="searchStatusCode" name="searchStatusCode" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" items="${useStateCodeList}">
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
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount}"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" id="aBasePenaltyCencelInsert" class="btn_green authWrite">취소 패널티 추가</a>
			<a href="javascript:;" id="aBasePenaltyNoShowInsert" class="btn_green authWrite">No Show 패널티 추가</a>
			<a href="javascript:;" id="aBasePenaltyCookingInsert" class="btn_green authWrite">요리명장 패널티 추가</a>
		</div>
	</div>
	
	<input type="hidden" name="frmId" value="${param.frmId}" />
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
	
</body>