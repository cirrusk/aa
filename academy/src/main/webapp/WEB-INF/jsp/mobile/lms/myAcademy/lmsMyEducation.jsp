<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>이용현황 - ABN Korea</title>
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
	
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	
	$(document.body).ready(function() {
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2(); //TOP로 이동
	});
	

	// 이전달,다음달호출
	function goMonthLink(currdateYMVal, currentYearStampVal) {
		$("#lmsMyEduForm > input[name='currdateYM']").val(currdateYMVal);
		$("#lmsMyEduForm > input[name='currentYearStamp']").val(currentYearStampVal);
		
		$("#lmsMyEduForm").attr("action", "/mobile/lms/myAcademy/lmsMyEducation.do");
		$("#lmsMyEduForm").submit();
	}

</script>

</head>

<body class="uiGnbM3">

<form id="lmsMyEduForm" name="lmsMyEduForm" method="post">
	<input type="hidden" name="PFYear"  value="${scrData.PFYear }" />
	<input type="hidden" name="currdateYM"  value="${scrData.currdateYM }" />
	<input type="hidden" name="currentYearStamp"  value="${scrData.currentYearStamp }" />
</form>
		
	
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">이용현황</h2>
			
			<div class="acSubWrap">
				<div class="acCalendarWrap">
					<div class="monthly">
						<strong>${scrData.currentYear}</strong>-<strong>${scrData.currentMon}</strong>
						<a href="#none" class="monthPrev<c:if test="${not empty scrData.prevYM}"> on</c:if>" <c:if test="${not empty scrData.prevYM}">onclick="javascript:goMonthLink('${scrData.prevYM}','${scrData.currentYearStamp}');"</c:if>><span>이전달</span></a>
						<a href="#none" class="monthNext<c:if test="${not empty scrData.nextYM}"> on</c:if>" <c:if test="${not empty scrData.nextYM}">onclick="javascript:goMonthLink('${scrData.nextYM}','${scrData.currentYearStamp}');"</c:if>><span>다음달</span></a>
					</div>
				</div>
				<p>아카데미 이용 현황과 스탬프 획득 정보를 확인할 수 있습니다.</p>
				<div class="acSubConWrap">
					<div class="acStateWrap">
						<dl class="acState01">
							<dt><span><strong>${scrData.currentMon}월 접속 일수</strong> <strong class="num">${scrData.connDaytoMon}</strong> 일</span></dt>
							<dd>PF${scrData.PFYear} 누적 ${scrData.connDaytoTot}일</dd>
						</dl>
						<dl class="acState02">
							<dt><span><strong>${scrData.currentMon}월 개근 주</strong> <strong class="num">${scrData.weeknumcnt}</strong> 주</span></dt>
							<dd><!-- <c:if test="${not empty scrData.connWeeklyStart and scrData.connWeeklyStart ne ''}"> ${scrData.connWeeklyStart} 부터 시작</c:if> -->
								주 1회 이상 접속<br />PF${scrData.PFYear} 연속 누적 ${scrData.connWeektoTot}주
							</dd>
						</dl>
						<dl class="acState03">
							<dt><span><strong>교육자료</strong> ${scrData.currentMon}월 <strong class="num">${scrData.eduResourceCnt}</strong> 건</span></dt>
							<dd>PF${scrData.PFYear} 누적 ${scrData.eduResourceTot}건<br/>동일 자료 중복제외</dd>
							
						</dl>
						<dl class="acState04">
							<dt><span><strong>온라인강의</strong> ${scrData.currentMon}월 <strong class="num">${scrData.onlineFinCnt}</strong> 건</span></dt>
							<dd>PF${scrData.PFYear} 누적 ${scrData.onlineFinTot}건<br/>동일 강의 중복제외</dd>
							
						</dl>
						<dl class="acState05">
							<dt><span><strong>오프라인강의</strong> ${scrData.currentMon}월 <strong class="num">${scrData.offlineFinCnt}</strong> 건</span></dt>
							<dd>PF${scrData.PFYear} 누적 ${scrData.offlineFinTot}건</dd>
						</dl>
						<dl class="acState06">
							<dt><span><strong>라이브교육</strong> ${scrData.currentMon}월 <strong class="num">${scrData.liveFinCnt}</strong> 건</span></dt>
							<dd>PF${scrData.PFYear} 누적 ${scrData.liveFinTot}건</dd>
						</dl>
						<dl class="acState_sns">
							<dt><span><strong>SNS 공유</strong></span></dt>
							<dd class="dtData"><span>${scrData.currentMon}월 <strong class="num">${scrData.logSNSCnt}</strong> 회</span></dd>
							<dd>PF${scrData.PFYear} 누적  ${scrData.logSNSTot}회<br />중복 허용 합산</dd>
						</dl>
						<dl class="acState_complete">
							<dt><span><strong>정규과정 수료</strong></span></dt>
							<dd>${scrData.currentYear}년 <strong class="num">${scrData.StampRegularCnt}</strong> 건</dd>
							<dd>누적 총 ${scrData.StampRegularTot}건</dd>
						</dl>
					</div>
				</div>

				<div class="acSubConWrap">
					<div class="acCalendarWrap">
						<div class="monthly">
							<strong>${scrData.currentYearStamp}</strong>
							<a href="#none" class="monthPrev<c:if test="${not empty scrData.prevYear}"> on</c:if>" <c:if test="${not empty scrData.prevYear}">onclick="javascript:goMonthLink('${scrData.currdateYM }','${scrData.prevYear}');"</c:if>><span>이전달</span></a>
							<a href="#none" class="monthNext<c:if test="${not empty scrData.nextYear}"> on</c:if>" <c:if test="${not empty scrData.nextYear}">onclick="javascript:goMonthLink('${scrData.currdateYM }','${scrData.nextYear}');"</c:if>><span>다음달</span></a>
						</div>
					</div>			
					<h3>일반 스탬프</h3>
					<div class="acStampWrapper">
						<ul class="acStampList" id="acStampList1">
							<c:forEach var="item" items="${stampList}" varStatus="status">
							<li><a href="#uiLayerPop_obtain01" onclick="layerPopupOpen(this);return false;"><span><img src="/mobile/lms/common/imageView.do?file=${item.stampimage}&mode=stamp"  alt="${item.stampimagenote}" /></span><c:if test="${not empty item.obtaindate}"><em>${item.obtaindate}</em></c:if></a></li>
							</c:forEach>	
						</ul>
					</div>
				</div>
				
				<div class="acSubConWrap">
					<h3 class="pdtM2">정규과정 스탬프</h3>
					<div class="acStampWrapper">
						<ul class="acStampList regular" id="acStampList2">
						<c:forEach var="itemR" items="${stampRegularList}" varStatus="status">
							<li><a href="#uiLayerPop_obtain02" onclick="layerPopupOpen(this);return false;"><span><img src="/mobile/lms/common/imageView.do?file=${itemR.stampimage}&mode=stamp"  alt="${itemR.stampimagenote}" /></span><c:if test="${not empty itemR.obtaindate}"><em>${itemR.obtaindate}</em></c:if></a></li>
						</c:forEach>	
						</ul>
					</div>
				</div>
				
				<!-- #Layer Popup : 일반 스탬프 획득조건 -->
				<div class="pbLayerPopup" id="uiLayerPop_obtain01">
					<div class="pbLayerHeader">
						<strong>일반 스탬프 획득조건</strong>
					</div>
					<div class="pbLayerContent">
						<div class="acStampWrapper">
							<ul class="acStampCondition" id="acStamp1">
								<c:forEach var="itemN" items="${stampNorList}" varStatus="status">
								<li><span><img src="/mobile/lms/common/imageView.do?file=${itemN.onimage}&mode=stamp"  alt="${itemN.onimagenote}" /></span> <em>${itemN.stampcondition}</em>
										<c:if test="${itemN.stampid eq '1' or itemN.stampid eq '2' or itemN.stampid eq '3' or itemN.stampid eq '4' }">
										<div style="width:100%;text-align:center;">치어리더 스탬프는 한 주에 한 번 이상 아카데미 연속으로 접속한 횟수에 의해 발급됩니다.</div>
										</c:if>
								</li>
								</c:forEach>
							</ul>
						</div>
					</div>
					<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
				</div>
				<!-- //#Layer Popup : 일반 스탬프 획득조건 -->
				
				<!-- #Layer Popup : 정규과정 스탬프 획득조건 -->
				<div class="pbLayerPopup" id="uiLayerPop_obtain02">
					<div class="pbLayerHeader">
						<strong>정규과정 스탬프 획득조건</strong>
					</div>
					<div class="pbLayerContent">
						<div class="acStampWrapper">
							<ul class="acStampCondition" id="acStamp2">
								<c:forEach var="itemC" items="${stampCourseList}" varStatus="status">
								<li><span><img src="/mobile/lms/common/imageView.do?file=${itemC.onimage}&mode=stamp"  alt="${itemC.onimagenote}" /></span> <em>${itemC.stampcondition}</em></li>
								</c:forEach>
							</ul>
						</div>
					</div>
					<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
				</div>
				<!-- //#Layer Popup : 정규과정 스탬프 획득조건 -->
			</div>
			<!-- //20160824 수정 -->
		</section>
		<!-- content ##iframe end## -->

<script type="text/javascript">
$(document).ready(function() {
	var $popslide1 = $("#acStamp1");
	var $popslide2 = $("#acStamp2");	
	$popslide1.owlCarousel({navigation : true, pagination : false, singleItem:true, stopOnHover : true, rewindNav: false, autoPlay : false});
	$popslide2.owlCarousel({navigation : true, pagination : false, singleItem:true, stopOnHover : true, rewindNav: false, autoPlay : false});
	
	owl1 = $("#acStamp1").data('owlCarousel');
	owl2 = $("#acStamp2").data('owlCarousel');
	$stampList1 = $("#acStampList1 > li > a");
	$stampList2 = $("#acStampList2 > li > a")
	$stampList1.on('click', function(){
		var slideNum1 = $(this).parent("li").index();
    	owl1.jumpTo(slideNum1);
	});
	$stampList2.on('click', function(){
		var slideNum2 = $(this).parent("li").index();
    	owl2.jumpTo(slideNum2);
	});
});
</script>	
		
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>