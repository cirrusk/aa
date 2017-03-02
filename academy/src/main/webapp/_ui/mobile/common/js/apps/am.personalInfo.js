var isMember; //userGroup 받기, ABO 인지 Member 인지
var nextChangePassword = false; //다음에 변경하기

//비밀번호 다음에 변경하기
function changePwNext(){
	nextChangePassword = true;
	$("#passwordChange").submit();
}

(function($){
	$.pageInit = function(){
		if($("#barcodeLocation").length){	
			var uid = $("#barcodeUid").val();
			if($.trim(uid).length >= 1){				
				$("#barcodeLocation").html(DrawCode39Barcode(uid, "0"));
			}
		}
		
		$.certify.addEvent();
		
		if($(".memWrap ul li input[name='userType']").length){
			$.userType.init();
		}
		$.findSendInfo.init();

	    if($("#formattedAddress").length){
			$(".addressInfo.olnyBg").text($("#formattedAddress").val());
		}

		$(".notExists").show();
		$(".exists").hide();		
		
		$(".inFocus").focus();
		
		if($(".myMessage ul li a").length){
			$.comm.myMessage.styles($(".myMessage ul li a").find("p:last"));
		}		
	},
	$.updateInfo = function(sUrl, oData){
		$.ajax({
			type:"POST",
			url: sUrl,
			dataType: "json",
			data: oData,
			success: function (data)
			{	
				if(data.result == "true"){
					window.location.href = data.path;
				}else{
					//$.ajaxUtil.errorMessage(data);
				}
			},
			error: function(){
				alert($.msg.err.system);
			}
		});	
	},
	$.userType = {
			init : function(){
				var type = $("input[name='userType']:checked").val();
				if(type == "abo"){
					$.userType.showAbo();
				}else if(type == "member"){
					$.userType.showMember();
				}else{
					$(".abo").hide();
					$(".member").hide();
				}
			},
			showAbo : function(){
				$(".abo").show();
				$(".member").hide();
				
				$("#name").val("");
				$("#birthday").val("");
				$("#mobile").val("");
				$("#castMobile").val("");
			},
			showMember : function(){
				$(".abo").hide();
				$(".member").show();
			}
	},
	$.findSendInfo = {
			format : {
				get : function(sVal){
					return sVal+"<br>으로 인증번호를 전송해 드립니다.";
				},
				set : function(el, sVal){
					$(el).html("").append(sVal);
				}
			},
			init : function(){
				var element = $("input[name='userCode']");
				// 선택된 값이 없어나 회원아이디가 한개 이상일 경우
				if($(element).length > 1 && !$(element).is(":checked")){
					return;
				}
				
				$.findSendInfo.format.set($("p#sms"), $.findSendInfo.format.get($(element).data("sms")));
			},
			select : function(el){
				$.findSendInfo.format.set($("p#sms"), $.findSendInfo.format.get($(el).data("sms")));
			}
	},
	$.moveResultPage = function(){
		var code;
		if($("input[name='userCode']").attr("type")=="radio"){
			code = $("input[name='userCode']:checked").attr("id");
		}else{
			code = $("input[name='userCode']").attr("id");
		}
		
		if(code == null || code.length <= 0) return;
		$("#authCerifyForm #name").val(code);
		$("#authCerifyForm").submit();
	},
	$.email = {
		init : function(){
			if($.trim($("#email01 option:selected").val()).length > 0){
				$("#email03").attr("readonly", "readonly")
			}
		}
	},
	$.menulock = {
		init : function(){
			$(".login").hide();
			$(".lockPw").hide();
		}
	},
	//전자세금 계산서
	$.taxBill = {
		init : function(){
			$("#email").val("");
			$("select#mobile01").find('option:first').attr('selected', true);
			$("#mobile02").val("");
			$("#mobile03").val("");
			$("input[name='adSms']:first").attr('checked', true);
		}
	}
})(jQuery)

