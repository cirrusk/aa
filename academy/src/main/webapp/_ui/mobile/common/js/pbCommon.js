jQuery(function($){

	function hideAddressBar() {

		  // 웹페이지의 높이가 화면높이보다 작을 때는 종료
		  if (document.height <= window.outerHeight) 	return;

		  var scrollTimer = setInterval(function() {
			   if ( ! pageYOffset) {
				   scrollTo(0, 1);
			   } else {
				   clearInterval(scrollTimer);
			   }
		  }, 100); // 100 밀리세컨드마다 반복 실행
	}
	window.addEventListener('load', hideAddressBar, false);  // 페이지 로드 되었을 때 실행
	window.addEventListener('orientationchange', hideAddressBar, false); // 화면이 가로/세로 전환되었을 때 실행

	var docWidth = $(document).width();
	var docHeight = $(document).height();
	var winWidth = $(window).width();
	var winHeight = $(window).height();
	var topPos = winHeight*1;

	//top버튼 세팅
	$(window).scroll(function(){
		var scrollT = $(document).scrollTop();
		if(scrollT > topPos){
			$('.btnTop').show();
		}else{
			$('.btnTop').hide();
		}
		return false;
	});


	//skip Navigation - 확인완료
	$('#pbSkipNavi a').click(function() {
		var clickHref = $(this).attr("href");
		$('' + clickHref + '').first().attr("tabindex", 0).focus();
	});

	if($('.headerTop').length){
		$(document).scrollTop(100);
	}

	//안드로이드폰 자간 조절
	var browser = navigator.userAgent.toLowerCase();
	var user_browser = (browser.indexOf('android')!=-1);
	if ( user_browser ) {
		$('#pbFooter .footerMenu, .footerCopyright address, .footerCopyright span').css('letter-spacing','-0.1em');
		$('.payBox .inputWrap .inputBox label, .payBox .inputWrap .labelSizeM').css('letter-spacing','-0.1em');
	}

	//gnb 활성화
	if($('body[class^="uiGnbM"]').length){
		var bodyClass = $('body').attr('class');
		$('#pbGnb ul li').each(function(){
			var targetClass =$(this).attr('class');
			if (bodyClass == targetClass) {
				$(this).find('a').addClass('on');
			}
		});
	}
	//gnb 클릭
	$('#pbGnb ul li a').click(function() {
		$('#pbGnb ul li a').each(function(){
			if($(this).hasClass('on') == true){
				$('#pbGnb ul li a[class=on]').removeClass('on');
			}
		});
		$(this).addClass('on');
	});

	//현재 페이지 위치
	if($('#pageLocation').length){

		//메가메뉴 수정으로 삭제
		//if($('.depth1').length){
		//	$(document).scrollTop(100);
		//}else{
		//	$('#pageLocation div').css('top','31px');
		//}
		//------//메가메뉴 수정으로 삭제

		// li 라인 없애기
		$('#pageLocation ul ul').each(function(){
			var liLength = $(this).find('li').length;
			if( liLength%2 == false){
				$(this).find('li').filter(':last-child').prev().css('border-bottom','none');
			}
		});

		//하위메뉴 열기 넣기
		$('#pageLocation ul li a').each(function(){
			if ($(this).next('ul').length) {
				$(this).attr("title","하위메뉴 열기").addClass('open');
			}
		});
	}
	//현재 페이지 클릭
	$('.depthClick').click(function(){
		if($(this).hasClass('uiOn') == true){
			$(this).next('div').slideUp();

			if(depth1Menu.find('a').hasClass('close') == true){
				depth1Menu.find('>ul').slideUp();
				depth1Menu.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");
			}
			$(this).removeClass('uiOn').attr("title","하위메뉴 열기");
		}else{
			$(this).next('div').slideDown();
			$(this).addClass('uiOn').attr("title","하위메뉴 닫기");

			if ($('#pageLocation ul li.On').length) {

				$('#pageLocation ul li.On a').removeClass('curr');
				if(depth1Menu.find('a').hasClass('close') == true){
					depth1Menu.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");
				}

				if($('#pageLocation ul li.On ul').length){
					$('#pageLocation ul li.On ul').slideDown();
					$('#pageLocation ul li.On').find('>a').removeClass('open').addClass('close').attr("title","하위메뉴 닫기");
				}else{
					$('#pageLocation ul li.On a').removeClass('curr').addClass('curr');
				}
			}
		}
	});

	//현재 페이지 하위 메뉴
	var depthMenu = $('#pageLocation ul');
	var depth1Menu = depthMenu.find('>li'); //1차메뉴
	var depth2Menu = depthMenu.find('>li>ul>li'); //2차메뉴

	//현재페이지 하위 메뉴 클릭
	depth1Menu.find('>a').click(depth1Click);

	function depth1Click(event){

		if ($(this).next('ul').is(':hidden')) {
			if(depth1Menu.find('a').hasClass('close') == true){
				depth1Menu.find('>ul').slideUp();
				depth1Menu.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");
			}
			$(this).next('ul').slideDown();
			$(this).removeClass('open').addClass('close').attr("title","하위메뉴 닫기");
		} else if(!$(this).next('ul').length) {
			// 하위메뉴가 없는 메뉴 클릭시
			$('#pageLocation div').slideUp();
			$('.depthClick').focus().removeClass('uiOn').attr("title","하위메뉴 열기");
		} else {
			//열려있는 자기자신을 닫을때 사용함
			$(this).next('ul').slideUp();
			$(this).removeClass('close').addClass('open').attr("title","하위메뉴 열기");
		}
	}

	//메가메뉴 수정으로 삭제
	//$('#allMenu').css({'height':docHeight+'px'});

	//전체메뉴 하위 자식들 높이에 따라 스크린 잠금해제
	var deviceHight;

	//디바이스 landscape, portrait 별 메가메뉴 높이 값 설정
	function getReDeviceWidth(){
		dir = window.orientation;
		dWidth = $('#pbWrap').width();
		winHeight = $(window).height();
		if(dir == 180){
			//console.log(true);
			deviceHight = $('#allMenu').height();
			//console.log(deviceHight);
		}else{
			//console.log(false);
			deviceHight = $(window).height();
		}
	}
	window.onorientationchange = function(){
		 e.preventDefault;
		 getReDeviceWidth();
	}

	//전체메뉴 열기
	$('.btnMenuOpen').click(function() {

		var allMenu_height = deviceHight;
		//console.log(allMenu_height );

		$('html,body').css({
			'overflow':'hidden',
			//'position':'fixed'
		});
		$('#allMenu').css('height',allMenu_height);//결정된 메뉴 높이값

		$('#allMenu').focus();
		var layerM =$('<div class="layerMask" id="layerMask" style="display:block;z-index:9000;" />');
		var targetM = $('#allMenu');
		$('#pageLocation div').hide();
		$('.depthClick').removeClass('uiOn').attr("title","하위메뉴 열기");

		targetM.after(layerM);
		//$('#layerMask').bind( 'touchmove', function(e) { e.preventDefault();});
		$('#allMenu').css({'display':'block','left':'0'});

		//$('#allMenu').animate({'left':0},500,function(){
			$('.btnMenuClose').css({'position':'fixed','display':'inline','width':'100%','height':'100%'});
			$('.btnMenuT,op').css({'position':'fixed'});
		//});0
		//전체 메뉴 활성화 하기
		if($('#pbGnb ul li a').hasClass('on')==true){
			$('.depthM>li>a').each(function(){
				var gnbClass = $('#pbGnb ul li a[class=on]').parent().attr('class');
				var targetClass =$(this).attr('class');
				if (gnbClass == targetClass) {
					$(this).next('ul').slideDown();
					$(this).addClass('on').attr("title","하위메뉴 닫기");
				}
			});
		}
	});
	//전체메뉴 닫기
	$('.btnMenuClose').click(function() {
		//화면고정
		t_height = 0; //창 닫을때, 내부 height 초기화
		// 화면 잠금 해제
		//$(document).off('touchmove',preventScr);

		$('body, html').css({
			'overflow':'',
			'position':''
		});
		$('#allMenuWrap').css('display','none');

		$('.btnMenuClose').css({'position':'absolute','display':'none','width':'0','height':'0'});
		$('.btnMenuTop').css({'position':'absolute'});
		$('#allMenu').css({'display':'none','left':'-320px'});

		//$('#allMenu').animate({'left':-320},500,function(){
			$('.layerMask').fadeOut(200).remove();
		//});
		if(AllMenuDepth1.find('a').hasClass('on') == true){
			AllMenuDepth1.find('>ul').slideUp();
			AllMenuDepth1.find('a').removeClass('on').attr("title","하위메뉴 열기");
			//2depth 메뉴가 활성화 되어 있으면  class 지우기
			if(AllMenuDepth2.find('a').hasClass('close') == true){
				AllMenuDepth2.find('>ul').slideUp();
				AllMenuDepth2.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");;
			}
		}
		$('.btnMenuOpen a').focus();
		$(document).scrollTop(0);
	});
	//전체메뉴 닫기{
	$('.btnMenuClose').on('touchstart',function(){
		$('.btnMenuClose').click();
		return false;
	});

	//첫페이지 설정
	$('.mainSetting a').each(function(){
		var addMarkup =$('<span class="hide">현재 설정된 첫 페이지</span>');
		if($(this).hasClass('on') == true){
			$(this).prepend(addMarkup);
		}else{
			$(this).attr("title","첫 페이지로 설정하기");
		}
	});
	//첫페이지 설정 클릭
	$('.mainSetting a').click(function() {
		var addMarkup =$('<span class="hide">현재 설정된 첫 페이지</span>');
		$('.mainSetting a').each(function(){
			if($(this).hasClass('on') == true){
				$(this).removeClass('on').find('span').remove();
				$(this).attr("title","");
			}
		});
		$(this).addClass('on').prepend(addMarkup);
		$(this).attr("title","첫 페이지로 설정하기");
	});

	//전체메뉴
	if($('.depthM').length){
		//하위메뉴 열기 넣기
		$('.depthM ul li a').each(function(){
			if ($(this).next('ul').length) {
				$(this).attr("title","하위메뉴 열기").addClass('open');
			}
		});

		//전체메뉴 정의
		var AllMenuDepth = $('.depthM');
		var AllMenuDepth1 = AllMenuDepth.find('>li'); //1차메뉴
		var AllMenuDepth2 = AllMenuDepth.find('>li>ul>li'); //2차메뉴

		//1Depth 클릭시
		function allMenuDepth1Click(event){
			var t = $(this);
			if (t.next('ul').is(':hidden')) {
				//하위메뉴가 있는 메뉴 클릭시
				if(AllMenuDepth1.find('a').hasClass('on') == true){
					AllMenuDepth1.find('>ul').slideUp();
					AllMenuDepth1.find('a').removeClass('on').attr("title","하위메뉴 열기");
					//2depth 메뉴가 활성화 되어 있으면  class 지우기
					if(AllMenuDepth2.find('a').hasClass('close') == true){
						AllMenuDepth2.find('>ul').slideUp();
						AllMenuDepth2.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");;
					}
				}
				t.next('ul').slideDown();
				t.addClass('on').attr("title","하위메뉴 닫기");

			} else if(!t.next('ul').length) {
				// 하위메뉴가 없는 메뉴 클릭시
				if(AllMenuDepth1.find('a').hasClass('on') == true){
					AllMenuDepth1.find('>ul').slideUp();
					AllMenuDepth1.find('a').removeClass('on').attr("title","하위메뉴 열기");
					//2depth 메뉴가 활성화 되어 있으면  class 지우기
					if(AllMenuDepth2.find('a').hasClass('close') == true){
						AllMenuDepth2.find('>ul').slideUp();
						AllMenuDepth2.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");;
					}
				}
			} else {
				//열려있는 자기자신을 닫을때 사용함
				t.next('ul').slideUp();
				t.removeClass('on').attr("title","하위메뉴 열기");
			}
		}

		//2Depth 클릭시
		function allMenuDepth2Click(event){
			var t = $(this);
			if (t.next('ul').is(':hidden')) {
				//하위메뉴가 있는 메뉴 클릭시
				if(AllMenuDepth2.find('a').hasClass('close') == true){
					AllMenuDepth2.find('>ul').slideUp();
					AllMenuDepth2.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");
				}
				t.next('ul').slideDown();
				t.removeClass('open').addClass('close').attr("title","하위메뉴 닫기");
			} else if(!t.next('ul').length) {
				// 하위메뉴가 없는 메뉴 클릭시
				if(AllMenuDepth2.find('a').hasClass('close') == true){
					AllMenuDepth2.find('>ul').slideUp();
					AllMenuDepth2.find('a[class=close]').removeClass('close').addClass('open').attr("title","하위메뉴 열기");;
				}
			} else {
				//열려있는 자기자신을 닫을때 사용함
				t.next('ul').slideUp();
				t.removeClass('close').addClass('open').attr("title","하위메뉴 열기");
			}
		}
		// 전체메뉴 클릭
		AllMenuDepth1.find('>a').click(allMenuDepth1Click);
		AllMenuDepth2.find('>a').click(allMenuDepth2Click);
	}


	//토글 있을때
	if($('.toggleBox').length){
		$('.toggleBox').each(function(){
			if($(this).hasClass('on') == true){
				$(this).find('.tggTit a').attr("title","자세히보기 닫기");
			}
		});


		$('.toggleBox .tggTit a').click(function(e) {
			e.preventDefault();
			if($(this).parent().parent().hasClass('on') == true){
				$(this).parent().parent().removeClass('on');
				$(this).attr("title","자세히보기 열기");

				if($(this).parent().parent().hasClass('inter') == true){
					$(this).text('국제후원자 입력');
				} else  if($(this).parent().parent().hasClass('aboWrite') == true){
					$(this).text('배우자 공동 ABO 등록');
				}

			}else {
				$(this).parent().parent().addClass('on');
				$(this).attr("title","자세히보기 닫기");

				if($(this).parent().parent().hasClass('inter') == true){
					$(this).text('국제후원자 입력 취소');
				} else  if($(this).parent().parent().hasClass('aboWrite') == true){
					$(this).text('배우자 공동 ABO 등록 취소');
				}

			}
		});

	}


	//제품맵 토글
	if($('.toggleList').length){
		$('.toggleList li>.tggTit').click(function() {
			if($(this).parent().hasClass('on') == true){
				$(this).parent().removeClass('on');
				$(this).attr("title","자세히보기 열기");
			}else {
				$(this).parent().addClass('on');
				$(this).attr("title","자세히보기 닫기");
			}
			return false;
		});
	}

	// 사용자검색설정 토글
	if($('.setupToggle').length){
		$('.setupToggle section>.titP').click(function() {
			if($(this).parent().hasClass('on') == true){
				$(this).parent().removeClass('on');
				$(this).find('a').attr("title","자세히보기 열기");
			}else {
				$(this).parent().addClass('on');
				$(this).find('a').attr("title","자세히보기 닫기");
			}
			return false;
		});
	}

	// 검색결과 탭
	if($('.totalSrcTab').length){
		$('.totalSrcTab li a').click(function() {
			$(this).parent().siblings('li').removeClass('on');
			$(this).parent().addClass('on');
		});
	}

	// 검색결과 토글
	if($('.totalResultWrap').length){
		$('.totalResultWrap section:first-child').addClass('on');
		$('.srcToggle h1 > a').click(function(e) {
			e.preventDefault();
			$(this).parent().parent().siblings('.srcToggle').removeClass('on');

			if($(this).parent().parent().hasClass('on') == true){
				$(this).parent().parent().removeClass('on');
				$(this).attr("title","자세히보기 열기");
			}else {
				$(this).parent().parent().addClass('on');
				$(this).attr("title","자세히보기 닫기");
			}
		});
	}


	//쇼핑메인, 비즈니스 메인 하단 guide
	if($('.guideBox').length){
		$('.guideBox>a').click(function() {
			if($(this).hasClass('on') == true){
				$(this).next('div').hide();
				$(this).removeClass('on');
			}else {
				$('.guideBox').find('div').hide();
				$('.guideBox>a[class=on]').removeClass('on');
				$(this).next('div').show();
				$(this).addClass('on');
				$(this).attr("title","하위메뉴 닫기");
			}
		});
		$('.guideBox div a').click(function() {
			$('.guideBox>a[class=on]').removeClass('on');
			if($('.guideBox').hasClass('shop') == true){
				$('.guideBox > a').attr("title","하위 메뉴 열기");
			} else {
				$('.guideBox > a').eq(0).attr("title","하위 메뉴 열기");
			}
			$(this).parent().hide();
		});
	}


	// 아카데미, 쇼핑, 비지니스 메인
	mainNoteCheck();
	function mainNoteCheck(){

		if (!$('#ntMarquee').length) return;

		var mainNote = $('.notiTop');
		var noteOpen = $('.notiTop .btnNotiOpen');
		var noteClose = $('.notiTop .btnNotiClose');

		mainNoteTest();

		$(noteOpen).click(function() {
			stopMarquee();
			$(mainNote).find('h1').show();
			$(mainNote).find('ul li').show();
			$(mainNote).find('ul li[class=on] span').removeClass('hide');
			$(mainNote).find('ul li[class=on]').removeClass('on');
			$(mainNote).find('ul').addClass('noteOpen');
			$(mainNote).find('ul > li').eq(0).css({'position':'static','display':'list-item'});
			$(mainNote).find('.btnNotiOpen').hide();
			$(mainNote).find('.btnNotiClose').show();
			$(mainNote).find('.btnMore').show();
		});

		$(noteClose).click(function() {
			$(mainNote).find('h1').hide();
			$(mainNote).find('ul li').hide();
			$(mainNote).find('ul li:first-child').show();
			$(mainNote).find('ul li:first-child').addClass('on');
			$(mainNote).find('ul li:first-child span').addClass('hide');
			$(mainNote).find('ul').css({'height':'40px'});
			$(mainNote).find('ul > li').eq(0).css({'position':'absolute','display':'block'});
			$(mainNote).find('ul').removeClass('noteOpen');
			$(mainNote).find('.btnNotiOpen').show();
			$(mainNote).find('.btnNotiClose').hide();
			$(mainNote).find('.btnMore').hide();
			mainNoteTest();
		});

		$(window).resize(function(){
			stopMarquee();
			mainNoteTest();
		});

	}

	function mainNoteTest(){

		var mainNote = $('.notiTop');
		var noteOpen = $('.notiTop .btnNotiOpen');
		var noteClose = $('.notiTop .btnNotiClose');

		//공지사항 flowText : 흐르는 text
		var ntMarquee,notiList,emWidth,btnW,txtPrnW;

		notiMarquee();
		function notiMarquee(){
			ntMarquee = $('.notiTop > ul');
			notiListLi = ntMarquee.find('>li');

			if($(notiListLi).hasClass('on') == true){

				ntMarqueeW = $('#ntMarquee').width();


				notiList = ntMarquee.find('li[class=on]');

				emWidth = notiList.find('a').outerWidth();
				//alert(emWidth + ',' + ntMarqueeW)


				btnW = noteOpen.outerWidth();
				winWidth = $(document).width();
				//txtPrnW = ntMarquee.innerWidth();
				ntDMW = winWidth - btnW;

				//alert(emWidth + ',' + ntDMW + ',' + winWidth);
				//console.log(btnW,ntDMW);

				//펼쳐보기 버튼 유/무에 따른 공지사항 너비
				$('#ntMarquee').css({'width':ntDMW +'px'});

				if(emWidth > ntDMW){
					mainNote.css('background-color','#f9f9f9');
					ntMarquee.removeClass('open');

					var lmtWidth =  emWidth - ntDMW;
					speed = emWidth * 24;
					function notiAnimate() {
						notiList.dequeue().stop().animate({left: - (lmtWidth)}, speed, function(){
							var that = this;
							setTimeout(function() {
								//console.log(that);
								$(that).css('left', '0px');
								notiAnimate();
							}, 2000);
						});
					}
					notiAnimate();
				} else {
					stopMarquee();
				}
			} else {
				stopMarquee();

			}
		}
	}

	function stopMarquee(){
		ntMarquee = $('.notiTop > ul');
		notiListLi = ntMarquee.find('>li');
		notiList = ntMarquee.find('li[class=on]');

		notiList.stop();

		ntMarquee.css({'position':'','display':'block','height':'auto','width':'100%','overflow':'hidden'});
		notiList.css({'position':'','left':'0'});

	}

	//mainNote();
	function mainNote(){
		if (!$('.notiTop').length) return;

		var mainNote = $('.notiTop');
		var noteOpen = $('.notiTop .btnNotiOpen');
		var noteClose = $('.notiTop .btnNotiClose');

		//공지사항 flowText : 흐르는 text
		var ntMarquee,notiList,emWidth,btnW,txtPrnW;

		notiMarquee();
		function notiMarquee(){
			if ($('.btnNotiOpen') == false) return;


			ntMarquee = $('.notiTop > ul');
			notiList = ntMarquee.find('li[class=on]');
			emWidth = notiList.find('em')[0].scrollWidth;
			btnW = noteOpen.outerWidth();
			winWidth = $(window).width();
			//txtPrnW = ntMarquee.innerWidth();
			ntDMW = winWidth - btnW;

			//console.log(btnW,ntDMW);

			//펼쳐보기 버튼 유/무에 따른 공지사항 너비
			$('#ntMarquee').css({'width':ntDMW +'px'});


			if(emWidth > winWidth){
				mainNote.css('background-color','#f9f9f9');
				ntMarquee.css({'position':'relative','display':'block','height':'40px','overflow':'hidden'});
				notiList.css({'position':'absolute'});

				var lmtWidth =  emWidth - ntDMW;
				speed = emWidth * 24;
				function notiAnimate() {
					notiList.animate({left: - (lmtWidth+20)}, speed, function(){
						var that = this;
						setTimeout(function() {
							//console.log(that);
							$(that).css('left', '0px');
							notiAnimate();
						}, 2000);
					});
				}
				notiAnimate();
			}
		}

		//setting..
		$(mainNote).find('h1').addClass('hide');
		$(mainNote).find('.btnNotiClose').addClass('hide');
		$(mainNote).find('.btnMore').addClass('hide');
		$(mainNote).find('ul li').hide();
		$(mainNote).find('ul li[class=on]').show();
		$(mainNote).find('ul li[class=on] span').addClass('hide');

		$(noteOpen).click(function() {
			$(mainNote).find('h1').removeClass('hide');
			$(mainNote).find('ul li').show();
			$(mainNote).find('ul li[class=on] span').removeClass('hide');
			$(mainNote).find('ul li[class=on]').removeClass('on');
			$(mainNote).find('.btnNotiOpen').addClass('hide');
			$(mainNote).find('.btnNotiClose').removeClass('hide');
			$(mainNote).find('.btnMore').removeClass('hide');

			//공지사항 flowText : 펼쳐보기 클릭시 중지
			if(notiList.is(':animated')){
				notiList.stop();
				ntMarquee.css({'position':'','display':'block','height':'auto','width':'100%','overflow':'hidden'});
				notiList.css({'position':'','left':'0px'});
			}

		});
		$(noteClose).click(function() {
			$(mainNote).find('h1').addClass('hide');
			$(mainNote).find('ul li').hide();
			$(mainNote).find('ul li:first-child').show();
			$(mainNote).find('ul li:first-child').addClass('on');
			$(mainNote).find('ul li:first-child span').addClass('hide');
			$(mainNote).find('.btnNotiOpen').removeClass('hide');
			$(mainNote).find('.btnNotiClose').addClass('hide');
			$(mainNote).find('.btnMore').addClass('hide');

			//공지사항 flowText : 접기 클릭시 실행
			notiMarquee();
		});
	}


	// 쇼핑 주문서 작성
	if($('.bankingInfo').length){
		$('.bankingInfo .tggCnt').hide();
		$('.bankingInfo .infoMore').click(function() {
			$(this).parent().next('div.tggCnt').show();
			$(this).hide();
		});
		$('.bankingInfo .infoClose').click(function() {
			$(this).parent().parent('div.tggCnt').hide();
			$(this).parent().parent('div.tggCnt').prev('p.btn').find('a.infoMore').show();
		});
	}
	// 예약주문 사전동의
	if($('.reserOrderConts').length){
		$('.reserOrderConts .textBoxCnt').hide();
		$('.reserOrderConts .infoMore').click(function() {
			$(this).parent().next('div.textBoxCnt').show();
			$(this).hide();
		});
		$('.reserOrderConts .infoClose').click(function() {
			$(this).parent().parent('div.textBoxCnt').hide();
			$(this).parent().parent('div.textBoxCnt').prev('p.btn').find('a.infoMore').show();
		});
	}

	//제품상세보기의 아코디언탭
	if($('.accodTab').length){
		$('.accodTab h2 a').click(function(){
			if($(this).parent().parent().hasClass('on') == true){
				$(this).parent().parent().removeClass('on');
			}else {
				$(this).parent().parent().addClass('on');
			}
			return false;
		});
	}

	if($('.togglePrdt').length){
		$('.togglePrdt section .tggTit ').click(function(){
			if($(this).parent().hasClass('on') == true){
				$(this).parent().removeClass('on');
			}else {
				$(this).parent().addClass('on');
			}
			return false;
		});
	}

	if($('.togglePrdtSlide').length){
		var toggleSlide = $('.togglePrdtSlide > section');
		var toggleSlideDiv = $('.togglePrdtSlide > section .tggCnt');
		//setting..
		$(toggleSlideDiv).hide();
		$(toggleSlide).eq(0).addClass('on');
		$(toggleSlide).eq(0).find('.tggCnt').show();

		$('.togglePrdtSlide section .tggTit ').click(function(){
			if($(this).parent().hasClass('on') == true){
				$(this).parent().removeClass('on');
				$(this).nextAll('.tggCnt').hide();
			}else {
				$(this).parent().addClass('on');
				$(this).nextAll('.tggCnt').show();
			}
			return false;
		});
	}

	//암웨이 용어집 - 20150522 개발팀 요청으로 삭제
	//$('.listType a').click(function() {
	//	var addMarkup =$('<span class="hide">현재 선택한 색인</span>');
	//	$('.listType a').each(function(){
	//		if($(this).hasClass('on') == true){
	//			$(this).removeClass('on').find('span').remove();
	//		}
	//	});
	//	$(this).addClass('on').prepend(addMarkup);
	//});


	// los 당월 전월 선택시 문구 넣어주기
	losMonthSort();
	function losMonthSort(){
		var $losMonthSort = $('.losMonthSort');
		if (!$losMonthSort.length) return;
		var $losMonthSortLink = $('.losMonthSort a');
		var $losMonthOn = $('.losMonthSort a.on');
		var $losMonthTxt =$('<span class="hide">현재 보고 있는 실적</span>');
		$losMonthOn.prepend($losMonthTxt);
		$losMonthSortLink.click(function(e) {
			e.preventDefault();
			$losMonthSortLink.removeClass('on');
			$losMonthSortLink.find('span[class=hide]').remove();
			$(this).addClass('on');
			$(this).prepend($losMonthTxt);
		});
	}

	//logical tab 클릭시 - 확인완료
	$('.tabWrapLogical h2 a').click(function() {
		if($('.tabWrapLogical section').hasClass('on') == true){
			$('.tabWrapLogical section').removeClass('on');
		}
		$(this).parent().parent().addClass('on');
	});

	//목록 검색에서 검색 포커스가면 창 커지게 - 20150702 기능 삭제
	/*if($('.listSearch').length){
		$('.listSearch input').on('keyup focus ',function(){
			$('.listSearch ').css({ 'left':'10px'});
		}).on('focusout',function(){
			$('.listSearch ').css({ 'left':'130px'});
		});
	} */

	//검색
	$('.unitedSearch input[type=text]').click(function(){
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

		$('.searchAutoWrap').show();
		if(inputVal == ''){
			$('.searchAutoWrap .newPromotion, .searchAutoWrap .autoText').css({ 'display':'none'});
			var searchPos = hotH+myH+closeH+45;
			$('.searchAutoWrap .hotText, .searchAutoWrap .myText, .searchAutoWrap .searchClose').css({ 'display':'block'});
			$('.headTop ').css({ 'height':searchPos});
		}else{
			$('.searchAutoWrap .hotText, .searchAutoWrap .myText, .searchAutoWrap .searchClose').css({ 'display':'none'});
			var searchPos = promotionH+autoH+ 45;
			$('.searchAutoWrap .newPromotion, .searchAutoWrap .autoText').css({ 'display':'block'});
			$('.headTop ').css({ 'height':searchPos});
		}

	})/*.on('focusout',function(){
		$('.unitedSearch').css({ 'margin':'0 49px 0 77px'});
		$('.searchAutoWrap').css({ 'margin':'0 -49px 0 -77px'});
		return false;
	});*/

	/*자동완성의 링크, 닫기버튼 클릭시 닫기*/
	$('.searchAutoWrap a').click(function() {
		$('.searchAutoWrap div').css({ 'display':'none'});
		if($('.headTop').hasClass('afterLogin') == true){
			$('.unitedSearch').css({ 'margin':'0 90px 0 77px'});
		} else {
			$('.unitedSearch').css({ 'margin':'0 49px 0 77px'});
		}
		$('.headTop ').css({ 'height':'45px'});
		$('.btnReset').css({ 'display':'none'});
	});
	$('.btnReset').click(function() {
		$('.unitedSearch input[type=text]').val('');
		$('.searchAutoWrap div').css({ 'display':'none'});
		if($('.headTop').hasClass('afterLogin') == true){
			$('.unitedSearch').css({ 'margin':'0 90px 0 77px'});
		} else {
			$('.unitedSearch').css({ 'margin':'0 49px 0 77px'});
		}
		$('.headTop ').css({ 'height':'45px'});
		$(this).css({ 'display':'none'});
	});
	$('.unitedSearch .btnSearch').click(function() {
		$('.searchAutoWrap div').css({ 'display':'none'});
		if($('.headTop').hasClass('afterLogin') == true){
			$('.unitedSearch').css({ 'margin':'0 90px 0 77px'});
		} else {
			$('.unitedSearch').css({ 'margin':'0 49px 0 77px'});
		}
		$('.headTop ').css({ 'height':'45px'});
		$('.btnReset').css({ 'display':'none'});
	});

	// 통합고객센터 시설안내
	cusInfo();
	function cusInfo(){
		if (!$('#customerInfo').length)	return;
		$(".brandDetail").hide();
		$(".brandDetail:eq(0)").show();

		$("#customerInfo").change(function(){
			var gVal = $(this).val();
			$(".brandDetail").hide();
			$(".brandDetail").each(function(i){
				if(i == gVal){
					$(".brandDetail:eq("+i+")").show();
				}
			});
		});

	}

	spInfoTab(); // 쇼핑 탭
	function spInfoTab(){
		if (!$('.spTabList').length) return;
		$('.spTabList a').eq(0).parent().addClass('on');
		$('.spTabCont').hide();
		$('.spTabCont').eq(0).show();

		$('.spTabList a').on('click focus ',function(){
			var obj = $(this).attr('href');
			$('.spTabCont').hide();
			$(obj).show();
			$('.spTabList a').parent().removeClass('on');
			$(this).parent().addClass('on');
			return false;
		});
	}


	//상품 상세보기의 구매하기
	if($('.purchaseWrap').length){
		$('.purchaseWrap .onlyBtn a').click(function() {
			$('.purchaseWrap').addClass('on');
		});
		$('.purchaseWrap .purchase .showHide').click(function() {
			$('.purchaseWrap').removeClass('on');
		});
	}

	//상품 목록 정렬 - 아래 열리는 것이 있는 애들
	if($('.listSort2').length){
		$(this).find('.btnSort').click(function() {
			if($(this).parent().hasClass('on') == true){
				$(this).parent().removeClass('on');
			}else{
				$(this).parent().addClass('on');
			}
		});
		$(this).find('span a').click(function() {
			var clickImgSrc = $(this).find('img').attr('src');
			var clickImgAlt = $(this).find('img').attr('alt');
			$('.listSort2 .btnSort').find('img').attr('src',clickImgSrc).attr('alt',clickImgAlt);
			$('.listSort2').removeClass('on');
		});
	}
	//상품 목록 정렬 - 토글로 바뀌는 애들
	if($('.listSort').length){
		$(this).find('.btnSort').click(function() {
			if($(this).hasClass('imgView') == true){
				$(this).find('img').attr('src',$(this).find('img').attr("src").split("_img.gif").join("_list.gif")).attr('alt','리스트 보기');
				$(this).removeClass('imgView');
			}else {
				$(this).find('img').attr('src',$(this).find('img').attr("src").split("_list.gif").join("_img.gif")).attr('alt','이미지 보기');
				$(this).addClass('imgView');
			}
		});
	}

	//losmap 플리킹 영역
	if($('.bizTblWrap .flickingArea').length){
		//flickingAreaW();
		function flickingAreaW(){
			var docW = $(document).width();
			var fixedW = $('.fixedArea').outerWidth()-2;
			var targetW = (docW - fixedW)+2;
			//$('.flickingArea').css({ 'left':fixedW+'px'});
		}

		flickingAreaS();

	}

	//LOSMAP에서 소팅 버튼 토글시
	$('.btnSortingLos').click(function(){
		if($(this).hasClass('off') == true){
			if($('.tblBiz .btnSortingUp').length){
				$('.tblBiz .btnSortingUp').find('img').attr('src',$('.tblBiz .btnSortingUp').find('img').attr("src").split("_up.png").join("_up2.png")).attr('alt','올림차순 정렬하기');
				$('.tblBiz .btnSortingUp').attr('class','btnSortingUp off');
			}
			if($('.tblBiz .btnSortingDown').length){
				$('.tblBiz .btnSortingDown').find('img').attr('src',$('.tblBiz .btnSortingDown').find('img').attr("src").split("_down.png").join("_down2.png")).attr('alt','내림차순 정렬하기');
				$('.tblBiz .btnSortingDown').attr('class','btnSortingDown off');
			}
			$(this).removeClass('off');
			$('.tblBiz .btnSortingLos').find('img').attr('src',$('.tblBiz .btnSortingLos').find('img').attr("src").split("_down2.png").join("_down.png")).attr('alt','현재 내림차순 정렬 보기');
		}
	});
	$('.btnSortingDown, .btnSortingUp').click(function(){
		if($(this).hasClass('off') == true){
			if($('.tblBiz .btnSortingLos').length){
				$('.tblBiz .btnSortingLos').addClass('off');
				$('.tblBiz .btnSortingLos').find('img').attr('src',$('.tblBiz .btnSortingLos').find('img').attr("src").split("_down.png").join("_down2.png")).attr('alt','내림차순 정렬하기');
			}
			if($('.tblBiz .btnSortingUp').length){
				$('.tblBiz .btnSortingUp').find('img').attr('src',$('.tblBiz .btnSortingUp').find('img').attr("src").split("_up.png").join("_up2.png")).attr('alt','올림차순 정렬하기');
				$('.tblBiz .btnSortingUp').attr('class','btnSortingUp off');
			}
			if($('.tblBiz .btnSortingDown').length){
				$('.tblBiz .btnSortingDown').find('img').attr('src',$('.tblBiz .btnSortingDown').find('img').attr("src").split("_down.png").join("_down2.png")).attr('alt','내림차순 정렬하기');
				$('.tblBiz .btnSortingDown').attr('class','btnSortingDown off');
			}
			var targetName = $(this).attr('class');
			if(targetName == 'btnSortingDown off'){
				$(this).find('img').attr('src',$(this).find('img').attr("src").split("_down2.png").join("_down.png")).attr('alt','현재 내림차순 정렬보기');
				$(this).removeClass('off');
			}else{
				$(this).find('img').attr('src',$(this).find('img').attr("src").split("_up2.png").join("_up.png")).attr('alt','현재 올림차순 정렬보기');
				$(this).removeClass('off');
			}
		}else{
			var targetName = $(this).attr('class');
			if(targetName == 'btnSortingDown'){
				$(this).attr('class','btnSortingUp');
				$(this).find('img').attr('src',$(this).find('img').attr("src").split("_down.png").join("_up.png")).attr('alt','현재 올림차순 정렬보기');
			}else{
				$(this).attr('class','btnSortingDown');
				$(this).find('img').attr('src',$(this).find('img').attr("src").split("_up.png").join("_down.png")).attr('alt','현재 내림차순 정렬보기');
			}
		}
	});

	$('#uiSearchInit').click(function() {
		$('.searchResult ').hide();
		$('.quickSearch input[type=text]').val("");
	});
	$('.searchResult .btnClose').click(function() {
		$('.searchResult ').hide();
	});

	//배송지 열기 닫기
	$('a.btnTgg').click(function() {
		if($(this).parent().parent().hasClass('on') == true){
			$(this).parent().parent().removeClass('on');
			$(this).find('img').attr('src',$(this).find('img').attr("src").split("_close.gif").join("_open.gif")).attr('alt','상세열기');
		}else{
			$(this).parent().parent().addClass('on');
			$(this).find('img').attr('src',$(this).find('img').attr("src").split("_open.gif").join("_close.gif")).attr('alt','상세닫기');
		}
	});

	//LOS 메뉴 열기 닫기
	$('.uiLosMenu').click(function() {
		$('.losMenu').hide();
		$(this).next('.losMenu').show();
	});
	$('.losMenu a').click(function() {
		$(this).parent().hide();
	});

	//쇼핑의 배송메시지
	$('.deliveryMessage input').click(function(){
		var inputVal = $(this).val();
		if(inputVal !== ''){
			$(this).next('div').hide();
		} else {
			$(this).next('div').show();
		}
		return false;
	});
	$('.deliveryMessage > div > a').click(function() {
		e.preventDefault();
		var clickText = $(this).text();
		$(this).parent().prev('input').val(clickText);
		$(this).parent().hide();
		return false;
	});




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

		// 슬라이드 목록 1개일때 touch & drag 비활성화
		if (sliderLiNum == 1){
			$(touchSliderId)
				.unbind("touchmove", this.touchmove)
				.unbind("touchend", this.touchend)
				.unbind("dragstart", this.touchstart)
				.unbind("drag", this.touchmove)
				.unbind("dragend", this.touchend)
		}
	}

	//ABO노트 터치슬라이드
	if($("#touchSlider_ABO").length){
		var touchSliderId = $("#touchSlider_ABO");
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
			roll: false,
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
				//처음페이지 이전버튼, 마지막 페이지 다음버튼 alert 팝업 및 기능 비활성
				if (touchSliderId.get(0)._width / touchSliderId.get(0)._left == 2) {
					// prev
					alert('첫 페이지 입니다');
					touchSliderId.get(0)._left = 0;
				} else if (touchSliderId.get(0)._width / Math.abs(touchSliderId.get(0)._left) == 2) {
					// next
					alert('마지막 페이지 입니다');
					touchSliderId.get(0)._left = 0;
				}

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

		// 슬라이드 목록 1개일때 touch & drag 비활성화
		if (sliderLiNum == 1){
			$(touchSliderId)
				.unbind("touchmove", this.touchmove)
				.unbind("touchend", this.touchend)
				.unbind("dragstart", this.touchstart)
				.unbind("drag", this.touchmove)
				.unbind("dragend", this.touchend)
		}
	}

	//제품 카테고리
	if($("#productSlider02").length){
		var touchSliderId3 = $("#productSlider02");
		var sliderLi3= $(touchSliderId3).find('li');
		var pagingTarget3 = touchSliderId3.parent().find('.sliderPagingProduct');
		var sliderLiNum = sliderLi3.length;

		if (sliderLiNum == 1) return;

		$(touchSliderId3).touchSlider2({
			flexible : true,
			//view : 2,
			btn_prev : touchSliderId3.parent().find(".btnPrev"),
			btn_next : touchSliderId3.parent().find(".btnNext"),
			initComplete : function (e) {
				pagingTarget3.html("");
				var num = 1;
				sliderLi3.each(function (i, el) {
					var altTxt = $(this).find('.name').text();
					if((i+1) % e._view == 0) {
						pagingTarget3.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slide_off.png" alt="' + altTxt + '"></a>');
					}
				});
				pagingTarget3.find(".btnPage").bind("click", function (e) {
					var i = $(this).index();
					touchSliderId3.get(0).go_page(i);
				});
			},
			counter : function (e) {
				pagingTarget3.find(".btnPage").removeClass("on").eq(e.current-1).addClass("on");
				pagingTarget3.find(".btnPage").each(function(){
					if($(this).hasClass('on') == true){
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_off.png").join("_on.png"));
					}else {
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_on.png").join("_off.png"));
					}
				});
			}
		});
	}




	//뉴핀
	if($("#newpinSlider").length){
		var touchSliderId4 = $("#newpinSlider");
		var sliderLi4= $(touchSliderId3).find('li');

		$(touchSliderId4).touchSlider2({
			flexible : true,
			roll : false,
			view : 3,
			btn_prev : touchSliderId4.parent().find(".btnPreB"),
			btn_next : touchSliderId4.parent().find(".btnNextB")
		});
	}

	function recommendSlider() {
		//상품 상세보기의 함께 사용하면 좋은 제품
		$(".recommendList .touchSliderWrap .recommSlide").each(function(){
			var touchSliderId2 = $(this);
			var sliderLi2= $(this).find('li');
			var pagingTarget2 = touchSliderId2.parent().find('.sliderPagingNum2');

			var windowW = $(window).width();
			var bodyW = $(document).width();

			if(windowW<480){
				$(this).css({"width":"320px"});
				recomm01Num2(touchSliderId2, sliderLi2, pagingTarget2);
			}else if(480<=windowW && windowW<640){
				$(this).css({"width":"480px"});
				recomm01Num3(touchSliderId2, sliderLi2, pagingTarget2);
			}else {
				$(this).css({"width":"640px"});
				recomm01Num4(touchSliderId2, sliderLi2, pagingTarget2);
			}
		});
	}

	recommendSlider();
	
	$(window).bind("orientationchange",function(event){
		var browser = navigator.userAgent.toLowerCase();
		var user_browser = (browser.indexOf('android')!=-1);
		if ( user_browser ) {
			window.location.reload();
		}
		recommendSlider();
		/*
		if(window.orientation==0){
			var windowW = $(window).width();
			if(windowW<480){
				$(this).css({"width":"320px"});
				recomm01Num2(touchSliderId2, sliderLi2, pagingTarget2);
			}else if(480<=windowW && windowW<640){
				$(this).css({"width":"480px"});
				recomm01Num3(touchSliderId2, sliderLi2, pagingTarget2);
			}else{
				$(this).css({"width":"640px"});
				recomm01Num4(touchSliderId2, sliderLi2, pagingTarget2);
			}
		}else{
			var windowW = $(window).width();
			if(windowW<480){
				$(this).css({"width":"320px"});
				recomm01Num2(touchSliderId2, sliderLi2, pagingTarget2);
			}else if(480<=windowW && windowW<640){
				$(this).css({"width":"480px"});
				recomm01Num3(touchSliderId2, sliderLi2, pagingTarget2);
			}else{
				$(this).css({"width":"640px"});
				recomm01Num4(touchSliderId2, sliderLi2, pagingTarget2);
			}
		}
		*/
	});
/*
	if($("#recommSlide01").length){
		var touchSliderId2 = $("#recommSlide01");
		var sliderLi2= $(touchSliderId2).find('li');
		var pagingTarget2 = touchSliderId2.parent().find('.sliderPagingNum2');

		var windowW = $(window).width();
		var bodyW = $(document).width();

		if(windowW<480){
			recomm01Num2();
		}else if(480<=windowW && windowW<640){
			$("#recommSlide01").css({"width":"480px"});
			recomm01Num3();
		}else {
			$("#recommSlide01").css({"width":"640px"});
			recomm01Num4();
		}

		$(window).bind("orientationchange",function(event){

			var browser = navigator.userAgent.toLowerCase();
			var user_browser = (browser.indexOf('android')!=-1);
			if ( user_browser ) {
				window.location.reload();
			}

			if(window.orientation==0){
				var windowW = $(window).width();
				if(windowW<480){
					$("#recommSlide01").css({"width":"320px"});
					recomm01Num2();
				}else if(480<=windowW && windowW<640){
					$("#recommSlide01").css({"width":"480px"});
					recomm01Num3();
				}else{
					$("#recommSlide01").css({"width":"640px"});
					recomm01Num4();
				}
			}else{
				var windowW = $(window).width();
				if(windowW<480){
					$("#recommSlide01").css({"width":"320px"});
					recomm01Num2();
				}else if(480<=windowW && windowW<640){
					$("#recommSlide01").css({"width":"480px"});
					recomm01Num3();
				}else{
					$("#recommSlide01").css({"width":"640px"});
					recomm01Num4();
				}
			}
		});
	};
*/

	function recomm01Num2(touchSliderId2, sliderLi2, pagingTarget2){
		touchSliderId2.touchSlider2({
			roll : false,
			view : 2,
			initComplete : function (e) {
				pagingTarget2.html("");
				var num = 1;
				sliderLi2.each(function (i, el) {
					// if((i+1) % e._view == 0) { <!--20150410 수정 -->
					if((i) % e._view == 0) {
						pagingTarget2.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slide_off.png" alt="다음 2개 상품 보기"></a>');
					}
				});
				pagingTarget2.find(".btnPage").bind("click", function (e) {
					var i = $(this).index();
					touchSliderId2.get(0).go_page(i);
				});
			},
			counter : function (e) {
				pagingTarget2.find(".btnPage").removeClass("on").eq(e.current-1).addClass("on");
				pagingTarget2.find(".btnPage").each(function(){
					if($(this).hasClass('on') == true){
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_off.png").join("_on.png"));
					}else {
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_on.png").join("_off.png"));
					}
				});
			}
		});
	};
	function recomm01Num3(touchSliderId2, sliderLi2, pagingTarget2){
		touchSliderId2.touchSlider2({
			roll : false,
			view : 3,
			initComplete : function (e) {
				pagingTarget2.html("");
				var num = 1;
				sliderLi2.each(function (i, el) {
					//if((i+2) % e._view == 0) { <!--20150410 수정 -->
					if((i) % e._view == 0) {
						pagingTarget2.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slide_off.png" alt="다음 3개 상품 보기"></a>');
					}
				});
				pagingTarget2.find(".btnPage").bind("click", function (e) {
					var i = $(this).index();
					touchSliderId2.get(0).go_page(i);
				});
			},
			counter : function (e) {
				pagingTarget2.find(".btnPage").removeClass("on").eq(e.current-1).addClass("on");
				pagingTarget2.find(".btnPage").each(function(){
					if($(this).hasClass('on') == true){
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_off.png").join("_on.png"));
					}else {
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_on.png").join("_off.png"));
					}
				});
			}
		});
	};
	function recomm01Num4(touchSliderId2, sliderLi2, pagingTarget2){
		touchSliderId2.touchSlider2({
			roll : false,
			view : 4,
			initComplete : function (e) {
				pagingTarget2.html("");
				var num = 1;

				sliderLi2.each(function (i, el) {
					//if((i+3) % e._view == 0) { <!--20150410 수정 -->
					if((i) % e._view == 0) {
						pagingTarget2.append('<a href="#none" class="btnPage"><img src="/_ui/mobile/images/common/btn_slide_off.png" alt="다음 4개 상품 보기"></a>');
					}

				});
				pagingTarget2.find(".btnPage").bind("click", function (e) {
					var i = $(this).index();
					touchSliderId2.get(0).go_page(i);
				});
			},
			counter : function (e) {
				pagingTarget2.find(".btnPage").removeClass("on").eq(e.current-1).addClass("on");
				pagingTarget2.find(".btnPage").each(function(){
					if($(this).hasClass('on') == true){
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_off.png").join("_on.png"));
					}else {
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_on.png").join("_off.png"));
					}
				});
			}
		});
	};


	/*
	// 쇼핑의 베스트 상품 클릭시
	$('.bestGoods h2').click(function() {
		if($('.bestGoods section').hasClass('on') == true){
			$('.bestGoods section').removeClass('on');
		}
		$(this).parent().addClass('on');
		return false;
	});
	*/

	// 쇼핑의 베스트 상품, 아카데미 자료실 tab
	$('.tabLogic h2').click(function() {
		if($('.tabLogic section').hasClass('on') == true){
			$('.tabLogic section').removeClass('on');
		}
		$(this).parent().addClass('on');
		return false;
	});

	//주문내역의 하위주문내역 열기 닫기
	$('.orderList li .btnChild').click(function() {
		if($(this).parent().parent().parent().hasClass('on') == true){
			$(this).parent().next('ul').hide();
			$(this).parent().parent().parent().removeClass('on');
			$(this).find('img').attr('alt','하위주문내역 열기').attr('src',$(this).find('img').attr("src").split("_close.gif").join("_open.gif"));
		}else{
			$(this).parent().next('ul').show();
			$(this).parent().parent().parent().addClass('on');
			$(this).find('img').attr('alt','하위주문내역 닫기').attr('src',$(this).find('img').attr("src").split("_open.gif").join("_close.gif"));
		}
		return false;
	});


	//양도할 구매권한 정보 열기 닫기
	$('.couponChoice .btnChild').click(function() {
		if($(this).parent().hasClass('on') == true){
			$(this).next('div').hide();
			$(this).parent().removeClass('on');
			$(this).attr('title','상세내역 열기');
		}else{
			$(this).next('div').show();
			$(this).parent().addClass('on');
			$(this).attr('title','상세내역 닫기');
		}
		return false;
	});


	// 쇼핑 설치정보변경
	if($('.myOderDeliWrap').length){
		$('.btnArrw').click(function(e) {
			var $sourceId = $(this).attr('id');
			if($sourceId == 'updateDeliveryInfoBtn' && $("#addrChangeEnable").val() == 'false') {
				alert($.msg.common.addrChangeBlocking);
				return;
			}

			e.preventDefault();
			var $target = $(this).attr('href');
			var $targetId = $target.slice(1);
			var $targetIdV = $('#'+$targetId);
			if ($targetIdV.is(':hidden')) {
				$targetIdV.show();
				$(this).hide();
			}
		});

		$('.myOderDetailClose').click(function(e) {
			e.preventDefault();
			$(this).closest('.myOderDeliTbl').hide();
			$(this).closest('.myOderDeliWrap').find('.btnArrw').show().focus();
		});
	}





	// 카테고리 제품목록 40개 더보기 액션
	//moreListViewInit();
	function moreListViewInit() {
		$moreBtn	= $('.listMore');
		$listCon	= $('ul.proListCate');
		itemCount	= $listCon.children('li').length;

		$moreBtn.on('click', function(ev) {
			if ($moreBtn.children('span').html() != 'TOP') {
				ev.preventDefault();

				$.ajax({
					url: "/mobile/services/sample.xml",
					type: "GET",
					data: {
						'currentCount'	: itemCount,
						'sampleField'	: 'sampleParameter'
					},
					dataType: "xml"
				}).done(function(xml) {
					var itemDatas = $(xml).find('item');
					for (i = 0; i < itemDatas.length; i ++)
						makeLineComponent(buildValueObject(itemDatas.eq(i)));

					var totalCount = parseInt($(xml).find('totalcount').text());

					if (totalCount <= $listCon.children('li').length) {
						$moreBtn.children('span').html('TOP');
						$moreBtn.attr('href', '#prdtListTop');
						$moreBtn.attr('class', 'listMoreTop');
					} else if (totalCount - $listCon.children('li').length < 40) {
						$moreBtn.children('span').html('' + (totalCount - $listCon.children('li').length) + '개 더보기');
					}
				});
			}
		});

		function buildValueObject(xmlItem) {
			var vo = {};
			vo.seq = xmlItem.children('seq').text();
			vo.code = xmlItem.children('code').text();
			vo.title = xmlItem.children('title').text();
			vo.thumb = xmlItem.children('thumb').text();
			vo.pv = xmlItem.children('pv').text();
			vo.bv = xmlItem.children('bv').text();
			vo.price = xmlItem.children('price').text();
			vo.tags = [];
			var xmlTags = xmlItem.children('tags').children('tag');
			for (var tgidx = 0; tgidx < xmlTags.length; tgidx ++) {
				var tg = {};
				tg.label = xmlTags.eq(tgidx).attr('label');
				tg.keyword = xmlTags.eq(tgidx).attr('keyword');
				vo.tags.push(tg);
			}
			return vo;
		}

		function makeLineComponent(item) {
			$proLn		= $listCon.children('li').eq(0).clone();
			$proLnk		= $proLn.children('div').eq(0);
			$proImg		= $proLnk.children('a').children('p').children('img');
			$proTag		= $proLn.find('span.tag');
			$proTtl		= $.merge(
									$proLnk.children('p').children('span').eq(0),
									$proLnk.children('p').children('a').eq(0));
			$proPvBv	= $proLnk.children('a').children('p.info').children('span').children('strong');
			$proPrc		= $proLnk.children('a').children('p.info').children('strong.price');

			$proLn.children('input').eq(0).attr('title', '[' + item.seq + '] ' + item.code + ' ' + item.title + '제품 선택하기');
			$proImg.attr('src', item.thumb);
			$proImg.attr('alt', '[' + item.seq + '] ' + item.code + ' ' + item.title);
			$proTag.children('em').remove();
			for (var tgidx = 0; tgidx < item.tags.length; tgidx ++) {
				var tagEm = $('<em></em>');
				tagEm.addClass(item.tags[tgidx].keyword);
				tagEm.html(item.tags[tgidx].label);
				$proTag.append(tagEm);
			}

			$proTtl.eq(0).html('[' + item.seq + '] ' + item.code);
			$proTtl.eq(1).html(item.title);
			$proPvBv.eq(0).html('PV ' + formatInt(item.pv));
			$proPvBv.eq(1).html('BV ' + formatInt(item.bv));
			$proPrc.html(formatInt(item.price));

			$listCon.append($proLn);
		}

		function formatInt(value) {
			var tmpStr = parseInt(value) + '';
			var rstStr = '';

			for (var curs = 3; curs < tmpStr.length; curs += 3)
				rstStr = ',' + tmpStr.substr(tmpStr.length - curs, 3) + rstStr;

			rstStr = tmpStr.substr(0, (tmpStr.length % 3 == 0 ? 3 : tmpStr.length % 3)) + rstStr;

			return rstStr;
		}
	}
	// 추가끝

	// 리스트 bg 처리
	//listBG(); 20150520 - 개발팀 요청으로 잠시 보류
	function listBG(){
		if ($('.photoList').length) {
			$('.photoList').each(function() {
				if($(this).hasClass('commList') == true){
					commListBg();
				} else if($(this).hasClass('editList') == true){
					editListBg();
				}
			});
		} else if ($('.listDownload').length) { // 리스트 다운로드일때
			var $listDownLoad = $('.listDownload');
			var $listDown = $listDownLoad.find('li[class=bg]');

			$listDown.find('span.dimmed').show();
		}

	}

	function commListBg(){

		var $photoList = $('.photoList.commList');
		var $listRead = $photoList.find('li[class=bg]');

		$listRead.find('span.dimmed').show();

		if($listRead.find('.listCont p.contents').children('.confirm').size()){
			$listRead.find('span.confirm').text('확인여부 : 읽음');
		}
	}

	function editListBg(){
		var $editList = $('.photoList.editList');
		var $editListLi = $editList.find('li');

		var $editCheckBg = $editList.find('li[class=bg]');
		var $editCheck = $editList.find('p.check').children('input[type=checkbox]');

		if ($editListLi.find('.listCont p.contents').children('.confirm').size()){
			$editListLi.find('span.confirm').text('확인여부 : 읽음');
		}

		$editCheck.change(function() {
			if(this.checked){
				$(this).parent('.check').nextAll('.listCont').find('span.dimmed').show();
			} else {
				$(this).parent('.check').nextAll('.listCont').find('span.dimmed').hide();
			}
		});
	}

	bzSelect(); // sopping brandzone
	function bzSelect(){
		if (!$('#branZoneSel').length) return;

		var $brandZondSel = $('#branZoneSel');
		var $brandDiv = $('.brandMallWrap');

		$brandZondSel.change(function() {
			var gVal = $(this).val();
			if (gVal == 'all') {
				$brandDiv.show();
			} else {
				$brandDiv.hide();
				$brandDiv.eq(gVal).show();
			}

		});


	}

	bizRuleFaq();
	function bizRuleFaq(){
		if (!$('.bizFaqTab').length) return;

		$('.bizTabCont').eq(0).show();
		$('.bizFaqTab li').eq(0).addClass('on');

		$('.bizFaqTab li a').on('click focus ',function(){
			var obj = $(this).attr('href');
			$('.bizTabCont').hide();
			$(obj).show();
			$('.bizFaqTab li a').parent().removeClass('on');
			$(this).parent().addClass('on');
			return false;
		});

	}

	abnGdNav();
	function abnGdNav(){
		if (!$('#abnGuideNav').length) return;

		var abnGuide = $('#abnGuideNav');
		var abnGuideDep = $('.abnMenu .menuDep');
		var abnGuideDep1 = $(abnGuideDep).find('> ul > li.dep1');
		var abnGuideDep1Li = $(abnGuideDep1).find('> ul >li');

		var abnGuideDep2 = $(abnGuideDep).find('> ul > li.dep2');
		var abnGuideDep2Li = $(abnGuideDep2).find('> ul > li > ul > li');

		var abnGuideMn = $('.abnMenu .menu');

		var pageClass = $(abnGuide).attr('class').slice(-4);
		var pageMn = $(abnGuide).attr('class').slice(-2);
		var pageTopMn = $(abnGuide).attr('class').slice(-1);
		var pageTopNum = '0' + pageTopMn;

		guideComm();
		if(pageMn == '01'){
			$(abnGuideMn).find('>li').eq(pageTopMn-1).find('>a').addClass('on');
			$(abnGuideDep1Li).each(function(){
				var targetClass =$(this).attr('class').slice(-4);
				if (pageClass == targetClass) {
					$(this).find('>a').addClass('depOn');
				}
			});

		} else if(pageMn == '02'){
			$(abnGuideMn).find('>li').eq(pageTopMn-1).find('>a').addClass('on');

			$(abnGuideDep2Li).each(function(){
				var targetClass =$(this).attr('class').slice(-4);
				if (pageClass == targetClass) {
					$(this).find('>a').addClass('depOn');
				}
			});
		}
	}

	function guideComm(){
		$('.abnMenu .btnTbl').on('click',function(e){
			var abnMn = $('.abnMenu');
			var abnListBtn = $(abnMn).find('.btnTbl');

			if(abnMn.hasClass('mnOn') == true){
				$('.abnMenu .menuDep').hide();
				abnMn.removeClass('mnOn');
				abnListBtn.text('목록보기');
				return false;
			}else{
				$('.abnGuideJump').addClass('jumpOn');
				abnMn.addClass('mnOn');
				$('.abnMenu .menuDep').show();
				abnListBtn.text('목록닫기');
				return false;
			}
		});

		$('.menuDep .btnAbnClose').on('click',function(e){
			var abnMn = $('.abnMenu');
			var abnListBtn = $(abnMn).find('.btnTbl');
			$('.abnMenu .menuDep').hide();
			abnMn.removeClass('mnOn');
			abnListBtn.text('목록보기');
		});
	}

	spGuideNav();
	function spGuideNav(){
		if (!$('#spGuideNav').length) return;

		var spGuide = $('#spGuideNav');
		var spGuideDep = $('.abnMenu .menuDep');
		var spGuideDep2 = $(spGuideDep).find('> ul > li.dep2');
		var spGuideDep2Li = $(spGuideDep2).find('> ul >li');

		var spGuideMn = $('.abnMenu .menu');

		var pageClass = $(spGuide).attr('class').slice(-4);
		var pageMn = $(spGuide).attr('class').slice(-2);
		var pageTopMn = $(spGuide).attr('class').slice(-1);

		guideComm();

		$(spGuideMn).find('>li').eq(pageTopMn-1).find('>a').addClass('on');
		$(spGuideDep2Li).each(function(){
			var targetClass =$(this).attr('class').slice(-4);
			if (pageClass == targetClass) {
				$(this).find('>a').addClass('depOn');
			}
		});
	}

	spGuideTab();
	function spGuideTab(){
		if (!$('.oderGuideTab').length) return;
		
		var oderGuide = $('.oderGuideTab > ul');
		var oderGuideLi = $(oderGuide).find('> li');
		var oderCont = $('.oderGuideCont');
		var oderGuideLink = $(oderGuideLi).find('>a');
		
		var sUrl = location.href;

		if (sUrl.indexOf("?")!= -1) {
			var sPage;
			if( sUrl.indexOf("&") != -1 ) {
				sPage = sUrl.substring(sUrl.indexOf("?")+1, sUrl.indexOf("&"));	// & 까지 가져오기로 변경
			} else {
				sPage = sUrl.substr(sUrl.indexOf("?")+1, sUrl.length-1); // AS-IS Logic 이상함.
			}
			
			var installOder = "installOder"; // 설치주문 일때
			var smartOder = "smartOder"; // 스마드 오더 일때
			
			if (sPage == installOder){
				$(oderGuideLi).eq(2).find('a').addClass('on');
				$(oderCont).eq(2).show();
			} else if (sPage == smartOder){
				$(oderGuideLi).eq(3).find('a').addClass('on');
				$(oderCont).eq(3).show();
			} else {
				$(oderGuideLi).eq(0).find('a').addClass('on');
				$(oderCont).eq(0).show();
			}
		} else {
			$(oderGuideLi).eq(0).find('a').addClass('on');
			$(oderCont).eq(0).show();
		}

		
		$(oderGuideLink).on('click focus ',function(e){
			e.preventDefault();
			var obj = $(this).attr('href');
			$(oderCont).hide();
			$(obj).show();
			$(oderGuideLink).removeClass('on');
			$(this).addClass('on');
			//return false;
		});
	}


	$(window).resize(function() {
		var docW = $(document).width();
		$('.bizTblWrap').flickingJo({
			/* *********************************
				docW : 현재 document 사이즈
				colW : 테이블 td의 가로 사이즈
			********************************* */
			docW : docW,
			colW : '100'
		});
		/*$('.nameWrap').flickingJo({
			docW : docW,
			colW : '300'
		}); */
		$('.bizTblWrap.month').flickingJo({
			/* *********************************
       			docW : 현재 document 사이즈
   				colW : 테이블 td의 가로 사이즈
				iso 9 처리 추가 -- 20151027
			 ********************************* */
			docW : docW,
			colW : '60'
		});
	}).resize();
});


