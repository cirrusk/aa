<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.room.roomSubscriber"
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
	
	roomSubscriberList.init();
	roomSubscriberList.doSearch({page:1});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		roomSubscriberList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		roomSubscriberList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	//엑셀 다운로드
	$("#aRoomSubscriberExcelDown").on("click", function () {
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			
			var initParam = {
				  searchPpCode : $("#searchPpCode option:selected").val()
				, searchRoomTypeCode : $("#searchRoomTypeCode option:selected").val()
				, rsvProgressFormCode : $("#rsvProgressFormCode option:selected").val()
				, searchStrRsvDate : $("#searchStrRsvDate").val()
				, searchEndRsvDate : $("#searchEndRsvDate").val()
				, purchaseStrDate : $("#purchaseStrDate").val()
				, purchaseEndDate : $("#purchaseEndDate").val()
				, searchSessionCode : $("#searchSessionCode option:selected").val()
				, searchDivisionMemverCode : $("#searchDivisionMemverCode option:selected").val()
				, searchRoomName : $("#searchRoomName").val()
				, searchAccountTypeKey : $("#searchAccountTypeKey option:selected").val()
				, searchAccountTypeValue : $("#searchAccountTypeValue").val()
				, searchSessionCode : $("#searchSessionCode option:selected").val()
			};
			postGoto("/manager/reservation/roomSubscriber/roomSubscriberExcelDownload.do", initParam);
			
			hideLoading();
		}
	});

});

