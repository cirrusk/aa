$(document).ready(function(){
	$.address.initNewAddrSearch();    // 새 배송지검색 초기화
});

(function($) {
	$.fn.moveCenterLayerPopup = function(){
		if($(this).length){
			var offsetTop = $(this).offset().top;
			var adjustment = Math.max(0,( $(window).height() - $(this).outerHeight(true) ) / 2);
			var scrollTop = offsetTop - adjustment;
			$('html,body').animate({scrollTop: scrollTop}, 0);
		}
	}
	// [새 배송지 팝업] 탭클릭이벤트 (지번주소로 찾기)
	$(document).on("click", "#new_lotnum_addr_tab", function() {
		if($("#addressLayerPop").length){
			if($("#addResult").css("display") == "none" && $("#addr_rest").css("display") == "none"){
				$.address.openLayerPopLotnumAddr();
			}
		}
		$.address.clickNewLotnumAddrTab();
	});
	
	// ==========================================
	// [새 배송지 팝업] - 지번주소검색	
	// ==========================================
	$(document).on("click", "#new_lotnum_addr_search #search_input fieldset div #search_input_button", function() {
		$.address.clickNewAddrLotNumberSearchBtn($("#new_lotnum_addr_search #search_input fieldset div #search_keyword").val());
	});
	
	// 검색어 입력후 엔터키 이벤트
	$(document).on("keydown", "#new_lotnum_addr_search #search_input fieldset div #search_keyword", function(event) {
		if (event.keyCode == 13) {
			$.address.clickNewAddrLotNumberSearchBtn($("#new_lotnum_addr_search #search_input fieldset div #search_keyword").val());
		}
	});
	
	// [새 배송지 팝업] - 지번주소검색 : 검색된 기본주소를 선택하기전에 [이전]버튼을 클릭한 경우
	$(document).on("click", ".pbPopContent #returnto_search_input .btnBasicGL", function() {
		$("#new_lotnum_addr_search #search_input").show();
		$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide(); //검색된 결과 없음 숨김
		$("#new_lotnum_addr_search .yesResult").hide(); //결과 리스트 숨김
		$(this).hide(); //이전버튼 숨김
		$("#addressLayerPop").moveCenterLayerPopup();
		return false;
	});
	
	// [새 배송지 팝업] - 체크아웃 지번주소검색 : 검색된 기본주소를 선택하기전에 [이전]버튼을 클릭한 경우
	$(document).on("click", ".pbLayerContent #return_search_input .btnTblL", function() {
		$("#new_lotnum_addr_search #search_input").show();
		$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide(); //검색된 결과 없음 숨김
		$("#new_lotnum_addr_search .yesResult").hide(); //결과 리스트 숨김
		$(this).hide(); //이전버튼 숨김
		return false;
	});	

	// [새 배송지 팝업] - 지번주소검색 : 검색된 주소의 [선택]버튼을 클릭한 경우
	$(document).on("click", "#new_lotnum_addr_search #addResult li .btns .btnTbl", function() {
		$.address.clickNewAddrLotNumberResultList($(this));
		$("#addressLayerPop").moveCenterLayerPopup();
		$("#returnto_search_input .btnBasicGL").hide();
		return false;
	});
	
	// [새 배송지 팝업] - 지번주소검색 : 나머지주소 부분의 [주소입력]버튼을 선택한 경우
	$(document).on("click", "#new_lotnum_addr_search .detailAddrSrc#addr_rest div.btn #btnInputAddr", function() {
		$.address.clickNewAddrLotNumberInputRest();
	});
	
	// [새 배송지 팝업] - 지번주소검색 : 나머지주소 부분입력후 <엔터키> 클릭한 경우
	$(document).on("keydown", "#new_lotnum_addr_search .detailAddrSrc#addr_rest #disp .inputBox #addLast", function(event) {
		if (event.keyCode == 13) {
			$.address.clickNewAddrLotNumberInputRest();
		}
	});
	
	// [새 배송지 팝업] - 지번주소검색 : [이전] 버튼 클릭한 경우
	$(document).on("click", "#new_lotnum_addr_search .detailAddrSrc#addr_rest div.btn #btnPrev", function() {
		$("#new_lotnum_addr_search #search_input").show();
		$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide();
		$("#new_lotnum_addr_search #search_result").hide();
		$("#new_lotnum_addr_search .detailAddrSrc#addr_rest").hide();
		$("#new_lotnum_addr_search .addResultList#final_addr").hide();
		$("#new_lotnum_addr_search #search_result .boxBtn").hide();
		$("#addressLayerPop").moveCenterLayerPopup();
		$("input[id=addLast]").val("");
		$("#search_keyword").focus();
	});	
	
	// [새 배송지 팝업] - 지번주소검색 : 나머지주소 부분의 주소입력버튼을 클릭한 후, [이전]버튼을 클릭한 경우.
	$(document).on("click", "#new_lotnum_addr_search .addResultList#final_addr #returnto_result_choice #back", function() {
		$("#new_lotnum_addr_search #search_input").show();
		$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide();
		$("#new_lotnum_addr_search #search_result").hide();
		$("#new_lotnum_addr_search .detailAddrSrc#addr_rest").hide();
		$("#new_lotnum_addr_search .addResultList#final_addr").hide();
		$("#new_lotnum_addr_search #search_result .boxBtn").hide();
		//$("#new_lotnum_addr_search #returnto_search_input").hide(); 이전버튼...
		$("#new_lotnum_addr_search .detailAddrSrc#addr_rest div.btn #btnPrev").show();
		$("#addressLayerPop").moveCenterLayerPopup();
		$("input[id=addLast]").val("");
		$("#search_keyword").focus();
	});
	
	// [새 배송지 팝업] - 지번주소검색 : 나머지주소 부분의 주소입력버튼을 클릭한 후, 정제된 주소에서 지번 또는 도로명주소를 선택한 경우.
	$(document).on("click", "#new_lotnum_addr_search .addResultList#final_addr li span.btns a[class='btnTbl']", function() {
		$.address.choiceNewDeliveryAddress($(this));
	});

	// ==========================================
	// [새 배송지 팝업] - 도로명주소로 찾기
	// ==========================================
	// 탭클릭이벤트
	$(document).on("click", "#new_road_addr_tab", function() {
		$.address.clickNewRoadAddrTab();
	});

	// [새 배송지 팝업] - 도로명주소 검색방법 Radio Button Event (도로명주소+건물명 or 도로명주소+건물번호) 
	$(document).on("click", "#new_road_addr_search #roadname_search_select", function() {
		$.address.choiceRoadNmTypeRadioBtn($(this).find("input:checked").val());
	});
	
	// [새 배송지 팝업] - 도로명주소 검색에서 (도로명 + 건물명) 시/도를 선택한 경우.
	$(document).on("change", "#roadname_search_bdgName_form .inputWrapBox .inputWrap #area11", function() {
		$.address.changeWideNmBox($("#roadname_search_bdgName_form .inputWrapBox .inputWrap #area11"));
	});
	
	// [새 배송지 팝업] - 도로명주소 검색에서 (도로명 + 건물번호) 시/도를 선택한 경우.
	$(document).on("change", "#roadname_search_bdgNum_form .inputWrapBox .inputWrap #area11", function() {
		$.address.changeWideNmBox($("#roadname_search_bdgNum_form .inputWrapBox .inputWrap #area11"));
	});

	// [새 배송지 팝업] - 도로명주소검색 - 도로명주소+건물명으로 검색
	$(document).on("click", "#roadname_search_bdgName_form .inputWrapBox .btn #roadname_search_bdgName_btn", function() {
		$.address.clickNewAddrRoadNameSearchByBuildNameBtn();
		$("#addressLayerPop").moveCenterLayerPopup();
	});
	
	// [새 배송지 팝업] - 도로명주소검색 - 도로명주소+건물명으로 검색 <엔터키 이벤트>
	$(document).on("keydown", "#roadname_search_bdgName_form .inputWrapBox .inputWrap .inputBox #keyword02", function(event) {
		if (event.keyCode == 13) {
			$.address.clickNewAddrRoadNameSearchByBuildNameBtn();
			$("#addressLayerPop").moveCenterLayerPopup();
		}
	});

	// [새 배송지 팝업] - 도로명주소검색 - 도로명주소+건물번호로 검색
	$(document).on("click", "#roadname_search_bdgNum_form .inputWrapBox .btn #roadname_search_bdgNum_btn", function() {
		$.address.clickNewAddrRoadNameSearchByBuildNumberBtn();
		$("#addressLayerPop").moveCenterLayerPopup();
	});
	
	// [새 배송지 팝업] - 도로명주소검색 - 도로명주소+건물번호로 검색 <엔터키 이벤트>
	$(document).on("keydown", "#roadname_search_bdgNum_form .inputWrapBox .inputWrap .inputBox #keyword02", function(event) {
		if (event.keyCode == 13) {
			$.address.clickNewAddrRoadNameSearchByBuildNumberBtn();
			$("#addressLayerPop").moveCenterLayerPopup();
		}
	});
	
	// [새 배송지 팝업] - 도로명주소검색 : 검색된 기본주소를 선택하기전에 [이전]버튼을 클릭한 경우
	$(document).on("click", "#new_road_addr_search #result_back .btnBasicGL", function() {
		$.address.clickNewAddrRoadNameSearchResultBackBtn();
		$("#addressLayerPop").moveCenterLayerPopup();
	});

	// [새 배송지 팝업] - 도로명주소검색 : 검색된 기본주소의 [선택]버튼을 클릭한 경우
	$(document).on("click", "#new_road_addr_search .addResultList.yesResult li .btns .btnTbl", function() {
		$.address.clickNewAddrRoadNameResultList($(this));
		$("#addressLayerPop").moveCenterLayerPopup();
	});
	
	// [새 배송지 팝업] - 도로명주소검색 : 나머지 주소를 입력후 [주소입력] 버튼을 클릭한 경우
	$(document).on("click", "#new_road_addr_search .detailAddrSrc.noline .btn .btnTbl", function() {
		$.address.clickNewAddrRoadNameInputRest();
	});
	
	// [새 배송지 팝업] - 도로명주소검색 : 나머지 주소를 입력후 [주소입력] <엔터키 이벤트>
	$(document).on("keydown", "#new_road_addr_search .detailAddrSrc.noline .inputWrap.block .inputBox #addLast", function(event) {
		if (event.keyCode == 13) {
			$.address.clickNewAddrRoadNameInputRest();
		}
	});
	
	// [새 배송지 팝업] - 도로명주소검색 : 나머지 주소를 입력후 [주소입력] 버튼 클릭후, [이전]버튼을 클릭한 경우.
	$(document).on("click", "#new_road_addr_search #returnto_result_choice .btnBasicGL", function() {
		$("#new_road_addr_search #final_addr").hide();
		$("#new_road_addr_search #returnto_result_choice").hide();
		$("#addressLayerPop").moveCenterLayerPopup();
	});
	
	// [새 배송지 팝업] - 도로명주소검색 : 나머지주소 부분의 [주소입력]버튼을 클릭한 후, 정제된 주소에서 지번 또는 도로명주소를 선택한 경우.
	$(document).on("click", "#new_road_addr_search ul#final_addr li .btns .btnTbl", function() {
		$.address.choiceNewDeliveryAddress($(this));
	});
	
	// [새 배송지 팝업] - 저장버튼 클릭
	$(document).on("click", "#new_address_save_btn", function(event) {
		event.preventDefault();
		$.address.saveNewDeliveryAddress($(this).parents("#uiLayerPop_delivery"));
	});	
	
	// [새 배송지 팝업] - 취소버튼, 창닫기(X) 클릭
	$(document).on("click", "#new_address_cancel_btn, #new_address_cancel_btn_x", function(event) {
		event.preventDefault();
		closeLayerPopup($(this).parents("#uiLayerPop_delivery"));
		$(this).parents("#uiLayerPop_delivery").html("");
	});	

	$(document).on("click", "#addressPopClose", function(event){
		event.preventDefault();
		$.address.popupClose();
	});
	
	// [새 배송지 팝업] - 받는분 이름 길이체크
	$(document).on("keyup keydown", "input[name=name]", function () {
		// 특수문자 제거
		$.removeSpecialChar($(this));
		
		// 길이체크
		var inputval = $(this).val();
		if (inputval.length > 20) {
			$(this).val(inputval.substring(0, 20));
		}
	});

	// [새 배송지 팝업] - 전화번호, 휴대폰 번호 숫자만 입력
	$(document).on("keydown", "input[name=phone02], input[name=phone03], input[name=mobile02], input[name=mobile03]", function(e){
		$.inputOnlyNumber(e);
	});	

	// [새 배송지 팝업] - [20150901 : 박준규] 기본 배송지 선택 시 그룹 '일반'으로 변경 후 수정x
	$(document).on("change", "#new_lotnum_addr_input #basicAddress", function() {
		if ($(this).is(":checked") == true){
			// 그룹을 일반으로 변경
			$("#new_lotnum_addr_input #deleiveryAddressGroup").val("GENERAL");
			// 변경x 
			$("#new_lotnum_addr_input #deleiveryAddressGroup").prop("disabled", "disabled");
			// 핸드폰번호 필수표시 x
			$("#new_lotnum_addr_input #addr_rest #home_phone").hide();
	    	$("#new_lotnum_addr_input #addr_rest #mobile_phone").hide();
			// $("#inputed_phone").find("th span").html("휴대폰번호");
			// $("#inputed_phone").find("th span").removeClass("required");
			
			// 기본정보의 전화번호/휴대폰번호로 설정
			var phone = $("#delivery_section #delivery_address .dPlaceInfo dl dd").eq(1).html().trim();
			var homePhone = "";
			var mobilePhone = "";
			
			if (phone.indexOf("/") == -1) {
				homePhone = "";
				mobilePhone = phone;
			} else {
				homePhone = phone.split("/")[0];
				mobilePhone = phone.split("/")[1];
			}
			
			if (homePhone != null && homePhone != "") {
				var numArr = homePhone.split("-");
				$("#new_lotnum_addr_input .addAddress #home_phone #phone01").val(numArr[0]);
				$("#new_lotnum_addr_input .addAddress #home_phone #phone02").val(numArr[1]);
				$("#new_lotnum_addr_input .addAddress #home_phone #phone03").val(numArr[2]);
			}
			if (mobilePhone != null && mobilePhone != "") {
				var numArr = mobilePhone.split("-");
				$("#new_lotnum_addr_input .addAddress #mobile_phone #mobile01").val(numArr[0]);
				$("#new_lotnum_addr_input .addAddress #mobile_phone #mobile02").val(numArr[1]);
				$("#new_lotnum_addr_input .addAddress #mobile_phone #mobile03").val(numArr[2]);
			}
			
		} else {
			// 변경o
			$("#new_lotnum_addr_input #deleiveryAddressGroup").removeAttr("disabled");
			// 핸드폰번호 필수표시 o
			$("#new_lotnum_addr_input #addr_rest #home_phone").show();
	    	$("#new_lotnum_addr_input #addr_rest #mobile_phone").show();
			// $("#inputed_phone").find("th span").html("<strong>필수항목</strong>휴대폰번호");
			// $("#inputed_phone").find("th span").addClass("required");
			
			// 전화번호/휴대폰번호 지움
	    	$("#new_lotnum_addr_input .addAddress #home_phone #phone01").val("");
	    	$("#new_lotnum_addr_input .addAddress #home_phone #phone02").val("");
	    	$("#new_lotnum_addr_input .addAddress #home_phone #phone03").val("");
			
			$("#new_lotnum_addr_input .addAddress #mobile_phone #mobile01").val("");
			$("#new_lotnum_addr_input .addAddress #mobile_phone #mobile02").val("");
			$("#new_lotnum_addr_input .addAddress #mobile_phone #mobile03").val("");
		}
	});
	
	$.address = {
		validation : {
			postNumCheck : function(postVal){
				return ($.trim(postVal || "").length <= 4);
			}
		},	
		popupClose : function(){
			$("#addressLayerPop").unbind('keydown');
			$("#addressLayerPop").fadeOut(200);
			$('.layerMask').fadeOut(200).remove();
			$("#addressLayerPop").attr('aria-hidden','true');
			
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest").hide();
			$("#new_lotnum_addr_search #final_addr").hide();
			$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide();
			$("#new_lotnum_addr_search .yesResult").hide();
			
			$(".pbPopContent #returnto_search_input .btnBasicGL").hide();
			$(".pbPopContent #return_search_input .btnTblL").hide();
			
			$("#new_road_addr_search .yesResult").hide();
			$("#new_road_addr_search #result_back").hide(); // 이전 버튼
			$("#new_road_addr_search .detailAddrSrc").hide();
			$("#new_road_addr_search #final_addr").hide();
			$("#new_road_addr_search #returnto_result_choice").hide(); //이전 버튼
			
			$.address.init();
		},
		init : function(){
			//input val 초기화
			$("#addressLayerPop input:text").val("");
			//라디오는 첫번째
			$("input[name='roadname']:first").attr('checked', true);
			//select도 첫번째
			$("#addressLayerPop select").find('option:first').attr('selected', true);
		},
		openLayerPopLotnumAddr : function(){
			$("#new_lotnum_addr_search").show();
			$("#search_input").show();
			$("#new_road_addr_search").hide();
		},
		openLayerPopRoadAddr : function(){
			$("#new_lotnum_addr_input").show();
			$("#new_road_addr_search #roadname_search_bdgName_form").prev().show();
			$("#new_road_addr_search #roadname_search_bdgName_form").show();
			$("#new_road_addr_search #roadname_search_bdgNum_form").hide();
		},
		clickNewLotnumAddrTab : function (options) {
			if ($("#new_lotnum_addr_tab").attr("class") == undefined) {
				$("#new_lotnum_addr_tab").addClass("on");
				$("#new_lotnum_addr_tab *").remove();
				$("#new_lotnum_addr_tab").append("<strong>지번주소 찾기</strong>");
				
				$("#new_road_addr_tab").removeAttr("class");
				$("#new_road_addr_tab *").remove();
				$("#new_road_addr_tab").append("<a href=\"#\" onclick=\"return false;\">도로명주소 찾기</a>");
				
				$("#new_lotnum_addr_search").show();
				$("#new_lotnum_addr_input").show();
				$(".pbLayerContent #returnto_search_input").show();
				$("#new_road_addr_search").hide();
			}

		},
		clickNewAddrLotNumberSearchBtn : function (searchKeyword) {
			if(searchKeyword == null || searchKeyword == ""){
				$("#search_keyword").focus();
				alert("검색어를 입력해 주세요.");
				return false;
			}
			
			// 새 배송지 팝업 - 지번주소검색
			var param = {};
			param.searchKeyword = searchKeyword;

			$.ajax({
				type     : "GET",
				url      : $.address.data.baseUrl + "/deliveryNewAddressLotNumberSearch",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#new_lotnum_addr_search #search_input").hide();
					$("#new_lotnum_addr_search .resultGuide").show();
					$("#returnto_search_input").show();

					if($(".pbPopContent #returnto_search_input a").attr("class") == "btnBasicGL"){
						$(".pbPopContent #returnto_search_input .btnBasicGL").show();
					}else{
						$(".pbLayerContent #return_search_input .btnTblL").show();
						$("#return_search_input").show();
					}

					if (data == null || data.length==0) {
						$("#new_lotnum_addr_search .resultGuide.noResult#no_result span").text(searchKeyword);
						$("#new_lotnum_addr_search .resultGuide.noResult#no_result").show();
						$("#new_lotnum_addr_search .yesResult").hide();
					} else {
						$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide();
						$("#new_lotnum_addr_search .yesResult").show();
						$("#new_lotnum_addr_search #addResult *").remove();
						$("#new_lotnum_addr_search #addResult").html(data);
					}
					return true;
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		clickNewAddrLotNumberResultList : function (obj) {
			$("#new_lotnum_addr_search .resultGuide.noResult#no_result").hide();
			$("#new_lotnum_addr_search .yesResult").hide();
			$(".pbLayerContent #returnto_search_input .btnBasicGL").hide();
			$(".pbLayerContent #return_search_input .btnTblL").hide();
			
			// 상세주소 입력부분 표시
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest").show();
			$("#new_lotnum_addr_search #final_addr").hide();
			
			// 선택된 주소 입력
			// 20160329 고문석 - 우편번호 5자리 변경 프로젝트
			var zipCode = obj.parent("span").parent("li").find("input[name='zipCode']").val();
			//var zipCode1 = obj.parent("span").parent("li").find("input[name='zipCode1']").val();
			//var zipCode2 = obj.parent("span").parent("li").find("input[name='zipCode2']").val();
			var dispAddr = obj.parent("span").parent("li").find("input[name='dispAddr']").val();
			var addr1    = obj.parent("span").parent("li").find("input[name='addr1']").val();
			var addr2    = obj.parent("span").parent("li").find("input[name='addr2']").val();
			var addr3    = obj.parent("span").parent("li").find("input[name='addr3']").val();
			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			var dongCode    = obj.parent("span").parent("li").find("input[name='dongCode']").val();
			var buildingManNum    = obj.parent("span").parent("li").find("input[name='buildingManNum']").val();

			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #zipcode").val(zipCode);
			//$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #zipcode1").val(zipCode1);
			//$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #zipcode2").val(zipCode2);
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #disp #dispaddr").val(dispAddr);
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #addr1").val(addr1);
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #addr2").val(addr2);
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #addr3").val(addr3);
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #dongCode").val(dongCode);
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #buildingManNum").val(buildingManNum);
			
		},
		clickNewAddrLotNumberInputRest : function () {
			var param = {};
			param.zipCode  = $("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #zipcode").val();
			param.address1 = $("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #addr1").val();
			param.address2 = $("#new_lotnum_addr_search .detailAddrSrc#addr_rest #zipcode #addr2").val();
			//param.address2 = $("#new_lotnum_addr_search .detailAddrSrc#addr_rest #disp .inputBox #addLast").val();
			param.restAddr = $("#new_lotnum_addr_search .detailAddrSrc#addr_rest #disp .inputBox #addLast").val();
			$("#new_lotnum_addr_search .detailAddrSrc#addr_rest div.btn #btnPrev").hide();
			
			$.ajax({
				type     : "GET",
				url      : $.address.data.baseUrl + "/searchCleanAddressForLotNumberAddr",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#new_lotnum_addr_search .addResultList#final_addr").show();
					$(".pbLayerContent #returnto_search_input .btnBasicGL").hide(); //이전 버튼
					
					if (data != null) {
						var input_rest_addr = $("#new_lotnum_addr_search detailAddrSrc#addr_rest #disp #addLast").val();
						$("#new_lotnum_addr_search .addResultList#final_addr").html(data);
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});							
		},
		choiceNewDeliveryAddress : function (obj) {
			var addrFull  = obj.parent("span").parent("li").find("input[id='addrFull']").val();
			
			var addrType  = obj.parent("span").parent("li").find("input[id='addrType']").val();
			var zipCode   = obj.parent("span").parent("li").find("input[id='zipCode']").val();
			var wideNm    = obj.parent("span").parent("li").find("input[id='wideNm']").val();
			var cityNm    = obj.parent("span").parent("li").find("input[id='cityNm']").val();
			var sectionNm = obj.parent("span").parent("li").find("input[id='sectionNm']").val();
			var streetNm  = obj.parent("span").parent("li").find("input[id='streetNm']").val();
			var buildNm   = obj.parent("span").parent("li").find("input[id='buildNum']").val();
			var addr1 = obj.parent("span").parent("li").find("input[id='addr1']").val();
			var addr2 = obj.parent("span").parent("li").find("input[id='addr2']").val();
			var addr3 = obj.parent("span").parent("li").find("input[id='addr3']").val();
			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			var dongCode = obj.parent("span").parent("li").find("input[id='dongCode']").val();
			var buildingManNum = obj.parent("span").parent("li").find("input[id='buildingManNum']").val();
			// modified for any
			var krAddrType  = obj.parent("span").parent("li").find("input[id='krAddrType']").val();
			
			if($.address.data.addrUsePage != 'ADDRUPDATE' && $.address.data.addrUsePage != 'CHECKOUT' && $.address.data.addrUsePage != 'MYORDER'){
				var addrParam = {
							"addrFull" 	: addrFull
						  , "addrType" 	: krAddrType
						  , "zipCode" 	: zipCode
						  , "wideNm" 	: wideNm
						  , "cityNm" 	: cityNm
						  , "sectionNm" : sectionNm
						  , "streetNm" 	: streetNm
						  , "buildNm" 	: buildNm
						  , "addr1" 	: addr1
						  , "addr2" 	: addr2	
						  , "addr3" 	: addr3	
						  , "dongCode" 	: dongCode	
						  , "buildingManNum" 	: buildingManNum	
				};
				
				// 우편번호 4자리 이하 or null
				if ($.address.validation.postNumCheck(addrParam.zipCode)) {
					alert($.address.message.MSG_ADDRESS_POST_NUM_CHECK);
					return false;
				}
				
				if($.address.getCallbackByName("callback")){
					var callback = eval("opener.window." + $.address.getCallbackByName("callback"));
					$.address.selectAddressForSignup(addrFull, addrParam, callback);
				}else{
					var callback = $.address.data.layerPopupCallback;
					$.address.selectAddressForSignup(addrFull, addrParam, callback);
				}
			}else{
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='addrType']").val(addrType);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='zipCode']").val(zipCode);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='wideNm']").val(wideNm);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='cityNm']").val(cityNm);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='sectionNm']").val(sectionNm);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='streetNm']").val(streetNm);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='buildNum']").val(buildNm);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='addr1']").val(addr1);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='addr2']").val(addr2);
				// 체크아웃
				$("#inputed_addr").text(addrFull);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='formattedAddress']").val(addrFull);
				//20160329 고문석 - 우편번호 5자리 변경 프로젝트
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='dongCode']").val(dongCode);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='buildingManNum']").val(buildingManNum);

				$("#new_lotnum_addr_input .btnWrapC").find("input[id='post']").val(zipCode);
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='city']").val(wideNm + ' ' + cityNm);
				if (addrType == 'NUMBER') {
					$("#new_lotnum_addr_input .btnWrapC").find("input[id='addr']").val(addr1 + ' ' + addr2 + ' ' + addr3);
				} else {
					$("#new_lotnum_addr_input .btnWrapC").find("input[id='addr']").val(addr1 + ' ' + addr2);
					$("#new_lotnum_addr_input .btnWrapC").find("input[id='building']").val(addr3);
				}
				$("#recipient").find("input[name=name]").focus();
			}
		},
		clickNewRoadAddrTab : function () {
			if ($("#new_road_addr_tab").attr("class") == undefined) {
				$("#new_road_addr_tab").addClass("on");
				$("#new_road_addr_tab *").remove();
				$("#new_road_addr_tab").append("<strong>도로명주소 찾기</strong>");
				
				$("#new_lotnum_addr_tab").removeAttr("class");
				$("#new_lotnum_addr_tab *").remove();
				$("#new_lotnum_addr_tab").append("<a href=\"#\" onclick=\"return false;\">지번주소 찾기</a>");
				
				$("#new_lotnum_addr_search").hide();
				$("#new_road_addr_search").show();
				$("#new_road_addr_search .addSelectBox.addTypeLine").hide();
				$("#new_road_addr_search .boxBtn").hide();
				
				// 입력부분은 지번주소와 동일한 것 사용함.
				$("#new_lotnum_addr_input").show();

				// 도로명 + 건물명 부분이 선택되도록 호출함.
				$("#new_road_addr_search #roadname_search_bdgName_form").show();
				$("#new_road_addr_search #roadname_search_bdgNum_form").hide();
				
				$("#new_road_addr_search #no_result_msg").hide();
				$("#new_road_addr_search .yesResult").hide();
				$("#new_road_addr_search .detailAddrSrc").hide();
				$("#new_road_addr_search #final_addr").hide();
				$("#new_road_addr_search #result_back").hide();
				$("#new_road_addr_search #returnto_result_choice").hide(); //이전 버튼
				$(".pbLayerContent #returnto_search_input").hide();
				
			}
			// 시도 & 시군구 조회
			$.address.changeWideNmBox(null);
		},
		choiceRoadNmTypeRadioBtn : function (checkedVal) {
			$("#new_road_addr_search #no_result_msg").hide(); //결과 리스트
			$("#new_road_addr_search .yesResult").hide(); // 결과
			$("#new_road_addr_search .detailAddrSrc.noline").hide();
			$("#new_road_addr_search #final_addr").hide();
			$("#new_road_addr_search #result_back").hide();
			$("#new_road_addr_search #returnto_result_choice").hide();
			if (checkedVal == 'bdgName') {
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").prev().show();
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").show();
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").prev().hide();
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").hide();
			}
			else if (checkedVal == 'bdgNum') {
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").prev().hide();
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").hide();
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").prev().show();
				$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").show();
			}

			// 시도 & 시군구 조회
			$.address.changeWideNmBox(null);
		},
		changeWideNmBox : function (cityObj) {
			var searchType = $("#new_road_addr_search #roadname_search_select").find("input[name='roadname']:checked").val();
			if(!searchType){
				return false;
			}
			
			var param = {};
			param.searchType = searchType;
			param.wideNm = "";
			
			if(cityObj!=null){
				var cityVal = cityObj.find("option:selected").val();
				if(cityVal != "-1"){
					param.wideNm = cityObj.find("option:selected").text()	
				}
			}
			
			$.ajax({
				type     : "GET",
				url      : $.address.data.baseUrl + "/roadNmSearchWideNmSearch",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#new_road_addr_search .searchInput.roadName").html(data);
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		clickNewAddrRoadNameSearchByBuildNameBtn : function () {
			var $wideObj = $("#roadname_search_bdgName_form .inputWrapBox .inputWrap #area11 option:selected");
			var $cityObj = $("#roadname_search_bdgName_form .inputWrapBox .inputWrap #area12 option:selected");
			var $streetAddr   = $("#roadname_search_bdgName_form .inputWrapBox .inputWrap .inputBox #keyword01");
			var $buildingName = $("#roadname_search_bdgName_form .inputWrapBox .inputWrap .inputBox #keyword02");

			if($wideObj.val() == "-1"){
				alert("시/도를 선택해 주세요.");
				return false;
			}
			if($cityObj.val() == "-1"){
				alert("시/군/구를 선택해 주세요.");
				return false;
			}

			if($streetAddr.val() == null || $streetAddr.val() == ""){
				$streetAddr.focus();
				alert("도로명을 입력해 주세요.");
				return false;
			}else if($buildingName.val() == null || $buildingName.val() == ""){
				$buildingName.focus();
				alert("건물명을 입력해 주세요.");
				return false;
			}
			
			// 새 배송지 팝업 - 도로명주소검색 (도로명 + 건물명)
			var param = {};
			param.wideNm = $wideObj.text();
			param.cityNm = $cityObj.text();
			param.streetNm  = $streetAddr.val();
			param.buildName = $buildingName.val();
			
			$.ajax({
				type     : "GET",
				url      : $.address.data.baseUrl + "/deliveryRoadNameSearchByBuildName",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").prev().hide();
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").hide();
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").prev().hide();
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").hide();
					$("#new_road_addr_search #result_back").show(); //이전 버튼
					if (data == null || data.length == 0) {
						$("#new_road_addr_search #no_result_msg").show();
						$("#new_road_addr_search #no_result_msg span").text(param.wideNm+"시/도 "+param.cityNm+"시/군/구 "+param.streetNm+"길 "+param.buildName);
						$("#new_road_addr_search .yesResult").hide();
					} else {
						$("#new_road_addr_search #no_result_msg").hide();
						$("#new_road_addr_search .yesResult").show();
						
						$("#new_road_addr_search .addResultList.yesResult").html(data);
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		clickNewAddrRoadNameSearchByBuildNumberBtn : function () {
			var $wideObj = $("#roadname_search_bdgNum_form .inputWrapBox .inputWrap #area11 option:selected");
			var $cityObj = $("#roadname_search_bdgNum_form .inputWrapBox .inputWrap #area12 option:selected");
			var $streetAddr  = $("#roadname_search_bdgNum_form .inputWrapBox .inputWrap .inputBox #keyword01");
			var $buildingNum = $("#roadname_search_bdgNum_form .inputWrapBox .inputWrap .inputBox #keyword02");
			
			if($wideObj.val() == "-1"){
				alert("시/도를 선택해 주세요.");
				return false;
			}
			if($cityObj.val() == "-1"){
				alert("시/군/구를 선택해 주세요.");
				return false;
			}

			if($streetAddr.val() == null || $streetAddr.val() == ""){
				$streetAddr.focus();
				alert("도로명을 입력해 주세요.");
				return false;
			}else if($buildingNum.val() == null || $buildingNum.val() == ""){
				$buildingNum.focus();
				alert("건물번호을 입력해 주세요.");
				return false;
			}
			
			// 새 배송지 팝업 - 도로명주소검색 (도로명 + 건물번호)
			var param = {};
			param.wideNm = $wideObj.text();
			param.cityNm = $cityObj.text();
			param.streetNm    = $streetAddr.val();
			param.buildNumber = $buildingNum.val();
			
			var url = $.address.data.baseUrl + "/deliveryRoadNameSearchByBuildNumber";
			$.ajax({
				type     : "GET",
				url      : url,
				data     : param,
				dataType : "html",
				success: function (data){
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").prev().hide();
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgName_form").hide();
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").prev().hide();
					$("#new_road_addr_search .searchInput.roadName #roadname_search_bdgNum_form").hide();
					$("#new_road_addr_search #result_back").show();

					if (data == null || data.length == 0) {
						$("#new_road_addr_search #no_result_msg").show();
						$("#new_road_addr_search #no_result_msg span").text(param.wideNm+"시/도 "+param.cityNm+" 시/군/구 "+param.streetNm+"길 "+param.buildNumber);
						$("#new_road_addr_search .yesResult").hide();
						
					} else {
						$("#new_road_addr_search #no_result_msg").hide();
						$("#new_road_addr_search .yesResult").show();
						
						$("#new_road_addr_search .addResultList.yesResult").html(data);
//						
					}
					return true;
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});				
		},
		clickNewAddrRoadNameSearchResultBackBtn : function () {
			
			if ($("#new_road_addr_search #roadname_search_select").find("input:checked").val() == 'bdgName') {
				$("#new_road_addr_search #roadname_search_bdgName_form").prev().show();
				$("#new_road_addr_search #roadname_search_bdgName_form").show();
				$("#new_road_addr_search #roadname_search_bdgNum_form").prev().hide();
				$("#new_road_addr_search #roadname_search_bdgNum_form").hide();
			} else {
				$("#new_road_addr_search #roadname_search_bdgName_form").prev().hide();
				$("#new_road_addr_search #roadname_search_bdgName_form").hide();
				$("#new_road_addr_search #roadname_search_bdgNum_form").prev().show();
				$("#new_road_addr_search #roadname_search_bdgNum_form").show();
			}
			
			$("#new_road_addr_search #no_result_msg").hide();
			$("#new_road_addr_search .yesResult").hide();
			$("#new_road_addr_search #result_back").hide();
		},
		clickNewAddrRoadNameResultList : function (obj) {
			$("#new_road_addr_search .yesResult").hide();
			$("#new_road_addr_search #result_back").hide(); // 이전 버튼
			$("#new_road_addr_search .detailAddrSrc").show();

			// 선택된 주소 입력
			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			var zipCode  = obj.parent("span").parent("li").find("input[name='zipCode']").val();
			//var zipCode1  = obj.parent("span").parent("li").find("input[name='zipCode1']").val();
			//var zipCode2  = obj.parent("span").parent("li").find("input[name='zipCode2']").val();
			var dispAddr  = obj.parent("span").parent("li").find("input[name='dispAddr']").val();
			var addr1     = obj.parent("span").parent("li").find("input[name='addr1']").val();
			var addr2     = obj.parent("span").parent("li").find("input[name='addr2']").val();
			var addr3     = obj.parent("span").parent("li").find("input[name='addr3']").val();
			var buildName = obj.parent("span").parent("li").find("input[name='buildName']").val();
			var buildNum  = obj.parent("span").parent("li").find("input[name='buildNum']").val();
			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			var dongCode  = obj.parent("span").parent("li").find("input[name='dongCode']").val();
			var buildingManNum  = obj.parent("span").parent("li").find("input[name='buildingManNum']").val();

			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #zipcode").val(zipCode);
			//$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #zipcode1").val(zipCode1);
			//$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #zipcode2").val(zipCode2);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.block .inputBox #dispaddr").val(dispAddr);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #addr1").val(addr1);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #addr2").val(addr2);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #addr3").val(addr3);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #buildName").val(buildName);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #buildNum").val(buildNum);
			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #dongCode").val(dongCode);
			$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #buildingManNum").val(buildingManNum);
			
		},
		clickNewAddrRoadNameInputRest : function () {
			if($.trim($("#new_road_addr_search .detailAddrSrc.noline .inputWrap.block .inputBox #addLast").val()) == ""){
				alert($.msg.address.inputDetailAddress);
				$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.block .inputBox #addLast").val("");
				$("#new_road_addr_search .detailAddrSrc.noline .inputWrap.block .inputBox #addLast").focus();
				return false;
			}

			var param = {};
			param.zipCode  = $("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #zipcode").val();
			param.address1 = $("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #addr1").val();
			param.address2 = $("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #buildNum").val();
			param.restAddr = $("#new_road_addr_search .detailAddrSrc.noline .inputWrap.block .inputBox #addLast").val();
			//20160329 고문석 - 우편번호 5자리 변경 프로젝트
			param.dongCode  = $("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #dongCode").val();
			param.buildingManNum  = $("#new_road_addr_search .detailAddrSrc.noline .inputWrap.post #buildingManNum").val();
			
			$.ajax({
				type     : "GET",
				url      : $.address.data.baseUrl + "/searchCleanAddressForRoadNameAddr",
				data     : param,
				dataType : "html",
				success: function (data){
					$("#new_road_addr_search #final_addr").show();
					$("#new_road_addr_search #returnto_result_choice").show(); //이전 버튼
					
					if (data != null && data.length > 0) {
						$("#new_road_addr_search #final_addr").html(data);
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});							
		},
		message : {
			  MSG_ADDRESS_NOT_INPUT 	: "주소는 필수항목입니다. 주소 입력 후 저장해 주세요."
			, MSG_ADDRESS_POST_NUM_CHECK : "주소가 정상적이지 않습니다. 현재창을 닫고 다시 시도해 주시길 바랍니다."	  
			, MSG_NAME_NOT_INPUT        : "받는 분 성함은 필수항목입니다. 받는 분 성함 입력 후 저장해 주세요."
			, MSG_MOBILE_NOT_INPUT      : "휴대폰번호는 필수항목입니다. 휴대폰번호 입력 후 저장해 주세요."
			, MSG_AGREE_NOT_INPUT       : "개인정보 제3자 제공동의 체크는 필수입니다. 체크 후 저장해 주세요."
			, MSG_AGREE_NOT_YES         : "동의를 받으신 경우에만 저장이 가능합니다."
			, MSG_TOTAL_ADDR_COUNT      : "배송지는 최대 999개까지만 등록이 가능합니다."
			, MSG_UPDATE_DEFAULT_ADDR   : "이미 설정된 기본배송지가 있습니다. 기본배송지를 변경하시겠습니까?"
			, MSG_SET_DEFAULT_ADDR      : "기본배송지로 설정됩니다."
			, MSG_PHONE_FRONT_NUMBER_SIZE_CHECK  : "전화번호 앞자리는 세자리이상 입력해 주세요."
			, MSG_PHONE_BACK_NUMBER_SIZE_CHECK   : "전화번호 뒷자리는 네자리이상 입력해 주세요."
			, MSG_MOBILE_FRONT_NUMBER_SIZE_CHECK : "휴대폰번호 앞자리는 세자리이상 입력해 주세요."
			, MSG_MOBILE_BACK_NUMBER_SIZE_CHECK  : "휴대폰번호 뒷자리는 네자리이상 입력해 주세요."
		},
		initNewAddrSearch : function (option) {
			// 처음에는 지번주소검색부분만 표시함.
			$("#new_lotnum_addr_search").show();
			$("#new_lotnum_addr_input").show();
			$("#new_road_addr_search").hide();
			$("#new_road_addr_input").hide();
			$("#search_keyword").focus();
			
			$("#phone02").attr("maxlength", "4");
			$("#phone03").attr("maxlength", "4");
			$("#mobile02").attr("maxlength", "4");
			$("#mobile03").attr("maxlength", "4");
		},
		// modified for any
		selectAddressForSignup : function(addrFull, addrParam, callback) {
			callback.apply(opener, [addrParam]);
			$.address.popupClose();
		},
		// modified for any
		getCallbackByName : function(name){
		  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
		  var regexS = "[\\?&]"+name+"=([^&#]*)";
		  var regex = new RegExp( regexS );
		  var results = regex.exec( window.location.href );
		  
		  if( results == null )
			return "";
		  else
			return decodeURIComponent(results[1].replace(/\+/g, " "));
		},
		openAddressModifyPopupPage : function(addrSeq, flags, obj) {
			var actionUrl = "/shop/order/checkout/orderCreatingAddressModifyPopup?addrSeq=" + addrSeq + "&flags=" + flags;
			$.address.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
				$("#uiLayerPop_delivery").html(data);
				layerPopupOpen(obj);
			}, null);
		},
		saveNewDeliveryAddress : function (obj) {
			// [20150901 : 박준규] 기본 배송지 여부 체크
			var isBasicAddress = $("input:checkbox[id='basicAddress']").is(":checked");
			// [20150901 : 박준규] 수정할 주소의 Flags
			var flags = $("#flags");
			
			var num_check=/^[0-9]*$/;
			
			// 주소미입력
			if ($("#inputed_addr").text().length == 0) {
				alert($.address.message.MSG_ADDRESS_NOT_INPUT);
				return false;
			}
			
			// 우편번호 4자리 이하 or null
			if ($.address.validation.postNumCheck($(".pbLayerContent #addressSaveForm #post").val())) {
				alert($.address.message.MSG_ADDRESS_POST_NUM_CHECK);
				return false;
			}
			
			// 받는분 이름 미입력
			if ($("input[name=name]").val().length == 0) {
			    alert($.address.message.MSG_NAME_NOT_INPUT);
			    $("input[name=name]").focus();
				return false;
			}
			
			// [20150901 : 박준규] 기본배송지로 신규등록할때는 Flags를 S로 변경
			if (isBasicAddress) {
				flags.val("S");
			}
			
			// [20150901 : 박준규] Shipment/Application이 아닐때만 폰/핸드폰번호 체크
			if (flags.val() != "S" && flags.val() != "A") {
				// 전화번호 02 숫자 유효성 체크
				if(!num_check.test($("#phone02").val())){
					alert($.msg.common.inputOnlyNumber);
					$("#phone02").val("");
					$("#phone02").focus();
					return false;
				}
				// 전화번호 03 숫자 유효성 체크
				if(!num_check.test($("#phone03").val())){
					alert($.msg.common.inputOnlyNumber);
					$("#phone03").val("");
					$("#phone03").focus();
					return false;
				}
				// 폰번호 길이체크
				if ($("#phone02").val().length > 0 && $("#phone02").val().length < 3) {
					alert($.address.message.MSG_PHONE_FRONT_NUMBER_SIZE_CHECK);
					$("#phone02").focus();
					return false;
				}
				if ($("#phone03").val().length > 0 && $("#phone03").val().length < 4) {
					alert($.address.message.MSG_PHONE_BACK_NUMBER_SIZE_CHECK);
					$("#phone03").focus();
					return false;
				}
	
				// 휴대폰 번호 01 미입력
				if ($("#mobile01").val().length == 0) {
					alert($.address.message.MSG_MOBILE_NOT_INPUT);
					$("#mobile01").focus();
					return false;
				}
				// 휴대폰 번호 02 미입력
				if ($("#mobile02").val().length == 0) {
					alert($.address.message.MSG_MOBILE_NOT_INPUT);
					$("#mobile02").focus();
					return false;
				}
				// 휴대폰 번호 02 숫자 유효성 체크
				if(!num_check.test($("#mobile02").val())){
					alert($.msg.common.inputOnlyNumber);
					$("#mobile02").val("");
					$("#mobile02").focus();
					return false;
				}			
				// 휴대폰 번호 03 미입력
				if ($("#mobile03").val().length == 0) {
					alert($.address.message.MSG_MOBILE_NOT_INPUT);
					$("#mobile03").focus();
					return false;
				}
				// 휴대폰 번호 03 숫자 유효성 체크
				if(!num_check.test($("#mobile03").val())){
					alert($.msg.common.inputOnlyNumber);
					$("#mobile03").val("");
					$("#mobile03").focus();
					return false;
				}
				// 핸드폰번호 길이체크
				if ($("#mobile02").val().length < 3) {
					alert($.address.message.MSG_MOBILE_FRONT_NUMBER_SIZE_CHECK);
					$("#mobile02").focus();
					return false;
				}
				if ($("#mobile03").val().length < 4) {
					alert($.address.message.MSG_MOBILE_BACK_NUMBER_SIZE_CHECK);
					$("#mobile03").focus();
					return false;
				}
			}
			
			// 개인정보제3자 제공동의 미입력
			if ($("#new_lotnum_addr_input").find("input[name='agree']:checked").val() == undefined) {
				alert($.address.message.MSG_AGREE_NOT_INPUT);
				return false;
			}
			// 개인정보제3자 제공동의  아니오 선택
			if ($("#new_lotnum_addr_input").find("input[name='agree']:checked").val() == 1) {
				alert($.address.message.MSG_AGREE_NOT_YES);
				return false;
			}
			// 배송지 최대갯수(999) 를 초과하는 경우
			if ($("#new_lotnum_addr_input").find("#totalCount").val() == $.address.data.TOTAL_ADDR_COUNT) {
				alert($.address.message.MSG_TOTAL_ADDR_COUNT);
				return false;
			}
			// 기본배송지 설정
			if ($("input[name='defaultAddress']:checked").length == 1) {
				if(!confirm($.address.message.MSG_UPDATE_DEFAULT_ADDR)){
					return false;
				}
				$("#new_lotnum_addr_input .btnWrapC").find("input[id='flags']").val('S');
			}
			// 전화번호가 잘못 입력된 경우 전화번호 저장 안함
			if(($("#phone02").val().length == 0 && $("#phone03").val().length > 0) || ($("#phone02").val().length > 0 && $("#phone03").val().length == 0)//
					|| ($("#phone01 option:selected").val().length == 0 && $("#phone02").val().length > 2 && $("#phone03").val().length > 3)//
					|| ($("#phone01 option:selected").val().length != 0 && $("#phone02").val().length == 0 && $("#phone03").val().length == 0)) {
				$("#phone01 option:eq(0)").attr("selected", "selected");
				$("#phone02").val("");
				$("#phone03").val("");
			}
			if($.address.data.inProcSaveNewDeliveryAddress){
				return false;
			}

			$.address.data.inProcSaveNewDeliveryAddress = true;
			loadingLayerS();
			
			$.ajax({
				type     : "POST",
				url      : $.address.data.baseUrl + "/saveNewDeliveryAddress",
				data     : $(".pbLayerContent #addressSaveForm").serialize(),
				dataType : "json",
				success: function (data){
					
					$.address.data.inProcSaveNewDeliveryAddress = false;
					loadingLayerSClose();
					
					if(data.status != "SUCCESS"){
						alert(data.msg);
						return false;
					}
					
					var fullAddress  = $("#inputed_addr").text();
					var addrName     = $("#new_lotnum_addr_input #name").val();
					var phoneNumber  = $("#new_lotnum_addr_input #phone01 option:selected").val() + "-" +
					                   $("#new_lotnum_addr_input #phone02").val() + "-" +
							           $("#new_lotnum_addr_input #phone03").val();
					var mobileNumber = $("#new_lotnum_addr_input #mobile01 option:selected").val() + "-" +
						               $("#new_lotnum_addr_input #mobile02").val() + "-" +
							           $("#new_lotnum_addr_input #mobile03").val();
					var postalCode = $("#new_lotnum_addr_input .btnWrapC #post").val();
					var formattedAddress = $("#new_lotnum_addr_input .btnWrapC #formattedAddress").val();
					var modify = $("#uiLayerPop_delivery").attr("data-code");

					if(phoneNumber.length < 3){
						phoneNumber = "";
					}					

					if (($("#checkout_request_type").val() == "install" 
						    || $("#prev_delivery_choice_type_single_run").val() == 'singleAddr' 
			    	        || $("#prev_delivery_choice_type_single_run").val() == 'multiAddr'
					    	|| window.location.href.indexOf('myorder') != -1) && modify == undefined) {
						if ($("#prev_delivery_choice_type_single_run").val() == 'multiAddr') {
							// 부모창에 100개가 선택된 상태이면 부모창에 적용하지 않는다.
							if ($.address.checkSelectedAddrCount() == false) {
								closeLayerPopup(obj);
								return false;
							}

							// [복수배송지]
							var addrFlags  = $("#pbPopWrap #flags").val();   // general, gift

							// 이미 선택된 주소카운트
							var addrIndex = 0;
							$("#delivery_multi_choice").find("div.deliInputBox").each(function() {
								addrIndex += 1;
							});
							
							// 부모창에 적용
							addrIndex++;
							var addrHtml = $.address.makeMultiDeliveryInfoHtml(data.hybrisCode, data.legacyCode, addrFlags, addrIndex, addrName, '', phoneNumber, mobileNumber, postalCode, fullAddress);
							$("#delivery_multi_choice_addrList").append(addrHtml);

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

							closeLayerPopup(obj);
						} else {
							$("#delivery_single_delivery_address p").html(fullAddress);
							$("#delivery_single_delivery_name p").html(addrName);
							$("#delivery_single_delivery_tel p").html(phoneNumber);

							phoneNumber.length > 0 ? $("#delivery_single_delivery_tel").show() : $("#delivery_single_delivery_tel").hide();

							$("#delivery_single_delivery_mobile p").html(mobileNumber);
							$("#delivery_single_delivery_choice_radio_hidden").val(data.legacyCode);

							// myOrder form에 저장
							if(window.location.href.indexOf('myorder') != -1){
								var defaultAddrChecked = false;
								if($("input[name='defaultAddress']:checked").length == 1){
									defaultAddrChecked = true;
								}
								$.address.saveDataToMyOrderForm(data, formattedAddress, postalCode, addrName, phoneNumber, mobileNumber, defaultAddrChecked, obj);
							}
							else{
								// 재고체크 (설치주문만)
								if ($("#checkout_request_type").val() == 'install') {
									$("#delivery_single_delivery_choice_radio_hidden").click();
								}
								closeLayerPopup(obj);
							}
						}
					} else {
						// 배송지 관리
						if(window.location.href.indexOf('/address/shipping') != -1){
							closeLayerPopup(obj);
							window.location.reload();
						}else{
							var actionUrl = "/shop/order/checkout/orderCreatingSingleAddressListPopup";
							$.address.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
								$("#uiLayerPop_delivery").html(data);
							}, null);
						}
					}
				},
				error: function(xhr, st, err){
					xhr = null;
					$.address.data.inProcSaveNewDeliveryAddress = false;
					loadingLayerSClose();
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						alert($.msg.err.system);
					}
					return false;
				}
			});							
		},
		checkSelectedAddrCount : function () {
			var parentSelectedAddrCount = 0;
			$("#delivery_multi_choice").find("div.deliInputBox").each(function() {
				parentSelectedAddrCount++;
			});
			
			if (parentSelectedAddrCount > 99) {
				return false;
			}
			return true;
		},
		saveDataToMyOrderForm : function (data, formattedAddress, postalCode, addrName, phoneNumber, mobileNumber, defaultAddrChecked, obj){
			var addrArray = formattedAddress.split("] ");
			var fullAddress = formattedAddress;
			if(addrArray.length >= 2){
				fullAddress = addrArray[1];
			}
				
			$("#delivery_single_delivery_address").html( $.address.makeSingleDeliveryAddressHtml(postalCode, fullAddress));
			
			// form에 값 저장
			$("#addressSaveForm input[name='addrSeq']").val(data.legacyCode);
			$("#addressSaveForm input[name='name']").val(addrName);
			$("#addressSaveForm input[name='addrType']").val($("#new_lotnum_addr_input .btnWrapC #addrType").val());
			$("#addressSaveForm input[name='homePhone']").val(phoneNumber);
			$("#addressSaveForm input[name='mobilePhone']").val(mobileNumber);								
			$("#addressSaveForm input[name='post']").val($("#new_lotnum_addr_input .btnWrapC #post").val());
			
			if($("#addrGroupTr #deleiveryAddressGroup option:selected").text() == "일반"){
				$("#addressSaveForm input[name='flags']").val("GENERAL"); // addrFlags
			}
			else{
				$("#addressSaveForm input[name='flags']").val("GIFT"); // addrFlags
			}

			$("#addressSaveForm input[name='formattedAddress']").val(fullAddress);
			
			$("#updateDeliveryInfoBtn").attr("style", "display:none;");
			$("#myOrderDetail01").attr("style", "display:block;");
			   
			 $.address.reloadMyOrderDeliveryInfo(defaultAddrChecked, obj);
		},
		makeSingleDeliveryAddressHtml : function (postalCode, fullAddress) {
			var htmlAddress = 
				"<strong class='labelSizeM'>주소</strong>" +
				"<div class='addressWrap addressR'>";

				if(postalCode != null && postalCode.length == 6){
					var prePostalCode = postalCode.substring(0, 3);
					var postPostalCode = postalCode.substring(3, 6);
					htmlAddress += " <span> [<span>" + prePostalCode + "-" + postPostalCode + "</span>] " + fullAddress + "</span>";
				}
				else{
					htmlAddress += " <span> [<span>" + postalCode + "</span>] " + fullAddress + "</span>";
				}
				// hidden 변수에 세팅
				$("#changePostCode").val(postalCode);

				htmlAddress += "</div>";
		    return htmlAddress;
		},
		reloadMyOrderDeliveryInfo : function (isChangeDefaultAddr, obj){
			var params	   = {};				
			params.isChangeDefaultAddr	       = isChangeDefaultAddr;
			
			$.ajax({
				type     : "GET",
				url      : "/shop/myorder/detail/ajax/reloadRecentlyAddrList",
				data     : params,
				dataType : "html",
				success: function (data){
					$("#delivery_single_delivery_choice").html(data);
					closeLayerPopup(obj);
				},
				error: function(xhr, st, err){
					alert($.msg.err.system);
					closeLayerPopup(obj);
				}
			});
		},
		data : {
			  addrUsePage		: 'CHECKOUT'
			, baseUrl			: ""
			, TOTAL_ADDR_COUNT  : "999"
			, url				: "/_ui/mobile"
			, checkoutBaseUrl	: "/shop/order/checkout"
			, anyoneBaseUrl		: "/account/find/address"
			, myorderDetailBaseUrl	: "/shop/myorder/detail"
			, inProcSaveNewDeliveryAddress   : false				
		},
		makeMultiDeliveryInfoHtml : function (addrKey, addrCode, addrFlags, addrIndex, addrName, addrType, phone, mobile, postalCode, formattedAddress) {
			var strHtml = "";
			var btnImg = "";
			var useClass = "";
			var strAddrIndex = addrIndex + "";

			if (addrIndex < 10) {
				strAddrIndex = "0" + strAddrIndex;
			}

			if(addrIndex == 1){
				useClass = "on";
				btnImg = $.address.data.url + '/images/content/btn_child_close.gif';
			}else{
				btnImg = $.address.data.url + '/images/content/btn_child_open.gif';
			}
			$("#delivery_multi_choice #addrMenu").remove();
			
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
			strHtml += '			<span>' + formattedAddress + '</span>';
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
				strHtml += '					<option value="빠른 배송 부탁 드립니다.">빠른 배송 부탁 드립니다.</option>';
				strHtml += '					<option value="부재 시 휴대폰으로 연락주세요.">부재 시 휴대폰으로 연락주세요.</option>';
				strHtml += '					<option value="배송 전 연락 부탁 드립니다.">배송 전 연락 부탁 드립니다.</option>';
				strHtml += '					<option value="(최근)주말배송 싫어요.">(최근)주말배송 싫어요.</option>';
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
		}
	};
})(jQuery);
