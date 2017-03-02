<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/framework/include/top.jsp" %>
	<%@ include file="/WEB-INF/jsp/framework/include/include_reservation.jsp" %>

	<meta id="metaUrl" 		property="og:url" 			content="" />
	<meta id="metaTitle" 	property="og:title" 		content="abnkorea" />
	<meta id="metaContent" 	property="og:description" 	content="" />
	<meta id="imageUrl"		property="og:image" 		content="http://www.abnkorea.co.kr/?icid=banner|%EC%95%94%EC%9B%A8%EC%9D%B4" />

	<script type="text/javascript" src="/_ui/desktop/common/js/jquery.touchSlider.js"></script>
	<script type="text/javascript" src="/_ui/desktop/common/js/pbCommonAcademyReservation.js"></script>
	<script src="/js/adjustIframe.js"></script>
	<script src="/js/stringUtility.js"></script>
	<script src="/_ui/desktop/common/js/kakao.min.js"></script>
	
	<script src="/_ui/desktop/common/js/reservationSns.js"></script>
	
	<script type="text/javascript" src="http://share.naver.net/js/naver_sharebutton.js"></script>
<!-- 	<script type="text/javascript" src="//developers.band.us/js/share/band-button.js?v=11102016"> -->
	
	<!-- 개발 반영 임시 Iframe height -->
	<script type="text/javascript">
	$(document).ready(function () {
		
		$("meta[property='og\\:url']").attr("content", location.href);
		
		if("http://ad.abnkorea.co.kr/" == $(location).prop("host")){
			parent.$("#IframeComponent").height("3000");
		}
	});
	</script>