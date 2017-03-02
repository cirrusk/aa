<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	

var reportPopGrid = new AXGrid(); // instance 상단그리드

//Grid Default Param
var defaultParam = {
		  page: 1
	 	, rowPerPage: 20
	 	, sortColKey: "lms.online.list"
	 	, sortIndex: 0
	 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
	
	reportPopList.init();
	reportPopList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		reportPopList.doSearch();
	});
	
	$("#rowPerPage").on("change", function(){
		reportPopList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
});


			/* Stamp 회원탭 구성 */
			var reportPopList = {
					/** init : 초기 화면 구성 (Grid)
					*/		
					init : function() {
						var idx = 0; // 정렬 Index 
						var _colGroup = [
											 {key:"no", label:"NO", width:"50", align:"center", formatter:"money", sort:false}
											, {key:"uid", label:"ABO 번호", width:"200", align:"center"}
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
											, {key:"pincode", label:"핀레벨", width:"200", align:"center"}
											, {
												key:"finishdate", label:"수료일시", width:"150", align:"center",formatter:function(){
												
													if(this.item.finishflag == "수료")
														{
															return this.item.finishdate;
														}
													else
														{
															return "";
														}
												}
											}
											, {key:"finishflag", label:"수료여부", width:"150", align:"center"}
										]
						var gridParam = {
								colGroup : _colGroup
								, fitToWidth: false
			 					//, fixedColSeq: 3
								, colHead : { heights: [25,25]}
								, targetID : "AXGridTarget"
								, sortFunc : reportPopList.doSortSearch
								, doPageSearch : reportPopList.doPageSearch
							}

						fnGrid.initGrid(reportPopGrid, gridParam);
					}, doPageSearch : function(pageNo) {
						// Grid Page List
						reportPopList.doSearch({page:pageNo});
					}, doSortSearch : function(){
						var sortParam = getParamObject(reportPopGrid.getSortParam()+"&page=1");
						defaultParam.sortOrder = sortParam.sortWay; 
						// 리스트 갱신(검색)
						reportPopList.doSearch(sortParam);
					}, doSearch : function(param) {
						
						// Param 셋팅(검색조건)
						 var initParam = {
								searchtype : $("#searchtype").val()
								, searchtext : $("#searchtext").val()
								, courseid : $("#courseid").val()
								, searchpinlevel : $("#searchpinlevel").val()
						}; 
						
						 $.extend(defaultParam, param);
							$.extend(defaultParam, initParam);
							$.ajaxCall({
								url: "<c:url value="/manager/lms/statistics/lmsReportPopListAjax.do"/>"
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
						   		reportPopGrid.setData(gridData);
					   		 
					   	}
			}
}

</script>
</head>

<body class="bgw">
<input type="hidden" id="courseid" value="${param.courseid }">
<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
	<c:if test="${param.coursetype eq 'O' }">
		<h2 class="fl">온라인 과정 수료자 조회</h2>
	</c:if>
		<c:if test="${param.coursetype eq 'F' }">
		<h2 class="fl">오프라인 과정 수료자 조회</h2>
	</c:if>
		<c:if test="${param.coursetype eq 'L' }">
		<h2 class="fl">라이브 과정 수료자 조회</h2>
	</c:if>
		<c:if test="${param.coursetype eq 'R' }">
		<h2 class="fl">정규 과정 수료자 조회</h2>
	</c:if>
		<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
	</div>
	
	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
		
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="15%" />
							<col width="25%"  />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
						</colgroup>
						<tr>
						<c:choose>
							<c:when test="${param.coursetype eq 'O' }">
								<th>과정명</th>
								<td colspan="5">${data.coursename }</td>
							</c:when>
							<c:otherwise>
								<th>과정명</th>
								<td>${data.coursename }</td>
								<th>테마명</th>
								<td colspan="3">${data.themename }</td>
							</c:otherwise>
						</c:choose>
						</tr>
						<tr>
							<th>교육기간</th>
							<td>${data.edudate }</td>
							<th>신청자</th>
							<td>${data.requestcount }</td>
							<th>수료자</th>
							<td>${data.finishcount }</td>
						</tr>
					</table>
				</div>
					
				<br/>
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
											<option value="${pincodelist.targetcodeseq }"> ${pincodelist.targetcodename } </option>
										</c:forEach>
									</select>
								</td>
								<th>조회</th>
								<td>
									<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
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
							</div>
						</div>
						<div id="AXGrid">
							<div id="AXGridTarget"></div>
						</div>
						
				<div class="contents_title clear">
					<div class="fr">
						<a href="javascript:;" id="closeBtn" class="btn_green close-layer"> 닫기</a>
					</div>
				</div>
		</div>
	</div>
</div>
`
</body>