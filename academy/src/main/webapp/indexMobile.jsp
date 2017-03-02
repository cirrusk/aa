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
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<!-- <link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">  -->
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<!-- <script src="/_ui/desktop/common/js/pbCommon2.js"></script> -->
<!-- <script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script> -->
<!-- <script src="/_ui/desktop/common/js/pbLayerPopup.js"></script> -->
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
		$("#IframeComponent").attr("src", "/mobile/mypage/noteSend.do");
	});
	
	$("#trainingFeeURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/trainingFee/trainingFeeIndex.do");
	});
	
	$("#roomEduURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/roomEduForm.do");
	});
	$("#roomBizURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/roomBizForm.do");
	});
	$("#roomQueenRUL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/roomQueenForm.do");
	});
	$("#roomInfoURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/roomInfoList.do");
	});
	
	$("#expHealthURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/expHealthForm.do");
	});
	
	$("#expInfoURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/expInfoList.do");
	});
	
	$("#expSkinURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/expSkinForm.do");
	});
	
	$("#expBrandURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/expBrandForm.do");
	});
	
	$("#expCultureURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/expCultureForm.do");
	});
	
	$("#expCultureInfoURL").on("click", function(){
		$("#IframeComponent").attr("src", "/mobile/reservation/expInfoList.do");
	});
	
	
	$("#lmsMain").on("click", function(){
		location.href = "lmsMobile.jsp";
	});
	
	$("#lmsMyEducationURL").on("click", function(){ 		//교육현황
		$("#IframeComponent").attr("src", "/mobile/lms/myAcademy/lmsMyEducation.do" );
	}); 
	$("#lmsMyRequestURL").on("click", function(){ 		//통합교육 신청현황
		$("#IframeComponent").attr("src", "/mobile/lms/myAcademy/lmsMyRequest.do");
	});    
	$("#lmsMyContentURL").on("click", function(){ 		//최근 본 콘텐츠
		$("#IframeComponent").attr("src", "/mobile/lms/myAcademy/lmsMyContent.do");
	});    
	$("#lmsMyDepositURL").on("click", function(){ 		//보관함
		$("#IframeComponent").attr("src", "/mobile/lms/myAcademy/lmsMyDeposit.do");
	});    
	$("#lmsMyRecommendURL").on("click", function(){ 		//추천콘텐츠
		$("#IframeComponent").attr("src", "/mobile/lms/myAcademy/lmsMyRecommend.do");
	});                    	                   				
	
	$("#lmsInformationRegularURL").on("click", function(){ 		//정규과정소개
		$("#IframeComponent").attr("src", "/mobile/lms/information/lmsRegular.do");
	});                    	                   				
	
	$("#lmsOnlineNewURL").on("click", function(){ 		//온라인강의 신규
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineNew.do");
	});
	$("#lmsOnlineBestURL").on("click", function(){ 		//온라인강의 인기
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineBest.do");
	});
	$("#lmsOnlineBisURL").on("click", function(){ 		//온라인강의 비즈니스 이해
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineBiz.do");
	});
	$("#lmsOnlineBisSolURL").on("click", function(){ 		//온라인강의 비즈니스 솔루션
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineBizSolution.do");
	});
	$("#lmsOnlineNewTreeURL").on("click", function(){ 		//온라인강의 뉴트리라이트
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineNutrilite.do");
	});
	$("#lmsOnlineArtstURL").on("click", function(){ 		//온라인강의 아티스트리
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineArtistry.do");
	});
	$("#lmsOnlineHomeLiveURL").on("click", function(){ 		//온라인강의 홈리빙
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineHomeliving.do");
	});
	$("#lmsOnlineParCareURL").on("click", function(){ 		//온라인강의 퍼스널케어
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlinePersonalcare.do");
	});
	$("#lmsOnlineRecipeURL").on("click", function(){ 		//온라인강의 레시피
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineRecipe.do");
	});
	$("#lmsOnlineHealthURL").on("click", function(){ 		//온라인강의 건강영양
		$("#IframeComponent").attr("src", "/mobile/lms/online/lmsOnlineHealthNutrition.do");
	});
	
	$("#lmsLiveEduURL").on("click", function(){ 		//라이브교육 시청
		$("#IframeComponent").attr("src", "/mobile/lms/liveedu/lmsLiveEdu.do");
	});                    	
	
	$("#lmsEduDataNewURL").on("click", function(){ 		//교육자료 신규
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceNew.do");
	});
	$("#lmsEduDataBestURL").on("click", function(){ 		//교육자료 인기
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceBest.do");
	});
	$("#lmsEduDataBisURL").on("click", function(){ 		//교육자료 비즈니스
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceBiz.do");
	});
	$("#lmsEduDataNewTreeURL").on("click", function(){ 		//교육자료 뉴트리라이트
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceNutrilite.do");
	});
	$("#lmsEduDataArtstURL").on("click", function(){ 		//교육자료 아티스트리
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceArtistry.do");
	});
	$("#lmsEduDataParCareURL").on("click", function(){ 		//교육자료 퍼스널케어
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourcePersonalcare.do");
	});
	$("#lmsEduDataHomeLiveURL").on("click", function(){ 		//교육자료 홈리빙
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceHomeliving.do");
	});
	$("#lmsEduDataRecipeURL").on("click", function(){ 		//교육자료 레시피
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceRecipe.do");
	});
	$("#lmsEduDataHealthURL").on("click", function(){ 		//교육자료 건강영양
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceHealthNutrition.do");
	});
	$("#lmsEduDataMusicURL").on("click", function(){ 		//교육자료 음원자료실
		$("#IframeComponent").attr("src", "/mobile/lms/eduResource/lmsEduResourceMusic.do");
	});
	$("#lmsRequestRegularURL").on("click", function(){ // 통합교육신청 정규과정
		$("#IframeComponent").attr("src", "/mobile/lms/request/lmsCourse.do");
	});
	
	$("#lmsRequestOfflineURL").on("click", function(){ // 통합교육신청 오프라인강의
		$("#IframeComponent").attr("src", "/mobile/lms/request/lmsOffline.do");
	});
	
	$("#lmsRequestLiveURL").on("click", function(){ // 통합교육신청 라이브교육
		$("#IframeComponent").attr("src", "/mobile/lms/request/lmsLive.do");
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
					<span style="font-size:18px;font-weight:bold;color:#black;">AI MOB MENU</span>
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
			<iframe id="IframeComponent" src="javascript:;" title="아카데미 아이프레임" style="width:700px; border:1px solid #C3C3C3; min-height:500px; overflow-x: hidden; overflow-y: auto;" frameborder="1" marginwidth="0" marginheight="0" scrolling="yes" ></iframe>
		
<!-- 		<section id="pbContent" class=""> -->
<!-- 			<iframe id="IframeComponent" src="//amway.abnkorea.co.kr/abn_kppr/myoffice/education/edu_center/edu_application_ip.asp?ctg=AAP" style="width: 712px; height: 1204px;" scrolling="no" frameborder="0"></iframe> -->
<!-- 		</section> -->
		<!-- iframe 높이 자동조절 개발 요청 -->
</div>
</body>
</html>