(function($) {
	$.autocomplete = {
		data : {
			isAutoSearch : true
		},
		search : function(term) {
			if(!this.validation(term)) {
				return false;	
			}
			
			var url = "/search/ajax/autocomplete?term=" + encodeURIComponent(term);
			$.get(url, function(data) {
				if(data.suggestions != null && data.suggestions.length > 0){
					$.autocomplete.render(data, term);
				} else {
					$('.searchAutoWrap .hotText, .searchAutoWrap .myText, .searchAutoWrap .searchClose').css({ 'display':'none'});
					$('.searchAutoWrap .newPromotion, .searchAutoWrap .autoText').css({ 'display':'none'});
					$('.headTop ').css({ 'height': "45px"});
				}
			});
		},
		render : function(data, term) {
			var renderHtml = "";

			if(data.suggestions.length > 0) {
				$.each(data.suggestions, function(i, obj) {
					renderHtml += '<a href="/search?text='+ encodeURIComponent(obj["term"]) +'&sl=1">' + $.autocomplete.highlight(obj["term"], term) + '</a>';
				});
				$(".searchAutoWrap .autoText").empty();
				$(".searchAutoWrap .autoText").append(renderHtml);

				var inputVal = $('.unitedSearch input[type=text]').val();
				var promotionH = $('.searchAutoWrap .newPromotion').outerHeight();
				var autoH = $('.searchAutoWrap .autoText').outerHeight();
				var hotH = $('.searchAutoWrap .hotText').outerHeight();
				var myH = $('.searchAutoWrap .myText').outerHeight();
				var closeH = $('.searchAutoWrap .searchClose').outerHeight();

				$('.unitedSearch').css({ 'margin':'0'});
				$('.searchAutoWrap').css({ 'margin':'0'});
				$('.unitedSearch .btnSearch').css({ 'right':'1px'});
				$('.btnReset ').css({'display':'block'});

				$('.searchAutoWrap .hotText, .searchAutoWrap .myText, .searchAutoWrap .searchClose').css({ 'display':'none'});
				var searchPos = promotionH+autoH+ 45;
				$('.searchAutoWrap .newPromotion, .searchAutoWrap .autoText').css({ 'display':'block'});
				$('.headTop ').css({ 'height':searchPos});
			}
		},
		highlight : function(name, term) {
			var arrText = term.split(" ");
			for(var text in arrText) {
				name = name.replace(arrText[text], "<strong>" + arrText[text] + "</strong>");
			}
			return name;
		},
		validation : function(term) {
			if(this.data.isAutoSearch == false) {
				return false;	
			}
			// TODO 완성형 한글문자가 아닌 경우 조회하지 않도록 수정필요.
			return true;
		},
		mySearchText : {
			create : function() {
				var renderHtml = "";
				var mySearchText = this.get();
				if(mySearchText != null) {
					var arrMySearchText = mySearchText.split(",");
					$.each(arrMySearchText, function(i, text) {
						if(text.length <= 0)
							return true;
						
						if(i == 15)
							return false;

						// xss replace
						text = text.replace(/\</g, "&lt;").replace(/\>/g, "&gt;")
						text = text.replace(/\(/g, "&#40;").replace(/\)/g, "&#41;");
						text = text.replace(/\"/g, "&#34;").replace(/\'/g, "&#39;");
						
						renderHtml += '<a href="/search?text='+ encodeURIComponent(text) +'&sl=1">' + text + '</a>';						
					});
					$(".searchAutoWrap .myText > a").empty();
					$(".searchAutoWrap .myText").append(renderHtml);	
				}
			},
			add : function(text) {
				// xss replace
				text = text.replace(/\</g, "&lt;").replace(/\>/g, "&gt;")
				text = text.replace(/\(/g, "&#40;").replace(/\)/g, "&#41;");
				text = text.replace(/\"/g, "&#34;").replace(/\'/g, "&#39;");

				var mySearchText = $.cookie("mySearchText") || "";
				var arrMySearchText = mySearchText.split(",");
				var index = $.inArray(text, arrMySearchText);
				
				if(index == -1) {
					arrMySearchText.unshift(text);
				} else {
					arrMySearchText.splice(index, 1);
					arrMySearchText.unshift(text);
				}
				// 저장 15개로 제한하도록 수정
				arrMySearchText.length = 15;
				
				$.cookie("mySearchText", arrMySearchText.join(), {expires:7,path:'/'});
			},
			get : function() {
				return $.cookie("mySearchText");
			},
			remove : function() {
				$.cookie("mySearchText", null);
				$(".searchAutoWrap .myText > a").empty();
			}
		}
	};	
})(jQuery);

$(document).ready(function(){
	// firefox 한글 keyup적용
	new beta.fix(".unitedSearch input[type=text]");
	
	// 나의 검색어 생성
	$.autocomplete.mySearchText.create();

	// 검색시 나의 검색어 추가
	$(".unitedSearch form").submit(function () {
		var $text = $(this).find("input[type=text]");
		var value = $.trim($text.val());
		if(value.length <= 0) {
			alert("검색어를 입력하세요.");
			$text.focus();
			$text.click();
			return false;
		}
		$.autocomplete.mySearchText.add(value);
	});

	// 자동완성 목록 선택시 나의 검색어 추가
	$(document).on("click", ".searchAutoWrap .myText > a", function(){
		var value = $(this).text();
		if(value.length > 0) {
			$.autocomplete.mySearchText.add(value);	
		}		
	});

	// 나의 검색어 삭제
	$(document).on("click", ".searchAutoWrap .searchOption .uiMyTextDel", function(){
		if(confirm("나의 검색어를 삭제하시겠습니까?")) {
			$.autocomplete.mySearchText.remove();
			$(".searchAutoWrap").hide();
			alert("나의 검색어가 삭제되었습니다.");
		}	
	});

	var $commonSearchInput = $('.unitedSearch input[type=text]');
	var lastCommonTerm = "";
	$commonSearchInput.on('focus',function(){
		lastCommonTerm = "";
		$commonSearchInput.keyup();
	});
	
	// 검색어 입력시 
	$commonSearchInput.on('keyup',function(){
		// 자동완성 미사용시 return
		if($.autocomplete.data.isAutoSearch == false) {
			return false;	
		}
		var term = $(this).val();

		if(term != null && term.length > 0 && lastCommonTerm == term) {
			return false;
		}
		lastCommonTerm = term;
		
		if(term != null && term.length > 0) {
			$.autocomplete.search(term);
		} else {
			var inputVal = $('.unitedSearch input[type=text]').val();
			var promotionH = $('.searchAutoWrap .newPromotion').outerHeight();
			var autoH = $('.searchAutoWrap .autoText').outerHeight();
			var hotH = $('.searchAutoWrap .hotText').outerHeight();
			var myH = $('.searchAutoWrap .myText').outerHeight();
			var closeH = $('.searchAutoWrap .searchClose').outerHeight();

			$('.unitedSearch').css({ 'margin':'0'});
			$('.searchAutoWrap').css({ 'margin':'0'});
			$('.unitedSearch .btnSearch').css({ 'right':'1px'});
			$('.btnReset ').css({'display':'block'});
			
			// 입력 Text가 없으면
			$('.searchAutoWrap .newPromotion, .searchAutoWrap .autoText').css({ 'display':'none'});
			var searchPos = hotH+myH+closeH+45;
			$('.searchAutoWrap .hotText, .searchAutoWrap .myText, .searchAutoWrap .searchClose').css({ 'display':'block'});
			$('.headTop ').css({ 'height':searchPos});
		}
	});
});