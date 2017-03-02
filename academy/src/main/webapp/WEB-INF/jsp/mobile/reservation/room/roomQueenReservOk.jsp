<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>
<%
/* -------------------------------------------------------------------------- */
/* 캐쉬 사용안함                                                              */
/* -------------------------------------------------------------------------- */
response.setHeader("cache-control","no-cache");
response.setHeader("expires","-1");
response.setHeader("pragma","no-cache");

System.out.println(">>> /WEB-INF/jsp/mobile/reservation/room/roomQueenReservOk.jsp");
%>
<script type="text/javascript">

$(document).ready(function () {
	$(".result").show();
	setTimeout(function(){ abnkorea_resize(); }, 500);
});

function tempSharing(url, sns){
	
	if (sns == 'facebook'){
		
		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 퀸룸/파티룸 예약";
		var content = $("#snsText").val();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";
		
		sharing(currentUrl, title, sns, content);
		
	}else{
		
		var title = "abnKorea";
		var content = $("#snsText").val();
		
		sharing(url, title, sns, content);
	}
	
}


function accessParentPageQueen(){
	var newUrl = "/reservation/roomQueenForm";
	top.window.location.href="${hybrisDomain}"+newUrl;
}

function accessParentPage(){
	var newUrl = "/reservation/expInfoList";
	top.window.location.href="${hybrisDomain}"+newUrl;
}

</script>
<div id="pbContainer">
<section id="pbContent" class="bizroom">
	<form id="roomEduForm" name="roomEduForm" method="post">
	</form>
	<input type="hidden" id="transactionTime" />
	<input type="hidden" id="snsText" name="snsText">
	<section class="brIntro">
		<h2><a href="#uiToggle_01">퀸룸/파티룸 예약 필수 안내</a></h2>
		<div id="uiToggle_01" class="toggleDetail">
			<c:out value="${reservationInfo}" escapeXml="false" />
		</div>
	</section>

	<section class="mWrap">
		<!-- 스텝1 -->
		<div class="bizEduPlace">
			<div class="result" >
				<div class="tWrap">
					<em class="bizIcon step01"></em><strong class="step">STEP1/ 지역, 룸</strong>
						<span>${ppName}<em class="bar">|</em>${roomName}</span>
					<%-- 
						<span>강서 AP<em class="bar">|</em>컨퍼런스 룸 2 (8명)</span> 
					--%>
				</div>
			</div>
		</div>
		<!-- 스텝2 -->
		<div class="bizEduPlace">
			<div class="result" >
				<div class="tWrap">
					<em class="bizIcon step02"></em><strong class="step">STEP2/ 날짜, 세션</strong>
					<span>총${reservationCount}건<em class="bar">|</em>결제예정금액 : ${totalAmount}원</span>
					<div class="resultDetail">
						<c:forEach var="item" items="${reservedInfo}" varStatus="status">
							<span>
							${item.reservationDate}&nbsp;${item.reservationWeek}<em class="bar">|</em>
							${item.sessionName} (${item.startTime}~${item.endTime})<em class="bar">|</em>
							${item.paymentAmount}원
							</span>
						</c:forEach>
					</div>
					<%--
					<span>총2건<em class="bar">|</em>결제예정금액 : 300,000원</span>
					<div class="resultDetail">
						<span>2016-05-25 (수)<em class="bar">|</em>Session 2 (12:00~14:00)</span>
						<span>2016-05-27 (금)<em class="bar">|</em>Session 2 (12:00~14:00) (대기신청)</span>
					</div>
					--%>
				</div>
			</div>
		</div>
		<!-- 스텝3 -->
		<div class="bizEduPlace">
			<div class="result" >
				<div class="tWrap">
					<em class="bizIcon step03"></em><strong class="step">STEP3/ 동의</strong>
					<span>신용카드<em class="bar">|</em>${totalAmount}원</span>
				</div>
			</div>
		</div>
		<!-- //스텝3 -->
		
		<!-- 예약완료 -->
		<div class="stepDone selcWrap" id="stepDone">
			<div class="doneText"><strong class="point1">예약</strong><strong class="point3">이 완료 되었습니다.</strong><br>
			이용해 주셔서 감사합니다.</div>
			
			<div class="detailSns">
				<a href="#none" id="snsKt" onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"  title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
				<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
				<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');"       title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
				<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');"   title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
			</div>
			<span class="doneText">예약내역공유</span>

			<div class="btnWrap aNumb2">
				<a href="#" onclick="javascript:accessParentPageQueen();" class="btnBasicGL">예약계속하기</a>
				<a href="#" onclick="javascript:accessParentPage();" class="btnBasicBL" >예약현황확인</a>
			</div>
		</div>
		<!-- //예약완료 -->
	</section>

</section>
</div>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>