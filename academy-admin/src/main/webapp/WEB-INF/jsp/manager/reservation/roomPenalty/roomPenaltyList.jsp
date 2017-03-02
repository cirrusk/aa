<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>


<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.common.list"
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
    
	roomPenaltyList.init();
	roomPenaltyList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		roomPenaltyList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		roomPenaltyList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 패널티 현황 엑셀 다운로드
	$("#aRoomPenaltyExcelDown").on("click", function () {
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			
			var initParam = {
				searchTypeCode : $("#searchTypeCode option:selected").val(),
				searchApplyTypeCode : $("#searchApplyTypeCode option:selected").val(),
				searchStartGrantDate : $("#searchStartGrantDate").val(),
				searchEndGrantDate : $("#searchEndGrantDate").val(),
				searchStatusCode : $("#searchStatusCode option:selected").val(),
				searchStatusName : $("#searchStatusName").val()
			};
			postGoto("/manager/reservation/roomPenalty/roomPenaltyListExcelDownload.do", initParam);
			
			hideLoading();
		}
	});
	
	// 등록 버튼 클릭시
// 	$("#aBasePlazaInsert").on("click", function(){
// 		var popParam = {
// 				url : "<c:url value="/manager/reservation/basePlaza/basePlazaInsertPop.do" />"
// 				, width : "512"
// 				, height : "400"
// // 				, params : param
// 				, targetId : "searchPopup"
// 		}
// 		window.parent.openManageLayerPopup(popParam);
// 	});
	
	// 노출번호 지정 버튼 클릭시
// 	$("#aBasePlazaRowChangeUpdate").on("click", function(){
// 		var popParam = {
// 				url : "<c:url value="/manager/reservation/basePlaza/basePlazaRowChangeUpdatePop.do" />"
// 				, width : "512"
// 				, height : "800"
// // 				, params : param
// 				, targetId : "searchPopup"
// 		}
// 		window.parent.openManageLayerPopup(popParam);
// 	});
	
	// 변경이력 버튼 클릭시
// 	$("#aBasePlazaHistorySelect").on("click", function(){
// 		var popParam = {
// 				url : "<c:url value="/manager/reservation/basePlaza/basePlazaHistoryListPop.do" />"
// 				, width : "1024"
// 				, height : "800"
// // 				, params : param
// 				, targetId : "searchPopup"
// 		}
// 		window.parent.openManageLayerPopup(popParam);
// 	});
});

