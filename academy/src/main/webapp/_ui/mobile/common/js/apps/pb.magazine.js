(function($) {
	$.common = {
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
			}
	},
	$.magazine = {
			isLogin : false,
			data : {},		
			returnList : function(element){
				$.detail.pageMove(element);
			}
	},
	$.detail = {
			pageMove : function(element){
				$("#magazineSearchForm").attr("action", $(element).attr("href"));
				$("#magazineSearchForm #categoryCode").val($(element).data("categorycode") || "");
				$("#magazineSearchForm #id").val($(element).data("id") || "");
				$("#magazineSearchForm").submit();
			}
	},
	$.list = {
			getSearchData : function(){
				var actionUrl = location.pathname+"/magazineList";
				$.list.searchData($.magazine);
				$.common.callAjax('POST', actionUrl, 'html', "#magazineSearchForm", function successCallBack(data){
			    $("a.listMore").remove();  
				$("div#mobileList").append(data);
				}, null);
			},
			searchData : function(magazine){
				$("#magazineSearchForm #page").val(magazine.data.page || "1");
			//	$("#magazineSearchForm #totPage").val(magazine.data.totPage || "1");
			}	
	}
})(jQuery);

//목록
$(document).on("click", "div.btnWrap aNumb1 a.btnBasicGrL", function(e){
	e.preventDefault();
	$.magazine.returnList(this);
});

//더보기
$(document).on("click", "a.listMore", function(e){
	$.magazine.data.page = $(this).children("input[name$='page']").attr("value");
	$.magazine.data.totPage=  $(this).children("input[name$='totPage']").attr("value");

	if($.magazine.data.page +1 >= $.magazine.data.totPage)
	return false;

	$.magazine.data.page++;
	$.list.getSearchData(); 
	return false;
});

