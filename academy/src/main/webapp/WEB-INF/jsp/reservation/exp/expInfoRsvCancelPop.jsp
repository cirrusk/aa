<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	if($("input[name='typecode']").val() == "N"){
		$("#cancelMsg").hide();
	}
	
	$(".btnBasicBL").on("click", function(){
		var param = {
			  rsvseq : $("input[name = rsvseq]").val()
			, expsessionseq : $("input[name = expsessionseq]").val()
			, reservationdate : $("input[name = reservationdate]").val()
			, ppseq : $("input[name = ppseq]").val()
			, expseq : $("input[name = expseq]").val()
			, typecode : $("input[name = typecode]").val()
			, transactiontime : $("input[name = transactiontime]").val()
		};
		
		/* if(confirm("예약 취소를 하시겠습니까?") == true){ */
			$.ajaxCall({
				url: "<c:url value='/reservation/updateCancelCodeAjax.do' />"
				, type : "POST"
				, data: param
				, success: function(data, textStatus, jqXHR){
					
					try{
						
						if(data.errorMsg) {
							alert(data.errorMsg);
							return;
						}
					
						alert("예약이 취소되었습니다.");
						
						/*--------------------부모창 새로고침---------------------------------------*/
							
						if($("#parentInfo").val() != "CAL"){
							/* var frm = document.expInfoForm
							var title = "parent2";
							var url =  "<c:url value="/reservation/expInfoDetailList.do"/>";
							
							window.opener.name = title; //객체의 레퍼런스가 아닌 스트링을 사용한 이름을 지정해 주어야 함.
							frm.target = title; 
							
							frm.action = url;
							frm.method = "post";
							frm.submit();  */
							window.opener.document.location.href=window.opener.document.URL;
							window.opener.cancelUrlCall();
						}else{
							/* 캘린더 부모 함수 호출 */
							var popYear = $("#popYear").val();
							var popMonth = $("#popMonth").val();
							var popDay = $("#popDay").val();
							var dayFlag = $("#popFlag").val();
							
							window.opener.viewTypeCalendar(popYear, popMonth, popDay, dayFlag);
						}
						
						/*-----------------------------------------------------------------*/
						
						/*팝업창 닫기 */
						self.close();
						
					}catch(e){
						//console.log(e);
					}
					
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}
			});
/* 		}else{
			return false;
		} */
	});

});

function closePop(){
	try{
		self.close();
	}catch(e){
		//console.log(e);
	}
}
</script>
</head>
<body>
<form id="expInfoForm" name="expInfoForm" method="post">
	<input type="hidden" name="rsvseq" value="${scrData.rsvseq}">
	<input type="hidden" name="purchasedate" value="${scrData.purchasedate}">
	<input type="hidden" name="expsessionseq" value="${scrData.expsessionseq}">
	<input type="hidden" name="reservationdate" value="${scrData.reservationdate}">
	<input type="hidden" name="ppseq" value="${scrData.ppseq}">
	<input type="hidden" name="typecode" value="${scrData.typecode}">
	
	<input type="hidden" name="expseq" value="${scrData.expseq}">
	
	<input type="hidden" name="transactiontime" value="${scrData.transactiontime}">
	
	<!-- 캘린더 부모 함수 호출시 필요한 파라미터 -->
	<input type="hidden" name="parentInfo" id="parentInfo" value="${scrData.parentInfo}">
	<input type="hidden" name="popYear" id="popYear" value="${scrData.popYear}">
	<input type="hidden" name="popMonth" id="popMonth" value="${scrData.popMonth}">
	<input type="hidden" name="popDay" id="popDay" value="${scrData.popDay}">
	<input type="hidden" name="popFlag" id="popFlag" value="${scrData.popFlag}">
</form>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500121.gif" alt="예약취소" /></h1>
	</header>
	<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
	
		<em class="listDotFS">예약을 취소하시겠습니까?</em>
		
		<div class="lineBox msgBox" id="cancelMsg">
			<p class="textC">취소 시 패널티가 적용됩니다.</p>
		</div>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="취소" onclick="javascript:closePop();">
			<input type="button" class="btnBasicBL" value="확인" />
		</div>
		
		
		
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>