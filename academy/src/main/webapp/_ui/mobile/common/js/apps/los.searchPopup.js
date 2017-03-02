(function($) {
	$.searchPopup = {
			searchNow : function(){
				searchCondition = $.searchPopup.getSearchCondition();
				searchCondition.pop(); //CSRF토큰 제거
				if(!$("#searchConditionSelect").attr('disabled')){
					searchCondition.shift(); // id 제거
				}				
				searchCondition.shift(); // title 제거		
				
				$.losmapMain.startSearch(searchCondition);
				closeLayerPopup($($("#ptGroupDetailSearchPopup").attr('href')));
				
			},

			saveSearchCondition : function(){
				
				var titleText = $("#userSearchText").val();
				if(titleText.length === 0){
					alert($.getMsg($.msg.common.inputDetail, "사용자 조회 항목명"));
					return false;
				}
				
				
				
				$.post("/business/losmap/popup/searchcondition/ajax/set", $.searchPopup.getSearchCondition(),function(data) {
					
					$.searchPopup.searchNow();				
					$.searchPopup.refreshSearchConditionList(titleText);
				});
				
			},
			
			setNewNameSearchCondition : function(){
				
				var titleText = $("#userSearchText").val();
				if(titleText.length === 0){
					alert($.getMsg($.msg.common.inputDetail, "사용자 조회 항목명"));
					return false;
				}
				var isSameName = false;
				$("#searchConditionSelect option").each(function() {
	                if ($(this).text() == $.trim(titleText)) {
	                	alert($.getMsg($.msg.los.inquery.sameName));
	                	isSameName = true;
	                	return false;
	                }
	            });		
				
				if(isSameName){
					return false;
				}
				
				selectedItems = $.searchPopup.getSearchCondition();

				
				$.post("/business/losmap/popup/searchcondition/ajax/set", selectedItems ,function(data) {
					$.searchPopup.searchNow();
					$.searchPopup.refreshSearchConditionList(titleText);					
				});
				
			},
			
			deleteSearchCondition : function(){
				var id = $("#searchConditionSelect").val();
				if(id=="-1"){
					alert($.getMsg($.msg.los.inquery.defaultAttributeDelete));
					return false;
				}
				
				$.losCommon.callAjax("GET", "/business/losmap/popup/searchcondition/ajax/delete", "html", { "id" :  id }, 
				function successCallBack(data) {
					$.searchPopup.refreshSearchConditionList();
							
				}, null);		
			},
			
			refreshSearchConditionList : function(titleText){				
				var html;
				
				$.losCommon.callAjax("GET", "/business/losmap/popup/searchcondition/ajax/getList", "json",  "", 
						function successCallBack(data) {
							var html ="";
							html += "<option value='-1'>전체</option>";
							for(i=0; i < data.length ; i++){
								if(data[i].title==titleText){
									html += "<option value=" + data[i].id + " selected >" + data[i].title + "</option>";
								}else {
									html += "<option value=" + data[i].id + ">" + data[i].title + "</option>";
								}
							}
							$("#searchConditionSelect").html(html);
							$("#userSearchConditionSelectMain").html(html);
							return false;
						}, null);	
				
				closeLayerPopup($($("#searchPopup").attr('href')));
			},

			getSearchCondition : function(){
				var searchCondition = $("#searchConditionForm").serializeArray();				
				return searchCondition;
			},
			changeSetType : function(){
				
				var selectedOption = $("#searchConditionSelect option:selected").text();
				var id = $("#searchConditionSelect option:selected").val();
				$("#userSearchText").val(selectedOption);
				
				$.searchPopup.resetSearchPopup();			
				
				if(id=="-1"){						
					return false;
				}else{
					$.losCommon.callAjax("GET", "/business/losmap/popup/searchcondition/ajax/getItem", "json", { "id" :  id }, 
							function successCallBack(data) {							
							$.searchPopup.setLosSearchCondition(data);
							}, null);
					
				}					
			},
			
			resetSearchPopup : function(losSearchCodition){
				var defaultComparator="MORE_THAN";			
				
				$("#uiSeting_01").removeClass("on");
				$("#currentPinCondition").val("");
				$("#currentPinConditionComparator").val(defaultComparator);
				$("#highestPinCondition").val("");
				$("#highestPinConditionComparator").val(defaultComparator);
				
				$("#uiSeting_02").removeClass("on");
				$("#currentAchieveRateCondition").val("");
				$("#currentAchieveRateConditionComparator").val(defaultComparator);
				$("#goalAchieveRateCondition").val("");
				$("#goalAchieveRateConditionComparator").val(defaultComparator);

				$("#uiSeting_03").removeClass("on");
				$("#personalPvCondition").val("");
				$("#personalPvConditionComparator").val(defaultComparator);
				$("#groupPvCondition").val("");
				$("#groupPvConditionComparator").val(defaultComparator);

				$("#uiSeting_04").removeClass("on");
				$("#orderAmountCondition").val("");
				$("#orderAmountConditionComparator").val(defaultComparator);
				$("#orderCountCondition").val("");
				$("#orderCountConditionComparator").val(defaultComparator);
				
				$("#uiSeting_05").removeClass("on");
				$("#returnAmountCondition").val("");
				$("#returnAmountConditionComparator").val(defaultComparator);
				$("#returnCountCondition").val("");
				$("#returnCountConditionComparator").val(defaultComparator);
			},
			
			setLosSearchCondition : function(losSearchCodition){
				if(losSearchCodition.currentPinCondition !=null){
					$("#currentPinCondition").val(losSearchCodition.currentPinCondition);
					$("#currentPinConditionComparator").val(losSearchCodition.currentPinConditionComparator);
					$("#uiSeting_01").addClass("on");
				}	
				
				if(losSearchCodition.highestPinCondition !=null){
					$("#highestPinCondition").val(losSearchCodition.highestPinCondition);
					$("#highestPinConditionComparator").val(losSearchCodition.highestPinConditionComparator);
					$("#uiSeting_01").addClass("on");
				}	
				
				if(losSearchCodition.currentAchieveRateCondition !=null){
					$("#currentAchieveRateCondition").val(losSearchCodition.currentAchieveRateCondition);
					$("#currentAchieveRateConditionComparator").val(losSearchCodition.currentAchieveRateConditionComparator);
					$("#uiSeting_02").addClass("on");
				}	
				
				if(losSearchCodition.goalAchieveRateCondition !=null){
					$("#goalAchieveRateCondition").val(losSearchCodition.goalAchieveRateCondition);
					$("#goalAchieveRateConditionComparator").val(losSearchCodition.goalAchieveRateConditionComparator);
					$("#uiSeting_02").addClass("on");
				}	
				
				if(losSearchCodition.personalPvCondition !=null){
					$("#personalPvCondition").val(losSearchCodition.personalPvCondition);
					$("#personalPvConditionComparator").val(losSearchCodition.personalPvConditionComparator);
					$("#uiSeting_03").addClass("on");
				}	
				
				if(losSearchCodition.groupPvCondition !=null){
					$("#groupPvCondition").val(losSearchCodition.groupPvCondition);
					$("#groupPvConditionComparator").val(losSearchCodition.groupPvConditionComparator);
					$("#uiSeting_03").addClass("on");
				}	
				
				if(losSearchCodition.orderAmountCondition !=null){
					$("#orderAmountCondition").val(losSearchCodition.orderAmountCondition);
					$("#orderAmountConditionComparator").val(losSearchCodition.orderAmountConditionComparator);
					$("#uiSeting_04").addClass("on");
				}	
				
				if(losSearchCodition.orderCountCondition !=null){
					$("#orderCountCondition").val(losSearchCodition.orderCountCondition);
					$("#orderCountConditionComparator").val(losSearchCodition.orderCountConditionComparator);
					$("#uiSeting_04").addClass("on");
				}	
				
				if(losSearchCodition.returnAmountCondition !=null){
					$("#returnAmountCondition").val(losSearchCodition.returnAmountCondition);
					$("#returnAmountConditionComparator").val(losSearchCodition.returnAmountConditionComparator);
					$("#uiSeting_05").addClass("on");
				}	
				
				if(losSearchCodition.returnCountCondition !=null){
					$("#returnCountCondition").val(losSearchCodition.returnCountCondition);
					$("#returnCountConditionComparator").val(losSearchCodition.returnCountConditionComparator);
					$("#uiSeting_05").addClass("on");
				}			
			}


	}

})(jQuery);	

