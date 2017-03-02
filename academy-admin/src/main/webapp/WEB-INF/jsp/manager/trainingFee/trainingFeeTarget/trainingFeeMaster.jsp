<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">	
//Grid Init
var trainingFeeMasterGrid = new AXGrid(); // instance 상단그리드

//Grid Default Param
var defaultParam = {
	  page: 1
 	, rowPerPage: "${rowPerCount }"
 	, sortColKey: "trainingfee.target.list"
 	, sortIndex: 1
 	, sortOrder:"DESC"
 	, pageID : "${param.frmId}"
};

$(document.body).ready(function(){
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});
	myIframeResizeHeight("${param.frmId}");
	trainingFeeMaster.init();	
	
	// 페이지당 보기수 변경 이벤트
	$("#cboPagePerRow").on("change", function(){
		trainingFeeMaster.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
	});
	
	$("#getGridDetailView").on("click", function(){
		getGridDetailView(trainingFeeMasterGrid.getExcelFormat("html"));
	});
	
	// 검색버튼 클릭
	$("#btnSearch").on("click", function(){
		trainingFeeMaster.doSearch({page:1});
	});
	
	// 추가 버튼 클릭시
	$("#aTargetInsert").on("click", function(){
		var param = {
				mode:"I"
			,pageID : "${param.frmId}"
			,menuAuth:"${param.menuAuth}"
		};
		
		var popParam = {
				url : "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterLearPop01.do" />"
				, width : "1024"
				, height : "800"
				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	});
	
	// 삭제 버튼 클릭시
	$("#aTargetDelete").on("click", function(){
		gridEvent.chkDelete();
	});
	
	// 운영그룹 버튼 클릭시
	$("#aTargetUpdateGrp").on("click", function(){
		gridEvent.chkGroupcodeChange();
	});
	
	// 엑셀 업로드 버튼 클릭시
	$("#aExcelUpload").on("click", function(){
		var result = confirm("교육비 대상자 일괄 등록을 진행 하시겠습니까?"); 
		
		if(result) {
			var param = {
				 page : "target"
				,pageID : "${param.frmId}"
				,menuAuth:"${param.menuAuth}"
			};
			
			var popParam = {
					url : "<c:url value="/manager/common/excel/excelUpload.do" />"
					, height : "280"
					, params : param
			}
			
			window.parent.openManageLayerPopup(popParam);
		}
	});
	
	$("#aboSearch").aboSearch("CalculationNm","btnCalSearch","txtSearchType","${param.frmId}");
	$("#aboSearch1").aboSearch("DepositNm","btnDepSearch","txtDepSearchType","${param.frmId}");
	
	trainingFeeMaster.doSearch();
});



function doReturnValue(param) {
	if(param.rtninputnm=="CalculationNm") {
		$("select[name='txtSearchType']").val("1");
		$("input[name='CalculationNm']").val(param.uid);
	} else {
		$("select[name='txtDepSearchType']").val("1");
		$("input[name='DepositNm']").val(param.uid);
	}
}

