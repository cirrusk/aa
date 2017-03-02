(function($) {
	$.message = {
		init : function(){
			//Detail에서 목록으로 돌아간 후 focus
			if( $("#searchForm #id").val() ){
				$("ul").find("a[data-id='"+$("#searchForm #id").val()+"']").focus();
			}
			//리스트 3줄 넘어가는 경우 말줄임 표시
			if($(".myMessage ul li a").length){
				$.comm.myMessage.styles($(".myMessage ul li a").find("p:last"));
			}
			$.message.data.page = ($("#searchForm #page").val() || 1) ; // 페이지 세팅
			$.message.data.isSeeMore = ( Number($("#searchForm #totPage").val()) || 1 ) > (Number($.message.data.page) || 1) ? "true" : "false"; // 더 보기 정보 세팅
			$.message.setSeeMore(); // 더 보기 적용
			$.message.data.sort = $("#searchForm #read").val(); // sorting 정보 세팅
			$("#sorting").find("option[value='"+$.message.data.sort+"']").attr("selected", "selected"); //selectBox에 소팅정보 일치 시킴
		},
		util : {
			mapping : function(){
				$.message.data.id         = $.message.data.id         	|| "";
				$.message.data.page       = $.message.data.page 		|| 1;
				$.message.data.prePage    = $.message.data.prePage 		|| "list";
				$.message.data.eraseIds   = $.message.data.eraseIds 	|| new Array();
				$.message.data.erasePlace = $.message.data.erasePlace 	|| "list";
				$.message.data.searchVal  = $.message.data.searchVal 	|| "";
				$.message.data.sort		  = $.message.data.sort			|| null;

				$.each($.message.data, function(key, value){
					$("#searchForm").find("#" + key).val(value);
				});
			}
		},
		page : {
			list     : "/mypage/message/list",
			listAjax : "/mypage/message/ajax/search",
			detail   : "/mypage/message/detail",
			del      : "/mypage/message/erase"
		},
		data : {
			page       : 1
		  , searchVal  : ""
		  , eraseIds   : new Array()  
		  , erasePlace : "list"
		  , prePage    : "list"	 
		  , id         : null 
		  , isSeeMore  : ""
		  , sort	   : null
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
						alert($.getMsg($.msg.err.system));
					}
					return false;
				}
			});				
		},		
		list :{
			search : function(){
				var searchVal = $.trim($("#searchVal").val());
				if(searchVal.length <= 0){
					alert($.getMsg($.msg.personalinfo.common.enterRequired, "검색어"));
					$("#searchVal").focus();
					return false;
				}
				
				if(searchVal.length <= 1){
					alert($.getMsg($.msg.common.minSearchText, "2"));
					$("#searchVal").focus();
					return false;
				}
				
				$.message.data.page = 1;
				$.message.data.searchVal  = searchVal;
				$.message.data.sort = $("#sorting option:selected").val();
				$.message.list.searchPage($.message.data);
			},
			sorting : function(){
				$.message.data.page = 1;
				$.message.data.sort = $("#sorting option:selected").val();
				
				$.message.list.searchPage($.message.data);
			},
			// 리스트 조회
			searchPage : function(data){
				$("#searchForm #page").val(data.page || "1");
				$("#searchForm #searchVal").val(data.searchVal || "");
				$("#searchForm #read").val(data.sort || null);

				$.message.callAjax("POST", $.message.page.listAjax, "html", "#searchForm", function(data){
					if( (Number($.message.data.page) || 1) > 1){
						$(".myMessage ul").append(data);
					}else{
						$(".myMessage ul").html(data);
					}
					$("#searchVal").blur();
					$.message.setSeeMore();
				}, null);
			},
			// 목록으로 돌아가기
			returnList : function(){
				$("#searchForm").attr("action", $.message.page.list);
				$("#searchForm").submit();
			}
		},
		detail :{
			pageMove : function(data){
				$("#searchForm #id").val(data.id);
				$("#searchForm #prePage").val(data.prePage);

				$("#searchForm #page").val(data.page || "1");
				$("#searchForm #searchType").val(data.searchType || "all"); 
				$("#searchForm #searchVal").val(data.searchVal || "");
				
				$("#searchForm").attr("action", $.message.page.detail);
				$("#searchForm").submit();
			}
		},
		// 메시지 삭제
		del : function(){
			$.message.util.mapping();
			$("#searchForm").attr("action", $.message.page.del);
			$("#searchForm").submit();
		},
		setSeeMore : function(){
			if($.message.data.isSeeMore == "false"){
				$("#btnSeeMore").hide();
			}else{
				$("#btnSeeMore").show();
			}
		}
	}
})(jQuery);

$(document).on("change", "#sorting", function(){
	$.message.list.sorting();
});

//다음 20개
$(document).on("click", "a#btnSeeMore", function(){
	$.message.data.page = Number($.message.data.page || 1) + 1;
	
	$.message.data.searchVal  = $("#searchForm #searchVal").val();
	$.message.data.sort = $("#searchForm #read").val();
	
	$.message.list.searchPage($.message.data);
});

// list 검색
$(document).on("click", "#searchBtn", function(){
	$.message.list.search();
})

// list 검색
$(document).on("keydown", "#searchVal", function(e){
	if(e.which == 13){
		$.message.list.search();
	}
});


// 메시지 삭제
$(document).on("click", "#messageDelBtn", function(e){

	var place = $(this).data("place");
	
	if(confirm($.msg.message.confirmDelete) == false){
		return;
	}
	$.message.data.id = $(this).data("id");
	$.message.data.eraseIds.push($(this).data("id"));

	$.message.data.prePage = $("#searchForm").find("#prePage").val() || "list";
	$.message.data.erasePlace = place;
	$.message.del();
});

//공지사항 게시물 조회
$(document).on("click", "a[class^='messageItem']", function(e){
	e.preventDefault();
	
	$.message.data.id = $(this).data("id");
	$.message.data.prePage = $(this).data("page");
	
	$.message.detail.pageMove($.message.data);
});

// 목록으로 돌아가기
$(document).on("click", "#returnListBtn", function(e){
	e.preventDefault();
	$.message.list.returnList();
});


$(document).ready(function(){
	$.message.init();
		
});

