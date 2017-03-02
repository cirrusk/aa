<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">

var listGrid = "";

listGrid += '<div class="tbl_write">                                                                               ';
listGrid += '<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">                        ';
listGrid += '	<colgroup>                                                                                         ';
listGrid += '		<col width="15%" />                                                                            ';
listGrid += '		<col width="20%"  />                                                                           ';
listGrid += '		<col width="10%" />                                                                            ';
listGrid += '		<col width="45%" />                                                                            ';
listGrid += '		<col width="10%" />                                                                            ';
listGrid += '	</colgroup>                                                                                        ';
listGrid += '	<tr>                                                                                               ';
listGrid += '		<th>핀레벨</th>                                                                                ';
listGrid += '		<td>                                                                                           ';
listGrid += '			<select id="searchpinlevel" name="searchpinlevel">                                         ';
listGrid += '				<option value="">선택</option>                                                         ';
listGrid += '			</select>                                                                                  ';
listGrid += '		</td>                                                                                          ';
listGrid += '		<th>조회</th>                                                                                  ';
listGrid += '		<td>                                                                                           ';
listGrid += '			<select id="searchmemberinfo" name="searchmemberinfo" style="width:auto; min-width:100px" >';
listGrid += '				<option value="">전체</option>                                                         ';
listGrid += '				<option value="1">ABO번호</option>                                                     ';
listGrid += '				<option value="2">이름</option>                                                        ';
listGrid += '			</select>                                                                                  ';
listGrid += '			<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" > ';
listGrid += '		</td>                                                                                          ';
listGrid += '		<td>                                                                                           ';
listGrid += '			<div class="btnwrap mb10">                                                                 ';
listGrid += '				<a href="javascript:;" id="stepBtnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>            ';
listGrid += '			</div>                                                                                     ';
listGrid += '		</td>                                                                                          ';
listGrid += '	</tr>                                                                                              ';
listGrid += '</table>                                                                                              ';
listGrid += '<br/>                                                                                                 ';
listGrid += '<div class="contents_title clear">                                                                    ';
listGrid += '	<div class="fl">                                                                                   ';
listGrid += '		<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px">                 ';
listGrid += '			<option value="20">20</option>                                                             ';
listGrid += '			<option value="50">50</option>                                                             ';
listGrid += '			<option value="500">500</option>                                                           ';
listGrid += '			<option value="1000">1000</option>                                                         ';
listGrid += '		</select>                                                                                      ';
listGrid += '		                                                                                               ';
listGrid += '		<span> Total : <span id="totalcount"></span>건</span>                                          ';
listGrid += '	</div>                                                                                             ';
listGrid += '</div>                                                                                                ';
listGrid += '</div>';





//Grid Init
var stepStudentGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.offline.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};	

