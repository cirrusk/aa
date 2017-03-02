<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include_frame.jsp" %>

<script type="text/javascript">
var selectTree = {};

var treeMenu = new AXTree();
var menuFunc = {
	init : function(){
		// Tree Start
		var _colGroup_Tree = [
							{key : "menuname", label : "제목", align : "left" , indent : true}
						]

		var treeParam = {
				colGroup : _colGroup_Tree
				, targetID : "AXTreeTarget_${param.frmId}"
				, height : "500px"
				, relation: {
					parentKey: "uppergroup"		// 부모아이디 키
					, childKey: "menucode" 		// 자식아이디 키
				}
				, doClick : menuFunc.doSelect
		};
		fnTree.initTree(treeMenu, treeParam);
		// Tree End

		// 버튼 이벤트
		// 등록(Tree)
		$("#btnInsert").on("click", function(){
			if(typeof selectTree.lv == "undefined"){
				alert("상위 메뉴를 선택 해 주세요. ");
				return;
			} else if(selectTree.lv == 0){

				// 상위 코드
				$("#spanUpperGroup").text("eHRD");
				$("[name='upperGroup']").val("eHRD");

			} else {
				// 상위 코드
				$("#spanUpperGroup").text( $("[name='menuCd']").val() );
				$("[name='upperGroup']").val( $("[name='menuCd']").val() );
			}

			// 코드
			$("[name='menuCd']").val("");
			$("#spanMenuCd").text("자동처리");
			// Levels
			$("[name='menuLevel']").val(  parseInt(selectTree.lv) + 1 );
			$("#spanMenuLevel").text(  parseInt(selectTree.lv) + 1 );
			// 메뉴명
			$("[name='menuName']").val("");
			// Link Url
			$("[name='linkurl']").val("");
			// 정렬순서
			$("[name='sortnum']").val("1");
			// 보기 여부
			$("input:radio[name='visibleYn']:input[value='Y']").prop("checked", true);
			// 메뉴 여부
			$("input:radio[name='menuYn']:input[value='Y']").prop("checked", true);
			// 사용여부
			$("input:radio[name='useYn']:input[value='Y']").prop("checked", true);

			// delete readonly
			$("#tblLecInfo1 input:text").removeAttr("readonly", "readonly");
			selectTree.mode = "I";
			selectTree.lv = parseInt(selectTree.lv) + 1;

			$("#btnDelete").hide();
			$('#btnUpdate').hide();
			$("#btnSave").show();
		});

		//저장
		$("#btnSave").on("click", function (mode, item, idx){
			// 저장전 Validation
			if(!chkValidation({chkId:"#tblLecInfo1", chkObj:"hidden|input|select"}) ){
				return;
			}
			if(!confirm("저장하시겠습니까?")){
				return;
			}
		 	selectTree.mode = "I";
			menuFunc.doSave(selectTree.mode);
		});

		//수정
        $("#btnUpdate").on("click",function(){
			if(typeof selectTree.lv == "undefined" || selectTree.lv == 0){
				alert("최상위는 수정 할 수 없습니다. ");
				return;
			}
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			selectTree.mode = "U";
			menuFunc.doSave(selectTree.mode);
		});

		// 삭제
		$("#btnDelete").on("click", function(){
			if($("#menuCd").val() == null || selectTree.lv == 0){
				alert("최상위는 삭제 할 수 없습니다. ");
				return;
			}
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			selectTree.mode = "D";
			menuFunc.doSave(selectTree.mode);
		});
	} // end Init
	, doSave : function(mode, item, idx){
        if(mode == "I") {
			var sUrl = "<c:url value="/manager/common/menu/insertMenu.do"/>";
			var sMsg = "등록하였습니다.";
		}else if(mode == "U"){
			sUrl = "<c:url value="/manager/common/menu/updateMenu.do"/>";
			sMsg = "수정하였습니다.";
		} else if(mode == "D"){
			sUrl = "<c:url value="/manager/common/menu/deleteMenu.do"/>";
			sMsg = "삭제하였습니다.";
		}

		if(mode == "D" && $("#menuCd").val() == ""){
			alert("등록 중에는 삭제 할 수 없습니다.");
			return;
		}

    	// 저장전 Validation
    	if(!chkValidation({chkId:"#tblLecInfo1", chkObj:"hidden|input|select"}) ){
    		return;
    	}

		if($("#linkurl").val() == "#"){
			$("#menuType").val("F");
		}else{
			$("#menuType").val("M");
		}

		var param = {
			menuCode : $("#menuCd").val()
			, menuType :$("#menuType").val()
			, menuName : $("#menuName").val()
			, linkurl : $("#linkurl").val()
			, sortnum : $("#sortnum").val()
			, upperGroup : $("#upperGroup").val()
			, menuLevel : selectTree.lv
			, menuYn :$("input:radio[name=menuYn]:checked").val()
			, visibleYn : $("input:radio[name=visibleYn]:checked").val()
			, useYn : $("input:radio[name=useYn]:checked").val()
		};

		$.ajaxCall({
			url: sUrl
			, data: param
			, success: function( data, textStatus, jqXHR){
				if(data.result < 1){
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
	        		return;
				} else {
					alert(sMsg);
					// 트리뷰 갱신
					menuFunc.doSearch();
					// 입력폼 초기화
					menuFunc.initSave();
				}
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var msg = '<spring:message code="errors.load"/>';
				alert(msg);
			}
		});
	}
	, doSearch : function(){	// Tree Setting
		$.ajaxCall({
				url: "<c:url value="/manager/common/menu/menuListAjax.do"/>"
				, data: ""
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
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});

		function callbackList(data) {
			// Tree Bind Real
			treeMenu.setList(data.treeList);
			// 1차 까지 선택
			treeMenu.expandAll(1);
		}
	}
	, doSelect : function(idx, item){
		var menuAuth = param.menuAuth;

		// Level에 따른 세팅
		if(item.menuLevel <= 1){
			$("#htrUpperMenu").hide();
		} else {
			$("#htrUpperMenu").show();
		}
		if(item.menuLevel == 0){
			$("#tblLecInfo1 input:text").attr("readonly", "readonly");
			$("#btnDelete").hide();
			$("#btnSave").hide();
		} else {
			$("#tblLecInfo1 input:text").removeAttr("readonly", "readonly");
            if(menuAuth == "W"){
                $("#btnDelete").show();
                $("#btnUpdate").show();
            }else{
                $("#btnDelete").hide();
                $("#btnUpdate").hide();
            }
			$("#btnSave").hide();
		}

		// 상위 메뉴
		$("#spanUpperGroup").text(item.uppergroup);
		$("[name='upperGroup']").val(item.uppergroup);
		// 코드
		$("#spanMenuCd").text(item.menucode);
		$("[name='menuCd']").val(item.menucode);
		// Levels
		$("[name='menuLevel']").val(item.menulevel);
		$("#spanMenuLevel").text(item.menulevel);
		// 메뉴명
		$("[name='menuName']").val(item.menuname);
		// link url
		$("[name='linkurl']").val(item.linkurl);
		// 정렬순서
		$("[name='sortnum']").val(item.sortnum);
		// 메뉴여부
		$("input:radio[name='menuYn']:input[value='"+item.menuyn+"']").prop("checked", true);
		// 보기여부
		$("input:radio[name='visibleYn']:input[value='"+item.visibleyn+"']").prop("checked", true);
		// 사용여부
		$("input:radio[name='useYn']:input[value='"+item.useyn+"']").prop("checked", true);

		selectTree.idx = idx;
		selectTree.lv = item.menulevel;
		selectTree.mode = "U";

	} // end doSelect
	, initSave : function(){
		// 상위코드
		$("[name='upperGroup']").val("");
		$("#spanUpperGroup").text( "" );
		// 코드
		$("[name='menuCd']").val("");
		$("#spanMenuCd").text( "" );
		// Levels
		$("[name='menuLevel']").val( '0' );
		$("#spanMenuLevel").text( "" );
		// 코드명
		$("[name='menuName']").val("");
		// linkurl
		$("[name='linkurl']").val( "" );
		// 정렬순서
		$("[name='sortnum']").val( "0" );
		// 메뉴여부
		$("input:radio[name='menuYn']:input[value='Y']").prop("checked", true);
		// 보기여부
		$("input:radio[name='visibleYn']:input[value='Y']").prop("checked", true);
		// 사용여부
		$("input:radio[name='useYn']:input[value='Y']").prop("checked", true);
	}
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

$(document).ready(function(){
	authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

	// Tree Init
	menuFunc.init();

	// Tree Bind
	menuFunc.doSearch();

});
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl"> 메뉴 관리</h2>
		<div class="fr">
			<ul class="navigation">
				<li class="home"><a href="#">홈으로</a></li>
				<li><a href="#">시스템 관리</a></li>
				<li class="end">메뉴 관리</li>
			</ul>
		</div>
	</div>
	<!--// title-->

<div class="treeWrap clear">
	<!-- Ax Tree  -->
	<div class="frameTree">
		<div id="AXTreeTarget_${param.frmId}" style="width:250px; height:500px;"></div>
		<!--버튼//-->
		<div class="mt10 btn_area clear authWrite">
			<div class="btn_left"><a href="javascript:;" id="btnInsert" class="btn_gray" >등록</a></div>
		</div>
		<!--//버튼-->
	</div>
	<!--// Ax Tree  -->

	<div class="treeView">
	<!-- Contents Area -->
		<div class="tbl_write">
			<table id="tblLecInfo1" width="100%" border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="17%" />
					<col width="*"  />
				</colgroup>
				<tr>
					<th>단계</th>
					<td >
						<input type="hidden" id="menuType" name="menuType"  title="단계" value="" />
						<input type="hidden" id="menuLevel" name="menuLevel" class="required" title="단계" value="" />
						&nbsp;<span id="spanMenuLevel"></span>
					</td>
				</tr>
				<tr id="htrUpperMenu" style="display:none">
					<th>상위 메뉴</th>
					<td >
						<input type="hidden" id="upperGroup" name="upperGroup" class="" title="상위 메뉴" />
						&nbsp;<span id="spanUpperGroup"></span>
					</td>
				</tr>
				<tr>
					<th>메뉴코드</th>
					<td >
						<input type="hidden" id="menuCd" name="menuCd" class="" title="메뉴코드" style="width:80%"/>
						&nbsp;<span id="spanMenuCd"></span>
					</td>
				</tr>
				<tr>
					<th>메뉴명</th>
					<td >
						<input type="text" id="menuName" name="menuName" class="required" title="메뉴명" style="width:80%" maxlength="33" oninput="maxLengthCheck(this)"/>
					</td>
				</tr>
				<tr>
					<th>Link Url</th>
					<td >
						<input type="text" id="linkurl" name="linkurl" class="required" title="Link Url" style="width:80%" maxlength="100" oninput="maxLengthCheck(this)"/>
					</td>
				</tr>
				<tr>
					<th>정렬순서</th>
					<td >
						<input type="text" id="sortnum" name="sortnum" class="required isNum" title="정렬순서" style="width:80px;IME-MODE:disabled;" maxlength="5" oninput="maxLengthCheck(this)" onkeydown="return showKeyCode(event)"/>
					</td>
				</tr>
				<tr>
					<th>메뉴 여부</th>
					<td >
						<input type="radio" id="menuYn1" name="menuYn" class="required" title="메뉴 여부" value="Y" checked/> 메뉴
						<input type="radio" id="menuYn2" name="menuYn" class="required" title="메뉴 여부" value="N" /> 메뉴 아님
					</td>
				</tr>
				<tr>
					<th>보기 여부</th>
					<td >
						<input type="radio" id="visibleYn1" name="visibleYn" class="required" title="보기 여부" value="Y" checked/> 보임
						<input type="radio" id="visibleYn2" name="visibleYn" class="required" title="보기 여부" value="N" /> 안보임
					</td>
				</tr>
				<tr>
					<th>사용 여부</th>
					<td >
						<input type="radio" id="useYn1" name="useYn" class="required" title="사용 여부" value="Y" checked/> 사용
						<input type="radio" id="useYn2" name="useYn" class="required" title="사용 여부" value="N" /> 미사용
					</td>
				</tr>
			</table>
		</div>

		<!-- Pop Button Area -->
		<div class="btn_area">
			<div class="btn_right">
				<a href="javascript:;" id="btnSave" class="btn_green authWrite" style="display:none">저장</a>
				<a href="javascript:;" id="btnUpdate" class="btn_green"  style="display:none">수정</a>
				<a href="javascript:;" id="btnDelete" class="btn_gray" style="display:none" >삭제</a>
			</div>
		</div>

	</div>
	<!--// Contents Area -->
</div>
</body>