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
<title>아카데미 모바일 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<!-- <script src="/_ui/desktop/common/js/pbCommon2.js"></script> -->
<!-- <script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script> -->
<!-- <script src="/_ui/desktop/common/js/pbLayerPopup.js"></script> -->
</head>
<script type="text/javascript">

$(document.body).ready(function(){
	$("#pbLnb a").click(function(){
		event.preventDefault();
		var uid = $("#uid").val();
		var url = $(this).attr("href");
		
		location.href = url + "?loginUid=" + uid;
	});
});

var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
var eventer = window[eventMethod];
var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

// Listen to message from iFrame resize
eventer(messageEvent, function (e) {
	var $IframeComponent = $("#IframeComponent");
	try {
		var data = e.data;
		if(data && isNaN(data)) {
			eval(data);
		} else {
			$IframeComponent.css({ height: e.data });
		}
		
	} catch(e) {
		// iframe resize
		try {
			if ($IframeComponent.contents()) {
				var $bodyHeight = $IframeComponent.contents().find("#pbContent"); 
				if($bodyHeight) {
					$IframeComponent.height($bodyHeight.height());
				}
			}
		} catch(e) {}
	}
}, false);


function login(){
	var uid = $("#uid").val();
	if(uid == ""){
		alert("아이디를 입력하세요.");
		return;
	}
    $.ajax({
        url : '/lms/common/lmsCommonLoginAjax.do',
        data:{uid : $("#uid").val()} ,
        dataType:'json',
        type:'post',
        success:function(data){
        	alert(data.msg);
        }
    });
}
function openMenu(){
	location.href ="/indexMobile.jsp";
}
function logout(){
    $.ajax({
        url : '/lms/common/lmsCommonLogoutAjax.do',
        data:{uid : $("#uid").val()} ,
        dataType:'json',
        type:'post',
        cache :  'false' ,
        success:function(data){
        	alert(data.msg);
        }
    });
}
</script>
<body>
<div style="height:100px;width:100%">하이브릭스 영역
	<br /><br /><a href="javascript:;" onclick="openMenu()">서브메뉴 열기</a>
</div>
<div id="pbWrap">
		<!-- 메뉴리스트 -->
		<section id="pbLnb" style="width: 200px; position: absolute; display:none; z-index: 999;  background-color: #FFFFFF;">
			<nav>
                <ul id="uiLnb" style="font-size:14px;">
            			<li style="padding: 5px 0px 5px 0px;"><a href="lmsMobile.jsp?url=/mobile/lms/main.do" id="" class="btn_orange">-LMS 메인페이지</a></li>
            				<ul>
            					<li>+나의아카데미</li>
            						<ul>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/myAcademy/lmsMyEducation.do">&nbsp;&nbsp;-이용현황</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/myAcademy/lmsMyRequest.do">&nbsp;&nbsp;-통합교육 신청현황</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/myAcademy/lmsMyContent.do">&nbsp;&nbsp;-최근 본 콘텐츠</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/myAcademy/lmsMyDeposit.do">&nbsp;&nbsp;-보관함</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/myAcademy/lmsMyRecommend.do">&nbsp;&nbsp;-추천콘텐츠</a></li>
            						</ul>
            					<li><a href="lmsMobile.jsp?url=/mobile/lms/information/lmsRegular.do">-정규과정소개</li>
            					<li>+온라인강의</li>
            						<ul>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineNew.do">&nbsp;&nbsp;-신규</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineBest.do">&nbsp;&nbsp;-인기</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineBiz.do">&nbsp;&nbsp;-비즈니스 이해</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineBizSolution.do">&nbsp;&nbsp;-비즈니스 솔루션</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineNutrilite.do">&nbsp;&nbsp;-뉴트리라이트</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineArtistry.do">&nbsp;&nbsp;-아티스트리</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineHomeliving.do">&nbsp;&nbsp;-홈리빙</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlinePersonalcare.do">&nbsp;&nbsp;-퍼스널케어</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineRecipe.do">&nbsp;&nbsp;-레시피</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/online/lmsOnlineHealthNutrition.do">&nbsp;&nbsp;-건강영양</a></li>
            						</ul>
            					<li><a href="lmsMobile.jsp?url=/mobile/lms/liveedu/lmsLiveEdu.do">-라이브시청</a></li>
            					<li>+교육자료</li>
            						<ul>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceNew.do">&nbsp;&nbsp;-신규</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceBest.do">&nbsp;&nbsp;-인기</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceBiz.do">&nbsp;&nbsp;-비즈니스</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceNutrilite.do">&nbsp;&nbsp;-뉴트리라이트</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceArtistry.do">&nbsp;&nbsp;-아티스트리</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourcePersonalcare.do">&nbsp;&nbsp;-퍼스널케어</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceHomeliving.do">&nbsp;&nbsp;-홈리빙</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceRecipe.do">&nbsp;&nbsp;-레시피</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceHealthNutrition.do">&nbsp;&nbsp;-건강영양</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/eduResource/lmsEduResourceMusic.do">&nbsp;&nbsp;-음원 자료실</a></li>
            						</ul>
            					<li>+통합교육신청</li>
            						<ul>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/request/lmsCourse.do">&nbsp;&nbsp;-정규과정</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/request/lmsOffline.do">&nbsp;&nbsp;-오프라인강의</a></li>
            							<li><a href="lmsMobile.jsp?url=/mobile/lms/request/lmsLive.do">&nbsp;&nbsp;-라이브교육</a></li>
            						</ul>
            				</ul>
                    	<input type="text" id="uid" value="00000000001"><br>
                    	<input type="button" value="로그아웃" onclick="logout()">
                    	<!-- <input type="button" value="로그인" onclick="login()"> -->
            			<li style="padding: 5px 0px 5px 0px;"><a href="javascript:;" id="" class="btn_orange">교육장예약 메인페이지</a></li>
						<li style="padding: 5px 0px 5px 0px;"><a href="javascript:;" id="" class="btn_orange">교육비 메인페이지</a></li>
                 </ul>
               </nav>
		</section>
		<c:set var="url" value="/mobile/lms/main.do"/>
		<c:if test="${not empty param.url }">
			<c:set var="url" value="${param.url }"/>
		</c:if>
		<iframe id="IframeComponent" src="${url }" title="아카데미 아이프레임" style="width:100%; border:1px solid #000000; min-height:100px; overflow-x: hidden; overflow-y: auto;" frameborder="1" marginwidth="0" marginheight="0" scrolling="no" ></iframe>
		<!-- iframe 높이 자동조절 개발 요청 -->
		<div>footer</div>
</div>
</body>
</html>
