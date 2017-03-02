var _isAboConversion;
var _validationFlag = "submit";
var _transition;
var certifyCount = 0;


/**
 * 회원가입 단계별 프로세스
 */
// 인증
/*-----------------------------------------------------------------------------------*/
var personallyCertify; 		// 본인확인
var realNameCertify; 		// 실명인증
var emailCertify;			// 이메일인증
var accountNumberCertify; 	// 계좌번호인증
var sponsorCertify;			// sponsor 확인
var interSponsorCertify; 	// 국제 후원자 확인
var idCertify;				// 아이디 확인
var registerPartner;		// 부사업자(배우자) ABO 등록 여부

var userName;     // 본인인증 성명
var userBirthDate; // 본인인증 생년월일
var userGender;    // 본인인증 성별
/*-----------------------------------------------------------------------------------*/

var certify = function(){
	this.oCertify = null;
	this._status = 0; // 인증여부
	this.oElement = null; // 인증 체크 로직을 실행하는  element
	this.observerElements = new Array(); // 값으 변경될 경우 인증을 초기화 하는 element's
	this.fn_InitCertify = function(){}; // 인증값을 초기화할 경우
	this.fn_ObserverInit = function(){};
	this.fn_CheckCertify = function(){return true;}; // 인증 체크하는 로직
	this.fn_SuccessCertify = function(){this.setStatus(true);} // 인증 성공 시
	
	// 초기값을 구성한다.
	this.initialize.apply(this, arguments);
}

$(document).on("click", "#authPhonePopup", function(e){
	if(personallyCertify){
		personallyCertify.applyInitCertify(); //본인인증 초기화
	}

	$("#phoneCertifyForm").attr("action", "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb");
	$("#phoneCertifyForm").submit();
});

$(document).on("click", "#authIPinPopup", function(e){
	if(personallyCertify){
		personallyCertify.applyInitCertify(); //본인인증 초기화
	}		

	$("#ipinCertifyForm").attr("action", "https://cert.vno.co.kr/ipin.cb");
	$("#ipinCertifyForm").submit();
});

$.extend(certify.prototype, {
	initialize: function(data){
		if(data.oCertify){
			this.oCertify = data.oCertify;
		}
		
		if(data.initCertify){
			this.fn_InitCertify = data.initCertify;
		}
		
		if(data.observerInit){
			this.fn_ObserverInit = data.observerInit;
		}
		
		if(data.observer){
			var sub = this;
			for(var i=0; i < data.observer.length; i++){
				var element = data.observer[i];
				
				if(element.prop("tagName") == "INPUT"){
					$(element).bind('keyup', function() {
						sub.observerInit.call(sub, this);
					});
				}else if(element.prop("tagName") == "SELECT"){
					element.bind("change", function(){
						sub.observerInit.call(sub, this);
					});
				}else{
					element.on("click", function(){
						sub.observerInit.call(sub, this);
					});					
				}
				
			}
		}
		
		if(data.checkCertify){
			this.fn_CheckCertify = data.checkCertify;
		}
		
		if(data.successCertify){
			this.fn_SuccessCertify = data.successCertify;
		}
		
		if(data.oElement){
			var sub = this;
			this.oElement = data.oElement;
			//console.log("this--", this.oElement);
			this.oElement.on("click", function(){
				sub.processCertify.call(sub, this);
			});
		}
		
		// 인증 초기화하는 로직이 있을 경우
		if(data.init){
			data.init.apply(this);
		}		
	},
	getCertifyElement : function(){
		return this.oCertify;
	},
	getStatus : function(){
		return this._status == 1 ? true : false;
	},
	setStatus : function(bStatus){
		this._status = bStatus ? 1 : 0;
	},
	applyInitCertify : function(){
		this.setStatus(false);
		this.fn_InitCertify.call(this);
	},
	observerInit : function(oEl){
		this.setStatus(false);
		this.fn_ObserverInit.call(this, oEl);
	},
	processCertify : function(element){
		if(this.fn_CheckCertify(element)){
			this.setStatus(true);
			this.fn_SuccessCertify(element);
		}
	}
});

