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
<title>온라인강의 - ABN Korea</title>
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
			
			$("#lmsForm > input[name='agreeYn']").val(chkCode);
			
			doSubmit();
		});
		
	});

	// 확인호출
	function doSubmit() {
		$("#lmsForm").attr("action", "/lms/PersonalInfoAgree.do");
		$("#lmsForm").submit();
	}
	
</script>

</head>

<body>
<form id="lmsForm" name="lmsForm" method="post">
	<input type="hidden" name="agreeCourseid"  value="${scrData.agreeCourseid }" />
	<input type="hidden" name="agreeYn"  value="" />
</form>

		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
				<h1><img src="/_ui/desktop/images/academy/h1_w030400000.gif" alt="온라인강의"></h1>
				<p><img src="/_ui/desktop/images/academy/txt_w030400100.gif" alt="제품·비즈니스에 대한 다양한 온라인 과정을 만나보세요." /></p>
			</div>
			
			<p class="topBoxUpper"><strong>[필수]</strong>온라인강의 사용을 위한 개인정보 활용 동의</p>
			
			<div class="lineBox2 pdbL">
				<p class="textC mgtS"><strong>온라인강의 사용을 위한 개인정보 활용 동의</strong></p>
				
				<p class="ptxt mgtM">본인이 암웨이의 ABO로 등록하고 활용하는 동안에 암웨이가 본인으로부터 
				취득하거나 암웨이에서 작성하는 개인정보는 교육 서비스를 위해 Alticor, USA(Amway Global)에 위탁하여 처리할 수 있습니다.</p>
				<p class="ptxt mgtM">이러한 위탁계약 등을 통하여 서비스 제공자의 개인정보보호 관련 지시엄수, 개인정보에 관한 비밀유지,
				제3자 제공의 금지 및 사고시의 책임부담 등을 명확히 규정하고 당해 계약내용을 서면 또는 전자적으로
				보관하여 이용자의 권익을 보호하고 있습니다.</p>
				
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
			
			<div class="agreeCWrap">
				<div class="agreeSec">
					본인은 위 내용을 읽고 명확히 이해하였으며 이에
					<input type="radio" id="radio01" name="chkType" value="Y" class="mglM"><label for="radio01">동의함</label> 
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
				
