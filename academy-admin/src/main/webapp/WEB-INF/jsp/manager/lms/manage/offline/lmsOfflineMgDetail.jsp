<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통 공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

//Grid Init
var eduApplicantGrid = new AXGrid(); // instance 상단그리드

var g_params = {showTab:1};

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.offline.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};


	
$(document.body).ready(function(){
	
	layer.init();
	eduApplicantList.doSearch({page:1});
	
	var penaltyFlag = $("#penaltyFlag").val();
	
	if(penaltyFlag == "N")
		{
			$("#divLmsOfflineMgDetailTab_AX_Tabs_AX_3").hide();
		}
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		eduApplicantList.doSearch({page:1});
	});
	
	// 삭제 버튼 클릭시
	$("#deleteButton").on("click", function(){
		gridEvent.chkDelete();
	});
	
	$("#rowPerPage").on("change", function(){
		eduApplicantList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	//수강생 추가 버튼 클릭시
	$("#insertButton").on("click",function(){
		
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
		//교육신청자 추가 버튼 클릭
			var popParam = {
					url : "/manager/lms/manage/offline/applicant/lmsOfflineMgDetailApplicantPop.do"
					, width : 1024
					, height : 900
					, maxHeight : 900
					, params : {courseid : $("#courseid").val()}
					, targetId : "addApplicantPop"
			}
			window.parent.openManageLayerPopup(popParam);
		
	});
	
	$("#getGridDetailView").on("click", function(){
		getGridDetailView(eduApplicantGrid.getExcelFormat("html"));
	});
});


var layer = {
		init : function(){
			// 상단 탭
			$("#divLmsOfflineMgDetailTab").bindTab({
				  theme : "AXTabs"
				, overflow:"visible"
				, value: 1
				, options:[
					  {optionValue:"1", optionText:"교육신청자", tabId:"1"} 
					, {optionValue:"2", optionText:"좌석등록", tabId:"2"}
					, {optionValue:"3", optionText:"출석처리", tabId:"3"}
					, {optionValue:"4", optionText:"페널티대상자", tabId:"4"}
				]
				, onchange : function(selectedObject, value){
					layer.setViewTab(value, selectedObject);
				}
			});
			// 초기 화면 셋팅
			eduApplicantList.init();
		}, setViewTab : function(value, selectedObject){
			
					$("#tabLayer .tabView").hide();
					$("#divTabPage" + value).show();
					g_params.showTab = value;
					
					// Grid Bind Real
					if(g_params.showTab=="1") {
						window.location.reload();
						
					} else if(g_params.showTab=="2") {
					 $.ajax({
							url: "<c:url value="/manager/lms/manage/offline/seatRegister/lmsOfflineMgDetailSeatRegister.do"/>"
								, data: "courseid="+$("#courseid").val()+"&frmId=W010200102"
								, dataType : "text"
								, type : "post"
								, success: function(data)
									{
										$("#tabLayer").html(data);
									}
								, error: function()
									{
							           	alert("<spring:message code="errors.load"/>");
									}
						}) ;
				} else if(g_params.showTab=="3"){
					
						 $.ajax({
							url: "<c:url value="/manager/lms/manage/offline/attend/lmsOfflineMgDetailAttendHandle.do"/>"
								, data: "courseid="+$("#courseid").val()+"&frmId=W010200103"
								, dataType : "text"
								, type : "post"
								, success: function(data)
									{
										$("#tabLayer").html(data);
									}
								, error: function()
									{
							           	alert("<spring:message code="errors.load"/>");
									}
						}) ;
					} else if(g_params.showTab=="4"){
						
							$.ajax({
								url: "<c:url value="/manager/lms/manage/offline/penalty/lmsOfflineMgDetailPenaltyList.do"/>"
									, data: "courseid="+$("#courseid").val()+"&frmId=W010200104"
									, dataType : "text"
									, type : "post"
									, success: function(data)
										{
											$("#tabLayer").html(data);
										}
									, error: function()
										{
								           	alert("<spring:message code="errors.load"/>");
										}
							}) ;
							
					}
					myIframeResizeHeight(frmid);
			
		} // end func  setViewTab
	}

/* 교육신청자 관리 탭 구성 */
var eduApplicantList = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								{key:"uid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
								    return this.item.___checked && this.item.___checked["1"];
								}}
								, {key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
								, {key:"uid", label:"ABO 번호", width:"150", align:"center"}
								, {key:"name", label:"이름", width:"150", align:"center"}
								, {key:"pincode", addclass:idx++, label:"핀레벨", width:"100", align:"center"}
								, {key:"requestchannel",  label:"신청채널", width:"200", align:"center"}
								, {key:"requestdate",  label:"신청일시", width:"200", align:"center"}
								, {key:"togetherrequestflag",  label:"부사업자 신청", width:"150", align:"center"}
							]
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: false
 					//, fixedColSeq: 3
					, colHead : { heights: [25,25]}
					, targetID : "AXGridTarget_Applicant"
					, sortFunc : eduApplicantList.doSortSearch
					, doPageSearch : eduApplicantList.doPageSearch
				}

			fnGrid.initGrid(eduApplicantGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			eduApplicantList.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(eduApplicantGrid.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			eduApplicantList.doSearch(sortParam);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			 var initParam = {
					searchpinlevel : $("#searchpinlevel").val()	
				  , searchmemberinfo : $("#searchmemberinfo").val()
				  , courseid : "${detail.courseid}"
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/offline/lmsOfflineMgApplicantListAjax.do"/>"
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
		   		eduApplicantGrid.setData(gridData);
		   		
		   	}
			
		}
	}

