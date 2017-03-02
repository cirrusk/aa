<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
	//Grid Init
	var commonCodeGrid = new AXGrid(); // instance 상단그리드

	//Grid Default Param
	var defaultParam = {
		sortColKey: "common.commonCode.list"
	};

	$(document.body).ready(function() {
		param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
		if(param.menuAuth == "W"){
			$(".authWrite").show();
		}else{
			$(".authWrite").hide();
		}

		commonCode.init();
		commonCode.doSearch();

		// 추가 버튼 클릭시
		$("#codeUpload").on("click", function(codemasterseq){
			var param = {
				mode:"I"
			    , codemasterseq :$("#codemasterseq").val()
				, frmId  : $("[name='frmId']").val()
				, pageID : "${param.frmId}"
				, menuAuth:"${param.menuAuth}"
			};

			var popParam = {
				url : "<c:url value="/manager/common/systemCode/systemCodeDetailPop.do"/>"
				,modalID:"modalDiv01"
				, width : "512"
				, height : "450"
				, params : param
				, targetId : "searchPopup"
			}
			window.parent.openManageLayerPopup(popParam);
		});

		$("#codeMaster").on("click", function(){
			var f = document.listForm;
			f.action = "/manager/common/systemCode/systemCodeList.do";
			f.submit();
		});

		// 코드순번저장 버튼
        $("#codeAllSave").on("click", function(){
			//수정
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			var codeseq = document.getElementsByName("cmmseq[]");
			var inp = document.getElementsByName("neworder[]");
			var neworder = "";

			for(var i=0; i<codeseq.length; i++){
				if(inp[i].value == null || inp[i].value == ""){
					alert("코드순번을 입력해 주세요");
					return;
				}
				if(i == 0) {
					neworder = codeseq[i].value + "/" + inp[i].value;
				} else {
					neworder = neworder + "," + codeseq[i].value + "/" + inp[i].value;
				}
			}

			var orderParam = {};
			var sMsg = "수정하였습니다.";

			var param = {
				neworder : neworder
			};
			// Param 셋팅(검색조건)
			var masterParam = {
				codemasterseq : $("#codemasterseq").val()
			};

			$.extend(orderParam, param);
			$.extend(orderParam, masterParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/systemCode/systemCodeDetailOrder.do"/>"
				, data: orderParam
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						//return;
					} else {
						alert(sMsg);
						commonCode.doSearch();
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.2");
				}
			});
		});

	});

	function changeOrder(val, index, obj){
		if(!isNumber(val)){
			alert("주관식 점수를 숫자로 입력해 주세요.");
			obj.value = adminGrid.list[index].neworder;
			return;
		}
		adminGrid.list[index].neworder = val;
	}

	/* 숫자만 입력받기 */
	function showKeyCode(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || keyID == 8 || keyID == 9 || keyID == 37 || keyID == 39 || keyID == 46 )
		{
			return;
		}
		else if(keyID == 16){
			alert("특수문자는 입력 불가능 합니다.");
			return false;
		} else 	{
			return false;
		}
		
	}

	var gridEvent = {
		nameClick: function (commoncodeseq,codemasterseq) {

			var param = {
				mode: "U"
				, commoncodeseq :commoncodeseq
				, codemasterseq :$("#codemasterseq").val()
				, frmId  : $("[name='frmId']").val()
				, pageID : "${param.frmId}"
				, menuAuth:"${param.menuAuth}"
			};

			var popParam = {
				url: "<c:url value="/manager/common/systemCode/systemCodeDetailPop.do" />"
				, width: "512"
				, height: "450"
				, params: param
				, targetId: "searchPopup"
			}

			window.parent.openManageLayerPopup(popParam);
		}
	}

	var commonCode = {
		/** init : 초기 화면 구성 (Grid)
		 */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				  {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
				, {key:"codename", label:"하위코드명", width:"150", align:"center", sort:false}
				, {key:"commoncodeseq", addclass:idx++, label:"하위코드", width:"150", align:"center", sort:false, formatter: function(){
					return "<a href=\"javascript:;\" onclick=\"gridEvent.nameClick('" + this.item.commoncodeseq + "')\">" + this.item.commoncodeseq + "</a>";
				  }}
				, {key:"codeaccount", label:"코드설명", width:"200", align:"center", sort:false}
				, {key:"useyn", label:"사용유무", width:"80", align:"center", sort:false}
				, {key:"codeorder", label:"기존순번", width:"100", align:"center", sort:false}
				, {key:"neworder", label:"코드순번", width:"200", align:"center", sort:false,formatter: function(){
					return '<input type="text" name="neworder[]" maxlength="9" style="IME-MODE:disabled;" onkeydown="return showKeyCode(event)" value="'+this.item.neworder+'" onblur="changeOrder(this.value, '+this.index+', this)"/><input type="hidden" name="cmmseq[]" value="'+this.item.commoncodeseq+'"/>';
				}}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
				, targetID : "AXGridTarget_${param.frmId}"
			}

			fnGrid.nonPageGrid(commonCodeGrid, gridParam);
		}, doSearch : function(param) {

			// Param 셋팅(검색조건)
			var initParam = {
				codemasterseq : $("#codemasterseq").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/systemCode/systemCodeDetailAjax.do"/>"
				, data: defaultParam
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
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
					list: obj.dataList
				};
				// Grid Bind Real
				commonCodeGrid.setData(gridData);
			}
		}
	}

	function doReturn() {
		commonCode.doSearch();
	}

</script>
</head>

<body class="bgw">
	<form:form id="listForm" name="listForm" method="post">
		<input type="hidden" id="codemasterseq" value="${codeDetail.codemasterseq}"/>
		<input type="hidden" name="frmId" value="${param.frmId}"/>
		<input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
	</form:form>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">시스템코드</h2>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<th scope="row" style="text-align: center;">업무구분</th>
				<td>
					<div>
						<div>${codeDetail.workscope }</div>
					</div>
				</td>
				<th scope="row" style="text-align: center;">코드분류명</th>
				<td>
					<div>${codeDetail.codemastername }</div>
				</td>
			</tr>
		</table>

		<div class="contents_title clear" style="padding-top: 15px;height: 10px;">
			<div class="fr" style="vertical-align:middle; margin-left:0px;">
				<a href="javascript:;" id="codeMaster" class="btn_gray">상위코드</a>
				<a href="javascript:;" id="codeUpload" class="btn_green authWrite">하위코드등록</a>
				<a href="javascript:;" id="codeAllSave" class="btn_green authWrite">코드순번저장</a>
			</div>
		</div>
	</div>

	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget_${param.frmId}"></div>
	</div>

	<!-- Board List -->

</body>
