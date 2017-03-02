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
<c:if test="${param.result == 'OK' }">
<title>[팝업] 통합교육 신청완료 - ABN Korea</title>
</c:if>
<c:if test="${param.result != 'OK' }">
<title>[팝업] 통합교육 신청실패 - ABN Korea</title>
</c:if>
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

<c:if test="${param.result != 'OK' }">
<!-- 신청실패 -->
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w030700112_1.gif" alt="신청실패" /></h1>
	</header>
	<a href="#" class="btnPopClose" onclick="windowClose()"><img src="/_ui/desktop/images/common/btn_close.gif" alt="신청실패 팝업창 닫힘"></a>
	
	<section id="pbPopContent">
		<strong class="fcDG">교육신청 실패하였습니다.</strong>
		
		<div class="grayBox2">
			<p class="textC lineHS">현재 선택하신 교육 신청이 불가합니다. <br /> 
			<c:choose>
				<c:when test="${param.status eq '1' }">
				패널티 적용으로 신청이 불가능 합니다. <br>자세한 정보는 나의아카데미>통합교육신청현황을 확인해 주세요.
				</c:when>
				<c:when test="${param.status eq '2'}">
				현재 수강신청이 가능한 대상이 아닙니다. 수강대상자 정보 확인 부탁드립니다. 
				</c:when>
				<c:when test="${param.status eq '3'}">
				현재 수강신청이 가능한 기간이 아닙니다. 수강신청 일정 확인 부탁드립니다.
				</c:when>
				<c:otherwise>
				신청대상 및 신청기간을 확인해 주세요
				</c:otherwise>
			</c:choose>
			</p>
		</div>
		
		<div class="btnWrapC">
			<a href="#none" class="btnBasicAcGNL" onclick="windowClose()">확인</a>
		</div>
	</section>
</div>
</c:if>
<c:if test="${param.result == 'OK' }">
<!-- 신청완료 -->
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w030700112_2.gif" alt="신청완료" /></h1>
	</header>
	<a href="#" class="btnPopClose" onclick="windowClose()"><img src="/_ui/desktop/images/common/btn_close.gif" alt="신청완료 팝업창 닫힘"></a>
	
	<section id="pbPopContent">
		<strong class="fcDG">교육신청 정상적으로 완료되었습니다.</strong>
		<div class="grayBox2">
			<p class="textC lineHS">신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 <br />나의 아카데미 > 통합교육 신청현황 메뉴에서 진행할 수 있습니다.</p>
		</div>
	<c:if test="${param.groupflag == 'Y' }">
		<!-- AmwayGo! 모바일 어플리케이션 안내 -->
		<div class="mgtL">
			<strong class="fcDG">AmwayGo! 모바일 어플리케이션 안내</strong>
			
			<div class="grayBox2">
				<p class="textC lineHS">본 교육은 <strong>AmwayGo! 모바일 어플리케이션이 활용되는 교육</strong>입니다.<br />
				앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다.</p>
				<div class="textC mgtL">
					<a href="${amwaygo.googleplay }" target="_blank"><img src="/_ui/desktop/images/academy/img_googleplay.gif" alt="Google play" /></a>
					<a href="${amwaygo.appstore }" target="_blank"><img src="/_ui/desktop/images/academy/img_appstore.gif" alt="App Store" /></a>
				</div>
			</div>
		</div>
		<!-- // AmwayGo! 모바일 어플리케이션 안내 -->
	</c:if>
		<div class="btnWrapC">
			<a href="#none" class="btnBasicAcGNL" onclick="windowClose()">확인</a>
		</div>
	</section>
</div>
</c:if>

</body>
</html>