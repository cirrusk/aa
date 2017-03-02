<!-- 교육비 사전 교육 계획서!! -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">
var localFrmId        = "";
var localMenuAuth     = "";
var localparam = {};
//Grid Init
var trainingFeeRentGrid = new AXGrid(); // instance 상단그리드


//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "100" 
 	, sortColKey: "trainingfee.proof.rentdtlG"
 	, sortIndex: 1
 	, sortOrder:"ASC"
};

$(document.body).ready(function(){
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeRent.doSearch({page:1});
	});
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		return;
	});
	
	$("#ifrm_main_${param.frmId}", parent.document).height("1450");
	
	fn_init();
	
});

function fn_init() {
	localparam= { fiscalyear:window.parent.g_managerLayerMenuId.sessionOnFiscalYear
			    , depabo_no:window.parent.g_managerLayerMenuId.sessionOnAboNo
	            , rentid:window.parent.g_managerLayerMenuId.sessionOnRentId
	            , groupcode:window.parent.g_managerLayerMenuId.sessionOnRentGroupCode
	            , renttype:"group"
            	,pageID : "${param.frmId}"
	            , frmId    :"${param.frmId}"};
	
	localFrmId        = window.parent.g_managerLayerMenuId.sessionOnFrmId;
	localMenuAuth     = window.parent.g_managerLayerMenuId.sessionOnMenuAuth;
	authButton(param={frmId:localFrmId,menuAuth:localMenuAuth});
	
	$.ajaxCall({
   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeRentDetailInfo.do"/>"
   		, data: localparam
   		, success: function( data, textStatus, jqXHR){
   				$("#txtfiscalyear").text(data.rentData.fiscalyear);
   				$("#txtAboNo").text(data.rentData.depabo_no);
   				$("#txtAboName").text(data.rentData.depaboname);
   				$("#txtFromMonth").text(data.rentData.rentfrommonth);
   				$("#txtToMonth").text(data.rentData.renttomonth);
   				$("#rentdeposit").text(data.rentData.rentdeposit);
  				$("#rentamount").text(data.rentData.rentamount);
//   				$("#rentdeposit5").text(data.rentData.rentdeposit5);
//   				$("#rentdeposit12").text(data.rentData.rentdeposit12);
  				$("#btnCheckFlag").val(data.rentData.checkflag);
  				$("#btnRentStatus").val(data.rentData.rentstatus);
  				$("#rentstatus").text(data.rentData.rentstatustxt);

  				trainingFeeRent.init();
   				trainingFeeRent.doSearch(localparam);
   				trainingFeeRent.imgLoading(data.imgData);
   				btnEvent.imgCheck();
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("[info] 처리도중 오류가 발생하였습니다.");
   		}
   	});	
}

