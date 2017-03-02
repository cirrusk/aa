<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">
<!-- jenkins test ver 0.1 -->
$(document.body).ready(function(){
	$(".btnBasicGL").on("click", function(){
		/*팝업창 닫기 */
		self.close();
	});
});
</script>
</head>
<body>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500050.gif" alt="약관 및 동의 전체보기" /></h1>
	</header>
	<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" onclick="javascript:self.close();" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
		<div class="tabWrapLogical tabStyle1">
			<section class="logTabSection on">
				<h2 class="tab01"><a href="#none">시설교육 규정 동의</a></h2>
				<div class="tabcon">
					<h3>시설교육 규정 동의</h3>
					<div class="scrollbox">
						<div class="termsWrapper pdNone" tabindex="0">
							<c:out value="${clause05}" escapeXml="false" />
						</div>
					</div>
				</div>
			</section>
			<section class="logTabSection">
				<h2 class="tab02"><a href="#none">시설교육 제품 교육 시 주의 사항</a></h2>
				<div class="tabcon">
					<h3>시설교육 제품 교육 시 주의 사항</h3>
					<div class="scrollbox">
						<div class="termsWrapper pdNone" tabindex="0">
							<c:out value="${clause02}" escapeXml="false" />
						</div>
					</div>
					<p class="listWarning">※ 한국암웨이 뉴트리라이트 제품은 의약품이 아닌 건강기능식품으로, 제품 판매 또는 권유시 세심한 주의가 요구됩니다.</p>
				</div>
			</section>
		</div>	
		
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>