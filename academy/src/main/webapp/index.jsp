<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<title>교육비 관리 - ABN Korea</title>
<![endif]-->
<!-- <link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css"> -->
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
</head>
<script type="text/javascript">
$(document.body).ready(function(){
	
	if( 'localhost' != document.domain ){
		document.domain='abnkorea.co.kr';
	}
	
	var $IframeComponent = $("#IframeComponent"); 
	var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
	var eventer = window[eventMethod];
	var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

	// Listen to message from iFrame resize
	eventer(messageEvent, function (e) {
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
	                           var $bodyHeight = $IframeComponent.contents().find("#bodyHeight"); 
	                           if($bodyHeight) {
	                                 $IframeComponent.height($bodyHeight.height());
	                           }
	                    }
	             } catch(e) {}
	       }
	}, false);
	
	$("#myPageMessage").on("click", function(){
		$("#IframeComponent").attr("src", "/mypage/noteSend.do");
	});
	
	$("#trainingFeeURL").on("click", function(){
		$("#IframeComponent").attr("src", "/trainingFee/trainingFeeIndex.do");
	});
	
	$("#roomEduURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/roomEduForm.do");
	});
	$("#roomBizURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/roomBizForm.do");
	});
	$("#roomQueenRUL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/roomQueenForm.do");
	});
	$("#roomInfoURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/roomInfoList.do");
	});
	
	$("#expHealthURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/expHealthForm.do");
	});
	
	$("#expInfoURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/expInfoList.do");
	});
	
	$("#expSkinURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/expSkinForm.do");
	});
	
	$("#expBrandURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/expBrandForm.do");
	});
	
	$("#expCultureURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/expCultureForm.do");
	});
	
	$("#expCultureInfoURL").on("click", function(){
		$("#IframeComponent").attr("src", "/reservation/expCultureInfoList.do");
	});
	
	
	$("#lmsMain").on("click", function(){
		location.href = "/lmsMain.jsp";
	});
	$("#lmsMyEducationURL").on("click", function(){ 		//교육현황
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyEducation.do" );
	}); 
	$("#lmsMyRequestURL").on("click", function(){ 		//통합교육 신청현황
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyRequest.do");
	});    
	$("#lmsMyContentURL").on("click", function(){ 		//최근 본 콘텐츠
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyContent.do");
	});    
	$("#lmsMyDepositURL").on("click", function(){ 		//보관함
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyDeposit.do");
	});    
	$("#lmsMyRecommendURL").on("click", function(){ 		//추천콘텐츠
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyRecommend.do");
	});                    	                   				
	
	$("#lmsInformationRegularURL").on("click", function(){ 		//정규과정소개
		$("#IframeComponent").attr("src", "/lms/information/lmsRegular.do");
	});                    	                   				
	
	$("#lmsOnlineNewURL").on("click", function(){ 		//온라인강의 신규
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineNew.do");
	});
	$("#lmsOnlineBestURL").on("click", function(){ 		//온라인강의 인기
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineBest.do");
	});
	$("#lmsOnlineBisURL").on("click", function(){ 		//온라인강의 비즈니스 이해
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineBiz.do");
	});
	$("#lmsOnlineBisSolURL").on("click", function(){ 		//온라인강의 비즈니스 솔루션
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineBizSolution.do");
	});
	$("#lmsOnlineNewTreeURL").on("click", function(){ 		//온라인강의 뉴트리라이트
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineNutrilite.do");
	});
	$("#lmsOnlineArtstURL").on("click", function(){ 		//온라인강의 아티스트리
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineArtistry.do");
	});
	$("#lmsOnlineHomeLiveURL").on("click", function(){ 		//온라인강의 홈리빙
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineHomeliving.do");
	});
	$("#lmsOnlineParCareURL").on("click", function(){ 		//온라인강의 퍼스널케어
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlinePersonalcare.do");
	});
	$("#lmsOnlineRecipeURL").on("click", function(){ 		//온라인강의 레시피
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineRecipe.do");
	});
	$("#lmsOnlineHealthURL").on("click", function(){ 		//온라인강의 건강영양
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineHealthNutrition.do");
	});
	
	$("#lmsLiveEduURL").on("click", function(){ 		//라이브교육 시청
		$("#IframeComponent").attr("src", "/lms/liveedu/lmsLiveEdu.do");
	});                    	
	
	$("#lmsEduDataNewURL").on("click", function(){ 		//교육자료 신규
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceNew.do");
	});
	$("#lmsEduDataBestURL").on("click", function(){ 		//교육자료 인기
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceBest.do");
	});
	$("#lmsEduDataBisURL").on("click", function(){ 		//교육자료 비즈니스
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceBiz.do");
	});
	$("#lmsEduDataNewTreeURL").on("click", function(){ 		//교육자료 뉴트리라이트
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceNutrilite.do");
	});
	$("#lmsEduDataArtstURL").on("click", function(){ 		//교육자료 아티스트리
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceArtistry.do");
	});
	$("#lmsEduDataParCareURL").on("click", function(){ 		//교육자료 퍼스널케어
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourcePersonalcare.do");
	});
	$("#lmsEduDataHomeLiveURL").on("click", function(){ 		//교육자료 홈리빙
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceHomeliving.do");
	});
	$("#lmsEduDataRecipeURL").on("click", function(){ 		//교육자료 레시피
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceRecipe.do");
	});
	$("#lmsEduDataHealthURL").on("click", function(){ 		//교육자료 건강영양
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceHealthNutrition.do");
	});
	$("#lmsEduDataMusicURL").on("click", function(){ 		//교육자료 음원자료실
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceMusic.do");
	});
	$("#lmsRequestRegularURL").on("click", function(){ // 통합교육신청 정규과정
		$("#IframeComponent").attr("src", "/lms/request/lmsCourse.do");
	});
	
	$("#lmsRequestOfflineURL").on("click", function(){ // 통합교육신청 오프라인강의
		$("#IframeComponent").attr("src", "/lms/request/lmsOffline.do");
	});
	
	$("#lmsRequestLiveURL").on("click", function(){ // 통합교육신청 라이브교육
		$("#IframeComponent").attr("src", "/lms/request/lmsLive.do");
	});	
});



