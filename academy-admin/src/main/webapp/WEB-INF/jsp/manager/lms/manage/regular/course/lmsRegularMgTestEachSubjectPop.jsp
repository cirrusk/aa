<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var courseGrid = new AXGrid(); // instance 상단그리드
var num = 0;

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.regular.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

     
 var uidArr=[];   
     
	
$(document.body).ready(function(){
	
	courseStudentList.init();
	courseStudentList.doSearch({page:1});
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		courseStudentList.doSearch({page:1});
	});
	
	
	$("#rowPerPage").on("change", function(){
		courseStudentList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	
});

//회원별 주관식 답변 보기
function goAnswer(stepCourseId,uId,studyflag)
{	
	if(studyflag == 'Y')
		{
			var data = {
					courseid : "${param.courseid}"
					,stepcourseid : stepCourseId
					,uid : uId
					,uidlist : uidArr
					,coursename : "${coursename}"
					,stepseq : $("#stepseq").val()
			}
			var popParam = {
					url : "/manager/lms/manage/regular/course/lmsRegularMgDetailTestSubjectAnswerPop.do"
					, width : 1024
					, height : 900
					, maxHeight : 900
					, params : data
					, targetId : "testSubjectAnswerPop"
			}
			window.parent.openManageLayerPopup(popParam);
		}
	else
		{
			alert("해당 신청자는 시험을 치지 않았습니다.");
		}
	
}

/* courseOnline List Grid */
var courseStudentList = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								{key:"no", label:"No.", width:"50", align:"center", sort:false}
								, {key:"uid", label:"ABO 번호", width:"200", align:"center", sort:false}
								, {key:"name", label:"이름", width:"150", align:"center", sort:false}
								, {key:"pincode", label:"핀레벨", width:"100", align:"center", sort:false}
								, {key:"studydate",  label:"응시일시", width:"250", align:"center", sort:false}
								, {key:"studyflag", display:false}
								, {key:"subjectpoint",  label:"주관식점수", width:"100", align:"center", sort:false}
								, {		
									key: "marking", label : "채점", width: "150", align: "center", sort: false, formatter: function () {
										return "<a href=\"javascript:;\" class=\"btn_green\"  onclick=\"javascript:goAnswer('${param.stepcourseid }', '" + this.item.uid + "','"+this.item.studyflag+"');\">채점</a>";
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
			// Param 셋팅(검색조건)
			 var initParam = {
					searchpinlevel : $("#searchpinlevel").val()	
				  , searchmemberinfo : $("#searchmemberinfo").val()
				  , stepcourseid : "${param.stepcourseid }"
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgTestEachSubjectPopAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		alert("success"+data);
		        		return;
					} else {
						var count = 0;
						$.each(data.studentList,function(idx,val){
							
							if(val.studyflag == "Y")
								{	
									uidArr[count] = val.uid;
									count++;
								}
							 
						});
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
		   		num=obj.totalCount+1;
		   		courseGrid.setData(gridData);
		   		
		   	}
			
		}
	}


function reflashBottom(){
	$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.courseStudentList.doSearch();
	try{
		$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.readPassManNum();
	}catch(e){}
}
	
</script>
</head>

<body class="bgw">
<input type="hidden" id="stepseq" name="stepseq" value="${param.stepseq }"/>
<div id="popwrap">
<!--pop_title //-->
<div class="title clear">
	<h2 class="fl">주관식 개별 채점</h2>
	<span class="fr"><a href="javascript:;" class="btn_close close-layer" onclick="reflashBottom();">X</a></span>
</div>

	<!-- Contents -->
	<div id="popcontainer"  style="height:430px">
		<div id="popcontent">
	
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="15%" />
						<col width="15%"  />
						<col width="15%" />
						<col width="40%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th>시험명</th>
						<td colspan="4"> ${coursename }</td>
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
					<div id="AXGridTarget_Course"></div>
				</div>
		</div>
		
		<div class="contents_title clear">
					<div align="center">
						<a href="javascript:;" id="closeBtn" class="btn_green close-layer" onclick="reflashBottom();"> 닫기</a>
					</div>
				</div>
	</div>
</div>
</div>

</body>