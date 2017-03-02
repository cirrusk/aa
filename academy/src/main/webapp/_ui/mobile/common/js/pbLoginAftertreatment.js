(function($) {
	$.loginAfter = {
	    cookie : {
	    	key : {
	    		thirdPerson     : "COOKIE_THIRD_PERSON_AGREE", // 제3자 활용동의가 동의 안되어 있는 사용자
	    		recommendPw     : "COOKIE_RECOMMEND_CHANGE_PASSWORD" // 비밀번호 변경 대상자 (필수)
	    	},
	    	get : function(cookieName){
	            var value;
	            var cookies = document.cookie.split(';');
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
		url : {
			thirdPerson : "/mypage/personalinfo/use-agreement",	 // 개인정보 활용 동의 페이지
		},
		init : function(){
			var thirdPerson     = $.loginAfter.cookie.get($.loginAfter.cookie.key.thirdPerson) 		|| "";
			var recommendPw     = $.loginAfter.cookie.get($.loginAfter.cookie.key.recommendPw) 		|| "";
			var appUserId       = $.loginAfter.cookie.get($.loginAfter.cookie.key.appUserId) 		|| "";
			
			$.loginAfter.cookie.remove($.loginAfter.cookie.key.thirdPerson);
			$.loginAfter.cookie.remove($.loginAfter.cookie.key.recommendPw);

			if(thirdPerson.length >= 1)
			{
				var message = "개인정보의 제3자 제공동의에 대한 동의가 진행하지 않았습니다."
					        + "\n{user} 분들이 본인의 상위 ABO에게 본인 정보에 대한 제공 동의이며, 자세한 내용은 동의 화면에서 확인 가능합니다."
				            + "\n동의 화면으로 이동합니다.";
				message = message.replace("{user}", thirdPerson == "abo"? "ABO" : "회원");
				alert(message);
				
				// 패스워드 변경 대상자 일 경우 화면 이동 안함
				if(recommendPw.length <= 0)
				{
					window.location.href = $.loginAfter.url.thirdPerson;
				}
			}
		}
	}
})(jQuery);

$(document).ready(function(){
	$.loginAfter.init();
});