<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

// $(document.body).ready(function(){
// 	$(".btnBasicBL").on("click", function(){
		
		
// 		var param = {
// 			  rsvseq : $("input[name = rsvseq]").val()
// 			, expsessionseq : $("input[name = expsessionseq]").val()
// 			, reservationdate : $("input[name = reservationdate]").val()
// 			, ppseq : $("input[name = ppseq]").val()
// 		};
		
// 		if(confirm("예약 취소를 하시겠습니까?") == true){
// 			$.ajax({
// 				url: "<c:url value="/reservation/updateCancelCodeAjax.do"/>"
// 				, type : "POST"
// 				, data: param
// 				, success: function(data, textStatus, jqXHR){
					
// 					try{
// 						alert("예약이 취소되었습니다.");
						
// 						/*--------------------부모창 새로고침---------------------------------------*/
							
// 						if($("#parentInfo").val() != "CAL"){
// 							var frm = document.expInfoForm
// 							var title = "parent2";
// 							var url =  "<c:url value="/reservation/expInfoDetailList.do"/>";
							
// 							window.opener.name = title; //객체의 레퍼런스가 아닌 스트링을 사용한 이름을 지정해 주어야 함.
// 							frm.target = title; 
							
// 							frm.action = url;
// 							frm.method = "post";
// 							frm.submit(); 
// 						}else{
// 							/* 캘린더 부모 함수 호출 */
// 							var popYear = $("#popYear").val();
// 							var popMonth = $("#popMonth").val();
// 							var popDay = $("#popDay").val();
							
// 							window.opener.viewTypeCalendar(popYear, popMonth, popDay);
// 						}
						
// 						/*-----------------------------------------------------------------*/
						
// 						/*팝업창 닫기 */
// 						self.close();
						
// 					}catch(e){
// 						console.log(e);
// 					}
					
// 				},
// 				error: function( jqXHR, textStatus, errorThrown) {
//					var mag = '<spring:message code="errors.load"/>';
//					alert(mag);
// 				}
// 			});
// 		}else{
// 			return false;
// 		}
// 	});

// });

</script>
</head>
<body>
<!-- <form id="expInfoForm" name="expInfoForm" method="post"> -->
<%-- 	<input type="text" name="rsvseq" value="${scrData.rsvseq}"> --%>
<%-- 	<input type="text" name="purchasedate" value="${scrData.purchasedate}"> --%>
<%-- 	<input type="text" name="expsessionseq" value="${scrData.expsessionseq}"> --%>
<%-- 	<input type="text" name="reservationdate" value="${scrData.reservationdate}"> --%>
<%-- 	<input type="text" name="ppseq" value="${scrData.ppseq}"> --%>
	
<!-- 	<!-- 캘린더 부모 함수 호출시 필요한 파라미터 --> -->
<%-- 	<input type="hidden" name="parentInfo" id="parentInfo" value="${scrData.parentInfo}"> --%>
<%-- 	<input type="hidden" name="popYear" id="popYear" value="${scrData.popYear}"> --%>
<%-- 	<input type="hidden" name="popMonth" id="popMonth" value="${scrData.popMonth}"> --%>
<%-- 	<input type="hidden" name="popDay" id="popDay" value="${scrData.popDay}"> --%>
<!-- </form> -->
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500020.gif" alt="예약실패 알림" /></h1>
	</header>
	<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
	<section id="pbPopContent">
	
		<em class="listDotFS">예약에 실패하였습니다.</em>
		
		<div class="lineBox msgBox">
		<p class="textC">원인: <span class="colorSpMB">카드번호 오류</span></p>
		</div>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicBS" value="확인" />
		</div>
		
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>