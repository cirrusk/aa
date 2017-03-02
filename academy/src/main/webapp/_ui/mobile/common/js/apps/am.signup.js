/**
 * 회원가입 단계별 프로세스
 */

//$.backForward.checkPageBack();
  
//인증 후 리턴 값
function fn_ReturnCertifyResult(bRtn, sMessage, oData){
	if(bRtn == 0){
		userName = oData.name || "";
		userBirthDate = oData.birthDate || "";
		userGender = oData.gender || "";
		
		personallyCertify.processCertify();
	}else{
		alert(sMessage);
		personallyCertify.applyInitCertify();
	}
}

(function($){
	$.signup = {
		init : function(){
			// 1. 부사업자(배우자) ABO 등록 여부
			registerPartner = $("#registerPartner").val() == "true" ? true : false;
			// 국제후원자 설정
			if($("input[name='internationalSponsorType']").length){
		    	$("input[name='internationalSponsorType']:first").attr('checked', true);
		    	$("input[name='internationalSponsorType']:last").addClass("mglS");
		    }
			
			//member ui : 성별 간격을 주기위한 class 추가
		    if($("input[name='gender']").length){
		    	$("#gender1").next().addClass("mgSet");
		    }
		    
		    //주소값 보여주기
		    if($("#formattedAddress").length){
				$(".addressInfo.olnyBg").text($("#formattedAddress").val());
			}
		    
		    if($("#showLoding").length){
		    	$.signup.lodingUtil.init();
		    }
		},
		lodingUtil : {
			init : function(){
				var loadImg = $('<div class="loadingS hide" id="loadingS"><img src="/_ui/mobile/images/common/loading_s.gif" alt="로딩중"></div>');
				var layerM  = $('<div class="loadMask  hide" id="loadMask" style="display:block"><img src="/_ui/mobile/images/common/bg_loading.png" alt=""></div>');
				if (loadImg.length){
					$('#loadingS').remove();
					$('#loadMask').remove();
				}
				$('body').append(loadImg);
				loadImg.before(layerM);
			},
			close : function(){
				$('#loadingS').addClass("hide");
				$('#loadMask').addClass("hide");
			},
			show : function(){
				$('#loadingS').removeClass("hide");
				$('#loadMask').removeClass("hide");
			}
		},
		checkMobileNum : function(mobile01, mobile02, mobile03){
			var result = true;
			if(!mobile01.children("option:selected").val()){
				alert($.getMsg($.msg.common.inputDetail, "휴대폰번호를"));
				mobile01.focus();
				result = false;
				return false;
			}
			
			var arrayMobile = new Array(mobile02, mobile03);
			
			for (var index=0 ; index < arrayMobile.length ; index++){
				var value = arrayMobile[index].val();
				if(!value){
					alert($.getMsg($.msg.common.inputDetail, "휴대폰번호를"));
					arrayMobile[index].focus();
					result = false;
					return false;
				}
				
				if(/D/g.test(value)){
					alert($.msg.personalinfo.common.inputIncorrectInfo);
					arrayMobile[index].focus();
					result = false;
					return false;
				}
				
				if(arrayMobile[index].attr("id") == "mobile02"){
					if(value.length < 3 || value.length > 4){
						alert($.msg.personalinfo.common.inputIncorrectInfo);
						arrayMobile[index].focus();
						result = false;
						return false;
						
					}
				}else{
					if(value.length != 4){
						alert($.msg.personalinfo.common.inputIncorrectInfo);
						arrayMobile[index].focus();
						result = false;
						return false;
						
					}
				}
			}
			return result;
		}
	}
	
})(jQuery);

//약관 팝업
$(document).on("click", "a.termAgreePopup", function(){
	var popupUrl = "/account/signup/agree/popup?versionId="+$(this).data("versionid"); 
	$.windowOpener(popupUrl, $.getWinName(), "");
	return false;
});

//일괄동의 이벤트(일괄 동의, 동의 안함 체크 후 각각 항목의 동의 여부가 변경되면 일괄 동의, 동의안함 리셋)
$(document).on("click", "input[name$='agree']", function(){
	if($(this).val() != $("input[name='agreeTotalYN']:checked").val()){
		$("input[name='agreeTotalYN']").attr("checked", false);
	}
});

$(document).on("click", "input.sendCertify", function(){
	$("#cfNumber").val("");

	//휴대폰번호 체크
	if(!$.signup.checkMobileNum($("#mobile01"), $("#mobile02"), $("#mobile03") )){
		return false;
	}

	$.certify.util.sendCertifyNum("signup");
	return false;
	
	
});

$(document).on("click", "#checkCertifyNum", function(){
	if(($.certify.data.time + 1) <= 0){
		alert($.msg.signup.timeOverCertificationNum);
		return false;
	}
	
	if($.trim($("#cfNumber").val()).length != 6){
		alert($.msg.signup.inputCertificationNum);
		$("#cfNumber").focus();
		return false;
	}
	
	if($("#cfNumber").val() == $.certify.data.certifyNum){
		$("#timeView").hide();
		$("#checkCertify").val("true");

		clearTimeout(_transition);

		$.certify.data.time = $.certify.data.limitMin;
		$.certify.data.limitTime = new Date().setMilliseconds($.certify.data.limitMin);
		
		$.certify.util.serverCertify();
	}else{
		alert($.msg.signup.inputWrongCertificationNum);
		$("#cfNumber").focus();
		return false;
	}
	
});

// 국제 후원자 선택시 popup open
$(document).on("click", "input[name='internationalSponsorType']", function(){
	var interSponType = $(this).val();
	
	if(interSponType == 'BUSINESS'){
		
		$("#interSponsorPopup").trigger("click");
		
	    $("input[name='internationalSponsorType']:first").attr('checked', true);//국제후원자 다시 선택
	}
});

$(document).on("click", "p.agreeTotalYN input:radio", function(){
	//-------- signup 1단계 약관동의 ------------------------------------------------------------------
	//	1. 약관 동의 전체 동의, 동의안함 선택
	//-----------------------------------------------------------------------------------------------
	// 약관, 동의서, 유의사항 전체 동의, 동의안함 선택 (1단계, 3단계)
	$("p.agreeBoxYN input:radio[value='"+ this.value + "']").attr('checked', true);
});

$(document).on("click", "#conversionBtn", function(e){
	if($("#aboAgreeYes").is(":checked") != true){
		e.preventDefault();
		alert("Member 포인트 소멸 확인 내용에  “동의” 하셔야 ABO로 전환할 수 있습니다");
		$("input#aboAgreeYes").focus();
		return;
	}
	
	$("#conversionForm").submit();
});

function loding(){

}

$("document").ready(function(){
	window.name ="Parent_window";
	$.certify.addEvent();
	$.signup.init();
});