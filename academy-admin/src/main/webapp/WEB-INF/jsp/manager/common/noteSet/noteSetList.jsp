<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
	//Grid Init
	var systemCodeGrid = new AXGrid(); // instance 상단그리드

	//Grid Default Param
	var defaultParam = {
		page: 1
		, rowPerPage: "${rowPerCount }"
		, sortColKey: "common.noteSet.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

	$(document.body).ready(function() {
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
		systemCode.init();
		systemCode.doSortSearch();

		// 페이지당 보기수 변경 이벤트
		$("#cboPagePerRow").on("change", function(){
			systemCode.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
		});

		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			systemCode.doSearch({page:1});
		});

		// 추가 버튼 클릭시
		$("#codeUpload").on("click", function(){
			var param = {
				mode:"I"
				, frmId  : $("[name='frmId']").val()
			};

			var popParam = {
				url : "<c:url value="/manager/common/noteSet/noteSetPop.do"/>"
				,modalID:"modalDiv01"
				, width : "600"
				, height : "450"
				, params : param
				, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		});
	});

	var gridEvent = {
		nameClick: function (notesetseq) {

			var param = {
				mode: "U"
				, notesetseq :notesetseq
				, frmId  : $("[name='frmId']").val()
				, pageID : "${param.frmId}"
				, menuAuth:"${param.menuAuth}"
			};

			var popParam = {
				url: "<c:url value="/manager/common/noteSet/noteSetPop.do" />"
				, width: "600"
				, height: "450"
				, params: param
				, targetId: "searchPopup"
			}

			window.parent.openManageLayerPopup(popParam);

		}
	}

	var systemCode = {
		/** init : 초기 화면 구성 (Grid)
		 */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				  {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
				, {key:"noteservice", label:"서비스", width:"150", align:"center", sort:false}
				, {key:"sendtime", label:"발송시기", width:"150", align:"center", sort:false}
				, {key:"notecontent", label:"안내문구", width:"150", align:"center", sort:false}
				, {key:"notesetseq", label:"쪽지코드", width:"150", align:"center", sort:false,  formatter: function(){
					return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.notesetseq + "')\">" + this.item.notesetseq + "</a>";
				  }}
				, {key:"registrant", label:"등록자", width:"150", align:"center", sort:false}
				, {key:"registrantdate", label:"최종등록일", width:"150", align:"center", sort:false}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : systemCode.doSortSearch
				, doPageSearch : systemCode.doPageSearch
			}

			fnGrid.initGrid(systemCodeGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			systemCode.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
				sortIndex : sortKey
				, page : 1
			};

			// 리스트 갱신(검색)
			systemCode.doSearch(param);
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
				noteservice : $("#noteservice").val()
				, noteitem : $("#noteitem").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/noteSet/noteSetListAjax.do"/>"
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
				systemCodeGrid.setData(gridData);
			}
		}
	}

	function doReturn() {
		systemCode.doSearch();
	}

</script>
</head>

<body class="bgw">
	<input type="hidden" name="frmId" value="${param.frmId}"/>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">쪽지설정</h2>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<th scope="row" style="text-align: center;">서비스 구분</th>
				<td>
					<select id="noteservice">
						<option value="">전체</option>
						<option value="3">쇼핑</option>
						<option value="2">비즈니스</option>
						<option value="1">아카데미</option>
					</select>
				</td>
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
		</table>

		<div class="contents_title clear"style="padding-top: 15px;height: 10px;">
			<div class="fr">
				<a href="javascript:;" id="codeUpload" class="btn_green authWrite" style="vertical-align:middle; margin-left:0px;">쪽지정보 등록</a>
			</div>
		</div>
	</div>

	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>

	<!-- Board List -->

</body>
