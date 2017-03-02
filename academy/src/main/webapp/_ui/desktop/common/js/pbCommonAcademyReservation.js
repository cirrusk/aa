/**
 * 이하 ECM 1.5 에서 추가한 코드
 */
jQuery(function($){
	
	//교육장 예약 아코디언 스텝
	bizEduPlace();
	
	//닫기버튼 있는 툴팁
	if ($('.tag.closeBtnType').length){
		var $tagLayer = $('.tag.closeBtnType');
	
		$tagLayer.each(function(){
			/* 0527 닫기기능 삭제
			var $layerCloseBtn = $(this).find('.btnCloseTip');
			$layerCloseBtn.click(function(){
				$(this).parents('.withCloseTip').hide();
				return false;
			});*/
		
			$(this).mouseover(function(){
				if($(this).find('.withCloseTip').is(':hidden')){
					$(this).find('.withCloseTip').show();
				}
			}).mouseleave(function(){
				if($(this).find('.withCloseTip').is(':visible')){
					$(this).find('.withCloseTip').hide();
				}
			}).click(function(e){
				e.preventDefault();
			})
		});
	}

	//시설예약 현황확인 목록-캘린더형 보기
	if($('.bizroomStateBox .viewWrapper').length){
		
		//목록형-캘린더형 보기형식 토글
		$('.bizroomStateBox .viewWrapper').hide();
		var switchBTN = $('.viewTypeSet').find('>a');
		var currentMenu = $('.viewTypeSet').find('>a.on').attr('href');
		$(currentMenu).show();
		
		$(switchBTN).click(function(e){
			e.preventDefault();
			var cliked = $(this).attr('href');
			
			$(this).addClass('on').siblings().removeClass('on');
			$(this).parents().find('.viewWrapper').hide();
			$(this).parents().find(cliked).show();
		});
	}
	
	//아카데미 상세보기-간략보기 토글
	if($('.toggleViewBox').length){
		
		$('.toggleViewBox .viewWrapper').hide();
		var switchBTN = $('.viewTypeSet').find('>a');
		var currentMenu = $('.viewTypeSet').find('>a.on').attr('href');
		$(currentMenu).show();
		
		$(switchBTN).click(function(e){
			e.preventDefault();
			var cliked = $(this).attr('href');
			
			$(this).addClass('on').siblings().removeClass('on');
			$(this).parents().find('.viewWrapper').hide();
			$(this).parents().find(cliked).show();
		});
	}

	//브랜드체험 프로그램 선택 탭
	if ($('.programWrap').length){
		
		//브랜드 메뉴 목록
		$('.programWrap .programList > a').click(function() {
			$(this).next('ul').toggle();
			return false;
		});
		 
		$('.programWrap .programList > ul > li').click(function(e) {
			e.preventDefault();
			
			var $this = $(this);
			var $prgGroup = $this.children('a');
			var $prgCont = $this.parent().siblings('.programCont');
			var prgGroupId = $prgGroup.attr('href').slice(1);
			
			$this.parent().hide().parent('.programList').children('a').text($this.text());
			$prgCont.hide();
			$('div[id='+prgGroupId+']').show();
		});
		
		var $groupTap = $('.programWrap .brselectArea > a');
		$groupTap.each(function(){		
			$(this).click(function(){
				if($groupTap.parents().find('a').hasClass('on')){
					$groupTap.parents().find('a').removeClass('on');
				}
				$(this).addClass('on');
				
				var groupId = $(this).attr('href').slice(1);
				$('.programListWrap').hide();			
				$('div[id='+groupId+']').show();			
				
				return false;
			});
		});
		
		var $programWrapList = $('.programListWrap > .programImg a');
		$programWrapList.each(function(){
			var $this = $(this);			
			$this.click(function(){
				if($this.siblings('a').hasClass('active')){
					$this.siblings('a').removeClass('active');
				}
				$this.addClass('active');
				
				var $brandConId = $this.attr('href').slice(1);
				$this.parents('.programListWrap').find('dl.prgSection').hide();		
				$('dl[id='+$brandConId+']').show();
				
				return false;
			});
		});
	}
	
	//브랜드체험 프로그램 토글
//	if ($('.programList').length){
//		var $acc_dt = $('.programList > dt > a');
//		$acc_dt.click(function(){
//			var $this = $(this);
//			$this.parents('.programList').find('.active').removeClass('active');
//			$this.parent().addClass('active');
//			$this.parent().next('dd').addClass('active').attr('tabindex','0');
//		});
//	}else{
//		var $acc_dt = $('.programList > dt > a');
//		$acc_dt.click(function(){
//			var $this = $(this);
//			$this.parent().removeClass('active');
//			$this.parent().next('dd').removeClass('active');
//		});
//	}
	
	//프로그램 선택 체크시 준비물 보이기
	if ($('.tblProgram').length){
		var $input = $('.tblProgram').find(':checkbox');
		
		$input.each(function() {
			$input.click(function(){
				if($(this).is(":checked")){	
					$(this).parents('tr').find('td .prepare').css('display','block');
					$(this).parents('tr').addClass('select');
				}else{ 
					$(this).parents('tr').find('td .prepare').css('display','none');
					$(this).parents('tr').removeClass('select');
				}
			});
		})
	}
	//(문화체험)프로그램 선택 체크시 준비물 보이기
	if ($('.programList').length){
		var $input = $('.programList dt').find(':checkbox');
		
		$input.each(function() {
			$input.click(function(){
				if($(this).is(":checked")){	
					$(this).parents('dt').find('.prepare').css('display','block');
				}else{ 
					$(this).parents('dt').find('.prepare').css('display','none');
				}
			});
		})
	}
	
	//sns공유 펼치고 닫기
	if ($('.snsZone .snsLink').length){
		
		$('.share').each(function(){
			$(this).click(function(e){
				e.preventDefault();
				var t = $(this), snsLink = $(this).parent().find('.snsLink');

				t.toggleClass('on');
				if(t.hasClass('on')){
					snsLink.css("overflow","visible").stop().animate({width:"161px"}, 100);
				} else {
					snsLink.css("overflow","hidden").stop().animate({width:"0"}, 0);
				}
			});
		});
	}
});

