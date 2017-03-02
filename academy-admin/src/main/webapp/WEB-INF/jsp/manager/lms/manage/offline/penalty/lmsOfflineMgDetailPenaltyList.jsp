<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

var penaltyListGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.offline.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};
$(document.body).ready(function(){
	penaltyList.init();
	penaltyList.doSearch({page:1});
	myIframeResizeHeight(frmid);
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		penaltyList.doSearch({page:1});
	});
	
});

		 /* 교육신청자 관리 탭 구성 */
		 var penaltyList = {
		 		/** init : 초기 화면 구성 (Grid)*/	
		 		init : function() {
		 			var idx = 0; // 정렬 Index 
		 			var _colGroup = [
		 								 {key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
		 								, {key:"uid", label:"ABO 번호", width:"200", align:"center"}
		 								, {key:"name", label:"이름", width:"200", align:"center"}
		 								, {key:"pincode", label:"핀레벨(신청)", width:"150", align:"center"}
		 								, {key:"finishflag", label:"출석여부", width:"150", align:"center"}
		 								, {key:"cleardate", label:"페널티 종료일", width:"250", align:"center"}
		 							]
		 			var gridParam = {
		 					colGroup : _colGroup
		 					, fitToWidth: false
		  					//, fixedColSeq: 3
		 					, colHead : { heights: [25,25]}
		 					, targetID : "AXGridTarget_Penalty"
		 					, sortFunc : penaltyList.doSortSearch
		 					, doPageSearch : penaltyList.doPageSearch
		 				}

		 			fnGrid.initGrid(penaltyListGrid, gridParam);
		 		}, doPageSearch : function(pageNo) {
		 			// Grid Page List
		 			penaltyList.doSearch({page:pageNo});
		 		}, doSortSearch : function(){
		 			var sortParam = getParamObject(penaltyListGrid.getSortParam()+"&page=1");
		 			defaultParam.sortOrder = sortParam.sortWay; 
		 			// 리스트 갱신(검색)
		 			penaltyList.doSearch(sortParam);
		 		}, doSearch : function(param) {
		 			
		 			// Param 셋팅(검색조건)
		 			 var initParam = {
		 					searchpinlevel : $("#searchpinlevel").val()	
		 				  , searchmemberinfo : $("#searchmemberinfo").val()
		 				  , courseid : "${courseid}"
		 				  , searchtext : $("#searchtext").val()
		 			}; 
		 			$.extend(defaultParam, param);
		 			$.extend(defaultParam, initParam);
		 			$.ajaxCall({
		 		   		url: "<c:url value="/manager/lms/manage/offline/penalty/lmsOfflineMgDetailPenaltyListAjax.do"/>"
		 		   		, data: defaultParam
		 		   		, success: function( data, textStatus, jqXHR){
		 		   			if(data.result < 1){
		 		        		alert("<spring:message code="errors.load"/>");
		 		        		alert("success"+data);
		 		        		return;
		 					} else {
		 						callbackList(data);
		 					}
		 		   		},
		 		   		error: function( jqXHR, textStatus, errorThrown) {
		 		           	alert("<spring:message code="errors.load"/>");
		 		           	alert("error"+textStatus);
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
		 		   		$("#totalcount").text(obj.totalCount);
		 		   		// Grid Bind Real
		 		   		penaltyListGrid.setData(gridData);
		 		   		
		 		   	}
		 			
		 		}
		 	}
</script>
</head>

<body class="bgw">
	<input type="hidden" id="courseid" value="${courseid }"/>
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="15%" />
						<col width="20%"  />
						<col width="10%" />
						<col width="45%" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th>핀레벨</th>
						<td>
							<select id="searchpinlevel" name="searchpinlevel">
								<option value="">선택</option>
								<c:forEach items="${pincodelist}" var="pincodelist">
									<option value="${pincodelist.targetcodeseq }"> ${pincodelist.casetwo } </option>
								</c:forEach>
							</select>
						</td>
						<th>조회</th>
						<td>
							<select id="searchmemberinfo" name="searchmemberinfo" style="width:auto; min-width:100px" >
								<option value="">전체</option>
								<option value="1">ABO번호</option>
								<option value="2">이름</option>
							</select>
							<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
						</td>
						<td>
							<div class="btnwrap mb10">
								<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
							</div>
						</td>
					</tr>
				</table>
				<br/>
				
				<div class="contents_title clear">
					<div class="fl">
						<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
							<option value="20">20</option>
							<option value="50">50</option>
							<option value="500">500</option>
							<option value="1000">1000</option>
						</select>
						
						<span> Total : <span id="totalcount"></span>건</span>
					</div>
				</div>
				
				
				<!-- axisGrid -->
				<div id="AXGrid">
					<div id="AXGridTarget_Penalty"></div>
				</div>
				
		</div>
</body>