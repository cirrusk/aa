
/////////////            /common/js/sliderTab.js 로 합쳐서 사용.

jQuery(function($){
	// 개인 메인 이벤트 전용
	$('.mainVisualInner > a').on('click', function(e){
		e.preventDefault();
		var divSel = $(this).closest('.mainVisualInner');									//배너 전체 감싸는 영역
		var divWidth = divSel.innerWidth();													//배너의 가로 길이
		var divSlider = $(this).attr('href');												//클릭한 아이디값
		var onSel = $('a.on',divSel).attr('href');											//배너 전체중 현재 on 아이디 값
		var divPre = $(divSlider).siblings('.tab');											//클릭한 아이디값의 같은 레벨 선택
		$(onSel).css('display','block');													//유지
		$(this).addClass('on').siblings('a').removeClass('on');

		var visual1Depth = $(this).attr('href');
		$(visual1Depth).show().addClass('tabon').siblings('.tab').removeClass('tabon');
		if(divSlider == onSel || divPre .is(':animated')){
			return false;
		} else {
			var $thisEl = $(this);
			sliderActive($thisEl,divSel,divWidth,divSlider,onSel,divPre);

		}
	});
	// 개인 메인 스마트라이프  전용
	$('.asideMainSmartInner > a').on('click' ,function(e){
		e.preventDefault();
		var divSel = $(this).parent();														//배너 전체 감싸는 영역
		var divHeight = divSel.innerHeight();												//배너의 높이
		var divSlider = $(this).attr('href');												//클릭한 아이디값
		var onSel = $(divSel).children('a').filter('a.on').attr('href');					//배너 전체중 현재 on 아이디 값
		var divPre = $(divSlider).siblings('ul');											//클릭한 아이디값의 같은 레벨 선택

		$(onSel).css('display','block');													//유지
		var visual1Depth = $(this).attr('href');
		$(visual1Depth).show().addClass('ulOn').siblings('ul').removeClass('ulOn');

		if(divSlider == onSel || divPre .is(':animated')){
			return false;
		} else {
			$(this).addClass('on').siblings('a').removeClass('on');

			var $thisEl = $(this);
			sliderActive2($thisEl,divSel,divHeight,divSlider,onSel,divPre);
		}
	});
	// 슬라이드 공용
	$('.innerBox > a').on('click' ,function(e){
		e.preventDefault();
		var divSel = $(this).closest('.tab');												//배너 전체 감싸는 영역
		var divWidth = divSel.innerWidth();													//배너의 가로 길이
		var divSlider = $(this).attr('href');												//클릭한 아이디값
		var onSel = $('.innerBox.on > a',divSel).attr('href');								//배너 전체중 현재 on 아이디 값
		var divPre = $(divSlider).closest('.innerBox').siblings().children('.imgBox');		//클릭한 아이디값의 같은 레벨 선택

		$(onSel).css('display','block');													//유지
		if(divSlider == onSel || divPre .is(':animated')){
			return false;
		} else {
			var $thisEl = $(this);
			sliderActive($thisEl,divSel,divWidth,divSlider,onSel,divPre);
		}
	});

	// 좌우 동작
	function sliderActive($thisEl,divSel,divWidth,divSlider,onSel,divPre,auto){
		var sliderA, sliderB;
		if(auto < 0){
			sliderA = divWidth,
			sliderB = '-' + divWidth + 'px';
		}else{
			if(divSlider > onSel){													// <<< move
				sliderA = divWidth,
				sliderB = '-' + divWidth + 'px';
			}else if(divSlider < onSel){											// >>> move
				sliderA = '-' + divWidth + 'px',
				sliderB = divWidth;
			}
		}
		$thisEl.parent().addClass('on').siblings().removeClass('on');
		$(divSlider).show().css('left',sliderA).stop().animate({
			'left' : 0
		},500);
		$('.bg', divSlider).css('left',sliderA).stop().animate({
			'left' : 0
		},700);
		$(onSel).stop().animate({
			'left' : sliderB
		},500,function(){
			$(this).hide().css('left', 0);
		});
	}
	// 상하 동작
	function sliderActive2($thisEl,divSel,divHeight,divSlider,onSel,divPre){
		var sliderA, sliderB;
		if(divSlider > onSel){													// <<< move
			sliderA = divHeight,
			sliderB = '-' + divHeight + 'px';
		}else if(divSlider < onSel){											// >>> move
			sliderA = '-' + divHeight + 'px',
			sliderB = divHeight;
		}
		$thisEl.parent().addClass('on').siblings().removeClass('on');
		$(divSlider).show().css('top',sliderA).stop().animate({
			'top' : 0
		},500,function(){
			$(this).siblings('ul').hide();
		});
		$(onSel).stop().animate({
			'top' : sliderB
		},500,function(){
			$(this).hide().css('top', 0);
		});
	}

	// 메인 배너 컨트롤
	autoPlayM();
	var playBtnM;
	function autoPlayM(){
		playBtnM = setInterval(function(){
			var playIs = $('.tabon').parent().parent().find('.stop').size();
			var nowA = $('.tabon .on > a').attr('href');
			var lastA = $('.tabon .innerBox:last > a').attr('href');

			if(playIs !== 0){
				return false;
			}
			if(nowA == lastA){
				var $thisEl = $('.tabon .innerBox:first > a');
				var auto = '-1';
				var divSel = $($thisEl).closest('.tabon');											//배너 전체 감싸는 영역
				var divWidth = divSel.innerWidth();													//배너의 가로 길이
				var divSlider = $($thisEl).attr('href');											//클릭한 아이디값
				var onSel = $('.innerBox.on > a',divSel).attr('href');								//배너 전체중 현재 on 아이디 값
				var divPre = $(divSlider).closest('.innerBox').siblings().children('.imgBox');		//클릭한 아이디값의 같은 레벨 선택
				$(onSel).css('display','block');													//유지
				sliderActive($thisEl,divSel,divWidth,divSlider,onSel,divPre,auto);
			} else {
				$('.tabon .on').next().find('a').click();
			}
		},5000);
	}
	$('.mainVisual .btnPlay').on('click', function(){
		autoPlayM();
		$(this).parent().removeClass('stop');
		$(this).hide().prev().show();
	});
	$('.mainVisual .btnStop').on('click',function(){
		$(this).parent().addClass('stop');
		clearInterval(playBtnM);
		$(this).hide().next().show().css('display','block');
	});
	// img 마우스 올라갔을때 멈춤과 벗어났을때 움직임
	$('.mainVisual').on('mouseover focus',function(){
		clearInterval(playBtnM);
	}).on('mouseout blur',function(){
		var stopIs = $(this).closest('.tabon').parent();
		if(stopIs.find('.stop').size() == 0){
			autoPlayM();
		}
		return false;
	});

	//$('div[id^="login_"]').hide();
	//$('div[id^="logout_"]').hide();
	$('.asideUserInfo').hide();
	$('.mainEvent').find('h2').show();


	// mainEvent 효과주기
	function mainEventShow(){
		$('.mainEvent h2').animate({left:-90}, {duration: 300});
		$('.mainEventInner').animate({left:0}, {duration: 200});
	}
	function mainEventHide(){
		$('.mainEvent h2').animate({left:32}, {duration: 300});
		$('.mainEventInner').animate({left:-553}, {duration: 200});
	}
	$('.mainEvent h2').find('a').click(mainEventShow).focus(mainEventShow);
	$('.mainEventClose').click(mainEventHide).focus(mainEventHide);

	//S-Branch 효과주기
	function mainSBranchOver(){
		var aH = $(this).height();
		var aT = $(this).position().top;
		$( '.mainSBranchMask' ).animate({top: aT,height:aH}, {duration: 200});
		$(this).animate({left:-145}, {duration: 300});
	}
	function mainSBranchOut(){
		$(this).animate({left:0}, {duration: 150});
	}
	function mainSbranceLeave(){
		$( '.mainSBranchMask' ).animate({top:0}, {duration: 150});
	}
	$('.mainSBranchInner').find('a').mouseenter(mainSBranchOver).mouseout(mainSBranchOut);
	$('.mainSBranchInner').mouseleave(mainSbranceLeave);


	// asideMainCard 효과주기
	function asideMainCardEffect(){
		var clickClass = $(this).attr("class");
		var divH = 150;
		var divT = 25;
		$('.asideMainCard h3').removeAttr("class");
		$('.asideMainCard h3').addClass(''+clickClass+'');
		if(clickClass =='menu01'){
			$('.asideMainCard').find('.menu01Div').animate({top:divT}, {duration: 400});
			$('.asideMainCard').find('.menu02Div').animate({top:divH+divT}, {duration: 400});
			$('.asideMainCard').find('.menu03Div').animate({top:(divH*2)+divT}, {duration: 400});
		}else if(clickClass =='menu02'){
			$('.asideMainCard').find('.menu01Div').animate({top:-(divH-divT)}, {duration: 400});
			$('.asideMainCard').find('.menu02Div').animate({top:divT}, {duration: 400});
			$('.asideMainCard').find('.menu03Div').animate({top:divH+divT}, {duration: 400});
		}else if(clickClass =='menu03'){
			$('.asideMainCard').find('.menu01Div').animate({top:-((divH*2)-divT)}, {duration: 400});
			$('.asideMainCard').find('.menu02Div').animate({top:-(divH-divT)}, {duration: 400});
			$('.asideMainCard').find('.menu03Div').animate({top:divT}, {duration: 400});
		}
		return false;
	}
	$('.asideMainCard').find('a[class^="menu0"]').click(asideMainCardEffect).focus(asideMainCardEffect);

});