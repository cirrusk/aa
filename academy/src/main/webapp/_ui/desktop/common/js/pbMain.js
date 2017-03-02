jQuery(function($){
	// 메인 새소식 게시판
	sideNoticeFn();
	function sideNoticeFn(){

		if (!$('.sideBoxWrap .noticeCont').length){
			return;
		}

		$('.sideBoxWrap h3:eq(0)').attr('style','margin-left:0');
		$('.sideBoxWrap h3.on').next('.noticeCont').show();
		//$('.noticeCont:eq(0)').show();
		$('.sideBoxWrap h3 a').on('click focus ',function(){
			$('.noticeCont').hide();
			$('.sideBoxWrap h3').removeClass('on');
			$(this).parent().next().show();
			$(this).parent().addClass('on');
			return false;
		})
	}

	// 메인 새소식 게시판 페이징
	sideNoticePage();
	function sideNoticePage(){
		if (!$('.sideBoxWrap .noticeCont .noticePage').length){
			return;
		}
		for(i = 0; i < $('.noticeCont').length ; ++ i ){
			$('.noticeCont').eq(i).find('.noticePage').children().eq(0).attr('style','border-left:0');
		}
	}


	// 쇼핑의 베스트 상품 클릭시
	$('.shopBestPrdt h3').click(function() {
		if($('.shopBestPrdt section').hasClass('on') == true){
			$('.shopBestPrdt section').removeClass('on');
		}
		$(this).parent().addClass('on');
		return false;
	});

	// 쇼핑 페이징 배너
	numBnr();
	function numBnr(){
		for(i = 0; i < $('.numBnr').length ; ++ i ){
			numID = $('.numBnr').eq(i).attr('id');
			numPageBnr(numID);
		}

		function numPageBnr(){

			var $numBnr		= $('#'+numID);
			var	$numBnrBody = $numBnr.children('.numBnrBody');
			var $numBnrDiv  = $numBnrBody.children('.numBnrDiv');
			var	$numBnrAct  = $numBnrDiv.children('.numBnrAct');
			var $numBnr_num = $numBnr.find('.showState');
			var $numCtr 	= $numBnr.find('.numCtrl').find('a');
			var numBnrW		= $numBnrDiv.width();
			var numBnrSum   = $numBnrDiv.length;
			var numWplus = numBnrW;
			var numWmiuns = '-' + numBnrW + 'px';
			var onIndex, numBnrNow, moveAc, clickA;

			$numBnrAct.hide();
			$numBnrDiv.show();
			$numBnrDiv.eq(0).addClass('on').children('.numBnrAct').show();
			$numBnr_num.find('span').eq(-1).text(numBnrSum);
			numBnrNow =	$numBnrBody.children('.on').index();
			$numBnr_num.find('strong').text(numBnrNow+1);

			// 배너의 갯수가 1일때 컨트롤 제어
			if(numBnrSum > 1) {
				$numBnr.find('.numCtrl').show();
				$numBnr.find('.showState').show();
			} else if(numBnrSum == 1) {
				$numBnr.find('.numCtrl').hide();
				$numBnr.find('.showState').hide();
				return;
			}

			$numCtr.on('click',function(e){
				e.preventDefault();
				var clickBtn = $(this).attr('class');
				if(clickBtn == 'mainPrev'){
					numBnrNow = $numBnrBody.children('.on').prev().index();
					moveAc = 'movePrev';
					numBnrMv(numBnrNow,moveAc);
				} else if(clickBtn == 'mainNext'){
					numBnrNow = $numBnrBody.children('.on').next().index();
					moveAc = 'moveNext';
					numBnrMv(numBnrNow,moveAc);
				}
			});


			function numBnrMv(clickA,moveAc){
				numBnrBefore =	$numBnrBody.children('.on').index();
				$numBnrDiv.removeClass('on');
				eff = 'swing';
				speed = 700;

				if(moveAc == 'moveNext'){
					if($numBnr.children('.fadeType').size()){
						$numBnrDiv.eq(numBnrBefore).children('.numBnrAct').show().stop().fadeOut(speed,function(){
							$(this).hide();
						});
					} else {
						// before
						$numBnrDiv.eq(numBnrBefore).children('.numBnrAct').css('z-index','1').stop().animate({'left': numWmiuns},speed, eff, function(){
							$(this).hide();
						});
					}
					if(clickA == '-1') clickA = 0;
					numBnrNow = clickA;
					if(numBnrNow == numBnrSum){
						if($numBnr.children('.fadeType').size()){
							speed = 700;
							$numBnrDiv.eq(0).addClass('on').children('.numBnrAct').css('left',0).show().stop().hide().fadeIn(speed);
						} else {
							$numBnrDiv.eq(0).addClass('on').children('.numBnrAct').css('left',numWmiuns).show().stop().animate({'left': 0 },speed, eff);
						}
						$numBnr_num.find('strong').text('1');
					} else {
						if($numBnr.children('.fadeType').size()){
							speed = 700;
							$numBnrDiv.eq(numBnrNow).addClass('on').children('.numBnrAct').css('left',0).show().stop().hide().fadeIn(speed);
						} else {
							$numBnrDiv.eq(numBnrNow).addClass('on').children('.numBnrAct').css('left',numWplus).show().stop().animate({'left': 0 },speed, eff);
						}
						$numBnr_num.find('strong').text(numBnrNow + 1);

					}

				}  else if(moveAc == 'movePrev'){
					if($numBnr.children('.fadeType').size()){
						$numBnrDiv.eq(numBnrBefore).children('.numBnrAct').show().stop().fadeOut(speed,function(){
							$(this).hide();
						});
					} else {
						$numBnrDiv.eq(numBnrBefore).children('.numBnrAct').css('z-index','1').stop().animate({'left': numWplus},speed, eff, function(){
							$(this).hide();
						});
					}

					numBnrNow = clickA + 1;
					if(numBnrNow == 0){
						if($numBnr.children('.fadeType').size()){
							speed = 700;
							$numBnrDiv.eq(numBnrSum - 1).addClass('on').children('.numBnrAct').css('left',0).show().stop().hide().fadeIn(speed);
							$imgSlider = $numBnrDiv.eq(numBnrSum - 1).children('.numBnrAct');
						} else {
							$numBnrDiv.eq(numBnrSum - 1).addClass('on').children('.numBnrAct').css('left',numWmiuns).show().stop().animate({'left': 0 },speed, eff);

						}
						$numBnr_num.find('strong').text(numBnrSum);
					} else {
						if($numBnr.children('.fadeType').size()){
							speed = 700;
							$numBnrDiv.eq(numBnrNow - 1).addClass('on').children('.numBnrAct').css('left',0).show().stop().hide().fadeIn(speed);
						} else {
							$numBnrDiv.eq(numBnrNow - 1).addClass('on').children('.numBnrAct').css('left',numWmiuns).show().stop().animate({'left': 0 },speed, eff);

						}
						$numBnr_num.find('strong').text(numBnrNow);
					}

				}

			}
		}
	}

	//메인 롤링배너 공통
	slideBnr();
	function slideBnr(){

		var autoTime, eff, speed, i, sliderID;

		for(i = 0; i < $('.slideBnr').length ; ++ i ){
			sliderID = $('.slideBnr').eq(i).attr('id');
			slideRollBnr(sliderID);
		}

		function slideRollBnr(){

			var $sliderBnr =	$('#'+sliderID);

			var $sliderCtr = $sliderBnr.find('.rollControl').find('div > a');
			var $sliderBody = 	$sliderBnr.children('.sliderBody');
			var $sliderDiv = $sliderBody.children('.sliderDiv');
			var $sliderAct = $sliderDiv.children('.sliderImg');
			var $sliderRollBtn = $sliderDiv.children('.rollNum');
			
			var $rollCnts = 	$sliderBnr.find('.rollNum').length-1;
			var $rollCnt = 1;
			var $rollWs = 	$sliderBnr.find('.rollNum').eq(1).width();
			var $rollW = 	$sliderBnr.find('.rollNum').eq(0).width();
			var $rollLeft=(($rollCnts*($rollWs+5))+($rollCnt*($rollW+5)))+25;
			$sliderBnr.find('.rollControl').css('margin-left',$rollLeft);

			var sliderW = 			$sliderAct.width();
			var sliderH = 			$sliderAct.height();
			var sliderSum =			$sliderDiv.length;
			var sliderWplus = 		sliderW;
			var sliderWmiuns = 		'-' + sliderW + 'px';
			var autoCtr, autoCtr2, autoCtr3, sliderNow, clickA, moveAc, sliderBefore, onIndex, widths, $imgSlider;

			//SETTING
			$sliderDiv.show();
			$sliderRollBtn.show();
			$sliderBnr.find('.rollControl').show();
			autoTime = 5000;
			$sliderAct.hide();
			$sliderDiv.eq(0).addClass('on').children('.sliderImg').show();
			sliderNow =	$sliderBody.children('.on').index();

			$sliderBnr.find('.autoOn').find('.stop').children('.hide').text('롤링 정지');
			$sliderBnr.find('.autoOn').find('.play').children('.hide').text('자동 롤링');

			if(sliderSum > 1) {
				$sliderBnr.find('.rollControl').show();
			} else if(sliderSum == 1) {
				$sliderBnr.find('.rollControl').hide();
				$sliderBnr.find('.rollNum').hide();
				return;
			}

			// BtnR
			function btnR(){
				var $btnR = $sliderBnr.find('.btnR');
				if(!$btnR.size()) return;
				var sImgW = $btnR.find('.sliderImg').width();
				var rollWTot=0;
				var $rollCnt = $btnR.find('.rollNum').length;

				for(var r = 0; r < $rollCnt; r++){
					var rollW = $btnR.find('.rollNum').eq(r).width();
					rollWTot = rollWTot + rollW + 5;
				}

				var rollLeft=sImgW-(rollWTot+10)
				$btnR.find('.sliderDiv').eq(0).find('.rollNum').css('margin-left',rollLeft);

			}
			btnR();

			// rollControl
			$sliderCtr.on('click',function(e){
				e.preventDefault();
				var clickBtn = $(this).attr('class');

				if(clickBtn == 'stop'){
					$(this).parent().removeClass('autoOn').addClass('autoOff');
					stopInt();
					$(this).attr('class','play').children('.hide').text('자동 롤링');
				} else if(clickBtn == 'play'){
					$(this).parent().addClass('autoOn').removeClass('autoOff');
					playInt();
					$(this).attr('class','stop').children('.hide').text('롤링 정지');
				}
			});

			// A CLICK
			$sliderDiv.children('a.rollNum').on('click',function(e){
				e.preventDefault();
				sliderNow =	$sliderBody.children('.on').index();
				clickA = $(this).closest('.sliderDiv').index();
				if(sliderNow < clickA){
					moveAc = 'moveNext';
					sliderMv(clickA, moveAc);
				} else if(sliderNow > clickA){
					moveAc = 'movePrev';
					sliderMv(clickA, moveAc);
				}
			});

			// OVER STOP
			$($sliderBnr.find('a')).on('mouseover focus',function(){
					stopInt();
			}).on('mouseleave blur',function(){
				if($sliderBnr.find('.rollControl').children('.autoOn').size()){
						stopInt(); playInt();
				} else if($sliderBnr.find('.rollControl').children('.autoOff').size()){
						stopInt();
				}
			});

			// AUTO
			function playInt(){
				autoCtr = setInterval(function(){
					sliderNow =	$sliderBody.children('.on').index() + 1;
					moveAc = 'moveNext';
					sliderMv(sliderNow, moveAc);
				},autoTime);
			}
			function stopInt(){clearInterval(autoCtr);}
			if($sliderBnr.children('.rollControl').size()) playInt();

			// slide
			function sliderMv(clickA, moveAc){
				sliderBefore =	$sliderBody.children('.on').index();
				$sliderDiv.removeClass('on');
				eff = 'swing';
				speed = 700;


				if(moveAc == 'moveNext'){
					if($sliderBnr.children('.fadeType').size()){
						$sliderDiv.eq(sliderBefore).children('.sliderImg').show().stop().fadeOut(speed,function(){
							$(this).hide();
						});
					} else {
						// before
						$sliderDiv.eq(sliderBefore).children('.sliderImg').css('z-index','1').stop().animate({'left': sliderWmiuns},speed, eff, function(){
							$(this).hide();
						});
					}
					$sliderDiv.eq(sliderBefore).children('.sliderImg').find('.trBg').hide();

					if(clickA == '-1') clickA = 0;
					sliderNow = clickA;
					if(sliderNow == sliderSum){
						if($sliderBnr.children('.fadeType').size()){
							speed = 700;
							$sliderDiv.eq(0).addClass('on').children('.sliderImg').css('left',0).show().stop().hide().fadeIn(speed);
							$imgSlider = $sliderDiv.eq(0).children('.sliderImg');
						} else {
							$sliderDiv.eq(0).addClass('on').children('.sliderImg')
							.css('left',sliderWplus).show().stop().animate({'left': 0 },speed, eff);
							$imgSlider = $sliderDiv.eq(0).children('.sliderImg').css('z-index','10');
						}
					} else {
						if($sliderBnr.children('.fadeType').size()){
							speed = 700;
							$sliderDiv.eq(sliderNow).addClass('on').children('.sliderImg').css('left',0).show().stop().hide().fadeIn(speed);
							$imgSlider = $sliderDiv.eq(sliderNow).children('.sliderImg');

						} else {
							$sliderDiv.eq(sliderNow).addClass('on').children('.sliderImg')
							.css('left',sliderWplus).show().stop().animate({'left': 0 },speed, eff);
							$imgSlider = $sliderDiv.eq(sliderNow).children('.sliderImg').css('z-index','10');
						}
					}

				} else if(moveAc == 'movePrev'){
					if($sliderBnr.children('.fadeType').size()){
						$sliderDiv.eq(sliderBefore).children('.sliderImg').show().stop().fadeOut(speed,function(){
							$(this).hide();
						});
					} else {
						$sliderDiv.eq(sliderBefore).children('.sliderImg').css('z-index','1').stop().animate({'left': sliderWplus},speed, eff, function(){
							$(this).hide();
						});
					}
					$sliderDiv.eq(sliderBefore).children('.sliderImg').find('.trBg').hide();

					sliderNow = clickA + 1;
					if(sliderNow == 0){
						if($sliderBnr.children('.fadeType').size()){
							speed = 700;
							$sliderDiv.eq(sliderSum - 1).addClass('on').children('.sliderImg').css('left',0).show().stop().hide().fadeIn(speed);
							$imgSlider = $sliderDiv.eq(sliderSum - 1).children('.sliderImg');
						} else {
							$sliderDiv.eq(sliderSum - 1).addClass('on').children('.sliderImg')
							.css('left',sliderWmiuns).show().stop().animate({'left': 0 },speed, eff);
							$imgSlider = $sliderDiv.eq(sliderSum - 1).children('.sliderImg').css('z-index','10');

						}
					} else {
						if($sliderBnr.children('.fadeType').size()){
							speed = 700;
							$sliderDiv.eq(sliderNow - 1).addClass('on').children('.sliderImg').css('left',0).show().stop().hide().fadeIn(speed);
							$imgSlider = $sliderDiv.eq(sliderNow - 1).children('.sliderImg');

						} else {
							$sliderDiv.eq(sliderNow - 1).addClass('on').children('.sliderImg')
							.css('left',sliderWmiuns).show().stop().animate({'left': 0 },speed, eff);
							$imgSlider = $sliderDiv.eq(sliderNow - 1).children('.sliderImg').css('z-index','10');

						}
					}

				}
			}
		}
	}

});