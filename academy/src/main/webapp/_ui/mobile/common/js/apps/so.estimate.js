(function($) {
	$.estimate = {
			data : {
				  url : "/_ui/mobile"
				, isEstimateCreate : false
				, isEstimateList : false
				, totalDeliveryPrice : "3300"
				, deliveryPrice : "3000"
				, freeDeliveryPrice : "60000"
				, deliveryTaxAmount : "300"
				, productCode : ""
				, vpsCode : ""
				, productName : ""
				, productPrice : ""
				, websiteAklSiteHttps : ""
				, quickOrderList : []
				, quickSearchList : []
				, isSeeMore : ""
				, page : ""
				, inProgress : false
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					cache	 : false,
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ){ 
							errorCallBack(); 
						} else {
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},
			getData : function(type, page, pop){
				var searchValue = $.trim($("input[name=corSearch]").val());
				
				if(type=="R"){
					$.estimate.getSearchData(page, "", "R", pop);
				}else if(type=="O"){
					searchValue = $.trim($("#nameOldSearch").val());
					//조회후 결과없음 알림창 비교를 위해 분리호출
					$.estimate.getSearchData(page, searchValue, "O", pop);
				}else{
					if(searchValue==""){
						alert($.msg.estimate.intputSearchWord);
						$("input[name=corSearch]").focus();
						return;
					}
					//조회후 결과없음 알림창 비교를 위해 분리호출
					$.estimate.getSearchData(page, searchValue, "S", pop);
				}
				return false;
			},
			getSearchData : function(page, searchValue, option, pop){
				if(option=="S" && $.estimate.data.inProgress){
					return false;
				}
				$.estimate.data.inProgress = true;
				var actionUrl  = "/shop/estimate-sheet/business-registration/ajax/search";
				var params	   = {};

				params.page	       = page;
				params.searchValue = searchValue;
				if(pop){
					params.type = "popup";
				}				

				$.estimate.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					$.estimate.data.inProgress = false;
					if(option=="S" || option=="R"){
						if(pop){
							$("#bizList").html(data);
						}else{
							$("#registrationList").html(data);
						}
					}else{
						$("#bizList").html($("#bizList").html()+data);
					}

					$("input[name=corSearch]").val(searchValue);
					$("#nameOldSearch").val(searchValue);

					//검색오류알림
					if(option=="S"){
						var tmpTot= $("#listInfo").attr("data-code");
						tmpTot = $.returnNumber(tmpTot);
						if(tmpTot<=0)
						{
							alert($.msg.estimate.noSearchResult);
							$("input[name=corSearch]").focus();
							$.estimate.setSeeMore();
							return;
						}
					}
					$.estimate.setSeeMore();
				}, function errorCallBack(data){
					$.estimate.data.inProgress = false;
				});
			},
			setSeeMore : function(){
				if($.estimate.data.isSeeMore == "false"){
					$("#btnBizSeeMore").hide();
				}else{
					$("#btnBizSeeMore").show();
				}
			}			
	};
	// ############################################################################
	// 견적 내역
	// ############################################################################

	// 더보기 - SeeMore
	$(document).off("click", "#btnEstimateSeeMore").on("click", "#btnEstimateSeeMore", function(e){
		$.estimate.data.page++;
		var actionUrl  = "/shop/estimate-sheet/list/ajax/seeMore";
		$.estimate.list.getToEstimate(actionUrl, $.estimate.data.page, 20);
		return false;
	});

	$.estimate.list = {
			getToEstimate : function(actionUrl, page, range) {
				
				var params = {};

				params.page = page;
				params.range = range;
				
				$.estimate.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					$("#estimateList").html($("#estimateList").html()+data);
					$.estimate.setSeeMore();
				}, null);
			}
	}

	// ############################################################################
	// 사업자등록증 관리
	// ############################################################################	

	$(document).ready(function(){
		// 사업자 등록증 관리 입력 format 정의
		$.bizRegistration.inputFormat();
	});
	
	// 더보기 - SeeMore
	$(document).off("click", "#btnBizSeeMore").on("click", "#btnBizSeeMore", function(e){
		$.estimate.data.page++;
		$.estimate.getData("O", $.estimate.data.page, $(this).attr("data-type"));
		return false;
	});

	$(document).off("click", "#regtDetail").on("click", "#regtDetail", function(e){
		var entry = $(this).parents("li").find("input[name=entry]").val();
		var apprDt = $(this).parents("li").find("input[name=appr]").val();
		var url = "/shop/estimate-sheet/business-registration/detail?registrationNumber=" + entry + "&apprDt=" + apprDt;
		$.windowOpener(url, $.getWinName());
		return false;
	});

	// 검색 버튼
	$(document).on("click", "#btnSearch", function(){
		$.estimate.getData("S", 1, $("#btnBizSeeMore").attr("data-type"));
	});

	// 검색 입력 엔터 처리 
	$(document).on("keydown", "input[name=corSearch]", function(e){
		if (e.keyCode == 13) {
			$.estimate.getData("S", 1, $("#btnBizSeeMore").attr("data-type"));
			return false;
		}
	});

	// 검색 초기화
	$(document).on("click", "#corReset", function(e){
		$.estimate.getData("R", 1, $("#btnBizSeeMore").attr("data-type"));
		return false;
	});

	// 사업자 등록증 저장
	$(document).on("click", "#btnRegistrationSave", function(){
		$.bizRegistration.getData($(this));
	});

	// 사업자 등록증 삭제
	$(document).on("click", "#btnRegistrationDelete", function(){
		if(confirm($.msg.estimate.businessLicenseDelete)){
			$.bizRegistration.deleteLicense($(this));
		}
	});
	
	$.bizRegistration = {
			data : {
				registrationNumber 	: ""
				, apprDt 			: ""
				, taxName			: ""
				, email 			: ""
				, cellPhone 		: ""
				, cellSMS	 		: false
				, aboEmailAddr		: ""
				, aboCellPhone		: ""
				, aboCellSMS 		: false
			},
			// 사업자등록증 저장
			saveLicense : function(){
				var actionUrl  = "/shop/estimate-sheet/business-registration/ajax/save";

				$.bizRegistration.setData();

				$.estimate.callAjax('POST', actionUrl, 'json', $("#bizRegistrationForm").serialize(), function successCallBack(data){
					if(data.status == $.msg.common.success){
						alert($.msg.common.saveDone);
						location.href = "/shop/estimate-sheet/business-registration?history=true";
					} else {
						var msg = data.status;
						msg = msg.replace(/\\n/g, "\\\n").replace(/\\/g, "");
						alert(msg);
					}
				}, null);
			},
			getData : function(obj){
				if(!$.bizRegistration.checkInputData(obj)){
					return;
				}
				
				if(confirm($.msg.estimate.saveModification)){
					$.bizRegistration.saveLicense();
				}
			},
			setData : function(){
				$("#bizRegistrationForm #taxName").val($.bizRegistration.data.taxName || "");
				$("#bizRegistrationForm #email").val($.bizRegistration.data.email || "");
				$("#bizRegistrationForm #cellPhone").val($.bizRegistration.data.cellPhone || "");
				$("#bizRegistrationForm #cellSMS").val($.bizRegistration.data.cellSMS || false);
				$("#bizRegistrationForm #aboEmailAddr").val($.bizRegistration.data.aboEmailAddr || "");
				$("#bizRegistrationForm #aboCellPhone").val($.bizRegistration.data.aboCellPhone || "");
				$("#bizRegistrationForm #aboCellSMS").val($.bizRegistration.data.aboCellSMS || false);
			},
			checkInputData : function(obj){
				var emailCheck = /^[A-Za-z0-9]+[\w.-]+[\w.-]*[@]{1}[\w-]+[\w.-]*[.]{1}[A-Za-z]{2,5}$/;
				
				var stdObj 				= obj.parents("section#pbContent");
				// 전자세금계산서 수신정보
				var taxName				= $.trim(stdObj.find("#taxForm #taxName").val());
				var cellPhone01			= $.trim(stdObj.find("#taxForm #cellPhone01").val());
				var cellPhone02			= $.trim(stdObj.find("#taxForm #cellPhone02").val());
				var cellPhone03			= $.trim(stdObj.find("#taxForm #cellPhone03").val());
				var email	 			= $.trim(stdObj.find("#taxForm #email").val());
				var cellSMS		 		= stdObj.find("#taxForm #taxSms").is(":checked");
				
				// 중개 ABO 정보
				var aboCellPhone01		= $.trim(stdObj.find("#aboForm #aboCellPhone01").val());
				var aboCellPhone02		= $.trim(stdObj.find("#aboForm #aboCellPhone02").val());
				var aboCellPhone03		= $.trim(stdObj.find("#aboForm #aboCellPhone03").val());
				var aboEmail 			= $.trim(stdObj.find("#aboForm #aboEmail").val());
				var aboCellSMS		 	= $("input:radio[name='aboSms'][checked]").attr("value");
				
				// 전자세금계산서 수신정보
				if(taxName.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "받는이의 성함을"));
					$("#taxName").focus();
					return false;
				}
				
				if(cellPhone01.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "전자세금계산서 수신용 휴대폰 식별번호를"));
					$("#cellPhone01").focus();
					return false;
				}
				
				if(cellPhone02.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "전자세금계산서 수신용 휴대폰 앞번호를"));
					$("#cellPhone02").focus();
					return false;
				}
				
				if(cellPhone03.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "전자세금계산서 수신용 휴대폰 뒷번호를"));
					$("#cellPhone03").focus();
					return false;
				}
				
				if(email.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "전자세금계산서 수신용 수신자 이메일 주소를"));
					$("#email").focus();
					return false;
				}

				if(!emailCheck.test(email)){
					alert($.getMsg($.msg.signup.doNotInputFormReInput, ["전자세금계산서 수신용 이메일", "abcd@gmail.com 형태로"]));
					$("#email").focus();
					return false;
				}
				
				// 중개 ABO 정보
				if(aboCellPhone01.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "중개 ABO 정보용 휴대폰 식별번호를"));
					$("#aboCellPhone01").focus();
					return false;
				}
				
				if(aboCellPhone02.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "중개 ABO 정보용 휴대폰 앞번호를"));
					$("#aboCellPhone02").focus();
					return false;
				}
				
				if(aboCellPhone03.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "중개 ABO 정보용 휴대폰 뒷번호를"));
					$("#aboCellPhone03").focus();
					return false;
				}
				
				if (!$("input:radio[name='aboSms']:checked").val()) {
					alert($.msg.estimate.selectAboSMS);
					$("input:radio[name='aboSms']")[0].focus();
					return false;
				}
				
				if(aboEmail.length <= 0){
					alert($.getMsg($.msg.common.inputDetail, "중개 ABO 정보용 이메일 주소를"));
					$("#aboEmail").focus();
					return false;
				}

				if(!emailCheck.test(aboEmail)){
					alert($.getMsg($.msg.signup.doNotInputFormReInput, ["중개 ABO 정보용 이메일", "abcd@gmail.com 형태로"]));
					$("#aboEmail").focus();
					return false;
				}
				var cellPhone			= cellPhone01 + "-" + cellPhone02 + "-" + cellPhone03;
				var aboCellPhone		= aboCellPhone01 + "-" + aboCellPhone02 + "-" + aboCellPhone03;
				
				$.bizRegistration.data.taxName	 		= taxName;
				$.bizRegistration.data.cellPhone 		= cellPhone;
				$.bizRegistration.data.email 			= email;
				$.bizRegistration.data.cellSMS 			= cellSMS;
				$.bizRegistration.data.aboCellPhone 	= aboCellPhone;
				$.bizRegistration.data.aboEmailAddr 	= aboEmail;
				$.bizRegistration.data.aboCellSMS 		= aboCellSMS;
				
				return true;
			},
			// 사업자등록증 삭제
			deleteLicense : function(obj){
				var actionUrl  = "/shop/estimate-sheet/business-registration/ajax/delete";
				var params	   = {};
				var stdObj = obj.parents("section#pbContent");
				var apprDt = $.trim(stdObj.find("#bizRegistrationForm #apprDt").val());
				var registrationNumber = $.trim(stdObj.find("#bizRegistrationForm #registrationNumber").val());

				params.apprDt		 	  = apprDt;
				params.registrationNumber = registrationNumber;

				$.estimate.callAjax('GET', actionUrl, 'json', params, function successCallBack(data){
					if(data.status == $.msg.common.success){
						alert($.msg.common.saveDone);
						location.href = "/shop/estimate-sheet/business-registration";
					}
				}, null);				
			},
			// format 정의
			inputFormat : function(){
				// 받는 이 한글만 입력
				$("#taxName").inputOnlyKorean();
				
				// only 숫자 입력 및 Maxlength 설정
				$("#cellPhone02").inputOnlyNumber();
				$("#cellPhone02").css("ime-mode", "disabled");
				$("#cellPhone02").attr("maxlength", "4");
				
				$("#cellPhone03").inputOnlyNumber();
				$("#cellPhone03").css("ime-mode", "disabled");
				$("#cellPhone03").attr("maxlength", "4");
				
				$("#aboCellPhone02").inputOnlyNumber();
				$("#aboCellPhone02").css("ime-mode", "disabled");
				$("#aboCellPhone02").attr("maxlength", "4");
				
				$("#aboCellPhone03").inputOnlyNumber();
				$("#aboCellPhone03").css("ime-mode", "disabled");
				$("#aboCellPhone03").attr("maxlength", "4");
				
				// email 한글 사용 불가(크롬 안됨)
			    $("#email02").css("ime-mode", "disabled");
			    $("#email03").css("ime-mode", "disabled");
			    
			    $("#aboEmailAddr02").css("ime-mode", "disabled");
			    $("#aboEmailAddr03").css("ime-mode", "disabled");
			}
	}	
})(jQuery);