(function($) {
	$.common = {
			init : function(){
				if( $("#resourceSearchForm #id").val() ){
					$("li").find("a[data-id='"+$("#resourceSearchForm #id").val()+"']").focus();
				}
				$.resource.data.page = $("#resourceSearchForm #page").val();
				$.resource.data.searchVal = $("#resourceSearchForm #searchVal").val();
				
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
			setListMore : function(element){
				var countOfPages = parseInt($(".listMore").attr("data-countperpage"), 10);
				var totCnt = parseInt($(".listMore").attr("data-totcnt"), 10);
				var totPageCnt = totCnt / countOfPages + 1;
				var currPage;
				
				if(element == null)
					{
					currPage = parseInt($("#resourceSearchForm #page").val(), 10);
					}
				else if(element == 'business')
					{
					currPage = $.businessForm.data.page;
					}
				else if(element == 'terminology')
					{
					currPage = $.terminology.data.page;
					}
				
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
			},
			setResourcePageRefresh : function(){
				$("div.listL a#selectAll").hide();
				$("div.listL a#delete").hide();
				$("a#editEnd").hide();
				$("#bottomListType").hide();
				$.common.setListMore();
				$("li#editMyResource").hide();
			},
			setBusinessPageRefresh : function(){
				$.common.setListMore('business');
			},
			setTerminologyPageRefresh : function(){
				$.common.setListMore('terminology');
			},
	},
	$.resource = {
			isLogin : false,
			data : {
				page		: 1
			},
			currSortResourceType : function(){
				return $("div.listType select#sortResourceType option:selected").val();
			},
			currSortType : function(){
				return $("div.listType select#sortType option:selected").val();
			},
			returnList : function(element){
				$.detail.pageMove(element);
			}
	},
	$.terminology = {
			isLogin : false,
			data : {
				page		: 1
			}
	},
	$.businessForm = {
			isLogin : false,
			data : {
				page		: 1
			}
	},
	$.detail = {
			pageMove : function(element){
				$("#resourceSearchForm").attr("action", $(element).attr("href"));
				$("#resourceSearchForm").removeAttr("target");
				$("#resourceSearchForm #categoryCode").val($(element).data("categorycode") || "");
				$("#resourceSearchForm #id").val($(element).data("id") || "");
				$("#resourceSearchForm #sortResourceType").val($(element).data("sortresourcetype") || "ALL");
				$("#resourceSearchForm #sortType").val($(element).data("sorttype") || "");
				$("#resourceSearchForm #searchVal").val($(element).data("searchval") || "");
				$("#resourceSearchForm #page").val($(element).data("page") || "1");
				
				$("#res_h_refresh").val("Y");
				$("#res_h_id").val($(element).data("id") || "");
				
				$("#resourceSearchForm").submit();
			}
	},
	$.list = {
			getSearchData : function(){
				var actionUrl = location.pathname + "/resourceList";
				$.list.searchData($.resource);
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
					if($.resource.data.page > 1 && $("#resourceSearchForm #isMobile").val() != "true")
						{
						var $data = $(data);
	    				var resourceList = $data.find("ul#resourceListStart").html();
						$("ul#resourceListStart").append(resourceList);
						$.common.setResourcePageRefresh();
						}
					else
						{
						$("#resourceList").html(data);
						$.common.setResourcePageRefresh();
						}
					
					if($("#res_h_refresh").val() == "Y"){
						$.common.init();
						$("#res_h_refresh").val("N");
					}
					
				}, null);
			},
			search : function(){
				var searchVal = $("div.listSearch input.searchVal").val();
				if($.trim(searchVal).length && $.trim(searchVal).length < 2){
					alert("검색어는 최소 2글자 이상 입력해 주세요.");
					$("div.listSchB input.searchVal").focus();
					return;
				}
				
				$.resource.data.sortResourceType = $.resource.currSortResourceType();
				$.resource.data.sortType = $.resource.currSortType();
				$.resource.data.searchVal = $.trim(searchVal);
				$.list.getSearchData();
			},
			searchData : function(resource){
				$("#resourceSearchForm #page").val(resource.data.page || "1");
				$("#resourceSearchForm #sortResourceType").val(resource.data.sortResourceType || resource.currSortResourceType());
				$("#resourceSearchForm #sortType").val(resource.data.sortType || resource.currSortType());
				$("#resourceSearchForm #searchType").val(resource.data.searchType || "ALL");
				$("#resourceSearchForm #searchVal").val(resource.data.searchVal || "");
				
				$("#res_h_resSort").val(resource.data.sortResourceType || resource.currSortResourceType());
				$("#res_h_sort").val(resource.data.sortType || resource.currSortType());
				$("#res_h_page").val(resource.data.page || "1");
				$("#res_h_searchVal").val(resource.data.searchVal || "");
			}
	},
	$.like = {
			getLikeData : function(){
				var actionUrl = location.pathname + "/resourceLike";
				//$.list.searchData($.resource);
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
					var checkLike = $(data).find("#resourceSearchForm #checkLike").val();
					$("#resourceSearchForm #checkLike").val(checkLike);
					
					if($("#resourceSearchForm #checkLike").val() == "TRUE")
					{
						var $myReco = $(data).find(".myReco");
						$(".myReco").html($myReco.html());
					//	$(".myReco").removeClass("on");
						
						alert("해당 자료를 추천하였습니다.");
					}
					else
					{
						alert("이미 추천하신 자료입니다.");
					}
	    			}, null);
			}
	},
	$.likeOnList = {
			getLikeData : function(element){
				var actionUrl = location.pathname + "/checkLike";
				var selectedId = $(element).data("id");
				$.list.searchData($.resource);
				$("#resourceSearchForm #id").val($(element).data("id"));
				$("#resourceSearchForm #checkLike").val($(element).data("checklike"))
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
					
					var resultMsg = '이미 추천하신 자료입니다.';
					
					if(data != null){
						
						var uneditMyRecEle = $(data).find('div[class=acDataInfo] .myReco').first();
						var editMyRecEle = $(data).find('input[data-id=' + selectedId + ']').parents('li').find('.myReco');
						var checkLikeResult = uneditMyRecEle.attr('data-checkLike');
						if(checkLikeResult == 'true'){
							resultMsg = '해당 자료를 추천하였습니다.';
						}

						var originUneditMyRes = $('#resourceListStart div[id=' + selectedId + '] .myReco').parent('span');
						var originEditMyRes = $('#resourceListStart').find('input[data-id=' + selectedId + ']').parents('li').find('.myReco').parent('span');
						originUneditMyRes.html(uneditMyRecEle);
						originEditMyRes.html(editMyRecEle);
					}
						alert(resultMsg);
					
				
					
	    			}, null);
			}
	},
	$.setMyResourceOnList = {
			setData : function(element){
				var actionUrl = location.pathname + "/checkMyResource";		
				var selectedId = $(element).data("id");
				$.list.searchData($.resource);
				$("#resourceSearchForm #id").val($(element).data("id"));
				$("#resourceSearchForm #checkMyResource").val($(element).data("checkmyresource"));
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
					
				if($("#resourceSearchForm #categoryCode").val() == "MY1")
					{
						window.location.replace("http://" + location.host + "/academy/resource/c/MY1");
					}
					else
					{				
						var resultMsg;
					if(data != null){
						var uneditMyDataEle = $(data).find('div[class=acDataInfo] .myData');
						var editMyDataEle = $(data).find('input[data-id=' + selectedId + ']').parents('li').find('.myData');
						var checkMyResource = uneditMyDataEle.attr('data-checkMyResource');
						
						var originUneditMyData = $('#resourceListStart div[id=' + selectedId + '] .myData').parent('span');
						var originEditMyData = $('#resourceListStart').find('input[data-id=' + selectedId + ']').parents('li').find('.myData').parent('span');
						
						if(checkMyResource == 'true'){
							resultMsg = '해당 자료가 나의 자료실에 추가되었습니다.';
						}else{
							resultMsg = '해당 자료가 나의 자료실에서 해제되었습니다.';
						}
						alert(resultMsg);
						originUneditMyData.html(uneditMyDataEle);
						originEditMyData.html(editMyDataEle);

					}else{
						alert(resultMsg);
					}

					}

	    		}, null);
			}
	},
	$.setMyResource = {
			setData : function(){
				var actionUrl = location.pathname + "/setMyResource";
				//$.list.searchData($.resource);
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
					// 나의 자료실의 경우 나의자료실해제 시 list page로 이동 

					var checkMyResource = $(data).find("#resourceSearchForm #checkMyResource").val();
					$("#resourceSearchForm #checkMyResource").val(checkMyResource);
					
					if($("#resourceSearchForm #checkMyResource").val() == "TRUE")
					{
						alert("해당 자료가 나의 자료실에 추가되었습니다.");
					}
					else
					{
						alert("해당 자료가 나의 자료실에서 해제되었습니다.");
					}
					
					if($("#resourceSearchForm #categoryCode").val() == "MY1")
					{
						window.location.replace("http://" + location.host + "/academy/resource/c/MY1");
					}
					else
					{
						var $myData = $(data).find(".myData");
						$(".myData").html($myData.html());
					}

	    		}, null);
			}
	},
	$.delMyResource = {
			setData : function(element){
				var actionUrl = location.pathname + "/delMyResource";
				//$.list.searchData($.resource);
				if($.isArray(element))
					{
					$("#resourceSearchForm #ids").val(element);
					}
				else
					{
					$("#resourceSearchForm #id").val(element);
					}
				$.common.callAjax('POST', actionUrl, 'html', "#resourceSearchForm", function successCallBack(data){
					$("#resourceList").html(data);
					$.common.setResourcePageRefresh();
				}, null);
			}
	},
	$.terminologyList = {
			getSearchData : function(){
				var actionUrl = location.pathname + "/terminologyList";
				$.terminologyList.searchData($.terminology);
				$.common.callAjax('POST', actionUrl, 'html', "#terminologySearchForm", function successCallBack(data){
					if($.terminology.data.page > 1)
					{
						var $data = $(data);
	    				var terminologyList = $data.filter("ul#terminologyListStart").html();
						$("ul#terminologyListStart").append(terminologyList);
						$.common.setTerminologyPageRefresh();
					}
					else
					{
						$("#terminologyList").html(data);
						$.common.setTerminologyPageRefresh();
					}
				}, null);
			},
			search : function(){
				var searchVal = $("div.listSearch input.terminologySearchVal").val();
				if($.trim(searchVal).length && $.trim(searchVal).length < 2){
					alert("검색어는 최소 2글자 이상 입력해 주세요.");
					$("div.listSearch input.terminologySearchVal").focus();
					return;
				}
				
				$.terminology.data.searchVal = $.trim(searchVal);
				$.terminology.data.page = 1;
				$.terminologyList.getSearchData();
			},
			searchData : function(terminology){
				$("#terminologySearchForm #page").val(terminology.data.page || "1");
				$("#terminologySearchForm #initialPhoneme").val(terminology.data.initialPhoneme || "AllKor");
				$("#terminologySearchForm #searchVal").val(terminology.data.searchVal || "");	
			}
	},
	$.businessFormList = {
			getSearchData : function(){
				var actionUrl = location.pathname + "/businessFormList";
				$.businessFormList.searchData($.businessForm);
				$.common.callAjax('POST', actionUrl, 'html', "#businessFormSearchForm", function successCallBack(data){
					if($.businessForm.data.page > 1)
					{
						var $data = $(data);
	    				var businessFormList = $data.filter("ul#businessListStart").html();
						$("ul#businessListStart").append(businessFormList);
						$.common.setBusinessPageRefresh();
					}
					else	
					{
						$("#businessFormList").html(data);
						$.common.setBusinessPageRefresh();
					}
				}, null);
			},
			search : function(){
				var searchVal = $("div.listSearch input.businessFormSearchVal").val();
				if($.trim(searchVal).length && $.trim(searchVal).length < 2){
					alert("검색어는 최소 2글자 이상 입력해 주세요.");
					$("div.listSearch input.searchVal").focus();
					return;
				}
				
				$.businessForm.data.searchVal = $.trim(searchVal);
				$.businessForm.data.page = 1;
				$.businessFormList.getSearchData();
			},
			searchData : function(businessForm){
				$("#businessFormSearchForm #page").val(businessForm.data.page || "1");
				$("#businessFormSearchForm #searchVal").val(businessForm.data.searchVal || "");	
			}
	}
})(jQuery);

