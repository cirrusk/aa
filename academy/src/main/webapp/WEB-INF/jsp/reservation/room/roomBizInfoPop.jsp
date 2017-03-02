<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
// 	$(".btnBasicBL").on("click", function(){
		
		
// 	});
	
	$(".btnBasicGL").on("click", function(){
		try{
// 			window.opener.location.reload();
			self.close();
		}catch(e){
// 			console.log(e);
		}
	});
	
});
	
function closeSelf(){
	self.close();
}

function roomBizInsert(){
	
	$(".btnBasicBL").removeAttr("onclick");
	
	var param = $("#roomEduForm").serialize();
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/roomEduReservationInsertAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			if("false" == data.possibility){
				alert(data.reason);
// 				self.close();
				return false;
			}else{
				var totalCnt = data.totalCnt;
				
				if (totalCnt){
					/* 부모창으로  예약한 데이터 전달 */
					try{
						window.opener.$("#transactionTime").val(data.transactionTime);
						window.opener.roomBizRsvDetail();
						self.close();
					}catch(e){
//							console.log(e);
					}
				} else {
					alert("처리도중 오류가 발생하였습니다.");
				}
			}
			
			/*팝업창 닫기 */
			window.opener.roomBizRsvDetail();
			self.close();
			
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
		<h1><img src="/_ui/desktop/images/academy/h1_w020500080.gif" alt="예약정보 확인" /></h1>
	</header>
	<a href="javascript:void(0);" onclick="javascript:closeSelf();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<form id="roomEduForm" name="roomEduForm" method="post">
	<section id="pbPopContent">
			
<!-- 		<span class="resvItem">강서 AP<em>|</em>컨퍼런스 룸2 (8명)</span> -->
		<span class="resvItem">${roomBizInfoList[0].ppName}<em>|</em>${roomBizInfoList[0].roomName}</span>
		<table class="confirmTbl">
			<caption>예약정보 확인</caption>
			<colgroup>
				<col style="width:30%" />
				<col style="width:45%" />
				<col style="width:25%" />
			</colgroup>
			
			<thead>
			<tr>
				<th scope="col">날짜</th>
				<th scope="col">세션(사용시간)</th>
				<th scope="col">금액</th>
			</tr>
			</thead>
			<tbody>
				<c:set var="totalCnt" value="0"/>
				<c:forEach var="item" items="${roomBizInfoList}" varStatus="status">
					<tr>
						<td>${item.sessionYmd}
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
						<td>무료</td>
					</tr>
					<c:set var="totalCnt" value="${totalCnt + 1}"/>
				</c:forEach>
<!-- 			<tr>
				<td>2016-05-25(수)</td>
				<td>Session 2 (12:00~14:00)</td>
				<td>무료</td>				
			</tr>
			<tr>
				<td>2016-05-27(금)</td>
				@edit 20160701 예약대기를 대기신청으로 문구 변경
				<td>Session 2 (12:00~14:00)<br />(대기신청)</td>
				<td>무료</td>				
			</tr> -->
			</tbody>
			<tfoot>
			<tr>
				<td colspan="3" class="total textR"><strong>총 ${totalCnt}건</strong><em>|</em><strong>무료</strong></td>
			</tr>
			</tfoot>
		</table>
		
		<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="예약취소" />
			<input type="button" class="btnBasicBL" onclick="javascript:roomBizInsert();" value="예약확정" />
		</div>
	
	</section>
	</form>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>