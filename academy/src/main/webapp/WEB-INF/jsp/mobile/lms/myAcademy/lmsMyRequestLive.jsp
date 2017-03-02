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
<title>통합교육신청 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<style>
.pbLayerPopup#uiLayerPop_acApp{top:50px !important} /* 팝업위치 */
</style>
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		if(navigator.userAgent.match(/android/i)){
			$("#amwaygo_android").show();
		}
		if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
			$("#amwaygo_iphone").show();
		}
		$(".popCloseConfirm").click(function(){
			$(".btnPopClose").trigger("click");
		});
		setTimeout(function(){ abnkorea_resize(); }, 500);
		fnAnchor2();
	});
	function cancelCourse(courseid){
		if(!confirm("신청취소 하시겠습니까?")){return;}
		$.ajaxCall({
			url: "/mobile/lms/myAcademy/lmsMyRequestCancelAjax.do"
			, data: {courseid : courseid}
			, success: function(data, textStatus, jqXHR){
				alert(data.msg);
				if(data.result == "LOGOUT"){
	   				fnSessionCall("");
	   				return;
				}else if(data.result == "OK"){
					$("#cancelCourseDiv").hide();
					$("#statusStr").html("취소");
					$(".actionbutton").html("");
				}
			},
			error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
			}
		});
	}
	function goList(){
		var viewtype = $("#searchForm input[name='viewtype']").val();
		if(viewtype != "1"){
			$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequest.do");
		}else{
			$("#searchForm").attr("action", "/mobile/lms/myAcademy/lmsMyRequestList.do");
		}
		$("#searchForm").submit();
	}
	function showLive(courseid, status){
		if(status != "Y"){
			alert("방송 시간이 아닙니다.");
			return;
		}
		top.document.location.href = "${abnHttpDomain}/lms/liveedu/lmsLiveEdu?courseid=" + courseid;
	}
	function gotolinkurl(url){
		if(url.indexOf("\:\/\/") < 0){
			url = "http://"+url
		}
		window.open(url);
	}
