<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
// 	$("#btnBasicBL").on("click", function(){
		
		
// 	});
	$(".btnBasicGL").on("click", function(){
		try{
// 			window.opener.location.reload();
			self.close();
		}catch(e){
// 			console.log(e);
		}
	});
	$(".btnPopClose").on("click", function(){
		self.close();
	});
	
});

function roomEduInsert(){
	$(".btnBasicBL").removeAttr("onclick");
	
	var param = $("#roomEduForm").serialize();
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/roomEduReservationInsertAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			if ("false" == data.possibility){
				
				alert(data.reason);
				$(".btnBasicBL").attr("onclick", "javascript:roomEduInsert()");
				self.close();
				
			} else {
				
				var totalCnt = data.totalCnt;
				if (totalCnt){
					try{
						/*팝업창 닫기 */
						window.opener.$("#transactionTime").val(data.transactionTime);
						window.opener.roomEduRsvDetail();
						self.close();
					}catch(e){
//							console.log(e);
					}
				} else {
					alert("처리도중 오류가 발생하였습니다.");
				}
			}

		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			
			$(".btnBasicBL").attr("onclick", "javascript:roomEduInsert()");
		}
	});
}

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
		<h1><img src="/_ui/desktop/images/academy/h1_w020500040.gif" alt="예약 및 결제정보 확인" /></h1>
	</header>
	<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
			
		<span class="resvItem">${roomEduPaymentInfoList[0].ppName}<em>|</em>${roomEduPaymentInfoList[0].roomName}</span>
				
		<table class="confirmTbl">
			<caption>예약 확인</caption>
			<colgroup>
				<col style="width:30%" />
				<col style="width:45%" />
				<col style="width:25%" />
			</colgroup>
			<thead>
			<tr>
				<th scope="col">날짜</th>
				<th scope="col">세션(사용시간)</th>
				<th scope="col">금액(VAT포함)</th>
			</tr>
			</thead>
			<tbody>
				<c:set var="totalPrice" value="0"/>
				<c:set var="totalCnt" value="0"/>
				
				<form id="roomEduForm" name="roomEduForm" method="post">
					<c:forEach var="item" items="${roomEduPaymentInfoList}" varStatus="status">
						<tr>
							<td>${item.sessionYmd}
								<input type="hidden" name="interfaceChannel" value="WEB" />
								<input type="hidden" name="typeseq" value="${item.typeSeq}">
								<input type="hidden" name="ppseq" value="${item.ppSeq}">
								<input type="hidden" name="roomseq" value="${item.roomSeq}">
								<input type="hidden" name="reservationdate" value="${item.reservationDate}">
								<input type="hidden" name="rsvsessionseq" value="${item.rsvSessionSeq}">
								<input type="hidden" name="startdatetime" value="${item.startDateTime}">
								<input type="hidden" name="enddatetime" value="${item.endDateTime}">
								<input type="hidden" name="price" value="${item.price}">
								<input type="hidden" name="cookmastercode" value="${item.cookMasterCode}">
								<input type="hidden" name="standbynumber" value="${item.standByNumber}">
								<input type="hidden" name="paymentstatuscode" value="${item.paymentStatusCode}">
							</td>
							<td>${item.sessionName}</td>
							<td>${item.sessionPrice}</td>
						</tr>
						<c:set var="totalPrice" value="${totalPrice + item.price}"/>
						<c:set var="totalCnt" value="${totalCnt + 1}"/>
					</c:forEach>
					
					<input type="hidden" name="bankid"  	 value="${reqData.bankid}" />
					<input type="hidden" name="bankname"  	 value="${reqData.bankname}" />
					<input type="hidden" name="paymentmode"  value="${reqData.paymentmode}" />
					<input type="hidden" name="cardowner" 	 value="${reqData.cardowner}" />
					<input type="hidden" name="cardnumber1"  value="${reqData.cardnumber1}" />
					<input type="hidden" name="cardnumber2"  value="${reqData.cardnumber2}" />
					<input type="hidden" name="cardnumber3"  value="${reqData.cardnumber3}" />
					<input type="hidden" name="cardnumber4"  value="${reqData.cardnumber4}" />
					<input type="hidden" name="cardmonth" 	 value="${reqData.cardmonth}" />
					<input type="hidden" name="cardyear" 	 value="${reqData.cardyear}" />
					<input type="hidden" name="cardpassword" value="${reqData.cardpassword}" />
					<input type="hidden" name="einstallment" value="${reqData.einstallment}" />
					<input type="hidden" name="ninstallment" value="${reqData.ninstallment}" />
					<input type="hidden" name="birthday" 	 value="${reqData.birthday}" />
					<input type="hidden" name="biznumber" 	 value="${reqData.biznumber}" />
					<input type="hidden" name="orderAmount"  value="${totalPrice}" />
							
				</form>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="3" class="total textR">
					<strong>총 ${totalCnt}건</strong><em>|</em><strong><fmt:formatNumber value="${totalPrice}" type="number" />원</strong>
				</td>
			</tr>
			</tfoot>
		</table>
		
		<c:if test="${totalPrice ne 0}">
			<table class="tblInput mgtL">
				<caption>결제정보 확인</caption>
				<colgroup>
					<col style="width:30%" />
					<col style="width:70%" />
				</colgroup>			
				<tbody>
				<tr>
					<th scope="row">카드번호</th>
					<td>${reqData.cardnumber1} - **** - **** - ${reqData.cardnumber4}</td>
				</tr>
				<tr>
					<th scope="row">유효기간</th>
					<td>${reqData.cardyear}년 ${reqData.cardmonth}월</td>
				</tr>
				<tr>
					<th scope="row">할부기간</th>
					<td>${reqData.ninstallment}개월</td>
				</tr>
				<tr>
					<th scope="row">카드결제금액</th>
					<td><strong><fmt:formatNumber value="${totalPrice}" type="number" />원</strong></td>
				</tr>
				</tbody>
			</table>
			
			<div class="lineBox mgtbM">
				<ul class="listDot">
				<li>결제완료까지 시간이 지연될 수 있습니다. 조금만 기다려 주세요.</li>
				<li>[예약확정] 버튼은 한 번만 선택하세요. 여러 번 선택하시면 예약이 중복 생성될 수 있습니다.</li>
				<li>※ 사용 예정일 1~7일 전 취소한 경우, 해당 시설 임대 금액의 10%를 취소 수수료로 공제 후 환급됩니다.</li>
				</ul>
			</div>
		</c:if>
		
		<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>
		<strong>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</strong></p>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="예약취소" />
			<input type="button" class="btnBasicBL" onclick="javascript:roomEduInsert();" value="예약확정" />
		</div>
	
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
