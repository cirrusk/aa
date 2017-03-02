<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

/* 뒤로가기 제어 */
history.pushState(null, null, location.href); 
window.onpopstate = function(event) { 
	history.go(1);
}

$(document.body).ready(function(){
	$(".btnBasicBXL").on("click", function(){
		location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expInfoList.do'/>";
	});	
	
	$(".btnBasicGL").on("click", function(){
		
		$(".pbLayerWrap").hide();
		$("#layerMask").remove();
	});
	
	$("#brandChange").on("click", function(){
		var randsaveyn = $("input[name = randsaveyn]").val();
		
		var param = {
			  rsvseq          : $("input[name = rsvseq]").val()
			, purchasedate    : $("input[name = purchasedate]").val()
			, ppseq           : $("input[name = ppseq]").val()
			, partnerTypeCode : $("input:radio[name = partnerTypeCode]:checked").val()
			, transactiontime : $("input[name = transactiontime]").val()
			, randsaveyn      : $("input[name = randsaveyn]").val()
			, accounttype     : $("input[name = accounttype]").val()
		};
		
		if(randsaveyn=="N") {
			alert("정원인원이 초과 되어 변경 할 수 없습니다.");
			return;
		}
		
		if(confirm("동반인 구분을 수정 하시겠습니까?") == true) {
			$.ajax({
				url: "<c:url value="/reservation/changePartnertAjax.do"/>"
				, type : "POST"
				, data: param
				, success: function(data, textStatus, jqXHR){
					
					if(data.msg == "success"){
						$("#uiLayerPop_w01").hide();
						
						alert("정상적으로 처리 완료 되었습니다.");
						$("#expInfoForm").attr("action", "/reservation/expInfoDetailList.do");
						$("#expInfoForm").submit();
					}else{
						alert("처리 도중 에레가 발생 되었습니다.");
					}
					
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="errors.load"/>';
					alert(mag);
				}
			});
		} else {
			return false;
		}
	});

});

function changePartnert(rsvseq, partnertypecode, transactiontime, randsaveyn, accounttype){
	$("input[name = rsvseq]").val("");
	$("input[name = rsvseq]").val(rsvseq);
	$("input[name = transactiontime]").val(transactiontime);
	$("input[name = randsaveyn]").val(randsaveyn);
	$("input[name = accounttype]").val(accounttype);
	
	$("input:radio[name = partnerTypeCode]").each(function(){
		
		if($(this).val() == partnertypecode){
// 			$(this).attr("checked", "checked");
			$(this).prop("checked", true);
		}
		
	});
	
}

function expInfoRsvCancel(rsvseq, expsessionseq, formatreservationdate, expseq, typecode, transactiontime){
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
	
	$("input[name = transactiontime]").val(transactiontime);
	
	var frm = document.expInfoForm
	var url = "<c:url value="/reservation/expInfoRsvCanselPop.do"/>";
	var title = "testpop";
	var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=no, resizable=no";
	window.open("", title,status);
	
	frm.target = title;
	frm.action = url;
	frm.method = "post";
	frm.submit();

}

function cancelUrlCall() {
	$(".btnBasicBXL").click();
}