//stepChange Event Ajax
function stepChangeAjax(){
	
	
	// 각 단계별 과정명 가져와서 selectBox 조립
	$.ajaxCall({
		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailStepCourseList.do"/>"
		, async : false
		, data:  "courseid="+$("#courseid").val()+"&stepseq="+$("#stepList").val()
		, success: function(data, textStatus, jqXHR){
			var tag = "";
			tag += '<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">   ' ;
			tag += '<colgroup>                                                                       ' ;
			tag += '	<col width="20%" />                                                          ' ;
			tag += '	<col width="13%" />                                                          ' ;
			tag += '	<col width="20%" />                                                          ' ;
			tag += '	<col width="13%" />                                                          ' ;
			tag += '	<col width="20%" />                                                          ' ;
			tag += '	<col width="14%" />                                                          ' ;
			tag += '</colgroup>                                                                      ' ;
			tag += '<tr>                                                                             ' ;
			tag += '	<th>필수과정수</th>                                                          ' ;
			tag += '	<td>'+data.mustcoursecount +'</td>                                               ' ;
			tag += '	<th>선택과정수</th>                                                          ' ;
			tag += '	<td>'+data.selectcoursecount +'</td>                                             ' ;
			tag += '	<th>총과정수</th>                                                            ' ;
			tag += '	<td id="totalCourseCount">'+data.totalcoursecount +'</td>                                              ' ;
			tag += '</tr>                                                                            ' ;
			tag += '</table>                                                                         ' ; 
			
		$("#addTable").html(tag);
		
		var stepCourseList = data.stepCourseList;
		var pincodeList = data.pincodelist;
		var html = "<option value=''>과정명 선택</option>";
		var pincodeHtml ="<option value=''>선택</option>"; 
		
		
		//데이터 조립
		$.each(stepCourseList, function(index,  val)
		{
			var stepcourseid = val.stepcourseid;
			var stepcoursename = val.stepcoursename;
					html += "<option value='"+stepcourseid+"'>"+stepcoursename+"</option>";
		});
		$("#stepCourseList").html("");
		$("#stepCourseList").html(html);
		
		
		//show
		$("#pageTarget").html(listGrid);
		
		$.each(pincodeList, function(index, val)
		{
			var targetcodeseq = val.targetcodeseq;
			var casetwo = val.casetwo;
			
			pincodeHtml +="<option value='"+targetcodeseq+"'>"+casetwo+"</option>";
			
		});
		$("#searchpinlevel").html("");
		$("#searchpinlevel").html(pincodeHtml);
		
		stepStudentList.init();
		stepStudentList.doSearch({page:1});
		},
		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
		}
	});
};

	
	$(document).ready(function(){
		var stepSeq = "${param.stepseq}";
		
		if(stepSeq != null && stepSeq != "")
		{	
			var stepCourseId	= "${param.stepcourseid}";
			
			$("#stepList").val(stepSeq);
			
			//stepChange Event Ajax
			stepChangeAjax();
			$("#stepStudentGrid").show();
			
			
			$("#stepCourseList").val(stepCourseId);
			stepCourseListChange(stepCourseId,stepSeq);
		}
		
		
		var height = $(document).height();
		
		// 검색버튼 클릭
		$(document).on("click","#stepBtnSearch",function(){
			stepStudentList.doSearch({page:1});
		});
		
		
		$("#rowPerPage").on("change", function(){
			stepStudentList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
		});
		
		//stepChangeEvent
		$("#stepList").on("change",function(){
			//stepChange Event Ajax
			stepChangeAjax();
			$("#stepStudentGrid").show();
			
			$("#ifrm_main_W010200200_W", parent.document).height($(document).height()+150);
		});
		
		//stepCourseChangeEvent
		$("#stepCourseList").on("change",function(){
			
			if($("#stepCourseList").val() == '')
			{	
				//stepChange Event Ajax
				stepChangeAjax();
				$("#stepStudentGrid").show();
				
			}
			else
				{
					stepCourseListChange($("#stepCourseList").val(),$("#stepList").val());
				}
			
		});
		
	});
	

	
