<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
	$(".btnBasicBS").on("click", function(){

		var selectChoice = $("input:radio[name='resConfirm']:checked").val();

		if(selectChoice == "resConfirm1"){
			
			/* 발견된 중복건수를 opener 페이지의 세션선택 상자에서 찾은 후 해제 시키는 기능 */
			$("input[type='hidden']").each(function(){
				window.opener.$(".brSessionWrap input[type='checkbox'][id='" + $(this).val() + "'] ").prop("checked", false);
			});
			
			/* 위의 중복된 세션 해제 후 예약 정보를 갱신시킨다. */
			window.opener.sessionCheck();
			
			/* 부모 함수 호출 - 결제 */
			window.opener.paymentCheck();

			/* 팝업창 닫는 기능 */
			self.close();

		} else {
			
			/* 3단계의 '이전'버튼을 클릭하는 이벤트를 발생시킨다. */
			window.opener.$("#step3 > div > div.sectionWrap > div > a.btnBasicGS").click();
			
			/* 팝업창 닫는 기능 */
			self.close();
		}
	});
});

</script>
</head>
<body>
<!-- <form id="expInfoForm" name="expInfoForm" method="post"> -->
<%-- 	<input type="text" name="rsvseq" value="${scrData.rsvseq}"> --%>
<%-- 	<input type="text" name="purchasedate" value="${scrData.purchasedate}"> --%>
<%-- 	<input type="text" name="expsessionseq" value="${scrData.expsessionseq}"> --%>
<%-- 	<input type="text" name="reservationdate" value="${scrData.reservationdate}"> --%>
<%-- 	<input type="text" name="ppseq" value="${scrData.ppseq}"> --%>
	
	<!-- 캘린더 부모 함수 호출시 필요한 파라미터 -->
<%-- 	<input type="hidden" name="parentInfo" id="parentInfo" value="${scrData.parentInfo}"> --%>
<%-- 	<input type="hidden" name="popYear" id="popYear" value="${scrData.popYear}"> --%>
<%-- 	<input type="hidden" name="popMonth" id="popMonth" value="${scrData.popMonth}"> --%>
<%-- 	<input type="hidden" name="popDay" id="popDay" value="${scrData.popDay}"> --%>
<!-- </form> -->
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500030.gif" alt="예약불가 알림" /></h1>
	</header>
	<a href="javascript:void(0);" onClick="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
		<p>예약 진행 중 다른 사용자가 실시간으로 아래 예약건을 이미 완료 하였습니다.</p>
	
		<h2 class="mgtL">예약불가 항목</h2>
		
		<c:forEach var="item" items="${roomEduPaymentDisableList}" varStatus="status">
			<div class="lineBox msgBox">
				<input type="hidden" name="cancelKey" value="${item.reservationDate}_${item.rsvSessionSeq}" />
				<span class="resvItem">${item.ppName}<em>|</em>${item.roomName}<em>|</em>${item.sessionYmd}<em>|</em>${item.sessionName}</span>
			</div>
		</c:forEach>
		
		<div class="pdlS pdtS">
			<!-- @edit 20160701 문구수정 -->
			<p class="mgbS">
				<input type="radio" id="resConfirm1" name="resConfirm" value="resConfirm1" />
				<label for="resConfirm1">예약불가 세션 제외 후 결제 진행</label>
			</p>
			<p>
				<input type="radio" id="resConfirm2" name="resConfirm" value="resConfirm2" />
				<label for="resConfirm2">날짜 및 세션 다시 선택 후 진행</label>
			</p>
		</div>
		
		<div class="btnWrapC">
			<input type="submit" class="btnBasicBS" value="확인" />
		</div>
	
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>