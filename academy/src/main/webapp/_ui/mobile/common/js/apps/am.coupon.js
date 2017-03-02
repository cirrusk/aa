(function($) {
	$.coupon = {
			data : {
				  url : "/_ui/mobile"
				, isSeeMore : ""
				, page : ""
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					cache	 : false,
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ){ 
							errorCallBack(); 
						} else {
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},
			getSearchData : function(page){
				var actionURL;
				var params = {};
				var type = 'html';

				params.page	= page;	
				actionUrl = "/mypage/coupon/management/ajax/list";

				$.coupon.callAjax('GET', actionUrl, type, params, function successCallBack(data){
					$("#couponList").html($("#couponList").html()+data);
					$.coupon.setSeeMore();
				}, null);
			},
			setSeeMore : function(){
				if($.coupon.data.isSeeMore == "false"){
					$("#couponSeeMore").hide();
				}else{
					$("#couponSeeMore").show();
				}
			}
	};

	// ############################################################################
	// 쿠폰 관리
	// ############################################################################

	// 더보기
	$(document).on("click", "#couponSeeMore", function(e){
		$.coupon.data.page++;
		$.coupon.getSearchData($.coupon.data.page);
		return false;
	});
})(jQuery);