function stepCourseListChange(stepCourseId,stepSeq)
{
		 $.ajax({
			url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgChangeStepCourse.do"/>"
				, async : false
				, data:  "courseid="+$("#courseid").val()+"&stepcourseid="+stepCourseId+"&stepseq="+stepSeq
				, dataType : "text"
				, type : "post"
					, success: function(data){
						$("#pageTarget").html(data);
						
						$("#addTable").html($("#addTag").html());
						
						$("#stepStudentGrid").hide();
						$("#ifrm_main_W010200200_W", parent.document).height($(document).height()+150);
					},
					error: function() {
			           	alert("<spring:message code="errors.load"/>");
					}
					,complete: function()
					{		
						var test = {
								init : function(){
									// 상단 탭
									$("#divLmsRegularMgDetailTab").bindTab({
										  theme : "AXTabs"
										, overflow:"visible"
										, value: "U3"
										, options:[
											  {optionValue:"U1", optionText:"교육현황", tabId:"U1"} 
											, {optionValue:"U2", optionText:"교육신청자", tabId:"U2"}
											, {optionValue:"U3", optionText:"교육과정", tabId:"U3"}
											, {optionValue:"U4", optionText:"수료처리", tabId:"U4"}
										]
										, onchange : function(selectedObject, value){
											layer.setViewTab(value, selectedObject);
										}
									});
								}
						}
						
							$("#stepCourseList").val(stepCourseId);
							
							g_params.showTab = "U3";
							
							test.init();
					}
					
	 
		}) ; 
		 
}
	
	var stepStudentList = {
			/** init : 초기 화면 구성 (Grid)
			*/	
			
			
			init : function() {
				var idx = 0; // 정렬 Index 
				var _colGroup = [
									{key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
									, {key:"uid", label:"ABO 번호", width:"200", align:"center"}
									, {key:"name", label:"이름", width:"200", align:"center"}
									, {key:"pincode", label:"핀레벨", width:"150", align:"center"}
									, {		
											key: "finishcount", label : "이수과정", width: "250", align: "center", sort: false, formatter: function () {
														return "<span>"+this.item.finishcount+" / "+$('#totalCourseCount').text()+"</span>";
											}
										}
									, {
										key:"finishflag", label:"수료여부", width:"150", align:"center", formatter:function(){
										 				if(this.item.finishflag == "Y")
										 					{
										 						return "O";
										 					}
										 				else
										 					{
										 						return "X";
										 					}
											}
										}
								]
				var gridParam = {
						colGroup : _colGroup
						, fitToWidth: false
	 					//, fixedColSeq: 3
						, colHead : { heights: [25,25]}
						, targetID : "AXGridTarget_Step"
						, sortFunc : stepStudentList.doSortSearch
						, doPageSearch : stepStudentList.doPageSearch
					}

				fnGrid.initGrid(stepStudentGrid, gridParam);
			}, doPageSearch : function(pageNo) {
				// Grid Page List
				stepStudentList.doSearch({page:pageNo});
			}, doSortSearch : function(){
				var sortParam = getParamObject(stepStudentGrid.getSortParam()+"&page=1");
				defaultParam.sortOrder = sortParam.sortWay; 
				// 리스트 갱신(검색)
				stepStudentList.doSearch(sortParam);
			}, doSearch : function(param) {
				
				// Param 셋팅(검색조건)
				 var initParam = {
						searchpinlevel : $("#searchpinlevel").val()	
					  , searchmemberinfo : $("#searchmemberinfo").val()
					  , courseid : $("#courseid").val()
					  , stepseq : $("#stepList").val()
					  , searchtext : $("#searchtext").val()
				}; 
				$.extend(defaultParam, param);
				$.extend(defaultParam, initParam);
				$.ajaxCall({
			   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgDetailStepStudentListAjax.do"/>"
			   		, data: defaultParam
			   		, success: function( data, textStatus, jqXHR){
			   			if(data.result < 1){
			        		alert("<spring:message code="errors.load"/>");
			        		alert("success"+data);
			        		return;
						} else {
							callbackList(data);
					   		for(var i = 1;i<=data.totalCount;i++)
					   			{
							   		$("#apseq_"+i).append($("#apList").html());
					   			}
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
			   		stepStudentGrid.setData(gridData);
			   		
			   	}
				
			}
		}
	
	
	
</script>
<body>
<input type="hidden"  id="courseid" value="${courseid }"/>
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tr>
				<th align="center">단 계 명</th>
				<td>
					<select id="stepList">
						<option value="">단계명 선택</option>
						<c:forEach items="${stepNameList }" var="stepNameList">
							<option value="${stepNameList.stepseq }">[${stepNameList.steporder} 단계] ${stepNameList.stepname }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th align="center">과 정 명</th>
				<td>
					<select id="stepCourseList">
						<option value=''>과정명 선택</option>
					</select>
				</td>
			</tr>
		</table>
			<span id="addTable"></span>
		</table>
	</div>
	<br/><br/>
	
	<div id="pageTarget"></div>
		
		<!-- axisGrid -->
		<div id="stepStudentGrid">
			<div id="AXGrid">
				<div id="AXGridTarget_Step"></div>
			</div>
		</div>
	
</body>


	
</html>