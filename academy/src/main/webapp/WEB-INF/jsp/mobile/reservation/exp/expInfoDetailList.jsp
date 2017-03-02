<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">

/* 뒤로가기 제어 */
history.pushState(null, null, location.href); 
window.onpopstate = function(event) { 
	history.go(1);
}

var tableCnt = 0;
$(document.body).ready(function (){
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	/* move function */
	var $pos = $("#pbContent");
	var iframeTop = parent.$("#IframeComponent").offset().top
	parent.$('html, body').animate({
	    scrollTop:$pos.offset().top + iframeTop
	}, 500);

	$("#goExpInfoList").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/mobile/reservation/expInfoList.do'/>"
	});
});

function changePartnertLayer(rsvseq, partnertypecode, randsaveyn, accounttype){
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	$("input[name = randsaveyn]").val(randsaveyn);
	$("input[name = accounttype]").val(accounttype);
	
	$("input:radio[name = partnerTypeCode]").each(function(){
		
		if($(this).val() == partnertypecode){
			$(this).attr("checked", "checked");
		}
		
	});
	
	
	layerPopupOpen("<a href='#uiLayerPop_alter' class='btnTbl'>변경</a>");return false;
}

function expInfoRsvCancelLayer(rsvseq, expsessionseq, formatreservationdate, expseq, typecode){
	
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	$("input[name = expsessionseq]").val("");
	$("input[name = expsessionseq]").val(expsessionseq);
	$("input[name = reservationdate]").val("");
	$("input[name = reservationdate]").val(formatreservationdate);
	
	$("input[name = expseq]").val("");
	$("input[name = expseq]").val(expseq);
	
	$("input[name = typecode]").val("");
	$("input[name = typecode]").val(typecode);
	
	$("input[name = parentInfo]").val("");
	$("input[name = parentInfo]").val("D");
	
	var temp = $("input[name = typecode]").val();
	
// 	console.log($("input[name = typecode]").val());
	if($("input[name = typecode]").val() == "N"){
		$("#cancelMsg").hide();
	}
	
	layerPopupOpen("<a href='#uiLayerPop_cancel' class='btnTbl'>예약취소</a>");return false;	
}

function visitNumberChangelayerPop(expSeq, rsvSeq, visitNumber, randsaveyn, accounttype){
	/* 해당 프로그램 참석 제한 인원 조회 ajax*/
	$("input[name = randsaveyn]").val(randsaveyn);
	$("input[name = accounttype]").val(accounttype);
	
	var param = {"searchExpSeq" : expSeq};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/expCultureSeatCountSelectAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			<%-- 요건 변경 : 남은 좌석 수 만큼 에서 2로 고정 --%>
			//var expCultureSeatCount = parseInt(data.expCultureSeatCount);
			var expCultureSeatCount = 2;
			
			var html = "";
			
			for(var i = 1 ; i <= 2 ; i++){
				if(i == parseInt(visitNumber)){
					if(i==1) html += "<option value=\""+i+"\" selected=\"selected\">없음</option>";
					if(i==2) html += "<option value=\""+i+"\" selected=\"selected\">있음</option>";
				}else{
					if(i==1) html += "<option value=\""+i+"\">없음</option>";
					if(i==2) html += "<option value=\""+i+"\">있음</option>";
				}
			}
			
			$("#visitNumber").empty();
			$("#visitNumber").append(html);
			
			$("input[name = rsvseq]").val(rsvSeq);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
	layerPopupOpen("<a href='#uiLayerPop_alterMemberNum' class='btnTbl'>예약취소</a>");return false;
}

