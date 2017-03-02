<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

var _arrTabMenu = {};

var _initTab = [{optionValue : "M", closable : false, optionText : "Main Index", menuCd : "M"}];
var tabConfig = {
		theme : "AXTabs",
		value : _initTab[0].optionValue,
		overflow : "scroll",
		scrollAmount : 2,
		options : _initTab, 
		onchange : function(selectedObject, value){
			var targetId = 'contents_{0}'.format(value);
			
			try{				
				$(this).setValueTab(value);
			} catch(e) {
				
			}
    		
    		var hasDiv = false;
    		$("#inner > .conDiv").each(function(){
    			if($(this).attr("id") == targetId){
    				hasDiv = true;
    			}
    		});

    		if(!hasDiv){
    			var url = "${ctp}";
    			
    			if(selectedObject.menuUrl != "#"){
    				url = selectedObject.menuUrl + "?frmId=" + selectedObject.menuCd + "&menuAuth=" + selectedObject.menuAuth;
    			}
    			if(typeof selectedObject.tmpParam != "undefined" && selectedObject.tmpParam != ""){
    				url += "&" + selectedObject.tmpParam;
    			}
	    		$("#inner").append("<div id=\"" + targetId + "\" class=\"conDiv\" menuId=\"" + value + "\"><iframe id=\"ifrm_main_" + value + "\" class=\"targerFrame\" frameboader=\"0\" scrolling=\"no\"></iframe></div>");
	    		
	    		var objIfrm = $('#ifrm_main_' + value);
	    		objIfrm.attr("src", url);
	    		objIfrm.css({ 
	    			"height" : "100%"
	    			, "min-height" : "900px" 
				});
    		}
    		$("#inner > .conDiv").hide();
    		$("#inner > #" + targetId).show();    		
    		
    		if(value=="M") {
				$("#btnIfrmRefresh").hide();
				return;
			} else {
				$("#btnIfrmRefresh").show();
			}
    		
    		// Tree에 선택된 메뉴 표시
    		for(var i = 0; i < leftMenuTree.list.length; i++){
    			if(selectedObject.menuCd == leftMenuTree.list[i].menuCd){
    				leftMenuTree.click(leftMenuTree.list[i].__index);
    			}
    		}
		},
	    onclose: function(selectedObject, value){
	        //toast.push("onclose: "+Object.toJSON(value));	        
	    	var targetId = 'contents_{0}'.format(value);
	    	$('#'+ targetId).remove();
	    }
	};
$(document.body).ready(function(){
	// Tab Bind
	$("#tabMenuTop").bindTab(tabConfig);
});