/* 교육장 예약 아코디언 스텝 */
function bizEduPlace(){
	if (!$('.brWrap').length) return;
	
	//스텝1
	$('#step1 .sectionWrap > section').hide();
	$('#step1 .sectionWrap > section').eq(0).show();
	//지역선택
	$('.brselectArea.local>a').each(function(){
		$(this).click(function(){
			$(this).parent().parent().next().slideDown();
		})
	});
	//룸선택
	$('.brselectArea.room a').each(function(){
		$(this).click(function(){
			$(this).parents('.brSelectWrap').next().slideDown(function(){
				touchsliderFn();
			});
		})
	});
	
	var stepButton = $('.stepBtn');
	var prevButton = $('.btnWrapR > .btnBasicGS');
	var currntButton = $('.brWrap > .modifyBtn');

	//다음 버튼 클릭 시
	$(stepButton).each(function(){
		$(this).click(function(){
			stepClose.call(this);
			stepOpen.call(this, 'next');
		});
	});
	//이전 버튼 클릭 시
	$(prevButton).each(function(){
		$(this).click(function(){
			stepClose.call(this);
			stepOpen.call(this, 'prev');
			
			/* ul li(each) */
			$("#touchSlider").find("ul").css("height", "148px");
			$("#touchSlider").find("li").each(function() {
				$(this).css("height", "148px");
			});
		});
	});
	//화살표 버튼 클릭 시
	$(currntButton).each(function(){
		$(this).click(function(){
			stepClose.call(this);
			stepOpen.call(this, 'currnt');
		});
	});
	
	//현재 스텝 닫기
	function stepClose(){
		var $brWrap = $(this).parents('.brWrap');
		var stepTit = $brWrap.find('.stepTit');
		var result = $brWrap.find('.result');
		
		//활성화 된 상태
		$brWrap.find('.sectionWrap').stop().slideUp(function(){
			$brWrap.find(stepTit).find('.close').show();
			$brWrap.find(stepTit).find('.open').hide();
			
			$brWrap.find('.modifyBtn').show();
			$brWrap.find('.req').show(); //결과값 보기
			$brWrap.removeClass('current').addClass('finish');
		});
	}
	
	//스텝 열기
	function stepOpen(param){
		if(param == 'next'){
			var $brWrap = $(this).parents('.brWrap').next();
		}else if(param == 'prev'){
			var $brWrap = $(this).parents('.brWrap').prev();
		}else if(param == 'currnt'){
			var $brWrap = $(this).parents('.brWrap');
		}
		var stepTit = $brWrap.find('.stepTit');
		
		$brWrap.find('.modifyBtn').hide();
		$brWrap.find('.result').hide();
		$brWrap.find('.sectionWrap').stop().slideDown(function(){
			$brWrap.find(stepTit).find('.close').hide();
			$brWrap.find(stepTit).find('.open').show();
			$brWrap.removeClass('finish').addClass('current');
		});
	}
	
}

