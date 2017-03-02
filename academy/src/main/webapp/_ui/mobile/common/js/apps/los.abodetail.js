(function($) {
	$.aboDetail = {
		showPrivatePv : function()	{
			$("#privatePvGraph").show();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").hide();
			
			$("#privatePvTable").show();
			$("#privateBvTable").hide();
			$("#groupPvTable").hide();
			$("#groupBvTable").hide();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").hide();
			$("#volumePvTable").hide();
			$("#volumeBvTable").hide();

			$.aboDetail.setAxisX($("#hiddenMaxValuePrivatePv").val());
		},
		showPrivateBv : function()	{
			$("#privatePvGraph").hide();
			$("#privateBvGraph").show();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").hide();		
			
			$("#privatePvTable").hide();
			$("#privateBvTable").show();
			$("#groupPvTable").hide();
			$("#groupBvTable").hide();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").hide();
			$("#volumePvTable").hide();
			$("#volumeBvTable").hide();

			$.aboDetail.setAxisX($("#hiddenMaxValuePrivateBv").val());
		},
		showGroupPv : function()	{
			$("#privatePvGraph").hide();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").show();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").hide();		
			
			$("#privatePvTable").hide();
			$("#privateBvTable").hide();
			$("#groupPvTable").show();
			$("#groupBvTable").hide();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").hide();
			$("#volumePvTable").hide();
			$("#volumeBvTable").hide();

			$.aboDetail.setAxisX($("#hiddenMaxValueGroupPv").val());
		},
		showGroupBv : function(){
			$("#privatePvGraph").hide();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").show();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").hide();

			$("#privatePvTable").hide();
			$("#privateBvTable").hide();
			$("#groupPvTable").hide();
			$("#groupBvTable").show();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").hide();
			$("#volumePvTable").hide();
			$("#volumeBvTable").hide();

			$.aboDetail.setAxisX($("#hiddenMaxValueGroupBv").val());
		},
		showRubyPv  : function()	{
			$("#privatePvGraph").hide();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").show();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").hide();

			$("#privatePvTable").hide();
			$("#privateBvTable").hide();
			$("#groupPvTable").hide();
			$("#groupBvTable").hide();
			$("#rubyPvTable").show();
			$("#rubyBvTable").hide();
			$("#volumePvTable").hide();
			$("#volumeBvTable").hide();

			$.aboDetail.setAxisX($("#hiddenMaxValueRubyPv").val());
		},
		showRubyBv : function(){
			$("#privatePvGraph").hide();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").show();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").hide();

			$("#privatePvTable").hide();
			$("#privateBvTable").hide();
			$("#groupPvTable").hide();
			$("#groupBvTable").hide();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").show();
			$("#volumePvTable").hide();
			$("#volumeBvTable").hide();

			$.aboDetail.setAxisX($("#hiddenMaxValueRubyBv").val());
		},
		showVolumePv : function()	{
			$("#privatePvGraph").hide();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").show();
			$("#volumeBvGraph").hide();

			$("#privatePvTable").hide();
			$("#privateBvTable").hide();
			$("#groupPvTable").hide();
			$("#groupBvTable").hide();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").hide();
			$("#volumePvTable").show();
			$("#volumeBvTable").hide();
			
			$.aboDetail.setAxisX($("#hiddenMaxValueVolumePv").val());
		},
		showVolumeBv	 : function(){
			$("#privatePvGraph").hide();
			$("#privateBvGraph").hide();
			$("#groupPvGraph").hide();
			$("#groupBvGraph").hide();
			$("#rubyPvGraph").hide();
			$("#rubyBvGraph").hide();
			$("#volumePvGraph").hide();
			$("#volumeBvGraph").show();

			$("#privatePvTable").hide();
			$("#privateBvTable").hide();
			$("#groupPvTable").hide();
			$("#groupBvTable").hide();
			$("#rubyPvTable").hide();
			$("#rubyBvTable").hide();
			$("#volumePvTable").hide();
			$("#volumeBvTable").show();

			$.aboDetail.setAxisX($("#hiddenMaxValueVolumeBv").val());
		},
		setAxisX : function(maxValue) {
			if(maxValue <= 0){
				maxValue = 100000;
			}
			var axisX = $(".graphUnit");
			axisX.html('');
			
			var html = '<span>0</span>';			
			for(var idx = 1; idx <= 10; idx++){
				if(idx % 2 == 0){
					//html += "<span><fmt:formatNumber pattern='###,###' value='" + ((maxValue / 10) * idx) + "'/></span>";
					html += "<span>" +$.losCommon.numberWithCommas((maxValue / 10) * idx) + "</span>";	
				}
			}			
			axisX.html(html);
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
})(jQuery);	

