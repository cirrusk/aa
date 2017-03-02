(function($) {
	var isPrev = false;
	var ptDetailLosmap;
	$.ptDetailPopup ={
			data : {
				url : "/_ui/desktop"
			  , currentMonth	: 0
			  , ptList : []
			  , ptSelectedId : ""
			  , losSearchAttributes : ["REGIST_DATE_NEW","PV","BV", "personalOrderAmt", "sponsor"]
	          , losSearchAttributesHidden : ["currentPinCondition","highestPinCondition","currentAchieveRateCondition","goalAchieveRateCondition", "personalPvCondition", "groupPvCondition","orderAmountCondition", "orderCountCondition", "returnAmountCondition", "returnCountCondition"]		
		      , newConditionAttributes : ["REGIST_DATE_NEW","PV","BV", "personalOrderAmt", "sponsor"]
		      , foreignerConditionAttributes : ["foreigner","visaContry","visaType", "expiredDate", "sponsor"]
			  , inactionConditionAttributes :  ["DISTRICT","REGIST_DATE","sponsor"]
			  , unpaidConditionAttributes : ["sponsor"]
			  , renewalConditionAttributes : ["renewal","renewalMethod","REGIST_DATE","sponsor"]
	 		  , travelConditionAttributes : ["travelNo","travelCurrentTP","travelTargetTP","travelPercent","sponsor"]
			  , defaultArr : ["PV", "BV", "GROUP_PV", "GROUP_BV", "ACHIEVE_RATE", "NEXT_ACHIEVE_RATE"]
			  , currentLosmapGridDatas : []
			  , newCountStatics : {}
			  , renwealCount : 0
			 
//			  , ALERT_MSG_AUTH_PT 	: "해당 서비스는 PT 이상 이용하실 수 있습니다."
			},
			init : function(){				
				$.ptDetailPopup.data.ptList = $.losmapMain.data.ptList;
				$.ptDetailPopup.data.ptSelectedId = $.losmapMain.data.ptSelectedId;
				$.ptDetailPopup.setPTList();
				$.ptDetailPopup.setPtDetailLosmap();				
				$.ptDetailPopup.setThisMonth($.ptDetailPopup.data.currentMonth, false);		
				
				$("#userCondition").addClass("hide");
				$("#defaultCondition").removeClass("hide");
			},			
			setThisMonth : function(){
				$("#searchMonth").val($.ptDetailPopup.data.currentMonth).attr("selected", "selected");
			},
			setPtDetailLosmap : function(){
				ptDetailLosmap = new dhtmlXGridObject('ptDetailLosmap');
				ptDetailLosmap.setImagePath(IMAGE_RESOUCE_PATH + "/dhtmlx/");
				$.losCommon.setHeader(ptDetailLosmap,true,695,154,$.ptDetailPopup.data.losSearchAttributes, $.ptDetailPopup.data.losSearchAttributesHidden)
				
				ptDetailLosmap.setEditable(false);
				ptDetailLosmap.setFiltrationLevel(-2);
				ptDetailLosmap.setMultiselect(true);					
				
				ptDetailLosmap.init();		
				ptDetailLosmap.enableAutoHeight(true);
				ptDetailLosmap.splitAt(1)
				ptDetailLosmap.setSkin("dhx_skyblue");
				

				$.ptDetailPopup.loadPTDetail();

			},
			setNewCountStatics : function (){
				var date = new Date();
				var currentMonth = date.getMonth() + 1;
				
				for(i=0;i<5;i++){
			    	 if( currentMonth ==0)
			    	 {
			    		 currentMonth = 12;
			    	  }   
			    	 
			    	 $.ptDetailPopup.data.newCountStatics[currentMonth] = 0; 
			    	 currentMonth = currentMonth -1;
				}		
			},
			
			loadPTDetail : function(){
				NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.ptDetailPopup.loadPTDetailProc(); });
			},
			
			
			loadPTDetailProc : function(){	
					loadingLayerS()
					ptDetailLosmap.clearAll();
					ptDetailLosmap.addRow("-1", ["Loading..."]);
					
					var id = $("#ptGroup option:selected" ).val();
					var type;
					if($("#setPt01").attr("checked")){
						type = $("#defaultSearchSetting").val();
					}else{
						type = "userOption"
					}
					
					$.losCommon.callAjax("GET", "popup/ptgroup/ajax/ptdetail","json", {"pk" : id, "type" : type, "isPrev" : isPrev  }, function(data){
						
						$("#noDataPTDetail").addClass("hide");
						var downLineData = data;
						if(type=="newOption"){							
							$.ptDetailPopup.setNewCountStatics();
						}else if(type == "renewalOption"){
							$.ptDetailPopup.data.renwealCount = 0;
						}
						var tempId;
						ptDetailLosmap.startFastOperations();
						for (var iLoop = 0; iLoop < downLineData.length; iLoop++) {		
							
							var resultText = downLineData[iLoop].text;
							var resultDataArray = new Array();
						    var titleText = downLineData[iLoop].text;								
							
						    resultDataArray = $.ptDetailPopup.getResultDataArray(downLineData[iLoop]);
							ptDetailLosmap.addRow(downLineData[iLoop].id,resultDataArray);			
							if(!$("#userSel").attr("checked")){
								var currentLosmapGridData = {key : downLineData[iLoop].id, value : resultDataArray};
								$.ptDetailPopup.data.currentLosmapGridDatas.push( currentLosmapGridData );
							}
						}
						ptDetailLosmap.stopFastOperations();
						if(type=="newOption"){
							$("#newCount").text(downLineData.length + "건");
							$.ptDetailPopup.setNewCountResult();
						}else if(type=="foreignerOption"){
							$("#foreignerCount").text("총 " + downLineData.length + "명");
							
							//비자만료일로 소팅
							ptDetailLosmap.sortRows(4);
						}else if(type=="inactionOption"){
							$("#inactionCount").text("총 " + downLineData.length + "명");
						}else if(type=="unpaidOption"){
							$("#unpaidCount").text(downLineData.length + "건");
						}else if(type=="renewalOption"){
							$("#renewalCount").text(downLineData.length + "건");
							var renewalPercent;
							if(downLineData.length==0){
								renewalPercent = 0;
							}else{
								renewalPercent = (downLineData.length - $.ptDetailPopup.data.renwealCount) * 100 / downLineData.length;
							}
							$("#renewalPercent").text(renewalPercent.toFixed(2) + "%" );				
						}else if(type=="travelOption"){
							$("#travelCount").text(downLineData.length + "건");
						}
						
						if($("#setPt02").attr("checked")){

							$("#userCount").text(downLineData.length + "건");
						}
						
						ptDetailLosmap.deleteRow("-1" );
						if(downLineData.length == 0){
							$("#noDataPTDetail").removeClass("hide");
						}						
						loadingLayerSClose();
						NetFunnel_Complete();
					},function(err){					
						loadingLayerSClose();
						NetFunnel_Complete();
						return false;
					});	

		
			},
			setNewCountResult : function(){
				var html = "";
				staticsMap = $.ptDetailPopup.data.newCountStatics;
				$.each(staticsMap, function(key,value){
					html += "<em>" + key + "월 :"+ "</em>" + value + "명";
				});
				$("#newCountStatics").html(html);
				
			},
			
			getResultDataArray : function (data){
				resultDataArray = [];
				resultDataArray.push("<img src='/_ui/mobile/images/dhtmlx/dhxgrid_skyblue/tree/" +data.iconImage + "' align='left'>" +   data.text );
				searchAttributes = $.ptDetailPopup.data.losSearchAttributes;
				searchAttributesHidden = $.ptDetailPopup.data.losSearchAttributesHidden;
				searchAttributesHiddenLength = searchAttributesHidden.length;

				for(i=0 ; i < searchAttributes.length ; i++){
					switch(searchAttributes[i]){
						case  "PV" :
							resultDataArray.push($.losCommon.numberWithCommas(data.privatePV));
							break;							
						case  "BV" :
							resultDataArray.push($.losCommon.numberWithCommas(data.privateBV));
							break;		
						case  "GROUP_PV" :
							resultDataArray.push($.losCommon.numberWithCommas(data.groupPV));
							break;
						case  "GROUP_BV" :
							resultDataArray.push($.losCommon.numberWithCommas(data.groupBV));
							break;
						case  "Q_LEG" :
							resultDataArray.push($.losCommon.numberWithCommas(data.qlegs));
							break;
						case "personalOrderAmt" :
							resultDataArray.push($.losCommon.numberWithCommas(data.personalOrderAmt));
							break;
						case "PERSONAL_ORDER" :
							resultDataArray.push($.losCommon.numberWithCommas(data.personalOrderAmt));
							break;
						case "PERSONAL_AMOUNT" :
							resultDataArray.push($.losCommon.numberWithCommas(data.personalReturnAmt)+"("+$.losCommon.numberWithCommas(data.personalReturnCount) +")");
							break;
						case "ACHIEVE_RATE" :
							resultDataArray.push(data.currentPercent + "%");
							break;
						case "NEXT_ACHIEVE_RATE" :
							resultDataArray.push(data.nextPercent + "%");
							break;
						case  "GOAL_RATE" :
							resultDataArray.push(data.aimPercent + "%");
							break;
						case  "REGIST_DATE" :
							var date = new Date(data.customer.registerDate);
							resultDataArray.push($.losCommon.getFormattedDate(date));
							break;		
						case  "REGIST_DATE_NEW" :
							var date = new Date(data.customer.registerDate);
							resultDataArray.push($.losCommon.getFormattedDate(date));
							var count = $.ptDetailPopup.data.newCountStatics[date.getMonth() +1];
							count ++;
							$.ptDetailPopup.data.newCountStatics[date.getMonth() +1] =count;
							break;
						case  "INTER_SPONSOR_YN" :
							resultDataArray.push(data.internationalSponsor);
							break;
						case  "PIN" :
							resultDataArray.push(data.customer.userGroup.uid);					
							break;
						case  "HIGHEST_PIN" :
							if(data.customer.highestAchieve!=null){
								resultDataArray.push(data.customer.highestAchieve.uid);
							}else{
								resultDataArray.push("");
							}
							break;
						case  "foreigner" :
							if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner && data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){
								resultDataArray.push("주/부사업자");								
							} else if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner){
								resultDataArray.push("주사업자");
							} else if(data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){
								resultDataArray.push("부사업자");
							} else {
								resultDataArray.push("");
							}
							break;
						case  "visaContry" :
							if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner && data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){
								if(data.customer.additionalCustomerInfo.amwayCountry != null && data.customer.partnerInfo.amwayCountry!=null ){
									resultDataArray.push(data.customer.additionalCustomerInfo.amwayCountry + "/" + data.customer.partnerInfo.amwayCountry);
								}else{
									resultDataArray.push("");
								}																
							} else if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner){
								if(data.customer.additionalCustomerInfo.amwayCountry!=null){
									resultDataArray.push(data.customer.additionalCustomerInfo.amwayCountry);
								}else{
									resultDataArray.push("");
								}								
							} else if(data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){
								if(data.customer.partnerInfo.amwayCountry!=null){
									resultDataArray.push(data.customer.partnerInfo.amwayCountry);
								}else{
									resultDataArray.push("");
								}
								
							} else {
								resultDataArray.push("");
							}						
							break;
						case  "visaType" :
							if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner && data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){								
								if(data.customer.additionalCustomerInfo.visaTypeName!=null && data.customer.partnerInfo.visaTypeName!=null){
									resultDataArray.push(data.customer.additionalCustomerInfo.visaTypeName + "비자"+ "/" + data.customer.partnerInfo.visaTypeName + "비자");								
								}else{
									resultDataArray.push("");
								}							
							} else if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner){
								if(data.customer.additionalCustomerInfo.visaTypeName != null){
									resultDataArray.push(data.customer.additionalCustomerInfo.visaTypeName + "비자");
								}else{
									resultDataArray.push("");
								}							
							} else if(data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){
								if(data.customer.partnerInfo.visaTypeName!=null){
									resultDataArray.push(data.customer.partnerInfo.visaTypeName + "비자");
								}else{
									resultDataArray.push("");
								}								
							} else {
								resultDataArray.push("");
							}
							break;
						case  "expiredDate" :
							if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner && data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){								
								if(data.customer.additionalCustomerInfo.visaExpireDate!=null && data.customer.partnerInfo.visaExpireDate!=null){
									var visaExpiredDate =  new Date(data.customer.additionalCustomerInfo.visaExpireDate);
									var partnerVisaExpiredDate = new Date(data.customer.partnerInfo.visaExpireDate);
									resultDataArray.push($.losCommon.getFormattedDate(visaExpiredDate)+ "/" + $.losCommon.getFormattedDate( partnerVisaExpiredDate));								
								}else{
									resultDataArray.push("");
								}							
							} else if(data.customer.additionalCustomerInfo!=null&&data.customer.additionalCustomerInfo.foreigner){
								if(data.customer.additionalCustomerInfo.visaExpireDate != null){
									resultDataArray.push($.losCommon.getFormattedDate( new Date(data.customer.additionalCustomerInfo.visaExpireDate)));
								}else{
									resultDataArray.push("");
								}							
							} else if(data.customer.partnerInfo != null && data.customer.partnerInfo.foreigner){
								if(data.customer.partnerInfo.visaExpireDate!=null){
									resultDataArray.push($.losCommon.getFormattedDate( new Date(data.customer.partnerInfo.visaExpireDate)));
								}else{
									resultDataArray.push("");
								}								
							} else {
								resultDataArray.push("");
							}			
							break;
						case  "DISTRICT" :
							resultDataArray.push(data.customer.businessDistrict);
							break;
						case  "renewal" :
							if(data.renewalData !=null){
								resultDataArray.push(data.renewalData.renewalFlag);
								if(data.renewalData.renewalFlag == "Y"){
									$.ptDetailPopup.data.renwealCount++;
								}								
							}else {
								resultDataArray.push("");
							}

							break;
						case  "renewalMethod" :
							if(data.renewalData !=null){
								var method = data.renewalData.renewalMethod;
								if(method == "ABN"){
									resultDataArray.push("online");
								}else if (method == "ETC"){
									resultDataArray.push("AP/기타");
								}else if (method != ""){
									resultDataArray.push("자동갱신");
								}else {
									resultDataArray.push("");
								}
							}else {
								resultDataArray.push("");
							}
							break;
						case  "sponsor" :
							sponsor = data.customer.sponser;
							if(sponsor != null){
								resultDataArray.push(sponsor.name + "(" + sponsor.uid + ")");
							}else {
								resultDataArray.push("");
							}
							break;
						case  "travelNo" :							
							if(data.travelData  != null){
								resultDataArray.push($.losCommon.numberWithCommas(data.travelData.travelNo));
							}else {
								resultDataArray.push("");
							}
							break;		
						case  "travelCurrentTP" :							
							if(data.travelData  != null){
								resultDataArray.push($.losCommon.numberWithCommas(data.travelData.currentTp));
							}else {
								resultDataArray.push("");
							}
							break;		
						case  "travelTargetTP" :							
							if(data.travelData  != null){
								resultDataArray.push($.losCommon.numberWithCommas(data.travelData.targetTp));
							}else {
								resultDataArray.push("");
							}
							break;	
						case  "travelPercent" :							
							if(data.travelData  != null){
								resultDataArray.push(Math.round(data.travelData.currentTp * 1000 / data.travelData.targetTp)/10 + "%");
							}else {
								resultDataArray.push("");
							}
							break;		
							
					}					
						
				}
				for(i=0 ; i < searchAttributesHidden.length ; i++){
					switch(searchAttributesHidden[i]){
						case  "currentPinCondition" :
							resultDataArray.push(data.currentPinGrade);					
							break;
						case  "highestPinCondition" :
							resultDataArray.push(data.highestPinGrade);
							break;
						case "currentAchieveRateCondition" :
							resultDataArray.push(data.currentPercent);
							break;
						case  "goalAchieveRateCondition" :
							resultDataArray.push(data.aimPercent);
							break;
						case  "personalPvCondition" :
							resultDataArray.push(data.privatePV);
							break;							
						case  "groupPvCondition" :
							resultDataArray.push(data.groupPV);
							break;
						case "orderAmountCondition" :
							resultDataArray.push(data.personalOrderAmt);
							break;
						case "orderCountCondition" :
							resultDataArray.push(data.personalOrderCount);
							break;
						case "returnAmountCondition" :
							resultDataArray.push(data.personalReturnAmt);
							break;
						case "returnCountCondition" :
							resultDataArray.push(data.personalReturnCount);
							break;
					}
					
				}
				return resultDataArray;
			},
			
				
			setPTList : function(){
				var html = "";
				for(i=0; i<$.ptDetailPopup.data.ptList.length;i++){

					html += "<option value='" + $.ptDetailPopup.data.ptList[i].key + "' >" +$.ptDetailPopup.data.ptList[i].value + "</option>";
					
				}
				$("#ptGroup").append(html);
				selectedID =$.ptDetailPopup.data.ptSelectedId;
				$('#ptGroup option[value=' + selectedID +"]").attr('selected','selected');			
			},
			resetAttibutes : function(inqueryLists){
				$('#ptDetailSearchConditionSelect').val("-1").attr("selected", "selected");				
				$.ptDetailPopup.data.currentLosmapGridDatas = [];
				$.ptDetailPopup.data.losSearchAttributes =inqueryLists ;
				ptDetailLosmap.clearAll();
				$.ptDetailPopup.setPtDetailLosmap();					
			},	
			doFilter : function(columnIndex ,searchValue ,moreLess, isPreserve){

					ptDetailLosmap.filterBy(columnIndex,function(value){ 
						//console.log("columnIndex = " + columnIndex + ", searchValue = " + searchValue +", value = " + value + ", moreLess " + moreLess);
						
						value *=1;
						searchValue *=1;
						if(moreLess=="MORE_THAN"){
							return (value >= searchValue);
						}else {
							return (value <= searchValue);
						}						
					}, isPreserve)			
				
			},
			resetSearchCondition : function() {				
				$("#noDataPTDetail").addClass("hide");
					var gridDatas = $.ptDetailPopup.data.currentLosmapGridDatas;
					
					 if( gridDatas.length > 0){
						 ptDetailLosmap.clearAll()
							for(i=0;i<gridDatas.length;i++){
								ptDetailLosmap.addRow(gridDatas[i].key, gridDatas[i].value);
							}
						}
				
               
			},
			
			changeConditionSetType : function() {	
				var id = $("#ptDetailSearchConditionSelect option:selected").val();
				$("#ptDetailSearchConditionSelect option").each(function(){
					if($(this).val()==="#$searchNowOptionAttribute"){
						$(this).remove();
					} 
				});
				if(id=="-1"){							
					$.losmapMain.resetSearchCondition();
					return false;
				}else{
					$.losCommon.callAjax("GET", "/business/losmap/popup/searchcondition/ajax/getItem", "json", { "id" :  id }, 
							function successCallBack(data) {
								searConditionData = [];
								searConditionData.push({name: "currentPinCondition", value : data.currentPinCondition});
								searConditionData.push({name: "currentPinConditionComparator", value : data.currentPinConditionComparator});
								searConditionData.push({name: "highestPinCondition", value : data.highestPinCondition});
								searConditionData.push({name: "highestPinConditionComparator", value : data.highestPinConditionComparator});
								searConditionData.push({name: "currentAchieveRateCondition", value : data.currentAchieveRateCondition});
								searConditionData.push({name: "currentAchieveRateConditionComparator", value : data.currentAchieveRateConditionComparator});
								searConditionData.push({name: "goalAchieveRateCondition", value : data.goalAchieveRateCondition});
								searConditionData.push({name: "goalAchieveRateConditionComparator", value : data.goalAchieveRateConditionComparator});
								searConditionData.push({name: "personalPvCondition", value : data.personalPvCondition});
								searConditionData.push({name: "personalPvConditionComparator", value : data.personalPvConditionComparator});
								searConditionData.push({name: "groupPvCondition", value : data.groupPvCondition});
								searConditionData.push({name: "groupPvConditionComparator", value : data.groupPvConditionComparator});
								searConditionData.push({name: "orderAmountCondition", value : data.orderAmountCondition});
								searConditionData.push({name: "orderAmountConditionComparator", value : data.orderAmountConditionComparator});
								searConditionData.push({name: "orderCountCondition", value : data.orderCountCondition});
								searConditionData.push({name: "orderCountConditionComparator", value : data.orderCountConditionComparator});
								searConditionData.push({name: "returnAmountCondition", value : data.returnAmountCondition});
								searConditionData.push({name: "returnAmountConditionComparator", value : data.returnAmountConditionComparator});
								searConditionData.push({name: "returnCountCondition", value : data.returnCountCondition});
								searConditionData.push({name: "returnCountConditionComparator", value : data.returnCountConditionComparator});
													
								$.losmapMain.startSearch(searConditionData);
								
							}, null);
					
				}	
			},	
			
			changeAttitudeSetType : function() {	
				var index = $("#ptDetailSearchAttributeSelect option").index($("#ptDetailSearchAttributeSelect option:selected"));
				var title = $("#ptDetailSearchAttributeSelect option:selected").val();
				$("#ptDetailSearchAttributeSelect option").each(function(){
					if($(this).val()==="#$searchNowOptionAttribute"){
						$(this).remove();
					} 
				});
				if(title=="#ptDetailSearchAttributeSelect"){
					$.losmapMain.resetAttibutes($.losmapMain.data.searchNowAttributes);		
					return false;
				}
				if(index<3){
					$.losmapMain.setDefaultAttribute(title);
				}else{
					$.losCommon.callAjax("GET", "/business/losmap/popup/inquerycondition/ajax/getItem", "json", { "title" :  title}, 
							function successCallBack(data) {
								attributeList = data.entries;
								var attributeArray = [];
								for(i=0;i<attributeList.length;i++){
									attributeArray.push(attributeList[i].code);
								}
								$.losmapMain.resetAttibutes(attributeArray);								
							}, null);
					
				}				
			},
			showNewCondition : function(){				
				$("#newCondition").removeClass("hide");
				$("#foreignerCondition").addClass("hide");
				$("#inactionCondition").addClass("hide");
				$("#renewalCondition").addClass("hide");
				$("#unpaidCondition").addClass("hide");
				$("#travelCondition").addClass("hide");
			},		
			showForeignerCondition : function(){				
				$("#newCondition").addClass("hide");
				$("#foreignerCondition").removeClass("hide");
				$("#inactionCondition").addClass("hide");
				$("#renewalCondition").addClass("hide");
				$("#unpaidCondition").addClass("hide");
				$("#travelCondition").addClass("hide");
			},
			showInactionCondition : function(){
				$("#newCondition").addClass("hide");
				$("#foreignerCondition").addClass("hide");
				$("#inactionCondition").removeClass("hide");
				$("#renewalCondition").addClass("hide");
				$("#unpaidCondition").addClass("hide");
				$("#travelCondition").addClass("hide");
			},
			showRenewalCondition : function(){
				$("#newCondition").addClass("hide");
				$("#foreignerCondition").addClass("hide");
				$("#inactionCondition").addClass("hide");
				$("#renewalCondition").removeClass("hide");
				$("#unpaidCondition").addClass("hide");
				$("#travelCondition").addClass("hide");
			},
			showUnpaidCondition : function(){
				$("#newCondition").addClass("hide");
				$("#foreignerCondition").addClass("hide");
				$("#inactionCondition").addClass("hide");
				$("#renewalCondition").addClass("hide");
				$("#unpaidCondition").removeClass("hide");
				$("#travelCondition").addClass("hide");
			},
			showTravelCondition : function(){

				$("#newCondition").addClass("hide");
				$("#foreignerCondition").addClass("hide");
				$("#inactionCondition").addClass("hide");
				$("#renewalCondition").addClass("hide");
				$("#unpaidCondition").addClass("hide");
				$("#travelCondition").removeClass("hide");
			},
			showUserCondition : function(){
				$.ptDetailPopup.resetAttibutes($.ptDetailPopup.data.defaultArr);
				$("#userCondition").removeClass("hide");
				$("#defaultCondition").addClass("hide");
			},
			showDefaultCondition : function(){
				var optionVal =$("#defaultSearchSetting").val();
				var inqueryList;
				if(optionVal=="newOption"){
					$.ptDetailPopup.showNewCondition();
					inqueryList = $.ptDetailPopup.data.newConditionAttributes;
				} else if(optionVal=="foreignerOption"){
					$.ptDetailPopup.showForeignerCondition();
					inqueryList = $.ptDetailPopup.data.foreignerConditionAttributes;
				} else if(optionVal=="inactionOption"){
					$.ptDetailPopup.showInactionCondition();
					inqueryList = $.ptDetailPopup.data.inactionConditionAttributes;
				} else if(optionVal=="renewalOption"){
					$.ptDetailPopup.showRenewalCondition();
					inqueryList = $.ptDetailPopup.data.renewalConditionAttributes;
				} else if(optionVal=="unpaidOption"){
					$.ptDetailPopup.showUnpaidCondition();
					inqueryList = $.ptDetailPopup.data.unpaidConditionAttributes;
				} else if(optionVal=="travelOption"){
					$.ptDetailPopup.showTravelCondition();
					inqueryList = $.ptDetailPopup.data.travelConditionAttributes;
				}	
				$.ptDetailPopup.data.losSearchAttributes = inqueryList;
				$.ptDetailPopup.resetAttibutes($.ptDetailPopup.data.losSearchAttributes);
				$("#userCondition").addClass("hide");
				$("#defaultCondition").removeClass("hide");
			},
			
			openUnpaidPopupPage : function() {				
				var popupUrl = "/business/losmap/popup/unpaidpopup";
				//[팝업]미지급 보너스 상세 안내
				var popupTitle = "";
			    var popupOption = "width=772, height=630, scrollbars=yes, menubar=no, status=no, resizale=no";
			    
				$.windowOpener(popupUrl, popupTitle, popupOption);
			},
			changePT : function(){
				selectedValue = $("#ptGroup option:selected").val();
				ptDetailLosmap.clearAll();
				var type;
				if($("#userSel").attr("checked")){
					type = $("#defaultSearchSetting").val();
				}
				$.ptDetailPopup.loadPTDetail();
				
			},
			setCurrentMonth : function(){
				isPrev = false;			
				$.ptDetailPopup.loadPTDetail();
				
			},
			setPrevMonth : function(){
				isPrev = true;			
				$.ptDetailPopup.loadPTDetail();
				
			},
			getLosmapRowsNum : function(){
				if(ptDetailLosmap==null){
					return 0;
				}else{
					return ptDetailLosmap.getRowsNum();
				}				
			}
			
	}	
})(jQuery);	

