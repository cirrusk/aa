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
		, sortColKey: "common.targetMaster.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

	$(document.body).ready(function() {
		param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
		if(param.menuAuth == "W"){
			$(".authWrite").show();
		}else{
			$(".authWrite").hide();
		}

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
		$("#codeUpload").on("click", function(){
			var param = {
				mode:"I"
				, frmId  : $("[name='frmId']").val()
				, pageID : "${param.frmId}"
				, menuAuth:"${param.menuAuth}"
			};

			var popParam = {
				url : "<c:url value="/manager/common/targetCode/targetCodeListPop.do" />"
				,modalID:"modalDiv01"
				, width : "512"
				, height : "400"
				, params : param
				, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		});
	});

	var gridEvent = {
		nameClick: function (targetmasterseq) {

			var param = {
				mode: "U"
				, targetmasterseq :targetmasterseq
				, frmId  : $("[name='frmId']").val()
				, pageID : "${param.frmId}"
				, menuAuth:"${param.menuAuth}"
			};

			var popParam = {
				url: "<c:url value="/manager/common/targetCode/targetCodeListPop.do" />"
				, width: "512"
				, height: "400"
				, params: param
				, targetId: "searchPopup"
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
				  {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
				, {key:"targetmasterseq", addclass:idx++, label:"코드분류", width:"150", align:"center", sort:false}
				, {key:"targetmastername", addclass:idx++, label:"코드분류명", width:"150", align:"center", sort:false,  formatter: function(){
					return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.targetmasterseq + "')\">" + this.item.targetmastername + "</a>";
				  }}
				, {key: "btn", label : "하위코드명", width: "150", align: "center", formatter: function () {
						return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"adminList.doSearchDetail('" + this.item.targetmasterseq  + "')\">하위코드설정</a>";
				  }}
				, {key:"modifydate", addclass:idx++, label:"최종수정일", width:"200", align:"center", sort:false}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: true
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
				targetmasterseq : $("#disCode").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/targetCode/targetCodeListAjax.do"/>"
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
		}, doSearchDetail: function(val){
			var f = document.listForm;
			f.targetmasterseq.value = val;
			f.action = "/manager/common/targetCode/targetCodeDetail.do";
			f.submit();
		}
	}

	function doReturn() {
		adminList.doSearch();
	}

</script>
</head>

<body class="bgw">
    <form:form id="listForm" name="listForm" method="post">
		<input type="hidden" name="targetmasterseq" id="targetmasterseq" />
		<input type="hidden" name="frmId" value="${param.frmId}"/>
		<input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
    </form:form>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">대상자코드</h2>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<th scope="row" style="text-align: center;">업무구분</th>
				<td>
					<label>
						대상자
					</label>
				</td>
				<th scope="row" style="text-align: center;">코드분류</th>
				<td>&nbsp;
				    <select id="disCode">
						<option value="">전체</option>
						<c:forEach var="items" items="${listScope }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
		</table>

		<div class="contents_title clear" style="padding-top: 15px;height: 15px;">
			<div class="fl">
			</div>
			<div class="fr">
				<a href="javascript:;" id="authWrite" class="btn_green authWrite" style="vertical-align:middle; margin-left:0px;">코드분류등록</a>
			</div>
		</div>
	</div>


	<!-- grid -->
	<div id="AXGrid">
		 <div id="AXGridTarget_${param.frmId}"></div>
	</div>

	<!-- Board List -->

</body>