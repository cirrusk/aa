<!-- Special 위임 Proposal!! -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
//Grid Init
var trainingFeeSpecialLogGrid = new AXGrid(); // instance 상단그리드
var lpageNo = 1;

//Grid Default Param
var defaultParam = {
	  page: lpageNo
 	, rowPerPage: "${rowPerCount}"
 	, sortColKey: "trainingfee.agree.agreelist3"
 	, sortIndex: 0
 	, sortOrder:"DESC"
};

$(document.body).ready(function(){
	trainingFeeSpecialLog.init();
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeSpecialLog.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
});

function fn_init() {
// 	fn_setClassYear();
// 	doSearch();
}

var trainingFeeSpecialLog = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"row_num", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
			                        return this.item.___checked && this.item.___checked["1"];
			             	}}	
							, {key:"row_num", addClass:idx++, label:"No.", width:"40", align:"center", sort:false}
						    , {key:"fiscalyear", addClass:idx++, label:"회계 연도", width:"100", align:"center"}
							, {key:"registrantdate", addClass:idx++, label:"등록일", width:"200", align:"center"}
							, {key:"registrant", addClass:idx++, label:"동록자", width:"200", align:"center"}
							, {key:"realfilename", addClass:idx++, label:"동록 파일명", width:"700", align:"center", formatter: function(){
							 	return "<a href=\"javascript:;\" onclick=\"javascript:trainingFeeSpecialLog.fileDownload('" + this.item.attachfile + "','" + this.item.uploadseq + "')\">"+isNvl(this.item.realfilename,"")+"</a>";
							  }}
							, {key:"specialid", addClass:idx++, label:"등록버튼", width:"0", align:"center"}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeSpecialLog.doSortSearch
					, doPageSearch : trainingFeeSpecialLog.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeSpecialLogGrid, gridParam);
			trainingFeeSpecialLog.doSearch({page:"1"});
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			lpageNo = pageNo;
			trainingFeeSpecialLog.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : lpageNo
			};
			
			// 리스트 갱신(검색)
			trainingFeeSpecialLog.doSearch(param);
		}, doSearch : function(param) {
			
			$.extend(defaultParam, param);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/agreelist/selectSpecialLog.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		           		alert("처리도중 오류가 발생하였습니다.");
		           		return;
		   			} else {
		   				callbackList(data);
		   			}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});			

		   	function callbackList(data) {
		   		
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
		   		trainingFeeSpecialLogGrid.setData(gridData);
		   	}
		},
		fileUpload : function(fiscalyear){
			var param = {
					fiscalyear : fiscalyear
					, frmId : "${param.frmId}"
			};
			
			var popParam = {
					url : "<c:url value="/manager/trainingFee/agreelist/trainingFeeAgreeSpecialLogFile.do"/>"
					, width : "700"
					, height : "300"
					, params : param 
					, targetId : "searchPopup"
			}
			
			window.parent.openManageLayerPopup(popParam);
		},
		fileDownload : function(fileKey, uploadSeq){
			var param = {
					work : "ADMINTRFEE"
					, fileKey : fileKey
					, uploadSeq : uploadSeq
			};

	    	postGoto("/manager/common/trfeefile/trfeeFileDownload.do", param);
// 	    	postGoto("<c:url value="/manager/common/trfeefile/trfeeFileDownload.do"/>", param);	
		},
		logDelete : function(){
			var checkedfiscalyear = "";
			var checkedspecialid  = "";
			var checkedList = trainingFeeSpecialLogGrid.getCheckedListWithIndex(0);// colSeq
			
			for(var i = 0; i < checkedList.length; i++){
				if(i == 0){
					checkedfiscalyear = checkedList[i].item.fiscalyear;
					checkedspecialid  = checkedList[i].item.specialid;
				} else {
					checkedfiscalyear = checkedfiscalyear+","+checkedList[i].item.fiscalyear;
					checkedspecialid  = checkedspecialid+","+checkedList[i].item.specialid;
				}
			}
			
			if($.trim(checkedfiscalyear).length == 0){
				alert("선택된 Special위임내역이 없습니다.");
				return;
			}
			
			var result = confirm("선택한 Special위임내역을 삭제 하시겠습니까?"); 
			
			if(result) {
				var param = {
						 fiscalyear : checkedfiscalyear
						,specialid  : checkedspecialid
					};
				
				if(result) {
					$.ajaxCall({
						method : "POST",
						url : "<c:url value="/manager/trainingFee/agreelist/trainingFeeAgreeSpecialLogDelete.do"/>",
						dataType : "json",
						data : param,
						success : function(data, textStatus, jqXHR) {
							if (data.result.errCode < 0) {
								alert("처리도중 오류가 발생하였습니다.");
							}else{
								trainingFeeSpecialLog.doSearch();
								alert("Special위임내역 삭제를 완료 하였습니다.");
							}
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alert("처리도중 오류가 발생하였습니다.");
						}
					});
				}
			}
		}
	}
	
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">Special 위임  Proposal</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">약관동의현황</a></li>
				<li class="end"><a href="#">Special위임내역</a></li>
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
		</table>
	</div>
			
	<div class="contents_title clear">
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>
		</div>
		<div class="fr">
			<a href="javascript:;" class="btn_green authWrite" onclick="javascript:trainingFeeSpecialLog.logDelete()">위임동의삭제</a>
			<a href="javascript:;" class="btn_green authWrite" onclick="javascript:trainingFeeSpecialLog.fileUpload('')">위임동의저장</a>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>