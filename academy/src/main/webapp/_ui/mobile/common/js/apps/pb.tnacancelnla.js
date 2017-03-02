(function($) {
	$.tnacencelnla = {
		searchData	 : {
			text					: "",
			page					: 0,
			currentUri				: ""
		},
		pagination : {
			currentPage				: 0,
			numberOfPages			: 0,
			pageSize				: 0,
			totalNumberOfResults	: 0,
			sort					: ""
		},
		init :  function (options) {

			$.tnacencelnla.pagination.currentPage	= options.currentPage || 0;
			$.tnacencelnla.pagination.numberOfPages = options.numberOfPages || 0;
			$.tnacencelnla.pagination.pageSize = options.pageSize || 0;
			$.tnacencelnla.pagination.totalNumberOfResults = options.totalNumberOfResults || 0;
			$.tnacencelnla.pagination.sort = options.sort || "";
			$.tnacencelnla.searchData.currentUri = options.currentUri || "";

			// 목록정렬 변경시
			$(document).on("change", "#pbContent .listType select", function(){
				var sortCode = $(this).find("option:selected").val();
				$.tnacencelnla.searchData.page = 0;
				$.tnacencelnla.getTNACancelNLAList("facet");	
			});
			
			// 더보기
			$(document).on("click", "#pbContent .listMore", function(){
				if($.tnacencelnla.searchData.page+1 >= $.tnacencelnla.pagination.numberOfPages)
					return false;

				$.tnacencelnla.searchData.page++;
				$.tnacencelnla.getTNACancelNLAList("paging");
				return false;
			});

			// 검색어 입력 후 Enter
			$("#pbContent .quickSearch #quickSrch").bind("keydown", function(e){
				if (e.keyCode == 13) {
					$("#pbContent .quickSearch .btnSearch").click();
				}
			});
			
			// 검색버튼 클릭시(공통에 있는 이벤트 안태우기 위해 unbind)
			$("#pbContent .quickSearch .btnSearch").unbind("click").bind("click", function(){
				$.tnacencelnla.searchData.page = 0;
				$.tnacencelnla.getTNACancelNLAList("text");
				return false;
			});

			$.tnacencelnla.setListMore();
		},
		setListMore : function(){
			
			var currentPage = $.tnacencelnla.pagination.currentPage;
			var pageSize = $.tnacencelnla.pagination.pageSize;
			var numberOfPages = $.tnacencelnla.pagination.numberOfPages;
			var totalNumberOfResults = $.tnacencelnla.pagination.totalNumberOfResults;
			
			var $moreBtn = $("#pbContent .listMore,#pbContent .listMoreTop");
			if(currentPage+1 >= numberOfPages) {
				$moreBtn.attr("href", "#pbContent");
				$moreBtn.attr("class", "listMoreTop");
				$moreBtn.children("span").html("TOP");
			} else {
				var nextViewCount = pageSize;
				if(currentPage+2 >= numberOfPages) {
					nextViewCount = (totalNumberOfResults - ((currentPage+1) * pageSize));
				}

				$moreBtn.attr("href", "#");
				$moreBtn.attr("class", "listMore");
				$moreBtn.children("span").html(nextViewCount + "개 더보기");
			}
		},
		getParam : function(searchType) {

			var param = "";

			// 검색어
			param += $("#pbContent .quickSearch #quickSrch").val();	

			var rtnParam = {};
			rtnParam.text = param;
			rtnParam.facet = $("#pbContent .listType select").val() || "";
			rtnParam.page = $.tnacencelnla.searchData.page;
						
			return rtnParam;
		},
		getTNACancelNLAList : function(searchType) {

			var param = this.getParam(searchType);
			var url = $.tnacencelnla.searchData.currentUri + "/ajax/tnaCancelNLAList";

			$.ajax({
				type		: "GET",
				url			: url,
				data		: param,
				dataType	: "text",
				success		: function(data,st) {
					$.tnacencelnla.renderer(data, searchType);
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
		renderer : function(data, searchType) {

			var $data = $(data);
			var $pagination = $data.find("div#pagination");
			var currentPage= parseInt($pagination.find('span#currentPage').text(), 10);
			var totalNumberOfResults = parseInt($pagination.find('span#totalNumberOfResults').text(), 10);
			var numberOfPages = parseInt($pagination.find('span#numberOfPages').text(), 10);
			var sort = $pagination.find('span#sort').text();

			if(searchType == "text" && totalNumberOfResults <= 0)
			{
				alert("검색된 제품이 없습니다. 제품의 VPS 코드, 제품명, SKU 번호를 확인하신 후 다시 검색해 주세요.");
				return false;
			}
			
			$.tnacencelnla.pagination.currentPage = currentPage;
			$.tnacencelnla.pagination.totalNumberOfResults = totalNumberOfResults;
			$.tnacencelnla.pagination.numberOfPages = numberOfPages;
			$.tnacencelnla.pagination.sort = sort;
			
			$("#pbContent .listType .listL").html("<strong>전체</strong> " + $.setComma(totalNumberOfResults) + ' 건');
			
			if($.tnacencelnla.pagination.currentPage == 0) {
				$(".proList.detailCont").empty();
			}
			$(".proList.detailCont").append($data.find("div#ajaxList").html());
			
			$.tnacencelnla.setListMore();
		}
	};
})(jQuery);