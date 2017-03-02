<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.comon.BaseRuleList"
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
    
	baseRuleList.init();
	baseRuleList.doSearch({page:1});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		baseRuleList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		baseRuleList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 추가 버튼 클릭시
	$("#aBaseRuleInsert").on("click", function(){
		
		var popParam = {
				url : "<c:url value="/manager/reservation/baseRule/baseRuleInsertPop.do" />"
				, width : "1024"
				, height : "1050"
// 				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});
});

function baseRuleDetail(settingseq){
	var param = {
			settingSeq : settingseq
	};
	
	//console.log(param);
	
	var popParam = {
			url : "<c:url value="/manager/reservation/baseRule/baseRuleDetailPop.do"/>"
			, width : "1024"
			, height : "800"
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
var baseRuleListGrid = new AXGrid(); // instance 상단그리드
var baseRuleList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
							, {key:"role", label:"자격", width:"200", align:"center", sort:false}
							, {key:"globaldailycount", addClass:idx++, label:"일", width:"100", align:"center", sort:false}
							, {key:"globalweeklycount", addClass:idx++, label:"주", width:"100", align:"center", sort:false}
							, {key:"globalmonthlycount", addClass:idx++, label:"월", width:"100", align:"center", sort:false}
							, {key:"ppdailycount", addClass:idx++, label:"일", width:"100", align:"center", sort:false}
							, {key:"ppweeklycount", addClass:idx++, label:"주", width:"100", align:"center", sort:false}
							, {key:"ppmonthlycount", addClass:idx++, label:"월", width:"100", align:"center", sort:false}
							, {key:"statusname", addClass:idx++, label:"상태", width:"150", align:"center", sort:false}
							, {key:"updatedate", addClass:idx++, label:"최종수정일시", width:"200", align:"center", sort:false}
							, {key:"updateuser", addClass:idx++, label:"최종수정자", width:"100", align:"center", sort:false}
							, {key:"btns", addClass:idx++, label:"수정", width:"100", align:"center", formatter: function(){
								if(param.menuAuth == "W"){
									return "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javascript:baseRuleDetail('"+this.item.settingseq+"')\">수정</a>";
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
									, {colseq:null, colspan: 3, label: "전국PP 예약 제한 횟수", align: "center", valign:"middle"}
									, {colseq:null, colspan: 3, label: "PP별 예약 제한 횟수", align: "center", valign:"middle"}
									, {colSeq: 8, rowspan: 2, valign:"middle"}
									, {colSeq: 9, rowspan: 2, valign:"middle"}
									, {colSeq: 10, rowspan: 2, valign:"middle"}
									, {colSeq: 11, rowspan: 2, valign:"middle"}
			                  	], [
										 {colSeq: 2}
										,{colSeq: 3}
										,{colSeq: 4}
										,{colSeq: 5}
										,{colSeq: 6}
										,{colSeq: 7}
				                      ]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : baseRuleList.doSortSearch
					, doPageSearch : baseRuleList.doPageSearch
				}
			
			fnGrid.initGrid(baseRuleListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			baseRuleList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			baseRuleList.doSearch(param);
			
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				searchStateCode : $("#searchStateCode option:selected").val()
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/reservation/baseRule/baseRuleListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		   				var mag = '<spring:message code="errors.load"/>';
		   				alert(mag);
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
		   		//console.log(obj);

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
		   		baseRuleListGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">누적예약가능 횟수</h2>
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
				<th>상태</th>
				<td scope="row">
					<select id="searchStateCode" name="searchStateCode" style="width:auto; min-width:100px" >
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
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" id="aBaseRuleInsert" class="btn_green authWrite">등록</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
		
</body>