(function($) {
	$.certify = {
			sendCertifyNum : function(sUrl, oData, fnSuccess){
				$.ajax({
					type:"POST",
					url: sUrl,
					dataType: "json",
					data: oData,
					success: function (data)
					{	
						fnSuccess();
					},
					error: function(){
						$("#timeView").hide();
						$("#timeView").html($.certify.util.initViewLimitTime());
						clearTimeout(_transition);
						alert($.msg.err.system);
					}
				});				
			},	
			addEvent : function(){
				$(".postSendCertify").hide();
				$("#timeView").html($.certify.util.initViewLimitTime());
				
				var observers = [$("#mobile01"), $("#mobile02"), $("#mobile03"), $("input[name='userCode']")];
				for(var i=0; i < observers.length; i++){
					var element = observers[i];
					if(element.prop("tagName") == "INPUT"){
						if(element.attr("type") == "radio"){
							element.bind("click", function(){
								$.certify.util.observersInit();
							});							
						}else{
							element.bind("keyup", function(){
								$.certify.util.observersInit();
							});							
						}
					}else if(element.prop("tagName") == "SELECT"){
						element.bind("change", function(){
							$.certify.util.observersInit();
						});
					}else{
						element.bind("click", function(){
							$.certify.util.observersInit();
						});					
					}
				}
			},
			data : {
					baseViewFormat : "남은시간 : {0}분 {1}초",
					limitMin : 1000 * 60 * 3, // 제한 시간(3분)
					certifyNum : -999999,
					limitTime : new Date().setMilliseconds(1000 * 10 * 6), 
					time : 1000 * 60 * 3,

					init : function(){
						$.certify.data.certifyNum = $.certify.util.createNum();
						$.certify.data.time = $.certify.data.limitMin;
						$.certify.data.limitTime = new Date().setMilliseconds($.certify.data.limitMin);			
					}
			},
			util : {
					isForeigner : function(ssn2){
						var checkNum = ssn2.substring(0, 1) || "";
						if(/[12349]/.test(checkNum) == false){
							alert($.msg.signup.doNotRegisterForeigner);
							realNameCertify.setStatus(false);
							return true;
						}
						
						return false;
					},
					isNotAdult : function(checkAgeSsn1, checkAgeSsn2){
						//만 19세 미만 체크(현재 년도 - 태어난 년도 < 19)
						var tempAge;
						var century = checkAgeSsn2.substr(0,1);
						
						if(century < 3){
							tempAge = "19"+checkAgeSsn1.toString();
						}else if(century > 2 && century < 5){
							tempAge = "20"+checkAgeSsn1.toString();
						}else if(century > 5){
							alert($.getMsg($.msg.signup.doNotInputFormReConfirm, ["실명확인 정보가", "한글성명과 주민등록번호를"]));
							return true;
						}
						
						if ($.comm.util.isAdult(tempAge) != true){
							alert($.getMsg($.msg.signup.doNotRegisterMinor, "ABO"));
							realNameCertify.setStatus(false);
							return true;
						}
						return false;
					},
					isEnd : function(){
						return ($.certify.data.time + 1) <= 0;
					},
					lpad : function(originalstr, length, strToPad){
						originalstr = originalstr +"";
					    while (originalstr.length < length){
					        originalstr = strToPad + originalstr;
					    }
					    return originalstr;
					},
					createNum : function(){
						var rendomNum = Math.floor(Math.random() * 1000000)+100000;
						if(rendomNum>1000000){
							rendomNum = rendomNum - 100000;
						}	
						return rendomNum;
					},
					sendCertifyNum : function(flag){
						$(".authOk").hide();
						$("#checkCertifyNum").show();
						
						$("#sendCertify").hide();
						$("#resendCertify").show();
						$(".postSendCertify").show();
						$("#checkCertify").val("false");
						$("#serverCertify").val("false");		
						
						$.certify.data.init();
						
						$.certify.data.certifyNum = $.certify.util.createNum();
						if(flag == "signup"){
							$(".certifyForm #mobile").val(  $("#mobile01 option:selected").val()+ "-"  
									                      + $("#mobile02").val()+ "-" 
									                      + $("#mobile03").val());
						}else{
							var code;
							if($("input[name='userCode']").attr("type")=="radio"){
								code = $("input[name='userCode']:checked").attr("id");
							}else{
								code = $("input[name='userCode']").attr("id");
							}

							$(".certifyForm #code").val(code);
						}
						
						$(".certifyForm #certifyNum").val($.certify.data.certifyNum);
						
						var data =  $(".certifyForm").serialize();
						$(".certifyForm #certifyNum").val("");
						$.certify.sendCertifyNum($.comm.ajaxUrl.sendCertifyNum , data, function(){});	
						$.certify.util.timeStart();
						$.certify.util.transition();
						alert($.getMsg($.msg.signup.sendCertificationNum, "SMS로"));						
					},
					count : function(){
						$.certify.data.time = Math.round(($.certify.data.limitTime - (new Date()).getTime())/1000); 
						return $.certify.util.isEnd();
					},
					resetNum : function(){
						$.certify.data.certifyNum = -9999999;
					},
					timeStart : function(){
						$.certify.data.limitTime = new Date().setMilliseconds($.certify.data.limitMin)
					},
					serverCertify : function(){
						$(".authOk").show();
						$("#checkCertifyNum").hide();
						$("#serverCertify").val("true");						
					},
					transition : function(){
						if($.certify.util.count()){
							$("#checkCertify").val("false");
							$("#serverCertify").val("false");								
//							$.certify.data.init();
							
							alert($.msg.signup.timeOverCertificationNum);
							clearTimeout(_transition);
							return false;
						}
						$("#timeView").show();
						$("#timeView").html($.certify.util.viewLimitTime());
						
						_transition = setTimeout($.certify.util.transition, 1000);
					},
					initViewLimitTime : function(){
						var time = 180;
						var iSecs = $.certify.util.lpad(time % 60, 2, "0"); 
						var iMins = Math.round((time-30)/60);  
						return $.certify.data.baseViewFormat.replace("{0}", iMins).replace("{1}", iSecs);
					},
					viewLimitTime : function(){
						var time = $.certify.data.time;
						var iSecs = $.certify.util.lpad(time % 60, 2, "0"); 
						var iMins = Math.round((time-30)/60);  
						return $.certify.data.baseViewFormat.replace("{0}", iMins).replace("{1}", iSecs);
					},
					observersInit : function(){
						$(".authOk").hide();

						$("#cfNumber").val("");
						
						$("#checkCertify").val("false");
						$("#serverCertify").val("false");	
						
						$("#sendCertify").show();
						$("#resendCertify").hide();
						
						$(".postSendCertify").hide();
						$("#timeView").html($.certify.util.initViewLimitTime());
						
						clearTimeout(_transition);
					}
			},
			// 인증 결과값 return
			popupResult : function(iReturn){
				if(iReturn == 1) return;
				var $form = $("form#personalCerify");
				$form.find("input#personallyCertify").val(iReturn == 0 ? true : false);
				$form.submit();
			},
			interSponsor : {
				certifyInit : function(){
					$("#okeyBtn").show();
					$("#cancelBtn").hide();
					interSponsorCertify.setStatus(false);
				},
				init : function(){
					$.certify.interSponsor.certifyInit();
					
					$("#internationalSponsorName").val("");
					$("#internationalSponsorNo").val("");
					$("#uiSponsor input:checkbox").each(function(){
						$(this).attr('checked', false);
					});
					
					$("#uiSponsor select").find('option:first').attr('selected', true);
					$("#uiSponsor input:radio:first").attr('checked', true);
					$("input#intersponsorCertify").val(false);
				}
			},
			dupMemberCheck : function(form){
				$("#ajaxCertify #name").val($("#authCerifyFormMember #name").val());
			    $("#ajaxCertify #birthDate").val($("#authCerifyFormMember #birthday").val());
			    $("#ajaxCertify #mobile01").val($("#authCerifyFormMember #mobile01").val());
			    $("#ajaxCertify #mobile02").val($("#authCerifyFormMember #mobile02").val());
			    $("#ajaxCertify #mobile03").val($("#authCerifyFormMember #mobile03").val());

				$.ajax({
					type:"POST",
					url: $.comm.ajaxUrl.dupUser,
					dataType: "json",
					data: $("#ajaxCertify").serialize(),
					success: function (data)
					{	
						if(data.rtn == false){
							alert(data.message);
							return false;
						}else{
							$("#serverCertify").val("true");
							
							if($(form).find("#mobile").length){
								$("#castMobile").val($.comm.util.castPhone($("#mobile").val()));
							}
							form.submit();						
						}
					},
					error: function(){
						alert($.msg.err.system);
					}
				});
			}
	}
})(jQuery);

