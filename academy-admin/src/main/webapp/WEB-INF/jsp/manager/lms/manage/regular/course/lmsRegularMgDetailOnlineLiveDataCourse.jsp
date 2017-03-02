<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var courseGrid = new AXGrid(); // instance 상단그리드

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.regular.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

     
     
     
	
$(document.body).ready(function(){
	courseStudentList.init();
	courseStudentList.doSearch({page:1});
	// 검색버튼 클릭
	
	$("#btnSearchO").on("click", function(){
		courseStudentList.doSearch({page:1});
	});
	
	$("#rowPerPage").on("change", function(){
		courseStudentList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	//저장버튼 클릭시
	$("#finishUpdateBtn").on("click",function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
		
		var beforefinishflags = [];
		var uids = [];
		var finishflags = [];
		for(var i = 0; i < courseGrid.list.length; i++){
			beforefinishflags[i] = courseGrid.list[i].beforefinishflag;
			uids[i] = courseGrid.list[i].uid;
			finishflags[i] = courseGrid.list[i].finishflag;
		}
		var param = {
				courseid : $("#courseid").val()
				, stepcourseid : $("#stepcourseid").val()
				, coursetype : $("#courseType").val()
				, stepseq : $("#stepseq").val()
				, uids : uids
				, finishflags : finishflags
				, beforeFinishflags : beforefinishflags
		}
		
		if( !confirm("수료 정보를 저장하시겠습니까?") ) {
			return;
		}
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgOnlineLiveDataFinishUpdateAjax.do"/>"
	   		, data: param
	   		, success: function( data, textStatus, jqXHR){
	   			courseStudentList.doSearch({page:1});
	        		alert("저장완료하였습니다.");
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	           	alert("error"+textStatus);
	   		}
	   	});
	});
	
});

function changeFinishFlag(val, index){
	courseGrid.list[index].finishflag = val;
}

/* courseOnline List Grid */
var courseStudentList = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								{key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
								, {key:"uid", label:"ABO 번호", width:"200", align:"center"}
								, {key:"name", label:"이름", width:"150", align:"center"}
								, {key:"pincode", addclass:idx++, label:"핀레벨", width:"100", align:"center"}
								, {key:"finishdate",  label:"수료일시", width:"200", align:"center"}
								, {key:"beforefinishflag", label:"원래플래그", width:"100", align:"center", display:false}
								, {		
									key: "finishflag", label : "수료여부", width: "250", align: "center", sort: false, formatter: function () {
										
										var data = this.item.finishflag;
										var selectTag = "";
										selectTag += "<select id='finishflag_"+this.item.no.number()+"' name='finishflags' onchange='changeFinishFlag(this.value, "+this.index+")'>";
										
										if(data == 'Y')
											{	
												selectTag += "<option value='N'>미수료</option>                           ";
												selectTag += "<option value='Y' selected='selected'>수료</option>                             ";
											}
										else
											{
												selectTag += "<option value='N' selected='selected'>미수료</option>                           ";
												selectTag += "<option value='Y'>수료</option>                             ";
											}
												selectTag += "</select>  ";
												selectTag += "<input type='hidden' name='uids' value='"+this.item.uid+"'/>";
												return selectTag+"<input type='hidden' name='beforeFinishflags' value='"+data+"'/>" ;
									}
								}
							]
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: false
 					//, fixedColSeq: 3
					, colHead : { heights: [25,25]}
					, targetID : "AXGridTarget_Course"
					, sortFunc : courseStudentList.doSortSearch
					, doPageSearch : courseStudentList.doPageSearch
				}

			fnGrid.initGrid(courseGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			courseStudentList.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(courseGrid.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			courseStudentList.doSearch(sortParam);
		}, doSearch : function(param) {
			// 신청자수,수료자수 변경 다시 읽기
			studentNumRefreshStep();
			// Param 셋팅(검색조건)
			 var initParam = {
					searchpinlevel : $("#searchpinlevel").val()	
				  , searchmemberinfo : $("#searchmemberinfo").val()
				  , stepcourseid : $("#stepcourseid").val()
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgOnlineLiveDataListAjax.do"/>"
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
					list: obj.studentList
					, page:{
						pageNo: obj.page,
						pageSize: defaultParam.rowPerPage,
						pageCount: obj.totalPage,
						listCount: obj.totalCount
					}
				};			   		
		   		$("#totalcount").text(obj.totalCount);
		   		// Grid Bind Real
		   		courseGrid.setData(gridData);
		   		
		   	}
			
		}
	}

	
</script>
</head>

<body class="bgw">
<input type="hidden" id="courseType" name="coursetype" value="${coursetype }">

<div id="addTag" style="display:none;">
	<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th>과정유형</th>
				<td>
					<c:choose>
						<c:when test="${ coursetype eq 'O'}">
							온라인
						</c:when>
						<c:when test="${ coursetype eq 'L'}">
							라이브
						</c:when>
						<c:when test="${ coursetype eq 'D'}">
							교육자료
						</c:when>
					</c:choose>
				</td>
				<th>교육기간</th>
				<td>${courseData.edudate}</td>
				<th>신청자</th>
				<td id="requestcountNumStep">${courseData.requestcount }</td>
				<th>수료자</th>
				<td id="finishcountNumStep">${courseData.finishcount}</td>
			</tr>
		</table>
</div>
	
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
								<a href="javascript:;" id="btnSearchO" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
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
					
					<div class="fr">
						<a href="javascript:;" id="finishUpdateBtn" class="btn_green">수료여부 저장</a>
					</div>
				</div>
				
				
		</div>
				<!-- axisGrid -->
				<div id="AXGrid">
				<form id="frm"  method="post" enctype="multipart/form-data">
					<input type="hidden" id="stepcourseid" name="stepcourseid" value="${param.stepcourseid }"/>
					<input type="hidden" id="stepseq" name="stepseq" value="${stepseq }"/>
					<div id="AXGridTarget_Course"></div>
				</form>
				</div>
</body>