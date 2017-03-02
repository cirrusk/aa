<!-- 교육비 사전 교육 계획서!! -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
var localparam = {};
//Grid Init
var trainingFeeSpendingGrid = new AXGrid(); // instance 상단그리드
var localGiveYear     = "";
var localGiveMonth    = "";
var localDepAboNo     = "";
var localTrfee        = "";
var localSpendamount  = "";
var localGrtamount    = "";
var gridExtData = {};

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "trainingfee.proof.planDtl"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	trainingFeeSpending.init();
	
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeSpending.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeSpending.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	fn_init();
});

function fn_init(param) {
	localGiveYear     = window.parent.g_managerLayerMenuId.sessionOnGiveYear;
	localGiveMonth    = window.parent.g_managerLayerMenuId.sessionOnGiveMonth;
	localDepAboNo     = window.parent.g_managerLayerMenuId.sessionOnAboNo;
	localTrfee        = window.parent.g_managerLayerMenuId.sessionOnTrfee;
	
	localparam= { giveyear :localGiveYear
			    , givemonth:localGiveMonth
			    , abono    :localDepAboNo
			    , trfee    :localTrfee   };
	
	$.ajaxCall({
   		url: "<c:url value="/manager/trainingFee/trainingFeeCommon/trainingFeeTargetInfoListAjax.do"/>"
   		, data: localparam
   		, success: function( data, textStatus, jqXHR){
   				callbackList(data);
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("처리도중 오류가 발생하였습니다.");
   		}
   	});

   	function callbackList(data) {
   		var obj = data.targetInfo; //JSON.parse(data);
		
		$("#txtGiveYear" ).text(localparam.giveyear);
		$("#txtGiveMonth").text(localparam.givemonth);
		$("#txtAboNo"    ).text(obj.abo_no);
		$("#txtAboName"  ).text(obj.abo_name);
		$("#txtBr"       ).text(obj.br);
		$("#txtGroupCode").text(obj.groupcode);
		$("#txtCode"     ).text(obj.code);
		$("#txtLoa"      ).text(obj.loanamekor);
		$("#txtCPin"     ).text(obj.groupsname);
		$("#txtDept"     ).text(obj.department);
		
		$("#txtTrfee").text(setComma(localTrfee));
		
		trainingFeeSpending.doSearch({page:"1"});
   	}
}

