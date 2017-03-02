<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var trainingFeeGiveTargetGrid = new AXGrid(); // instance 상단그리드
var trainingFeeGridTab2L = new AXGrid(); // instance 상단그리드
var trainingFeeGridTab2R = new AXGrid(); // instance 상단그리드

var g_params = {showTab:1};

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount }"
 	, sortColKey: "trainingfee.target.list1"
 	, sortIndex: 0
 	, sortOrder:"ASC"
};

var defaultParamTabL = {
		  page: 1
	 	, rowPerPage: 300
	 	, sortColKey: "trainingfee.target.list2"
	 	, sortIndex: 1
	 	, sortOrder:"DESC"
	};

var defaultParamTabR = {
		  page: 1
	 	, rowPerPage: 300
	 	, sortColKey: "trainingfee.target.list3"
	 	, sortIndex: 1
	 	, sortOrder:"DESC"
	};
	
$(document.body).ready(function(){
	layer.init();
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeGiveTarget.doSearch({page:1});
	});
	
	// tab검색버튼 클릭
	$("#btnTabSearch").on("click", function(){
		trainingFeeTargetTab2L.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeGiveTarget.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	$("#aboSearch").aboSearch("DepositNm","btnDepSearch","txtSearchType","${param.frmId}");
	trainingFeeGiveTarget.doSearch();
	
	$("#getGridDetailView").on("click", function(){
		getGridDetailView(trainingFeeGiveTargetGrid.getExcelFormat("html"));
	});
	
	$("#getGridDetailViewR").on("click", function(){
		getGridDetailView(trainingFeeGridTab2R.getExcelFormat("html"));
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

var layer = {
		init : function(){
			// 상단 탭
			$("#divTrainingFeeTargetTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value: 1
				, options:[
					  {optionValue:"1", optionText:"전체", tabId:"1"} 
					, {optionValue:"2", optionText:"운영그룹", tabId:"2"}
				]
				, onchange : function(selectedObject, value){
					layer.setViewTab(value, selectedObject);
				}
			});
			// 초기 화면 셋팅
			trainingFeeGiveTarget.init();
		}, setViewTab : function(value, selectedObject){
			$("#tabLayer .tabView").hide();
			$("#divTabPage" + value).show();
			g_params.showTab = value;
			
			// Grid Bind Real
			if(g_params.showTab=="1") {
				trainingFeeGiveTarget.init();
			} else if(g_params.showTab=="2") {
				$("#searchGiveYearTab").bindDate({separator:"-", selectType:"m"});
				$("#searchGiveYearTab").val(setToDay().substring(0,7));
				
				trainingFeeTargetTab2L.init();
				trainingFeeTargetTab2R.init();
			}
		} // end func setViewTab
	}

/* 지급대상자 관리_전체 탭 리스트 */
var trainingFeeGiveTarget = {
		/** init : 초기 화면 구성 (Grid)*/
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
							, {key:"depabo_no", label:"ABO No", width:"60", align:"center"}
							, {key:"depaboname", label:"ABO Name", width:"120", align:"center"}
							, {key:"depcode", addclass:idx++, label:"Code", width:"60", align:"center"}
							, {key:"highestachievename", addclass:idx++, label:"H.Pin", width:"100", align:"center"}
							, {key:"groupsname", addclass:idx++, label:"C.Pin", width:"100", align:"center"}
							, {key:"loanamekor", addclass:idx++, label:"LOA", width:"100", align:"center"}
							, {key:"br", addclass:idx++, label:"BR", width:"60", align:"center"}
							, {key:"department", addclass:idx++, label:"Dept", width:"80", align:"center"}
							, {key:"trfee", addclass:idx++, label:"실교육비", width:"80", align:"center", formatter:"money"}
							, {key:"groupcode", addclass:idx++, label:"운영그룹", width:"60", align:"center"}
							, {key:"authperson", addclass:idx++, label:"개인", width:"50", align:"center"}
							, {key:"authgroup", addclass:idx++, label:"그룹", width:"50", align:"center"}
							, {key:"authmanageflag", addclass:idx++, label:"총무", width:"50", align:"center"}
							,{
								key:"note", addclass:idx++, label:"메모", width:"80", align:"center", sort:false, formatter: function () {
									return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:gridEvent.clickMemo('" + this.item.giveyear + "','" + this.item.givemonth + "','" + this.item.depabo_no + "');\">메모장</a>";
								}
							}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, mergeCells: false
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
									, {colSeq: 8, rowspan: 2, valign:"middle"}
									, {colSeq: 9, rowspan: 2, valign:"middle"}
									, {colSeq: 10, rowspan: 2, valign:"middle"}
									, {colseq:null, colspan: 3, label: "권한", align: "center", valign:"middle"}
									, {colSeq: 14, rowspan: 2, valign:"middle"}
			                  	], [
									 {colSeq: 11}
									,{colSeq: 12}
									,{colSeq: 13}
			                      ]
								]
						}
				, body: {
	                marker: function () {
	
	                }
		        }
				, foot: {
	                rows: [
	                       [
	                           {colSeq: null, colspan: 9, align: "center", valign: "middle" , formatter: function () { return "실교육비 합계"; }},
	                           {colSeq: 10, colspan: 2, formatter: function () {
	                               var sum = 0;
	                               $.each(this.list, function () {
	                                   sum += parseInt(this.trfee);
	                               });
	                               return sum.money();
	                           }}
	                       ]
	                   ]
	               }
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeGiveTarget.doSortSearch
					, doPageSearch : trainingFeeGiveTarget.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeGiveTargetGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			defaultParam.page = pageNo;
			// Grid Page List			
			trainingFeeGiveTarget.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeGiveTarget.doSearch(param);
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
 		   		url: "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeGiveTargetListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		           		alert("처리도중 오류가 발생하였습니다.");
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
		   		trainingFeeGiveTargetGrid.setData(gridData);
		   		trainingFeeGiveTargetGrid.setDataSet({});
		   	}
			
		}
	}
	
