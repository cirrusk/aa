(function($) {
	$.plaza = {
		data : {
			tempSelVal : "",
		},
		setting : function(){
			//선택된 값
			var obj = $("#selectStore option:selected").val();
			
			//title
			var plazaNm = $("#selectStore option:selected").text();
			if('AP-Bundang-ABC-02' == obj){
				plazaNm += " (암웨이 브랜드 체험센터)";
			}else{
				plazaNm += " 암웨이 플라자";
			}
			$("#plazaTitle").text(plazaNm);
			
			//선택되지 않은 영역 숨김
			if($.plaza.data.temSelVal){
				$("."+$.plaza.data.temSelVal).hide();
			}
			
			$("."+obj).show(); //선택한 암웨이 플라자 정보 보이기
			$.touchSlider($("."+obj+" .touchSlider").attr("id")); // 썸네일 이미지 touchSlider
			
			$.storefinder.drawMap($("."+obj).find(".map_canvas").attr("id")); // 구글 map 그리기
			
			//선택했었던 값 저장
			$.plaza.data.temSelVal = obj;
		}

	},
	$.storefinder = { //구글 맵 설정
		drawMap: function(id){
			var $e=$("#"+id);
			var position = new google.maps.LatLng($e.data("latitude"), $e.data("longitude"));
			var mapOptions = {
				zoom: 16,
				zoomControl: true,
				panControl: true,
				streetViewControl: false,
				mapTypeId: google.maps.MapTypeId.ROADMAP,
				center: position
			}
			var renderMap = new google.maps.Map(document.getElementById(id), mapOptions);
			
			var marker = new google.maps.Marker({
				position: position
				,map: renderMap
			});
		}
	},
	$.touchSlider = function(id){
		var touchSliderId = $("#"+id);
		var sliderLi= $(touchSliderId).find('li');
		var pagingTarget = touchSliderId.parent().find('.sliderPaging');
		var counterTarget = touchSliderId.parent().find('.sliderCount');
		var sliderLiNum = sliderLi.length;

		if (sliderLiNum > 1){
			if($('.touchSliderWrap .btnPrev, .touchSliderWrap .btnNext').length){
				$('.touchSliderWrap .btnPrev, .touchSliderWrap .btnNext').show();
			}
		}

		$(touchSliderId).touchSlider({
			flexible : true,
			btn_prev : touchSliderId.parent().find(".btnPrev"),
			btn_next : touchSliderId.parent().find(".btnNext"),
			initComplete : function (e) {
				pagingTarget.html("");
				var num = 1;
				sliderLi.each(function (i, el) {
					var altTxt = $(this).find('img').attr('alt');
					if((i+1) % e._view == 0) {
						var pagingType = pagingTarget.attr('class');
						if(pagingType == 'sliderPaging colorG'){
							//alert('그린');
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slideg_off.png" alt="' + altTxt + '"></a>');
						}else	if(pagingType == 'sliderPaging colorR'){
							//alert('레드');
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slide_off.png" alt="' + altTxt + '"></a>');
						}else {
							//alert('블루');
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slideb_off.png" alt="' + altTxt + '"></a>');
						}
					}
				});
				pagingTarget.find('.btnPage').bind("click", function (e) {
					var i = $(this).index();
					touchSliderId.get(0).go_page(i);
				});
			},
			counter : function (e) {
				pagingTarget.find('.btnPage').removeClass("on").eq(e.current-1).addClass("on");
				pagingTarget.find('.btnPage').each(function(){
					if($(this).hasClass('on') == true){
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_off.png").join("_on.png"));
					}else {
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_on.png").join("_off.png"));
					}
				});
				if (!$('.sliderCount').length) return;
				$(".currentP").html(e.current);
				$(".totalP").html(e.total);
				$("#countSel").val(e.current).attr("selected", "selected");
			}
		});
	}
})(jQuery);

var selectedVal; 

$(document).on("change", "#selectStore", function(){
	$.plaza.setting();
});

$(document).ready(function (){
	
	if($("div#brandCenterMap").length){
		$.storefinder.drawMap("brandCenterMap");
	}
	
	if($("div.mapArea").length > 1){
		$.plaza.setting();
	}
});

