<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">

/* 뒤로가기 제어 */
history.pushState(null, null, location.href); 
window.onpopstate = function(event) { 
	history.go(1); 
}

$(document.body).ready(function(){
	
	$(".btnBasicBXL").on("click", function(){
		location.href = "<c:url value='/reservation/roomInfoList.do'/>";
// 		$("#roomInfoForm").attr("action", "/reservation/roomInfoList.do");
// 		$("#roomInfoForm").submit();
	});	
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
});

/* 예약 취소 팝업 */
function roomInfoRsvCancel(rsvseq, roomseq, standbynumber, typecode){
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	
	$("input[name = roomseq]").val("");
	$("input[name = roomseq]").val(roomseq);

	$("input[name = standbynumber]").val("");
	$("input[name = standbynumber]").val(standbynumber);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	var frm = document.roomInfoForm
	var url = "<c:url value='/reservation/roomInfoRsvCancelPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

/* 환불 내역 확인 팝업 */
function roomInfoRsvPaybackInfo(rsvseq){
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	
	var frm = document.roomInfoForm
	var url = "<c:url value='/reservation/roomInfoRsvPaybackInfoPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=800, directories=no, status=no, scrollbars=yes, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}

function showRoomRsvReceipt(){
	
	var tempTypeName = $("#tempTypeName").text().split(":");
	
	$("input[name='typeName']").val("");
	$("input[name='typeName']").val($.trim(tempTypeName[1]));
	
	$("input[name='cardName']").val("");
	$("input[name='cardName']").val($("#tempCardName").text());
	
	var frm = document.roomInfoForm
	var url = "<c:url value='/reservation/showRoomRsvReceiptPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=400, height=600, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
}


function tempSharing(url, sns){

	if (sns == 'facebook'){

		var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation=" + $("#transactionTime").val();    // Returns full URL
		var title = "abnKorea - 문화체험 예약";
		var content = $("#snsText").text();
		var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";

		sharing(currentUrl, title, sns, content);

	}else{

		var title = "abnKorea";
		var content = $("#snsText").text();

		sharing(url, title, sns, content);
	}

}
</script>
</head>
<body>
<form id="roomInfoForm" name="roomInfoForm" method="post">
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="roomseq" value="${scrData.roomseq}">
	<input type="hidden" name="standbynumber">
	<input type="hidden" name="purchasedate" value="${scrData.purchasedate}">
	<input type="hidden" name="virtualpurchasenumber" value="${scrData.virtualpurchasenumber}">
	<input type="hidden" name="typecode">
	<input type="hidden" name="typeName">
	<input type="hidden" name="cardName">
</form> 
	<!-- content area | ### academy IFRAME Start ### -->
	<section id="pbContent" class="bizroom">
		<div class="hWrap">
			<h1><img src="/_ui/desktop/images/academy/h1_w020500110.gif" alt="시설예약 현황확인"></h1>
			<p><img src="/_ui/desktop/images/academy/txt_w020500110.gif" alt="시설예약 현황정보를 확인할 수 있습니다."></p>
		</div>
		
		<div class="bizroomStateBox">
			<dl class="tblDetailCol4">
				<dt>예약자</dt>
				<dd>${roomInfoDetailList[0].account} ${roomInfoDetailList[0].name}</dd>
				<dt>등록일자</dt>
				<dd>${roomInfoDetailList[0].purchasedate}</dd>
				<c:set value="0" var="totalAmount"/>
				<c:forEach items="${roomInfoDetailList}" var="item" varStatus="status">
					<c:set value="${totalAmount + item.paymentamount}" var="totalAmount"/>
				</c:forEach>
				<c:if test="${totalAmount ne 0}">
					<dt>결제방법</dt>
					<dd>신용카드</dd>
					<dt>카드종류</dt>
					<dd id="tempCardName">${roomInfoDetailList[0].cardname}</dd>
					<dt>카드번호</dt>
					<dd>${fn:substring(cardNumber, 0,4)}-${fn:substring(cardNumber, 4,8)}-${fn:substring(cardNumber, 8,12)}-${fn:substring(cardNumber, 12,16)}</dd>
					<dt>결제금액</dt>
					<dd><fmt:formatNumber>${totalAmount}</fmt:formatNumber>원</dd>
				</c:if>

			</dl>
			<div class="tblBottomBtnR">
			<c:if test="${totalAmount ne 0}">
				<a href="#uiLayerPop_w01" class="btnCont" onclick="javascript:showRoomRsvReceipt();"><span>신용카드영수증</span></a>
			</c:if>
			</div>
			
			<h2 class="pdtL"><img src="/_ui/desktop/images/academy/h2_w020500120.gif" alt="예약정보"></h2>
			<div class="reservInfoHeader">
				<div class="title"><span id="tempTypeName">시설종류 : ${roomInfoDetailList[0].typename}</span><em>|</em><span>지역 : ${roomInfoDetailList[0].ppname}</span><em>|</em><span>Room명 : ${roomInfoDetailList[0].roomname}</span></div>
				<!-- @edit 20160627 전체예약취소 버튼 삭제 -->
			</div>
			<!-- @edit 20160627 테이블 태그 수정, 환불관련 추가, 환불영수증 버튼명 변경 20160701 환불영수증 버튼명 환불내역으로 재변경, 예약가능->대기신청 -->
			<table class="tblList lineLeft">
				<caption>예약정보 테이블</caption>
				<colgroup>
					<col style="width:15%" />
					<col style="width:25%" />
					<col style="width:28%" />
					<col style="width:20%" />
					<col style="width:auto" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">사용일</th>
						<th scope="col">사용시간</th>
						<th scope="col">결제금액</th>
						<th scope="col">상태</th>
						<th scope="col"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${roomInfoDetailList}" var="item" varStatus="status">
					<tr>
						<td>${fn:substring(item.reservationdate, 0, 4)}-${fn:substring(item.reservationdate, 4, 6)}-${fn:substring(item.reservationdate, 6, 8)}(${item.reservationweekday})</td>
						<td>${item.sessionname} (${fn:substring(item.startdatetime, 0, 2)}:${fn:substring(item.startdatetime, 2, 4)}~${fn:substring(item.enddatetime, 0, 2)}:${fn:substring(item.enddatetime, 2, 4)})</td>
						<td>
							<c:if test="${item.paymentstatuscode ne 'P03' && item.paymentamount eq 0}">
								무료
							</c:if>
							<c:if test="${item.paymentstatuscode ne 'P03' && item.paymentamount ne 0}">
								<fmt:formatNumber>${item.paymentamount}</fmt:formatNumber>원
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03' && item.paymentamount eq 0}">
								무료
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03'&& item.paymentamount ne 0}">
								<span class="throught"><fmt:formatNumber>${item.paymentamount}</fmt:formatNumber>원</span><br />
								환불금액:<fmt:formatNumber>${item.refundamount}</fmt:formatNumber>원<br/>${item.cancelpenalty}<!-- 결재 환불 도입 이후 생성 예정 -->
							</c:if>
						</td>
						<td>
							<c:if test="${item.paymentstatuscode ne 'P03'}">
								${item.paymentstatusname}
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03'}">
								${item.paymentstatusname}<br/>(${item.canceldatetime})
							</c:if>
						</td>
						<td>
							<c:if test="${item.paymentstatuscode eq 'P07' || item.paymentstatuscode eq 'P01' || item.paymentstatuscode eq 'P02'}">
								<c:if test="${item.gettoday eq item.reservationdate}">
									-
								</c:if>
								<c:if test="${item.gettoday ne item.reservationdate}">
									<a href="#none" class="btnTbl" onclick="javascript:roomInfoRsvCancel('${item.rsvseq}', '${item.roomseq}', '${item.standbynumber}', '${item.typecode}');"><span>예약취소</span></a>
								</c:if>
								
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P06'}">
								-
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P05'}">
								-
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03' && item.paymentamount ne 0}">
								<a href="#none" class="btnTbl" onclick="javascript:roomInfoRsvPaybackInfo('${item.rsvseq}');"><span>환불내역</span></a>
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03' && item.paymentamount eq 0}">
								-
							</c:if>
						</td>
					</tr>
					<span id="snsText">
						<p>
							■ ${item.ppname} (${item.typename}) ${item.reservationdate}${item.rsvweek}| ${item.session}|
							<c:choose>
								<c:when test="${item.rsvinfoflag eq 'CN'}">
									동반자 <c:if test="${item.partnertypename eq 1}">없음</c:if> <c:if test="${item.partnertypename eq 2}">있음</c:if>
								</c:when>
								<c:otherwise>
									${item.partnertypename}
								</c:otherwise>
							</c:choose>
						</p>
					</span>
					</c:forEach>
				</tbody>
			</table>
			<!-- @edit 20160627 환불 관련 추가 -->
			<ul class="listDot">
				<li>예약취소 시 실제 카드승인취소는 한국암웨이에서 카드사로 승인취소를요청한 날로부터 3~5일 후에 이루어집니다.</li>
				<li>카드 승인취소여부와 정확한 환불일자는 해당카드사에서 확인하실 수 있습니다.</li>
			</ul>
			<!-- //@edit 20160627 환불 관련 추가 -->
			<div class="brWrap">
				<div class="snsWrap">
					<!-- 20150313 : SNS영역 수정 -->
				<span class="snsLink">
					<!-- @eidt 20160627 URL 복사 삭제 -->
					<a href="#" id="snsKs" class="snsCs" onclick="javascript:tempSharing('${httpDomain}', 'kakaoStory');" title="새창열림"><span class="hide">카카오스토리</span></a>
					<a href="#" class="snsBand" onclick="javascript:tempSharing('${httpDomain}', 'band');" title="새창열림"><span class="hide">밴드</span></a>
					<a href="#" id="snsFb" class="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');" title="새창열림"><span class="hide">페이스북</span></a>
				</span>
					<!-- //20150313 : SNS영역 수정 -->
					<span class="snsText"><img src="/_ui/desktop/images/academy/sns_text.gif" alt="예약내역공유" /></span>
				</div>
				<div class="btnWrapC">
					<a href="javascript:void(0);" class="btnBasicBXL">시설예약 현황확인 목록</a>
				</div>
			</div>
		</div>
	</section>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
	
	<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>