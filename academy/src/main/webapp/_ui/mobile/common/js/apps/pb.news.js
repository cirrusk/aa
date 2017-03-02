(function($) {
	$.csrnews = {
			init : function(){
				
				$.csrnews.data.page = $("#searchForm #page").val() || 1; // 페이지 세팅
				$.csrnews.data.isSeeMore = $("#searchForm #totPage").val() > (Number($.csrnews.data.page) || 1 ) ? "true" : "false"; // 더 보기 정보 세팅
				$.csrnews.data.searchVal = $("#searchForm #searchVal").val();
				
				$.csrnews.setSeeMore(); // 더 보기 적용
				
			},
			focusTitle : function(){
				//Detail에서 목록으로 돌아간 후 focus
				if( $("#searchForm #startId").val() ){
					$("ul").find("a[data-id='"+$("#searchForm #startId").val()+"']").focus();
				}
			},
			data : {},
			url : {
				list 			: "/introduction/news/csr",
				listAjax		: "/introduction/news/csr/ajax/search",
				reloadListAjax	:"/introduction/news/csr/ajax/reloadList",
				detail			: "/introduction/news/csr/detail"
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
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},
		    utils : {
		        castData : function(isReverse)
		        {
		              $.each($("input.reflashVal"), function()
		              {
		                     var field = $(this).data("cast");
		                     if(field)
		                     {
		                           var castObj = isReverse ? $(field) : $(this);
		                           var orgObj  = isReverse ? $(this)  : $(field);
		                           if(castObj.length && orgObj.length){
		                                  castObj.val(orgObj.val());
		                           }
		                     }
		              });
		        }
		    },
			list : {			
					returnList : function(){
						$("#searchForm").attr("action", $.csrnews.url.list);
						$("#searchForm").submit();
					},
					search : function(){
						var searchVal = $.trim($("#searchTxt").val());
						if(searchVal.length && searchVal.length < 2){
							//"검색어는 최소 2글자 이상 입력해 주세요."
							alert($.getMsg($.msg.common.minSearchText, "2"));
							$("#searchTxt").focus();
							return;
						}
						
						$.csrnews.data.page = 1;
						$.csrnews.data.searchVal  = searchVal;
						$.csrnews.list.searchPage($.csrnews.data);
						
					},
					searchPage : function(data){
						$("#searchForm #page").val(data.page || 1);
						$("#searchForm #searchVal").val(data.searchVal || "");
						
						var url = $.csrnews.url.listAjax;
							
						if($("#res_h_refresh").val() == "Y"){
							url = $.csrnews.url.reloadListAjax;
						}
						
						$.csrnews.callAjax("POST", url, "html", "#searchForm", function(data){
							if((Number($.csrnews.data.page) || 1) > 1 && $("#res_h_refresh").val() != "Y"){
								$(".newsList ul").append(data);
							}else{
								$(".newsList ul").html(data);
							}
							$("#searchTxt").blur();
							$.csrnews.setSeeMore();
							
							var searchResult;
							if($.csrnews.data.searchVal){
								searchResult = "<strong>검색</strong> "+$.csrnews.data.totCnt+" 건";
							}else{
								searchResult = "<strong>전체</strong> "+$.csrnews.data.totCnt+" 건";
							}
							
							$("span.listInfo").html(searchResult);
							
							if($("#res_h_refresh").val() == "Y"){
								$.csrnews.focusTitle();
								$("#res_h_refresh").val("N");
							}
						});
					}
			},
			detail : {		
					page : function(element){
						if($.trim($(element).data("id")).length <= 0) return;
						$("#searchForm").attr("action", $.csrnews.url.detail);
						$("#searchForm #id").val($(element).data("id"));
						
						if($(element).data("startid")){
							$("#searchForm #startId").val($(element).data("startid")||"");
						}
						
						$("#res_h_refresh").val("Y");
						$.csrnews.utils.castData();
						
						$("#searchForm").submit();
					}
			},
			setSeeMore : function(){
				if($.csrnews.data.isSeeMore == "false"){
					$("#btnSeeMore").hide();
				}else{
					$("#btnSeeMore").show();
				}
			}
	}

})(jQuery);

//다음 20개
$(document).on("click", "a.listMore", function(){
	
	$.csrnews.data.page = (Number($.csrnews.data.page) || 1) + 1;
	
	$.csrnews.data.searchVal  = $("#searchForm #searchVal").val();
	
	$.csrnews.list.searchPage($.csrnews.data);
});

// 뉴스 게시물 조회
$(document).on("click", "[class='moveDetail']", function(e){
	e.preventDefault();
	$.csrnews.detail.page($(this));
});

// 검색버튼 클릭
$(document).on("click", "#searchNewsBtn", function(e){
	e.preventDefault();
	$.csrnews.list.search();
});

//검색 엔터클릭
$(document).on("keydown", "#searchTxt", function(e){
	if(e.which == 13){
		e.preventDefault();
		$.csrnews.list.search();
	}
});

// 목록
$(document).on("click", "#returnList", function(e){
	e.preventDefault();
	$.csrnews.list.returnList();
});

$(document).ready(function(){
	if($("#res_h_refresh").val() == "Y"){
		$.csrnews.utils.castData(true);
		$.csrnews.init();
		$.csrnews.list.searchPage($.csrnews.data);
	}else{
		$.csrnews.init();
		$.csrnews.focusTitle();
	}
});