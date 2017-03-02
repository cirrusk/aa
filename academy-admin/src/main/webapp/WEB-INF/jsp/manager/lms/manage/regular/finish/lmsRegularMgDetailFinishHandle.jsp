<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">

var regularStudentGrid = new AXGrid(); // instance 상단그리드
var frmid = "${param.frmId}";

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 20
 	, sortColKey: "lms.regular.list"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};
	
$(document.body).ready(function(){
	
	regularStudentList.init();
	regularStudentList.doSearch({page:1});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		regularStudentList.doSearch({page:1});
	});
	
	$("#rowPerPage").on("change", function(){
		regularStudentList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
	});
	
	/*
	$("#allFinishFlag").on("click", function(){
		allFinishFlag("Y");
	});
	*/
	
	$("#updateFinishBtn").on("click", function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		var beforefinishflags = [];
		var uids = [];
		var finishflags = [];
		var uidString = "";
		var finishFlagString = "";
		var beforeFinishFlagString = "";
		for(var i = 0; i < regularStudentGrid.list.length; i++){
			beforefinishflags[i] = regularStudentGrid.list[i].beforefinishflag;
			uids[i] = regularStudentGrid.list[i].uid;
			finishflags[i] = regularStudentGrid.list[i].finishflag;
			if(i != 0 ){
				uidString += ",";
				finishFlagString += ",";
				beforeFinishFlagString += ",";
			}
			uidString += regularStudentGrid.list[i].uid ;
			finishFlagString += regularStudentGrid.list[i].finishflag ;
			beforeFinishFlagString += regularStudentGrid.list[i].beforefinishflag ;
		}
		//var param = $("#frm").serialize();
		
		if( !confirm("수료 정보를 저장하시겠습니까?") ) {
			return;
		}

		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/manage/regular/course/lmsRegularMgFinishUpdateAjax.do"/>"
	   		, timeout : 600 * 1000
	   		//, data : {courseid : $("#courseid").val(), uids:uids , finishflags:finishflags , beforeFinishflags:beforefinishflags}
	   		, data : {courseid : $("#courseid").val(), finishFlagString:finishFlagString, uidString:uidString , beforeFinishFlagString:beforeFinishFlagString}
	   		, success: function( data, textStatus, jqXHR){
	   			regularStudentList.doSearch({page:1});
	        		alert("저장완료하였습니다.");
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	           	alert("error"+textStatus);
	   		}
	   	});
	});
	
});

/* 교육신청자 List Grid */
var regularStudentList = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
								{key:"no", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
								    return this.item.___checked && this.item.___checked["1"];
								}}
			                 	,
			                 	{key:"no", label:"No.", width:"50", align:"center", formatter:"money", sort:false}
								, {key:"uid", label:"ABO 번호", width:"150", align:"center"}
								, {key:"name", label:"이름", width:"150", align:"center"}
								, {key:"pincodename", addclass:idx++, label:"핀레벨", width:"100", align:"center"}
								, {key:"beforefinishflag", label:"원래플래그", width:"100", align:"center", display:false}
							<c:forEach var="item" items="${steplist}" varStatus="status">
								, {key:"stepseq_${item.stepseq}",  label:"단계${item.stepseq}(${item.mustflagname})", width:"100", align:"center"}
							</c:forEach>
								, {		
									key: "finishflag", label : "수료여부", width: "150", align: "center", sort: false, formatter: function () {
										
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
									, changed: function () {alert(this.item.no.number())}
								}
							]
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: false
 					//, fixedColSeq: 3
					, colHead : { heights: [25,25]}
					, targetID : "AXGridTarget_Finish"
					, sortFunc : regularStudentList.doSortSearch
					, doPageSearch : regularStudentList.doPageSearch
				}

			fnGrid.nonPageGrid(regularStudentGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			regularStudentList.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(regularStudentGrid.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			regularStudentList.doSearch(sortParam);
		}, doSearch : function(param) {
			// 신청자수,수료자수 변경 다시 읽기
			studentNumRefresh();
			// Param 셋팅(검색조건)
			 var initParam = {
					searchfinishflag : $("#searchfinishflag").val()
				  ,	searchpinlevel : $("#searchpinlevel").val()	
				  , searchmemberinfo : $("#searchmemberinfo").val()
				  , courseid : "${courseid}"
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/finish/lmsRegularMgDetailFinishHandleListAjax.do"/>"
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
					list: obj.finishList
					, page:{
						pageNo: obj.page,
						pageSize: defaultParam.rowPerPage,
						pageCount: obj.totalPage,
						listCount: obj.totalCount
					}
				};			   		
		   		$("#totalcount").text(obj.totalCount);
		   		// Grid Bind Real
		   		regularStudentGrid.setData(gridData);
		   		
		   	}
			
		}
	}
 function changeFinishFlag(val, index){
	regularStudentGrid.list[index].finishflag = val;
}

function allFinishFlag(changedFinishFlagVal){
	var listIdx = regularStudentGrid.getCheckedListWithIndex(0);
	var len = listIdx.length;
	if(len == 0){
		alert("선택된 수강자가 없습니다.");
		return;
	}
	//수료상태 변경
	for(var i = 0; i<len;i++)
	{	
		var no = listIdx[i].item.no;
		$("#finishflag_"+no).val(changedFinishFlagVal);
		listIdx[i].item.finishflag = changedFinishFlagVal;
	}
}
</script>


<body class="bgw">
<input type="hidden" id="courseid" value="${param.courseid }">
	
			<div class="tbl_write">
				<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="20%"  />
						<col width="20%"  />
						<col width="20%"  />
						<col width="20%"  />
						<col width="20%"  />
					</colgroup>
					<tr>
						<th>수료여부</th>
						<td>
							<select id="searchfinishflag" name="searchfinishflag">
								<option value="">선택</option>
								<option value="Y">수료</option>
								<option value="N">미수료</option>
							</select>
						</td>
						<th>핀레벨</th>
						<td>
							<select id="searchpinlevel" name="searchpinlevel">
								<option value="">선택</option>
								<c:forEach items="${pincodelist}" var="pincodelist">
									<option value="${pincodelist.targetcodeseq }"> ${pincodelist.casetwo } </option>
								</c:forEach>
							</select>
						</td>
						<td rowspan="2">
							<div class="btnwrap mb10">
								<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" style="width:auto; min-width:30px">검색</a>
							</div>
						</td>
					</tr>
					<tr>
						<th>조회</th>
						<td colspan="3">
							<select id="searchmemberinfo" name="searchmemberinfo" style="width:auto; min-width:100px" >
								<option value="">전체</option>
								<option value="1">ABO번호</option>
								<option value="2">이름</option>
							</select>
							<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
						</td>
					</tr>
				</table>
			</div>
			
			<div class="contents_title clear">
				<div class="fl">
					<span id="finishcoutrequestcountNum"> 수료자 : ${total.finishcnt} / ${total.totalcnt}</span>
					 <a href="javascript:;" id="allFinishFlag" class="btn_green" onclick="allFinishFlag('Y')">선택회원 수료로 변경</a>
				</div>
				
				<div class="fr">
					<div style="float:right;">
						<a href="javascript:;" id="updateFinishBtn" class="btn_green">수료여부 저장</a>
					</div>
				</div>
			</div>
				
			<!-- axisGrid -->
			<div id="AXGrid">
			<form id="frm"  method="post" enctype="multipart/form-data">
				<div id="AXGridTarget_Finish"></div>
			</form>	
			</div>
</body>
