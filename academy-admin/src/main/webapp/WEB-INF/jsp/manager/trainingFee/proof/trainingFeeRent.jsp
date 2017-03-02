<!-- 임차료 관리!! -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init 
var trainingFeeRentGrid = new AXGrid(); // instance 상단그리드
var lfrmId = "${param.frmId}";
var lmenuAuth = "${param.menuAuth}";

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount }" 
 	, sortColKey: "trainingfee.proof.rent"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	trainingFeeRent.init();
	
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeRent.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeRent.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	$("#aboSearch").aboSearch("DepositNm","btnDepSearch","txtSearchType","${param.frmId}");
	
	trainingFeeRent.doSearch();
	
	$("#getGridDetailView").on("click", function(){
		getGridDetailView(trainingFeeRentGrid.getExcelFormat("html"));
	});
});

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

function doReturnValue(param) {
	$("select[name='txtSearchType']").val("1");
	$("input[name='DepositNm']").val(param.uid);
}


var trainingFeeRent = {
	/** init : 초기 화면 구성 (Grid)
	*/		
	init : function() {
		var idx = 0; // 정렬 Index 
		var _colGroup = 
			[
				  {key:"row_num", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
				, {key:"abo_no", label:"ABO 번호", width:"100", align:"center", sort:false}
				, {key:"name", addClass:idx++, label:"ABO 성명", width:"150", align:"center"}
				, {key:"groupcode", addClass:idx++, label:"운영그룹", width:"80", align:"center"}
				, {key:"renttitle", addClass:idx++, label:"계약 명", width:"150", align:"left"}
				, {key:"rentfrommonth", addClass:idx++, label:"시작 월", width:"100", align:"center"}
				, {key:"renttomonth", addClass:idx++, label:"종료 월", width:"100", align:"center"}
				, {key:"renttypename", addClass:idx++, label:"신청형태", width:"80", align:"center"}
				, {key:"rentdeposit", addClass:idx++, label:"보증금", width:"150", align:"right", formatter: function(){
					var money = isNvl(this.item.rentdeposit,"0");
					if(!isNull(this.item.rentdeposit)) money = money.replace(".0","");
					return setComma(money);	
				}}
				, {key:"rentamount", addClass:idx++, label:"월 임대로", width:"150", align:"right", formatter: function(){
					var money = isNvl(this.item.rentamount,"0");
					if(!isNull(this.item.rentamount)) money = money.replace(".0","");
					return setComma(money);	
				}}
				, {key:"rentstatus", addClass:idx++, label:"처리상태", width:"100", align:"center"}
				, {
					key: "btns", label : "상세보기", width: "150", align: "center", formatter: function () {
						return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"trainingFeeRent.doSearchTab('" + this.item.fiscalyear  + "','" + this.item.abo_no + "','" + this.item.rentid + "','" + this.item.rentgroupcode + "','" + this.item.renttype + "')\">상세보기</a>";
					}
				}
			]
		
		var gridParam = {
				  colGroup : _colGroup
				, fitToWidth: true
				, colHead : { heights: [20,20]
				, rows : [
							[
								  {colSeq: 0, rowspan: 2, valign:"middle"}
								, {colSeq: 1, rowspan: 2, valign:"middle"}
								, {colSeq: 2, rowspan: 2, valign:"middle"}
								, {colSeq: 3, rowspan: 2, valign:"middle"}
								, {colSeq: 4, rowspan: 2, valign:"middle"}
								, {colseq:null, colspan: 2, label: "임대 기간", align: "center", valign:"middle"}
								, {colSeq: 7, rowspan: 2, valign:"middle"}
								, {colSeq: 8, rowspan: 2, valign:"middle"}
								, {colSeq: 9, rowspan: 2, valign:"middle"}
								, {colSeq: 10, rowspan: 2, valign:"middle"}
								, {colSeq: 11, rowspan: 2, valign:"middle"}
							], [
								 {colSeq: 5}
								,{colSeq: 6}
							]
						]
					}
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : trainingFeeRent.doSortSearch
				, doPageSearch : trainingFeeRent.doPageSearch
			}
		
		fnGrid.initGrid(trainingFeeRentGrid, gridParam);
	}, doPageSearch : function(pageNo) {
		defaultParam.page=pageNo;
		// Grid Page List
		trainingFeeRent.doSearch({page:pageNo});
	}, doSortSearch : function(sortKey){
		// Grid Sort
		defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
		var param = {
				sortIndex : sortKey
				, page : 1
		};
		
		// 리스트 갱신(검색)
		trainingFeeRent.doSearch(param);
	}, doSearch : function(param) {
		// Param 셋팅(검색조건)
		var initParam = {
					searchGiveYear : $("#searchGiveYear").val()	
				  , searchDepSchType :$("#txtDepSearchType").val()
				  , searchDepositNm :$("#DepositNm").val()
				  , searchBR :$("#cbSearchBR").val()
				  , searchGrpCd :$("#cbSearchGrp").val()
				  , searchCode :$("#cbSearchCode").val()
				  , searchLoa :$("#cbSearchLOA").val()
				  , searchCPin :$("#cbSearchCPin").val()
				  , searchDept :$("#cbSearchDept").val()
		};
	
		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);
		
	   	$.ajaxCall({
	   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeRentListAjax.do"/>"
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
	           	alert("처리도중 오류가 발생하였습니다.");
	   		}
	   	});			

	   	function callbackList(data) {
	   		
	   		var obj = data; //JSON.parse(data);
	   		$("#processCnt").text(obj.getCount.total_cnt);
	   		
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
	   		trainingFeeRentGrid.setData(gridData);
	   	}
	},
	doSearchTab : function(fiscalyear, abono, rentid,rentgroupcode, renttype) {
		// 상세 tabpage
		var strMenuCd   = "";
		var strMenuText = "";
		var strLinkurl = "";
		
		if(renttype=="person") {
			strMenuCd = "W03020040010";
			strMenuText = "임차료 상세보기(개인)";
			strLinkurl = '/manager/trainingFee/proof/trainingFeeRentDetail.do';	
		} else {
			strMenuCd = "W03020040020";
			strMenuText = "임차료 상세보기(그룹)";
			strLinkurl = '/manager/trainingFee/proof/trainingFeeRentDetailGrp.do';
		}
		
		// 전역변수 처리
		window.parent.g_managerLayerMenuId.sessionOnFiscalYear  = fiscalyear;
		window.parent.g_managerLayerMenuId.sessionOnAboNo     = abono;
		window.parent.g_managerLayerMenuId.sessionOnRentId    = rentid;
		window.parent.g_managerLayerMenuId.sessionOnRentGroupCode = rentgroupcode;
		window.parent.g_managerLayerMenuId.sessionOnFrmId       = lfrmId;
		window.parent.g_managerLayerMenuId.sessionOnMenuAuth    = lmenuAuth;
		
		var item = { menuCd   : strMenuCd
				   , menuText : strMenuText
				   , linkurl  : strLinkurl
				   , menuYn   : 'Y'
				   , callFn   : 'fn_init' 
		};
		
		window.parent.addTabMenu(Object.toJSON(item));
	}
}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">임차료 관리</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">교육비증빙</a></li>
				<li class="end"><a href="#">임차료 관리</a></li>
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
				<th>회계년도</th>
				<td scope="row">
					<input type="text" id="searchGiveYear" name="datepYear" class="AXInput datepYear setDateYear" readonly="readonly">
				</td>
				<th>ABO</th>
				<td scope="row">
					<div id="aboSearch">
						<label style="width:70px;text-align:right;">Deposit :</label>
						<select id="txtDepSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
							<option value="1">ABO 번호</option>
							<option value="2">ABO 이름</option>
						</select>
						<input type="text" id="DepositNm" name="DepositNm" style="width:auto; min-width:100px" >
						<a href="javascript:;" id="btnDepSearch" name="btnDepSearch" class="btn_gray btn_mid">검색</a>
					</div>
				</td>
				<th rowspan="4">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th scope="row">BR</th>
				<td>
					<select id="cbSearchBR" name="cbSearchBR">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchBR }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">운영그룹</th>
				<td>
					<select id="cbSearchGrp" name="cbSearchGrp">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchGrpCd }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">Code</th>
				<td>
					<select id="cbSearchCode" name="cbSearchCode">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchCode }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">LOA</th>
				<td>
					<select id="cbSearchLOA" name="cbSearchLOA">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchLOA }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">C.Pin</th>
				<td>
					<select id="cbSearchCPin" name="cbSearchCPin">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchCPin }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">Dept</th>
				<td>
					<select id="cbSearchDept" name="cbSearchDept">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchDept }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
	</div>
			
	<div class="contents_title clear">
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>
			<a href="javascript:;" id="getGridDetailView" class="btn_green">팝업보기</a>
		</div>
		<div class="fr">
			<div style="font-size:14px;font-color:red;">
				<span style="font-size:14px;font-color:red;">미승인 건수 :</span> <span id="processCnt"></span>건
			</div>
<!-- 			<a href="javascript:;" id="aInsert" class="btn_green">승인처리</a> -->
<!-- 			<a href="javascript:;" id="aInsertEnd" class="btn_green">종료</a>			 -->
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>