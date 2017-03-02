// academy > aboNote use only
$(document).ready(function(){
	aboNote.init();
});
var aboNote = {
	sIdx : 0,			//0 ~ n번까지 생성될 수 있음, 목록 순번
	sImg : 0,			//최대 n개 이미지가 등록되고, 1페이지에 5개씩 n/5페이지가 생길 수 있음.
	sPage : 51,			//총 페이지 수
	sPageNum : 5,		//총 페이지 수를 보여줄 이미지의 갯수
	pIdx : null,
	sPageImg : null,	//현재 페이지
	sSkipItem : null,   //네비 버튼들
	sUL : null,			//썸네일 목록 ul
	sLI : null,			//썸네일 목록 li
	sLInum : null,		//썸네일 목록 li 갯수
	sBtnImgL : null,	//이전 이미지 보기 버튼
	sBtnImgR : null,	//다음 이미지 보기 버튼
	sCurrentImg : null,	//현재 이미지 쪽수 표시
	easing : 'easeInOutCirc',
	ctrlImg : function(v){
		if(v == 'R' && aboNote.sIdx == aboNote.sLInum-1){
			alert('마지막 이미지 입니다.');
		}
		if(v == 'L' && aboNote.sIdx == 0){
			alert('처음 이미지 입니다.');
		}
		if(v == 'R' && aboNote.sIdx < aboNote.sLInum-1){
			aboNote.sIdx = aboNote.sIdx + 1;
			aboNote.imgChg();
			aboNote.onOff();
			aboNote.skipNavi();

		}
		if(v == 'L' && aboNote.sIdx > 0){
			aboNote.sIdx = aboNote.sIdx - 1;
			aboNote.imgChg();
			aboNote.onOff();
			aboNote.skipNavi();
		}
	},
	onOff : function(){
		aboNote.sLI.removeClass('on');
		aboNote.sLI.eq(aboNote.sIdx).addClass('on');
		aboNote.sLI.eq(aboNote.sIdx).attr("tabindex", 0);
	},
	skipNavi : function(){
		aboNote.sSkipItem.removeClass('on');
		var sFlag1 = Math.floor(aboNote.sIdx / aboNote.sPageNum);
		if(sFlag1 == 0){
			aboNote.sSkipItem.eq(0).addClass('on');
		} else if(sFlag1 == 1) {
			aboNote.sSkipItem.eq(1).addClass('on');
		} else if(sFlag1 == 2) {
			aboNote.sSkipItem.eq(2).addClass('on');
		} else if(sFlag1 == 3) {
			aboNote.sSkipItem.eq(3).addClass('on');
		} else if(sFlag1 == 4) {
			aboNote.sSkipItem.eq(4).addClass('on');
		} else if(sFlag1 == 5) {
			aboNote.sSkipItem.eq(5).addClass('on');
		}
	},
	skipClick : function(){
		aboNote.sSkipItem.click(function(e){
			e.preventDefault ? e.preventDefault() : e.returnValue = false;
			var pIdx = aboNote.sSkipItem.index(this);
			if(pIdx == 0){
				aboNote.sIdx = 0 ;
				aboNote.skipChgImg();
				aboNote.sSkipItem.eq(pIdx).addClass('on');
			} else if (pIdx == 1){
				aboNote.sIdx = 5 ;
				aboNote.skipChgImg();
				aboNote.sSkipItem.eq(pIdx).addClass('on');
			} else if (pIdx == 2){
				aboNote.sIdx = 10 ;
				aboNote.skipChgImg();
				aboNote.sSkipItem.eq(pIdx).addClass('on');
			} else if (pIdx == 3){
				aboNote.sIdx = 15 ;
				aboNote.skipChgImg();
				aboNote.sSkipItem.eq(pIdx).addClass('on');
			} else if (pIdx == 4){
				aboNote.sIdx = 20 ;
				aboNote.skipChgImg();
				aboNote.sSkipItem.eq(pIdx).addClass('on');
			} else if (pIdx == 5){
				aboNote.sIdx = 25 ;
				aboNote.skipChgImg();
				aboNote.sSkipItem.eq(pIdx).addClass('on');
			}
		});
	},
	skipChgImg : function(){
		aboNote.sSkipItem.removeClass('on');
		aboNote.imgChg();
		aboNote.onOff();
	},
	imgChg : function(){
		aboNote.sLI.hide();
		aboNote.sLI.eq(aboNote.sIdx).show();
		aboNote.sCurrentImg.text(aboNote.sLI.eq(aboNote.sIdx).find('.pageNum').text());
	},
	init : function(){
		aboNote.sUL = $('.noteList').find('>ul');					//썸네일 목록 ul
		aboNote.sLI = aboNote.sUL.find('>li');						//썸네일 목록 li
		aboNote.sLInum = aboNote.sUL.find('>li').length;			//썸네일 목록 li 갯수

		aboNote.sBtnImgL = $('.pagingBox').find('.prev');		    //이전 이미지 보기 버튼
		aboNote.sBtnImgR = $('.pagingBox').find('.next');	        //다음 이미지 보기 버튼
		aboNote.sCurrentImg = $('.pagingBox').find('.pageView');	//현재 이미지 순번 표시
		aboNote.sSkipItem = $('.noteSkip').find('>span');
		aboNote.sImg = $('.noteList').find('img').length;

		//setting
		aboNote.sLI.eq(0).show();
		aboNote.sLI.eq(0).addClass('on');
		aboNote.sLI.eq(0).attr("tabindex", 0);
		aboNote.sCurrentImg.text(aboNote.sLI.eq(0).find('.pageNum').text());
		aboNote.sSkipItem.eq(0).addClass('on');

		//이전, 다음 이미지 보기
		aboNote.sBtnImgL.click(function(){aboNote.ctrlImg('L');});
		aboNote.sBtnImgR.click(function(){aboNote.ctrlImg('R');});

		aboNote.skipClick(); // 왼쪽 스킵 메뉴
	}
};