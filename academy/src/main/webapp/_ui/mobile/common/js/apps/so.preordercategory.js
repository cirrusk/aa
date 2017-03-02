(function($) {
	$.preordercategory = {
		pagination : {
			currentPage				: 0,
			numberOfPages			: 0,
			pageSize				: 0,
			totalNumberOfResults	: 0
		},
		init :  function (options) {
			$.preordercategory.pagination.currentPage	= options.currentPage || 0;
			$.preordercategory.pagination.numberOfPages = options.numberOfPages || 0;
			$.preordercategory.pagination.pageSize = options.pageSize || 0;
			$.preordercategory.pagination.totalNumberOfResults = options.totalNumberOfResults || 0;
			
			// 페이지 번호 클릭시
			$(document).on("click", "#pbContent .listMore", function(){
				$.preordercategory.pagination.currentPage++;
				$.preordercategory.getList();
				return false;
			});
		},
		getList : function() {

			var param = { "page" : $.preordercategory.pagination.currentPage };
			
			$.ajax({
				type		: "GET",
				url			: "/shop/preorder/category/ajax/list",
				data		: param,
				dataType	: "text",
				success		: function(data,st) {
					$.preordercategory.renderer(data);
				},
				error		: function(xhr,st,err){
					xhr=null;
				},
				beforeSend	: function(xhr){

				},
				complete	: function(xhr, textStatus) {
				
				}
			});
		},
		renderer : function(data) {
			var $data = $(data);
			var $pagination = $data.find("div#pagination");
			var currentPage= parseInt($pagination.find('span#currentPage').text(), 10);
			var totalNumberOfResults = parseInt($pagination.find('span#totalNumberOfResults').text(), 10);
			var numberOfPages = parseInt($pagination.find('span#numberOfPages').text(), 10);

			$.preordercategory.pagination.currentPage = currentPage;
			$.preordercategory.pagination.totalNumberOfResults = totalNumberOfResults;
			$.preordercategory.pagination.numberOfPages = numberOfPages;
			
			$("#pbContent .newsList ul").append($data.find('div#preOrderCategory').html());
			
			// 20개 더보기 숨기기
			if(currentPage >= numberOfPages) {
				$("#pbContent .listMore").hide();
			}
			
		}
	}
})(jQuery);