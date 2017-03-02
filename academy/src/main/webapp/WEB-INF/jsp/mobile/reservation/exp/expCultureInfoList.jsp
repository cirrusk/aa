<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">

$(document).ready(function () {
	
	if("" == $("input[name=nonMember]").val()){
		/* 팝업 오픈 */
		layerPopupOpen("<a href=\"#uiLayerPop_noneculture\"/>", 10);
		return false;
// 		openLayerPopup("<a href=\"#uiLayerPop_noneculture\"/>");
// 		layerPopOpen("#uiLayerPop_noneculture");
	}else{
		setTimeout(function(){ abnkorea_resize(); }, 500);
	}
	
	/* 변경 버튼 클릭 이벤트 */
	$("#alterBtn").on("click", function () {
		/* this 다음 input 태그(expSeq, rsvSeq, visitNumber)를 제한인원 조회 함수에 전달 */
		visitNumberChangelayerPop($(this).next().val(), $(this).next().next().val(), $(this).next().next().next().val());
	});

	/* 취소 버튼 클릭 이벤트 */
	$("#cancelBtn").on("click", function () {
		/* this 다음 input 태그 value 를 rsvSeq 태그에 전송  */
		$("#rsvSeq").val($(this).next().val());
	});
});

/* 문화체험 참석인원 변경 취소 버튼  */
function noneMemberConfirmCancel() {
	var newUrl = "${hybrisUrl}/business";
	top.window.location.href=newUrl;
}

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

/* 문화체험  */
function visitNumberChangelayerPop(expSeq, rsvSeq, visitNumber) {
	
	/* 해당 프로그램 참석 제한 인원 조회 ajax*/
	var param = {"searchExpSeq" : expSeq};
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureSeatCountSelectAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
			<%-- 요건 변경 : 남은 좌석 수 만큼 에서 2로 고정 --%>
			//var expCultureSeatCount = parseInt(data.expCultureSeatCount);
			var expCultureSeatCount = 2;
			
			var html = "";
			
			for(var i = 1 ; i <= expCultureSeatCount ; i++){
				if(i == parseInt(visitNumber)){
					html += "<option value=\""+i+"\" selected=\"selected\">"+i+"명</option>";
				}else{
					html += "<option value=\""+i+"\">"+i+"명</option>";
				}
			}
			
			$("#visitNumber").empty();
			$("#visitNumber").append(html);
			
			$("#rsvSeq").val(rsvSeq);
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
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
			alert("참석인원이 변경되었습니다.");
			
			$("#expCultureForm").submit();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
}