function searchSessionName(){
	if($("#searchPpCode option:selected").val() == ""){
		return false;
	}
	
	if( $("#searchRoomTypeCode option:selected").val() == ""){
		return false;
	}
	
	var param = {
		  ppseq : $("#searchPpCode option:selected").val()
		, typeseq : $("#searchRoomTypeCode option:selected").val()
		, rsvtypecode : "R01"
	}
	
	$.ajaxCall({
		url: "<c:url value="/manager/reservation/roomSubscriber/searchSessionNameListAjax.do"/>"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var data = data.dataList;

			$("#searchSessionCode").empty();
			$("#searchSessionCode").append("<option value=>선택</option>"); 
			
			for(var i = 0; i < data.length; i++){
				$("#searchSessionCode").append("<option value="+data[i].sessionname+">" +data[i].sessionname+ "</option>");
				 
			}

		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 관리자 우선예약 취소 */
function adminRoomCancel(rsvseq, cancelcode){
	var result = confirm("해당 운영자예약을 취소 하시겠습니까?");
	
	var param = {
		  rsvseq : rsvseq
		, cancelcode : "B01"
		, paymentstatuscode : "P03"
	}
	
	if(result) {
		$.ajaxCall({
			url: "<c:url value="/manager/reservation/roomSubscriber/adminRoomCancelAjax.do"/>"
			, data: param
			, success: function(data, textStatus, jqXHR){
				if (data.result.errCode < 0) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
				}else{
					alert("정상적으로 처리 하였습니다.");
					roomSubscriberList.doSearch({page:1});
				}
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

/* noShow 지정 해제 */
function noShowConfirmChkeck(rsvseq, noshowcode){
	
	var msg;
	/* noShow지정 */
	if(noshowcode == "R01"){
		var result = confirm("해당 예약자에 대해 No Show 지정을 하시겠습니까?");
		msg = "No Show 지정 완료 되었습니다."
		var param = {
			  rsvseq : rsvseq
			, noshowcode : "R02"
			, paymentstatuscode : "P05"
			, statuscode : "B01"
		};
		
	}else if(noshowcode == "R02"){
	/* noShow 지정 해제 */
		msg = "No Show 해제 완료 되었습니다."
		var result = confirm("해당 예약자에 대해 No Show 지정을  해제 하시겠습니까?");
		var param = {
				  rsvseq : rsvseq
				, noshowcode : "R01"
				, paymentstatuscode : "P06"
				, statuscode : "B01"
			};
		
	}
	
	if(result) {
		$.ajaxCall({
			url: "<c:url value="/manager/reservation/roomSubscriber/noShowCodeUpdateAjax.do"/>"
			, data: param
			, success: function(data, textStatus, jqXHR){
				if (data.result.errCode < 0) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
				}else{
					alert(msg);
					roomSubscriberList.doSearch({page:1});
				}
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}
}

/* 환불 내역 상세보기 */
function roomRefundHistoryDetail(rsvseq){
	param = {
		rsvseq : rsvseq 
	};
	var popParam = {
			url : "<c:url value="/manager/reservation/roomSubscriber/roomRefundHistoryPop.do" />"
			, width : "600"
			, height : "400"
			, params : param
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

//Grid Init
var roomSubscriberListGrid = new AXGrid(); // instance 상단그리드
var roomSubscriberList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", addClass:idx++, label:"No.", width:"50", align:"center", formatter:"money", sort:false}
							, {key:"account", addClass:idx++, label:"예약자", width:"100", align:"center", sort:false}
							, {key:"memberdivison", addClass:idx++, label:"회원 구분", width:"100", align:"center"}
							, {key:"temp", addClass:idx++, label:"핀/나이/지역/요리명장", width:"100", align:"center"}
							, {key:"ppname", addClass:idx++, label:"PP", width:"100", align:"center"}
							, {key:"roomname", addClass:idx++, label:"시설명", width:"100", align:"center"}
							, {key:"typename", addClass:idx++, label:"시설타입", width:"100", align:"center"}
							, {key:"reservationdate", addClass:idx++, label:"사용일", width:"100", align:"center"}
							, {key:"sessionname", addClass:idx++, label:"세션", width:"100", align:"center"}
							, {key:"sessiontime", addClass:idx++, label:"시간", width:"100", align:"center"}
							, {key:"purchasedate", addClass:idx++, label:"등록일", width:"100", align:"center"}
							, {key:"paymentamount", addClass:idx++, label:"금액", width:"100", align:"center"}
							, {key:"adminfirstreason", addClass:idx++, label:"사유", width:"100", align:"center"}
							, {key:"paymentstatusname", addClass:idx++, label:"예약 상태", width:"100", align:"center", formatter: function(){
								if(this.item.cancelcode == "B02"){
									if(this.item.paymentstatuscode == "P05"){
										return "-";
									}else{
										return this.item.paymentstatusname;
									}
								}else{
									if(this.item.paymentstatuscode == "P05"){
										return "-";
									}else{
										return "예약취소";
									}
								}
								
							}}
							, {key:"btns", addClass:idx++, label:"예약취소", width:"100", align:"center", formatter: function(){
								
								/* 결제 유무가 사용 완료일 경우 - */
								if(this.item.paymentstatuscode == "P06"){
									return "-";
								}else{
									/* 관리자 우선 예약일 경우 */
									if(this.item.adminfirstcode == "R01"){
										/* 관리자 우선 얘약을 취소를 하였을 경우 */
										if(this.item.cancelcode == "B01"){
											return "-"
										}else if(this.item.cancelcode == "B02"){
											/* 관리자 우선 예약을 하였을 경우 */
											if(param.menuAuth == "W"){
												return "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javascript:adminRoomCancel('"+this.item.rsvseq+"', '"+this.item.cancelcode+"')\">취소</a>";
											}else{
												return "";
											}
										}
									/* 일반 ABO 예약일 경우 */
									}else if(this.item.adminfirstcode == "R02"){
										if(this.item.cancelcode == "B01" && this.item.paymentamount != "0"){
											return "<a href=\"javascript:;\" onclick=\"javascript:roomRefundHistoryDetail('"+this.item.rsvseq+"')\">환불</a>";
										}else if(this.item.paymentamount == "0"){
											return "-";
										}else{
											return "-";
										}
									}
								}
								
								
							  }}
							, {key:"btns", addClass:idx++, label:"No Show", width:"100", align:"center", formatter: function(){
								/* 관리자 일경우 */
								if(this.item.adminfirstcode == "R01"){
									return "-";
								}else{
									/* 일반 사용자 */
									if(this.item.cancelcode == "B02"){
										/* no show가 아닐 경우 */
										
										/* 유료 */
										if(this.item.noshowcode == "R01" && this.item.paymentamount == "0"){
											if(param.menuAuth == "W"){
												if(this.item.noshowflag == "T"){
													return "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javascript:noShowConfirmChkeck('"+this.item.rsvseq+"', '"+this.item.noshowcode+"')\">지정</a>";
												}else{
													return "";
												}
											}else{
												return "";
											}
										/* no show일 경우 */
										}else if(this.item.noshowcode == "R02"){
											if(param.menuAuth == "W"){
												return "No Show <br/> <a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javascript:noShowConfirmChkeck('"+this.item.rsvseq+"', '"+this.item.noshowcode+"')\">해제</a>";
											}else{
												return "";
											}
											
										/* 무료일경우 */
										}else if(this.item.paymentamount >= "0"){
											return "-";
										}
									}else{
										return "-";
									}
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
									, {colSeq: 11, rowspan: 2, valign:"middle"}
									, {colSeq: 12, rowspan: 2, valign:"middle"}
									, {colSeq: 13, rowspan: 2, valign:"middle"}
									, {colSeq: 14, rowspan: 2, valign:"middle"}
									, {colSeq: 15, rowspan: 2, valign:"middle"}
									
			                  	]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : roomSubscriberList.doSortSearch
					, doPageSearch : roomSubscriberList.doPageSearch
				}
			
			fnGrid.initGrid(roomSubscriberListGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			roomSubscriberList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			roomSubscriberList.doSearch(param);
			
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				  searchPpCode : $("#searchPpCode option:selected").val()
				, searchRoomTypeCode : $("#searchRoomTypeCode option:selected").val()
				, rsvProgressFormCode : $("#rsvProgressFormCode option:selected").val()
				, searchStrRsvDate : $("#searchStrRsvDate").val()
				, searchEndRsvDate : $("#searchEndRsvDate").val()
				, purchaseStrDate : $("#purchaseStrDate").val()
				, purchaseEndDate : $("#purchaseEndDate").val()
				, searchSessionCode : $("#searchSessionCode option:selected").val()
				, searchDivisionMemverCode : $("#searchDivisionMemverCode option:selected").val()
				, searchRoomName : $("#searchRoomName").val()
				, searchAccountTypeKey : $("#searchAccountTypeKey option:selected").val()
				, searchAccountTypeValue : $("#searchAccountTypeValue").val()
				, searchSessionCode : $("#searchSessionCode option:selected").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/reservation/roomSubscriber/roomSubscriberListAjax.do"/>"
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
		   		roomSubscriberListGrid.setData(gridData);
		   	}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">예약자 관리</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<th>PP</th>
				<td style="width: 40%">
					<select id="searchPpCode" name="searchPpCode"  onchange="javascript:searchSessionName();">
						<c:if test="${1 < fn:length(ppCodeList)}">
							<option value="">전체</option>
						</c:if>
						<c:forEach var="item" items="${ppCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				
				<th>시설타입</th>
				<td>
					<select id="searchRoomTypeCode" name="searchRoomTypeCode" onchange="javascript:searchSessionName();">
						<option value="">전체</option>
						<c:forEach var="item" items="${roomtypecodelist}">
							<option value="${item.commoncodeseq}">${item.codename}</option>
						</c:forEach>
					</select>
				</td>
				
				<th scope="row">상태</th>
				<td>
					<select id="rsvProgressFormCode" name="rsvProgressFormCode">
						<option value="">전체</option>
						<c:forEach var="item" items="${reservationProgressFormCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				<th rowspan="4">
					<!-- 운영그룹_검색 -->
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width: 40%">검색</a>
					</div>
				</th>
			</tr>
			
			<tr>
				<th>사용 일자</th>
				<td>
					<input type="text" id="searchStrRsvDate" name="searchStrRsvDate" class="AXInput datepDay" style="width: 30%;" readonly="readonly">&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
					<input type="text" id="searchEndRsvDate" name="searchEndRsvDate" class="AXInput datepDay" style="width: 30%;" readonly="readonly">
				</td>
				
				<th scope="row">등록일</th>
				<td colspan="3">
					<input type="text" id="purchaseStrDate" name="purchaseStrDate" class="AXInput datepDay" style="width: 30%;"  readonly="readonly">&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
					<input type="text" id="purchaseEndDate" name="purchaseEndDate" class="AXInput datepDay" style="width: 30%;"  readonly="readonly">
				</td>
			</tr>
			
			<tr>
				<th scope="row">세션</th>
				<td>
					<select id="searchSessionCode" name="searchSessionCode">
						<option value="">전체</option>
					</select>
				</td>
				
				<th scope="row">회원구분</th>
				<td  colspan="3">
					<select id="searchDivisionMemverCode" name="searchDivisionMemverCode">
						<option value="">전체</option>
						<c:forEach var="item" items="${divisionMemverCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			
			<tr>
				<th scope="row">시설명</th>
				<td>
					<input type="text" id="searchRoomName" name="searchRoomName">
				</td>
				
				<th scope="row">예약자</th>
				<td  colspan="3">
					<select id="searchAccountTypeKey" name="searchAccountTypeKey">
						<option value="">전체</option>
						<c:forEach var="item" items="${searchAccountTypeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
					<input type="text" id="searchAccountTypeValue" name="searchAccountTypeValue">
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
		<div class="fr">
			<a href="javascript:;" id="aRoomSubscriberExcelDown" class="btn_green">엑셀다운</a>
		</div>
		
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
		
</body>
