<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
	$(".btnBasicBL").on("click", function(){
		
		
		var param = {
			  rsvseq : $("input[name = rsvseq]").val()
			, roomseq : $("input[name = roomseq]").val()
			, standbynumber : $("input[name = standbynumber]").val()
			, typecode : $("input[name = typecode]").val()
		};
			$.ajaxCall({
				url: "<c:url value='/reservation/updateRoomCancelCodeAjax.do'/>"
				, type : "POST"
				, data: $("#roomInfoForm").serialize()
				, success: function(data, textStatus, jqXHR){
					
					try{
						
						if(data.errorMsg) {
							alert(data.errorMsg);
							return;
						}
					
						/*--------------------부모창 새로고침---------------------------------------*/
							
						if($("#parentInfo").val() != "CAL"){
	
							$("input[name=purchasedate]").val($("input[name=purchasedate]").val().replace(/-/g,""));
							
							var frm = document.roomInfoForm
							var title = "parent2";
							var url =  "<c:url value="/reservation/roomInfoDetailList.do"/>";
							
							window.opener.name = title; //객체의 레퍼런스가 아닌 스트링을 사용한 이름을 지정해 주어야 함.
							frm.target = title; 
							
							frm.action = url;
							frm.method = "post";
							frm.submit(); 
						}else{
							/* 캘린더 부모 함수 호출 */
							var popYear = $("#popYear").val();
							var popMonth = $("#popMonth").val();
							var popDay = $("#popDay").val();
							
							window.opener.viewTypeCalendar(popYear, popMonth, popDay);
						}
						
						/*-----------------------------------------------------------------*/
						
						alert("예약이 취소되었습니다.");
						
						/*팝업창 닫기 */
						self.close();
						
					}catch(e){
	// 					console.log(e);
					}
					
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}
			});
	});

	$(".btnBasicGL").on("click", function(){
		/*팝업창 닫기 */
		self.close();
	});
});

</script>
</head>
<body>
<form id="roomInfoForm" name="roomInfoForm" method="post" >

	<input type="hidden" name="interfaceChannel" value="WEB" >
	<input type="hidden" name="rsvseq" value="${scrData.rsvseq}" >
	<input type="hidden" name="roomseq" value="${scrData.roomseq}" >
	<input type="hidden" name="standbynumber" value="${scrData.standbynumber}" >
	<input type="hidden" name="reservationdate" value="${reservationInfo.reservationdate}" >
	<input type="hidden" name="purchasedate" value="${reservationInfo.purchasedate}" >
	<input type="hidden" name="virtualpurchasenumber" value="${reservationInfo.virtualpurchasenumber}" >
	<input type="hidden" name="paymentamount" value="${reservationInfo.paymentamount}" >
	
	<c:if test="${null ne roomInfoRsvCancelPenalty.applytypevalue}" >
	<input type="hidden" name="typecode" value="${scrData.typecode}" >
	</c:if>
	<c:if test="${null eq roomInfoRsvCancelPenalty.applytypevalue}" >
	<input type="hidden" name="typecode" value="N" >
	</c:if>
	
	<!-- 캘린더 부모 함수 호출시 필요한 파라미터 -->
	<input type="hidden" name="parentInfo" id="parentInfo" value="${scrData.parentInfo}" >
	<input type="hidden" name="popYear" id="popYear" value="${scrData.popYear}" >
	<input type="hidden" name="popMonth" id="popMonth" value="${scrData.popMonth}" >
	<input type="hidden" name="popDay" id="popDay" value="${scrData.popDay}" >
</form>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500121.gif" alt="예약취소" /></h1>
	</header>
	<a href="#" onclick="javascrip:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
	
		<em class="listDotFS">예약을 취소하시겠습니까?</em>
		
		<!-- @edit 20160701 문구변경 -->
		<c:if test="${'P' eq scrData.typecode && null ne roomInfoRsvCancelPenalty.applytypevalue}">
			<!-- 유료예약인 경우 -->
			<div class="lineBox msgBox">
			<p class="textC">취소 시 결제 금액의 ${roomInfoRsvCancelPenalty.applytypevalue}%의 취소 수수료 제외후 환불 처리됩니다.</p>
			</div>
		</c:if>
		<c:if test="${'F' eq scrData.typecode && null ne roomInfoRsvCancelPenalty.applytypevalue}">
			<!-- 무료예약인 경우 -->
			<div class="lineBox msgBox">
			<p class="textC">취소 시 패널티가 적용됩니다.</p>
			</div>
		</c:if>
		<c:if test="${'C' eq scrData.typecode && null ne roomInfoRsvCancelPenalty.applytypevalue}">
			<!-- 요리명장 무료예약인 경우 -->
			<div class="lineBox msgBox">
			<p class="textC">취소 시 패널티가 적용됩니다.</p>
			</div>
		</c:if>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="취소">
			<input type="button" class="btnBasicBL" value="확인" />
		</div>
		
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>