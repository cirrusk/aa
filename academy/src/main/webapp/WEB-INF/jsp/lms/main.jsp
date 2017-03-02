<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%//@ include file="/WEB-INF/jsp/framework/include/header.jsp" 
%>
<%//@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" 
%>
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
<title>아카데미 - ABN Korea</title>
<!--[if lt IE 9]>
	<script src="/_ui/desktop/common/js/html5.js"></script>
	<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
	<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
	<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
	<script src="/_ui/desktop/common/js/owl.carousel2.js"></script><!-- 2017-02-10 새로운 버젼 js 로 파일교체 * Owl Carousel v2.2.0 * Copyright 2013-2016 David Deutsch * Licensed under MIT (https://github.com/OwlCarousel2/OwlCarousel2/blob/master/LICENSE) -->
	<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
	<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
	<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
	
<script src="/js/front.js"></script>
<script src="/js/lms/lmsComm.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">

	$(document.body).ready(function() {
		
		fnMemberGrade("pinLevelImg", "rtnFn"); // 멤버이미지 요청
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
		
		/* 2017-02-10 추가 */
		var owl = $('.acMainslider');
	    owl.owlCarousel({
	        items: 1,
	        loop: true,
	        nav:true,
	        autoplay: true,
	        autoplayTimeout: 3000,
	        autoplayHoverPause: true,
	    });
		
		owl.on('mouseenter',function(){ 
			owl.trigger('stop.owl.autoplay'); 
		})
		owl.on('mouseleave',function(){ 
			owl.trigger('play.owl.autoplay'); 
		});
		/* 2017-02-10 추가 */
		/* 2017-02-10 삭제
		var $slide = $("#acMainslide");
		$slide.owlCarousel({
			items : 1,
			singleItem : true,
			pagination : true, 
			navigation : true,
			autoPlay : 3000,
			stopOnHover : true
		});
		
		btnstopPosition();
		function btnstopPosition(){
			var $itemWrap = $(".owl-pagination");
			var $item = $(".owl-page");
			var $itemNum = $item.length-1;
			var $itemDefault = 1;
			var $itemW = 	$item.eq(1).width();
			var $itemActiveW = 	$item.eq(0).width();
			var $itemWrapLeft=(($itemNum*$itemW)+ ($itemDefault*$itemActiveW))/2;
			var $rollLeft=(($itemNum*$itemW)+ ($itemDefault*$itemActiveW))/2 + 5;
			var $btnAutoplay = $(".acMainslideWrap .btnAutoplay");
			
			$itemWrap.css('margin-left', -$itemWrapLeft);
			$btnAutoplay.css('margin-left', $rollLeft);
			$btnAutoplay.click(function(){
				$(this).toggleClass("autoplay");
				if($(this).is(".autoplay")){
					$slide.trigger('owl.stop', 3000);
					$(this).find("span").html("자동롤링 시작");
				} else {
					$slide.trigger('owl.play', 3000);
					$(this).find("span").html("자동롤링 정지");
				}
			});
		}
		*/
		
		
		$("#categorySaveButton").on("click", function(){
			if(!confirm("카테고리 구독 설정을 저장하시겠습니까?")) {
				return;
			}
			//체크확인
			var categorytypes = "";
			$("input[name='check_mycategory']:checked").each(function(){
				categorytypes += $(this).val() + ",";
			});
			if( categorytypes == "" ) {
				//alert("구독할 카테고리를 선택하세요.");
				//return;
			} else {
				categorytypes = categorytypes.substring(0,categorytypes.length-1);
			}
			
			var param = {
				categorytypes : categorytypes
			}
			$.ajaxCall({
		   		url: "/lms/myAcademy/lmsMyRecommendCategorySaveAjax.do"
		   		, data: param 
		   		, dataType: "json"
		   		, success: function( data, textStatus, jqXHR){
		   			if( data.result == "SUCCESS" ) {
		   				$(location).attr("href","/lms/main.do");
		   			} else if( data.result == "FAIL" ) {
		   				$("#categoryCancelButton").trigger("click");
		   				alert("처리도중 오류가 발생하였습니다.");
		   			} else if( data.result == "LOGOUT" ) {
		   				fnSessionCall("");
		   			}
		   		}
		   		, error: function( jqXHR, textStatus, errorThrown) {
		        	alert("처리도중 오류가 발생하였습니다.");
		   		}
		   	});
		});
		
		$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
		
	});

	// 알림 이동
	function fnMessNote() {
		var addUrl = "${scrData.httpRootDomain}" + "/mypage/noteSend";
		
		parent.location.href = addUrl ;
	}
	
	// 상세보기호출
	function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
		var addUrl = "${scrData.httpRootDomain}" + actionUrl;
		
		parent.location.href = addUrl + "?courseid=" + courseidVal ;
	}

	var fnCategory = function() {
		//카테고리 설정 값 읽어오기
		var param = {};
		$.ajaxCall({
	   		url: "/lms/myAcademy/lmsMyRecommendCategoryReadAjax.do"
	   		, data: param 
	   		, dataType: "json"
	   		, success: function( data, textStatus, jqXHR){
	   			if( data.result == "SUCCESS" ) {
	   				for( var i=0; i<data.categoryArr.length; i++ ) {
	   					if( data.categoryArr[i] == "Y" ) {
	   						$("#lb_cate0"+ (i+1)).prop("checked",true);	
	   					} else {
	   						$("#lb_cate0"+ (i+1)).prop("checked",false);
	   					}
	   				}
	   			} else if( data.result == "LOGOUT" ) {
	   				fnSessionCall("");
	   			}
	   		}
	   		, error: function( jqXHR, textStatus, errorThrown) {
	        	alert("처리도중 오류가 발생하였습니다.");
	   		}
	   	});
	}
	
	//회원등급 적용(멤버이미지)
	function fnRtnMemberGrade(rtnVal) {
		$("#pinLevelImg").addClass(rtnVal);
		if(rtnVal == "pinLevelLgMember") $("#categoryLabel").hide();
	}
	
	// 더보기 
	function nextPage(){
		var urlVal = "/lms/mainMoreAjax.do";
		
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
	   			abnkorea_resize();
	   		}
	   	});
	}
	
