<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp"%>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp"%>

<script type="text/javascript">
	var trainingFeePlanGrid = new AXGrid(); // instance 상단그리드
	
	//Grid Default Param
	var defaultParam = {
		page : 1,
		rowPerPage : "${rowPerCount }",
		sortColKey : "trainingfee.proof.plan",
		sortIndex : 1,
		sortOrder : "DESC"
	};
	
	$(document.body).ready(function() {
		trainingFeePlan.init();
		
		// 페이지당 보기수 변경 이벤트
		$("#cboPagePerRow").on("change", function(){
			trainingFeePlan.doSearch({page:1, rowPerPage : $("#cboPagePerRow").val() });
		});
		
		trainingFeePlan.doSearch();
	});

	//레이어 팝업 호출
	function trainingFeePlanInsert(giveyear, givemonth, rowmode){
		if(rowmode == "I"){
			var param = {
					mode: rowmode,
					giveyear : giveyear,
					givemonth : givemonth,
					frmId     : $("#frmId").val()
					,menuAuth:"${param.menuAuth}"
				};
		}else if(rowmode == "U"){
			var param = {
					mode: rowmode,
					giveyear : giveyear,
					givemonth : givemonth,
					frmId     : $("#frmId").val()
					,menuAuth:"${param.menuAuth}"
				};
			
		}
					
		var popParam = {
				url : "<c:url value="/manager/trainingFee/proof/trainingFeeScheduleInsert.do"/>"
				, width : "800"
				, height : "250"
				, params : param
				, targetId : "searchPopup"
		}
		window.parent.openManageLayerPopup(popParam);
	}
	
	
	var trainingFeePlan = {
		/** init : 초기 화면 구성 (Grid)*/
		init : function() {
			var idx = 0; // 정렬 Index 
			var _colGroup = [
					{key : "row_num", label : "No.", width : "60", align : "center", sort : false},
					{key : "giveyear", label : "지급연도", width : "100", align : "center", sort : false},
					{key : "givemonth", label : "지급 월", width : "100", align : "center", sort : false},
					{key : "startdt", label : "시작일자", width : "200", align : "center", sort : false},
					{key : "starttime", label : "시작시간", width : "200", align : "center", sort : false},
					{key : "enddt", label : "종료일자", width : "200", align : "center", sort : false},
					{key : "endtime", label : "종료시간", width : "200", align : "center", sort : false},
					{key : "smssendflag", label : "SMS발송예약", width: "100", align: "center", sort : false},
					{key : "rowmode", label : "버튼", width: "100", align: "center", sort : false, formatter: function () {
							return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:trainingFeePlanInsert('"+this.item.giveyear+"', '"+this.item.givemonth+"', '"+this.item.rowmode+"')\">"+this.item.rowmodebut+"</a>";
						}
					}
			    ]
	
			var gridParam = {
				colGroup : _colGroup,
				fitToWidth : false,
				height : "640px",
				colHead : {
					heights : [ 20, 20 ],rows : 
						[ 
							[ 
								{colSeq : 0, rowspan : 2, valign : "middle"},
								{colSeq : 1, rowspan : 2, valign : "middle"},
								{colSeq : 2, rowspan : 2, valign : "middle"},
								{colseq : null, colspan : 4, label : "일정", align : "center", valign : "middle"},
								{colSeq : 7, rowspan : 2, valign : "middle"},
								{colSeq : 8, rowspan : 2, valign : "middle"}
							],[ 
								{colSeq : 3}, 
								{colSeq : 4},
								{colSeq : 5},
								{colSeq : 6} 
							]
						]
					},
				targetID : "AXGridTarget_${param.frmId}",
				sortFunc : trainingFeePlan.doSortSearch,
				doPageSearch : trainingFeePlan.doPageSearch
			}

			fnGrid.initGrid(trainingFeePlanGrid, gridParam);
		},
		doPageSearch : function(pageNo) {
			defaultParam.page = pageNo;
			// Grid Page List
			trainingFeePlan.doSearch({
				page : pageNo
			});
		},
		doSortSearch : function(sortKey) {
			// Grid Sort
			defaultParam.sortOrder = fnGrid.sortGridOrder(defaultParam, sortKey);
			var param = {
				sortIndex : sortKey,
				page : 1
			};

			// 리스트 갱신(검색)
			trainingFeePlan.doSearch(param);
		},
		doSearch : function(param) {
			
			if($("#searchGiveYear").val() == "" || $("#searchGiveYear").val() == "null"){
				alert("지급연도를 선택해 주십시오")
				return false;
			}else{
				
				//검색_지급년도 값 파라미터
				var initParam = {
					giveyear : $("#searchGiveYear").val()
				};
				
				$.extend(defaultParam, param);
				$.extend(defaultParam, initParam);
				
				//리스트 ajax호출
				$.ajaxCall({
					method : "POST",
					url : "<c:url value="/manager/trainingFee/proof/trainingFeeScheduleList.do"/>",
					dataType : "json",
					data : defaultParam,
					success : function(data, textStatus, jqXHR) {
						if (data.result < 1) {
							alert("처리도중 오류가 발생하였습니다.");
							return;
						} else {
							callbackList(data);
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("처리도중 오류가 발생하였습니다.");
					}
				});
			}
					
			//리스트 그리는곳
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
		   		
		   		trainingFeePlanGrid.setData(gridData);
			}
			
		}
	}
	function doReturn() {
		alert("호출");
	}
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">교육비 일정 관리</h2>
		<input type="hidden" id="frmId" value="${param.frmId}" />
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">교육비</a></li>
				<li><a href="#">교육비증빙</a></li>
				<li class="end">일정관리</li>
			</ul>
		</div>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="9%" />
				<col width="*" />
				<col width="10%" />
				<col width="30%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th scope="row">지급연도</th>
				<td>
<!-- 					<input type="text" id="searchGiveYear" name="searchGiveYear" class="datepYer" style="width: auto; min-width: 100px"> -->
					<input type="text" name="searchGiveYear" id="searchGiveYear" class="AXInput datepYear setDateYear" readonly="readonly"/>
				</td>

				<th rowspan="2">
					<div class="btnwrap mb10">
						<a href="javascript:;" id="btnSearch" class="btn_gray btn_big" onclick="trainingFeePlan.doSearch();">검색</a>
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
		</div>
	</div>

	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>

	<!-- Board List -->

</body>