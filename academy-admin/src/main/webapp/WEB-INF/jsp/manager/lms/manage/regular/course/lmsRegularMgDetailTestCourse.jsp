<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var courseGrid = new AXGrid(); // instance 상단그리드
var testType = "${courseData.testtype}";

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
	
	
var subjectPoint = "${courseData.subjectpoint }";	
	
	courseStudentList.init();
	courseStudentList.doSearch({page:1});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		courseStudentList.doSearch({page:1});
	});
	
	$("#rowPerPage").on("change", function(){
		courseStudentList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	//저장버튼 클릭시
	$("#finishUpdateBtn").on("click",function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		var uids = [];
		var finishflags = [];
		var beforefinishflags = [];
		var studyflags = [];
		var subjectpoints = [];
		var beforesubjectpoints = [];
		var objectpoints = [];
		var beforeobjectpoints = [];
		for(var i = 0; i < courseGrid.list.length; i++){
			uids[i] = courseGrid.list[i].uid;
			finishflags[i] = courseGrid.list[i].finishflag;
			beforefinishflags[i] = courseGrid.list[i].beforefinishflag;
			studyflags[i] = courseGrid.list[i].studyflag;
			subjectpoints[i] = courseGrid.list[i].subjectpoint;
			beforesubjectpoints[i] = courseGrid.list[i].beforesubjectpoint;
			objectpoints[i] = courseGrid.list[i].objectpoint;
			beforeobjectpoints[i] = courseGrid.list[i].beforeobjectpoint;
		}
		var param = {
				courseid : $("#courseid").val()
				, stepcourseid : $("#stepcourseid").val()
				, coursetype : $("#courseType").val()
				, stepseq : $("#stepseq").val()
				, uids : uids
				, finishflags : finishflags
				, beforefinishflags : beforefinishflags
				, studyflags : studyflags
				, subjectpoints : subjectpoints
				, beforesubjectpoints : beforesubjectpoints
				, objectpoints : objectpoints
				, beforeobjectpoints : beforeobjectpoints
		}
		
		if( !confirm("수료 정보를 저장하시겠습니까?") ) {
			return;
		}
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgTestFinishUpdateAjax.do"/>"
	   		, data: param
	   		, success: function( data, textStatus, jqXHR){
	   				courseStudentList.doSearch({page:1});
	   				$("#finishcountNum").text(data.finishcount);
	        		alert("저장완료하였습니다.");
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	           	alert("error"+textStatus);
	   		}
	   	});
	});
	
	//주관식 점수 엑셀 등록 버튼 클릭
	$("#insertSubjectPointBtn").on("click",function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
			var popParam = {
					url : "/manager/lms/manage/regular/course/lmsRegularMgDetailTestSubjectExcelPop.do"
					, width : 1024
					, height : 600
					, maxHeight : 600
					, params : {
						stepcourseid : $("#stepcourseid").val() 
						, subjectpoint : subjectPoint
						, testtype : testType
						, stepseq : $("#stepseq").val()
						, courseid : $("#courseid").val()
					}
					, targetId : "subjectExcelPop"
			}
			window.parent.openManageLayerPopup(popParam);
		
	});
	
	//객관식 재채점 클릭
	$("#objectRemarkingBtn").on("click",function(){
		
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
		if(testType == 'O')
		{
			if( !confirm("객관식 점수를 재채점하시겠습니까?") ) {
				return;
			}
			var param = $("#frm").serialize();
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgTestObjectRemarking.do"/>"
		   		, data: param
		   		, success: function( data, textStatus, jqXHR){
		   				courseStudentList.doSearch({page:1});
		   				$("#finishcountNum").text(data.finishcount);
		        		alert(" 객관식 점수를 재채점하였습니다.");
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
		           	alert("error"+textStatus);
		   		}
		   	});
		}
		else
			{
				alert("해당과정은 오프라인 시험이기에 객관식 답안이 없습니다.");
			}
	});
	
	
	//주관식 개별채점 클릭
	$("#subjectMarkingBtn").on("click",function(){
		
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
		if(testType == 'O')
			{
				var popParam = {
						url : "/manager/lms/manage/regular/course/lmsRegularMgTestEachSubjectPop.do"
						, width : 1024
						, height : 900
						, maxHeight : 900
						, params : {stepcourseid : $("#stepcourseid").val(), stepseq : $("#stepseq").val(), courseid : $("#courseid").val() }
						, targetId : "eachSubjectPop"
				}
				window.parent.openManageLayerPopup(popParam);
				
			}
		else
			{
				alert("해당과정은 오프라인 시험이기에 주관식 답안이 없습니다.");
			}
		});
	
	
});

//회원별 시험 보기
function goAnswer(stepCourseId,uId,studyflag)
{	
	if(studyflag == 'Y')
		{
			var data = {
					stepcourseid : stepCourseId
					,uid : uId
					,uidlist : uidArr
			}
			var popParam = {
					url : "/manager/lms/manage/regular/course/lmsRegularMgDetailTestAnswerPop.do"
					, width : 1024
					, height : 900
					, maxHeight : 900
					, params : data
					, targetId : "testAnswerPop"
			}
			window.parent.openManageLayerPopup(popParam);
		}
	else
		{
			alert("해당 신청자는 시험을 치지 않았습니다.");
		}
	
}

