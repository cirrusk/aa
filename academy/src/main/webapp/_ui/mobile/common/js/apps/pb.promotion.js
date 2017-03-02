(function($) {
	$.news = {
		init :  function () {
			
			// change sort
			$(document).on("change", "section#pbContent div.listType > select", function(){
				var url = $(this).find("option:selected").attr("value"); 
	            if (url) { 
	                location.href = url;
	            }
	            return false;
	    	});
			
			// 장바구니 담기
			$(document).on("click", "ul.proList div.btnBox span.btnR .btnTbl", function(){
				
				// 비활성화 장바구니 버튼 처리
				if ($(this).hasClass("off"))
				{
					var isNotLaunched = $("ul.proList").attr("data-orderable-value");
					if (isNotLaunched == "Y") {
						var isPromotion = $("ul.proList").attr("data-promotion-flag");
						if (isPromotion == "true") {
							alert($.getMsg($.msg.news.promotionNotLaunched));
						} else {
							alert($.getMsg($.msg.news.newProductNotLaunched));
						}
					}
					return false;
				}
				
				if($(this).attr("href") != "#") {
					
					location.href = $(this).attr("href");
					return false;
				}
				
				var cartParam = [];
				var code = $(this).parent().attr("data-code");
				var qty = 1;
				
				if(code != null || code.length > 0) {
					cartParam.push({"productCodes" : code, "qties" : qty});	
				}

				// 장바구니 클릭은 중복체크를 위함으로 파라미터 추가.
				$.addToCart(cartParam, true);
				
				return false;
			});

			// 전체 제품 선택
			$(document).on("click", "#pbContent div.btnGroup > a.btnBoard", function(){
				var isChecked = !$(this).hasClass("on");
				
				if(isChecked) {
					$(this).addClass("on");
					$("ul.proList li input[type='checkbox']").not(':disabled').attr("checked", 'checked');	
				} else {
					$(this).removeClass("on");
					$("ul.proList li input[type='checkbox']").not(':disabled').removeAttr("checked");
				}
				
				return false;
			});

			// 전체 선택 동기화
			var allSelectSync = function() {
				var checkedAmount = $("ul.proList li input[type='checkbox']:checked").not(':disabled').length;
				var allAmount =  $("ul.proList li input[type='checkbox']").not(':disabled').length;
				
				if (checkedAmount > 0 && checkedAmount == allAmount) {
					$("#pbContent div.btnGroup > a.btnBoard").addClass("on");
				} else {
					$("#pbContent div.btnGroup > a.btnBoard").removeClass("on");
				}				
			};
			allSelectSync();
			$(document).on("click", "ul.proList li input[type='checkbox']", allSelectSync);
			
			// 선택한 제품 장바구니에 담기
			$(document).on("click", "#pbContent div.btnGroup div.btnR a.btnBoard", function(){

				var isNotLaunched = $("ul.proList").attr("data-orderable-value");
				if (isNotLaunched == "Y") {
					var isPromotion = $("ul.proList").attr("data-promotion-flag");
					if (isPromotion == "true") {
						alert($.getMsg($.msg.news.promotionNotLaunched));
					} else {
						alert($.getMsg($.msg.news.newProductNotLaunched));
					}
					return false;
				}

				var $checked = $("ul.proList li input[type='checkbox']:checked");

				if($checked.length <= 0) {
					alert("제품을 선택해 주세요.");
					return false;
				}

				if($(this).attr("href") != "#") {
					location.href = $(this).attr("href");
					return false;
				}
				
				var cartParam = [];

				$checked.each(function(idx, obj) {
					var $li = $(this).parents("li:first");
					var code = $li.find(".btnBox").find(".btnR").attr("data-code");
					var qty = 1;
					
					if(code != null || code.length > 0) {
						cartParam.push({"productCodes" : code, "qties" : qty});	
					}
				});
				
				try {
					// 장바구니 클릭은 중복체크를 위함으로 파라미터 추가.
					$.addToCart(cartParam, true, function (){
						$("ul.proList li input[type='checkbox']").not(':disabled').removeAttr("checked");
						$("#pbContent div.btnGroup > a.btnBoard").removeClass("on");
					});	
				} catch(e) {}
				
				return false;
			});
		}
	};
})(jQuery);


$(document).ready(function(){
	
	$.news.init();

});