//상세조회 후 목록 조회 클릭
$(document).on("click", "a#resourceReturnList", function(e){
	e.preventDefault();
	$.resource.returnList(this);
});

//자료실 게시물 상세 조회 (리스트, 이전자료/다음자료)
$(document).on("click", "a.detail, a#resourcePrev, a#resourceNext", function(e){
	e.preventDefault();
	$.detail.pageMove(this);
});

//sort select (자료타입 sort, 자료정보별 sort, 검색조건 select) 
$(document).on("change", "div.listType select#sortResourceType, div.listType select#sortType, div.listSearch input#searchResource", function(){
	$.resource.data.page = 1;
	$.list.search();
});

//자료검색 버튼 클릭
$(document).on("click", "div.listSearch input#searchResource", function(e){
	$.resource.data.page = 1;
	$.list.search();
});

//용어집 한글/영어 전체 클릭
$(document).on("click", "div#terminologyType a[class^=btnBoard]", function(e){
	$("div.indexGlossary div a[class^=btnBoard]").removeClass("on");
	$(this).addClass("on");
	$.terminology.data.initialPhoneme = $(this).attr("id");
	$.terminologyList.search();
});

//용어집 검색 버튼 클릭
$(document).on("click", "div.listSearch input#searchTerminology", function(e){
	$.terminologyList.search();
});

