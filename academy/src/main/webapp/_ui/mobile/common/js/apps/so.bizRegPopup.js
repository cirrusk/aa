(function($) {
	$.estimate = {
			data : {
				  url : "/_ui/mobile"
				, isSeeMore : ""
				, page : ""
				, totCnt : ""
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
				params.type = "popup";

				$.estimate.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					$.estimate.data.inProgress = false;
					if(option=="S" || option=="R"){
						$("#bizList").html(data);
					}else{
						$("#bizList").html($("#bizList").html()+data);
					}

					$("input[name=corSearch]").val(searchValue);
					$("#nameOldSearch").val(searchValue);

					//검색오류알림
					if(option=="S"){
						var tmpTot= $.estimate.data.totCnt;
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
	// 사업자등록증 관리
	// ############################################################################	

	// 더보기 - SeeMore
	$(document).off("click", "#btnBizSeeMore").on("click", "#btnBizSeeMore", function(e){
		$.estimate.data.page++;
		$.estimate.getData("O", $.estimate.data.page, $(this).attr("data-type"));
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

	// 사업자 등록증 상세보기
	$(document).on("click", "#btnMgmtDetail", function(){
		$.windowOpener($(this).attr("href"), $.getWinName());
		return false;
	});
	
	// 사업자 등록증 팝업 - 선택
	$(document).on("click", "#biz01", function(e){
		event.preventDefault();
		var parentli = $(this).parents("li");
		var bizName = parentli.find("input[name=bizName]").val();
		var bizNum = parentli.find("input[name=bizNum]").val();
		var apprDtOrg = parentli.find("input[name=apprDtOrg]").val();
		var bizApprDt =  parentli.find("strong[id=bizApprDt]").text();
		var addrParam = " : " + bizNum + " " + bizName;

		$("#bizInfo").html(addrParam);
		$("#bizInfoNumber").val(bizNum);
		$("#bizInfoApproveDate").val(apprDtOrg);
		$("#bizInfoName").val(bizName);
		
		// 나의 주문내역 처리
		if($("#hiddenPageType").val() == 'MYORDER'){
			var msg = "거래내역증빙신청을 변경하시겠습니까?";
			msg += "\n\n사업장명 : " + bizName;
			msg += "\n사업자등록번호 : " + bizNum;
			
			if (confirm(msg)) {
				$("span[id='myOrderbizName']").attr("style", "display;");
				$("span[id='myOrderbizInfoNumber']").attr("style", "display;");		
				$("#myOrderbizName").html(bizName);
				$("#myOrderbizInfoNumber").html(bizNum);
				$("#myOrderbizApprDt").val(apprDtOrg);
				$("input:radio[id='appBizY']").attr("checked", true);
				$("input:radio[id='appCashY']").attr("checked", false);
				$("input:radio[id='appCashN']").attr("checked", false);
				$("a[id='choice_corporate_reg_number_reg']").hide();
				$("a[id='choice_corporate_reg_number_change']").show();
				
				var id = $("#orderDetailInvoiceCode").val();
				var menus = $("#ordDetailMenus").val();
				var isGeneralInReservedMenu = $.myOrderList.getBooleanValue($("#isGeneralInReservedMenu").val());					
				if(menus != "general" && isGeneralInReservedMenu != true){
					id = $("#orderDetailCode").val();
				}
				
				$.myOrderList.detail.updateEvidence(id, bizNum, apprDtOrg, '', '', 'biz', menus, isGeneralInReservedMenu);
			}
		}
		else{
			closeLayerPopup($(this).parents("#uiLayerPop_bizReg"));
			$("#uiLayerPop_bizReg").html("");
		}
		return false;
	});
	
	$(document).on("click", "#bizList label", function(e){
		return false;
	});
	
	// 팝업 닫기 버튼
	$(document).on("click", "#btnPopClose, #btnBizPopClose", function(){
		event.preventDefault();
		closeLayerPopup($(this).parents("#uiLayerPop_bizReg"));
		$("#uiLayerPop_bizReg").html("");
		return false;
	});

	// 상세보기
	$(document).on("click", "#btnRegBizDetail", function(){
		var actionUrl = $(this).attr("href");
		$.estimate.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_bizReg").html(data);
		}, null);
		return false;
	});
	
	// 상세보기 - 이전
	$(document).on("click", "#btnPrevRegBiz", function(){
		var actionUrl = $(this).attr("href");
		$.estimate.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
			$("#uiLayerPop_bizReg").html(data);
		}, null);
		return false;
	});	

})(jQuery);