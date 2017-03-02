<!-- 교욱비 서약서 !! -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var trainingFeeWrittenGrid = new AXGrid(); // instance 상단그리드


//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount}"
 	, sortColKey: "trainingfee.agree.agree"
 	, sortIndex: 1
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	trainingFeeWritten.init();
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeWritten.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	$("#writtenInsert").on("click", function(){
		trainingFeeWritten.listClick("insert","");
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeWritten.doSearch({page:1});
	});
});

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

var trainingFeeWritten = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
							, {key:"fiscalyear", label:"회계연도", width:"300", align:"center"}
							, {key:"agreetitle", addClass:idx++, label:"교육비 제3자 동의서 제목", width:"500", align:"center", formatter: function () {
								return "<a href=\"javascript:;\" onclick=\"javascript:trainingFeeWritten.listClick('list','" + this.item.agreeid + "');\">"+this.item.agreetitle+"</a>";
							}}
							, {key:"agreeid", addClass:idx++, label:"버전", width:"100", align:"center"}
							, {key:"registrant", addClass:idx++, label:"등록자", width:"200", align:"center"}
							, {key:"registrantdate", addClass:idx++, label:"등록일", width:"350", align:"center"}
						]
			
			var gridParam = {
					  colGroup : _colGroup
					, fitToWidth : true
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeWritten.doSortSearch
					, doPageSearch : trainingFeeWritten.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeWrittenGrid, gridParam);
			trainingFeeWritten.doSearch({page:1});
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			trainingFeeWritten.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeWritten.doSearch(param);
		}, doSearch : function(param) {
			// Param 셋팅(검색조건)
			var initParam = {
					fiscalyear    : $("#searchGiveYear").val()	
				  , agreetypecode : "300"
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/agree/trainingFeeWrittenSearch.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			var obj = data; //JSON.parse(data);

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
			   		trainingFeeWrittenGrid.setData(gridData);
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});
		},
		listClick : function(type, agreeid) {
			var param = {
					fiscalyear    : $("#searchGiveYear").val()	
				  , agreetypecode : "300"
				  , agreetypename : "제3자동의"
				  , type : type
				  , agreeid : agreeid
				  , frmId    : "${param.frmId}"
				};
			
			var popParam = {
					  url : "<c:url value="/manager/trainingFee/agree/trainingFeeWrittenEdit.do" />"
					, width    : "780"
					, height   : "570"
					, params   : param
					, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		}
	}
function doReturn() {
	trainingFeeWritten.doSearch({page : 1});
}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교육비 제3자동의서</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">약관문서관리</a></li>
				<li class="end"><a href="#">교육비 제3자동의서</a></li>
			</ul>
		</div>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*"  />
				<col width="10%" />
				<col width="30%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th scope="row">회계연도</th>
				<td>
					<input type="text" id="searchGiveYear" name="datepYear" class="AXInput datepYear setFiscalYear" readonly="readonly">
				</td>
				
				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
		</table>
	</div>
	
	<div class="contents_title clear">
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" id="writtenInsert" class="btn_green authWrite">등록</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>