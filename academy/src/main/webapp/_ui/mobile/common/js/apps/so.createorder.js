// New ABO Promotion
var newABOEntryDate = new Date(2016, 2, 1);
var newABOStartDate = new Date(2016, 2, 2, 10);
var newABOEndDate = new Date(2016, 2, 31, 23, 50);

$(document).ready(function(){
	$.order.initCheckoutButton();   // 결제버튼영역 초기화
	
	new beta.fix("#silgle_delivery_message");
	new beta.fix("#multi_delivery_message");

	// pilot 기간동안 기능제한
	if (isPilotLimited == 'true' && $("#reserve_order_check").val() == "true") {
		alert($.getMsg($.msg.common.pilotLimited));
		if ($("#goto_prev_page").attr("href") != undefined) {
	    	window.location.href = $("#goto_prev_page").attr("href");
	    } else {
	    	window.location.href = $("#goto_cart").attr("href");
	    }
		return false;
	}
	
	function FlashObject (path, width, height) {
	    var m_movie = path;
	    var m_width = width;
	    var m_height = height;

	    this.wmode = "";
	    this.id = "";
	    this.quality = "high";
	    this.menu = "false";
	    this.allowScriptAccess = "sameDomain";
	    this.FlashVars = "";

	    this.Render = function()
	    {
	        var html = "<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0' width='" + m_width + "' height='" + m_height + "'";
		        if (this.id != "") {
		        	html += " id='" + this.id + "'";
		        }
		        html += ">";
		        
		        html += "<param name='allowScriptAccess' value='" + this.allowScriptAccess + "' />";
		        html += "<param name='movie' value='" + m_movie + "' />";
		        html += "<param name='menu' value='" + this.menu + "' />";
		        html += "<param name='quality' value='" + this.quality + "' />";
		        if (this.wmode != "") {
		        	html += "<param name='wmode' value='" + this.wmode + "' />";
		        }
		        if (this.FlashVars != "") {
		        	html += "<param name='FlashVars' value='" + this.FlashVars + "' />";
		        }
		        html += "<embed src='" + m_movie + "' quality='" + this.quality + "' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' width='" + m_width + "' height='" + m_height + "'";
		        html += " allowScriptAccess='" + this.allowScriptAccess + "'";
		        if (this.wmode != "") {
		        	html += " wmode='" + this.wmode + "'";
		        }
		        if (this.FlashVars != "") {
		        	html += " FlashVars='" + this.FlashVars + "'";
		        }
		        html += " /></object>";
	        
	        document.write(html);
	    }
	}
});

