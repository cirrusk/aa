String.prototype.replaceEnd = function(oldString, newString){
	return this.split(oldString).join(newString);
};


/*!
jQuery word-break keep-all Plugin ver 1.3.0
Copyright 2012, Ahn Hyoung-woo (mytory@gmail.com)
*/
jQuery.fn.wordBreakKeepAll=function(option){var is_there_end_angle_bracket=function(str){return str.lastIndexOf('<')<str.lastIndexOf('>');};var is_there_start_angle_bracket=function(str){return str.lastIndexOf('>')<str.lastIndexOf('<');};var is_there_no_angle_bracket=function(str){return str.lastIndexOf('>')==str.lastIndexOf('<');};var defaultOption={OffForIE:false,useCSSonIE:true};var opt=$.extend(defaultOption,option);if(/MSIE/.test(navigator.userAgent)&&opt.OffForIE==false&&opt.useCSSonIE==true){var addWordBreakKeepAll=function(obj){$(obj).css({'word-break':'keep-all','word-wrap':'break-word'});if($(obj).css('display')=='inline'){$(obj).css('display','block');}};}else if(!/MSIE/.test(navigator.userAgent)||/MSIE/.test(navigator.userAgent)&&opt.OffForIE==false&&opt.useCSSonIE==false){var addWordBreakKeepAll=function(obj){var html=$(obj).html();html=html.replace(/(\r\n|\n|\r)/gm,' ＃＆＊＠§ ');var textArr=html.split(' ');textArr=textArr.filter(function(e){return e;});$(obj).text('');var skip=false;var full_str='';for(var i=0,j=textArr.length;i<j;i++){var str=textArr[i];if(skip==false&&is_there_no_angle_bracket(str)&&str.indexOf('＃＆＊＠§')==-1){full_str+='<span style="white-space: nowrap">'+str+'</span> ';}else{full_str+=str+' ';}
if(is_there_start_angle_bracket(str)){skip=true;}
if(is_there_end_angle_bracket(str)){skip=false;}};$(obj).html(full_str.replace(/＃＆＊＠§/g,"\n"));};}
return this.each(function(){addWordBreakKeepAll(this);});};


