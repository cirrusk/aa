
/**
 * 이하 ECM 1.5 에서 추가한 코드
 */
jQuery(function($){

	/* 토글 */
	//교육장 안내글 토글
/*	if($('.brIntro').length){
		$('.brIntro h2> a').click(function(e) {
			e.preventDefault();
			if($(this).parent().hasClass('on') == true){
				$(this).parent().removeClass('on');
				$(this).attr("title","자세히보기 열기");
				$('.toggleDetail').hide();
			}else {
				$(this).parent().addClass('on');
				$(this).attr("title","자세히보기 닫기");
				$('.toggleDetail').show();
			}
		});
	}*/
	 
	//토글 있을때
	/*if($('.toggleBox').length){
		$('.toggleBox .tggTit a').click(function(e) {
			e.preventDefault();
			if($(this).parent().parent().hasClass('on') == true){
				$(this).parent().parent().removeClass('on');
				$(this).attr("title","자세히보기 열기");
			}else {
				$(this).parent().parent().addClass('on');
				$(this).attr("title","자세히보기 닫기");
			}
		});
	}*/
	
	//정규과정 신청 스텝
	if($('.eduStep').length){
		$('.eduStep > dt a').click(function(e) {
			e.preventDefault();
			if($(this).hasClass('on') == true){
				$(this).removeClass('on');
				$(this).attr("title","자세히보기 열기");
				$(this).parent().parent().find('dd').hide();
			}else {
				$(this).addClass('on');
				$(this).attr("title","자세히보기 닫기");
				$(this).parent().parent().find('dd').show();
			}
		});
	}
	
	//logical tab 클릭시 - 확인완료
	$('.tabWrapLogical h2 a').click(function(e) {
		e.preventDefault();
		if($('.tabWrapLogical section').hasClass('on') == true){
			$('.tabWrapLogical section').removeClass('on');
		}
		$(this).parent().parent().addClass('on');
	});
	
	/* 시설예약 현황확인 목록-캘린더형 보기 */
	if($('.bizroomSwitchBox').length){
		
		//목록형-캘린더형 보기형식 토글
		$('.bizroomSwitchBox>section').hide();
		var switchBTN = $('.viewTypeSwitch').find('>a');
		var currentMenu = $('.viewTypeSwitch').find('>a.on').attr('href');
		$(currentMenu).show();
		
		$(switchBTN).click(function(e){
			e.preventDefault();
			var cliked = $(this).attr('href');
			$(this).addClass('on').siblings().removeClass('on');
			$(this).parents('.bizroomSwitchBox').find('>section').hide();
			$(this).parents('.bizroomSwitchBox').find(cliked).show();
		});
	}
	
	/* 교육장 예약 아코디언 스텝 */
	bizEduPlace();
	function bizEduPlace(){
		if (!$('.bizEduPlace').length) return;
		
		var stepWrap = $('.bizEduPlace');
		var stepResult = $('.bizEduPlace').find('.result'); //결과값
		var selectDiv = $('.bizEduPlace').find('.selectDiv'); //펼쳤을때 전체영역
		var selcWrapDt = $('.selcWrap>dt');
		var selcWrapDd = $('.selcWrap>dd');
		var stepButton = $('.btnWrap > .btnBasicBL');
		var prevButton = $('.btnWrap > .btnBasicGL');
		
		stepResult.hide();
		selcWrapDd.hide();
		selcWrapDt.show();
		//selectDiv.eq(0).find(selcWrapDd).show();
		selcWrapDd.eq(0).show();
		
		$('.selectArea.local>a').each(function(){
			$(this).click(function(){
				$(this).parent().parent().next().slideDown();
			})
		});
		$('.selectArea.room>a').each(function(){
			$(this).click(function(){
				$(this).parent().parent().next().slideDown(function(){
					touchsliderFn();
				});
			})
		});
		
		//다음 버튼 클릭 시
		$(stepButton).each(function(){
			$(this).click(function(){
				$(this).parents('.bizEduPlace').removeClass('current');
				$(this).parents('.bizEduPlace').find('.result').show();
				$(this).parents('.bizEduPlace').find('.selectDiv').slideUp();
				
				//다음 섹션열기
				var $nextStep = $(this).parents('.bizEduPlace').next();
				$nextStep.addClass('current').find('.selectDiv').slideDown();
				$nextStep.find(stepResult).hide();
				$nextStep.find(selectDiv).show();
				$nextStep.find(selcWrapDd).show();
			});
		});
		
		//이전 버튼 클릭 시
		$(prevButton).each(function(){
			$(this).click(function(){
				$(this).parents('.bizEduPlace').removeClass('current finish');
				$(this).parents('.bizEduPlace').find(stepResult).hide();
				$(this).parents('.bizEduPlace').find(selcWrapDt).show();
				$(this).parents('.bizEduPlace').find(selcWrapDd).hide();
				$(this).parents('.bizEduPlace').find(selectDiv).show();
				
				//이전 섹션열기
				var $prevStep = $(this).parents('.bizEduPlace').prev();
				$prevStep.removeClass('finish').addClass('current').find('.selectDiv').slideDown();
				$prevStep.find(stepResult).hide();
				$prevStep.find(selectDiv).show();
				$prevStep.find(selcWrapDd).show();
			});
		});
		
		//타이틀 클릭으로 스텝박스 열기
		$(stepResult).click(function(){
			
			//한번 열었던 스텝
			if( stepWrap.is('.finish')){
				//열려있는 스텝 닫기
				stepWrap.siblings().removeClass('current');
				stepWrap.siblings().find(selectDiv).slideUp();
				stepWrap.find('.result').show();
			
				$(this).parent().addClass('current');
				$(this).hide();
				$(this).parent().find('.selectDiv').slideDown();
				
				$('html, body').animate({
					scrollTop: $(this).offset().top
				}, 300);
			}
		});
	}
	
	//브랜드체험 프로그램 탭
	if ($('.programWrap').length){
		var $groupTap = $('.programWrap .selectArea > a');
		$groupTap.each(function(){		
			$(this).click(function(){
				if($groupTap.parents().find('a').hasClass('active')){
					$groupTap.parents().find('a').removeClass('active');
				}
				$(this).addClass('active');
				
				var groupId = $(this).attr('href').slice(1);
				$('.programListWrap').hide();
				$('div[id='+groupId+']').show();
				
				return false;
			});
		});
	}
	
	//브랜드체험 프로그램목록 토글
	if ($('.programList').length){
		var $acc_dt = $('.programList > dt > a');
		$acc_dt.click(function(){
			var $this = $(this);
			$this.parents('.programList').find('.active').removeClass('active');
			$this.parent().addClass('active');
			$this.parent().next('dd').addClass('active').attr('tabindex','0');
		});
	}
	
	//프로그램 선택 체크시 준비물 보이기
	if ($('.tblSession').length){
		var $input = $('.tblSession').find(':checkbox');
		
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
	
	//프로그램 선택 시 세부내용 보이기
	if ($('.programDetailTr').length){
		var $programTitle = $('.tblSession .programTitle > a');
		var $programDetail = $('.programDetailTr');

		$programTitle.click(function(){
			$programDetail.hide();
			$(this).parents('tr').next().show();
		});
	}
	
	//교육비 멤버 아코디언탭
	if($('.articleBox').length){
		$('.articleTit a').click(function(e){
			e.preventDefault();
			if($(this).parent().parent().hasClass('mbOn') == true){
				$(this).parent().parent().removeClass('mbOn');
			}else {
				$(this).parent().parent().addClass('mbOn');
			}
			//return false;
		});
	}
	

	
});	

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
							pagingTarget.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slide_off.png" alt="' + altTxt + '"></a>');
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

		// 슬라이드 목록 1개일때 touch & drag 비활성
		if (sliderLiNum == 1){
			$(touchSliderId)
				.unbind("touchmove", this.touchmove)
				.unbind("touchend", this.touchend)
				.unbind("dragstart", this.touchstart)
				.unbind("drag", this.touchmove)
				.unbind("dragend", this.touchend)
		}
	}
}