//기존설정 라디오
$(document).on("click", "#setupUsedRadio", function (){
	$("#setupNewRadio").prop('checked', false);
	$("#searchNew").addClass("hide");
	$("#searchExsiting").removeClass("hide");
	$("#searchConditionSelect").attr('disabled', false);
})

//신규설정 라디오
$(document).on("click", "#setupNewRadio", function (){
	$("#setupUsedRadio").prop('checked', false);
	$("#searchNew").removeClass("hide");
	$("#searchExsiting").addClass("hide");
	$("#searchConditionSelect").attr('disabled', true);
	$("#userSearchText").val("");
})

$(document).on("click", "#searchNowSearchCondition", function (){
	$.losmapMain.addSearchConditionSearchNowOption();
	$.searchPopup.searchNow();
	closeLayerPopup($($("#searchPopup").attr('href')));
})

$(document).on("click", "#saveSearchCondition", function (){
	if($("#searchConditionSelect option").size()>10){
		alert($.getMsg($.msg.los.inquery.searchListCountOver));
		return false;
	}
	
	var isSameName = false;
	var titleText = $("#userSearchText").val();
	$("#searchConditionSelect option").each(function() {
        if ($(this).text() == $.trim(titleText)) {
        	alert($.getMsg($.msg.los.inquery.sameName));
        	isSameName = true;
        	return false;
        }
    });		
	
	if(isSameName){
		return false;
	}
	$.searchPopup.saveSearchCondition()
})