//서식 검색 버튼 클릭
$(document).on("click", "div.listSearch input#searchBusinessForm", function(e){
	$.businessFormList.search();
});

//like btn 클릭
$(document).on("click", "dd.detailInfo a.myReco", function(){
	$.like.getLikeData();
	return false;
});

//더보기(20건씩 조회)
$(document).on("click", "a.listMore", function(){
	if($(this).attr("id") == "resourceListMore")
	{
		$.resource.data.page++;
		$.list.getSearchData();
	}
	else if($(this).attr("id") == "businessListMore")
	{
		$.businessForm.data.page++;
		$.businessFormList.getSearchData();
	}
	else if($(this).attr("id") == "terminologyListMore")
	{
		$.terminology.data.page++;
		$.terminologyList.getSearchData();
	}
	
});

//나의 자료실 편집 버튼 클릭
$(document).on("click", "div.listType div.listL a#editMyList", function(){
	$("li#editMyResource").show();
	$("li#uneditMyResource").hide();
	$("#bottomListType").show();
	$("div.photoList").addClass("editList");
	/*$("a.listCont").before("<p class='check'><input type='checkbox' id='listCheck0"+ $("p.check").find("input").index("input") +"' title='${resourceData} 선택'></p>");
	$("a.listCont").wrap("<label for='listCheck0"+ $("ul#resourceListStart").find("label.listCont").index() +"' class='listCont'>");
	$("strong#resourceTitle").unwrap("a.listCont");*/
	$("a#selectAll, a#delete, a#editEnd").show();
	$("a#editMyList, select#sortResourceType, select#sortType").hide();
});