function getLogin() {
	if ( $("#cookie_abono").val() == "" ) {
		alert("테스트 로그인 ABO번호를 입력 해 주세요!");
		return;
	}
	createVirtualHybrisCookie();
	createTmeporaryCookie();
	alert("로그인 처리 되었습니다. 메뉴를 선택해 주세요!");
}
function getLogin2() {
	createVirtualHybrisCookie();
	//createTmeporaryCookie();
	alert("비회원 로그인처리 되었습니다. 비회원 메뉴를 선택해 주세요!");
}

function createVirtualHybrisCookie(){
	document.cookie="i_mar=ABCDEFGHIJKLMNOPQRSTUVWXYZ;path=/;";
}

function createTmeporaryCookie(){
	var cookie_abono = $("#cookie_abono").val();
	document.cookie="username=" + cookie_abono + ";path=/;";
}

function expireTmeporaryCookie(){
	var expireDate = new Date();
	expireDate.setDate( expireDate.getDate() - 1 );
	
	document.cookie="i_mar=;path=/;expires=" + expireDate.toGMTString() + ";";
	document.cookie="username=;path=/;expires=" + expireDate.toGMTString() + ";";
	
	$("#cookie_abono").val("");
	alert("로그아웃 처리 되었습니다.");
	
}

</script>
<body>
<div id="pbSkipNavi"><a href="#pbContent">본문 바로가기</a><a href="#pbGnb">주메뉴 바로가기</a><a href="#pbLnb">서브메뉴 바로가기</a></div>
<div id="pbWrap">
	<!-- header area -->
	<header id="pbHeader" style="width: 1070px; margin: 0 auto; position: relative; z-index: 100;border:1px solid blue;">header include</header>
	<!-- //header area -->
	<div id="pbContainer" style="width: 1070px; margin: 0 auto; padding: 30px 0 99px 0; position: relative; border:1px solid red;">