$(document).on("click", "#modifySearchCondition", function (){	
	$.searchPopup.saveSearchCondition()
})

$(document).on("click", "#deleteSearchCondition", function (){	
	$.searchPopup.deleteSearchCondition()
})

$(document).on("change", "#searchConditionSelect", function (){	
	$.searchPopup.changeSetType()
})
$(document).on("click", "#setNewNameSearchCondition", function (){	
	if($("#searchConditionSelect option").size()>10){
		alert($.getMsg($.msg.los.inquery.searchListCountOver));
		return false;
	}
	$.searchPopup.setNewNameSearchCondition()
})

$(document).on("click", "#personalPvYes", function (){	
	$("#personalPvNo").prop('checked', false);
	$("#personalPvCondition").val("0");
	$("#personalPvConditionComparator").val("MORE_THAN");
})
$(document).on("click", "#personalPvNo", function (){	
	$("#personalPvYes").prop('checked', false);
	$("#personalPvCondition").val("0");
	$("#personalPvConditionComparator").val("LESS_THAN");
})

$(document).on("click", "#groupPvYes", function (){	
	$("#groupPvNo").prop('checked', false);
	$("#groupPvCondition").val("0");
	$("#groupPvConditionComparator").val("MORE_THAN");
})
$(document).on("click", "#groupPvNo", function (){	
	$("#groupPvYes").prop('checked', false);
	$("#groupPvCondition").val("0");
	$("#groupPvConditionComparator").val("LESS_THAN");
})

$(document).on("click", "#orderMoneyYes", function (){	
	$("#orderMoneyNo").prop('checked', false);
	$("#orderAmountCondition").val("0");
	$("#orderAmountConditionComparator").val("MORE_THAN");
})
$(document).on("click", "#orderMoneyNo", function (){	
	$("#orderMoneyYes").prop('checked', false);
	$("#orderAmountCondition").val("0");
	$("#orderAmountConditionComparator").val("LESS_THAN");
})

$(document).on("click", "#orderYes", function (){	
	$("#orderNo").prop('checked', false);
	$("#orderCountCondition").val("0");
	$("#orderCountConditionComparator").val("MORE_THAN");
})
$(document).on("click", "#orderNo", function (){	
	$("#orderYes").prop('checked', false);
	$("#orderCountCondition").val("0");
	$("#orderCountConditionComparator").val("LESS_THAN");
})

$(document).on("click", "#returnMoneyYes", function (){	
	$("#returnMoneyNo").prop('checked', false);
	$("#returnAmountCondition").val("0");
	$("#returnAmountConditionComparator").val("MORE_THAN");
})
$(document).on("click", "#returnMoneyNo", function (){	
	$("#returnMoneyYes").prop('checked', false);
	$("#returnAmountCondition").val("0");
	$("#returnAmountConditionComparator").val("LESS_THAN");
})

$(document).on("click", "#returnYes", function (){	
	$("#returnNo").prop('checked', false);
	$("#returnCountCondition").val("0");
	$("#returnCountConditionComparator").val("MORE_THAN");
})
$(document).on("click", "#returnNo", function (){	
	$("#returnYes").prop('checked', false);
	$("#returnCountCondition").val("0");
	$("#returnCountConditionComparator").val("LESS_THAN");
})

$(document).on("click", "#userSettingBtn_01", function(e){
	if($("#uiSeting_01").hasClass("on")){
		$("#uiSeting_01").removeClass("on");
	}else{
		$("#uiSeting_01").addClass("on");
	}
});

$(document).on("click", "#userSettingBtn_02", function(e){
	if($("#uiSeting_02").hasClass("on")){
		$("#uiSeting_02").removeClass("on");
	}else{
		$("#uiSeting_02").addClass("on");
	}
});

$(document).on("click", "#userSettingBtn_03", function(e){
	if($("#uiSeting_03").hasClass("on")){
		$("#uiSeting_03").removeClass("on");
	}else{
		$("#uiSeting_03").addClass("on");
	}
});

$(document).on("click", "#userSettingBtn_04", function(e){
	if($("#uiSeting_04").hasClass("on")){
		$("#uiSeting_04").removeClass("on");
	}else{
		$("#uiSeting_04").addClass("on");
	}
});

$(document).on("click", "#userSettingBtn_05", function(e){
	if($("#uiSeting_05").hasClass("on")){
		$("#uiSeting_05").removeClass("on");
	}else{
		$("#uiSeting_05").addClass("on");
	}
});

