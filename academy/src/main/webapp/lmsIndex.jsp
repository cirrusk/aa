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
<title>아카데미 - ABN Korea</title>
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
	var loginUid = $("#uid").val();
	
	$("#lmsMyEducationURL").on("click", function(){ 		//교육현황
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyEducation.do?loginUid="+$("#uid").val() );
	}); 
	$("#lmsMyRequestURL").on("click", function(){ 		//통합교육 신청현황
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyRequest.do?loginUid="+$("#uid").val());
	});    
	$("#lmsMyContentURL").on("click", function(){ 		//최근 본 콘텐츠
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyContent.do?loginUid="+$("#uid").val());
	});    
	$("#lmsMyDepositURL").on("click", function(){ 		//보관함
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyDeposit.do?loginUid="+$("#uid").val());
	});    
	$("#lmsMyRecommendURL").on("click", function(){ 		//추천콘텐츠
		$("#IframeComponent").attr("src", "/lms/myAcademy/lmsMyRecommend.do?loginUid="+$("#uid").val());
	});                    	                   				
	
	$("#lmsInformationRegularURL").on("click", function(){ 		//정규과정소개
		$("#IframeComponent").attr("src", "/lms/information/lmsRegular.do?loginUid="+$("#uid").val());
	});                    	                   				
	
	$("#lmsOnlineNewURL").on("click", function(){ 		//온라인강의 신규
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineNew.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineBestURL").on("click", function(){ 		//온라인강의 인기
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineBest.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineBisURL").on("click", function(){ 		//온라인강의 비즈니스 이해
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineBiz.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineBisSolURL").on("click", function(){ 		//온라인강의 비즈니스 솔루션
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineBizSolution.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineNewTreeURL").on("click", function(){ 		//온라인강의 뉴트리라이트
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineNutrilite.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineArtstURL").on("click", function(){ 		//온라인강의 아티스트리
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineArtistry.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineHomeLiveURL").on("click", function(){ 		//온라인강의 홈리빙
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineHomeliving.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineParCareURL").on("click", function(){ 		//온라인강의 퍼스널케어
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlinePersonalcare.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineRecipeURL").on("click", function(){ 		//온라인강의 레시피
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineRecipe.do?loginUid="+$("#uid").val());
	});
	$("#lmsOnlineHealthURL").on("click", function(){ 		//온라인강의 건강영양
		$("#IframeComponent").attr("src", "/lms/online/lmsOnlineHealthNutrition.do?loginUid="+$("#uid").val());
	});
	
	$("#lmsLiveEduURL").on("click", function(){ 		//라이브교육 시청
		$("#IframeComponent").attr("src", "/lms/liveedu/lmsLiveEdu.do?loginUid="+$("#uid").val());
	});                    	
	
	$("#lmsEduDataNewURL").on("click", function(){ 		//교육자료 신규
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceNew.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataBestURL").on("click", function(){ 		//교육자료 인기
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceBest.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataBisURL").on("click", function(){ 		//교육자료 비즈니스
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceBiz.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataNewTreeURL").on("click", function(){ 		//교육자료 뉴트리라이트
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceNutrilite.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataArtstURL").on("click", function(){ 		//교육자료 아티스트리
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceArtistry.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataParCareURL").on("click", function(){ 		//교육자료 퍼스널케어
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourcePersonalcare.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataHomeLiveURL").on("click", function(){ 		//교육자료 홈리빙
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceHomeliving.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataRecipeURL").on("click", function(){ 		//교육자료 레시피
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceRecipe.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataHealthURL").on("click", function(){ 		//교육자료 건강영양
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceHealthNutrition.do?loginUid="+$("#uid").val());
	});
	$("#lmsEduDataMusicURL").on("click", function(){ 		//교육자료 음원자료실
		$("#IframeComponent").attr("src", "/lms/eduResource/lmsEduResourceMusic.do?loginUid="+$("#uid").val());
	});

	
	$("#lmsRequestRegularURL").on("click", function(){ // 통합교육신청 정규과정
		$("#IframeComponent").attr("src", "/lms/request/lmsCourse.do?loginUid="+$("#uid").val());
	});
	
	$("#lmsRequestOfflineURL").on("click", function(){ // 통합교육신청 오프라인강의
		$("#IframeComponent").attr("src", "/lms/request/lmsOffline.do?loginUid="+$("#uid").val());
	});
	
	$("#lmsRequestLiveURL").on("click", function(){ // 통합교육신청 라이브교육
		$("#IframeComponent").attr("src", "/lms/request/lmsLive.do?loginUid="+$("#uid").val());
	});
	
	
	
	
	
	
	
	
	$("#trainingFeeURL").on("click", function(){
		$("#IframeComponent").attr("src", "http://localhost:8080/trainingFee/trainingFeeMain.do");
	});
	
	$("#expHealthURL").on("click", function(){
		$("#IframeComponent").attr("src", "http://localhost:8080/reservation/expHealthInsertForm.do");
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
        cache : 'false' ,
        success:function(data){
        	alert(data.msg);
        }
    });
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
<div id="pbSkipNavi"><a href="#pbContent">본문 바로가기</a><a href="#pbGnb">주메뉴 바로가기</a><a href="#pbLnb">서브메뉴 바로가기</a></div>
<div id="pbWrap">
	<!-- header area -->
	<header id="pbHeader" style="width: 1070px; margin: 0 auto; position: relative; z-index: 100;border:1px solid blue;">header include<a href="/lmsMain.jsp">LMS메인페이지</a></header>
	<!-- //header area -->
	<div id="pbContainer" style="width: 1070px; margin: 0 auto; padding: 30px 0 99px 0; position: relative; border:1px solid red;">
		<!-- lnb include -->
		<!-- 메뉴리스트 -->
		<section id="pbLnb" style="width: 225px; float: left; padding-top: 28px; position: relative;">business lnb include
			<nav>
				<h1>서브메뉴</h1>
                <h2><a href="/business"><img src="/_ui/desktop/images/lnb/h2_lnb_business.gif" alt="비즈니스"></a></h2>
                <ul id="uiLnb" style="font-size:14px;">
           			<li style="padding: 5px 0px 5px 0px;"><a href="#" id="lmsMainpageURL" class="btn_orange">LMS 메인페이지</a></li>
           				<ul>
                    		<li>&nbsp;&nbsp;나의아카데미</li>
                    			<ul>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsMyEducationURL">교육현황</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsMyRequestURL">통합교육 신청현황</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsMyContentURL">최근 본 콘텐츠</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsMyDepositURL">보관함</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsMyRecommendURL">추천콘텐츠</a></li>
                    			</ul>
                    		<li>&nbsp;&nbsp;<a href="#" id="lmsInformationRegularURL">정규과정소개</a></li>
                    		<li>&nbsp;&nbsp;온라인강의</li>
                    			<ul>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineNewURL" >신규</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineBestURL" >인기</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineBisURL">비즈니스 이해</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineBisSolURL">비즈니스 솔루션</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineNewTreeURL">뉴트리라이트</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineArtstURL">아티스트리</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineHomeLiveURL">홈리빙</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineParCareURL">퍼스널케어</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineRecipeURL">레시피</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsOnlineHealthURL">건강영양</a></li>
                    			</ul>
                    		<li>&nbsp;&nbsp;<a href="#" id="lmsLiveEduURL">라이브교육 시청</a></li>
                    		<li>&nbsp;&nbsp;교육자료</li>
                    			<ul>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataNewURL" >신규</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataBestURL" >인기</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataBisURL">비즈니스</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataNewTreeURL">뉴트리라이트</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataArtstURL">아티스트리</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataParCareURL">퍼스널케어</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataHomeLiveURL">홈리빙</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataRecipeURL">레시피</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataHealthURL">건강영양</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsEduDataMusicURL">음원자료실</a></li>
                    			</ul>
                    		<li>&nbsp;&nbsp;통합교육신청</li>
                    		<ul>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsRequestRegularURL" >정규과정</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsRequestOfflineURL">오프라인강의</a></li>
                    				<li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="lmsRequestLiveURL">라이브교육</a></li>
                    			</ul>
                    		<li>&nbsp;&nbsp;온라인매거진</li>
                    	</ul>
                    	<input type="text" id="uid" value="00000000001"><br>
                    	<input type="button" value="로그아웃" onclick="logout()">
                    <li>&nbsp;</li>	
                    <li style="padding: 5px 0px 5px 0px;"><a href="javascript:;" id="" class="btn_orange">교육장예약 메인페이지</a></li>
                    	<ul>
                    		<li>시설예약</li>
                    			<ul>
                    				<li>1</li>
                    				<li>2</li>
                    				<li>3</li>
                    				<li>4</li>
                    			</ul>
                    		<li>체험예약</li>
                    			<ul>
                    				<li><a href="#" id="expHealthURL">체성분측정예약</a></li>
                    				<li><a href="#">피부측정예약</a></li>
                    				<li><a href="#">브랸드체험예약</a></li>
                    				<li><a href="#">문화체험예약</a></li>
                    				<li><a href="#">체험예약현황확인</a></li>
                    			</ul>
                    	</ul>
                    <li style="padding: 5px 0px 5px 0px;"><a href="javascript:;" id="trainingFeeURL" class="btn_orange">교육비 메인페이지</a></li>
                 </ul>
               </nav>
		</section>
		
		<!-- //lnb include -->
		<div class="pageLocation" style="position: absolute; z-index: 1; right: 133px; text-align: right; border:1px solid #000000;">
			<span class="hide">현재 페이지 위치</span>
			<span>Home</span>&gt;<span>비지니스</span>&gt;<span>사업지원</span>&gt;<strong>교육비관리</strong>
		</div>
		
		
		
		
		
		
		
		
		
<!-- 		<section id="pbContent" class=""> -->
<!-- 			<iframe id="IframeComponent" src="//amway.abnkorea.co.kr/abn_kppr/myoffice/education/edu_center/edu_application_ip.asp?ctg=AAP" style="width: 712px; height: 1204px;" scrolling="no" frameborder="0"></iframe> -->
			<iframe id="IframeComponent" src="javascript:;" title="아카데미 아이프레임" style="width:712px; min-height:1500px; overflow-x: hidden; overflow-y: auto;" frameborder="1" marginwidth="0" marginheight="0" scrolling="no" ></iframe>
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