function flickingAreaS(){
	$('.bizTblWrap .flickingArea').each(function(){
		var colLength = $(this).find('.tblBiz thead th').length;
		var firstCW = $(this).find('.tblBiz thead th:first-child').width();
		var tableL = colLength-1;
		var thWidthL = 100;
		var thWidthS = 60;
		var tableW= (thWidthL*tableL)+firstCW;
		var tableWS= (thWidthS*tableL)+firstCW;

		$(this).find('.tblBiz').css({ 'width':tableW+'px'});
		$(this).find('.tblBiz thead th').css({ 'width':thWidthL+'px'});
		$(this).find('.tblBiz thead th:first-child').css({ 'width':(firstCW+1)+'px'});
		$(this).find('.tblBiz.month').css({ 'width':tableWS+'px'});
		$(this).find('.tblBiz.month thead th').css({ 'width':thWidthS+'px'});
		$(this).find('.tblBiz.month thead th:first-child').css({ 'width':(firstCW+1)+'px'});
	});
}

function btn_popDialog(param1){//개발팀 삽입 요청-20150622
	if(Android != null){
		window.popDialog.popUpWebview(param1);
	}else if(iPhone != null) {
		//alert("iPhone 로그아웃");
		window.location.href = "jscall2://?popdialog";
	}else{
		alert("지원 하지 않는 OS입니다.");
	}
}

