(function($) {
	// 더보기
	$(document).on("click", "#btnAddressSeeMore", function() {
		var obj = $(this);
		var sortType = $("select[id='deriGroup'] option:selected").val();
		var startIndex = Number($("#address_start_index").val()) + 20;
		var gubun = $("#btnSelectAll").attr("data-code");
		var searchKeyword = $("#old_keyword").val();
		
		$.deliveryAddress.getSearchData(startIndex, sortType, searchKeyword, obj, gubun);
		return false;
	});
	
	// 단일배송지팝업 선택버튼 클릭
	$(document).on("click", "#singleBtnAddrChoice", function(event) {
		event.preventDefault();
		if($.deliveryAddress.isChecked($("input[name=singleChk]"))){
			$.deliveryAddress.deliveryPopupChoiceButton("S", $(this).parents("#uiLayerPop_delivery"));
		}
		
		return false;
	});
	
	// 복수배송지팝업 선택버튼 클릭
	$(document).on("click", "#multiBtnAddrChoice", function(event) {
		event.preventDefault();
		if($.deliveryAddress.isChecked($("input[name=multiChk]"))){
			$.deliveryAddress.deliveryPopupChoiceButton("M", $(this).parents("#uiLayerPop_delivery"));
		}
		
		return false;
	});
	
	$(document).on("click", "#btnDeliveryPopClose, #btnAddrCancel", function(event) {
		event.preventDefault();
		closeLayerPopup($(this).parents("#uiLayerPop_delivery"));
		$(this).parents("#uiLayerPop_delivery").html("");
		
	});

	// ==========================================
	// [단일 배송지 팝업] - 이벤트 
	// ==========================================
	// 체크박스 선택 이벤트
	$(document).off("change", "input[name=singleChk]").on("change", "input[name=singleChk]", function(e)
	{
		$("input[name=singleChk]").prop('checked', false);
		$(this).attr('checked', true);
	});	
	
	// 닫기버튼 클릭이벤트 
	$(document).on("click", "#delivery_single_choice_popup_button_close", function() {
		self.close();
	});
	
	// 검색버튼 클릭이벤트 
	$(document).on("click", "#delivery_single_address_popup_search_box #search_button", function() {
		$("select[id='deriGroup'] option:eq(0)").attr("selected", "selected");
		$.deliveryAddress.clickDeliveryAddressSearchBtn("searchButton");
	});
	
	// 검색어 입력후 엔터키 이벤트 
	$(document).on("keydown", "#delivery_single_address_popup_search_box #search_keyword", function(event) {
		if (event.keyCode == 13) {
			$("select[id='deriGroup'] option:eq(0)").attr("selected", "selected");
			$.deliveryAddress.clickDeliveryAddressSearchBtn("searchButton");
		}
	});
	// [단일 배송지 팝업] - 검색어 특수문자 제거
	$(document).on("keydown", "#delivery_single_address_popup_search_box #search_keyword", function() {
		$.removeSpecialChar($(this));
	});
	$(document).on("keyup", "#delivery_single_address_popup_search_box #search_keyword", function() {
		$.removeSpecialChar($(this));
	});
	$(document).on("blur", "#delivery_single_address_popup_search_box #search_keyword", function() {
		$.removeSpecialChar($(this));
	});

	// 주소타입선택 이벤트 (전체, 일반, 선물)
	$(document).on("change", "select[id='deriGroup']", function() {
		$.deliveryAddress.clickDeliveryAddressSearchBtn("addrType");
	});

	// 수정 버튼 클릭이벤트 
	$(document).on("click", "#address_modify_btn", function() {
		var rowData = $(this).parents("li");
		var addrCode  = rowData.find("input[name='addr_code']").val();
		var addrFlags = rowData.find("input[name='addr_flags']").val();
		var actionUrl = "/shop/order/checkout/orderCreatingAddressModifyPopup";
		var params = {};

		params.addrSeq = addrCode;
		params.flags = addrFlags;

		$.order.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
			$("#uiLayerPop_delivery").html(data);
		}, null);

		layerPopupOpen($(this));
		$("#uiLayerPop_delivery").attr("data-code", "modify");
		//$.address.openAddressModifyPopupPage(addrCode, addrFlags);
		return false;
	});
	
	// ==========================================
	// [복수 배송지 팝업] - 전체 선택
	// ==========================================
	$(document).on("click", "#btnSelectAll", function(e){
		$.deliveryAddress.clickChoiceAllDelivery();
	});
	
	$.deliveryAddress = {
		clickChoiceAllDelivery : function () {
			// 선택되어 있는 것이 있는 지를 체크
	    	var checkedInput = false;
	    	$("#result_list").find("input[name=multiChk]").each(function(){
				if ($(this).prop("checked") == true) {
					checkedInput = true;
					return false;
				}
			});

	    	// 선택안된 것이 있는 지를 체크 (선택된 것이 있는 경우만 체크 - 즉, 섞여있는 지를 체크하기위함.)
			var unCheckedInput = false;
			if (checkedInput == true) {
				$("#result_list").find("input[name=multiChk]").each(function(){
					if ($(this).prop("checked") == false) {
						unCheckedInput = true;
						return false;
					}
				});
			}
			
			// 선택된 주소와 선택안된 주소가 섞여있는 경우, 선택안된 모두를 선택하도록 한다.
			if (checkedInput && unCheckedInput) {
				$("#result_list").find("input[name=multiChk]").each(function(){
					if (!$(this).prop("checked")) {
						this.checked = true;
					}
				});
			} else {
				$("#result_list").find("input[name=multiChk]").each(function(){
					this.checked = !$(this).prop("checked");
				});
			}
		},
		setSeeMore : function(startIndex, sortType, obj){
			// 현재 검색된 갯수
			var viewCount = $.deliveryAddress.data.totCnt;

			if (sortType == "general") {
				viewCount = $.deliveryAddress.data.commonAddrCnt;
			} else if (sortType == "gift") {
				viewCount = $.deliveryAddress.data.giftAddrCnt;
			}			

			if (startIndex > viewCount || viewCount < 21) {
				obj.hide();
			}else{
				obj.show();
			}	
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
		getSearchData : function(startIndex, sortType, searchKeyword, obj, gubun){
			var actionURL = "";
			var params = {};

			params.requestType	= "searchAjax";
			params.searchKeyword = searchKeyword;
			params.startIndex	= startIndex;
			params.addrTypeParam = sortType;

			if(gubun == 'single'){
				actionUrl = $.deliveryAddress.data.preUrl + "/orderCreatingSingleAddressListPopup";
			}else if(gubun == 'multi'){
				actionUrl = $.deliveryAddress.data.preUrl + "/orderCreatingMultiAddressListPopup";
			}
			
			$.deliveryAddress.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
				$("#result_list").append(data);
				$("#address_start_index").val(startIndex);
				
				$.deliveryAddress.listEvent();
				$.deliveryAddress.setSeeMore(startIndex, sortType, obj);
			}, null);
		},
		listEvent : function(){
			//배송지 열기 닫기
			$('#result_list a.btnTgg').unbind("click");
			$('#result_list a.btnTgg').click(function() {
				if($(this).parent().parent().hasClass('on') == true){
					$(this).parent().parent().removeClass('on');
					$(this).find('img').attr('src',$(this).find('img').attr("src").split("_close.gif").join("_open.gif")).attr('alt','상세열기');
				}else{
					$(this).parent().parent().addClass('on');
					$(this).find('img').attr('src',$(this).find('img').attr("src").split("_open.gif").join("_close.gif")).attr('alt','상세닫기');
				}
			});
		},
		initCheckoutButton : function () {
			if ($("#orderCreatingCheckoutForm #checkOutRequestType").val() == 'install') {
				$("#cart_order_buttonlist").show();
			} else {
				$("#cart_order_buttonlist").hide();
			}
		},
		// 체크박스 체크 유무
		isChecked : function(checkbox){
			if(!checkbox.is(":checked")){
				alert($.msg.address.noSelectDeliveryAddr);
				return false;
			}
			return true;
		},
		clickDeliveryAddressSearchBtn : function (option) {
			var searchKeyword = $("input[id='search_keyword']").val();
			var startIndex = 1;
			var sortType = $("select[id='deriGroup'] option:selected").val();
			var actionUrl = "/shop/order/checkout/orderCreatingSingleAddressListPopup";
			
			var param = {};
			param.requestType = "searchAjax";
			param.searchKeyword = searchKeyword;
			param.startIndex = startIndex;
			param.addrTypeParam = sortType;
			
			if (option == "searchButton" && searchKeyword.length == 0) {
				alert($.msg.address.msgNotInputAddrSearchLKeyword);
				return false;
			}
			
			if(option == "addrType" && $("#btnSelectAll").attr("data-code") == "multi"){
				actionUrl = "/shop/order/checkout/orderCreatingMultiAddressListPopup";
			}

			$("select[id='deriGroup']").attr("disabled", true);
			
			$.ajax({
				type     : "GET",
				url      : actionUrl,
				data     : param,
				dataType : "html",
				success: function (data){
					if (data != null) {
						$("#noMsg").hide();
						$("#result_list").show();
						$("#result_list *").remove();
						$("#result_list").html(data);
					} 

					if($("#result_list").find(".deliInputBox").attr("id") == undefined){
						$("#result_list").hide();
						$("#noMsg").show();
					}
					// 더보기 디스플레이 유무
					$.deliveryAddress.setSeeMore(startIndex, sortType, $("#btnAddressSeeMore"));

					// startindex reset
					$("#address_start_index").val(startIndex);

					$("#old_keyword").val($("#search_keyword").val());
					$("select[id='deriGroup']").attr("disabled", false);
					
					$.deliveryAddress.listEvent();
				},
				error: function(xhr, st, err){
					xhr = null;
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						$("select[id='deriGroup']").attr("disabled", false);
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		checkMultiDeliveryCountDuplicate : function () {
			// 메인창에 이미 선택되어진 주소목록
			var parentSelectedAddrList = "";
			var parentSelectedAddrCount = 0;
			$("#delivery_multi_choice").find("div.deliInputBox").each(function() {
				parentSelectedAddrList += $(this).attr("id") + "|";
				parentSelectedAddrCount++;
			});				
			
			// 복수배송지 팝업에서 선택된 주소목록
			var returnVal = true;
			var selectedAddrCnt = 0;
			$("#result_list").find("input[name=multiChk]:checked").each(function () {
				if (parentSelectedAddrList.indexOf($(this).attr("id")) < 0) {
					selectedAddrCnt++;
				} else {
					alert($.deliveryAddress.message.MSG_SELECTED_ADDRESS);
					returnVal = false;
					return false;
				}
			});
			
			// 총갯수가 100개를 초과한 지를 체크한다.
			if (returnVal && parentSelectedAddrCount + selectedAddrCnt > 100) {
				alert($.deliveryAddress.message.MSG_MULTI_ADDR_COUNT_RESTRICT);
				returnVal = false;
			}
			
			return returnVal;
		},
		deliveryPopupChoiceButton : function (type, obj) {
			// 갯수체크 및 중복체크
			if ($.deliveryAddress.checkMultiDeliveryCountDuplicate() == false) {
				return false;
			}
			
			var addrKey = ""
			var rowData = ""
			var addrCode = "";
			var addrFlags = ""; 
			var addrName = "";
			var addrType = "";
			var phone = "";
			var mobile = "";
			var postalCode = "";
			var formattedAddress = "";
			var chkObj = "";
			
			if(type == "M"){
				chkObj = $("#result_list").find("input[name=multiChk]:checked");
			}else{
				chkObj = $("#result_list").find("input[name=singleChk]:checked");
			}
			
			var chkLength = Number(chkObj.length)-1;
			var addrIndex = 0;
			$("#delivery_multi_choice").find("div.deliInputBox").each(function() {
				addrIndex += 1;
			});
			
			var addAbnAddr = [];
			chkObj.each(function(index){
				addrIndex += 1;
				rowData = $(this).parents("li");
				addrKey  = rowData.find("input[type='checkbox']").attr("id");
				addrCode = rowData.find("input[name=addr_code]").val();
				addrFlags = rowData.find("input[name=addr_flags]").val();
				addrName = rowData.find("input[name=addr_name]").val();
				addrType = rowData.find("input[name=addr_type]").val();
				phone = rowData.find("input[name=phone]").val();
				mobile = rowData.find("input[name=mobile]").val();
				postalCode = rowData.find("input[name=postal_code]").val();
				formattedAddress = rowData.find("input[name=formatted_address]").val();

				addAbnAddr.push({"addrSeq" : addrCode, "flags" : addrFlags});

				if(type == "M"){
					var addrHtml = $.deliveryAddress.makeMultiDeliveryInfoHtml(addrKey, addrCode, addrFlags, addrIndex, addrName, addrType, phone, mobile, postalCode, formattedAddress, chkLength, index);
					$("#delivery_multi_choice_addrList").append(addrHtml);
				}
				else if(type == "S" && window.location.href.indexOf('myorder') == -1){
					var addrSeq = rowData.find("input[name=addr_seq]").val();
					
					$("#delivery_single_delivery_address p").html("[" + postalCode + "] " + formattedAddress);
					$("#delivery_single_delivery_name p").html(addrName);
					$("#delivery_single_delivery_tel p").html(phone);
					$("#delivery_single_delivery_mobile p").html(mobile);
					$("#delivery_single_delivery_choice_radio_hidden").val(addrCode);
					
					// 전화번호가 없는 경우, div자체를 hide시킨다.
					if (phone.length > 0) {
						$("#delivery_single_delivery_tel").show();
					} else {
						$("#delivery_single_delivery_tel").hide();
					}
					
					// 기본주소 초기화
					$("#delivery_single_delivery_choice_memAddr01 option:eq(0)").attr("selected", "selected");
					// 재고체크 (설치주문만)
					if ($("#checkout_request_type").val() == 'install') {
						$("#delivery_single_delivery_choice_radio_hidden").click();
					}

					$("#delivery_single_delivery_choice").find("select#delivery_single_delivery_choice_memAddr01 option").each(function() {
						if ($(this).val() == addrSeq) {
							$(this).attr("selected", "selected");
						}
					});
				}
			});

			// myOrder form에 저장
			if(window.location.href.indexOf('myorder') != -1){
				$.deliveryAddress.saveDataToMyOrderForm(postalCode, formattedAddress, addrName, phone, mobile, addrCode, addrType, addrFlags);
			}

			if(type == "M"){
				$("#delivery_multi_choice_totList").show();
				$("#delivery_multi_choice_button2").show();
				$("#delivery_multi_choice_noList").hide();				
				$("#multi_delivery_selected_addr_count").text(addrIndex);

				// 복수배송지 추가시 결제방법초기화를 위한 셋팅
				$("#multi_address_add_radio_hidden").val("Y");
				$("#multi_address_add_radio_hidden").click();
				
				if($.order){
					$.order.displayDeliMsgChkDiv($.order.getDeliMsgChk());
				}
			}
			
			$.deliveryAddress.updateAddrInHybris(addAbnAddr, function callback(){closeLayerPopup(obj);});	
			
			return false;
		},
		saveDataToMyOrderForm : function(postalCode, formattedAddress, addrName, phone, mobile, addrCode, addrType, addrFlags){				
			$("#delivery_single_delivery_address").html( $.deliveryAddress.makeSingleDeliveryAddressHtml(addrType, postalCode, formattedAddress));
			$("#delivery_single_delivery_name p").html(addrName);
			$("#delivery_single_delivery_tel p").html(phone);
			$("#delivery_single_delivery_mobile p").html(mobile);
			$("#delivery_single_delivery_choice_radio_hidden").val(addrCode);

			// form에 값 저장
			$("#addressSaveForm input[name='addrSeq']").val(addrCode);
			$("#addressSaveForm input[name='name']").val(addrName);
			$("#addressSaveForm input[name='addrType']").val(addrType);
			$("#addressSaveForm input[name='flags']").val(addrFlags);
			$("#addressSaveForm input[name='homePhone']").val(phone);
			$("#addressSaveForm input[name='mobilePhone']").val(mobile);
			$("#addressSaveForm input[name='post']").val(postalCode);
			$("#addressSaveForm input[name='formattedAddress']").val(formattedAddress);
		},
		updateAddrInHybris : function(addAbnAddr, callback){
			if(addAbnAddr == null) {
				return false;
			} else if(typeof(addAbnAddr) == 'string') {
				addAbnAddr = $.parseJSON(addAbnAddr);
			}
			
			$("#abnAddressSaveForm input").not("[name='CSRFToken']").remove();

			$(addAbnAddr).each(function(idx) {
				var addrItem = addAbnAddr[idx];
				$("#abnAddressSaveForm").append($("<input/>", {"id" : "addrSeq" + idx, "name" : "addrSeq[" + idx + "]", "value" : addrItem.addrSeq, "type" : "hidden"}));
				$("#abnAddressSaveForm").append($("<input/>", {"id" : "flags" + idx, "name" : "flags[" + idx + "]", "value" : addrItem.flags, "type" : "hidden"}));
			});
			
			$.ajax({
				type     : "POST",
				url      : "/shop/order/checkout/ajax/updateDeliveryAddrs",
				data     : $("#abnAddressSaveForm").serialize(),
				dataType : "json",
				success: function (data){
					if( typeof callback === 'function' ) { 
						callback(); 
					}
				},
				error: function(xhr, st, err){
					alert($.msg.err.system);
				}
			});					
		},		
		makeSingleDeliveryAddressHtml : function (addrType, postalCode, formattedAddress) {
			var htmlAddress = 
				"<strong class='labelSizeM'>주소</strong>" +
				"<div class='addressWrap addressR'>";

				if(postalCode != null && postalCode.length == 6){
					var prePostalCode = postalCode.substring(0, 3);
					var postPostalCode = postalCode.substring(3, 6);
					htmlAddress += " <span> [<span>" + prePostalCode + "-" + postPostalCode + "</span>] " + formattedAddress + "</span>";
				}
				else{
					htmlAddress += " <span> [<span>" + postalCode + "</span>] " + formattedAddress + "</span>";
				}
				// hidden 변수에 세팅
				$("#changePostCode").val(postalCode);

				htmlAddress += "</div>";
		    return htmlAddress;
		},
		makeMultiDeliveryInfoHtml : function (addrKey, addrCode, addrFlags, addrIndex, addrName, addrType, phone, mobile, postalCode, formattedAddress, chkLength, index) {
			var strHtml = "";
			var btnImg = "";
			var useClass = "";
			var strAddrIndex = addrIndex + "";

			if (addrIndex < 10) {
				strAddrIndex = "0" + strAddrIndex;
			}

			if(addrIndex == 1){
				useClass = "on";
				btnImg = $.deliveryAddress.data.url + '/images/content/btn_child_close.gif';
			}else{
				btnImg = $.deliveryAddress.data.url + '/images/content/btn_child_open.gif';
			}
			
			strHtml += '<div class="deliInputBox ' + useClass + '" id="' + addrKey + '">';
			strHtml += '	<input type="hidden" id="addrCode_'+addrKey+'" value="' +addrCode+'"/> ';
			strHtml += '	<input type="hidden" id="addrFlags_'+addrKey+'" value="'+addrFlags+'"/>';
			strHtml += '	<div class="addrName">';
			strHtml += '		<p><strong>배송지 ' + addrIndex + '</strong>' + addrName + '</p>';
			strHtml += '		<a href="#none" id="multi_delivery_detail_close" class="btnTgg"><img src="' + btnImg + '" alt="상세닫기"/></a>';
			strHtml += '	    <a href="#none" id="delivery_multi_choice_bntAddrDelete" class="btnTbl">삭제</a>';
			strHtml += '	</div>';
			strHtml += '	<div class="detailAddrIn">';
			strHtml += '		<div class="addressWrap addressR">';
			strHtml += '			<span>[' + postalCode + '] ' + formattedAddress + '</span>';
			if (phone.length > 0) {
				strHtml += '		<span><strong>연락처 :</strong> ' + phone + ' / ' + mobile + '</span>';
			} else {
				strHtml += '		<span><strong>연락처 :</strong> ' + mobile + '</span>';
			}
			strHtml += '		</div>';
			if (isPilotLimited == 'false') {
				strHtml += '		<div class="deliMsgBox">';
				strHtml += '			<strong class="title">배송메시지</strong>';
				strHtml += '			<p class="txt">택배기사님께 전달하는 메시지는 배송 시 참고하는 내용으로 배송상황 및 요청내용에 따라 반영되지 않을 수 있습니다. 배송일 및 배송시각은 지정하셔도 반영되지 않습니다.</p>';
				strHtml += '			<div class="deliveryMsge" name="multiDeliveryMessage">';
				strHtml += '				<select id="multi_delivery_default_message" title="배송메시지 선택">';
				strHtml += '					<option value="">배송메모를 선택해 주세요.</option>';
				strHtml += '					<option value="부재 시 경비실에 맡겨주세요.">부재 시 경비실에 맡겨주세요.</option>';
				strHtml += '					<option value="부재 시 휴대폰으로 연락주세요.">부재 시 휴대폰으로 연락주세요.</option>';
				strHtml += '					<option value="배송 전 연락 부탁 드립니다.">배송 전 연락 부탁 드립니다.</option>';
				strHtml += '				</select>';
				strHtml += '				<textarea id="multi_delivery_message" name="multi_delivery_message" title="배송메시지 입력"></textarea>';
				strHtml += '				<span class="bytes" id="chkBytes">(<em>0</em> / 40Bytes)</span>';
				strHtml += '			</div>';
				strHtml += '		</div>';
			}
			strHtml += '	</div>';
			strHtml += '</div>';

			return strHtml;
		},
		message : {
			 MSG_NOT_INPUT_ADDR_SEARCH_KEYWORD  : "받는 분 또는 주소 입력 후 다시 검색해 주세요."
		    ,MSG_MULTI_ADDR_COUNT_RESTRICT      : "배송지 선택은 최대 100개까지 가능합니다."
		    ,MSG_SELECTED_ADDRESS               : "이미 선택한 배송지입니다."
		},
		data : {
			  url : "/_ui/mobile"
			, preUrl : "/shop/order/checkout"
			, totCnt : ""
		    , commonAddrCnt : ""
          , giftAddrCnt : ""
		},
	};
})(jQuery);