// 본인확인을 주민등록번호로 할 경우
function fnOpenSsnCertify(){
	// 본인 인증은 서버에서 처리 하므로 화면에서는 true 처리한다.
	personallyCertify.setStatus(true);
	realNameCertify.applyInitCertify();
	$("#prevNextStepDiv").show();
	$("#prevArea").hide(); //
	
	$("#authCheckTypes").hide(); 				// 인증방법 숨김 처리
	$("#authNotice").hide();					// 인증주의사항
	$(".listWarning.mgtS").hide();	
	$(".postPersonalCertify").show(); 			// 주민등록번호로 실명확인 영역 활성화	
}

//회원가입을 위한 주민번호 인증
function getResultRealNameForSignup(data){
	if(data.result === true){
		//만 19세 미만 체크(현재 년도 - 태어난 년도 < 19)
		var checkAgeSsn1 = $("div.checkRealNameInput #ssn1").val();
		var checkAgeSsn2 = $("div.checkRealNameInput #ssn2").val();
		
		if($.certify.util.isNotAdult(checkAgeSsn1, checkAgeSsn2) != true){
			realNameCertify.processCertify(this);
		}
		
	}else{
		if(data.message){
			alert(data.message);
		}else{
			alert($.getMsg($.msg.signup.doNotInputFormReConfirm, ["실명확인 정보가", "한글성명과 주민등록번호를"]));
		}
		realNameCertify.setStatus(false);
	}
}

