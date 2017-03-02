$(document).on("click", "#loginBtn", function(){
	$("#loginBtn").attr("disabled", true);
	$("#loginPageForm").submit();
})

$(document).on("keydown", ".loginFormBtn", function(e){
	if(e.which == 13){
		$("#loginBtn").click();
	}
});

$("document").ready(function(){
	$.validator.setDefaults({
		ignoreTitle : true,
		focusCleanup : false, 
		focusInvalid : false, 
		onclick : false, 
		onkeyup : false,
		onfocusout : false,
		showErrors : function(errorMap, errorList){
			if(errorList[0]){
				var oError = errorList[0];
				alert(oError.message);
				$(oError.element).focus();
				
				$("#loginBtn").attr("disabled", false);
			}
		}
	});
	
	var oErrMessage = $("#errMessage");
	if(oErrMessage.val()){
		alert(oErrMessage.val().replace(/<br[^>]*>/gi, "\n"));
		oErrMessage.val("");
	}
	
	// 로그인 페이지
	$("#loginPageForm").validate({
		submitHandler: function(form){
			$.amwayHash.setHash();
			form.submit();
		},
		
		rules:{
			username : {
				required: true
			},
			password : {
				required: true
			}			
		},
		
		messages: {
			username : {
				required : $.getMsg($.msg.common.inputDetail, "아이디 또는 비밀번호를")
			},
			password : {
				required : $.getMsg($.msg.common.inputDetail, "아이디 또는 비밀번호를")
			}
		}
	});	
});