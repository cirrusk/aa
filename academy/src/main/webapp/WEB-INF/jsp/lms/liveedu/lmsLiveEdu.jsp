<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<title>라이브교육 시청 - ABN Korea</title>
<!--[if lt IE 9]>
	<script src="/_ui/desktop/common/js/html5.js"></script>
	<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->

	<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
	
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

	<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
	<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
	<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
	<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
	<script src="/_ui/desktop/common/js/owl.carousel.js"></script>
	
	<script src="/js/front.js"></script>
	<script src="/js/lms/lmsComm.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	
	$(document.body).ready(function() {
		
		setTimeout(function(){ abnkorea_resize(); }, 500);

		init();
	});
	
	// 
	function init() {
		
	}
	
	// 새로고침
	function goRefreshLink(courseidVal) {
		$("#lmsForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsForm").attr("action", "/lms/liveedu/lmsLiveEdu.do");
		$("#lmsForm").submit();
	}
	
</script>
	
</head>

<body oncontextmenu="return false" ondragstart="return false" onselectstart="return false">

<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="courseid"  value="${param.courseid }" />
</form>

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030500100.gif" alt="라이브교육시청"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030500100.gif" alt="제품ㆍ비즈니스 정보를 생생한 라이브교육으로 만나보세요."></p>
			</div>
			
			<!-- 게시판 상세 -->
			<c:set var="groupflag" value="N" />
			<c:forEach var="item" items="${courseList}" varStatus="status">
				<c:set var="groupflag" value="${item.groupflag}" />
			<dl class="tblDetailHeader">
				<dt>
				<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
				${item.coursename}
				<%-- </c:if> --%>
				</dt>
				<dd>
				<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
					본방송 : ${item.mainstart}<em>|</em><span><c:if test="${not empty item.livereplaylink and item.livereplaylink ne ''}">재방송 : ${item.replaystart}</c:if></span>
				<%-- </c:if> --%>
				</dd>
			</dl>
			
			<!-- 동영상 -->
			<div class="tblDetailCont details">
				<div class="detailMovie">
					<div class="movie">
					<c:if test="${item.mainplayyn eq 'Y' or item.premainplayyn eq 'Y'}">
						<iframe src="${item.livelink}" frameborder="0" allowfullscreen width="712" height="394" title="${item.linktitle}"></iframe>
					</c:if>
					<c:if test="${item.replayyn eq 'Y' or item.prereplayyn eq 'Y'}">
						<iframe src="${item.livereplaylink}" frameborder="0" allowfullscreen width="712" height="394" title="${item.linktitle}"></iframe>
					</c:if>
					<%-- 
					<c:if test="${item.mainplayyn ne 'Y' and item.replayyn ne 'Y'}">
						<div class="borderBox">
							<p style="width:100%;text-align:center;">아직 교육시간이 아닙니다.</p>
						</div>
						<!-- <iframe src="http://play.smartucc.kr/live/player.php?playkey=e99a49b3c4faeb84ddae03e7898c5d41" frameborder="0" allowfullscreen width="712" height="394" title="현재 방송 중이 아닙니다."></iframe> -->
					</c:if>
					 --%>
					</div>
				</div>
				<div class="detailRefresh">
					 <a href="#none" class="btnRefresh" onClick="javascript:goRefreshLink('${param.courseid}');"><span>새로고침</span></a> 
					 <span>방송시간에 맞추어 새로고침 하시면 시청이 가능합니다.</span>
				</div>
				<p>
				<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
				${item.coursecontent}
				<%-- </c:if> --%>
				</p>
			</div>
				
			<!-- //동영상 -->
			</c:forEach>
			
			<c:if test="${courseList eq null || courseList.size() == 0}">
			<div class="tblDetailCont details">
				<div class="detailMovie">
					<div class="movie">
						현재 진행중인 라이브 교육이 없습니다.
						<!-- <iframe src="http://play.smartucc.kr/live/player.php?playkey=e99a49b3c4faeb84ddae03e7898c5d41" frameborder="0" allowfullscreen width="712" height="394" title="현재 방송 중이 아닙니다."></iframe> --> 
					</div>
				</div>
				<div class="detailRefresh">
					 <a href="#none" class="btnRefresh" onClick="javascript:goRefreshLink();"><span>새로고침</span></a> 
					 <span>방송시간에 맞추어 새로고침 하시면 시청이 가능합니다.</span>
				</div>
			</div>
			</c:if>
			
		<c:if test="${groupflag eq 'Y'}">
			<div class="borderBox">
				<p><img src="/_ui/desktop/images/academy/txt_liveEdu.gif" alt="AmwayGo! 모바일 어플리케이션 안내" /></p>
				<p class="mgtM"><img src="/_ui/desktop/images/academy/img_liveEdu.gif" alt="본 교육은 AmwayGo! 모바일 어플리케이션이 활용되는 교육입니다. 
					앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다." /></p>
				<div class="textC mgtL">
					<a href="https://play.google.com" target="_blank"><img src="/_ui/desktop/images/academy/img_googleplay.gif" alt="구글플레이" /></a>
					<a href="https://www.apple.com/retail/" target="_blank"><img src="/_ui/desktop/images/academy/img_appstore.gif" alt="앱스토어" /></a>
				</div>
			</div>
		</c:if>
		</section>
		<!-- //content area | ### academy IFRAME Start ### -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>