var trainingFeeRent = {
		/** init : 초기 화면 구성 (Grid)
		*/
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							  {key:"depabo_no", label:"ABO 번호", width:"100", align:"center", sort:false}
							, {key:"depaboname", addClass:idx++, label:"ABO 이름", width:"150", align:"right"}
							, {key:"trfee", addClass:idx++, label:"교육비", width:"150", align:"right", formatter:"money"}
							, {key:"trfeerate", addClass:idx++, label:"비율", width:"150", align:"right", formatter:"money"}
							, {key:"rentdepositratepay", addClass:idx++, label:"월 보증금", width:"150", align:"right", formatter: function(){
								var money = isNvl(this.item.rentdepositratepay,"0");
								if(!isNull(this.item.rentdepositratepay)) money = money.replace(".0","");
								return setComma(money);	
							}}
							, {key:"rentamountratepay", addClass:idx++, label:"월 임대료", width:"150", align:"right", formatter: function(){
								var money = isNvl(this.item.rentamountratepay,"0");
								if(!isNull(this.item.rentamountratepay)) money = money.replace(".0","");
								return setComma(money);	
							}}
							, {key:"totalamount", addClass:idx++, label:"총합계", width:"150", align:"right", formatter: function(){
								var money = isNvl(this.item.totalamount,"0");
								if(!isNull(this.item.totalamount)) money = money.replace(".0","");
								return setComma(money);	
							}}
						]
						
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: true
					, height:"630px"
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeRent.doSortSearch
					, doPageSearch : trainingFeeRent.doPageSearch
				}
			
			fnGrid.nonPageGrid(trainingFeeRentGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			trainingFeeRent.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
		}, doSearch : function(param) {
			
			$.extend(defaultParam, param);
			
 		   	$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeRentGrpDetailListAjax.do"/>"
		   		, data: defaultParam
		   		, success: function( data, textStatus, jqXHR){
		   				callbackList(data);
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("[조희] 처리도중 오류가 발생하였습니다.");
		   		}
		   	});			

		   	function callbackList(data) {
		   		
		   		var obj = data; //JSON.parse(data);
		   		
				if(obj.dataList.length>0) {
			   		// Grid Bind
			   		var gridData = {
			   				list: obj.dataList
				   		};			   		
			   		
			   		// Grid Bind Real
			   		trainingFeeRentGrid.setData(gridData);
			   		
			   		// 화면 상단 셋팅
			   		var item = obj.dataList[0];
			   		
	// 		   		$("#txtDept").text(item.depositpay);
			   		$("#txtFromMonth").text(item.rentfrommonth);
			   		$("#txtToMonth").text(item.renttomonth);
				} else {
					var gridNullData = {
				   			list: {},
				   			page:{
				   				pageNo: 1,
				   				pageSize: defaultParam.rowPerPage,
				   				pageCount: 0,
				   				listCount: 0
				   			}
				   		};
			   		
					trainingFeeRentGrid.setData(gridNullData);
					alert("지급 대상자가 선정 되어 있지 않습니다.");
				}
		   	} 
		}, doApprove : function() {
			var result = confirm("임차료(그룹) 승인 처리 하시겠습니까?"); 
		
			if(result) {
		
				$.ajaxCall({
					url: "<c:url value="/manager/trainingFee/proof/trainingFeeRentDetailGrpConfrim.do"/>"
					, data: localparam
					, success: function(data, textStatus, jqXHR){
						if (data.result.errCode < 1) {
							fn_init();
			        		alert(data.result.errMsg);
			        		return;
						} else {
							if (data.result.errCode == 100) {
								alert(data.result.errMsg);
							} else {
								callbackList(data);	
							}
						}
					},
					error: function( jqXHR, textStatus, errorThrown) {
			           	alert("처리도중 오류가 발생하였습니다.");
					}
				});
				
				function callbackList(data) {
					if(parseInt(data.result.errCode)>0){
						$("#btnRentStatus").val("Y");
						alert("저장 완료 되었습니다.");
					} else {
						alert("저장 중 오류가 발생 하였습니다.");
					}
				}
				
			}
		}, doReject : function() {
			
			var popParam = {
					url : "<c:url value="/manager/trainingFee/proof/trainingFeeRentRejectPop.do"/>"
					, width : "800"
					, height : "500"
					, params : localparam
					, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		}, imgLoading : function(img) {
			var imgHtml = "";
			var chkData = {
					"chkFile" : "jpg, jpeg, png, gif, JPG, JPEG, PNG, GIF"
			};
			
			$.each(img, function (i,val) {
				if(i==0) {
					imgHtml += "<div id='img"+(i+1)+"'>";					
				} else {
					imgHtml += "<div id='img"+(i+1)+"' style='display:none;'>";
				}
				var ext = val.fileext;
				var opts = $.extend({},chkData);
				
				if(opts.chkFile.indexOf(ext) == -1) {
					imgHtml += "<a href=\"javascript:;\" onclick=\"javascript:trainingFeeRent.fileDownload('" + val.filekey + "','" + val.uploadseq + "')\">"+isNvl(val.realfilename,"")+"</a>";
				} else {
					imgHtml += "<a href=\"javascript:;\" onclick=\"javascript:trainingFeeRent.fileDownload('" + val.filekey + "','" + val.uploadseq + "')\"><img src='/manager/trainingFee/proof/imageView.do?filefullurl="+val.filefullurl+"&storefilename="+val.storefilename+"' width='400px;' style='max-height:460px;'></a>";
				}
				imgHtml += "</div>";
			});
			$("#totpage").text(img.length);
			$("#img").html(imgHtml);
		},
		fileDownload : function(fileKey, uploadSeq){
			var param = {
					work : "TRFEE"
					, fileKey : fileKey
					, uploadSeq : uploadSeq
			};

	    	postGoto("/manager/common/trfeefile/trfeeFileDownload.do", param);	
		}
	}
	
