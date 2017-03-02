<!-- 교육비 지출 증빙 서류 !!-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
//Grid Init
var trainingFeeTotalGrid = new AXGrid(); // instance 상단그리드


//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "self.self.list1"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	trainingFeeTotal.init();
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeTotal.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
});

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

var trainingFeeTotal = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"grpCd", width:"40", align:"center", formatter:"checkbox", formatterLabel:"", sort:false, checked:function(){
								return this.item.___checked && this.item.___checked["1"];
							  }}
							, {key:"rowNum", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
							, {key:"selfYear", label:"지급 월", width:"40", align:"center", sort:false}
							, {key:"selfYear", label:"ABO 번호", width:"40", align:"center", sort:false}
							, {key:"selfPlanNm", addClass:idx++, label:"ABO 성명", width:"100", align:"center", formatter: function(){
							 	return "<a href=\"javascript:;\" onclick=\"doSearchTab('" + this.index + "')\">" + this.item.knowNm + "</a>";
							  }}
							, {key:"selfWriteStDt", addClass:idx++, label:"교육비", width:"60", align:"center"}
							, {key:"selfWriteEnDt", addClass:idx++, label:"합계", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"개인", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"상태", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"운영그룹", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"그룹", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"상태", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"합계", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"처리일자", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:"처리상태", width:"60", align:"center"}
							, {key:"selfApprovalStDt", addClass:idx++, label:" ", width:"60", align:"center"}
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
									, {colseq:null, colspan: 1, label: "계획서", align: "center", valign:"middle"}
									, {colseq:null, colspan: 6, label: "지출증빙 서류", align: "center", valign:"middle"}
									, {colSeq: 13, rowspan: 2, valign:"middle"}
									, {colSeq: 14, rowspan: 2, valign:"middle"}
									, {colSeq: 15, rowspan: 2, valign:"middle"}
			                  	], [
										{colSeq: 6}
										,{colSeq: 7}
										,{colSeq: 8}
										,{colSeq: 9}
										,{colSeq: 10}
										,{colSeq: 11}
										,{colSeq: 12}
			                      ]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeTotal.doSortSearch
					, doPageSearch : trainingFeeTotal.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeTotalGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			trainingFeeTotal.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeTotal.doSearch(param);
		}, doSearch : function(param) {
			/**
			// Param 셋팅(검색조건)
			var initParam = {
					selfYear : localSelfYear	
				  , selfPlanCd :localSelfPlanCd
				  , selfTeamCd :selfTeamCd
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manage/self/selfCheapAppStateAjax.mvc"/>"
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

		   		// Grid Bind
		   		var gridData = {
			   			list: obj.aDataList,
			   			page:{
			   				pageNo: obj.page,
			   				pageSize: defaultParam.rowPerPage,
			   				pageCount: obj.totalPage,
			   				listCount: obj.totalCount
			   			}
			   		};			   		
		   		
		   		// Grid Bind Real
		   		trainingFeeGrid.setData(gridData);
		   	}
			*/
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교욱비 지출 증빙 서류</h2>
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
				<td scope="row">
					<input type="text" id="" name="" style="width:auto; min-width:100px" >
				</td>
				
				<th scope="row">ABO<br>(Deposit)</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">ABO 번호</option>
					</select>
					<input type="text" id="" name="" style="width:auto; min-width:100px" >
					<a href="javascript:;" id="btnSearch" class="btn_gray btn_mid">검색</a>
				</td>
				
				
				<th rowspan="5">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
				
			</tr>
			<tr>
				<th scope="row">상태(개인)</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
				
				<th scope="row">상태(그룹)</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">BR</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
				<th scope="row">운영그룹</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">Code</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
				<th scope="row">LOA</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th scope="row">C.Pin</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
				<th scope="row">Dept</th>
				<td>
					<select id="txtSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
						<option value="">전체</option>
					</select>
				</td>
				
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
<!-- 		<div class="fr"> -->
<!-- 			<a href="javascript:;" id="aInsert" class="btn_orange">업로드처리유무</a> -->
<!-- 			<a href="javascript:;" id="aInsertEnd" class="btn_orange">종료</a>			 -->
<!-- 		</div> -->
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>