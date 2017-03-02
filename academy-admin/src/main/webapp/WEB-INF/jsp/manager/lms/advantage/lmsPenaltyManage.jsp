<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//권한 변수
var managerMenuAuth ="${managerMenuAuth}";

var penaltyGrid = new AXGrid(); // instance 상단그리드

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.stamp.list"
 	, sortIndex: 3
 	, sortOrder:"ASC"
};

$(document.body).ready(function(){
	
	penaltyList.init();
	penaltyList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		var searchstartdate = $("#searchstartdate").val();
		var searchenddate = $("#searchenddate").val();
		if(searchstartdate != "" && searchenddate != ""){
			if( searchenddate < searchstartdate ){
				alert("페널티 종료일 조건의 종료이이 시작일 보다 크거나 같아야 합니다.");
				return;
			}
		}
		penaltyList.doSearch();
	});
	
	$("#rowPerPage").on("change", function(){
		penaltyList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
		
});

			/* Stamp 회원탭 구성 */
			var penaltyList = {
					/** init : 초기 화면 구성 (Grid)
					*/		
					init : function() {
						var idx = 0; // 정렬 Index 
						var _colGroup = [
											 {key:"no", label:"No", width:"50", align:"center", formatter:"money", sort:false}
											, {key:"uid", label:"ABO번호", width:"150", align:"center"	}
											, {
												key:"name", label:"성명", width:"150", align:"center", formatter:function()
												{
													if(this.item.partnerinfoname != null && this.item.partnerinfoname !="")
														{
															return this.item.name+"&"+this.item.partnerinfoname;
														}
													else
														{
															return this.item.name;
														}
												}
											}
											, {
												key:"coursename", label:"페널티 사유", width:"300", align:"center", formatter:function()
												{
													return this.item.coursename+" 불참";
												}
											}
											, {key:"cleardate", label:"페널티 해제일", width:"150", align:"center"	}
											, {key:"penaltypast", label:"페널티 종료 여부", width:"150", align:"center", display:false	}
											, {
												key:"clearnote", label:"해제사유", width:"250", align:"center",formatter:function(){
													if( (this.item.clearnote != null && this.item.clearnote != "") || this.item.penaltypast == "Y")
														{
															return this.item.clearnote;
														}
													else
														{
															return "<input type='text' id='"+this.item.courseid+"_"+this.item.uid+"_clearnote' name='clearnote'/>";
														}
												}
											}
											, {
												key:"clear", label:"해제", width:"80", align:"center",formatter:function(){
													if( (this.item.clearnote != null && this.item.clearnote != "") || this.item.penaltypast == "Y")
													{
														return "O";
													}
													else
													{
														return "<input type='button' value='해제' onclick=\"clearPenalty('"+this.item.courseid+"','"+this.item.uid+"')\"/>";
													}
												}	
											}
										]
						var gridParam = {
								colGroup : _colGroup
								, fitToWidth: false
			 					//, fixedColSeq: 3
								, colHead : { heights: [25,25]}
								, targetID : "AXGridTarget"
								, sortFunc : penaltyList.doSortSearch
								, doPageSearch : penaltyList.doPageSearch
							}

						fnGrid.initGrid(penaltyGrid, gridParam);
					}, doPageSearch : function(pageNo) {
						// Grid Page List
						penaltyList.doSearch({page:pageNo});
					}, doSortSearch : function(){
						var sortParam = getParamObject(penaltyGrid.getSortParam()+"&page=1");
						defaultParam.sortOrder = sortParam.sortWay; 
						// 리스트 갱신(검색)
						penaltyList.doSearch(sortParam);
					}, doSearch : function(param) {
						
						// Param 셋팅(검색조건)
						 var initParam = {
								searchstartdate : $("#searchstartdate").val()	
							  , searchenddate : $("#searchenddate").val()
							  , searchpenaltystatus : $("#searchpenaltystatus").val()
							  , searchtype : $("#searchtype").val()
							  , searchtext : $("#searchtext").val()
						}; 
						
						 $.extend(defaultParam, param);
							$.extend(defaultParam, initParam);
							$.ajaxCall({
						   		url: "<c:url value="/manager/lms/advantage/lmsPenaltyManageListAjax.do"/>"
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
						   		penaltyGrid.setData(gridData);
					   		 
					   	}
			}
}
			
			
function clearPenalty(courseId,uId)
			{
				//권한 체크 함수
				if(checkManagerAuth(managerMenuAuth)){return;}
				
				var param ={courseid : courseId, uid : uId, clearnote : $("#"+courseId+"_"+uId+"_clearnote").val()};
				
				
				$.ajaxCall({
			   		url: "<c:url value="/manager/lms/advantage/lmsPenaltyClearAjax.do"/>"
			   		, data: param
			   		, success: function( data, textStatus, jqXHR){
			   			penaltyList.doSearch();
			   		},
			   		error: function( jqXHR, textStatus, errorThrown) {
			           	alert("<spring:message code="errors.load"/>");
			           	alert("error"+textStatus);
			   		}
			   	});
			}

</script>
</head>
<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">페널티 관리</h2>
	</div>
	
	<!--search table // -->
		<div class="tbl_write">
			<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="15%" />
					<col width="25%"  />
					<col width="20%" />
					<col width="30%" />
					<col width="10%" />
				</colgroup>
				<tr>
					<th>페널티 종료일</th>
					<td>
						<input type="text" id="searchstartdate" name="searchstartdate" class="AXInput datepDay" > ~ 
						<input type="text" id="searchenddate" name="searchenddate" class="AXInput datepDay" >
					</td>
					<th id="thName">페널티 상태</th>
					<td>
						<select id="searchpenaltystatus">
							<option value="">선택</option>
							<option value="Y">페널티</option>
							<option value="N">해제</option>
						</select>
					</td>
					
					<th rowspan="2">
						<div class="btnwrap mb10">
							<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
						</div>
					</th>
				</tr>
				<tr>
					<th>조회</th>
					<td colspan="3">
						<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
							<option value="">전체</option>
							<option value="1">ABO번호</option>
							<option value="2">이름</option>
							<option value="3">불참사유</option>
						</select>
						<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
					</td>
				</tr>
			</table>
		</div>
	
			<!-- axisGrid -->
		<br/>
			<div class="contents_title clear">
				<div class="fl">
					<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
						<option value="20" >20</option>
						<option value="50">50</option>
						<option value="500">500</option>
						<option value="1000">1000</option>
					</select>
					
					<span> Total : <span id="totalcount"></span>건</span>
				</div>
			</div>
			<div id="AXGrid">
				<div id="AXGridTarget"></div>
			</div>
</body>
</html>