<!-- 		<div style="widht:200px;height:100px;"> -->
<!-- 			<input type="text" id="cookie_abono" value="7480002" style="width:100px;" /> <br/> -->
<!-- 			<a href="javascript:void(0);" onclick="javascript:createVirtualHybrisCookie();">1. Hybris 쿠키 생성</a> <br/> -->
<!-- 			<a href="javascript:void(0);" onclick="javascript:createTmeporaryCookie();">2. 사용자 쿠키 생성</a> <br/> -->
<!-- 			<a href="javascript:void(0);" onclick="javascript:expireTmeporaryCookie();">전체 쿠키 만료</a><br/><br/> -->
<!-- 			<b>상위 두개의 쿠키 생성후 진행해야 함</b><br/> -->
<!-- 			> requirement cookie -->
<!-- 			- lms : Hybris cookie -->
<!-- 			- 교육비, 교육장 : Hybris + abono -->
<!-- 		</div> -->
		<!-- lnb include -->
		<!-- 메뉴리스트 -->
		<section id="pbLnb" style="width: 225px; float: left; padding-top: 28px; position: relative;">
			<nav>
				<div>
					<input type="text" id="cookie_abono" value="7480002" style="width:100px;" /><br/>					
					<a href="javascript:void(0);" onclick="javascript:getLogin();"><span style="font-size:14px;font-weight:bold;">로그인</span></a>&nbsp;
					<a href="javascript:void(0);" onclick="javascript:expireTmeporaryCookie();"><span style="font-size:14px;">로그아웃</span></a>
					<br/><a href="javascript:void(0);" onclick="javascript:getLogin2()"><span style="font-size:14px;">비회원로그인</span></a>
				</div>
				<div style="margin-top:20px;margin-left:5px;">
					<span style="font-size:18px;font-weight:bold;color:#black;">AI PC MENU</span>
				</div>
                <ul id="uiLnb" style="font-size:14px;font-weight:bold;color:#black;margin-top:20px;margin-left:5px;">
           			<li style="pading:5px 5px 0px 5px;border:1px solid #C3C3C3;width:100px;">마이페이지</li>
                    	<ul style="font-size:14px;font-weight:bold;color:#blue;padding:10px 0px 10px 20px;">
                    		<li style="pading:5px 5px 0px 5px;"><a href="javascript:;" id="myPageMessage"><span style="color:blue;">맞춤쪽지</span></a>
                    	</ul>
                    	
                    <li style="pading:5px 5px 0px 5px;border:1px solid #C3C3C3;width:100px;">예약서비스</li>
                    	<ul style="font-size:14px;font-weight:bold;color:#black;padding:5px 0px 0px 20px;">
                    		<li style="pading:5px 5px 0px 5px;">시설예약</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="roomEduURL">교육장예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="roomBizURL">비즈룸예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="roomQueenRUL">퀸룸/파티룸예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="roomInfoURL">시설예약현황확인</a></li>
                    			</ul>
                    		<li style="pading:5px 5px 0px 5px;">체험예약</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="expHealthURL">체성분측정예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="expSkinURL">피부측정예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="expBrandURL">브랜드체험예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="expCultureURL">문화체험예약</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="expCultureInfoURL">문화체험예약현황확인</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="expInfoURL">체험예약현황확인</a></li>
                    			</ul>
                    	</ul>
                    <li style="pading:5px 5px 0px 5px;border:1px solid #C3C3C3;width:100px;">교육비</li>
                    	<ul style="font-size:14px;font-weight:bold;color:#blue;padding:10px 0px 10px 20px;">
                    		<li style="pading:5px 5px 0px 5px;"><a href="javascript:;" id="trainingFeeURL"><span style="color:blue;">교육비 관리</span></a>
                    	</ul>
                    <li style="pading:5px 5px 0px 5px;border:1px solid #C3C3C3;width:100px;">교육</li>
                    	<ul style="font-size:14px;font-weight:bold;color:#blue;padding:10px 0px 10px 20px;">
                    		<li style="pading:5px 5px 0px 5px;">메인페이지</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsMain">메인</a></li>
                    			</ul>
                    		<li style="pading:5px 5px 0px 5px;">나의아카데미</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsMyEducationURL">교육현황</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsMyRequestURL">통합교육 신청현황</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsMyContentURL">최근 본 콘텐츠</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsMyDepositURL">보관함</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsMyRecommendURL">추천콘텐츠</a></li>
                    			</ul>
                    			
                    		<li style="pading:5px 5px 0px 5px;">정규과정소개</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsInformationRegularURL">정규과정소개</a></li>
                    			</ul>
                    			
                    		<li style="pading:5px 5px 0px 5px;">온라인강의</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineNewURL" >신규</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineBestURL" >인기</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineBisURL">비즈니스 이해</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineBisSolURL">비즈니스 솔루션</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineNewTreeURL">뉴트리라이트</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineArtstURL">아티스트리</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineHomeLiveURL">홈리빙</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineParCareURL">퍼스널케어</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineRecipeURL">레시피</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsOnlineHealthURL">건강영양</a></li>
                    			</ul>
                    			
                    		<li style="pading:5px 5px 0px 5px;">라이브교육 시청</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsLiveEduURL" >라이브교육 시청</a></li>
                    			</ul>

                    		<li style="pading:5px 5px 0px 5px;">교육자료</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataNewURL" >신규</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataBestURL" >인기</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataBisURL">비즈니스</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataNewTreeURL">뉴트리라이트</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataArtstURL">아티스트리</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataParCareURL">퍼스널케어</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataHomeLiveURL">홈리빙</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataRecipeURL">레시피</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataHealthURL">건강영양</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsEduDataMusicURL">음원자료실</a></li>
                    			</ul>
                    				
                    		<li style="pading:5px 5px 0px 5px;">통합교육신청</li>
                    			<ul style="font-size:14px;font-weight:bold;color:blue;padding:10px 0px 10px 20px;">
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsRequestRegularURL" >정규과정</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsRequestOfflineURL">오프라인강의</a></li>
                    				<li>&nbsp;&nbsp;<a href="#" id="lmsRequestLiveURL">라이브교육</a></li>
                    			</ul>
                    					
                    	</ul>
                 </ul>
               </nav>
		</section>
		
		<!-- //lnb include -->
