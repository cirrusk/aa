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
<title>오프라인강의 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<style>
.pbLayerPopup#uiLayerPop_acRegist{top:50px !important} /* 레이어팝업위치 */
.pbLayerPopup#uiLayerPop_acRegistFail{top:50px !important} /* 레이어팝업위치 */
</style>
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
	fnAnchor2();
	setTimeout(function(){ abnkorea_resize(); }, 500);
	if(navigator.userAgent.match(/android/i)){
		$("#amwaygo_android").show();
	}
	if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
		$("#amwaygo_iphone").show();
	}
	
	$(".popCloseConfirm").click(function(){
		$(".btnPopClose").trigger("click");
	});
	
	if($("#reqeustOptionView").val() == "Y"){
		$(".reqeustOptionDiv").show();
	}
});
var requestCourse = function(courseid){
	var togetherrequestflag = "N";
	if(togetherrequestflag != "Y"){togetherrequestflag = "N";}
	var apseq = "";
	if( $("#apseq").length > 0 ){
		apseq = $("#apseq").val();
		if(apseq == "0"){
			alert("참석 지역을 선택해 주세요.");
			$("#apseq").focus();
			return;
		}
	}
	if(!confirm("해당과정을 신청하겠습니까?")){return;}
	var coursename = "${detail.item.coursename }";
	var apname = "${detail.item2.apname } ${detail.item2.roomname }";
	var startdate = "${detail.item.startdate }";
	var data = {courseid: courseid, apseq: apseq, togetherrequestflag: togetherrequestflag, groupflag : "${detail.item.groupflag}", coursename : coursename, apname:apname, startdate:startdate};
	$.ajaxCall({
   		url: "/mobile/lms/request/lmsCourseRequestAjax.do"
   		, data: data
   		, dataType: "json"
   		, async : false
   		, success: function( data, textStatus, jqXHR){
   			if(data.result == "OK"){ // 성공
   				$("#a_uiLayerPop_acRegist").trigger("click");
   				$("#reqeustButtonDiv").html('<a href="#none" class="btnBasicGL" onclick="requestCourseOk()">신청완료</a><a href="#none" class="btnBasicGNL" onclick="goMyCourse()">수강하기</a>');
   				/* $('<div>※ 신청 취소 및 변경은 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의아카데미 &gt; 통합교육 신청현황</a> 에서 진행할 수 있습니다.</div>').insertAfter("#reqeustButtonDiv"); */
   				$('<div>※ 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top" class="u">나의 아카데미 > 통합교육 신청현황</a> 메뉴에서 진행할 수 있습니다.</div>').insertAfter("#reqeustButtonDiv");
   				$("#reqeustButtonDiv").removeClass("aNumb1").addClass("bNumb2");
   				$(".reqeustOptionDiv").hide();
   				abnkorea_resize();
   				fnAnchor2();
   			} else if(data.result == "NO"){ // 실패
   				var penaltycount = data.item.penaltycount;
   				if(penaltycount != "0" && penaltycount != ""){
   					$("#reasonOfCant1").hide();
   					$("#reasonOfCant2").show();
   				}else{
   					$("#reasonOfCant1").show();
   					$("#reasonOfCant2").hide();
   				}
   				$("#a_uiLayerPop_acRegistFail").trigger("click");
   				fnAnchor2();
   			} else if(data.result == "LOGOUT"){ // 로그아웃상태
   				fnSessionCall("");
   			}
   		}
   	});
};
function goList(){
	 var viewtype = $("#searchForm input[name=viewtype]").val();
	 if(viewtype == "2"){
		 $("#searchForm").attr("action", "lmsOfflineMonth.do");
	 }
	 $("#searchForm").submit();
}
function requestCourseEnd(){
	alert("신청마감된 과정입니다.");
}
function requestCourseStart(){
	alert("교육이 시작된 과정입니다.");
}
function requestCourseOk(){
	//alert("자세한 신청 결과 조회, 신청 취소는 나의 아카데미 > 통합교육 신청현황 메뉴에서 진행할 수 있습니다");
	alert("신청 완료되었습니다. 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 나의 아카데미 > 통합교육 신청현황 메뉴에서 진행할 수 있습니다.");
}
function gotolinkurl(url){
	if(url.indexOf("\:\/\/") < 0){
		url = "http://"+url
	}
	window.open(url);
}
function goMyCourse(){
	var courseid = "${detail.item.courseid}";
	parent.location.href = "${abnHttpDomain}/lms/myAcademy/lmsMyRequest?courseid="+courseid+"&detailyn=y";
}
</script>
</head>
<body class="uiGnbM3">

		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">오프라인강의</h2>
			
			<div class="acSubWrap">
				<section class="acItems">
					<article class="item">
						<a href="#none">
							<strong class="tit">[${detail.item2.apname }]  ${detail.item.coursename }</strong>
							<span class="category">${detail.item.themename }</span>
							<span class="img">
								<img src="/lms/common/imageView.do?file=${detail.item.courseimage}&mode=course" alt="${detail.item.courseimagenote}"/>
							</span>
						</a>
						<div class="snsZone">
							<a href="#none" class="like <c:if test="${detail.item.mylikecount ne '0'}">on</c:if>" onclick="javascript:likeitemClick('${detail.item.courseid}','likecntlab${detail.item.courseid}');"><span class="hide">좋아요</span></a>
							<em id="likecntlab${detail.item.courseid}">${detail.item.likecount }</em>
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
			<c:if test="${detail.item2.togetherflag eq 'Y' and not empty userinfo.partnerinfossn }">
				<div class="acInputWrap reqeustOptionDiv"  style="display:none">
					<input type="checkbox" id="togetherrequestflag"  name="togetherrequestflag" value="Y" /><label for="togetherrequestflag">부사업자 동반참석</label>
				</div>
			</c:if>				
				
						<fmt:parseNumber var="requestcount" value="${detail.item.requestcount}"/>
						<fmt:parseNumber var="limitcount" value="${detail.item2.limitcount }"/>
						<c:set var="reqeustOptionView" value="N" />
						<c:choose>
							<c:when test="${detail.item.requestflag eq 'Y' }">
								<div class="btnWrap bNumb2" id="reqeustButtonDiv">							
								<a href="#none" class="btnBasicGL" onclick="requestCourseOk()">신청완료</a>
								<a href="#none" class="btnBasicGNL" onclick="goMyCourse()">수강하기</a>
								</div>
								<%-- <div>※ 신청 취소 및 변경은 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top">나의아카데미 &gt; 통합교육 신청현황</a> 에서 진행할 수 있습니다.</div> --%>
								<div>※ 신청 과정 수강 및 자세한 신쳥 결과 조회, 신청 취소는 <a href="${abnHttpDomain}/lms/myAcademy/lmsMyRequest" target="_top" class="u">나의 아카데미 > 통합교육 신청현황</a> 메뉴에서 진행할 수 있습니다.</div>
							</c:when>
							<c:when test="${requestcount >= limitcount }">
								<div class="btnWrap aNumb1" id="reqeustButtonDiv">
								<a href="#none" class="btnBasicGL">신청마감</a>
								</div>
							</c:when>
							<c:when test="${detail.item.startdateflag eq '1'}">
								<div class="btnWrap aNumb1" id="reqeustButtonDiv">
								<a href="#none" class="btnBasicGL" onclick="requestCourseEnd()">교육시작</a>
								</div>
							</c:when>
							<c:otherwise>
								<div class="btnWrap aNumb1" id="reqeustButtonDiv">
								<a href="#none" class="btnBasicGNL" onclick="requestCourse('${detail.item.courseid }')">신청하기</a>
								</div>
							<c:if test="${detail.item2.togetherflag eq 'Y' and not empty userinfo.partnerinfossn }">
								<div class="reqeustOptionDiv"  style="display:none">※ 배우자 동반 교육 참석 희망시 "부사업자 동반참석" 체크 박스를 선택해 주세요.</div>
							</c:if>
								<c:set var="reqeustOptionView" value="Y" />
							</c:otherwise>
						</c:choose>
				<input type="hidden" name="reqeustOptionView" id="reqeustOptionView" value="${reqeustOptionView }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon1"></span>교육일시 및 장소</dt>
					<dd>
						<p class="listDot">${detail.item.startdate3 } ~ ${detail.item.enddate3 }</p>
						<p class="listDot">${detail.item2.apname } ${detail.item2.roomname }</p>
					</dd>
				</dl>
				<dl class="eduCont">
					<dt><span class="eduIcon icon2"></span>신청대상</dt>
					<dd>
						<ul class="listDot">
							${detail.item2.targetdetail }
						</ul>
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
				<dl class="eduCont">
					<dt><span class="eduIcon icon4"></span>교육 상세 내용</dt>
					<dd>
						<ul class="listDot">
							${detail.item2.detailcontent}
						</ul>	
					</dd>
				</dl>
				<dl class="eduCont">
					<dt><span class="eduIcon icon5"></span>유의사항 및 기타안내</dt>
					<dd>
						<strong class="tit">유의사항</strong>
						<ul class="listDot">
							${detail.item2.note }
							<c:if test="${not empty detail.item2.linktitle and not empty detail.item2.linkurl }"><li><a href="javascript:void(0);" onclick="gotolinkurl('${detail.item2.linkurl}') " class="u">${detail.item2.linktitle }</a></li></c:if>
						</ul>
					</dd>
				</dl>
			<c:if test="${!empty detail.item2.penaltynote }">
				<dl class="eduCont">
					<dt><span class="eduIcon icon6"></span>페널티</dt>
					<dd>
						<ul class="listDot">
							${detail.item2.penaltynote }
						</ul>	
					</dd>
				</dl>
			</c:if>
				<a href="javascript:;" onclick="goList()" class="btnList"><span>목록</span></a>
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
	<!-- Layer Popup: 신청실패 -->
	<div class="pbLayerPopup" id="uiLayerPop_acRegistFail">
		<div class="pbLayerHeader">
			<strong>신청실패</strong>
		</div>
		<div class="pbLayerContent">
			<p><strong>교육신청 실패하였습니다.</strong></p>
			<p class="mgtM">현재 선택하신 교육은 신청이 불가합니다.</p>
			<p id="reasonOfCant1">신청대상 및 신청기간을 확인해 주세요.</p>
			<p id="reasonOfCant2">페널티 기간입니다.</p>
			<div class="btnWrap mgtL">
				<a href="#none" class="btnBasicGNL popCloseConfirm">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //Layer Popup: 신청실패 -->
	<!-- Layer Popup: 신청완료 -->
	<div class="pbLayerPopup" id="uiLayerPop_acRegist">
		<div class="pbLayerHeader">
			<strong>신청완료</strong>
		</div>
		<div class="pbLayerContent">
			<p><strong>교육신청 정상적으로 완료되었습니다.</strong></p>
			<p class="mgtSM">신청내역은 나의아카데미 &gt; 통합교육 신청현황에서 확인하시기 바랍니다.</p>
		<c:if test="${detail.item.groupflag eq 'Y' }">
			<!-- AmwayGo! 모바일 어플리케이션 안내 -->
			<p class="lineTop"><strong>AmwayGo! 모바일 어플리케이션 안내</strong></p>
			<p>본 교육은 AmwayGo! 모바일 어플리케이션이 활용되는 교육입니다.  
			앱 설치 후 스마트폰을 통해 다양한 교육 활동에 참여할 수 있습니다.</p>
			
			<div class="imgBox">
				<!-- 안드로이드폰일 경우 -->
				<a href="${amwaygo.googleplay }" target="_blank" id="amwaygo_android" style="display:none;"><img src="/_ui/mobile/images/academy/img_googleplay.gif" alt="Google Play" /></a>
				<!-- 아이폰일 경우 -->
				<a href="${amwaygo.appstore }" target="_blank" id="amwaygo_iphone" style="display:none;"><img src="/_ui/mobile/images/academy/img_appstore.gif" alt="Available on the App Store" /></a>
			</div>
			<!-- // AmwayGo! 모바일 어플리케이션 안내 -->
		</c:if>
			<div class="btnWrap">
				<a href="#none" class="btnBasicGNL popCloseConfirm">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //Layer Popup: 신청완료 -->
	<div style="display:none">
		<a href="#uiLayerPop_acRegistFail" id="a_uiLayerPop_acRegistFail" onclick="layerPopupOpen(this); return false;">신청실패</a>
		<a href="#uiLayerPop_acRegist" id="a_uiLayerPop_acRegist" onclick="layerPopupOpen(this); return false;">신청완료</a>
	</div>


<form name="searchForm" id="searchForm" action="/mobile/lms/request/lmsOffline.do#data${detail.item.courseid }">
<input type="hidden" name="viewtype" value="${param.viewtype }">
<input type="hidden" name="searchyear" value="${param.searchyear}">
<input type="hidden" name="searchmonth" value="${param.searchmonth }">
<c:forEach items="${searchapseqArr }" var="data">
<input type="hidden" name="searchapseq" value="${data }">
</c:forEach>
<input type="hidden" name="back" value="Y">
<input type="hidden" name="page" value="${param.page }">
<input type="hidden" name="courseid" value="${param.courseid }">
</form>

</body>
</html>