/* 운영그룹 검색 결과 그리는곳 */
var trainingFeeTargetTab2L = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", addclass:idx++, label:"No.", width:"40", align:"center", formatter:"money", sort:false}
							, {key:"loakor", addclass:idx++, label:"LOA", width:"80", align:"center",sort:false}
							, {key:"groupcode", addclass:idx++, label:"운영그룹", width:"80", align:"center", formatter:"money", sort:false, formatter: function (){
									return "<a href=\"javascript:;\" onclick=\"javascript:gridEvent.clickGroupCode('"+this.item.giveyear+"','"+this.item.givemonth+"','"+this.item.loakor+"','"+this.item.groupcode+"');\">"+this.item.groupcode+"</a>";
								}
							}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, height : "670"
					, colHead : { heights: [55,55],
						}
					, targetID : "trainingFeeGridTab2L_${param.frmId}"
					, sortFunc : trainingFeeTargetTab2L.doSortSearch
					, doPageSearch : trainingFeeTargetTab2L.doPageSearch
				}
			
			fnGrid.nonPageGrid(trainingFeeGridTab2L, gridParam);
			trainingFeeTargetTab2L.doSortSearch();
		}, doPageSearch : function(pageNo) {
			defaultParamTabL.page = pageNo;
			// Grid Page List
			trainingFeeTargetTab2L.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParamTabL.sortOrder = fnGrid.sortGridOrder(defaultParamTabL, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeTargetTab2L.doSearch(param);
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
					searchGiveYear  : $("#searchGiveYearTab").val()	
				  , searchLoa       : $("#cbSearchLOAtab2").val()	  
				  , searchGroupCode : $("#cbSearchGrptab2").val()
			};
			
			$.extend(defaultParamTabL, param);
			$.extend(defaultParamTabL, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeGiveTargetGrpListAjax.do"/>"
		   		, data: defaultParamTabL
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
		   		
		   		var gridNullData = {
			   			list: {},
			   			page:{
			   				pageNo: 1,
			   				pageSize: defaultParam.rowPerPage,
			   				pageCount: 0,
			   				listCount: 0
			   			}
			   		};
		   		
		   		// Grid Bind Real
		   		trainingFeeGridTab2L.setData(gridData);
 		   		trainingFeeGridTab2R.setData(gridNullData);
		   	}
		}
	}

var trainingFeeTargetTab2R = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								{key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
								, {key:"depositabo_no", label:"ABO No", width:"60", align:"center"}
								, {key:"depositaboname", label:"ABO Name", width:"100", align:"center"}
								, {key:"depositcode", addClass:idx++, label:"Code", width:"60", align:"center"}
								, {key:"highestachievename", addclass:idx++, label:"H.Pin", width:"100", align:"center"}
								, {key:"groupsname", addclass:idx++, label:"C.Pin", width:"100", align:"center"}
								, {key:"loakor", addClass:idx++, label:"LOA", width:"100", align:"center"}
								, {key:"br", addClass:idx++, label:"BR", width:"60", align:"center"}
								, {key:"department", addClass:idx++, label:"Dept", width:"60", align:"center"}
								, {key:"realtrainingfee", addClass:idx++, label:"실교육비", width:"100", align:"right", formatter:"money"}
								, {key:"authperson", addClass:idx++, label:"개인", width:"50", align:"center"}
								, {key:"authgroup", addClass:idx++, label:"그룹", width:"50", align:"center"}
								, {key:"authmanageflag", addClass:idx++, label:"총무", width:"50", align:"center"}
								,{
									key:"memo", addclass:idx++, label:"메모", width:"80", align:"center", sort:false, formatter: function () {
										return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:gridEvent.clickMemo('" + this.item.giveyear + "','" + this.item.givemonth + "','" + this.item.depositabo_no + "');\">메모장</a>";
									}
								}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, height : "670"
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
									, {colSeq: 8, rowspan: 2, valign:"middle"}
									, {colSeq: 9, rowspan: 2, valign:"middle"}
									, {colseq:null, colspan: 3, label: "권한", align: "center", valign:"middle"}
									, {colSeq: 13, rowspan: 2, valign:"middle"}
			                  	], [
									 {colSeq: 10}
									,{colSeq: 11}
								    ,{colSeq: 12}

			                      ]
								]
						}
					, targetID : "trainingFeeGridTab2R_${param.frmId}"
					, sortFunc : trainingFeeTargetTab2R.doSortSearch
					, doPageSearch : trainingFeeTargetTab2R.doPageSearch
				}
			
			fnGrid.nonPageGrid(trainingFeeGridTab2R, gridParam);
		}, doPageSearch : function(pageNo) {
			defaultParamTabR.page = pageNo;
			// Grid Page List
			trainingFeeTargetTab2R.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParamTabR.sortOrder = fnGrid.sortGridOrder(defaultParamTabR, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeTargetTab2R.doSearch(param);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			$.extend(defaultParamTabR, param);
			
			$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeGiveTargetGrpDetailListAjax.do"/>"
		   		, data: defaultParamTabR
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
		   		trainingFeeGridTab2R.setData(gridData);
		   	}
			
		}
	}
	