//당사에 입금해주셔야 할 금액 발생 안내
$(document).on("click", "#accountReceivablePopup", function(){
	var popUrl = "/mypage/paymentinfo/popup/returnAmountGuide"
    $.windowOpener(popUrl, $.getWinName(), '');
});


$(document).on("click", "a#receiveInfoSave", function(e){
	$($(this).data("submit")).submit();
});

$(document).on("click", "#elecTax", function(){
	$.taxBill.init();
});

// Push 메시지리스트 pushMessage
$(document).on("click", "#pushMessage", function(){
	alert("pushMessage");
});

// 설정변경 alarmSetting
$(document).on("click", "#alarmSetting", function(){
	alert("alarmSetting");
});

$(document).on("click", "dl.detailData .aPointArea", function(){
	// location.href ="/mypage/point/a";
});

//전자(세금)계산서 수신정보 팝업열기
$(document).on("click", "#taxBillsReceiveInfoPopup", function(){
	var popUrl = "/mypage/taxBillsReceiveInfo"

    $.windowOpener(popUrl, $.getWinName(), "");
});

// 잠금 비밀번호 해제
$(document).on("click", "#checkPasswordBtn", function(){

	if($.trim($("#password").val()).length <= 0){
		alert($.getMsg($.msg.personalinfo.common.enterRequired, "잠금 비밀번호" ));
		$("#password").focus();
		return false;
	}
	
	$("#passwordEnteringForm").submit();
});

//잠금 비밀번호 변경 비밀번호
$(document).on("click", "#checkLoginPasswordBtn", function(){
	$(".passwordCheckFormForAuth").submit();
});



// 잠김비밀번호 재설정
$(document).on("click", "#changePasswordBtn", function(){
	$("#lockPwReSetting").submit();
});

//비밀번호 다음에 변경하기
$(document).on("click", "#nextChangeBtn", function(){
	nextChangePassword = true;
	$("#nextChangeForm").submit();
});

// 회원유형(abo, member)
$(document).on("click", "input[name='userType']", function(){
	if($(this).val() == "abo"){
		$.userType.showAbo();
	}else{
		$.userType.showMember();
	}
});

// 회원아이디 선택
$(document).on("click", "div.type02 input[type='radio']", function(){
	$("input[name='certifyType']").attr("checked", false);
	$.findSendInfo.select(this);
	$("#certifyDiv").hide();
	$("#userInfo").show();
	$(".postSendCertify").next().hide();
})

// 인증 구분
$(document).on("click", "input[name='certifyType']", function(){
	if($("input[name='userCode']").attr("type")=="radio" && $("input[name='userCode']").is(":checked") == false){
		return $(this).attr("checked", false);
	}
	
	$("#certifyDiv").show();
})

// 인증 후 결과 값
function fn_ReturnCertifyResult(iReturn, message){
    // 0 success
    // 1 systemerror
    // 2 process logic validation error
	if(iReturn == 1){
		alert($.msg.err.system);
	}else{
		$.certify.popupResult(iReturn);
	}
}

// 인증번호 전송
$(document).on("click", "#certifyDiv input:button", function(){
	$.certify.util.sendCertifyNum("personal");
});

// 인증번호 확인
$(document).on("click", "#checkCertifyNum", function(){
	if(($.certify.data.time + 1) <= 0){
		alert($.msg.signup.timeOverCertificationNum);
		return false;
	}
	
	if($.trim($("#cfNumber").val()).length != 6 ){
		alert($.msg.signup.inputCertificationNum);
		$("#cfNumber").focus();
		return false;
	}
	
	if($("#cfNumber").val() == $.certify.data.certifyNum){
		$("#checkCertify").val("true");
		clearTimeout(_transition);
		$.certify.data.init();
		
		$.moveResultPage();
	}else{
		alert($.msg.signup.inputWrongCertificationNum);
		$("#cfNumber").focus();
		return false;
	}
});

