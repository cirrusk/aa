<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	//Grid Init
	var adminGrid = new AXGrid(); // instance 상단그리드

	//Grid Default Param
	var defaultParam = {
		page: 1
		, rowPerPage: "${rowPerCount }"
		, sortColKey: "common.targetUploadListCntPop.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

	var _colGroup = [
		{key:"row_num", label:"No.", width:"40", align:"center", sort:false}
		, {key:"aboname", label:"대상자이름", width:"150", align:"center", sort:false}
		, {key:"abono", label:"ABO번호", width:"150", align:"center", sort:false}
	]

	var gridParam = {
		colGroup : _colGroup
		, fitToWidth: true
		, targetID : "AXGridTarget_${param.frmId}"
	}
	fnGrid.nonPageGrid(adminGrid, gridParam);
	doSearch();

	function doSearch(param) {

		// Param 셋팅(검색조건)
		var initParam = {
			groupseq : $("#groupseq").val()
		};

		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);

		$.ajaxCall({
			url: "<c:url value="/manager/common/targetUpload/targetUploadListCntPopAjax.do"/>"
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

</script>

    <form:form id="listForm" name="listForm" method="post">
	     <input type="hidden" name="groupseq" id="groupseq" value="${popDetail.groupseq}"/>
    </form:form>
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				등록인원 조회
			</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->

		<!-- Contents -->
		<div id="popcontainer"  style="height:auto;">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<!-- grid -->
					<div id="AXGrid">
						<div id="AXGridTarget_${param.frmId}"></div>
					</div>
				</div>
				<!--// Sub Title -->
			</div>
		</div>

		<div class="btnwrap mb10">
			<button id="closebTn"  class="btn_close close-layer" >닫기</button>
		</div>
	</div>
