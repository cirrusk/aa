$(document).ready(function(){

	var galleryCtrl = {
		countPerPage	: 5,

		// 최초 초기화 실행 - 탭, 갤러리 보기, 갤러리 섬네일 스크롤 각 init을 실행
		init : function() {
			galleryCtrl.initGalleryTabs();
			galleryCtrl.initGalleryView();
			galleryCtrl.initGalleryRolling();
		},

		// 지역 탭 버튼 이미지 변경 핸들러 - 화면 전환은 이미 구현되어 있으므로 생략함
		initGalleryTabs : function() {
			var gifOff		= '_off.gif';
			var gifOn		= '_on.gif';

			var $aTabs		= $('.spTabList.apTabList').find('a');
			$aTabs.on('click', function() {
				for (var i = 0; i < $aTabs.length; i ++) {
					var tb = $aTabs.eq(i);
					var selectedTab;

					if (tb.attr('class') == $(this).attr('class')) {
						tb.children('img').attr('src', tb.children('img').attr('src').replaceEnd(gifOff, '').replaceEnd(gifOn, '') + gifOn);
						selectedTab = $('div.spTabCont').eq(i);
					} else {
						tb.children('img').attr('src', tb.children('img').attr('src').replaceEnd(gifOff, '').replaceEnd(gifOn, '') + gifOff);
					}
				}

				// div 전환을 이쪽으로 옮기고자 하면 이 부분에 코딩

				galleryCtrl.setCurrentIndexText(selectedTab);
			});
		},

		// 탭 변경시, 최초 실행시 해당 탭의 visibility 컨트롤
		initGalleryView : function() {
			$tabs = $('div.spTabCont');

			for (var i = 0; i < $tabs.length; i ++) {
				$tab = $tabs.eq(i);

				var $pRollUl		= $tab.find('ul.thumbList');				//썸네일 목록 ul
				var $pRollLi		= $pRollUl.children('li');					//썸네일 목록 li
				var rollCnt			= Math.min(galleryCtrl.countPerPage, $pRollLi.length);

				for (var j = 0; j < $pRollLi.length; j ++) {
					if (j < rollCnt) $pRollLi.eq(j).show();
					else $pRollLi.eq(j).hide();
				}

				galleryCtrl.selectThumbImage($tab, 0);
			}

			galleryCtrl.setCurrentIndexText($tabs.eq(0));
		},

		// 각 스크롤 버튼 핸들러 처리
		initGalleryRolling : function() {
			var $aGallery		= $('.galleryWrap .galleryView');
			var $aImage			= $aGallery.children('img');		//이미지 크게보기 큰 이미지
			var $aImageCtrl		= $aGallery.children('a');
			var $aRollList		= $('.galleryWrap .rollingList');
			var $aRollUl		= $aRollList.find('ul');			//썸네일 목록 ul
			var $aRollLi		= $aRollUl.children('li');			//썸네일 목록 li
			var $aRollCtrl		= $aRollList.children('a');
			var $curIndex		= $('.galleryBox').find('.pageBtn');

			$aRollCtrl.on('click', function(ev) {
				ev.preventDefault();

				var dir			= $(this).attr('class');
				var $tab		= $(this).parents('div.spTabCont');
				var $pRolls		= $tab.find('ul.thumbList').children('li');					//썸네일 목록 li
				var curPg		= galleryCtrl.getSelectedPage($tab);
				var maxPg		= parseInt($pRolls.length / galleryCtrl.countPerPage) + ($pRolls.length % galleryCtrl.countPerPage == 0 ? 0 : 1);

				switch(dir) {
					case 'btnNextM':
						curPg ++;
						break;
					case 'btnPreM' :
						curPg --;
						break;
				}

				if (curPg >= maxPg) {
					alert('마지막 페이지 입니다.');
					return;
				} else if (curPg < 0) {
					alert('처음 페이지 입니다.');
					return;
				}

				galleryCtrl.selectThumbPage($tab, curPg);
			});

			$aRollUl.find('a').on('click', function(ev) {
				ev.preventDefault();

				var $tab		= $(this).parents('div.spTabCont');
				var $pImage		= $tab.find('.galleryView').find('img');	//이미지 크게보기 큰 이미지
				var $pRolls		= $tab.find('ul.thumbList').children('li');	//썸네일 목록 li

				$pRolls.removeClass('on');
				$(this).parents('li').addClass('on');

				$pImage.attr('src', $(this).attr('href'));
				$pImage.attr('alt', $(this).children().attr('alt'));

				galleryCtrl.setCurrentIndexText($tab);
			});

			$aImageCtrl.on('click', function(ev) {
				ev.preventDefault();

				var dir			= $(this).attr('class');
				var $tab		= $(this).parents('div.spTabCont');
				var $pRolls		= $tab.find('ul.thumbList').children('li');					//썸네일 목록 li
				var curIdx		= galleryCtrl.getSelectedIndex($tab);
				var maxIdx		= $pRolls.length;

				switch(dir) {
					case 'btnNextB':
						curIdx ++;
						break;

					case 'btnPreB' :
						curIdx --;
						break;
				}

				if (curIdx >= maxIdx) {
					alert('마지막 이미지 입니다.');
					return;
				} else if (curIdx < 0) {
					alert('처음 이미지 입니다.');
					return;
				}

				galleryCtrl.selectThumbImage($tab, curIdx);
			});
		},

		// 해당 탭에서 지정된 인덱스의 이미지를 크게 표시
		selectThumbImage : function($tab, idx) {
			var $pRollUl		= $tab.find('ul.thumbList');				//썸네일 목록 ul
			var $pRollLi		= $pRollUl.children('li');					//썸네일 목록 li
			var $pImage			= $tab.find('.galleryView').find('img');	//이미지 크게보기 큰 이미지

			$pRollLi.removeClass('on');
			$pRollLi.eq(idx).addClass('on');

			$pImage.attr('src', $pRollLi.eq(idx).children().attr('href'));
			$pImage.attr('alt', $pRollLi.eq(idx).children().children().attr('alt'));

			if (parseInt(idx / 5) != galleryCtrl.getSelectedPage($tab))
				galleryCtrl.selectThumbPage($tab, parseInt(idx / 5));

			galleryCtrl.setCurrentIndexText($tab, idx);
			galleryCtrl.setButtonStatus();
		},

		// 해당 탭에서 섬네일리스트 페이지 변경/이동
		selectThumbPage : function($tab, page) {
			var $pRollUl		= $tab.find('ul.thumbList');				//썸네일 목록 ul
			var $pRollLi		= $pRollUl.children('li');					//썸네일 목록 li
			var stIdx			= page * galleryCtrl.countPerPage;
			var edIdx			= stIdx + galleryCtrl.countPerPage;

			for (var j = 0; j < $pRollLi.length; j ++) {
				if (j < edIdx && j >= stIdx) $pRollLi.eq(j).show();
				else $pRollLi.eq(j).hide();
			}

			galleryCtrl.setButtonStatus();
		},

		// 해당 탭에서 현재 보여지는 이미지 인덱스 반환
		getSelectedIndex : function($tab) {
			var $pRollUl		= $tab.find('ul.thumbList');				//썸네일 목록 ul
			var $pRollLi		= $pRollUl.children('li');					//썸네일 목록 li
			var $pImage			= $tab.find('.galleryView').find('img');	//이미지 크게보기 큰 이미지

			var idx = -1;
			for (var i = 0; i < $pRollLi.length; i ++)
				if ($pRollLi.eq(i).children().attr('href') == $pImage.attr('src') &&
				   $pRollLi.eq(i).children().children().attr('alt') == $pImage.attr('alt'))
					idx = i;

			return idx;
		},

		// 해당 탭에서 현재 보여지는 페이지 인덱스 반환
		getSelectedPage : function($tab) {
			var $pRollUl		= $tab.find('ul.thumbList');				//썸네일 목록 ul
			var $pRollLi		= $pRollUl.children('li');					//썸네일 목록 li

			var idx = -1;
			for (var i = 0; i < $pRollLi.length; i ++) {
				if ($pRollLi.eq(i).css('display') != 'none') {
					idx = i;
					break;
				}
			}

			return parseInt(idx / 5);
		},

		// 이미지, 섬네일리스트 스크롤 버튼의 상태 표시 (hidden span)
		setButtonStatus : function() {
			$tabs = $('div.spTabCont');

			for (var i = 0; i < $tabs.length; i ++) {
				var $tab		= $tabs.eq(i);
				var $pRolls		= $tab.find('ul.thumbList').children('li');
				var curPg		= galleryCtrl.getSelectedPage($tab);
				var maxPg		= parseInt($pRolls.length / galleryCtrl.countPerPage) + ($pRolls.length % galleryCtrl.countPerPage == 0 ? 0 : 1);
				var curIdx		= galleryCtrl.getSelectedIndex($tab);
				var maxIdx		= $pRolls.length;
				var $imgCtrl	= $tab.find('.galleryView').children('a');
				var $tmbCtrl	= $tab.find('.rollingList').children('a');

				$tmbCtrl.eq(0).children().text('이전 이미지 리스트 보기');
				$tmbCtrl.eq(1).children().text('다음 이미지 리스트 보기');

				if (curPg + 1 >= maxPg)
					$tmbCtrl.eq(1).children().text('다음 이미지 리스트 보기가 없습니다.');

				if (curPg - 1 < 0)
					$tmbCtrl.eq(0).children().text('이전 이미지 리스트 보기가 없습니다.');

				$imgCtrl.eq(0).children().text('이전 이미지 보기');
				$imgCtrl.eq(1).children().text('다음 이미지 보기');

				if (curIdx + 1 >= maxIdx)
					$imgCtrl.eq(1).children().text('다음 이미지 보기가 없습니다.');

				if (curIdx - 1 < 0)
					$imgCtrl.eq(0).children().text('이전 이미지 보기가 없습니다.');
			}
		},

		// 현재 페이지 표시 (우측 상단)
		setCurrentIndexText : function($tab, currentIdx) {
			if (!currentIdx) currentIdx = galleryCtrl.getSelectedIndex($tab);
			var tmp = '<span class="hide">현재 이미지 순서 </span><strong>' + (currentIdx + 1);
			tmp += '</strong> / <span class="hide">전체 이미지 수</span><span>' + $tab.find('ul.thumbList').children('li').length +'</span>';
			$tab.find('.pageBtn').html(tmp);
		}
	};

	galleryCtrl.init();

});
