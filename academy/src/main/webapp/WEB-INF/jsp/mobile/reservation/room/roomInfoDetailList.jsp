<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

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
		location.href = "<c:url value='/mobile/reservation/roomInfoList.do'/>";
// 		$("#roomInfoForm").attr("action", "/reservation/roomInfoList.do");
// 		$("#roomInfoForm").submit();
	});	
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	/* move function */
	var $pos = $("#pbContent");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 500);
	
});

/* 예약 취소 데이터 정리 */
function roomInfoRsvCancelData(rsvseq, roomseq, standbynumber, typecode, paymentamount, reservationdate, purchasedate, virtualpurchasenumber){
	
	/* 해당 결제 적용 패널티 조회 */
	
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	
	$("input[name = roomseq]").val("");
	$("input[name = roomseq]").val(roomseq);

	$("input[name = standbynumber]").val("");
	$("input[name = standbynumber]").val(standbynumber);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	var param = {
			  "rsvseq" : rsvseq
			, "roomseq" : roomseq
			, "standbynumber" : standbynumber
			, "typecode" : typecode
	}
	
	/* 해당 패널티 정보 조회 */
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/roomInfoRsvCancelAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
// 			console.log(data);
			var tempTypeCode = data.roomInfoRsvCancelPenalty.applytypevalue != null ? data.roomInfoRsvCancelPenalty.typecode : 'N';
			$("input[name = typecode]").val(tempTypeCode);
			$("input[name = paymentamount]").val(paymentamount);
			$("input[name = reservationdate]").val(reservationdate);
			$("input[name = purchasedate]").val(purchasedate);
			$("input[name = virtualpurchasenumber]").val(virtualpurchasenumber);

			var applytypevalue = data.roomInfoRsvCancelPenalty.applytypevalue;
			if(!isNull(applytypevalue)) {
				if(typecode == "P"){
					$("#typecodeP").show();
					$("#typecodeF").hide();
					$("#typecodeC").hide();
					$("#penaltyvalue").text(applytypevalue);
				} else if(typecode == "F"){
					$("#typecodeP").hide();
					$("#typecodeF").show();
					$("#typecodeC").hide();
				} else if(typecode == "C"){
					$("#typecodeP").hide();
					$("#typecodeF").hide();
					$("#typecodeC").show();
				} else {
					$("#typecodeP").hide();
					$("#typecodeF").hide();
					$("#typecodeC").hide();
				}
			} else {
				$("#typecodeP").hide();
				$("#typecodeF").hide();
				$("#typecodeC").hide();
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 예약 취소 */
function roomInfoRsvCancel(){
	var param = {
			  "rsvseq" : $("input[name=rsvseq]").val()
			, "roomseq" : $("input[name=roomseq]").val()
			, "standbynumber" : $("input[name=standbynumber]").val()
			, "typecode" : $("input[name=typecode]").val()
			, "paymentamount" : $("input[name=paymentamount]").val()
			, "reservationdate" : $("input[name=reservationdate]").val()
			, "purchasedate" : $("input[name=purchasedate]").val()
			, "virtualpurchasenumber" : $("input[name=virtualpurchasenumber]").val()
			, "interfaceChannel" : $("input[name=interfaceChannel]").val()
	}
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/updateRoomCancelCodeAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			cancelClosePop();
			
			$("input[name = purchasedate]").val($("input[name = purchasedate]").val().substring(0,4)+$("input[name = purchasedate]").val().substring(5,7)+$("input[name = purchasedate]").val().substring(8,10));
			
			$("#roomInfoForm").attr("action", "${pageContext.request.contextPath}/mobile/reservation/roomInfoDetailList.do");
			$("#roomInfoForm").submit();
			
			alert("예약이 취소되었습니다.");
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}

/* 환불 내역 확인 팝업 */
function roomInfoRsvPaybackInfo(rsvseq){
	
	var param = {"rsvseq" : rsvseq};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/roomInfoRsvPaybackInfoAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var paybackInfo = data.roomInfoRsvPaybackInfo;
			
			$("#account").empty();
			$("#paymentdate").empty();
			$("#reservationdate").empty();
			$("#typename").empty();
			$("#ppname").empty();
			$("#session").empty();
			$("#canceldatetime").empty();
			$("#applytypevalue").empty();
			$("#paymentamount").empty();
			$("#refundcharge").empty();
			$("#refundamount").empty();
			$("#virtualpurchasenumber").empty();
			
			$("#account").append(paybackInfo.account);
			$("#paymentdate").append(paybackInfo.paymentdate);
			$("#reservationdate").append(paybackInfo.reservationdate);
			$("#typename").append(paybackInfo.typename);
			$("#ppname").append(paybackInfo.ppname + " / " + paybackInfo.roomname);
			$("#session").append(paybackInfo.sessionname 
					+ " (" + paybackInfo.startdatetime.substring(0, 2) 
					+ ":" + paybackInfo.startdatetime.substring(2, 4) 
					+ "~" + paybackInfo.enddatetime.substring(0, 2) 
					+ ":" + paybackInfo.enddatetime.substring(2, 4) + ")");
			$("#canceldatetime").append(paybackInfo.canceldatetime);
			$("#applytypevalue").append("결제금액 기준 "+paybackInfo.applytypevalue+"% 취소 수수료 제외 후 환불");
			$("#paymentamount").append(setComma(paybackInfo.paymentamount)+"원");
			$("#refundcharge").append(setComma(paybackInfo.refundcharge)+"원");
			$("#refundamount").append(setComma(paybackInfo.refundamount)+"원");
			$("#virtualpurchasenumber").append(paybackInfo.virtualpurchasenumber+" 신용");
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 레이어 팝업 닫기 */
function cancelClosePop(){
	$("#uiLayerPop_cancel").hide();
// 	 $("#step2Btn").parents("dd").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

/* 레이어 팝업 닫기 */
function cancelViewClosePop(){
	$("#uiLayerPop_cancelView").hide();
// 	 $("#step2Btn").parents("dd").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".selectDiv").show();
// 	 $("#step2Btn").parents(".bizEduPlace").find(".result").hide();
	$("#layerMask").remove();
	 
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

function showReceipt(){
	
// 	var tempTypeName = $("#typename").text()
	
	$("input[name='tempTypeName']").val("");
	$("input[name='tempTypeName']").val($("#typename").text());
	
	$("input[name='cardName']").val("");
	$("input[name='cardName']").val($("#tempCardName").text());
	
	var frm = document.roomInfoForm
	var url = "<c:url value='/mobile/reservation/showRoomRsvReceiptPop.do'/>";
	var title = "testpop";
	var status = "toolbar=no, width=300, height=600, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();
	
// 	layerPopupOpen(obj);
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
<form id="roomInfoForm" name="roomInfoForm" method="post">
	<input type="hidden" name="interfaceChannel" value="WEB" >
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="roomseq" value="${scrData.roomseq}">
	<input type="hidden" name="standbynumber">
	<input type="hidden" name="purchasedate" value="${scrData.purchasedate}">
	<input type="hidden" name="reservationdate">
	<input type="hidden" name="virtualpurchasenumber" value="${scrData.virtualpurchasenumber}">
	<input type="hidden" name="typecode">
	<input type="hidden" name="tempTypeName">
	<input type="hidden" name="cardName">
	<input type="hidden" name="paymentamount">
</form>

	<!-- container -->
	<div id="pbContainer">
		<!-- content -->
		<section id="pbContent" class="bizroom">
					
			<div class="topBox">
				<dl>
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
					<dd>${fn:substring(getReceiptInfo.cardNumber, 0,4)}-${fn:substring(getReceiptInfo.cardNumber, 4,8)}-${fn:substring(getReceiptInfo.cardNumber, 8,12)}-${fn:substring(getReceiptInfo.cardNumber, 12,16)}</dd>
					<dt>결제금액</dt>
					<dd><fmt:formatNumber>${totalAmount}</fmt:formatNumber>원</dd>
				</c:if>
				</dl>
			</div><!-- //.topBox -->
			<div class="btnWrap textR mgtS">
			<c:if test="${totalAmount ne 0}">
				<a href="#uiLayerPop_receipt1" class="btnTbl" onclick="showReceipt();return false;">신용카드영수증</a>
			</c:if>
			</div>
			
			<div class="titP mgtM">예약정보</div>
			
			<div class="topBox mgbS">
				<dl>
					<dt>시설종류</dt>
					<dd>${roomInfoDetailList[0].typename}</dd>
					<dt>지역</dt>
					<dd>${roomInfoDetailList[0].ppname}</dd>
					<dt>Room명</dt>
					<dd>${roomInfoDetailList[0].roomname}</dd>
				</dl>
			</div><!-- //.topBox -->
			
			
			
			<div class="stateWrap">
			<c:forEach items="${roomInfoDetailList}" var="item" varStatus="status">
				<dl class="tblBizroomState">
					<dt>
						<span class="block">사용일자</span> 
						${fn:substring(item.reservationdate, 0, 4)}
						-${fn:substring(item.reservationdate, 4, 6)}
						-${fn:substring(item.reservationdate, 6, 8)}
						(${item.reservationweekday}) ${item.sessionname} 
						(${fn:substring(item.startdatetime, 0, 2)}:${fn:substring(item.startdatetime, 2, 4)}
						~${fn:substring(item.enddatetime, 0, 2)}
						:${fn:substring(item.enddatetime, 2, 4)}) 
							<c:if test="${item.paymentstatuscode eq 'P07' || item.paymentstatuscode eq 'P01' || item.paymentstatuscode eq 'P02'}">
								<c:if test="${item.gettoday eq item.reservationdate}">
									-
								</c:if>
								<c:if test="${item.gettoday ne item.reservationdate}">
									<a href="#uiLayerPop_cancel" class="btnTbl" onclick="layerPopupOpen(this);
										roomInfoRsvCancelData('${item.rsvseq}'
															, '${item.roomseq}'
															, '${item.standbynumber}'
															, '${item.typecode}'
															, '${item.paymentamount}'
															, '${fn:substring(item.reservationdate, 0, 4)}-${fn:substring(item.reservationdate, 4, 6)}-${fn:substring(item.reservationdate, 6, 8)}'
															, '${item.purchasedate}'
															, '${item.virtualpurchasenumber}');return false;">예약취소</a>
								</c:if>
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03' && item.paymentamount ne 0}">
								<a href="#uiLayerPop_cancelView" class="btnTbl" onclick="layerPopupOpen(this);roomInfoRsvPaybackInfo('${item.rsvseq}');return false;">환불내역</a>
							</c:if>
					</dt>
					<dd>
							<c:if test="${item.paymentstatuscode ne 'P03' && item.paymentamount eq 0}">
								<p>무료</p>
							</c:if>
							<c:if test="${item.paymentstatuscode ne 'P03' && item.paymentamount ne 0}">
								<p>결제금액 : <fmt:formatNumber>${item.paymentamount}</fmt:formatNumber>원</p>
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03' && item.paymentamount eq 0}">
								<p>무료</p>
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03'&& item.paymentamount ne 0}">
								<p class="payCancel">결제금액 : <fmt:formatNumber>${item.paymentamount}</fmt:formatNumber>원</p>
								<p>환불금액 <fmt:formatNumber>${item.refundamount}</fmt:formatNumber>원 ${item.cancelpenalty}</p><!-- 결재 환불 도입 이후 생성 예정 -->
							</c:if>
							<c:if test="${item.paymentstatuscode ne 'P03'}">
								<p>상태 : ${item.paymentstatusname}</p>
							</c:if>
							<c:if test="${item.paymentstatuscode eq 'P03'}">
								<p>상태 : ${item.paymentstatusname} (${item.canceldatetime})</p>
							</c:if>
					</dd>
				</dl>
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
			</div>
			
			<!-- @edit 160627 문구추가 -->
			<ul class="listDot brdTop">
				<li>예약취소 시 실제 카드승인취소는 한국암웨이에서 카드사로 승인취소를요청한 날로부터 3~5일 후에 이루어집니다.</li>
				<li>카드 승인취소여부와 정확한 환불일자는 해당카드사에서 확인하실 수 있습니다.</li>
			</ul>

			<div class="stepDone selcWrap">

				<div class="detailSns">
					<a href="#none" id="snsKt" onclick="javascript:tempSharing('${httpDomain}', 'kakaotalk');"  title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_ct.gif" alt="카카오톡"></a>
					<a href="#none" id="snsKs" onclick="javascript:tempSharing('${httpDomain}', 'kakaostory');" title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_cs.gif" alt="카카오스토리"></a>
					<a href="#none" id="snsBd" onclick="javascript:tempSharing('${httpDomain}', 'band');"       title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_bd.gif" alt="밴드"></a>
					<a href="#none" id="snsFb" onclick="javascript:tempSharing('${httpDomain}', 'facebook');"   title="새창열림"><img src="/_ui/mobile/images/common/btn_sns_fb.gif" alt="페이스북"></a>
				</div>
				<span class="doneText">예약내역공유</span>

			</div>
			
			<div class="btnWrap aNumb1">
				<a href="/mobile/reservation/roomInfoList.do" class="btnBasicBL">시설예약 현황확인 목록</a>
			</div>
			
			<!-- //시설예약 현황확인
				m02_050_layer 참조
			<!-- layer popoup -->
			<!-- 예약취소 알림 -->
			<div class="pbLayerPopup" id="uiLayerPop_cancel">
				<div class="pbLayerHeader">
					<strong>예약취소</strong>
				</div>
				<div class="pbLayerContent">
					<!-- 20160714 페널티 수정 -->
					<div class="cancelWrap">
						<p>예약을 취소하시겠습니까?</p>
						<div class="lineBox msgBox" id="typecodeP" style="display:none">
							<p class="textC">취소 시 결제 금액의 <span id="penaltyvalue"></span>%의 취소 수수료 제외후 환불 처리됩니다.</p>
						</div>
						<!-- 무료예약인 경우 -->
						<div class="lineBox msgBox" id="typecodeF" style="display:none">
							<p class="textC">취소 시 패널티가 적용됩니다.</p>
						</div>
						<!-- 요리명장 무료예약인 경우 -->
						<div class="lineBox msgBox" id="typecodeC" style="display:none">
							<p class="textC">취소 시 패널티가 적용됩니다.</p>
						</div>
					</div>
					
					<div class="btnWrap aNumb2">
						<span><a href="#none" class="btnBasicGL" onclick="javascript:cancelClosePop();">취소</a></span>
						<span><a href="#none" class="btnBasicBL" onclick="javascript:roomInfoRsvCancel();">확인</a></span>
					</div>
				</div>
				
				<a href="#none" class="btnPopClose" onclick="javascript:cancelClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			
			<!-- 환불내역 확인 -->
			<div class="pbLayerPopup" id="uiLayerPop_cancelView">
				<div class="pbLayerHeader">
					<strong>환불내역 확인</strong>
				</div>
				<div class="pbLayerContent">
					<h2>시설 예약</h2>
					<table class="tblCredit">
						<colgroup><col width="110px" /><col width="auto" /></colgroup>
						<tbody>
							<tr>
								<th scope="row" class="bdTop">예약자</th>
								<td id="account" class="bdTop">7480003 홍길동</td>
							</tr>
							<tr>
								<th scope="row">예약완료일자</th>
								<td id="paymentdate">2016-04-20</td>
							</tr>
							<tr>
								<th scope="row">사용예정일자</th>
								<td id="reservationdate">2016-05-31</td>
							</tr>
							<tr>
								<th scope="row">시설종류</th>
								<td id="typename">교육장</td>
							</tr>
							<tr>
								<th scope="row">지역 / 시설명</th>
								<td id="ppname">강서AP / 비전센타1</td>
							</tr>
							<tr>
								<th scope="row">사용예정시간</th>
								<td id="session">Session1 (14:00~17:00)</td>
							</tr>
						</tbody>
					</table>
					
					<h2 class="mgtL">결제 및 취소</h2>
					<table class="tblCredit">
						<colgroup><col width="110px" /><col width="auto" /></colgroup>
						<tbody>
							<tr>
								<th scope="row" class="bdTop">취소일자</th>
								<td id="canceldatetime" class="bdTop">2016-4-20 11:12:10</td>
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
								<td id="virtualpurchasenumber">123456 신용</td>
							</tr>
							<tr>
								<th scope="row">환불방법</th>
								<td id="applytypevalue">결제금액 기준 10% 취소 수수료 제외 후 환불</td>
							</tr>
							<tr>
								<th scope="row">결제금액</th>
								<td id="paymentamount" >150,000원</td>
							</tr>
							<tr>
								<th scope="row">취소수수료</th>
								<td id="refundcharge">15,000원</td>
							</tr>
							<tr>
								<th scope="row">환불금액</th>
								<td id="refundamount">135,000원</td>
							</tr>
						</tbody>
					</table>
					<div class="btnWrap bNumb1">
						<a href="#" class="btnBasicGL" onclick="javascript:cancelViewClosePop();">닫기</a>
					</div>
				</div>
				<a href="#none" class="btnPopClose" onclick="javascript:cancelViewClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
			</div>
			<!-- //환불내역 확인 -->
			
			<!-- //layer popoup -->
	
			
		</section>
		<!-- //content -->
	</div>
	<!-- container -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/mobile/footer.jsp" %>