//나의 자료실 선택삭제 버튼 클릭
$(document).on("click", "a#delete", function(){
	var chkValue = new Array();
	$("p.check input:checkbox[id^=listCheck]:checked").each(function(){
		chkValue.push($(this).attr("data-id"));
	});

	if(chkValue.length > 0)
		{
			if(confirm(chkValue.length+"개의 자료를 나의 자료실에서 삭제하시겠습니까?"))
			{
				$.delMyResource.setData(chkValue);
			}
		}
	
});

//나의 자료실 편집완료 버튼 클릭
$(document).on("click", "div.listType a#editEnd", function(){
	$("#bottomListType").hide();
	$("div.photoList").removeClass("editList");
	$("li#editMyResource").hide();
	$("li#uneditMyResource").show();
	/*$("p.check").remove();
	$("div.photoList").removeClass("editList");
	$("label.listCont").wrap("<a href='${resourceData.linkUrl}' class='listCont' data-categoryCode='${resourceSearchForm.categoryCode}' data-id='${resourceData.id}' data-sortResourceType='${resourceSearchForm.sortResourceType}' data-sortType='${resourceSearchForm.sortType}' data-searchVal='${resourceSearchForm.searchVal}'>");
	$("strong#resourceTitle").unwrap("label.listCont");*/
	$("a#selectAll, a#delete, a#editEnd").hide();
	$("a#editMyList, select#sortResourceType, select#sortType").show();
});

