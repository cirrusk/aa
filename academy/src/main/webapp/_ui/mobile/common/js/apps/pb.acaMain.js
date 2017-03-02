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
	$.resource = {
			isLogin : false,
			data : {},
			curr2depthType : function(){
				var type = $("section#pbContent div.tabWrap ul").find("li.on").attr("id") || "";
				return type=="ALL" ? "" : type;
			}
	},
	$.list = {
			getSearchData : function(element){
				var actionUrl = "/view/AcademyMainResourceComponentController/resource";
				$.list.searchData($.resource);
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
    				$("#resourceList").html(data);
				}, null);
			}
	},
	$.detail = {
			pageMove : function(element){
				$("#resourceSearchForm").attr("action", $(element).attr("href"));
				
				$("#resourceSearchForm #categoryCode").val($(element).data("categorycode") || "");
				
				$("#resourceSearchForm").submit();
			}
	}
})(jQuery);

// 아카데미 메인 자료실 배너 카테고리 클릭
$(document).on("click", "ul.tabSubNav li", function(e){
	e.preventDefault();
	var id = $(this).children("a").data("code");
	$("ul.tabSubNav li").removeClass("on");
	$(this).addClass("on");
	$("div[id^=subDataList_]").hide();
	$("#subDataList_"+id).show();
});

//자료실 게시물 상세 조회 (리스트(제목, 이미지, 내용 클릭), 이전자료/다음자료)
$(document).on("click", "a#newResourceLink", function(e){
	e.preventDefault();
	$.detail.pageMove(this);
});

$(document).ready(function(){
	$("div[id^=subDataList_]").hide();
	$("#subDataList_PR101").show();
	$("ul.tabSubNav li").first().addClass("on");
});