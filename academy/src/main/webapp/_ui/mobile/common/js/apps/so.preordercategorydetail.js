(function($) {
	$.preordercategorydetail = {
		data : {
			maxNumberPerPreOrder : 0
		},
		init :  function (options) {

			$.preordercategorydetail.data.maxNumberPerPreOrder =  options.maxNumberPerPreOrder;

			// 제품구매 예약
			$("#pbContent .btnWrap .btnBasicRL").click(function(){
				
				if($(this).attr("href") != "#")
					return true;
				
				if($.preordercategorydetail.validation() == false)
					return false;

				$.preordercategorydetail.savePreOrder();
				return false;
			});
		},
		savePreOrder : function() {
			loadingLayerS();
			var $form = $("#preOrderSaveForm");
			$.ajax({
				type		: "POST",
				url			: "/shop/preorder/ajax/save",
				data		: $form.serialize(),
				dataType	: "json",
				success		: function(data,st) {
					if(data.status == "success") {
						alert("제품구매 예약이 완료 되었습니다.\n'제품구매 예약 내역' 에서 확인 및 변경 가능합니다.");
						window.location.reload();
					} else {
						alert("시스템 관리자에게 문의하세요.");
					}
					loadingLayerSClose();
				},
				error		: function(xhr,st,err){
					xhr=null;
					alert("시스템 관리자에게 문의하세요.");
					loadingLayerSClose();
				},
				beforeSend	: function(xhr){

				},
				complete	: function(xhr, textStatus) {
					loadingLayerSClose();
				}
			});
		},
		validation : function() {
			
			// 조건 : 제품 개수 모두 0으로 하고 신청하기 클릭한 경우
			// 1개 이상 제품의 수량을 입력하여 주세요.
			var isProductMaxPreOrder = false;
			
			var preOrderCnt = 0;
			
			$(".preProList .amtCont input[type=number]").each(function(){
				
				var preOrderValue = Number($(this).val());
				preOrderCnt += preOrderValue;
				
				var productMaxPreOrder = $(this).parents(".amtCont:first").attr("data-maxPreOrder") || "0";
				if(!isProductMaxPreOrder && productMaxPreOrder > 0 && preOrderValue > 0 && preOrderValue > productMaxPreOrder)
				{
					isProductMaxPreOrder = true;
				}
			});
			
			if(preOrderCnt <= 0) {
				alert("1개 이상 제품의 수량을 입력하여 주세요.");
				return false;
			}
			
			var maxNumberPerPreOrder = $.preordercategorydetail.data.maxNumberPerPreOrder;
			if(maxNumberPerPreOrder > 0 && preOrderCnt > maxNumberPerPreOrder){
				alert("예약가능 수량을 초과 하였습니다.");
				return false;
			}
			
			if(isProductMaxPreOrder) {
				alert("예약가능 수량을 초과 하였습니다.");
				return false;
			}
			
			return true;
		}
	}
})(jQuery);