jQuery(function($){

	if($('.asideSmart').length){
		asideSmartChk();
	}

	//skip Navigation - 확인완료
	$('#pbSkipNavi a').click(function() {
		var clickHref = $(this).attr('href');
		$('' + clickHref).first().attr('tabindex', 0).focus();
	});

	//첫페이지 설정
	loginMainSet();
	function loginMainSet(){
		if (!$('.mainSetting').length) return;

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
	}

	// footerShotcut
	footerShotcht();
	function footerShotcht() {
		if (!$('.footerShotcut').length) return;
		var footerShowCut = $('.footerShotcut');
		var footerOff = $(footerShowCut).find('.titOff');
		var footerOn = $(footerShowCut).find('.titOn');
		var footerCont = $(footerShowCut).find('> div');
		var footerScLink = $(footerShowCut).find('> a');

		var footerShowCutDiv = $('.footerShotcut .scBrand, .footerShotcut .scFamily');
		var footerContLast = $('.footerShotcut .scBrand a:last, .footerShotcut .scFamily a:last');

		$(footerCont).addClass('footerSiteCont');
		$(footerScLink).addClass('footerScLink');

		$(footerOff).on('mouseover focus click',function(e){
			e.preventDefault();
			$(this).closest().find('.footerSiteCont').hide();
			$(this).closest().find('a[class=titOn]').removeClass('titOn').addClass('titOff');
			$(this).next('.footerSiteCont').show();
			$(this).removeClass('titOff').addClass('titOn');
		});

		$(footerOff).on('mouseleave',function(e){
			e.preventDefault();
			$(this).next('.footerSiteCont').hide();
			$(this).removeClass('titOn').addClass('titOff');
		});

		$(footerShowCutDiv).on('mouseover focus ',function(e){
			e.preventDefault();
			$(this).show();
			$(this).prev('.footerScLink').removeClass('titOff').addClass('titOn');
		});

		$(footerShowCutDiv).on('mouseleave',function(e){
			e.preventDefault();
			$(this).hide();
			$(this).prev('.footerScLink').removeClass('titOn').addClass('titOff');
		});

		$(footerContLast).bind('focusout',function(){
			$(this).closest('.footerSiteCont').hide();
			$(this).closest('.footerSiteCont').prev('.footerScLink').removeClass('titOn').addClass('titOff');
		});
	}

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

	//통합고객센터 공지사항 조회권한 변경 레이어 팝업
	cusModify();
	function cusModify(){
		var modiR = $('.modifyRight');
		if (!$(modiR).length) return;
		var $modiCheck = $(modiR).find('input[type=radio]:checked');
		$modiCheck.each(function(){
			$(modiR).removeClass('on');
			$modiCheck.closest(modiR).addClass('on');
		});

		$(modiR).find('input[type="radio"]').click(function() {
			$(modiR).removeClass('on');
			$(this).closest(modiR).addClass('on');
		});
	}

	//온라인 매거진에서 현재 보고있는 매거진에 문구 넣어주기 - 확인완료
	var $magazineListatView = $('.magazineList.atView');
	if($magazineListatView.length){
		var $magazineOn = $('.magazineList.atView li[class=on]');
		var magazineTxt =$('<span class="hide">현재 화면에서 보고 있는 매거진</span>');
		$magazineOn.prepend(magazineTxt);
	}

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

	// 브랜드 체험센터 탭 - 확인완료
	var $brandTabW = $('.brandTabWrap');
	if($brandTabW.length){
		var $brandTabLink = $('.brandTabWrap a');
		var $brandDetail = $('.brandDetail');

		$brandTabLink.eq(0).addClass('on');
		$brandDetail.eq(0).show();

		$brandTabLink.click(function(e) {
			e.preventDefault();
			var $target = $(this).attr('href');
			var $brandOnSrc = '_on.gif';
			var $brandOffSrc = '_off.gif';

			$brandDetail.hide();
			if($brandTabW.find('a').hasClass('on') == true){
				$brandTabW.find('a[class=on]>img').attr('src',$brandTabW.find('a[class=on]>img').attr('src').replaceEnd($brandOnSrc,$brandOffSrc));
				$('.brandTabWrap a[class=on]').removeClass('on');
			}
			$($target).show();
			$(this).addClass('on');
			$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($brandOffSrc,$brandOnSrc));
		});
	}

	//국제 후원자 입력, 입력취소 - 확인완료
	$('#uiSponsorBtn').click(function(e) {
		e.preventDefault();
		if ($(this).next('div').is(':hidden')) {
			$(this).next('div').show();
			$(this).addClass('open');
			$(this).find('span').text('국제후원자 입력취소');
			$(this).attr('title','닫기');
		} else {
			$(this).next('div').hide();
			$(this).removeClass('open');
			$(this).find('span').text('국제후원자 입력');
			$(this).attr('title','열기');
		}
	});

	// utility 약관 tab
	agInfoTab();
	function agInfoTab(){

		if (!$('.agTabList').length) return;
		var agTabList = $('.agTabList');
		var agTabListDiv = $(agTabList).find('> li');
		var agTabLink = $(agTabListDiv).find('a.tit');
		var agTabCont = $('.agTabCont');

		$(agTabListDiv).eq(0).addClass('on');
		$(agTabCont).hide();
		$(agTabCont).eq(0).show();
		$(agTabListDiv).addClass('agTabWrap');

		$(agTabLink).click(function(e) {
			e.preventDefault();
			$(agTabListDiv).removeClass('on');
			$(this).closest('.agTabWrap').addClass('on');
			$(agTabCont).hide();
			$(this).nextAll(agTabCont).show();
		});
	}

	// 쇼핑 탭
	spInfoTab();
	function spInfoTab(){
		if (!$('.spTabList').length) return;
		$('.spTabList a').eq(0).parent().addClass('on');
		$('.spTabCont').hide();
		$('.spTabCont').eq(0).show();

		$('.spTabList a').on('click focus',function(e){
			e.preventDefault();
			var obj = $(this).attr('href');
			$('.spTabCont').hide();
			$(obj).show();
			$('.spTabList a').parent().removeClass('on');
			$(this).parent().addClass('on');
		});
	}

	//input 위에 있는 label toggle - 확인완료
	reLogInputChk();
	function reLogInputChk(){
		if(!$('.utilityBox .utilityInput input').length) return;
		if($('.utilityBox .bgId input').val()){
			$('.utilityBox .bgId label').addClass('hide');
		}
		if($('.utilityBox .bgPw input').val()){
			$('.utilityBox .bgPw label').addClass('hide');
		}
	}
	LogInputChk();
	function LogInputChk(){
		if(!$('.loginCont .loginInput input').length) return;
		if($('.loginCont .loginInput input#username').val()){
			$('label[for=username]').addClass('hide');
		}
		if($('.loginCont .loginInput input#password').val()){
			$('label[for=password]').addClass('hide');
		}
	}
	losSchChk();
	function losSchChk(){
		if(!$('.losmapSearch input').length) return;
		if($('.losmapSearch input').val()){
			$('.losmapSearch label').addClass('hide');
		}
	}

	$('.utilityBox .utilityInput input, .loginCont .loginInput input, .losmapSearch input').on('keyup focus ',function(){
		var $inpId = $(this).attr('id');
		$(this).closest('fieldset').find('label[for=' + $inpId + ']').toggleClass('hide',this !== '');
	}).on('focusout',function(){
		var $inpId = $(this).attr('id');
		var value = $(this).val();
		if(value == ''){
			$(this).closest('fieldset').find('label[for=' + $inpId + ']').removeClass('hide');
		}
	});

	$('.utilityBox .utilityInput input, .loginCont .loginInput input, .losmapSearch input').each(function(){
		var $inpId = $(this).attr('id');
		if($(this).val() != ''){
			var $label = $(this).closest('fieldset').find('label[for=' + $inpId + ']');
			!$label.hasClass("hide") && $label.addClass('hide');
		}
	});


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

	// 쇼핑 설치정보, 배송정보 더보기
	if($('.myOderDeliWrap').length){
		$('.btnTblArrow').click(function(e) {
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
			$(this).closest('.myOderDeliTbl').prev('.deliAddrList').find('.btnTblArrow').show().focus();
		});
	}

	//쇼핑의 배송지 선택에서   - 확인완료
	var $deliListArea = $('table td.deliListArea');
	if($deliListArea.length){
		$('.btnTblArrow').eq(0).addClass('open').find('span').text('내용닫기');
		$('.addrMsg').eq(0).show();
	}


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


	//쇼핑의 배송메시지
	deliveryMsg();
	function deliveryMsg(){
		if (!$('.deliveryMessage').length) return;
		var deriveryMsg = $('.deliveryMessage');
		var deliveryMsgIpt = $(deriveryMsg).find('.txt');
		var deliveryMsgCont = $(deriveryMsg).find('div');

		$(deliveryMsgIpt).addClass('deliveryIpt');
		$(deliveryMsgCont).addClass('deliveryMsgCont');

		$('.deliveryMessage input').on('keyup focus ',function(){
			var $inputVal = $(this).val();

			if($inputVal !== ''){
				$(this).nextAll('.deliveryMsgCont').hide();

			} else {
				$(this).nextAll('.deliveryMsgCont').show();
			}
		});
		$('.deliveryMessage > div > a').click(function(e) {
			e.preventDefault();
			var clickText = $(this).text();
			$(this).closest('.deliveryMsgCont').prevAll('.deliveryIpt').val(clickText).focus();
			$(this).closest('.deliveryMsgCont').hide();
		});

		$('.deliveryMessage > div a:last-child').focusout(function() {
			$(this).closest('.deliveryMsgCont').hide();
		});
	}


	//AP선택 클릭시 - 확인완료 20150528 : 개발팀요청으로 삭제
	//$(document).on('click', '.apListWrap a', function(e) {//$('.apListWrap a').click(function(e) { 20150417 : 개발팀요청으로 수정
	//	e.preventDefault();
	//	var $addMarkup =$('<span class="hide">현재 선택한 AP</span>');
	//	var $apOn = $('.apListWrap a[class=uiApOn]');
	//	var $apOnSrc = '_on.gif';
	//	var $apOffSrc = '_off.gif';
	//	if($apOn.length){
	//		$apOn.find('img').attr('src',$apOn.find('img').attr('src').replaceEnd($apOnSrc,$apOffSrc));
	//		$apOn.find('span[class=hide]').remove();
	//		$apOn.removeClass('uiApOn');
	//	}
	//	$(this).addClass('uiApOn');
	//	$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($apOffSrc,$apOnSrc));
	//	$(this).prepend($addMarkup);
	//});

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
			$('.uiApSelShow').children('li:first').find('a').trigger('click');
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

	popUserSet();
	function popUserSet() {
		if($('.conditionSetting div.off').length){
			var $conSetDiv = $('.conditionSetting div');
			//$conSetDiv.find('select').attr('tabindex', -1).focus();
			$conSetDiv.find('select').attr('disabled','disabled');
			//$conSetDiv.find('input').attr('tabindex', -1).focus();
			$conSetDiv.find('input').attr('disabled','disabled');
			$conSetDiv.attr('aria-hidden', 'true');
		}
		var $userOnSrc = '_on.gif';
		var $userOffSrc = '_off.gif';
		var $conSetLink = $('.conditionSetting h3 a');

		var $uiSeting = $('div[id^="uiSeting_"]');
		if($uiSeting.hasClass('on') == true){
			$('.conditionSetting .on').parent().find('h3 img').attr('src',$('.conditionSetting .on').parent().find('h3 img').attr('src').replaceEnd($userOffSrc,$userOnSrc));
			//$uiSeting.find('select').attr('tabindex', 0).focus();
			$uiSeting.find('select').removeAttr('disabled');
			//$uiSeting.find('input').attr('tabindex', 0).focus();
			$uiSeting.find('input').removeAttr('disabled');
			$uiSeting.attr('aria-hidden', 'false');
		}

		$conSetLink.click(function(e){
			e.preventDefault();
			var $target = $(this).attr('href');
			var $targetId = $target.slice(1);
			var $targetIdV = $('#'+$targetId);

			if($(this).hasClass('on') == true){
				$(this).removeClass('on');
				$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($userOnSrc,$userOffSrc));

				$targetIdV.addClass('off');
				//$targetIdV.find('select').attr('tabindex', -1).focus();
				$targetIdV.find('select').attr('disabled','disabled');
				//$targetIdV.find('input').attr('tabindex', -1).focus();
				$targetIdV.find('input').attr('disabled','disabled');
				$targetIdV.attr('aria-hidden', 'true');
				$('a[href="#'+$targetId+'"]').focus();
			}else{
				$(this).addClass('on');
				$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($userOffSrc,$userOnSrc));
				$targetIdV.removeClass('off');
				//$targetIdV.find('select').attr('tabindex', 0).focus();
				$targetIdV.find('select').removeAttr('disabled');
				//$targetIdV.find('input').attr('tabindex', 0).focus();
				$targetIdV.find('input').removeAttr('disabled');
				$targetIdV.attr('aria-hidden', 'false');
				$('a[href="#'+$targetId+'"]').focus();
			}
		});
	}

	//상세검색 열기 - 확인완료
	$('#uiDetailSrcOpen').click(function() {
		$('.detailSrcBox').show();
	});
	$('#uiDetailSrcClose').click(function() {
		$('.detailSrcBox').hide();
	});
	$('#uiDetailSrcReset').click(function() {
		$('.totalSearch input[type=text]').val('');
		$('.totalSearch select option:eq(0)').attr('selected','selected');
	});


	losSortBtn();
	function losSortBtn(){
		if (!$('.tblListLos').length) return;
		$('.btnSortingDown, .btnSortingUp, .btnSortingLos').click(function(e){
			e.preventDefault();
			var losBtn = $('.btnSortingDown, .btnSortingUp, .btnSortingLos');
			var losBtnOn = $('.btnSortingDown.on, .btnSortingUp.on, .btnSortingLos.on');
			var losBtnTxt =$('<span class="hide">선택됨</span>');

			$(losBtnOn).removeClass('on');
			$(losBtn).next('span[class=hide]').remove();
			$(this).addClass('on');
			$(this).after(losBtnTxt);
		});
	}

	// LOSMAP 트리
	if($('.losmapTreeWrap').length){
		var losTableH = $('.losmapTbl table tbody').outerHeight();
		var losTree = $('.losTree');
		losTree.find('li:has("ul")').prepend('<a href="#none" class="btnLosDownline">LOS 프론트라인 열기</a>');
		losTree.find('li:has("ul ul")').prepend('<a href="#none" class="btnLosAll">LOS 전체 열기</a>');


		losTree.find('li:last').addClass('end');

		if(!losTree.next('ul').is(':hidden')){
			$('.losTree>li:eq(0)>.btnLosAll').addClass('up').text('LOS 전체 닫기');
			$('.losTree>li:eq(0)>.btnLosDownline').addClass('up').text('LOS 프론트라인 닫기');
		}

		if(!$('.losmapWrap.groupReTotal').length) {
			//$('.losmapTree').css({'height':losTableH+17+'px'});
			$('.losmapTree').css({'height':losTableH+'px'});
		}
	}

	//LOSMAP 트리 초기 체크박스 세팅
	if($('.losCheck').length){
		if($('.losTree').length){
			$('.losCheck').each(function(){
				var parentL= $('.losTree').offset().left;
				var targetL =$(this).offset().left;
				var losCheckPos = (targetL-parentL)+20;
				//alert(losCheckPos);
				$(this).css({'left':'-'+ losCheckPos +'px'});
			});
		}
	}

	//로스맵 트리 전체 열기
	$('.btnLosAll').click(function(e){
		e.preventDefault();
		var targetP = $(this).parent();
		var targetUl = $(this).parent().find('ul');

		if (targetUl.css('display') == 'none'){
			targetUl.slideDown(100);
			targetP.addClass('open');
			$(this).addClass('up');
			$(this).next().addClass('up').text('LOS 프론트라인 닫기');
			targetUl.find('.btnLosAll').addClass('up').text('LOS 전체 닫기').parent().addClass('open');
			targetUl.find('.btnLosDownline').addClass('up').text('LOS 프론트라인 닫기').parent().addClass('open');
			$(this).text('LOS 전체 닫기');
			targetUl.find('li:last-child').addClass('lc');
			targetP.removeClass('close');
		} else {
			targetUl.slideUp(100);
			targetP.removeClass('open');
			$(this).removeClass('up');
			$(this).next().removeClass('up').text('LOS 프론트라인 열기');
			targetUl.find('.btnLosAll').removeClass('up').text('LOS 전체 열기').parent().removeClass('open');
			targetUl.find('.btnLosDownline').removeClass('up').text('LOS 프론트라인 열기').parent().removeClass('open');
			$(this).text('LOS 전체 열기');
			targetUl.find('li:last-child').removeClass('lc');
			targetP.addClass('close');
		}
		if(targetUl.find('.losCheck').length){
			targetUl.find('.losCheck').each(function(){
				var parentL= $('.losTree').offset().left;
				var targetL =$(this).offset().left;
				var losCheckPos = (targetL-parentL)+20;
				//alert(losCheckPos);
				$(this).css({'left':'-'+ losCheckPos +'px'});
			});
		}
	});

	//로스맵 다운라인 전체 열기
	$('.btnLosDownline').click(function(e){
		e.preventDefault();
		var targetP = $(this).parent();
		var targetUl = $(this).parent().find('>ul');
		if (targetUl.css('display') == 'none'){
			targetUl.slideDown(100);
			targetP.addClass('open');
			$(this).addClass('up');
			$(this).text('LOS 프론트라인 닫기');
			targetUl.find('li:last-child').addClass('lc');
			targetP.removeClass('close');
		} else {
			targetUl.slideUp(100);
			targetP.removeClass('open');
			$(this).removeClass('up');
			$(this).text('LOS 프론트라인 열기');
			targetUl.find('li:last-child').removeClass('lc');
			targetP.addClass('close');
		}
		if(targetUl.find('.losCheck').length){
			targetUl.find('.losCheck').each(function(){
				var parentL= $('.losTree').offset().left;
				var targetL =$(this).offset().left;
				var losCheckPos = (targetL-parentL)+20;
				//alert(losCheckPos);
				$(this).css({'left':'-'+ losCheckPos +'px'});
			});
		}
	});

	//제품 상세보기 아코디언 tab - 확인완료
	accodTab();
	function accodTab(){
		if (!$('.accodTab').length) return;
		var accodTabSec = $('.accodTab section');
		var accodTabCont = $(accodTabSec).find('> div');
		var accodLink = $('.accodTab h2 a');

		$(accodTabSec).addClass('accodSection');
		$(accodTabCont).attr('tabindex', 0);
		$(accodTabCont).focusin(function(e) {
			e.preventDefault();
			$(this).addClass('onFocus');
		});
		$(accodTabCont).focusout(function(e) {
			e.preventDefault();
			$(accodTabCont).removeClass('onFocus');
		});
		$(accodLink).click(function(e){
			e.preventDefault();
			$(accodTabSec).removeClass('on');
			$(this).closest('.accodSection').addClass('on');
		});
	}

	//제품메인, 상세보기 탭
	shopSpecial();
	function shopSpecial(){
		if (!$('.specialWrap').length) return;
		var specialSec = $('.specialWrap section');
		var specialLink = $('.specialWrap h3 a');
		$(specialSec).addClass('specialSection');
		$(specialLink).click(function(e){
			e.preventDefault();
			$(specialSec).removeClass('on');
			$(this).closest('.specialSection').addClass('on');
		});
	}

	//쇼핑 전체메뉴 보기
	if($('.shoppingTopMenu').length){
		$('#uiShoppingMenuAll').click(function(){
			if($(this).hasClass('on') == true){
				$('.wholeMenu').hide();
				$('#uiShoppingMenuAll > img').attr('src','/_ui/desktop/images/main/shoppingTop_m01.png');
				$(this).removeClass('on');
			}else{
				$('.wholeMenu').show();
				$('#uiShoppingMenuAll > img').attr('src','/_ui/desktop/images/main/shoppingTop_m01_on.png');
				$(this).addClass('on');
			}
			return false;
		});
		$('.wholeMenu .btnClose').click(function(){
			$('.wholeMenu').hide();
			$('#uiShoppingMenuAll > img').attr('src','/_ui/desktop/images/main/shoppingTop_m01.png');
			$('#uiShoppingMenuAll').removeClass('on');
			return false;
		});
	}

	categoryTab();
	function categoryTab(){
		if(!$('.tabWrap2').length) return;
		var $tabWrap2 = $('.tabWrap2');
		var tabWrapH  =  $tabWrap2.outerHeight();
		var tabHeight = $('ul.tabDepth').height();
		var tabLiH    = $('ul.tabDepth > li').outerHeight();

		//$('.tabDepth > li:nth-of-type(5n)').addClass('lc');
		$('.tabDepth > li:nth-child(5n)').addClass('lc');
		$('.proListTop').addClass('ep');

		if(!$('.tabWrap2 li .tabS').length) return;

		var tabSH    = $('ul.tabDepth li .tabS').outerHeight();
		var tabLiNum  = $('ul.tabDepth > li').length;
		var pNum = 5;
		var tabLiPNum = Math.ceil(tabLiNum/pNum);
		var tabWrapTotal = tabLiH * tabLiPNum;
		var tabTotalH = tabWrapTotal + tabSH;

		if ($('ul.tabDepth li.on').find('.tabS').css('display') == 'block'){
			$tabWrap2.css({'height':tabTotalH+'px'});
		} else {
			$tabWrap2.css({'height':tabWrapTotal+'px'});
		}

	}


	//아카데미 자료실 목록전환
	$('.listTypeSet').each(function() {
		$('.listTypeSet a.img').click(function(e) {
			e.preventDefault();
			$(this).siblings('a').removeClass('on');
			$(this).addClass('on');
			$(this).closest('.listType').siblings('.acTxtList').attr('class','acImgList');
		});
		$('.listTypeSet a.list').click(function(e) {
			e.preventDefault();
			$(this).siblings('a').removeClass('on');
			$(this).addClass('on');
			$(this).closest('.listType').siblings('.acImgList').attr('class','acTxtList');
		});
		$('.listTypeSet a.label').click(function(e) {
			e.preventDefault();
			$(this).siblings('a').removeClass('on');
			$(this).addClass('on');
		});
	});


	//aside scroll
	var $asideMenu = $('#pbAside');
	if($asideMenu.length){
		var $pbContainer = $('#pbContainer');
		var $guideBarSide = $('#uiGuideBar');
		var $oderBoxSide = $('#payment_sum_area');
		var asideTop = $asideMenu.position().top;
		var asideHeight = $asideMenu.outerHeight();
		var footerHeight = $('#pbFooter').outerHeight();

		movAside();

		$(window).scroll(function(){
			movAside();
		});
		$(window).resize(function(){
			movAside();
		});
	}

	function movAside(){
		var docHeight = $(document).height();
		var containerT = $pbContainer.offset().top;
		var containerH = $pbContainer.outerHeight();
		var asideBotPos = containerH-asideHeight-asideTop;
		var asideLimitPos = docHeight - footerHeight - (asideHeight+asideTop*2);

		if($guideBarSide.length){
			var guideHeight = $guideBarSide.outerHeight();
			var asideBotPos = containerH-asideHeight;
			var asideLimitPos = docHeight - footerHeight-guideHeight-(asideHeight+asideTop);
		}
		if($oderBoxSide.length){
			var orderTop=$oderBoxSide.offset().top;
			var orderCssTop= $oderBoxSide.position().top;
			var orderHeight=$oderBoxSide.outerHeight();
			var orderBotPos = containerH-orderHeight-78;
			var orderLimitPos = docHeight - footerHeight-(orderHeight+78);
		}

		var windowW = $(window).width();
		var containerL = $pbContainer.offset().left;
		var asideL = containerL + 760;
		var scrollL = $(document).scrollLeft();
		var scrollT = $(document).scrollTop();

		if(scrollT <= containerT){
			$asideMenu.css('position','absolute').css({'top':asideTop +'px','left':'50%','margin-left':'445px'});
		}else if( scrollT< asideLimitPos){
			if(windowW<1070){
				$asideMenu.css('position', 'fixed').css({'top':asideTop +'px','left':'0','margin-left':asideL-scrollL+220+'px'});
			}else{
				$asideMenu.css('position', 'fixed').css({'top':asideTop +'px','left':'50%','margin-left':'445px'});
			}
		}else if(scrollT> asideLimitPos){
			$asideMenu.css('position', 'absolute').css({'top':asideBotPos+'px','left':'50%','margin-top':'0px','margin-left':'445px'});
		}
		if($oderBoxSide.length){
			if(scrollT < 320){
				$oderBoxSide.css('position','absolute').css({'top':'203px','left':'50%','margin-left':'225px'});
			}else if(scrollT < orderLimitPos){
				if(windowW<1070){
					$oderBoxSide.css('position', 'fixed').css({'top':asideTop+'px','left':'0','margin-left':asideL-scrollL+'px'});
				}else{
					$oderBoxSide.css('position', 'fixed').css({'top':asideTop+'px','left':'50%','margin-left':'225px'});
				}
			}else if(scrollT > orderLimitPos){
				$oderBoxSide.css('position', 'absolute').css({'top':orderBotPos+'px','left':'50%','margin-left':'225px'});
			}
		}
	}


	// gnb, lnb
	commMenu();
	function commMenu(){

		//GNB 있을 경우
		var lastEvent = null; // gnb, lnb 공통

		var $commMnOnSrc   = '_on.gif';
		var $commMnOverSrc = '_over.gif';
		var $commMnOffSrc  = '_off.gif';

		//gnb 정의
		var $gnbMenu = $('#uiGnb');
		var $gnb1Item = $gnbMenu.find('>li'); //1차메뉴


		//gnb 메뉴 초기 세팅 부분 : 20150330 오류 수정
		gnbSetting();
		function gnbSetting(){
			$('ul#uiGnb li a').each(function(){
				if($('ul#uiGnb li>a').hasClass('current') == true){
					var $uiGnbli = $('ul#uiGnb li a[class=current]');
					$uiGnbli.find('img').attr('src',$uiGnbli.find('img').attr('src').replaceEnd($commMnOffSrc,$commMnOnSrc));
				};
			});
		}

		//gnb 오버시
		function gnbOverOut(event){
			var $gnbOn = $(this);
			if (this == lastEvent) return false;
			lastEvent = this;
			setTimeout(function(){ lastEvent=null }, 0);

			if ($gnbOn.next('div').is(':hidden')) {
				if($gnb1Item.hasClass('on') == true){
					var $uiGnbliOn = $('ul#uiGnb li[class=on]');
					if($('ul#uiGnb li[class=on]>a').hasClass('current') == true){
						$uiGnbliOn.find('img').attr('src',$uiGnbliOn.find('img').attr('src').replaceEnd($commMnOverSrc,$commMnOnSrc));
					}else{
						$uiGnbliOn.find('img').attr('src',$uiGnbliOn.find('img').attr('src').replaceEnd($commMnOverSrc,$commMnOffSrc));
					}
					$gnb1Item.removeClass('on');
					$gnb1Item.find('a').next('div').hide();
				}
				$gnbOn.next('div').show();
				$gnbOn.parent().addClass('on');
				if($gnbOn.hasClass('current') == true){
					$gnbOn.find('img').attr('src',$gnbOn.find('img').attr('src').replaceEnd($commMnOnSrc,$commMnOverSrc));
				}else{
					$gnbOn.find('img').attr('src',$gnbOn.find('img').attr('src').replaceEnd($commMnOffSrc,$commMnOverSrc));
				}
			}
		}
		function gnbLeave(){
			$gnb1Item.find('>div').css('display','none');
			$gnb1Item.find('>div').hide();
			$('ul#uiGnb li a').each(function(){

				if($gnb1Item.hasClass('on') == true){
					if($('ul#uiGnb li>a').hasClass('current') == true){
						var $uiGnblia = $('ul#uiGnb li a[class=current]');
						if($('ul#uiGnb li[class=on]>a').hasClass('current') == true){
							$uiGnblia.find('img').attr('src',$uiGnblia.find('img').attr('src').replaceEnd($commMnOverSrc,$commMnOnSrc));
						}
					}
					var $uiGnbliOn = $('ul#uiGnb li[class=on]');
					$uiGnbliOn.find('img').attr('src',$uiGnbliOn.find('img').attr('src').replaceEnd($commMnOverSrc,$commMnOffSrc));
					$gnb1Item.removeClass('on');
				}

			});
		}
		//gnb 아웃시
		$('#uiGnb').mouseleave(gnbLeave);

		// gnb 클릭
		$gnb1Item.find('>a').mouseover(gnbOverOut).focus(gnbOverOut);
		$('.gnbDiv03 ul li:last').focusout(gnbLeave);
		$('.btnSearch').focus(gnbLeave);

		$('.uiGnb li a:first-child, .gnbDiv03 ul li:last-child a:last-child').focusout(function(e) {
			$('.footerShotcut ').next('div').hide();
		});

	}


	// 사이드바 슬라이드
	asidePaging();
	function asidePaging() {
		var $asideBody		= $('.asideToday .asideCanv ul').eq(0);
        var $asideTotl      = $('.asideToday h2').eq(0).children('span').eq(0);
		var $asideList		= $asideBody.children('li');
		var $asideCtrl		= $('.asideToday .asideCtrl').eq(0).find('a');
		var $asideSum		= $('.asideToday .aisdeTodaySum').eq(0);
		var wPlus			= $('.asideToday .asideCanv').width();
		var wMinus			= '-' + wPlus + 'px';
		var pgCount			= $asideList.length;
		var pgTotal         = 0;
		var pgNow, moveAc, asideBefore, eff, speed;

		$asideList.children('.asidePage').hide();
		$asideList.eq(0).show().addClass('on').children('.asidePage').show();

        for (i = 0; i < $asideList.length; i ++) {
            var dvPage = $asideList.eq(i).children('.asidePage');
            var liPage = dvPage.find('li');
            for (j = 0; j < liPage.length; j ++)
                if (liPage.eq(j).children().length > 0)
                    pgTotal ++;
        }

		$asideSum.html('<span class="hide">현재 페이지:</span><strong>' + (pgTotal > 0 ? 1 : 0) + '</strong>/<span class="hide">전체 페이지:</span>' + (pgTotal > 0 ? pgCount : 0));

		$asideTotl.html(pgTotal + '');
		if (pgTotal == 0) {
			$.merge($('.aisdeTodaySum'), $('.asideCanv'), $('.asideCtrl')).hide();
			$asideCtrl.hide();
		} else if (pgCount == 1) {
			$asideCtrl.hide();
		}

		$asideCtrl.on("click", function(e) {
			var clickBtn = $(this).attr('class');
			if(clickBtn == 'btnTodayPre'){
				pgNow = ($asideBody.children('.on').index() + pgCount - 1) % pgCount;
				moveAc = 'movePrev';
			} else if(clickBtn == 'btnTodayNext'){
				pgNow = ($asideBody.children('.on').index() + pgCount + 1) % pgCount;
				moveAc = 'moveNext';
			}

            if ($asideList.length > 1) {
                asidePgMv(pgNow, moveAc);
                $asideSum.html('<span class="hide">현재 페이지:</span><strong>' + (pgNow + 1) + '</strong>/<span class="hide">전체 페이지:</span>' + pgCount);
            }
		});

		function asidePgMv(asideNow, moveAc) {
			asideBefore =	$asideBody.children('.on').index();
			$asideList.removeClass('on');
			eff = 'swing';
			speed = 700;

			if(moveAc == 'moveNext'){
				$asideList.eq(asideBefore).children('.asidePage').css('z-index','1').stop().animate({'left': wMinus},speed, eff, function(){
					$(this).hide();
				});

				$asideList.eq(asideNow).addClass('on').children('.asidePage').css('left',wPlus).show().stop().animate({'left': 0 },speed, eff);
			}  else if(moveAc == 'movePrev'){
				$asideList.eq(asideBefore).children('.asidePage').css('z-index','1').stop().animate({'left': wPlus},speed, eff, function(){
					$(this).hide();
				});

                $asideList.eq(asideNow).addClass('on').children('.asidePage').css('left',wMinus).show().stop().animate({'left': 0 },speed, eff);
			}
		}
	}

	// 기획상품 슬라이드(무한)
    productSlideInit();
	function productSlideInit() {
		var $aMask  = $('.spDetail .productBox .productSlidingMask');
		var $aCtrl  = $('.spDetail .productBox').children('a');
		var $aList  = $aMask.children('.productList').children('.proListImg');
		var $aComp  = $('.spDetail .productBox .productSlidingMask .productList');
		var cWidth	= $aList.eq(0).children('li').eq(0).innerWidth();
		var itemPerPage	= 4;
		var efSpeed		= 700;
		var efType		= 'swing';

		adjustListSize();

		for (i = 0; i < $aList.length; i ++){
			$aList.eq(i).children('li').eq(0).addClass('on');
			if($aList.eq(i).children('li').length < 5){
				$aList.eq(i).parents('.productBox').children('a').hide();
			}
		}

		$aList.children('li').find('a').on('focus', function(ev) {
			var $pBack  	= $(this).parents('.productList');
			var $pLi		= $(this).parents('li');
			var $pUl		= $pLi.parent();
			var $pCol		= $pUl.children('li');
			var pgCur		= $pUl.children('.on').index();
			var pgFoc		= $pLi.index();
			var pgNow;

			if (pgFoc < pgCur) {	//	scroll left (prev)
				pgNow = pgCur - itemPerPage;
				$pCol.eq(pgCur).removeClass('on');
				$pCol.eq(pgNow).addClass('on');

				$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
			} else if (pgFoc - pgCur >= itemPerPage) {	// scroll right (next)
				pgNow = pgCur + itemPerPage;
				$pCol.eq(pgCur).removeClass('on');
				$pCol.eq(pgNow).addClass('on');

				$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
			}
		});

		$aCtrl.on('click', function(ev) {
			ev.preventDefault();

			var $pMask		= $(this).parent().children('.productSlidingMask');
			var $pBack  	= $pMask.children('.productList');
			var $pList  	= $pBack.children('.proListImg');
			var $pCol		= $pList.children('li');
			var mvDir   	= $(this).attr('class');
			var pgCount		= $pCol.length;
			var pgBefore	= $pList.children('.on').index();
			var pgNow, lfNow;

			if($pBack.is(':animated')){
				return false;
			}

			switch(mvDir) {
				case 'btnPrev' :
					pgNow = pgBefore - itemPerPage;

					if (pgNow >= 0) {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(pgNow).addClass('on');

						$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
					} else {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(pgCount - (pgCount % itemPerPage > 0 ? pgCount % itemPerPage : itemPerPage)).addClass('on');

						var cLeft = parseInt((pgCount - 1) / itemPerPage) * itemPerPage * cWidth;
						var $pProxy = $pBack.clone();
						$pMask.append($pProxy);
						$pProxy.css('left', '-' + $pBack.width() + 'px');

						$pProxy.stop(true).animate({'left': - cLeft }, efSpeed, efType, function() {
							$pProxy.remove();
						});

						$pBack.stop(true).animate({'left': $pBack.width() - cLeft }, efSpeed, efType, function() {
							$pBack.css('left', '-' + cLeft + 'px');
						});
					}
					break;
				case 'btnNext' :
					pgNow = pgBefore + itemPerPage;

					if (pgNow < pgCount) {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(pgNow).addClass('on');

						$pBack.stop(true).animate({'left': - pgNow * cWidth }, efSpeed, efType);
					} else {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(0).addClass('on');

						var cLeft = $pBack.width();
						var $pProxy = $pBack.clone();
						$pMask.append($pProxy);
						$pProxy.css('left', $pMask.width() + 'px');

						$pBack.stop(true).animate({'left': - cLeft }, efSpeed, efType, function() {
							$pBack.css('left', '0px');
						});

						$pProxy.stop(true).animate({'left': 0 }, efSpeed, efType, function() {
							$pProxy.remove();
						});
					}
					break;
			}
		});

		function adjustListSize() {
			for (i = 0; i < $aList.length; i ++) {
				var colCnt = $aList.eq(i).children('li').length;
				colCnt = colCnt % itemPerPage > 0 ? parseInt(colCnt / itemPerPage + 1) * itemPerPage : colCnt;
				$aList.eq(i).parent().css('width', (colCnt * cWidth) + 'px');
			}
		}
	}


    // 2차분류 슬라이드(무한)
    //secondSlideInit();
    function secondSlideInit() {
        var $aMask  = $('.brandListWrap .brandListMask');
        var $aCtrl  = $('.brandListWrap').children('a');
        var $aList  = $aMask.children('.brandList').children('ul');
		var cWidth	= 215;
        var itemPerPage	= 3;
        var efSpeed		= 700;
		var efType		= 'swing';

        adjustListSize();

        for (i = 0; i < $aList.length; i ++)
            $aList.eq(i).children('li').eq(0).addClass('on');

		$aList.children('li').find('a').on('focus', function(ev) {
			var $pBack  	= $(this).parents('.brandList');
			var $pLi		= $(this).parents('li');
			var $pUl		= $pLi.parent();
			var $pCol		= $pUl.children('li');
			var pgCur		= $pUl.children('.on').index();
			var pgFoc		= $pLi.index();
			var pgNow;

			if (pgFoc < pgCur) {	//	scroll left (prev)
				pgNow = pgCur - itemPerPage;
				$pCol.eq(pgCur).removeClass('on');
				$pCol.eq(pgNow).addClass('on');

				$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
			} else if (pgFoc - pgCur >= itemPerPage) {	// scroll right (next)
				pgNow = pgCur + itemPerPage;
				$pCol.eq(pgCur).removeClass('on');
				$pCol.eq(pgNow).addClass('on');

				$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
			}
		});

        $aCtrl.on('click', function(ev) {
			ev.preventDefault();

			var $pMask		= $(this).parent().children('.brandListMask');
            var $pBack  	= $pMask.children('.brandList');
            var $pList  	= $pBack.children('ul');
			var $pCol		= $pList.children('li');
            var mvDir   	= $(this).attr('class');
            var pgCount		= $pCol.length;
            var pgBefore	= $pList.children('.on').index();
            var pgNow, lfNow;

			switch(mvDir) {
                case 'btnPrev' :
                    pgNow = pgBefore - itemPerPage;

					if (pgNow >= 0) {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(pgNow).addClass('on');

						$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
					} else {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(pgCount - (pgCount % itemPerPage > 0 ? pgCount % itemPerPage : itemPerPage)).addClass('on');

						var cLeft = parseInt(pgCount / itemPerPage) * itemPerPage * cWidth;
						var $pProxy = $pBack.clone();
						$pMask.append($pProxy);
						$pProxy.css('left', '-' + $pBack.width() + 'px');

						$pProxy.stop().animate({'left': - cLeft }, efSpeed, efType, function() {
							$pProxy.remove();
						});

						$pBack.stop().animate({'left': $pBack.width() - cLeft }, efSpeed, efType, function() {
							$pBack.css('left', '-' + cLeft + 'px');
						});
					}
                    break;
                case 'btnNext' :
                    pgNow = pgBefore + itemPerPage;

					if (pgNow < pgCount) {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(pgNow).addClass('on');

						$pBack.stop().animate({'left': - pgNow * cWidth }, efSpeed, efType);
					} else {
						$pCol.eq(pgBefore).removeClass('on');
						$pCol.eq(0).addClass('on');

						var cLeft = $pBack.width();
						var $pProxy = $pBack.clone();
						$pMask.append($pProxy);
						$pProxy.css('left', cLeft + 'px');

						$pProxy.stop().animate({'left': 0 }, efSpeed, efType, function() {
							$pProxy.remove();
						});

						$pBack.stop().animate({'left': - cLeft }, efSpeed, efType, function() {
							$pBack.css('left', '0px');
						});
					}
                    break;
			}
        });

		function adjustListSize() {
			for (i = 0; i < $aList.length; i ++) {
				var colCnt = $aList.eq(i).children('li').length;
				colCnt = colCnt % itemPerPage > 0 ? parseInt(colCnt / itemPerPage + 1) * itemPerPage : colCnt;
				$aList.eq(i).parent().css('width', (colCnt * cWidth) + 'px');
			}
		}
    }

    // 제품 상세 슬라이드
	detailSlideInit();
	function detailSlideInit() {
		var $aMask  = $('.thumbBox .thumbMask');
		var $aBack  = $('.thumbBox .thumbMask .thumbList');
		var $aCtrl  = $('.thumbBox').children('a');
		var $aList  = $aBack.children('ul');
		var $aThmb	= $aList.find('a');
		var cWidth	= 75;
		var itemPerPage	= 4;
		var efSpeed		= 700;
		var efType		= 'swing';
		var sPage = 0;
		var sBtnPageL = $('.thumbBox').find('.btnPrev'); //이전 페이지 보기 버튼
		var sBtnPageR = $('.thumbBox').find('.btnNext'); // 다음 페이지 보기 버튼

		// adjustListSize();
		settingList();

		$aThmb.on('click', function(ev) {
			ev.preventDefault();
			var $pList	= $('.thumbMask .thumbList').children('ul');
			var $pCol	= $pList.children('li');
			$pCol.removeClass('on');
			var imgIdx = $(this).parent().index();
			for (var i = 0; i < $pList.length; i ++)
				$pList.eq(i).children('li').eq(imgIdx).addClass('on');

			var $pPic	= $.merge($('.thumbBox').parent().children('strong.photo').children('a').children('img'), $('.thumbBox').parent().children('strong.photo').children('img'));

			// 섬네일 인덱스 번호로 이미지 지정
			$pPic.attr('src', '/_ui/desktop/images/product/@big_goods_' + imgIdx + '.jpg');

			// 임시로 작은 이미지를 큰 이미지에 보이도록 - 추후 삭제
			var imgSrc	= $(this).children('img').attr('src');
			$pPic.attr('src', imgSrc);
			// --------------------------------- 추후 삭제
		});

		$aCtrl.on('click', function(ev) {
			ev.preventDefault();

			//$('.thumbList li:nth-of-type(4n)').addClass('first'); --- ie8 이하 오류
			$('.thumbList li:nth-child(4n)').addClass('first');

			var isThisPop	= $(this).parents('.thumbBox').parent().attr('class') == 'pbLayerContent';
			var $pMask		= $(this).parent().children('.thumbMask');
			var $pBack  	= $pMask.children('.thumbList');
			var $aBack		= $('.thumbMask .thumbList');
			var $pList  	= $pBack.children('ul');
			var $pCol		= $pList.children('li');
			var mvDir   	= $(this).attr('class');
			var pgCount		= $pCol.length; // li 갯수
			var pbLf		= $pBack.css('left').replace('px', '');
			var pgBefore	= pbLf == 'auto' ? 0 : - parseInt(pbLf) / cWidth;
			var pgNow, lfNow;

			if (pgCount <= itemPerPage) return;
			if($aBack.is(':animated')){
				return false;
			}
			switch(mvDir) {
				case 'btnPrev' :
					pgNow = pgBefore - itemPerPage;

					if (pgNow >= 0) {
						$aBack.stop(true).animate({'left': - pgNow * cWidth }, efSpeed, efType, function(){
							$pBack.css('left', - pgNow * cWidth + 'px');
						});
						//$pBack.stop(true).animate({'left': $pBack.width() - cLeft }, efSpeed, efType, function() {
						//	$pBack.css('left', '-' + cLeft + 'px');
						//});
						sBtnPageR.show();
						if (pgNow == 0) sBtnPageL.hide();
					} else {
						sBtnPageL.hide();
					}
					break;
				case 'btnNext' :
					pgNow = pgBefore + itemPerPage;
					var pgNum = Math.ceil(pgCount/itemPerPage);
					var pIdx = Math.ceil(pgNow/pgNum);

					if (pIdx <= pgNum) {
						$aBack.stop(true).animate({'left': - pgNow * cWidth }, efSpeed, efType);
						sBtnPageL.show();
						if (pIdx == pgNum) sBtnPageR.hide();
					} else {
						sBtnPageR.hide();
					}
					break;
			}
		});

        function settingList(){
        	//최초 이전 페이지 없음 표시
        	sBtnPageL.hide();

        	for (i = 0; i < $aBack.length; i ++) {
				var colCnt = $aBack.eq(i).find('li').length;
				colCnt = colCnt % itemPerPage > 0 ? parseInt(colCnt / itemPerPage + 1) * itemPerPage : colCnt;
				$aBack.eq(i).css('width', (colCnt * cWidth) + 'px');

				if(colCnt == itemPerPage){ // 이미지 갯수가 5개 이상일때만 이전, 다음 페이지 버튼이 활성화 됨
	    			sBtnPageR.hide();
	    		}
			}

        	for (i = 0; i < $aList.length; i ++)
                $aList.eq(i).children('li').eq(0).addClass('on');

        }

        function btnAct(v){
        	if(v == 'btnNext'){
        		if(sPage == itemPerPage-1){
    				$('.btnNext').hide();
    			}
    			if(sPage > 0){
    				$('.btnNext').show();
    			}
    		}
    		if(v == 'btnPrev'){
    			if(sPage == 0){
    				$('.btnPrev').hide();
    			}
    			if(sPage < itemPerPage-1){
    				$('.btnPrev').show();
    			}
    		}

        }
	}


	// 나의 자료실 추가/해제
	//myDownloadButtonInit(); 20150518 개발팀 요청으로 삭제
	function myDownloadButtonInit() {
		var $aBtn	= $('.detailInfo .btnTblMyData');
		var $aBtnOn	= $('.detailInfo .btnTblMyData.on');

		$aBtn.hide();
		$aBtnOn.show();

		$aBtn.on('click', function(ev) {
			ev.preventDefault();

			if ($(this).hasClass('on') > 0) {	// 추가
				//alert('change_to__add_service');
			} else {	// 해제
				//alert('change_to__remove_service');
			}

			$aBtn.show();
			$(this).hide();
		});
	}

	// 비즈니스 자료 용어집 색인 버튼
	dictionalyIndexInit();
	function dictionalyIndexInit() {
		var $aBtn	= $('.indexGlossary a');
		var selTxt	= '<span class="hide">현재 선택한 색인</span>';

		for (i = 0; i < $aBtn.length; i ++)
			if ($aBtn.eq(i).hasClass('on'))
				$aBtn.eq(i).prepend(selTxt);

		$aBtn.on('click', function(ev) {
			for (i = 0; i < $aBtn.length; i ++) {
				if ($aBtn.eq(i).hasClass('on')) {
					$aBtn.eq(i).children('span').remove();
					$aBtn.eq(i).removeClass('on');
				}
			}

			var idx = $(this).html();
			$(this).addClass('on');
			$(this).prepend(selTxt);

			indexHandler(idx);
		});

		function indexHandler(indexStr) {
			//alert('change_to__index_"' + indexStr + '"_handler');
		}
	}


	// 배송지 목록 즐겨찾기
	deliveryBookmarkInit();
	function deliveryBookmarkInit() {
		var $aBtn	= $('table .icoBookmark');

		$aBtn.on('click', function(ev) {
			var rowNum = $(this).parents('tr').children('th').html();

			if ($(this).hasClass('on')) {
				$(this).removeClass('on');
				setBookmarkStatus(rowNum, 'off');
			} else {
				$(this).addClass('on');
				setBookmarkStatus(rowNum, 'on');
			}
		});

		function setBookmarkStatus(num, onoff) {
			alert('change_to__bookmark_' + onoff + '_handler_on_no_' + num);
		}
	}

	serviceCheck();
	function serviceCheck(){
		if (!$('.serviceCheck').length) return;

		serviceSize();

		function serviceSize(){
			var windowW = $(window).width();
			var windowH = $(window).height();

			var contH = $('.sCheckWrap').height();
			var contMarginH = contH / 2;
			var $target = $('.serviceCheck');
			var $cont = $('.sCheckWrap');

			$target.css({ 'height':windowH,'width':windowW});
			$cont.css({ 'height':contH, 'margin-top':-contMarginH});

		}
		$(window).resize(function () { serviceSize() });
	}

	shopCategory.init(); // 쇼핑 - 2차 카테고리 상단 배너

	abnGdCurrent(); // abnguide nav
	function abnGdCurrent(){
		if (!$('.abnGuideJump').length) return;
		var pageClass = $('#abnGuideNav').attr('class').slice(-4);
		var pageMn = $('#abnGuideNav').attr('class').slice(-2);

		var jumpDeps1 = $('.abnGuideJump .m1 .dep');
		var jumpDeps2 = $('.abnGuideJump .m2 .dep');

		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		abnGdJumpRoll();

		if(pageMn == '01'){
			var jump1 = $('#jump1');
			var jump1Li = $(jump1).find('>li');

			$(jump1).parent('li').find('>a').addClass('on');
			if($(jump1).parent('li').find('>a').hasClass('on') == true){
				$(jump1).parent('li').find('>a').find('img').attr('src',$(jump1).parent('li').find('>a').find('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}

			$(jump1Li).each(function(){
				var targetClass =$(this).attr('class').slice(-4);

				if (pageClass == targetClass) {
					$(this).find('>a').addClass('depOn');
					jumpDeps1.find('.depOn img').attr('src',jumpDeps1.find('.depOn img').attr('src').replaceEnd($OffSrc,$OnSrc));
				}
			});
		} else if(pageMn == '02'){
			var jump2 = $('#jump2');
			var jump2Li = $(jump2).find('.deps > span');

			$(jump2).parent('li').find('>a').addClass('on');

			if($(jump2).parent('li').find('>a').hasClass('on') == true){
				$(jump2).parent('li').find('>a').find('img').attr('src',$(jump2).parent('li').find('>a').find('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}

			$(jump2Li).each(function(){
				var targetClass =$(this).attr('class').slice(-4);

				if (pageClass == targetClass) {
					$(this).find('>a').addClass('depsOn');
					$(this).parent('.deps').parent('.d').find('>span').addClass('depOn');
					jumpDeps2.find('.depOn img').attr('src',jumpDeps2.find('.depOn img').attr('src').replaceEnd($OffSrc,$OnSrc));
				}
			});
		}

	}

	function abnGdJumpRoll(){
		var jumpBtn = $('.abnGuideJump').find('.btn');
		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		$('.abnGuideJump .btn').on('click',function(e){
			if(jumpBtn.hasClass('btnOn') == true){
				$('.abnGuideJump').removeClass('jumpOn');
				jumpBtn.removeClass('btnOn').addClass('btnOff');
				$('.dep').hide();
				jumpBtn.text('목록보기');
				return false;
			}else{
				$('.abnGuideJump').addClass('jumpOn');
				jumpBtn.removeClass('btnOff').addClass('btnOn');
				$('.dep').show();
				jumpBtn.text('목록닫기');
				return false;
			}
		});

		$('.abnGuideJump .m1 a, .abnGuideJump .m2 > a').on('mouseover focus',function(e){
			if(!$(this).hasClass('on') == true & !$(this).hasClass('depOn') == true){
				$(this).children('img').attr('src',$(this).children('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}
		});
		$('.abnGuideJump .m1 a, .abnGuideJump .m2 > a').on('mouseleave focusout',function(e){
			if(!$(this).hasClass('on') == true & !$(this).hasClass('depOn') == true){
				$(this).children('img').attr('src',$(this).children('img').attr('src').replaceEnd($OnSrc,$OffSrc));
			}
		});
	}

	spGdJump(); // 쇼핑주문 가이드 navi
	function spGdJump(){
		if (!$('.spGuideJump').length) return;
		var pageClass = $('#spGuideNav').attr('class').slice(-4);
		var jumpDeps = $('.spGuideJump .menuMn');
		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		var menuMn = $('.dep');
		var menuMnLi = $(menuMn).find('>li');

		spGdJumpRoll();

		$(menuMnLi).each(function(){
			var targetClass =$(this).attr('class').slice(-4);

			if (pageClass == targetClass) {
				$(this).find('>a').addClass('depsOn');
				$(this).parent('.dep').parent('.menuMn').find('>a').addClass('depOn');
				jumpDeps.find('.depOn img').attr('src',jumpDeps.find('.depOn img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}
		});
	}

	function spGdJumpRoll(){
		var jumpBtn = $('.spGuideJump').find('.btn');
		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		$('.spGuideJump .btn').on('click',function(e){
			if(jumpBtn.hasClass('btnOn') == true){
				$('.spGuideJump').removeClass('jumpOn');
				jumpBtn.removeClass('btnOn').addClass('btnOff');
				$('.dep').hide();
				jumpBtn.text('목록보기');
				return false;
			}else{
				$('.spGuideJump').addClass('jumpOn');
				jumpBtn.removeClass('btnOff').addClass('btnOn');
				$('.dep').show();
				jumpBtn.text('목록닫기');
				return false;
			}
		});

		$('.spGuideJump .menuMn > a').on('mouseover focus',function(e){
			if(!$(this).hasClass('on') == true & !$(this).hasClass('depOn') == true){
				$(this).children('img').attr('src',$(this).children('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}
		});
		$('.spGuideJump .menuMn > a').on('mouseleave focusout',function(e){
			if(!$(this).hasClass('on') == true & !$(this).hasClass('depOn') == true){
				$(this).children('img').attr('src',$(this).children('img').attr('src').replaceEnd($OnSrc,$OffSrc));
			}
		});

	}


	//abnGdJump(); // ABN 가이드 메뉴
	function abnGdJump(){
		if (!$('.abnGuideJump').length) return;
		var jumpBtn = $('.abnGuideJump').find('.btn');
		var jumpDep = $('.abnGuideJump .menu');
		var jumpDeps = $('.abnGuideJump .dep');
		var jumpMarkup =$('<span class="hide">현재 선택</span>');

		$(jumpBtn).on('click',function(e){
			if($(this).hasClass('btnOn') == true){
				$('.abnGuideJump').removeClass('jumpOn');
				$(this).removeClass('btnOn').addClass('btnOff');
				$('.dep').hide();
				$(this).text('목록보기');
				return false;
			}else{
				$('.abnGuideJump').addClass('jumpOn');
				$(this).removeClass('btnOff').addClass('btnOn');
				$('.dep').show();
				$(this).text('목록닫기');
				return false;
			}
		});

		$('.m1 > a, .m2 > a').on('click',function(e){
			if(jumpBtn.hasClass('btnOn') == true){
				$('.abnGuideJump').removeClass('jumpOn');
				jumpBtn.removeClass('btnOn').addClass('btnOff');
				$('.dep').hide();
				jumpBtn.text('목록보기');
				return false;
			}else{
				$('.abnGuideJump').addClass('jumpOn');
				jumpBtn.removeClass('btnOff').addClass('btnOn');
				$('.dep').show();
				jumpBtn.text('목록닫기');
				return false;
			}
		});

		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		jumpDep.find('.on img').attr('src',jumpDep.find('.on img').attr('src').replaceEnd($OffSrc,$OnSrc));
		jumpDeps.find('.depOn img').attr('src',jumpDeps.find('.depOn img').attr('src').replaceEnd($OffSrc,$OnSrc));
		$('.abnGuideJump .on, .abnGuideJump .depOn').prepend(jumpMarkup);

		$('.abnGuideJump .m1 a, .abnGuideJump .m2 > a').on('mouseover focus',function(e){
			if(!$(this).hasClass('on') == true & !$(this).hasClass('depOn') == true){
				$(this).children('img').attr('src',$(this).children('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}
		});
		$('.abnGuideJump .m1 a, .abnGuideJump .m2 > a').on('mouseleave focusout',function(e){
			if(!$(this).hasClass('on') == true & !$(this).hasClass('depOn') == true){
				$(this).children('img').attr('src',$(this).children('img').attr('src').replaceEnd($OnSrc,$OffSrc));
			}
		});
	}

	abnGdTab(); // ABN 가이드 탭
	/*function abnGdTab(){
		if (!$('.tabs').length) return;

		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		$($('.tabs').find('a.on').attr('href')).show();
		$('.tabs').find('a.on img').attr('src',$('.tabs').find('a.on img').attr('src').replaceEnd($OffSrc,$OnSrc));


		$('.tabs li a').on('click',function(e){
			if($('.tabs li').find('a').hasClass('on') == true){
				$('.tabs li').find('a[class=on]>img').attr('src',$('.tabs li').find('a[class=on]>img').attr('src').replaceEnd($OnSrc,$OffSrc));
			}
			$('.tabs li a').removeClass('on');
			$('.tabCont').hide();
			$(this).addClass('on');
			if($(this).hasClass('on') == true){
				$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}
			var target = $($(this).attr('href'));
			target.show();
			return false;
		});
	} */

	function abnGdTab(){
		if (!$('.abnGuideCont .tabs').length) return;
		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		$('.tabs li a').on('mouseover focus',function(){
			$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($OffSrc,$OnSrc));
		});

		$('.tabs li a').on('mouseleave focusout',function(e){
			$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($OnSrc,$OffSrc));
		});
	}

	spGuideTab();
	function spGuideTab(){

		if (!$('.oderGuideTab').length) return;

		var $OnSrc = '_on.gif';
		var $OffSrc = '_off.gif';

		var oderGuide = $('.oderGuideTab > ul');
		var oderGuideLi = $(oderGuide).find('> li');
		var oderCont = $('.oderGuideCont');

		var sUrl = location.href;

		if (sUrl.indexOf("?")!= -1) {
			var sPage;
			if( sUrl.indexOf("&") != -1 ) {
				sPage = sUrl.substring(sUrl.indexOf("?")+1, sUrl.indexOf("&"));	// & 까지 가져오기로 변경
			} else {
				sPage = sUrl.substr(sUrl.indexOf("?")+1, sUrl.length-1); // AS-IS Logic 이상함.
			}
			var salesComm = "salesComm"; // 중개판매관리 일때 예외 처리
			var installOder = "installOder"; // 설치주문 일때
			var smartOder = "smartOder"; // 스마드 오더 일때
			
			if (sPage == salesComm) {
				$(oderGuideLi).eq(4).find('a').addClass('on');
				$(oderCont).eq(4).show();
			} else if (sPage == installOder){
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

		$(oderGuideLi).find('a.on img').attr('src',$(oderGuideLi).find('a.on img').attr('src').replaceEnd($OffSrc,$OnSrc));

		$(oderGuideLi).find('a').on('click',function(e){
			if($(oderGuideLi).find('a').hasClass('on') == true){
				$(oderGuideLi).find('a[class=on]>img').attr('src',$(oderGuideLi).find('a[class=on]>img').attr('src').replaceEnd($OnSrc,$OffSrc));
			}
			$(oderGuideLi).find('a').removeClass('on');
			$(oderCont).hide();
			$(this).addClass('on');
			if($(this).hasClass('on') == true){
				$(this).find('img').attr('src',$(this).find('img').attr('src').replaceEnd($OffSrc,$OnSrc));
			}
			var target = $($(this).attr('href'));
			target.show();
			return false;
		});
	}

});


function asideSmartChk(){
	$('.asideSmart > a').wordBreakKeepAll({OffForIE: false});
	if ($('.asideSmart > a > span').length){
		$('.asideSmart > a > span').each(function(){
			var textAside = '일시품절/해지/단종';
			var textValue = $(this).html();
			if(textValue == textAside){
				$(this).html('일시품절/해지<br>/단종');
			}
		});
	}
}

var shopCategory = {
	sNum : 3,			//한번에 보여지는 목록 갯수
	sIdx : 0,			//0 ~ n번까지 생성될 수 있음, 목록 순번
	sTarget : null,
	sBox : null,
	sPage : 0,
	sUL : null,			//썸네일 목록 ul
	sLI : null,			//썸네일 목록 li
	sLInum : null,		//썸네일 목록 li 갯수
	sBtnImgL : null,	//이전 이미지 보기 버튼
	sBtnImgR : null,	//다음 이미지 보기 버튼
	easing : 'easeInOutCirc',
	listShow : function(n){
		shopCategory.sLI.each(function(i){
			if(i >= shopCategory.sNum * n && i < (shopCategory.sNum * n) + shopCategory.sNum ) {
				shopCategory.sLI.eq(i).show(); //최초 3개 목록만 보여줌
			} else {
				shopCategory.sLI.eq(i).hide();
			}
		});
	},
	ctrlPage : function(v){
		if(v == 'R' && shopCategory.sPage < shopCategory.sPageNum-1){
			shopCategory.sPage = shopCategory.sPage + 1;
			shopCategory.listShow(shopCategory.sPage);
			shopCategory.txtIns('R');
		}
		if(v == 'L' && shopCategory.sPage > 0){
			shopCategory.sPage = shopCategory.sPage - 1;
			shopCategory.listShow(shopCategory.sPage);
			shopCategory.txtIns('L');
		}
	},
	txtIns : function(v){
		if(v == 'R'){
			if(shopCategory.sPage == shopCategory.sPageNum-1){
				shopCategory.sBtnImgR.hide();
			}
			if(shopCategory.sPage > 0){
				shopCategory.sBtnImgL.show();
			}
		}
		if(v == 'L'){
			if(shopCategory.sPage == 0){
				shopCategory.sBtnImgL.hide();
			}
			if(shopCategory.sPage < shopCategory.sPageNum-1){
				shopCategory.sBtnImgR.show();
			}
		}
	},
	init : function(){
		shopCategory.sTarget = $('.brandListWrap');
		shopCategory.sBox = $('.brandListMask');
		shopCategory.sUL = shopCategory.sBox.find('ul');					//썸네일 목록 ul
		shopCategory.sLI = shopCategory.sUL.find('li');						//썸네일 목록 li
		shopCategory.sLInum = shopCategory.sUL.find('li').length;				//썸네일 목록 li 갯수
		shopCategory.sBtnImgL = shopCategory.sTarget.children('.btnPrev');	//이전 이미지 보기 버튼
		shopCategory.sBtnImgR = shopCategory.sTarget.children('.btnNext');	//다음 이미지 보기 버튼

		shopCategory.listShow(shopCategory.sPage); //
		shopCategory.sPageNum = Math.ceil(shopCategory.sLInum/shopCategory.sNum);
		shopCategory.sBtnImgL.hide();
		shopCategory.sBtnImgR.hide();
		shopCategory.sUL.show();

		//이전, 다음 페이지 보기
		if(shopCategory.sLInum > shopCategory.sNum){ // 이미지 갯수가 3개 이상일때만 이전, 다음 페이지 버튼이 활성화 됨
			shopCategory.sBtnImgL.click(function(e){e.preventDefault ? e.preventDefault() : e.returnValue = false; shopCategory.ctrlPage('L');});
			shopCategory.sBtnImgR.click(function(e){e.preventDefault ? e.preventDefault() : e.returnValue = false; shopCategory.ctrlPage('R');});
			shopCategory.sBtnImgR.show();
		} else {
			shopCategory.sBtnImgL.hide();
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

window.onload=function(){ //20150601 시점수정

	//보안프로그램 영역 제거
	//nProtectFly();
	function nProtectFly(){
		if (!$('#NPKFXX').length) return;
		$('#NPKFXX').addClass('hide');
	}
	//EPpluginFly();
	function EPpluginFly(){
		if (!$('#EPplugin').length) return;
		$('#EPplugin').addClass('hide');
	}

};

