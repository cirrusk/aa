<!-- 교육비 체크리스트!! -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>


<script type="text/javascript">	

//Grid Init
var trainingFeeCheckListGrid = new AXGrid(); // instance 상단그리드
var gridExtData = {};

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount }"
 	, sortColKey: "trainingfee.proof.check"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	trainingFeeCheckList.init();
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	$("input[name='fromConfrimDt']").val(setToDay());
	$("input[name='toConfrimDt']").val(setDatediff(setToDay(),15));
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeCheckList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	$("#getGridDetailView").on("click", function(){
		getGridDetailView(trainingFeeCheckListGrid.getExcelFormat("html"));
	});
	
	$("#btnSearch").on("click", function(){
		trainingFeeCheckList.doSearch();
	});
	
	$("#btnConfrimDt").on("click", function(){
		$("input[name='fromConfrimDt']").val("");
		$("input[name='toConfrimDt']").val("");
	});
		
	$("#uploadYn").on("click", function(){
		var checkedspendid = "";
		var checkedabo_no  = "";
		var checkedList    = trainingFeeCheckListGrid.getCheckedListWithIndex(0);// colSeq
		
		for(var i = 0; i < checkedList.length; i++){
			if(i == 0){
				checkedspendid = checkedList[i].item.spendid;
				checkedabo_no = checkedList[i].item.depabo_no;
			} else {
				checkedspendid = checkedspendid+","+checkedList[i].item.spendid;
				checkedabo_no  = checkedabo_no+","+checkedList[i].item.depabo_no;
			}
		}
		
		if($.trim(checkedspendid).length == 0){
			alert("선택된 대상자가 없습니다.");
			return;
		}
		
		var result = confirm("선택한 대상자에 업로드 유무를 일괄 변경 하시겠습니까?"); 
		
		if(result) {
			var params = {
					  giveyear        : checkedList[0].item.giveyear
					, givemonth       : checkedList[0].item.givemonth
					, spendid         : checkedspendid
					, depabono        : checkedabo_no
					, as400uploadfalg : $("#checkUploadfalg").val() }
			
			$.ajaxCall({
				method   : "POST",
				url      : "<c:url value="/manager/trainingFee/proof/updateAs400UploadFalg.do"/>",
				dataType : "json",
				data     : params,
				success  : function(data, textStatus, jqXHR) {
					if (data.result.errCode < 1) {
						alert("처리도중 오류가 발생하였습니다.");
					}else{
						alert("저장 완료 하였습니다.");
						trainingFeeCheckList.doSearch();
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
				}
			});			
		}
	});
	
	$("#aboSearch").aboSearch("DepositNm","btnDepSearch","txtSearchType","${param.frmId}");
	
	trainingFeeCheckList.doSearch();
});

function doReturnValue(param) {
	$("select[name='txtSearchType']").val("1");
	$("input[name='DepositNm']").val(param.uid);
}

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