var gridEvent = {
		chkDelete : function() {
			//권한체크함수
			if(checkManagerAuth($("#managerMenuAuth").val())){return;}
			
			
			// 선택 정보 삭제전 메세지 출력
			var checkedUidList = eduApplicantGrid.getCheckedParams(0, false);// colSeq
			var len = checkedUidList.length;
			if(len == 0){
				alert("선택된 교육신청자가 없습니다.");
				return;
			}
			

			 var result = confirm("선택한 교육신청자를 삭제 하시겠습니까?"); 
			 
			 if(result) {
				$.ajaxCall({
					url: "<c:url value="/manager/lms/manage/offline/lmsOfflineMgApplicantDeleteAjax.do"/>"
					, async : false
					, data: $.param(checkedUidList)+"&courseid="+$("#courseid").val()
					, success: function(data, textStatus, jqXHR){
						alert(data.cnt + "건이 삭제 되었습니다.");
						eduApplicantList.doSearch({page:1});
						newShowApplicantCount();
					},
					error: function( jqXHR, textStatus, errorThrown) {
			           	alert("<spring:message code="errors.load"/>");
					}
				});
			}    
		}
}

function reSearch(){
	location.href = location.href; 
}

function newShowApplicantCount(){
	$.ajaxCall({
		url: "/manager/lms/manage/offline/lmsOfflineMgDetailAjax.do"
		, data : {courseid: "${detail.courseid}"}
		, success: function(data, textStatus, jqXHR){
			$("#requestcount").text(data.requestcount);
			$("#finishcount").text(data.finishcount);
		},
		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
		}
	});
} 

</script>
</head>

<body class="bgw">
<input type="hidden" id="courseid" value="${detail.courseid }">
<input type="hidden" id="penaltyFlag" value="${detail.penaltyflag }">

<!-- 권한 변수 -->
<input type="hidden" id="managerMenuAuth" value="${managerMenuAuth}">

<div class="contents_title clear">
		<h2 class="fl">오프라인 과정 운영 상세</h2>
	</div>
	
	<!--search table // -->

	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="10%"  />
				<col width="10%" />
				<col width="25%" />
				<col width="10%" />
				<col width="15%"  />
				<col width="10%" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th>오프라인테마명</th>
				<td colspan="3" style="line-height:1.2em;">	${detail.themename }	</td>
				<th>과정명</th>
				<td colspan="3" style="line-height:1.2em;">	${detail.coursename }	</td>
			</tr>
			<tr>
				<th>교육장소</th>
				<td style="line-height:1.2em;"> ${detail.apname }</td>
				<th>교육기간</th>
				<td style="line-height:1.2em;">	${detail.edudate }	</td>
				<th>신청자수</th>
				<td id="requestcount" style="line-height:1.2em;">	${detail.requestcount }</td>
				<th>수료자수</th>
				<td id="finishcount" style="line-height:1.2em;"> ${detail.finishcount }</td>
			</tr>
			<tr>
				<th>부사업자허용</th>
				<td style="line-height:1.2em;"> <c:choose><c:when test="${detail.togetherflag eq 'Y'}">허용</c:when><c:otherwise>불허</c:otherwise></c:choose></td>
				<th>현장접수 허용</th>
				<td style="line-height:1.2em;"> <c:choose><c:when test="${detail.placeflag eq 'Y'}">허용</c:when><c:otherwise>불허</c:otherwise></c:choose></td>
				<th>패널티 적용</th>
				<td style="line-height:1.2em;"> <c:choose><c:when test="${detail.penaltyflag eq 'Y'}">적용</c:when><c:otherwise>비적용</c:otherwise></c:choose></td>
				<th>AmwayGO 적용</th>
				<td style="line-height:1.2em;"> <c:choose><c:when test="${detail.groupflag eq 'Y'}">적용</c:when><c:otherwise>비적용</c:otherwise></c:choose></td>
			</tr>
		</table>
	</div>
	
	<div id="divLmsOfflineMgDetailTab"></div>
	
	<div id="tabLayer">
		<div id="divTabPage1" class="tabView">
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
						
						<a href="javascript:;" id="deleteButton" class="btn_green">신청취소</a>
						
						<span> Total : <span id="totalcount"></span>건</span>
					</div>
					
					<div class="fr">
						<div style="float:right;">
							<a href="javascript:;" id="getGridDetailView" class="btn_green">팝업보기</a>
							<a href="javascript:;" id="insertButton"  class="btn_green">교육신청자추가</a>
						</div>
					</div>
				</div>
				
				
				<!-- axisGrid -->
				<div id="AXGrid">
					<div id="AXGridTarget_Applicant"></div>
				</div>
		</div>
	</div>
	
</div>
</body>