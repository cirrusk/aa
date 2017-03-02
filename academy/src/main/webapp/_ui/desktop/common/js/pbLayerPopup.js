//jQuery UI 1.9.1 Original Source Start
function focusable(element, isTabIndexNotNaN){ var map, mapName, img, nodeName = element.nodeName.toLowerCase(); if ( "area" === nodeName ) { map = element.parentNode; mapName = map.name; if ( !element.href || !mapName || map.nodeName.toLowerCase() !== "map" ) { return false; } img = $( "img[usemap=#" + mapName + "]" )[0]; return !!img && visible( img ); } return ( /input|select|textarea|button|object/.test( nodeName ) ? !element.disabled : "a" === nodeName ? element.href || isTabIndexNotNaN : isTabIndexNotNaN) && visible( element ); }
function visible( element ) { return $.expr.filters.visible( element ) && !$( element ).parents().addBack().filter(function() { return $.css( this, "visibility" ) === "hidden"; }).length; }
jQuery.extend( $.expr[ ":" ],{ data: $.expr.createPseudo ? $.expr.createPseudo(function( dataName ) {return function( elem ) { return !!$.data( elem, dataName ); }; }) : function( elem, i, match ) { return !!$.data( elem, match[ 3 ] ); }, focusable: function( element ) { return focusable( element, !isNaN( $.attr( element, "tabindex" ) ) ); }, tabbable: function( element ) { var tabIndex = $.attr( element, "tabindex" ), isTabIndexNaN = isNaN( tabIndex ); return ( isTabIndexNaN || tabIndex >= 0 ) && focusable( element, !isTabIndexNaN ); } });
//jQuery UI 1.9.1 Original Source End




jQuery(function($){

	// all layer popup hide
	$('div[id^="uiLayerPop"]').hide();
	var $layerPop = $('div[id^="uiLayerPop_"]');

	// layerPop center align -  click Event
	$(document).on('click', 'a[href^="#uiLayerPop_"]', layerPopupOpen);//$('a[href^="#uiLayerPop_"]').click(layerPopupOpen); 20150417 : 개발팀요청수정

	appname = navigator.appName;
	useragent = navigator.userAgent;
	if(appname == "Microsoft Internet Explorer") appname = "IE";
	IE7 = (useragent.indexOf('MSIE 7')>0);

	// layerPop center align - Open modal window
	function layerPopupOpen(){
		var $this = $(this);
		var $target = $($this.attr('href'));
		var target = $this.attr('href');
		$target.show();

		if ($('.tag a.miniB').length){
			$('.tag a.miniB').css({'z-index':'1'});
		}

		if(!appname==IE7) {
		// ie7 error s : 20140918 ------
			$target.attr('tabindex','0').focus();
			$target.trigger('focus');

			var tabbables = $(target + ' :tabbable'),
			//첫번째 탭요소
			first = tabbables.filter(':first'),
			//마지막 탭요소
			last  = tabbables.filter(':last');

			//키 이벤트 등록
			$target.live('keydown',function(event){
				if(event.keyCode !== 9){ return; }
				if((event.target == last[0]) && !event.shiftKey){
					if((event.target.tagName=='INPUT') && (event.target.type=='text')){
						if (document.selection){ document.selection.empty();}
						else if (window.getSelection){ window.getSelection().collapseToStart();}
					}
					first.focus();//첫번째 탭 요소로 포커스 이동
					event.preventDefault();//상위 이벤트 핸들러로 전달되지 않도록 이벤트 해제
				} else if((event.target == first[0]) && event.shiftKey){
					last.focus();//마지막 탭 요소로 포커스 이동
					event.preventDefault();//상위 이벤트 핸들러로 전달되지 않도록 이벤트 해제
				}
			});
		// ie7 error e : 20140918 ------
		}

		// 암막
		var layerM =$('<div class="layerMask" id="layerMask" style="display:block"></div>');
		$target.before(layerM);
		$(window).scrollTop();
		
		$target.css({ 'display':'block', 'position':'fixed', 'top':'100px', 'left':'50%', 'marginLeft': - $target.width()/2 });

		$('#pbHeader').css({'z-index':'-1'});
		$('#pbFooter').css({'z-index':'-1'});

		if(target=="#uiLayerPop_prodDetail"){
			$('#pbAside').css({'z-index':'-1'});
		}

		// layerPop center align - Close button
		$(document).on('click', 'div[id^="uiLayerPop_"] .btnPopClose,.layerPopClose', function(){closeLayerPopup($target);return false;}); // $layerPop.find('.btnPopClose, .layerPopClose').bind('click',function(){closeLayerPopup($target);return false;}); 20150417 : 개발팀요청수정
		return false;
	}
	
	// layerPop center align - Close modal window and bg
	function closeLayerPopup($target){
		$('#pbHeader').css({'z-index':'100'});
		$('#pbFooter').css({'z-index':'50'});

		if ($('#uiLayerPop_prodDetail').length){
			$('#pbAside').css({'z-index':'100'});
		};

		if ($('.tag a.miniB').length){
			$('.tag a.miniB').css({'z-index':'11'});
		}

		$layerPop.find('.btnPopClose, .layerPopClose').unbind('click');
		$target.unbind('keydown');
		$target.attr('tabindex','-1');
		$target.fadeOut(200);
		var targetId=$target.attr('id');
		$('.layerMask').fadeOut(200).remove();
		$('a[href="#'+targetId+'"]').focus();
		return false;
	};

	// layerPop X,Y coordenadas
	var $layerPopXY = $('div[id^="uiLayerPopXY_"]');
	// layerPop X,Y coordenadas - Click Event
	$('a[href^="#uiLayerPopXY_"]').click(layerPopupXYOpen);

	// layerPop X,Y coordenadas - Open modal window
	function layerPopupXYOpen(event){
		var $this = $(this);
		var $target= $($this.attr('href'));
		var target = $this.attr('href');
		var targetClass = target.slice(1);

		//열려있는 레이어 팝업 닫음
		$layerPopXY.hide();

		$target.show();
		$target.attr('tabindex','0');
		//$target.trigger('focus');

		var $thisOffset = $this.offset();
		var $thisY = $this.position().top;
		var $thisX = $this.position().left ;
		var $thisW = $this.outerWidth();
		var $thisH = $this.outerHeight();

		//alert("$thisX : "+$thisX+"   $thisY : "+$thisY);

		//$(document).scrollTop();
		//$target.css({'display':'block','position':'absoulte','top':$thisY,'left':$thisX+$thisW});
		//$target.css({'display':'block','position':'absoulte','top':- ($thisH/2) +'px','left': ($thisW/2)+'px','z-index':'9999'});
		$target.css({'display':'block','position':'absoulte','top':- $thisH +'px','left':'0px','z-index':'9999'});

		// layerPop X,Y coordenadas - Close button
		$layerPopXY.find('.'+targetClass+'').bind('click',function(){layerPopupXYClose(targetClass);return false;});
		return false;
	}

	// layerPop X,Y coordenadas - Close modal window
	function layerPopupXYClose(targetClass){
		$('#'+targetClass+'').hide();
		$('#'+targetClass+'').attr('tabindex','-1');
		$('a[href="#'+targetClass+'').focus();
		return false;
	};


	// layerPop mouseOver
	var $layerPopOver = $('div[id^="uiLayerPopOver_"]');

	// layerPop mouseOver Event
	$('a[href^="#uiLayerPopOver_"]').mouseover(layerPopupOverOpen).focus(layerPopupOverOpen);

	// layerPop mouseOver
	function layerPopupOverOpen(event){
		var $this = $(this);
		var $target = $($this.attr('href'));

		var $thisOffset = $this.offset();
		var $thisY = $thisOffset.top;
		var $thisX = $thisOffset.left ;
		var $thisW = $this.width();
		var $thisH = $this.height();

		$layerPopOver.hide();
		$(document).scrollTop();
		$target.css({'display':'block','position':'fixed','top':$thisY,'left':$thisX+$thisW});
		return false;
	}

	// layerPop mouseLeave
	$layerPopOver.mouseleave(function(e) {
		$(this).hide();
	});
	$('a[href^="#uiLayerPopOver_"]').focusout(function(e) {
		$layerPopOver.hide();
	});


	//URL 복사하기
	$('.snsUrlBox a.snsUrl').click(openSnsUrl);
	function openSnsUrl(){
		var $this = $(this);
		var $target = $($this.next('.alert'));
		var target = $this.next('.alert');
		$target.show();

		$target.attr('tabindex','0').focus();
		return false;
	}
	$('.snsUrlBox a.btnClose').click(closeSnsUrl);
	function closeSnsUrl($target){
		var $this = $(this);
		$this.parent('.alert').hide();
		$this.parent().prev().focus();
		return false;
	}
	//----URL 복사하기

});


