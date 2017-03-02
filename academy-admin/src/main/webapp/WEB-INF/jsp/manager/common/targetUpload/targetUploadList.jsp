<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>


<script type="text/javascript">
	//Grid Init
	var adminGrid = new AXGrid(); // instance 상단그리드

	//Grid Default Param
	var defaultParam = {
		page: 1
		, rowPerPage: "${rowPerCount }"
		, sortColKey: "common.targetUpload.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

	$(document.body).ready(function() {
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
		adminList.init();

		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			adminList.doSearch({page:1});
		});

		// 추가 버튼 클릭시
		$("#popBtn").on("click", function(){
			var param = {
				mode:"I"
				, frmId  : $("[name='frmId']").val()
			};

			var popParam = {
				url : "<c:url value="/manager/common/targetUpload/targetUploadPop.do" />"
				,modalID:"modalDiv01"
				, width : "900"
				, height : "500"
				, params : param
				, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		});

		//샘플다운로드(엑셀)
		$("#sampleDownBtn").on("click", function(){
			var result = confirm("일괄업로드샘플 내려받기를 시작 하시겠습니까?\n네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다.");
			if(result) {
				showLoading();
				var initParam = {
					exceltype : "testpool"
				   ,downloadfile:"대상자일괄 업로드"
				};
				postGoto("<c:url value="/manager/common/targetUpload/targetUploadSampleExcelDownload.do"/>", initParam);
				hideLoading();
			}

		});

		$("#delBtn").on("click",function(){
			delEvent.chkDelete();
		});

	});

	var gridEvent = {
		nameClick: function (groupseq) {
			var param = {
				mode: "L"
			  , groupseq:groupseq
			};

			var popParam = {
				url: "<c:url value="/manager/common/targetUpload/targetUploadDetailCntPop.do" />"
				, width: "612"
				, height: "400"
				, params: param
				, targetId: "searchPopup"
			}

			window.parent.openManageLayerPopup(popParam);
		},
		// 추가 버튼 클릭시
		doPopup: function (groupseq) {
			var param = {
				groupseq: groupseq
				, frmId  : $("[name='frmId']").val()
			};

			var popParam = {
				url : "<c:url value="/manager/common/targetUpload/targetUploadDetailPop.do" />"
				,modalID:"modalDiv01"
				, width : "900"
				, height : "550"
				, params : param
				, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		}
	}

	var adminList = {
		/** init : 초기 화면 구성 (Grid)
		 */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				{key: "groupseq", label: " ", width: "50", align: "center", formatter:"checkbox", checked:function(){
					return this.item.___checked && this.item.___checked["1"];
				}},
				{key : "row_num", label : "No.", width : "60", align : "center", sort : false},
				{key : "targetgroupname", label : "대상자그룹명", width : "150", align : "center", sort : false, formatter: function() {
					return "<a href=\"javascript:;\" onclick=\"gridEvent.doPopup('" + this.item.groupseq + "')\">" + this.item.targetgroupname + "</a>";
				}},
				{key : "targetcnt", label : "등록인원", width : "150", align : "center", sort : false, formatter: function(){
					if(this.item.targetcnt == "0"){
						return this.item.targetcnt + "명";
					}else if(!(this.item.targetcnt == "0")){
						return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.groupseq + "')\">" + this.item.targetcnt + "</a>" +"명";
					}
				}},
				{key : "cookmastercode", label : "요리명장여부", width : "150", align : "center", sort : false, formatter: function(){
					if(this.item.cookmastercode == "C01"){
						return "<span>Y</span>"
					}else if(this.item.cookmastercode == "C02"){
						return "<span>N</span>"
					}
				}},
				{key : "targetuse", label : "사용용도", width : "150", align : "center", sort : false},
				{key : "insertuser", label : "등록자", width : "100", align : "center", sort : false},
				{key : "updatedate", label : "등록일", width : "150", align : "center", sort : false}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: true
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : adminList.doSortSearch
				, doPageSearch : adminList.doPageSearch
			}

			fnGrid.initGrid(adminGrid, gridParam);
			adminList.doSearch();
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			adminList.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
				sortIndex : sortKey
				, page : 1
			};

			// 리스트 갱신(검색)
			adminList.doSearch(param);
		}, doSearch : function(param) {

			// Param 셋팅(검색조건)
			var initParam = {
				targetgroupname : $("#targetgroupname").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/targetUpload/targetUploadListAjax.do"/>"
				, data: defaultParam
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						return;
					} else {
						callbackList(data);
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
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
				// Grid Bind Real
				adminGrid.setData(gridData);
			}
		}, dosearchDetail2: function(val){
			var f = document.listForm;
			f.targetmasterseq.value = val;
			f.action = "/manager/common/targetCode/targetCodeDetail.do";
			f.submit();
		}
	}

	var delEvent ={
		chkDelete : function() {
			// 선택 정보 삭제전 메세지 출력
			var groupseq = "";
			var checkedList = adminGrid.getCheckedListWithIndex(0);// colSeq

			for(var i = 0; i < checkedList.length; i++){
				if(i == 0){
					groupseq = checkedList[i].item.groupseq;
				} else {
					groupseq = groupseq+","+checkedList[i].item.groupseq;
				}
			}

			if($.trim(groupseq).length == 0){
				alert("선택된 대상자가 없습니다.");
				return;
			}
			var param = {
				groupseq : groupseq
			};

			var result = confirm("선택한 대상을 삭제 하시겠습니까?");

			if(result) {
				$.ajaxCall({
					url: "<c:url value="/manager/common/targetUpload/targetUploadDelete.do"/>"
					, data: param
					, success: function(data, textStatus, jqXHR){
						alert(data.cnt + "건이 삭제 되었습니다.");
						adminList.doSearch();
					},
					error: function( jqXHR, textStatus, errorThrown) {
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
					}
				});
			}
		}
	}

	function doReturn() {
		adminList.doSearch();
	}

</script>
</head>

<body class="bgw">
<form:form id="listForm" name="listForm" method="post">
	<input type="hidden" name="groupseq" id="groupseq" value="${list.groupseq}"/>
	<input type="hidden" name="frmId" value="${param.frmId}"/>
</form:form>
<!--title //-->
<div class="contents_title clear">
	<h2 class="fl">대상자일괄업로드</h2>
</div>

<!--search table // -->
<div class="tbl_write">
	<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<th scope="row">대상자그룹명</th>
			<td>
				<input type="text" class="AXInput" style="min-width:303px;" id="targetgroupname" value=""/>
				<a href="javascript:;" id="btnSearch" class="btn_gray" onclick="adminList.doSearch()">조회</a>
			</td>
		</tr>
	</table>

	<div class="contents_title clear"style="height: 15px;padding-top: 15px;">
		<div class="fr">
			<a href="javascript:;" id="sampleDownBtn" class="btn_green">일괄업로드샘플 다운로드</a>
			<a href="javascript:;" id="popBtn" class="btn_green authWrite">대상자일괄업로드</a>
			<a href="javascript:;" id="delBtn" class="btn_green authWrite">삭제</a>
		</div>
	</div>
</div>

<!-- grid -->
<div id="AXGrid">
	<div id="AXGridTarget_${param.frmId}"></div>
</div>
<!-- Board List -->

</body>