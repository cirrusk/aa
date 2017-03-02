//jQuery UI 1.9.1 Original Source Start
function focusable(element, isTabIndexNotNaN){ var map, mapName, img, nodeName = element.nodeName.toLowerCase(); if ( "area" === nodeName ) { map = element.parentNode; mapName = map.name; if ( !element.href || !mapName || map.nodeName.toLowerCase() !== "map" ) { return false; } img = $( "img[usemap=#" + mapName + "]" )[0]; return !!img && visible( img ); } return ( /input|select|textarea|button|object/.test( nodeName ) ? !element.disabled : "a" === nodeName ? element.href || isTabIndexNotNaN : isTabIndexNotNaN) && visible( element ); }
function visible( element ) { return $.expr.filters.visible( element ) && !$( element ).parents().addBack().filter(function() { return $.css( this, "visibility" ) === "hidden"; }).length; }
jQuery.extend( $.expr[ ":" ],{ data: $.expr.createPseudo ? $.expr.createPseudo(function( dataName ) {return function( elem ) { return !!$.data( elem, dataName ); }; }) : function( elem, i, match ) { return !!$.data( elem, match[ 3 ] ); }, focusable: function( element ) { return focusable( element, !isNaN( $.attr( element, "tabindex" ) ) ); }, tabbable: function( element ) { var tabIndex = $.attr( element, "tabindex" ), isTabIndexNaN = isNaN( tabIndex ); return ( isTabIndexNaN || tabIndex >= 0 ) && focusable( element, !isTabIndexNaN ); } });
//jQuery UI 1.9.1 Original Source End



jQuery(function($){
	$('div[id^="uiLayerPop"]').hide();
});


function layerPopupOpen(e, reqTop){

	var target = $(e).attr('href');
	var $target = $($(e).attr('href'));

	$target.show();
	$target.attr('tabindex','0');

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
	})
	
	// 암막
	var layerM =$('<div class="layerMask" id="layerMask" style="display:block"><img src="/_ui/mobile/images/common/bg_mask.png" alt=""></div>');
	$target.before(layerM);

	var bodyW = $(document).width();
	var bodyH = $(document).height();
	var windowW = $(window).width();
	var windowH = $(window).height();

	var scrollT = $(document).scrollTop();
	var targetH = $target.outerHeight();
	var targetTop = Math.round($(e).offset().top);
	
	
	if(targetH < windowH ){
		var resultTop = Math.round(((windowH - targetH)/2)+scrollT); //레이어 팝업이 windowH보다 작을때는 세로의 중앙에 띄움
		if (reqTop) {
			resultTop = reqTop;
		}
		$target.css({'display':'block','top':resultTop});
	}else{
		var resultTop= Math.round(scrollT+15);
		$target.css({'display':'block','top':resultTop}); //레이어 팝업이 windowH보다 클때는 위에서 15px띄운 위치에 뜸
	}
	$(window).scrollTop();
	//풀사이즈 고정 레이어(SOP 2016.05.19 추가)
	if( $target.is('.fixedFullsize')){
		$target.css({'display':'block','top':'0','height':windowH});
		$target.find('.pbLayerContent').css({ height:windowH-80, overflow:'auto'});
		$('body').css('overflow','hidden');
	}


	//가로모드일때 레이어 팝업 사이즈 처리
	$(window).bind("orientationchange",function(event){
		if(!window.orientation==0){
			//alert("가로방향9");
			//alert('windowW : '+windowW);

			var resultTop= ((windowW - targetH)/2)+scrollT;

			if(targetH >windowW ){
				$target.css({ 'display':'block','top':scrollT+30});
			}else{
				$target.css({ 'display':'block','top':resultTop});
			}
		} else {
			//alert("세로방향9");
			//alert('windowW : '+windowW);
		}
	});


	if($target.find('.btnPopClose').hasClass('orderNotice') == true){
		//$target.find('.btnPopClose').bind('click',function(){
		//	$.order.closeOrderRestrictionPopup();
		//	closeLayerPopup($target);
		//	return false;
		//}); --- 개발팀 요청
	}else{
		$target.find('.btnPopClose').bind('click',function(){closeLayerPopup($target);return false;});
		return false;
	}


}

function closeLayerPopup($target){

	var $layerPop = $('div[id^="uiLayerPop_"]');

	$layerPop.find('.btnPopClose, .layerPopClose').unbind('click');
	$target.unbind('keydown');
	$target.fadeOut(200);
	var targetId=$target.attr('id');
	$('.layerMask').fadeOut(200).remove();
	//$('a[href="#'+targetId+'').focus();
	$target.attr('aria-hidden','true');
	//풀사이즈 고정 레이어(SOP 2016.05.19 추가)
	if( $target.is('.fixedFullsize')){$('body').css('overflow','')}
	return false;
};


/* 개발에서 사용안함
function loadingLayer(){
	var loadImg =$('<div class="loading" id="loading"><img src="/_ui/mobile/images/common/loading.gif" alt="로딩중"></div>');
	var layerM =$('<div class="loadMask" id="loadMask" style="display:block"><img src="/_ui/mobile/images/common/bg_loading.png" alt=""></div>');
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
*/
function loadingLayerS(){
	var loadImg =$('<div class="loadingS" id="loadingS"><img src="/_ui/mobile/images/common/loading.gif" alt="로딩중"></div>');
	var layerM =$('<div class="loadMask" id="loadMask" style="display:block"><img src="/_ui/mobile/images/common/bg_loading.png" alt=""></div>');
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