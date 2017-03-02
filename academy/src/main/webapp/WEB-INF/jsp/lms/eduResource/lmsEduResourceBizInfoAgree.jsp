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
<title>교육자료 저작권 동의 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script src="/_ui/desktop/common/js/owl.carousel.js"></script>


	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
	
<script src="/js/front.js"></script>
<script src="/js/lms/lmsComm.js"></script>

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
		$("#lmsForm").attr("action", "/lms/BizInfoAgreeEduResource.do");
		$("#lmsForm").submit();
	}
	
</script>

</head>

<body>
<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="agreeCategoryid"  value="${scrData.categoryid }" />
	<input type="hidden" id="loginYn"  value="${scrData.loginYn }" />
	<input type="hidden" name="agreeYn"  value="" />
</form>

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
		<c:if test="${scrData.menuCategory eq 'EduResourceMusic'}"> <!-- 음원자료실 저작권 동의 -->
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030601000.gif" alt="음원 자료실"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030601000.gif" alt="저작권 걱정없이 다양한 음원을 비즈니스에 활용하세요."></p>
			</div>
			
			<!-- 20160803 문구수정 -->
			<p class="topBoxUpper"><strong>[필수]</strong> AMWAY Music Library (음원자료실) ABO 사용 요건</p>
			
			<div class="lineBox2">
				<p class="textC mgtS"><strong>[${scrData.name}]을(를) 위한 AMWAY Music Library</strong></p>
				<p class="textC fcR mgtbS"><strong>ABO 사용 요건</strong></p>
				
				<ol class="numList">
				<li><strong>1. 용어 정의.</strong> Amway Music Library에는 Alticor Inc.에서 사용권을 얻은 트랙(“Amway 라이선스 음원”)이 포함되어 있습니다.  Alticor Inc.는 다음 섹션들에 명시된 요건을 조건으로 하여 ABO에게 Amway 비즈니스에 한하여 Amway 라이선스 음원을 사용할 수 있는 자격을 제공합니다. Amway 라이선스 음원은 해당 요건을 준수하여 사용해야 합니다.</li>
				<li><strong>2. 회의 및 이벤트.</strong> 승인받은 제공업체 및 ABO는 회의, 이벤트 또는 기타 Amway 비즈니스 관련 활동에서 Amway의 사전 허가 없이 Amway 라이선스 음원을 변형하지 않고 녹음된 그대로 사용할 수 있습니다.</li>  
				<li><strong>3. 공연.</strong> 커버, 솔로, 합주 또는 유사한 활동 등 Amway 라이선스 음원을 사용하여 라이브 공연을 하려는 경우 Amway의 사전 승인을 받아야 합니다.</li>
				<li><strong>4. 재판매, 배포 또는 수정 안 됨.</strong> Amway 라이선스 음원을 재판매, 배포 또는 수정할 수 없습니다.</li>  
				<li><strong>5. 발췌.</strong> Amway 라이선스 음원은 위의 섹션 2에 명시된 바와 같은 방식으로 변형되지 않은 발췌 부분을 회의 및 이벤트에 사용하는 경우를 제외하고 전체 또는 일부를 수정할 수 없습니다.</li>
				<li><strong>6. 확인.</strong> 음원 트랙은 언제든지 Amway Music Library 삭제될 수 있으므로 승인받은 제공업체 또는 ABO는 선택한 음원 을 사용하기 전에 Amway 뮤직 라이브러리에 액세스하여 여전히 음원 을 사용할 수 있는지 확인해야 합니다.</li>
				<li><strong>7. 파생 작업.</strong> Amway의 사전 승인 없이 Amway 라이선스 음원 을 변형하거나 편곡해서는 안 됩니다.</li>
				<li><strong>8. 요건 이해.</strong> Amway Music Library에 액세스하거나 Amway 라이선스 음원 을 다운로드 및/또는 사용함으로써 귀하는 이러한 요건에 동의하게 됩니다. 또한 Amway의 허가를 받은 후에만 Amway 라이선스 음원 을 사용하며, Amway에서 언제든지 사용 허가를 철회하거나 Amway Music Library에서 트랙을 삭제할 권한을 가진다는 점에 동의합니다.</li>
				</ol>			
			</div> 
		</c:if>
		
		<c:if test="${scrData.menuCategory ne 'EduResourceMusic'}"> <!-- 음원자료실외의 저작권 동의 -->
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030400001.gif" alt="저작권 사용 동의"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030400001.gif" alt="콘텐츠 이용을 위하여 저작권 정책을 확인 바랍니다." /></p>
			<!-- <h1><img src="/_ui/desktop/images/academy/${scrData.menuCategoryImg}" alt="${scrData.menuCategoryNm}"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030600100.gif" alt="다양한 교육자료를 통해 암웨이의 제품과 비즈니스를 전달하세요."></p>  -->
			</div>
			
			<p class="topBoxUpper"><strong>[필수]</strong>교육자료(${scrData.menuCategoryNm}) 콘텐츠 이용을 위한 저작권 사용 동의</p>
			<!-- <p class="topBoxUpper"><strong>[필수]</strong>교육자료 콘텐츠 이용을 위한 저작권 사용 동의</p> -->
			
			<div class="lineBox2 pdbL">
				<p class="textC mgtS"><strong>교육자료 콘텐츠 이용을 위한 저작권 사용 동의</strong></p>
				
				<ol class="numList mgtM">
					<li>1. 암웨이가 발행 및 제공하는 모든 자료는 저작권 보호를 받으며 암웨이의 사전 서면 승인 없이는 무단으로 전제하거나 발췌할 수 없다. 단, 지침 9.2.에 의거하여 제 규정에 벗어나지 않는 범위 내에서는 사용이 가능하다.</li>
					<li>2. ABO는 ABO로서의 기능을 수행하기 위한 목적에 한하여 공식적인 암웨이 자료를 사용할 수 있다.</li>  
				</ol>
				
				<p class="ptxt mgtbM">한국암웨이는 회원 관리, 서비스 제공, 주문 처리, 장애처리, 민원처리 등 계약의 이행을 위해,
				개인정보를 제한된 범위에서 암웨이 글로벌에 위탁하여 관리를 하고 있습니다.
				개인정보취급을 위탁하는 회사는 아래와 같습니다.</p>
				
				<table class="tblList lineLeft">
					<caption>개인정보취급 위탁하는 회사</caption>
					<colgroup>
						<col style="width:16%" />
						<col style="width:auto" />
						<col style="width:32%" />
						<col style="width:16%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">이전목적</th>
							<th scope="col">이전국가 및 이전 받는 자</th>
							<th scope="col">이전항목</th>
							<th scope="col">이전시점</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<td>ABO 교육</td>
							<td>Alticor, USA(알티코, 미국)</td>
							<td>ABO번호, 이름, 주소, 연락처</td>
							<td>교육 시</td>
						</tr>
					</tbody>
				</table>
			</div> 
		</c:if>
			
			<div class="agreeCWrap">
				<div class="agreeSec">
					본인은 위 내용을 읽고 명확히 이해하였으며 이에
					<input type="radio" id="radio01" name="chkType" class="mglM" value="Y"><label for="radio01">동의함</label> 
					<input type="radio" id="radio02" name="chkType" value="N"><label for="radio02">동의하지 않음</label>
				</div>
				<div class="btnWrapC pdtM">
					<a href="#none" id="btnConfirm" name="btnConfirm" class="btnBasicAcGNL">확인</a>
				</div>
			</div>

		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
		
		
</body>
</html>				
				
