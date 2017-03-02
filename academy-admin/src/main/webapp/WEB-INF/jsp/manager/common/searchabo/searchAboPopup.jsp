<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
	
	<script type="text/javascript">
		var layerAboGrid = new AXGrid();
		
		var defaultParam = {
				  page: 1
			 	, rowPerPage: 10
			 	, sortColKey: "trainingfee.abo.abolist"
			 	, sortIndex: 1
			 	, sortOrder:"DESC"
			};
		
		$(document).ready(function(){
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
							, {key:"uid", addClass:idx++, label:"ABO 번호", width:"100", align:"center"}
							, {key:"name", addClass:idx++, label:"ABO 이름", width:"150", align:"center"}
							, {key:"groupsname", addClass:idx++, label:"C.Pin", width:"200", align:"center"}
							, {key:"rtninputnm", addClass:idx++, label:"return", width:"0", align:"center", sort:false}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, targetID : "AXGrid_ABO"
					, sortFunc : layerDoSortSearch
					, doPageSearch : layerDoPageSearch
					, body: {
                        ondblclick: function (idx, item) {
                        	layerAbo.doReturnValue(this.item);
                        }
                    }
				}
			
			fnGrid.initGrid(layerAboGrid, gridParam);
			
			$("#btnSearch").on("click", function(){
				layerAbo.doSearch({page:1});
			});
			
			$(".btn_close").on("click", function(){
				var rtnFrmId = $("input[name='rtnFrmId']").val();
                closeManageLayerPopup("searchAbo",rtnFrmId);
			});
		});
		
		function layerDoSortSearch(sortKey) {
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			layerAbo.doSearch(param);
		}
		
		function layerDoPageSearch(pageNo) {
			layerAbo.doSearch({page:pageNo});
		}
		
		var layerAbo = {
				/** init : 초기 화면 구성 (Grid)
				*/
				doSearch : function(param) {
					// Param 셋팅(검색조건)
					var initParam = {
								searchType : $("#SearchTypeAbo").val()	
							  , searchName : $("#SearchAboName").val()
							  , rtnInputNm : $("#rtnInputNm").val()							  
					};
					
					$.extend(defaultParam, param);
					$.extend(defaultParam, initParam);
					
		 		   	$.ajaxCall({ 		   		
				   		url: "<c:url value="/manager/common/searchabo/searchAboList.do"/>"
				   		, data: defaultParam
				   		, success: function( data, textStatus, jqXHR){
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
					   		layerAboGrid.setData(gridData);
				   		},
				   		error: function( jqXHR, textStatus, errorThrown) {
							var msg = '<spring:message code="errors.load"/>';
							alert(msg);
				   		}
				   	});			
				},
				doReturnValue : function(param) {
					var rtnFrmId = $("input[name='rtnFrmId']").val();
					
                    if($("body").find(".modalBg").length == 1){ // Iframe에서 호출한 경우
                    	eval($('#ifrm_main_'+rtnFrmId).get(0).contentWindow.doReturnValue(param));
            		} else {// 2번째 팝업일 경우
            			doReturnValue(param);
            		}
            		
                    closeManageLayerPopup("searchAbo",rtnFrmId);
				}
			}
	</script>
</head>	
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">ABO 검색</h2>
			<span class="fr"><a href="javascript:;" class="btn_close">X</a></span>
		</div>
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<div class="tbl_write1">
					<input type="hidden" name="rtnFrmId" value="${lyData.frmId }" />
					<input type="hidden" id="rtnInputNm" name="rtnInputNm" value="${lyData.inputNm }" />
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="10%" />
							<col width="80"  />
							<col width="20%" />
						</colgroup>
						<tr>
							<th>ABO</th>
							<td>
								<select id="SearchTypeAbo" style="width:auto; min-width:100px" >
									<option value="1" <c:if test="${lyData.searchType eq '1' }">selected</c:if> >ABO 번호</option>
									<option value="2" <c:if test="${lyData.searchType eq '2' }">selected</c:if>>ABO 이름</option>
								</select>
								<input type="text" id="SearchAboName" name="SearchAboName" style="width:auto; min-width:200px" value="${lyData.searchName }">
							</td>
							<th>
								<div class="btnwrap1 mb10">
									<a href="javascript:;" id="btnSearch" class="btn_gray btn_big30">검색</a>
								</div>
							</th>
						</tr>
					</table>
				</div>
				<span style="font-size:14px;">* 선택 할 ABO를 더블 클릭 해주세요.</span>
				<!-- grid -->
				<div id="AXGrid">
					<div id="AXGrid_ABO"></div>
				</div>
			</div>
			<div class="btnwrap clear">
				<a href="javascript:;" id="btnLayClose" class="btn_gray btn_close" >닫기</a>
			</div>
		</div>
	</div>