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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>정규과정 - ABN Korea</title>
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
$(document).ready(function() {
	setTimeout(function(){ abnkorea_resize(); }, 500);
	$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
	var courseid = $("#goViewForm > input[name='courseid']").val();
	var back = $("#goViewForm > input[name='back']").val();
	if(back != "Y"){
		fnAnchor2();	
	}else{
		fnAnchor2();
		//포커스 이동 필요
	}
});
// 상세보기 호출
function goViewLink(sCode, sMsg, courseidVal, actionUrl) {
	$("#goViewForm > input[name='courseid']").val(courseidVal);
	$("#goViewForm").attr("action", actionUrl);
	$("#goViewForm").submit();
}
// 다음 20개 더보기
function nextPage(){
	var page = $("#goViewForm > input[name='page']").val();
	var nextPage = Number(page) + 1;
	$("#goViewForm > input[name='page']").val(nextPage);
	var back = $("#goViewForm > input[name='back']").val();
	$("#goViewForm > input[name='back']").val("");
	var totalPage = $("#goViewForm > input[name='totalPage']").val();
	if(nextPage >= totalPage){
		$("#nextPage").hide();
	}
	callList(nextPage, back);
}
function callList(page, back){
	$.ajaxCall({
   		url: "/mobile/lms/request/lmsCourse.do"
   		, data: {page: page, back: back}
   		, dataType: "html"
   		, success: function( data, textStatus, jqXHR){
   			$("#articleSection").append($(data).find("#articleSection"));
   			abnkorea_resize();
   			$(".img").find("img").load(function(){abnkorea_resize();});  // 이미지로드 완료시 호출.
   		}
   	});
}
</script>

</head>
<body class="uiGnbM3">

		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">통합교육신청 정규과정</h2>
			
			<div class="acSubWrap" id="articleDiv">
				<section class="acItems" id="articleSection">
				<c:forEach items="${courseList }" var="item" varStatus="status">
					<article class="item<c:if test='${item.requestflag eq "Y" }'> selected</c:if>" id="data${item.courseid }">
						<a href="javascript:;" onclick="fnAccesViewClick('${item.courseid }', 'request');">
							<strong class="tit">${item.coursename }</strong>
							<span class="img">
								<img src="/lms/common/imageView.do?file=${item.courseimage}&mode=course" alt="${item.courseimagenote}" />
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${item.courseid}','likecntlab${item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${item.courseid}">${item.likecount }</em>
						<c:if test="${item.snsflag eq 'Y' }"	>
							<a href="#none" class="share" data-url="${httpDomain }/mobile/lms/share/lmsCourseView.do?courseid=${item.courseid }" data-courseid="${item.courseid }" data-title="${item.coursename }" data-image="${httpDomain }/lms/common/imageView.do?file=${item.courseimage}&mode=course"><span class="hide">공유</span></a>
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
							<p>
								<span class="tit">대상</span>${item.target }<br>
								<span class="tit">교육</span>${item.startdate4 } ~ ${item.enddate4 }<br />
								<span class="tit">신청</span>${item.requeststartdate5 } ~ ${item.requestenddate5 }<br />
							</p>
							<!-- <p class="date">등록일 2013-02-01</p> -->
						</div>
					</article>
				</c:forEach>
				
				<c:if test="${empty courseList and (scrData.page eq '1' or scrData.page eq '0')  }">
					<article class="item">
						<div class="nodata">등록된 정규과정이 없습니다.</div>
					</article>
				</c:if>			
			
				</section>
				
				<c:if test="${scrData.totalPage ne scrData.page and scrData.page ne '0' }">
				<a href="#none" class="listMore" id="nextPage" onclick="nextPage();"><span>20개 더보기</span></a>
				</c:if>
				<c:if test="${scrData.totalCount ne '0'  }">
					<a href="#none" class="listMoreTop" onclick="fnAnchor2();"><span>TOP</span></a>
				</c:if>

			</div>
			
		</section>
		<!-- content ##iframe end## -->

<form name="goViewForm" id="goViewForm" action="/mobile/lms/request/lmsCourseView.do">
	<input type="hidden" name="courseid" value="${scrData.courseid }">
	<input type="hidden" name="page" value="${scrData.page }">
	<input type="hidden" name="back" value="${scrData.back }">
	<input type="hidden" name="totalPage" value="${scrData.totalPage }">
</form>
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