function showToggle(){
	if (!$('.deliveryIn .deliInputBox').length) return;
	$('.deliveryIn .deliInputBox').addClass('on');
	$('.deliveryIn .deliInputBox a.btnTgg img').attr('src','/_ui/mobile/images/content/btn_child_close.gif');
}
function hideToggle(){
	if (!$('.deliveryIn .deliInputBox').length) return;
	$('.deliveryIn .deliInputBox').removeClass('on');
	$('.deliveryIn .deliInputBox a.btnTgg img').attr('src','/_ui/mobile/images/content/btn_child_open.gif');
}


;(function($){
	$.fn.extend({
		flickingJo : function(opt) {
			var defaults = {
				docW : '',
				colW : '100'
			}
			var opt = $.extend(defaults, opt);
			return this.each(function(){
				var $this 			= $(this),
					$fixedArea 		= $this.find('.fixedArea'),
					$flickingArea 	= $this.find('.flickingArea'),
					$table 			= $flickingArea.find('table'),
					$theadTh		= $flickingArea.find('thead th');

				var docW 			= opt.docW,
					colW 			= opt.colW,
					fTh 			= $fixedArea.width() - 2,
					colSum			= $theadTh.length,
					tblW			= (colW * (colSum - 1)) + fTh,
					defaultPosition	= $(window).width(),
					endPosition 	= 0,
					movePosition 	= 0;

				$table.css('width', tblW);
				$theadTh.eq(0).css('width', fTh);
				$this.find('#btnCnt').detach();

				if(docW < tblW){

					$this.append('<div id="btnCnt" class="leftArrw"></span>');
					$this.find('#btnCnt').show();

					$flickingArea.scroll(function(event) {
						endPosition = event.currentTarget.scrollWidth;
						movePosition = event.currentTarget.scrollLeft;

						if ((endPosition - defaultPosition) === movePosition) {
							$this.find('#btnCnt').attr('class','').addClass('rightArrw');
						} else if (!movePosition) {
							$this.find('#btnCnt').attr('class','').addClass('leftArrw');
						}  else {
							$this.find('#btnCnt').attr('class','').addClass('centerArrw');
						}
					});

					$(window).scroll(function(event) {

						if(defaultPosition < $flickingArea.scrollWidth){
							//console.log(true);
							$this.find('#btnCnt').show();
							var tbTop = $flickingArea.offset().top,
								tbBtm = tbTop + $flickingArea.height();

							var vwTop = $(window).scrollTop(),
								vwBtm = vwTop + $(window).height();

							var btnMin = Math.max(vwTop, tbTop),
								btnMax = Math.min(vwBtm, tbBtm),
								btnOffset = (btnMin + btnMax) * .5;

							//var $btnCnt = btnMin < btnMax ? $this.find('#btnCnt').show() : $this.find('#btnCnt').hide();
							$btnCnt.css('top', (btnOffset) + 'px');
						}
					});

				}

			});
		}
	});

})(jQuery);
