<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

var authenticationFlag = null;
var nonMember = "";
var nonMemberId = "";
var timer;

$(document.body).ready(function(){
	/* 본인확인 완료문구 hide */
	$(".footMsg").hide();
	/* 인증 완료 플래그 false */
	authenticationFlag = false;
	/* 인증번호 입려 태그 hide */
	$(".authenticationNumberInputForm").hide();
	
	/* 인증번호 전송 버튼 클릭 시*/
	$("#authenticationNumberSend").click(function () {
		
		/* 이름(휴대전화번호) 널 체크 */
		if("" == $("#nonMember").val()
			|| "" == $("#nonMemberId2").val()
			|| "" == $("#nonMemberId3").val()){
			alert("이름(휴대폰번호)을 입력하여 주세요");
			return;
		}
		/* 이름(휴대전화번호) 유효성 체크 */
		if(!/^[가-힝]{2,}$/.test($("#nonMember").val())
			|| !/^[0-9]{4}$/.test($("#nonMemberId2").val())
			|| !/^[0-9]{4}$/.test($("#nonMemberId3").val())){
			alert("잘못된 정보가 입력되었습니다. 확인후 다시 입력하여 주세요.");
			return;
		}
		
		/* 본인확인 완료문구 hide */
		$(".footMsg").hide();
		/* 인증 완료 플래그 false */
		authenticationFlag = false;
		/* 인증번호 입려 태그 hide */
		$(".authenticationNumberInputForm").hide();
		
		/* 인증번호 전송 nonMemberId1 */
		var param = {"nonMember" : $("#nonMember").val()
				, "nonMemberId1" : $("#nonMemberId1").val()
				, "nonMemberId2" : $("#nonMemberId2").val()
				, "nonMemberId3" : $("#nonMemberId3").val()
			};
		
		$.ajaxCall({
			url: "<c:url value='/reservation/expCultureAuthenticationNumberSendAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var authenticationInfo = data.expCultureAuthenticationInfo;
				
				/* 3분 카운트 */
				countDownTimer('timeCount');
				
				/* 인증번호 입려 태그 show */
				$(".authenticationNumberInputForm").show();
				$("#cfNumber").val("");
				
				/* 인증번호 전송 버튼 hide*/
				$("#authenticationNumberSend").val("인증번호 재전송");
				
				nonMember = authenticationInfo.nonMember;
				nonMemberId = authenticationInfo.nonMemberId;
				$("#expCultureForm > input[name='nonMemberId']").val(nonMemberId);
				
				if(0 <= location.href.indexOf("localhost")
					|| 0 <= location.href.indexOf("aq")
					|| 0 <= location.href.indexOf("dev")
					){
					alert("인증번호 [" + authenticationInfo.certNumber + "]");
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
		
	});
	
	/* 인증 확인 버튼 클릭 시 */
	$("#cfNumberBtn").click(function () {
		/* 인증번호 전송 nonMemberId1 */
		var param = {"nonMember" : nonMember
				, "nonMemberId" : nonMemberId
				, "certNumber" : $("#cfNumber").val()
			};
		
		$.ajaxCall({
			url: "<c:url value='/reservation/expCultureAuthenticationNumberCheckAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var authenticationCheckInfo = data.expCultureAuthenticationCheckInfo;
				
				if("true" == authenticationCheckInfo.possibility){
					/* 인증번호 입려 태그 hide */
					$(".authenticationNumberInputForm").hide();
					/* 본인확인 완료 문구 show */
					$(".footMsg").show();
					/* 인증 완료 플래그 true */
					authenticationFlag = true;
				}else{
					alert(authenticationCheckInfo.reason);
				}
				
			},
			error: function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	});
	
	$(".btnBasicGL").on("click", function(){
		if($("#tempParentFlag").val() == "date"){
			$("#expCultureForm").attr("action", "/reservation/expCultureForm.do");
		}else if($("#tempParentFlag").val() == "program"){
			$("#expCultureForm").attr("action", "/reservation/expCultureProgramForm.do");
		}
		$("#expCultureForm").submit();
	});
	
	$(".btnBasicBL").on("click", function(){
		if(!$("input:checkbox[id='check1']").is(":checked")){
			alert("개인정보 수집 및 이용에 관한 동의 를 하셔야 합니다.");
			return;
		}
		
		if(!authenticationFlag){
			alert("인증을 진행하셔야 합니다.");
			return;
		}
		
		if(nonMember != $("#nonMember").val()
			|| nonMemberId != $("#nonMemberId1").val() + "" + $("#nonMemberId2").val() + "" + $("#nonMemberId3").val()){
			alert("인증을 진행한 이름(휴대폰번호)와 현재 입력되어있는 이름(휴대폰번호)가 일치하지 않습니다.");
			return;
		}
		
		/* 비회원 누적예약 제한 검사 */
		if(!availabilityCheck()){
			return;
		}
		
		var param = $("#expCultureForm").serialize();
		
		$.ajaxCall({
			url: "<c:url value='/reservation/expProgramVailabilityCheckAjax.do'/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var item = data.ProgramVailability;
				
				if(item.cnt != 0) {
					alert("중복 신청이 불가능 합니다. 확인 후 신청 해 주세요.");
				} else {
					$.ajaxCall({
						url: "<c:url value='/reservation/expCultureRsvInsertAjax.do' />"
						, type : "POST"
						, data: param
						, success: function(data, textStatus, jqXHR){
							$("#expCultureForm").attr("action", "/reservation/expCultureNonmemberComplete.do");
							$("#expCultureForm").submit();
						},
						error: function(jqXHR, textStatus, errorThrown) {
							var mag = '<spring:message code="errors.load"/>';
							alert(mag);
						}
					});
				}
			}
		});
	});

});

function middlePenaltyCheck() {
	
	var penaltyCheck = true;
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/rsvMiddlePenaltyCheckAjax.do'/>"
		, type : "POST"
		, data: $("#expCultureForm").serialize()
		, async: false
		, success: function(data, textStatus, jqXHR){
			if(!data.middlePenaltyCheck){
				alert("패널티로 인해서 예약이 불가 합니다.");
				penaltyCheck = false;
			}

		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	return penaltyCheck;
}

function availabilityCheck() {
	
	var availabilityCheck = true;
	
	$("#checkList").empty();
	
	$("#expCultureForm").children("input").each(function () {
		if("tempTypeSeq" == $(this).attr("name")){
			$("#checkList").append("<input type=\"hidden\" name=\"typeSeq\" value=\""+$(this).val()+"\">");
		}else if("tempReservationDate" == $(this).attr("name")){
			$("#checkList").append("<input type=\"hidden\" name=\"reservationDate\" value=\""+$(this).val()+"\">");
		}
	});
	
	$("#checkList").append("<input type=\"hidden\" name=\"nonMemberId\" value=\""+nonMemberId+"\">");
	$("#checkList").append("<input type=\"hidden\" name=\"typeseq\" value=\""+$("input[name=tempTypeSeq]").val()+"\">");
	$("#checkList").append("<input type=\"hidden\" name=\"ppseq\" value=\""+$("input[name=tempPpSeq]").val()+"\">");
	$("#checkList").append("<input type=\"hidden\" name=\"expseq\" value=\""+$("input[name=tempExpSeq]").val()+"\">");
	
	$.ajaxCall({
		  url: "<c:url value='/reservation/rsvAvailabilityCheckAjax.do'/>"
		, type : "POST"
		, data: $("#checkList").serialize()
		, async: false
		, success: function(data, textStatus, jqXHR){
			if(!data.rsvAvailabilityCheck){
				alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
				availabilityCheck = false;
			}
		}, error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	return availabilityCheck;
}

// 남은 시간 카운터
function countDownTimer(id){
	var end = new Date();
	end.setMinutes(end.getMinutes() + 3);
	
	var _second = 1000;
	var _minute = _second * 60;
	var _hour = _minute * 60;
	var _day = _hour * 24;
	
	function showRemaining() {
		var now = new Date();
		var distance = end - now;
		if (distance < 0) {
			
			clearInterval(timer);
			document.getElementById(id).innerHTML = "";
			
			return;
		}
		var days = Math.floor(distance / _day);
		var hours = Math.floor((distance % _day) / _hour);
		var minutes = Math.floor((distance % _hour) / _minute);
		var seconds = Math.floor((distance % _minute) / _second);
		
		document.getElementById(id).innerHTML = "남은시간 : " + minutes + "분 " + seconds + "초";
	}

	clearInterval(timer);
	timer = setInterval(showRemaining, 1000);
}

</script>
</head>
<body>
<form id="checkList" name="checkList" method="post">
</form>
<form id="expCultureForm" name="expCultureForm" method="post">
<input type="hidden" id="tempParentFlag" value="${expCultureInfoList[0].tempParentFlag}">
<input type="hidden" name="nonMemberId" value="">
<c:forEach var="item" items="${expCultureInfoList}" varStatus="status">
	<input type="hidden" name="tempTypeSeq" value="${item.tempTypeSeq}">
	<input type="hidden" name="tempPpSeq" value="${item.tempPpSeq}">
	<input type="hidden" name="tempPpName" value="${item.tempPpName}">
	<input type="hidden" name="tempExpSeq" value="${item.tempExpSeq}">
	<input type="hidden" name="tempExpSessionSeq" value="${item.tempExpSessionSeq}">
	<input type="hidden" name="tempReservationDate" value="${item.tempReservationDate}">
	<input type="hidden" name="tempStandByNumber" value="${item.tempStandByNumber}">
	<input type="hidden" name="tempPaymentStatusCode" value="${item.tempPaymentStatusCode}">
	<input type="hidden" name="tempProductName" value="${item.tempProductName}">
	<input type="hidden" name="tempStartDateTime" value="${item.tempStartDateTime}">
	<input type="hidden" name="tempEndDateTime" value="${item.tempEndDateTime}">
	<input type="hidden" name="tempVisitNumber" value="${item.tempVisitNumber}">
	<input type="hidden" name="tempKrWeekDay" value="${item.tempKrWeekDay}">
</c:forEach>

<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
<!-- 	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500350.gif" alt="문화체험 예약현황확인"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500350.gif" alt="문화체험 예약현황을 확인할 수 있습니다."></p>
	</div> -->
	<div class="hWrap">
		<!-- 20161027 수정 -->
		<h1><img src="/_ui/desktop/images/academy/h1_w020500360.gif" alt="문화체험 예약"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020500360.gif" alt="전국 Amway Plaza에서 운영되고 있는 문화 체험을 예약하실 수 있습니다."></p>
		<!-- //20161027 수정 -->
	</div>
	
	<div class="hWrap mgtbL">
		<h2><img src="/_ui/desktop/images/academy/h2_w020500350_01.gif" alt="비회원 문화체험 신청"></h2>
		<p><img src="/_ui/desktop/images/academy/txt_w020500350_02.gif" alt="아래의 약관을 읽고 동의해 주세요."></p>
<!-- 		<span class="hBtn"><a href="#" target="_blank" title="새창 열림" class="btnCont"><span>약관보기</span></a></span> -->
	</div>
	
	<h3 class="pdNone"><img src="/_ui/desktop/images/academy/h3_w02_aproom_09.gif" alt="[필수] 개인정보 수집/이용에 대한 동의" /></h3>
	<!-- @eidt 20160704 약관관련 구성 및 텍스트 변경 -->
	<table class="tblList lineLeft">
		<caption>[필수] 개인정보 수집/이용에 대한 동의</caption>
		<colgroup>
			<col style="width:24%" />
			<col style="width:34%" />
			<col style="width:auto" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">항목</th>
				<th scope="col">이용 목적</th>
				<th scope="col">이용&middot;보유기간</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>이름, 휴대폰 번호</td>
				<td><span class="tdTextL lineHS">예약자 식별<br />예약 정보 확인 서비스 제공<br />예약관련 상담 대응<br />예약관련 안내사항 전달<br />불참 시 패널티 적용</span></td>
				<td><span class="lineHS">예약 시점으로부터 4개월 동안 보유<br />(패널티 규정 추적 관리를 위함)</span></td>
			</tr>
		</tbody>
	</table>
	<div class="agreeBoxYN">
		<span>위 개인정보 수집 및 이용 약관을 확인하였으며 이에 동의하십니까?</span>
		<span class="inputR"><input type="checkbox" id="check1" /><label for="check1">동의합니다.</label></span>
	</div>
	<!-- // @eidt 20160701 약관관련 구성 및 텍스트 변경 -->
	<p class="listWarning">※ 개인정보 수집 및 이용에 대한 동의를 거부하실 수 있으나, 거부 시 예약서비스 이용이 제한됩니다.</p>
		
	<div class="hWrapLineN">
		<h3><strong><span class="fcR">[필수]</span>비회원님의 연락 가능한 정보를 확인 하였습니다.</strong></h3>
		<span class="requiredTbl"><strong>필수 항목</strong>표시는 필수 항목입니다.</span>
	</div>
	<table class="tblInput borderT1 mgNone">
		<caption>실명인증</caption>
		<colgroup>
			<col style="width:20%">
			<col style="width:80%">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row" class="thVerticalT">이름 <span class="fcR">*</span></th>
				<td>
					<em class="listDot">2자 이상 한글로 띄어쓰기 없이 입력해주세요.</em>
					<input type="text" id="nonMember" name="nonMember" size="25" title="이름 입력">
				</td><!-- 20150424 : 오타 수정 -->
			</tr>
			<tr>
				<th scope="row" class="thVerticalT">휴대폰번호 <span class="fcR">*</span></th>
				<td>
					<select id="nonMemberId1" name="nonMemberId1" title="휴대폰 식별번호 선택" class="selWidthS">
						<option value="010" selected="selected">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="018">018</option>
						<option value="019">019</option>
						<option value="0130">0130</option>
					</select>
					<input type="text" id="nonMemberId2" name="nonMemberId2" size="4" title="휴대폰번호 앞자리 입력" maxlength="4" style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope"> - 
					<input type="text" id="nonMemberId3" name="nonMemberId3" size="4" title="휴대폰번호 뒷자리 입력" maxlength="4" style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope">
					<span class="btnTbl">
						<input type="button" value="인증번호 전송" id="authenticationNumberSend" class="btn">
<!-- 						<input type="button" value="인증번호 재전송" class="btn"> -->
					</span>
					<br/>
					<label for="cfNumber" class="dotLabel mgNone authenticationNumberInputForm">인증번호 입력</label>
					<input type="text" size="12" id="cfNumber" class="authenticationNumberInputForm" title="인증번호 입력">
					<span class="btnTbl authenticationNumberInputForm">
					<input type="button" value="확인" id="cfNumberBtn" class="btn">
					</span>
					<span id="timeCount" class="authenticationNumberInputForm"></span>
				</td>
			</tr>
		</tbody>
	</table>
	<p class="listWarning">※ 타인의 신상정보를 허락 없이 임의로 사용하여 예약 할 경우 대한민국 형법 위반으로 처벌 받을 수 있습니다.</p>
	<div class="footMsg">
		<p class="certMsg">본인확인이 <span>완료</span>되었습니다.</p>
	</div>
	<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
	
	<div class="btnWrapC">
		<input type="button" class="btnBasicGL" value="예약취소" />
		<input type="button" class="btnBasicBL" value="예약확정" />
	</div>
	
</section>
<!-- //content area | ### academy IFRAME End ### -->
</form>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>