/* 문화체험 참석인원 변경 완료 버튼  */
function visitNumberChangeConfirm() {
	var randsaveyn = $("input[name = randsaveyn]").val();
	
	if(randsaveyn=="N") {
		alert("정원인원이 초과 되어 변경 할 수 없습니다.");
		return;
	} else if(randsaveyn=="B" && $("#visitNumber").val()=="2") {
		alert("변경시 정원인원이 초과 되어 변경 할 수 없습니다.")
		return;
	}
	
	/* 참석인원 변경 ajax */
	var param = {"rsvSeq" : $("input[name = rsvseq]").val()
				, "visitNumber" : $("#visitNumber").val()};
	
	$.ajax({
		url: "<c:url value='/mobile/reservation/expCultureVisitNumberUpdateAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			alert("참석인원이 변경되었습니다.");
			
			$("#expInfoForm").submit();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}
/* 문화체험 참석인원 변경 팝업 닫기 */
function alterClosePop(){
	$("#uiLayerPop_alterMemberNum").hide();
	$("#layerMask").remove();
	
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
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
<body class="uiGnbM3">
<form id="expInfoForm" name="expInfoForm" method="post">
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="expsessionseq">
	<input type="hidden" name="reservationdate">
	<input type="hidden" name="purchasedate" value="${scrData.purchasedate}">
	<input type="hidden" name="ppseq" value="${scrData.ppseq}">
	<input type="hidden" name="typeseq" value="${scrData.typeseq}">
	<input type="hidden" name="expseq" value="${scrData.expseq}">
	<input type="hidden" name="typecode">
	<input type="hidden" name="parentInfo">
	<input type="hidden" name="randsaveyn" value="" />
	<input type="hidden" name="accounttype" value="" />

</form>
<section id="pbContent" class="bizroom">
	<div class="topBox">
		<dl>
			<dt>예약자</dt>
			<dd>${scrData.account}&nbsp;${scrData.accountname}</dd>
			<dt>등록일자</dt>
			<dd>${scrData.purchasedate}</dd>
		</dl>
	</div><!-- //.topBox -->
	
	<div class="titP mgtM">
		예약정보
	</div>
	<div class="topBox mgbS">
		<dl>
			<dt>체험종류</dt>
			<dd>${expInfoDetailList[0].typename}</dd>
			<dt>지역</dt>
			<dd>${expInfoDetailList[0].ppname}</dd>
		</dl>
	</div><!-- //.topBox -->
	
	<div class="stateWrap">
		<c:forEach var="item" items="${expInfoDetailList}">
			<dl class="tblBizroomState">
			
			<c:if test="${item.rsvcancel eq '-'  || item.gettoday eq item.formatreservationdate}">
				<dt>
					<input type="hidden" id="transactionTime" value="${item.transactiontime}">
					<span class="block">체험일자</span>${item.reservationdate}${item.rsvweek} ${item.session} 
				</dt>
			</c:if>
			<c:if test="${item.rsvcancel ne '-' && item.gettoday ne item.formatreservationdate}">
				<dt>
					<span class="block">체험일자</span>${item.reservationdate}${item.rsvweek} ${item.session} 
					<a href="#" class="btnTbl" onclick="expInfoRsvCancelLayer('${item.rsvseq}','${item.expsessionseq}','${item.formatreservationdate}','${item.expseq}','${item.typecode}');">예약취소</a>
				</dt>
			</c:if>
			<dd>
			<!-- 문화체험 -->
			<c:if test="${item.rsvinfoflag eq 'CN'}">
				<p>${item.typename}<em>|</em>동반자 <c:if test="${item.partnertypename eq 1}">없음</c:if> <c:if test="${item.partnertypename eq 2}">있음</c:if>
				<c:if test="${item.cancelcode eq 'B02'}">
					<a href="#" class="btnTbl" onclick="javascript:visitNumberChangelayerPop('${item.expseq}', '${item.rsvseq}', '${item.visitnumber}', '${item.randsaveyn}', '${item.accounttype}');">참석인원 변경</a>
				</c:if>
				</p>
			</c:if>
			
			<!-- 브랜드 그룹 -->
			<c:if test="${item.rsvinfoflag eq 'BG'}">
				<p>${item.typename}<em>|</em>${item.partnertypename}</p>
			</c:if>
			
			<c:if test="${item.rsvinfoflag eq 'BP' || item.rsvinfoflag eq 'NM'}">
				<p>${item.typename}<em>|</em>${item.partnertypename} 
				<c:if test="${item.cancelcode eq 'B02'}">
					<a href="#" class="btnTbl" onclick="javascript:changePartnertLayer('${item.rsvseq}', '${item.partnertypecode }', '${item.randsaveyn}', '${item.accounttype}');">동반자 변경</a>
				</c:if>
				</p>
			</c:if>
			
<%-- 			<p>${item.typename}<em>|</em>${item.partnertypename}  --%>
<%-- 				<c:if test="${item.partnertypename ne ''}"> --%>
<%-- 					<a href="#" class="btnTbl" onclick="javascript:changePartnertLayer('${item.rsvseq}', '${item.partnertypecode }');">변경</a> --%>
<%-- 				</c:if> --%>
<!-- 			</p> -->
			
			
			<p>상태 : ${item.paymentstatusname}</p>
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
		<a href="#none" class="btnBasicBL" id="goExpInfoList">체험예약 현황확인 목록</a>
	</div>
	<!-- //시설예약 현황확인 -->
	<div class="pbLayerPopup" id="uiLayerPop_alterMemberNum">
		<div class="pbLayerHeader">
			<strong>참석인원 변경</strong>
		</div>
		<div class="pbLayerContent">
			<div class="selectBox mgAuto">
				<label for="memberNum">동반자</label> 
					<input type="hidden" id="rsvSeq">
					<select id="visitNumber" title="참석인원 선택">
						<option value="1">없음</option>
						<option value="2">있음</option>
					</select>
			</div>
			
			<div class="btnWrap aNumb2">
				<span><a href="#" class="btnBasicGL" onclick="javascript:alterClosePop();">변경취소</a></span>
				<span><a href="#" class="btnBasicBL" onclick="javascript:visitNumberChangeConfirm();">변경완료</a></span>
			</div>
		</div>
		<a href="#none" class="btnPopClose" onclick="javascript:alterClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	
	<!-- layer popoup -->
	<!-- //layer popoup -->
	<!-- 예약취소&동반자 변경 팝업 모음 -->
	<%@ include file="/WEB-INF/jsp/mobile/reservation/exp/expInfoPop.jsp" %>
	
</section>

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
<!-- </body> -->
<!-- </html> -->
