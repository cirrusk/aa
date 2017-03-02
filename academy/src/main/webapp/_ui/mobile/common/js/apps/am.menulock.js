var checkRequired = false;

(function($) {
	$.menulock = {
			init : function(){
				
				// checkRequired true인 경우 필수 체크
				if($("#menuLockUse1").length && $("#menuLockUse1").prop("type") == "hidden")
				{
					checkRequired = true;
				}
				
				// 본인확인
				if($("#personallyCertify").length){
					personallyCertify = null;
					personallyCertify = new certify({
						init : function(){
							// 모바일 본인 인증 화면 전환 후 처리
							if($("#certifyPost").val() == "true")
							{
								if($.trim($("#certifyErrMessage").val()).length <= 0)
								{
									this.processCertify(this);
								}
								else
								{
									this.applyInitCertify();
									
									if($("input#failView").length){										
										$(".authInit").hide();									
										$(".authFail").show();
									}
								}
							}
							else
							{
								this.applyInitCertify();
							}
						},
						initCertify : function(){
							$("div.authOk").hide();
							$("#password").val("");
						},
						observer : [$("#password")],
						observerInit : function(){
							$("div.authOk").hide();
						},
						successCertify : function(){
							$("div.authOk").show();
						}
					});
					
					$("a.certifyPopup").bind("click", function(){					
						personallyCertify.applyInitCertify();
					});
				}
				
				$.menulock.validation();
			},
			isRequired : function(element){			
				
				if($("input[name='menuLockUse']").length && $("#menuLockUse1").prop("type") != "hidden"){
					if(element){
						if($.trim($(element).val()).length >= 1){return true;}
						if($(element).hasClass("noRequired")){ return false;}
					}
					return !$("input[name='menuLockUse']").is(":checked");
				}
				
				return checkRequired;
			},			
			validation : function(){
				// 잠금비밀번호 본인확인 ( 잠금 비밀번호 입력 )
				if($("#authPasswordDiv #password").length){
					$("#authPasswordDiv #password").rules( "add", {
						required : {
							param : true,
			    			depends : function(element){
			    				return (personallyCertify && personallyCertify.getStatus() == false);
			    			}
						},				
						messages: {
							required : $.msg.personalinfo.menuLock.checkPassword
						}
					});			
				}
				
				// 잠금비밀번호 본인확인 ( 휴대폰, 아이핀 인증 )
				if($("#personallyCertify").length){
					$("#personallyCertify").rules( "add", {
						certify : {
							param: personallyCertify,
			    			depends : function(element){
			    				return $.trim($("#authPasswordDiv #password").val()).length <= 0;
			    			}
						},
						messages: {
							certify : "본인확인을 먼저 해 주세요."
						}
					});			
				}	
				
				if($("#menuLockBoxCheck").length){
					$("#menuLockBoxCheck").rules( "add", {
						menuCheck : {
							param : true,
			    			depends : function(element){
			    				return $.menulock.isRequired();
			    			}					
						},
						messages: {
							menuCheck : $.msg.personalinfo.menuLock.checkMenu	
						}
					});	
				}
				
				if($("div.passwordEditDiv #password").length){
					$("div.passwordEditDiv #password").rules( "add", {
						required: {
							param : true,
			    			depends : function(element){
			    				return $.menulock.isRequired(element);
			    			}
						},
						continuationPasswordCheck : {
							param : true,
			    			depends : function(element){
			    				return $.menulock.isRequired(element);
			    			}							
						},
						onlyNumber : {
							param : true,
			    			depends : function(element){
			    				return $.menulock.isRequired(element);
			    			}
						},
						messages: {
							required : $.getMsg($.msg.personalinfo.menuLock.passwordRequired, "잠금 비밀번호"),
							continuationPasswordCheck : $.msg.personalinfo.menuLock.doNotPasswordRepeatWord
						}
					});
				}
				
				if($("div.passwordEditDiv #confirmPassword").length){
					$("div.passwordEditDiv #confirmPassword").rules( "add", {
						required: {
							param : true,
			    			depends : function(element){
			    				return $.menulock.isRequired($("div.passwordEditDiv #password"));
			    			}
						},
						equalTo : "div.passwordEditDiv #password",
						messages: {
							required : $.getMsg($.msg.personalinfo.menuLock.passwordRequired, "잠금 비밀번호 확인"),
							equalTo  : $.getMsg($.msg.personalinfo.menuLock.equalToPassword,   "잠금 비밀번호가 서로")
						}
					});	
				}					
			},			
			// 메뉴 그룹의 메뉴 전체 선택(해제)
			allClick : function(element){
				$("input."+ $(element).attr("id")).attr("checked", $(element).is(":checked"));
			},
			// 메뉴 그룹 전체 선택 해제
			releaseAll : function(element){
				if($(element).is(":checked") == false){
					$(element).parent().parent().parent().find(".allSelect").attr("checked", false);
				}
			},
			// 잠금 메뉴 사용 안함
			noMenuLock : function(element){				
				$("input.passwordEdit").attr("disabled", $(element).is(":checked")); 							// 잠금 비밀번호 설정
				$("div.menuBox input[type='checkbox']").attr("disabled", $(element).is(":checked")); 	// 잠금 메뉴 선택
				
				if($(element).is(":checked") == true){
					$("input.passwordEdit").val("");
					$("div.menuBox input[type='checkbox']").attr("checked", false);
				}				
			}
	}
})(jQuery);

// 잠금 메뉴 전체 선택
$(document).on("click", ".allSelect", function(){
	$.menulock.allClick(this);
});

//잠금 메뉴 전체 선택 해제
$(document).on("click", ".menuBoxCheck", function(){
	$.menulock.releaseAll(this);
});

//잠금 메뉴 사용 유무 선택
$(document).on("click", "input[name='menuLockUse']", function(){
	$.menulock.noMenuLock(this);
});

// 잠금 메뉴 설정 저장
$(document).on("click", "#saveMenuLock", function(){
	$("#menuLockEditForm").submit();
})

// 잠금 메뉴 본인 확인 실패 후 이전 버튼 클릭
$(document).on("click", "#authFailBtn", function(){
	$(".authInit").show();									
	$(".authFail").hide();
})

// 잠금 메뉴 재설정 본인확인
$(document).on("click", "#menuLockAuthForm #findingBtn", function(){
	$("#menuLockAuthForm").submit();
})

$("document").ready(function(){
	$.menulock.init();
});