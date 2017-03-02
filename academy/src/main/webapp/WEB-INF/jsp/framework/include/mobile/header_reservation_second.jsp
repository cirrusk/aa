<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/framework/include/mobile/top.jsp" %>

<meta id="metaTitle" property="og:title" content="abnkorea">
<meta id="metaUrl" property="og:url" content="http://www.amway.co.kr">
<meta id="metaContent" property="og:description" content="예약 시스템">

<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css">


<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademyReservationSecond.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/front_reservation.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/json3.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/jquery.form.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/jquery.number.min.js"></script>

<!-- 	<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script> -->
<script src="/_ui/mobile/common/js/pbCommon.js"></script>
<script src="/_ui/mobile/common/js/jquery.touchSlider.js"></script>

<script src="/js/stringUtility.js"></script>
<script src="/_ui/mobile/common/js/reservationSns.js"></script>
<!-- 	<script src="/_ui/desktop/common/js/reservationSns.js"></script> -->

<script src="/_ui/desktop/common/js/kakao.min.js"></script>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

<style>
	input {height:31px;}
</style>

<script type="text/javascript">

	var browser;

	// 모바일 가로/세로 resize
	$(window).on("orientationchange", function(event){
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
	
	// ap안내 아이프레임 높이 조정
	function abnkoreaApInfoPop_resize(){
		var tempHeight = 0;
		if($("#uiLayerPop_apInfo").height() > 900){
			tempHeight = 0;
		}else{
			tempHeight = 900 - $("#uiLayerPop_apInfo").height();
		}
		
		
		var iHeight = $("#uiLayerPop_apInfo").height() + tempHeight;
		var isResize = false;
		if(iHeight == null){
			iHeight = $(document).height();
		}
		try
		{
			window.parent.postMessage(iHeight, "*");
			isResize = true;
			
			$("#layerMask").css("display", "none");
		}
		catch(e){
			isResize = false;
		}
		if(!isResize)
		{
			try{
			}
			catch(e){
			}
		}
	}
	
	// ap안내 아이프레임 높이 조정
	function abnkoreaConfirmPop_resize(){
		var iHeight = $("#pbContent").height() + 200;
		var isResize = false;
		if(iHeight == null){
			iHeight = $(document).height();
		}
		try
		{
			window.parent.postMessage(iHeight, "*");
			isResize = true;
		}
		catch(e){
			isResize = false;
		}
		if(!isResize)
		{
			try{
			}
			catch(e){
			}
		}
	}
	

	// 아이프레임 높이 조정
	function abnkoreaCard_resize()
	{
		var iHeight = $("#pbContent").height() + 200;
		var isResize = false;
		if(iHeight == null){
			iHeight = $(document).height();
		}
		try
		{
			window.parent.postMessage(iHeight, "*");
			isResize = true;
		}
		catch(e){
			isResize = false;
		}
		if(!isResize)
		{
			try{
			}
			catch(e){
			}
		}
	}
	
	// 아이프레임 높이 조정
	function rsvConfirmPop_resize(){
		$('#uiLayerPop_confirm').each(function(){
			this.scrollIntoView(true);
		});
	}


</script>