(function($) {
	$.sponser = {
			agree : function(element) {
				var agreeYn = $(element).attr("id").replace("sponsorAgree", "");
				$.sponser.submit(agreeYn);	
			},
			submit : function(agreeYn){
				$("#termContractAgreeForm input#agree").val(agreeYn);
				$("#termContractAgreeForm").submit();
			}
	}
})(jQuery);

$(document).on("click", "#termContractAgreeForm a.sponsorAgree", function(){
	$.sponser.agree(this);
});