</script>
	
</head>

<body>

<form id="lmsForm" name="lmsEdudataForm" method="post">
	<input type="hidden" name="rowPerPage"  value="${scrData.rowPerPage }" />
	<input type="hidden" name="totalCount"  value="${scrData.totalCount }" />
	<input type="hidden" name="firstIndex"  value="${scrData.firstIndex }" />
	<input type="hidden" name="totalPage"  value="${scrData.totalPage }" />
	<input type="hidden" name="page"  value="${scrData.page }" />
	<input type="hidden" name="courseid"  value="" />
</form>

	<!-- ### academy IFRAME Start ### -->
	<div id="academyMain" class="academyMain">
	
		<!-- content area  -->
		<section id="pbContent">
			<h2 class="hide">아카데미 메인</h2>
			<div class="personalArea">
				<!-- 로그인 전 -->
				<div class="loginBefore<c:if test="${not empty scrData.uid}"> none</c:if>">로그인 후에 더 많은 아카데미의 서비스를 이용하실 수 있습니다. [<a href="${scrData.loginUrl}" target="_top">로그인</a>]&nbsp;&nbsp;ABO가 아니시라면 지금 가입하세요! [<a href="${scrData.addUrl}" target="_top">회원가입</a>]</div>
				<!-- 로그인 후 -->
				<div class="loginAfter<c:if test="${empty scrData.uid}"> none</c:if>">
					<c:set var="notecontent" value="${scrData.notecontent }" />
					<c:if test="${fn:length(notecontent) > 46}"><c:set var="notecontent" value="${fn:substring(notecontent,0,45)}..." /></c:if>
					
				 	<div class="currentSec"><a href="#none" onclick="javascript:fnMessNote();"><strong>${scrData.notesendCnt}</strong> <em>|</em> ${notecontent}<img src="/_ui/desktop/images/academy/ico_more.gif" class="more" alt="맞춤쪽지목록" /> </a></div>					
					<div class="level"><span id="pinLevelImg"></span> <a href="#none">${scrData.name}님</a></div>
				</div>
			</div>
			
			<!-- //acMainslideWrap -->
			<div class="acMainslideWrap">
				<div id="acMainslide" class="acMainslider">
				<c:choose>
					<c:when test="${bannerList ne null and bannerList.size() > 0}">
						<c:forEach var="item" items="${bannerList}" varStatus="status">
							<div class="item"><a href="${item.pclink }" ${item.pctargetstr }><img src="/lms/common/imageView.do?file=${item.pcimage}&mode=course" alt="${item.pcimagenote}" /></a></div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="item"><a href="#none"><img src="/_ui/desktop/images/academy/@img_acMainBnr01.jpg" alt="" /></a></div>
					</c:otherwise>
				</c:choose>
				</div>
				<div class="acMainSliderNavi">
					<!--<a href="#none" class="btnAutoplay"><span class="hide">자동롤링 정지</span></a> 2017-02-10 삭제 -->
				</div>
			</div>
			<!-- //acMainslideWrap -->
			
			<div class="acMainCon">
				<div id="pageLocationTop" class="hWrap">
				<c:if test="${not empty scrData.uid}">
					<c:set var="userName" value="${scrData.name}" />
					<c:if test="${fn:length(userName) > 12}"><c:set var="userName" value="${fn:substring(userName,0,10) }..." /></c:if>
					<h3>${userName}님을 위한 <img src="/_ui/desktop/images/academy/h3_w030000010_1.gif" alt="맞춤 교육 콘텐츠" /><span>빅데이터 분석을 통한 맞춤 교육 제안!</span></h3>
					<span id="categoryLabel" class="rightWrap"><c:if test="${scrData.aboMem eq 'Y'}"><a href="#uiLayerPop_settingCate" class="btnBasicAcWS" onclick="javascript:fnCategory();fnAnchor2();">카테고리 구독 설정</a></c:if></span>
				</c:if>
				<c:if test="${empty scrData.uid}">
					<h3><img src="/_ui/desktop/images/academy/h3_w030000010_0.gif" alt="처음 만나는 암웨이" /><span>보다 나은 삶을 제공하는 암웨이를 만나보세요</span></h3>
				</c:if>
				</div>
				
				<div class="acMainContents">
					<c:if test="${courseList eq null or courseList.size() == 0}">
						<c:if test="${empty scrData.uid}">
							<div class="noItems">추천 콘텐츠가 없습니다.</div>
						</c:if>
						<c:if test="${not empty scrData.uid}">
							<div class="noItems">맞춤 교육 콘텐츠가 없습니다.</div>
						</c:if>
					</c:if>
					<c:if test="${courseList ne null and courseList.size() > 0}">
					<div id="articleSection" class="acItems">
						<c:forEach var="item" items="${courseList}" varStatus="status">
						<div class="item<c:if test="${item.savetype eq '1'}"> selected</c:if>">
							<a href="#none" class="acThumbImg" onClick="javascript:fnAccesViewClick('${item.courseid}','main');">
								<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course"  alt="${item.courseimagenote}" />
								<c:if test="${item.datatype eq 'M'}"><span class="catetype avi">동영상</span></c:if><c:if test="${item.datatype eq 'S'}"><span class="catetype audio">오디오</span></c:if><c:if test="${item.datatype eq 'F'}"><span class="catetype doc">문서</span></c:if><c:if test="${item.datatype eq 'L'}"><span class="catetype out">링크</span></c:if><c:if test="${item.datatype eq 'I'}"><span class="catetype img">이미지</span></c:if>
								
								<c:if test="${not empty item.playtime and (item.datatype eq 'M' or item.datatype eq 'S' or item.coursetype eq 'O')}"><span class="time">${item.playtime}</span></c:if>

								<c:set var="coursename" value="${item.realcoursename }" />
								<c:if test="${item.coursetype eq 'F'}">
									<c:set var="coursename" value="[${item.apname }] ${item.realcoursename }" />
								</c:if>
								<c:if test="${fn:length(coursename) > 33}">
									<c:set var="coursename" value="${fn:substring(coursename,0,31) }..." />
								</c:if>
								<span class="tit">${coursename}</span>
							</a>
							<div>
								<c:if test="${item.coursetype eq 'O' or item.coursetype eq 'D'}"><span class="menu">[${item.coursetypename}]</span>&nbsp;<span class="cate">${item.categoryname}</span></c:if>
								<c:if test="${item.coursetype ne 'O' and item.coursetype ne 'D'}"><span class="menubox">${item.coursetypename}</span></c:if>
								
								<a href="#none" class="scLike <c:if test="${item.mylikecnt ne '0'}">on</c:if>" <c:if test="${not empty scrData.uid}">onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}','1');"</c:if>><span class="hide">좋아요</span><em id="likecntlab${item.courseid}">${item.likecnt}</em></a>
							</div>
						</div>
						</c:forEach>
					</div>
					</c:if>
					<c:if test="${scrData.totalPage ne scrData.page}">
					<div class="btnWrapC" id="btnMorelist">
						<a href="#none" id="nextPage" class="btnBasicAcWXL" onclick="nextPage();">더보기 +</a>
					</div>
					</c:if>
				</div>
			</div>
			
			<!-- #Layer Popup : 카테고리 구독 설정 -->
			<div class="pbLayerWrap" id="uiLayerPop_settingCate" style="width:600px;display:none;">
				<div class="pbLayerHeader">
					<strong><img src="/_ui/desktop/images/academy/h1_w030000010_lp.gif" alt="카테고리 구독 설정"></strong>
					<a href="#none" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="카테고리 구독 설정 닫기"></a>
				</div>
				<div class="pbLayerContent">
					<div class="acMainPopup">
						<p class="textC">
							<strong>구독을 하시면 해당 카테고리의 업데이트 시 맞춤 알림을 받을 수 있습니다.</strong> (중복 선택 가능)</p>
						<div class="acInputWrap">
							<input type="checkbox" id="lb_cate01" name="check_mycategory" value="1" /><label for="lb_cate01">비즈니스</label>
							<input type="checkbox" id="lb_cate02" name="check_mycategory" value="2" /><label for="lb_cate02">뉴트리라이트</label>
							<input type="checkbox" id="lb_cate03" name="check_mycategory" value="3" /><label for="lb_cate03">아티스트리</label>
							<input type="checkbox" id="lb_cate04" name="check_mycategory" value="4" /><label for="lb_cate04">퍼스널케어</label>
							<input type="checkbox" id="lb_cate05" name="check_mycategory" value="5" /><label for="lb_cate05">홈리빙</label>
							<input type="checkbox" id="lb_cate06" name="check_mycategory" value="6" /><label for="lb_cate06">레시피</label>
						</div>
					</div>
					<div class="btnWrapC">
						<a href="#none" id="categoryCancelButton" class="btnBasicAcGS layerPopClose">취소</a>
						<a href="#none" id="categorySaveButton" class="btnBasicAcGNS">저장</a>
					</div>
					
				</div>
			</div>
			<!-- //#Layer Popup : 목표설정 -->

		</section>
		<!-- //content area  -->
		
	</div>
	<!-- // ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>