function changeFinishFlag(val, index){
	courseGrid.list[index].finishflag = val;
}
function changeSubjectPoint(val, index, obj){
	if(!isNumber(val)){
		alert("주관식 점수를 숫자로 입력해 주세요.");
		obj.value = courseGrid.list[index].subjectpoint;
		return;
	}
	courseGrid.list[index].subjectpoint = val;
}
function changeObjectPoint(val, index, obj){
	if(!isNumber(val)){
		alert("객관식 점수를 숫자로 입력해 주세요.");
		obj.value = courseGrid.list[index].objectpoint;
		return;
	}
	courseGrid.list[index].objectpoint = val;
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
								, {
									key:"name", label:"이름", width:"150", align:"center", formatter:function(){
										
										if(testType == 'O')
											{
												return "<a href=\"javascript:;\"  onclick=\"javascript:goAnswer('${courseData.courseid }', '" + this.item.uid + "','"+this.item.studyflag+"');\">"+this.item.name+"</a>";
											}
										else
											{
												return "<span>"+this.item.name+"</span>";
											}
									}
								}
								, {key:"pincode", addclass:idx++, label:"핀레벨", width:"100", align:"center"}
								, {key:"studydate",  label:"응시일시", width:"250", align:"center"}
								, {key:"studyflag", display:false}
								, {
									key:"subjectpoint",  label:"주관식점수", width:"100", align:"center", formatter:function(){
										if(testType == 'O' && "${courseData.subjectpoint }" == 0)
											{
												return "<input type='text' name='subjectpoints' value='"+this.item.subjectpoint+"' readonly='readonly' onblur='changeSubjectPoint(this.value, "+this.index+", this)'/> <input type='hidden' name='beforesubjectpoints' value='"+this.item.subjectpoint+"'/>";
											}
										else
											{
												return "<input type='text' name='subjectpoints' value='"+this.item.subjectpoint+"' onblur='changeSubjectPoint(this.value, "+this.index+", this)'/><input type='hidden' name='beforesubjectpoints' value='"+this.item.subjectpoint+"'/>";
											}
									}
								}
								, {
									key:"objectpoint",  label:"객관식점수", width:"100", align:"center", formatter:function(){
											if(testType == 'O' && "${courseData.objectpoint }" == 0)
												{
													return "<input type='text' name='subjectpoints' value='"+this.item.objectpoint+"' readonly='readonly' onblur='changeObjectPoint(this.value, "+this.index+", this)'/><input type='hidden' name='beforeobjectpoints' value='"+this.item.objectpoint+"'/>";
												}
											else
												{
													return "<input type='text' name='objectpoints' value='"+this.item.objectpoint+"' onblur='changeObjectPoint(this.value, "+this.index+", this)'/><input type='hidden' name='beforeobjectpoints' value='"+this.item.objectpoint+"'/>";
												}
									}
								}
								, {
									key:"totalpoint",  label:"총점", width:"100", align:"center", formatter:function(){
										
										var objectpoint = Number(this.item.objectpoint);
										var subjectpoint = Number(this.item.subjectpoint);
										var totalpoint = (objectpoint+subjectpoint);
										
										return totalpoint;
									}
								}
								, {		
									key: "finishflag", label : "수료여부", width: "250", align: "center", sort: false, formatter: function () {
										var selectTag = "";
										selectTag += "<select id='finishflag_"+this.item.no.number()+"' name='finishflags' onchange='changeFinishFlag(this.value, "+this.index+")'>";

										if(this.item.finishflag == 'Y')
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
										
										return selectTag + "<input type='hidden' name='uids' value='"+this.item.uid+"'/><input type='hidden' name='studyflags' value='"+this.item.studyflag+"'/><input type='hidden' name='beforefinishflags' value='"+this.item.finishflag+"'/>";
									}
								}
								, {key:"beforefinishflag", label:"이전완료여부", width:"150", align:"center", display:false}
								, {key:"studyflag", label:"시험완료여부", width:"150", align:"center", display:false}
								, {key:"beforesubjectpoint", label:"이전주관식점수", width:"150", align:"center", display:false}
								, {key:"beforeobjectpoint", label:"이전객관식점수", width:"150", align:"center", display:false}
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
		   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgTestListAjax.do"/>"
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
		   		courseGrid.setData(gridData);
		   		
		   	}
			
		}
	}


function readPassManNum(){
	var param = $("#frm").serialize();
	$.ajaxCall({
   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgTestReadPassManNum.do"/>"
   		, data: param
   		, success: function( data, textStatus, jqXHR){
   			$("#finishcountNum").text(data.finishcount);
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
   		}
   	});	
}

function reSearch(){
	courseStudentList.doSearch({page:1});
}
</script>
</head>

<body class="bgw">
<input type="hidden" id="testType" value="${courseData.testtype }">
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
				<td>시험</td>
				<th>객관식점수</th>
				<td>${courseData.objectpoint }</td>
				<th>주관식점수</th>
				<td>${courseData.subjectpoint }</td>
				<th>기준점수</th>
				<td>${courseData.passpoint }</td>
				
			</tr>
			<tr>
				<th>시험기간</th>
				<td colspan="3">${courseData.edudate}</td>
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
					
					<div class="fr">
						<a href="javascript:;" id="subjectMarkingBtn" class="btn_green">주관식 개별 채점</a>
						<a href="javascript:;" id="insertSubjectPointBtn" class="btn_green">주관식 점수 엑셀등록</a>
						<a href="javascript:;" id="objectRemarkingBtn" class="btn_green">객관식 재채점</a>
						<a href="javascript:;" id="finishUpdateBtn" class="btn_green">수료여부 저장</a>
					</div>
				</div>
				
				
		</div>
				<!-- axisGrid -->
				<div id="AXGrid">
				<form id="frm"  method="post" enctype="multipart/form-data">
					<input type="hidden" id="stepcourseid" name="stepcourseid" value="${courseData.courseid }"/>
					<input type="hidden" id="courseid" name="courseid" value="${param.courseid }"/>
					<input type="hidden" name="stepseq"  id="stepseq" value="${stepseq }"/>
					<div id="AXGridTarget_Course"></div>
				</form>
				</div>
</body>