var btnEvent = {
		btnNext : function() {
			var num = parseInt($("#pagenum").text());
			var totnum = parseInt($("#totpage").text());
			var sTag = "";
			
			if( parseInt($("#totpage").text()) < (num + 1) ) {
				alert("영수증이 존재 하지 않습니다.");
			} else {
				$("#pagenum").text((num + 1))
				
				$("#img"+(num)).hide();
				$("#img"+(num+1)).show();
			}
			if(parseInt($("#pagenum").text())==totnum) {
				btnEvent.imgCheck();
			}
		},
		btnBack : function() {
			var num = parseInt($("#pagenum").text());
			
			if( (num - 1) == 0 ) {
				alert("영수증이 존재 하지 않습니다.");
			} else {
				$("#pagenum").text((num - 1))
				
				$("#img"+(num)).hide();
				$("#img"+(num-1)).show();
			}
		},
		imgCheck : function() {
			$.ajaxCall({
				url: "<c:url value="/manager/trainingFee/proof/trainingFeeRentDetailCheck.do"/>"
				, data: localparam
				, success: function(data, textStatus, jqXHR){
					if (data.result.errCode < 1) {
		        		alert("처리도중 오류가 발생하였습니다.");
		        		return;
					} else {
						$("#btnCheckFlag").val("Y");
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
				}
			});
		}
}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">임차료 상세보기(그룹)</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">교육비증빙</a></li>
				<li class="end"><a href="#">임차료 관리</a></li>
			</ul>
		</div>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="40%"  />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tr>
				<th>회계년도</th>
				<td scope="row" colspan="3">
					<span id="txtfiscalyear"></span> 년도
				</td>
			</tr>
			<tr>
				<th>ABO No</th>
				<td scope="row">
					<span id="txtAboNo"></span>
				</td>
				<th>ABO Name</th>
				<td scope="row">
					<span id="txtAboName"></span>
				</td>
			</tr>
			<tr>
				<th>보증금/임대료</th>
				<td scope="row">
					<span id="rentdeposit"></span> / <span id="rentamount"></span>
				</td>
				<th>처리상태</th>
				<td scope="row">
					<span id="rentstatus"></span>
				</td>
			</tr>
			<tr>
				<th>시작 월</th>
				<td scope="row">
					<span id="txtFromMonth"></span>월
				</td>
				<th>종료 월</th>
				<td scope="row">
					<span id="txtToMonth"></span>월
				</td>
			</tr>
		</table>
	</div>
	
	<div style="width:100%;">
			<div class="contents_title clear">
				<div class="fr">
					<input type="hidden" id="btnCheckFlag" value="" />
					<input type="hidden" id="btnRentStatus" value="" />
					<a href="javascript:trainingFeeRent.doApprove();" class="btn_green authWrite" >승인</a>					
					<a href="javascript:trainingFeeRent.doReject();" id="btnReject" class="btn_green authWrite" >반려</a>
				</div>
			</div>
			<div id="AXGrid">
				<div id="AXGridTarget_${param.frmId}"></div>
			</div>
			<div id="img" style="width:100%;height:460px;border:1px solid #dddddd;padding:5px;">
				<a href="javascript:;">이미지</a>
			</div>
			<div style="width:100%;text-align:center;margin-top:5px;">
				<a href="javascript:btnEvent.btnBack();" class="btn_green">◀</a>
				<span id="pagenum">1</span> / <span id="totpage" class="totimg">3</span>
				<a href="javascript:btnEvent.btnNext();" class="btn_green">▶</a>
			</div>
		
	</div>	
			
	<!-- Board List -->
		
</body>