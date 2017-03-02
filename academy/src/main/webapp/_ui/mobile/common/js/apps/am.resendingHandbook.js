(function($) {
	$.resendHandbook={
			request : function(){
				$.ajax({
					type : "GET",
					url : "/mypage/resendingReq",
					dataType : "json",
					data : null,
					success : function(data) {
						if (data.result === true) {
							alert("ABO 등록증&수첩 재발송 신청이 정상적으로 접수되었습니다.");
						}else{
							alert($.msg.err.system);
						}
					},
					error : function() {
						alert($.msg.err.system);
					}
				});
			}
	}
})(jQuery)

// ABO 등록증/수첩 재발송
$(document).on("click", "#requestBtn", function(e){
	var actionUrl = "/mypage/resendingReq";
	
	if (!confirm("ABO 등록증&수첩 재발송 신청을 접수하시겠습니까?")) 
	{
		return false;
	}	
	$.resendHandbook.request();
	return false;
});