</script>
</head>
<body class="uiGnbM3">
<form name="searchForm" id="searchForm" method="post">
<input type="hidden" name="searchyn"  value="Y" />
<input type="hidden" name="searchClickYn" value="Y" />
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="courseid" value="${param.courseid }">
<input type="hidden" name="coursetype">
<input type="hidden" name="back" value="Y">
<input type="hidden" name="searchyear" value="${param.searchyear}">
<input type="hidden" name="searchmonth" value="${param.searchmonth }">
<input type="hidden" name="searchday" value="01">
<c:forEach items="${paramValues.searchcoursetype }" var="data">
<input type="hidden" name="searchcoursetype" value="${data }">
</c:forEach>
<input type="hidden" name="searchstatus" value="${param.searchstatus }">
<input type="hidden" name="searchstartdate" value="${param.searchstartdate }">
<input type="hidden" name="searchenddate" value="${param.searchenddate }">
<input type="hidden" name="searchstartyear" value="${param.searchstartyear }">
<input type="hidden" name="searchstartmonth" value="${param.searchstartmonth }">
<input type="hidden" name="searchendyear" value="${param.searchendyear }">
<input type="hidden" name="searchendmonth" value="${param.searchendmonth }">
<input type="hidden" name="searchtext" value="${param.searchtext }">
<input type="hidden" name="page"  value="${param.page }" />
		

		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">통합교육신청현황 상세</h2>

			<div class="eduStateBox">
				<dl class="eduSummary">
					<dt><strong>${detail.coursename }</strong>
						<span class="category">${detail.themename }</span> <span class="catebox">라이브교육</span>
						<c:if test="${detail.groupflag eq 'Y' }">
						<a href="#uiLayerPop_acApp" onclick="layerPopupOpen(this); return false;"><img src="/_ui/mobile/images/academy/amwaygo_flag_mob.png" alt="AmwayGo!" class="flag" /></a>
						</c:if>
					</dt>
					<dd>
						<div><span class="tit">신청일</span>${detail.requestdatestr2 }</div>
						<div><span class="tit">본방송</span>${detail.startdatestr2 } ${detail.startdatehh } </div>
					<c:if test="${not empty detail.livereplaylink }">
						<div><span class="tit">재방송</span>${detail.replaystartstr2 } ${detail.replaystarthh }</div>
					</c:if>
						<div><span class="tit">나의현황</span><span id="statusStr">${detail.studystatusname }</span></div>
					<c:if test="${detail.requestflag eq 'Y' and detail.cancelpossibleflag eq 'Y' }">
						<div class="textR" id="cancelCourseDiv"><a href="javascript:;" class="btnBasicWS" onclick="cancelCourse('${detail.courseid}');">신청취소</a></div>
					</c:if>
					</dd>
				</dl>
			</div>
			
			<div class="acSubWrap">
				<h3>시청현황</h3>
				
				<div class="eduSummary">
					<div class="eduSubItem">
						<span>[옵션1]</span> 본방송
						<span class="fr"><strong class="actionbutton">
						<c:choose>
							<c:when test="${detail.studystatus eq 'S' or detail.studystatus eq 'A' or detail.liveshowbuttonyn eq 'Y'}">
								<a href="javascript:;" class="fr btnBasicWS"" onclick="showLive('${detail.courseid}', '${detail.liveshowbuttonyn }');">시청하기</a>
							</c:when>
							<c:when test="${detail.studystatus eq 'C'}">
								<!-- 취소인 경우 -->
							</c:when>
							<c:otherwise>
								${detail.studystatusname }
							</c:otherwise>
						</c:choose>
						</strong></span>
					</div>
					<div class="eduSubCont"><span class="tit">일시</span>
						${detail.startdatestr2 } ${detail.startdatehh }
					</div>
				</div>
			<c:if test="${not empty detail.livereplaylink }">	
				<div class="eduSummary">
					<div class="eduSubItem">
						<span>[옵션2]</span> 재방송
						<span class="fr"><strong class="actionbutton">
						<c:choose>
							<c:when test="${detail.replaystudystatus eq 'S' or detail.replaystudystatus eq 'A' or detail.replayshowbuttonyn eq 'Y'}">
								<a href="javascript:;" class="btnBasicWS" onclick="showLive('${detail.courseid}', '${detail.replayshowbuttonyn }');">시청하기</a>
							</c:when>
							<c:when test="${detail.studystatus eq 'C'}">
								<!-- 취소인 경우 -->
							</c:when>
							<c:otherwise>
								${detail.replaystudystatusname }
							</c:otherwise>
						</c:choose>
						</strong></span>
					</div>
					<div class="eduSubCont"><span class="tit">일시</span>${detail.replaystartstr2 } ${detail.replaystarthh }</div>
				</div>
			</c:if>
			<c:if test="${not empty detail.note }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon5"></span>유의사항 및 기타안내</dt>
					<dd>
						<ul class="listDot">
							${detail.note }
							<c:if test="${not empty detail.linktitle and not empty detail.linkurl }">
								<li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.linkurl}') " class="u">${detail.linktitle }</a></li>
							</c:if>
						</ul>
					</dd>
				</dl>
			</c:if>

				<a href="javascript:;" class="btnList" onclick="goList();">목록</a>
			</div>
			
		</section>
		<!-- content ##iframe end## -->

</form>

			<!-- Layer Popup: 앱다운로드 -->
			<div class="pbLayerPopup" id="uiLayerPop_acApp" style="top:50px !important">
				<div class="pbLayerHeader">
					<strong>AmwayGo! 안내</strong>
				</div>
				<div class="pbLayerContent">
					<p>본 교육은 AmwayGo! 모바일 어플리케이션이 활용되는 교육입니다.  
					앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다.</p>
					
					<div class="imgBox">
						<!-- 안드로이드폰일 경우 -->
						<a href="${amwaygo.googleplay }" target="_blank" id="amwaygo_android" style="display:none;"><img src="/_ui/mobile/images/academy/img_googleplay.gif" alt="Google Play" /></a>
						<!-- 아이폰일 경우 -->
						<a href="${amwaygo.appstore }" target="_blank" id="amwaygo_iphone" style="display:none;"><img src="/_ui/mobile/images/academy/img_appstore.gif" alt="Available on the App Store" /></a>
					</div>
					<!-- // AmwayGO! 모바일 어플리케이션 안내 -->
				
					<div class="btnWrap">
						<a href="#none" class="btnBasicGNL popCloseConfirm">확인</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //Layer Popup: 앱다운로드 -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>