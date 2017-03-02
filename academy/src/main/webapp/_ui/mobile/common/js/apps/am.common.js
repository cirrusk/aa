(function($){
	$.fn.NextFocus = function(nextSelect, maxVal) {
		$(this).keyup(function(e) {
			if(maxVal && $(this).val().length == maxVal){
				e.preventDefault();
				nextSelect.focus();
			}
		});
		
		$(this).keydown(function(e) {
			if(e.which == 13){
				e.preventDefault();
				nextSelect.focus();
			}
		});
	},	
	$.fn.moveCenterView = function(){
		   var offsetTop = $(this).offset().top;
		   var adjustment = Math.max(0,( $(window).height() - $(this).outerHeight(true) ) / 2);
		   var scrollTop = offsetTop - adjustment;

		   $('html,body').animate({scrollTop: scrollTop}, 200);
	},
	$.ajaxUtil = {
		executeAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
			$.ajax({
				type : type || "POST",
				url  : url,
				dataType : dataType || "json",
				data : data,
				success : function(data) {
					if( typeof successCallBack === 'function' ) { successCallBack(data); }
					return;
				},
				error : function() {
					if( typeof errorCallBack === 'function' ) { return errorCallBack(); }
					
					loadingLayerSClose();
					return alert($.msg.err.system);
				},
				complete : function(){
					loadingLayerSClose();
				}
			});
		},
		postAjaxForm : function(form, url, successCallBack, errorCallBack){
			$.ajax({
				type : "POST",
				url  : url,
				dataType : "json",
				data : form.serialize(),
				success : function(data) {
					if( typeof successCallBack === 'function' ) { successCallBack(data); }
					return;
				},
				error : function() {
					if( typeof errorCallBack === 'function' ) { 
						return errorCallBack(); 
					}
					
					loadingLayerSClose();
					return alert($.msg.err.system);
				},
				complete : function(){
					loadingLayerSClose();
				}
			});
		},	
		errorMessage : function(data){
			// 세션에 담긴 uid가 삭제되었을 경우
			$.each(data, function(key, value){
				if(key != "result" && key != "message"){
					
					alert(value.replace(/\{\d\}/gi, ""));

					if($("#" + key).length){
						$("#" + key).focus();
					}else if($("*[name^='"+ key + "']")){
						$($("*[name^='"+ key + "']")[0]).focus();
					}
					return false;
				}
			})			
		}
	},	
	$.comm = {
			ajaxUrl : {
				ssnCertifyForResign 	: "/account/certify/ajax/resign/ssn-certify",
				ssnCertify        		: "/account/certify/ajax/ssn-certify",
				sendCertifyNum    		: "/account/certify/ajax/send/certification-num",
				checkPassword     		: "/account/certify/ajax/check-password",
				dupUser           		: "/account/signup/ajax/duplication/user",
				dupMemberid       		: "/account/signup/ajax/duplication/memberid",
				searchSponser     		: "/account/signup/ajax/search/sponser",
				accountNum        		: "/account/signup/ajax/accountNumber-certify",
				changePwRecommend 		: "/account/password/ajax/recommend-change",
				changePwReset     		: "/account/find/ajax/reset-password",
				changeMenuPw      		: "/account/menulock/ajax/reset-password",
				changePwMypage    		: "/mypage/password/ajax/change",
				changeMyBasicInfo 		: "/mypage/personalinfo/ajax/update/basicInfo",
				changeMyAdditionInfo 	: "/mypage/personalinfo/ajax/update/additionalInfo",
				changeMyAgreeInfo 		: "/mypage/personalinfo/ajax/update/terms",
				changeSponsorType 		: "/mypage/personalinfo/ajax/update/sponsorBenefitNotifyType",
				menuLockEdit      		: "/mypage/menulock/ajax/setup/menu",
				changeSponsor     		: "/mypage/personalinfo/ajax/sponsor-change",
				taxBillsReceiveInfoPage	: "/mypage/ajax/taxBillsReceiveInfo",
				menuLockEdit      		: "/mypage/menulock/ajax/setup/menu",
				changeUseAgreement 		: "/mypage/personalinfo/ajax/use-agreement",
				changeAccount 			: "/mypage/paymentinfo/popup/ajax/returnAmountGuide/notView",
				checkMenuLockAuth    	: "/mypage/menulock/ajax/setup/menu/auth",
				sponsorChangeRequestSave	: "/mypage/sponsor-change/request/ajax/save",
				sponsorChangeRequestCancel	: "/mypage/sponsor-change/request/ajax/cancel",
				sponsorChangePreSponsor : "/mypage/sponsor-change/request/ajax/pre-sponsor"	,
				sponsorChangeApprovalSave	: "/business/record/sponsor-change/approval/ajax/save",
				sponsorChangeApprovalListGet: "/business/record/sponsor-change/approval/ajax/list",
				sponsorChangeStatus		: "/mypage/sponsor-change/request/ajax/process-status",
				sponsorChangeRetry		: "/mypage/sponsor-change/request/ajax/retry"
			},			
			util : {
				isAdult: function(brithDate){
					var crrDate = new Date();
					var crrYear = (crrDate.getFullYear()-19).toString();
					var crrMonth = crrDate.getMonth()+1;
					var crrDate = crrDate.getDate();
					crrMonth = crrMonth < 10 ? "0"+crrMonth.toString() : crrMonth.toString();
					crrDate = crrDate < 10 ? "0"+crrDate.toString() : crrDate.toString();
					
					if ((parseInt(crrYear+crrMonth+crrDate) - parseInt(brithDate)) < 0){
						return false;
					}
					return true;
					
				},
				castPhone: function(orgPhone){
					// 자릿수가 7자리 미만 && 8자리 초과 
					if(orgPhone.length < 7 && orgPhone.length > 8){
						return "";
					}else{
						// 숫자 이외의 값이 있을 경우 
						if(/[^\d]/g.test(orgPhone)){
							return "";
						}
					}
					var regex = /(\d{3,4})(\d{4})/gi;
					return orgPhone.replace(regex, "$1-$2");
				}
				
			},
			inputFormat : function(){
				$("input#birthday").inputOnlyNumber();
				$("input#mobile").inputOnlyNumber();
				
				
				// 주민등록 번호 only 숫자 입력
				$("#realNameCheckTable .ssnInput").inputOnlyNumber();
				$("#realNameCheckTable .ssnInput").attr("autocomplete", "off");
				
				$(".checkRealNameInput .ssnInput").inputOnlyNumber();
				
				$("#name").inputOnlyKorean();
				$("#realNameCheckTable #name").NextFocus($("#realNameCheckTable #ssn1"));
				$("#ssn1").NextFocus($("#ssn2"), 6);
				$("#realNameCheckTable #ssn2").NextFocus($("#realNameCheckTable #realNameCkBtn"));
				

				//후원자 ABO번호 only 숫자 입력
				$("input#sponserNo").inputOnlyNumber();
				$("input#internationalSponsorNo").inputOnlyNumber();
				$("input#inputSponsorNo").inputOnlyNumber();
				
				//전화번호 only 숫자 입력
				$("input#mobile02").inputOnlyNumber();
				$("input#mobile03").inputOnlyNumber();
				$("input#home02").inputOnlyNumber();
				$("input#home03").inputOnlyNumber();
				$("input#partnerMobile02").inputOnlyNumber();
				$("input#partnerMobile03").inputOnlyNumber();
				
				//계좌번호 only 숫자 입력
				$("input#accountNumber").inputOnlyNumber();
				
			    $("#mobile02").attr("maxlength", "4");
			    $("#mobile03").attr("maxlength", "4");
			    $("#home02").attr("maxlength", "4");
			    $("#home03").attr("maxlength", "4");
			    $("#partnerMobile02").attr("maxlength", "4");
			    $("#partnerMobile03").attr("maxlength", "4");
			    
			    //이름 한글 입력
			    new beta.fix("input#name");
			    
			    //영문이름 ime-mode 추가
//			    $("#englishName").css("ime-mode", "disabled");
			},
			searchSponsor : function(sponsorNo, fnSuccess, fnError){
				$.ajax({
					type:"GET",
					url: $.comm.ajaxUrl.searchSponser,
					dataType: "json",
					data: "sponserNo="+sponsorNo,
					success: function (data)
					{	
						fnSuccess(data);
					},
					error: function (data){
						fnError
					}
				});		
			},
			address : {
				open : function(fn_call){
					if(typeof fn_call == 'undefined' || fn_call == null){
						fn_call = "$.comm.address.collback";
					}
					var popUrl = "/account/find/address?callback=" + fn_call;
					var popOption = "width=772, height=630, scrollbars=yes, menubar=no, status=no, resizale=no";
				    
				    $.windowOpener(popUrl, $.getWinName(), popOption);
				},
				callback : function(address){
					$("#koreaAddressType").val(address.addrType);

					var regex = /(\d{3})(\d{3})/gi;
					var zipCode = (address.zipCode).replace(regex, "$1-$2");
					$("#postalCode").val(zipCode);
					
					$("#line1").val(address.addr1);
					$("#line2").val(address.addr2);
					$("#town").val(address.wideNm + " " + address.cityNm);
					$("#streetNumber").val(address.buildNm);
					
					if(address.addrType == "NUMBER"){
						$("#streetName").val(address.sectionNm);
						$("#addressText").val(address.addr1 +" "+ address.addr2);
					}else{
						$("#streetName").val(address.streetNm);
						$("#addressText").val(address.addr1 +" "+ address.addr2);
					}

					//20160401 고문석 우편번호5자리 변경 프로젝트
					$("#dongCode").val(address.dongCode);
					$("#buildingManNum").val(address.buildingManNum);
					$("#formattedAddress").val(address.addrFull);
					$(".addressInfo").text(address.addrFull);
					$("#building").val(address.addr3);
					
				}
			},
			agreement : {
				init : function(){
					//전화번호 수집에 동의
					if($("#homeAgree1").is(':checked') || $("#homeAgree1").length <= 0){
						$("#homeArea .labelBlock").show();
				    	$("#homeArea .inputBoxBlock").show();
					}
					//파트너 전화번호 수집 동의
					if($("#partnerMobileAgree1").is(':checked') || $("#partnerMobileAgree1").length <= 0){
				    	$("#partnerMobileArea .labelBlock").show();
				    	$("#partnerMobileArea .inputBoxBlock").show();
					}
					//주소 수집에 동의
					if($("#addressAgree1").is(':checked') || $("#addressAgree1").length <= 0){
						$("#addressArea").show();
						$("#addressArea .labelBlock").show();
//				    	$("#addressArea .inputBoxBlock").show();
				    	$("#addressArea .btnWrap.aNumb2").show();
				    	$("#addressArea .addressInfo.olnyBg").show();
					}
					
				}
			},
			myMessage : {
				styles : function(element){ //element = $(element)
					var styles = {
						"word-break": "break-all"
						, "overflow": "hidden"
						, "display": "-webkit-box"
						, "-webkit-line-clamp": "3"
						, "-webkit-box-orient": "vertical"
						, "line-height": "1.5em"
						, "max-height": "4.35em"
					};
					element.css(styles);
				}
			}
	}

})(jQuery)