// 후원자 조회
$(document).on("click", "#searchSponsor", function(){
	var sponNum = $.trim($("#inputSponsorNo").val());
	
	if(sponNum == null || sponNum.length <= 0 || /\D/.test(sponNum)){
		alert($.getMsg($.msg.personalinfo.common.enterRequired, "후원자 번호" ));
		$("#sponsorName").val($.msg.personalinfo.common.noSearchResult);
		$("#inputSponsorNo").focus();
		
		return;
	}
	loadingLayerS();
	$.comm.searchSponsor(sponNum, function(data){
		if(data.result == true)
		{
			alert($.msg.personalinfo.common.complete);
			$("#sponsorName").val(data.sponsorName);
			$("#sponserNo").val(data.sponsorNo);
			loadingLayerSClose();
		}
		else
		{
			alert(data.message);
			$("#sponsorName").val($.msg.personalinfo.common.noSearchResult);
			$("#sponserNo").val("");
			loadingLayerSClose();
		}
	}, function(){
		alert($.msg.err.system);
		loadingLayerSClose();
	});
});

//후원자 정정 저장
$(document).on("click", "#saveChangeSponsor", function(){
	
		
	if($.trim($("#sponserNo").val()).length <= 0){
		alert($.getMsg($.msg.personalinfo.common.enterRequired, "후원자 번호" ));
		$("#inputSponsorNo").focus();
		return;
	}
	
	if($.trim($("#loginPassword").val()).length <= 0){
		alert($.getMsg($.msg.personalinfo.common.enterRequired, "비밀번호" ));
		$("#loginPassword").focus();
		return;
	}
	
	if(confirm($.msg.personalinfo.common.saveInfo)){
		loadingLayerS();
		$("#password").val($("#loginPassword").val());
		
		$.ajaxUtil.postAjaxForm($("#lynxRegisterForm"), $.comm.ajaxUrl.changeSponsor, function(data){
			if(data.result == true){
				loadingLayerSClose();
				location.href ="/mypage/personalinfo/basicInfoSearch";
			}else{
				loadingLayerSClose();
				$.ajaxUtil.errorMessage(data);
			}
		});
	}
})

// 후원자 정정 popup
$(document).on("click", "#sponsorChangeRequest", function(e){
	e.preventDefault();
	
	var formData = $("#sponsorChangeForm").serialize() || null;
	$.ajaxUtil.executeAjax("POST", $.comm.ajaxUrl.sponsorChangeStatus, "json", formData, function(data){
		if(data && data.failProcessed == true && data.status == "APPROVED"){
			$.ajaxUtil.executeAjax("POST", $.comm.ajaxUrl.sponsorChangeRetry, "json", formData, function(){}, function(){});
			alert($.msg.sponsor.processing);
		}else{
			window.location.href="/mypage/sponsor-change/request";
		}
	}, function(){
		window.location.href="/mypage/sponsor-change/request";
	});
})

//기본정보 수정
$(document).on("click", "#updateInfo", function(){
	$($(this).data("submit")).submit();
});

//부가정보 수정
$(document).on("click", "#additionInfoUpdate", function(){
	if(confirm($.msg.personalinfo.common.saveInfo)){
		loadingLayerS();
		
		$.ajaxUtil.postAjaxForm($("form"), $.comm.ajaxUrl.changeMyAdditionInfo, function(data){
			if(data.result == true){
				loadingLayerSClose();
				alert($.msg.personalinfo.common.saved);
				window.location.href = data.path;
			}else{
				loadingLayerSClose();
				$.ajaxUtil.errorMessage(data);
			}
		});
		
		return false;
	}
});

//후원수당 수신 방법 선택 변경
$(document).on("click", '#typeChange',function(){
	$($(this).data("submit")).submit();
});


//마케팅/홍보 목적의 개인정보 수집 및 이용 동의
$(document).on("click", '#agreementUpdate',function(){
	$($(this).data("submit")).submit();
});


// 회원정보 수정 취소
$(document).on("click", "#cancelInfo", function(){
	history.back();
});

$(document).ready(function(){
	$.pageInit();
});

//$.menulock.init();
// $.certify.popup();