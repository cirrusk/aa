<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

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
		<h1><img src="/_ui/desktop/images/academy/h1_w020500120_pop.gif" alt="환불내역 확인" /></h1>
	</header>
	<a href="#" class="btnPopClose" onclick="javascrip:self.close();"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
		
		<h2>시설 예약</h2>
		<table class="tblInput mgtS">
			<caption>환불내역 확인</caption>
			<colgroup>
				<col style="width:30%" />
				<col style="width:70%" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">예약자</th>
				<td>${roomInfoRsvPaybackInfo.account } ${roomInfoRsvPaybackInfo.name }</td>
			</tr>
			<tr>
				<th scope="row">예약완료일자</th>
				<td>${roomInfoRsvPaybackInfo.paymentdate }</td>
			</tr>
			<tr>
				<th scope="row">사용예정일자</th>
				<td>${roomInfoRsvPaybackInfo.reservationdate }</td>
			</tr>
			<tr>
				<th scope="row">시설종류</th>
				<td>${roomInfoRsvPaybackInfo.typename }</td>
			</tr>
			<tr>
				<th scope="row">지역/시설명</th>
				<td>${roomInfoRsvPaybackInfo.ppname } / ${roomInfoRsvPaybackInfo.roomname }</td>
			</tr>
			<tr>
				<th scope="row">사용예정시간</th>
				<td>${roomInfoRsvPaybackInfo.sessionname } (${fn:substring(roomInfoRsvPaybackInfo.startdatetime, 0, 2) }:${fn:substring(roomInfoRsvPaybackInfo.startdatetime, 2, 4) }~${fn:substring(roomInfoRsvPaybackInfo.enddatetime, 0, 2)}:${fn:substring(roomInfoRsvPaybackInfo.enddatetime, 2, 4)})</td>
			</tr>
			</tbody>
		</table>
		
		<h2 class="mgtL">결제 및 취소</h2>
		<table class="tblInput mgtS">
			<caption>결제 및 취소</caption>
			<colgroup>
				<col style="width:30%" />
				<col style="width:70%" />
			</colgroup>
			<tbody>
			<tr>
				<th scope="row">취소일자</th>
				<td>${roomInfoRsvPaybackInfo.canceldatetime }</td>
			</tr>
			<tr>
				<th scope="row">취소구분</th>
				<td>시설예약 취소</td>
			</tr>
			<tr>
				<th scope="row">취소형태</th>
				<td>신용카드</td>
			</tr>
			<tr>
				<th scope="row">취소번호</th>
				<td> ${roomInfoRsvPaybackInfo.virtualpurchasenumber } 신용</td>
			</tr>
			<tr>
				<th scope="row">환불방법</th>
				<td>결제금액 기준 ${roomInfoRsvPaybackInfo.applytypevalue }% 취소 수수료 제외 후 환불</td>
			</tr>
			<tr>
				<th scope="row">결제금액</th>
				<td><fmt:formatNumber>${roomInfoRsvPaybackInfo.paymentamount }</fmt:formatNumber></td>
			</tr>
			<tr>
				<th scope="row">취소수수료</th>
				<td><fmt:formatNumber>${roomInfoRsvPaybackInfo.refundcharge }</fmt:formatNumber></td>
			</tr>
			<tr>
				<th scope="row">환불금액</th>
				<td><strong><fmt:formatNumber>${roomInfoRsvPaybackInfo.refundamount }</fmt:formatNumber></strong></td>
			</tr>
			</tbody>
		</table>
		
		<div class="btnWrapC">
			<a href="#none" class="btnBasicGL">닫기</a>
		</div>
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>