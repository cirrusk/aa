<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>교육자료 - ABN Korea</title>
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
		
		fnAnchor2(); //TOP로 이동
	});
	
	// 상세보기호출
	function goEduResourceLink(courseidVal) {
		$("#lmsEdudataForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsEdudataForm").attr("action", "/mobile/lms/eduResource/lmsEduResourceView.do");
		$("#lmsEdudataForm").submit();
	}

	// 상세보기전 공통호출
	function fnResourceView(courseidVal) {
		var datatype = "${scrData.datatype}";
		var sortColumn = "${scrData.sortColumn}";
		var searchType = "M";
		var searchTxt = "${scrData.searchTxt}";
		var currPage = "${scrData.page}";
		var searchVal = "eduResource|" + datatype + "|" + sortColumn + "|" + searchType + "|" + searchTxt + "|" + currPage + "|";
	
		fnAccesEduView(courseidVal, searchVal);
	}
	
	// 상세보기 
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		$("#lmsEdudataForm > input[name='courseid']").val(courseidVal);
		
		$("#lmsEdudataForm").attr("action", actionUrl);
		$("#lmsEdudataForm").submit();
	}
	
	// 목록으로 이동.
	function listClick() {
		var menuCategoryVal = $("#lmsEdudataForm > input[name='menuCategory']").val();
		if(menuCategoryVal == "") menuCategoryVal = "EduResourceNew";
		
		$("#lmsEdudataForm > input[name='totalCount']").val("");
		
		$("#lmsEdudataForm").attr("action", "/mobile/lms/eduResource/lms" + menuCategoryVal + ".do");
		$("#lmsEdudataForm").submit();
	}
	
	//다운로드
	function fileDown() {
		var nameVal = "";
		var fileVal = "";
		var filedownVal = $("#filedown").val();
		var courseid = $("#lmsEdudataForm > input[name='courseid']").val();
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

<body class="uiGnbM3">

<form id="lmsEdudataForm" name="lmsEdudataForm" method="post">
	<input type="hidden" name="menuCategory"  value="${scrData.menuCategory }" />
	<input type="hidden" name="menuCategoryNm"  value="${scrData.menuCategoryNm }" />
	<input type="hidden" name="menuCategoryImg"  value="${scrData.menuCategoryImg }" />
	<input type="hidden" name="tabViewTypeBox"  value="${scrData.tabViewTypeBox }" />
	
	<input type="hidden" name="datatype"   value="${scrData.datatype }" />
	<input type="hidden" name="sortColumn"   value="${scrData.sortColumn }" />
	<input type="hidden" name="sortOrder"     value="${scrData.sortOrder }" />
	<input type="hidden" name="searchType"   value="M" />
	<input type="hidden" name="searchTxt"  value="${scrData.searchTxt }" />
	
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	
	<input type="hidden" name="courseid"  value="${scrData.courseid }" />
	<input type="hidden" name="categoryid"  value="${scrData.categoryid }" />
</form>
		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">교육자료</h2>
			
			<div class="acSubWrap">
			<c:set var="complianceExist" value="N"/>
			<c:forEach var="item" items="${courseView}" varStatus="status">
				<c:if test="${item.complianceflag eq 'Y'}">
					<c:set var="complianceExist" value="Y" />
				</c:if>
				<c:if test="${item.datatype eq 'M'}">
				<!-- 동영상 -->
				<section class="acItems">
					<article class="item">
						<div>	
							<strong class="tit">${item.coursename}</strong>
							<span class="category">${item.categoryname}</span>
							<span class="img videoPlayer">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;"  />
							<c:if test="${(empty item.mobilelink or item.mobilelink eq '')}">
								<a href="#none" class="btnPlay">일반화질 재생</a>
								<a href="#none" class="btnDef">일반화질</a>
							</c:if>
							<c:if test="${(not empty item.mobilelink and item.mobilelink ne '')}">
								<a href="${item.mobilelink}" class="btnPlay" target="_blank">일반화질 재생</a>
								<a href="${item.mobilelink}" class="btnDef" target="_blank">일반화질</a>
							</c:if>
								<a href="<c:if test="${(empty item.pclink or item.pclink eq '')}">#none</c:if><c:if test="${(not empty item.pclink and item.pclink ne '')}">${item.pclink}</c:if>" class="btnDef high" target="_blank">고화질</a>
							</span>
						</div>
						<!-- <div class="iframeZone">
							<iframe src="${item.pclink}" frameborder="0" scrolling="no" frameborder="0" title="${item.coursename}"></iframe>
						</div> -->
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
						<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
							<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
						</c:if>
						<c:if test="${item.complianceflag ne 'Y'}">
							<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
						</c:if>	
							<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
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
							<p>${item.coursecontentdetail}</p>
							<p class="date"><span class="catetype2 avi">동영상</span>
							등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
				</c:if>
				<c:if test="${item.datatype eq 'S'}">
				<!-- 오디오 -->
				<section class="acItems">
					<article class="item">
						<div>
							<strong class="tit">${item.coursename}</strong>
							<span class="category">${item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" style="width: 100%; height: auto;"  />
							</span>
						</div>
						<div class="iframeZone">
							<iframe src="${item.pclink}" frameborder="0" scrolling="no" frameborder="0" title="${item.coursename}"></iframe>
						</div>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
						<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
							<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
						</c:if>
						<c:if test="${item.complianceflag ne 'Y'}">
							<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
						</c:if>
							<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
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
							<p>${item.coursecontentdetail}</p>
							<p class="date"><span class="catetype2 audio">오디오</span>등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
				<div class="btnWrap aNumb1">
					<c:if test="${(empty item.filelink or item.filelink eq '') and (not empty item.filedown and item.filedown ne '')}">
					<a href="#none" class="btnBasicGNL"  onclick="fileDown();">다운로드</a>	
					</c:if>
					<c:if test="${(empty item.filedown or item.filedown eq '') and (not empty item.filelink and item.filelink ne '')}">
					<a href="${item.filelink}" target="_blank" class="btnBasicGNL">다운로드</a>	
					</c:if>
				</div>
				</c:if>
				<c:if test="${item.datatype eq 'F'}">
				<!-- 문서 -->
				<section class="acItems">
					<article class="item">
						<div>
							<strong class="tit">${item.coursename}</strong>
							<span class="category">${item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
							</span>
						</div>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
						<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
							<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
						</c:if>
						<c:if test="${item.complianceflag ne 'Y'}">
							<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
						</c:if>
						<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
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
							<p>${item.coursecontentdetail}</p>
							<p class="date"><span class="catetype2 doc">문서</span>등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
				<div class="btnWrap aNumb1">
					<c:if test="${(empty item.filelink or item.filelink eq '') and (not empty item.filedown and item.filedown ne '')}">
					<a href="#none" class="btnBasicGNL"  onclick="fileDown();">다운로드</a>	
					</c:if>
					<c:if test="${(empty item.filedown or item.filedown eq '') and (not empty item.filelink and item.filelink ne '')}">
					<a href="${item.filelink}" target="_blank" class="btnBasicGNL">다운로드</a>	
					</c:if>
				</div>
				</c:if>
				<c:if test="${item.datatype eq 'L'}">
				<!-- 외부링크 -->
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">${item.coursename}</strong>
							<span class="category">${item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
								<!-- <span class="time">1h20m30s</span> -->
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
						<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
							<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
						</c:if>
						<c:if test="${item.complianceflag ne 'Y'}">
							<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
						</c:if>
							<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
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
							<p>${item.coursecontentdetail}</p>
							<p class="date"><span class="catetype2 link">외부링크</span>등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</section><!-- //.acItems -->
				<div class="btnWrap aNumb1">
					<c:if test="${empty item.pclink or item.pclink eq ''}"><a href="#none" class="btnBasicGNL"></c:if>
					<c:if test="${not empty item.pclink and item.pclink ne ''}"><a href="${item.pclink}" target="_blank" class="btnBasicGNL"></c:if>
					링크보기</a>
				</div>
				</c:if>
				<c:if test="${item.datatype eq 'I'}">
				<!-- 이미지 -->
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">${item.coursename}</strong>
							<span class="category">${item.categoryname}</span>
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  style="width: 100%; height: auto;" />
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecnt ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecnt}</em>
							<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
							<a href="#none" class="share" data-url="${scrData.httpDomain}/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${scrData.httpDomain }/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
							</c:if>
						<c:if test="${item.complianceflag ne 'Y'}">
							<a href="#none" id="saveitemlab${item.courseid}" class="save<c:if test="${item.savetype eq '2'}"> on</c:if>" onclick="javascript:depositClick('${item.courseid}','saveitemlab${item.courseid}');"><span class="hide">보관함</span></a>
						</c:if>
							<c:if test="${item.snsflag eq 'Y' and item.complianceflag ne 'Y'}">
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
							<p>${item.coursecontentdetail}</p>
							<p class="date"><span class="catetype2 image">이미지</span>등록일 ${item.modifydate}<em>|</em>조회 ${item.viewcount}</p>
						</div>
					</article>
				</section>
				<div class="btnWrap aNumb1">
					<c:if test="${empty item.pclink or item.pclink eq ''}"><a href="#none" class="btnBasicGNL"></c:if>
					<c:if test="${not empty item.pclink and item.pclink ne ''}"><a href="${item.pclink}" target="_blank" class="btnBasicGNL"></c:if>
					카드뉴스보기</a>
				</div>
				</c:if>
				
				<input type="hidden" id="filedown" name="filedown"  value="${item.filedown }" />
			</c:forEach>
			
			<c:if test="${courseView eq null or courseView.size() == 0}">
				<section class="acItems">
					<article class="item">
						<span class="img">
							<img src="/_ui/desktop/images/academy/no_authority.gif" style="min-width:100%; height: auto;" alt="이용 권한이 없습니다." />
						</span>
						<div align="center">이용 권한이 없습니다.</div>
					</article>
				</section>
				<div class="btnWrap aNumb1">
				</div>
			</c:if>
				
				<c:if test="${scrData.openFlag ne 'C' }">
				<div class="nextItems">
				
					<article class="item">
					<c:forEach var="item" items="${courseViewPrev}" varStatus="status">
						<c:set var="coursenames" value="${item.coursename }" />
						<c:if test="${fn:length(coursenames) > 34}"><c:set var="coursenames" value="${fn:substring(coursenames,0,32) }..." /></c:if>
						<a href="#none" title="이전" onClick="javascript:fnResourceView('${item.courseid}');">
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
								<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
							</span>
							<span class="title">[이전] ${coursenames}</span>
						</a>
					</c:forEach>
					<c:if test="${courseViewPrev eq null || courseViewPrev.size() == 0}">
						<a href="#none">
							<span class="img">
								<img src="/_ui/mobile/images/academy/noimage.gif" alt="" />
							</span>
							<span class="title">[이전] 자료가 없습니다.</span>
						</a>
					</c:if>
					</article>
										
					<article class="item">
					<c:forEach var="item" items="${courseViewNext}" varStatus="status">
						<c:set var="coursenames" value="${item.coursename }" />
						<c:if test="${fn:length(coursenames) > 34}"><c:set var="coursenames" value="${fn:substring(coursenames,0,32) }..." /></c:if>
						<a href="#none" title="다음" onClick="javascript:fnResourceView('${item.courseid}');">
							<span class="img">
								<img src="/mobile/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}"  />
								<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S')}"><span class="time">${item.playtime}</span></c:if>
							</span>
							<span class="title">[다음] ${coursenames}</span>
						</a>
					</c:forEach>
					<c:if test="${courseViewNext eq null || courseViewNext.size() == 0}">
						<a href="#none">
							<span class="img">
								<img src="/_ui/mobile/images/academy/noimage.gif" alt="" />
							</span>
							<span class="title">[다음] 자료가 없습니다.</span>
						</a>
					</c:if>
					</article>
					
				</div>
				</c:if>
					
				<a href="#none" class="btnList" onclick="javascript:listClick();">목록</a>
			</div>
			<div class="acSubWrap">
				<div class="toggleBox attNote on">
					<strong class="tggTit"><a href="#none" title="자세히보기 닫기" onclick="javascript:setTimeout(function(){ abnkorea_resize(); }, 500);">ⓘ 유의사항</a></strong>
					<div class="tggCnt">
						<ul class="listTxt">
							<li>한국암웨이 ABN 아카데미에서 서비스되는 일체의 콘텐츠에 대한 지적 재산권은 한국암웨이(주)에 있으며, 임의로 자료를 수정/변경하여 사용하거나, 기타 개인의 영리 목적으로 사용할 경우에는 지적 재산권 침해에 해당하는 사안으로, 그 모든 법적 책임은 콘텐츠를 불법으로 남용한 개인 또는 단체에 있습니다.</li>
							<li>모든 자료는 원저작자의 요청이나 한국암웨이의 사정에 따라 예고 없이 삭제될 수 있습니다.</li>
						<c:if test="${complianceExist eq 'Y' or scrData.menuCategory eq 'EduResourceMusic' }">
							<li>건강영양 &middot; 음원자료실 카테고리의 자료는 ABO를 대상으로 배포된 자료로 SNS를 통한 공유 및 보관함 담기는 제한되어 있습니다.</li>
						</c:if>
						</ul>
					</div>
				</div>
			</div>
			
		</section>
		<!-- content ##iframe end## -->

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
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>