/* 문화체험 예약 취소 */
function expCultureRsvCancel() {
	
	var param = {"rsvSeq" : $("#rsvSeq").val()};
	
	$.ajax({
		url: "<c:url value='/reservation/expCultureCancelUpdateAjax.do'/>"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			alert("예약이 취소되었습니다.");
			
			$("#expCultureForm").submit();
			
		}, error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

/* 문화체험 취소 팝업 닫기 */
function cancelClosePop(){
	$("#uiLayerPop_cancel").hide();
	$("#layerMask").remove();
	
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}

/* 문화체험 참석인원 변경 팝업 닫기 */
function alterClosePop(){
	$("#uiLayerPop_alter").hide();
	$("#layerMask").remove();
	
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}
</script>

<!-- content area | ### academy IFRAME Start ### -->
<form id="expCultureForm" name="expCultureForm" method="post">
	<input type="hidden" name="nonMember" value="${nonMember}" />
	<input type="hidden" name="nonMemberId" value="${nonMemberId}" />
</form>

<!-- content -->
<section id="pbContent" class="bizroom">
			
	<p class="totalMsg">총 <strong>${fn:length(expCultureInfoList)}개</strong>의 등록내역이 있습니다.</p>
	
	<div class="stateWrap">
	<c:forEach var="item" items="${expCultureInfoList}" varStatus="status">
		<dl class="tblBizroomState">
			<c:if test="${item.paymentstatuscode eq 'P01' || item.paymentstatuscode eq 'P02'}">
			<dt>체험일자 : ${item.reservationdate} (${item.krweekday}) ${fn:substring(item.startdatetime, 0, 2)}:${fn:substring(item.startdatetime, 2, 4)} 
				<a href="#uiLayerPop_cancel" id="cancelBtn" class="btnTbl" onclick="layerPopupOpen(this);return false;">예약취소</a>
				<input type="hidden" value="${item.rsvseq}">
			</dt>
			</c:if>
			<c:if test="${item.paymentstatuscode ne 'P01' && item.paymentstatuscode ne 'P02'}">
			<dt>체험일자 : ${item.reservationdate} (${item.krweekday}) ${fn:substring(item.startdatetime, 0, 2)}:${fn:substring(item.startdatetime, 2, 4)} ~ ${fn:substring(item.enddatetime, 0, 2)}:${fn:substring(item.enddatetime, 2, 4)}</dt>
			</c:if>
			<dd>
				<p>${item.ppname} | ${item.productname}</p>
				<p>준비물 : ${item.preparation}</p>
				<c:if test="${item.paymentstatuscode eq 'P01'}">
				<p>참석인원 : ${item.visitnumber}명
					<a href="#uiLayerPop_alter" id="alterBtn" class="btnTbl" onclick="layerPopupOpen(this);return false;">변경</a>
					<input type="hidden" value="${item.expseq}">
					<input type="hidden" value="${item.rsvseq}">
					<input type="hidden" value="${item.visitnumber}">
				</p>
				<p>상태 : 대기신청</p>
				</c:if>
				<c:if test="${item.paymentstatuscode eq 'P02'}">
				<p>참석인원 : ${item.visitnumber}명 
					<a href="#uiLayerPop_alter" id="alterBtn" class="btnTbl" onclick="layerPopupOpen(this);return false;">변경</a>
					<input type="hidden" value="${item.expseq}">
					<input type="hidden" value="${item.rsvseq}">
					<input type="hidden" value="${item.visitnumber}">
				</p>
				<p>상태 : 체험대기</p>
				</c:if>
				<c:if test="${item.paymentstatuscode eq 'P03'}">
				<p>참석인원 : ${item.visitnumber}명 <a href="#none" class="btnTbl">변경</a></p>
				<p>상태 : 취소완료(${item.canceldatetime})</p>
				</c:if>
				<c:if test="${item.paymentstatuscode eq 'P05'}">
				<p>참석인원 : ${item.visitnumber}명 <a href="#none" class="btnTbl">변경</a></p>
				<p>상태 : 체험완료</p>
				</c:if>
				<c:if test="${item.paymentstatuscode eq 'P06'}">
				<p>참석인원 : ${item.visitnumber}명 <a href="#none" class="btnTbl">변경</a></p>
				<p>상태 : 체험불참</p>
				</c:if>
			</dd>
		</dl>
	</c:forEach>
	</div>
	<!-- //문화체험 예약현황확인 -->
	
	
	<!-- layer popoup -->
	<!-- 참석인원 변경 -->
	<div class="pbLayerPopup" id="uiLayerPop_alter">
		<div class="pbLayerHeader">
			<strong>참석인원 변경</strong>
		</div>
		<div class="pbLayerContent">
			<div class="selectBox mgAuto">
				<label for="memberNum">참석인원</label> 
					<input type="hidden" id="rsvSeq">
					<select id="visitNumber" title="참석인원 선택">
						<option>1명</option>
						<option>2명</option>
						<option>3명</option>
					</select>
			</div>
			
			<div class="btnWrap aNumb2">
				<span><a href="#" class="btnBasicGL" onclick="javascript:alterClosePop();">변경취소</a></span>
				<span><a href="#" class="btnBasicBL" onclick="javascript:visitNumberChangeConfirm();">변경완료</a></span>
			</div>
		</div>
		<a href="#none" class="btnPopClose" onclick="javascript:alterClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- // 참석인원 변경 -->
	
	<!-- 예약취소 알림 -->
	<div class="pbLayerPopup" id="uiLayerPop_cancel">
		<div class="pbLayerHeader">
			<strong>예약취소</strong>
		</div>
		<div class="pbLayerContent">
			
			<div class="cancelWrap">
				<p>예약을 취소하시겠습니까?</p>
				<!-- 20160714 페널티 수정 -->
				<p class="bdBox">취소 시 상황에 따라 페널티가 적용될 수 있습니다.</p>
			</div>
			
			<div class="btnWrap aNumb2">
				<span><a href="#none" class="btnBasicGL" onclick="javascript:cancelClosePop();">취소</a></span>
				<span><a href="#none" class="btnBasicBL" onclick="javascript:expCultureRsvCancel();">확인</a></span>
			</div>
		</div>
		
		<a href="#none" class="btnPopClose" onclick="javascript:cancelClosePop();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //예약취소 알림 -->
	
	<!-- 비회원 문화체험 신청자 확인 -->
	<div class="pbLayerPopup" id="uiLayerPop_noneculture" style="top : 10px;">
		<div class="pbLayerHeader">
			<strong>신청자 확인</strong>
		</div>
		<div class="pbLayerContent">
			
			<p>이름과 연락처를 입력하시면 나의 문화체험 예약내역 확인이 가능합니다.</p>
			
			<table class="tblCredit">
				<colgroup><col width="80px"><col width="auto"></colgroup>
				<tbody>
					<tr>
						<th scope="row">이름</th>
						<td><input type="text" id="nonMember" title="이름" /></td>
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
		
			<div class="btnWrap bNumb1">
				<a href="#" class="btnBasicBL" onclick="javascript:noneMemberCheck();">확인</a>
			</div>
		</div>
		<a href="#none" class="btnPopClose" onclick="javascript:noneMemberConfirmCancel();"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
	</div>
	<!-- //비회원 문화체험 신청자 확인 -->

</section>
<!-- //content -->

<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