$(document).on("change", "#defaultSearchSetting", function (){
	var optionVal =$("#defaultSearchSetting").val();
	var inqueryList;
	if(optionVal=="newOption"){
		$.ptDetailPopup.showNewCondition();
		inqueryList = $.ptDetailPopup.data.newConditionAttributes;
	} else if(optionVal=="foreignerOption"){
		$.ptDetailPopup.showForeignerCondition();
		inqueryList = $.ptDetailPopup.data.foreignerConditionAttributes;
	} else if(optionVal=="inactionOption"){
		$.ptDetailPopup.showInactionCondition();
		inqueryList = $.ptDetailPopup.data.inactionConditionAttributes;
	} else if(optionVal=="renewalOption"){
		$.ptDetailPopup.showRenewalCondition();
		inqueryList = $.ptDetailPopup.data.renewalConditionAttributes;
	} else if(optionVal=="unpaidOption"){
		$.ptDetailPopup.showUnpaidCondition();
		inqueryList = $.ptDetailPopup.data.unpaidConditionAttributes;
	} else if(optionVal=="travelOption"){
		$.ptDetailPopup.showTravelCondition();
		inqueryList = $.ptDetailPopup.data.travelConditionAttributes;
	}	
	$.ptDetailPopup.resetAttibutes(inqueryList);
})	

