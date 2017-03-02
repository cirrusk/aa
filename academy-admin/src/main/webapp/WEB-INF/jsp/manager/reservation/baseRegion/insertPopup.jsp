<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	

/** 
 * global setting
 */
 
/** 
 * 행정구역의 목록 편집 과정중에 index 숫자가 중복이 되거나 하는 상황을 고려해 계속 증가 하도록 하는 값을 설정해 놓고
 * 고유한 넘버링이 될 수 있도록 한다.
 */
var currentIndex = 0;


/* first action */
$(document).ready(function(){

	gridFunctionList.init(function(){
		var param = {
				page : 1,
				cityGroupCode : '${cityGroupCode}'
		};
		//gridFunctionList.doSearch(param);
	});
	
	/** 추가지역 선택영역의 시도선택 select-box event */
	$("#selectCityCode").change(function(){
		getAllCityCodeList.excute($(this).val());
	});
	
	/** 
	* "추가" 버튼 event 
	* 소속행정구역, 추가 지역을 선택 후 추가를 누르면, 
	* 선택된 행정구역 목록에 추가가 된다 - transaction은 없음. 
	*/
	$("#addItemBtn").click(function(){
		buttons.addItemBtn();
	});
	
	/**
	* "저장" 버튼 event
	*/
	$("#saveBtn").click(function(){
		buttons.saveBtn();
	});
});

/** 
 * 화면내 버튼 기능 모음
 */