// Tab Event
window.addTabMenu = function(option){
	var options = $("#tabMenuTop").getOptions();
	
	var _selectTabMenuId = "";
	var _selectTabMenuText = "";
	var obj = null;
	
	try{
		obj = JSON.parse(option);
		_selectTabMenuId = obj.menuCd;
		_selectTabMenuText = obj.menuText;
	}catch(e){
		alert(e);
	}
	
	if(options == null || typeof options == "undefined"){
		options = _arrTabMenu;
		$("#tabMenuTop").bindTab(tabConfig).bind(options);
	}
	
	var exist = false;
	$(options).each(function(index, value){
		if(_selectTabMenuId == value.optionValue) {
			exist = true;
			return false;
		}
	});
	
	$('#contents > div').hide();
	
	if(exist && obj.menuYn == "Y"){
		var targetId = 'contents_{0}'.format(_selectTabMenuId);
		$('#tabMenuTop').setValueTab(_selectTabMenuId);
		$('#contents > #' + targetId).show();
		
		if( !isNull(obj.callFn) ){ 
			var addData = {
				"menu" : obj.callMenu
				, "key" : obj.callMenuKey1
			}
			if(typeof g_managerLayerMenuId.subMenu == "undefined"){
				g_managerLayerMenuId.subMenu = [];
			}
			
			var iRtn = -1;
			for(var i = 0; i < g_managerLayerMenuId.subMenu.length; i++){
				if(g_managerLayerMenuId.subMenu[i].menu == obj.callMenu){
					iRtn = i;
					break;
				}
			}
			
			if(iRtn == -1) {
				g_managerLayerMenuId.subMenu.push(addData);
			} else {
				g_managerLayerMenuId.subMenu[iRtn] = addData;
			}

			if( isNull(obj.funcData) ) {
				eval("$(\"#ifrm_main_" + _selectTabMenuId + "\").get(0).contentWindow." + obj.callFn + "()");
			} else {
				eval("$(\"#ifrm_main_" + _selectTabMenuId + "\").get(0).contentWindow." + obj.callFn +"(" + JSON.stringify(obj.funcData)+ ")");
			}
		}
		
	} else {
    	
    	if(typeof obj.urlParam != "undefined"  && obj.urlParam != ""){
    		obj.tmpParam = obj.urlParam;
    	}
    	var myTabOption = [
        	{optionValue : _selectTabMenuId, closable:true, optionText: _selectTabMenuText, menuCd : _selectTabMenuId, menuUrl : obj.linkurl, tmpParam: obj.tmpParam, menuAuth : obj.menuAuth}
        ];
    	
    	if(obj.menuYn == "Y"){
        	$("#tabMenuTop").addTabs(myTabOption);
        	$("#tabMenuTop").setValueTab(_selectTabMenuId);
        	
        	_arrTabMenu = $("#tabMenuTop").getOptions();
    	}

		if( !isNull(obj.callFn) ){ 
			try {
				var addData = {
					"menu" : obj.callMenu
					, "key" : obj.callMenuKey1
				}
				if(typeof g_managerLayerMenuId.subMenu == "undefined"){
					g_managerLayerMenuId.subMenu = [];
				}
				
				var iRtn = -1;
				for(var i = 0; i < g_managerLayerMenuId.subMenu.length; i++){
					if(g_managerLayerMenuId.subMenu[i].menu == obj.callMenu){
						iRtn = i;
						break;
					}
				}
				if(iRtn == -1) {
					g_managerLayerMenuId.subMenu.push(addData);
				} else {
					g_managerLayerMenuId.subMenu[iRtn] = addData;
				}
				eval("$(\"#ifrm_main_" + _selectTabMenuId + "\").get(0).contentWindow." + obj.callFn +"(" + JSON.stringify(obj.funcData)+ ")");
			} catch (e){}
		}
	}	
}
var chkGlobalMenu = function(chkValue){
	var rtnValue = {};
	for(var i = 0; i < g_managerLayerMenuId.subMenu.length; i++){
		if(g_managerLayerMenuId.subMenu[i].menu == chkValue){
			rtnValue = g_managerLayerMenuId.subMenu[i];
			break;
		}
	}
	return rtnValue;
}
// end addTabMenu
var g_managerLayerMenuId = {};
// Layer Popup Open
var openManageLayerPopup = function(options){
	var default_value =  {	
		  targetId : "layer_pop"
		, width : 850
		, height : 600
		, maxHeight : 700
		, callback : false
		, params : ""
		, level : "1"
	};
	
	var opts = $.extend({}, default_value, options);
	
	opts.width  = parseFloat(opts.width);
	opts.height = parseFloat(opts.height);
	opts.height = opts.height > opts.maxHeight ? opts.maxHeight : opts.height;
	opts.level  = $("body").find(".modalBg").length;
	
	// 활성화 Iframe Menu Id
	var showMenuId = "";
	$(".conDiv").each(function(){
		if($(this).css("display") == "block"){
			showMenuId = $(this).attr("menuId"); 
		}
	});
	
	var xindex = "5000";
	if(opts.level > 0){
		xindex = "5010";
	};
	var item = opts.params;
	
	$.ajax({
		url: opts.url,
		type:'post',
		data : opts.params,
		success: function(data){
			// 열린 Ifrm ID 설정 
			g_managerLayerMenuId.callId = "ifrm_main_" + showMenuId;
			
			obj.html(data);
			
			var objContainer = obj.find('#popcontainer');
			objContainer.height( opts.height - 50);

			if(opts.level > 1){
				$(".close-layer" + opts.level).on("click", function(){
					closeManageLayerPopup(opts.targetId, item.pageID);
				});
			} else {
				// 닫기 버튼 이벤트
				$(".close-layer").on("click", function(){
					closeManageLayerPopup(opts.targetId, item.pageID);
				});
			}

       		setManageMouseWheelOff(obj);
		},
		error: function(xhr,status,error){  
			closeManageLayerPopup();
			alert("code:"+xhr.status);
		}
	});
	
	// modal
	var modalHtml = '<div class="modalBg" id="'+opts.targetId+'_modal" style="z-index:'+(xindex-1)+';"></div>';
	var parentDoc = $(parent.document).find('body');
	parentDoc.append(modalHtml);

	// 기존 Layer 삭제
	$("#" + opts.targetId).remove();
	$(parent.document).find("body").append('<div id="' + opts.targetId + '"></div>');
	
	// Layer 레이아웃
	var obj = $(parent.document).find('#'+ opts.targetId);
	obj.css({
		position:'absolute'
		, zIndex: xindex
		, width: opts.width
		, height: opts.height
		, maxHeight: opts.maxHeight
		, backgroundColor: '#fff'
		, left: $(window).width() <=  opts.width ? '0' : '50%'
		, top: $(window).height() <=  opts.height ? '0' : '50%'
		, marginLeft: $(window).width() <=  opts.width ? '0' : -(opts.width/2)
		, marginTop: $(window).height() <=  opts.height ? '0' : -(opts.height/2)
	});
	
	
	// 0908 레이어 팝업 후 탭 닫았을때 스크롤 없어지는 문제때문에 주석처리함
	/* 
	$(window).bind('resize', function(){
		if ( $(window).height() <=  obj.height() ) {
			obj.css({
				top: '0'
				, marginTop: '0'
			});
		} else {
			obj.css({
				top: '50%'
				, marginTop: -(opts.height/2)
			});
		}
		if ( $(window).width() <=  obj.width() ) {
			obj.css({
				left: '0'
				, marginLeft: '0'
			});
		} else {
			obj.css({
				left: '50%'
				, marginLeft: -(opts.width/2)
			});
		}
		setManageMouseWheelOff(obj);
	});
	 */
		
};