$(document).on("change", "#userSearchSetting", function (){
	$.ptDetailPopup.showUserCondition();	
})	

$(document).on("click", "#unpaidPopup", function (){
	layerPopupOpen($(this))
	return false;
})

//기본설정 라디오버튼 선택
$(document).on("click", "#setPt01", function(){
	$("#setPt02").prop('checked', false);	
	$.ptDetailPopup.showDefaultCondition();
	$("#ptDetailSearchConditionSelect").attr("disabled",true);
	$("#ptDetailSearchAttributeSelect").attr("disabled",true);
	$("#ptDetailMonth").addClass("hide");	

});

//나의설정 라디오버튼 선택
$(document).on("click", "#setPt02", function(){
	$("#setPt01").prop('checked', false);	
	$.ptDetailPopup.showUserCondition();
	$("#ptDetailSearchConditionSelect").attr("disabled",false);
	$("#ptDetailSearchAttributeSelect").attr("disabled",false);	
	$("#ptDetailMonth").removeClass("hide");	
	
});

//이번버튼 클릭
$(document).on("click", "#ptBackBtn", function(){
	$.losmapMain.showPT();
});

// 조회항목 설정 레이어팝업
$(document).on("click", "#ptGroupDetailInqueryPopup", function(){
	var obj = $(this);
	$("#ptDetailSearchAttributeSelect option[value='#$searchNowOptionAttribute']").remove();
	var param = {};
	$.ajax({
		type : "GET",
		url : "/business/ptgroup/popup/inquerycondition/",
		dataType : "html",
		data : param,
		success : function(data) {
			$("#uiLayerPop_losInquery").html(data);
			$.setInquery.init();
			layerPopupOpen(obj);
		},
		error : function() {
			alert($.msg.err.system);
		}
	});
	
	return false;
});



