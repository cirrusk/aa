<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var eduApplicantGrid = new AXGrid(); // instance 상단그리드


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
	
	
	eduApplicantList.init();
	eduApplicantList.doSearch({page:1});
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		eduApplicantList.doSearch({page:1});
	});
	

	
	$("#rowPerPage").on("change", function(){
		eduApplicantList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
});



/* 교육신청자 List Grid */
var eduApplicantList = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								 {key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
								, {key:"uid", label:"ABO 번호", width:"150", align:"center"}
								, {key:"name", label:"이름", width:"150", align:"center", formatter:function(){
										return "<a href=\"javascript:;\"  onclick=\"javascript:goSurvey('${param.stepcourseid }', '" + this.item.name + "', '" + this.item.uid + "','"+this.item.finishflag+"');\">"+this.item.name+"</a>";
									}
								}
								, {key:"pincode", addclass:idx++, label:"핀레벨", width:"100", align:"center"}
								, {key:"finishdate",  label:"제출일시", width:"200", align:"center"}
								, {
									key:"finishflag",  label:"제출여부", width:"150", align:"center", formatter:function(){
										if(this.item.finishflag == "Y")
											{
												return "제출";
											}
										else
											{
												return "미제출";
											}
									}
								}
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
				  , stepcourseid : "${param.stepcourseid}"
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyCourseListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		alert("success"+data);
		        		return;
					} else {
						var count = 0;
						$.each(data.studentList,function(idx,val){
							
							if(val.finishflag == "Y")
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
		   		eduApplicantGrid.setData(gridData);
		   		
		   	}
			
		}
	}

//회원별 시험 보기
function goSurvey(stepCourseId,Name,uId,finishflag)
{	
	if(finishflag == 'Y')
		{
			var data = {
					stepcourseid : stepCourseId
					,name : Name
					,uid : uId
					,uidlist : uidArr
			}
			var popParam = {
					url : "/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyResponsePop.do"
					, width : 1024
					, height : 900
					, maxHeight : 900
					, params : data
					, targetId : "surveyResponsePop"
			}
			window.parent.openManageLayerPopup(popParam);
		}
	else
		{
			alert("해당 신청자는 설문을 제출 하지 않았습니다.");
		}
	
}


	
</script>
</head>

<body class="bgw">
	
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
		</div>
		
				<!-- axisGrid -->
				<div id="AXGrid">
					<div id="AXGridTarget_Applicant"></div>
				</div>
</body>