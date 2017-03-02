<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
$(document.body).ready(function(){
	// Iframe Refresh - 개발용 임시
	$("#btnIfrmRefresh").on("click", function(){
		$(".conDiv").each(function(){
			if($(this).css("display") == "block"){
				var objIfrm = $(this).find("iframe");
				objIfrm.attr("src", objIfrm.attr("src"));
			}
		});
	});
	
	// 과정 WORKFLOW 호출
	/* var url = "<c:url value="/manage/lecture/workflowList.mvc"/>";
	$("#inner").append("<div id=\"contents_M\" class=\"conDiv\" menuId=\"M\"><iframe id=\"ifrm_main_M\" class=\"targerFrame\" frameboader=\"0\" scrolling=\"no\"></iframe></div>");
	
	var objIfrm = $('#ifrm_main_M');
	objIfrm.attr("src", url);
	objIfrm.css({ 
		"height" : "100%"
		, "min-height" : "805px" 
	}); */

	// Left Menu Open/Off
	$(".btn_toggle").off("click").on("click", function(){
		if (!$(".btn_toggle").hasClass("on")) {
			$("#content").animate({"margin-left": "-=277px"}, 100);
			$("#lnbwrap").hide(100);
			$(".btn_toggle").addClass("on");
		} else {
			$("#content").animate({"margin-left": "+=277px"}, 100);
			$("#lnbwrap").show(100);
			$(".btn_toggle").removeClass("on");
		}
	});
});

function fnCtxIframeResize(frmId,nHeight){
	$("#ifrm_main_" + frmId ).height(nHeight);
}

function fnCtxIframeSize(frmId){
	return $("#ifrm_main_" + frmId ).height();
}

</script>
</head>

<body>
<div id="wrap">

	<!-- header -->
	<%@ include file="/WEB-INF/jsp/manager/frame/include/header.jsp" %>
	<!-- //header -->
	
	<!-- container //-->
	<div id="container">
		<!-- Left Menu //-->
		<%@ include file="/WEB-INF/jsp/manager/frame/include/left_menu.jsp" %>
		<!--// Left Menu -->
		
		<!--// Left Menu -->

		<!--content //-->
		<div id="content">
			<!--tab //-->
			<%@ include file="/WEB-INF/jsp/manager/frame/include/tab_menu.jsp" %>
			<!--// tab-->
			
			<div class="btn_toggle"></div>
			
			<!-- inner //-->
			<div id="inner">
				<div class="btnwrap ">
					<a href="javascript:;" id="btnIfrmRefresh" class="btn_green" style="display:none;float:right;" >새로고침</a>
				</div>
					
				<!-- contents_main  -->
				<div id="contents_area" class="conDiv"></div>				
				<!--// contents_main  -->
			</div>
			<!--// inner -->
		</div>
		<!--// content -->
	</div>
	<!--// container -->
	<div id="searchPopup"></div>
</div>

</body>
</html>