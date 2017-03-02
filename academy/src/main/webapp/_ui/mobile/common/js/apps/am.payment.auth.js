$("document").ready(function(){
	$.payment = {
		url : {auth:"/mypage/paymentinfo/auth"},
		moveCertifyPage : function(path){
			$("form#paymentInfoForm #path").val(path);
			//console.log($("form#paymentInfoForm #path").val());
			$("form#paymentInfoForm").submit();
		},
		validation : {
			init: function(){
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
				
			}
		}
	}	
});

// 로그인 비밀번호 체크 화면으로 이동
$(document).on("click", "a.requiredCertify", function(e){
	e.preventDefault();
	//console.log("movePath: " + $(this).attr("href"));
	$.payment.moveCertifyPage($(this).attr("href"));
})

//취소
$(document).on("click", "#cancelInfo", function(){
	window.location.href = "/mypage/paymentinfo/";
})

//저장버튼 클릭 ( 계좌등록(삭제), 비밀번호 변경 )
$(document).on("click", "#paymentRegisterBtn", function(){
	$("form#paymentForm").submit();
})

//
$("document").ready(function(){
	$.payment.validation.init();
	
	$("#bankPassword").inputOnlyNumber();
	$("#confirmBankPassword").inputOnlyNumber();
	
})
