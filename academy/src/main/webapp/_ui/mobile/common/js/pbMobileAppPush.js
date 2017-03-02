
function callReturnApp(pushToken, deviceCd, pushYn) {
	$.moblieApp.pushAjax(pushToken, deviceCd, pushYn);
}

(function($){
    $.moblieApp = {   		
    		pushAjax : function(pushToken, deviceCd, pushYn){
    			var oData = {};
    			oData.pushYn    = pushYn;
    			oData.pushToken = pushToken;
    			oData.deviceCd  = deviceCd;
    			
                $.ajax({
                    type:"GET",
                    url: $.moblieApp.data.push,
                    dataType: "json",
                    data: oData,
                    contentType: "application/json",
                    async: false,
                    success: function (data){
                    	if(data.path){
                    		window.location.href = data.path;
                    	}
                    },
                    error: function(){}
                }); 
    		},
    		data : {
    			push		: "/amwayinfo/ajax/push-agree",
    			uid: null
    		},
    		isIos : function(){
    			return navigator.userAgent.match(/AMWAY_IOS_APP/i) != null && navigator.userAgent.match(/AMWAY_IOS_APP/i).length >= 1;
    			//AMWAY_IOS_APP
    		},
    		isAndroid : function(){
    			return navigator.userAgent.match(/AMWAY_ANDROID_APP/i) != null && navigator.userAgent.match(/AMWAY_ANDROID_APP/i).length >= 1;
    			//AMWAY_ANDROID_APP
    		},
    		isDevice : function(){
    			var android = /AMWAY_ANDROID_APP/gi;
    			var ios = /AMWAY_IOS_APP/gi;
    			return android.test(navigator.userAgent) || ios.test(navigator.userAgent);
    		},
    		init : function(){
    			login  = $.moblieApp.cookie.get($.moblieApp.cookie.key.login)  || "";
    			logout = $.moblieApp.cookie.get($.moblieApp.cookie.key.logout) || "";
    			// console.log(login + ", " + logout);
    			if(login.length >= 1){
    				$.moblieApp.data.uid = login;
    				$.moblieApp.login(login);
    			}
    			
                if(logout.length >= 1){
                	$.moblieApp.data.uid = null;
                	$.moblieApp.logout(logout);
                }    			
    		},
    	    cookie : {
    	    	key : {
    	    		login  : "COOKIE_MOBILE_APP_LOGIN",
    	    		logout : "COOKIE_MOBILE_APP_LOGOUT"
    	    	},
    	    	get : function(cookieName){
    	            var value;
    	            var cookies = document.cookie.split(';');
    	            // console.log(cookies);
    	            $(cookies).each(function(index, val){
    	            	var cookie = val.split("=");
    	            	if(cookieName == $.trim(cookie[0])){
    	            		value = cookie[1] || "";
    	            		return;
    	            	}
    	            });
    	            
    	            return value;
    	    	},
    	    	remove: function(cookieName){
    	            var expireDate = new Date();
    	            expireDate.setDate(expireDate.getDate() - 1);
    	            document.cookie = cookieName + "= " + "; expires="+ expireDate.toGMTString() + "; path=/";
    	    	}
    	    },
    	    login : function(pUid){
    	        //console.log("login:: " + pUid);
    	    	$.moblieApp.cookie.remove($.moblieApp.cookie.key.login);
    	    	if($.moblieApp.isDevice() != true) return;
    	    	
    	    	try{
	    	        if ($.moblieApp.isAndroid()) {
	    	            window.pushtokenupdatejs.callpushTokenUpdateJavascriptFromAndroid(pUid, "Y");
	    	        } else if ($.moblieApp.isIos()) {
	    	        	// alert("jscall2://?login||" + pUid + "||" + "Y");
	    	            window.location.href = "jscall2://?login||" + pUid + "||" + "Y";
	    	        } else {
	    	            alert("지원 하지 않는 OS입니다.");
	    	        }
    	    	}catch(e){} 
    	    },
    	    logout : function(pUid){
    	    	//console.log("logout:: " + pUid);
    	    	
    	    	$.moblieApp.cookie.remove($.moblieApp.cookie.key.logout);
    	    	if($.moblieApp.isDevice() != true) return;
    	    	
    	    	try{    	    	
	    	        if ($.moblieApp.isAndroid()) {
	    	            window.logoutjs.callLogoutJavascriptFromAndroid();
	    	        } else if ($.moblieApp.isIos()) {
	    	            window.location.href = "jscall2://?logout";
	    	        } else {
	    	            alert("지원 하지 않는 OS입니다.");
	    	        }
    	    	}catch(e){}     	        
    	    }
    }
})(jQuery);

// Push 메시지리스트
$(document).on("click", "#pushMessageBtn", function(){

    if($.moblieApp.isAndroid()){
    	window.activitjs.callContentView('2');

    }else if($.moblieApp.isIos()){
    	window.location.href = "jscall2://?msglist";

    }else{
        alert("지원 하지 않는 OS입니다.");
    }
});

//쇼핑정보 및 알림
$(document).on("click", "#alarmSettingBtn", function(){
    if($.moblieApp.isAndroid()){
        window.activitjs.callContentView('1');
    }else if($.moblieApp.isIos()){
    	window.location.href = "jscall2://?setting";      
    }else{
        alert("지원 하지 않는 OS입니다.");
    }
});

$("document").ready(function(){
	$.moblieApp.init();
})