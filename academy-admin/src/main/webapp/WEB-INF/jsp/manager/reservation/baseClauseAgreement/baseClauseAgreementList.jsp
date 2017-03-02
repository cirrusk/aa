<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.comon.BaseClauseAgreemnet"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	baseClauseAgreementList.init();
	baseClauseAgreementList.doSearch({page:1});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		baseClauseAgreementList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		baseClauseAgreementList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
});

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

//Grid Init
var baseClauseAgreementListGrid = new AXGrid(); // instance 상단그리드
var baseClauseAgreementList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
							, {key:"reserveperson", label:"예약자", width:"300", align:"center", sort:false}
							, {key:"divisionmemvername", addClass:idx++, label:"회원 구분", width:"100", align:"center"}
							, {key:"typename", addClass:idx++, label:"약관타입", width:"200", align:"center"}
							, {key:"title", addClass:idx++, label:"약관명", width:"200", align:"center"}
							, {key:"version", addClass:idx++, label:"버전", width:"100", align:"center"}
							, {key:"statusname", addClass:idx++, label:"동의여부", width:"100", align:"center"}
							, {key:"agreedatetime", addClass:idx++, label:"동의일자", width:"200", align:"center"}
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
					, sortFunc : baseClauseAgreementList.doSortSearch
					, doPageSearch : baseClauseAgreementList.doPageSearch
				}
			
			fnGrid.initGrid(baseClauseAgreementListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			baseClauseAgreementList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			baseClauseAgreementList.doSearch(param);
			
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				  searchClauseTypeCode : $("#searchClauseTypeCode option:selected").val()
				, searchDivisionMemverCode : $("#searchDivisionMemverCode option:selected").val()
				, searchAgreeStrDate : $("#searchAgreeStrDate").val()
				, searchAgreeEndDate : $("#searchAgreeEndDate").val()
				, searchAgreementCode : $("#searchAgreementCode option:selected").val()
				, searchSearchAccountTypeKey : $("#searchSearchAccountTypeKey option:selected").val()
				, searchSearchAccountTypeValue : $("#searchSearchAccountTypeValue").val()
			};
			
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/reservation/baseClauseAgreement/baseClauseAgreementListAjax.do"/>"
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
		   		baseClauseAgreementListGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">약관 관리</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="*"/>
				<col width="*"/>
				<col width="*"/>
				<col width="*"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>약관타입</th>
				<td>
					<select id="searchClauseTypeCode" name="searchClauseTypeCode">
						<option value="">전체</option>
						<c:forEach var="item" items="${clauseTypeCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				
				<th scope="row">회원구분</th>
				<td>
					<select id="searchDivisionMemverCode" name="searchDivisionMemverCode">
						<option value="">전체</option>
						<c:forEach var="item" items="${divisionMemverCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				<th rowspan="3">
					<!-- 운영그룹_검색 -->
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
			
			<tr>
				<th>동의 일자</th>
				<td>
					<input type="text" id="searchAgreeStrDate" name="" class="AXInput datepDay " readonly="readonly">&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
					<input type="text" id="searchAgreeEndDate" name="" class="AXInput datepDay " readonly="readonly">
				</td>
				
				<th scope="row">동의 여부</th>
				<td>
					<select id="searchAgreementCode" name="searchAgreementCode">
						<option value="">전체</option>
						<c:forEach var="item" items="${agreementCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			
			<tr>
				<th>예약자</th>
				<td colspan="3">
					<select id="searchSearchAccountTypeKey" name="searchSearchAccountTypeKey">
						<option value="">전체</option>
						<c:forEach var="item" items="${searchAccountTypeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
					<input type="text" id="searchSearchAccountTypeValue" name="searchSearchAccountTypeValue">
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
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
		
</body>