$(document).on("click", "#inqueryPopupClose", function(){
	closeLayerPopup($($("#ptGroupDetailInqueryPopup").attr('href')));
});

$(document).on("click", "#ptGroupDetailSearchPopup", function(){
	var obj = $(this);
	$("#ptDetailSearchConditionSelect option[value='#$searchNowOptionAttribute']").remove();
	var param = {};
	$.ajax({
		type : "GET",
		url : "/business/losmap/popup/searchcondition/",
		dataType : "html",
		data : param,
		success : function(data) {
			$("#uiLayerPop_losSearch").html(data);
			layerPopupOpen(obj);
		},
		error : function() {
			alert($.msg.err.system);
		}
	});

	return false;
});

$(document).on("click", "#searchPopupClose", function(){
	closeLayerPopup($($("#ptGroupDetailSearchPopup").attr('href')));
});

$(document).on("change", "#ptGroup", function (){
	$.ptDetailPopup.changePT();
})	

$(document).on("click", "#ptDetailCurrentMonth", function (){
	$.ptDetailPopup.setCurrentMonth();	
})	

$(document).on("click", "#ptDetailPrevMonth", function (){
	$.ptDetailPopup.setPrevMonth();	
})	

$(document).on("change", "#ptDetailSearchConditionSelect", function (){
	$.ptDetailPopup.changeConditionSetType();
})	

$(document).on("change", "#ptDetailSearchAttributeSelect", function (){
	$.ptDetailPopup.changeAttitudeSetType();
})	