//회원탈퇴를 위한 주민번호 인증
function getResultRealNameForReSign(data){
	if(data.result == true){
		realNameCertify.processCertify(this);
	}else{
		if(data.message){
			alert(data.message);
		}else{
			alert("주민번호 인증에 " +(++certifyCount)+ "회 실패하였습니다.");
		}
		realNameCertify.setStatus(false);
	}
}

$(document).ready(function(){
	certifyCount = 0;
	
	//-------- signup 2단계(3단계) 본인확인(배우자) ---------------------------------------------------
	//	1. 실명인증
	//  2. 실명인증 ajax(was)
	//	3. 본인확인
	//	
	//-----------------------------------------------------------------------------------------------
	// 1. 실명인증
	if($("#realNameCertify").length){
		realNameCertify = new certify({
			observer : [$("div.inputBox.checkRealNameInput input#name"), $("div.inputNum2.checkRealNameInput span input.ssnInput")],
			observerInit : function(){
				$(".postRealNameAuth").hide();
				$("#realNameCheckComplete").hide();
				$("#realNameCkBtn").val("실명확인");
			},
			initCertify : function(){
				if(personallyCertify && personallyCertify.getStatus()){
					$(".checkRealNameInput #ssn2").attr("readonly", false).val("");
				}else{
					$(".checkRealNameInput input[type!='button']").attr("readonly", false).val("");
				}
	
				$(".postRealNameAuth").hide();
				$("#realNameCheckComplete").hide();
				$("#realNameCkBtn").val("실명확인");			
			},
			successCertify : function(){
				$(".postRealNameAuth").show();
				$("#realNameCheckComplete").show();
				$("#realNameCkBtn").val("실명완료");
			}
		});
		
		// 2. 실명인증 ajax(was)
		$("#realNameCkBtn").on("click", function(){
			
			realNameCertify.observerInit();
			
			if(!personallyCertify.getStatus()){
				return alert($.msg.signup.doNotPersonallyCertify);
			}
			
			var nameMessage = $.getMsg($.msg.common.inputDetail, "한글 성명을");
			var ssnMessage = $.getMsg($.msg.common.inputDetail, "주민등록번호를");
			
			if($("input#resignPage").length){
				nameMessage = $.getMsg($.msg.resign.realNameCertify, "실명");
				ssnMessage = $.getMsg($.msg.resign.realNameCertify, "주민등록번호");
			}
			
			if(!$.trim($("div.checkRealNameInput #name").val())){
				alert(nameMessage);
				$("div.checkRealNameInput #name").focus();
				return false;
			}else{
				var result = true;
				$("div.checkRealNameInput input.ssnInput").each(function(){		
					if(!$.trim($(this).val())){
						alert(ssnMessage);
						$(this).focus();
						result = false;
						return false;
					}
				});
				
				if(!result) return false;
			} 

			$("#authCerifyFormAjax input[name='name']").val($("form[id^='authCerifyForm'] input[id='name']").val());
			$("#authCerifyFormAjax input[name='ssn1']").val($("form[id^='authCerifyForm'] input[id='ssn1']").val());
			$("#authCerifyFormAjax input[name='ssn2']").val($("form[id^='authCerifyForm'] input[id='ssn2']").val());
				
			
			var url = $.comm.ajaxUrl.ssnCertify;
			var successFn = getResultRealNameForSignup;
			if($("input#resignPage").length){
				// 회원탈퇴를 위한 주민번호 인증
				url = $.comm.ajaxUrl.ssnCertifyForResign;
				successFn = getResultRealNameForReSign;
				$("#authCerifyFormAjax input[name='step']").val($("form[id^='authCerifyForm'] input[name='step']").val());
				
			}else{
				var ssn1 = $(".checkRealNameInput span input#ssn1").val();
				var ssn2 = $(".checkRealNameInput span input#ssn2").val();
				
				// 외국인 체크
				var isForeigner = $.certify.util.isForeigner(ssn2);
				if(isForeigner || isForeigner == null){
					return false;
				}
				
				// 19세 미만 체크
				var isNotAdult = $.certify.util.isNotAdult(ssn1, ssn2);
				if(isNotAdult || isNotAdult == null){
					return false;
				}
			}
			
			$.ajax({
				type:"POST",
				url: url,
				dataType: "json",
				data: $("#authCerifyFormAjax").serialize(),
				success: function (data)
				{		
					successFn(data);
				},
				error: function(){
					alert($.msg.err.system);
					realNameCertify.setStatus(false);
				}
			});	
		});
	}
	
	// 3. 본인확인
	if($("#personallyCertify").length){
		// 본인확인
		personallyCertify = new certify({
			init : function(){
				// 모바일 본인 인증 화면 전환 후 처리
				if($("#certifyPost").val() == "true" && $.trim($("#certifyErrMessage").val()).length <= 0)
				{
					// 인증 후 return 된 값이 있을 경우 
					if(   (userName      && userName.length      >= 1) 
					   || (userGender    && userGender.length    >= 1)
					   || (userBirthDate && userBirthDate.length >= 1))
					{
						this.processCertify(this);
					}
					else{
						this.applyInitCertify();
					}
				}
				else
				{
					this.applyInitCertify();
				}
			},
			initCertify : function(){
				$("#authCheckTypes").show();
				$("#authNotice").show();
				$(".listWarning.mgtS").show();
				
				$("#prevNextStepDiv").hide();
				$("#prevArea").show(); //
				
				$("div#personalCertifyComplete").hide()	// 인증 완료 DIV 숨김
				$(".postPersonalCertify").hide(); 		// 실명확인 관련 element 숨김 처리 함
				
				// 실명인증 초기화
				if(realNameCertify){
					realNameCertify.applyInitCertify();
				}
			},
			successCertify : function(){
				
				$("#prevNextStepDiv").show();
				$("#prevArea").hide();
				
				$("#authCheckTypes").hide(); 				// 인증방법 숨김 처리
				$("#authNotice").hide();					// 인증주의사항 숨김 처리
				$(".listWarning.mgtS").hide();
				$("div#personalCertifyComplete").show(); 	// 본인확인이 완료되었습니다.
				$(".postPersonalCertify").show(); 			// 주민등록번호로 실명확인 영역 활성화
				
				if(realNameCertify){
					realNameCertify.applyInitCertify();
				}

				$("div.checkRealNameInput #name").attr("readonly", true).val(userName);
				$("div.checkRealNameInput #ssn1").attr("readonly", true).val(userBirthDate);
				$("div.checkRealNameInput #gender").val(userGender);
			}
		});
	}

	// 후원자 인증
	if($("#sponsorCertify").length){
		// 6. 후원자 인증
		sponsorCertify = new certify({
			oCertify : $("#sponsorCertify"),
			observer : [$("#sponserNo")],
			observerInit : function(){
				$("#sponserName").val("");
				$("#sponsorCheckBtn").show();
				$("#sponsorCheckBtn").next().hide();
				$("#sponsorCheckBtn").removeAttr("disabled");
			},
			initCertify : function(){
				if(this.getCertifyElement().val() == "true"){
					$("#sponsorCheckBtn").hide();
					$("#completeBtn").show();
					sponsorCertify.setStatus(true);
				}else{
					$("#sponsorCheckBtn").show();
					$("#completeBtn").hide();
					$("#sponserNo").val("");
					$("#sponserName").val("");
				}
			},
			successCertify : function(){
				alert($.msg.signup.successSponsorCertify);
				$("#sponsorCheckBtn").hide();
				$("#sponsorCheckBtn").next().show();
				$("input:submit").removeAttr("disabled");
			}
		});
	
		// 7. 후원자 조회 ajax
		$("#sponsorCheckBtn").on("click", function(){
			
			$("#sponsorCheckBtn").attr("disabled", "disabled");
			$("input:submit").attr("disabled", "disabled");
			
			sponsorCertify.observerInit();
			if(!$("input#sponserNo").val()){
				alert($.getMsg($.msg.common.inputDetail, "후원자 번호를"));
				
				$("#sponsorCheckBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				
				$("input#sponserNo").focus();
				return false;
			}else if( /\D/.test($("input#sponserNo").val()) ) {
				alert($.msg.signup.doNotSponsorNum);
				
				$("#sponsorCheckBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				
				$("input#sponserNo").focus();
				return false;
			}
			loadingLayerS();
			var sponsorNo = $("input#sponserNo").val();
			
			$.comm.searchSponsor(sponsorNo, function(data){
				if(data.result == true){
					$("#sponserName").val(data.sponsorName);
					sponsorCertify.processCertify(this);
					loadingLayerSClose();
				}else{
					alert(data.message);

					$("#sponsorCheckBtn").removeAttr("disabled");
					$("input:submit").removeAttr("disabled");
					$("#sponserNo").focus();
					sponsorCertify.setStatus(false);
					loadingLayerSClose();
				}
			}, function(){
				alert($.msg.err.system);
				$("#sponsorCheckBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				sponsorCertify.setStatus(false);
				loadingLayerSClose();
			});
			
		});
	
	}
	
	
	// 국제후원자
	if($("#intersponsorCertify").length){
		// 8. 국제후원자 : 국제후원자 확인
		interSponsorCertify = new certify({
			oCertify : $("#intersponsorCertify"),
			oElement : $("#okeyBtn"),// 버튼 element
			observer : [$("#internationalSponsorName"), $("#internationalSponsorNo"), $("#internationalSponsorCountry"), $("#cancelBtn")],
			observerInit : function(oEl){
				$("#okeyBtn").show();
				$("#cancelBtn").hide();
				
				if($(oEl).attr("id") == "cancelBtn"){
					$("#internationalSponsorName").val("");
					$("#internationalSponsorNo").val("");
					$("#internationalSponsorCountry").val("");
				}

			},
			initCertify : function(){
				if(this.getCertifyElement().val() == "true"){
					//국제후원자 UI open 설정
					$(".toggleBox.inter").addClass('on');
					$(".toggleBox.inter .tggTit a").attr("title","자세히보기 닫기");
					$(".toggleBox.inter .tggTit a").text("국제후원자 입력 취소");
					
					//확인 취소 버튼
					$("#okeyBtn").hide();
					$("#cancelBtn").show();
					
					interSponsorCertify.setStatus(true);
				}else{
					$(".toggleBox.inter .tggTit a").text("국제후원자 확인");
					$("#internationalSponsorName").val("");
					$("#internationalSponsorCountry").find('option:first').attr('selected','true');
					$("#internationalSponsorNo").val("");
					$(".toggleBox.inter input:checkbox").each(function(){
						$(this).attr('checked', false);
					});
				}
				
			},
			
			checkCertify : function(){
				var regSponNo = /\d/;
				
				var interName = $("#internationalSponsorName").val();
				var interSponContry = $("#internationalSponsorCountry option:selected").val();
				var interSponNo = $("#internationalSponsorNo").val();
				var checkedSponsorType = $("input[name='internationalSponsorType']").is(':checked');
				var errorMessage;
				
				if(!checkedSponsorType){
					errorMessage = $.msg.signup.checkInterSponsor;
					$("#internationalSponsorType1").focus();
				}else if(!interName){
					errorMessage = $.getMsg($.msg.common.inputDetail, "성명을");
					$("#internationalSponsorName").focus();
				}else if(!interSponContry){
					errorMessage = "국가코드를 선택해 주세요.";
					$("#internationalSponsorCountry").focus();
				}else if(!interSponNo){
					errorMessage = $.getMsg($.msg.common.inputDetail, "후원자 ABO번호를");
					$("#internationalSponsorNo").focus();
				}else if(!regSponNo.test(interSponNo)){
					errorMessage = $.getMsg($.msg.signup.doNotInputFormReConfirm, ["후원자 ABO번호가", "다시"]);
					$("#internationalSponsorNo").focus();
				}else{
					return true;
				}
				alert(errorMessage);
				return false;
			},
			successCertify : function(){
				$("#okeyBtn").hide();
				$("#cancelBtn").show();
//				alert($.msg.signup.interSponsorCertifyCheck);
				
				var country = $("#internationalSponsorCountry option:selected").text();
				var sponsorNm = $("#internationalSponsorNo").val();
				alert($.getMsg($.msg.signup.interSponsorCertifyCheck, [ country, sponsorNm]));
			}
		});
		
		//국제 후원자 열고 닫기 이벤트 추가
		if($('.toggleBox.inter').length){
			$('.toggleBox.inter .tggTit a').click(function() {
				if($(this).parent().parent().hasClass('on') == true){
					//열려있는 상태
					$(this).text("국제후원자 입력 취소");
				}else {
					//닫혀있는 상태
					$(this).text("국제후원자 확인");
					$.certify.interSponsor.init();
				}
			});
		}
	}

	
	//이메일 인증
	if($("#emailCertify").length){
		emailCertify = new certify({
			oCertify : $("#emailCertify"),
			oElement : $("#emailCertifyBtn"),// 버튼 element
			observer : [$("input#email")],
			observerInit : function(){
				//select box 처리 readonly
				$("#emailCertifyBtn").parent().show();
				$("#emailCertified").hide();
			},
			initCertify : function(){
				// 인증값 초기화
				if(this.getCertifyElement().val() == "true"){
					$("#emailCertifyBtn").parent().hide();
					$("#emailCertified").show();
					emailCertify.setStatus(true);
				}else{
					$("#emailCertifyBtn").parent().show();
					$("#emailCertified").hide();
				}
				
			},
			checkCertify : function(){
				var regEmail01 = /^[_0-9a-zA-Z-](\.?[_0-9a-zA-Z-])*@[0-9a-zA-Z-]*(\.[0-9a-zA-Z-]+)*$/;
				var regEmail02 = /amway.com/g;
				
				var valEmail = $("#email").val();
				if(!regEmail01.test(valEmail) || valEmail.length == 0){
					alert($.getMsg($.msg.signup.doNotInputFormReInput, [ "이메일", "abcd@gmail.com 형태로"]));
					$("#email").focus();
					return false;
				}
				
				if(regEmail02.test(valEmail)){
					alert($.msg.signup.doNotEmailAmway);
					$("#email").focus();
					return false;
				}
				return true;
				
			},
			successCertify : function(){
				alert($.msg.signup.successCertify);
				$("#emailCertifyBtn").parent().hide();
				$("#emailCertified").show();
			}
		});
	}
	
	// 계좌 인증
	if($("#accountCertify").length){
		//4. 계좌 인증
		accountNumberCertify = new certify({
			oCertify : $("#accountCertify"),
			observer : [$("select#bankCode"), $("input#accountNumber")],
			observerInit : function(){
				$("#accountCertifyBtn").parent().show();
				$("#accountCertified").hide();
			},
			initCertify : function(){
				// 인증값 초기화\
				if(this.getCertifyElement().val() == "true"){
					$("#accountCertifyBtn").parent().hide();
					$("#accountCertified").show();
					accountNumberCertify.setStatus(true);
				}else{
					$("#accountCertifyBtn").parent().show();
					$("#accountCertified").hide();
				}
				
			},
			successCertify : function(){
				alert($.msg.signup.successCertify);
			
				$("#accountCertifyBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				$("#accountCertifyBtn").parent().hide();
				$("#accountCertified").show();
			}
			
		});
		
		// 5. 계좌 인증 ajax(was)
		$("#accountCertifyBtn").on("click", function(){
			
			$("#accountCertifyBtn").attr("disabled", "disabled");
			$("input:submit").attr("disabled", "disabled");
			accountNumberCertify.observerInit();
			
			if(!$("#bankCode option:selected").val()){	
				alert($.getMsg($.msg.common.selectDetail, "거래은행을") );
				$("#accountCertifyBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				$("select#bankCode").focus();
				return false;
			}else if(!$("#accountNumber").val()){
				alert($.getMsg($.msg.common.inputDetail, "계좌번호를"));
				$("#accountCertifyBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				$("#accountNumber").focus();
				return false;
			}else if( /\D/.test( $("#accountNumber").val() ) ){
				alert($.getMsg($.msg.signup.doNotInputFormReInput, ["계좌번호가", "숫자로만"]));
				$("#accountCertifyBtn").removeAttr("disabled");
				$("input:submit").removeAttr("disabled");
				$("#accountNumber").focus();
				return false;
			} 
	
			$("#accountCertifyAjax input[name='bankCode']").val($("#bankCode option:selected").val());
			$("#accountCertifyAjax input[name='accountNum']").val($("#accountNumber").val());
	
			$.ajax({
				type:"POST",
				url: $.comm.ajaxUrl.accountNum,
				dataType: "json",
				data:$("#accountCertifyAjax").serialize(),
				success: function (data)
				{	
					if(data.bRtn === true){
						accountNumberCertify.processCertify(this);
					}else{
						//인증시 세션이 끊어진 경우
						if(data.isSessionOut === true){
							window.location.reload(true);
							return false;
						}
						//인증 실패(계좌번호가 맞지 않은경우)
						else{
							accountNumberCertify.setStatus(false);

							var msg = data.errorMsg ? data.errorMsg : $.msg.signup.failCertify;
							alert( msg );
							
							$("#accountCertifyBtn").removeAttr("disabled");
							$("input:submit").removeAttr("disabled");
							$("#accountNumber").focus();
						}
					}
				},
				error: function (data){
					alert($.msg.err.system);
					$("#accountCertifyBtn").removeAttr("disabled");
					$("input:submit").removeAttr("disabled");
					accountNumberCertify.setStatus(false);
				}
			});
		});
	}
	
	
	// 아이디 중복 확인
	if($("#idCertify").length){
		// 12. 아이디 중복확인
		idCertify = new certify({
			oCertify : $("#idCertify"),
			observer : [$("#uid")],
			observerInit : function(){
				$("#idCertifyBtn").parent().show();
				$("#idCertified").hide();
				//초기값
			},
			initCertify : function(){
				if(this.getCertifyElement().val() == "true"){
					idCertify.setStatus(true);
					$("#idCertifyBtn").parent().hide();
					$("#idCertified").show();
				}else{
					$("#uid").val("");
					$("#idCertifyBtn").parent().show();
					$("#idCertified").hide();
				}
			},
			successCertify : function(){
				alert($.msg.signup.successIdDuplicationCheck);
				$("#idCertifyBtn").parent().hide();
				$("#idCertified").show();
			}
		});
	
		// 12. 아이디 중복확인
		$("#idCertifyBtn").on("click", function(){
			idCertify.observerInit();
			var id = $("input#uid").val();
			if(id){
				if(((/^[a-zA-Z0-9_]{6,10}$/).test(id)) == false || ((/^[a-zA-Z].*/).test(id)) == false ) {
					alert($.msg.signup.inputIdForm);
					$("input#uid").focus();
					return false;
				}
			}else{
				alert($.getMsg($.msg.common.inputDetail, "아이디를"));
				$("input#uid").focus();
				return false;
			}
			
			$("#idDuplicationCheckAjax input[name='uid']").val($("input#uid").val());
	
			$.ajax({
				type:"POST",
				url: $.comm.ajaxUrl.dupMemberid,
				dataType: "json",
				data: $("#idDuplicationCheckAjax").serialize(),
				success: function (data)
				{	
					if(data.rtn == false){
						alert($.msg.signup.failIdDuplicationCheck);
						$("#uid").focus();
						idCertify.setStatus(false);
					}else{
						$("#uid").val($("#uid").val().toUpperCase());
						idCertify.processCertify(this);
					}
				},
				error: function (data){
					alert($.msg.err.system);
					idCertify.setStatus(false);
				}
			});
			
		});
	}
	
	//인증 값 유지
    if($("#emailCertify").length){
    	emailCertify.applyInitCertify();
    }
    if($("#accountCertify").length){
    	accountNumberCertify.applyInitCertify();
    }
    if($("#sponsorCertify").length){
    	sponsorCertify.applyInitCertify();
    }
    if($("#intersponsorCertify").length){
    	interSponsorCertify.applyInitCertify();
    }
    if($("#idCertify").length){
    	idCertify.applyInitCertify();
    }

    registerPartner = $("#registerPartner").val() == "true" ? true : false;
    
});
