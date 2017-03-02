$(document).ready(function(){
	rolling.init();
});
var rolling = {
	sNum : 5,			//한번에 보여지는 목록 갯수
	sPage : 0,			//최대 n개 이미지가 등록되고, 1페이지에 5개씩 n/5페이지가 생길 수 있음.
	sPageNum : null,	//총 페이지 수 n/5
	sIdx : 0,			//0 ~ n번까지 생성될 수 있음, 목록 순번
	sTarget : null,		//이미지 크게보기 영역
	sImg : null,		//이미지 크게보기 큰 이미지
	sUL : null,			//썸네일 목록 ul
	sLI : null,			//썸네일 목록 li
	sLInum : null,		//썸네일 목록 li 갯수
	sBtnImgL : null,	//이전 이미지 보기 버튼
	sBtnImgR : null,	//다음 이미지 보기 버튼
	sBtnPageL : null,	//이전 페이지 보기 버튼
	sBtnPageR : null,	//다음 페이지 보기 버튼
	sCurrentImg : null,	//현재 이미지 순번 표시
	easing : 'easeInOutCirc',
	thumbClick : function(){
		rolling.sLI.find('a').click(function(e){
			e.preventDefault ? e.preventDefault() : e.returnValue = false;
			rolling.sIdx = rolling.sLI.find('a').index(this);
			rolling.sImg.attr('src',$(this).attr('href'));
			rolling.sImg.attr('alt',$(this).children().attr('alt'));
			rolling.onOff();
		});
	},
	listShow : function(n){
		rolling.sLI.each(function(i){
			if(i >= rolling.sNum * n && i < (rolling.sNum * n) + rolling.sNum ) {
				rolling.sLI.eq(i).show(); //최초 5개 목록만 보여줌
			} else {
				rolling.sLI.eq(i).hide();
			}
		});
	},
	txtIns : function(v){
		if(v == 'R'){
			if(rolling.sPage == rolling.sPageNum-1){
				rolling.sBtnPageR.addClass('on');
				rolling.sBtnPageR.children().text('다음 이미지 리스트 보기가 없습니다.');
			}
			if(rolling.sPage > 0){
				rolling.sBtnPageL.removeClass('on');
				rolling.sBtnPageL.children().text('이전 이미지 리스트 보기');
			}
		}
		if(v == 'L'){
			if(rolling.sPage == 0){
				rolling.sBtnPageL.addClass('on');
				rolling.sBtnPageL.children().text('이전 이미지 리스트 보기가 없습니다.');
			}
			if(rolling.sPage < rolling.sPageNum-1){
				rolling.sBtnPageR.removeClass('on');
				rolling.sBtnPageR.children().text('다음 이미지 리스트 보기');
			}
		}
	},
	ctrlImg : function(v){
		if(v == 'R' && rolling.sIdx == rolling.sLInum-1){
			alert('마지막 이미지 입니다.');
		}
		if(v == 'L' && rolling.sIdx == 0){
			alert('처음 이미지 입니다.');
		}
		if(v == 'R' && rolling.sIdx < rolling.sLInum-1){
			rolling.sIdx = rolling.sIdx + 1;
			var sFlag1 = Math.floor(rolling.sIdx / rolling.sNum);
			if(sFlag1 > rolling.sPage) { // 어떠한 조건이 됐을때 페이지 넘버 올려주고 listShow 실행
				rolling.sPage = sFlag1;
				rolling.listShow(rolling.sPage);
				rolling.txtIns('R');
			}
			rolling.infoCh();
			rolling.onOff();
		}
		if(v == 'L' && rolling.sIdx > 0){
			rolling.sIdx = rolling.sIdx - 1;
			var sFlag2 = Math.floor(rolling.sIdx / rolling.sNum);
			if(sFlag2 < rolling.sPage) { // 어떠한 조건이 됐을때 페이지 넘버 올려주고 listShow 실행
				rolling.sPage = sFlag2;
				rolling.listShow(rolling.sPage);
				rolling.txtIns('L');
			}
			rolling.infoCh();
			rolling.onOff();
		}
	},
	ctrlPage : function(v){
		if(v == 'R' && rolling.sPage < rolling.sPageNum-1){
			rolling.sPage = rolling.sPage + 1;
			rolling.listShow(rolling.sPage);
			rolling.txtIns('R');
		}
		if(v == 'L' && rolling.sPage > 0){
			rolling.sPage = rolling.sPage - 1;
			rolling.listShow(rolling.sPage);
			rolling.txtIns('L');
		}
	},
	onOff : function(){
		rolling.sLI.removeClass('on');
		rolling.sLI.eq(rolling.sIdx).addClass('on');
		rolling.sCurrentImg.text(rolling.sIdx+1);	//현재 이미지 순번 표시
	},
	infoCh : function(){
		rolling.sImg.attr('src',rolling.sLI.eq(rolling.sIdx).find('a').attr('href'));
		rolling.sImg.attr('alt',rolling.sLI.eq(rolling.sIdx).find('img').attr('alt'));
	},

	init : function(){
		rolling.sTarget = $('.galleryView');
		rolling.sImg = rolling.sTarget.find('img');					//이미지 크게보기 큰 이미지
		rolling.sUL = $('.rollingList').find('ul');					//썸네일 목록 ul
		rolling.sLI = rolling.sUL.find('li');						//썸네일 목록 li
		rolling.sLInum = rolling.sUL.find('li').length;				//썸네일 목록 li 갯수
		rolling.sBtnImgL = rolling.sTarget.children('.btnPreB');	//이전 이미지 보기 버튼
		rolling.sBtnImgR = rolling.sTarget.children('.btnNextB');	//다음 이미지 보기 버튼
		rolling.sBtnPageL = $('.rollingList').find('.btnPreM');		//이전 페이지 보기 버튼
		rolling.sBtnPageR = $('.rollingList').find('.btnNextM');	//다음 페이지 보기 버튼
		rolling.sCurrentImg = $('.galleryBox').find('.pageBtn').find('strong');	//현재 이미지 순번 표시
		$('.galleryBox').find('.pageBtn').find('span').eq(-1).text(rolling.sLInum);	//전체 이미지 갯수 표시
		rolling.sCurrentImg.text(rolling.sIdx+1);

		//총 페이지 수
		rolling.sPageNum = Math.ceil(rolling.sLInum/rolling.sNum);

		//최초 이미지 넣어주기
		rolling.sImg.attr('src',rolling.sLI.eq(0).find('a').attr('href'));

		//최초 5개 목록만 보여줌
		rolling.listShow(rolling.sPage);
		rolling.sLI.eq(0).addClass('on');

		//이전, 다음 이미지 보기
		rolling.sBtnImgL.click(function(e){e.preventDefault ? e.preventDefault() : e.returnValue = false; rolling.ctrlImg('L');});
		rolling.sBtnImgR.click(function(e){e.preventDefault ? e.preventDefault() : e.returnValue = false; rolling.ctrlImg('R');});

		//최초 이전 페이지 없음 표시
		rolling.sBtnPageL.addClass('on');
		rolling.sBtnPageL.children('span').text('이전 이미지 리스트 보기가 없습니다.');

		//이전, 다음 페이지 보기
		if(rolling.sLInum > rolling.sNum){ // 이미지 갯수가 5개 이상일때만 이전, 다음 페이지 버튼이 활성화 됨
			rolling.sBtnPageL.click(function(e){e.preventDefault ? e.preventDefault() : e.returnValue = false; rolling.ctrlPage('L');});
			rolling.sBtnPageR.click(function(e){e.preventDefault ? e.preventDefault() : e.returnValue = false; rolling.ctrlPage('R');});
		} else {
			rolling.sBtnPageR.addClass('on');
			rolling.sBtnPageR.children().text('다음 이미지 리스트 보기가 없습니다.');
		}

		//썸네일 클릭시 큰 이미지 교체
		rolling.thumbClick();
	}
};