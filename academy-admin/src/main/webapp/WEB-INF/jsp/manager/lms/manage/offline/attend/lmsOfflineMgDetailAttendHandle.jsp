<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

var attendListGrid = new AXGrid(); // instance 상단그리드

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.offline.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	var penaltyFlag = $("#penaltyFlag").val();
	
	if(penaltyFlag == "N")
		{
			$("#penaltyBtn").hide();
		}
	
	
	attendList.init();
	attendList.doSearch();
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		attendList.doSearch({page:1});
	});
	
	//출석결과 엑셀등록 버튼 클릭시
	$("#insertExcelBtn").on("click",function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
			var popParam = {
					url : "/manager/lms/manage/offline/attend/lmsOfflineMgDetailAttendExcelPop.do"
					, width : 1024
					, height : 600
					, maxHeight : 600
					, params : {courseid : $("#courseid").val()}
					, targetId : "attendResultPop"
			}
			window.parent.openManageLayerPopup(popParam);
		
	});

	//바코드 출석 처리 버튼 클릭시
	$("#attendBarcodeBtn").on("click",function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		var popParam = {
				url : "/manager/lms/manage/offline/attend/lmsOfflineMgDetailAttendBarcodePop.do"
				, width : 1024
				, height : 900
				, maxHeight : 900
				, params : {courseid : $("#courseid").val()}
				, targetId : "attendBarcodePop"
		}
		window.parent.openManageLayerPopup(popParam);
		
	});
	
	$("#rowPerPage").on("change", function(){
		attendList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	//저장버튼 클릭시
	$("#saveBtn").on("click",function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
		var uids = [];
		var finishflags = [];
		var beforefinishflags = [];
		var attendflags = [];
		var beforeattendflags = [];
		for(var i = 0; i < attendListGrid.list.length; i++){
			uids[i] = attendListGrid.list[i].uid + "";
			finishflags[i] = attendListGrid.list[i].finishflag + "";
			beforefinishflags[i] = attendListGrid.list[i].beforefinishflag + "";
			attendflags[i] = attendListGrid.list[i].attendflag + "";
			beforeattendflags[i] = attendListGrid.list[i].beforeattendflag + "";
		}
		var param = {
				courseid : $("#courseid").val()
				, uids : uids
				, finishflags : finishflags
				, beforefinishflags : beforefinishflags
				, attendflags : attendflags
				, beforeattendflags : beforeattendflags
		}
		
		if( !confirm("출석 정보를 저장하겠습니까?") ) {
			return;
		}
		
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/manage/offline/attend/lmsOfflineMgAttendUpdateAjax.do"/>"
	   		, data: param
	   		, success: function( data, textStatus, jqXHR){
	        		alert("저장완료하였습니다.");
					
	        		var iniObject = {
							optionValue : "3"
							,optionText : "출석처리"
							,tabId : "3"
					}
					
					layer.setViewTab("3",iniObject);
	        		newShowApplicantCount();
	        		
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	           	alert("error"+textStatus);
	   		}
	   	});
	});
	
	//마감(페널티처리) 버튼 클릭시
	$("#penaltyBtn").on("click",function(){
		
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
		if(penaltyFlag == "Y")
			{
				var param = "courseid="+$("#courseid").val();
				
				$.ajaxCall({
			   		url: "<c:url value="/manager/lms/manage/offline/attend/lmsOfflineMgAttendFinishPenaltyAjax.do"/>"
			   		, data: param
			   		, success: function( data, textStatus, jqXHR){
			        		alert(data.result);
			   		},
			   		error: function( jqXHR, textStatus, errorThrown) {
			           	alert("<spring:message code="errors.load"/>");
			           	alert("error"+textStatus);
			   		}
			   	}); 
			}
		else
			{
				alert("해당과정은 페널티적용과정이 아닙니다.");
			}
	});
	
});
function changeAttendFlag(val, index){
	attendListGrid.list[index].attendflag = val;
}
function changeFinishFlag(val, index){
	attendListGrid.list[index].finishflag = val;
}

			/* 교육신청자 관리 탭 구성 */
			var attendList = {
					/** init : 초기 화면 구성 (Grid)
					*/		
					init : function() {
						var idx = 0; // 정렬 Index 
						var _colGroup = [
											 {key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
											, {
												key:"uid", label:"ABO 번호", width:"200", align:"center", formatter: function()
													{
														return "<span name='uid'>"+this.item.uid+"</span>";
													}
												}
											, {key:"name", label:"이름", width:"150", align:"center"}
											, {key:"pincode", label:"핀레벨", width:"150", align:"center"}
											, {key:"requestchannel", label:"신청채널", width:"150", align:"center"}
											, {key:"requestdate", label:"신청일시", width:"150", align:"center"}
											, {
												key:"attendflag", label:"출석구분", width: "150", align: "center", sort: false, formatter: function () {
													var selectTag = "";
													selectTag += "<select id='attendflag_"+this.item.no.number()+"' name='attendflags' onchange='changeAttendFlag(this.value, "+this.index+")'>";

													if(this.item.attendflag == 'C')
													{	
														selectTag += "<option value='C' selected='selected'>바코드</option>                           ";
														selectTag += "<option value='M'>수동</option>                             ";
													}
													else
													{
														selectTag += "<option value='C'>바코드</option>                           ";
														selectTag += "<option value='M'  selected='selected'>수동</option>                             ";
													}

														selectTag += "</select>  ";
														
														return selectTag+"<input type='hidden' name='uids' value='"+this.item.uid+"'/><input type='hidden' name='beforeattendflags' value='"+this.item.attendflag+"'/>";
												}
											}
											, {		
													key: "finishflag", label : "출석여부", width: "150", align: "center", sort: false, formatter: function () {
														var selectTag = "";
														selectTag += "<select id='finishflag_"+this.item.no.number()+"' name='finishflags' onchange='changeFinishFlag(this.value, "+this.index+")'>";

														if(this.item.finishflag == 'Y')
															{	
																selectTag += "<option value='N'>미출석</option>                           ";
																selectTag += "<option value='Y' selected='selected'>출석</option>                             ";
															}
														else
															{
																selectTag += "<option value='N' selected='selected'>미출석</option>                           ";
																selectTag += "<option value='Y'>출석</option>                             ";
															}
														
																selectTag += "</select>  ";
																
																return selectTag+"<input type='hidden' name='beforefinishflags' value='"+this.item.finishflag+"'/>";
													}
												}
											, {
												key:"togetherstatus", label:"부사업자 참석", width:"100", align:"center", formatter: function(){
													if($("#togetherflag").val() == "Y")
														{
															return this.item.togetherstatus;
														}
													else
														{
															return "미허용 과정";
														}
												}
											}
											, {key:"seatnumber", label:"좌석번호", width:"150", align:"center"}
											, {key:"beforeattendflag", label:"이전출석구분", width:"150", align:"center", display:false}
											, {key:"beforefinishflag", label:"이전출석여부", width:"150", align:"center", display:false}
										]
						var gridParam = {
								colGroup : _colGroup
								, fitToWidth: false
			 					//, fixedColSeq: 3
								, colHead : { heights: [25,25]}
								, targetID : "AXGridTarget_Attend"
								, sortFunc : attendList.doSortSearch
								, doPageSearch : attendList.doPageSearch
							}

						fnGrid.initGrid(attendListGrid, gridParam);
					}, doPageSearch : function(pageNo) {
						// Grid Page List
						attendList.doSearch({page:pageNo});
					}, doSortSearch : function(){
						var sortParam = getParamObject(attendListGrid.getSortParam()+"&page=1");
						defaultParam.sortOrder = sortParam.sortWay; 
						// 리스트 갱신(검색)
						attendList.doSearch(sortParam);
					}, doSearch : function(param) {
						
						// Param 셋팅(검색조건)
						 var initParam = {
								 searchattendway : $("#searchattendway").val()	
							  , searchattendstatus : $("#searchattendstatus").val()
							  , courseid : "${courseid}"
							  , searchpinlevel : $("#searchpinlevel").val()
							  , searchtype : $("#searchtype").val()
							  , searchtext : $("#searchtext").val()
						}; 
						
						 $.extend(defaultParam, param);
							$.extend(defaultParam, initParam);
							$.ajaxCall({
						   		url: "<c:url value="/manager/lms/manage/offline/attend/lmsOfflineMgAttendListAjax.do"/>"
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
						   		attendListGrid.setData(gridData);
					   		 
					   	}
			}
}
function reSearch(){
	attendList.doSearch({page:1});
	newShowApplicantCount();
}
</script>
</head>

<body class="bgw">
	<input type="hidden" value="${togetherflag }" id="togetherflag">
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="20%"  />
				<col width="10%" />
				<col width="45%" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th>출석구분</th>
				<td>
					<select id="searchattendway" name="searchattendway" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="C">바코드</option>
						<option value="M">수동</option>
					</select>
				</td>
				<th>출석여부</th>
				<td>
					<select id="searchattendstatus" name="searchattendstatus" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="Y">출석</option>
						<option value="N">미출석</option>
					</select>
				</td>
				<th rowspan="4">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
					</div>
				</th>
			</tr>
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
						<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
							<option value="">전체</option>
							<option value="1">ABO번호</option>
							<option value="2">이름</option>
							<option value="3">좌석번호</option>
						</select>
						<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
					</td>
				</tr>
			</table>
		</div>
				
				<div class="contents_title clear">
					<div class="fl">
						<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
							<option value="20" >20</option>
							<option value="50">50</option>
							<option value="500">500</option>
							<option value="1000">1000</option>
						</select>
						
						<span> Total : <span id="totalcount"></span>건</span>
						<a href="javascript:;" id="saveBtn" class="btn_green" style="vertical-align:middle">저장</a>
					</div>
					
					<div class="fr">
						<a href="javascript:;" id="attendBarcodeBtn" class="btn_green" style="vertical-align:middle">현장 바코드 출석 처리</a>
						<a href="javascript:;" id="insertExcelBtn" class="btn_green" style="vertical-align:middle">출석결과 엑셀등록</a>
						<a href="javascript:;" id="penaltyBtn" class="btn_green" style="vertical-align:middle">마감(페널티처리)</a>
					</div>
				</div>
			
			<!-- axisGrid -->
				<div id="AXGrid">
				<form id="frm"  method="post" enctype="multipart/form-data">
					<input type="hidden" id="courseid"  name="courseid" value="${courseid }">
					<div id="AXGridTarget_Attend"></div>
				</form>
				</div>
				
</div>
</body>