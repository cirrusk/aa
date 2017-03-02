<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<title>정규과정소개 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
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
	setTimeout(function(){ abnkorea_resize(); }, 500);
	fnAnchor2(); //TOP로 이동
	$(".img").load(function(){abnkorea_resize(); });  // 이미지로드 완료시 호출.
});
function goRegular(){
	var url = "${scrData.DomainUrl}";
	parent.location.href = url ;
}
</script>
</head>
<body class="uiGnbM3">
		
		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">정규과정소개</h2>
			
			<div class="acSubWrap standardClass">
				<section>
					<h3>뉴트리라이트 브랜드 전문가 과정</h3>
					<p>과학적 사실에 근거한 뉴트리라이트 비즈니스 전문가를 꿈꾸는 ABO분들을 위한 과정입니다.</p>
					<div><img src="/_ui/mobile/images/academy/img_standardClass01.jpg" alt="뉴트리라이트 브랜드 전문가 과정 대표이미지" /></div>
					<dl>
						<dt>1단계 : 건강영양 아카데미 과정</dt>
						<dd><ul class="dashList">
								<li>- 모든 ABO 대상</li>
								<li>- 객관적인 과학 지식에 근거한 건강 영양에 대한 온라인 과정</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>2단계 : 뉴트리라이트 아카데미 과정</dt>
						<dd><ul class="dashList">
								<li>- 건강영양 아카데미 과정 수료한 유자격 SP 이상 대상</li>
								<li>- 전국AP에서 진행되는 제품 전달을 위한 체계적인 뉴트리라이트 솔루션 과정</li>
							</ul>
						</dd>
					</dl>
				</section>
				
				<section>
					<h3>아티스트리 브랜드 전문가 과정</h3>
					<p>뷰티 전반의 체계적인 지식과 제품 실기 과정으로 구성된 아티스트리 뷰티 비즈니스 전문가를 꿈꾸는 ABO분들을 위한 과정입니다.</p>
					<div><img src="/_ui/mobile/images/academy/img_standardClass02.jpg" alt="아티스트리 브랜드 전문가 과정 대표이미지" /></div>
					<dl>
						<dt>1단계 : 뷰티 스쿨 과정</dt>
						<dd><ul class="dashList">
								<li>- 모든 ABO 대상</li>
								<li>- 피부에 대한 지식과 아티스트리 제품 사용법에 대한 온라인 과정</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>2단계 : 아티스트리 아카데미 과정</dt>
						<dd><ul class="dashList">
								<li>- 뷰티 스쿨 과정을 수료한 유자격 SP 이상 대상</li>
								<li>- 스킨케어 솔루션과 메이크업 실습 과정</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>3단계 : 뷰티 큐레이터 과정</dt>
						<dd><ul class="dashList">
								<li>- 아티스트리 아카데미 과정을 수료한 유자격 PT 이상 대상</li>
								<li>- 전문적인 뷰티 솔루션 전달을 위한 비즈니스 커뮤니케이션 과정</li>
							</ul>
						</dd>
					</dl>
				</section>
				
				<section>
					<h3>Amway Queen 요리명장 과정</h3>
					<p>암웨이 퀸을 활용한 다양한 레시피 시연과 성공적인 홈미팅 &amp; 홈파티 노하우를 전달하는 과정입니다.</p>
					<div><img src="/_ui/mobile/images/academy/img_standardClass03.jpg" alt="Amway Queen 요리명장 과정 대표이미지" /></div>
					<dl>
						<dt>1단계 : 요리명장 선발대회</dt>
						<dd><ul class="dashList">
								<li>- 유자격  PT 이상, 전국 AP 예선을 통해 선발되신 ABO 대상</li>
								<li>- 본인만의 암웨이 퀸을 사용해 요리 하는 경연</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>2단계 : 요리명장 워크샵</dt>
						<dd><ul class="dashList">
								<li>- 요리명장 대상</li>
								<li>- 요리명장 ABO 강사 과정</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>3단계 : 요리명장 쿠킹 클래스</dt>
						<dd><ul class="dashList">
								<li>- 요리명장 대상</li>
								<li>- 전국 AP/ABC 쿠킹클래스를 통한 명장으로 업그레이드 되는 과정</li>
							</ul>
						</dd>
					</dl>
				</section>
				
				<section>
					<h3>비즈니스 리더 정규 과정</h3>
					<p>'비즈니스'에 대한 동기부여와 '리더'로서 준비되는 비즈니스 리더를 육성하는 과정입니다.</p>
					<div><img src="/_ui/mobile/images/academy/img_standardClass04.jpg" alt="비즈니스 정규 과정 대표이미지" /></div>
					<dl>
						<dt>SP 세미나</dt>
						<dd><ul class="dashList">
								<li>- New SP 대상</li>
								<li>- 본격적인 사업자로서 첫 번째인 SP 핀의 인정과 차기 핀으로의 성장을 위한 마인드에 관한 세미나 (SP 인정식, 비즈니스 업데이트, SMP & 윤리강령)</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>New Platinum 세미나</dt>
						<dd><ul class="dashList">
								<li>- New Platinum 대상</li>
								<li>- 플래티넘 리더로서의 핀의 인정과 ABO 리더로서의 소통 및 역할에 관한 세미나 (비즈니스 업데이트, 개인 성향 유형별 커뮤니케이션, 윤리강령 서약식)</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>Emerald 포럼</dt>
						<dd><ul class="dashList">
								<li>- New Emerald 대상</li>
								<li>- 새로운 목표 달성을 위한 효율적 리더십 역량 강화하는 포럼 (비즈니스 업데이트, 마케팅 업데이트, 상황 대응 리더십)</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>New Diamond Conference</dt>
						<dd><ul class="dashList">
								<li>- New Diamond 대상</li>
								<li>- Diamond 성취자들에게 제공되는 최상의 교육, 정보공유 및 코칭의 기회</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>Diamond 세미나</dt>
						<dd><ul class="dashList">
								<li>- 유자격 Diamond 대상</li>
								<li>- 내 외부 변화와 흐름에 따른 차기연도 비즈니스 전략 수립에 도움을 주는 세미나 (비즈니스 업데이트, 마케팅 업데이트, 차년도 사회/소비 트렌드 특강)</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>윤리강령 교육과정</dt>
						<dd><ul class="dashList">
								<li>- 기본 과정 : 모든 ABO 대상<br/>심화 과정 : SP 이상</li>
								<li>- 지속 가능한 성장을 위한 필수 요소인 비즈니스 건전성 향상을 위한 윤리강령 교육</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt>뉴 플래티늄 글로벌 인증 과정</dt>
						<dd><ul class="dashList">
								<li>- Platinum 이상</li>
								<li>- 플래티늄의 역량을 강화하고 보다 안정적인 사업을 진행할 수 있도록 기본 지식을 전달하는 전 세계 뉴 플래티늄 대상, 글로벌 암웨이 교육인증과정</li>
							</ul>
						</dd>
					</dl>
				</section>
				
				<div class="btnWrap aNumb1">
					<a href="#" class="btnBasicGNL" onclick="goRegular();">정규과정 수강신청</a>
				</div>
			</div>
			
		</section>
		<!-- content ##iframe end## -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
</body>
</html>