
// preorder quantity script
$(document).ready(function(){
	// button control
	$(document).off("keydown.amtCont", ".amtCont input").on("keydown.amtCont", ".amtCont input", function(e){
		$.inputOnlyNumber(e);
	});

	// 제품 수량이 0 이하 일 경우 Alert
	$(document).off("focusout.amtCont", ".amtCont input").on("focusout.amtCont", ".amtCont input", function(){
		if($(this).val() == "" || Number($(this).val()) < 0) {
			$(this).val(0);
			return false;
		}
		// 001 입력 되면 1로 변경
		$(this).val(Number($(this).val()));
		
		return false;
	});

	// 제품 수량 감소	
	$(document).off("click.amtCont", ".amtCont a.btnMinus").on("click.amtCont", ".amtCont a.btnMinus", function(){
		var $current = $(this).parent().find("input");

		if ($current.val() == "") {
			$current.val(0);
			return false;
		}

		if ($current.val() > 0) {
			$current.val(parseInt($current.val(), 10) - 1);
		} else {
			return false;
		}
		return false;
	});

	// 제품 수량 증가 
	$(document).off("click.amtCont", ".amtCont a.btnPlus").on("click.amtCont", ".amtCont a.btnPlus", function(){
		var $current = $(this).parent().find("input");

		if ($current.val() == "") {
			$current.val(0);
			return false;
		}
		
		if ($current.val() >= 0 && $current.val() < 999) {
			$current.val(parseInt($current.val(), 10) + 1);
		} else {
			return false;
		}
		return false;
	});	
});