<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>음원자료실 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>


	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
	
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<script type="text/javascript">
	
	$(document.body).ready(function() {
		
		setTimeout(function(){ abnkorea_resize(); }, 500);

		// 확인버튼 클릭
		$("#btnConfirm").on("click", function(){
			var chkCode = $("input:radio[name = chkType]:checked").val();
			if(chkCode != "Y" && chkCode != "N") {
				alert("동의여부를 선택해주세요.");
				return;
			}
			
			var loginYn = $("#loginYn").val();
			if( loginYn != "Y" ) {
				alert("로그인 후 이용하실 수 있습니다.");
			}	
			
			$("#lmsForm > input[name='agreeYn']").val(chkCode);
			
			doSubmit();
		});
		
	});

	// 확인호출
	function doSubmit() {
		$("#lmsForm").attr("action", "/mobile/lms/BizInfoAgreeEduResource.do");
		$("#lmsForm").submit();
	}
	
</script>

</head>

<body class="uiGnbM3">
<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="agreeCategoryid"  value="${scrData.categoryid }" />
	<input type="hidden" id="loginYn"  value="${scrData.loginYn }" />
	<input type="hidden" name="agreeYn"  value="" />
</form>

		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">교육자료 ${scrData.menuCategoryNm}</h2>
			<div class="acSubWrapW">
			
			<c:if test="${scrData.menuCategory eq 'EduResourceMusic'}"> <!-- 음원자료실 저작권 동의 -->
				<h3 class="titH3"><span>[필수]</span> AMWAY Music Library (음원자료실) ABO 사용 요건</h3>
				<div class="bdBox">
					<h4 class="textC mgbS">[${scrData.name}]을(를) 위한 AMWAY Music Library</h4>
					<p class="textC mgbS fcR"><strong>ABO 사용 요건</strong></p>
					
					<ol class="acNumList">
						<li><strong>1. 용어정의</strong>
							Amway Music Library에는 Alticor Inc.에서 사용권을 얻은 트랙("Amway 라이선스 음원")이 포함되어 있습니다. Alticor Inc.는 다음 섹션들에 명시된 요건을 조건으로 하여 ABO에게 Amway 비즈니스에 한하여 Amway 라이선스 음원을 사용할 수 있는 자격을 제공합니다. Amway 라이선스 음원은 해당 요건을 준수하여 사용해야 합니다.</li>
						<li><strong>2. 회의 및 이벤트</strong>
							승인받은 제공업체 및 ABO는 회의, 이벤트 또는 기타 Amway 비즈니스 관련 활동에서 Amway의 사전 허가 없이 Amway 라이선스 음원을 변형하지 않고 녹음된 그대로 사용할 수 있습니다.</li>
						<li><strong>3. 공연</strong>
							커버, 솔로, 합주 또는 유사한 활동 등 Amway 라이선스 음원을 사용하여 라이브 공연을 하려는 경우 Amway의 사전 승인을 받아야 합니다.</li>
						<li><strong>4. 재판매, 배포 또는 수정 안 됨</strong>
							Amway 라이선스 음원을 재판매, 배포 또는 수정할 수 없습니다.</li>
						<li><strong>5. 발췌</strong>
							Amway 라이선스 음원은 위의 섹션 2에 명시된 바와 같은 방식으로 변형되지 않은 발췌 부분을 회의 및 이벤트에 사용하는 경우를 제외하고 전체 또는 일부를 수정할 수 없습니다.</li>
						<li><strong>6.확인</strong>
							음원 트랙은 언제든지 Amway Music Library 삭제될 수 있으므로 승인받은 제공업체 또는 ABO는 선택한 음원 을 사용하기 전에 Amway 뮤직 라이브러리에 액세스하여 여전히 음원 을 사용할 수 있는지 확인해야 합니다.</li>
						<li><strong>7. 파생 작업</strong>
							Amway의 사전 승인 없이 Amway 라이선스 음원 을 변형하거나 편곡해서는 안 됩니다.</li>
						<li><strong>8. 요건 이해</strong>
							Amway Music Library에 액세스하거나 Amway 라이선스 음원 을 다운로드 및/또는 사용함으로써 귀하는 이러한 요건에 동의하게 됩니다. 또한 Amway의 허가를 받은 후에만 Amway 라이선스 음원 을 사용하며, Amway에서 언제든지 사용 허가를 철회하거나 Amway Music Library에서 트랙을 삭제할 권한을 가진다는 점에 동의합니다.</li>
					</ol>
				</div>
			</c:if>
			
			<c:if test="${scrData.menuCategory ne 'EduResourceMusic'}"> <!-- 음원자료실외의 저작권 동의 -->
				<h3 class="titH3"><span>[필수]</span> 교육자료 콘텐츠 이용을 위한 저작권 사용 동의</h3>
				<div class="bdBox pdtM">
					<h4 class="textC mgbM">교육자료(${scrData.menuCategoryNm}) 콘텐츠 이용을 위한 저작권 사용 동의</h4>
					<!-- <h4 class="textC mgbM">교육자료 콘텐츠 이용을 위한 저작권 사용 동의</h4> -->
					<ol class="acNumList mgtM">
						<li>1. 암웨이가 발행 및 제공하는 모든 자료는 저작권 보호를 받으며 암웨이의 사전 서면 승인 없이는 무단으로 전제하거나 발췌할 수 없다. 단, 지침 9.2.에 의거하여 제 규정에 벗어나지 않는 범위 내에서는 사용이 가능하다.</li>
						<li>2. ABO는 ABO로서의 기능을 수행하기 위한 목적에 한하여 공식적인 암웨이 자료를 사용할 수 있다.</li>  
					</ol>
					
					<p class="mgbM">한국암웨이는 회원 관리, 서비스 제공, 주문 처리, 장애처리, 민원처리 등 계약의 이행을 위해, 개인정보를 제한된 범위에서 암웨이 글로벌에 위탁하여 관리를 하고 있습니다.</p>
					
					<table class="tblCont">
						<caption>개인정보취급 위탁하는 회사</caption>
						<colgroup>
							<col style="width:30%">
							<col style="width:auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="bg">이전목적</th>
								<td>ABO 교육</td>
							</tr>
							<tr>
								<th scope="row" class="bg">이전국가 및 이전 받는 자</th>
								<td>Alticor, USA(알티코, 미국)</td>
							</tr>
							<tr>
								<th scope="row" class="bg">이전항목</th>
								<td>ABO번호, 이름, 주소, 연락처</td>
							</tr>
							<tr>
								<th scope="row" class="bg">이전시점</th>
								<td>교육 시</td>
							</tr>
						</tbody>
					</table>
				</div>
			</c:if>
			
				<div class="acAgreeBoxWrap">
					<p>본인은 위 내용을 읽고 명확히 이해하였으며 이에</p>
					<span><input type="radio" id="acAgree1" name="chkType" value="Y" checked="checked"><label for="acAgree1">동의</label></span>
					<span><input type="radio" id="acAgree2" name="chkType" value="N"><label for="acAgree2">동의하지 않음</label></span>
				</div>
				
				<div class="btnWrap aNumb1">
					<a href="#none" id="btnConfirm" name="btnConfirm" class="btnBasicGNL">확인</a>
				</div>
			</div>
					
		</section>
		<!-- content ##iframe end## -->
		
		
</body>
</html>				
				
