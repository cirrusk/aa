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
		, sortColKey: "common.targetRule.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

	$(document.body).ready(function() {
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
		adminList.init();
		adminList.doSortSearch();

		// 페이지당 보기수 변경 이벤트
		$("#cboPagePerRow").on("change", function(){
			adminList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
		});

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
				url : "<c:url value="/manager/common/targetRule/targetRulePop.do" />"
				,modalID:"modalDiv01"
				, width : "830"
				, height : "400"
				, params : param
				, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		});
	});

	var gridEvent = {
		nameClick: function (targetruleseq) {

			var param = {
				mode: "U"
				, targetruleseq :targetruleseq
				, frmId  : $("[name='frmId']").val()
				, pageID : "${param.frmId}"
				, menuAuth:"${param.menuAuth}"
			};

			var popParam = {
				url: "<c:url value="/manager/common/targetRule/targetRulePop.do" />"
				, width: "830"
				, height: "400"
				, params: param
				, targetId: "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		}
	}

	var adminList = {
		/** init : 초기 화면 구성 (Grid) */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				{key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
				, {key:"targetcodegubun", label:"대상자코드구분", width:"150", align:"center", sort:false}
				, {key:"rulegubun", label:"업무구분", width:"150", align:"center", sort:false}
				, {key:"targetrulename", label:"대상자코드 조건명", width:"250", align:"center", sort:false,  formatter: function(){
					return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.targetruleseq + "')\">" + this.item.targetrulename + "</a>";
				  }}
				, {key:"registrant", label:"등록자", width:"150", align:"center", sort:false}
				, {key:"registrantdate", addclass:idx++, label:"등록일시", width:"200", align:"center", sort:false}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : adminList.doSortSearch
				, doPageSearch : adminList.doPageSearch
			}

			fnGrid.initGrid(adminGrid, gridParam);
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
				targetcodegubun : $("#targetcodegubun").val()
				, rulegubun : $("#rulegubun").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/targetRule/targetRuleListAjax.do"/>"
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

	function doReturn() {
		adminList.doSearch();
	}

</script>
</head>

<body class="bgw">
    <form:form id="listForm" name="listForm" method="post">
		<input type="hidden" id="targetruleseq" name="targetruleseq"/>
		<input type="hidden" name="frmId" value="${param.frmId}"/>
    </form:form>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">대상자 조건 설정</h2>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<th scope="row" style="text-align: center;">대상자코드구분</th>
				<td>
					<select id="targetcodegubun">
						<option value="">선택</option>
						<option value="pincode">핀레벨</option>
						<option value="bonuscode">보너스레벨</option>
						<option value="agecode">나이</option>
					</select>
				</td>
				<th scope="row" style="text-align: center;">업무구분</th>
				<td>&nbsp;
				    <select id="rulegubun">
						<option value="">전체</option>
						<option value="1">예약서비스</option>
						<option value="2">교육</option>
					</select>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" onclick="adminList.doSearch();">검색</a>
					</div>
				</th>
			</tr>
		</table>
		<div class="contents_title clear"style="padding-top: 15px;height: 10px;">
			<div class="fl" style="font-size: 15px;">
				대상자 코드 조건명 수정 및 삭제 는 IT팀에 문의하여 처리하세요.
			</div>
			<div class="fr">
				<a href="javascript:;" id="popBtn" class="btn_green authWrite">조건 설정</a>
			</div>
		</div>
	</div>

	<!-- grid -->
	<div id="AXGrid">
		 <div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->

</body>