//[메인] 회계년도, 조회항목명 선택
$(document).on("change", "#deadlineResultSearchYear, #myInqueryList", function(){
		var searchItemsName = $("#myInqueryList").val().trim(); 
		var targetYear = $("#deadlineResultSearchYear").val();
		var selectedUserPk = $(".selectedUserPk").text();
		
		var url = "/business/record/deadline/periodChange";
		var params	   = {};
		
		params.deadlineResultSearchYear = targetYear;
		params.searchEntry = searchItemsName;
		params.selectedPk = selectedUserPk;
		
		$.losCommon.callAjax('GET', url, 'html', params, function successCallBack(data){
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
			return false;
		},null);
});


$(document).on("change", "#searchType", function(){
	var searchType = $("#searchType").val().trim();
	
	switch(searchType){
	case "personalPV" :
		$.aboDetail.showPrivatePv();
		break;
	case "privateBV" :
		$.aboDetail.showPrivateBv();
		break;
	case "groupPV" :
		$.aboDetail.showGroupPv();
		break;
	case "groupBV" :
		$.aboDetail.showGroupBv();
		break;
	case "rubyPv" :
		$.aboDetail.showRubyPv();
		break;
	case "rubyBV" :
		$.aboDetail.showRubyBv();
		break;
	case "volumePV" :
		$.aboDetail.showVolumePv();
		break;
	case "volumeBV" :
		$.aboDetail.showVolumeBv();
		break;
	}
});

$(document).on("click", "#viewAboInfo", function(){
	$(".tab01").parent().addClass("on");
	$(".tab02").parent().removeClass("on");	
	$(".tab03").parent().removeClass("on");
	$("#btnCnt").remove();
})

$(document).on("click", "#viewResult", function(){
	$(".tab01").parent().removeClass("on");
	$(".tab02").parent().addClass("on");	
	$(".tab03").parent().removeClass("on");
	flickingAreaS();
	$(window).trigger('resize');	
})

$(document).on("click", "#viewGraph", function(){
	$(".tab01").parent().removeClass("on");
	$(".tab02").parent().removeClass("on");	
	$(".tab03").parent().addClass("on");
	$("#btnCnt").remove();
	
	var url = "/business/losmap/popup/ajax/graph";
	loadingLayerS(); 
	var selectedUserPk = $(".selectedUserPk").text();
	var params	   = {};
	params.selectedPk = selectedUserPk;
	
	$.losCommon.callAjax('GET', url, "", params, function successCallBack(data){
		$("#aboGraphDiv").html(data);
		$.aboDetail.showPrivatePv(); // default : personalPV
		loadingLayerSClose();
	},null);
})

// 조회항목 설정 팝업 열기
$(document).off("click", "#inqueryBtn").on("click", "#inqueryBtn", function(e){
	$.aboDetail.popupInit();
	$(this).attr("href", "#uiLayerPop_03");
	layerPopupOpen($(this));
	$.setInquery.setDefaultEntry();
	return false;
});


$(document).on("click", "#inqueryPopupClose", function(){
	closeLayerPopup($($("#inqueryPopup").attr('href')));
});


