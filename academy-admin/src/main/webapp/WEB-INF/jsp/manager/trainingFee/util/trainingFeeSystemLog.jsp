<!-- 시스템 로그 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
//Grid Init
var trainingFeeSystemLogGrid = new AXGrid(); // instance 상단그리드


//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount}"
 	, sortColKey: "trainingfee.util.utillist"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeSystemLog.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeSystemLog.doSearch({page:1});
	});
	
	$("#btnConfrimDt").on("click", function(){
		$("input[name='fromConfrimDt']").val("");
		$("input[name='toConfrimDt']").val("");
	});
	
	var getDate = new Date();
	var smonth = getDate.getMonth()+1;
	if(getDate.getMonth()+1<10) smonth = "0"+smonth;
	
	$("input[name='fromConfrimDt']").val(getDate.getFullYear()+"-"+smonth+"-01");
	$("input[name='toConfrimDt']").val(setToDay());
	
	$("#aboSearch").aboSearch("DepositNm","btnDepSearch","txtSearchType","${param.frmId}");
	
	trainingFeeSystemLog.init();
});

function doReturnValue(param) {
	$("select[name='txtSearchType']").val("1");
	$("input[name='DepositNm']").val(param.uid);
}

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

var trainingFeeSystemLog = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", addClass:idx++, label:"No.", width:"40", align:"center", sort:false}
							, {key:"registrantdate", label:"발생일시", width:"200", align:"center", sort:false}
							, {key:"abo_no", label:"ABO 번호", width:"100", align:"center", sort:false}
							, {key:"name", label:"ABO 이름", width:"200", align:"center", sort:false}
							, {key:"systemtype", addClass:idx++, label:"시스템구분", width:"100", align:"center"}
							, {key:"systemtext", addClass:idx++, label:"Process Event Id", width:"300", align:"center"}
						]
			
			var gridParam = { 
					colGroup : _colGroup
					, fitToWidth: true
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeSystemLog.doSortSearch
					, doPageSearch : trainingFeeSystemLog.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeSystemLogGrid, gridParam);
			trainingFeeSystemLog.doSearch();
		}, doPageSearch : function(pageNo) {
			defaultParam.page=pageNo;
			// Grid Page List
			trainingFeeSystemLog.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeSystemLog.doSearch(param);
		}, doSearch : function(param) {
			if(isNull($("input[name='fromConfrimDt']").val()) && !isNull($("input[name='toConfrimDt']").val()) ) {
				alert("[검색조건] 일자 시작/종료일자 둘다 입력 해주세요!");
				return;
			} else if(!isNull($("input[name='fromConfrimDt']").val()) && isNull($("input[name='toConfrimDt']").val()) ) {
				alert("[검색조건] 일자 시작/종료일자 둘다 입력 해주세요!");
				return;
			}
			
			// Param 셋팅(검색조건)
			var initParam = {
					    searchDepSchType : $("#txtDepSearchType").val()
					  , searchDepositNm  : $("#DepositNm").val()
					  , fromConfrimDt    : $("input[name='fromConfrimDt']").val()
					  , toConfrimDt      : $("input[name='toConfrimDt']").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({ 		   		
		   		url: "<c:url value="/manager/trainingFee/util/selectSystemLog.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   				callbackList(data);
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
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
		   		
		   		// Grid Bind Real
		   		trainingFeeSystemLogGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">시스템로그</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">UTIL</a></li>
				<li class="end"><a href="#">시스템로그</a></li>
			</ul>
		</div>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*"  />
				<col width="10%" />
				<col width="30%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<tr>
				<th>ABO</th>
				<td colspan="3">
					<div id="aboSearch">
						<select id="txtDepSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
							<option value="1">ABO 번호</option>
							<option value="2">ABO 이름</option>
						</select>
						<input type="text" id="DepositNm" name="DepositNm" style="width:auto; min-width:100px" >
						<a href="javascript:;" id="btnDepSearch" name="btnDepSearch" class="btn_gray btn_mid">검색</a>
					</div>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th scope="row">일자</th>
				<td colspan="3">
					<input type="text" id="fromConfrimDt" name="fromConfrimDt" class="AXInput datepDay" readonly="readonly">
					~
					<input type="text" id="toConfrimDt" name="toConfrimDt" class="AXInput datepDay" readonly="readonly">
					<a href="javascript:;" id="btnConfrimDt" class="btn_gray btn_mid">Reset</a>
				</td>
			</tr>
		</table>
	</div>
			
	<div class="contents_title clear">
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>		
		</div>
		<div class="fr">
<!-- 			<a href="javascript:;" id="aInsert" class="btn_orange">추가</a> -->
<!-- 			<a href="javascript:;" id="aInsertEnd" class="btn_orange">종료</a>			 -->
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>