<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
	var managerMenuAuth ="${managerMenuAuth}";
	//Grid Init
	var listGrid = new AXGrid(); // instance 상단그리드
	var frmid = "${param.frmId}";
	//Grid Default Param
	var defaultParam = {
		page: 1
	 	, rowPerPage: 20
	 	, sortColKey: "lms.testpoolcategory.list"
	 	, sortIndex: 0
	 	, sortOrder:"DESC"
	};
	
	$(document.body).ready(function(){
		
		list.init();
		
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
		
		// 엑셀다운 버튼 클릭시
		$("#aExcdlDown").on("click", function(){
			var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
			if(result) {
				showLoading();
				var initParam = {
					  searchtext :$("#searchtext").val()
				};
				$.extend(defaultParam, initParam);
				postGoto("<c:url value="/manager/lms/test/lmsTestPoolExcelDownload.do"/>", defaultParam);
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
					key:"categoryid", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
				    return this.item.___checked && this.item.___checked["1"];
				}}		
				, {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
				, {key:"categoryname", label:"문제분류명", width:"400", align:"center", sort:false}
				, {key:"testpoolcount", label:"문제수", width:"140", align:"center", sort:false}
				, {
					key:"manage", label:"관리", width:"220", align:"center", sort:false, formatter: function () {
						return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goTestTab('" + this.item.categoryid + "');\">문제관리</a>" + 
							" <a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goWrite('U','" + this.item.categoryid + "');\">수정</a>"
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
				  searchtext :$("#searchtext").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
			$.ajaxCall({
		   		url: "<c:url value="/manager/lms/test/lmsTestPoolAjax.do"/>"
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
				alert("선택된 문제분류가 없습니다.");
				return;
			}
			var result = confirm("문제분류를 삭제하면 포함된 문제를 이용할 수 없습니다.\n선택한 문제분류를 삭제 하겠습니까?"); 
			
			if(result) {
				$.ajaxCall({
					url: "<c:url value="/manager/lms/test/lmsTestPoolDeleteAjax.do"/>"
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
	
	function goWrite(modeVal,categoryidVal){
		var param = {
			inputtype : modeVal ,
			categoryid : categoryidVal
		};
		var popParam = {
				url : "<c:url value="/manager/lms/test/lmsTestPoolPop.do" />"
				, width : "550"
	        	, height : "200"
				, maxHeight : 400
				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	}
	
	function listRefresh(){
		var pageNo = $(".AXgridPageNo").val();
		list.doSearch({page:pageNo});
	}

	function goTestTab( categoryIdVal ) {
		// 상세 tabpage
		var strMenuCd   = "";
		var strMenuText = "";
		var strLinkurl = "";
		
		strMenuCd = "W010300210";
		strMenuText = "문제은행 등록";
		strLinkurl = '/manager/lms/test/lmsTestPoolList.do';
		
		// 전역변수 처리
		window.parent.g_managerLayerMenuId.sessionOnCategoryId  = categoryIdVal;
		
		var item = { 
			menuCd   : strMenuCd
			, menuText : strMenuText
			, linkurl  : strLinkurl
			, menuYn   : 'Y'
			, callFn   : 'reloadFrame' 
			, funcData : ''
			, urlParam : "prefrmId="+frmid
		};
		
		window.parent.addTabMenu(Object.toJSON(item));
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
				<col width="*" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th>조회</th>
				<td>
					<input type="text" id="searchtext" name="searchtext" style="width:auto; min-width:300px" >
				</td>
				<th>
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
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