//팝업창 닫기
$(document).on("click", "a.popupClose", function(){
	window.close();
});

//다음 페이지로 이동
$(document).on("click", "a#nextStep", function(e){
	e.preventDefault();
	try{_validationFlag ="submit";}catch(e){}

	//$.amwayHash.setHash();
	$($(this).data("submit")).submit();
});

var click = 0;
//다음 페이지로 이동 ( 회원가입 )
$(document).on("click", "a#nextStepSignup", function(e){
	e.preventDefault();
	
	// 중복 클릭 방지
	if($(this).data("submit") == "#signInfo"){
		if($("a#nextStepSignup").attr("href") != '#'){
			return false;
		}
	}
	
	try{_validationFlag ="submit";}catch(e){}
	
	if($(this).data("submit") == "#signInfo"){
		$("a#nextStepSignup").attr("href", null);
	}
	
	$($(this).data("submit")).submit();
});

//이전 페이지로 이동
$(document).on("click", "a#prevStep", function(e){	
	if(personallyCertify && personallyCertify.getStatus()){
		e.preventDefault();
		personallyCertify.applyInitCertify();
	}
	return;
});

// 이메일 주소 직접 선택
$(document).on("change", "#email01", function(){
	$("#email03").val($(this).val());
	$.trim($(this).val()).length ? $("#email03").attr("readonly", "readonly") : $("#email03").removeAttr("readonly");
});

