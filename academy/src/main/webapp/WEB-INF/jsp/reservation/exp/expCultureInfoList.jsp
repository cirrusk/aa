<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	if("" == $("input[name=nonMember]").val()){
		/* 팝업 오픈 */
		layerPopOpen("#uiLayerPop_99");
	}
});

/* 비회원정보 확인 및  */
function noneMemberCheck() {
	
	/* 이름(휴대전화번호) 널 체크 */
	if("" == $("#nonMember").val()
		|| "" == $("#nonMemberId1").val()
		|| "" == $("#nonMemberId2").val()
		|| "" == $("#nonMemberId3").val()){
		alert("이름(휴대폰번호)을 입력하여 주세요");
		return;
	}
	
	if(!/^[가-힝]{2,}$/.test($("#nonMember").val())){
		alert("잘못된 정보가 입력되었습니다. 확인후 다시 입력하여 주세요.");
		$("#nonMember").focus();
		return;
	}
	
	/* 비회원 정보 정리 */
	$("input[name=nonMember]").val($("#nonMember").val());
	$("input[name=nonMemberId]").val($("#nonMemberId1").val()+$("#nonMemberId2").val()+$("#nonMemberId3").val());
	
	/* submit */
	$("#expCultureForm").submit();
}

function doPage(page) {
	
	$("#expCultureForm > input[name='page']").val(page);  // 
	$("#expCultureForm").submit();
}

