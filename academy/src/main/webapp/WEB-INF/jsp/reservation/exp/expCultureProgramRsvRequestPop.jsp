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
	
// 	$("#memberConfirm").on("click", function(){
// 	});
	
// 	$("#nonmemberConfirm").on("click", function(){
// 	});
	
});

function memberInsert(){
	
	$("#memberConfirm").removeAttr("onclick");
	
	var param = $("#expCultureForm").serialize();
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureRsvInsertAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				/* 부모창으로  예약한 데이터 전달 */
				window.opener.$("#transactionTime").val(data.transactionTime);
				window.opener.expCultureRsvComplete(data.expCultureCompleteList);
				self.close();
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			$("#memberConfirm").attr("onclick", "javascript:memberInsert()");
		}
	});
}

function noMemberInsert(){
	
	$("#nonmemberConfirm").removeAttr("onclick");
	
	var param = $("#expCultureForm").serialize();
	
	$.ajaxCall({
		url: "<c:url value='/reservation/expCulturePopToParentAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				/* 부모창으로  예약한 데이터 전달 */
				window.opener.expCultureNonmemberIdCheckForm(data.expCultureInfoList);
				self.close();
			}
		},
		error: function(jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			$("#nonmemberConfirm").attr("onclick", "javascript:noMemberInsert()");
		}
	});
}

</script>
</head>
<body>
<form id="expCultureForm" name="expCultureForm" method="post">
<input type="hidden" name="tempParentFlag" value="program">
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500080.gif" alt="예약정보 확인" /></h1>
	</header>
	<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
			
		<span class="resvItem">${expCultureProgramList[0].ppName}</span>
		
		<table class="confirmTbl">
			<caption>예약정보 확인</caption>
			<colgroup>
				<col style="width:auto" />
				<col style="width:25%" />
				<col style="width:18%" />
				<col style="width:15%" />
			</colgroup>
			<thead>
			<tr>
				<th scope="col">프로그램</th>
				<th scope="col">날짜</th>
				<th scope="col">체험시간</th>
				<th scope="col">참석인원</th>
			</tr>
			</thead>
			<tfoot>
			<tr>
				<td colspan="4" class="total textR"><strong>총  ${fn:length(expCultureProgramList)} 건</strong></td>
			</tr>
			</tfoot>
			<tbody>
			<c:forEach var="item" items="${expCultureProgramList}" varStatus="status">
			<tr>
				<td>${item.productName}</td>
				<td>${fn:substring(item.reservationDate, 0, 4)}-${fn:substring(item.reservationDate, 4, 6)}-${fn:substring(item.reservationDate, 6, 8)} (${item.krWeekDay})</td>
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
						<c:forEach begin="1" end="2" step="1" var="cnt">
						<option value="${cnt}">${cnt}명</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			</c:forEach>
<!-- 			<tr>
				<td>가족이 대를 잇는 추억놀이</td>
				<td>2016-05-21 (토)</td>
				<td>14:00</td>
				<td><select title="참석인원 선택" class="tdSel">
						<option>1명</option>
						<option>2명</option>
					</select>
				</td>				
			</tr>
			<tr>
				<td>신나는 ABC 마술쇼~!!</td>
				<td>2016-05-22 (일)</td>
				<td>15:00<br />(대기신청)</td>
				<td><select title="참석인원 선택" class="tdSel">
						<option>1명</option>
						<option>2명</option>
					</select>
				</td>
			</tr> -->
			</tbody>
		</table>
		
		<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
		
		<c:if test="${expCultureProgramList[0].account ne ''}">
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="예약취소" />
			<input type="button" id="memberConfirm" onclick="javascript:memberInsert();" class="btnBasicBL" value="예약확정" />
		</div>
		</c:if>
		<c:if test="${expCultureProgramList[0].account eq ''}">
		<!--  비회원 일 경우 -->
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="예약취소" />
			<input type="button" id="nonmemberConfirm" onclick="javascript:noMemberInsert();" class="btnBasicBL" value="다음" />
		</div>
		</c:if>
	</section>
</div>
</form>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>