//나의 자료실 전체선택 클릭
$(document).on("click", "a#selectAll", function(){
	
	var chkObjs = $("p.check input[id^='listCheck']");
	
	if (chkObjs.length == $("p.check input[id^='listCheck']:checked").length)
	{
		$("a#selectAll").removeClass("on");
		chkObjs.prop("checked", false);
		$("a#selectAll > span").remove();
		$("p.check input").each(function() {
			$(this).parent().parent().removeClass("bg");
		});
	}
	else
	{
		$("a#selectAll").addClass("on");
		chkObjs.prop("checked", true);
		$("a#selectAll").append("<span class='hide'>현재 선택</span>");
		$("p.check input").each(function() {
			$(this).parent().parent().addClass("bg");
		});
	}
});


//나의 자료실 선택 시 class=bg 추가
$(document).on("click", "p.check input", function(){
	var chkObjs = $("p.check input[id^='listCheck']");
	
	if($(this).parent().parent().hasClass("bg"))
		{
			$(this).parent().parent().removeClass("bg");
			if (chkObjs.length != $("p.check input[id^='listCheck']:checked").length)
				{
					$("a#selectAll").removeClass("on");
				}
		}
	else
		{
			$(this).parent().parent().addClass("bg");
			if (chkObjs.length == $("p.check input[id^='listCheck']:checked").length)
				{
					$("a#selectAll").addClass("on");
				}
		}
});

//ABO수첩 닫기
$(document).on("click", "a#noteClose", function(){
	window.close();
});

//리스트에서 like btn 클릭 
$(document).on("click", "div.acDataInfo a.myReco", function(){
	$.likeOnList.getLikeData(this);
	return false;
});

//리스트에서 나의 자료실 버튼 클릭
$(document).on("click", "div.acDataInfo a.myData", function(){
	$.setMyResourceOnList.setData(this);
	return false;
});

//나의 자료실 버튼 클릭
$(document).on("click", "dd.detailInfo a.myData", function(){
	$.setMyResource.setData();
	return false;
});

//document.ready
$(document).ready(function(){
	$("div.listL a#selectAll").hide();
	$("div.listL a#delete").hide();
	$("a#editEnd").hide();
	$("#bottomListType").hide();
	if ($("#menu_id").val() != null)
		{
		$.common.setListMore($("#menu_id").val());
		}
	else
		$.common.setListMore();
	$("li#editMyResource").hide();
	
	if($("#res_h_refresh").val() == "Y") {
    	
    	var sort = $("#res_h_sort").val();
    	var resSort = $("#res_h_resSort").val();
    	var page = $("#res_h_page").val();
    	var searchVal = $("#res_h_searchVal").val();
    	
    	// sort
    	$("select#sortType").val(sort);
    	
		// resource sort
		$("select#sortResourceType").val(resSort);
		
		// search val
		$("input.searchVal").val(searchVal);
		
		// page
		$.resource.data.page = page;
		
		$("#resourceSearchForm #isMobile").val("true");
		$("#resourceSearchForm #id").val($("#res_h_id").val() || "");
		
		$.list.search();
    }
	else
		{
		$.common.init();
		}

});