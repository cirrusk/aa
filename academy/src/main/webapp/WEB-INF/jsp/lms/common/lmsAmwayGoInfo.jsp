<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

<!doctype html>
<html lang="ko">
<head>
<!-- page common -->
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- //page common -->
<!-- page unique -->
<meta name="Description" content="설명들어감">
<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>[팝업] AmwayGo! 안내 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$(this).focus();
});
function windowClose(){
	window.close();
}
</script>
</head>


<body>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w030700111_3.gif" alt="AmwayGo! 안내" /></h1>
	</header>
	<a href="#" class="btnPopClose" onclick="windowClose()"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘"></a>
	
	<section id="pbPopContent">
		<strong class="fcDG">AmwayGO! 모바일 어플리케이션 안내</strong>
		<div class="grayBox2">
			<p class="textC lineHS">본 교육은 <strong>AmwayGO! 모바일 어플리케이션이 활용되는 교육</strong>입니다.<br />
			앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다.</p>
			<div class="textC mgtL">
				<a href="${amwaygo.googleplay }" target="_blank"><img src="/_ui/desktop/images/academy/img_googleplay.gif" alt="Google play" /></a>
				<a href="${amwaygo.appstore }" target="_blank"><img src="/_ui/desktop/images/academy/img_appstore.gif" alt="App Store" /></a>
			</div>
		</div>
		<div class="btnWrapC">
			<a href="#none" class="btnBasicAcGNL" onclick="windowClose()">확인</a>
		</div>
	</section>
</div>
</body>
</html>