var trainingFeeSpending = {
		/** init : 초기 화면 구성 (Grid)
		*/
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
							, {key:"spenddt", label:"교육일자", width:"120", align:"center", sort:false}
							, {key:"edukindname", addClass:idx++, label:"교육종류", width:"80", align:"center"}
							, {key:"edutitle", addClass:idx++, label:"교육명", width:"200", align:"center"}
							, {key:"personcount", addClass:idx++, label:"예상인원", width:"60", align:"center"}
							, {key:"plancount", addClass:idx++, label:"횟수(회)", width:"60", align:"center", formatter:"money"}
							, {key:"place", addClass:idx++, label:"교육장소", width:"150", align:"center"}
							, {key:"edudesc", addClass:idx++, label:"교육설명", width:"150", align:"center"}
							, {key:"rate", addClass:idx++, label:"비율", width:"60", align:"center"}
							, {key:"plantype", addClass:idx++, label:"형태", width:"60", align:"center"}
							, {key:"spenditemname", addClass:idx++, label:"지출항목", width:"150", align:"center"}
							, {key:"spendamount", addClass:idx++, label:"예상금액", width:"100", align:"center", formatter:"money"}
							, {key:"registrantdate", addClass:idx++, label:"등록일시", width:"100", align:"center"}
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
									, {colseq:null, colspan: 4, label: "예상지출", align: "center", valign:"middle"}
			                  	], [
									 {colSeq: 9}
									,{colSeq: 10}
									,{colSeq: 11}
									,{colSeq: 12}
			                      ]
								]
						}
			        , body       : {
						marker       : [
										{
											display: function () {
												var pitem = this.item.spenddt;
				                                 var nitem = null;

				                                if(this.list.length-1 > this.index){
				                                    nitem = this.list[this.index.number()+1].spenddt; 
				                                } 
				                                
				                                if(pitem != nitem){
				                                	var sum = 0;
				                                	
			                                        $.each(this.list, function (i,val) {
			                                        	if(val.spenddt==pitem) {
				                                           sum += parseInt(this.spendamount);
			                                        	}
			                                        });
				                                       
				                                	gridExtData.subTotalTotamt= sum;
				                                	gridExtData.subTotalName  = pitem + " 사전계획서 합계";
				                                	gridExtData.subTotal      = true;       
				                                    this.item.subTotal        = true;
				                                } else {
				                                	gridExtData.subTotalTotamt= 0;
				                                	gridExtData.subTotalName  = pitem + " 사전계획서 합계";
				                                	gridExtData.subTotal      = false;       
				                                    this.item.subTotal        = false;
				                                }
				                                
												return this.item.subTotal ? true : false; 
											},
											 addClass : function(){
					                            return this.item.subTotal ? 'sumgray' : 'sumgray';
					                         },
												rows: [
													[{
														colSeq  : null, colspan: 11, formatter: function () {
															return gridExtData.subTotalName;
														}, align: "center"
													}, {
														colSeq: 12, formatter: function () {
															return gridExtData.subTotalTotamt.money();
														}
													}, 
													{colSeq: 13}]
												]
										}]
			        }
			        , foot: {
                        rows: [
                               [
                                   {colSeq: null, colspan: 11, align: "center", valign: "middle" , formatter: function () { return "계"; }},
                                   {colSeq: 12, formatter: function () {
                                       var sum = 0;
                                       var persum = 0;
                                       var grpsum = 0;
                                       
                                       $.each(this.list, function (i,val) {
                                    	   if( this.plantype == '개인' ) persum += parseInt(this.spendamount);
                                    	   if( this.plantype == '그룹' )  grpsum += parseInt(this.spendamount);
                                           sum += parseInt(this.spendamount);
                                       });
                                       
	                                    $("#txtSpendamount").text(setComma(persum));
	                               		$("#txtGrtamount").text(setComma(grpsum));
	                               		$("#txtTotamount").text(setComma(sum));
	                               		var txtamount = parseInt(sum) - parseInt($("#txtTrfee").text().replace(/,/g, ''));
	                               		$("#txtAmount").text(setComma(txtamount));
	                               		
                                       return sum.money();
                                   }},
                                   {colSeq: 13}
                               ]
                           ]
                       }
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeSpending.doSortSearch
					, doPageSearch : trainingFeeSpending.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeSpendingGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			trainingFeeSpending.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeSpending.doSearch(param);
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			$.extend(defaultParam, param);
			$.extend(defaultParam, localparam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/proof/trainingFeePlanDetailList.do"/>"
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
		   		trainingFeeSpendingGrid.setData(gridData);
		   		trainingFeeSpendingGrid.setDataSet({});
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">사전교육계획서 상세보기</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">교육비증빙</a></li>
				<li class="end"><a href="#">사전교육계획서</a></li>
			</ul>
		</div>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="23%" />
				<col width="10%" />
				<col width="23%" />
				<col width="10%" />
				<col width="23%" />
			</colgroup>
			<tr>
				<th>지급연도</th>
				<td scope="row">
					<span id="txtGiveYear"></span>년도 <span id="txtGiveMonth"></span>월
				</td>
				<th>ABO No</th>
				<td scope="row">
					<span id="txtAboNo"></span>
				</td>
				<th>ABO Name</th>
				<td scope="row">
					<span id="txtAboName"></span>
				</td>
			</tr>
			<tr>
				<th>BR</th>
				<td scope="row">
					<span id="txtBr"></span>
				</td>
				<th>운영그룹</th>
				<td scope="row">
					<span id="txtGroupCode"></span>
				</td>
				<th>Code</th>
				<td scope="row">
					<span id="txtCode"></span>
				</td>
			</tr>
			<tr>
				<th>LOA</th>
				<td scope="row">
					<span id="txtLoa"></span>
				</td>
				<th>C.Pin</th>
				<td scope="row">
					<span id="txtCPin"></span>
				</td>
				<th>Dept</th>
				<td scope="row">
					<span id="txtDept"></span>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tbl_write2">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="33%" />
				<col width="33%"  />
				<col width="33%" />
			</colgroup>
			<tr>
				<th>교육비</th>
				<th>사전계획 총 금액</th>
				<th>차액</th>
			</tr>
			<tr>
				<td scope="row">
					<span id="txtTrfee"></span>
				</td>
				<td scope="row">
					개인 : <span id="txtSpendamount"></span>원 +
					그룹 : <span id="txtGrtamount"></span>원 
					합계 : <span id="txtTotamount"></span>원
				</td>
				<td scope="row">
					<span id="txtAmount"></span>원
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
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>