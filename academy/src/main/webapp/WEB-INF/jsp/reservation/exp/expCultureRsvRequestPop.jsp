<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
	$(".btnBasicGL").on("click", function(){
		
		try{
// 			window.opener.location.reload();
			self.close();
		}catch(e){
			//console.log(e);
		}
	});
	
	$("#memberConfirm").on("click", function(){
		
		var param = $("#expCultureForm").serialize();
		
		$.ajax({
			url: "<c:url value='/reservation/expCultureRsvInsertAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				/* 부모창으로  예약한 데이터 전달 */
				if("false" == data.possibility){
					alert(data.reason);
					return false;
				}else{
					try{
						window.opener.$("#transactionTime").val(data.transactionTime);
						window.opener.expCultureRsvComplete(data.expCultureCompleteList);
						self.close();
					}catch(e){
						alert(e);
					}
				}
				
			},
			error: function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	});
	
	$("#nonmemberConfirm").on("click", function(){

		var param = $("#expCultureForm").serialize();
		
		$.ajax({
			url: "<c:url value='/reservation/expCulturePopToParentAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				if("false" == data.possibility){
					alert(data.reason);
					return false;
				}else{
					/* 부모창으로  예약한 데이터 전달 */
					self.close();
					window.opener.expCultureNonmemberIdCheckForm(data.expCultureInfoList);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
	});
	
});

</script>
</head>
<body>
<form id="expCultureForm" name="expCultureForm" method="post">
<input type="hidden" name="tempParentFlag" value="date">
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500080.gif" alt="예약정보 확인" /></h1>
	</header>
	<a href="#" onClick="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
			
		<span class="resvItem">${expCultureProgramList[0].ppName}<em>|</em>${fn:substring(expCultureProgramList[0].reservationDate, 0, 4)}-${fn:substring(expCultureProgramList[0].reservationDate, 4, 6)}-${fn:substring(expCultureProgramList[0].reservationDate, 6, 8)} (${expCultureProgramList[0].krWeekDay})</span>
		
		<table class="confirmTbl">
			<caption>예약정보 확인</caption>
			<colgroup>
				<col style="width:auto"/>
				<col style="width:25%"/>
				<col style="width:20%"/>
			</colgroup>
			<thead>
			<tr>
				<th scope="col">프로그램</th>
				<th scope="col">체험시간</th>
				<th scope="col">참석인원</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach var="item" items="${expCultureProgramList}" varStatus="status">
			<tr>
				<td>${item.productName}</td>
				<c:if test="${item.paymentStatusCode eq 'P02'}">
				<td>${fn:substring(item.startDateTime, 0, 2)}:${fn:substring(item.startDateTime, 2, 4)}</td>
				</c:if>
				<c:if test="${item.paymentStatusCode eq 'P01'}">
				<td>${fn:substring(item.startDateTime, 0, 2)}:${fn:substring(item.startDateTime, 2, 4)}<br/>(대기신청)</td>
				</c:if>
				<td>
					<input type="hidden" name="tempTypeSeq" value="${item.typeSeq}">
					<input type="hidden" name="tempPpSeq" value="${item.ppSeq}">
					<input type="hidden" name="tempPpName" value="${item.ppName}">
					<input type="hidden" name="tempExpSeq" value="${item.expSeq}">
					<input type="hidden" name="tempExpSessionSeq" value="${item.expSessionSeq}">
					<input type="hidden" name="tempReservationDate" value="${item.reservationDate}">
					<input type="hidden" name="tempStandByNumber" value="${item.standByNumber}">
					<input type="hidden" name="tempPaymentStatusCode" value="${item.paymentStatusCode}">
					<input type="hidden" name="tempProductName" value="${item.productName}">
					<input type="hidden" name="tempStartDateTime" value="${item.startDateTime}">
					<input type="hidden" name="tempEndDateTime" value="${item.endDateTime}">
					<input type="hidden" name="tempKrWeekDay" value="${item.krWeekDay}">
					<select title="참석인원 선택" name="tempVisitNumber" class="tdSel">
							<option value="1">없음</option>
							<option value="2">있음</option>
					</select>
				</td>
			</tr>
			</c:forEach>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="4" class="total textR"><strong>총 ${fn:length(expCultureProgramList)} 건</strong></td>
			</tr>
			</tfoot>
		</table>
		
		
		<c:if test="${expCultureProgramList[0].account ne ''}">
		<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="예약취소" />
			<input type="button" id="memberConfirm" class="btnBasicBL" value="예약확정" />
		</div>
		</c:if>
		<c:if test="${expCultureProgramList[0].account eq ''}">
		<!--  비회원 일 경우 -->
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="예약취소" />
			<input type="button" id="nonmemberConfirm" class="btnBasicBL" value="다음" />
		</div>
		</c:if>
		
		
	</section>
</div>
</form>

		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>