/* 시설 패널티 현황 상세 */
function roomPenaltyDetailPop(historyseq) {
	var popParam = {
			url : "<c:url value="/manager/reservation/roomPenalty/roomPenaltyDetailPop.do" />"
			, width : "512"
			, height : "400"
			, params : {historySeq: historyseq}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

/* 시설 패널티 해제 */
function roomPenaltyCancelLimit(historyseq, rsvseq) {
	var param = {
			historySeq : historyseq,
			rsvseq : rsvseq,
			noshowcode : "R01",
			paymentstatuscode : "P02"
		};
	
	sUrl = "<c:url value="/manager/reservation/roomPenalty/roomPenaltyCancelLimitUpdateAjax.do"/>";
	
	
	var result = confirm("해당 패널티가 해제됩니다.\n진행하시겠습니까?");
	
	if(result) {
		$.ajaxCall({
			method : "POST",
			url : sUrl,
			dataType : "json",
			data : param,
			success : function(data, textStatus, jqXHR) {
				if (data.result.errCode < 0) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
				}else{
					alert("저장 완료 하였습니다.");
				}
// 				closeManageLayerPopup("searchPopup");
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

//Grid Init
var roomPenaltyListGrid = new AXGrid(); // instance 상단그리드
var roomPenaltyList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"NO", width:"50", align:"center", formatter:"money", sort:false}
							, {key:"account", label:"ABO No.", width:"150", align:"center", sort:false}
							, {key:"aboname", label:"ABO 이름", width:"100", align:"center", sort:false}
							, {key:"typecode", label:"패널티 유형", width:"150", align:"center", sort:false}
							, {key:"applytypecode", addClass:idx++, label:"패널티 내용", width:"200", align:"center"}
							, {key:"grantdate", addClass:idx++, label:"적용일자", width:"150", align:"center"}
							, {key:"typename", addClass:idx++, label:"시설타입", width:"100", align:"center"}
							, {key:"limitstartdate", addClass:idx++, label:"제한시작일", width:"150", align:"center"}
							, {key:"limitenddate", addClass:idx++, label:"제한종료일", width:"150", align:"center"}
							, {key:"btns", addClass:idx++, label:"상세보기", width:"100", align:"center", formatter: function(){
								return "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javasctipt:roomPenaltyDetailPop('"+this.item.historyseq+"')\">보기</a>";
							  }}
							, {key:"btns", addClass:idx++, label:"해제", width:"100", align:"center", formatter: function(){
								if(this.item.tempapplytypecode != 'P01'){
									if(this.item.penaltystatuscode == 'B02'){
										return "해제완료";
									}else{
										if(param.menuAuth == "W"){
											return "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javasctipt:roomPenaltyCancelLimit('"+this.item.historyseq+"', '"+this.item.rsvseq+"')\">해제</a>";
										}else{
											return "";
										}
									}
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
									, {colSeq: 2, rowspan: 2, valign:"middle"}
									, {colSeq: 3, rowspan: 2, valign:"middle"}
									, {colSeq: 4, rowspan: 2, valign:"middle"}
									, {colSeq: 5, rowspan: 2, valign:"middle"}
									, {colSeq: 6, rowspan: 2, valign:"middle"}
									, {colSeq: 7, rowspan: 2, valign:"middle"}
									, {colSeq: 8, rowspan: 2, valign:"middle"}
									, {colSeq: 9, rowspan: 2, valign:"middle"}
									, {colSeq: 10, rowspan: 2, valign:"middle"}
			                  	]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : roomPenaltyList.doSortSearch
					, doPageSearch : roomPenaltyList.doPageSearch
				}
			
			fnGrid.initGrid(roomPenaltyListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			roomPenaltyList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			roomPenaltyList.doSearch(param);
			
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				searchTypeCode : $("#searchTypeCode option:selected").val(),
				searchApplyTypeCode : $("#searchApplyTypeCode option:selected").val(),
				searchStartGrantDate : $("#searchStartGrantDate").val(),
				searchEndGrantDate : $("#searchEndGrantDate").val(),
				searchStatusCode : $("#searchStatusCode option:selected").val(),
				searchStatusName : $("#searchStatusName").val()
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/reservation/roomPenalty/roomPenaltyListAjax.do"/>"
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
// 		   		console.log(obj);

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
		   		roomPenaltyListGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">시설 패널티 현황</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="*" />
				<col width="*"  />
				<col width="*" />
				<col width="*" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>패널티 유형</th>
				<td scope="row">
					<select id="searchTypeCode" name="searchTypeCode" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" items="${penaltyTypeCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				<th>패널티 내용</th>
				<td scope="row" colspan="2">
					<select id="searchApplyTypeCode" name="searchApplyTypeCode" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" items="${penaltyApplyTypeCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
			<tr>
				<th>적용일자</th>
				<td colspan="5">
					<input type="text" id="searchStartGrantDate" name="" class="AXInput datepDay " readonly="readonly">&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
					<input type="text" id="searchEndGrantDate" name="" class="AXInput datepDay " readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>예약자</th>
				<td scope="row" colspan="3">
					<select id="searchStatusCode" name="searchStatusCode" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" items="${searchAccountTypeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
					<input type="text" id="searchStatusName" name="searchStatusName">
				</td>
				<th>
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
				
			</tr>
		</table>
	</div>

	<div class="contents_title clear">
		<br/>
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount}"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" id="aRoomPenaltyExcelDown" class="btn_green">엑셀다운</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
		
</body>