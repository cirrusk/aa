
(function($) {
	$.record={
			data : {},
			
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.record.ajax(type, url, dataType, data, successCallBack, errorCallBack); });
			},
			
			ajax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					success: function (data){
						if(data.result === "false"){
							alert(data.errorMessage);
							NetFunnel_Complete();
							return;
						}else{
							successCallBack(data);
							NetFunnel_Complete();
							return false;
						}
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === "function" ) { 
							errorCallBack();
						} else {
							alert($.msg.err.system);
						}
						NetFunnel_Complete();
						return false;
					}
				});				
			},
			
			//layerpopup 초기화
			popupInit : function(){
				$("#userSel01").prop('checked', true);
				$("#userSel02").prop('checked', false);
				$("#inqueryList").val("default").attr('selected', "selected");
				$("#titleText").val("기본");
				$("#new").hide();
				$("#modify").show();
				$("#inqueryList").attr('disabled', false);
				$.setInquery.setDefaultEntry();
			}
	} 
})(jQuery)


// [메인] 회계년도, 조회항목명 선택
$(document).on("change", "#deadlineResultSearchYear, #myInqueryList", function(){
		var searchItemsName = $("#myInqueryList").val();
		if (searchItemsName ==="searchNow"){
			searchItemsName = "default";
		}
		var targetYear = $("#deadlineResultSearchYear").val();
		var url = "/business/record/deadline/periodChange";
		var params	   = {};
		 
		params.deadlineResultSearchYear = targetYear;
		params.searchEntry = searchItemsName;
//		loadingLayerS();
		
		$.record.callAjax('GET', url, 'html', params, function successCallBack(data){
			$("#myInqueryList option").each(function(){
				if($(this).val()==="searchNow"){
					$(this).remove();
				}
			});
			$("#deadlineResult_List").html(data);
			$("#deadlineResultSearchYear").val(targetYear);
			flickingAreaS();
			$(window).trigger('resize');	
			$("#myInqueryList").val(searchItemsName).attr('selected', "selected");
//			loadingLayerSClose();
		},null);
});

// 조회항목 설정 팝업 열기
$(document).off("click", "#inqueryBtn").on("click", "#inqueryBtn", function(e){
	$.record.popupInit();
	$(this).attr("href", "#uiLayerPop_03");
	layerPopupOpen($(this));
	$.setInquery.setDefaultEntry();
	return false;
});