(function($) {

	$(document).off("click", "#checkUserBenefit").on("click", "#checkUserBenefit", function(e){
		$.checkBenefit(true, null, null);
		return false;
	});

	// ==========================================
	// 제품목록 이벤트 - 재고상태, 제품삭제
	// ==========================================
	// 재고상태클릭
	$(document).on("click", "#checkout_stock_status_msg", function() {
		var productCode = $(this).parent("a").parent("span").parent("div").find("input").val();
		layerPopupOpen($("#click_uiLayerPop_stockStatus_detail_" + productCode));
	});
	
	// 제품목록에서 삭제버튼 클릭
	$(document).on("click", "#checkout_stock_status_product_delete", function(event) {
		event.preventDefault();
		
		// 제품이 하나만 있는 경우는 이전페이지로 이동
		if ($("#order_product_list ").find("li[id^=product_row_]").length == 1) {
			alert($.order.message.MSG_RETURN_PRE_PAGE_NO_PRODUCT);
			if ($("#goto_prev_page").attr("href") != undefined) {
		    	window.location.href = $("#goto_prev_page").attr("href");
		    } else {
		    	window.location.href = $("#goto_cart").attr("href");
		    }
		} else {
			var stockStatus = $("#checkout_stock_status_msg").text();
			if (confirm(stockStatus + $.order.message.MSG_DELETE_PRODUCT)) {
				$.order.deleteProductFromOrderEntry($(this).parent("div").find("input").val());
			} else {
				return false;
			}
		}
	});
		
	// 제품상태팝업에서 확인버튼 클릭
	$(document).on("click", "#restriction_popup_confirm_button", function(event) {
		event.preventDefault();
		if ($(':radio[name="restrict_popup"]:checked').val() == undefined) {
			alert($.order.message.MSG_NO_CHOICE_RESTRICTION_POPUP);
			return false;
		}
		
		var option = $(':radio[name="restrict_popup"]:checked').val();
		if (option == 'returnToPrevUrl') {
	    	window.location.href = $("#goto_prev_page").attr("href");
	    } else if (option == 'returnToCart') {
	    	window.location.href = $("#goto_cart").attr("href");
		} else {
			if ($("#order_product_list ").find("em[id=checkout_stock_status_orderable]").length == 0) {
				alert($.order.message.MSG_RETURN_PRE_PAGE_NO_PRODUCT);
				if ($("#goto_prev_page").attr("href") != undefined) {
			    	window.location.href = $("#goto_prev_page").attr("href");
			    } else {
			    	window.location.href = $("#goto_cart").attr("href");
			    }
			} else {
				$.order.deleteProductFromOrderEntry( option );
			}
		}
	});
	
	// 재고상태상세팝업 닫기버튼
	$(document).on("click", "#stock_status_detail_popup_close", function () {
		$(this).parent("div").parent("div").parent("div").find("a[id='stock_status_detail_popup_closex']").click();
	});

	// ==========================================
	// 배송방법 선택 이벤트
	// ==========================================
	// 배달주문 또는 AP주문 선택 라디오버튼 이벤트
	$(document).on("change", ":radio[name=select_run_pickup_radio]", function() {
		var checkedVal = $(':radio[name=select_run_pickup_radio]:checked').val();
		if (checkedVal == 'run') {
	        $.checkBenefit(true, $.order.selectDeliveryChoice(checkedVal), null);
		} else if (checkedVal == 'pickup') {
	        $.checkBenefit(true, $.order.selectDeliveryChoice(checkedVal), null);
		}
	}).filter(function(){
	   return this.checked;
	}).change();

	// ==========================================
	// 새 배송지 팝업띄우는 이벤트
	// ==========================================
	$(document).on("touchstart click", "#delivery_new_address", function(event) {
		event.preventDefault();
		if ($("#reserve_order_check").val() == "true" || $("#reserve_order_check_current_time").val() == "true") {
			alert($.order.message.MSG_NOT_ALLOWED_NEW_ADDRESS);
			return false;
		}
		var actionUrl = "/shop/order/checkout/orderCreatingNewAddressPopup";

		$.order.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_delivery").html(data);
			layerPopupOpen($("#delivery_new_address"));
		}, null, false);
	});
	
	// ==========================================
	// 단일배송지 선택 이벤트
	// ==========================================
	$(document).on("change", "#delivery_single_delivery_choice_memAddr01", function() {
		$.order.selectSingleDeliveryAddress();
	});

	// 배달주문 - 단일배송 또는 복수배송 선택 라디오버튼 이벤트
	$(document).on("change", ":radio[name=delivery_silgle_multi]", function() {
		$.order.selectDeliveryAddrSection();
	}).filter(function(){
	   return this.checked;
	}).change();
	
	// [단일배송지]목록 버튼 클릭
	$(document).on("touchstart click", "#delivery_single_choice_button", function () {
		var actionUrl = "/shop/order/checkout/orderCreatingSingleAddressListPopup";
		$.order.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_delivery").html(data);
			layerPopupOpen($("#delivery_single_choice_button"));
		}, null, false);
	});
	
	// [단일 배송지 화면] - 배송메세지 입력 & 체크
	$(document).on("keydown", "#silgle_delivery_message", function() {
		$.order.checkCharacter($(this), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});
	$(document).on("keyup", "#silgle_delivery_message", function() {
		$.order.checkCharacter($(this), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});
	$(document).on("focusout", "#silgle_delivery_message", function() {
		$.order.checkCharacter($(this), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});

	$(document).on("change", "#silgle_delivery_default_message", function(event) {
		event.preventDefault();
		$("#silgle_delivery_message").val($("#silgle_delivery_default_message option:selected").val());
		$.order.checkCharacter($("#silgle_delivery_message"), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});
	
	// 배송지팝업에서 선택버튼
	$(document).on("click", "#delivery_single_delivery_choice_radio_hidden", function () {
		$.order.checkStockForDelivery('noReset');
	});

	// ==========================================
	// [복수 배송지 화면] - 배송지목록 버튼클릭
	// ==========================================

	$(document).on('keyup', "#gratitudePhone2", function(){
       	$.numberValidationCheck($(this));
    });
	$(document).on('keyup', "#gratitudePhone3", function(){
       	$.numberValidationCheck($(this));
    });

	$(document).on("touchstart click", "#delivery_multi_choice_button", function(event) {
		event.preventDefault();
		var actionUrl = "/shop/order/checkout/orderCreatingMultiAddressListPopup";
		$.order.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_delivery").html(data);
			$.deliveryAddress.listEvent();
			layerPopupOpen($("#delivery_multi_choice_button"));
		}, null, false);
		return false;
	});

	// 배송메세지 입력창 클릭
	$(document).on("keydown", "#multi_delivery_message", function() {
		$.order.checkCharacter($(this), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});
	$(document).on("keyup", "#multi_delivery_message", function() {
		$.order.checkCharacter($(this), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});
	$(document).on("focusout", "#multi_delivery_message", function() {
		$.order.checkCharacter($(this), 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});
	$(document).on("change", "#multi_delivery_default_message", function(event) {
		event.preventDefault();
		var deliveryMsgObj = $(this).parent("div").find("textarea[id=multi_delivery_message]"); 
		deliveryMsgObj.val($(this).val());
		$.order.checkCharacter(deliveryMsgObj, 40, $.order.message.MSG_DELIVERY_MESSAGE);
	});

	// 배송지 삭제 버튼클릭
	$(document).on("click","#delivery_multi_choice_bntAddrDelete", function(event) {
		event.preventDefault();
		$.order.clickMultiDeliveryListDeleteButton($(this));
	});	
	
	// [복수 배송지 화면] - 배송지가 추가되는 경우의 이벤트
	$(document).on("click", "#multi_address_add_radio_hidden", function (event) {
		event.preventDefault();
		// 결제방법 초기화
		$.order.initializePaymentAreaAjax();
		$.order.initializeEvidenceTermsAreaAjax();
		// 결제금액 초기화
		$.order.initializePaymentAmountAreaAjax();
	});
	
	// [복수 배송지 화면] - 배송지 전체 내용보기 버튼 클릭
	$(document).on("click", "#open_all_multi_delivery", function(event) {
		event.preventDefault();
		$("#delivery_multi_choice_addrList").find(".deliInputBox").each(function() {
			var obj = $(this);
			obj.addClass('on');
			obj.find('img').attr('src',obj.find('img').attr("src").split("_open.gif").join("_close.gif")).attr('alt','상세닫기');
		});
	});
	
	// [복수 배송지 화면] - 배송지 전체 내용닫기 버튼 클릭
	$(document).on("click", "#close_all_multi_delivery", function(event) {
		event.preventDefault();
		$("#delivery_multi_choice_addrList").find(".deliInputBox.on").each(function() {
			var obj = $(this);
			obj.removeClass('on');
			obj.find('img').attr('src',obj.find('img').attr("src").split("_close.gif").join("_open.gif")).attr('alt','상세열기');
		});
	});
	
	$(document).on("click", "#multi_delivery_detail_close", function (event) {
		event.preventDefault();
		$.order.openCloseMultiDeliveryDetail($(this));
	});
	
	// [복수 배송지 화면] 보내는 분 길이변경
	$(document).on("keyup", "#gratitudeSender", function() {
		$.order.checkCharacter($(this), 30, $.order.message.MSG_GRATITUDE_SENDER_MESSAGE);
	});
	$(document).on("focusout", "#gratitudeSender", function() {
		$.order.checkCharacter($(this), 30, $.order.message.MSG_GRATITUDE_SENDER_MESSAGE);
	});

	$(document).on("click", "#deliMsgChkbox", function() {
		if($("#deliMsgChkbox").is(":checked")){
			var iLoop = 0;
			var message = "";
			$("textarea[name='multi_delivery_message']").each(function() {
				if(iLoop==0){
					message = $(this).val();
				}else{
					$(this).val(message);
					$.order.checkCharacter($(this), 40, null);
				}
				iLoop++;
			});
		}
	});

	// ==========================================
	// 픽업주문 AP선택 이벤트
	// ==========================================
	$(document).on("change", "#delivery_ap_choice", function() {
		$.order.selectApDeliveryAddress();
	});
	
	// AP안내팝업
	$(document).on("click", "#apInfoBtn", function (event) {
		event.preventDefault();
		$.order.clickApInfoPopupButton();
	});

	// 배송안내
	$(document).on("click", "#deliveryInfoBtn", function (event) {
		event.preventDefault();
		var popupUrl = "/static/shop/order/cart/checkout/shipping-guide";
		$.windowOpener(popupUrl, $.getWinName());
		return false;
	});

	// ==========================================
	// 설치주문 배송지 선택 이벤트
	// ==========================================
	$(document).on("change", "#install_order_delivery_info_choice_address", function() {
		$.order.selectInstallDeliveryAddress();
	});

	$(document).on("click", "#btnInsOrder", function (event) {
		event.preventDefault();
		var popupUrl = "/static/shop/order/install/checkout/installation-order-guide";
		$.windowOpener(popupUrl, $.getWinName());
		return false;
	});

	// ==========================================
	// [쿠폰페이지] - 쿠폰선택버튼 클릭
	// ==========================================
	$(document).on("click", "#coupon_choice_button", function(event) {
		event.preventDefault();
		
		// pilot 기간동안 기능제한
		if (isPilotLimited == 'true') {
			alert($.getMsg($.msg.common.pilotLimited));
			return false;
		}
		
		if ($(':radio[name=select_run_pickup_radio]:checked').val() == 'run' && $(".inputRad" ).find("input:checked").val() == 'multiAddr') {
			// 복수배송시 쿠폰사용불가 메세지
			alert($.order.message.MSG_MULTI_ADDR_NO_USE_COUPON);
			return false;
		}

		// 예약주문시 쿠폰사용불가 (AS400 시스템연동불가)
		if ($("#reserve_order_check").val() == "true" || $("#reserve_order_check_current_time").val() == "true") {
			alert($.order.message.MSG_RESERVE_ORDER_NO_USE_COUPON);
			return false;
		}

		var actionUrl = "/shop/order/checkout/orderCreatingCouponPopup";
		
		$.order.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_Coupon").html(data);
			layerPopupOpen($("#coupon_choice_button"));
		}, null, true);
	});
	
	// [쿠폰선택팝업] - 적용버튼 클릭
	$(document).on("click", "#coupon_popup_button_apply", function(event) {
		event.preventDefault();
		// 선택된 쿠폰이 없는 경우
		if ($("input[name=choice_coupon_radio]:checked").val() == undefined || $("input[name=choice_coupon_radio]:checked").val().length == 0) {
			alert($.order.message.MSG_NO_SELECTED_COUPON);
			return false;
		}

		$.order.clickCouponPopupPageApplyButton($("input[name=choice_coupon_radio]:checked").val(), $(this).parents("#uiLayerPop_Coupon"));
		return false;
	});
	
	// [쿠폰선택팝업] - 등록버튼 클릭
	$(document).on("click", "#registe_coupon_popup_button", function(event) {
		event.preventDefault();
		var couponNum = $("#coupon_popup_number");
		// 입력된 쿠폰이 없는 경우
		if (couponNum.val() == undefined || couponNum.val().length == 0) {
			alert($.order.message.MSG_NO_INPUT_COUPON);
			return false;
		}
		if($.order.couponValidationCheck(couponNum)){
			$.order.clickCouponPopupPageApplyButton(couponNum.val(), $(this).parents("#uiLayerPop_Coupon"));
		}
		return false;
	});
	
	// [쿠폰선택팝업] 더보기
	$(document).on("click", "#btnCouponSeeMore", function(event){
		event.preventDefault();
		$.order.data.page++;
		$.order.gestCouponData($.order.data.page);
		return false;
	});

	// [쿠폰선택팝업] 체크박스 선택 이벤트
	$(document).off("change", "input[name=choice_coupon_radio]").on("change", "input[name=choice_coupon_radio]", function(e)
	{
		$("input[name=choice_coupon_radio]").prop('checked', false);
		$(this).attr('checked', true);
	});

	// [쿠폰선택팝업] 취소 버튼
	$(document).on("click", "#btnCouponCancel", function(event) {
		event.preventDefault();
		closeLayerPopup($(this).parents("#uiLayerPop_Coupon"));
		$("#uiLayerPop_Coupon").html("");
		return false;
	});

	// [쿠폰선택팝업] 닫기 버튼
	$(document).on("click", ".btnPopClose", function() {
		closeLayerPopup($(this).parents("#uiLayerPop_Coupon"));
		$("#uiLayerPop_Coupon").html("");
		return false;
	});	
	
	$(document).on("keydown", "#coupon_popup_number", function(e){
		$.inputOnlyNumberEng(e);
		//$.inputOnlyNumber(e);
	});
	
	// [쿠폰선택팝업] 쿠폰등록 유효성 체크
	$(document).on('keyup', "#coupon_popup_number", function(){
		$(this).val($(this).val().toUpperCase());
       	$.order.couponValidationCheck($(this));
       	return false;
    });
	
	// 쿠폰적용취소 버튼
	$(document).on("click", "#coupon_apply_cancel", function(event) {
		event.preventDefault();
		$.order.clickCouponApplyCancel();

		// 결제방법 초기화
		$.order.initializePaymentAreaAjax();
		// 결제방법 다음부분 초기화
		$.order.initializeEvidenceTermsAreaAjax();
		// 결제금액 초기화
		$.order.initializePaymentAmountAreaAjax();
	});
	
	// 쿠폰적용시 결제방법초기화를 위한 이벤트
	$(document).on("click", "#coupon_apply_radio_hidden", function (event) {
		event.preventDefault();
		// 결제방법 초기화
		$.order.initializePaymentAreaAjax();
	});
	
	// ==========================================
	// [결재방법 선택]  
	// ==========================================
	$(document).on("change", ":radio[name=payment_type]", function() {
        $.order.choicePaymentArea();
	}).filter(function(){
	   return this.checked;
	}).change();
	
	// ==========================================
	// [결재방법 - 신용카드] 
	// ==========================================
	
	// [Apoint] 모두사용체크 
	$(document).on("change", "#payment_type_card_apoint_allUse", function() {
		$.order.checkAllPointUse('card',
				$("#payment_type_card_apoint_allUse"), 
				$("#payment_type_card_apoint_input"), 
				$("#payment_type_card_apoint_rawdata"));
	});
	// [A포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keydown", "#payment_type_card_apoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_card_apoint_input"));
	});
	// [A포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keyup", "#payment_type_card_apoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_card_apoint_input"));
	});
	// [A포인트] 입력부분에 포커스 IN
	$(document).on("focus", "#payment_type_card_apoint_input", function() {
		$.order.focusInPointInputBox(
				$("#payment_type_card_apoint_allUse"), 
				$("#payment_type_card_apoint_input"), 
				$("#payment_type_card_apoint_rawdata"));
	});
	// [A포인트] 입력부분에 포커스 OUT
	$(document).on("blur", "#payment_type_card_apoint_input", function() {
		$.order.focusOutPointInputBox('card',
				$("#payment_type_card_apoint_allUse"), 
				$("#payment_type_card_apoint_input"), 
				$("#payment_type_card_apoint_rawdata"));
	});
	// [A포인트] 적용버튼 이벤트
	$(document).on("click", "#payment_type_card_apoint_apply", function(event) {
		event.preventDefault();
		$.order.applyInputAPoint($(this), $("#payment_type_card_apoint_rawdata"), $("#payment_type_card_apoint_input"), $("#payment_type_card_apoint_allUse"), $("#payment_type_card_hold_point"), true);
	});
	
	
	// [멤버포인트] 모두사용체크 
	$(document).on("change", "#payment_type_card_mpoint_allUse", function() {
		$.order.checkAllPointUse('card',
				$("#payment_type_card_mpoint_allUse"), 
				$("#payment_type_card_mpoint_input"), 
				$("#payment_type_card_mpoint_rawdata"));
	});
	// [멤버포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keydown", "#payment_type_card_mpoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_card_mpoint_input"));
	});
	$(document).on("keyup", "#payment_type_card_mpoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_card_mpoint_input"));
	});
	// [멤버포인트] 입력부분에 포커스 IN
	$(document).on("focus", "#payment_type_card_mpoint_input", function() {
		$.order.focusInPointInputBox(
				$("#payment_type_card_mpoint_allUse"), 
				$("#payment_type_card_mpoint_input"), 
				$("#payment_type_card_mpoint_rawdata"));
	});
	// [멤버포인트] 입력부분에 포커스 OUT
	$(document).on("blur", "#payment_type_card_mpoint_input", function() {
		$.order.focusOutPointInputBox('card',
				$("#payment_type_card_mpoint_allUse"), 
				$("#payment_type_card_mpoint_input"), 
				$("#payment_type_card_mpoint_rawdata"));
	});
	// [멤버포인트] 적용버튼 이벤트
	$(document).on("click", "#payment_type_card_mpoint_apply", function(event) {
		event.preventDefault();
		$.order.applyInputMPoint($(this), $("#payment_type_card_mpoint_rawdata"), $("#payment_type_card_mpoint_input"), $("#payment_type_card_mpoint_allUse"), $("#payment_type_card_hold_point"), true);
	});
	
	
	// 카드선택 이벤트 (카드종류에 따라서 결제방식 바뀜.
	$(document).on("change", "#payment_type_card_choice_card_kind", function() {
		// [20150901 : 박준규] 카드종류 선택 시 엣모스피어 K3관련 alert창으로 인하여 기존의 selected 제거
		$("#installment_period_select_period option:selected").attr("selected", false);
		
		var isReserveOrder = true;
		if ($("#reserve_order_check").val() != "true" && $("#reserve_order_check_current_time").val() != "true") {
			isReserveOrder = false;
		}
		$.order.selectPaymentTypeCardKind(isReserveOrder);
	});
	
	// 결제방식 클릭 (안심결제, 일반결제)
	$(document).on("click", ":radio[name=choice_card_payment_plan]", function() {
		$.order.choiceCardPaymentPlan($(this).val());
	});
	
	// 카드종류선택 (개인, 법인카드)
	$(document).on("click", ":radio[name=choice_card_type]", function() {
		$.order.choiceCardKind($(':radio[name=choice_card_type]:checked').val());
	});
	
	// 카드번호 숫자만 입력, 4자리 입력 시 포커스 이동
	$(document).on("keydown", "#card_number input[id^='card_number_']", function (e) {
		//$.order.checkCardNumber(e);
		$.inputOnlyNumber(e);
	});
	$(document).on("keyup", "#card_number input[id^='card_number_']", function (e) {
		//$.order.checkCardNumber(e);
		$.inputOnlyNumber(e);
		$.removeSpecialChar($(this));
		if($(this).parent().next().length && $(this).val().length == 4){
			e.preventDefault();
			$(this).parent().next().find("input[id^='card_number_']").focus();
		}
	});
	
	// 카드사혜택보기 버튼 클릭
	$(document).on("click", "#payment_type_card_card_benefits", function(event) {
		event.preventDefault();
		$.order.clickHowtopayCardBenefitsButton();
	});
	
	// 카드사 혜택보기 팝업 닫기
	$(document).on("click", "#card_benefit_close", function (event) {
		event.preventDefault();
		self.close();
	});
	$(document).on("click", "#card_benefit_close_x", function (event) {
		event.preventDefault();
		self.close();
	});
	
	// 카드 - 할부개월수 선택이벤트
	$(document).on("change", $("#installment_period_select_period"), function() {
		if( $("#bf_select_period").val() == $("#installment_period_select_period option:selected").attr("id") ) {
			return true;
		}
		$.order.selectCardInstallmentPeriod();
	});
	
	// 카드 유효기간 월 체크
	$(document).on("blur", "#expiry_date_month", function () {
		$.order.checkCardExpiryMonthBlur($(this))
	});
	
	// 카드 유효기간 년 체크
	$(document).on("blur", "#expiry_date_year", function () {
		$.order.checkCardExpiryYearBlur($(this))
	});
	
	// 카드 비밀번호 입력값체크
	$(document).on("blur", "#credit_card_password", function () {
		$.order.checkCardPasswordBlur($(this))
	});
	
	// 개인카드입력 생년월일 입력값체크
	$(document).on("blur", "#card_birth_date", function () {
		$.order.checkCardBirthDateBlur($(this))
	});
	
	// 법인카드입력 사업자등록번호 입력값체크
	$(document).on("blur", "#card_corporate_reg_number", function () {
		$.order.checkCardCorporateRegNumberBlur($(this));
	});

	// ==========================================
	// [결재방법 - 무통장입금] 결제계좌선택
	// ==========================================
	$(document).on("change", "#payment_type_bank_transfer_choice_bank", function() {
		$.order.selectDwpBankAccount();
	});
	
	// 입금자명 입력값체크
	$(document).on("blur", "#bank_transfer_depositor", function() {
		$.order.checkInputValueDepositorName();
	});
	
	// ==========================================
	// [결재방법 - 자동이체] 
	// ==========================================
	// [Apoint] 모두사용체크 
	$(document).on("change", "#payment_type_direct_debit_apoint_allUse", function() {
		$.order.checkAllPointUse('directDebit',
				$("#payment_type_direct_debit_apoint_allUse"), 
				$("#payment_type_direct_debit_apoint_input"), 
				$("#payment_type_direct_debit_apoint_rawdata"));
	});
	// [A포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keydown", "#payment_type_direct_debit_apoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_direct_debit_apoint_input"));
	});
	// [A포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keyup", "#payment_type_direct_debit_apoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_direct_debit_apoint_input"));
	});
	// [A포인트] 입력부분에 포커스 IN
	$(document).on("focus", "#payment_type_direct_debit_apoint_input", function() {
		$.order.focusInPointInputBox(
				$("#payment_type_direct_debit_apoint_allUse"), 
				$("#payment_type_direct_debit_apoint_input"), 
				$("#payment_type_direct_debit_apoint_rawdata"));
	});
	// [A포인트] 입력부분에 포커스 OUT
	$(document).on("blur", "#payment_type_direct_debit_apoint_input", function() {
		$.order.focusOutPointInputBox('directDebit',
				$("#payment_type_direct_debit_apoint_allUse"), 
				$("#payment_type_direct_debit_apoint_input"), 
				$("#payment_type_direct_debit_apoint_rawdata"));
	});
	// [A포인트] 적용버튼 이벤트
	$(document).on("click", "#payment_type_direct_debit_apoint_apply", function(event) {
		event.preventDefault();
		$.order.applyInputAPoint($(this), $("#payment_type_direct_debit_apoint_rawdata"), $("#payment_type_direct_debit_apoint_input"), $("#payment_type_direct_debit_apoint_allUse"), $("#payment_type_direct_debit_hold_point"), true);
	});

	
	// 자동이체계좌등록 버튼 클릭
	$(document).on("click", "#registe_direct_debit", function () {
		if (confirm($.order.message.MSG_REGISTE_DIRECT_DEBIT_ACCOUNT) == true) {
			window.location.href = "/mypage/paymentinfo/";
		} else {
			return false;
		}
	});
	// 자동이체계좌 비밀번호 체크
	$(document).on("blur", "#direct_debit_password", function () {
		if ($(this).val().length > 0) {
			$.order.checkDirectDebitPasswordBlur($(this));
		}
	});

	// 자동이체 안내 더보기 클릭
	$(document).on("click", "#payment_type_direct_debit_infoMore", function(event) {
		event.preventDefault();
		$("#payment_type_direct_debit .bankingInfo #direct_debit_info").show();
		$("#payment_type_direct_debit_infoMore").hide();
		return false;
	});
	// 자동이체 안내 닫기 클릭
	$(document).on("click", "#payment_type_direct_debit_infoClose", function(event) {
		event.preventDefault();
		$("#payment_type_direct_debit .bankingInfo #direct_debit_info").hide();
		$("#payment_type_direct_debit_infoMore").show();
		return false;
	});
	

	// ==========================================
	// [결재방법 - 자동이체예약] 
	// ==========================================
	// 자동이체 안내 더보기 클릭
	$(document).on("click", "#payment_type_direct_debit_reservation_infoMore", function(event) {
		event.preventDefault();
		$("#payment_type_direct_debit_reservation .bankingInfo #direct_debit_reserve_info").show();
		$("#payment_type_direct_debit_reservation_infoMore").hide();
		return false;
	});
	// 자동이체 안내 닫기 클릭
	$(document).on("click", "#payment_type_direct_debit_reservation_infoClose", function(event) {
		event.preventDefault();
		$("#payment_type_direct_debit_reservation .bankingInfo #direct_debit_reserve_info").hide();
		$("#payment_type_direct_debit_reservation_infoMore").show();
		return false;
	});
	
	// 자동이체계좌등록 버튼 클릭
	$(document).on("click", "#registe_direct_debit_reservation", function () {
		if (confirm($.order.message.MSG_REGISTE_DIRECT_DEBIT_ACCOUNT) == true) {
			window.location.href = "/mypage/paymentinfo/";
		} else {
			return false;
		}
	});
	
	// 자동이체계좌 비밀번호 체크 
	$(document).on("blur", "#direct_debit_reservation_password", function () {
		if ($(this).val().length > 0) {
			$.order.checkDirectDebitPasswordBlur($(this));
		}
	});
	
	// ==========================================
	// [결재방법 - A포인트] 
	// ==========================================
	// [Apoint] 모두사용체크 
	$(document).on("change", "#payment_type_apoint_apoint_allUse", function() {
		$.order.checkAllPointUse('apoint',
				$("#payment_type_apoint_apoint_allUse"), 
				$("#payment_type_apoint_apoint_input"), 
				$("#payment_type_apoint_apoint_rawdata"));
	});
	// [A포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keydown", "#payment_type_apoint_apoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_direct_debit_apoint_input"));
	});
	// [A포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keyup", "#payment_type_apoint_apoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_direct_debit_apoint_input"));
	});
	// [A포인트] 입력부분에 포커스 IN
	$(document).on("focus", "#payment_type_apoint_apoint_input", function() {
		$.order.focusInPointInputBox(
				$("#payment_type_apoint_apoint_allUse"), 
				$("#payment_type_apoint_apoint_input"), 
				$("#payment_type_apoint_apoint_rawdata"));
	});
	// [A포인트] 입력부분에 포커스 OUT
	$(document).on("blur", "#payment_type_apoint_apoint_input", function() {
		$.order.focusOutPointInputBox('apoint',
				$("#payment_type_apoint_apoint_allUse"), 
				$("#payment_type_apoint_apoint_input"), 
				$("#payment_type_apoint_apoint_rawdata"));
	});
	// [A포인트] 적용버튼 이벤트
	$(document).on("click", "#payment_type_apoint_apoint_apply", function(event) {
		event.preventDefault();
		$.order.applyInputAPoint($(this), $("#payment_type_apoint_apoint_rawdata"), $("#payment_type_apoint_apoint_input"), $("#payment_type_apoint_apoint_allUse"), $("#payment_type_apoint_hole_point"), true);
	});
	
	// ==========================================
	// [결재방법 - 멤버포인트] 
	// ==========================================
	// [Mpoint] 모두사용체크 
	$(document).on("change", "#payment_type_mpoint_mpoint_allUse", function() {
		$.order.checkAllPointUse('mpoint',
				$("#payment_type_mpoint_mpoint_allUse"), 
				$("#payment_type_mpoint_mpoint_input"), 
				$("#payment_type_mpoint_mpoint_rawdata"));
	});
	// [멤버포인트] 입력부분에 숫자만 입력되는 지 체크
	$(document).on("keydown", "#payment_type_mpoint_mpoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_mpoint_mpoint_input"));
	});
	$(document).on("keyup", "#payment_type_mpoint_mpoint_input", function() {
		$.order.checkPointInputBoxValue($("#payment_type_mpoint_mpoint_input"));
	});
	// [멤버포인트] 입력부분에 포커스 IN
	$(document).on("focus", "#payment_type_mpoint_mpoint_input", function() {
		$.order.focusInPointInputBox(
				$("#payment_type_mpoint_mpoint_allUse"), 
				$("#payment_type_mpoint_mpoint_input"), 
				$("#payment_type_mpoint_mpoint_rawdata"));
	});
	// [멤버포인트] 입력부분에 포커스 OUT
	$(document).on("blur", "#payment_type_mpoint_mpoint_input", function() {
		$.order.focusOutPointInputBox('mpoint',
				$("#payment_type_mpoint_mpoint_allUse"), 
				$("#payment_type_mpoint_mpoint_input"), 
				$("#payment_type_mpoint_mpoint_rawdata"))
	});
	// [멤버포인트] 적용버튼 이벤트
	$(document).on("click", "#payment_type_mpoint_mpoint_apply", function(event) {
		event.preventDefault();
		$.order.applyInputMPoint($(this), $("#payment_type_mpoint_mpoint_rawdata"), $("#payment_type_mpoint_mpoint_input"), $("#payment_type_mpoint_mpoint_allUse"), $("#payment_type_mpoint_hold_point"), true);
	});
	
	// ==========================================
	// [결재방법 - 결제증빙내역관련] 
	// ==========================================	
	// [결제방법 : 세금계산서] - 라디오버튼클릭 (사업자등록증 선택팝업 Alert)
	$(document).on("click", ":radio[name=payment_evidence_choice]", function() {
		// 거래증빙라디오 버튼 클릭시 클릭안된 데이터는 삭제함.
		$.order.checkPaymentEvidenRadio();

		if($(":radio[name=payment_evidence_choice]:checked").val() == 'tax_bill' && $("#bizInfoNumber").val().length == 0) {
			$("#bizinfo_choice_button").focus();
			$("#bizinfo_choice_button").trigger("click");
		}
	});

	// [결제방법 : 사업자등록증관리] - 사업자등록증 버튼 클릭
	$(document).on("click", "#bizinfo_choice_button", function(event) {
		event.preventDefault();
		$(":radio[value='tax_bill']").attr("checked", "checked");
		
		var actionUrl = "/shop/estimate-sheet/business-registration?type=popup";
		$.order.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_bizReg").html(data);
			layerPopupOpen($("#bizinfo_choice_button"));
		}, null, true);
		// 거래증빙라디오 버튼 클릭시 클릭안된 데이터는 삭제함.
		$.order.checkPaymentEvidenRadio();
	});
	
	// [결제증빙내역 : 현금영수증] 종류별 최대길이, 비밀번호처리
	$(document).on("change", "#cash_receipt_kind", function() {
		var receiptKind = $("#cash_receipt_kind option:selected").val();
		var objSpan = $(this).parent("p").find("span[class='input']");
		var objNumber = $(this).parent("p").find("input[id='cash_reciept_number']");
		objNumber.remove();
		
		if (receiptKind == 'CPN') {
			// 휴대폰번호
			var html = "<input type='number' name='cash_reciept_number' id='cash_reciept_number' size='21' minlength='10' maxlength='11' oninput='$.maxLengthCheck(this);' title='현금영수증 증빙신청 휴대폰번호'/>";
			objSpan.append(html);
		} else if (receiptKind == 'SSN') {
			// 주민번호
			var html = "<input type='number' name='cash_reciept_number' id='cash_reciept_number' size='21' minlength='13' maxlength='13' oninput='$.maxLengthCheck(this);' style='-webkit-text-security:disc;' title='현금영수증 증빙신청 주민번호'/>";
			objSpan.append(html);
		} else if (receiptKind == 'CDN') {
	        // 현금영수증카드번호
			var html = "<input type='number' name='cash_reciept_number' id='cash_reciept_number' size='21' minlength='15' maxlength='18' oninput='$.maxLengthCheck(this);' title='현금영수증 증빙신청 현금영수증카드번호'/>";
			objSpan.append(html);
		} else if (receiptKind == 'BRN') {
			// 사업자등록번호
			var html = "<input type='number' name='cash_reciept_number' id='cash_reciept_number' size='21' minlength='10' maxlength='10' oninput='$.maxLengthCheck(this);' title='현금영수증 증빙신청 사업자등록번호'/>";
			objSpan.append(html);
		}
	});
	
	// [결제증빙내역 : 현금영수증] 입력값 체크
	$(document).on("focusout", "#cash_reciept_number", function () {
		$.order.checkCashRecieptNumber($(this));
	});
	
	// pilot 기간동안 기능제한
	$(document).on("click", "#payment_evidence_pvbv", function () {
		if (isPilotLimited == 'true' && $("#payment_evidence_pvbv").attr('checked') != 'checked') {
			alert($.getMsg($.msg.common.pilotLimited));
			$("#payment_evidence_pvbv").attr("checked", "checked");
			return false;
		}
	});
	$(document).on("click", "#payment_evidence_price", function () {
		if (isPilotLimited == 'true' && $("#payment_evidence_price").attr('checked') != 'checked') {
			alert($.getMsg($.msg.common.pilotLimited));
			$("#payment_evidence_price").attr("checked", "checked");
			return false;
		}
	});
	
	// ==========================================
    // [결재요청] - 결제요청버튼을 클릭
	// ==========================================
	$(document).on("click", "#request_checkout", function(event) {
		event.preventDefault();
		// $.order.requestCheckoutProcess($.order.checkOutPaymentProcess);
		$.order.checkStockForDelivery('requestCheckOut', $.order.requestCheckoutProcess);
		return false;
	});
	
    // [결재요청] - 예약주문팝업 체크
	$(document).on("click", "#reserve_order_popup_approve_close", function(event) {
		event.preventDefault();
		if ($.order.checkReserveOrderAgree()) {
			$(this).parent("span").parent("div").parent("div").find("a[id=reserve_order_popup_approve_closex]").click();
		} else {
			return false;
		}
	});
    // [결재요청] - 예약주문팝업 더보기
	$(document).on("click", "#uiLayerPop_reserveOrder_moreinfo_open", function(event) {
		event.preventDefault();
		$("#uiLayerPop_reserveOrder_moreinfo").show();
		$("#uiLayerPop_reserveOrder_moreinfo_open").hide();
	});
    // [결재요청] - 예약주문팝업 더보기 닫기
	$(document).on("click", "#uiLayerPop_reserveOrder_moreinfo_close", function(event) {
		event.preventDefault();
		$("#uiLayerPop_reserveOrder_moreinfo").hide();
		$("#uiLayerPop_reserveOrder_moreinfo_open").show();
	});
	
	$.order = {
		checkReserveOrderAgree : function () {
			if ($("input[id='pbReserveTermsOK']").attr("checked") != "checked") {
				alert($.order.message.MSG_RESERVE_ORDER_TERMS_APPROVE);
				return false;
			}
			return true;
		},
		clickStockStatusDetailMessage : function (productCode) {
			var popupUrl = "/shop/order/checkout/orderCreatingStockStatusDetailPopupPage?productCode=" + productCode;
			$.windowOpener(popupUrl, $.getWinName());
		},
		clickStockStatusMessage : function (productCode) {
			var popupUrl = "/shop/order/checkout/orderCreatingStockStatusPopupPage";
			$.windowOpener(popupUrl, $.getWinName());
		},
		closeOrderRestrictionPopup : function () {
			if ($("#prev_delivery_choice_type").val() == 'run') {
				if ($(':radio[name=delivery_silgle_multi]:checked').val() == "multiAddr") {
					$.order.initializePaymentAreaAjax();
					$.order.initializeEvidenceTermsAreaAjax();
				} else {
					$.order.initializeDeliveryAreaAjax();
				}
			} else {
				$.order.initializeDeliveryAreaAjax();
			}
			$("#checkout_stock_status_product_delete").focus();
		},
		checkPaymentEvidenRadio : function () {
			// [신청안함]
			if ($(":radio[name=payment_evidence_choice]:checked").val() == 'no_apply') {
				// 사업자등록증부분 초기화
				$("#bizInfoNumber").val("");
				$("#bizInfoApproveDate").val("");
				$("#bizInfoName").val("");
				$("#bizInfo").text("");

				// 현금영수증부분 초기화
				$("#cash_reciept_number").val("");
				$("#cash_reciept_number").attr("disabled", "disabled");
				$("#cash_receipt_kind option:eq(0)").attr("selected", "selected");
				$("#cash_receipt_kind").attr("disabled", "disabled");
				$("#cash_receipt_proof_type option:eq(0)").attr("selected", "selected");
				$("#cash_receipt_proof_type").attr("disabled", "disabled");
			}
			// [세금계산서 선택]
			if ($(":radio[name=payment_evidence_choice]:checked").val() == 'tax_bill') {
				// 현금영수증부분 초기화
				$("#cash_reciept_number").val("");
				$("#cash_reciept_number").attr("disabled", "disabled");
				$("#cash_receipt_kind option:eq(0)").attr("selected", "selected");
				$("#cash_receipt_kind").attr("disabled", "disabled");
				$("#cash_receipt_proof_type option:eq(0)").attr("selected", "selected");
				$("#cash_receipt_proof_type").attr("disabled", "disabled");
			}
			// [현금영수증 선택]
			if ($(":radio[name=payment_evidence_choice]:checked").val() == 'cash_receipt') {
				// 현금영수증부분 초기화
				$("#cash_receipt_kind").removeAttr("disabled");
				$("#cash_reciept_number").removeAttr("disabled");
				$("#cash_receipt_proof_type").removeAttr("disabled");

				// 사업자등록증부분 초기화
				$("#bizInfoNumber").val("");
				$("#bizInfoApproveDate").val("");
				$("#bizInfoName").val("");
				$("#bizInfo").text("");
			}
		},
		deleteProductFromOrderEntry : function (productCode) {
			var param = {};
			param.productCode = productCode;
			
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/deleteProductFromOrderEntry",
				data     : param,
				dataType : "html",
				success: function (data){
					if (data.length == 0) {
						return false;
					}
					// 제품목록부분을 바꿔준다.
					$("#order_product_list *").remove();
					$("#order_product_list").html(data);
					
					// 주문불가상품이 있는 경우, 재고체크안함.
					if ($.order.checkStockStatusMessage() == false) {
						return false;
					}
					
					// 재고체크
					if ($("#prev_delivery_choice_type").val() == 'run') {
						if ($("#prev_delivery_choice_type_single_run").val() == 'singleAddr') {
							if ($(':radio[name=select_run_pickup_radio]:checked').val() != undefined) {
								// 단일주문은 배달방법 선택된 경우만 재고체크
								$.order.checkStockForDelivery("noReset");
							}
						}
						else if ($("#prev_delivery_choice_type_single_run").val() == 'multiAddr') {
							if ($(':radio[name=payment_type]:checked').val() != undefined) {
								// 복수주문은 결제방법이 선택된 상태에서만 재고체크
								$.order.checkStockForDelivery("noReset");
							}
						}
					}
					else if ($(':radio[name=select_run_pickup_radio]:checked').val() == 'pickup') {
						// 픽업주문
						$.order.checkStockForDelivery("noReset");
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		checkStockStatusMessage : function () {
			var statusMsgCnt = 0;
			$("#order_product_list").find("em[id=checkout_stock_status_msg]").each(function () {
				statusMsgCnt++;
			});
			
			if (statusMsgCnt == 0) {
				$("#order_disable_message").text("");
				return true;
			} else {
				$("#order_disable_message").text($.order.message.MSG_ORDER_STOCK_ERROR);
				return false;
			}
		},
		checkAllPointUse : function(paymentMode, checkbox, inputbox, rawdata) {
			// 포인트가 마이너스인 경우
			if ($.order.nanToNumber(rawdata.val()) < 0) {
				alert($.order.message.MSG_PAYMENT_RAWDATA_MINUS_POINT);
				checkbox.removeAttr("checked");
				inputbox.val("0");
				return false;
			}

			var inputablePoint = $.order.nanToNumber($("#payment_amount_section #order_total_sum .total #total_price").val()) + 
			                     $.order.nanToNumber($("#order_total_sum_apoint_rawdata").val()) + 
			                     $.order.nanToNumber($("#order_total_sum_mpoint_rawdata").val());

			// 카드는 결제금액이 1000원 이상, 자동이체는 1원 이상이어야 함.
			if (paymentMode == 'card') {
				if (inputablePoint < 1000) {
					alert($.order.message.MSG_APPLY_APOINT_IS_NOT);
					checkbox.removeAttr("checked");
					return false;
				}
				inputablePoint = inputablePoint - 1000;
			} else if (paymentMode == 'directDebit') {
				if (inputablePoint < 1) {
					alert($.order.message.MSG_APPLY_APOINT_IS_NOT);
					checkbox.removeAttr("checked");
					return false;
				}
				inputablePoint = inputablePoint - 1;
			} else {
				if (inputablePoint == 0) {
					alert($.order.message.MSG_APPLY_APOINT_IS_NOT);
					checkbox.removeAttr("checked");
					return false;
				}
			}

			if (checkbox.attr('checked') == 'checked') {
				if (inputablePoint >= $.order.nanToNumber(rawdata.val())) {
					inputbox.val($.order.nanToNumber(rawdata.val()));
				} else {
					inputbox.val($.order.nanToNumber(inputablePoint));
				}
			} else {
				inputbox.val("0");
			}
		},
		checkPointInputBoxValue : function(inputbox) {
			if (isNaN(inputbox.val()) == true) {
				inputbox.val("");
				return false;
			} 
		},
		focusInPointInputBox : function(checkbox, inputbox, rawdata) {
			checkbox.removeAttr("checked");
		},
		focusOutPointInputBox : function(paymentMode, checkbox, inputbox, rawdata) {
			// to number
			inputbox.val($.order.nanToNumber(inputbox.val()));
			
			// 입력한 포인트가 마이너스인 경우
			if ($.order.nanToNumber(inputbox.val()) < 0) {
				alert($.order.message.MSG_PAYMENT_INPUT_MINUS_POINT);
				inputbox.val("0");
				return false;
			} else {
				// 포인트가 마이너스인 경우
				if ($.order.nanToNumber(rawdata.val()) < 0) {
					alert($.order.message.MSG_PAYMENT_RAWDATA_MINUS_POINT);
					inputbox.val("0");
					return false;
				}
			}

			if (isNaN(inputbox.val()) == true) {
				inputbox.val("0");
				return false;
			} else {
				var inputablePoint = $.order.nanToNumber($("#payment_amount_section #order_total_sum .total #total_price").val()) + 
					                 $.order.nanToNumber($("#order_total_sum_apoint_rawdata").val()) + 
					                 $.order.nanToNumber($("#order_total_sum_mpoint_rawdata").val());

				// 카드는 결제금액이 1000원 이상, 자동이체는 1원 이상이어야 함.
				if (paymentMode == 'card') {
					if (inputablePoint - 1000 < inputbox.val()) {
						alert($.order.message.MSG_APOINT_OVER_PAYMENT_CARD);
						inputbox.val("0");
						return false;
					}
				} else if (paymentMode == 'directDebit') {
					if (inputablePoint - 1 < inputbox.val()) {
						alert($.order.message.MSG_APOINT_OVER_PAYMENT_BANK);
						inputbox.val("0");
						return false;
					}
					inputablePoint = inputablePoint - 1;
				}
			}
			
			// 보유포인트 초과 적용
			if ($.order.nanToNumber(inputbox.val()) > $.order.nanToNumber(rawdata.val())) {
				checkbox.removeAttr("checked");
				alert($.order.message.MSG_PAYMENT_OVER_INPUT_APOINT);
				inputbox.val("0");
				inputbox.focus();
				return false;
			}
		},
		checkCashRecieptNumber : function (inputbox) {
			if (isNaN(inputbox.val())) {
				alert($.order.message.MSG_CASH_RECIEPT_NUMBER_CHECK);
				inputbox.val("");
				return false;
			}

			// 현금영수증 증빙신청번호 최소자리수체크
			if (inputbox.val().length > 0 && inputbox.val().length < inputbox.attr('minlength')) {
				alert($.getMsg($.order.message.MSG_CHECK_INPUT_MIN_LENGTH, [inputbox.attr('title'), inputbox.attr('minlength')]));
				return false;
			}
		},
		applyInputAPoint : function(button, rawdata, inputBox, alluse, holdPointSpan, isLoadingLayer) {
			var rawPoint   = rawdata.val();
			var applyPoint = inputBox.val().split(",").join("");
			var holdPoint  = $.order.nanToNumber(rawPoint) - $.order.nanToNumber(applyPoint);
			
			// 적용 포인트 미입력
			if (applyPoint.length == 0) {
				alert($.order.message.MSG_PAYMENT_INPUT_APOINT);
				inputBox.focus();
				return false;
			}

			if(isLoadingLayer){
				loadingLayerS();
			}
			
			// Ajax 최종결제금액 계산
			var param = {};
			param.addDiscountType = "apoint";
			param.addDiscountAmount = applyPoint;
			
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/applyFinalCheckoutPaymentAjax",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#payment_amount_section *").remove();
					$("#payment_amount_section").html(data);

					inputBox.val(applyPoint);
					
					if ($(':radio[name=payment_type]:checked').val() == '007') {
						// 결재금액이 30만원 이상인 경우에는 일반결제부분 삭제
						$.order.checkCardKindForCheckoutPrice();
						// 5만원 미만인 경우는 disable처리
						$.order.checkCardInstallmentPlan();
					}
					if(isLoadingLayer){
						loadingLayerSClose();
					}
				},
				error: function(xhr, st, err){
					if(isLoadingLayer){
						loadingLayerSClose();
					}
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		applyInputMPoint : function(button, rawdata, inputBox, alluse, holdPointSpan, isLoadingLayer) {
			var rawPoint   = rawdata.val();
			var applyPoint = inputBox.val().split(",").join("");
			var holdPoint  = $.order.nanToNumber(rawPoint) - $.order.nanToNumber(applyPoint);
			
			// 적용 포인트 미입력
			if (applyPoint.length == 0) {
				alert($.order.message.MSG_PAYMENT_INPUT_MPOINT);
				inputBox.focus();
				return false;
			}
			
			if(isLoadingLayer){
				loadingLayerS();
			}
			// Ajax 최종결제금액 계산
			var param = {};
			param.addDiscountType = "mpoint";
			param.addDiscountAmount = applyPoint;
			
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/applyFinalCheckoutPaymentAjax",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#payment_amount_section *").remove();
					$("#payment_amount_section").html(data);

					inputBox.val(applyPoint);
					
					if ($(':radio[name=payment_type]:checked').val() == '007') {
						// 결재금액이 30만원 이상인 경우에는 일반결제부분 삭제
						$.order.checkCardKindForCheckoutPrice();
						// 5만원 미만인 경우는 disable처리
						$.order.checkCardInstallmentPlan();
					}
					if(isLoadingLayer){
						loadingLayerSClose();
					}
				},
				error: function(xhr, st, err){
					if(isLoadingLayer){
						loadingLayerSClose();
					}
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		checkCardInstallmentPlan : function (option) {
			if ($.order.nanToNumber($("#payment_amount_section #order_total_sum .total #total_price").val()) < 50000) {
				$("#installment_period_select_period option:eq(0)").attr("selected", "selected");
				$("#installment_period_select_period").attr("disabled", "disabled");
			} else {
				$("#installment_period_select_period").removeAttr("disabled");
			}
		},
		checkCardKindForCheckoutPrice : function () {
			if ($("#reserve_order_check").val() != "true" && $("#reserve_order_check_current_time").val() != "true") {
				if ($.order.nanToNumber($("#payment_amount_section #order_total_sum .total #total_price").val()) > 300000) {
					$(":radio[value='paySafety']").attr("checked", "checked");
					$.order.choiceCardPaymentPlan('paySafety');

					$("#payment_type_card .payBox #payment_plan .inputBox input[value='payNormal']").hide();
					$("#payment_type_card .payBox #payment_plan .inputBox label[for='payNormal']").hide();
				} else {
					$("#payment_type_card .payBox #payment_plan .inputBox input[value='payNormal']").show();
					$("#payment_type_card .payBox #payment_plan .inputBox label[for='payNormal']").show();
				}
			}
		},
		selectPaymentTypeCardKind : function(isReserveOrder) {
			var cardCode = $("#payment_type_card_choice_card_kind option:selected").val();
			var cardCodeArray = cardCode.split('_');
			var param = {};
			param.cardCode = cardCodeArray[0];
			
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/selectPaymentCardKindAjax",
				data     : param,
				dataType : "json",
				success: function (data){
					$.each(data, function(key, value) {
						if (key == "authType" && isReserveOrder == false) {
							// 안심클릭이 디폴트로 선택되도록
							$(":radio[value='paySafety']").attr("checked", "checked");
							$.order.choiceCardPaymentPlan('paySafety');

							// 30만원 이상인 경우 일반결제 삭제
							$.order.checkCardKindForCheckoutPrice();								
						} else if (key == "installmentPlans") {
							var html = "";
							var isMaxInstallment = false;

							/* [20160126 : 고문석], 앳모스피어 보상판매 프로모션 유이자 10개월 Blocking 수정 Start */
							if($("#plan10EnableGeneral").length > 0) {
								var choiceCardKind = $("#payment_type_card_choice_card_kind option:selected").val();
								
								$.each(value, function(key, value) {
									/* plan10Enable : false && 카드사(국민/현대/삼성/롯데) -> 유이자 10개월 blocking */
									if (value.code != '10' || (value.code == '10' && $("#plan10EnableGeneral").val() == "true") || (value.code == '10' && $("#plan10EnableGeneral").val() == "false" && choiceCardKind != "016_ISP" && choiceCardKind != "027_MPI" && choiceCardKind != "031_MPI" && choiceCardKind != "047_MPI")) {
										html += "<option id='" + value.code + "'>" + value.name + "</option>";
									}
								});
							} else {
								$.each(value, function(key, value) {
									html += "<option id='" + value.code + "'>" + value.name + "</option>";
								});
							}
							/* [20160126 : 고문석], 앳모스피어 보상판매 프로모션 유이자 10개월 Blocking 수정 End */
							
							$("#installment_period_select_period *").remove();
							$("#installment_period_select_period").html(html);
						}
					});
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});		
		},
		selectCardInstallmentPeriod : function () {
			var cardPeriod = $("#payment_type_card .payBox #installment_period_select_period option:selected").attr('id');
			
			$("#bf_select_period").val(cardPeriod);
			
			/* [20160126 : 고문석], 앳모스피어 보상판매 프로모션 유이자 10개월 Blocking 수정 Start */
			if ($("#plan10EnablePromotion").val() == "false" && cardPeriod == "10") {
				// alert("지금 구매하시는 엣모스피어 공기청정기는 프로모션 대상 제품이 아닙니다.");
			}
			/* [20160126 : 고문석], 앳모스피어 보상판매 프로모션 유이자 10개월 Blocking 수정 End */
		},
		resetPoint : function(isMaxInstallment) {
			var paramPointType = "";
			var paramPointObject = null;
			var paramPointAlluseObject = null;
			var paramPointInputObject = null;
			var paramPointButtonObject = null;
			
			// ABO or MEMBER
			if ($("#abo_member_yn").val() == 'true') {
				paramPointType = "apoint";
				paramPointAlluseObject = $("#payment_type_card_apoint_allUse");
				paramPointInputObject  = $("#payment_type_card_apoint_input");
				paramPointButtonObject = $("#payment_type_card_apoint_apply");
			} else {
				paramPointType = "mpoint";
				paramPointAlluseObject = $("#payment_type_card_mpoint_allUse");
				paramPointInputObject  = $("#payment_type_card_mpoint_input");
				paramPointButtonObject = $("#payment_type_card_mpoint_apply");
			}
			
			// 무이자할부여부에 따라
			if (isMaxInstallment == true) {
				paramPointInputObject.val('');
				paramPointAlluseObject.attr("disabled", "disabled");
				paramPointInputObject.attr("disabled", "disabled");
				paramPointButtonObject.hide();
			} else {
				paramPointAlluseObject.removeAttr("disabled");
				paramPointInputObject.removeAttr("disabled");
				paramPointButtonObject.show();
				return false;
			}

			// Ajax 최종결제금액 계산
			var param = {};
			param.addDiscountType = paramPointType;
			param.addDiscountAmount = 0;
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/applyFinalCheckoutPaymentAjax",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#payment_amount_section *").remove();
					$("#payment_amount_section").html(data);

					if ($(':radio[name=payment_type]:checked').val() == '007') {
						// 최종결재금액이 30만원 이상인 경우에는 일반결제부분 삭제
						$.order.checkCardKindForCheckoutPrice();
						// 최종결재금액이 5만원 미만인 경우는 disable처리
						$.order.checkCardInstallmentPlan();
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		choiceCardPaymentPlan : function (paymentPlan) {
			if (paymentPlan == 'paySafety') {
				$("#payment_type_card .payBox #card_number").hide();
				$("#payment_type_card .payBox #expiry_date").hide();
				$("#payment_type_card .payBox #card_password").hide();
				$("#payment_type_card .payBox #birth_date").hide();
				$("#payment_type_card .payBox #corporate_reg_number").hide();
				$("#card_kind #cardType").hide();
				
				// 일반결제입력값 리셋
				$("#payment_type_card .payBox #card_kind .inputWrap .inputBox input[value='personal']").attr("checked", true); // 카드종류
				$("#payment_type_card .payBox #card_number").find("input[id^='card_number_']").each(function(){ $(this).val(""); });    // 카드번호
				$("#payment_type_card .payBox #expiry_date").find("input").each(function(){ $(this).val(""); });    // 유효기간
				$("#payment_type_card .payBox #card_password").find("input").each(function(){ $(this).val(""); });  // 카드비밀번호
				// $("#payment_type_card .payBox #installment_period_select_period option:eq(0)").attr("selected", "selected"); // 할부기간
				$("#payment_type_card .payBox #birth_date").find("input").each(function(){ $(this).val(""); });     // 생년월일
				$("#payment_type_card .payBox #corporate_reg_number").find("input").each(function(){ $(this).val(""); }); 
			} else {
				$("#payment_type_card .payBox #card_number").show();
				$("#payment_type_card .payBox #expiry_date").show();
				$("#payment_type_card .payBox #card_password").show();
				$("#payment_type_card .payBox #birth_date").show();
				$("#payment_type_card .payBox #corporate_reg_number").hide();
				$("#card_kind #cardType").show();
			}

			// 할부기간 전체 노출
			$("#installment_period").show();
			$("#installment_period_select_period").removeAttr("disabled");
			// 5만원 미만인 경우는 disable처리
			$.order.checkCardInstallmentPlan();
		},
		choiceCardKind : function (cardKind) {
			if (cardKind == 'personal') {
				$("#payment_type_card .payBox #birth_date").show();
				$("#payment_type_card .payBox #corporate_reg_number").hide();
				$("#payment_type_card .payBox #select_period").attr("disabled", false);
				$("#payment_type_card .payBox #corporate_reg_number").find("input").each(function(){ $(this).val(""); }); 

				// 할부기간 전체 노출
				$("#installment_period_select_period").removeAttr("disabled");
				// 5만원 미만인 경우는 disable처리
				$.order.checkCardInstallmentPlan();
			} else {
				$("#payment_type_card .payBox #corporate_reg_number").show();
				$("#payment_type_card .payBox #birth_date").hide();
				$("#payment_type_card .payBox #birth_date").find("input").each(function(){ $(this).val(""); });
				
				// 할부기간 일시불만 노출
				$("#installment_period_select_period option:eq(0)").attr("selected", "selected"); // 할부기간
				$("#installment_period_select_period").attr("disabled", "disabled");
			}
		},
		clickDeliveryAp : function (selectedApCode) {
			var $apOnSrc = '_on.gif';
			var $apOffSrc = '_off.gif';
			
			$("#delivery_section #delivery_ap .apListWrap").find("a").each(function () {
				if ($(this).find("#posCode").val() == selectedApCode) {
					$(this).addClass("uiApOn");
					$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($apOffSrc, $apOnSrc));
				} else {
					$(this).removeClass("uiApOn");
					$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($apOnSrc, $apOffSrc));
				}
			});
			
			var option = "noReset";
			if ($("#prev_delivery_choice_type_ap").val() == selectedApCode) {
				option = "noReset";
				$("#prev_delivery_choice_type_ap").val(selectedApCode);
			}

			// [재고체크]
			$.order.checkStockForDelivery("noReset");
		},
		clickHowtopayCardBenefitsButton : function () {
			var popupUrl = "/shop/order/checkout/orderCreatingCardBenefitsPopup";
			$.windowOpener(popupUrl, $.getWinName());
		},

		checkCardNumber : function (inputbox) {
			if (isNaN(inputbox.val()) == true) {
				inputbox.val("");
				return false;
			}
		},
		checkCardExpiryMonthBlur : function (inputbox) {
			if (isNaN(inputbox.val()) == true || (Number(inputbox.val()) < 1 || Number(inputbox.val()) > 12)) {
				inputbox.val("");
				return false;
			}else if(inputbox.val().length < 2){
				inputbox.val("0" + inputbox.val());
			}
		},
		checkCardExpiryYearBlur : function (inputbox) {
			if (isNaN(inputbox.val()) == true || inputbox.val().length < 2) {
				inputbox.val("");
				return false;
			}
		},
		checkCardPasswordBlur : function (inputbox) {
			if (isNaN(inputbox.val()) == true || inputbox.val().length < 2) {
				inputbox.val("");
				return false;
			}
		},
		checkCardBirthDateBlur : function (inputbox) {
			if (inputbox.val().length == 0) {
				return false;
			}
			
			if (isNaN(inputbox.val()) == true || inputbox.val().length < 6) {
				alert($.order.message.MSG_NOT_AVAILIBLE_BIRTH_DATE);
				inputbox.val("");
				inputbox.focus();
				return false;
			}
			
			// 생년월일 유효성체크
			if ($.checkBirthDay('19' + inputbox.val()) == false && $.checkBirthDay('20' + inputbox.val()) == false) {
				alert($.order.message.MSG_NOT_AVAILIBLE_BIRTH_DATE);
				inputbox.val("");
				inputbox.focus();
				return false;
			}
		},
		checkCardCorporateRegNumberBlur : function (inputbox) {
			if (isNaN(inputbox.val()) == true || inputbox.val().length < 10) {
				inputbox.val("");
				return false;
			}
		},
		selectDwpBankAccount : function () {
			var bankCode = $("#payment_type_bank_transfer_choice_bank option:selected").val();

			var bankName        = $("#payment_type_bank_transfer .payBox #choice_bank_area input[id='bankName_" + bankCode + "']").val();
			var bankAccount     = $("#payment_type_bank_transfer .payBox #choice_bank_area input[id='dwpAccountNumber_" + bankCode + "']").val();
			var depositDeadLine = $("#payment_type_bank_transfer .payBox #choice_bank_area input[id='depositDeadLine_" + bankCode + "']").val();
			
			var bankInfoHtml = bankName + " " + bankAccount + "<span>(입금기한: " + depositDeadLine + ")";
			$("#payment_type_bank_transfer .payBox #choice_bank_area .selectBox .inputTxt").html(bankInfoHtml);

		},
		checkInputValueDepositorName : function () {
			// delete special char
			var depositorName = $.removeSpecialChar($("#bank_transfer_depositor"));
		    
			// delete space
			var depositorName = $("#bank_transfer_depositor").val().split(" ").join("");
			
		    // length check (18)
		    var korChar = /^[ㄱ-ㅎ|가-힣|\*]+$/;
		    var engChar = /^[a-z|A-Z|0-9|\*]+$/;
			var count = 0;
			for(var i = 0; i < depositorName.length; i++) {
				if (count > 17) {
					if(escape(depositorName.charAt(i)) == "%0A") {
						count--;
					}
					depositorName = depositorName.substring(0, i);			
					break;
				}
				if (korChar.test(depositorName.charAt(i))) {
					count += 2;
				} else if (engChar.test(depositorName.charAt(i))) {
					count++;
				} 
			}
			
			$("#bank_transfer_depositor").val(depositorName);
		},
		checkDirectDebitPassword : function (inputbox) {
			if (isNaN(inputbox.val()) == true) {
				inputbox.val("");
				return false;
			}
		},
		checkDirectDebitPasswordBlur : function (inputbox) {
			// 비밀번호 유효성체크
			if (isNaN(inputbox.val()) == true) {
				inputbox.val("");
				return false;
			}
			
			// 비밀번호를 변경하지 않은 경우
			if ($.order.data.inputDirectDebitPasswordValid && inputbox.val() == $.order.data.inputDirectDebitPassword) {
				return false;
			} else {
				$.order.data.inputDirectDebitPassword = inputbox.val();
			}

			var param = {};
			param.directDebitPassword = inputbox.val();
			
			loadingLayerS();
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/checkDirectDebitPassword",
				data     : param,
				dataType : "json",
				success: function (data){
					if(data.status != "SUCCESS"){
						if (data.msg) {
							alert(data.msg);
						}else{
							alert($.order.message.MSG_CHECK_DIRECT_DEBIT_PASSWORD);
						}
						inputbox.val("");
						$.order.data.inputDirectDebitPasswordValid = false;
					} else {
						$.order.data.inputDirectDebitPasswordValid = true;
					}
					loadingLayerSClose();
				},
				error: function(xhr, st, err){
					loadingLayerSClose();
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		orderCreatingDeliveryAddrAjax : function(option) {

			// 배송지선택에서 배달주문 선택시 배송지목록조회
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/orderCreatingDeliveryAddrAjax",
				data     : "",
				dataType : "html",
				success: function (data){
					$("#delivery_address *").remove();
					$("#delivery_address").append(data);
					$('#delivery_ap').hide();
					$('#delivery_address').show();
					
					// 최종결제금액 초기화
					$.order.initializePaymentAmountAreaAjax();
					
					// 필요한 부분만 show한다.
					$('#deliveryAddrInfo').find("tr[id='delivery_single_delivery_choice']").show();
					$('#deliveryAddrInfo').find("tr[id='delivery_single_delivery_name']").show();
					$('#deliveryAddrInfo').find("tr[id='delivery_single_delivery_tel']").show();
					$('#deliveryAddrInfo').find("tr[id='delivery_single_delivery_mobile']").show();
					$('#deliveryAddrInfo').find("tr[id='delivery_msg']").show();
					$('#delivery_multi_choice_gratitudeSender').hide();
					$('#delivery_multi_choice_gratitudePhone').hide();
					$('#delivery_multi_choice').hide();

					// 쿠폰영역 초기화
					$.order.clickCouponApplyCancel();
					// 결제방법부분 초기화
					$.order.initializePaymentAreaAjax('single-delivery');
					// 결제방법 다음부분 초기화
					$.order.initializeEvidenceTermsAreaAjax();
					
					// 복수배송지 목록 초기화
					$("#multi_delivery_selected_addr_count").text("0");
					$("#delivery_multi_choice").find("div.deliInputBox").each(function() {
						$(this).remove();
					});
					$("#multi_delivery_addr").val("");
					
					// [재고체크] 배송지가 있는 경우, 배달주문선택시 선택된 배송지로 재고체크함
					// if ($("#none_delivery_address_list").val() == "N") {
					//     $.order.checkStockForDelivery(option);
					// }
					
					// [20150901 : 박준규] 기본 배송지 Checked 설정 Start
					if ($("#delivery_single_delivery_choice_memAddr01 option:eq(1)").html() == "기본 배송지") {
						$("#delivery_single_delivery_choice_memAddr01 option:eq(1)").attr("selected", "selected");
						$.order.selectSingleDeliveryAddress();
					}
					// [20150901 : 박준규] 기본 배송지 Checked 설정 End
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		orderCreatingDeliveryApAjax : function() {
			
			// 배송지선택에서 PickUp주문 선택시 AP목록조회
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/orderCreatingDeliveryApAjax",
				data     : "",
				dataType : "html",
				success: function (data){
					$("#delivery_ap *").remove();
					$("#delivery_ap").append(data);
					$('#delivery_address').hide();
					$('#delivery_ap').show();
					
					// 최종결제금액 초기화
					$.order.initializePaymentAmountAreaAjax();
					// 제품목록초기화
					// $.order.initializeProductListAreaAjax();
					// 쿠폰영역 초기화
					$.order.clickCouponApplyCancel();
					$("#coupon_page").hide();
					// 버튼영역초기화
					$("#payment_section").hide();
					// 결제방법 다음부분 초기화
					$.order.initializeEvidenceTermsAreaAjax();
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		selectSingleDeliveryAddress : function () {
			var selectedAddrSeq = $("#delivery_single_delivery_choice_memAddr01 option:selected").val();
			
			if (selectedAddrSeq.length != 0) {
				$("#delivery_single_delivery_name .textBox").text($("#delivery_single_delivery_choice .selectBox").find("input[name=addr_name_" + selectedAddrSeq + "]").val());
				$("#delivery_single_delivery_address .textBox").text($("#delivery_single_delivery_choice .selectBox").find("input[name=formatted_address_" + selectedAddrSeq + "]").val());
				$("#delivery_single_delivery_mobile .textBox").text($("#delivery_single_delivery_choice .selectBox").find("input[name=mobile_" + selectedAddrSeq + "]").val());
				
				// 전화번호영역 - 전화번호가 있는 경우에만 표시
				if ($("#delivery_single_delivery_choice .selectBox").find("input[name=phone_" + selectedAddrSeq + "]").val().length > 0) {
					$("#delivery_single_delivery_tel").show();
					$("#delivery_single_delivery_tel .textBox").text($("#delivery_single_delivery_choice .selectBox").find("input[name=phone_" + selectedAddrSeq + "]").val());
				} else {
					$("#delivery_single_delivery_tel").hide();
				}
				
				$("#delivery_single_delivery_choice_radio_hidden").val("");
				
				// 재고체크 (설치주문만)
				if ($("#checkout_request_type").val() == 'install') {
					$.order.checkStockForDelivery("noReset");
				}
			} else {
				$("#delivery_single_delivery_name .textBox").text("");
				$("#delivery_single_delivery_address .textBox").text("");
				$("#delivery_single_delivery_mobile .textBox").text("");
				$("#delivery_single_delivery_tel .textBox").text("");
				
				// 쿠폰영역 숨김
				$.order.clickCouponApplyCancel();
				$("#coupon_page").hide();
				// 결제방법부분 숨김
				$("#payment_section").hide();
				// 결제방법 다음부분 초기화
				$.order.initializeEvidenceTermsAreaAjax();
			}
		},
		selectApDeliveryAddress : function () {
			// AP를 선택해주세요 부분이 선택된 경우
			var apSeq = $("#delivery_ap_choice option:selected").val();
			if (apSeq.length == 0) {
				$.order.selectDeliveryChoice('pickup');
				return false;
			}
			
			// AP주문불가 메세지가 있는 경우
			if($("#ap_order_message_" + apSeq).val().length > 0) {
				alert($("#ap_order_message_" + apSeq).val());
				$("#delivery_ap_choice option:eq(0)").attr("selected", "selected");
				return false;
			}
			
			$.order.checkStockForDelivery("noReset");
		},
		clickApInfoPopupButton : function () {
			var posCode = $("#delivery_ap_choice option:selected").val();
			var popupUrl = "/customer/apinfo?apCode=" + posCode;
			$.windowOpener(popupUrl, $.getWinName());
		},
		selectInstallDeliveryAddress : function () {
			var selectedAddrSeq = $("#install_order_delivery_info_choice_address option:selected").val();
			
			$("#install_order_delivery_name p").text($("#install_order_delivery_info").find("input[name=addr_name_" + selectedAddrSeq + "]").val());
			$("#install_order_delivery_address p").text($("#install_order_delivery_info").find("input[name=formatted_address_" + selectedAddrSeq + "]").val());
			$("#install_order_delivery_mobile p").text($("#install_order_delivery_info").find("input[name=mobile_" + selectedAddrSeq + "]").val());

			// 전화번호영역 - 전화번호가 있는 경우에만 표시
			if ($("#install_order_delivery_info").find("input[name=phone_" + selectedAddrSeq + "]").val().length > 0) {
				$("#install_order_delivery_tel").show();
				$("#install_order_delivery_tel p").text($("#install_order_delivery_info").find("input[name=phone_" + selectedAddrSeq + "]").val());
			} else {
				$("#install_order_delivery_tel").hide();
			}
			
			$("#delivery_single_delivery_choice_radio_hidden").val("");
			$.order.checkStockForDelivery("noReset");
		},
		selectDeliveryChoice : function (checkedVal) {
			var option = 'noReset';
			if ($("#prev_delivery_choice_type").val() != checkedVal) {
				option = "noReset";
			}
			
			// 배달주문, ap주문
			if (checkedVal == 'run') {
				// 단일배송과 기본주소지를 선택하여 노출
				$.order.orderCreatingDeliveryAddrAjax(option);
				// 같은 배송방식을 클릭하였는 지를 체크하기 위함.(단일, 복수)
				$("#prev_delivery_choice_type_single_run").val('singleAddr');
			}
			else if (checkedVal == 'pickup') {
				$.order.orderCreatingDeliveryApAjax();
			}

			// 같은 배송방식을 클릭하였는 지를 체크하기 위함.(배달, 픽업)
			$("#prev_delivery_choice_type").val(checkedVal);
		},
		selectDeliveryAddrSection : function () {
			var checkedVal = $(':radio[name=delivery_silgle_multi]:checked').val();
			var option = 'noReset';
			if ($("#prev_delivery_choice_type_single_run").val() != checkedVal) {
				option = "noReset";
			}
			
			if (checkedVal == 'singleAddr') {
				$.order.orderCreatingDeliveryAddrAjax(option);
			} else {
				$("#delivery_single_delivery_choice").hide();
				$("#delivery_single_delivery_name").hide();
				$("#delivery_single_delivery_address").hide();
				$("#delivery_single_delivery_tel").hide();
				$("#delivery_single_delivery_mobile").hide();
				$("#delivery_msg").hide();

				$('#delivery_multi_choice_gratitudeSender').show();
				$('#delivery_multi_choice_gratitudePhone').show();
				$('#delivery_multi_choice').show();

				// ======================================================================
				// [최종결제금액 초기화] 복수배송을 선택하면 최종결제금액이 아닌 결제예상금액을 표시한다. 
				//  - 배송지들을 입력하고 결제방법을 선택하면 배송비를 계산하여 최종결제금액을 표시한다.
				// ======================================================================
				$.order.initializePaymentAmountAreaAjax();
				// 쿠폰영역 초기화
				$.order.clickCouponApplyCancel();
				// 결제방법부분 초기화
				$.order.initializePaymentAreaAjax('multi-delivery');
				// 결제방법 다음부분 초기화
				$.order.initializeEvidenceTermsAreaAjax();

			}

			// 같은 배송방식을 클릭하였는 지를 체크하기 위함.(단일, 복수)
			$("#prev_delivery_choice_type_single_run").val(checkedVal);
		},
		checkStockForDelivery : function (resetOption, callBackFunction) {
			var paramDeliveryType = "";
			var paramAddr = [];
			var paramPosCode = "";
			var paramInstallDate = "";
			var paramGratitudeSender = "";
			var paramGratitudePhone = "";
			var bizRegistrationNumber= "";
			var bizRegApproveDate = "";
			var bizRegistrationName = "";
			
			if (resetOption == 'requestCheckOut') {
				// 결제진행중인 경우 RETURN
				if ($.order.data.inProgress) {
					return;
				}
				// 결제요청시 재고체크는 사업자등록증 데이터 셋팅
			    bizRegistrationNumber  = $("#bizInfoNumber").val();
			    bizRegApproveDate      = $("#bizInfoApproveDate").val();
			    bizRegistrationName    = $("#bizInfoName").val();

			    // 주문시 링크삭제 (복수주문방지용)
				$.order.data.inProgress = true;
				$("#cart_order_buttonlist").hide();
			}

			// 배송방법(배달주문 / 픽업주문)에서 배달주문선택시 단일배송의 기본배송지로 체크 OR 기본배송지 이외의 배송시 체크
			if ($(':radio[name=select_run_pickup_radio]:checked').val() == "run" && $(':radio[name=delivery_silgle_multi]:checked').val() == "singleAddr") {
				var addrSeq = $("#delivery_single_delivery_choice_radio_hidden").val();
				if (addrSeq == undefined || addrSeq.length == 0) {
					addrSeq = $("#delivery_single_delivery_choice_memAddr01 option:selected").val();
					paramAddr.push({"addrSeq" : $("#delivery_single_delivery_choice").find("input[name='addr_code_" + addrSeq + "']").val(), "deliveryMessage" : $("#silgle_delivery_message").val()});
				}else{
					paramAddr.push({"addrSeq" : addrSeq, "deliveryMessage" : $("#silgle_delivery_message").val()});
				}
				
				paramDeliveryType = 'single-delivery';
				paramPosCode = "";
				
				if ($("#checkout_request_type").val() == 'install') {
					paramDeliveryType = 'install';
				}
			}
			// 배송방법(배달주문 / 픽업주문)에서 픽업주문선택후 각 AP를 선택
			else if ($(':radio[name=select_run_pickup_radio]:checked').val() == "pickup") {
				paramDeliveryType = 'pickup';
				paramAddr.push({"addrSeq" : "00", "deliveryMessage" : ""});
				paramPosCode = $("#delivery_ap_choice option:selected").val();
			}
			// 배송방법(배달주문 / 픽업주문)에서 배달주문선택후 복수배송을 선택하고 결제방법을 선택
			else if ($(':radio[name=select_run_pickup_radio]:checked').val() == "run" && $(':radio[name=delivery_silgle_multi]:checked').val() == 'multiAddr') {
				$("#delivery_multi_choice").find("div.deliInputBox").each(function() {
					var addrId = $(this).attr("id");
					var message = $(this).find("textarea[id=multi_delivery_message]").val();
					if (message == undefined || message.length == 0) {
						message = ' ';
					}
					paramAddr.push({"addrSeq" : $(this).find("input[id='addrCode_"+addrId+"']").val(), "deliveryMessage" : message});
				});
				
				if (isPilotLimited == 'false') {
					// 복수주문시 보내는 분 정보셋팅
					paramGratitudeSender = $("#gratitudeSender").val();
					if (paramGratitudeSender.length != 0) {
						// 복수배송 보내는 분 전화번호체크
						if ($("#gratitudePhone1 option:selected").val().length != 0 && $("#gratitudePhone2").val().length > 2 && $("#gratitudePhone3").val().length > 3) {
							paramGratitudePhone = $("#gratitudePhone1 option:selected").val() + '-' + $("#gratitudePhone2").val() + '-' + $("#gratitudePhone3").val();
						}
					} else {
						if ($("#gratitudePhone1 option:selected").val().length != 0 && $("#gratitudePhone2").val().length > 2 && $("#gratitudePhone3").val().length > 3) {
							alert($.msg.order.gratitudeSenderCheck);
							$("#gratitudeSender").focus();
							return false;
						}
					}
				}
				
				paramDeliveryType = 'multi-delivery';
				paramPosCode = "";
			}
			else if ($("#checkout_request_type").val() == 'install') {
				var addrSeq = $("#delivery_single_delivery_choice_radio_hidden").val();
				if (addrSeq == undefined || addrSeq.length == 0) {
					addrSeq = $("#delivery_single_delivery_choice_memAddr01 option:selected").val();
					paramAddr.push({"addrSeq" : $("#delivery_single_delivery_choice").find("input[name='addr_code_" + addrSeq + "']").val(), "deliveryMessage" : ""});
				} else {
					paramAddr.push({"addrSeq" : addrSeq, "deliveryMessage" : ""});
				}

				var selectedInstallDate = $("#install_date_select option:selected").val().split("(");
				paramInstallDate = selectedInstallDate[0].split("-").join("");
				paramDeliveryType = 'install';
				paramPosCode = "";
			}
			
			// -----------------------------------------------------------------------
			// [재고체크] 재고체크후 제품목록, 최종결제금액부분 업데이트 모듈 호출한다.
			// -----------------------------------------------------------------------
			$("#checkOutDeliveryForm input").not("[name='CSRFToken']").remove();
			var checkOutDeliveryForm = $("#checkOutDeliveryForm");
			$(paramAddr).each(function(idx) {
				var item = paramAddr[idx];
				checkOutDeliveryForm.append($("<input/>", {"id" : "addrSeq" + idx        , "name" : "addrSeq[" + idx + "]"        , "value" : item.addrSeq        , "type" : "hidden"}));
				checkOutDeliveryForm.append($("<input/>", {"id" : "deliveryMessage" + idx, "name" : "deliveryMessage[" + idx + "]", "value" : item.deliveryMessage, "type" : "hidden"}));
			});

			checkOutDeliveryForm.append($("<input/>", {"id" : "deliveryType"          , "name" : "deliveryType"         , "value" : paramDeliveryType    , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "posCode"               , "name" : "posCode"              , "value" : paramPosCode         , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "resetOption"           , "name" : "resetOption"          , "value" : resetOption          , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "installDate"           , "name" : "installDate"          , "value" : paramInstallDate     , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "couponNumber"          , "name" : "couponNumber"         , "value" : ($("#coupon_number").val() != undefined ? $("#coupon_number").val() : ""), "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "gratitudeSender"       , "name" : "gratitudeSender"      , "value" : paramGratitudeSender , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "gratitudePhone"        , "name" : "gratitudePhone"       , "value" : paramGratitudePhone  , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "bizRegistrationNumber" , "name" : "bizRegistrationNumber", "value" : bizRegistrationNumber, "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "bizRegApproveDate"     , "name" : "bizRegApproveDate"    , "value" : bizRegApproveDate    , "type" : "hidden"}));
			checkOutDeliveryForm.append($("<input/>", {"id" : "bizRegistrationName"   , "name" : "bizRegistrationName"  , "value" : bizRegistrationName  , "type" : "hidden"}));

			loadingLayerS();
			
			$.ajax({
				type     : "POST",
				url      : "/shop/order/checkout/checkStockForDeliveryAjax",
				data     : checkOutDeliveryForm.serialize(),
				dataType : "html",
				success: function (data){
					if (data.length == 0) {
						// 결제버튼 클릭
						if (resetOption == 'requestCheckOut') {
							loadingLayerSClose(); 
							// 삭제된 링크복원 (복수주문방지용)
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;
						}
						return false;
					}
					
					// 제품목록부분을 바꿔준다.
					$("#order_product_list *").remove();
					$("#order_product_list").html(data);
					
					// 동일한 주문 체크
					if (resetOption != 'requestCheckOut' && resetOption == 'choicePayment' && $("#same_order_check").val() == 'true') {
						if(confirm($.order.message.MSG_SAME_ORDER_CONFIRM) == false) {
							loadingLayerSClose(); 
							$.order.initializePaymentAreaAjax();
							$.order.initializeEvidenceTermsAreaAjax();

							return false;
						}
					}
					
					// 재고체크의 AS400에러가 있는 경우 또는 재고체크후 주문불가 상품이 있는 경우
					if ($("#checkout_error_msg").val().length > 0 || $("#order_available_check").val() == "N") {
						
						// 결제방법 선택, 복수주문이 아니면, 쿠폰영역부터 숨김처리 
						if (resetOption != 'choicePayment' && paramDeliveryType != 'multi-delivery' && resetOption != 'applyApoint' && resetOption != 'applyMpoint') {
							// 쿠폰영역 숨김
							$.order.clickCouponApplyCancel();
							$("#coupon_page").hide();
							// 결제방법 숨김
							$("#payment_section").hide();
							// 결제방법 아래부분 숨김
							$.order.initializeEvidenceTermsAreaAjax();
						} else {
							// 결제방법 초기화
							$.order.initializePaymentAreaAjax();
							// 결제방법 아래부분 숨김
							$.order.initializeEvidenceTermsAreaAjax();
						}
						
						loadingLayerSClose(); 

						if ($("#checkout_error_msg").val().length > 0) {
							// 재고체크 AS400에러
							alert($("#checkout_error_msg").val());
						} else {
							// 재고체크 주문불가상품 팝업
							$.order.checkStockStatusMessage();
							layerPopupOpen($("#click_uiLayerPop_stockStatus"));
						}
						
						// 결제버튼 클릭
						if (resetOption == 'requestCheckOut') {
							// 삭제된 링크복원 (복수주문방지용)
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;
						}
						
						return false;
					}
					
					// 복수주문이면서 프로모션목록이 있는 경우
					if ($("#prev_delivery_choice_type").val() == 'run' 
						  && $("#prev_delivery_choice_type_single_run").val() == 'multiAddr' 
						  && $("#promotion_yn").val() == 'Y') {
						alert($.order.message.MSG_MULTI_DELIVERY_PROMOTION);
						
						if (resetOption == 'choicePayment') {
							// 결제방법 초기화
							$.order.initializePaymentAreaAjax();
							$.order.initializeEvidenceTermsAreaAjax();
							// 결제금액 초기화
							$.order.initializePaymentAmountAreaAjax();
						} else {
							// 배송방법 초기화
							$.order.initializeDeliveryAreaAjax();
							// 쿠폰영역 초기화
							$.order.clickCouponApplyCancel();
							$("#coupon_page").hide();
							// 버튼영역초기화
							$("#payment_section").hide();
							// 결제방법 다음부분 초기화
							$.order.initializeEvidenceTermsAreaAjax();
							// 결제금액 초기화
							$.order.initializePaymentAmountAreaAjax();
						}

						loadingLayerSClose(); 
						return false;
					}
					
					// 주문불가상품이 없음.
					$("#order_disable_message").text("");
					
					// 결제버튼을 클릭한 경우
					if (resetOption == 'requestCheckOut') {
						// 결제요청 프로세스
						if (typeof callBackFunction === 'function') {
							loadingLayerSClose(); 
							callBackFunction($.order.checkOutPaymentProcess);
						}
					} else {
						// 재고체크가 정상인 경우 - 단일배송, 픽업주문은 초기화처리가 필요함.
						if (resetOption != 'choicePayment' && paramDeliveryType != 'multi-delivery' && resetOption != 'applyApoint' && resetOption != 'applyMpoint') {
							// 쿠폰영역 결제방법 초기화
							$.order.clickCouponApplyCancel();
							// 결제방법 초기화
							$.order.initializePaymentAreaAjax(paramDeliveryType);
							// 결제방법 다음부분 초기화
							$.order.initializeEvidenceTermsAreaAjax();
						}
						// [최종결제금액 업데이트]
						$.order.updateFinalPaymentAmountAjax(resetOption);

						// 결제방법 선택시
						if (resetOption == 'choicePayment' || resetOption == 'applyApoint' || resetOption == 'applyMpoint') {
							if ($("#reserve_order_check").val() != "true" && $("#reserve_order_check_current_time").val() != "true") {
								// 프로모션부분 업데이트
							    if (typeof callBackFunction === 'function') {
									callBackFunction();
							    }
							}
						}

						loadingLayerSClose(); 
					}
				},
				error: function(xhr, st, err){
					loadingLayerSClose(); 
					
					// 결제버튼 클릭
					if (resetOption == 'requestCheckOut') {
						// 삭제된 링크복원 (복수주문방지용)
						$("#cart_order_buttonlist").show();
						$.order.data.inProgress = false;
					}

					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		updateFinalPaymentAmountAjax : function (option) {
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/updateFinalPaymentAmountAjax",
				data     : "",
				dataType : "html",
				success: function (data){
					if (typeof $(":radio[name=payment_type]:checked").val() != 'undefined') {
						$("#payment_expected_amount_section").hide();
						$("#payment_amount_section *").remove();
						$("#payment_amount_section").html(data);
						$("#payment_amount_section").show();
					} else {
						$("#payment_amount_section").hide();
						$("#payment_expected_amount_section *").remove();
						$("#payment_expected_amount_section").html(data);
						$("#payment_expected_amount_section").show();
					}

					if (option == 'applyApoint') {
						$.order.applyApoint();
					} else if (option == 'applyMpoint') {
						$.order.applyMpoint();
					} else if (option == 'choicePayment') {
						// 신용카드 제한
						if ($(':radio[name=payment_type]:checked').val() == '007') {
							// 결재금액이 30만원 이상인 경우에는 일반결제부분 삭제
							$.order.checkCardKindForCheckoutPrice();
							// 5만원 미만인 경우는 disable처리
							$.order.checkCardInstallmentPlan();
						}
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		initializeProductListAreaAjax : function () {
			
			// [제품목록부분 초기화]
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/initializeProductListAreaAjax",
				data     : "",
				dataType : "html",
				success: function (data){
					// 제품목록부분을 바꿔준다.
					$("#order_product_list *").remove();
					$("#order_product_list").html(data);
					$("#order_disable_message").text("");
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		initializeDeliveryAreaAjax : function () {
			
			// [배송방법부분 초기화]
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/initializeDeliveryAreaAjax",
				data     : "",
				dataType : "html",
				success: function (data){
					// 배송방법부분을 바꿔준다.
					$("#delivery_section *").remove();
					$("#delivery_section").html(data);

					// 쿠폰영역 결제방법, 버튼영역은 hide
					$.order.clickCouponApplyCancel();
					$("#coupon_page").hide();
					$("#payment_section").hide();
					$("#cart_order_buttonlist").hide();
					
					$.order.checkStockStatusMessage();
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		initializePaymentAmountAreaAjax : function () {

			// [최종결제금액 초기화]
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/initializePaymentAmountAreaAjax",
				data     : "",
				dataType : "html",
				success: function (data){
					// 최종결제금액 부분 바꿈
					$("#payment_amount_section *").remove();
					$("#payment_amount_section").html(data);
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		initializePaymentAreaAjax : function(deliveryType) {
			if (deliveryType == null || deliveryType.length == 0) {
				if ($(':radio[name=select_run_pickup_radio]:checked').val() == "run" && $(':radio[name=delivery_silgle_multi]:checked').val() == "singleAddr") {
					deliveryType = 'single-delivery';
					if ($("#checkout_request_type").val() == 'install') {
						deliveryType = 'install';
					}								
				} else if ($(':radio[name=select_run_pickup_radio]:checked').val() == "pickup") {
					deliveryType = 'pickup';
				} else {
					deliveryType = 'multi-delivery';
				}
			}

			var param = {};
			param.deliveryType = deliveryType;

			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/initializePaymentAreaAjax",
				data     : param,
				dataType : "html",
				success: function (data){
					// 쿠폰영역 표시
					$("#coupon_page").show();

					// 결제방법부분 초기화
					$("#payment_section *").remove();
					$("#payment_section").html(data);
					$("#payment_section").show();
					
					if(deliveryType == "multi-delivery") {
						// New ABO Promotion
						var toDate = new Date();
						var customerBirthMonth = $("#birthDate").val() ? $("#birthDate").val().substring(0,2) : "XX";
						// 가입일자 3/1
						// 프로모션 시작일 3/2 - 3/31
						var entryDateJS = new Date($("#entryDate").val().substring(0,4), Number($("#entryDate").val().substring(4,6))-1, $("#entryDate").val().substring(6,8));
						if(  ( entryDateJS >= newABOEntryDate || customerBirthMonth == 91 || customerBirthMonth == 92 )
						  && ( newABOStartDate <= toDate && newABOEndDate > toDate ) ) {
							alert($.msg.order.newABOPromotion);
						} 
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},		
		initializeEvidenceTermsAreaAjax : function() {
			// 거래내역 증빙신청
			$(":radio[name=payment_evidence_choice][value=no_apply]").attr("checked", "checked");
			$("#payment_evidence_price").removeAttr("checked");
			$("#payment_evidence_pvbv").removeAttr("checked");
			$('#payment_evidence').hide();
			
			// 약관동의 영역
			$("#payment_terms_agree_payAgree01").removeAttr("checked");
			$("#payment_terms_agree_payAgree02").removeAttr("checked");
			$("#payment_terms_agree").hide();
			
			// 버튼영역
			$("#cart_order_buttonlist").hide();
		},
		clickCouponPopupPageApplyButton : function (couponNumber, obj) {
			var param = {};
			param.couponNumber = couponNumber;			
			
			loadingLayerS();
			
			// 쿠폰체크
			$.ajax({
				type	: "GET",
				url		: "/shop/order/checkout/checkCouponNumber",
				dataType: "json",
				data    : param,
				success : function (data){
					if (data.status != "SUCCESS") {
						alert(data.msg);			
						return false;
					}
					
					// 선택한 쿠폰을 적용
					$("#coupon_page .noTxt").hide();
					$("#coupon_page .couponBox").remove();
					
					var couponNumber = data.couponNumber;
					var couponName   = data.couponName;
					var fromDate     = data.fromDate;
					var toDate       = data.toDate;
					var couponHtml = 
						"<div class='couponBox'>" +
						"    <span class='couponTit'>" + couponName + "</span>" +
						"    <div class='couponImg'><img src='" + $.order.data.url + "/images/content/img_coupon1.gif' alt='쿠폰'></div>"+
						"    <div class='couponInfo type2'>"+
						"        <span>유효기간 : " + fromDate + " ~ " + toDate + "</span>" +
						"    </div>" +
						"    <input type='hidden' id='coupon_number' value='" + couponNumber + "'>" +
						"    <span class='btn'>" +
						"	     <a href='#' onClick='return false;' class='btnTbl' id='coupon_apply_cancel'>적용취소</a>" +
						"    </span>" +
						"</div>";
					$("#coupon_page .couponWrap").append(couponHtml);
					
					// 쿠폰적용시 결제방법초기화를 위한 셋팅
					$("#coupon_apply_radio_hidden").val("Y");
					$("#coupon_apply_radio_hidden").click();
					loadingLayerSClose();
					closeLayerPopup(obj);
					$("#uiLayerPop_Coupon").html("");
				},
				error: function(){
					loadingLayerSClose();
					alert($.order.message.MSG_NOT_AVAILABLE_COUPON);
					return false;
				}
			});
			loadingLayerSClose();
		},
		clickCouponApplyCancel : function () {
			$("#coupon_page .couponWrap *").remove();
			$("#coupon_page .couponWrap").html("<p class='noTxt'>사용가능한 쿠폰을 확인해 주세요.</p>");
			
			$.ajax({
				type	: "GET",
				url		: "/shop/order/checkout/couponApplyCancel",
				dataType: "json",
				data    : "",
				success : function (data){
					return false;
				},
				error: function(){
					alert($.msg.err.system);
					self.close();
					return false;
				}
			});
		},
		gestCouponData : function () {
			var param = {};
			
			param.page = $.order.data.page;
			param.sortType = 1;
			param.totalCount = $(".listInfo strong").text();

			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/orderCreatingCouponPopupAjax",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#coupon_list").append(data);
					$.order.setSeeMore();
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		updatePromotionAreaAjax : function () {
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/updatePromotionAreaAjax",
				data     : "",
				dataType : "html",
				success: function (data){
				    if (data != null && data.length > 0) {
						$('#promotion_section').show();
						$("#promotion_section *").remove();
						$("#promotion_section").html(data);
				    }
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});		
		},
		choicePaymentArea : function (options) {
			// 단일배송이고, 선택된 배송지가 없는 경우
			if ($(':radio[name=select_run_pickup_radio]:checked').val() == "run" 
				&& $(':radio[name=delivery_silgle_multi]:checked').val() == 'singleAddr' && $("#delivery_single_delivery_name .textBox").text() == "") {
				alert($.order.message.MSG_NO_INPUT_SINGLE_DELIVERY);
				$(':radio[name=payment_type]:checked').removeAttr("checked");
				$("#delivery_single_delivery_choice_memAddr01").focus();
				
				return false;
			}
			// 복수주문이고, 입력된 배송지가 없는 경우
			if ($(':radio[name=select_run_pickup_radio]:checked').val() == "run" 
				&& $(':radio[name=delivery_silgle_multi]:checked').val() == 'multiAddr' && $("#delivery_multi_choice").find("div.deliInputBox").length == 0) {
				alert($.order.message.MSG_NO_INPUT_MULTI_DELIVERY);
				$(':radio[name=payment_type]:checked').removeAttr("checked");
				$("#delivery_multi_choice_button").focus();
				
				return false;
			}

			loadingLayerS(); 

			var paymentMode = $(':radio[name=payment_type]:checked').val();
			var param = {};
			param.paymentMode = paymentMode;
			
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/choicePaymentAreaAjax",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#payment_section *").remove();
					$("#payment_section").html(data);
					
					$('#payment_type_bank_transfer').hide();
					$('#payment_type_direct_debit').hide();
					$('#payment_type_direct_debit_reservation').hide();
					$('#payment_type_apoint').hide();
					$('#payment_type_mpoint').hide();
					$('#payment_type_card').hide();

					loadingLayerSClose(); 
					
					// 클릭된 결제방법이 선택되도록 셋팅한다.
					$(".payMethod").find("input:radio[name=payment_type]:input[value='" + paymentMode + "']").attr("checked", true);
					
					if (paymentMode == '007') {
						$('#payment_type_card').show();
						$('#payment_evidence_cash_receipt').hide();
						$('#payment_evidence_cash_receipt2').hide();

						// [20160126 : 고문석], 앳모스피어 보상판매 프로모션 유이자 10개월 Blocking 을 위해 신용카드 change trigger발생
						$("#payment_type_card_choice_card_kind").trigger("change");
						
						// [재고체크]  
						$.order.checkStockForDelivery("choicePayment", $.order.updatePromotionAreaAjax);
					}
					else if (paymentMode == '009') {
						$('#payment_type_bank_transfer').show();
						$('#payment_evidence_cash_receipt').show();
						$('#payment_evidence_cash_receipt2').show();
						
						// [재고체크]  
						$.order.checkStockForDelivery("choicePayment", $.order.updatePromotionAreaAjax);
					}
					else if (paymentMode == '005') {
						$('#payment_type_direct_debit').show();
						$('#payment_evidence_cash_receipt').show();
						$('#payment_evidence_cash_receipt2').show();
						
						// [재고체크]  
						$.order.checkStockForDelivery("choicePayment", $.order.updatePromotionAreaAjax);
					}
					else if (paymentMode == '006') {
						$('#payment_type_direct_debit_reservation').show();
						$('#payment_evidence_cash_receipt').show();
						$('#payment_evidence_cash_receipt2').show();
						
						// [재고체크]  
						$.order.checkStockForDelivery("choicePayment", $.order.updatePromotionAreaAjax);
					}
					else if (paymentMode == '077') {
						$('#payment_type_apoint').show();
						$('#payment_evidence_cash_receipt').hide();
						$('#payment_evidence_cash_receipt2').hide();
						
						// [재고체크]  
						$.order.checkStockForDelivery("applyApoint", $.order.updatePromotionAreaAjax);
					}
					else if (paymentMode == '026') {
						$('#payment_type_mpoint').show();
						$('#payment_evidence_cash_receipt').hide();
						$('#payment_evidence_cash_receipt2').hide();
						
						// [재고체크]  
						$.order.checkStockForDelivery("applyMpoint", $.order.updatePromotionAreaAjax);
					}
					
					$("#selected_payment_mode").val(paymentMode);
					$("#reserve_order_section").show(); // 예약주문 약관
					$('#payment_evidence').show();      // 거래내역 증빙신청
					$("#payment_terms_agree").show();   // 약관동의 영역
					$("#cart_order_buttonlist").show(); // 버튼영역
					
					// 거래명세서에 가격과 PV/BV 표시여부체크
					if ($("#prev_delivery_choice_type").val() == 'pickup') {
						$("#payment_evidence_area2").hide();
					} else if ($("#prev_delivery_choice_type").val() == 'run') {
						$("#payment_evidence_area2").show();
						$("#payment_evidence_price").attr("checked", "checked");
						$("#payment_evidence_pvbv").attr("checked", "checked");
					}
					
					// 현금영수증 신청안함을 디폴트로 선택
					$(":radio[name=payment_evidence_choice][value=no_apply]").attr("checked", "checked");
					$.order.checkPaymentEvidenRadio();
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		applyApoint : function () {
		    var inputablePoint = $.order.nanToNumber($("#payment_amount_section #order_total_sum .total #total_price").val()) +
                                 $.order.nanToNumber($("#order_total_sum_apoint_rawdata").val());
			var availablePoint = $("#payment_type_apoint_apoint_rawdata").val();
			
			// 최종결제금액보다 A포인트가 적으면 결제방법부분 초기화, 크면 입력하고 Disable 시킨다.
			if (availablePoint < inputablePoint) {
				alert($.order.message.MSG_POINT_UNDER_PAYMENT_AMOUNT);
				// 결제방법 초기화
				$.order.initializePaymentAreaAjax();
				// 결제방법 다음부분 초기화
				$.order.initializeEvidenceTermsAreaAjax();
				return false;
			} else {
				var apointApply   = $("#payment_type_apoint_apoint_apply");
				var apointRawdata = $("#payment_type_apoint_apoint_rawdata");
				var apointInput   = $("#payment_type_apoint_apoint_input");
				var apointAlluse  = $("#payment_type_apoint_apoint_allUse");
				var holdPointSpan = $("#payment_type_apoint_hole_point");

				apointInput.val(inputablePoint);
				apointInput.attr("disabled", "disabled");
				apointAlluse.attr("checked", "checked");
				apointAlluse.attr("disabled", "disabled");
				apointApply.hide();
				
				$.order.applyInputAPoint(apointApply, apointRawdata, apointInput, apointAlluse, holdPointSpan, false);
			}
		},
		applyMpoint : function () {
		    var inputablePoint = $.order.nanToNumber($("#payment_amount_section #order_total_sum .total #total_price").val()) +
                                 $.order.nanToNumber($("#order_total_sum_mpoint_rawdata").val());
			var availablePoint = $("#payment_type_mpoint_mpoint_rawdata").val();
			
			// 최종결제금액보다 A포인트가 적으면 결제방법부분 초기화, 크면 입력하고 Disable 시킨다.
			if (availablePoint < inputablePoint) {
				alert($.order.message.MSG_POINT_UNDER_PAYMENT_AMOUNT);
				// 결제방법 초기화
				$.order.initializePaymentAreaAjax();
				// 결제방법 다음부분 초기화
				$.order.initializeEvidenceTermsAreaAjax();
				return false;
			} else {
				var mpointApply   = $("#payment_type_mpoint_mpoint_apply");
				var mpointRawdata = $("#payment_type_mpoint_mpoint_rawdata");
				var mpointInput   = $("#payment_type_mpoint_mpoint_input");
				var mpointAlluse  = $("#payment_type_mpoint_mpoint_allUse");
				var holdPointSpan = $("#payment_type_mpoint_hole_point");

				mpointInput.val(inputablePoint);
				mpointInput.attr("disabled", "disabled");
				mpointAlluse.attr("checked", "checked");
				mpointAlluse.attr("disabled", "disabled");
				mpointApply.hide();
				
				$.order.applyInputMPoint(mpointApply, mpointRawdata, mpointInput, mpointAlluse, holdPointSpan, false);
			}
		},
		resetAppliedPointAjax : function (obj) {
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/resetAppliedPointAjax",
				data     : "",
				dataType : "json",
				success: function (data){
					obj.val("");
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		requestCheckoutProcess : function(checkOutPaymentProcess) {
		    loadingLayerS(); 

		    var isReserveOrderStart = $("#reserve_order_check").val() == "true" ? true : false;
			var paymentMode = $(':radio[name=payment_type]:checked').val();
			
			// Mobile APP IOS에서 KICC 결제시의 메세지
			if (($.isMobileIos() || $.isMobileAppIos()) && $(':radio[name=payment_type]:checked').val() == '007' && $(":radio[name=choice_card_payment_plan]:checked").val() == 'paySafety') {
				alert($.order.message.MSG_IOS_KICC_CHECKOUT_MSG);
			}
			
			// [결제요청]클릭 시 입력값체크
			if(!$.order.requestCheckoutInputValueCheck(isReserveOrderStart)){
				loadingLayerSClose(); 

				// 삭제된 링크복원 (복수주문방지용)
				$("#cart_order_buttonlist").show();
				$.order.data.inProgress = false;
				return false;
			}
			
			// 주문서작성시 예약주문시간구간여부
			var param = {};
			param.isReserveOrderStart = isReserveOrderStart;
			param.paymentMode = paymentMode;
			
			$.ajax({
				type     : "GET",
				url      : "/shop/order/checkout/checkOrderRestriction",
				data     : param,
				dataType : "json",
				success: function (data){
					// 현재시간의 예약주문시간구간여부
					var isReserveOrderNow = data.isMaintenanceTime;
					var reserveOrderMessageEnd = data.reserveOrderMessageEnd;
					var reserveOrderMessageMultiDelivery = data.reserveOrderMessageMultiDelivery;
					var reserveOrderMessagePickup = data.reserveOrderMessagePickup;
					var reserveOrderMessagePaymentMode = data.reserveOrderMessagePaymentMode;
					
					// 파일럿 기간동안 기능제한 (예약주문진입불가)
					if (isPilotLimited == 'true' && isReserveOrderNow) {
						alert($.getMsg($.msg.common.pilotLimited));

						loadingLayerSClose(); 
						$("#cart_order_buttonlist").show();
						$.order.data.inProgress = false;

						return false;
					}
					
					// ----------------------------------------------------------------------------
					// A. 일반주문인 경우 - 주문시작, 결제요청 모두 예약시간대가 아닌경우
					// ----------------------------------------------------------------------------
					if (isReserveOrderStart == false && isReserveOrderNow == false) {
						// 거래증빙내역 체크 - 세금계산서 선택후 사업자등록증 미입력한 경우.
						if ($(":radio[name=payment_evidence_choice]:checked").val() == 'tax_bill' && $("#bizInfoNumber").val().length == 0) {
							alert($.order.message.MSG_CHOICE_CORP_REG_NUM_CHECK);
							$("#bizinfo_choice_button").focus();

							loadingLayerSClose(); 
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;

							return false;
						}

						// 중계판매 전용 제품이 포함 세금계산서 미신청 하고 결제요청 진행 시, 사업자등록증 선택 Alert
						if (($("#salesLimitProduct").val()=='true' || Number($("#transit_product_count").val()) > 0)
								&& $("#bizInfoNumber").val().length == 0) {
							if(Number($("#transit_product_count").val()) > 0){
								alert($.order.message.MSG_CHOICE_CORP_REG_NUM_TRANSIT_PRODUCT);
							}else{
								alert($.order.message.MSG_CHOICE_CORP_REG_NUM_SALESLIMIT_PRODUCT);
							}
							
							$("#bizinfo_choice_button").focus();

							loadingLayerSClose(); 
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;

							return false;
						}
						
						// 중개판매 시 사업자등록증 증빙신청 후 사업자등록증 선택하지 않고 [결제요청] 클릭 시, 사업자등록증 선택 Alert
						if ($("#checkout_request_type").val() == 'transit' && $("#bizInfoNumber").val().length == 0) {
							alert($.order.message.MSG_CHOICE_CORP_REG_NUM_TRANSIT);
							$("#bizinfo_choice_button").focus();

							loadingLayerSClose(); 
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;

							return false;
						}
					}
					// ----------------------------------------------------------------------------
					// B. 일반주문인 경우 - 주문시작은 예약주문시간대이고, 결제요청이 예약시간대가 아닌경우
					// ----------------------------------------------------------------------------
					else if (isReserveOrderStart == true && isReserveOrderNow == false) {
						// 일반주문 결제 알림 (일반주문화면이동) 
						alert(reserveOrderMessageEnd);
					}
					// ----------------------------------------------------------------------------
					// C. 예약주문인 경우1 - 주문시작, 결제요청 모두 예약시간대인 경우
					// ----------------------------------------------------------------------------
					else if (isReserveOrderStart == true && isReserveOrderNow == true) {
						// 예약주문시입력값체크
						if (!$.order.reserveOrderInputVaueCheck()) {
							loadingLayerSClose(); 

							// 삭제된 링크복원 (복수주문방지용)
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;
							return false;
						}
					}
					// ----------------------------------------------------------------------------
					// D. 예약주문인 경우2 - 주문시작은 예약주문시간대 이전이고, 결제요청은 예약주문시간대인 경우
					// ----------------------------------------------------------------------------
					else if (isReserveOrderStart == false && isReserveOrderNow == true) {
						// 설치주문, 중계주문, 10개월무이자 프로모션 인 경우 || 중재주문상품이 포함된 경우
						if ($("#checkout_request_type").val() == 'install' || $("#checkout_request_type").val() == 'transit' 
							  || $("#checkout_request_type").val() == 'promotion' || Number($("#transit_product_count").val()) > 0
							  || $("#salesLimitProduct").val()=='true') {
							
							// 카트에서 중개제품이 포함되어 온 경우
							if ($("#checkout_request_type").val() == 'cart') {
								alert($.order.message.MSG_INSTALL_NO_RESERVE_ORDER);
						    	window.location.href = $("#goto_cart").attr("href");
							} else {
								alert($.order.message.MSG_INSTALL_NO_RESERVE_ORDER2);
						    	window.location.href = $("#goto_prev_page").attr("href");
							}

					    	return false;
						}
						
						// 예약주문시 배송방법 체크 (픽업주문)
						if ($(':radio[name=select_run_pickup_radio]:checked').val() == 'pickup') {
							// 배송영역 초기화
							$.order.initializeDeliveryAreaAjax();
							// 쿠폰영역 초기화
							$.order.clickCouponApplyCancel();
							$("#coupon_page").hide();
							// 버튼영역초기화
							$("#payment_section").hide();
							// 결제방법 다음부분 초기화
							$.order.initializeEvidenceTermsAreaAjax();
							// 결제금액 초기화
							$.order.initializePaymentAmountAreaAjax();

							// 픽업주문불가 메세지
							alert(reserveOrderMessagePickup);

							loadingLayerSClose(); 
							
							// 삭제된 링크복원 (복수주문방지용)
							$.order.data.inProgress = false;
							return false
						}
						
						// 예약주문시 배송방법 체크 (복수주문)
						if ($(':radio[name=select_run_pickup_radio]:checked').val() == "run" && $(':radio[name=delivery_silgle_multi]:checked').val() == 'multiAddr') {
							// 배송영역 초기화
							$.order.initializeDeliveryAreaAjax();
							// 쿠폰영역 초기화
							$.order.clickCouponApplyCancel();
							$("#coupon_page").hide();
							// 버튼영역초기화
							$("#payment_section").hide();
							// 결제방법 다음부분 초기화
							$.order.initializeEvidenceTermsAreaAjax();
							// 결제금액 초기화
							$.order.initializePaymentAmountAreaAjax();

							// 복수배송불가 메세지
							alert(reserveOrderMessageMultiDelivery);

							loadingLayerSClose(); 
							
							// 삭제된 링크복원 (복수주문방지용)
							$.order.data.inProgress = false;
							return false
						}
						
						// 예약주문시 결제방법 체크
						if (paymentMode != '005' && paymentMode != '009') {
							// 결제방법부분 초기화
							$.order.initializePaymentAreaAjax();
							// 결제방법 다음부분 초기화
							$.order.initializeEvidenceTermsAreaAjax();
							// 결제방법불가 메세지
							alert(reserveOrderMessagePaymentMode);

							loadingLayerSClose(); 
							
							// 삭제된 링크복원 (복수주문방지용)
							$.order.data.inProgress = false;
							return false
						}

						// 모든 제한에 걸리지 않은 경우 예약주문 안내팝업을 띄운다.
						if ($("#pbReserveTermsOK").attr('checked') != 'checked') {
							layerPopupOpen($("#click_uiLayerPop_reserveOrder"));
							$("#pbReserveTermsOK").focus();

							loadingLayerSClose(); 
							
							// 삭제된 링크복원 (복수주문방지용)
							$("#cart_order_buttonlist").show();
							$.order.data.inProgress = false;
							return false;
						}
					}
					
					// coupon number
					if ($("#coupon_number").val() != undefined) {
						$("#checkOutForm input[name='couponNumber']").val($("#coupon_number").val());
					}
			        
					// PaymentInfo
					$.order.setCheckOutPaymentInfoData(isReserveOrderNow);
					
					// PaymentEvidence
					if(!$.order.setCheckOutEvidenceData()){

						loadingLayerSClose(); 
						
						// 삭제된 링크복원 (복수주문방지용)
						$("#cart_order_buttonlist").show();
						$.order.data.inProgress = false;
						return false;
					}
					
					// ====================================
					// 결제모듈 checkOutPaymentProcess 호출
					// ====================================
					if (typeof checkOutPaymentProcess === 'function') {
						loadingLayerSClose(); 
						checkOutPaymentProcess(isReserveOrderNow);
					}
				},
				error: function(xhr, st, err){
					loadingLayerSClose(); 

					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					// 삭제된 링크복원 (복수주문방지용)
					$("#cart_order_buttonlist").show();
					$.order.data.inProgress = false;
					return false;
				}
			});				

		},
		checkOutPaymentProcess : function (isReserveOrderNow) {
		    loadingLayerS(); 

		    var ajaxurl = "";
		    if (isReserveOrderNow) {
			    ajaxurl = "/shop/order/checkout/checkOutPaymentProcess";
		    } else {
			    if ($(':radio[name=payment_type]:checked').val() == '007' && $(":radio[name=choice_card_payment_plan]:checked").val() == 'paySafety') {
			    	// 신용카드이고, KEY-IN 결제가 아닌 경우
				    ajaxurl = "/shop/order/checkout/saveCartDataForMobileMpiIsp";
			    } else {
				    ajaxurl = "/shop/order/checkout/checkOutPaymentProcess";
			    }
		    }

			$.ajax({
				type	: "POST",
				url		: $("#url_https").val() + ajaxurl,
				dataType: "json",
				data    : $("#checkOutForm").serialize(),
				success : function (data){
					if(data.status == "SUCCESS"){
						loadingLayerSClose(); 
					    if (isReserveOrderNow) {
							//==================================
							// 예약주문
							//==================================
							$("#checkOutForm").attr('action', "/shop/order/checkout/complete");
							$("#checkOutForm").attr('method', "post");
							$("#checkOutForm").submit();
					    } else {
							if ($(':radio[name=payment_type]:checked').val() == '007' && $(":radio[name=choice_card_payment_plan]:checked").val() == 'paySafety') {
								//==================================
								// EasyPay 모듈이 필요한 경우 (Card ISP, MPI)
								//==================================
								var cardCode = $("#payment_type_card_choice_card_kind option:selected").val();
								var cardCodeArray = cardCode.split('_');
								$("#frm_pay input[name='sp_usedcard_code']").val(cardCodeArray[0]); // 카드사코드
								$("#frm_pay input[name='sp_pay_type']").val("11");                  // 결제구분 (신용카드만)
								$("#frm_pay input[name='sp_pay_mny']").val(Number($("#payment_amount_section #order_total_sum .total #total_price").val()));  // 총결제금액
								$("#frm_pay input[name='sp_quota']").val( $("#installment_period_select_period option:selected").attr('id')); // 할부개월수
								
								// if ($.isMobileAppIos() || $.isMobileAppAndroid()) {
								// 	   $("#frm_pay input[name='sp_version']").val("1"); // mobile app
								// } else {
								//     $("#frm_pay input[name='sp_version']").val("0"); // mobile web
								// }
								
								// 무이자할부개월수 셋팅
								// if ($("#frm_pay input[name='sp_noint_yn']").val() == 'Y') {
								// 	$("#frm_pay input[name='sp_noinst_term']").val($("#installment_period_select_period option:selected").attr('id'));
								// }

								/* Easypay Plugin 실행 */
								var frm_pay = document.frm_pay;
								frm_pay.sp_product_nm.value = encodeURIComponent(frm_pay.sp_product_nm.value);
								frm_pay.sp_mall_nm.value = encodeURIComponent(frm_pay.sp_mall_nm.value);
								frm_pay.sp_user_nm.value = encodeURIComponent(frm_pay.sp_user_nm.value);
								frm_pay.submit();
							} else {
								//==================================
								// EasyPay 모듈이 필요없는 경우
								//==================================
								$("#checkOutForm").attr('action', "/shop/order/checkout/complete");
								$("#checkOutForm").attr('method', "post");
								$("#checkOutForm").submit();
							}
					    }
					}else{
						if(data.binCodeMsg){
							alert(data.binCodeMsg);
						}else{
							$("#checkOutNoticeForm input").not("[name='CSRFToken']").remove();
							$("#checkOutNoticeForm").append($("<input/>", {"name" : "errCode", "value" : data.errCode, "type" : "hidden"}));
							$("#checkOutNoticeForm").append($("<input/>", {"name" : "errMsg",  "value" : data.msg,     "type" : "hidden"}));
	
							$("#checkOutNoticeForm").attr("action", "/shop/order/checkout/complete");
							$("#checkOutNoticeForm").attr("method", "POST");
							$("#checkOutNoticeForm").submit();

							return false;
						}
						
						// 결제영역 초기화
						$.order.initializePaymentAreaAjax();
						// 결제방법 다음부분 초기화
						$.order.initializeEvidenceTermsAreaAjax();

						loadingLayerSClose(); 
						
						// 삭제된 링크복원 (복수주문방지용)
						$.order.data.inProgress = false;
					}
					return false;
				},
				error: function(){
					// 결제영역 초기화
					$.order.initializePaymentAreaAjax();
					// 결제방법 다음부분 초기화
					$.order.initializeEvidenceTermsAreaAjax();

					loadingLayerSClose(); 
					alert($.msg.err.system);
						
					// 삭제된 링크복원 (복수주문방지용)
					$.order.data.inProgress = false;
					
					return false;
				}
			});
		},
		reserveOrderInputVaueCheck : function () {
			// 예약주문시 주의사항 동의 미체크시
			if ($("#pbReserveTermsOK").attr('checked') != 'checked') {
				alert($.order.message.MSG_RESERVE_ORDER_TERMS_APPROVE);
				$("#pbReserveTermsOK").focus();
				return false;
			}

			// 예약주문 30만원이상으로 신용카드 선택시 (제한삭제됨)
			/*
			if ($(':radio[name=payment_type]:checked').val() == '007' && $.order.nanToNumber($("#payment_sum_area .oderTotalSum #orderTotalPrice #total_price").val()) >= 300000) {
				alert($.order.message.MSG_RESERVE_ORDER_CARD_AMOUNT_RESTRICTION);
				$('#payment_type_card').hide();
				$('#payment_evidence #cash_receipt_div').hide();
				$("#cart_order_buttonlist").hide();

				return false;
			}
			*/
			
			return true;
		},
		requestCheckoutInputValueCheck : function (isReserveOrderStart) {
			// AP주문에서 AP를 선택하지 않고 [결제요청] 버튼 선택 시
			if ($(':radio[name=select_run_pickup_radio]:checked').val() == 'pickup' && $("#delivery_ap .apListWrap").find("a[class='uiApOn']") == undefined) {
				alert($.order.message.MSG_NO_CHOICE_AP);
				return false;
			}
			
			// 쿠폰적용후 복수주문을 선택하여 결제요청
			if ($(':radio[name=select_run_pickup_radio]:checked').val() == 'run' 
				    && $(".deliverMulti" ).find("input:checked").val() == 'multiAddr' && $("#coupon_number").val() != undefined) {
				alert($.order.message.MSG_MULTI_ADDR_NO_USE_COUPON);
				return false;
			}
			
			// 결제방법 선택 누락 후 [결제요청] 버튼 선택 시
			if ($(':radio[name=payment_type]:checked').val() == undefined) {
				alert($.order.message.MSG_NO_PAYMENT_TYPE);
				return false;
			}
			// 거래증빙내역 체크 (현금영수증)
			if ($(":radio[name=payment_evidence_choice]:checked").val() == 'cash_receipt' && $("#cash_reciept_number").val().length == 0) {
				alert($.order.message.MSG_CHOICE_CASH_RECIEPT_CHECK);
				$("#cash_reciept_number").focus();
				return false;
			}

			// 거래증빙내역 체크 (현금영수증) - 최소자리수체크
			if ($(":radio[name=payment_evidence_choice]:checked").val() == 'cash_receipt' 
				  && $("#cash_reciept_number").val().length > 0
				  && $("#cash_reciept_number").val().length < $("#cash_reciept_number").attr('minlength')) {
				alert($.getMsg($.order.message.MSG_CHECK_INPUT_MIN_LENGTH, [$("#cash_reciept_number").attr('title'), $("#cash_reciept_number").attr('minlength')]));
				return false;
			}
			
			// 결제 동의 미 체크 후  [결제요청] 버튼 선택 시
			if ($("#payment_terms_agree_payAgree01").attr('checked') == undefined) {
				alert($.order.message.MSG_CHECK_AGREE_FOR_CHECKOUT);
				$("#payment_terms_agree_payAgree01").focus();
				return false;
			}
			
			// 배송정보, 결제정보에 대한 동의 미 체크 후  [결제요청] 버튼 선택 시
			if ($("#payment_terms_agree_payAgree02").attr('checked') == undefined) {
				alert($.order.message.MSG_CHECK_AGREE_FOR_DELIVERY_CHECKOUT_TERMS);
				$("#payment_terms_agree_payAgree02").focus();
				return false;
			}
			
			if ($(':radio[name=payment_type]:checked').val() == '005'){
				if($("#direct_debit_password").val().length <= 0){
					alert($.order.message.MSG_CHECK_DIRECT_DEBIT_PASSWORD_NOT);
					$("#direct_debit_password").focus();
					return false;
				}	
			} 

			if ($(':radio[name=payment_type]:checked').val() == '006'){
				if($("#direct_debit_reservation_password").val().length <= 0){
					alert($.order.message.MSG_CHECK_DIRECT_DEBIT_PASSWORD_NOT);
					$("#direct_debit_reservation_password").focus();
					return false;
				}	
			} 

			// 결제방법이 카드결제이고, 일반결제인 경우 입력값체크
			if ($(':radio[name=payment_type]:checked').val() == '007' 
				&& $(":radio[name=choice_card_payment_plan]:checked").val() == 'payNormal') {
				// 카드번호체크
				if($("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_01']").val().length == 0) {
					alert($.order.message.MSG_CHECK_CARD_NUMBER);
					$("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_01']").focus();
					return false;
				}
				if($("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_02']").val().length == 0) {
					alert($.order.message.MSG_CHECK_CARD_NUMBER);
					$("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_02']").focus();
					return false;
				}
				if($("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_03']").val().length == 0) {
					alert($.order.message.MSG_CHECK_CARD_NUMBER);
					$("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_03']").focus();
					return false;
				}
				
				// 유효기간체크
				if ($("#expiry_date_month").val().length == 0) {
					alert($.order.message.MSG_CHECK_CARD_EXPIRY_MONTH);
					$("#expiry_date_month").focus();
					return false;
				}
				if ($("#expiry_date_year").val().length == 0) {
					alert($.order.message.MSG_CHECK_CARD_EXPIRY_YEAR);
					$("#expiry_date_year").focus();
					return false;
				}
				
				// 카드비밀번호
				if ($("#credit_card_password").val().length == 0) {
					alert($.order.message.MSG_CHECK_CARD_PASSWORD);
					$("#credit_card_password").focus();
					return false;
				}
				
				if ($(':radio[name=choice_card_type]:checked').val() == 'personal') {
					// 생년월일
					if ($("#card_birth_date").val().length == 0) {
						alert($.order.message.MSG_CHECK_CARD_BIRTH_DATE);
						$("#card_birth_date").focus();
						return false;
					}
				} else {
					// 사업자등록번호
					if ($("#card_corporate_reg_number").val().length == 0) {
						alert($.order.message.MSG_CHECK_CARD_CORPORATE_REG_NUMBER);
						$("#card_corporate_reg_number").focus();
						return false;
					}
				}
			}
			
			return true;
			
		},
		setCheckOutPaymentInfoData : function(isReserveOrderNow) {
			var paymentMode = $(':radio[name=payment_type]:checked').val();
			var bankCode            = "";
			var depositAccount      = "";
			var depositDeadLine     = "";
			var depositorName       = "";
			var directDebitPassword = "";
			var cardType            = ""; // 카드타입 (개인, 법인)
			var cardPaymentPlan     = ""; // 카드결제타입 (안심결제, 일반결제)
			var cardNumber          = "";
			var cardInstallmentPlan = "";
			var cardAuthCode        = "";
			var cardExpireDate      = "";
			var cardAcceptNumber    = "";
			var cardBankCode        = "";
			var creditCardPassword  = "";
			var cardBirthDate       = "";
			var cardCorporateRegNumber  = "";
			
			if (paymentMode == '007') { // 신용카드
				var cardCodeAuth = $("#payment_type_card_choice_card_kind option:selected").val();
				var cardCodeAuthArray = cardCodeAuth.split('_');
				
				cardType            = $(':radio[name=choice_card_type]:checked').val();
				cardPaymentPlan     = $(":radio[name=choice_card_payment_plan]:checked").val();
				cardNumber          = $("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_01']").val() + 
				                      $("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_02']").val() + 
				                      $("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_03']").val() + 
				                      $("#card_number .inputBoxBlock .inputNum4 span input[id='card_number_04']").val();
				cardInstallmentPlan = $("#installment_period_select_period option:selected").attr('id');
				cardAuthCode        = cardCodeAuthArray[1];
				cardBankCode        = cardCodeAuthArray[0];
				cardExpireDate      = $("#expiry_date_year").val() + $("#expiry_date_month").val()
				cardAcceptNumber    = "";
				creditCardPassword  = $("#credit_card_password").val();
				cardBirthDate       = $("#card_birth_date").val();
				cardCorporateRegNumber = $("#card_corporate_reg_number").val();
				
				// 예약주문이거나 일반주문은 일반결제인 경우
				if (isReserveOrderNow || (isReserveOrderNow == false && $(":radio[name=choice_card_payment_plan]:checked").val() == 'payNormal')) {
					$("#checkOutForm input[name='kknCode']").val("2");  // VAN 사 구분
					if ($(':radio[name=choice_card_type]:checked').val() == 'personal') {
						$("#checkOutForm input[name='bizNo']").val(cardBirthDate);
					} else {
						$("#checkOutForm input[name='bizNo']").val(cardCorporateRegNumber);
					}
				}
			} else if (paymentMode == '009') { // 무통장입금
				bankCode            = $("#payment_type_bank_transfer_choice_bank option:selected").val();
				depositAccount      = $("#payment_type_bank_transfer .payBox #choice_bank_area input[id='dwpAccountNumber_" + bankCode + "']").val();
				depositDeadLine     = $("#payment_type_bank_transfer .payBox #choice_bank_area input[id='depositDeadLine_" + bankCode + "']").val();
				depositorName       = $("#bank_transfer_depositor").val();
			} else if (paymentMode == '005') { // 자동이체
				directDebitPassword = $("#direct_debit_password").val();
			} else if (paymentMode == '006') { // 자동이체예약
				directDebitPassword = $("#direct_debit_reservation_password").val();				
			} else if (paymentMode == '077') { // A포인트
				// 적용버튼 클릭이벤트로 적용됨.
			} else if (paymentMode == '026') { // M포인트
				// 적용버튼 클릭이벤트로 적용됨.
			} 
			
			$("#checkOutForm input[name='paymentMode']").val(paymentMode);                         // 결제구분
			$("#checkOutForm input[name='bankCode']").val(bankCode);                               // 무통장입금 은행코드
			$("#checkOutForm input[name='depositorName']").val(depositorName);                     // 무통장입금 입금자명
			$("#checkOutForm input[name='depositAccount']").val(depositAccount);                   // 무통장입금 계좌번호
			$("#checkOutForm input[name='depositDeadLine']").val(depositDeadLine);                 // 무통장입금 입금기한
			$("#checkOutForm input[name='directDebitPassword']").val(directDebitPassword);         // 자동이체 or 자동이체예약 비밀번호
			$("#checkOutForm input[name='cardType']").val(cardType);                               // 신용카드 카드타입 (개인, 법인)
			$("#checkOutForm input[name='cardPaymentPlan']").val(cardPaymentPlan);                 // 신용카드 결제타입 (안심결제, 일반결제)
			$("#checkOutForm input[name='cardNumber']").val(cardNumber);                           // 신용카드 카드번호
			$("#checkOutForm input[name='cardInstallmentPlan']").val(cardInstallmentPlan);         // 신용카드 할부개월
			$("#checkOutForm input[name='cardAuthCode']").val(cardAuthCode);                       // 신용카드 결제방법(isp, mpi)
			$("#checkOutForm input[name='cardExpireDate']").val(cardExpireDate);                   // 신용카드 만기년월
			$("#checkOutForm input[name='cardAcceptNumber']").val(cardAcceptNumber);               // 신용카드 카드승인번호 (From AS400)
			$("#checkOutForm input[name='cardBankCode']").val(cardBankCode);                       // 신용카드 매입사코드
			$("#checkOutForm input[name='creditCardPassword']").val(creditCardPassword);           // 신용카드 비밀번호 (2자리)	
			$("#checkOutForm input[name='cardBirthDate']").val(cardBirthDate);                     // 개인카드입력시 생년월일
			$("#checkOutForm input[name='cardCorporateRegNumber']").val(cardCorporateRegNumber);   // 법인카드입력시 사업자등록번호	
		},
		setCheckOutEvidenceData : function() {
			var evidenceType = $(':radio[name=payment_evidence_choice]:checked').val();
			if(!evidenceType){
				alert($.order.message.MSG_NO_SELECTED_CORP_REG_NUM);
				return false;
			}
			
		    var cashReceiptsNumber     = "";
		    var cashReceiptsType       = "";
		    var cashProofType          = "";
		    var bizRegistrationNumber  = "";
		    var bizRegApproveDate      = "";
		    var bizRegistrationName    = "";
		    var invoicePrintStatus     = $("#payment_evidence_price").attr('checked') == 'checked' ? 'Y' : 'N';
		    var invoicePvBvPrintStatus = $("#payment_evidence_pvbv").attr('checked') == 'checked' ? 'Y' : 'N';
		    
		    if (evidenceType == 'cash_receipt') {
			    cashReceiptsNumber     = $("#cash_reciept_number").val();
			    cashReceiptsType       = $("#cash_receipt_kind option:selected").val();
			    cashProofType          = $("#cash_receipt_proof_type option:selected").val();
		    } else if (evidenceType == 'tax_bill') {
			    bizRegistrationNumber  = $("#bizInfoNumber").val();
			    bizRegApproveDate      = $("#bizInfoApproveDate").val();
			    bizRegistrationName    = $("#bizInfoName").val();
		    }
		    
		    $("#checkOutForm input[name='cashReceiptsNumber']").val(cashReceiptsNumber);           // 현금영수증
		    $("#checkOutForm input[name='cashReceiptsType']").val(cashReceiptsType);               // 현금영수증 식별구분
		    $("#checkOutForm input[name='cashProofType']").val(cashProofType);                     // 현금영수증 증빙타입(소득공제용(개인) / 지출증빙용(사업자))
		    $("#checkOutForm input[name='bizRegistrationNumber']").val(bizRegistrationNumber);     // 사업자등록증 번호
		    $("#checkOutForm input[name='bizRegApproveDate']").val(bizRegApproveDate);             // 사업자등록증 승인일자
		    $("#checkOutForm input[name='bizRegistrationName']").val(bizRegistrationName);         // 사업자등록증 등록명
		    $("#checkOutForm input[name='invoicePrintStatus']").val(invoicePrintStatus);           // 거래명세서내에 가격표시여부
		    $("#checkOutForm input[name='invoicePvBvPrintStatus']").val(invoicePvBvPrintStatus);   // 거래명세서내에 PV/BV 표시여부
		    
		    return true;
		},
		checkCharacter : function(obj, limit, msg){
	        var $count = obj.parent().find("span.bytes");
	        if(!obj.parent().find("span.bytes").length){
	        	$count = obj.parents(".inputWrap").find("div.inputTxt");
	        }
			var $input = obj;
	        var maximumCount = limit * 1;
        	var len = $.fn.getAS400Byte($input.val());
            var now = maximumCount - len;

            if (now < 0) {
            	if(msg && isAlert){
            		isAlert = false;
            		$count.text("(" + len + " / " + limit + "Bytes)");
            		alert(msg);
            		return false;
            	}
                var str = $input.val();
                var temp = $.fn.getAS400String($input.val(), limit);
                $input.val(temp);
                now = 0;
            }else{
            	isAlert = true;
            }
            $count.text("(" + $.fn.getAS400Byte($input.val()) + " / " + limit + "Bytes)");
		},
		initCheckoutButton : function () {
			$("#cart_order_buttonlist").hide();
		},
		// 더보기 디스플레이 유무
		setSeeMore : function(){
			if($.order.data.isSeeMore == "false"){
				$("#btnCouponSeeMore").hide();
			}else{
				$("#btnCouponSeeMore").show();
			}
		},
		//쿠폰 유효성 체크
		couponValidationCheck : function(obj){
			var num_check=/^[A-Za-z0-9]*$/;

			if(!num_check.test(obj.val())){
				alert($.getMsg($.msg.common.inputDetail, "영문과 숫자만"));
				obj.val("");
				obj.focus();
				return false;
			}
			return true;
		},
		openCloseMultiDeliveryDetail : function(obj){
			if(obj.parent().parent().hasClass('on') == true){
				obj.parent().parent().removeClass('on');
				obj.find('img').attr('src',obj.find('img').attr("src").split("_close.gif").join("_open.gif")).attr('alt','상세열기');
			}else{
				obj.parent().parent().addClass('on');
				obj.find('img').attr('src',obj.find('img').attr("src").split("_open.gif").join("_close.gif")).attr('alt','상세닫기');
			}
		},
		clickMultiDeliveryListDeleteButton : function (obj) {
			var isDeliMsgChk = $.order.getDeliMsgChk();
			
			obj.parent("div").parent("div.deliInputBox").remove();
			var boxLength = $(".deliInputBox").length;
			var addrCount = $.order.nanToNumber($("#multi_delivery_selected_addr_count").text());
			
			$.order.displayDeliMsgChkDiv(isDeliMsgChk);


			if (addrCount == 1) {
				$("#delivery_multi_choice_button2").hide();
				$("#delivery_multi_choice_totList").hide();
				$("#delivery_multi_choice_noList").show();
			}
			// 배송비 n건
			$("#multi_delivery_selected_addr_count").text(addrCount-1);
			// 배송지 타이틀 업데이트
			$("#delivery_multi_choice_addrList .deliInputBox").each(function(index){
				var num = Number(index)+1;
				$(this).find(".addrName p strong").text("배송지 " + num);
			});

			if(boxLength == 0){
				$("#noList").show();
			}
			
			// 결제방법 초기화
			$.order.initializePaymentAreaAjax();
			$.order.initializeEvidenceTermsAreaAjax();
			// 결제금액 초기화
			$.order.initializePaymentAmountAreaAjax();
		},
		callAjax : function(type, url, dataType, data, successCallBack, errorCallBack, useLoadingLayer){
			if (useLoadingLayer) {
				loadingLayerS();
			}
			
			$.ajax({
				type     : type,
				url      : url,
				dataType : dataType,
				data     : data,
				cache	 : false,
				success: function (data){
					if( typeof successCallBack === 'function' ) { successCallBack(data); }
					if (useLoadingLayer) {
						loadingLayerSClose();
					}
					return false;
				},
				error: function(xhr, st, err){
					if (useLoadingLayer) {
						loadingLayerSClose();
					}
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
		data : {
			  url : "/_ui/mobile"
		    , interfaceChannel : "mobile"
		    , isSeeMore : ""
		    , page : ""
		    ,inProgress : false
		    ,inputDirectDebitPasswordValid : false
		    ,inputDirectDebitPassword : ""
		},
		message : {
			 MSG_NO_SELECTED_COUPON             : "적용할 쿠폰을 선택해 주세요."
			,MSG_NO_INPUT_COUPON                : "쿠폰번호 입력 후 등록해 주세요."
			,MSG_NO_INPUT_SINGLE_DELIVERY       : "배송지를 선택하세요."
			,MSG_NO_INPUT_MULTI_DELIVERY        : "배송지를 하나이상 입력해 주세요."
			,MSG_NOT_AVAILABLE_COUPON           : "유효하지 않은 쿠폰번호입니다. 다시 확인하시고 등록해 주세요."
		    ,MSG_MULTI_ADDR_NO_USE_COUPON       : "복수배송 시 쿠폰사용이 불가합니다."
		    ,MSG_RESERVE_ORDER_NO_USE_COUPON    : "예약주문 시 쿠폰사용이 불가합니다."
		    ,MSG_APOINT_OVER_PAYMENT_CARD       : "신용카드 결제는 결제금액이 최소 1000원이상 되어야 합니다."
		    ,MSG_APOINT_OVER_PAYMENT_BANK       : "자동이체 결제는 결제금액이 최소 1원이상 되어야 합니다."
		    ,MSG_APPLY_APOINT_IS_NOT            : "최종결제금액만큼 모두 적용되었습니다. 확인 후 다시 입력해 주세요."
		    ,MSG_PAYMENT_OVER_INPUT_APOINT      : "보유하고 계신 포인트 확인 후 다시 입력해 주세요."
		    ,MSG_PAYMENT_INPUT_APOINT           : "A포인트를 입력해주세요."
		    ,MSG_PAYMENT_INPUT_MPOINT           : "멤버포인트를 입력해주세요."
		    ,MSG_PAYMENT_INPUT_MINUS_POINT      : "포인트에 마이너스값을 입력할 수 없습니다. 다시 입력해 주세요."
		    ,MSG_PAYMENT_RAWDATA_MINUS_POINT    : "포인트가 부족합니다."
		    ,MSG_POINT_UNDER_PAYMENT_AMOUNT     : "보유하신 포인트가 결제금액보다 적습니다. 다른 결제방법을 선택해 주세요."
		    ,MSG_PAYMENT_NO_CHOICE_CORP_NUMBER  : "거래내역 증빙신청 시 사업자등록증을 선택하지 않으셨습니다. [사업자등록증 선택] 버튼 선택 후 신청하시고자 하는 사업자등록증을 선택해 주세요."
		    ,MSG_NO_CHOICE_AP                   : "픽업 가능하신 AP를 선택해 주세요."
		    ,MSG_NO_PAYMENT_TYPE                : "결제방법을 선택해 주세요."
			,MSG_NO_SELECTED_CORP_REG_NUM       : "거래내역 증빙신청을 선택해 주세요."
			,MSG_CHOICE_CASH_RECIEPT_CHECK      : "거래내역 증빙신청중 현금영수증을 선택하셨습니다. 현금영수증 증빙신청 번호를 입력해 주세요. "
			,MSG_CHOICE_CORP_REG_NUM_CHECK      : "거래내역 증빙신청중 세금계산서를 선택하셨습니다. [사업자등록증 선택] 버튼 선택 후 신청하시고자 하는 사업자등록증을 선택해 주세요. "
		    ,MSG_CHOICE_CORP_REG_NUM_TRANSIT    : "거래내역 증빙신청 시 사업자등록증을 선택하지 않으셨습니다. [사업자등록증 선택] 버튼 선택 후 신청하시고자 하는 사업자등록증을 선택해 주세요. "
		    ,MSG_CHOICE_CORP_REG_NUM_TRANSIT_PRODUCT    : "중개판매 전용 제품이 포함되어 있습니다. 거래내역 증빙신청을 세금계산서로 선택해 주세요."
		    ,MSG_CHOICE_CORP_REG_NUM_SALESLIMIT_PRODUCT : "구매제한 제품이 포함되어 있습니다. 거래내역 증빙신청을 세금계산서로 선택해 주세요."
		    ,MSG_CHECK_AGREE_FOR_CHECKOUT       : "결제 동의를 체크하여 주세요."
		    ,MSG_CHECK_AGREE_FOR_DELIVERY_CHECKOUT_TERMS : "배송정보, 결제정보에 대한 동의 를 체크하여 주세요."
		    ,MSG_CHECK_SAME_ORDER               : "이미 존재하는 주문입니다. 반복 주문 하시겠습니까?"
		    ,MSG_CHECK_DELETE_MULTI_ADDRESS     : "삭제하시겠습니까?"
		    ,MSG_RESERVE_ORDER_TERMS_APPROVE    : "예약주문 시 주의사항 및 개인정보 제공 동의는 필수 항목입니다"
		    ,MSG_ORDER_STOCK_ERROR              : "※ 주문제품에 주문불가 상품이 포함되어 있습니다. 확인 후 배송방법을 다시 선택해주세요."
		    ,MSG_DELETE_PRODUCT                 : " 제품을 삭제하고 결제를 진행하시겠습니까?"
		    ,MSG_NO_CHOICE_RESTRICTION_POPUP    : "옵션을 선택해 주세요."
		    ,MSG_RESERVE_ORDER_CARD_AMOUNT_RESTRICTION : "예약주문 시 신용카드로 30만원이상 결제는 불가합니다. "
		    ,MSG_CASH_RECIEPT_NUMBER_CHECK      : "숫자만 입력 가능합니다. 다시 입력해 주세요."
		    ,MSG_REGISTE_DIRECT_DEBIT_ACCOUNT   : "자동이체계좌 등록 화면으로 이동시 주문서작성/결제가 중단됩니다. 이동 하시겠습니까? "
		    ,MSG_CHECK_DIRECT_DEBIT_PASSWORD    : "자동이체 비밀번호가 틀렸습니다. 확인 후 다시 입력해 주세요."
		    ,MSG_CHECK_DIRECT_DEBIT_PASSWORD_NOT: "자동이체 비밀번호를 입력해 주세요."
		    ,MSG_CHECK_CARD_NUMBER              : "카드번호를 입력해 주세요."
		    ,MSG_CHECK_CARD_EXPIRY_MONTH        : "카드유효기간 년을 입력해 주세요."
		    ,MSG_CHECK_CARD_EXPIRY_YEAR         : "카드유효기간 월을 입력해 주세요."
		    ,MSG_CHECK_CARD_PASSWORD            : "카드비밀번호를 입력해 주세요."
		    ,MSG_CHECK_CARD_BIRTH_DATE          : "생년월일을 입력해 주세요."
		    ,MSG_NOT_AVAILIBLE_BIRTH_DATE       : "유효하지 않은 생년월일입니다. 다시 입력해 주세요."
		    ,MSG_CHECK_CARD_CORPORATE_REG_NUMBER : "사업자등록번호를 입력해 주세요."
		    ,MSG_DELIVERY_MESSAGE               : "배송메세지는 40Byte까지 입력 가능합니다."
		    ,MSG_GRATITUDE_SENDER_MESSAGE       : "보내는 분 성명은 30Bytes까지 입력 가능하며, 30Bytes 이상은 짤리게 됩니다."
		    ,MSG_RETURN_PRE_PAGE_NO_PRODUCT     : "삭제 후 이전 페이지로 이동합니다."
		    ,MSG_NOT_ALLOWED_NEW_ADDRESS        : "예약주문시간이므로 배송지의 등록, 수정이 불가합니다."
		    ,MSG_SAME_ORDER_CONFIRM             : "이미 존재하는 주문입니다. 반복 주문 하시겠습니까?"
		    ,MSG_INSTALL_NO_RESERVE_ORDER       : "예약주문만 가능한 시간입니다. 장바구니로 돌아갑니다."
		    ,MSG_INSTALL_NO_RESERVE_ORDER2      : "예약주문만 가능한 시간입니다. 이전페이지로 돌아갑니다."
		    ,MSG_MULTI_DELIVERY_PROMOTION       : "복수배송시 프로모션이 적용된 결제방법은 불가합니다. 다른 배송방법이나 결제방법을 선택해주세요."
		    ,MSG_CHECK_INPUT_MIN_LENGTH         : "{0}를 {1}자리 이상 입력해 주세요."
		    ,MSG_IOS_KICC_CHECKOUT_MSG          : "사파리 브라우저의 경우 결제 앱 종료 이후 특정 카드사에 한해 쇼핑몰 애플리케이션을 다시 실행하셔야 결제가 진행, 완료됩니다. 반드시 쇼핑몰 애플리케이션을 다시 띄워 결제 결과를 확인해 주시기 바랍니다."
		},
		nanToNumber : function (number) {
			if(isNaN(number)){
				return  0;
			}
			return Number(number);
		},
		getDeliMsgChk : function (){
			var isChecked = false;
			
			var deliMsgChkbox = $("#deliMsgChkbox");
			if(deliMsgChkbox && deliMsgChkbox.length > 0){
				isChecked = deliMsgChkbox.is(":checked");
			}
			
			return isChecked;		
		},
		displayDeliMsgChkDiv : function (isChecked){
			var deliMsgChkDiv = $("#deliMsgChkDiv");
			if(deliMsgChkDiv && deliMsgChkDiv.length > 0){
				$("#deliMsgChkDiv").remove();
			}
			
			var multiDeliveryMessage = $("div[name='multiDeliveryMessage']");
			if(multiDeliveryMessage && multiDeliveryMessage.length > 1){
				multiDeliveryMessage.first().after("<div class='deliMsgChk' id='deliMsgChkDiv'><input type='checkbox' id='deliMsgChkbox'><label for='deliMsgChkbox'>배송메시지 일괄 적용</label></div>");
				$("#deliMsgChkbox").attr("checked", isChecked);
			}
		}
	};
})(jQuery);
