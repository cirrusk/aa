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
<title>이용현황 - ABN Korea</title>

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
		fnAnchor2(); //TOP로 이동
	});
	
	// 이전달,다음달호출
	function goMonthLink(currdateYMVal, currentYearStampVal) {
		$("#lmsMyEduForm > input[name='currdateYM']").val(currdateYMVal);
		$("#lmsMyEduForm > input[name='currentYearStamp']").val(currentYearStampVal);
		
		$("#lmsMyEduForm").attr("action", "/lms/myAcademy/lmsMyEducation.do");
		$("#lmsMyEduForm").submit();
	}

</script>

</head>

<body>

<form id="lmsMyEduForm" name="lmsMyEduForm" method="post">
	<input type="hidden" name="PFYear"  value="${scrData.PFYear }" />
	<input type="hidden" name="currdateYM"  value="${scrData.currdateYM }" />
	<input type="hidden" name="currentYearStamp"  value="${scrData.currentYearStamp }" />
</form>
		
	
		<!-- content area  -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030100100.gif" alt="이용현황" /></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030100100.gif" alt="아카데미의 이용 현황과 스탬프 획득 정보를 확인할 수 있습니다." /></p>
			</div>
			
			<div class="achWrap">
				<div class="acCalendarWrap">
					<div class="monthly">
						<strong>${scrData.currentYear}</strong>-<strong>${scrData.currentMon}</strong>
						<a href="#none" class="monthPrev<c:if test="${not empty scrData.prevYM}"> on</c:if>" <c:if test="${not empty scrData.prevYM}">onclick="javascript:goMonthLink('${scrData.prevYM}','${scrData.currentYearStamp}');"</c:if>><span>이전달</span></a>
						<a href="#none" class="monthNext<c:if test="${not empty scrData.nextYM}"> on</c:if>" <c:if test="${not empty scrData.nextYM}">onclick="javascript:goMonthLink('${scrData.nextYM}','${scrData.currentYearStamp}');"</c:if>><span>다음달</span></a>
					</div>
				</div>
			</div>
			
			<div class="acStateWrap">
				<dl class="acState01">
					<dt><span class="monthNum">${scrData.currentMon} </span><span class="hide">월 접속 일수</span></dt>
					<dd class="info"><span><strong class="num point">${scrData.connDaytoMon}</strong> <em>일</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 누적 ${scrData.connDaytoTot}일</dd>
				</dl>
				<dl class="acState02">
					<dt><span class="monthNum">${scrData.currentMon} </span><span class="hide">월 개근 주</span></dt>
					<dd class="infotxt1">
						<!-- <span><c:if test="${not empty scrData.connWeeklyStart and scrData.connWeeklyStart ne ''}"> ${scrData.connWeeklyStart} 부터 시작</c:if></span> -->
							<span>주 1회 이상 접속</span>
					</dd>
					<dd class="info"><span><strong class="num point">${scrData.weeknumcnt}</strong> <em>주</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 연속 누적  ${scrData.connWeektoTot}주</dd>
				</dl>
				<dl class="acState03">
					<dt><span class="hide">교육자료</span></dt>
					<dd class="info1"><span>${scrData.currentMon}월 <strong class="num">${scrData.eduResourceCnt}</strong> <em>건</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 누적 ${scrData.eduResourceTot}건 <span>동일 자료 중복제외</span></dd>
				</dl>
				<dl class="acState04">
					<dt><span class="hide">온라인강의</span></dt>
					<dd class="info1"><span>${scrData.currentMon}월 <strong class="num">${scrData.onlineFinCnt}</strong> <em>건</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 누적 ${scrData.onlineFinTot}건 <span>동일 강의 중복제외</span></dd>
				</dl>
				<dl class="acState05">
					<dt><span class="hide">오프라인강의</span></dt>
					<dd class="info1"><span>${scrData.currentMon}월 <strong class="num">${scrData.offlineFinCnt}</strong> <em>건</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 누적 ${scrData.offlineFinTot}건</dd>
				</dl>
				<dl class="acState06">
					<dt><span class="hide">라이브교육</span></dt>
					<dd class="info1"><span>${scrData.currentMon}월 <strong class="num">${scrData.liveFinCnt}</strong> <em>건</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 누적 ${scrData.liveFinTot}건</dd>
				</dl>
				<dl class="acState_sns">
					<dt><span class="hide">SNS 공유</span></dt>
					<dd class="info"><span>${scrData.currentMon}월 <strong class="num">${scrData.logSNSCnt}</strong> <em>회</em></span></dd>
					<dd class="infotxt">PF${scrData.PFYear} 누적 ${scrData.logSNSTot}회<span>중복 허용 합산</span></dd>
				</dl>
				<dl class="acState_complete">
					<dt><span class="hide">정규과정 수료</span></dt>
					<dd class="info"><span>${scrData.currentYear}년 <strong class="num point">${scrData.StampRegularCnt}</strong> <em>건</em></span></dd>
					<dd class="infotxt"><span>누적 총 ${scrData.StampRegularTot}건</span></dd>
				</dl>
			</div>
			
			<div class="achWrap">
				<div class="acCalendarWrap">
					<div class="monthly">
						<strong>${scrData.currentYearStamp}</strong>
						<a href="#none" class="monthPrev<c:if test="${not empty scrData.prevYear}"> on</c:if>" <c:if test="${not empty scrData.prevYear}">onclick="javascript:goMonthLink('${scrData.currdateYM }','${scrData.prevYear}');"</c:if>><span>이전년도</span></a>
						<a href="#none" class="monthNext<c:if test="${not empty scrData.nextYear}"> on</c:if>" <c:if test="${not empty scrData.nextYear}">onclick="javascript:goMonthLink('${scrData.currdateYM }','${scrData.nextYear}');"</c:if>><span>다음년도</span></a>
					</div>
					
				</div>
				<h2><img src="/_ui/desktop/images/academy/h2_w030100100_01.gif" alt="일반 스탬프" /></h2>
				<a href="#uiLayerPop_obtain01" class="btnBasicAcWS" onClick="fnAnchor2();">획득조건</a>
			</div>
			<div class="acStampWrapper brd">
				<ul class="acStampList">
				<c:forEach var="item" items="${stampList}" varStatus="status">
					<li><span><img src="/lms/common/imageView.do?file=${item.stampimage}&mode=stamp"  alt="${item.stampimagenote}" /></span><c:if test="${not empty item.obtaindate}"><em>${item.obtaindate}</em></c:if></li>
				</c:forEach>	
				</ul>
			</div>
			
			<div class="achWrap">
				<h2 class="lft"><img src="/_ui/desktop/images/academy/h2_w030100100_02.gif" alt="정규과정 스탬프" /></h2>
				<a href="#uiLayerPop_obtain02" class="btnBasicAcWS" onClick="fnAnchor2();">획득조건</a>
			</div>
			
			<div class="acStampWrapper">
				<ul class="acStampList regular">
				<c:forEach var="itemR" items="${stampRegularList}" varStatus="status">
					<li><span><img src="/lms/common/imageView.do?file=${itemR.stampimage}&mode=stamp"  alt="${itemR.stampimagenote}" /></span><c:if test="${not empty itemR.obtaindate}"><em>${itemR.obtaindate}</em></c:if></li>
				</c:forEach>	
				</ul>
			</div>
			
			<!-- #Layer Popup : 일반 스탬프 획득조건 -->
			<div class="pbLayerWrap" id="uiLayerPop_obtain01" style="width:700px;display:none;">
				<div class="pbLayerHeader">
					<strong><img src="/_ui/desktop/images/academy/h1_w030100100_lp01.gif" alt="일반 스탬프 획득조건"></strong>
					<a href="#none" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="일반 스탬프 획득조건 닫기"></a>
				</div>
				<div class="pbLayerContent">
					<div class="acStampWrapper">
						<ul class="acStampList">
							<c:forEach var="itemN" items="${stampNorList_}" varStatus="status">
							<li><span><img src="/mobile/lms/common/imageView.do?file=${itemN.onimage}&mode=stamp"  alt="${itemN.onimagenote}" /></span> <em>${itemN.stampcontent}</em></li>
							</c:forEach>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp01_on.png" alt="치어리더 1개월" /></span> <em>1개월 동안 <br/>한 주에 한 번 이상 <br/>아카데미 접속</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp02_on.png" alt="치어리더 3개월" /></span> <em>3개월 동안 <br/>한 주에 한 번 이상 <br/>아카데미 접속</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp03_on.png" alt="치어리더 6개월" /></span> <em>6개월 동안 <br/>한 주에 한 번 이상 <br/>아카데미 접속</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp04_on.png" alt="치어리더 1년" /></span> <em>12개월 동안 <br/>한 주에 한 번 이상 <br/>아카데미 접속</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp05_on.png" alt="스마트루키" /></span> <em>온라인 과정 <br/>100회 수강 완료<br/>(동일 강의 중복 허용)</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp06_on.png" alt="익스플로러" /></span> <em>오프라인 과정 <br/>30회 수료 완료</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp07_on.png" alt="베스트컬렉터" /></span> <em>교육 자료 200회 조회 완료<br/>(동일 자료 중복 허용)</em></li>
							<li><span><img src="/_ui/desktop/images/academy/img_acStamp08_on.png" alt="셀레브리티" /></span> <em>SNS 교육 자료 공유 100건<br/>(동일 자료 중복 허용)</em></li>
						</ul>
						치어리더 스탬프는 한 주에 한 번 이상 아카데미 연속으로 접속한 횟수에 의해 발급됩니다.
					</div>
				</div>
				
			</div>
			<!-- //#Layer Popup : 일반 스탬프 획득조건 -->
			
			<!-- #Layer Popup : 정규과정 스탬프 획득조건 -->
			<div class="pbLayerWrap" id="uiLayerPop_obtain02" style="width:700px;display:none;">
				<div class="pbLayerHeader">
					<strong><img src="/_ui/desktop/images/academy/h1_w030100100_lp02.gif" alt="정규과정 스탬프 획득조건"></strong>
					<a href="#none" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="정규과정 스탬프 획득조건 닫기"></a>
				</div>
				<div class="pbLayerContent">
					<div class="acStampWrapper">
						<ul class="acStampList regular">
							<c:forEach var="itemN" items="${stampCourseList_}" varStatus="status">
							<li><span><img src="/mobile/lms/common/imageView.do?file=${itemC.onimage}&mode=stamp"  alt="${itemC.onimagenote}" /></span> <em>${itemC.stampcontent}</em></li>
							</c:forEach>

							<li><span><img src="/_ui/desktop/images/academy/img_acStampR01_on.png" alt="건강영양 아카데미" /></span> <em>건강영양 아카데미 <br/>정규과정 수료</em></li>
							
							<li><span><img src="/_ui/desktop/images/academy/img_acStampR03_on.png" alt="뉴트리라이트 아카데미" /></span> <em>뉴트리라이트 아카데미 <br/>정규과정 수료</em></li>
							
							<li><span><img src="/_ui/desktop/images/academy/img_acStampR07_on.png" alt="뷰티스쿨" /></span> <em>뷰티스쿨 <br/>정규과정 수료</em></li>
							
							<li><span><img src="/_ui/desktop/images/academy/img_acStampR05_on.png" alt="아티스트리 아카데미" /></span> <em>아티스트리 아카데미 <br/>정규과정 수료</em></li>
							
							<li><span><img src="/_ui/desktop/images/academy/img_acStampR04_on.png" alt="뷰티 큐레이터" /></span> <em>뷰티 큐레이터 <br/>정규과정 수료</em></li>

							<li><span><img src="/_ui/desktop/images/academy/img_acStampR02_on.png" alt="요리명장" /></span> <em>요리명장 <br/>정규과정 수료</em></li>

							<li><span><img src="/_ui/desktop/images/academy/img_acStampR06_on.png" alt="비즈니스 리더" /></span> <em>비즈니스 리더 <br/>정규과정 수료</em></li>
							
							
						</ul>
					</div>
				</div>
			</div>
			<!-- //#Layer Popup : 정규과정 스탬프 획득조건 -->
		</section>
		
		
		<!-- //content area  -->
		
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>