<!-- 		<div class="pageLocation" style="position: absolute; z-index: 1; right: 133px; text-align: right;"> -->
<!-- 			<span class="hide">현재 페이지 위치</span> -->
<!-- 			<span>Home</span>&gt;<span>비지니스</span>&gt;<span>사업지원</span>&gt;<strong>교육비관리</strong> -->
<!-- 		</div> -->
		
		
		
		
		
		
		
		
		
<!-- 		<section id="pbContent" class=""> -->
<!-- 			<iframe id="IframeComponent" src="//amway.abnkorea.co.kr/abn_kppr/myoffice/education/edu_center/edu_application_ip.asp?ctg=AAP" style="width: 712px; height: 1204px;" scrolling="no" frameborder="0"></iframe> -->
			<iframe id="IframeComponent" src="/main.do" title="아카데미 아이프레임" style="width:712px; border:1px solid #C3C3C3; min-height:500px; overflow-x: hidden; overflow-y: auto;" frameborder="1" marginwidth="0" marginheight="0" scrolling="no" ></iframe>
<!-- 		</section> -->
		<!-- iframe 높이 자동조절 개발 요청 -->
			
		
		
		
		
		
		
		
		
		<aside id="pbAside" style="position: absolute; top: 30px; left: 50%; margin-left: 445px;">
			<h1>퀵메뉴</h1>
				<section class="asideUser">
                     <h2>개인정보</h2>
					<span>암웨이&amp;암순이</span>
					<p><a href="/mypage/message/list"><strong>맞춤메시지</strong></a></p>
				</section>
				<section class="asideSmart">
					<h2><img src="/_ui/desktop/images/common/h2_aside_smart.gif" alt="Smart Menu"></h2>
					<a data-type="smartmenu" href="/shop/news/product?icid=smart_menu|신제품"><span style="white-space: nowrap">신제품</span> </a>
						<a data-type="smartmenu" href="/shop/news/promotion?icid=smart_menu|프로모션"><span style="white-space: nowrap">프로모션</span> </a>
						<a data-type="smartmenu" href="/customer/notification?icid=smart_menu|공지사항"><span style="white-space: nowrap">공지사항</span> </a>
						<a href="#uiLayerPop_asid" class="btn"><img src="/_ui/desktop/images/common/btn_setting_smart.gif" alt="스마트 메뉴 설정"> </a>
					<div class="pbLayerWrap" id="uiLayerPop_asid" style="display: none;">
						<div class="pbLayerHeader">
							<strong><img src="/_ui/desktop/images/common/txt_aside_smartmenu.gif" alt="스마트 메뉴 설정"></strong>
							<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="스마트 메뉴 설정 닫기"></a>
						</div>
						<div class="pbLayerContent smartMenu">
							<p class="guideTxt">자주 사용하시는 서비스를 선택하세요.(<strong>3개까지</strong> 선택가능)</p>
            			</div>
					</div>
				</section>
				<div class="asideBox">
					<a href="/shop/wishlist" class="asideWish"><img src="/_ui/desktop/images/common/txt_aside_wish.gif" alt="위시리스트"></a>
					<section class="asideToday">
							<h2><img src="/_ui/desktop/images/common/h2_aside_today.gif" alt="오늘 본 제품"><span>29</span><span class="hide">개</span></h2>
							<p class="aisdeTodaySum"><span class="hide">현재 페이지:</span><strong>1</strong>/<span class="hide">전체 페이지:</span>10</p>                    
							<div class="asideCanv">
							</div>
							<div class="asideCtrl">
								<a href="#" class="btnTodayPre" title="이전" onclick="return false;"><img src="/_ui/desktop/images/common/btn_today_pre.gif" alt="이전상품 보기"></a>
								<a href="#" class="btnTodayNext" title="다음" onclick="return false;"><img src="/_ui/desktop/images/common/btn_today_next.gif" alt="다음상품 보기"></a>
							</div>
						</section>
					</div>
			<a href="#pbContent" class="btnTop"><img src="/_ui/desktop/images/common/btn_top.gif" alt="TOP(본문바로가기)"></a>
		</aside>
		
		<!-- aside area -->
		<aside id="pbAside" style="min-width: 1070px; border-top: 1px solid #dfdfdf; position: relative; z-index: 50;">aside include</aside>
		<!-- //aside area -->
	</div>
	<!--footer include -->
	<footer id="pbFooter">footer include</footer>
	<!--//footer include -->
</div>
<div class="skipNaviReturn"><a href="#pbSkipNavi">페이지 맨 위로 이동</a></div>
</body>
</html>