// 자녀수 : 자녀수 입력(부가정보)
$(document).on("change", ".children", function(){
	var total = 0;
	$("select.children").each(function(){
		total += parseInt($(this).find("option:selected").val().replace(/^d/g, "")) || 0;
	})
	
	$("#totalNumberOfChildren").val(total);
});

//전화번호 수집에 동의 이벤트
$(document).on("click", "#homeAgree1", function(){
	if ($(this).is(':checked')) {
		$("#homeArea .labelBlock").show();
    	$("#homeArea .inputBoxBlock").show();
    }else{
    	$("#homeArea .labelBlock").hide();
    	$("#homeArea .inputBoxBlock").hide();
        $("#homeArea input").each(function(){
        	$(this).val("");
        });
        $("#homeArea select").find('option:first').attr('selected', true);
    }
});

//파트너 전화번호 수집에 대한 이벤트
$(document).on("click", "#partnerMobileAgree1", function(){
	if ($(this).is(':checked')) {
		$("#partnerMobileArea .labelBlock").show();
    	$("#partnerMobileArea .inputBoxBlock").show();
    }else{
    	$("#partnerMobileArea .labelBlock").hide();
    	$("#partnerMobileArea .inputBoxBlock").hide();
        $("#partnerMobileArea input").each(function(){
        	$(this).val("");
        });
        $("#partnerMobileArea select").find('option:first').attr('selected', true);
    }
});