var trainingFeeMaster = {
		/** init : 초기 화면 구성 (Grid)
		*/		
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
							{key:"abo_no", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
			                        return this.item.___checked && this.item.___checked["1"];
			             	}}	
							, {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
							, {key:"abo_no", label:"ABO 번호", width:"80", align:"center"}
							, {key:"abo_name", label:"ABO 이름", width:"100", align:"center", formatter:"money", formatter: function(){
							 	return "<a href=\"javascript:;\" onclick=\"gridEvent.aboNameClick('" + this.item.giveyear + "','" + this.item.givemonth + "','" + this.item.abo_no + "')\">" + this.item.abo_name + "</a>";
							  }}
							, {key:"code", addclass:idx++, label:"Code", width:"80", align:"center"}
							, {key:"highestachievename", addclass:idx++, label:"H.Pin", width:"60", align:"center"}
							, {key:"groupsname", addclass:idx++, label:"C.Pin", width:"60", align:"center"}
							, {key:"loanamekor", addclass:idx++, label:"LOA", width:"100", align:"center"}
							, {key:"br", addclass:idx++, label:"BR", width:"60", align:"center"}
							, {key:"department", addclass:idx++, label:"Dept", width:"80", align:"center"}
							, {key:"qualifydia", addclass:idx++, label:"C.Up.Dia No", width:"100", align:"center"}
							, {key:"qualifydianame", addclass:idx++, label:"C.Up.Dia Name", width:"150", align:"center"}
							, {key:"delegtypename", addclass:idx++, label:"위임", width:"80", align:"center"}
							, {key:"sales", addclass:idx++, label:"매출액", width:"120", formatter:"money", align:"center"}
							, {key:"trfee", addclass:idx++, label:"교육비", width:"120", formatter:"money", align:"center"}
							, {key:"groupcode", addclass:idx++, label:"운영그룹", width:"80", align:"center"}
							, {key:"authperson", addclass:idx++, label:"권한(개인)", width:"80", align:"center"}
							, {key:"authgroup", addclass:idx++, label:"권한(그룹)", width:"80", align:"center"}
							, {key:"authmanageflag", addclass:idx++, label:"총무", width:"80", align:"center"}
							, {key:"depabo_no", addclass:idx++, label:"ABO No", width:"80", align:"center"}
							, {key:"depaboname", addclass:idx++, label:"ABO Name", width:"100", align:"center"}
							, {key:"depcode", addclass:idx++, label:"Code", width:"80", align:"center"}
							, {key:"tottrfee", addclass:idx++, label:"총교육비", width:"120", formatter:"money", align:"center"}
							, {key:"abocnt", addclass:idx++, label:"ABO Count", width:"80", align:"center"}
							,{
								key:"reference", addclass:idx++, label:"참고사항", width:"80", align:"center", sort:false, formatter: function () {
									return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:gridEvent.clickMemo('" + this.item.giveyear + "','" + this.item.givemonth + "','" + this.item.abo_no + "');\">참고사항</a>";
								}
							}
						]
			
			var gridParam = {
					colGroup : _colGroup
					, fitToWidth: false
// 					, fixedColSeq: 3
					, colHead : { heights: [25,25],
				          rows : [
			                     [
									  {colSeq:  0, rowspan: 2, valign:"middle"}
									, {colSeq:  1, rowspan: 2, valign:"middle"}
									, {colseq:null, colspan: 17, label: "Calculation ABO", align: "center", valign:"middle"}
									, {colseq:null, colspan: 5, label: "Deposit ABO", align: "center", valign:"middle"}
									, {colSeq: 24, rowspan: 2, valign:"middle"}
									
								
			                  	], [
									 {colSeq: 2}
									,{colSeq: 3}
									,{colSeq: 4}
									,{colSeq: 5}
									,{colSeq: 6}
									,{colSeq: 7}
									,{colSeq: 8}
									,{colSeq: 9}
									,{colSeq: 10}
									,{colSeq: 11}
									,{colSeq: 12}
									,{colSeq: 13}
									,{colSeq: 14}
									,{colSeq: 15}
									,{colSeq: 16}
									,{colSeq: 17}
									,{colSeq: 18}
									,{colSeq: 19}
									,{colSeq: 20}
									,{colSeq: 21}
									,{colSeq: 22}
									,{colSeq: 23}
			                      ]
								]
						}
					, targetID : "AXGridTarget_${param.frmId}"
					, sortFunc : trainingFeeMaster.doSortSearch
					, doPageSearch : trainingFeeMaster.doPageSearch
				}
			
			fnGrid.initGrid(trainingFeeMasterGrid, gridParam);
		}, doPageSearch : function(pageNo) {
			// Grid Page List
			defaultParam.page = pageNo;
			trainingFeeMaster.doSearch({page:pageNo});
		}, doSortSearch : function(sortKey){
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
					sortIndex : sortKey
					, page : 1
			};
			
			// 리스트 갱신(검색)
			trainingFeeMaster.doSearch(param);
		}, doSearch : function(param) {
			
			// Param 셋팅(검색조건)
			var initParam = {
					searchGiveYear : $("#searchGiveYear").val()	
				  , searchCalSchType :$("#txtCalSearchType").val()
				  , searchCalculationNm :$("#CalculationNm").val()
				  , searchDepSchType :$("#txtDepSearchType").val()
				  , searchDepositNm :$("#DepositNm").val()
				  , searchBR :$("#cbSearchBR").val()
				  , searchGrpCd :$("#cbSearchGrp").val()
				  , searchCode :$("#cbSearchCode").val()
				  , searchLoa :$("#cbSearchLOA").val()
				  , searchCPin :$("#cbSearchCPin").val()
				  , searchDept :$("#cbSearchDept").val()
				  , searchPass :$("#cbSearchPass").val()
				  , searchFlag :$("#txtSearchFlag").val()
			};
			
			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
		   		url: "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterListAjax.do"/>"
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
		   			var mag = '<spring:message code="errors.load"/>';
					alert(mag);
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
		   		
		   		try{
		   			$("#monthTotalTrfee").text(setComma(obj.dataList[0].monthtotaltrfee));
		   		} catch(e) {
		   			$("#monthTotalTrfee").text(0);
				}
		   		
		   		// Grid Bind Real
		   		trainingFeeMasterGrid.setData(gridData);
		   		
		   		
		   	}
			
		}
	}
	
