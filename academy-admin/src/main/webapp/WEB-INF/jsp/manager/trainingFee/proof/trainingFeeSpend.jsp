<!-- 교육비 사전 교육 계획서!! -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
//Grid Init
var trainingFeeSpendGrid = new AXGrid(); // instance 상단그리드
var lfrmId = "${param.frmId}";
var lmenuAuth = "${param.menuAuth}";

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount }" 
 	, sortColKey: "trainingfee.proof.spend"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	trainingFeeSpend.init();
	
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeSpend.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeSpend.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	$("#aboSearch").aboSearch("DepositNm","btnDepSearch","txtSearchType","${param.frmId}");
	
	trainingFeeSpend.doSearch();
	
	$("#getGridDetailView").on("click", function(){
		getGridDetailView(trainingFeeSpendGrid.getExcelFormat("html"));
	});
});

function doReturnValue(param) {
	$("select[name='txtSearchType']").val("1");
	$("input[name='DepositNm']").val(param.uid);
}

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}



var trainingFeeSpend = {
		/** init : 초기 화면 구성 (Grid)
		*/
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
							, {key:"givemonth", label:"지급 월", width:"80", align:"center", sort:false}
							, {key:"depabo_no", addClass:idx++, label:"ABO 번호", width:"150", align:"center"}
							, {key:"depaboname", addClass:idx++, label:"ABO 이름", width:"200", align:"center"}
							, {key:"trfee", addClass:idx++, label:"교육비", width:"100", align:"center", formatter: "money"}
							, {key:"planamount", addClass:idx++, label:"계획서합계", width:"100", align:"center", formatter: "money"}
							, {key:"spendamount", addClass:idx++, label:"개인", width:"100", align:"center", formatter: "money"}
// 							, {key:"spendstatus", addClass:idx++, label:"상태", width:"60", align:"center", formatter: function(){
// 								var txt = "진행중";
// 								if(this.item.spendstatus=="Y") txt = "완료";								
// 								return txt;
// 							}}
							, {key:"groupcode", addClass:idx++, label:"운영그룹", width:"80", align:"center"}
							, {key:"grtamount", addClass:idx++, label:"그룹", width:"100", align:"center", formatter: "money"}
							, {key:"totalamount", addClass:idx++, label:"합계", width:"100", align:"center", formatter: "money"}
							, {key:"grpstatus", addClass:idx++, label:"상태", width:"60", align:"center", formatter: function(){
								var txt = "진행중";
								if(this.item.spendstatus=="Y"||this.item.grpstatus=="Y") txt = "제출완료";								
								return txt;
							}}
							, {key:"spendconfirmdt", addClass:idx++, label:"처리일자", width:"100", align:"center"}
							, {key:"spendconfirmflag", addClass:idx++, label:"처리상태", width:"100", align:"center"}
							, {key:"selfApprovalEnDt", addClass:idx++, label:"상세보기", width:"150", align:"center", sort:false, formatter: function(){
							 	return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"trainingFeeSpend.doSearchTab('" + this.item.giveyear + "','" 
							 			                                                                                          + this.item.givemonth + "','" 
							 			                                                                                          + this.item.depabo_no + "','" 
							 			                                                                                          + isNvl(this.item.trfee,"0") + "')\">상세보기</a>";
							  }}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, colHead : { heights: [20,20],
				          rows : [
			                     [
									  {colSeq: 0, rowspan: 2, valign:"middle"}
									, {colSeq: 1, rowspan: 2, valign:"middle"}
									, {colSeq: 2, rowspan: 2, valign:"middle"}
									, {colSeq: 3, rowspan: 2, valign:"middle"}
									, {colSeq: 4, rowspan: 2, valign:"middle"}
									, {colSeq: 5, rowspan: 2, valign:"middle"}
									, {colseq:null, colspan: 5, label: "지출증빙", align: "center", valign:"middle"}
									, {colSeq: 11, rowspan: 2, valign:"middle"}
									, {colSeq: 12, rowspan: 2, valign:"middle"}
									, {colSeq: 13, rowspan: 2, valign:"middle"}
			                  	], [
									 {colSeq: 6}
									,{colSeq: 7}
									,{colSeq: 8}
									,{colSeq: 9}
									,{colSeq: 10}
			                      ]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeSpend.doSortSearch
					, doPageSearch : trainingFeeSpend.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeSpendGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			defaultParam.page = pageNo;
			// Grid Page List
			trainingFeeSpend.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeSpend.doSearch(param);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			var initParam = {
						searchGiveYear : $("#searchGiveYear").val()	
					  , searchDepSchType :$("#txtDepSearchType").val()
					  , searchDepositNm :$("#DepositNm").val()
// 					  , searchStatePerson :$("#searchStatePerson").val()
					  , searchStateGrp :$("#searchStateGrp").val()
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
		   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeSpendList.do"/>"
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
		   		
// 		   		$("#dotTxt").text(data.getCount);
		   		
		   		// Grid Bind Real
		   		trainingFeeSpendGrid.setData(gridData);
		   	}
		},
		doSearchTab : function(giveyear, givemonth, abono, trfee) {
			// 상세 tabpage
			var strMenuCd   = "";
			var strMenuText = "";
			var strLinkurl = "";
			
			strMenuCd = "W03020030010";
			strMenuText = "지출증빙 상세보기";
			strLinkurl = '/manager/trainingFee/proof/trainingFeeSpendDetail.do';
			
			// 전역변수 처리
			window.parent.g_managerLayerMenuId.sessionOnGiveYear    = giveyear;
			window.parent.g_managerLayerMenuId.sessionOnGiveMonth   = givemonth;
			window.parent.g_managerLayerMenuId.sessionOnAboNo       = abono;
			window.parent.g_managerLayerMenuId.sessionOnTrfee       = trfee;
			window.parent.g_managerLayerMenuId.sessionOnFrmId       = lfrmId;
			window.parent.g_managerLayerMenuId.sessionOnMenuAuth    = lmenuAuth;
			
			var item = { menuCd   : strMenuCd
					   , menuText : strMenuText
					   , linkurl  : strLinkurl
					   , menuYn   : 'Y'
					   , callFn   : 'fn_init' 
					   , funcData : ''
			};
			
			window.parent.addTabMenu(Object.toJSON(item));
		}
	}
	
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교육비지출증빙</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">교육비증빙</a></li>
				<li class="end">교육비지출증빙</li>
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
				<th>지급연도/월</th>
				<td>
					<input type="text" id="searchGiveYear" name="searchGiveYear" class="AXInput datepMon setDateMon" readonly="readonly">
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
				<th rowspan="5">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			<tr>
<!-- 				<th scope="row">상태(개인)</th> -->
<!-- 				<td> -->
<!-- 					<select id="searchStatePerson" name="searchStatePerson" > -->
<!-- 						<option value="">전체</option> -->
<!-- 						<option value="N">진행중</option> -->
<!-- 						<option value="Y">완료</option> -->
<!-- 					</select> -->
<!-- 				</td> -->
				<th scope="row">상태</th>
				<td colspan="3">
					<select id="searchStateGrp" name="searchStateGrp" >
						<option value="">전체</option>
<!-- 						<option value="N">진행중</option> -->
						<option value="Y">제출완료</option>
					</select>
				</td>
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
<!-- 		<div class="fr"> -->
<%-- 			<p style="font-size:14px;color:red;">조회월 기준 3개월 미승인 건수 : <span id="dotTxt">${getCount }</span>건</p> --%>
<!-- 		</div> -->
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>