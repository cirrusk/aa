<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
	var managerMenuAuth ="${managerMenuAuth}";
	//Grid Init
	var listGrid = new AXGrid(); // instance 상단그리드
	var frmid = "${param.frmId}";
	var prefrmid = "${param.prefrmId}"
	
	//Grid Default Param
	var defaultParam = {
		page: 1
	 	, rowPerPage: 20
	 	, sortColKey: "lms.testpool.list"
	 	, sortIndex: 0
	 	, sortOrder:"DESC"
	};
	
	$(document.body).ready(function(){
		//앞에서 가져온 값 사용하기
		$("#categoryid").val( window.parent.g_managerLayerMenuId.sessionOnCategoryId );
				
		list.init();
		
		$("#selectButton").on("click", function(){
			closeTapAndGoTap(frmid, prefrmid);
		});
		
		// 페이지당 보기수 변경 이벤트
		$("#rowPerPage").on("change", function(){
			list.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
		});
		
		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			list.doSearch({page:1});
		});
		
		// 검색버튼 클릭 효과주기
		$("#btnSearch").trigger("click");
		
		// 추가 버튼 클릭시
		$("#insertButton").on("click", function(){
			if(checkManagerAuth(managerMenuAuth)){return;}
			goWrite('I','');
			return;
		});
		
		// 삭제 버튼 클릭시
		$("#deleteButton").on("click", function(){
			if(checkManagerAuth(managerMenuAuth)){return;}
			gridEvent.chkDelete();
		});
		
		$("#insertExcel").on("click", function(){
			if(checkManagerAuth(managerMenuAuth)){return;}
			goExcelPopup();
		});
		
		// 엑셀다운 버튼 클릭시
		$("#aExcdlDown").on("click", function(){
			var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
			if(result) {
				showLoading();
				var initParam = {
					searchanswertype : $("#searchanswertype").val()	
					, searchuseflagtype : $("#searchuseflagtype").val()	
					, searchtype :$("#searchtype").val()
					, searchtext :$("#searchtext").val()
				};
				$.extend(defaultParam, initParam);
				postGoto("<c:url value="/manager/lms/test/lmsTestPoolListExcelDownload.do"/>", defaultParam);
				hideLoading();
			}
		});	
	});

	var list = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
				{
					key:"testpoolid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
				    return this.item.___checked && this.item.___checked["1"];
				}}		
				, {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
				, {key:"testpoolname", label:"문제명", width:"400", align:"center", sort:false}
				, {key:"answertypename", label:"문제유형", width:"100", align:"center", sort:false}
				, {key:"useflagname", label:"상태", width:"60", align:"center", sort:false}
				, {
					key:"manage", label:"수정", width:"100", align:"center", sort:false, formatter: function () {
						return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goWrite('U','" + this.item.testpoolid + "');\">수정</a>"
						;
					}
				}
			]
			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
				, colHead : { heights: [25,25]}
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : list.doSortSearch
				, doPageSearch : list.doPageSearch
			}
			
			fnGrid.initGrid(listGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			list.doSearch({page:pageNo});
		}, doSortSearch : function(){
			var sortParam = getParamObject(listGrid.getSortParam()+"&page=1");
			defaultParam.sortOrder = sortParam.sortWay; 
			// 리스트 갱신(검색)
			list.doSearch(sortParam);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			var initParam = {
				categoryid : $("#categoryid").val()
				, searchanswertype : $("#searchanswertype").val()	
				, searchuseflagtype : $("#searchuseflagtype").val()	
				, searchtype :$("#searchtype").val()
				, searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/test/lmsTestPoolListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		return;
					} else {
						callbackList(data);
					}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
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
		   		$("#categoryname").text(obj.categoryname);
		   		
		   		// Grid Bind Real
		   		listGrid.setData(gridData);
		   	}
		}
	}
	
	var gridEvent = {
		chkDelete : function() {
			// 선택 정보 삭제전 메세지 출력
			var checkedList = listGrid.getCheckedParams(0, false);// colSeq
			var len = checkedList.length;
			if(len == 0){
				alert("선택된 문제가 없습니다.");
				return;
			}
			var result = confirm("선택한 문제를 삭제 하겠습니까?"); 
			
			if(result) {
				$.ajaxCall({
					url: "<c:url value="/manager/lms/test/lmsTestPoolListDeleteAjax.do"/>"
					, data: jQuery.param(checkedList)
					, success: function(data, textStatus, jqXHR){
						alert(data.cnt + "건이 삭제 되었습니다.");
						list.doSearch();
					},
					error: function( jqXHR, textStatus, errorThrown) {
			           	alert("<spring:message code="errors.load"/>");
					}
				});
			}
		}
	}
	
	function goWrite(modeVal,testpoolidVal){
		var param = {
			inputtype : modeVal
			, categoryid : $("#categoryid").val()
			, testpoolid : testpoolidVal
		};
		var popParam = {
			url : "<c:url value="/manager/lms/test/lmsTestPoolListPop.do" />"
			, width : 1024
			, height : 800
			, maxHeight : 800
			, params : param
			, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	}
	
	function listRefresh(){
		var pageNo = $(".AXgridPageNo").val();
		list.doSearch({page:pageNo});
	}
	
	function closeTapAndGoTap(closeid, goid){
		window.parent.setValueTabMenu(goid);
		window.parent.listRefresh(goid);
		window.parent.closeTabMenu(closeid);
	}
	
	function goExcelPopup() {
		var param = {
			categoryid : $("#categoryid").val()
		};
		var popParam = {
			url : "<c:url value="/manager/lms/test/lmsTestPoolExcelPop.do" />"
			, width : 800
			, height : 500
			, maxHeight : 500
			, params : param
			, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	}
	
	function reSearch(){
		list.doSearch({page:1});
	}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">문제은행</h2>
	</div>
	
	<!--search table // -->

	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*"  />
				<col width="9%" />
			</colgroup>
			<tr>
				<th scope="row">문제분류명</th>
				<td>
					<input type="hidden" id="categoryid" name="categoryid" />
					<span id="categoryname"></span>
				</td>
				<td style="text-align:center;">
					<a href="javascript:;" id="selectButton" class="btn_green">목록</a>
				</td>
			</tr>
		</table>
	</div>
	
	<br>
	
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="21%" />
				<col width="9%"  />
				<col width="*"  />
				<col width="15%"  />
			</colgroup>
			<tr>
				<th scope="row">문제유형</th>
				<td>
					<select id="searchanswertype" name="searchanswertype" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="codeList" items="${answerTypeList}" varStatus="idx">
							<option value="${codeList.value}">${codeList.name}</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">상태</th>
				<td>
					<select id="searchuseflagtype" name="searchuseflagtype" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="codeList" items="${useList}" varStatus="idx">
							<option value="${codeList.value}">${codeList.name}</option>
						</c:forEach>
					</select>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>	
				</th>
			</tr>
			<tr>
				<th scope="row">조회</th>
				<td colspan="3">
					<select id="searchtype" name="searchtype" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<option value="1">문제명</option>
						<option value="2">문제지문</option>
					</select>
					<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:200px" >
				</td>
			</tr>
		</table>
	</div>
			
	<div class="contents_title clear">
		<div class="fl">
			<select id="rowPerPage" name="rowPerPage" style="width:auto; min-width:100px"> 
				<option value="20">20</option>
				<option value="50">50</option>
				<option value="500">500</option>
				<option value="1000">1000</option>
			</select>
			<a href="javascript:;" id="deleteButton" class="btn_green">삭제</a>
			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
			
			
			<span> Total : <span id="totalcount"></span>건</span>
		</div>
		
		<div class="fr">
			<div style="float:right;">
				<a href="javascript:;" id="insertExcel" class="btn_green">엑셀 등록</a>
				<a href="javascript:;" id="insertButton" class="btn_green">등록</a>
			</div>
		</div>
	</div>

	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>
</html>