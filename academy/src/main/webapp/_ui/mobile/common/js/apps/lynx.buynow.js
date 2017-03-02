(function($) {
	/*
	 * 데이터 생성방법 JSON 형태로 데이터 생성 var buyNowCartParam = [];
	 * buyNowCartParam.push({"productCodes" : "100179K81", "qties" : "1"});
	 * buyNowCartParam.push({"productCodes" : "LSP0820K2", "qties" : "1"});
	 */
	$.buynow = {
		data : {
			    urlHttps : ""
			  , inProgress   : false       
		},
		callBuynow : function(buyNowCartParam) {
			$.buynow.callBuyNowCart("buynow", "", buyNowCartParam)
		},
		callCart : function(buyNowCartParam) {
			$.buynow.callBuyNowCart("cart", "", buyNowCartParam)
		},
		callInstall : function(buyNowCartParam) {
			$.buynow.callBuyNowCart("install", "", buyNowCartParam)
		},
		callTransit : function(buyNowCartParam) {
			$.buynow.callBuyNowCart("transit", "", buyNowCartParam)
		},
		callPromotion : function(buyNowCartParam, requestCode) {
			$.buynow.callBuyNowCart("promotion", requestCode, buyNowCartParam)
		},
		callBuyNowCart : function(requestType, requestCode, buyNowCartParam) {
			
			if($.buynow.data.inProgress || buyNowCartParam == null){
				return;
			}
			
			$.buynow.data.inProgress = true;
			
			var chkUrl = "/shop/buynow/" + requestType + "/ajax/check";
			var addUrl = $.buynow.data.urlHttps + "/shop/order/" + requestType + "/checkout";
			if(requestCode){
				chkUrl = chkUrl + "/" + requestCode;
				addUrl = addUrl + "/" + requestCode;
			}

			$.setCartParam(buyNowCartParam);

			$.ajax({
				type	: "POST",
				url		: chkUrl,
				dataType: "json",
				data    : $("#addToCartForm").serialize(),
				success : function (data){
					if(data.status){
						if(data.confirmMsgInstall){
							if (confirm(data.confirmMsgInstall)) {
								$(document.location).attr("href", "/shop/install-product-category/c/INSTALL");
								$.buynow.data.inProgress = false;
								return false; 
							}
						}
						var salesLimit = false;
						if(data.confirmMsgSalesLimit){
							if (confirm(data.confirmMsgSalesLimit)) {
								salesLimit = true;
							}
						}
						if(data.confirmMsg){
							if (!confirm(data.confirmMsg)) {
								$.buynow.data.inProgress = false;
								return false; 
							}
						}
						if(data.isPromotionUrl){
							addUrl = $.buynow.data.urlHttps + "/shop/order/promotion/checkout/maxfree";
						}
						NetFunnel_Action({action_id : NetFunnel_TS_ACTION_ID_ORDER,skin_id : NetFunnel_TS_SKIN_ID_ORDER}
						 , {
							success : function(ev, ret) {
								$("#addToCartForm").append($("<input/>", {"id" : "salesLimit", "name" : "salesLimit", "value" : salesLimit, "type" : "hidden"}));
								$("#addToCartForm").attr('action',addUrl);
								$("#addToCartForm").attr('method',"POST");
								$("#addToCartForm").attr('target',"_self");
								$("#addToCartForm").submit();
								setTimeout(function() {
									$.buynow.data.inProgress = false;
								}, 1000 * 2);
							},
							stop : function(ev, ret) {
								$.buynow.data.inProgress = false;
							},
							error : function(ev, ret) {
								$.buynow.data.inProgress = false;
							}
						});
					}else{
						$.buynow.data.inProgress = false;
						alert(data.errorMsg);
					}
					return false;
				},
				error: function(){
					$.buynow.data.inProgress = false;
					//alert($.msg.err.system);
					return false;
				}
			});
		}
	};
})(jQuery);

$.buynow.data.inProgress = false;
