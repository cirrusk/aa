<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<c:choose>
	<c:when test="${detail.item.coursetype eq 'D' }">




<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta content="website" property="og:type">
<meta content="한국암웨이" property="og:title">
<meta content="한국암웨이 아카데미" property="og:description">
<meta content="${httpDomain }/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" property="og:url">
<meta content="ABN Korea Academy" property="og:site_name">
<meta content="${httpDomain }/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" property="og:image">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>교육자료 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.link.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.min.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<script type="text/javascript">
	//다운로드
	function fileDown() {
		var nameVal = "";
		var fileVal = "";
		var filedownVal = $("#filedown").val();
		var courseid = "${detail.item.courseid }";
		var arrFiledown = filedownVal.split('|');
		
		if(arrFiledown.length > 1) {
			 nameVal = arrFiledown[0];
			 fileVal = arrFiledown[1];
		}
		
		//showLoading();
		var defaultParam = { name : nameVal, file : fileVal, mode : "course"};
		//postGoto("/mobile/lms/common/downloadFile.do", defaultParam);
		location.href = "/mobile/lms/common/downloadFileCourse.do?method=get&mode=course&courseid="+courseid+"&file="+fileVal; //+"&name="+nameVal;
		//hideLoading();
	}
</script>

</head>


<body>
<div id="pbWrap" class="exWrap">
	<!-- header -->
		<header id="pbExHeader">
		<h1><img src="/_ui/mobile/images/academy/h1_biglogo.gif" alt="암웨이"></h1>
		<p><span>통합교육신청 <em>|</em> </span> <strong>${detail.item.coursetypename }</strong></p>
		</header>
	<!-- //header -->
	<!-- container -->
	<section id="pbContainer">
		<h1 class="hide">한국암웨이 아카데미</h1>

		<section id="pbContent" class="academyWrap">
			<h2 class="hide">교육자료</h2>
			
			<div class="acSubWrap">

				<c:if test="${detail.item.datatype eq 'M'}">
				<!-- 동영상 -->
				<section class="acItems">
					<article class="item">
						<div>	
							<strong class="tit">${detail.item.coursename}</strong>
							<span class="category">${detail.item.categoryname}</span>
							<span class="img videoPlayer">
								<img src="/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
								<a href="${detail.item2.mobilelink}" class="btnPlay">일반화질 재생</a>
								<a href="${detail.item2.mobilelink}" class="btnDef">일반화질</a>
								<a href="${detail.item2.pclink}" class="btnDef high">고화질</a>
							</span>
						</div>
					
						<div class="snsZone">
							<a href="#none" class="like" ><span class="hide">좋아요</span></a>
							<em>${detail.item.likecount}</em>
						<c:if test="${detail.item.snsflag eq 'Y' }">
							<a href="#none" class="share" data-url="${httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }" data-title="${detail.item.coursename }" data-image="${httpDomain }/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
					
						<div class="itemCont">
							<p>${detail.item.coursecontent}</p>
							<p class="date"><span class="catetype2 avi">동영상</span>
							등록일 ${detail.item.registrantdate}<em>|</em>조회 ${detail.item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
			<c:if test="${not empty detail.item2.filelink or not empty detail.item2.filedown}">
				<div class="btnWrap aNumb1">
					<a href="#none" class="btnBasicGNL" onclick="fileDown();">다운로드</a>
				</div>
			</c:if>
				</c:if>
				<c:if test="${detail.item.datatype eq 'S'}">
				<!-- 오디오 -->
				<section class="acItems">
					<article class="item">
						<div>
							<strong class="tit">${detail.item.coursename}</strong>
							<span class="category">${detail.item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
							</span>
						</div>
						<div class="iframeZone">
							<iframe src="${detail.item2.pclink}" frameborder="0" scrolling="no" frameborder="0" title="${detail.item.coursename}"></iframe>
						</div>
						
						<div class="snsZone">
							<a href="#none" class="like" ><span class="hide">좋아요</span></a>
							<em>${detail.item.likecount}</em>
						<c:if test="${detail.item.snsflag eq 'Y' }">
							<a href="#none" class="share" data-url="${httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }" data-title="${detail.item.coursename }" data-image="${httpDomain }/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
						
						<div class="itemCont">
							<p>${item.coursecontent}</p>
							<p class="date"><span class="catetype2 audio">오디오</span>등록일 ${item.registrantdate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
			<c:if test="${not empty detail.item2.filelink or not empty detail.item2.filedown}">
				<div class="btnWrap aNumb1">
					<a href="#none" class="btnBasicGNL" onclick="fileDown();">다운로드</a>
				</div>
			</c:if>
				</c:if>
				<c:if test="${detail.item.datatype eq 'F'}">
				<!-- 문서 -->
				<section class="acItems">
					<article class="item">
						<div>
							<strong class="tit">${detail.item.coursename}</strong>
							<span class="category">${detail.item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
							</span>
						</div>
						<div class="snsZone">
							<a href="#none" class="like" ><span class="hide">좋아요</span></a>
							<em>${detail.item.likecount}</em>
						<c:if test="${detail.item.snsflag eq 'Y' }">
							<a href="#none" class="share" data-url="${httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }" data-title="${detail.item.coursename }" data-image="${httpDomain }/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
						<div class="itemCont">
							<p>${item.coursecontent}</p>
							<p class="date"><span class="catetype2 doc">문서</span>등록일 ${detail.item.registrantdate}<em>|</em>조회 ${detail.item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
			<c:if test="${not empty detail.item2.filelink or not empty detail.item2.filedown}">
				<div class="btnWrap aNumb1">
					<a href="#none" class="btnBasicGNL" onclick="fileDown();">다운로드</a>
				</div>
			</c:if>
				</c:if>
				<c:if test="${detail.item.datatype eq 'L'}">
				<!-- 외부링크 -->
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">${detail.item.coursename}</strong>
							<span class="category">${detail.item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
								<!-- <span class="time">1h20m30s</span> -->
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like" ><span class="hide">좋아요</span></a>
							<em>${detail.item.likecount}</em>
						<c:if test="${detail.item.snsflag eq 'Y' }">
							<a href="#none" class="share" data-url="${httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }" data-title="${detail.item.coursename }" data-image="${httpDomain }/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
						<div class="itemCont">
							<p>${detail.item.coursecontent}</p>
							<p class="date"><span class="catetype2 link">외부링크</span>등록일 ${detail.item.registrantdate}<em>|</em>조회 ${detail.item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
				<div class="btnWrap aNumb1">
					<a href="${detail.item2.pclink}" target="_blank" class="btnBasicGNL">링크보기</a>
				</div>
				</c:if>
				<c:if test="${detail.item.datatype eq 'I'}">
				<!-- 이미지 -->
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">${detail.item.coursename}</strong>
							<span class="category">${detail.item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"  alt="${detail.item.courseimagenote}"  />
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like" ><span class="hide">좋아요</span></a>
							<em>${detail.item.likecount}</em>
						<c:if test="${detail.item.snsflag eq 'Y' }">
							<a href="#none" class="share" data-url="${httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }" data-title="${detail.item.coursename }" data-image="${httpDomain }/mobile/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
						<div class="itemCont">
							<p>${detail.item.coursecontent}</p>
							<p class="date"><span class="catetype2 image">이미지</span>등록일 ${detail.item.registrantdate}<em>|</em>조회 ${detail.item.viewcount}</p>
						</div>
					</article>
				</section>
				<div class="btnWrap aNumb1">
					<a href="${detail.item2.pclink}" target="_blank" class="btnBasicGNL">카드뉴스보기</a>
				</div>
				</c:if>
				<input type="hidden" id="filedown" name="filedown"  value="${detail.item2.filedown }" />
				<input type="hidden" id="filelink" name="filelink"  value="${detail.item2.filelink }" />

					
			</div>
			<div class="acSubWrap">
				<div class="toggleBox attNote">
					<strong class="tggTit"><a href="#none" title="자세히보기 열기">ⓘ 유의사항</a></strong>
					<div class="tggCnt">
						<ul class="listTxt">
							<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
							<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>
			
		</section>
	</section>
</div>

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
			
</body>
</html>



















	</c:when>
	<c:otherwise>
	
	
	
	
	
	
	


<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">

<meta content="website" property="og:type">
<meta content="한국암웨이" property="og:title">
<meta content="한국암웨이 아카데미" property="og:description">
<meta content="${httpDomain }/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" property="og:url">
<meta content="ABN Korea Academy" property="og:site_name">
<meta content="${httpDomain }/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" property="og:image">

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>${detail.item.coursetypename } - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.link.js"></script>
<script src="/_ui/mobile/common/js/apps/kakao.min.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>
<body>
<div id="pbWrap" class="exWrap">
	<!-- header -->
		<header id="pbExHeader">
		<h1><img src="/_ui/mobile/images/academy/h1_biglogo.gif" alt="암웨이"></h1>
		<p><span>통합교육신청 <em>|</em> </span> <strong>${detail.item.coursetypename }</strong></p>
		</header>
	<!-- //header -->
	<!-- container -->
	<section id="pbContainer">
		<h1 class="hide">한국암웨이 아카데미</h1>

		<section id="pbContent" class="academyWrap">
			<div class="acSubWrap">
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">${detail.item.coursename }</strong>
							<span class="category">${detail.item.themename }</span>
							<span class="img">
								<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" alt="${detail.item.courseimagenote}"/>
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like"><span class="hide">좋아요</span></a>
							<em>${detail.item.likecount }</em>
						<c:if test="${detail.item.snsflag eq 'Y' }">
							<a href="#none" class="share" data-url="${httpDomain }/mobile/lms/share/lmsCourseView.do?courseid=${detail.item.courseid }" data-courseid="${detail.item.courseid }" data-title="${detail.item.coursename }" data-image="${httpDomain }/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course"><span class="hide">공유</span></a>
							<div class="detailSns">
								<a href="#uiLayerPop_URLCopy" onclick="layerPopupOpenSnsUrl(this);return false;"><img src="/_ui/mobile/images/common/btn_sns_link.gif" alt="URL 복사"></a>
								<a href="#none" title="새창열림" id="snsKt"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
								<a href="#none" title="새창열림" id="snsKs"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
								<a href="#none" title="새창열림" id="snsBd"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
								<a href="#none" title="새창열림" id="snsFb"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
							</div>
						</c:if>
						</div>
						<div class="itemCont">
							<p>${detail.item.coursecontent }</p>
							<!-- <p class="date">등록일 2013-02-01</p> -->
						</div>
					</article>
				</section>
				
				<div class="eduCont">교육 신청은 <a href="${abnHttpDomain}/academy">ABN &gt; 아카데미</a>에서 가능합니다.</div>		
				
			<c:if test="${detail.item.coursetype eq 'L' }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon1"></span>방송일시</dt>
					<dd>
						<p class="listDot">본방송 : ${detail.item.startdate3 }</p>
					<c:if test="${detail.item2.togetherflag eq 'Y' }">
						<p class="listDot">재방송 : ${detail.item.replaystart3 }</p>
					</c:if>
					</dd>
				</dl>
			</c:if>
			<c:if test="${detail.item.coursetype eq 'R' }">
				<c:set var="apnamestr" value="" />
				<c:if test="${not empty detail.apList }">
					<c:forEach items="${detail.apList }" var="data" varStatus="status">					
						<c:if test="${status.index eq 0 }">
							<c:set var="apnamestr" value="${data.apname }" />
						</c:if>
						<c:if test="${status.index ne 0 }">
							<c:set var="apnamestr" value="${apnamestr }, ${data.apname }" />
						</c:if>
					</c:forEach>
				</c:if>
			
				<dl class="eduCont">
					<dt><span class="eduIcon icon1"></span>교육기간 및 장소</dt>
					<dd>
						<p class="listDot">${detail.item.startdate } ~ ${detail.item.enddate }</p>
						<c:if test="${not empty detail.apList }">
						<p class="listDotFS">장소 : ${apnamestr }</p>
						</c:if>
					</dd>
				</dl>
			</c:if>
			<c:if test="${detail.item.coursetype eq 'F' }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon1"></span>교육일시 및 장소</dt>
					<dd>
						<p class="listDot">${detail.item.startdate3 } ~ ${detail.item.enddate3 }</p>
						<p class="listDot">${detail.item2.apname } ${detail.item2.roomname }</p>
					</dd>
				</dl>
			</c:if>
			
				<dl class="eduCont">
					<dt><span class="eduIcon icon2"></span>신청대상</dt>
					<dd>
						<p class="listDot">${detail.item2.targetdetail }</p>
					</dd>
				</dl>
				
				<dl class="eduCont">
					<dt><span class="eduIcon icon3"></span>신청기간</dt>
					<dd>
						<ul class="listDot">
						<c:forEach items="${detail.reqList }" var="data" varStatus="status">
							<li><strong>${data.pincodename }</strong><br/>
							${data.reqdate }  
							</li>
						</c:forEach>
						</ul>
					</dd>
				</dl>
			</div>
			
			<div class="acSubWrap">
				<div class="toggleBox attNote on">
					<strong class="tggTit"><a href="#none" title="자세히보기 닫기">ⓘ 유의사항</a></strong>
					<div class="tggCnt">
						<ul class="listTxt">
							<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
							<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>
			
		</section>
	</section>
</div>
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
</body>
</html>
	
	
	
	
	
	
	
	
	
	
	
	</c:otherwise>
</c:choose>


