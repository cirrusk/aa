<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title> 온라인강의 저작권 동의- ABN Korea</title>
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
		$("#lmsForm").attr("action", "/mobile/lms/BizInfoAgreeOnline.do");
		$("#lmsForm").submit();
	}
	
</script>

</head>

<body class="uiGnbM3">
<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="categoryid"  value="${scrData.categoryid }" />
	<input type="hidden" name="agreeYn"  value="" />
</form>

		<!-- content ##iframe start## -->
		<section id="pbContent" class="academyWrap">
			<h2 class="hide">온라인강의 ${scrData.menuCategoryNm}</h2>
			<div class="acSubWrapW">
				<h3 class="titH3"><span>[필수]</span> 온라인강의 콘텐츠 이용을 위한 저작권 사용 동의</h3>
				<div class="bdBox pdtM">
					<h4 class="textC mgbM">온라인강의(${scrData.menuCategoryNm}) 콘텐츠 이용을 위한 저작권 사용 동의</h4>
					<!-- <h4 class="textC mgbM">온라인강의 콘텐츠 이용을 위한 저작권 사용 동의</h4> -->
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