// Layer Popup Close
var closeManageLayerPopup = function(targetId, pageID){
	// Set Default Target
	if(targetId == '' || typeof targetId == "undefined"){
		targetId = 'layer_pop';
	}
	$('#'+targetId).remove();
	$('#'+targetId+'_modal').remove();
	$("." + $(window).data("id_" + targetId)).remove();	

	// 휠 마우스 해제
	setManageMouseWheelOn();
	
	try{
// 		$("#tabMenuTop").focus();
// 		$("#tabMenuTop > .AXTab").each(function(i,val){
// 		});
// 		var options = $("#tabMenuTop");
// // 		var options = $("#tabMenuTop").getOptions('ifrm_main_' + pageID);
// // 		var options = AXTab.getOptions('ifrm_main_' + pageID);
// // 		AXTabClass.focusingItem(objID, objSeq, optionIndex)
// // 		$('#ifrm_main_' + pageID).setValueTab();
// // 		$("#"+tabID).setValueTab(tabValue);
// // 		$("#tabMenuTop").bindTab(tabConfig);
		eval($('#ifrm_main_'+pageID).get(0).contentWindow.doReturnClose());	
	}catch(e){
		
	}
	// Init 열린 Ifrm ID
	//g_managerLayerMenuId.callId = "";
};
//마우스 휠 방지 설정
var setManageMouseWheelOff = function(obj){
	$('html, body').css({
		overflowY: $(window).height() <=  obj.height() ? 'scroll' : 'hidden',
		overflowX: $(window).width() <=  obj.width() ? 'scroll' : 'hidden'
	});
};
// 마우스 휠 방지 설정 해제
var setManageMouseWheelOn = function(){
	$('html, body').css({
		overflowX:'',
		overflowY:''
	});
}
// After Action Call Back Event 
// 공통 팝업이므로 작업 처리 후 해당 Iframe.Func 호출
var doCallBackFunc = function(options){
	var default_value =  {
		funcId : "doSearch"
		, funcData : {page:1}
		, msg : ""
		, isClose : true
	};
	
	var opts = $.extend({}, default_value, options);

	if(opts.msg != ""){
		//toast.push(opts.msg);
		alert(opts.msg);
	}

	try{
		eval("$(\"#" + g_managerLayerMenuId.callId + "\").get(0).contentWindow." + opts.funcId +"(" + JSON.stringify(opts.funcData)+ ")");
	} catch(e){
		
	}
	if(opts.isClose){
		closeManageLayerPopup();
	}
	
	// 전역변수 처리
// 	g_managerLayerMenuId.sessionLecCd = opts.sessionLecCd;
// 	g_managerLayerMenuId.sessionLecNm = opts.sessionLecNm;		
};

</script>
		
			<div style="position:relative;" class="sampleCont">
				<div id="tabMenuTop"></div>
			</div>