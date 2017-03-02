<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">

	var adminGrid = new AXGrid(); // instance 상단그리드
	
	var selectData;
	
	//Grid Default Param
	var defaultParam = {
		page: 1
		, rowPerPage: 20
		, sortColKey: "common.targetMaster.list"
		, sortIndex: 1
		, sortOrder:"DESC"
	};

    $(document).ready(function(){
    	
    	
    	var adNo = "${param.adno}";
    	
    	var searchData = {
				searchtype : "1"
				,searchtext: adNo
			};
    	
    	adminList.init();
    	if(adNo != null && adNo != "")
    		{
			  	 $("#searchtype").val("1");
			  	 $("#searchtext").val(adNo);
    		}
  	 	adminList.doSearch();
  	 	
	// 페이지당 보기수 변경 이벤트
		$("#rowPerPage").on("change", function(){
			adminList.doSearch({page:1, rowPerPage : $("#rowPerPage").val() });
		});
	
		// 페이지당 보기수 변경 이벤트
		$("#btnSearch").on("click", function(){
			adminList.doSearch();
		});
    });

	var adminList = {
		/** init : 초기 화면 구성 (Grid)
		 */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				{key:"no", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
				, {key:"adno", label:"AD계정", width:"150", align:"center", sort:false}
				, {
					key:"managename", label:"이름", width:"100", align:"center", sort:false, formatter:function(){
						return "<input type='text' id='"+this.item.adno+"_name' value='"+this.item.managename+"'/>";
					}
				}
				, {
					key:"managedepart", label:"부서", width:"150", align:"center", sort:false, formatter:function(){
						return "<input type='text' id='"+this.item.adno+"_depart' value='"+this.item.managedepart+"'/>";
					}
				}
				, {
					key:"apseq", label:"장소", width:"150", align:"center", sort:false, formatter:function(){
						var selectTag = "";
						var apseq = this.item.apseq;
						selectTag += "<select id='"+this.item.adno+"_apseq'>";
						selectTag += "<option value=''>PP선택</option>                           ";
						$.each(selectData,function(idx,val){
							if(apseq == val.ppseq)
								{
										selectTag += '<option value="'+val.ppseq+'" selected="selected">'+val.ppname+'</option>';
								}
							else
								{
										selectTag += '<option value="'+val.ppseq+'">'+val.ppname+'</option>';
								}
							});
						selectTag += "</select>  ";
						
						return selectTag;
						
					}
				}
				,{
					key:"gaugeyn", width:"40", align:"center", label:"측정",formatter:function(){
						
						var checkbox = "";
						
						if(this.item.gaugeyn == "Y")
							{
								checkbox = '<input type="checkbox" id="'+this.item.adno+'_gaugeyn"   checked="checked">';
							}
						else
							{
								checkbox = '<input type="checkbox" id="'+this.item.adno+'_gaugeyn" >';
							}
						return checkbox;
						
					}
				}
				,{
					key:"experienceyn", width:"40", align:"center", label:"체험",formatter:function(){
						var checkbox = "";
						if(this.item.experienceyn == "Y")
							{
								checkbox = '<input type="checkbox" id="'+this.item.adno+'_experienceyn"  checked="checked">';
							}
						else
							{
								checkbox = '<input type="checkbox" id="'+this.item.adno+'_experienceyn">';
							}
								return checkbox;
					}
				}
				, {
					key:"update", label:"선택", width:"150", align:"center", sort:false, formatter:function(){
						return "<a href='javascript:;' class='btn_green' onclick=\"javascript:goUpdate('"+this.item.adno+"')\">수정&선택</a>";
					}
				}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
				, colHead : { heights: [25,25],
					rows : [
						[
							 {colSeq: 0}
							,{colSeq: 1}
							,{colSeq: 2}
							,{colSeq: 3}
							,{colSeq: 4}
							,{colSeq: 5}
							,{colSeq: 6}
							,{colSeq: 7}
						]
					]
				}
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
				searchtype :$("#searchtype").val()
				,searchtext: $("#searchtext").val()
			};
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/auth/authGroupListPopAjax.do"/>"
				, data: defaultParam
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						return;
					} else {
						
						selectData = data.ppList;
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
				$("#totalcount").text(obj.totalCount);
				// Grid Bind Real
				adminGrid.setData(gridData);
			}
		}
	}
	
	
function goUpdate(adNo)
	{	
		
		var gaugeYN;
		var experienceYN;
		
		if($("#"+adNo+"_gaugeyn").is(":checked"))
			{
				gaugeYN = "Y";
			}
		else
			{
				gaugeYN = "N";
			}
		
		if($("#"+adNo+"_experienceyn").is(":checked"))
			{
				experienceYN = "Y";
			}
		else
			{
				experienceYN = "N";
			}
			
		var data = {
				adno : adNo
				,managename : $("#"+adNo+"_name").val()
				,managedepart : $("#"+adNo+"_depart").val()
				,experienceyn : experienceYN
				,gaugeyn : gaugeYN
				,apseq : $("#"+adNo+"_apseq").val()
		}
		
		
		$.ajaxCall({
			url: "<c:url value="/manager/common/auth/authGroupListPopUpdateAjax.do"/>"
			,data: data
			,success: function(data, textStatus, jqXHR)
			{
				if(data.result < 1){
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
					return;
				} else {
					
					$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.goAuthorize(adNo);
					
					closeManageLayerPopup("authPopup");
				}
			}
			,error: function(jqXHR,textStatus,errorThrown)
			{
				
			}
		});
	}

</script>
<body class="bgw">
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				<c:if test="${layerMode.mode eq 'I' }">Window</c:if>
			</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->

		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3>사용자 검색</h3>
				</div>
				<!--// Sub Title -->
					<div class="tbl_write">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<th scope="row" style="text-align: center;">사용자</th>
								<td>
									<select id="searchtype">
										<option value="">선택</option>
										<option value="1">계정</option>
										<option value="2">이름</option>
									</select>
									<input type="text" id="searchtext" class="AXInput"/>
									<a href="javascript:;" id="btnSearch" class="btn_gray" onclick="javascript:;">조회</a>
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
						
						<span> Total : <span id="totalcount"></span>건</span>
					</div>
					
				</div>
				<!-- grid -->
				<div id="AXGrid">
					<%--<div id="AXGridTarget"></div>--%>
					<div id="AXGridTarget_${param.frmId}"></div>
				</div>

				<br>
				<div class="btnwrap mb10">
						<button id="closebTn"  class="btn_close close-layer" >닫기</button>
				</div>
			</div>
		</div>
	</div>
</body>