var gridEvent = {
		clickMemo : function(giveyear, givemonth, abono) {
			var param = {
				giveyear:giveyear
				,givemonth:givemonth
				,abono:abono
				,mode:"note"
				,menuAuth:"${param.menuAuth}"
			};
			
			var popParam = {
					url : "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterMemoLearPop01.do"/>"
					, width : "800"
					, height : "800"
					, params : param
					, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		},
		clickGroupCode : function(giveyear, givemonth, loa, groupcode) {
			var parm = {
					  searchGiveYear  : giveyear
					, searchGiveMonth : givemonth
					, searchLoa       : loa
					, searchGroupCode : groupcode
			};
			
			trainingFeeTargetTab2R.doSearch(parm);
		}
	}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">지급대상자관리</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">대상자관리</a></li>
				<li class="end">지급대상자관리</li>
			</ul>
		</div>
	</div>
	
	<div id="divTrainingFeeTargetTab" ></div>
	
	<!--search table // -->
	<!--// title-->
	<div id="tabLayer">
		<div id="divTabPage1" class="tabView">		
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
									<option value="2">ABO 성명</option>
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
					&nbsp;&nbsp;<a href="javascript:;" id="getGridDetailView" class="btn_green">팝업보기</a>
				</div>
				<div class="fr">
		<!-- 			<a href="javascript:;" id="aInsert" class="btn_green">추가</a> -->
		<!-- 			<a href="javascript:;" id="aInsertEnd" class="btn_green">종료</a>			 -->
				</div>
			</div>
				<!-- grid -->
			<div id="AXGrid">
				<div id="AXGridTarget_${param.frmId}"></div>
			</div>
		</div>
		
		<!-- 운영그룹 tabpage -->
		<div id="divTabPage2" class="tabView" style="display:none">
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="9%" />
						<col width="21%"  />
						<col width="9%" />
						<col width="21%" />
						<col width="9%" />
						<col width="21%" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th>지급연도/월</th>
						<td>
							<input type="text" id="searchGiveYearTab" name="searchGiveYearTab" class="AXInput" readonly="readonly">
						</td>
						<th scope="row">LOA</th>
						<td>
							<select id="cbSearchLOAtab2" name="cbSearchLOAtab2">
								<option value="">전체</option>
								<c:forEach var="items" items="${searchLOA }">
									<option value="${items.code }">${items.name }</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">운영그룹</th>
							<td>
								<select id="cbSearchGrptab2" name="cbSearchGrptab2">
									<option value="">전체</option>
									<c:forEach var="items" items="${searchGrpCd }">
										<option value="${items.code }">${items.name }</option>
									</c:forEach>
								</select>
							</td>
						<th>
							<!-- 운영그룹_검색 -->
							<div class="btnwrap mb10">
								<a href="javascript:;" id="btnTabSearch" class="btn_gray btn_big">검색</a>
							</div>
						</th>
					</tr>
				</table>
			</div>
				
			<!-- grid -->
			<div id="AXGrid">
				<div style="float:left; width:20%;">
					<div id="trainingFeeGridTab2L">
						<div id="trainingFeeGridTab2L_${param.frmId}"></div>
					</div>
				</div>
				<div style="float:right; width:80%;">
					<a href="javascript:;" id="getGridDetailViewR" class="btn_green">팝업보기</a>
					<div id="trainingFeeGridTab2R">
						<div id="trainingFeeGridTab2R_${param.frmId}"></div>
					</div>
				</div>
			</div>
				
		</div>
		
	</div>
			
	<!-- Board List -->
		
</body>