//주소 수집에 동의 이벤트
$(document).on("click", "#addressAgree1", function(){
	if ($(this).is(':checked')) {
		if($("#addressArea .agreeCheck .info #addressAgree1").length){
			$("#addressArea .labelBlock").show();
	    	$("#addressArea .btnWrap.aNumb2").show();
	    	$("#addressArea .addressInfo.olnyBg").show();
		}else{
			$("#addressArea").show();
		}
    }else{
    	if($("#addressArea .agreeCheck .info #addressAgree1").length){
    		$("#addressArea .labelBlock").hide();
        	$("#addressArea .btnWrap.aNumb2").hide();
        	$("#addressArea .addressInfo.olnyBg").hide();
		}else{
			$("#addressArea").hide();
		}
    	$(".addressInfo.olnyBg").text("");
    	$("#addressArea input").val("");
    }
});

// 주소 검색
$(document).on("click", "#addressSearch", function(fn_call){
	$.comm.address.open(fn_call);
})

$(document).on("click", 'a[href^="#uiLayerPop_"]', function(){
	layerPopupOpen(this);
});

//도로명 주소로 검색
$(document).on("click", 'a[href="#addressLayerPop"]', function() {
	
	if($(this).attr("id") == 'lotnumAddrSearch'){
		$.address.openLayerPopLotnumAddr();
		$.address.clickNewLotnumAddrTab();
	}else{
		$.address.openLayerPopRoadAddr();
		$.address.clickNewRoadAddrTab();
	}
	
});

$("document").ready(function(){
	
	//--------------------------------------------------------------------------
	//	errMessageBox service에서 validation 결과 오류가 있을 경우
	//-----------------------------------------------------------------------------------------
	var errMessageBox = $("span.errorMessageBox[id$=errors]");
	if(errMessageBox.length){
		alert(errMessageBox.html().replace(/\<br\>.*$/, "").replace(/^\s*/, ""));
		var oElement = errMessageBox[0].id.replace(".errors","").replace(/([\.|\[|\]])/g, "\\$1");
		oElement = $("#" + oElement) || $("[name^="+ oElement +"]");
		if(oElement && oElement.length)
		{
			if(oElement.hasClass("notFocus")!=true)
			{
				oElement.moveCenterView();
				oElement.focus();
			}
		}
	}
	
	$.comm.inputFormat();		
	$.comm.agreement.init();

});	