var trainingFeeCheckList = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
			                        return this.item.___checked && this.item.___checked["1"];
			             	}}
							, {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
							, {key:"givemonth", label:"지급 월", width:"80", align:"center", sort:false}
							, {key:"depabo_no", label:"ABO 번호", width:"100", align:"center", sort:false}
							, {key:"depaboname", addClass:idx++, label:"ABO 이름", width:"150", align:"center", sort:false}
							, {key:"code", addClass:idx++, label:"Code", width:"80", align:"center"}
							, {key:"rate", addClass:idx++, label:"%", width:"80", align:"center"}
							, {key:"br", addClass:idx++, label:"BR", width:"80", align:"center"}
							, {key:"qualifydia", addClass:idx++, label:"C.UP DIA NO", width:"80", align:"center"}
							, {key:"qualifydianame", addClass:idx++, label:"C.UP DIA NAME", width:"150", align:"center"}
							, {key:"trfee", addClass:idx++, label:"실교육비", width:"100", align:"center", formatter: function(){
								var money = isNvl(this.item.trfee,"0");
								if(!isNull(this.item.trfee)) money = money.replace(".0","");
								return setComma(money);	
							}}
							, {key:"calcnt", addClass:idx++, label:"Monthly Calculation Count", width:"80", align:"center"}
							, {key:"as400uploadfalg", addClass:idx++, label:"업로드 유무", width:"80", align:"center"}
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
									, {colseq:null, colspan: 8, label: "Deposit", align: "center", valign:"middle"}
									, {colSeq: 11, rowspan: 2, valign:"middle"}
									, {colSeq: 12, rowspan: 2, valign:"middle"}
			                  	], [
									 {colSeq: 3}
									,{colSeq: 4}
									,{colSeq: 5}
									,{colSeq: 6}
									,{colSeq: 7}
									,{colSeq: 8}
									,{colSeq: 9}
									,{colSeq: 10}
			                      ]
								]
						}, 
						body       : {
							marker       : [
											{
												display: function () {
													var pitem = this.item.spendconfirmdt;
					                                 var nitem = null;

					                                if(this.list.length-1 > this.index){
					                                    nitem = this.list[this.index.number()+1].spendconfirmdt; 
					                                } 
					                                
					                                if(pitem != nitem){
					                                	var sum = 0;
					                                	var sumbr1 = 0;
					                                	var sumbr2 = 0;
					                                	var sumbr3 = 0;
					                                	var sumbr4 = 0;
					                                	var sumbr5 = 0;
					                                	var brTxt = "";
					                                	
				                                        $.each(this.list, function (i,val) {
				                                        	if(val.spendconfirmdt==pitem) {
					                                           sum += parseInt(this.spendamount);		                                           
					                                           if(val.br=="BR1") sumbr1 += parseInt(this.spendamount);
					                                           if(val.br=="BR2") sumbr2 += parseInt(this.spendamount);
					                                           if(val.br=="BR3") sumbr3 += parseInt(this.spendamount);
					                                           if(val.br=="BR4") sumbr4 += parseInt(this.spendamount);
					                                           if(val.br=="BR5") sumbr5 += parseInt(this.spendamount);					                                           
				                                        	}
				                                        });
					                                    
				                                        if(!isNull(sumbr1)) brTxt = brTxt + ",BR1 : " + setComma(sumbr1) + "원";
				                                        if(!isNull(sumbr2)) brTxt = brTxt + ",BR2 : " + setComma(sumbr2) + "원";
				                                        if(!isNull(sumbr3)) brTxt = brTxt + ",BR3 : " + setComma(sumbr3) + "원";
				                                        if(!isNull(sumbr4)) brTxt = brTxt + ",BR4 : " + setComma(sumbr4) + "원";
				                                        if(!isNull(sumbr5)) brTxt = brTxt + ",BR5 : " + setComma(sumbr5) + "원";
				                                        brTxt = brTxt.substr(1);
					                                	gridExtData.subTotalTotamt= sum;
					                                	gridExtData.subTotalName  = "승인일자 : " + pitem + " 합계금액 : "+setComma(sum)+"원 ( "+brTxt+" )";
					                                	gridExtData.subTotal      = true;       
					                                    this.item.subTotal        = true;
					                                } else {
					                                	gridExtData.subTotalTotamt= 0;
					                                	gridExtData.subTotalName  = pitem + " 지출증빙 합계";
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
															colSeq  : null, colspan: 12, formatter: function () {
																return gridExtData.subTotalName;
															}
														}]
													]
											}]
				        }
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeCheckList.doSortSearch
					, doPageSearch : trainingFeeCheckList.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeCheckListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			defaultParam.page=pageNo;
			// Grid Page List
			trainingFeeCheckList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeCheckList.doSearch(param);
		}, doSearch : function(param) {
			if(isNull($("input[name='fromConfrimDt']").val()) && !isNull($("input[name='toConfrimDt']").val()) ) {
				alert("[검색조건] 승인일자 시작/종료일자 둘다 입력 해주세요!");
				return;
			} else if(!isNull($("input[name='fromConfrimDt']").val()) && isNull($("input[name='toConfrimDt']").val()) ) {
				alert("[검색조건] 승인일자 시작/종료일자 둘다 입력 해주세요!");
				return;
			}
			
			// Param 셋팅(검색조건)
			var initParam = {
						searchGiveYear   : $("#searchGiveYear").val()
					  , searchDepSchType : $("#txtDepSearchType").val()
					  , searchDepositNm  : $("#DepositNm").val()
					  , fromConfrimDt    : $("input[name='fromConfrimDt']").val()
					  , toConfrimDt      : $("input[name='toConfrimDt']").val()
					  , as400uploadfalg  : $("#as400uploadfalg").val()
					  , searchBR         : $("#cbSearchBR").val()
					  , searchGrpCd      : $("#cbSearchGrp").val()
					  , searchCode       : $("#cbSearchCode").val()
					  , searchLoa        : $("#cbSearchLOA").val()
					  , searchCPin       : $("#cbSearchCPin").val()
					  , searchDept       : $("#cbSearchDept").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({ 		   		
		   		url: "<c:url value="/manager/trainingFee/proof/selectCheckList.do"/>"
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
		   		trainingFeeCheckListGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교육비 체크리스트</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">교육비증빙</a></li>
				<li class="end"><a href="#">교육비 체크리스트</a></li>
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
				<th>업로드상태</th>
				<td>
					<select id="as400uploadfalg" name="as400uploadfalg" style="width:100px; min-width:100px" title="업로드상태" > 
						<option value="">선택</option>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</td>
				<th rowspan="6">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th scope="row">승인일자</th>
				<td>
					<input type="text" id="fromConfrimDt" name="fromConfrimDt" class="AXInput datepDay" readonly="readonly">
					~
					<input type="text" id="toConfrimDt" name="toConfrimDt" class="AXInput datepDay" readonly="readonly">
					<a href="javascript:;" id="btnConfrimDt" class="btn_gray btn_mid">Reset</a>
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
<!-- 			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">AS400 업로드용 Excel</a> -->
		</div>
		<div class="fr authWrite">
			<label>선택한 ABO의 업로드 처리상태을(를) </label>
			<select id="checkUploadfalg" style="width:50px; min-width:50px" title="업로드상태" > 
				<option value="Y">Y</option>
				<option value="N">N</option>
			</select>로
			<a href="javascript:;" id="uploadYn" class="btn_green">저장</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>