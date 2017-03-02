<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>온라인강의 - ABN Korea</title>
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
			
			$("#lmsForm > input[name='agreeYn']").val(chkCode);
			
			doSubmit();
		});
		
	});

	// 확인호출
	function doSubmit() {
		$("#lmsForm").attr("action", "/mobile/lms/PersonalInfoAgree.do");
		$("#lmsForm").submit();
	}
	
</script>

</head>

<body class="uiGnbM3">
<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="agreeCourseid"  value="${scrData.agreeCourseid }" />
	<input type="hidden" name="agreeYn"  value="" />
</form>

		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">온라인강의 신규</h2>
			
			<div class="acSubWrapW">
				<h3 class="titH3"><span>[필수]</span> 온라인강의 사용을 위한 개인정보 활용 동의</h3>
				<div class="bdBox pdtM">
					<h4 class="textC mgbM">온라인강의 사용을 위한 개인정보 활용 동의</h4>
					
					<p class="mgbM">본인이 암웨이의 ABO로 등록하고 활용하는 동안에 암웨이가 본인으로부터 취득하거나 암웨이에서 작성하는 개인정보는 교육 서비스를 위해 Alticor, USA(Amway Global)에 위탁하여 처리할 수 있습니다.</p>
					<p class="mgbM">이러한 위탁계약 등을 통하여 서비스 제공자의 개인정보보호 관련 지시엄수, 개인정보에 관한 비밀유지, 제3자 제공의 금지 및 사고시의 책임부담 등을 명확히 규정하고 당해 계약내용을 서면 또는 전자적으로 보관하여 이용자의 권익을 보호하고 있습니다.</p>
					<p class="mgbM">한국암웨이는 회원 관리, 서비스 제공, 주문 처리, 장애처리, 민원처리 등 계약의 이행을 위해, 개인정보를 제한된 범위에서 암웨이 글로벌에 위탁하여 관리를 하고 있습니다.</p>
					<p class="mgbS">개인정보취급을 위탁하는 회사는 아래와 같습니다.</p>
					
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
				
				<div class="acAgreeBoxWrap">
					<p>본인은 위 내용을 읽고 명확이 이해하였으며 이에</p>
					<span><input type="radio" id="radio01" name="chkType" value="Y" checked="checked"><label for="acAgree1">동의</label></span>
					<span><input type="radio" id="radio01" name="chkType" value="N"><label for="acAgree2">동의하지 않음</label></span>
				</div>
				
				<div class="btnWrap aNumb1">
					<a href="#none" id="btnConfirm" name="btnConfirm" class="btnBasicGNL">확인</a>
				</div>
			</div>
					
		</section>
		<!-- content ##iframe end## -->
		
		
</body>
</html>				
				
