/**
 * Description	: pcCommon.js copy, 아카데미 관련 없는 스크립트 삭제
 * Version: 	: 2016.06.28
 */

String.prototype.replaceEnd = function(oldString, newString){
	return this.split(oldString).join(newString);
};


jQuery(function($){

	//skip Navigation - 확인완료
	$('#pbSkipNavi a').click(function() {
		var clickHref = $(this).attr('href');
		$('' + clickHref).first().attr('tabindex', 0).focus();
	});

	//약관내용에 포커스 들어가기 - 확인완료
	var $agreeBoxT = $('.agreeBox > div');
	if($agreeBoxT.length){
		$agreeBoxT.attr('tabindex', 0);
		$agreeBoxT.focusin(function(e) {
			$(this).addClass('onFocus');
		});
		$agreeBoxT.focusout(function(e) {
			$('.agreeBox').removeClass('onFocus');
		});
	}

	// 건너뛰기 버튼 에서 공통으로 사용 - 확인완료
	$('a.btnHide').click(function(e) {
		e.preventDefault();
		var clickHref = $(this).attr('href');
		$('' + clickHref).attr('tabindex', 0).focus();
	});

	//logical tab 클릭시
	logicalTab();
	function logicalTab(){
		if (!$('.tabWrapLogical').length) return;
		var tabLogi = $('.tabWrapLogical');
		var tabLogiCont = $(tabLogi).find('> section');
		var tabLogiLink = $('.tabWrapLogical h2 a');
		$(tabLogiCont).addClass('logTabSection');
		$(tabLogiLink).click(function(e) {
			e.preventDefault();
			var tabLogOn = $('.logTabSection.on');
			$(tabLogOn).removeClass('on');
			$(this).closest('.logTabSection').addClass('on');
		});
	}

	//2detph 탭 디자인 class 삽입
	depthTab();
	function depthTab(){
		if(!$('.tabWrapS').length) return;
		var $tabWrap2 = $('.tabWrapS');
		$tabWrap2li = $('.tabWrapS li:last');
		$tabWrap2li.addClass('lc');
	}

	// 더보기,닫기 공통으로 사용하기 - 확인완료
	$('a[href^="#uiShowHide_"]').click(function(e) {
		e.preventDefault();
		var $target = $(this).attr('href');
		var $targetId = $target.slice(1);
		var $targetIdV = $('#'+$targetId);
		if ($targetIdV.is(':hidden')) {
			$targetIdV.show();
			$(this).hide();
		} else{
			$targetIdV.hide();
			$targetIdV.parent().find('.btnTblArrow').show();
			$targetIdV.parent().find('.btnSpDetail').show(); /* 카테고리 기획전 */
		}
	});

	//내용보기, 내용닫기 공통으로 사용하기  - 확인완료
	$('a[href^="#uiToggle_"]').click(function(e) {
		e.preventDefault();
		var $target = $(this).attr('href');
		var $targetId = $target.slice(1);
		var $targetIdV = $('#'+$targetId);
		if ($targetIdV.is(':hidden')) {
			$targetIdV.show();
			$(this).addClass('open').find('span').text('내용닫기');
		} else{
			$targetIdV.hide();
			$(this).removeClass('open').find('span').text('내용보기');
		}
	});
	
	//자세히 보기
	$('a[href^="#uiDetail_"]').click(function(e) {
		e.preventDefault();
		var $target = $(this).attr('href');
		var $targetId = $target.slice(1);
		var $targetIdV = $('#'+$targetId);
		if ($targetIdV.is(':hidden')) {
			$targetIdV.show();
			$(this).addClass('open').find('span.hide').text('내용닫기');
		} else{
			$targetIdV.hide();
			$(this).removeClass('open').find('span.hide').text('내용보기');
		}
	});

	//AP선택 클릭시 - 확인완료
	$(document).on('click', '.apListWrap a', function(e) {//$('.apListWrap a').click(function(e) { 20150417 : 개발팀요청으로 수정
		e.preventDefault();
		var $addMarkup =$('<span class="hide">현재 선택한 AP</span>');
		var $apOn = $('.apListWrap a[class=uiApOn]');
		var $apOnSrc = '_on.gif';
		var $apOffSrc = '_off.gif';
		if($apOn.length){
			$apOn.find('img').attr('src',$apOn.find('img').attr('src').replaceEnd($apOnSrc,$apOffSrc));
			$apOn.find('span[class=hide]').remove();
			$apOn.removeClass('uiApOn');
		}
		$(this).addClass('uiApOn');
		$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($apOffSrc,$apOnSrc));
		$(this).prepend($addMarkup);
	});

	//AP안내 버튼 클릭시 - 확인완료
	$(document).on('click', '.uiApBtnOpen', function(e) { //$('.uiApBtnOpen').click(function(e) { 20150417 : 개발팀요청으로 수정
		e.preventDefault();
		$('.uiApSelShow li').removeClass('on');
		$('.tabInfoWrap').hide();
		var $ckTarget = $('.apListWrap a[class=uiApOn]');
		if($ckTarget.length){
			var clickTarget = $ckTarget.attr('href');
			$('.uiApSelShow li a').each(function(){
				var viewTarget = $(this).attr('href');
				var viewTargetNum = viewTarget.slice(5);
				if(viewTarget == clickTarget){
					$(this).parent().addClass('on');
					$('#uiApView'+viewTargetNum).show();
				}
			});
		}else if($('.picAp').length){
			$('.uiApSelShow li a').each(function(){
				var $userId = $('.picAp').attr('id');
				var $userTarget = '#'+$userId;
				var $viewTarget = $(this).attr('href');
				var $viewTargetNum = $viewTarget.slice(5);
				if($viewTarget == $userTarget){
					$(this).parent().addClass('on');
					$('#uiApView'+$viewTargetNum+'').show();
				}
			});
		}else{
			$('.uiApSelShow li:first-child').addClass('on');
			$('#uiApView01').show();
		}
	});

	//AP안내 레이어 팝업에서 AP클릭시 - 확인완료
	$(document).on('click', '.uiApSelShow li a', function(e) {//$('.uiApSelShow li a').click(function(e) { 20150417 : 개발팀요청으로 수정
		e.preventDefault();
		var $ApSelShow = $('.uiApSelShow li.on');
		if($ApSelShow.length){
			$ApSelShow.removeClass('on');
			$('.tabInfoWrap').hide();
		}
		var viewTarget = $(this).attr('href').slice(5);
		$(this).parent().addClass('on');
		$('#uiApView'+viewTarget).show();
	});

	//팝업창에서의 리스트 클릭 - 확인완료
	if($('#pbPopContent .tabList').length){
		var addMarkup =$('<span class="hide">현재 선택한 컨텐츠</span>');
		$(this).find('li').eq(0).addClass('on').prepend(addMarkup);
	}
	$('.tabList li a').click(function(e) {
		e.preventDefault();
		var $tabAgreeListLink = $('.tabList li');
		var $tabAgreeListOn = $('.tabList li[class=On]');

		if($tabAgreeListLink.hasClass('on') == true){
			$tabAgreeListLink.removeClass('on');
			$tabAgreeListOn.find('span[class=hide]').remove();
		}
		$(this).parent().addClass('on');
		$(this).parent().prepend(addMarkup);

	});

});

window.onload=function(){

	//보안프로그램 영역 제거
	//nProtectFly();
	function nProtectFly(){
		if (!$('#NPKFXX').length) return;
		if(!$('#NPKFXX').hasClass('hide') == true){
			$('#NPKFXX').addClass('hide');
		}
	}
	//EPpluginFly();
	function EPpluginFly(){
		if (!$('#EPplugin').length) return;
		if(!$('#EPplugin').hasClass('hide') == true){
			$('#EPplugin').addClass('hide');
		}
	}

};


function showToggle(){
	if (!$('a[href^="#uiToggle_"]').length) return;
	$('.msgInput .addrMsg').show();
	$('.msgInput a.btnTblArrow').addClass('open').find('span').text('내용닫기');
}
function hideToggle(){
	if (!$('a[href^="#uiToggle_"]').length) return;
	$('.msgInput .addrMsg').hide();
	$('.msgInput a.btnTblArrow').removeClass('open').find('span').text('내용보기');
}