//터치슬라이더
function touchsliderFn(){
	
	if($("#touchSlider").length){
		var touchSliderId = $("#touchSlider");
		var sliderLi= $(touchSliderId).find('li');
		var pagingTarget = touchSliderId.parent().find('.sliderPaging');
		var counterTarget = touchSliderId.parent().find('.sliderCount');
		var sliderLiNum = sliderLi.length;
	
		if (sliderLiNum > 1){
			if($('.touchSliderWrap .btnPrev, .touchSliderWrap .btnNext').length){
				$('.touchSliderWrap .btnPrev, .touchSliderWrap .btnNext').show();
			}
		}
	
		if($('.sliderCount').length){
			for(i = 1; i <= sliderLi.length; i++ ){
				var txt = '페이지';
				var addOpt = document.createElement('option');
				addOpt.value = i;
				addOpt.appendChild(document.createTextNode(i + txt));
				$("#countSel").append(addOpt);
	
			}
		}
	
		if($('.touchSliderWrap .btnStopPlay').length){
			var sliderLiNum = sliderLi.length;
			var resultL = ((sliderLiNum-1)*16+40)/2;
			$('.touchSliderWrap .btnStopPlay').css("margin-left",""+resultL+"px");
			$('.touchSliderWrap .btnStopPlay').click(function(e) {
				e.preventDefault();
				if($(this).hasClass('.play') == true){
					$(this).find('img').attr('src',$(this).find('img').attr("src").split("_play.gif").join("_stop.gif"));
					$(this).removeClass('.play');
				}else {
					$(this).find('img').attr('src',$(this).find('img').attr("src").split("_stop.gif").join("_play.gif"));
					$(this).addClass('.play');
				}
			});
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
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/desktop/images/academy/btn_slide_off.png" alt="' + altTxt + '"></a>');
						}else	if(pagingType == 'sliderPaging colorR'){
							//alert('레드');
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/desktop/images/academy/btn_slide_off.png" alt="' + altTxt + '"></a>');
						}else {
							//alert('블루');
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/desktop/images/academy/btn_slideb_off.png" alt="' + altTxt + '"></a>');
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
	
		// 슬라이드 목록 1개일때 touch & drag 비활성
		if (sliderLiNum == 1){
			$(touchSliderId)
				.unbind("touchmove", this.touchmove)
				.unbind("touchend", this.touchend)
				.unbind("dragstart", this.touchstart)
				.unbind("drag", this.touchmove)
				.unbind("dragend", this.touchend)
		}
		
		/* ul li(each) */
		$("#touchSlider").find("ul").css("height", "148px");
		$("#touchSlider").find("li").each(function() {
			$(this).css("height", "148px");
		});
	}
}
