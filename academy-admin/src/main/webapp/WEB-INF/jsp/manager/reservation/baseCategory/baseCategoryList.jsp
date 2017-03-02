<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>


<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">	

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: 30
 	, sortColKey: "Rsv.common.list"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	
    param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
    
    if(param.menuAuth == "W"){
        $(".authWrite").show();
    }else{
        $(".authWrite").hide();
    }
    
	baseCategoryList.init();
	baseCategoryList.doSearch();
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		baseCategoryList.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		baseCategoryList.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	// 등록 버튼 클릭시
	$("#abaseCategoryInsert").on("click", function(){
		var popParam = {
				url : "<c:url value='/manager/reservation/baseCategory/baseCategoryInsertPop.do' />"
				, width : "512"
				, height : "450"
 				, params : {categoryseq : 0
				, frmId  : "${param.frmId}"}
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});
});

var popupFrame = {
		/* 등록 */
		insertPopup : function(categoryseq) {
			var popParam = {
					url : "<c:url value='/manager/reservation/baseCategory/baseCategoryInsertPop.do' />"
					, width : "512"
					, height : "400"
					, params : {categoryseq : categoryseq
					, frmId  : "${param.frmId}"}
					, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		},

		/* 수정 */
		updatePopup : function(categoryseq) {
			var popParam = {
					url : "<c:url value='/manager/reservation/baseCategory/baseCategoryUpdatePop.do' />"
					, width : "512"
					, height : "400"
					, params : {categoryseq : categoryseq
					, frmId  : "${param.frmId}"}
					, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		}		
		
};

//Grid Init
var baseCategoryListGrid = new AXGrid(); // instance 상단그리드

var baseCategoryList = {
		
	/** init : 초기 화면 구성 (Grid) */
	init : function() {
		
		var idx = 0; // 정렬 Index 
		var _colGroup = [
						  {key:"row_num", 						label:"No", width:"50", align:"center", formatter:"money", sort:false}
						, {key:"categoryname1", 				label:"카테고리1", width:"100", align:"center", sort:false}
						, {key:"categoryname2", addClass:idx++, label:"카테고리2", width:"150", align:"center", sort:false}
						, {key:"categoryname3", addClass:idx++, label:"카테고리3", width:"150", align:"center", sort:false}
						, {key:"realfilename", addClass:idx++, label:"동록 파일명", width:"200", align:"center", formatter: function(){
							if(param.menuAuth == "W"){
							 	return "<a href=\"javascript:;\" onclick=\"javascript:baseCategoryList.fileDownload('" + this.item.filekey + "','" + this.item.uploadseq + "')\">"+isNvl(this.item.realfilename,"")+"</a>";
							}else{
								return this.item.realfilename;
							}
						  }}
						, {key:"updatedate", 	addClass:idx++, label:"최종수정일시", width:"200", align:"center", sort:false}
						, {key:"updateuser", 	addClass:idx++, label:"최종수정자", width:"100", align:"center", sort:false}
						, {key:"statusname", 	addClass:idx++, label:"상태", width:"100", align:"center", sort:false}
						, {key:"btns",			addClass:idx++, label:"수정", width:"230", align:"right", sort:false
								, formatter: function(){
										var buttonStr = "";
										if(3 != this.item.typelevel && (this.item.categorytype2 == "" || this.item.categorytype2 == "E0301")){
											buttonStr += "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javasctipt:popupFrame.insertPopup(" + this.item.categoryseq + ")\">하위 카테고리 등록</a>";
										}
										buttonStr += "<a href=\"javascript:;\" class=\"btn_green authWrite\" onclick=\"javasctipt:popupFrame.updatePopup('" + this.item.categoryseq + "')\">수정</a>";
										
										if(param.menuAuth == "W"){
											return buttonStr;
										}else{
											return "";
										}
														
						  		}		
						  }
					]
		
		var gridParam = {
				colGroup : _colGroup
				, fitToWidth: true
				, targetID : "AXGridTarget_${param.frmId}"
				, sortFunc : baseCategoryList.doSortSearch
				, doPageSearch : baseCategoryList.doPageSearch
			}
		
		fnGrid.initGrid(baseCategoryListGrid, gridParam);
		
	}, 
	
	doPageSearch : function(pageNo) {
		
		// Grid Page List
		baseCategoryList.doSearch({page:pageNo});
		
	}, 
	
	doSortSearch : function(sortKey){
		
		// Grid Sort
		defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
		var param = {
				sortIndex : sortKey
				, page : 1
		};
		
		// 리스트 갱신(검색)
		baseCategoryList.doSearch(param);
		
	}, 
	
	doSearch : function(param) {
		// console.log(">>" + $("#statuscode option:selected").val());
		// Param 셋팅(검색조건)
		var initParam = {
			statuscode : $("#statuscode option:selected").val()
		};
		
		$.extend(defaultParam, param);
		$.extend(defaultParam, initParam);
		
	   	$.ajaxCall({
	   		url: "<c:url value='/manager/reservation/baseCategory/baseCategoryListAjax.do'/>"
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
	   		baseCategoryListGrid.setData(gridData);
	   	}
	},
	fileDownload : function(fileKey, uploadSeq){
		var param = {
				work : "RSVBRAND"
				, fileKey : fileKey
				, uploadSeq : uploadSeq
		};

    	postGoto("<c:url value="/manager/common/trfeefile/trfeeFileDownload.do"/>", param);	
	}
}
function doReturn() {
	baseCategoryList.doSearch({page : 1});
}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">브랜드카테고리관리</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*"  />
				<col width="20%" />
			</colgroup>
			<tr>
				<th>상태</th>
				<td scope="row">
					<select id="statuscode" name="statuscode" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="item" items="${useStateCodeList}">
							<option value="${item.commonCodeSeq}">${item.codeName}</option>
						</c:forEach>
					</select>
				</td>
				
				<th>
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
				
			</tr>
			
		</table>
	</div>

	<div class="contents_title clear">
		<br/>
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount}"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" id="abaseCategoryInsert" class="btn_green authWrite">카테고리1 등록</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
	<!-- Board List -->
		
</body>