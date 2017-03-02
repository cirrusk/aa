<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

<script type="text/javascript">

$(document).ready(function () {
	
	/* 예약계속하기} */
	$(".btnBasicGL").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expCultureForm.do'/>";
	});
	
	$(".result").show();
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	/* STEP2로 이동 */
	var $pos = $("#pbContent > section.mWrap > div.bizEduPlace");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 300);
});

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 문화체험 예약";
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

<!-- //예약완료 -->
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
	<input type="hidden" id="transactionTime" />
	<input type="hidden" id="snsText" name="snsText" value="${snsText}">
	<section class="mWrap">
		<div class="bizEduPlace">
			<div class="result" style="display:block;">
				<div class="tWrap">
					<em class="bizIcon step05"></em><strong class="step">예약내역</strong>
					<span>총${fn:length(expCultureCompleteList)}건</span>
					<div class="resultDetail">
					<c:forEach var="item" items="${expCultureCompleteList}" varStatus="status">
						<span>${item.ppName}<em class="bar">|</em>${item.productName}<em class="bar">|</em><em class="bar">|</em><br/>
						${fn:substring(item.reservationDate, 0, 4)}-${fn:substring(item.reservationDate, 4, 6)}-${fn:substring(item.reservationDate, 6, 8)}(${item.krWeekDay}) ${fn:substring(item.startDateTime, 0, 2)}:${fn:substring(item.startDateTime, 2, 4)}<em class="bar">|</em><br/>참석인원 ${item.visitNumber}명</span>
					</c:forEach>
					</div>
				</div>
			</div>
			
		</div>
		
		<!-- 예약완료 -->
		<div class="stepDone selcWrap" id="stepDone">
			<div class="doneText"><strong class="point1">예약</strong><strong class="point3">이 완료 되었습니다.</strong><br/>
			이용해 주셔서 감사합니다.</div>
			
			<div class="detailSns">
				<a href="#none" id="snsKt" onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"  title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
				<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
				<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');"       title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
				<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');"   title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
			</div>
			<span class="doneText">예약내역공유</span>
				
			<div class="btnWrap aNumb2">
				<a href="/mobile/reservation/expCultureForm.do" class="btnBasicGL">예약계속하기</a>
				<a href="/mobile/reservation/expInfoList.do" class="btnBasicBL">예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</section>

</section>

<!-- //content area | ### academy IFRAME End ### -->

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
