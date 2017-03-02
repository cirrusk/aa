(function($) {
	var losmap;
	var losmapGrid
	var PTGrid;
	var isGrid;
	var isPT;
	var isPTloaded=false;
	var isPrev = false;
	var isPTPrev = false;
	var isPTDetail = false;
	var isSearchFromDB = true;
	var isSearchMode = false;

	$.losmapMain ={
			data : {
				url : "/_ui/desktop"
			  , currentMonth	: 0
//			  , ALERT_MSG_AUTH_PT 	: "해당 서비스는 PT 이상 이용하실 수 있습니다."
			  , ptList  : []
			  , ptSelectedId : ""
			  , losSearchAttributes : new Array("PV","BV","GROUP_PV", "GROUP_BV","ACHIEVE_RATE","NEXT_ACHIEVE_RATE")
			  , losSearchAttributesHidden :  new Array("currentPinCondition","highestPinCondition","currentAchieveRateCondition","goalAchieveRateCondition", "personalPvCondition", "groupPvCondition","orderAmountCondition", "orderCountCondition", "returnAmountCondition", "returnCountCondition")
			  , currentLosmapGridDatas : []
			  , searchNowAttributes : []
			  , searchResultUplines : []
			  , highestLevel : 0
			  , selectedABODetailPosition : 0
			  , searchedId : ""
				  
			},
			init : function(){
				isPT=false;
				$.losmapMain.setLosmapGrid();
				$.losmapMain.setLosmap();								
				$.losmapMain.setThisMonth($.losmapMain.data.currentMonth, false);
				$.losmapMain.showLosmap();

			},	
			initPT : function(){
				isPT=true;				
				$.losmapMain.setPTGrid();	
				$.losmapMain.showPT();
				

			},	
			setThisMonth : function(){
				$("#searchMonth").val($.losmapMain.data.currentMonth).attr("selected", "selected");
			},
			setLosmap : function(){
				losmap = new dhtmlXGridObject('losmap');
				losmap.setImagePath(IMAGE_RESOUCE_PATH + "/dhtmlx/");
				$.losCommon.setHeader(losmap ,false,712, 164, $.losmapMain.data.losSearchAttributes, $.losmapMain.data.losSearchAttributesHidden );
				
				losmap.setEditable(false);
				losmap.setFiltrationLevel(-2);
				losmap.setMultiselect(true);
				
				losmap.attachEvent("onOpenStart", $.losmapMain.loadDownLineProc);	

				losmap.init();
				losmap.enableAutoHeight(true);
				losmap.splitAt(1);
				losmap.setSkin("dhx_skyblue");
				losmap._delta_y =false;
				
				if($(".losViewModePk").text().length>0){					
					$.losmapMain.loadDownLine(null,0,$(".losViewModePk").text());
				}else{
					if(isSearchMode){
						$.losmapMain.searchText($.losmapMain.data.searchedId);
					}else{
						$.losmapMain.loadDownLine();
					}
					
				}

			},
			setLosmapGrid : function(){
				losmapGrid = new dhtmlXGridObject('losmapGrid');
				losmapGrid.setImagePath(IMAGE_RESOUCE_PATH + "/dhtmlx/");

				$.losCommon.setHeader(losmapGrid, true,712, 164, $.losmapMain.data.losSearchAttributes, $.losmapMain.data.losSearchAttributesHidden );
		
				losmapGrid.setEditable(false);
				losmapGrid.setFiltrationLevel(-2);
				losmapGrid.setMultiselect(true);

				losmapGrid.init();	
				losmapGrid.enableAutoHeight(true);
				losmapGrid.splitAt(1);
				losmapGrid.setSkin("dhx_skyblue");
				
			},
			setPTGrid : function(){
				PTGrid = new dhtmlXGridObject('PTGrid');
				PTGrid.setImagePath(IMAGE_RESOUCE_PATH + "/dhtmlx/");
				$.losCommon.setHeader(PTGrid, true,712, 192, ["그룹PV","그룹BV","그룹주문\n금액(수)","그룹주문\n회원수","그룹반품\n금액(수)","신규회원","탈퇴회원"], []);			
				
				PTGrid.setEditable(false);
				PTGrid.setFiltrationLevel(-2);
				PTGrid.setMultiselect(true);
				
				
				PTGrid.init();	
				PTGrid.enableAutoHeight(true);
				PTGrid.splitAt(1);
				PTGrid.setSkin("dhx_skyblue");
				
				$.losmapMain.loadPT();
			},	
			
			loadDownLine : function(id, mode, selectedPk){
				NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.losmapMain.loadDownLineProc(id, mode, selectedPk); });
			},
		
			loadDownLineProc : function(id, mode, selectedPk){
				if (!Array.indexOf) {
					  Array.prototype.indexOf = function (obj, start) {
					    for (var i = (start || 0); i < this.length; i++) {
					      if (this[i] == obj) {
					        return i;
					      }
					    }
					  }
					}
				
				if(isSearchFromDB && isSearchMode && mode < 1){
					
					if($.losmapMain.data.searchResultUplines.indexOf(id) >=0){
						$.losmapMain.data.searchResultUplines.splice($.losmapMain.data.searchResultUplines.indexOf(id),1);
						losmap.addRow(id +"-2", ["Loading..."],null,id,null);
						$("#noDataLosmap").addClass("hide");
						$.losCommon.callAjax("GET", "ajax/result", "json",  {"pk" : id , "isPrev" : isPrev, "selectedPk" :  selectedPk} , function(data){	
							var downLineData = data;
							for (var iLoop = 0; iLoop < downLineData.length; iLoop++) {		
								resultDataArray = $.losmapMain.getResultDataArray(downLineData[iLoop]);							
								if(losmap.getSubItems(id).indexOf(downLineData[iLoop].id)<0){
									losmap.addRow(downLineData[iLoop].id, resultDataArray,null,id,downLineData[iLoop].iconImage);						
									titleText = resultDataArray.shift();
									resultDataArray.unshift("<img src='/_ui/mobile/images/dhtmlx/dhxgrid_skyblue/tree/" +downLineData[iLoop].iconImage + "' align='left'>" +   titleText );							
									losmapGrid.addRow(downLineData[iLoop].id, resultDataArray);
									
									if(downLineData[iLoop].hasDownline){								
										losmap.addRow(downLineData[iLoop].id +"-1", ["Loading..."],null,downLineData[iLoop].id,null);
									}	
								}
							}

							losmap.deleteRow(id +"-2" );
							NetFunnel_Complete();
							return true;
						},function(err){
							NetFunnel_Complete();
							return false;
						});
					}
				}	
						
				if(id==null){
					losmap.addRow("-1", ["Loading..."],null,0,null);
					losmapGrid.addRow("-1", ["Loading..."]);
				}			
				if(mode > 0 || id !=null && !(losmap.getSubItems(id).indexOf(id+"-1")>-1)){
					return true;
				}else{
					$("#noDataLosmap").addClass("hide");
					$.losCommon.callAjax("GET", "ajax/result", "json",  {"pk" : id , "isPrev" : isPrev , "selectedPk" : selectedPk} , function(data){				
						
						var downLineData = data;
						var resultDataArray = new Array();
						var tempId;
						
						losmap.setColWidth(0,250 + $.losmapMain.data.highestLevel * 18);
						
						for (var iLoop = 0; iLoop < downLineData.length; iLoop++) {		
					
							var parentId;
							var gridIndex;
							
							if(id==null){								
								parentId = 0;
								losmap.deleteRow("-1");		
								losmapGrid.deleteRow("-1");
							}else{
								parentId = id;
								gridIndex = losmapGrid.getRowIndex(id) + iLoop +1;
							}			
							if(losmap.getLevel(id)>$.losmapMain.data.highestLevel){
								$.losmapMain.data.highestLevel = losmap.getLevel(id);
							}									
					
							resultDataArray = $.losmapMain.getResultDataArray(downLineData[iLoop]);
							losmap.addRow(downLineData[iLoop].id, resultDataArray,null,parentId,downLineData[iLoop].iconImage);								
							titleText = resultDataArray.shift();
							resultDataArray.unshift("<img src='/_ui/mobile/images/dhtmlx/dhxgrid_skyblue/tree/" +downLineData[iLoop].iconImage + "' align='left'>" +   titleText );
							losmapGrid.addRow(downLineData[iLoop].id, resultDataArray, gridIndex);
							var currentLosmapGridData = {key : downLineData[iLoop].id, value : resultDataArray};
							$.losmapMain.data.currentLosmapGridDatas.push( currentLosmapGridData );							
							
							if(downLineData[iLoop].hasDownline){								
								losmap.addRow(downLineData[iLoop].id +"-1", ["Loading..."],null,downLineData[iLoop].id,null);
							}	
							
							if(id==null){
								tempId = downLineData[iLoop].id;
							}else{								
								losmap.showRow(id);								
							}
							
							
							
						}
						losmap.deleteRow(id +"-1" );
						
						if(id==null){
							losmap.openItem(tempId);
							if(downLineData.length == 0){
								$("#noDataLosmap").removeClass("hide");
							}
						}
						
						
						NetFunnel_Complete();
					},function (err){
						NetFunnel_Complete();
						return false;
					});	
					
					
					return true;
				}
			},
			
			showSelectedUserLos : function(pk){
				
				$("#myLosBtn").removeClass("hide");
				$("#businessPage").show();
				$("#aboDetailPage").hide();
				$.losmapMain.showLosmap();
				$.losmapMain.data.selectedPk = pk;
				losmap.clearAll();
				losmapGrid.clearAll();
				$.losmapMain.loadDownLine(null,0,pk);
			},
			
			showMyLos : function(){
				$("#myLosBtn").addClass("hide");
				$(".selectedUserPk").val("");
				$.losmapMain.data.selectedPk = null;
				losmap.clearAll();
				losmapGrid.clearAll();
				$.losmapMain.loadDownLine();
			},
			
			loadPT : function(){
				NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.losmapMain.loadPTProc(); });
			},
			
			loadPTProc : function(){
				if(!isPTloaded){
					$("#noDataLosmap").addClass("hide");
					PTGrid.addRow("-1", ["Loading..."]);
					$.losCommon.callAjax("GET", "ajax/ptgroup", "json", { "isPrev" : isPTPrev } , function(data){				
						$("#noDataPT").addClass("hide");
						var downLineData = data;
						
						var tempId;
						
						$.losmapMain.data.ptList = [];
						$.ptDetailPopup.data.ptList = [];
						for (var iLoop = 0; iLoop < downLineData.length; iLoop++) {		
							
							var resultText = downLineData[iLoop].text;
							var resultDataArray = new Array();
						    var titleText = downLineData[iLoop].text;			
							var ptItem = {key : downLineData[iLoop].id, value : titleText};
							$.losmapMain.data.ptList.push( ptItem );
							
							titleText = $.losmapMain.getLinkedPTText(downLineData[iLoop].id, titleText);
							resultDataArray.push(titleText);
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].groupPV));
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].groupBV));
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].grpOrderAmt) + "(" + $.losCommon.numberWithCommas(downLineData[iLoop].grpOrderCount) + ")");
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].grpOrderDistCount));
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].grpReturnAmt) + "(" + $.losCommon.numberWithCommas(downLineData[iLoop].grpReturnCount) + ")" );
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].newApplicationCount));
							resultDataArray.push($.losCommon.numberWithCommas(downLineData[iLoop].deleteCount));
							titleText = resultDataArray.shift();
							resultDataArray.unshift("<img src='/_ui/mobile/images/dhtmlx/dhxgrid_skyblue/tree/" +downLineData[iLoop].iconImage + "' align='left'>" +   titleText );
							PTGrid.addRow(downLineData[iLoop].id,resultDataArray);						
						}
						PTGrid.deleteRow("-1" );
						isPTloaded=true
						if(downLineData.length==0){
							$("#noDataPT").removeClass("hide");
						}
						NetFunnel_Complete();
					},function (err){
						NetFunnel_Complete();
						return false;
					});		
				}
			},
			nanToNumber : function(number){
				if(isNaN(number)) { return  0; }
				return number;
			},
			searchText : function(searchText)  {
			
				if(isGrid){
					losmapGrid.clearSelection();
				} else{
					losmap.clearSelection();
				}
				
				if(searchText.length ==0){						
					return false;
				}
				
				if(isSearchFromDB){
					loadingLayerS();
					if(!$.losmapMain.isAlphabetNumCheck(searchText)){
						$.losmapMain.searchName(searchText);
						return false;
					}						

					$.losCommon.callAjax("GET", "ajax/search", "json", { "searchword" : searchText, "isPrev" : isPrev } , function(data){							
						
						$.losmapMain.data.searchResultUplines = [];
						if(data==null || data==""){
							alert($.getMsg($.msg.los.inquery.noSearchResult));
							loadingLayerSClose();
							return false;
						}
						isSearchMode = true;
						$.losmapMain.data.searchedId = searchText;
						
						losmap.clearAll();
						losmapGrid.clearAll();
						var downLineData = data;

						var parentId = 0;
						for (var iLoop = 0 ; iLoop <downLineData.length ; iLoop++) {
							if(iLoop==downLineData.length-1){
								resultDataArray = $.losmapMain.getResultDataArray(downLineData[iLoop]);
								losmap.addRow(downLineData[iLoop].id,resultDataArray,null,parentId, downLineData[iLoop].iconImage);	

								titleText = resultDataArray.shift();
								resultDataArray.unshift("<img src='/_ui/mobile/images/dhtmlx/dhxgrid_skyblue/tree/" +downLineData[iLoop].iconImage + "' align='left'>" +   titleText );

								losmapGrid.addRow(downLineData[iLoop].id, resultDataArray);

								losmap.openItem(downLineData[iLoop].id);

								if(downLineData[iLoop].hasDownline){								
									losmap.addRow(downLineData[iLoop].id +"-1", ["Loading..."],null,downLineData[iLoop].id,null);
								}	
							}else{
								
								losmap.addRow(downLineData[iLoop].id,downLineData[iLoop].text, null,parentId,downLineData[iLoop].iconImage);
								var titleText = "<img src='/_ui/mobile/images/dhtmlx/dhxgrid_skyblue/tree/" +downLineData[iLoop].iconImage + "' align='left'>" +  downLineData[iLoop].text;
								losmapGrid.addRow(downLineData[iLoop].id, titleText);
								parentId = downLineData[iLoop].id;
							}
						}
						for (var iLoop = 0 ; iLoop <downLineData.length -1 ; iLoop++) {
							$.losmapMain.data.searchResultUplines.push(downLineData[iLoop].id);
						}
						if(iLoop == downLineData.length-1){
							losmap.setColWidth(0,250 + losmap.getLevel(downLineData[iLoop].id) * 18);
						}
						loadingLayerSClose();
					},function(err){
						alert($.getMsg($.msg.los.inquery.noSearchResult));
						loadingLayerSClose();
						return false;
					});	

				}else {

					var searchResult = losmap.findCell(searchText, 0, false);

					for (i = 0; i < searchResult.length; i++) {
						var searchedItemId = searchResult[i][0];
						if(!(searchedItemId.indexOf("-1") > -1)){
							if(isGrid){							
								losmapGrid.selectRowById(searchedItemId, true);
							} else{
								losmap.openItem(losmap.getParentId(searchedItemId));
								losmap.selectRowById(searchedItemId, true);
							}
						}
					}
				}
			
			},
			
			searchName : function(searchText){
				NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.losmapMain.searchNameProc(searchText); });
			},
			
			searchNameProc : function(searchText){
				
				$.losCommon.callAjax("GET", "ajax/searchname", "json", { "searchword" : searchText } , function(data){
					
					if(data==null || data.length==0){
						alert($.getMsg($.msg.los.inquery.noSearchResult));
						loadingLayerSClose();
						NetFunnel_Complete();
						return false;
					}else if(data.length==1){
						$.losmapMain.searchText(data[0].id);		
						NetFunnel_Complete();
						return false;
					}else{
						$.losmapMain.showSearchNamePopup(data);
						loadingLayerSClose();
						isBreak = true;
						NetFunnel_Complete();
						return false;
					}								
				},function(err){
					alert($.getMsg($.msg.los.inquery.noSearchResult));
					loadingLayerSClose();
					NetFunnel_Complete();
					return false;
				});
			},
	
			getResultDataArray : function (data){
				resultDataArray = [];
				resultDataArray.push( $.losmapMain.getLinkedText(data.id, data.text));
				searchAttributes = $.losmapMain.data.losSearchAttributes;
				searchAttributesHidden = $.losmapMain.data.losSearchAttributesHidden;
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
						case "PERSONAL_ORDER" :
							resultDataArray.push($.losCommon.numberWithCommas(data.personalOrderAmt)+"("+$.losCommon.numberWithCommas(data.personalOrderCount) +")");
							break;
						case "PERSONAL_AMOUNT" :
							if(data.personalReturnCount =="0"){
								resultDataArray.push($.losCommon.numberWithCommas(data.personalReturnAmt)+"("+$.losCommon.numberWithCommas(data.personalReturnCount) +")");
							}else{
								resultDataArray.push($.losmapMain.getLinkedReturnText(data.id,$.losCommon.numberWithCommas(data.personalReturnAmt)+"("+$.losCommon.numberWithCommas(data.personalReturnCount) +")"));
							}
							break;
						case "ACHIEVE_RATE" :
							resultDataArray.push(data.currentPercent + "%");
							break;
						case "NEXT_ACHIEVE_RATE" :
							resultDataArray.push(data.nextPercent + "%");
							break;
						case  "GOAL_RATE" :
							if(isPrev){
								resultDataArray.push("-");
							}else{
								resultDataArray.push(data.aimPercent + "%");
							}							
							break;
						case  "DISTRICT" :
							resultDataArray.push(data.businessDistrict);
							break;
						case  "REGIST_DATE" :
							resultDataArray.push($.losCommon.getFormattedDate(new Date(data.registerDate)));
							break;
						case  "INTER_SPONSOR_YN" :
							resultDataArray.push(data.internationalSponsor);
							break;
						case  "PIN" :
							resultDataArray.push(data.currentPin);					
							break;
						case  "HIGHEST_PIN" :
							resultDataArray.push(data.highestPin);
							break;		
						case  "RENEWAL_TYPE" :
							resultDataArray.push(data.renewalYN);
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
			
			startSearch : function(searchCondition){
				$("#noDataLosmap").addClass("hide");
				$("#noDataPTDetail").addClass("hide");
				var columns =  $.losmapMain.data.losSearchAttributesHidden;
				var losSearchAttributesLength = 	$.losmapMain.data.losSearchAttributes.length;
				var searchValue;
				var searchCount = 0;
				var isPreserve = false;
				for(i=0; i<searchCondition.length ; i+=2){
					if(searchCondition[i]!=null && searchCondition[i].value != null && searchCondition[i].value != "" && searchCondition[i].value != "-1"){
						if(i==0){
							isPreserve = false;
						}else{
							isPreserve = true;
						}
						var columnIndex=0;
						columnIndex=columns.indexOf(searchCondition[i].name) + losSearchAttributesLength +1 ;
						if(columnIndex >0){
							searchValue = searchCondition[i].value
							$.losmapMain.doFilter(columnIndex, searchValue ,searchCondition[i+1].value,isPreserve);			
							if(isPTDetail){
								if($.ptDetailPopup.getLosmapRowsNum()==0){
									$("#noDataPTDetail").removeClass("hide");
								}
							}else{
								if(losmapGrid.getRowsNum()==0){
									$("#noDataLosmap").removeClass("hide");
								}
							}
							searchCount++;
						}
					}
				}
				if(searchCount==0){
					$.losmapMain.resetSearchCondition();
				}
			},
			doFilter : function(columnIndex ,searchValue ,moreLess, isPreserve){

				if(isPTDetail){
					$.ptDetailPopup.doFilter(columnIndex ,searchValue ,moreLess, isPreserve);
				}else {
					losmapGrid.filterBy(columnIndex,function(value){ 
						//console.log("columnIndex = " + columnIndex + ", searchValue = " + searchValue +", value = " + value + ", moreLess " + moreLess);
						
						value *=1;
						searchValue *=1;
						if(moreLess=="MORE_THAN"){
							return (value >= searchValue);
						}else {
							return (value <= searchValue);
						}
						
					},isPreserve)
				}
				
			},
			resetAttibutes : function(inqueryLists){				
				
				if(!isPTDetail){			
					
					$('#userSearchConditionSelectMain').val("-1").attr("selected", "selected");
					$.losmapMain.data.currentLosmapGridDatas = [];
					$.losmapMain.data.losSearchAttributes =inqueryLists ;
					$("#losmap").show();				
					$("#losmapGrid").show();				
					
					losmap.clearAll();
					losmapGrid.clearAll();
			
					$.losmapMain.setLosmap();	
					$.losmapMain.setLosmapGrid();
					if(isGrid){
						$("#losmapGrid").show();				
						$("#losmap").hide();	
						$("#tabTree").hide();
						$("#tabGrid").show();	
						$("#userSearch").show();
					}else{
						$("#losmap").show();				
						$("#losmapGrid").hide();
						$("#tabTree").show();
						$("#tabGrid").hide();
						$("#userSearch").hide();
					}					
				}else {
					$.ptDetailPopup.resetAttibutes(inqueryLists);
				}
			},
		
			getLinkedText : function (id, text){
				return "<a href='#' value="+text +"  onclick='$.losmapMain.openABODetailPopupPage("+ id +");return false;'>"+text+"</a>";				 
			},
			
			getLinkedPTText : function (id, text){
				return "<a href='#' value="+text +"  onclick='$.losmapMain.openPTDetail("+ id + ");return false;'>"+text+"</a>";				 
			},
		
			
			getLinkedReturnText : function (id, text){
				return "<a href value="+text +"  onclick='$.losmapMain.openReturnPopupPage("+ id + ");return false;'>"+text+"</a>";				 
			},
			
			showBusinessResult : function(){
				$("#btnCnt").remove();
				$("#businessPage").show();
				$("#aboDetailPage").hide();
				$('html, body').animate({
				      scrollTop:$.losmapMain.data.selectedABODetailPosition
				    }, 0);
				
			},

			openABODetailPopupPage : function(id) {
				$.losmapMain.data.selectedABODetailPosition = $(document).scrollTop();
				$.losCommon.callAjax("GET", "/business/losmap/popup/ajax/detail/", "html", { "pk" : id } , function(data){			
													
					$("#aboDetailPage").html(data);
					
					if($('.bizTblWrap .flickingArea').length){
						$('.bizTblWrap .flickingArea').each(function(){
							var colLength = $(this).find('.tblBiz thead th').length;
							var firstCW = $(this).find('.tblBiz thead th:first-child').width();
							var tableL = colLength-1;
							var thWidthL = 100;
							var thWidthS = 60;
							var tableW= (thWidthL*tableL)+firstCW;
							var tableWS= (thWidthS*tableL)+firstCW;

							$(this).find('.tblBiz').css({ 'width':tableW+'px'});
							$(this).find('.tblBiz thead th').css({ 'width':thWidthL+'px'});
							$(this).find('.tblBiz thead th:first-child').css({ 'width':(firstCW+1)+'px'});
							$(this).find('.tblBiz.month').css({ 'width':tableWS+'px'});
							$(this).find('.tblBiz.month thead th').css({ 'width':thWidthS+'px'});
							$(this).find('.tblBiz.month thead th:first-child').css({ 'width':(firstCW+1)+'px'});
						});
					}
					
					
					$("#businessPage").hide();
					$("#aboDetailPage").show();
					
				},function(err){
					return false;
				});
				
				//$.windowOpener(popupUrl, popupTitle);
			},		
			
			openPTDetail: function(id) {						
				$.losmapMain.data.ptSelectedId =id;
				isPTDetail = true;
				$.losmapMain.showPTDetail();				
				$.ptDetailPopup.showNewCondition();
				
			},		
			openReturnPopupPage : function(pk) {
				$("#inqueryConditionSelect option:eq(0)").attr("selected", "selected");
				window.location.href = '/business/losmap/popup/return?pk=' + pk;
				return false;
				//$.windowOpener(popupUrl, popupTitle);
			},
		
			
			showLosmapGrid : function() {				
				$("#losmapGrid").show();				
				$("#losmap").hide();	
				$("#tabTree").hide();
				$("#tabGrid").show();	
				$("#userSearch").show();
				isGrid = true;
				if(losmapGrid.getRowsNum()==0){
					$("#noDataLosmap").removeClass("hide");
				}else {
					$("#noDataLosmap").addClass("hide");
				}
			},
			
			showLosmap : function() {
				$("#losmap").show();				
				$("#losmapGrid").hide();
				$("#tabTree").show();
				$("#tabGrid").hide();
				$("#userSearch").hide();				
				isGrid = false;
				if(losmap.getRowsNum()==0){
					$("#noDataLosmap").removeClass("hide");
				}else {
					$("#noDataLosmap").addClass("hide");
				}
			},
			
			showPT : function(){
				$("#pbContent_pt").show();
				$("#pbContent_ptDetail").hide();				
			},
			
			showPTDetail : function(){
				$("#pbContent_pt").hide();
				$("#pbContent_ptDetail").show();
				$("#setPt01").prop('checked', true);	
				$("#setPt02").prop('checked', false);					
				$.ptDetailPopup.init();
			},

			changeToCurrentMonth : function() {
				if(isPT){
					PTGrid.clearAll();
					isPTPrev=false;
					isPTloaded = false;
					$.losmapMain.loadPT();
				}else{
					losmap.clearAll();
					losmapGrid.clearAll();
					isPrev=false;					
					if($(".losViewModePk").text().length>0){					
						$.losmapMain.loadDownLine(null,0,$(".losViewModePk").text());
					}else{
						if(isSearchMode){
							$.losmapMain.searchText($.losmapMain.data.searchedId);
						}else{
							$.losmapMain.loadDownLine();
						}
					}				
				}				
			},
			changeToPrevMonth : function() {
				if(isPT){
					PTGrid.clearAll();
					isPTPrev=true;
					isPTloaded = false;
					$.losmapMain.loadPT();	
				}else{
					losmap.clearAll();
					losmapGrid.clearAll();
					isPrev=true;
					if($(".losViewModePk").text().length>0){					
						$.losmapMain.loadDownLine(null,0,$(".losViewModePk").text());
					}else{
						if(isSearchMode){
							$.losmapMain.searchText($.losmapMain.data.searchedId);
						}else{
							$.losmapMain.loadDownLine();
						}
					}				
				}
			},
			refreshSeachCondition : function(html) {
				$("#searchConditionSelect").html(html);
			},
			resetSearchCondition : function() {		
				$("#noDataLosmap").addClass("hide");
				if(isPTDetail){
					$.ptDetailPopup.resetSearchCondition();
				}else {					
					var gridDatas = $.losmapMain.data.currentLosmapGridDatas;
					
					 if( gridDatas.length > 0){
						 losmapGrid.clearAll()
							for(i=0;i<gridDatas.length;i++){
								losmapGrid.addRow(gridDatas[i].key, gridDatas[i].value);
							}
						}
				}			
               
			},
			refreshSeachAttribute : function(html, title) {
				$("#inqueryConditionSelect").html(html);
				if(title != null){
					$('#inqueryConditionSelect').val(title).attr("selected", "selected");
				}
				
			},

			changeSetType : function() {	
				var id = $("#userSearchConditionSelectMain option:selected").val();
				$("#userSearchConditionSelectMain option").each(function(){
					if($(this).val()==="#$searchNowOptionAttribute"){
						$(this).remove();
					} 
				});
				if(id=="-1"){
					$("#userSearchText").val("");				
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
				var index = $("#inqueryConditionSelect option").index($("#inqueryConditionSelect option:selected"));
				var title = $("#inqueryConditionSelect option:selected").val();
				$("#inqueryConditionSelect option").each(function(){
					if($(this).val()==="#$searchNowOptionAttribute"){
						$(this).remove();
					} 
				});
				if(title == "#$searchNowOptionAttribute"){
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
			setDefaultAttribute : function(condition) {	
				var defaultArr;				
				if(condition == 'defaultRecord'){
					defaultArr = ["PV", "BV", "GROUP_PV", "GROUP_BV", "ACHIEVE_RATE", "NEXT_ACHIEVE_RATE"];
					
				}
				else if(condition == 'defaultAcheive'){
					defaultArr = ["GROUP_PV", "GROUP_BV", "Q_LEG", "ACHIEVE_RATE", "NEXT_ACHIEVE_RATE", "GOAL_RATE"];
					
				}
				else if(condition == 'defaultAboInfo'){
					defaultArr = ["DISTRICT", "REGIST_DATE", "INTER_SPONSOR_YN", "PIN", "HIGHEST_PIN"];
					
				}
				$.losmapMain.resetAttibutes(defaultArr);	
				
			},
			addSearchNowOption : function(){			
				if(isPTDetail){
					$("#ptDetailSearchAttributeSelect").append("<option value='#$searchNowOptionAttribute' selected >바로검색</option>");
				}else{
					$("#inqueryConditionSelect").append("<option value='#$searchNowOptionAttribute' selected >바로검색</option>");
				}
				
			},
			addSearchConditionSearchNowOption : function(){
				if(isPTDetail){
					$("#ptDetailSearchConditionSelect").append("<option value='#$searchNowOptionAttribute' selected >바로검색</option>");
				}else{
					$("#userSearchConditionSelectMain").append("<option value='#$searchNowOptionAttribute' selected >바로검색</option>");
				}				
			},
			showSearchNamePopup : function(data){
				var html;
				for(i=0;i<data.length;i++){
					html += "<tr>";
					html += "<td>" + data[i].id+ "</td>";
					html += "<td>" + data[i].name + "</td>";
					html += "<td>" + data[i].city + "</td>";
					html += "<td class='btn'><a href='#none' class='btnCont' onclick=$.losmapMain.searchIdFromName('"+data[i].id+"');><span>선택</span></a></td>";
					html += "<tr>";
			}
				$("#searchNamePopupList").html(html);
				var obj = $("#uiLayerPop_losResult_tag");
				layerPopupOpen(obj);
				
			},			
			searchIdFromName : function(id){
				$("#uiLayerPop_losResult .btnPopClose").click();
				$.losmapMain.searchText(id);
			},
			resetSearch : function(){
				$("#txtSrc").val("");
				if(isSearchMode){
					isSearchMode = false;
					$.losmapMain.data.searchedId = "";
					losmap.clearAll();
					losmapGrid.clearAll();
					$.losmapMain.loadDownLine();
				}
			},
			isAlphabetNumCheck : function(text){
				var filter = /^[A-Za-z0-9]{4,50}$/i;
				if(filter.test(text)){
					return true;
				}else{
					return false;
				}
			}	
	}	
})(jQuery);	

$(document).on("click", "#btnLosmapGrid", function (){
	$.losmapMain.showLosmapGrid();
})

$(document).on("click", "#btnLosmapTree", function (){
	$.losmapMain.showLosmap();
})

$(document).on("click", "#searchConditionBtn", function (){
	$.losmapMain.openSearchConditionPopupPage();
})

$(document).on("click", "#inqueryPopup", function(){
	var obj = $(this);
	$("#inqueryConditionSelect option[value='#$searchNowOptionAttribute']").remove();
	var param = {};
	$.ajax({
		type : "GET",
		url : "/business/losmap/popup/inquerycondition/",
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
	closeLayerPopup($($("#inqueryPopup").attr('href')));
});

$(document).on("click", "#searchPopup", function(){
	var obj = $(this);
	$("#userSearchConditionSelectMain option[value='#$searchNowOptionAttribute']").remove();
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
	closeLayerPopup($($("#searchPopup").attr('href')));
});



$(document).on("keypress", "#txtSrc", function (e){
	if (!e){
		e = window.event;
	}
	var keyCode = e.keyCode || e.which;
	if (keyCode == '13') {
		$.losmapMain.searchText($("#txtSrc").val());
		return false;
	}
})
$(document).on("click", "#searchBtn", function (){
	$.losmapMain.searchText($("#txtSrc").val());

})	

$(document).on("click", "#businessBtn", function (){	
	$.losmapMain.showBusinessResult();
})	

$(document).on("click", "#currentMonth", function (){	
	$.losmapMain.changeToCurrentMonth();
})	
$(document).on("click", "#prevMonth", function (){
	$.losmapMain.changeToPrevMonth();
})	

// 사용자 반품정보
$(document).on("click", "#userReturnPageBack", function(e){
	window.close();
});

$(document).on("click", "#userReturnPageBack", function(e){
	window.close();
});

$(document).on("change", "#userSearchConditionSelectMain", function (){
	$.losmapMain.changeSetType();
})

$(document).on("change", "#inqueryConditionSelect", function (){
	$.losmapMain.changeAttitudeSetType();
})	


$(document).on("click", "#uiSearchInit", function (){
	$.losmapMain.resetSearch();	
})	

$(document).on("click", "#showLosBtn", function(){
	$.losmapMain.showSelectedUserLos($(".selectedUserPk").text());
	return false;
});

$(document).on("click", "#myLosBtn", function(){
	$.losmapMain.showMyLos();
	return false;
});