//뉴스그램 다운로드 Layer
function newsGramInfo(e){
	var $layerPopXY2 = $('div[id^="newsgLayer_"]');
	var target = $(e).attr('href');
	var $target = $($(e).attr('href'));
	var targetClass = target.slice(1);

	$layerPopXY2.hide();
	$target.show();

	/* 뉴스그램 > SNS URL 복사하기 */
	if (!$('.snsUrlBox .alert').length){
		return;
	}else{
		$('.snsUrlBox .alert').hide();
	}
	return false;
}
function newsGramInfoClose(e){
	var $target = $($(e).attr('href'));
	$target.hide();
	$target.prev('a').focus();
	return false;
};


function loadingLayer(){
	var loadImg =$('<div class="loading" id="loading"><img src="/_ui/desktop/images/common/loading.gif" alt="로딩중"></div>');
	var layerM =$('<div class="loadMask" id="loadMask" style="display:block"></div>');
	if (loadImg.length){
		$('#loading').remove();
		$('#loadMask').remove();
	}
	$('body').append(loadImg);
	loadImg.before(layerM);
}
function loadingLayerClose(){
	$('#loading').remove();
	$('#loadMask').remove();
	return false;
}
function loadingLayerS(){
	var loadImg =$('<div class="loadingS" id="loadingS"><img src="/_ui/desktop/images/common/loading_s.gif" alt="로딩중"></div>');
	var layerM =$('<div class="loadMask" id="loadMask" style="display:block"></div>');
	if (loadImg.length){
		$('#loadingS').remove();
		$('#loadMask').remove();
	}
	$('body').append(loadImg);
	loadImg.before(layerM);
}
function loadingLayerSClose(){
	$('#loadingS').remove();
	$('#loadMask').remove();
	return false;
}