/* 문화체험  */
function visitNumberChangelayerPop(expSeq, rsvSeq, visitNumber) {
	
	/* 해당 프로그램 참석 제한 인원 조회 ajax*/
	var param = {"searchExpSeq" : expSeq};
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureSeatCountSelectAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			var expCultureSeatCount = parseInt(data.expCultureSeatCount);
			
			var html = "";
			
			for(var i = 1 ; i <= 2 ; i++){
				if(i == parseInt(visitNumber)){
					html += "<option value=\""+i+"\" selected=\"selected\">"+i+"명</option>";
				}else{
					html += "<option value=\""+i+"\">"+i+"명</option>";
				}
			}
			
			$("#visitNumber").empty();
			$("#visitNumber").append(html);
			
			$("#rsvSeq").val(rsvSeq);
			
			layerPopOpen("#uiLayerPop_02");
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

/* 문화체험 참석인원 변경 완료 버튼  */
function visitNumberChangeConfirm() {
	
	/* 참석인원 변경 ajax */
	var param = {"rsvSeq" : $("#rsvSeq").val()
				, "visitNumber" : $("#visitNumber").val()};
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureVisitNumberUpdateAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			$("#expCultureForm").submit();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
}

/* 문화체험 참석인원 변경 취소 버튼  */
function visitNumberChangeCancel() {
	closeLayerPopup($($("#uiLayerPop_02")));
}

/* 문화체험 참석인원 변경 취소 버튼  */
function noneMemberConfirmCancel() {
	var newUrl = "${hybrisUrl}/business";
	top.window.location.href=newUrl;
}

/* 문화체험 예약 취소 */
function expCultureRsvCancel(rsvSeq) {
	
	var param = {"rsvSeq" : rsvSeq};
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureCancelUpdateAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			alert("예약이 취소되었습니다.");
			$("#expCultureForm").submit();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function layerPopOpen(e){
	var target = $(e);
	var $target = $($(e));	
		
	$target.show();
	$target.attr('tabindex','0');
	
	// 암막
	var layerM =$('<div class="layerMask" id="layerMask" style="display:block"></div>');
	$target.before(layerM);
	$(document).scrollTop();
	$target.css({ 'display':'block', 'position':'fixed', 'top':'50%', 'left':'50%', 'marginTop': - $target.height()/2, 'marginLeft': - $target.width()/2 });

	$('#pbHeader').css({'z-index':'-1'});
	$('#pbFooter').css({'z-index':'-1'});

	if(target=="#uiLayerPop_prodDetail"){
		$('#pbAside').css({'z-index':'-1'});
	}

	// layerPop center align - Close button
	$(document).on('click', 'div[id^="uiLayerPop_"] .btnPopClose,.layerPopClose', function(){closeLayerPopup($target);return false;});
	return false;	
}

function closeLayerPopup($target){
	var $layerPop = $('div[id^="uiLayerPop_"]');
	$layerPop.find('.btnPopClose, .layerPopClose').unbind('click');
	$target.unbind('keydown');
	$target.fadeOut(200);
	var targetId=$target.attr('id');
	$('.layerMask').fadeOut(200).remove();
	$('a[href="#'+targetId+'').focus();
	$target.attr('aria-hidden','true');
	return false;
};

</script>
</head>
<body>
<!-- content area | ### academy IFRAME Start ### -->
<form id="expCultureForm" name="expCultureForm" method="post">
	<input type="hidden" name="rowPerPage" value="${scrData.rowPerPage}" />
	<input type="hidden" name="totalCount" value="${scrData.totalCount}" />
	<input type="hidden" name="firstIndex" value="${scrData.firstIndex}" />
	<input type="hidden" name="totalPage" value="${scrData.totalPage}" />
	<input type="hidden" name="page" value="${scrData.page}" />

	<input type="hidden" name="nonMember" value="${scrData.nonMember}" />
	<input type="hidden" name="nonMemberId" value="${scrData.nonMemberId}" />
</form>
<section id="pbContent" class="bizroom">
	<div class="hWrap">
<!-- 		
		<h1><img src="/_ui/desktop/images/academy/h1_w020500350.gif" alt="문화체험 예약현황확인"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500350.gif" alt="문화체험 예약현황을 확인할 수 있습니다."></p>
 -->
		<h1><img src="/_ui/desktop/images/academy/h1_w020500370.gif" alt="체험예약 현황확인"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500370.gif" alt="체험예약 현황을 확인할 수 있습니다."></p>
		
	</div>
	
	<p class="mgtL"><strong>총 ${scrData.totalCount} 개</strong>의 등록내역이 있습니다.</p>
	
	<table class="tblCont mgtS">
		<caption>예약정보 확인</caption>
		<colgroup>
			<col style="width:12%" />
			<col style="width:12%" />
			<col style="width:15%" />
			<col style="width:auto" />
			<col style="width:12%" />
			<col style="width:18%" />
			<col style="width:14%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">등록일자</th>
				<th scope="col">지역</th>
				<th scope="col">체험일자</th>
				<th scope="col">프로그램</th>
				<th scope="col">참석인원</th>
				<th scope="col">상태</th>
				<th scope="col">예약취소</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="item" items="${expCultureInfoList}" varStatus="status">
		<tr>
			<td>${item.purchasedate}</td>
			<td>${item.ppname}</td>
			<td>${item.reservationdate}(${item.krweekday})<br />${fn:substring(item.startdatetime, 0, 2)}:${fn:substring(item.startdatetime, 2, 4)} ~ ${fn:substring(item.enddatetime, 0, 2)}:${fn:substring(item.enddatetime, 2, 4)}</td>
			<td>${item.productname}</td>
			
			<c:if test="${item.paymentstatuscode eq 'P01'}">
			<td>${item.visitnumber}명<a href="#none" class="btnCont" onclick="javascript:visitNumberChangelayerPop('${item.expseq}', '${item.rsvseq}', '${item.visitnumber}');"><span>변경</span></a></td>
			<td>대기신청</td>
			<td><a href="#none" class="btnCont" onclick="javascript:expCultureRsvCancel('${item.rsvseq}');"><span>예약취소</span></a></td>
			</c:if>
			
			<c:if test="${item.paymentstatuscode eq 'P02'}">
			<td>${item.visitnumber}명<a href="#none" class="btnCont" onclick="javascript:visitNumberChangelayerPop('${item.expseq}', '${item.rsvseq}', '${item.visitnumber}');"><span>변경</span></a></td>
			<td>체험대기</td>
			<td><a href="#none" class="btnCont" onclick="javascript:expCultureRsvCancel('${item.rsvseq}');"><span>예약취소</span></a></td>
			</c:if>
			
			<c:if test="${item.paymentstatuscode eq 'P03'}">
			<td>${item.visitnumber}명<a href="#none" class="btnCont"><span>변경</span></a></td>
			<td>취소완료 <br/>(${item.canceldatetime})</td>
			<td>-</td>
			</c:if>
			
			<c:if test="${item.paymentstatuscode eq 'P05'}">
			<td>${item.visitnumber}명<a href="#none" class="btnCont"><span>변경</span></a></td>
			<td>체험불참</td>
			<td>-</td>
			</c:if>
			
			<c:if test="${item.paymentstatuscode eq 'P06'}">
			<td>${item.visitnumber}명<a href="#none" class="btnCont"><span>변경</span></a></td>
			<td>체험완료</td>
			<td>-</td>
			</c:if>
		</tr>
		</c:forEach> 
		</tbody>
	</table>
	
	<!-- layer popup -->
	<div class="pbLayerWrap" id="uiLayerPop_02" style="width:400px;">
		<div class="pbLayerHeader">
			<strong><img src="/_ui/desktop/images/academy/h1_w020500360_pop4.gif" alt="참석인원 변경" /></strong>
			<a href="javascript:void(0);" class="btnPopClose" onclick="javascript:visitNumberChangeCancel();"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 닫기"></a>
		</div>
		<div class="pbLayerContent">
			<div class="textC mgtbL">
				<span class="mgRS">참석인원</span> 
				<select id="visitNumber" name="visitNumber" title="참석인원 선택">
				</select>
				<input type="hidden" id="rsvSeq">
			</div>
			
			<div class="btnWrapC">
				<input type="button" class="btnBasicGL" value="변경취소" onclick="javascript:visitNumberChangeCancel();"/>
				<input type="button" class="btnBasicBL" value="변경완료" onclick="javascript:visitNumberChangeConfirm();"/>
			</div>		
		</div>
	</div>
	
	<div class="pbLayerWrap" id="uiLayerPop_99" style="width:400px;">
		<div class="pbLayerHeader">
			<strong><img src="/_ui/desktop/images/academy/h1_w020500350_pop.gif" alt="신청자 확인" /></strong>
			<a href="javascript:void(0);" class="btnPopClose" onclick="javascript:noneMemberConfirmCancel();"><img src="/_ui/desktop/images/common/btn_close.gif" alt="안내 닫기"></a>
		</div>
		
		<div class="pbLayerContent">
			<p>이름과 연락처를 입력하시면 나의 문화체험 예약내역 확인이 가능합니다.</p>
			<table class="tblInput mgtM">
				<caption></caption>
				<colgroup>
					<col style="width:30%" />
					<col style="width:70%" />
				</colgroup>			
				<tbody>
				<tr>
					<th scope="row">이름</th>
					<td><input type="text" id="nonMember" title="이름"/></td>
				</tr>
				<tr>
					<th scope="row">휴대폰번호</th>
					<td>
						<input type="text" id="nonMemberId1" size="3" title="휴대폰앞번호" maxlength="3" style="ime-mode:disabled; width:50px;" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope"/> -
						<input type="text" id="nonMemberId2" size="4" title="휴대폰가운데번호" maxlength="4" style="ime-mode:disabled; width:50px;" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope"/> -
						<input type="text" id="nonMemberId3" size="4" title="휴대폰뒷번호" maxlength="4" style="ime-mode:disabled; width:50px;" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope"/>
					</td>
				</tr>
				</tbody>
			</table>
			<div class="btnWrapC">
				<input type="button" class="btnBasicBL" onclick="javascript:noneMemberCheck();" value="확인" />
			</div>
		</div>
	</div>
	<!-- //layer popup -->
	
	<!-- //페이지처리 -->
	<jsp:include page="/WEB-INF/jsp/framework/include/paging.jsp" flush="true">
		<jsp:param name="rowPerPage" value="${scrData.rowPerPage}"/>
		<jsp:param name="totalCount" value="${scrData.totalCount}"/>
		<jsp:param name="colNumIndex" value="10"/>
		<jsp:param name="thisIndex" value="${scrData.page}"/>
		<jsp:param name="totalPage" value="${scrData.totalPage}"/>
	</jsp:include>

</section>
<!-- //content area | ### academy IFRAME End ### -->

		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>