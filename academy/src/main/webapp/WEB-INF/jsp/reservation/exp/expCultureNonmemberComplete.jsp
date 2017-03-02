<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document).ready(function () {
	
	/* 예약계속하기} */
	$(".btnBasicGL").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expCultureForm.do'/>";
	});
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
});

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 문화 체험 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}




</script>
</head>
<body>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<c:set var="snsText" value="[한국암웨이]시설/체험 예약내역(총${fn:length(expCultureCompleteList)}건)"/>
	<c:forEach var="item" items="${expCultureCompleteList}" varStatus="status">
	<c:if test="${item.paymentStatusCode eq 'P01'}">
	<c:set var="snsText" value="${snsText}■${item.ppName}(${item.productName})${fn:substring(item.reservationDate, 0, 4)}-${fn:substring(item.reservationDate, 4, 6)}-${fn:substring(item.reservationDate, 6, 8)}(${item.krWeekDay}) | \n${fn:substring(item.startDateTime, 0, 2)}:${fn:substring(item.startDateTime, 2, 4)} (대기신청) | \n참석인원${item.visitNumber}명 \n"/>
	</c:if>
	<c:if test="${item.paymentStatusCode ne 'P01'}">
	<c:set var="snsText" value="${snsText}■${item.ppName}(${item.productName})${fn:substring(item.reservationDate, 0, 4)}-${fn:substring(item.reservationDate, 4, 6)}-${fn:substring(item.reservationDate, 6, 8)}(${item.krWeekDay}) | \n${fn:substring(item.startDateTime, 0, 2)}:${fn:substring(item.startDateTime, 2, 4)} | \n참석인원${item.visitNumber}명 \n"/>
	</c:if>
	</c:forEach>
	<input type="hidden" id="transactionTime" value="" />
	<input type="hidden" id="snsText" name="snsText" value="${snsText}">
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500290.gif" alt="문화체험 예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500290.gif" alt="전국 Amway Plaza에서 운영되고 있는 문화 체험을 예약하실 수 있습니다."></p>
	</div>
	
	<div class="brWrapAll">
		<span class="hide">문화체험 예약 스텝</span>
		<!-- 스텝2 -->
		<div class="brWrap" id="step2">
			<h2 class="stepTit">
				<span class="close mglS"><img src="/_ui/desktop/images/academy/h2_w02_apexp4_02.gif" alt="예약내역" /></span>
			</h2>
			<div class="brSelectWrapAll">
				<div class="result lines req">
					<p class="total">총 ${fn:length(expCultureCompleteList)} 건</p>
					<c:forEach var="item" items="${expCultureCompleteList}" varStatus="status">
					<!-- @edit 20160701 예약대기를 대기신청으로 문구 변경 (전체)-->
					<p><span>${item.ppName}<em>|</em>${item.productName}<em>|</em><br/></span> ${fn:substring(item.reservationDate, 0, 4)}-${fn:substring(item.reservationDate, 4, 6)}-${fn:substring(item.reservationDate, 6, 8)}(${item.krWeekDay}) ${fn:substring(item.startDateTime, 0, 2)}:${fn:substring(item.startDateTime, 2, 4)}<em>|</em>참석인원 ${item.visitNumber}명</p>
					</c:forEach>
				</div>
				
			</div>
		</div>
		<!-- //스텝2 -->
		<!-- 예약완료 -->
		<div class="brWrap" id="stepDone">
			<p><img src="/_ui/desktop/images/academy/brTextDone.gif" alt="예약이 완료 되었습니다. 이용해 주셔서 감사합니다." /></p>
			<div class="snsWrap">
				<!-- 20150313 : SNS영역 수정 -->
			<span class="snsLink">
				<!-- @eidt 20160627 URL 복사 삭제 -->
				<a href="#" id="snsKs" class="snsCs" onclick="javascript:tempSharing('${httpDomain}', 'kakaoStory');" title="새창열림"><span class="hide">카카오스토리</span></a>
				<a href="#" class="snsBand" onclick="javascript:tempSharing('${httpDomain}', 'band');" title="새창열림"><span class="hide">밴드</span></a>
				<a href="#" id="snsFb" class="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');" title="새창열림"><span class="hide">페이스북</span></a>
			</span>
				<!-- //20150313 : SNS영역 수정 -->
				<span class="snsText"><img src="/_ui/desktop/images/academy/sns_text.gif" alt="예약내역공유" /></span>
			</div>
			<div class="btnWrapC">
				<a href="/reservation/expCultureForm.do" class="btnBasicGL">예약계속하기</a>
				<a href="/reservation/expInfoList.do" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</div>
</section>
<!-- //content area | ### academy IFRAME End ### -->

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