var buttons = {

	/* 추가버튼 */
	addItemBtn : function(){
		
			/* 
			* 행정구역 및 도시의 편집 목록을 편집 하는 과정에서 중복된 도시가 선택 되어 추가 되더라도
			* 동일한 행정구역 또는 도시가 목록에 나타나지 않도록 필터링을 하는 기능
			*
			* 중복여부 : return
			*			-true : 동일한 값이 있음 
			*			-false : 돌일한 값 없음
			*/
			checkItem = function(item){
				var isDuplication = false;
				
				for(var listCnt = 0 ; listCnt < mainGrid.list.length ; listCnt++){
					
					//console.log(mainGrid.list[listCnt].regioncode);
					//console.log(item.regioncode);
					//console.log(mainGrid.list[listCnt].citycode);
					//console.log(item.citycode);
					
					var gridRegionCode = (mainGrid.list[listCnt].regioncode == undefined ) ? '' : mainGrid.list[listCnt].regioncode;
					var regionCode = (item.regioncode == undefined) ? '' : item.regioncode;
					var gridCityCode = (mainGrid.list[listCnt].citycode == undefined) ? '' : mainGrid.list[listCnt].citycode; 
					var cityCode = (item.citycode == undefined) ? '' : item.citycode;

					//console.log("gr " + gridRegionCode);
					//console.log("r  " + regionCode);
					//console.log("gc " + gridCityCode);
					//console.log("c  " + cityCode);
					//console.log("---------------------");
					
					if (gridRegionCode == regionCode && gridCityCode == cityCode){
						isDuplication = true;
						break;
					}
				}
				return isDuplication;
			}
		
			/* 행정구역 추가 */
			$("#regionCodeListArea input[name='regionCode']input[type='checkbox']:checked").each(function(){
				
				//console.log(":: " + $(this).val());
				//console.log(":: " + $(this).parent().children("span").text());
				
				//console.log(":: " + mainGrid.list.getMaxObject("colseq"));
				
				var checkedRegionCode = $(this).val();
				var checkedRegionName = $(this).parent().children("span").text();
				
				var checkedItem = {
						colseq : currentIndex,
						regioncode : checkedRegionCode,
						regionname : checkedRegionName,
						citycode : '',
						cityname : ''
				}
				
				if(!checkItem(checkedItem)){
					mainGrid.pushList(checkedItem);
					currentIndex++;
				}
				
			});
			
			/* 행정구역외 추가 지역 */
			var selectedRegionObject = {name : $("#selectCityCode :selected").text(), code : $("#selectCityCode :selected").val()}
			
			$("#cityListArea input[name='cityCode']input[type='checkbox']:checked").each(function(){
				
				var checkedCityCode = $(this).val();
				var checkedCityName = $(this).parent().children("span").text();
				
				var checkedItem = {
						/* colseq : mainGrid.list.length + 1, */
						colseq : currentIndex,
						regioncode : selectedRegionObject.code,
						regionname : selectedRegionObject.name, 
						citycode : checkedCityCode,
						cityname : checkedCityName
				}
				
				if(!checkItem(checkedItem)){
					mainGrid.pushList(checkedItem);
					currentIndex++;
				}
				
			});
	},
	
	/* 저장버튼 */
	saveBtn : function(){
		
			if( 0 >= $("#cityGroupName").val().length ){
				alert("지역군명은 필수 값입니다.");
				$("#cityGroupName").focus();
				return;
			}
			
			if( 0 == $(".AXGridBody tr.gridBodyTr").length ) {
				alert("행정구역 또는 도시를 추가 해야 합니다.");
				return;
			}

			var gridData = mainGrid.getExcelFormat('json');
			gridData.cityGroupInfo = {"cityGroupCode" : "${cityGroupCode}", "cityGroupName" : $("#cityGroupName").val(), "statusCode" : $("#statusCode").val()};

			var grid2json = Object.toJSON(gridData).replace(/\\u009/g,'');
			//console.log(grid2json);
			
			$.ajaxCall({
		   		url: "<c:url value = '/manager/reservation/baseRegion/regionDetailInsertAjax.do' />",
		   		data: {grid:grid2json},
		   		method: 'post',
		   		success: function(data, textStatus, jqXHR){
		   			
		   			if("success" == data.resultMessage){
			   			alert("저장 되었습니다.");
// 			   			$('#ifrm_main_${frmId}')[0].contentWindow.gridFunctionList.doSearch({page:1});
						var frmId = $("input[name='frmId']").val();
						eval($('#ifrm_main_'+frmId).get(0).contentWindow.gridFunctionList.doSearch({page:1}));
						
			   			$("#closeBtn").click();
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
	},
	
	/* 삭제버튼 */
	deleteItemBtn : function(_index){
			var itemList = [];
			var item = mainGrid.list[_index];
			//console.log(item);
			
			itemList.push({index:_index});
			//mainGrid.removeList(itemList);
			mainGrid.removeListIndex(itemList);
	} 
} 

/**
 * 행정구역으로 도시 목록 정보를 얻어오는 기능
 */
var cityListHtml = "";

var getAllCityCodeList = {
		
		
	init : function(){},
	
	excute : function(regionCode){
		$.ajaxCall({
	   		url: "<c:url value = '/manager/reservation/baseRegion/allCityCodeListAjax.do' />"
	   		, data: {"regionCode" : regionCode}
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.cityCodeList){
	   				//console.log(data.cityCodeList);
	   				
	   				cityListHtml = "";
	   				$("#cityListArea").html(cityListHtml);
	   				
	   				/*
	   				$.each(data.cityCodeList, function(i, item){
	   					cityListHtml 	+=
	   									+=	" <div style='border:1px; float:left; padding:5px; height:20px;'> "
	   									+=	" <input type='checkbox' id='cityCode' name='cityCode' value='" + item.code + "' /> "
	   									+=	item.name
	   									+=	" </div> ";
	   				})
	   				*/
	   				
	   				var forObject = data.cityCodeList;
	   				for(var item in forObject){
	   					if(forObject[item].code != null){
		   					cityListHtml 	+=	" <div style='border:1px; float:left; padding:5px; height:20px;'> "
											+	" <input type='checkbox' id='cityCode' name='cityCode' value='" + forObject[item].code + "' /> "
											+	" <span>" + forObject[item].name + "</span> "
											+	" </div> ";
	   					}
	   				}
	   				
	   				//console.log(cityListHtml);
	   				$("#cityListArea").html(cityListHtml);
	   			}else{
	   				var mag = '<spring:message code="errors.load"/>';
	   				alert(mag);
	           		return;
	   			}
	   			
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
	   		}
	   	});
	}
}

/** Grid Default Param */
var defaultParam = {
		page: 1
		, rowPerPage: 30
		, sortColKey: "Rsv.common.list"
		, sortIndex: 1
		, sortOrder:"DESC"
};

/** 그리드 object 생성 */
var mainGrid = new AXGrid(); // instance 상단그리드

/**
* grid functions
*/
var gridFunctionList = {
		
	/** init : 초기 화면 구성 (Grid) */
	init : function(callbackSearch) {
		var idx = 0; // 정렬 Index 
		var _colGroup = [
							{key:"regionname",		label:"시도",		width:"100", 	align:"center",		sort:false	},
							{key:"cityname",		label:"군구",		width:"120", 	align:"center",		sort:false	},
							{key:"",				label:"삭제",		width:"80", 	align:"center",		sort:false, 	formatter: function(){
								return "<a href=\"javascript:void(0);\" class=\"btn_green\" onclick=\"javascript:buttons.deleteItemBtn('"+this.index+"')\">삭제</a>";
							}}
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
								]
							]
					}
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : gridFunctionList.doSortSearch
				, doPageSearch : gridFunctionList.doPageSearch
		}
		
		fnGrid.initGrid(mainGrid, gridParam);
		
		if (typeof callbackSearch === "function" ){
			callbackSearch();
		}
		
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
		};
		
		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);
		
		$.ajaxCall({
	   		url: "<c:url value = '/manager/reservation/baseRegion/regionDetailListAjax.do' />"
	   		, data: defaultParam
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.cityGroupDetailList){
	   				callbackList(data);
	   			}else{
	   				var mag = '<spring:message code="errors.load"/>';
	   				alert(mag);
	           		return;
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
		   			list: obj.cityGroupDetailList,
		   			page:{
		   				pageNo: obj.page,
		   				pageSize: defaultParam.rowPerPage,
		   				pageCount: obj.totalPage,
		   				listCount: obj.totalCount
		   			}
		   		};
	   		
	   		// Grid Bind Real
	   		mainGrid.setData(gridData);
	   		
	   		currentIndex = mainGrid.list.length + 1;
	   	}
	   	
	}
	
}

