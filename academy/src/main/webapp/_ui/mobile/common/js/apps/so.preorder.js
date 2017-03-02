(function($) {
	$.preorder = {
		pagination : {
			currentPage				: 0,
			numberOfPages			: 0,
			pageSize				: 0,
			totalNumberOfResults	: 0
		},
		init :  function (options) {
			$.preorder.pagination.currentPage	= options.currentPage || 0;
			$.preorder.pagination.numberOfPages = options.numberOfPages || 0;
			$.preorder.pagination.pageSize = options.pageSize || 0;
			$.preorder.pagination.totalNumberOfResults = options.totalNumberOfResults || 0;

			// 페이지 번호 클릭시
			$(document).on("click", "#pbContent .listMore", function(){
				$.preorder.pagination.currentPage++;
				$.preorder.getList();
				return false;
			});
		},
		getList : function() {
			var param = { "page" : $.preorder.pagination.currentPage };
			$.preorder.callAjax("GET", "/shop/preorder/ajax/list", "text", param, function(data){
				$.preorder.renderer(data);
			});
		},
		renderer : function(data) {
			var $data = $(data);
			var $pagination = $data.find("div#pagination");
			var currentPage= parseInt($pagination.find('span#currentPage').text(), 10);
			var totalNumberOfResults = parseInt($pagination.find('span#totalNumberOfResults').text(), 10);
			var numberOfPages = parseInt($pagination.find('span#numberOfPages').text(), 10);

			$.preorder.pagination.currentPage = currentPage;
			$.preorder.pagination.totalNumberOfResults = totalNumberOfResults;
			$.preorder.pagination.numberOfPages = numberOfPages;

			$("#pbContent .newsList ul").append($data.find('div#preOrderCategory').html());

			// 20개 더보기 숨기기
			if(currentPage >= numberOfPages) {
				$("#pbContent .listMore").hide();
			}
		},
		validationForDetail : function(){
			var sumQty = 0;
			var isOverMax = false;

			$("#preOrderSaveForm input").not("[name='CSRFToken'], #preOrderCode, #categoryCode").remove();
			$(".proList li .amtCont input[type=number]").each(function(idx){
				var $amtObj = $(this).parents(".amtCont:first");
				var productCode = $amtObj.next("input[name=productCode]").val();
				var qty = Number($(this).val());
				var maxQty = Number($amtObj.attr("data-maxPreOrder") || 0);

				if(maxQty > 0 && qty > maxQty){
					isOverMax = true;
					return false;
				}

				$("#preOrderSaveForm").append($("<input/>", {"id" : "productCodes" + idx, "name" : "productCodes[" + idx + "]", "type" : "hidden", "value" : productCode}));
				$("#preOrderSaveForm").append($("<input/>", {"id" : "qties" + idx, "name" : "qties[" + idx + "]", "type" : "hidden", "value" : qty}));
	
				sumQty += qty;
			});

			var maxPreOrder = $("#maxPreOrder").val();
			if(maxPreOrder != 0 && maxPreOrder < sumQty){
				alert("예약가능 수량을 초과 하였습니다.");
				return false;
			}

			if(maxPreOrder <= 0 && isOverMax){
				alert("예약가능 수량을 초과 하였습니다.");
				return false;
			}

			if(sumQty <= 0){
				alert("1개 이상 제품의 수량을 입력하여 주세요.");
				return false;
			}
			return true;
		},
		savePreOrder : function(){
			loadingLayerS();
			var $form = $("#preOrderSaveForm");
			$.preorder.callAjax("POST", "/shop/preorder/ajax/save", "json", $form.serialize(), function(data){
				if(data.status == "success") {
					alert("변경된 수량으로 적용되었습니다.");
					$.preorder.getDetail();
				}
			});
		},
		cancelPreOrder : function(){
			loadingLayerS();
			$("#preOrderSaveForm input").not("[name='CSRFToken'], #preOrderCode, #categoryCode").remove();
			var url = "/shop/preorder/ajax/delete";
			$.preorder.callAjax("POST", url, "json", $("#preOrderSaveForm").serialize(), function(data){
				loadingLayerSClose();
				if(data.status == "success") {
					window.location.href = "/shop/preorder/list";
				}
			});
		},
		getDetail : function(){
			var param = {};
			param.code = $("#preOrderCode").val();
			$.preorder.callAjax("GET", "/shop/preorder/ajax/detail", "html", param, function(data){
				$("#preOrderProductList").html(data);
				$("body, html").animate({ scrollTop: $("#preOrderProductList").offset().top }, 0);
				loadingLayerSClose();
			});
		},
		callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
			$.ajax({
				type     : type,
				url      : url,
				dataType : dataType,
				data     : data,
				success: function (data){
					if( typeof successCallBack === 'function' ) { successCallBack(data); }
					return false;
				},
				error: function(xhr, st, err){
					xhr = null;
					// alert(err);
					if( typeof errorCallBack === 'function' ) { 
						errorCallBack(); 
					} else {
						loadingLayerSClose();
						alert($.msg.err.system);
					}
					return false;
				},
				complete : function(){
					loadingLayerSClose();
				}
			});
		}
	};

	// 변경내용 저장
	$(document).on("click", ".btnWrap .btnBasicRL", function(e){
		if(!$.preorder.validationForDetail()){
			return false;
		}
		$.preorder.savePreOrder();
		return false;
	});

	// 제품구매 예약 취소
	$(document).on("click", ".tblDetailHead .btnTbl", function(e){
		if(!confirm("해당 제품구매 예약을 취소 하시겠습니까?")){
			return false;
		}
		$.preorder.cancelPreOrder();
		return false;
	});
})(jQuery);