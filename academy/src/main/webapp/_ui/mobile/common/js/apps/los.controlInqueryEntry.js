(function($) {
	$.setInquery={
			data : {},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					success: function (data){
						if(data.result === "false"){
							alert(data.errorMessage);
							return;
						}else{
							successCallBack(data);
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
			
			resetItems : function(selectedItems){
				var searchYear = $("#deadlineResultSearchYear").val();
				var selectedUserPk = $(".selectedUserPk").text();
				var url = "/business/record/deadline/periodChange";
				var params	   = {}
				params.deadlineResultSearchYear = searchYear;
				params.searchNow = selectedItems;
				params.selectedPk = selectedUserPk;

				$.setInquery.callAjax('GET', url, 'html', params, function successCallBack(data){
					$("#deadlineResult_List").html(data);
					$("#deadlineResultSearchYear").val(searchYear);
					flickingAreaS();
					NetFunnel_Complete(); 
					$(window).trigger('resize');	
				},null);
				return false;
			},
			
			
			changeSetType : function(){
				var selectedOption = $("#inqueryList option:selected").text();
				var selOptionVal = $("#inqueryList option:selected").val();
				$("#titleText").val(selectedOption);
			},
			
			
			getChoicedList : function(){
				var idx = 0;
				var selectedItems ="";
				
				$("ol li > a").each(function(){			
					if($(this).hasClass("on")){
						var value=$(this).find("input").attr("value");
						selectedItems += value +"-";
					}
				});	
				return selectedItems;
			},

			
			setDefaultEntry : function(){
				$("#modifyArea").show();
				for(var j = 0; j < $("#selectItem").find("li input").length; j++){
					if($("#selectItem").find("li input")[j].value == "PV" ||
					   $("#selectItem").find("li input")[j].value == "BV" ||
					   $("#selectItem").find("li input")[j].value == "GROUP_PV"||
					   $("#selectItem").find("li input")[j].value == "GROUP_BV"||
					   $("#selectItem").find("li input")[j].value == "RUBY_PV"||
					   $("#selectItem").find("li input")[j].value == "RUBY_BV" )
					{
						$("#selectItem").find("a:eq(" + j + ")").addClass("on");
					}
					else
					{
						$("#selectItem").find("a:eq(" + j + ")").removeClass("on");
					}
				}
			},
			
			
			deselectAll : function(){
				$("#selectItem").find("a").attr("class", "btnChoose");	
				return false;
			},
			
			deleteSelectedItems : function(){
				deleteTitle = $("#inqueryList").val();
				$.setInquery.callAjax("GET", "/business/record/deadline/deleteInqueryEntry", "json", { "deleteTitle" :  deleteTitle }, 
						function successCallBack(data) {
							closeLayerPopup($($("#inqueryBtn").attr('href')));
							location.reload();
						}, null);			
			},
			
			modifySelectedItems : function(){
				var url = "/business/record/deadline/modifyInqueryEntry";
				var selectedItems = $.setInquery.getChoicedList();
				var sourceTitle =  $("#inqueryList").val();
				var newTitle = $("#titleText").val();
				var params	   = {};
				
				params.sourceTitle =sourceTitle;
				params.title =  newTitle;
				params.selectedItems = selectedItems;
				
				$("#myInqueryList option").each(function(){
					if($(this).val()==sourceTitle){
						$(this).remove();
					}
					if($(this).val()=="searchNow"){
						$(this).remove();
					} 
				});
				$("#inqueryList option").each(function(){
					if($(this).val()==sourceTitle){
						$(this).remove();
					}
				});
				
				$.setInquery.callAjax('GET', url, 'html', params, function successCallBack(data){
					$("#deadlineResult_List").html(data);
					$("#deadlineResultSearchYear option:eq(0)").attr("selected","selected");
					$("#myInqueryList").append( "<option value='" + newTitle+ "' selected>(개인)"+newTitle+"</option>");
					$("#inqueryList").append( "<option value='" + newTitle+ "' selected>"+newTitle+"</option>");
					flickingAreaS();
					$(window).trigger('resize');	
					NetFunnel_Complete(); 
					closeLayerPopup($($("#inqueryBtn").attr('href')));
				},null);	
			},
			
			saveNewEntry : function(){
				if($("#inqueryList option").size()>10){
					alert($.getMsg($.msg.los.inquery.listCountOver));
					return false;
				}
				
				var entryTitle = $("#titleText").val();
				var selectedItems = $.setInquery.getChoicedList();
				var params = {};
				if (entryTitle==""){
					alert($.getMsg($.msg.los.inquery.emptyEntryName));
					$("#titleText").focus();
					return false;
				}
				if (selectedItems==""){
					alert("조회항목을 선택하세요");
					return false;
				}
				var url = "/business/record/deadline/saveNewInqueryEntries";
				
				params.title = entryTitle;
				params.selectedItems = selectedItems;
				
				$("#myInqueryList option").each(function(){
					if($(this).val()=="searchNow"){
						$(this).remove();
					} 
				});
				
				$.setInquery.callAjax('GET', url, 'html', params, function successCallBack(data){
					$("#deadlineResult_List").html(data);
					$("#myInqueryList").append( "<option value='" + entryTitle+ "' selected>(개인)"+entryTitle+"</option>");
					$("#inqueryList").append( "<option value='" + entryTitle+ "'>"+entryTitle+"</option>");
					$("#deadlineResultSearchYear option:eq(0)").attr("selected","selected");
					flickingAreaS();
					$(window).trigger('resize');	
					NetFunnel_Complete();
					closeLayerPopup($($("#inqueryBtn").attr('href')));
				},null);
			},
			
			clickMobileItem : function(obj){
				if(obj.hasClass("on")){
					obj.removeClass("on");					
								
				}else{
					if($.setInquery.getSelectedItems().length>5){
						alert($.getMsg($.msg.los.inquery.attributeCountOver));
						return false;
					}					
					obj.addClass("on");					

				}
				return false;
			},
			
			//
			getSelectedItems : function (){
				var selectedItems = [];
				$("ol li > a").each(function()
				{			
					if($(this).hasClass("on")){
						selectedItems.push($(this).find("input").attr("value"));
					}
				});					
				return selectedItems;
			},
			
			//
			getNameFromCode : function(code){
				switch(code){
					case  "PV" :
						return "개인 PV";
					case  "BV" :
						return "개인 BV";
					case  "GROUP_PV" :
						return "그룹 PV";
					case  "GROUP_BV" :
						return "그룹 BV";
					case  "RUBY_PV" :
						return "루비 PV";
					case  "RUBY_BV" :
						return "루비 BV";
					case  "PAR_PV" :
						return "PAR PV";
					case  "VE_PV" :
						return "Ve 볼륨 PV";
					case  "VE_BV" :
						return "Ve 볼륨 BV"
				}
			},
			
			setSelectedEntry : function(){
				var selectedListName = $("#inqueryList option:selected").val();
				if (selectedListName == "default"){
					$.setInquery.setDefaultEntry();
				}
				else{
						var url = "/business/record/deadline/getItemsOfEntry"
						var params = {};
						params.title = selectedListName;
						
						$.ajax({
							type : "GET",
							url : "/business/record/deadline/getItemsOfEntry",
							dataType : "html",
							data : params,
							success : function(data) {
								var dataList = data.replace("[", '').replace("\"]", '').replace("\"",'').split('\",\"');
								
								$("#selectItem").find("a").attr("class", "btnChoose");
								for(var i=0;i<dataList.length; i++){
									var name = $.setInquery.getNameFromCode(dataList[i]);
									for(var j = 0; j < $("#selectItem").find("li input").length; j++){
										if($("#selectItem").find("li input")[j].value == dataList[i]){
											$("#selectItem").find("a:eq(" + j + ")").addClass("on");
										}
									}
								}
							},
							error : function() {
								alert($.msg.err.system);
							}
						});
				}
			}
			
	}
})(jQuery)


// [조회항목 설정 팝업] 신규설정 라디오버튼 선택
$(document).on("click", "#userSel02", function(){
	//기존설정 라디오버튼 체크해제
	$("#userSel01").prop('checked', false);
	
	//항목선택 초기화
	$.setInquery.deselectAll();
	
	var equalYN=0;
	var i =1;
	var num;
	while(equalYN==0){
		equalYN = 1;
		num = i+"";
		$("#inqueryList option").each(function(){
			if ($(this).text().indexOf("사용자 조회 항목명") === 0){
				if($(this).text().replace("사용자 조회 항목명","")===num){
					i++;
					equalYN = 0;
				}
			}
		});
	}
	// 하단 UI 변경
	$("#titleText").attr('readonly',false);
	$("#titleText").val($.getMsg($.msg.los.inquery.defaultName, num));
	$("#new").attr("class","btnWrapC");
	$("#new").show();
	$("#modifyArea").hide();
	$("#inqueryList").val("default").attr('selected', "selected");
	$("#inqueryList").attr('disabled', true);
});

//[조회항목 설정 팝업] 기존설정 라디오버튼 선택
$(document).on("click", "#userSel01", function(){
	//신규설정 라디오버튼 체크해제
	$("#userSel02").prop('checked', false);
	
	// 하단 UI 변경 
	$("#new").hide();
	$("#modifyArea").show();
	$("#inqueryList").attr('disabled', false);
	
	$.setInquery.changeSetType();
	$.setInquery.setDefaultEntry();
});

//[조회항목 설정 팝업] 기존설정항목 선택시 하단 UI 변경
$(document).on("change", "#inqueryList", function(){	
	$.setInquery.setSelectedEntry();
});

// [조회항목 설정 팝업] - 기존설정 항목명 선택 시 항목명 text box 값 insert
$(document).on("change", "#inqueryList", function(){
	$.setInquery.changeSetType();
});

//[조회항목 설정 팝업] 항목선택 이벤트
$(document).on("click", "ol li > a", function(){
	$.setInquery.clickMobileItem($(this));
});

//[조회항목 설정 팝업] 전체선택취소 버튼
$(document).on("click", "#btnDeselectAll", function(){
	$.setInquery.deselectAll();
});

//[조회항목 설정 팝업] 바로검색 버튼
$(document).on("click", "#searchTmpVal", function(){
	var selectedItems = $.setInquery.getChoicedList();
	if(selectedItems.length === 0)
	{
		alert($.getMsg($.msg.los.inquery.emptyAttribute2));
		return false;
	}
	NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.setInquery.resetItems(selectedItems); });
//	$.setInquery.resetItems(selectedItems);
	$("#myInqueryList").append( "<option value=\"searchNow\" selected>바로검색</option>");
	
	$("ol li > a").each(function(){
		$(this).removeClass("on");
	});
	closeLayerPopup($($("#inqueryBtn").attr('href')));
	return false;
});


