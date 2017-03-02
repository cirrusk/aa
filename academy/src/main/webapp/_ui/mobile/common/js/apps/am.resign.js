var _curResignStep; // 회원탈퇴 step

//$.backForward.checkPageBack();
$(window).bind("pageshow", function(event) {
    if ( event.originalEvent && event.originalEvent.persisted) {
         //history.forward();
    	 window.location.reload();
    }
});

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

// 회원탈퇴
(function($) {
	$.resign = {
			validation : {
					init : function(){
						$.validator.setDefaults({
							ignoreTitle 	: true,  focusCleanup 	: false, 
							focusInvalid 	: false, onclick 		: false, 
							onkeyup 		: false, onfocusout 	: false,
							showErrors 		: function(errorMap, errorList){
								if(errorList[0]){
									var oError = errorList[0];
									alert(oError.message);
									$(oError.element).focus();
								}
							}
						});
						
					    $("form.resignStep").validate({
							submitHandler: function(form){
								var lastConfirm = true;
								if($("form.lastStep").length){
									lastConfirm = confirm($.msg.resign.resignConfirm);
								}
								
								if(lastConfirm){
									form.submit();
								}
							}
						});
					    
						// 회원탈퇴 스탭에 따라 validation을 적용한다.
						switch(_curResignStep)
						{
							case "resignAgree" :
								$.resign.agree();
								break;
							case "resignAuth" :
							case "resignPartnerAuth" :	
								$.resign.auth();
								break;
						};
					}
			},
			agree : function(){
				$.validator.addMethod("agreeRequired", function(value, element, param) {
					
					var oElement = $("input[name='"+$(element).attr("name")+"']");
					
					if($(element).attr("name") == "resignationAgree"){
						//console.log($("input[name='resignationAgree']:checked").val());
						if(!$("input#agreeY").is(":checked")){
							return false;
						}
					}
					
					return oElement.is(":checked");
				}, $.msg.resign.termAgree);
				
				$.validator.addClassRules("agreeRequired", {agreeRequired:true});
			},
			auth: function(){
				$.validator.addMethod("certify", function(value, element, param) {
					return param.getStatus();
				}, $.msg.resign.authProcess);
				
		    	//성명
		    	$("#name").rules("add", {
		    		required : true,
		    		messages: {
						required : $.getMsg($.msg.resign.realNameCertify, '실명')
					}
		        });
		    	
		    	//주민등록번호
		    	$("#ssn1").rules("add", {
		    		required : true,
		    		messages: {
						required : $.getMsg($.msg.resign.realNameCertify, '주민등록번호')
					}
		    		
		        });
		    	
		    	//주민등록번호
		    	$("#ssn2").rules("add", {
		    		required : true,
		    		messages: {
						required : $.getMsg($.msg.resign.realNameCertify, '주민등록번호')
					}
		        });
		    	
		    	$("#personallyCertify").rules("add", {
		    		certify : {param: personallyCertify}
		        });
		    	
		    	$("#realNameCertify").rules("add", {
		    		certify : {param: realNameCertify}
		        });
			}
			
	}
})(jQuery);

$(document).on("click", "#cancelBtn", function()
{
	return;
})
					    
$(document).on("click", "#nextBtn", function(){
	if($("form.resignPasswordCheckFormForAuth").length)
	{
		$("form.resignPasswordCheckFormForAuth").submit();
		return;
	}
	
	$("form.resignStep").submit();
})

// AP안내 팝업
$(document).on("click", "#apInfo", function(){
	var popUrl = "/customer/apinfo";
	$.windowOpener(popUrl, $.getWinName(), '');
	return false;
});

$("document").ready(function(){
	_curResignStep = $("input#curResignStep").val();
	//console.log(_curResignStep);
	
	// 에러 메시지 호출 메시지 삭제
	if($.trim($("input#errorMessage").val()).length >= 1){
		alert($("input#errorMessage").val());
		$("input#errorMessage").val("");

	}

	$.resign.validation.init()
})

$.popupEvent = function(){
	var addEvent = 1;
}