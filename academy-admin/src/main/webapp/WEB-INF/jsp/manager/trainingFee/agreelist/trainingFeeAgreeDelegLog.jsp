<!-- 교육비 위임 동의 현황!! -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>


<script type="text/javascript">	
//Grid Init
var trainingFeeAgreeLogGrid = new AXGrid(); // instance 상단그리드


//Grid Default Param
var defaultParam = {
	  page: 1
	, rowPerPage: "${rowPerCount}"
 	, sortColKey: "trainingfee.agree.agreelist1"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	trainingFeeAgreeLog.init();
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeAgreeLog.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeAgreeLog.doSearch({page:1});
	});
	
	$("#aboSearch").aboSearch("CalculationNm","btnCalSearch","txtSearchType","${param.frmId}");
	$("#aboSearch1").aboSearch("DepositNm","btnDepSearch","txtDepSearchType","${param.frmId}");
	
	trainingFeeAgreeLog.doSearch();
});

function doReturnValue(param) {
	if(param.rtninputnm=="CalculationNm") {
		$("select[name='txtSearchType']").val("1");
		$("input[name='CalculationNm']").val(param.uid);
	} else {
		$("select[name='txtDepSearchType']").val("1");
		$("input[name='DepositNm']").val(param.uid);
	}
}

function agreeLogPrint(fiscalyear, depaboNo, delegtypecode){
	
	var param = {
			  title : "위임동의서"
			, fiscalyear    : fiscalyear
			, depaboNo      : depaboNo
			, delegtypecode : delegtypecode
			, agreetypecode : "200"
		};
		
		var popParam = {
				  url: "<c:url value="/manager/trainingFee/agreelist/trainingFeeAgreePrint.do"/>"
				, width : "900"
				, height : "1024"
				, params : param 
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
}

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

var trainingFeeAgreeLog = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", addClass:idx++, label:"No.", width:"40", align:"center", sort:false}
							, {key:"fiscalyear", addClass:idx++, label:"회계 연도", width:"80", align:"center", sort:false}
							, {key:"delegtypename", label:"위임구분", width:"100", align:"center"}
							, {key:"depabo_no", label:"ABO 번호", width:"80", align:"center"}
							, {key:"depaboname", addClass:idx++, label:"ABO 성명", width:"150", align:"center"}
							, {key:"delegatorabo_no", addClass:idx++, label:"ABO 번호", width:"80", align:"center"}
							, {key:"delegatoraboname", addClass:idx++, label:"ABO 성명", width:"150", align:"center"}
							, {key:"agreeflag", addClass:idx++, label:"동의여부", width:"80", align:"center"}
							, {key:"agreedate", addClass:idx++, label:"동의일자", width:"150", align:"center"}
							, {key:"registrantdate", addClass:idx++, label:"등록일자", width:"150", align:"center"}
							, {key:"agreetitle", addClass:idx++, label:"위임동의서 제목", width:"200", align:"center"}
							, {key:"agreeid", addClass:idx++, label:"버전", width:"60", align:"center"}
							, {
								key: "btns", label : "동의서출력", width: "100", align: "center", formatter: function () {
									var html = "";
									if( !isNull(this.item.agreeflag) ) html = "<a href=\"javascript:;\" class='btn_green' onclick=\"javascript:agreeLogPrint('" + this.item.fiscalyear + "','" + this.item.depabo_no + "','" + this.item.delegtypecode + "')\">동의서출력</a>";
									return html
								}
							}
						]
			
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, colHead : { heights: [25,25],
				          rows : [
			                     [
									  {colSeq:  0, rowspan: 2, valign:"middle"}
									, {colSeq:  1, rowspan: 2, valign:"middle"}
									, {colSeq:  2, rowspan: 2, valign:"middle"}
									, {colseq:null, colspan: 2, label: "피위임자", align: "center", valign:"middle"}
									, {colseq:null, colspan: 2, label: "위임자", align: "center", valign:"middle"}
									, {colSeq: 7, rowspan: 2, valign:"middle"}
									, {colSeq: 8, rowspan: 2, valign:"middle"}
									, {colSeq: 9, rowspan: 2, valign:"middle"}
									, {colSeq: 10, rowspan: 2, valign:"middle"}
									, {colSeq: 11, rowspan: 2, valign:"middle"}
									, {colSeq: 12, rowspan: 2, valign:"middle"}
			                  	], [
									 {colSeq: 3}
									,{colSeq: 4}
									,{colSeq: 5}
									,{colSeq: 6}
			                      ]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeAgreeLog.doSortSearch
					, doPageSearch : trainingFeeAgreeLog.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeAgreeLogGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			defaultParam.page=pageNo;
			// Grid Page List
			trainingFeeAgreeLog.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeAgreeLog.doSearch(param);
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				  fiscalyear    : $("#searchGiveYear").val()
				, cbApprove : $("#cbApprove option:selected").val()
				, searchCalSchType :$("#txtCalSearchType").val()
				, searchCalculationNm :$("#CalculationNm").val()
				, searchDepSchType :$("#txtDepSearchType").val()
			    , searchDepositNm :$("#DepositNm").val()			    
				, searchBR : $("#cbSearchBR option:selected").val()
				, searchGrpCd : $("#cbSearchGrp option:selected").val()
				, searchCode : $("#cbSearchCode option:selected").val()
				, searchLoa : $("#cbSearchLOA option:selected").val()
				, searchCPin : $("#cbSearchCPin option:selected").val()
				, searchDept : $("#cbSearchDept option:selected").val()
				, delegtypecode : $("#delegtypecode").val()
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		  url: "<c:url value="/manager/trainingFee/agreelist/selectAgreeDelegLog.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		           		alert("처리도중 오류가 발생하였습니다.");
		           		return;
		   			} else {
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
				   		trainingFeeAgreeLogGrid.setData(gridData);
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});			

		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교육비 위임 동의서 현황</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">약관동의현황</a></li>
				<li class="end"><a href="#">교육비위임동의</a></li>
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
				<th>회계연도</th>
				<td>
					<input type="text" id="searchGiveYear" name="datepYear" class="AXInput datepYear setDateYear" readonly="readonly">
				</td>
				<th>동의여부</th>
				<td>
					<select id="cbApprove" name="cbApprove" > 
						<option value="">선택</option>
						<ct:code type="option" majorCd="TR6" selectAll="false" />
					</select>
				</td>
				<th rowspan="6">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			<tr>
				<th>ABO</th>
				<td colspan="3">
					<div id="aboSearch" style="float:left;">
						<label style="width:70px;text-align:right;">피위임자 :</label>
						<select id="txtCalSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
							<option value="1">ABO 번호</option>
							<option value="2">ABO 이름</option>
						</select>
						<input type="text" id="CalculationNm" name="CalculationNm" style="width:auto; min-width:100px" >
						<a href="javascript:;" id="btnCalSearch" name="btnCalSearch" class="btn_gray btn_mid">검색</a>
					</div>
					<div id="aboSearch1" style="float:left;">
						<label style="width:70px;text-align:right;">위임자 :</label>
						<select id="txtDepSearchType" name="txtDepSearchType" style="width:auto; min-width:100px" >
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
			<tr>
				<th scope="row">위임구분</th>
				<td colspan="3">
					<select id="delegtypecode" name="delegtypecode">
						<ct:code type="option" majorCd="TR5" selectAll="true" except="IN ('1','2')" />
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
			
	<!-- Board List -->
		
</body>