//[조회항목 설정 팝업] 수정 버튼
$(document).on("click", "#modify", function(){
	var selectedItems = $.setInquery.getChoicedList();	
	if($("#titleText").val().length === 0){
		alert($.getMsg($.msg.common.inputDetail, "사용자 조회항목명을"));
		$("#titleText").focus();
		return false;
	}
	if(selectedItems ==""){
		alert($.getMsg($.msg.los.inquery.emptyAttribute));
		return false;
	}
	NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.setInquery.modifySelectedItems(); });
//	$.setInquery.modifySelectedItems();
	
	return false;
});

//[조회항목 설정 팝업] 저장 버튼
$(document).on("click", "#saveBtn, #setNewName", function(){
	text = $("#titleText").val();
	if(text == ""){
		alert($.getMsg($.msg.common.inputDetail, "사용자 조회항목명을"));
		return false;
	}
	if($.setInquery.getSelectedItems().length ==0){
		alert($.getMsg($.msg.los.inquery.emptyAttribute));
		return false;
	}
	var tmp = "";
	$("#inqueryList option").each(function(){
		if($(this).text() == text ){
			alert($.getMsg($.msg.los.inquery.sameName));
			tmp= "N";
		}
	});
	if(tmp == ""){
		NetFunnel_Action({action_id:NetFunnel_TS_ACTION_ID_INQUIRY, skin_id:NetFunnel_TS_SKIN_ID_ETC}, function(ev,ret){ $.setInquery.saveNewEntry(); });
//		$.setInquery.saveNewEntry();
	}
	return false;
});

//[조회항목 설정 팝업] 삭제 버튼
$(document).on("click", "#delete, #delBtn", function(){
	$.setInquery.changeSetType();
	var index = $("#inqueryList option").index($("#inqueryList option:selected"));
	if(index == 0){
		alert($.getMsg($.msg.los.inquery.defaultAttributeDelete));
		return false;
	}
	$.setInquery.deleteSelectedItems();
	return false;
});