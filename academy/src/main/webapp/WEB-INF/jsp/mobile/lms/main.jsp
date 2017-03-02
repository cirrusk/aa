<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>아카데미 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/_ui/mobile/common/js/jquery.event.drag-1.5.min.js"></script>
<script src="/_ui/mobile/common/js/jquery.touchSlider.js"></script>
<script src="/_ui/mobile/common/js/jquery.touchSlider2.js"></script>

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

	$(document).ready(function() { 
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
		
		goPageMoreBtn();
	});

	// 더보기, top 버튼 컨트롤
	function goPageMoreBtn() {
		var totalPageVal = $("#lmsForm > input[name='totalPage']").val();
		var pageVal = $("#lmsForm > input[name='page']").val();
		
		if(totalPageVal == 0 || totalPageVal == pageVal) {
			$("#moreBtn").hide();
			$("#topBtn").show();
		}
	}
	
	// 알림 이동
	function fnMessNote() {
		var addUrl = "${scrData.httpRootDomain}" + "/mypage/noteSend";
		
		parent.location.href = addUrl ;
	}
	
	//상세보기호출
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		var addUrl = "${scrData.httpRootDomain}" + actionUrl;
		
		parent.location.href = addUrl + "?courseid=" + courseidVal ;
		
	}
	
	// 더보기 
	function nextPage(){
		
		var urlVal = "/mobile/lms/mainMoreAjax.do";
		
		var rowPerPageVal = $("#lmsForm > input[name='rowPerPage']").val();
		var totalCountVal = $("#lmsForm > input[name='totalCount']").val();
		var firstIndexVal = $("#lmsForm > input[name='firstIndex']").val();
		var totalPageVal = $("#lmsForm > input[name='totalPage']").val();
		var pageVal = $("#lmsForm > input[name='page']").val();
		
		var nextPage = Number(pageVal) + 1;
		$("#lmsForm > input[name='page']").val(nextPage);
		if(nextPage >= totalPageVal){ 	$("#nextPage").hide(); }
		
		var params = {page:nextPage, rowPerPage:rowPerPageVal, totalCount:totalCountVal, firstIndex:firstIndexVal, totalPage:totalPageVal};
		
		$.ajaxCall({
	   		url: urlVal
	   		, data: params
	   		, dataType: "html"
	   		, success: function( data, textStatus, jqXHR){
	   			$("#articleSection").append($(data).filter("#articleSection").html());
	   			$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
	   			setTimeout(function(){ abnkorea_resize(); }, 500);
	   		}
	   	});
		
		goPageMoreBtn();
	}

</script>
</head>
<body class="uiGnbM3">
		
