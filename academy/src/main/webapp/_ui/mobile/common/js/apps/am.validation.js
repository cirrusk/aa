var isABO;
var beforeMobileNo = "";
var beforeHomeNo = "";

(function($) {
	$.keyLimit  = {
			// max 이상 반복되는 문자나 숫자 사용 금지
			limitRepetition : function(max){
				$(".limitRepetition").bind("keyup", function(){
					var reg =  new RegExp("(.)\1{" + max + "}", "g");
			    	if( reg.test($(this).val()) ){
			    		alert($.msg.signup.doNotPasswordRepeatWord);
			    		$(this).focus();
			    	}
				});
			}
	},
	// 약관 동의 여부
    $.agreeCheck = function(oAgree){
    	var agree = false;
	    if($(oAgree).length){
	    	agree = $(oAgree).is(':checked');
	    }
	    return agree;
    },
    $.isEmptyAddressInfo = function(){
		var result = true;
		
		$("input.addressRequired").each(function(){
			if($.trim($(this).val()).length <= 0){
				result = false;
				return false;
			}
		});
		
		return result;
	},
	// 약관 데이터 변경 여부
	$.isChangeAgree = function(){
		var adSms   = $("input[name='adSms']:checked").val() || ""; 
		var adMail = $("input[name='adMail']:checked").val() || "";
		var preAdSms = $("#preAdSms").val();
		var preAdMail = $("#preAdMail").val();
		return (adSms != preAdSms) || (adMail != preAdMail);
	},
	$.addValidation = function(){
	    
		// 약관동의 ABO
	    if($("#publicOfficial1").length){
	    	$("#publicOfficial1").rules("add", {
	    		required : true,
	        	messages : {
	        		required: $.msg.signup.checkPublicOfficial
	        	}
	        });
	    }
	    
	    // 실명인증 ABO
	    if($("#ssn1").length){
	    	$("#ssn1").rules("add", {
	    		required : true,
	    		digits : true,
	        	messages : {
	        		required : $.getMsg($.msg.common.inputDetail, "주민등록번호를"),
	        		digits : $.getMsg($.msg.signup.doNotInputFormReInput, ["주민등록번호", "숫자만"])
	        	}
	        });
	    }
	    
	    if($("#ssn2").length){
	    	$("#ssn2").rules("add", {
	    		required : true,
	    		digits : true,
	        	messages : {
	        		required : $.getMsg($.msg.common.inputDetail, "주민등록번호를"),
	        		digits : $.getMsg($.msg.signup.doNotInputFormReInput, ["주민등록번호", "숫자만"])
	        	}
	        });
	    }
	    
	    if($("#personallyCertify").length){
	    	$("#personallyCertify").rules("add", {
	    		certify : {param: personallyCertify}
	        });
	    }
	    
	    if($("#realNameCertify").length){
	    	$("#realNameCertify").rules("add", {
	    		certify : {param: realNameCertify}
	        });
	    }
		
	    // 실명인증 member
	    if($("#personallyCertify").length && isABO == false){
	    	$("#personallyCertify").rules("add", {
	    		personallyCertify : {
					certify : {param: personallyCertify}
				},
	        	messages : {
	        		personallyCertify : $.getMsg($.msg.signup.doNotPersonallyCertifyAfterDoit, "본인인증을")
	        	}
	        });
	    }
	    
	    
	    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//-------- signup 4단계 회원정보 입력 validation check ---------//
		//	1. 후원자 선택
		//	2. 기본정보 입력
		//	3. 개인정보 수집 및 동의 
		//--------------------------------------------------------------//
	    
	    $("#password").keyup(function(){
	    	if( /(.)\1{3,}/g.test($(this).val()) ){
	    		alert($.msg.signup.doNotPasswordRepeatWord);
	    	}
	    });
	    
	    
	    
	    //후원자 ABO 번호 확인
	    if($("#sponserNo").length){
	    	$("#sponserNo").rules("add", {
	    		required : true,
	    		digits: true,
	    		certify : {param: sponsorCertify},
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"후원자 확인\"은" ),
	        		digits : $.getMsg($.msg.signup.doNotInputFormReConfirm, ["후원자 ABO번호가", "다시"]) ,
	        		certify : $.getMsg($.msg.signup.required, "\"후원자 확인\"은")
	        	}
	        });
	    }
	    
	    //국제후원자 성명
	    if($("#internationalSponsorName").length){
	    	$("#internationalSponsorName").rules("add", {
	    		required : {
	    			param : true,
	    			depends : function(element){
	    				return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus();
	    			}
	    		},
	    		messages : {
	    			required : $.getMsg($.msg.common.inputDetail, "국제후원자 성명을")
	    		}
	    		
	        });
	    }
	    
	    //국제후원자 국가코드 
	    if($("#internationalSponsorCountry").length){
	    	$("#internationalSponsorCountry").rules("add", {
	    		required : {
	    			param : true,
	    			depends : function(element){
	    				return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus();
	    			}
	    		},
	    		messages : {
	    			required : $.getMsg($.msg.common.selectDetail, "국가코드를")
	    		}
	    	});
	    }
		
	    //국제후원자 ABO번호
	    if($("#internationalSponsorNo").length){
	    	$("#internationalSponsorNo").rules("add", {
	    		required : {
	    			param : true,
	    			depends : function(element){
	    				return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus();
	    			}
	    		},
	    		messages : {
	    			required : $.getMsg($.msg.common.inputDetail, "후원자 ABO번호를"),
	        		digits : $.getMsg($.msg.signup.doNotInputFormReConfirm, ["후원자 ABO번호가", "다시"]),
	        		certify : $.msg.signup.inputInterSponsor
	        	}
	        });
	    }
	    
	    //국제후원자 동의 여부1
	    if($("#isaPrivate1").length){
	    	$("#isaPrivate1").rules("add", {
	    		required : {
	        		param: true,
	        		depends : function(element){
	        			return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus();
	        		}
	        	},
	        	messages : {
	        		required : $.msg.signup.internationalSponsorPrivate
	        	}
	        });
	    }
		
	    //국제후원자 동의 여부2
	    if($("#isaIntro1").length){
	    	$("#isaIntro1").rules("add", {
	    		required : {
	        		param: true,
	        		depends : function(element){
	        			return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus();
	        		}
	        	},
	        	messages : {
	        		required : $.msg.signup.internationalSponsorIntro
	        	}
	        });
	    }
	    
	    //국제후원자 동의 여부3
	    if($("#isaAwawe1").length){
	    	$("#isaAwawe1").rules("add", {
	    		required : {
	        		param: true,
	        		depends : function(element){
	        			return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus();
	        		}
	        	},
	        	messages : {
	        		required : $.msg.signup.internationalSponsorAwawe
	        	}
	        });
	    }
	    
	    //국제후원자 동의 여부4
	    if($("#isaAgree1").length){
	    	$("#isaAgree1").rules("add", {
	    		required : {
	        		param: true,
	        		depends : function(element){
	        			return $(".toggleBox.inter.on").length && interSponsorCertify.getStatus(); 
	        		}
	        	},
	        	messages : {
	        		required : $.msg.signup.internationalSponsorAgree
	        	}
	        });
	    }
	    
		//주사업자 영문성명 확인
	    if($("#englishName").length){
	    	$("#englishName").rules("add", {
	    		required: true,
	            englishNameCheck: true,
	        	messages : {
	        		required : isABO ?  $.getMsg($.msg.signup.required, "\"주사업자(가입신청자) 영문성명\"은") : $.getMsg($.msg.signup.required, "\"영문성명\"은")
	        	}
	        });
	    }
	    
		//부사업자(배우자) 영문성명 확인
	    if($("#partnerEnglishName").length){
	    	$("#partnerEnglishName").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return registerPartner;
	        		}
	        	},
	        	englishNameCheck: true,
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"부사업자(배우자) 영문성명\"은")
	        	}
	        });
	    }

		//성별
	    if($("#gender1").length){
	    	$("#gender1").rules("add", {
	    		required :{
	        		param : true,
	        		depends : !isABO
	        	},
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"성별\"은")
	        	}
	        });
	    }
	    
	    if($("#uid").length){
	    	$("#uid").rules("add", {
	    		idCheck : true,
	        	required :{
	        		param : true,
	        		depends : !isABO
	        	},
	        	certify : {param: idCertify},
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"아이디\"는"),
	            	idCheck : $.msg.signup.inputIdForm,
	            	certify : $.getMsg($.msg.signup.duplicationCheck, "아이디")
	        	}
	        });
	    }

		//패스워드
	    if($("#password").length){
	    	$("#password").rules("add", {
	    		required: true,
	            continuationPasswordCheck : true, //연속되는 문자나 숫자
	            doNotIncludePhoneNum :
	            	function(element){
	            		var arrayNum = [];
	            		var mobile02 = $("#mobile02").val();
	            		var mobile03 = $("#mobile03").val();
	            		var home02 = $("#home02").val();
	            		var home03 = $("#home03").val();
	            		var pMobile02 = $("#partnerMobile02").val();
	            		var pMboile03 = $("#partnerMobile03").val();
	            		
	            		if(mobile02){
	            			arrayNum.push(mobile02);
	            		}
	            		if(mobile03){
	            			arrayNum.push(mobile03);
	            		}
	            		if(home02){
	            			arrayNum.push(home02);
	            		}
	            		if(home03){
	            			arrayNum.push(home03);
	            		}
	            		if(pMobile02){
	            			arrayNum.push(pMobile02);
	            		}
	            		if(pMboile03){
	            			arrayNum.push(pMboile03);
	            		}
	            		return arrayNum;
	            	},
	            	defaultPasswordCheck : true, //비밀번호로 영문/숫자 조합 6 ~ 10자리
	            	doNotIncludeId : function(){
	            		var uid;
	            		if($("#uid").val()){
	            			uid = $("#uid").val();
	            		}
	            		
	            		return uid; 
	            	},
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"비밀번호\"는")
	        	}
	        });
	    }
	    
	    //후원자 ABO 번호 확인
	    if($("#confirmPassword").length){
	    	$("#confirmPassword").rules("add", {
	    		required: true,
	    		   rangelength: [6, 8],
	    		   equalTo: "#password",
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"비밀번호 확인\"은"),
	                rangelength : $.getMsg($.msg.signup.equalTo, ["비밀번호와", "비밀번호 확인이"]),
	                equalTo : $.getMsg($.msg.signup.equalTo, ["비밀번호와", "비밀번호 확인이"])
	        	}
	        });
	    }
	    
		//주사업자 휴대폰 번호 1
	    if($("#mobile01").length){
	    	$("#mobile01").rules("add", {
	    		required: true,
	            digits: true,
	        	messages : {
	        		required : isABO ? $.getMsg($.msg.signup.required, "\"주사업자 휴대폰 번호\"는") : $.getMsg($.msg.signup.required, "\"휴대폰 번호\"는"),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//주사업자 휴대폰 번호 2
	    if($("#mobile02").length){
	    	$("#mobile02").rules("add", {
	            required: true,
	            digits: true,
	            rangelength: [3, 4], //3,4자리,
	        	messages : {
	        		required : isABO ? $.getMsg($.msg.signup.required, "\"주사업자 휴대폰 번호\"는") : $.getMsg($.msg.signup.required, "\"휴대폰 번호\"는"),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//주사업자 휴대폰 번호 3
	    if($("#mobile03").length){
	    	$("#mobile03").rules("add", {
	    		required: true,
	            digits: true,
	            rangelength: [4, 4], //4자리
	        	messages : {
	        		required : isABO ? $.getMsg($.msg.signup.required, "\"주사업자 휴대폰 번호\"는") : $.getMsg($.msg.signup.required, "\"휴대폰 번호\"는"),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
		
	    //주사업자 전화번호 1
	    if($("#home01").length){
	    	$("#home01").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return ( $("#home02").val()||$("#home03").val() || $("#homeAgree1").is(':checked'));
	        		}
	        	},
	        	messages : {
	        		required : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//주사업자 전화번호 2
	    if($("#home02").length){
	    	$("#home02").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return ( $("#home01 option:selected").val()||$("#home03").val() || $("#homeAgree1").is(':checked'));
	        		}
	        	},
	        	digits: true,
	            rangelength: [3, 4], //3,4자리
	        	messages : {
	        		required : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//주사업자 전화번호 3
	    if($("#home03").length){
	    	$("#home03").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return ( $("#home01 option:selected").val()||$("#home02").val() || $("#homeAgree1").is(':checked'));
	        		}
	        	},
	        	digits: true,
	            rangelength: [4, 4], //4자리
	        	messages : {
	        		required : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//부사업자 휴대폰번호 1
	    if($("#partnerMobile01").length){
	    	$("#partnerMobile01").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return ( $("#partnerMobile02").val()||$("#partnerMobile03").val() || $("#partnerMobileAgree1").is(':checked'));
	        		}
	        	},
	        	messages : {
	        		required : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//부사업자 휴대폰번호 2
	    if($("#partnerMobile02").length){
	    	$("#partnerMobile02").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return ( $("#partnerMobile01 option:selected").val()||$("#partnerMobile03").val() || $("#partnerMobileAgree1").is(':checked') );
	        		}
	        	},
	        	digits: true,
	            rangelength: [3, 4], //3,4자리
	        	messages : {
	        		required : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//부사업자 휴대폰번호 3
	    if($("#partnerMobile03").length){
	    	$("#partnerMobile03").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return ( $("#partnerMobile01 option:selected").val()||$("#partnerMobile02").val() || $("#partnerMobileAgree1").is(':checked')  );
	        		}
	        	},
	        	digits: true,
	            rangelength: [4, 4],
	        	messages : {
	        		required : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	digits : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }

		//이메일 id
	    if($("#email").length){
	    	$("#email").rules("add", {
	    		required : true,
	        	emailCheck : true,
	        	includeAmwayCheck : true,
	        	certify : {param: emailCertify},
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"이메일 주소\"는"),
	            	certify : $.getMsg($.msg.signup.certify, "이메일을")
	        	}
	        });
	    }
		
	    //주소
	    if($("#formattedAddress").length){
	    	$("#formattedAddress").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return isABO == true ? true : $("#addressAgree1").is(':checked');
	        		}
	        	},
	        	isEmptyAddressInfo : {
	        		param : true,
	        		depends : function(element){
	        			return isABO == true ? true : $("#addressAgree1").is(':checked');
	        		}
	        	},
	        	messages : {
	        		required : isABO == true ? $.getMsg($.msg.signup.required, "\"주소\"는") : $.getMsg($.msg.common.inputDetail, "\"주소\"를")
	        	}
	        });
	    }
	    
		//거래은행
	    if($("#bankCode").length){
	    	$("#bankCode").rules("add", {
	    		required : true,
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"주사업자 거래은행\"은")
	        	}
	        });
	    }
	    
		//계좌번호
	    if($("#accountNumber").length){
	    	$("#accountNumber").rules("add", {
	    		required : true,
	        	digits: true,
	        	certify : {param: accountNumberCertify},
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"주사업자 거래은행\"은"),
	            	digits: $.getMsg($.msg.signup.doNotInputFormReInput, ["계좌번호", "다시"]),
	            	certify : $.getMsg($.msg.signup.certify, "계좌번호를")
	        	}
	        });
	    }
	    
	    // 후원수당 정보 전달 방법 선택
	    if($("#sponsorBenefitNotifyType1").length){
	    	$("[name='sponsorBenefitNotifyType']").rules("add", {
	    		required : true,
	        	messages : {
	        		required: $.msg.signup.sponsorbenefitnotifytypeRequired
	        	}
	        });
	    }	    
	    	
	},
	$.addValidationCertify = function(){
		// 입력 직시 인증번호를 입력할 경우만 사용
		if($("#checkCertify").length){
			$("#checkCertify").rules( "add", {
				simpleCertify: {
					param : {
						checkCertify  : $("#checkCertify"),
						serverCertify : $("#serverCertify")	
					},
	    			depends : function(element){
	    				return _validationFlag != "certify"
	    			}
				}
			});	
		}
		
		if($("#uid").length){
			$("#uid").rules( "add", {
				required: true,
				messages: {
					required : $.getMsg($.msg.common.inputDetail, "아이디를")
				}
			});
		}
		if($("#name").length){
			$("#name").rules( "add", {
				required: true,
				minlength: 2,
				messages: {
					required:  $.getMsg($.msg.common.inputDetail, "이름을"),
					minlength: $.msg.personalinfo.common.inputIncorrectInfo
				}
			});
		}
		
		if($("#birthday").length){
			$("#birthday").rules( "add", {
				required: true,
				digits: true,
				rangelength: [8, 8],
				isBirthday: true,
				isAdult: $("#authCerifyFormMember").length == 1,
				messages: {
					required 	:	$.getMsg($.msg.common.inputDetail, "법정생년월일을"),
					digits 		:	$.msg.personalinfo.common.isNotBirth,
					rangelength : 	$.msg.personalinfo.common.isNotBirth
				}
			});
		}

		if($("#mobile02").length){
			$("#mobile01").rules( "add", {
				required: true,
				messages: {
					required : $.getMsg($.msg.common.inputDetail, "휴대폰번호를")
				}
			});	

			$("#mobile02").rules( "add", {
	            required: true,
	            digits: true,
	            rangelength: [3, 4],
				messages: {
					required : 		$.getMsg($.msg.common.inputDetail, "휴대폰번호를"),
					digits : 		$.msg.personalinfo.common.inputIncorrectInfo,
					rangelength : 	$.msg.personalinfo.common.inputIncorrectInfo
				}
			});	
			
			$("#mobile03").rules( "add", {
	            required: true,
	            digits: true,
	            rangelength: [4, 4],
				messages: {
					required : 		$.getMsg($.msg.common.inputDetail, "휴대폰번호를"),
					digits : 		$.msg.personalinfo.common.inputIncorrectInfo,
					rangelength : 	$.msg.personalinfo.common.inputIncorrectInfo
				}
			});	
		}else{
			if($("#mobile").length){
				$("#mobile").rules( "add", {
					required: true,
		            digits: true,
		            rangelength: [7, 8],
					messages: {
						required : 		$.getMsg($.msg.common.inputDetail, "휴대폰번호를"),
						digits : 		$.msg.personalinfo.common.inputIncorrectInfo,
						rangelength : 	$.msg.personalinfo.common.inputIncorrectInfo
					}
				});	
			}	
		}
	},
	$.addValidationPassword = function(){
		if($("#currentPassword").length){
			$("#currentPassword").rules( "add", {
				required: true,
				messages: {
					required :   $.getMsg($.msg.common.inputDetail, "현재 비밀번호를"),
				}
			});	
		}
		
		if($("#newPassword").length){
			$("#newPassword").rules( "add", {
				required: true,
				continuationPasswordCheck: true,
				defaultPasswordCheck : true,
				messages: {
					required : $.getMsg($.msg.common.inputDetail, "새 비밀번호를"),
				}
			});	
		}

		if($("#checkNewPassword").length){
			$("#checkNewPassword").rules( "add", {
				required: true,
				equalTo: "#newPassword",
				messages: {
					required : $.getMsg($.msg.common.inputDetail, "새 비밀번호 확인을"),
					equalTo : $.msg.personalinfo.common.equalToNewPassword
				}
			});	
		}
	},
	$.addValidationMenuLock = function(){
		if($("#lockPwReSetting #password").length){
			$("#lockPwReSetting #password").rules( "add", {
				required: {
					param : true,
	    			depends : function(element){
	    				// 잠금 메뉴 사용 유무 체크
	    				if($("input[name='menuLockUse']").length){
	    					return !$("input[name='menuLockUse']").is(":checked");
	    				}
	    				return true;
	    			}
				},
				continuationPasswordCheck : true, //연속되는 문자나 숫자
				onlyNumber : true,
				messages: {
					required : $.getMsg($.msg.personalinfo.menuLock.passwordRequired, "새잠금 비밀번호"),
					continuationPasswordCheck : $.msg.personalinfo.menuLock.doNotPasswordRepeatWord,
					number : $.msg.personalinfo.menuLock.passwordOnlyNumber
				}
			});			
		}

		if($("#lockPwReSetting #confirmPassword").length){
			$("#lockPwReSetting #confirmPassword").rules( "add", {
				required : true,
				equalTo : "#lockPwReSetting #password",
				messages: {
					required : $.getMsg($.msg.personalinfo.menuLock.passwordRequired, "새잠금 비밀번호 확인"),
					equalTo  : $.getMsg($.msg.personalinfo.menuLock.equalToPassword,  "새 비밀번호가 서로"),
                    number : $.msg.personalinfo.menuLock.passwordOnlyNumber
				}
			});	
		}		
	},	
	$.addValidationTaxBillsReceiveInfo = function(){
		//이메일 id
	    if($("#email").length){
	    	$("#email").rules("add", {
	    		required : true,
	        	emailCheck : true,
	        	messages : {
	        		required : $.getMsg($.msg.personalinfo.common.enterRequired, "이메일 주소"),
	        		emailCheck : $.msg.personalinfo.common.inputIncorrectInfo
	        	}
	        });
	    }

		//휴대폰 번호 1
	    if($("#mobile01").length){
	    	$("#mobile01").rules("add", {
	    		required: true,
	            digits: true,
	        	messages : {
	        		required : $.getMsg($.msg.personalinfo.common.enterRequired, "휴대폰번호"),
	        		digits : $.msg.personalinfo.common.inputIncorrectInfo
	        	}
	        });
	    }
	    
		//휴대폰 번호 2
	    if($("#mobile02").length){
	    	$("#mobile02").rules("add", {
	            required: true,
	            digits: true,
	            rangelength: [3, 4], //3,4자리,
	        	messages : {
	        		required : $.getMsg($.msg.personalinfo.common.enterRequired, "휴대폰번호"),
	        		digits : $.msg.personalinfo.common.inputIncorrectInfo,
	            	rangelength : $.msg.personalinfo.common.inputIncorrectInfo
	        	}
	        });
	    }
	    
		//휴대폰 번호 3
	    if($("#mobile03").length){
	    	$("#mobile03").rules("add", {
	    		required: true,
	            digits: true,
	            rangelength: [4, 4], //4자리
	        	messages : {
	        		required : $.getMsg($.msg.personalinfo.common.enterRequired, "휴대폰번호"),
	        		digits : $.msg.personalinfo.common.inputIncorrectInfo,
	            	rangelength : $.msg.personalinfo.common.inputIncorrectInfo
	        	}
	        });
	    }
		
	},
	// 회원정보 수정
	$.addValidationCustomerUpdate = function(){
		//주사업자 영문성명 확인
	    if($("#englishName").length){
	    	$("#englishName").rules("add", {
	    		required: true,
	            englishNameCheck: true,
	        	messages : {
	        		required : isABO ? $.getMsg($.msg.signup.required, "\"주사업자 영문성명\"는") : $.getMsg($.msg.signup.required, "\"영문성명\"은")
	        	}
	        });
	    }
	    
		//부사업자(배우자) 영문성명 확인
	    if($("#partnerEnglishName").length){
	    	$("#partnerEnglishName").rules("add", {
	    		required : {
	        		param : true,
	        		depends : function(element){
	        			return registerPartner;
	        		}
	        	},
	        	englishNameCheck: true,
	        	messages : {
	        		required : $.getMsg($.msg.signup.required, "\"부사업자 영문성명\"은")
	        	}
	        });
	    }
		//주사업자 휴대폰 번호 1
	    if($("#mobile01").length){
	    	$("#mobile01").rules("add", {
	    		required		: true,
	        	messages 		: {
	        		required 	: isABO ? $.getMsg($.msg.signup.required, "\"주사업자 휴대폰번호\"는") : $.getMsg($.msg.signup.required, "\"휴대폰번호\"는")
	        	}
	        });
	    }
	    
		//주사업자 휴대폰 번호 2
	    if($("#mobile02").length){
	    	$("#mobile02").rules("add", {
	            required		: true,
	            digits			: true,
	            rangelength		: [3, 4],
	        	messages 		: {
	        		required 	: isABO ? $.getMsg($.msg.signup.required, "\"주사업자 휴대폰번호\"는") : $.getMsg($.msg.signup.required, "\"휴대폰번호\"는"),
	        		digits      : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//주사업자 휴대폰 번호 3
	    if($("#mobile03").length){
	    	$("#mobile03").rules("add", {
	    		required		: true,
	            digits			: true,
	            rangelength		: [4, 4], //4자리
	        	messages 		: {
	        		required 	: isABO ? $.getMsg($.msg.signup.required, "\"주사업자 휴대폰번호\"는") : $.getMsg($.msg.signup.required, "\"휴대폰번호\"는"),
	        		digits      : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
	    //주사업자 전화번호 1
	    if($("#home01").length){
	    	$("#home01").rules("add", {
	    		required 		: {
	        		param 		: true,
	        		depends 	: function(element){
	        			return ( $("#home02").val() || $("#home03").val() || $.agreeCheck("#homeAgree1") );
	        		}
	        	},
	        	messages 		: {
	        		required 	: $.getMsg($.msg.personalinfo.common.enterRequired, "전화번호")
	        	}
	        });
	    }
	    
		//주사업자 전화번호 2
	    if($("#home02").length){
	    	$("#home02").rules("add", {
	    		required 		: {
	        		param 		: true,
	        		depends 	: function(element){    
	        			return ( $("#home01 option:selected").val()||$("#home03").val() || $.agreeCheck("#homeAgree1"));
	        		}
	        	},
	        	digits			: true,
	            rangelength		: [3, 4], //3,4자리
	        	messages 		: {
	        		required 	: $.getMsg($.msg.personalinfo.common.enterRequired, "전화번호"),
	            	digits 		: $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//주사업자 전화번호 3
	    if($("#home03").length){
	    	$("#home03").rules("add", {
	    		required 		: {
	        		param 		: true,
	        		depends 	: function(element){           			
	        			return ( $("#home01 option:selected").val()||$("#home02").val() || $.agreeCheck("#homeAgree1"));
	        		}
	        	},
	        	digits			: true,
	            rangelength		: [4, 4], //4자리
	        	messages 		: {
	        		required 	: $.getMsg($.msg.personalinfo.common.enterRequired, "전화번호"),
	            	digits 		: $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }
	    
		//부사업자 휴대폰번호 1
	    if($("#partnerMobile01").length){
	    	$("#partnerMobile01").rules("add", {
	    		required 		: {
	        		param 		: true,
	        		depends 	: function(element){
	        			return ( $("#partnerMobile02").val()||$("#partnerMobile03").val() || $.agreeCheck("#partnerMobileAgree1"));
	        		}
	        	},
	        	messages 		: {
	        		required 	: $.getMsg($.msg.personalinfo.common.enterRequired, "부사업자 휴대폰번호")
	        	}
	        });
	    }
	    
		//부사업자 휴대폰번호 2
	    if($("#partnerMobile02").length){
	    	$("#partnerMobile02").rules("add", {
	    		required 		: {
	        		param 		: true,
	        		depends 	: function(element){
	        			return ( $("#partnerMobile01 option:selected").val()||$("#partnerMobile03").val() || $.agreeCheck("#partnerMobileAgree1"));
	        		}
	        	},
	        	digits			: true,
	            rangelength		: [3, 4], //3,4자리
	        	messages 		: {
	        		required 	: $.getMsg($.msg.personalinfo.common.enterRequired, "부사업자 휴대폰번호"),
	            	digits 		: $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }

		//부사업자 휴대폰번호 3
	    if($("#partnerMobile03").length){
	    	$("#partnerMobile03").rules("add", {
	    		required 		: {
	        		param 		: true,
	        		depends 	: function(element){
	        			return ( $("#partnerMobile01 option:selected").val()||$("#partnerMobile02").val() || $.agreeCheck("#partnerMobileAgree1"));
	        		}
	        	},
	        	digits			: true,
	            rangelength		: [4, 4],
	        	messages 		: {
	        		required 	: $.getMsg($.msg.personalinfo.common.enterRequired, "부사업자 휴대폰번호"),
	            	digits 		: $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"]),
	            	rangelength : $.getMsg($.msg.signup.doNotInputFormReInput, [ "전화번호", "다시"])
	        	}
	        });
	    }

		// 이메일 주소
	    if($("#email").length){
	    	$("#email").rules("add", {
	    		required 		: true,
	        	emailCheck 	: true,
	        	includeAmwayCheck : true,
	        	certify 		: {param: emailCertify},
	        	messages 		: {
	        		required 	: $.getMsg($.msg.common.required, "이메일 주소"),
	            	certify 	: $.getMsg($.msg.signup.certify, "이메일을")
	        	}
	        });
	    }
	    
	    // 주소
	    if($("#formattedAddress").length){
	    	$("#formattedAddress").rules("add", {
	    		required 			: {
	        		param 			: true,
	        		depends 		: function(element){
	        			return $.agreeCheck("#addressAgree1");
	        		}
	        	},
	        	isEmptyAddressInfo 	: {
	        		param 			: true,
	        		depends 		: function(element){	        			
	        			return $.agreeCheck("#addressAgree1");
	        		}
	        	},
	        	messages 			: {
	        		required 		: $.agreeCheck("#addressAgree1") 	? $.getMsg($.msg.common.required, "\"주소\"")
	        															: $.getMsg($.msg.common.inputDetail, "\"주소\"를") 
	        	}
	        });
	    }
	    
	    // 후원수당 정보 전달 방법 선택
	    if($("#sponsorBenefitNotifyType1").length){
	    	$("[name='sponsorBenefitNotifyType']").rules("add", {
	    		required : true,
	        	messages : {
	        		required: $.msg.signup.sponsorbenefitnotifytypeRequired
	        	}
	        });
	    }	    
	}
	
	$.addValidationPayment = function(){
		//반품계좌 약관동의 추가
	    if($("#refoundAccount").length){
	    	$("#refoundAccount").rules("add", {
	    		required 		: true,
	        	messages 		: {
	        		required 	: $.msg.paymentInfo.collectAgree,
	        	}
	        });					    	
	    }
		
	    // 거래은행 선택
	    if($("#bankCode").length){
	    	$("#bankCode").rules("add", {
	    		required 		: true,
	        	messages 		: {
	        		required 	: $.getMsg($.msg.common.selectDetail, "거래은행을"),
	        	}
	        });					    	
	    }
    
	    // 계좌번호
	    if($("#accountNumber").length){
	    	$("#accountNumber").rules("add", {
	    		required 	 : true,
	    		number 		 : true,
	        	messages 	 :{
	        		required : $.getMsg($.msg.common.inputDetail, "계좌번호를"),
	        		number   : $.msg.common.inputOnlyNumber
	        	}
	        });					    	
	    }
	    
	    // 계좌 비밀번호
	    if($("#bankPassword").length){
	    	$("#bankPassword").rules("add", {
	    		required	    : true,
	    		number 		    : true,
	    		rangelength     : [6, 6],
	        	messages 	    : {
	        		required    : $.msg.paymentInfo.requiredPassword,
	        		number      : $.msg.common.inputOnlyNumber,
	        		rangelength : $.msg.paymentInfo.passwordOnlyNumber
	        	}
	        });					    	
	    }		
	    
	    // 계좌 비밀번호 확인
	    if($("#confirmBankPassword").length){
	    	$("#confirmBankPassword").rules("add", {
	    		required 		: true,
	    		equalTo			: "#bankPassword",
	        	messages		: {
	        		required 	: $.msg.paymentInfo.requiredConfirmPassword,
	        		equalTo		: $.msg.paymentInfo.equalToPassword
	        			
	        	}
	        });					    	
	    }
	}
})(jQuery);

$("document").ready(function(){
	$("[id^=mobile0]").each(function() {
		beforeMobileNo += $(this).val();
	});
	$("[id^=home0]").each(function() {
		beforeHomeNo += $(this).val();
	});
	
	// validation common setting
	$.validator.setDefaults({
		ignoreTitle : true,
		focusCleanup : false, 
		focusInvalid : false, 
		onclick : false, 
		onkeyup : false,
		onfocusout : false,
		showErrors : function(errorMap, errorList){
			if(errorList[0]){
				try{
					_validationFlag = "submit";
				}catch(e){}
				
				var oError = errorList[0];
				alert(oError.message);
				$(oError.element).focus();
			}
		}
	});
	
	$.validator.addMethod("email", function(value, element){
	    return true;
	}, '');
	
	//법정생년월일 확인 (ex:19860101)
	$.validator.addMethod("isBirthday", function(value, element) {
		var year = value.substring(0, 4); 
		var month = value.substring(4,6)-1;
		var day = value.substring(6,8);
		
		vDate = new Date();
		var crrYear = vDate.getFullYear();
		if(crrYear < year || (crrYear-100) > year){
			return false;
		}
		vDate.setFullYear(1900,0,1);
		vDate.setMinutes(00);
		vDate.setSeconds(00);
		vDate.setFullYear(year);
		vDate.setDate(day);
		vDate.setMonth(month);

		if( vDate.getFullYear() != year	||
			vDate.getMonth()    != month||
			vDate.getDate()     != day ){
			return false;
		}
		return true;
	}, $.msg.personalinfo.common.inputIncorrectInfo);
	
    //주소 정보가 모두 들어왔는지 확인(koreaAddressType, postalCode, line1, line2, town, streetName, streetNumber)
	$.validator.addMethod("isEmptyAddressInfo", function(value, element, param) {
		return $.isEmptyAddressInfo();
	}, $.getMsg($.msg.signup.doNotInputFormReInput, ["\"주소\"", "다시"]));
	
	// 동적으로 생성된 약관 리스트의 동의여부를 체크하기 위한 검증 로직 추가
	$.validator.addMethod("isAdult", function(value, element, param) {
		return $.comm.util.isAdult(value);
	}, $.getMsg($.msg.signup.doNotRegisterMinor, "Member"));
	
	// 동적으로 생성된 약관 리스트의 동의여부를 체크하기 위한 검증 로직 추가
	$.validator.addMethod("agree", function(value, element, param) {
		return $(element).is(":checked");
	}, "termType");
	
	$.validator.addClassRules("termAgreeCk", {agree:true});
		
	// 인증영역의 대한 검증 로직 추가
	$.validator.addMethod("certify", function(value, element, param) {
		return param.getStatus();
	}, $.getMsg($.msg.signup.doNotPersonallyCertifyAfterDoit, "주민등록번호 인증을 먼저") );

	// 간편 인증 결과
	$.validator.addMethod("simpleCertify", function(value, element, param) {
		return param.checkCertify.val() == "true" && param.serverCertify.val() == "true";
	}, $.getMsg($.msg.signup.doNotPersonallyCertifyAfterDoit, "본인확인을") ); 
	
	//-------- signup 4단계 회원정보 입력 메소드 ------------
	//영문성명체크 메소드
	$.validator.addMethod("englishNameCheck", function(value, element){
		var engNm = $.trim(value);
	    return this.optional(element) || !(/[^a-zA-Z\s]{1,}/gi.test( engNm )) && /^([^\s])/.test( engNm ) 
	    	&& /([^\s])$/.test( engNm ) && !(/(\s)\1{1,}/g.test( engNm ));// && !(/\s{2,}/g.test(value));
	}, $.msg.signup.inputEnglishNameForm);
	
	//비밀번호 영문 숫자 조합 6~8자리 체크 메소드
	$.validator.addMethod("defaultPasswordCheck", function(value, element){
	    return this.optional(element) || /^(?=.*[a-zA-Z])(?=.*[\d]).{6,8}$/.test( value ) && !(/[^a-zA-Z0-9]{1,}/g.test( value )); 
	    //!(/[\s]/g.test(value));
	}, $.msg.signup.inputPasswordForm);
	
	//비밀번호 연속된 문자 체크 메소드
	$.validator.addMethod("continuationPasswordCheck", function(value, element){
	    return this.optional(element) || !(/(.)\1{3,}/g.test( value ));
	}, $.msg.signup.doNotPasswordRepeatWord);
	
	//비밀번호 전화번호 포함여부 확인
	$.validator.addMethod("doNotIncludePhoneNum", function(value, element, param){
        var password = value;
        var include = false;
        if(param){
            for (var i = 0 ; i<param.length ; i++){
                include = value.match(param[i]);
                if(include){
                    break;
                }
            }
        }
        return this.optional(element) || !include ;
         
	}, $.getMsg($.msg.signup.doNotPasswordIncludeWord, "전화번호가"));
	
	//email id 체크 메소드
	$.validator.addMethod("emailCheck01", function(value, element){
	    return this.optional(element) || /^[_0-9a-zA-Z-](\.?[_0-9a-zA-Z-])*$/.test(value);
	}, $.getMsg($.msg.signup.doNotInputFormReInput, ["이메일", "abcd@gmail.com 형태로"]));
	
	//email @이하 체크 메소드
	$.validator.addMethod("emailCheck02", function(value, element){
	    return this.optional(element) || /^[0-9a-zA-Z-]*(\.[0-9a-zA-Z-]+)*$/.test(value);
	}, $.getMsg($.msg.signup.doNotInputFormReInput, ["이메일", "abcd@gmail.com 형태로"]));
	
	$.validator.addMethod("emailCheck", function(value, element){
	    return this.optional(element) || /^[_0-9a-zA-Z-](\.?[_0-9a-zA-Z-])*@[0-9a-zA-Z-]*(\.[0-9a-zA-Z-]+)*$/.test(value);
	}, $.getMsg($.msg.signup.doNotInputFormReInput, ["이메일", "abcd@gmail.com 형태로"]));
	
	//email amway.com 체크 메소드
	$.validator.addMethod("includeAmwayCheck", function(value, element){
	    return this.optional(element) || !(/amway.com$/.test(value));
	}, $.msg.signup.doNotEmailAmway);
	
	//인증된 값 검증 param = { tempData, currentData}
	$.validator.addMethod("certifyInterSpon", function(value, element, param){
		if(param[0] != param[1]){
			$("#okeyBtn").parent().show();
			$("#cancelBtn").parent().hide();
			return false;
		}
		return true;

	}, $.getMsg($.msg.signup.doNotInputFormReConfirm, ["국제후원자 정보가", "다시"]));
	
	// idCheck 체크 메소드
	$.validator.addMethod("idCheck", function(value, element){
		return /^[a-zA-Z0-9_]{6,10}$/.test(value) && /^[a-zA-Z]{1,}/.test(value);
	}, $.msg.signup.inputIdForm);
	
	//비밀번호에 아이디 포함여부 확인
	$.validator.addMethod("doNotIncludeId", function(value, element, param){
        return !value.match(param.toLowerCase());
	}, $.getMsg($.msg.signup.doNotPasswordIncludeWord, "아이디가"));
	
	// 숫자 이외의 값 체크
	$.validator.addMethod("onlyNumber", function(value, element, param){
        return /^\d{4,4}$/.test(value);
	}, $.msg.personalinfo.menuLock.passwordOnlyNumber);
	
	// 잠금메뉴 선택
	$.validator.addMethod("menuCheck", function(value, element){
	    return $(".menuBoxCheck:checked").length > 0;
	}, $.msg.personalinfo.menuLock.checkMenu);
	
	$.validator.addMethod("equalTo", function(value, element, param){
		return $(param).val() == value;
	}, ""); 
	
	if($("#isABO").length){
		isABO = eval($("#isABO").val());
	}
	
	// 회원정보 변경 페이지
    $(".validationForm").validate({
    	showErrors: function(errorMap, errorList){
			if(errorList[0]){
				$("a#nextStepSignup").attr("href", "#");
				var oError = errorList[0];
				
				if(oError.message == "termType")
				{
					var message = $(oError.element).next().children("span").text();
					alert($.getMsg($.msg.signup.termsAgreement, message));
				}
				else
				{
					alert(oError.message);
				}
				
				// class notFocus 선언된 element는 focus 이동 시키지 않는다.
				if($(oError.element).hasClass("notFocus")!=true)
				{
					$(oError.element).focus();
					$(oError.element).moveCenterView();
				}
			}
		},
		submitHandler: function(form){
			if($("#personallyCertify").length){
				$("#personallyCertify").val(personallyCertify.getStatus());
			}
			
			if($("#realNameCertify").length){
				$("#realNameCertify").val(realNameCertify.getStatus());
			}
			
			if($("#name").length){
				$("#name").val($("#name").val().replace(/\s*/g, ""));
			}
			
			if($("#sponsorCertify").length){
				$("input#sponsorCertify").val(sponsorCertify.getStatus());
			}
			
			if($("#intersponsorCertify").length && $(".toggleBox.inter.on").length){
				$("input#intersponsorCertify").val(interSponsorCertify.getStatus());
			}else{
				$("input#intersponsorCertify").val(false);
			}
			
			if($("#accountCertify").length){
				$("#accountCertify").val(accountNumberCertify.getStatus());
			}
			
			if($("#emailCertify").length){
				$("#emailCertify").val(emailCertify.getStatus());
			}
			
			if($("#idCertify").length){
				$("#idCertify").val(idCertify.getStatus());
			}

			form.submit();
		} 	
    });

    if($("form.validationForm").length){
    	$.addValidation();
    }
    
    
    
    // 인증 관련 페이지
	$(".certifyForm").validate({
		submitHandler: function(form){
			
			if($(form).data("id") == "certifyMember" ){
				//Member 회원 중복체크
				$.certify.dupMemberCheck(form);
				return false;
			}
			
			if($(form).find("#mobile").length){
				$("#castMobile").val($.comm.util.castPhone($("#mobile").val()));
			}
			form.submit();
			return false;
				
		}
	});
	
    $("form#basicUpdateForm").validate({
    	submitHandler: function(form){
    		if(confirm($.msg.personalinfo.common.saveInfo)){
	    		loadingLayerS();
	    		if($("#emailCertify").length){
					$("#emailCertify").val(emailCertify.getStatus());
				}
	    		
	    		$.ajaxUtil.postAjaxForm($(form), $.comm.ajaxUrl.changeMyBasicInfo, function(data){
	    			if(data.result == true){
						var msg = $.msg.personalinfo.common.saved;
						var afterMoblieNo = "";   var afterHomeNo = "";
						$("[id^=mobile0]").each(function() {
							afterMoblieNo += $(this).val();
						});
						$("[id^=home0]").each(function() {
							afterHomeNo += $(this).val();
						});
						if( beforeMobileNo != afterMoblieNo || beforeHomeNo != afterHomeNo ) {
							msg += "\n" +
									"이후부터 적용되오니 주문 시 변경사항 확인 부탁 드립니다.";
						}
						
	    				loadingLayerSClose();
	    				alert(msg);
	    				window.location.href = data.path;
	    			}else{
	    				loadingLayerSClose();
	    				$.ajaxUtil.errorMessage(data);
	    			}
				});
    		}
			return false;
    	}
    });
    
    $("form#agreeUpdateForm").validate({
		submitHandler: function(form){
			if(confirm($.msg.personalinfo.common.saveInfo)){
				loadingLayerS();
				$.ajaxUtil.postAjaxForm($(form), $.comm.ajaxUrl.changeMyAgreeInfo, function(data){
					if(data.result == true){
						loadingLayerSClose();
						alert(data.message);
						window.location.href = data.path;
					}else{
						loadingLayerSClose();
						$.ajaxUtil.errorMessage(data);
					}
				});
			}
			return false;
		}
	});
    
    $("form#typeChangeForm").validate({
		submitHandler: function(form){
			if(confirm($.msg.personalinfo.common.saveInfo)){
				loadingLayerS();
				$.ajaxUtil.postAjaxForm($(form), $.comm.ajaxUrl.changeSponsorType, function(data){
					if(data.result == true){
						loadingLayerSClose();
						alert(data.message);
						window.location.href = data.path;
					}else{
						loadingLayerSClose();
						$.ajaxUtil.errorMessage(data);
					}
				});
			}
			return false;
		}
	});
    
    if($("form.updateForm").length){
    	$.addValidationCustomerUpdate();
    }  

    if($("form.certifyForm").length){
    	$.addValidationCertify();
    }
    
    // 비밀번호 변경
	$(".changePassword").validate({
		submitHandler: function(form){
			var url;
			loadingLayerS();
			if($(form).attr("id") == "passwordChange"){
				url = $.comm.ajaxUrl.changePwMypage;
			}else if($(form).attr("id") == "updatePasswordForm"){
				url = $.comm.ajaxUrl.changePwReset;
			}else if($(form).attr("id") == "recommendPasswordChange"){
				url = $.comm.ajaxUrl.changePwRecommend;
			}

			$.ajaxUtil.postAjaxForm($(form), url, function(data){
				if (data.result === true) {
					alert($.msg.signup.completeChangePassword);
					window.location.href = data.path;
					loadingLayerSClose();
				} else {
					$.ajaxUtil.errorMessage(data);
					loadingLayerSClose();
				}
			});

			return false;	
		}
	});

    if($("form.changePassword").length){
    	$.addValidationPassword();
    }
    
    // 잠금 비밀번호
	$("#lockPwReSetting, #menuLockEditForm").validate({
		showErrors: function(errorMap, errorList){
			if(errorList[0]){
				var oError = errorList[0];
				alert(oError.message);
				// class notFocus 선언된 element는 focus 이동 시키지 않는다.
				if($(oError.element).hasClass("notFocus")!=true)
				{
					$(oError.element).focus();
					$(oError.element).moveCenterView();
				}
			}
		},
		submitHandler: function(form){
			
			var url;
			var alertMessage;
			if($(form).attr("id") == "menuLockEditForm"){
				url = $.comm.ajaxUrl.menuLockEdit;
				alertMessage = $.msg.personalinfo.menuLock.completeMenuLockSetting;
			}else if($(form).attr("id") == "lockPwReSetting"){
				url = $.comm.ajaxUrl.changeMenuPw;
				alertMessage = $.msg.personalinfo.menuLock.changePassword;
			}

			$.ajaxUtil.postAjaxForm($(form), url, function(data){
				if (data.result === true){
					alert(alertMessage);
					
					var returnUrl = "/mypage";
					if($(form).attr("id") == "lockPwReSetting"){
						returnUrl = data.path;
					}
					
					window.location.href = returnUrl;
				} else {
					$.ajaxUtil.errorMessage(data);
				}
			});
			
			return false;
		}
	});

    if($("form#lockPwReSetting").length){
    	$.addValidationMenuLock();
    }
    
    // 잠금 비밀번호 본인확인
	$("#menuLockAuthForm").validate({
		submitHandler: function(form){
			$(form).find("#personallyCertify").val(personallyCertify.getStatus()); 
			
			if($("#findingBtn").length){
				form.submit();
				return false;
			}
			
			var url = $.comm.ajaxUrl.checkMenuLockAuth;
			
			$.ajaxUtil.postAjaxForm($(form), url, function(data){
				if (data.result === true){
					form.submit();
				} else {
					$.ajaxUtil.errorMessage(data);
				}
			});
			
			return false;
		}
	});

    // 전자(세금) 계산서 수신정보
    $("#taxBillsReceiveInfo").validate({
    	submitHandler: function(form){
    		$.ajaxUtil.postAjaxForm($(form), $.comm.ajaxUrl.taxBillsReceiveInfoPage, function(data){
				if (data.result === true) {
					$('#uiLayerPop_elecTax a.btnPopClose').trigger('click');
				} else {
					$.ajaxUtil.errorMessage(data);
				}
			});
    		return false;
    	}
    });
    
    if($("form#taxBillsReceiveInfo").length){
    	$.addValidationTaxBillsReceiveInfo();
    }
    
    // 패스워드 체크(본인 확인) - 회원 탈퇴
    $(".resignPasswordCheckFormForAuth").validate({
    	submitHandler: function(form){
    		$.ajaxUtil.postAjaxForm($(form), $.comm.ajaxUrl.checkPassword, function(data){
    			if(data == false){
    				alert($.msg.resign.passwordError);
    			}else{
    				var lastConfirm = true;
					if($("form.lastStep").length){
						lastConfirm = confirm($.msg.resign.resignConfirm);
					}
					
					if(lastConfirm){
						form.submit();
					}
    			}
			})
			
			return false;
    	}
    });
    
    // 패스워드 체크(본인 확인)
    $(".passwordCheckFormForAuth").validate({
    	submitHandler: function(form){
    		$.ajaxUtil.postAjaxForm($(form), $.comm.ajaxUrl.checkPassword, function(data){
    			if(data == false){
    				alert($.msg.paymentInfo.passwordError);
    			}else{
    				form.submit();
    			}
			})
			
			return false;
    	}
    });
    
    if($("form.passwordCheckFormForAuth").length || $("form.resignPasswordCheckFormForAuth").length){
    	$("#password").rules("add", {
    		required : true,
        	messages : {
        		required : $.getMsg($.msg.common.notEnterField, "비밀번호"),
        	}
        });
    }
    
    // 개인정보 활용 동의 변경
    $(".changeUseAgreement").validate({
		submitHandler: function(form){
			loadingLayerS();
			var url = $.comm.ajaxUrl.changeUseAgreement;
		
			$.ajaxUtil.postAjaxForm($(form), url, function(data){
				if (data.result === true) {
					alert($.msg.useAgreement.changeSuccess);
					var isFromMyPageMessageBox = $(".isFromMyPageMessageBox").text();
				
					if(isFromMyPageMessageBox.length){
						window.location.href = "/mypage";
					}else{
						history.back();
					}
					loadingLayerSClose();
				} else {
					$.ajaxUtil.errorMessage(data);
					loadingLayerSClose();
				}
			});
			return false;	
		}
	}); 
    
    
    // 계좌
    $("form#paymentForm").validate({
		submitHandler: function(form){
			var saveUrlRegex = /(.*)(\/.*?)/gi; //  
			var addAjaxUrlPath = "$1/ajax$2";
			var url = $(form).attr("action").replace(saveUrlRegex, addAjaxUrlPath);
			
			loadingLayerS();
			$.ajaxUtil.postAjaxForm($(form), url, function(data){
				loadingLayerSClose();
				if (data.result === true) {
					if(data.message){
						alert(data.message);
					}
					
					if(data.path){
						window.location.href = data.path;
					}else{
						if(opener != null) {
							window.self.close();
						}
					}
				} else {
					$.ajaxUtil.errorMessage(data);
				}
			});
		}
	});
    
    if($("form#paymentForm").length){
    	$.addValidationPayment();
    }

});
