<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include_frame.jsp" %>
<script type="text/javascript">
	var selectTree = {};

	var adminGrid = new AXGrid(); // instance 상단그리드
	var adminList = {
		/** init : 초기 화면 구성 (Grid)
		 */
		init : function() {
			var idx = 0; // 정렬 Index
			var _colGroup = [
				  {key:"no", label:" ", width:"50", align:"center", formatter:"money", sort:false}
				, {
					key:"managename", label:"운영자명", width:"80", align:"center", sort:false,formatter:function(){
						var returnData = "";
						var menuAuthManege = param.menuAuth;
						
						if(this.item.managename == "" || this.item.managename == null)
							{
								if(menuAuthManege == "W"){
									returnData = "<a href='javascript:;' onclick=\"javascript:goNoRegister('"+this.item.adno+"');\">미등록</a>";
								}else{
									returnData = "<a href='javascript:;'>미등록</a>";
								}
							}
						else
							{
								returnData =  "<a href='javascript:;' onclick=\"javascript:goAuthorize('"+this.item.adno+"');\">"+this.item.managename+"</a>";
							}
						
						return returnData;
					}
				}
				, {key:"adno", label:"AD계정", width:"120", align:"center", sort:false}
				, {key:"managedepart", label:"소속", width:"80", align:"center", sort:false}
				, {key:"apname", label:"PP관리", width:"80", align:"center", sort:false}
				, {key:"modifier", label:"대상자수정자", width:"100", align:"center", sort:false}
				, {key:"modifydate", label:"대상자수정일자", width:"100", align:"center", sort:false}
				, {key:"authmodifier", label:"권한수정자", width:"100", align:"center", sort:false}
				, {key:"authmodifydate", label:"권한수정일자", width:"100", align:"center", sort:false}
				, {
					key:"update", label:"수정", width:"80", align:"center", sort:false, formatter:function(){
						var menuAuthManage = param.menuAuth;
						if(menuAuthManage == "W"){
							return "<a href='javascript:;' class='btn_green' onclick=\"javascript:goUpdate('"+this.item.adno+"','U');\">수정</a>";
						}else{
							return;
						}
					}
				}
			]

			var gridParam = {
				colGroup : _colGroup
				, fitToWidth: false
				, colHead : { heights: [25,25],
					rows : [
						[
							 {colSeq: 0}
							,{colSeq: 1}
							,{colSeq: 2}
							,{colSeq: 3}
							,{colSeq: 4}
							,{colSeq: 5}
							,{colSeq: 6}
							,{colSeq: 7}
							,{colSeq: 8}
						]
					]
				}
				, targetID : "AXGridTarget_${param.frmId}"
				, height : "590px"
			}
			
			fnGrid.nonPageGrid(adminGrid, gridParam);
		}, doSearch : function(param) {

			// Param 셋팅(검색조건)
			var initParam = {
				searchtype : $("#searchtype").val()
				,searchtext : $("#searchtext").val()
			};

			$.extend(defaultParam, param);
			$.extend(defaultParam, initParam);

			$.ajaxCall({
				url: "<c:url value="/manager/common/auth/authGroupListAjax.do"/>"
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
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});

			function callbackList(data) {
				var obj = data; //JSON.parse(data);
				// Grid Bind
				var gridData = {
					list: obj.dataList
				};
				// Grid Bind Real
				adminGrid.setData(gridData);
			}
		}
	}
	
	//Grid Default Param
	var defaultParam = {
		 sortColKey: "common.targetMaster.list"
	};
	
	$(document).ready(function(){
		authButton(param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"});

		// Tree Init
		adminList.init();
		adminList.doSearch();
 
		// 운영자등록 버튼 클릭시
		$("#pop").on("click", function(){
			goUpdate();
		});
		
		
		//전체 조회 권한 클릭
		$(document).on("click","#allCheck",function(){
			
			if(this.checked)
				{
					$("#rightTable input[name='menucodes']").prop("checked",true);
					$("input:radio[value=R]").prop("checked",true);
				}
			else
				{
					$("#rightTable input[name='menucodes']").prop("checked",false);
					$("#rightTable").find("input[type='radio']").prop("checked",false);
				}
		});
	
		//checkBox 클릭시
		$(document).on("click",".menu1",function(){
			
			var id = $(this).attr("id");
			
			if(this.checked)
				{
					$("."+id).prop("checked",true);
					$("input:radio[value=R]").filter("."+id).prop("checked",true);
				}
			else
				{
					$("."+id).prop("checked",false);
				}
			
		});
		
		$(document).on("click",".menu2",function(){
			
			var id = $(this).attr("id");
			
			if(this.checked)
				{
					$("."+id).prop("checked",true);
					$("input:radio[value=R]").filter("."+id).prop("checked",true);
				}
			else
				{
					$("."+id).prop("checked",false);
				}
			
		});

		$(document).on("click",".menu3",function(){

			var id = $(this).attr("id");

			if(this.checked)
			{
				$("."+id).prop("checked",true);
				$("input:radio[value=R]").filter("."+id).prop("checked",true);
			}
			else
			{
				$("."+id).prop("checked",false);
			}

		});
		
		//radio 버튼 클릭시
		$(document).on("click",".authradio",function(){
			
			var id = $(this).attr("id");
			id = id.replace("authradio","");
			
			var value = $(this).attr("value");
			
			$("input:radio[value="+value+"]").filter("."+id).prop("checked",true);
			
			
		});
		
		//초기화 버튼 클릭시
		$(document).on("click","#resetBtn",function(){
			
			$("#allCheck").prop("checked",false);
			$("#rightTable input[name='menucodes']").prop("checked",false);
			$("#rightTable").find("input[type='radio']").prop("checked",false);
			
		});
		
		//운영자 삭제 클릭시
		$(document).on("click","#delete_manager",function(){
			
			$.ajaxCall({
				url: "<c:url value="/manager/common/auth/authGroupListManagerDeleteAjax.do"/>"
				,data: "adno="+$("#curAdno").val()
				,success: function(data, textStatus, jqXHR)
				{	
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
		           		return;
		   			} else {
						alert("삭제하였습니다.");
						$("#rightTable").html("");
						adminList.doSearch();
		   			}
				}
				,error: function(jqXHR,textStatus,errorThrown)
				{
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});
			
		});
		
		//검색버튼 클릭시
		$("#btnSearch").on("click", function(){
			adminList.doSearch();
		});
		
		
		//저장버튼 클릭시
		$(document).on("click","#save_Btn",function(){
			
			var paramData = $("#menuForm"	).serialize();
			
			$.ajaxCall({
				url: "<c:url value="/manager/common/auth/authGroupListMenuAuthSaveAjax.do"/>"
				,data: paramData
				,success: function(data, textStatus, jqXHR)
				{	
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
		           		return;
		   			} else {
						alert("저장하였습니다.");
						adminList.doSearch();
		   			}
				}
				,error: function(jqXHR,textStatus,errorThrown)
				{
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});
			
			
		});
		
	});
	
	
 	//popUp창 가기
	function goUpdate(adNo,mode)
	{
		var param = {
				mode: mode
				,adno : adNo
				, frmId  : $("[name='frmId']").val()
			};

			var popParam = {
				url : "<c:url value="/manager/common/auth/authGroupListPop.do"/>"
				,modalID:"modalDiv01"
				, width : "900"
				, height : "600"
				, params : param
				, targetId : "authPopup"
			}
			window.parent.openManageLayerPopup(popParam);
	}
	
	//메뉴 권한 설정 가기
	function goAuthorize(adNo)
	{
		 $.ajax({
				url: "<c:url value="/manager/common/auth/authGroupListRightDivAjax.do"/>"
					, data:  "adno="+adNo
					, dataType : "text"
					, type : "post"
						, success: function(data){
							$("#rightTable").html($(data).filter("#rightTable").html());
				 			var menuAuthManage = param.menuAuth;
				 				if(menuAuthManage == "W"){
									$(".authWrite").show();
								}else{
									$(".authWrite").hide();
								}

						},
						error: function() {
							var msg = '<spring:message code="errors.load"/>';
							alert(msg);
						}
		 });
	}
	
	//미등록
	function goNoRegister(adNo)
	{
		if(confirm("로그인 승인 처리가 완료된 계정으로 권한부여를 위해서는 추가 기본 정보 등록이 필요합니다.\r\n 등록하시겠습니까?"))
			{
				goUpdate(adNo,'U');
			}
	}

	function doReturn() {
		adminList.doSearch();
	}
	
</script>

</head>

<body class="bgw">
	<input type="hidden" name="frmId" value="${param.frmId}"/>
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">운영자등록/권한관리</h2>
	<!--// title-->
	<div class="contents_title clear" style="width: 100%;">
		<div class="tbl_write">
			<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<th scope="row" style="text-align: center;height: 40px;">운영자검색</th>
					<td>
						&nbsp;
						<select id="searchtype">
							<option value="">선택</option>
							<option value="1">계정</option>
							<option value="2">이름</option>
						</select>
						&nbsp;
						<input type="text"  id="searchtext" class="AXInput" style="min-width:503px;"/>
						<a href="javascript:;" id="btnSearch" class="btn_gray" onclick="javascript:;">조회</a>
						<a href="javascript:;" class="btn_green authWrite" onclick="goUpdate('','I')">운영자등록</a>
					</td>
				</tr>
			</table>
		</div>
         <br/>
        <br/>
		<br/>
		<br/>
	</div>


	<!-- Board List -->
	<div class="treeWrap clear" style="width: 100%;">
		<!-- Ax Tree  -->
		<div class="frameTree" style="width:58%; float:left;" >
		<div class="contents_title clear">
			<div class="fl">
					<div style="font-size: 20px; font-weight: bold;">운영자목록</div>
			</div>
			<br/><br/><br/><br/><br/>
		</div>
		<br/><br/>
			<div id="AXGridTarget_${param.frmId}" style="width:auto; height:600px;overflow-y:scroll;"></div>
		</div>
		<!--// Ax Tree  -->
		
	
		<div class="treeView"  style="width:38%; height: 600px; float:right; margin-left: 0px;"  id="rightTable">
			<!-- Contents Area -->
	
		</div>
		<!--// Contents Area -->
	</div>
  </div>
</body>