<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	<input type="hidden" name="courseid"  value="" />
</form>

	<!-- ### academy IFRAME Start ### -->
	<div id=""academyMain"" class="acMain">
		<div id="pbContent">
			 <section class="acMainSection">
			 <c:if test="${empty scrData.uid}">
			 	<h2 class="hide">로그인 하시면 더 많은 서비스를 이용하실 수 있습니다.</h2>
			 </c:if>
			 <c:if test="${not empty scrData.uid}"> 
			 	<h2 class="hide">맞춤 쪽지</h2>
				<div class="acMainNote">
					<c:set var="notecontent" value="${scrData.notecontent }" />
					<c:if test="${fn:length(notecontent) > 46}"><c:set var="notecontent" value="${fn:substring(notecontent,0,45)}..." /></c:if>
					
					<a href="#none" onclick="javascript:fnMessNote();"><em>${notecontent}</em></a>
					<a href="#none" class="btnMore" onclick="javascript:fnMessNote();"><span class="hide">더보기</span></a>
				</div>
			</c:if>
			</section>
			
			<!-- 20160926 수정 -->
			<div class="touchSliderWrap spPlaneEx">
				<a href="#none" class="btnPrev"><img src="/_ui/mobile/images/common/ico_slidectrl_prev2.png" alt="이전"></a>
				<a href="#none" class="btnNext"><img src="/_ui/mobile/images/common/ico_slidectrl_next2.png" alt="다음"></a>
				<div class="touchSlider" id="touchSlider">
					<ul>
					<c:choose>
						<c:when test="${bannerList ne null and bannerList.size() > 0}">
							<c:forEach var="item" items="${bannerList}" varStatus="status">
								<li>
								<c:choose>
								<c:when test="${appyn eq 'Y' and item.mobiletarget eq 'OUT' }">
									<a href="#none" onclick="chromeOpen('${item.mobilelink}');">
								</c:when>
								<c:otherwise>
									<a href="${item.mobilelink }" ${item.mobiletargetstr }>
								</c:otherwise>
								</c:choose>
								<img src="/lms/common/imageView.do?file=${item.mobileimage}&mode=course" alt="${item.mobileimagenote}" /></a></li>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<!-- 배너가 없는 경우 -->
							<li><a href="#none"><img src="/_ui/mobile/images/academy/@img_acMainBnr01.jpg" alt=""></a></li>
							<li><a href="#none"><img src="/_ui/mobile/images/academy/@img_acMainBnr02.jpg" alt=""></a></li>
							<li><a href="#none"><img src="/_ui/mobile/images/academy/@img_acMainBnr03.jpg" alt=""></a></li>
						</c:otherwise>
					</c:choose>
					</ul>
				</div>
				<div class="sliderPaging colorG"></div>
			</div>
			<script type="text/javascript">touchsliderFn();</script>
			<!-- //20160926 수정 -->
			
			 <section id="pageLocationTop" class="acMainSection">
			 	<c:if test="${empty scrData.uid}">
				<h2><span>처음 만나는 암웨이</span></h2>
				</c:if>
			 	<c:if test="${not empty scrData.uid}">
				 	<c:set var="userName" value="${scrData.name}" />
					<c:if test="${fn:length(userName) > 12}"><c:set var="userName" value="${fn:substring(userName,0,10) }..." /></c:if>
				<h2><span>${userName}</span>님을 위한 맞춤 교육 콘텐츠</h2>
			 	</c:if>
			 	<h2 class="hide">추천 콘텐츠</h2>
				<div class="acMainContents">
					<section id="articleSection" class="acItems">
						<c:if test="${courseList eq null or courseList.size() == 0}">
							<c:if test="${empty scrData.uid}">
								<article class="item">
									<div class="nodata">추천 콘텐츠가 없습니다.</div>
								</article>
							</c:if>
							<c:if test="${not empty scrData.uid}">
								<article class="item">
									<div class="nodata">맞춤 교육 콘텐츠가 없습니다.</div>
								</article>
							</c:if>
						</c:if>
					
						<c:forEach var="item" items="${courseList}" varStatus="status">
						<article class="item<c:if test="${item.savetype eq '1'}"> selected</c:if>">
							<a href="#none" onClick="javascript:fnAccesViewClick('${item.courseid}','main');">
								<c:set var="coursename" value="${item.realcoursename }" />
								<c:if test="${item.coursetype eq 'F'}">
									<c:set var="coursename" value="[${item.apname }] ${item.realcoursename }" />
								</c:if>
								<c:if test="${fn:length(coursename) > 33}">
									<c:set var="coursename" value="${fn:substring(coursename,0,31) }..." />
								</c:if>
								<strong class="tit">${coursename}</strong>
								<span class="category">
								<c:choose>
									<c:when test="${item.coursetype eq 'O' or item.coursetype eq 'D'}">
										<span class="cate">[${item.coursetypename}]</span>&nbsp;${item.categoryname}
									</c:when>
									<c:when test="${item.coursetype eq 'R'}">
										<span class="catebox">${item.coursetypename}</span>&nbsp;신청&nbsp;:&nbsp;${item.requeststartdate}&nbsp;~&nbsp;${item.requestenddate}
									</c:when>
									<c:when test="${item.coursetype eq 'L'}">
										<span class="catebox">${item.coursetypename}</span>&nbsp;방송&nbsp;:&nbsp;${item.startdate}
									</c:when>
									<c:otherwise>
										<span class="catebox">${item.coursetypename}</span>&nbsp;교육&nbsp;:&nbsp;${item.startdate}
									</c:otherwise>
								</c:choose>
								</span>
								<span class="img">
									<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;" />
									<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if>
									<c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if>
									<c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if>
									<c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if>
									<c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
									<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>
								</span>
							</a>
							<div class="snsZone">
								<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
								<em id="likecntlab${item.courseid}">${item.likecnt}</em>
								<c:if test="${item.snsflag eq 'Y' }"	>
									<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
								</c:if>
								<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}">
									<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.depositcnt ne '0'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
								</c:if>
								<c:if test="${item.snsflag eq 'Y' }"	>
									<div class="detailSns">
										<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
										<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
										<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
										<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
										<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
									</div>
								</c:if>
							</div>
						</article>
						</c:forEach>	
					</section><!-- //.acItems -->
				</div>
				
				<div id="moreBtn">
					<a href="#none" id="nextPage" class="listMore" onclick="nextPage();"><span>20개 더보기</span></a>
				</div>
				<div id="topBtn" style="display:none">
					<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
				</div>
			</section>
		</div>
	</div>
	<!-- // ### academy IFRAME End ### -->
	

<!-- SNS layer popup -->
<div class="pbLayerPopup" id="uiLayerPop_URLCopy">
	<div class="alertContent">
		<h2 class="hide">URL 복사</h2>
		<em>복사하기 하여, <br>원하는 곳에 붙여넣기 해주세요</em>
		<input type="text" title="URL 주소" class="url" id="pbLayerPopupUrl" value=""><input type="hidden" id="snsCourseid" value="">
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>
<!-- //SNS layer popup -->

<script type="text/javascript">
$(document).ready(function() {
	var $slide = $("#acMainslide");
	var $btnAutoplay = $(".acMainslideWrap .btnAutoplay");
	$slide.owlCarousel({
      navigation : true, // Show next and prev buttons
      pagination : false,
      singleItem:true,
      stopOnHover : true,
      autoPlay : 5000
    });
});
</script>
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>