/* 문화체험  */
function visitNumberChangelayerPop(expSeq, rsvSeq, visitNumber, randsaveyn, accounttype) {
	$("input[name = randsaveyn]").val(randsaveyn);
	$("input[name = accounttype]").val(accounttype);
	
	/* 해당 프로그램 참석 제한 인원 조회 ajax*/
	var param = {"searchExpSeq" : expSeq };
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureSeatCountSelectAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var expCultureSeatCount = parseInt(data.expCultureSeatCount);
			
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
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


/* 문화체험 참석인원 변경 완료 버튼  */
function visitNumberChangeConfirm() {
	var randsaveyn = $("input[name = randsaveyn]").val();
	
	/* 참석인원 변경 ajax */
	var param = {
			  "rsvSeq" : $("input[name = rsvseq]").val()
			, "visitNumber" : $("#visitNumber").val()
			};
	
	if(randsaveyn=="N") {
		alert("정원인원이 초과 되어 변경 할 수 없습니다.");
		return;
	} else if(randsaveyn=="B" && $("#visitNumber").val()=="2") {
		alert("변경시 정원인원이 초과 되어 변경 할 수 없습니다.")
		return;
	}
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureVisitNumberUpdateAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			alert("정상적으로 처리 완료 되었습니다.");
			$("#expInfoForm").attr("action", "/reservation/expInfoDetailList.do");
			$("#expInfoForm").submit();
// 			$("#expInfoForm").submit();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
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
<body>
<form id="expInfoForm" name="expInfoForm" method="post">
	<input type="hidden" name="rsvseq">
	<input type="hidden" name="expsessionseq">
	<input type="hidden" name="reservationdate">
	<input type="hidden" name="purchasedate" value="${scrData.purchasedate}">
	<input type="hidden" name="ppseq" value="${scrData.ppseq}">
	<input type="hidden" name="typeseq" value="${scrData.typeseq}">
	<input type="hidden" name="expseq" value="${scrData.expseq}">
	<input type="hidden" name="typecode">
	<input type="hidden" name="transactiontime">
	<input type="hidden" name="randsaveyn" value="" />
	<input type="hidden" name="accounttype" value="" />
</form> 
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500370.gif" alt="체험예약 현황확인"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500370.gif" alt="체험예약 현황을 확인할 수 있습니다."></p>
	</div>
	
	<div class="bizroomStateBox">
		<dl class="tblDetailCol4">
			<dt>예약자</dt>
			<dd>${scrData.account}&nbsp;${scrData.accountname}</dd>
			<dt>등록일자</dt>
			<dd>${scrData.purchasedate}</dd>
		</dl>
		
		<h2 class="pdtL"><img src="/_ui/desktop/images/academy/h2_w020500120.gif" alt="예약정보"></h2>
		<div class="reservInfoHeader">
			<div class="title"><span>체험종류 : ${expInfoDetailList[0].typename}</span><em>|</em><span>지역 : ${expInfoDetailList[0].ppname}</span></div>
		</div>
		
		<table class="tblList lineLeft">
			<caption>예약정보 테이블</caption>
			<colgroup>
				<col style="width:20%">
				<col style="width:auto">
				<col style="width:20%">
				<col style="width:20%">
				<col style="width:15%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">체험일자</th>
					<th scope="col">프로그램</th>
					<th scope="col">비고</th>
					<th scope="col">상태</th>
					<th scope="col"></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${expInfoDetailList}" var="item">
					<tr>
						<td>${item.reservationdate}${item.rsvweek}<br />${item.session}</td>
						<input type="hidden" id="transactionTime" value="${item.transactiontime}">
<%-- 						<td><c:out value="${item.typename}"></c:out></td> --%>
						<c:if test="${item.preparation ne 'N'}">
							<td>${item.typename}<br />${item.preparation}</td>
						</c:if>
						<c:if test="${item.preparation eq 'N'}">
							<td>${item.typename}</td>
						</c:if>

						<!-- 문화체험 -->
						<c:if test="${item.rsvinfoflag eq 'CN'}">
							<c:if test="${item.rsvcancel ne '-' }">
								<td>동반인 <c:if test="${item.partnertypename eq 1}">없음</c:if><c:if test="${item.partnertypename eq 2}">있음</c:if><a href="#uiLayerPop_02" class="btnCont" onclick="javascript:visitNumberChangelayerPop('${item.expseq}', '${item.rsvseq}', '${item.visitnumber}', '${item.randsaveyn}', '${item.accounttype}');"><span>변경</span></a></td>
							</c:if>
							<c:if test="${item.rsvcancel eq '-' }">
								<td>동반인 <c:if test="${item.partnertypename eq 1}">없음</c:if><c:if test="${item.partnertypename eq 2}">있음</c:if></td>
							</c:if>
						</c:if>
						
						<!-- 브랜드 그룹 -->
						<c:if test="${item.rsvinfoflag eq 'BG'}">
							<td>${item.partnertypename}</td>
						</c:if>
						
						<c:if test="${item.rsvinfoflag eq 'BP' || item.rsvinfoflag eq 'NM'}">
							<td>${item.partnertypename} <a href="#uiLayerPop_w01" onclick="javascript:changePartnert('${item.rsvseq}', '${item.partnertypecode }', '${item.transactiontime}', '${item.randsaveyn}', '${item.accounttype}');" class="btnTbl"><span>변경</span></a></td>
						</c:if>
						
						<c:if test="${item.paymentstatuscode eq 'P03'}">
							<td>${item.paymentstatusname}<br/>(${item.canceldatetime})</td>
						</c:if>
						<c:if test="${item.paymentstatuscode ne 'P03'}">
							<td>${item.paymentstatusname}</td>
						</c:if>
						
						<c:if test="${item.rsvcancel eq '-' || item.gettoday eq item.formatreservationdate}">
							<td>-</td>
						</c:if>
						
						<c:if test="${item.rsvcancel ne '-' && item.gettoday ne item.formatreservationdate}">
							<td><a href="javascript:void(0);" class="btnTbl" onclick="javascript:expInfoRsvCancel('${item.rsvseq}','${item.expsessionseq}','${item.formatreservationdate}','${item.expseq}', '${item.typecode}', '${item.transactiontime}');"><span>${item.rsvcancel}</span></a></td>
						</c:if>

					</tr>
					
				</c:forEach>
				<span id="snsText" style="display:none">
					<c:forEach items="${expInfoDetailList}" var="item">
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
					</c:forEach>
				</span>
				
			</tbody>
		</table>
		
		<!-- layer popup -->
		<div class="pbLayerWrap" id="uiLayerPop_w01" style="width:400px">
			<div class="pbLayerHeader">
				<strong><img src="/_ui/desktop/images/academy/h1_w020500380_pop.gif" alt="동반여부 변경"></strong>
				<a href="#" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="동반여부 변경 닫기"></a>
			</div>
			<div class="pbLayerContent">
				<div class="inputList">
					<c:forEach var="item" items="${partnerTypeCodeList}">
						<span><input type="radio" id="radio01" name="partnerTypeCode" value="${item.commonCodeSeq}"/><label for="radio01">${item.codeName}</label></span>
					</c:forEach>
				</div>
				<div class="btnWrapC">
					<a href="javascript:void(0);" class="btnBasicGL">변경취소</a>
					<a href="javascript:void(0);" class="btnBasicBL" id="brandChange">변경완료</a>
				</div>
			</div>
		</div>
		<!-- //layer popup -->
		
		<!-- layer popup -->
		<div class="pbLayerWrap" id="uiLayerPop_02" style="width:400px;">
			<div class="pbLayerHeader">
				<strong><img src="/_ui/desktop/images/academy/h1_w020500360_pop4.gif" alt="참석인원 변경" /></strong>
				<a href="javascript:void(0);" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 닫기"></a>
			</div>
			<div class="pbLayerContent">
				<div class="textC mgtbL">
					<span class="mgRS">동반자</span> 
					<select id="visitNumber" name="visitNumber" title="참석인원 선택">
					</select>
<!-- 					<input type="hidden" id="rsvSeq"> -->
				</div>
				
				<div class="btnWrapC">
					<input type="button" class="btnBasicGL" value="변경취소"/>
					<input type="button" class="btnBasicBL" value="변경완료" onclick="javascript:visitNumberChangeConfirm();"/>
				</div>		
			</div>
		</div>
		<!-- //layer popup -->
		
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
				<a href="javascript:void(0);" class="btnBasicBXL">체험예약 현황확인 목록</a>
			</div>
		</div>
		
	</div>
	
</section>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>