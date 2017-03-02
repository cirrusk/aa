<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>라이브교육 시청 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>


	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

<script src="/_ui/mobile/common/js/apps/kakao.link.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.min.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	
	$(document.body).ready(function() {
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		if(navigator.userAgent.match(/android/i)){
			$("#amwaygo_android").show();
		}
		if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
			$("#amwaygo_iphone").show();
		}
	});
	
	// 새로고침
	function goRefreshLink(courseidVal) {
		$("#lmsForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsForm").attr("action", "/mobile/lms/liveedu/lmsLiveEdu.do");
		$("#lmsForm").submit();
	}
	
</script>
	
</head>

<body class="uiGnbM3" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">

<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="courseid"  value="${param.courseid }" />
</form>

		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">라이브교육 시청</h2>
			
			<div class="acSubWrap">
			<c:set var="groupflag" value="N" />
			<c:forEach var="item" items="${courseList}" varStatus="status">
				<c:set var="groupflag" value="${item.groupflag}" />
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">
							<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
							${item.coursename}
							<%-- </c:if> --%>
							</strong>
							<span class="category">
							<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
							${item.categoryname}
							<%-- </c:if> --%>
							</span>
						    <span class="img">
								<c:if test="${item.mainplayyn eq 'Y' or item.premainplayyn eq 'Y'}">
									<iframe src="${item.livelink}" frameborder="0" allowfullscreen="" width="100%" height="300px" title="${item.linktitle}"></iframe>
								</c:if>
								<c:if test="${item.replayyn eq 'Y' or item.prereplayyn eq 'Y'}">
									<iframe src="${item.livereplaylink}" frameborder="0" allowfullscreen="" width="100%" height="300px" title="${item.linktitle}"></iframe>
								</c:if>
							</span>
							<%-- 
								<c:if test="${item.mainplayyn ne 'Y' and item.replayyn ne 'Y'}">
									<p style="height:100px;font-size:9;color:000000;width:100%;text-align:center">아직 교육시간이 아닙니다.</p>
									<!-- <iframe src="http://play.smartucc.kr/live/player.php?playkey=e99a49b3c4faeb84ddae03e7898c5d41" width="100%" height="300px" frameborder="0" title="현재 방송 중이 아닙니다."></iframe> -->  
								</c:if>
								<!-- 디자인 변경되어 주석처리함 2016.09.05 
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;"  />
								<c:if test="${not empty item.playtime}"><span class="time">${item.playtime}</span></c:if>
								 -->
								  --%>

						</a>
						
						<!-- 디자인 변경되어 주석처리함 2016.08 4주차 정도
						<div class="iframeZone">
							<c:if test="${item.mainplayyn eq 'Y'}">
								<iframe src="${item.livelink}" frameborder="0" scrolling="no" frameborder="0" title="${item.linktitle}"></iframe>
							</c:if>
							<c:if test="${item.replayyn eq 'Y'}">
								<iframe src="${item.livereplaylink}" frameborder="0" scrolling="no" frameborder="0" title="${item.linktitle}"></iframe>
							</c:if>
							<c:if test="${item.mainplayyn ne 'Y' and item.replayyn ne 'Y'}">
								<% //방송시간이 아닙니다.  가바아 %>		
								<iframe src="http://play.smartucc.kr/live/player.php?playkey=e99a49b3c4faeb84ddae03e7898c5d41" width="100%" height="100%" frameborder="0" title="현재 방송 중이 아닙니다."></iframe>
							</c:if>
						</div>  
						-->
						<!-- 삭제 요청으로 주석처리함 2016.10.12
						<div class="snsZone">
							<a href="#none" class="like" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
							<a href="#none" class="share"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</div>
						-->
						
						<div class="itemInfo">
							<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
								<p><c:if test="${not empty item.mainstart and item.mainstart ne ''}">본방송 : ${item.mainstart}</c:if></p>
								<c:if test="${not empty item.livereplaylink and item.livereplaylink ne ''}"><p>재방송 : ${item.replaystart}</p></c:if>
							<%-- </c:if> --%>
						</div>
						<div class="itemCont">
							<p>
							<%-- <c:if test="${item.mainplayyn eq 'Y' or item.replayyn eq 'Y'}"> --%>
							${item.coursecontent}
							<%-- </c:if> --%>
							</p>
						</div>
					</article>
				</section><!-- //.acItems -->
				<div class="itemRefresh">
					<span>방송시간에 맞추어 새로고침 하시면 시청이 가능합니다.</span> <a href="#none" class="btnRefresh" onClick="javascript:goRefreshLink('${param.courseid}');"><span>새로고침</span></a>
				</div>
			</c:forEach>	
			<c:if test="${courseList eq null || courseList.size() == 0}">
				<section class="acItems">
					<article class="item">
							<span class="img">
								현재 진행중인 라이브 교육이 없습니다.
								<!-- <iframe src="http://play.smartucc.kr/live/player.php?playkey=e99a49b3c4faeb84ddae03e7898c5d41" width="100%" height="300px;" frameborder="0" title="현재 방송 중이 아닙니다."></iframe> -->  
							</span>
					</article>
				</section><!-- //.acItems -->
				<div class="itemRefresh">
					<span>방송시간에 맞추어 새로고침 하시면 시청이 가능합니다.</span> <a href="#none" class="btnRefresh" onClick="javascript:goRefreshLink('');"><span>새로고침</span></a>
				</div>
			</c:if>
			<c:if test="${groupflag eq 'Y'}">
				<dl class="eduCont">
					<dt><span class="eduIcon icon7"></span>AmwayGo! 모바일 어플리케이션 안내</dt>
					<dd>
						<p class="listDot">본 교육은 AmwayGo! 모바일 어플리케이션이 활용되는 교육입니다.
						앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다.</p>
						<div class="imgBox">
							
							<!-- 안드로이폰 일 경우 -->
							<a href="https://play.google.com" target="_blank" id="amwaygo_android" style="display:none;"><img src="/_ui/mobile/images/academy/img_googleplay.gif" alt="Google Play" /></a>
							
							<!-- 아이폰 일 경우 -->
							<a href="https://www.apple.com/retail/" target="_blank" id="amwaygo_iphone" style="display:none;"><img src="/_ui/mobile/images/academy/img_appstore.gif" alt="Available on the App Store" /></a>
						</div>
					</dd>
				</dl>
			</c:if>
				<div class="toggleBox attNote">
					<strong class="tggTit"><a href="#none" title="자세히보기 열기" onclick="javascript:setTimeout(function(){ abnkorea_resize(); }, 500);">ⓘ 유의사항</a></strong>
					<div class="tggCnt">
						<ul class="listTxt">
							<li>유선 인터넷이 연결된 PC또는 무선 인터넷(Wifi)이 지원하는 스마트 기기를 권장 드리며, 3G로 연결된 스마트 기기의 경우 서비스가 지연 될 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>
			
		</section>
		<!-- content ##iframe end## -->
		
<!-- SNS layer popup -->
<!-- 
<div class="pbLayerPopup" id="uiLayerPop_URLCopy">
	<div class="alertContent">
		<h2 class="hide">URL 복사</h2>
		<em>복사하기 하여, <br>원하는 곳에 붙여넣기 해주세요</em>
		<input type="text" title="URL 주소" class="url" id="pbLayerPopupUrl" value=""><input type="hidden" id="snsCourseid" value="">
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>
 -->
<!-- //SNS layer popup -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>