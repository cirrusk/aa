(function($) {	

	$.setInquery={
			init : function(){
				$('#inqueryList option:eq(0)').prop('selected', true);
				$.setInquery.setSelectedEntry();
			},
			
			setItemsForInquery : function() {
				$("#items_list option:selected").each(function(){
					var choicedLi = $(this).val();
					var choiceName = $(this).text();
					
					if($("#choiced_list option").size() > 5){
						alert($.getMsg($.msg.los.inquery.attributeCountOver));
						return false;				
					}
					$(this).hide();
					$(this).removeAttr("selected");
					$("#choiced_list").append("<option value='"+choicedLi+ "' name=" + choicedLi+">"+choiceName+"</option>");
				})
			},
			
			delItemsForInquery : function() {
				$("#choiced_list option:selected").each(function(){
					var choicedLi = $(this).val();
					var choiceName = $(this).text();
					$(this).remove();

					$("#items_list option").each(function(){
						if($(this).val() == choicedLi){
							$(this).show();
						}
					})
				})
			},
			
			cngIdxItemsForInquery : function(dir, index) {
				var targetIdx = null;
				if(dir=="u"){
					targetIdx = index -1 ;
				}
				if(dir=="d"){
					targetIdx = index+1;
				}
				
				var selected_val = $("#choiced_list option:eq("+index+")").val();
				var selected_name =$("#choiced_list option:eq("+index+")").text();
				var target_val =  $("#choiced_list option:eq("+targetIdx+")").val();
				var target_name =$("#choiced_list option:eq("+targetIdx+")").text();
				
				$("#choiced_list option:eq("+index+")").val(target_val);
				$("#choiced_list option:eq("+index+")").text(target_name);
				$("#choiced_list option:eq("+index+")").attr("index",targetIdx);
				$("#choiced_list option:eq("+index+")").removeAttr("selected");
				$("#choiced_list option:eq("+targetIdx+")").val(selected_val);
				$("#choiced_list option:eq("+targetIdx+")").text(selected_name);
				$("#choiced_list option:eq("+targetIdx+")").attr("index",index);
				$("#choiced_list option:eq("+targetIdx+")").attr("selected","true");
			},
			
			resetItems : function(cnghtml){
				$("tr#head").html(cnghtml);
			},
			
			resetDatas : function(colOrder){
				var colArray = colOrder;
				$("th#col1").attr("id",colArray[0].val());
				$("th#col2").attr("id",colArray[1].val());
				$("th#col3").attr("id",colArray[2].val());
				$("th#col4").attr("id",colArray[3].val());
				$("th#col5").attr("id",colArray[4].val());
				$("th#col6").attr("id",colArray[5].val());
			},
			
			setNewId : function(idx, value, name){
				var colNum = idx+1;
				$("th#col"+colNum).attr("id",value);
				$("th#col"+colNum).attr("text",name);
			},
			
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
			
			saveSelectedItems : function(){
				var selectedItems = $.setInquery.getSelectedItems();
				var title = $("#userText").val();
				
				if($("#inqueryList option").size()>12){
					alert($.getMsg($.msg.los.inquery.listCountOver));
					return false;
				}
				
				$("#inqueryList option").each(function() {
	                if ($(this).text() == $.trim(title)) {
	                	alert($.getMsg($.msg.los.inquery.sameName));
	                	return false;
	                }
	            });		
				$("#selectedListForm input").each(function(){
					if($(this).attr("name") != "CSRFToken"){
						$(this).remove();
					}
				});
				
				$("#selectedListForm").append("<input type='hidden' name=title value=\"" + title + "\">");
				for(i=0; i<selectedItems.length ; i++){
					$("#selectedListForm").append("<input type='hidden' name=searchAttributes[" + i + "] value=\"" + selectedItems[i] + "\">");
				}
				$.losmapMain.resetAttibutes(selectedItems);
				
				var pageType = $("#hiddenLosPageType").val();
				$.post("/business/losmap/popup/inquerycondition/ajax/save", $("#selectedListForm").serialize() + "&pageType=" + pageType,function(data) {
					$.setInquery.refreshSearchAttributeList(title);
				});
			},
			
			modifySelectedItems : function(){
				var sourceTitle = $("#inqueryList").val();
				var title = $("#userText").val();
				
				selectedItems = $.setInquery.getSelectedItems();
				$("#selectedListForm").append("<input type='hidden' name=title value=\"" + title + "\">");
				$("#selectedListForm").append("<input type='hidden' name=sourceTitle value=\"" + sourceTitle + "\">");
				for(i=0; i<selectedItems.length ; i++){
					$("#selectedListForm").append("<input type='hidden' name=searchAttributes[" + i + "] value=\"" + selectedItems[i] + "\">");
				}			
				
				var pageType = $("#hiddenLosPageType").val();
				
				$.post("/business/losmap/popup/inquerycondition/ajax/modify", $("#selectedListForm").serialize() + "&pageType=" + pageType,function(data) {
					$.losmapMain.resetAttibutes(selectedItems);
					$.setInquery.refreshSearchAttributeList(title);
				});		
			},
			
			deleteSelectedItems : function(){
				var deleteTitle = $("#inqueryList").val();
				$.losCommon.callAjax("GET", "/business/losmap/popup/inquerycondition/ajax/delete", "html", { "deleteTitle" :  deleteTitle }, 
						function successCallBack(data) {
					$.setInquery.refreshSearchAttributeList();
						}, null);			
			},
			
			changeSetType : function(){
				var selectedOption = $("#inqueryList option:selected").text();
				var selOptionVal = $("#inqueryList option:selected").val();
				$("#userText").val(selectedOption);
				
				if (selOptionVal.indexOf("default") != -1){
					$("#userText").val("");
				}
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
			
			setDefaultEntry : function(condition){
				var defaultArr;				
				if(condition == 'defaultRecord'){
					defaultArr = ["PV", "BV", "GROUP_PV", "GROUP_BV", "ACHIEVE_RATE","NEXT_ACHIEVE_RATE"];
				}
				else if(condition == 'defaultAcheive'){
					defaultArr = ["GROUP_PV", "GROUP_BV", "Q_LEG", "ACHIEVE_RATE", "NEXT_ACHIEVE_RATE", "GOAL_RATE"];
				}
				else if(condition == 'defaultAboInfo'){
					defaultArr = ["DISTRICT", "REGIST_DATE", "INTER_SPONSOR_YN", "PIN", "HIGHEST_PIN"];
				}
				
				$.setInquery.deselectAllEntry();
				for(var j = 0; j < $("#selectItem").find("li input").length; j++){
					if($.inArray($("#selectItem").find("li input")[j].value, defaultArr) > -1){
						$("#selectItem").find("a:eq(" + j + ")").addClass("on");
					}
				}
			},
			
			setSelectedEntry : function(){
				var selectedListName = $("#inqueryList option:selected").val();
				if (selectedListName.indexOf("default") != -1){
					$.setInquery.setDefaultEntry(selectedListName);
				}
				else{
						var url = "/business/losmap/popup/getItemsOfEntry"
						var params = {};
						params.title = selectedListName;
						params.pageType = $("#hiddenLosPageType").val();
						
						$.ajax({
							type : "GET",
							url : url,
							dataType : "html",
							data : params,
							success : function(data) {
								var dataList = data.replace("[", '').replace("\"]", '').replace("\"",'').split('\",\"');
								
								$.setInquery.deselectAllEntry();					
								for(var j = 0; j < $("#selectItem").find("li input").length; j++){
									if($.inArray($("#selectItem").find("li input")[j].value, dataList) > -1){
										$("#selectItem").find("a:eq(" + j + ")").addClass("on");
									}
								}
							},
							error : function() {
								alert($.msg.err.system);
							}
						});
				}
			},
			
			deselectAllEntry : function(){
				$("#selectItem").find("a").attr("class", "btnChoose");	
			},
			refreshSearchAttributeList : function(title){				
				$.losCommon.callAjax("GET", "/business/losmap/popup/inquerycondition/ajax/getList", "json",  "", 
						function successCallBack(data) {
							var html ="";
							html += "<option value = 'defaultRecord'>실적</option>";
							html += "<option value = 'defaultAcheive'>달성률현황</option>";
							html += "<option value = 'defaultAboInfo'>ABO정보</option>";
							for(i=0; i < data.length ; i++){
								html += "<option value=\"" + data[i].title + "\">(개인)" + data[i].title + "</option>";
							}
							$.losmapMain.refreshSeachAttribute(html, title);						
							closeLayerPopup($("#uiLayerPop_losInquery"));
							return false;
						}, null);	
			}
	}	

})(jQuery);

// [조회항목 설정 팝업] 신규설정 라디오버튼 선택
$(document).on("click", "#userSel02", function(){
	//기존설정 라디오버튼 체크해제
	$("#userSel01").prop('checked', false);
	
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

	$("#userText").val($.getMsg($.msg.los.inquery.defaultName, num));
	$("#new").attr("class","btnWrap aBlock");
	$("#new").show();
	$("#exsiting").hide();
	$("#inqueryList").attr('disabled', true);
	
	//List reset
	$.setInquery.deselectAllEntry();
});

//[조회항목 설정 팝업] 기존설정 라디오버튼 선택
$(document).on("click", "#userSel01", function(){
	//신규설정 라디오버튼 체크해제
	$("#userSel02").prop('checked', false);
	
	// 하단 UI 변경 
	$("#new").hide();
	$("#exsiting").show();
	$("#inqueryList").attr('disabled', false);
	
	$.setInquery.changeSetType();
	$.setInquery.setSelectedEntry();
});

// [조회항목 설정 팝업] - 기존설정 항목명 선택 시 항목명 text box 값 insert
$(document).on("change", "#inqueryList", function(){
	$.setInquery.changeSetType();
	$.setInquery.setSelectedEntry();
});

// [조회항목 설정 팝업] - ADD 버튼(>) 클릭이벤트
$(document).on("click", "#add_button", function() {
	$.setInquery.setItemsForInquery();
});

// [조회항목 설정 팝업] - DELETE 버튼(<) 클릭이벤트
$(document).on("click", "#del_button", function() {
	$.setInquery.delItemsForInquery();
});

// [조회항목 설정 팝업] - 위로 이동 버튼 클릭이벤트
$(document).on("click", "#up_button", function() {
	var cnt=0;
	$("#choiced_list option:selected").each(function(){
		cnt++
	});
	if(cnt=0){
		alert("순서를 변경할 항목을 선택해주세요");
		return false;
	}
	if (cnt > 1){
		alert("순서를 변경할 항목을 하나만 선택해주세요");
		return false;
	}
	
	var index =  $("#choiced_list option").index($("#choiced_list option:selected"));
	
	if(index == 0){
		return false;
	}
	
	$.setInquery.cngIdxItemsForInquery("u", index);
	return false;
});

// [조회항목 설정 팝업] - 아래로 이동 버튼 클릭이벤트
$(document).on("click", "#down_button", function() {
	var cnt=0;
	var totCnt=0;
	$("#choiced_list option").each(function(){
		totCnt++;
	});
	$("#choiced_list option:selected").each(function(){
		cnt++;
	});
	if(cnt=0){
		alert("순서를 변경할 항목을 선택해주세요");
		return false;
	}
	
	var index =  $("#choiced_list option").index($("#choiced_list option:selected"));
	if(index == totCnt-1){
		return false;
	}
	
	$.setInquery.cngIdxItemsForInquery("d", index);
	return false;
});

//[조회항목 설정 팝업] 바로검색 버튼
$(document).on("click", "#searchNow", function(){		
	if($.setInquery.getSelectedItems().length ==0){
		alert("조회항목을 1개 이상 선택해 주세요");
		return false;
	}
	$.losmapMain.data.searchNowAttributes = $.setInquery.getSelectedItems();
	$.losmapMain.addSearchNowOption();	
	$.losmapMain.resetAttibutes($.setInquery.getSelectedItems());
	closeLayerPopup($("#uiLayerPop_losInquery"));
});

//[조회항목 설정 팝업] 저장 버튼
$(document).on("click", "#save", function(){
	var text = $("#userText").val();
	if(text.length === 0){
		alert($.getMsg($.msg.common.inputDetail, "사용자조회항목"));
		return false;
	}
	if($.setInquery.getSelectedItems().length ==0){
		alert($.getMsg($.msg.los.inquery.emptyAttribute));
		return false;
	}
	
	var tmp = "";
	$("#inqueryList option").each(function() {
        if ($(this).text() == $.trim(text)) {
        	alert($.getMsg($.msg.los.inquery.sameName));
        	tmp= "N";
        }
    });	
	
	if(tmp == ""){
		$.setInquery.saveSelectedItems();
	}
	return false;
	
});

//[조회항목 설정 팝업] 삭제 버튼
$(document).on("click", "#delete", function(){
	
	var index = $("#inqueryList option").index($("#inqueryList option:selected"));
	if(index < 3){
		alert($.getMsg($.msg.los.inquery.defaultAttributeDelete));
		return false;
	}
	
	$.setInquery.deleteSelectedItems();
	
});

//[조회항목 설정 팝업] 수정 버튼
$(document).on("click", "#modify", function(){
	
	var index = $("#inqueryList option").index($("#inqueryList option:selected"));
	if(index < 3){
		alert($.getMsg($.msg.los.inquery.defaultAttributeModify));
		return false;
	}

	if($("#userText").val().length === 0){
		alert($.getMsg($.msg.common.inputDetail, "사용자조회항목"));
		return false;
	}
	if($.setInquery.getSelectedItems().length ==0){
		alert($.getMsg($.msg.los.inquery.emptyAttribute));
		return false;
	}
	
	$.setInquery.modifySelectedItems();
	
	return false;
});

//[조회항목 설정 팝업] 다른이름 저장
$(document).on("click", "#setNewName", function(){
	
	text = $("#userText").val();
	if(text.length === 0){
		alert($.getMsg($.msg.common.inputDetail, "사용자조회항목"));
		return false;
	}
	if($.setInquery.getSelectedItems().length ==0){
		alert($.getMsg($.msg.los.inquery.emptyAttribute));
		return false;
	}
	
	var tmp = "";
	$("#inqueryList option").each(function() {
        if ($(this).text() == $.trim(text)) {
        	alert($.getMsg($.msg.los.inquery.sameName));
        	tmp= "N";
        }
    });	
	
	if(tmp == ""){
		$.setInquery.saveSelectedItems();
	}
	return false;
});


$(document).on("click", "ol li > a", function(){
	$.setInquery.clickMobileItem($(this));

});

//전체선택취소 버튼
$(document).on("click", "#btnDeselectAll", function(){
	$.setInquery.deselectAllEntry();
	return false;
});