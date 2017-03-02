<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header_reservation_second.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/layerPop.jsp" %>

<script type="text/javascript">

var authenticationFlag = null;
var nonMember = "";
var nonMemberId = "";
var timer;

$(document.body).ready(function(){
	
	/* 본인확인 완료문구 hide */
	$(".msgBox").hide();
	/* 인증 완료 플래그 false */
	authenticationFlag = false;
	/* 인증번호 입려 태그 hide */
	$(".authenticationNumberInputForm").hide();
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
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
		$(".msgBox").hide();
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
				
				/* 인증번호 전송 버튼 hide*/
				$("#authenticationNumberSend").val("인증번호 재전송");
				$("#cfNumber").val("");
				
				nonMember = authenticationInfo.nonMember;
				nonMemberId = authenticationInfo.nonMemberId;
				$("#expCultureForm > input[name='nonMemberId']").val(nonMemberId);
				
				if(0 <= location.href.indexOf("localhost")
					|| 0 <= location.href.indexOf("aq")
					|| 0 <= location.href.indexOf("dev")
					){
					alert("인증번호 [" + authenticationInfo.certNumber + "]");
				}
				
				setTimeout(function(){ abnkorea_resize(); }, 500);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
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
					$(".msgBox").show();
					/* 인증 완료 플래그 true */
					authenticationFlag = true;
					
					setTimeout(function(){ abnkorea_resize(); }, 500);
				}else{
					alert(authenticationCheckInfo.reason);
				}
				
			},
			error: function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	});
	
	$(".btnBasicGL").on("click", function(){
		if($("#tempParentFlag").val() == "date"){
			$("#expCultureForm").attr("action", "/mobile/reservation/expCultureForm.do");
		}else if($("#tempParentFlag").val() == "program"){
			$("#expCultureForm").attr("action", "/mobile/reservation/expCultureProgramForm.do");
		}
		$("#expCultureForm").submit();
	});
	
	$(".btnBasicBL").on("click", function(){
		if(!$("input:checkbox[id='check2']").is(":checked")){
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
			url: "<c:url value='/mobile/reservation/expProgramVailabilityCheckAjax.do'/>"
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
							$("#expCultureForm").attr("action", "/mobile/reservation/expCultureNonmemberComplete.do");
							$("#expCultureForm").submit();
						},
						error: function(jqXHR, textStatus, errorThrown) {
							alert("처리도중 오류가 발생하였습니다.");
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

//남은 시간 카운터
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
		<!-- content -->
		<section id="pbContent" class="bizroom">
			<h2 class="titTop4">비회원 문화체험 신청</h2>
			<p class="h2Txt">(아래 약관 내용들을 잘 읽으신 후 동의하여 주세요.)</p>
			
			<div class="mAgreeWrap2">
				<p class="tit brdTop"><span class="colorB">[필수]</span> 개인정보 수집/이용에 대한 동의</p>
				<div class="tblWrap">
					<table class="tblDetail">
						<caption>[필수] 개인정보 수집/이용에 대한 동의</caption>
						<colgroup>
							<col style="width:100px" />
							<col style="width:auto" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">항목</th>
								<td>이름, 휴대폰 번호</td>
							</tr>
							<tr>
								<th scope="row">이용목적</th>
								<td>예약자 식별<br />
									예약 정보 확인 서비스 제공<br />
									예약관련 상담 대응<br />
									예약관련 안내사항 전달
								</td>
							</tr>
							<tr>
								<th scope="row">이용<br /> 보유기간</th>
								<td>예약 시점으로부터 4개월 동안 보유<br />
								(패널티 규정 추적 관리를 위함)</td>
							</tr>
						</tbody>
					</table>
					<div class="agreeBoxYN">
						위 개인정보 수집 및 이용 약관을 확인하였으며 이에 동의하십니까? <span class="floatR"><input type="checkbox" name="" id="check2" /><label for="check2">동의합니다.</label></span>
					</div>
					<p class="listWarning">※ 개인정보 수집 및 이용에 대한 동의를 거부하실 수 있으나, 거부 시 예약 서비스 이용이 제한됩니다.</p>
					
					<!-- @edit 20160625 휴대폰 인증하기 영역 변경 -->
					<div class="tblWrap">
						<p class="tit"><span class="colorB">[필수]</span> 비회원님의 연락 가능한 정보를 확인하였습니다.</p>
						<p class="textR"><img src="/_ui/mobile/images/common/ico_star_red.png" alt="필수" class="icoMust" />는 필수항목입니다.</p>
						<table class="tblDetail mgtS">
							<caption>[필수] 비회원님의 연락 가능한 정보</caption>
							<colgroup>
								<col style="width:100px" />
							<col style="width:auto" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><label for="contactName">이름</label> <img src="/_ui/mobile/images/common/ico_star_red.png" alt="필수" class="icoMust" /></th>
									<td>
										<div class="inputWrap">
											<div class="inputBox">
												<p class="listDot">2자 이상 한글로 띄어쓰기 없이 입력해주세요.</p>
												<input type="text" id="nonMember" name="nonMember" class="w100" />
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="contactNumber">휴대폰번호</label> <img src="/_ui/mobile/images/common/ico_star_red.png" alt="필수" class="icoMust" /></th>
									<!-- <td><input type="text" id="contactNumber" class="w100" /></td>-->
									<td>
										<div class="inputWrap">
											<div class="inputBox">
												<div class="inputNum3">
													<span><select title="휴대폰 식별번호 선택" id="nonMemberId1" name="nonMemberId1">
														<option value="010" selected="selected">010</option>
														<option value="011">011</option>
														<option value="016">016</option>
														<option value="017">017</option>
														<option value="018">018</option>
														<option value="019">019</option>
														<option value="0130">0130</option>
														</select></span>
													<span><input id="nonMemberId2" name="nonMemberId2" type="tel" size="4" title="휴대폰번호 앞자리 입력" maxlength="4" style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope"></span>
													<span><input id="nonMemberId3" name="nonMemberId3" type="tel" size="4" title="휴대폰번호 뒷자리 입력" maxlength="4" style="ime-mode:disabled" onkeydown='return stringUtility.onlyNumber(event)' onkeyup='stringUtility.removeChar(event)' autocomplete="nope"></span>
												</div>
											</div>
										</div>
										<div class="btnWrap certNum">
											<input id="authenticationNumberSend" class="btnTbl" type="button" value="인증번호 전송">
<!-- 											<input class="btnTbl" type="button" value="인증번호 재전송"> -->
										</div>
									</td>
								</tr>
								<tr class="authenticationNumberInputForm">
									<th scope="row"><label for="certNum">인증번호 입력</label></th>
									<td>
										<div class="inputWrap">
											<p class="inputBox"><input type="number" id="cfNumber"></p>
											<p class="inputBtn"><input type="button" id="cfNumberBtn" class="btnCont" value="확인"></p>
										</div>
										<div id="timeCount" class="certTime"></div>
										
									</td>
								</tr>
							</tbody>
						</table>
						<p class="listWarning mgtS">※  타인의 신상정보를 허락 없이 임의로 사용하여 예약 할 경우 대한민국 형법 위반으로 처벌 받을 수 있습니다. </p>
					</div>
					
					<!-- @edit 20160625 본인확인 메세지 추가 -->
					<div class="msgBox">
						<p class="certMsg">본인확인이 <span>완료</span>되었습니다.</p>
					</div>
					<!-- // @edit 20160625 본인확인 메세지 추가 -->
				
					<div class="agreeBox">
						위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.
						<p>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
					</div>
				</div>
				
				<div class="btnWrap bNumb2">
					<a href="#none" class="btnBasicGL">예약취소</a>
					<a href="#none" class="btnBasicBL">예약확정</a>
				</div>
			</div>
			<!-- // 비회원 문화체험 신청 -->
		</section>
		<!-- //content -->
<!-- //content area | ### academy IFRAME End ### -->
</form>
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/mobile/footer.jsp" %>