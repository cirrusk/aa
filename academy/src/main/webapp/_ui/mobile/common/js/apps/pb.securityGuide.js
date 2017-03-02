(function($) {
	$.securityGuide= {
			isLogin : false,
			init : function(){
				if( $("#securitySearchForm #id").val() ){
					$("li").find("a[data-id='"+$("#securitySearchForm #id").val()+"']").focus();
				}
				$.securityGuide.data.page = $("#securitySearchForm #page").val();
				$.securityGuide.data.searchVal = $("#securitySearchForm #searchVal").val();
			},
			data : {
				page		: 1
			},
			url : {
				list			: "/compliance/security",
				listAjax		: "/compliance/security/search",
				reloadListAjax	: "/compliance/security/resourceList",
			},
			callAjax : function(type, url, dataType, form, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data: $(form).serialize(),
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ) { 
							errorCallBack(); 
						} else {
							alert("시스템 담당자에게 문의해 주세요.");
						}
						return false;
					}
				});
			},
			returnList : function(element){
				$("#securitySearchForm").attr("action", $.securityGuide.url.list);
				$("#securitySearchForm #page").val($(element).data("page") || 1);
				$("#securitySearchForm #id").val($(element).data("id") || "");
				$("#securitySearchForm #searchVal").val($(element).data("searchval") || "");
				
				$("#securitySearchForm").submit();
			},
			setListMore : function(){
				var countOfPages = $(".listMore").attr("data-countperpage");
				var totCnt = $(".listMore").attr("data-totcnt");
				var totPageCnt = totCnt / countOfPages + 1;
				var currPage;
				
				currPage = parseInt($.securityGuide.data.page, 10);
								
				var moreBtn = $(".listMore, listMoreTop");
				if(currPage + 1 >= totPageCnt)
					{
						moreBtn.children("span").html("TOP");
						moreBtn.attr("href", "#pageLocation");
						moreBtn.attr("class", "listMoreTop");
					}
				else if(totCnt - (countOfPages * currPage) > countOfPages)
					{
						moreBtn.children("span").html(countOfPages + "개 더보기");
						moreBtn.attr("href", "#none");
						moreBtn.attr("class", "listMore");
					}
				else
					{
						moreBtn.children("span").html(totCnt - (countOfPages * currPage) + "개 더보기");
						moreBtn.attr("href", "#none");
						moreBtn.attr("class", "listMore");
					}
			}
	},
	$.detail = {		
			pageMove : function(element){
				$("#securitySearchForm").attr("action", $(element).attr("href"));
				$("#securitySearchForm #id").val($(element).data("id")||"");
				$("#securitySearchForm #searchVal").val($(element).data("searchval") || "");
				
				$("#sec_h_refresh").val("Y");
				$("#sec_h_id").val($(element).data("id") || "");
				
				$("#securitySearchForm").submit();
			}
	},
	$.list = {			
			getSearchData : function(){
				var url  = $.securityGuide.url.listAjax;
				
				if($("#sec_h_refresh").val() == "Y"){
					url = $.securityGuide.url.reloadListAjax;
				}
				
				$.list.searchData($.securityGuide);
				$.securityGuide.callAjax('POST', url, 'html', "#securitySearchForm", function successCallBack(data){
					if($.securityGuide.data.page > 1 && $("#sec_h_refresh").val() != "Y")
					{
					var $data = $(data);
    				var securityList = $data.find("ul#securityListStart").html();
					$("ul#securityListStart").append(securityList);
					$.securityGuide.setListMore();
					}
				else
					{
					$("#securityGuideList").html(data);
					$.securityGuide.setListMore();
					}
				}, null);
			},
			search : function(){
				var searchVal = $("div.listSearch input.searchVal").val();
				if($.trim(searchVal).length && $.trim(searchVal).length < 2){
					alert("검색어는 최소 2글자 이상 입력해 주세요.");
					$("div.listSearch input.searchVal").focus();
					return;
				}
				$.securityGuide.data.searchVal = $.trim(searchVal);
				$.list.getSearchData();				
			},			
			searchData : function(securityGuide){
				$("#securitySearchForm #page").val(securityGuide.data.page || "1");
				$("#securitySearchForm #searchVal").val(securityGuide.data.searchVal || "");
				$("#securitySearchForm #searchType").val(securityGuide.data.searchType || "ALL");
				
				$("#sec_h_page").val(securityGuide.data.page || "1");
				$("#sec_h_searchVal").val(securityGuide.data.searchVal || "");
			}
	}	
})(jQuery);

// 게시물 조회
$(document).on("click", " a[class^='securityGuideItem']", function(e){
	e.preventDefault();
	$.detail.pageMove(this);
});

// 검색버튼 클릭
$(document).on("click", "div.listSearch input#searchSecurityGuide", function(e){
	$.securityGuide.data.page = 1;
	$.list.search();
});

//더보기(20건씩 조회)
$(document).on("click", "a#securityListMore", function(){
	$.securityGuide.data.page++;
	$.list.getSearchData();
	
});

// 목록
$(document).on("click", "#returnList", function(e){
	e.preventDefault();
	$.securityGuide.returnList(this);
});

$("document").ready(function(){
	$.securityGuide.setListMore();
	
	if($("#sec_h_refresh").val() == "Y") {
    	
    	var page = $("#sec_h_page").val();
    	var searchVal = $("#sec_h_searchVal").val();
    	
		// search val
		$("input.searchVal").val(searchVal);
		
		// page
		$.securityGuide.data.page = page;
		
		$("#securitySearchForm #id").val($("#sec_h_id").val() || "");
		
		$.list.search();
    }
	
	$.securityGuide.init();
	
});