var gridEvent = {
	aboNameClick : function(giveyear,givemonth,abono) {
		var param = {
				mode:"U"
				,giveyear:giveyear
				,givemonth:givemonth
				,abono:abono
				,pageID : "${param.frmId}"
				,menuAuth:"${param.menuAuth}"
		};
		
		var popParam = {
				url : "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterLearPop01.do" />"
				, width : "1024"
				, height : "800"
				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
					
	},
	chkGroupcodeChange : function() {
		
		var checkedabono             = "";
		var checkedList = trainingFeeMasterGrid.getCheckedListWithIndex(0);// colSeq
		
		for(var i = 0; i < checkedList.length; i++){
			if(i == 0){
				checkedabono = checkedList[i].item.abo_no;
			} else {
				checkedabono = checkedabono+","+checkedList[i].item.abo_no;
			}
		}
		
		if($.trim(checkedabono).length == 0){
			alert("선택된 대상자가 없습니다.");
			return;
		}
		
		if( isNull($("#cbGrpList").val()) ) {
			alert("변경 하고자 하는 운영그룹을 선택 해 주세요.");
			$("#cbGrpList").focus();
			return;
		}
		
		var result = confirm("선택한 대상자에 운영그룹코드를 변경 하시겠습니까?"); 
		
		if(result) {
			var param = {
					searchGiveYear : $("#searchGiveYear").val()	
					,groupcode:$("#cbGrpList").val()
					,checkedabono:checkedabono
				};
			
			if(result) {
				$.ajaxCall({
					method : "POST",
					url : "<c:url value="/manager/trainingFee/trainingFeeTarget/updateMasterGroupCode.do"/>",
					dataType : "json",
					data : param,
					success : function(data, textStatus, jqXHR) {
						if (data.result.errCode < 0) {
							alert("처리도중 오류가 발생하였습니다.");
						}else{
							alert("저장 완료 하였습니다.");
							trainingFeeMaster.doSearch();
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("처리도중 오류가 발생하였습니다.");
					}
				});
			}
		}					
	},
	chkDelete : function() {
		// 대상자 삭제전 메세지 출력
		var checkedabono = "";
		var checkedList = trainingFeeMasterGrid.getCheckedListWithIndex(0);// colSeq
		
		for(var i = 0; i < checkedList.length; i++){
			if(i == 0){
				checkedabono = checkedList[i].item.abo_no;
			} else {
				checkedabono = checkedabono+","+checkedList[i].item.abo_no;
			}
		}
		
		if($.trim(checkedabono).length == 0){
			alert("선택된 대상자가 없습니다.");
			return;
		}
		
		var result = confirm("선택한 대상자를 삭제 하시겠습니까?"); 
		
		if(result) {
			var tempArr = $("#searchGiveYear").val().split("-");
			var tempGiveyear = tempArr[0];
			var tempGivemonth = tempArr[1];
			var param = {
					giveyear : tempGiveyear
					,givemonth : tempGivemonth
					,checkedabono:checkedabono
				};
	
			$.ajaxCall({
				url: "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterGiveTargetDeleteAjax.do"/>"
				, data: param
				, success: function(data, textStatus, jqXHR){
					if (data.result.errCode < 0) {
						alert("처리도중 오류가 발생하였습니다.");
					}else{
						alert("삭제 완료 되었습니다.");
						trainingFeeMaster.doSearch();
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
		           	alert("처리도중 오류가 발생하였습니다.");
				}
			});
		}
	},
	clickMemo : function(giveyear, givemonth, abono) {
		var param = {
			 giveyear:giveyear
			,givemonth:givemonth
			,abono:abono
			,mode:"reference"
			,menuAuth:"${param.menuAuth}"
		};
		
		var popParam = {
				url : "<c:url value="/manager/trainingFee/trainingFeeTarget/trainingFeeMasterMemoLearPop01.do"/>"
				, width : "800"
				, height : "650"
				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	}
}

function doReturnClose() {
	trainingFeeMaster.doSearch();
}

</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">마스터정보 관리</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">대상자관리</a></li>
				<li class="end">마스터정보 관리</li>
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
				<th>지급연도/월</th>
				<td colspan="3">
					<input type="text" id="searchGiveYear" name="searchGiveYear" class="AXInput datepMon setDateMon" readonly="readonly">
				</td>
				<th rowspan="7">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big">검색</a>
					</div>
				</th>
			</tr>
				
			<tr>
				<th>ABO</th>
				<td colspan="3">
					<div id="aboSearch" style="float:left;">
						<label style="width:70px;text-align:right;">Calculation :</label>
						<select id="txtCalSearchType" name="txtSearchType" style="width:auto; min-width:100px" >
							<option value="1">ABO 번호</option>
							<option value="2">ABO 이름</option>
						</select>
						<input type="text" id="CalculationNm" name="CalculationNm" style="width:auto; min-width:100px" >
						<a href="javascript:;" id="btnCalSearch" name="btnCalSearch" class="btn_gray btn_mid">검색</a>
					</div>
					<div id="aboSearch1" style="float:left;">
						<label style="width:70px;text-align:right;">Deposit :</label>
						<select id="txtDepSearchType" name="txtDepSearchType" style="width:auto; min-width:100px" >
							<option value="1">ABO 번호</option>
							<option value="2">ABO 이름</option>
						</select>
						<input type="text" id="DepositNm" name="DepositNm" style="width:auto; min-width:100px" >
						<a href="javascript:;" id="btnDepSearch" name="btnDepSearch" class="btn_gray btn_mid">검색</a>
					</div>
				</td>
			</tr>
			
			<tr>
				<th scope="row">BR</th>
				<td>
					<select id="cbSearchBR" name="cbSearchBR">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchBR }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">운영그룹</th>
				<td>
					<select id="cbSearchGrp" name="cbSearchGrp">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchGrpCd }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">Code</th>
				<td>
					<select id="cbSearchCode" name="cbSearchCode">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchCode }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">LOA</th>
				<td>
					<select id="cbSearchLOA" name="cbSearchLOA">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchLOA }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">C.Pin</th>
				<td>
					<select id="cbSearchCPin" name="cbSearchCPin">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchCPin }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
				<th scope="row">Dept</th>
				<td>
					<select id="cbSearchDept" name="cbSearchDept">
						<option value="">전체</option>
						<c:forEach var="items" items="${searchDept }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">위임구분</th>
				<td>
					<select id="cbSearchPass" name="cbSearchPass">
						<option value="">전체</option>
						<ct:code type="option" majorCd="TR5" selectAll="false" />
					</select>
				</td>
				<th scope="row">Cal/Dep 일치여부</th>
				<td>
					<select id="txtSearchFlag" name="txtSearchFlag">
						<option value="">전체</option>
						<option value="1">일치</option>
						<option value="2">불일치</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
			
	<div class="contents_title clear">
		<div class="fl">
			<select id="cboPagePerRow" name="cboPagePerRow" style="width:auto; min-width:100px"> 
				<ct:code type="option" majorCd="pageCnt" selectAll="false" selected="${rowPerCount }"  />
			</select>
			<span style="font-size:14px;"> 총 교육비 : </span><span id="monthTotalTrfee" style="font-size:14px;"></span>&nbsp;&nbsp;<a href="javascript:;" id="getGridDetailView" class="btn_green">팝업보기</a>
		</div>
		
		<div class="fr">
			<div style="float:left;padding:5px 5px 5px 5px;margin-right:5px;border:1px solid #ABABAB;width:300px;" class="authWrite">
				<label>개별 대상자</label><a href="javascript:;" id="aTargetInsert" class="btn_green">추가</a>&nbsp;&nbsp;&nbsp;<label>선택한 대상자를</label><a href="javascript:;" id="aTargetDelete" class="btn_green">삭제</a>
			</div>
			<div style="float:right;" class="authWrite">
				<div style="float:left;padding:5px 5px 5px 5px;border:1px solid #ABABAB;">
					<label>선택한 대상자를</label>
					<select id="cbGrpList" name="cbSearchGrp" style="width:auto; min-width:100px" >
						<option value="">선택</option>
						<c:forEach var="items" items="${searchGrpCd }">
							<option value="${items.code }">${items.name }</option>
						</c:forEach>
					</select>
					<label>으로</label>
					<a href="javascript:;" id="aTargetUpdateGrp" class="btn_green">운영그룹</a>
				</div>
				<div style="float:right;padding:5px 5px 5px 5px;">
					<a href="javascript:;" id="aExcelUpload" class="btn_green">엑셀 업로드</a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>
			
	<!-- Board List -->
		
</body>