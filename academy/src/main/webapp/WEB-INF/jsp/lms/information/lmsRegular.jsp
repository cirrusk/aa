<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<title>정규과정소개 - ABN Korea</title>
<!--[if lt IE 9]>
	<script src="/_ui/desktop/common/js/html5.js"></script>
	<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->

	<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
	
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>

	<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
	<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
	<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
	<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
	<script src="/_ui/desktop/common/js/owl.carousel.js"></script>
	
	<script src="/js/front.js"></script>
	<script src="/js/lms/lmsComm.js"></script>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
$(document).ready(function() { 
	setTimeout(function(){ abnkorea_resize(); }, 500);
	$(".img").load(function(){abnkorea_resize(); });  // 이미지로드 완료시 호출.
	fnAnchor2(); //TOP로 이동
});
function goRegular(){
	var url = "${scrData.DomainUrl}";
	parent.location.href = url ;
}
</script>
</head>

<body>
		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030300000.gif" alt="정규과정소개"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030300000.gif" alt="암웨이 정규과정을 소개합니다."></p>
			</div>

			<ul class="standardClassList">
				<li><a href="#class1" class="on">뉴트리라이트 브랜드 전문가 과정</a></li>
				<li><a href="#class2">아티스트리 브랜드 전문가 과정</a></li>
				<li><a href="#class3">Amway Queen 요리명장 과정</a></li>
				<li><a href="#class4">비즈니스 리더 정규 과정</a></li>
			</ul>
			
			<h2 id="class1"><img src="/_ui/desktop/images/academy/h2_w030300000_1.gif" alt="뉴트리라이트 브랜드 전문가 과정"></h2>
			<p class="standardClassTxt">과학적 사실에 근거한 뉴트리라이트 비즈니스 전문가를 꿈꾸는 ABO분들을 위한 과정입니다.</p>
			<div><img src="/_ui/desktop/images/academy/img_w030300000_1.jpg" alt="뉴트리라이트 브랜드 전문가 과정 대표이미지"></div>
			<div class="standardClassCont">
				<img src="/_ui/desktop/images/academy/w030300000_cont1.gif" alt="1단계:건강영양 아카데미 과정,모든 ABO 대상,객관적인 과학 지식에 근거한 건강 영양에 대한 온라인 과정. 2단계:뉴트리라이트 아카데미 과정,건강영양 아카데미 과정 수료한 유자격 SP 이상 대상,전국AP에서 진행되는 제품 전달을 위한 체계적인 뉴트리라이트 솔루션 과정" />
			</div>
			<h2 id="class2"><img src="/_ui/desktop/images/academy/h2_w030300000_2.gif" alt="아티스트리 브랜드 전문가 과정"></h2>
			<p class="standardClassTxt">뷰티 전반의 체계적인 지식과 제품 실기 과정으로 구성된 아티스트리 뷰티 비즈니스 전문가를 꿈꾸는 ABO분들을 위한 과정입니다.</p>
			<div><img src="/_ui/desktop/images/academy/img_w030300000_2.jpg" alt="아티스트리 브랜드 전문가 과정 대표이미지"></div>
			<div class="standardClassCont">
				<img src="/_ui/desktop/images/academy/w030300000_cont2.gif" alt="1단계:뷰티 스쿨 과정,모든 ABO 대상,피부에 대한 지식과 아티스트리 제품 사용법에 대한 온라인 과정. 2단계:아티스트리 아카데미 과정,뷰티 스쿨 과정을 수료한 유자격 SP 이상 대상,스킨케어 솔루션과 메이크업 실습 과정. 
				3단계:뷰티 큐레이터 과정,아티스트리 아카데미 과정을 수료한 유자격 PT 이상 대상,전문적인 뷰티 솔루션 전달을 위한 비즈니스 커뮤니케이션 과정" />
			</div>
			<h2 id="class3"><img src="/_ui/desktop/images/academy/h2_w030300000_3.gif" alt="Amway Queen 요리명장 과정"></h2>
			<p class="standardClassTxt">암웨이 퀸을 활용한 다양한 레시피 시연과 성공적인 홈미팅 &amp; 홈파티 노하우를 전달하는 과정입니다.</p>
			<div><img src="/_ui/desktop/images/academy/img_w030300000_3.jpg" alt="Amway Queen 요리명장 과정 대표이미지"></div>
			<div class="standardClassCont">
				<img src="/_ui/desktop/images/academy/w030300000_cont3.gif" alt="1단계:요리명장 선발대회,유자격  PT 이상, 전국 AP 예선을 통한 선발되신 ABO 대상,본인만의 암웨이 퀸을 사용해 요리하는 경연. 2단계 : 요리명장 워크샵,요리명장 대상,요리명장 ABO 강사 과정.
				3단계:요리명장 쿠킹 클래스,요리명장 대상,전국 AP/ABC 쿠킹클래스를 통한 명장으로 업그레이드 되는 과정" />
			</div>
			<h2 id="class4"><img src="/_ui/desktop/images/academy/h2_w030300000_4.gif" alt="비즈니스 리더 정규과정"></h2>
			<p class="standardClassTxt">'비즈니스'에 대한 동기부여와 '리더'로서 준비되는 비즈니스 리더를 육성하는 과정입니다.</p>
			<div><img src="/_ui/desktop/images/academy/img_w030300000_4.jpg" alt="비즈니스 정규과정 대표이미지"></div>
			<div class="standardClassCont">
				<dl>
					<dt>SP 세미나</dt>
					<dd><strong>New SP 대상</strong>
						<p>본격적인 사업자로서 첫 번째인 SP 핀의 인정과 차기 핀으로의 성장을 위한 마인드에 관한 세미나 (SP 인정식, 비즈니스 업데이트, SMP &amp; 윤리강령)</p>
					</dd>
				</dl>
				<dl>
					<dt>New Platinum 세미나</dt>
					<dd><strong>New Platinum 대상</strong>
						<p>플래티넘 리더로서의 핀의 인정과 ABO 리더로서의 소통 및 역할에 관한 세미나 (비즈니스 업데이트, 개인 성향 유형별 커뮤니케이션, 윤리강령 서약식)</p>
					</dd>
				</dl>
				<dl>
					<dt>Emerald 포럼</dt>
					<dd><strong>New Emerald 대상</strong>
						<p>새로운 목표 달성을 위한 효율적 리더십 역량 강화하는 포럼 (비즈니스 업데이트, 마케팅 업데이트, 상황 대응 리더십)</p>
					</dd>
				</dl>
				<dl>
					<dt>New Diamond Conference</dt>
					<dd><strong>New Diamond 대상</strong>
						<p>Diamond 성취자들에게 제공되는 최상의 교육, 정보공유 및 코칭의 기회</p>
					</dd>
				</dl>
				<dl>
					<dt>Diamond 세미나</dt>
					<dd><strong>유자격 Diamond 대상</strong>
						<p>내 외부 변화와 흐름에 따른 차기연도 비즈니스 전략 수립에 도움을 주는 세미나 (비즈니스 업데이트, 마케팅 업데이트, 차년도 사회/소비 트렌드 특강)</p>
					</dd>
				</dl>
				<dl>
					<dt>윤리강령 교육과정</dt>
					<dd><strong>기본 과정 - 모든 ABO 대상<br/>심화 과정 – SP 이상</strong>
						<p>지속 가능한 성장을 위한 필수 요소인 비즈니스 건전성 향상을 위한 윤리강령 교육</p>
					</dd>
				</dl>
				<dl>
					<dt>뉴 플래티늄 글로벌 인증 과정</dt>
					<dd><strong>Platinum 이상</strong>
						<p>플래티늄의 역량을 강화하고 보다 안정적인 사업을 진행할 수 있도록 기본 지식을 전달하는 전 세계 뉴 플래티늄 대상, 글로벌 암웨이 교육인증과정</p>
					</dd>
				</dl>
			</div>
				
			<div class="btnWrapC">
				<a href="#none" class="btnBasicAcGNL" onclick="goRegular();"><span>정규과정 수강신청</span></a>
			</div>
		</section>
<script type="text/javascript">
$(document).ready(function() {
	var $ClassList = $(".standardClassList a");
	$ClassList.click(function(){
		$ClassList.removeClass("on");
		$(this).addClass("on");
		abnkorea_resize();
	});
});
</script>
		<!-- //content area | ### academy IFRAME Start ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>