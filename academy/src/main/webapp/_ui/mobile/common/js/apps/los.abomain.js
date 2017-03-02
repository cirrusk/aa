(function($) {
	
	$.bizAboMain = {
			data : {
				  ALERT_MSG_AUTH_PT 	: "해당 서비스는 PT 이상 이용하실 수 있습니다."
				, ALERT_MSG_AUTH_DIA 	: "해당 서비스는 다이아몬드 이상 이용하실 수 있습니다."
				, AUTH_PLATINUM 		: "Platinum"
				, AUTH_DIAMOND 			: "Diamond"
				, isPtGroup				: false
				, isDiaGroup			: false
				, currentPv				: 0
			},
			checkAuthority : function(obj){
				if(obj.attr("data-auth") == null || obj.attr("data-auth") == ""){
					alert("해당 서비스는 다이아몬드/PT 이상 이용하실 수 있습니다.");
					return false;
				}
				
				if(obj.attr("data-auth") == $.bizAboMain.data.AUTH_PLATINUM && !($.bizAboMain.data.isPtGroup || $.bizAboMain.data.isDiaGroup)){
					alert($.bizAboMain.data.ALERT_MSG_AUTH_PT);
				}else if(obj.attr("data-auth") == $.bizAboMain.data.AUTH_DIAMOND && !$.bizAboMain.data.isDiaGroup){
					alert($.bizAboMain.data.ALERT_MSG_AUTH_DIA);
				}else if(obj.attr("href") != "#" && obj.attr("href") != "javascript:;"){
					if(obj.attr("target") == "_blank"){
						window.open(obj.attr("href"), '_blank');
					}else{
						location.href = obj.attr("href");
					}
				}
				return false;
			},
			setSelectByCurrentPvRate : function(){
				$("#selectTargetPvRate").val(Number($("#currentPvRateForSelect").val()) + 3);
			},
			saveTargetPvRate : function(targetPvRate){
				
				$.bizAboMain.callAjax(
										"GET"
									  , "/business/ajax/save-achieve"
									  , "html"
									  , {"targetPvRate" : targetPvRate} 
									  , function successCallBack(data){
										  $("#bizLosMap").html(data);
										  //closeLayerPopup($($("#regitTargetPv").attr('href')));
										}
									  , null);
			},
			setTargetPvRate : function(targetPvRate){
				var differenceVal = 0;
				switch (Number(targetPvRate)) {
				case 21:
					differenceVal = 10000000 - $.bizAboMain.data.currentPv;
					break;
				case 18:
					differenceVal = 6800000 - $.bizAboMain.data.currentPv;
					break;
				case 15:
					differenceVal = 4000000 - $.bizAboMain.data.currentPv;
					break;
				case 12:
					differenceVal = 2400000 - $.bizAboMain.data.currentPv;
					break;
				case 9:
					differenceVal = 1200000 - $.bizAboMain.data.currentPv;
					break;
				case 6:
					differenceVal = 600000 - $.bizAboMain.data.currentPv;
					break;
				case 3:
					differenceVal = 200000 - $.bizAboMain.data.currentPv;
					break;
				default:
					break;
				}
				
				differenceVal = differenceVal < 0 ? 0 : differenceVal;
				
				$("#needPV").val($.formatCurrency(differenceVal, 0));
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						// alert(err);
						if( typeof errorCallBack === 'function' ) { 
							errorCallBack(); 
						} else {
							loadingLayerSClose();
							alert($.msg.err.system);
						}
						return false;
					},
					complete : function(){
						loadingLayerSClose();
					}
				});
			}
			
	};

	// 레이어팝업 취소 버튼 이벤트
	$(document).off("click", ".pbLayerContent .btnBasicGL").on("click", ".pbLayerContent .btnBasicGL", function(e){
		closeLayerPopup($($("#regitTargetPv").attr('href')));
		return false;
	});

	$(document).off("click", ".pbLayerContent .btnPopClose").on("click", ".pbLayerContent .btnPopClose", function(e){
		closeLayerPopup($($("#regitTargetPv").attr('href')));
		return false;
	});
/*
	// 상위PIN전용 배너 클릭 이벤트
	$(document).off("click", "#bizMainPin a").on("click", "#bizMainPin a", function(e){
		$.bizAboMain.checkAuthority($(this));
		return false;
	});
*/
/*
	// 상위PIN전용 레이버 팝업 배너 클릭 이벤트
	$(document).off("click", "#subMainWrap .pbLayerContent .mainBizAbo li a").on("click", "#subMainWrap .pbLayerContent .mainBizAbo li a", function(e){
		$.bizAboMain.checkAuthority($(this));
		return false;
	});
*/
	// 차기 목표 달성 저장 이벤트
	$(document).off("click", "#saveTargetPvRate").on("click", "#saveTargetPvRate", function(e){
		closeLayerPopup($($("#regitTargetPv").attr('href')));
		loadingLayerS();
		$.bizAboMain.saveTargetPvRate($("#selectTargetPvRate option:selected").val());
		return false;
	});

	// 차기 달성 목표 변경 이벤트
	$(document).off("change", "#selectTargetPvRate").on("change", "#selectTargetPvRate", function(e){
		$.bizAboMain.setTargetPvRate($(this).val());
		return false;
	});
	
	// 차기 달성 목표 레이어 팝업
	$(document).off("click", "#regitTargetPv").on("click", "#regitTargetPv", function(e){
		$.bizAboMain.setTargetPvRate($("#selectTargetPvRate").val());
		return false;
	});
	
})(jQuery);