</script>
</head>

<body>
	<div id="popwrap">
		<input type="hidden" name="frmId" value="${frmId}"/>
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">지역군 등록</h2>
			<span class="fr"><a href="javascript:;" class="close-layer btn_close">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer">
			<div id="popcontent" style="height:510px;">
				<div class="tbl_body" style="width:624px;float: left;">
					<b>지역군명 등록/수정</b>
					<div class="tbl_write" style="width:624px;">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="20%">
								<col width="30%">
								<col width="20%">
								<col width="30%">
							</colgroup>
							<tbody>
								<tr>
									<th>지역군명</th>
									<td>
										<input type="hidden" id="cityGroupCode" name="cityGroupCode" value="${cityGroupCode}" />
										<input type="text" id="cityGroupName" name="cityGroupName" maxlength="30" size="30" value="${cityGroupName}"/>
									</td>
									<th>사용유무</th>
									<td>
										<select id="statusCode" name="statusCode" style="width:auto; min-width:100px" >
											<option value="B01">사용중</option>
											<option value="B02">사용안함</option>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<b>소속 행정구역 선택</b>
					<div class="tbl_write" style="width:624px;">
						<div id="regionCodeListArea" style="width:100%; height:100px;background-color:#f7f7f7;">
							<c:forEach var="item" items="${regionCodeList}">
								<div style="border:1px; float:left; padding:5px; height:20px;">
									<input type="checkbox" id="regionCode" name="regionCode" value="${item.code}" />
										<span>${item.name}</span>
								</div>
							</c:forEach>
						</div>
					</div>
					
					<b>추가 지역 선택 (시/군 단위)</b>
					<div class="tbl_write" style="width:624px;">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="20%">
								<col width="80%">
							</colgroup>
							<tbody>
								<tr>
									<th>시도선택</th>
									<td>
										<select id="selectCityCode" name="selectCityCode" style="width:auto; min-width:100px" >
											<option value="">선택</option>
											<c:forEach var="item" items="${regionCodeList}">
												<option value="${item.code}">${item.name}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<div id="cityListArea" style="width:100%; height:200px;background-color:#f7f7f7;">
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="btnwrap clear">
						<a href="javascript:;" id="addItemBtn" class="btn_green">추가</a>
					</div>
					
				</div>
				<div class="tbl_write" style="width:300px;height:460px;float: right;">
				
					<b>선택된 행정구역</b>
					<!-- grid // -->
					<div id="AXGrid">
						<div id="AXGridTarget_${param.frmId}"></div>
					</div>
					<!-- // grid -->
				
				</div>
				<div class="btnwrap clear">
					<a href="javascript:;" id="saveBtn" class="btn_green">저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_gray close-layer">닫기</a>
				</div>
			</div>
		</div>
		
	</div>
</body>