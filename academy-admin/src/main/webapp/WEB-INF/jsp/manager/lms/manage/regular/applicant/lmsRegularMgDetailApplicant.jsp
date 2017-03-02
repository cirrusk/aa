<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var eduApplicantGrid = new AXGrid(); // instance 상단그리드
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
	
	eduApplicantList.init();
	eduApplicantList.doSearch({page:1});
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		eduApplicantList.doSearch({page:1});
	});
	
	// 삭제 버튼 클릭시
	$("#deleteButton").on("click", function(){
		//권한체크함수
		if(checkManagerAuth($("#managerMenuAuth").val())){return;}
		
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
					url : "/manager/lms/manage/regular/applicant/lmsRegularMgDetailApplicantPop.do"
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



/* 교육신청자 List Grid */
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
								, {key:"apseq",  width:"150", align:"center", display:false}
								, {key:"apname",  label:"교육장소", width:"150", align:"center"}
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
			
			// 신청자수,수료자수 변경 다시 읽기
			studentNumRefresh();
			
			// Param 셋팅(검색조건)
			 var initParam = {
					searchpinlevel : $("#searchpinlevel").val()	
				  , searchmemberinfo : $("#searchmemberinfo").val()
				  , courseid : "${courseid}"
				  , searchtext : $("#searchtext").val()
			}; 
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/manage/regular/applicant/lmsRegularMgApplicantListAjax.do"/>"
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
					list: obj.applicantList
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
			// 선택 정보 삭제전 메세지 출력
			var listIdx = eduApplicantGrid.getCheckedListWithIndex(0);
			var len = listIdx.length;
			if(len == 0){
				alert("선택된 회원이 없습니다.");
				return;
			}
			
			//데이터 조립
			var arrUid = [];
			var arrApSeq = [];
			
			for(var i = 0; i<len;i++)
			{	
				if(listIdx[i].item.apseq == null)
					{
						arrApSeq[i] = "";	
					}
				else
					{
						arrApSeq[i] = listIdx[i].item.apseq;
					}
				arrUid[i] = listIdx[i].item.uid;
			
			}
			var data =
			{
				uids : arrUid
				,courseid : $("#courseid").val()
				,apseqs : arrApSeq
			};

			 var result = confirm("선택한 회원을 신청취소 하시겠습니까?"); 
			 
 			 if(result) {
				$.ajaxCall({
					url: "<c:url value="/manager/lms/manage/regular/applicant/lmsRegularMgApplicantDeleteAjax.do"/>"
					, data: data
					, success: function(data, textStatus, jqXHR){
						alert(data.cnt + "건이 삭제 되었습니다.");
						eduApplicantList.doSearch({page:1});
					},
					error: function( jqXHR, textStatus, errorThrown) {
			           	alert("<spring:message code="errors.load"/>");
					}
				});
			}     
		}
} 


	
</script>
</head>

<body class="bgw">
<input type="hidden" id="courseid" value="${courseid }">
	
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
				*[유의사항] 정규과정 신청자의 교육장소 수정은 불가합니다. 장소 수정은 필요시 기존 신청취소 후 신규 교육 신청 추가가 필요합니다.
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
</body>