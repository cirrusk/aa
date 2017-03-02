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
		, sortColKey: "common.batchResult.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

	$(document.body).ready(function() {
		adminList.init();

		// 페이지당 보기수 변경 이벤트
		$("#cboPagePerRow").on("change", function(){
			adminList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
		});

		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			adminList.doSearch({page:1});
		});

		$("input[name='startday']").val(setDatediff(setToDay(),-7));
		$("input[name='endday']").val(setToDay());
	});

	var adminList = {
		/** init : 초기 화면 구성 (Grid)
		 */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				{key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
				, {key:"batchname", label:"배치명", width:"150", align:"center", sort:false}
				, {key:"batchgubun", label:"배치구분", width:"150", align:"center", sort:false,formatter: function(){
					if(this.item.batchgubun == "day"){
						return "<span>일별</span>";
					}else if(this.item.batchgubun == "month"){
						return "<span>월별</span>";
					}
				}}
				, {key: "batchdate", label : "배치일시", width: "150", align: "center"}
				, {key:"batchresult", addclass:idx++, label:"성공여부", width:"200", align:"center", sort:false, formatter: function(){
					if(this.item.batchresult == "Y"){
						return "<span>성공</span>";
					}else if(this.item.batchresult == "N"){
						return "<span>실패</span>";
					}
				}}
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
				batchlogseq : $("#batchname option:selected").val()
			   ,batchgubun: $("#batchgubun option:selected").val()
			   ,startday: $("#startday").val()
			   ,endday:$("#endday").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/batchResult/batchResultListAjax.do"/>"
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
		}
	}

</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">배치결과로그</h2>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<th scope="row" style="text-align: center;">배치명</th>
				<td>
					<label>
						<select id="batchname">
							<option value="">전체</option>
							<c:forEach var="items" items="${batchname }">
								<option value="${items.code }">${items.name }</option>
							</c:forEach>
						</select>
					</label>
				</td>
				<th scope="row" style="text-align: center;">배치구분</th>
				<td>&nbsp;
					<label>
						<select id="batchgubun">
							<option value="">전체</option>
							<option value="day">일별</option>
							<option value="month">월별</option>
						</select>
					</label>
				</td>
			</tr>
			<tr>
				<th scope="row" style="text-align: center;">검색기간</th>
				<td colspan="3">
					<input type="text" id="startday" name="startday" class="AXInput datepDay" readonly="readonly">
					~
					<input type="text" id="endday" name="endday" class="AXInput datepDay" readonly="readonly">
					<a href="javascript:;" id="btnSearch" class="btn_gray btn_small">조회</a>
				</td>
			</tr>
		</table>
	</div>


	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget"></div>
		 <div id="AXGridTarget_${param.frmId}"></div>
	</div>

	<!-- Board List -->

</body>