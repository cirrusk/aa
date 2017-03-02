<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">

	/** object setting */
	$(document.body).ready(function(){
		
		param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
	    
	    if(param.menuAuth == "W"){
	        $(".authWrite").show();
	    }else{
	        $(".authWrite").hide();
	    }
		
		gridFunctionList.init();
		
		// 검색버튼 클릭
		$("#btnSearch").on("click", function(){
			gridFunctionList.doSearch({page:1});
		});
		
		// 페이지당 보기수 변경 이벤트
		$("#cboPagePerRow").on("change", function(){
			gridFunctionList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
		});
		
		// 등록 버튼 클릭시 POP-UP
		$("#insertPopup").on("click", function(){
			
			var param = {
				   searchTypeClass : $("#searchTypeClass option:selected").val()
				,  page: 1
			 	, rowPerPage: 30
			 	, sortColKey: "Rsv.common.list"
			 	, sortIndex: 1
			 	, sortOrder:"DESC"
		 		, frmId : "${param.frmId}"
			};
			
			var popParam = {
					url : "<c:url value='/manager/reservation/baseRegion/insertPopup.do' />"
					, width : "1024"
					, height : "900"
					, params : param
					, targetId : "detailPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		});
		
		gridFunctionList.doSearch({page:1});
	});
	
	/** Grid Default Param */
	var defaultParam = {
		  page: 1
	 	, rowPerPage: 30
	 	, sortColKey: "Rsv.common.list"
	 	, sortIndex: 1
	 	, sortOrder:"DESC"
	};
	
	/**
	* 상세보기 버튼 클릭시 POP-UP
	*/
	function detailPopup(seqNumber){
		var param = {
				  seqNumber : seqNumber
				, page: 1
			 	, rowPerPage: 30
			 	, sortColKey: "Rsv.common.list"
			 	, sortIndex: 1
			 	, sortOrder:"DESC"
		};
			
		var popParam = {
				url : "<c:url value = '/manager/reservation/baseRegion/detailPopup.do' />"
				, width : "600"
				, height : "800"
				, params : param
				, targetId : "layer_pop"
		};
		
		window.parent.openManageLayerPopup(popParam);
	}
	
	/**
	* 수정 버튼 클릭시 POP-UP
	*/
	function updatePopup(cityGroupCode, cityGroupName){
		var param = {
				cityGroupCode : cityGroupCode
				, cityGroupName : cityGroupName
				, frmId : "${param.frmId}"
				, page: 1
			 	, rowPerPage: 30
			 	, sortColKey: "Rsv.common.list"
			 	, sortIndex: 1
			 	, sortOrder:"DESC"
		};
			
		var popParam = {
				url : "<c:url value='/manager/reservation/baseRegion/updatePopup.do'/>"
				, width : "1024"
				, height : "670"
				, params : param
				, targetId : "updatePopup"
		};
		
		window.parent.openManageLayerPopup(popParam);
	}
	
	/* 지역군 삭제 */
	function deleteRegionAjax(cityGroupCode){
		var param = {
				citygroupcode : cityGroupCode
		};
		
		var result = confirm("지역군 정보를 삭제 하시겠스니까?");
		if(result){
			$.ajaxCall({
		   		url: "<c:url value = '/manager/reservation/baseRegion/deleteRegionAjax.do' />",
		   		data: param,
		   		method: 'post',
		   		success: function(data, textStatus, jqXHR){
		   			if("success" == data.resultMessage){
			   			alert("삭제 되었습니다.");
			   			gridFunctionList.doSearch();
		   			}else{
		   				var mag = '<spring:message code="errors.load"/>';
		   				alert(mag);
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
		   		}
			});
		}
	}
	
	/** 그리드 object 생성 */
	var mainGrid = new AXGrid(); // instance 상단그리드
	
	/**
	* grid functions
	*/
	var gridFunctionList = {
			
			/** init : 초기 화면 구성 (Grid) */
			init : function() {
				var idx = 0; // 정렬 Index 
				var _colGroup = [
									  {key:"seq", 			label:"No.",		width:"50", 	align:"center", 	sort:false,		formatter:"money" }
									, {key:"citygroupname",		label:"지역군",		width:"100", 	align:"center", 	sort:false 				}
									, {key:"citycount",			label:"행정구역",		width:"150", 	align:"center",		sort:false 				}
									, {key:"modifydatetime",	label:"최종수정일시",	width:"200", 	align:"center", 	sort:false 				}
									, {key:"modifier",			label:"최종수정자",	width:"100", 	align:"center", 	sort:false				}
									, {key:"statusname",		label:"상태",			width:"100", 	align:"center", 	sort:false				}
									, {key:"",					label:"행정구역 상세",	width:"60", 	align:"center",		sort:false,		formatter: function(){
										return "<a href=\"javascript:void(0);\" class=\"btn_green\" onclick=\"javascript:detailPopup('"+this.item.citygroupcode+"')\">보기</a>";
									  }}
									, {key:"",					label:"수정",			width:"60", 	align:"center",		sort:false,		formatter: function(){
										if(param.menuAuth == "W"){
											return "<a href=\"javascript:void(0);\" class=\"btn_green authWrite\" onclick=\"javascript:updatePopup('"+this.item.citygroupcode+"','"+this.item.citygroupname+"')\">수정</a>";
										}else{
											return "";
										}
										
									  }}
// 									, {key:"",					label:"삭제",			width:"60", 	align:"center",		sort:false,		formatter: function(){
// 										return "<a href=\"javascript:void(0);\" class=\"btn_orange\" onclick=\"javascript:deleteRegionAjax('"+this.item.citygroupcode+"')\">삭제</a>";
// 									  }}
								]
				var gridParam = {
						colGroup : _colGroup
						, colHead : { 
							heights: [20,20],
							rows : [
										[
										  {colSeq: 0, rowspan: 2, valign: "middle"}
										, {colSeq: 1, rowspan: 2, valign: "middle"}
										, {colSeq: 2, rowspan: 2, valign: "middle"}
										, {colSeq: 3, rowspan: 2, valign: "middle"}
										, {colSeq: 4, rowspan: 2, valign: "middle"}
										, {colSeq: 5, rowspan: 2, valign: "middle"}
										, {colSeq: 6, rowspan: 2, valign: "middle"}
										, {colSeq: 7, rowspan: 2, valign: "middle"}
// 										, {colSeq: 7, rowspan: 2, valign: "middle"}
										]
									]
							}
						, targetID : "AXGridTarget_${param.frmId}"
						, sortFunc : gridFunctionList.doSortSearch
						, doPageSearch : gridFunctionList.doPageSearch
				}
				
				fnGrid.initGrid(mainGrid, gridParam);
			}, 
			
			/** 페이지 이동 */
			doPageSearch : function(pageNo) {
				// Grid Page List
				gridFunctionList.doSearch({page:pageNo});
			}, 
			
			/** 컬럼 정렬 검색 */
			doSortSearch : function(sortKey){
				// Grid Sort
				defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
				var param = {
						sortIndex : sortKey
						, page : 1
				};
				
				// 리스트 갱신(검색)
				gridFunctionList.doSearch(param);
				
			}, 
			
			doSearch : function(param) {
				
				// search parameters
				var initParam = {
					// NONE
				};
				
				$.extend(defaultParam, param);
				$.extend(defaultParam, initParam);
				
	 		   	$.ajaxCall({
			   		url: "<c:url value='/manager/reservation/baseRegion/regionListAjax.do'/>"
			   		, data: defaultParam
			   		, success: function( data, textStatus, jqXHR){
			   			if(data.result < 1){
			   				var mag = '<spring:message code="errors.load"/>';
			   				alert(mag);
			           		return;
			   			} else {
			   				callbackList(data);
			   			}
			   		},
			   		error: function( jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
			   		}
			   	});			

			   	function callbackList(data) {
			   		
			   		var obj = data; //JSON.parse(data);
			   		//console.log(obj);

			   		// Grid Bind
			   		var gridData = {
				   			list: obj.dataList,
				   			page:{
				   				pageNo: obj.page,
				   				pageSize: defaultParam.rowPerPage,
				   				pageCount: obj.totalPage,
				   				listCount: obj.totalCount
				   			}
				   		};
			   		
			   		// Grid Bind Real
			   		mainGrid.setData(gridData);
			   	}
			   	
			}
			
		}

</script>
</head>

<body class="bgw">

	<div class="contents_title clear">
		<h2 class="fl">지역군정보</h2>
	</div>
	<!-- search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<%--<colgroup>
				<col width="*"  />
				<col width="20%" />
			</colgroup>
			<tr>
				<td scope="row">
				</td>
				<th>
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
				
			</tr>--%>
		</table>
	</div>
	<!-- // search table -->

	<!-- search-area // -->
	<div class="contents_title clear">
		<br/>
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount}"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:void(0);" id="insertPopup" class="btn_green authWrite">등록</a>
		</div>
	</div>
	<!-- // search-area -->

	<!-- grid // -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- // grid -->
	
</body>