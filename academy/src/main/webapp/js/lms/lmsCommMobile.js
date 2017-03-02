	// 상세보기전 접속 권한 체크 -  과정구분,교육시작 
	function fnAccesViewClick(courseidVal, callerMenu, searchVal) {
		//callerMenu :: main-메인페이지, eduEduResource-교육자료, request - 통합교육신청, -그외서브메뉴 

		var datatypeVal = "";
		if(callerMenu == "eduEduResource") {
			var arrSearch = searchVal.split('|');
			if(arrSearch.length > 1) {
				datatypeVal = arrSearch[1];
			}
		}

		var params = {courseid:courseidVal, datatype:datatypeVal};
		var glmsUrl = "";
		var onlyglmsUrl = "";
		$.ajax({
			url : "/mobile/lms/authViewDataEvent.do",
			method : "POST",
			cache: false ,
			async: false,
			data : params,
			success : function(data, textStatus, jqXHR) {
				if(parseInt(data.sCode) > 0  && parseInt(data.sCode) < 10) {
					if( data.sCode == "1") {
						// 온라인강의 링크
						//var winobj = window.open(data.sLink2, 'onlineView','toolbar=0, menubar=no');
						//var winobj = window.open(data.sLink+"?courseid="+data.sCourseid, 'onlineView','toolbar=0, menubar=no');
						//var winobj = window.open("about:blank", 'onlineView','');
						//winobj.location.href = data.sLink+"?courseid="+data.sCourseid;
						glmsUrl = data.sLink+"?courseid="+data.sCourseid;
						onlyglmsUrl = data.sLink;
					} else if( data.sCode == "3") {
						// 교육자료 링크
						parent.location.href = data.sLink2;
					} else {
						// 상세보기 링크
						if(callerMenu == "request"){ // 정규,오프,라이브 목록인 경우
							goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink);
						}else{
							parent.location.href = data.sLink2;
						}
					}
				} else if(parseInt(data.sCode) > 10  && parseInt(data.sCode) < 15) {
					//약관동의
					parent.location.href = data.sLink2;
				} else if(parseInt(data.sCode) > 15  && parseInt(data.sCode) < 20) {
					// 다른 링크
					goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink);
				} else if(parseInt(data.sCode) > 20  && parseInt(data.sCode) < 40) {
					// 링크가 없다. 메세지처리
					alert(data.sMsg);
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
		if(glmsUrl != ""){
			var glmsparams = {courseid:courseidVal};
			if(navigator.userAgent.indexOf("AMWAY") > -1){
				$.ajax({
					url : onlyglmsUrl,
					method : "POST",
					dataType : "json",
					cache: false ,
					async: false,
					data : glmsparams,
					success : function(data, textStatus, jqXHR) {
						if(data.redirectGlmsURL == "" ) {
							return;
						}
						if(data.activityid == "") {
							if(data.activitycode == "A") {
								alert("이용권한이 없습니다.");
							} else if(data.activitycode == "T") {
								alert("수강 기간이 종료되었습니다.");
							} else {
								alert("이용권한이 없습니다.");	
							}
							return;
						} else {
							chromeOpen(data.redirectGlmsURL);
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("처리도중 오류가 발생하였습니다.");
					}
				});
			}else{
				var winobj = window.open('about:blank', 'onlineView');
				winobj.location.href = glmsUrl;
			}
		}
	}

	
	// 교육자료 상세보기전 접속 권한 체크 -  교육자료메뉴, 교육자료상세 에서만 사용한다
	function fnAccesEduView(courseidVal, searchVal) {
		var datatypeVal = "";
		var sortColumnVal = "";
		var searchTypeVal = "";
		var searchTxtVal = "";
		var currPageVal = "";
		var arrSearch = searchVal.split('|');
		if(arrSearch.length > 1) {
			datatypeVal = arrSearch[1];
			sortColumnVal = arrSearch[2];
			searchTypeVal = arrSearch[3];
			searchTxtVal = arrSearch[4];
			currPageVal = arrSearch[5];
		}

		var params = {courseid:courseidVal, datatype:datatypeVal, sortColumn:sortColumnVal, searchType:searchTypeVal, searchTxt:searchTxtVal, currPage:currPageVal};
		$.ajax({
			url : "/mobile/lms/authViewDataEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success : function(data, textStatus, jqXHR) {
				if(parseInt(data.sCode) > 0  && parseInt(data.sCode) < 10) {
					if( data.sCode == "3") {
						// 교육자료 링크
						//parent.location.href = data.sLink2;
						goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink); 
					}
				} else if(parseInt(data.sCode) > 10  && parseInt(data.sCode) < 15) {
					//약관동의
					parent.location.href = data.sLink2;
				} else if(parseInt(data.sCode) > 15  && parseInt(data.sCode) < 20) {
					// 다른 링크
					goViewLink(data.sCode, data.sMsg, data.sCourseid, data.sLink);
				} else if(parseInt(data.sCode) > 20  && parseInt(data.sCode) < 40) {
					// 링크가 없다. 메세지처리
					alert(data.sMsg);
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	
	//좋아요 선택시 이벤트 단일.
	function likeitemClick(courseidVal, lablenm) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/mobile/lms/likecountEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success: function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			// count
					if(lablenm!="") {
						$("#"+lablenm).html(data.cntMsg);
						//바로 위의 클래스 값을 변경할 것
						$("#"+lablenm).prev().addClass(" on");
					}
					alert(data.sMsg);		//해당 자료를 추천하였습니다.
				} else if(data.sCode == "2") { // count되어있음
					alert(data.sMsg); 		//이미 추천하신 자료입니다.
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 추천 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	//좋아요 선택시 이벤트 복수(ex,cntMsg:999+, cntFullMsg:12,345).
	function likeitemClickDual(courseidVal, lablenm, detaillab) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/mobile/lms/likecountEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success: function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			// count
					//var cnt = cellNumber(data.sMsg,"s");
					if(lablenm!="") {
						$("#"+lablenm).html(data.cntMsg);
						$("#"+lablenm).prev().addClass(" on");
						//alert("id명:"+lablenm+" 값="+data.cntMsg);
					}
					if(detaillab!="") {
						$("#"+detaillab).html(data.cntFullMsg);
					}
					alert(data.sMsg);		//해당 자료를 추천하였습니다.
				} else if(data.sCode == "2") { // count되어있음
					alert(data.sMsg); 		//이미 추천하신 자료입니다.
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 추천 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	//자료실 선택시 이벤트 (목록)
	function depositClick(courseidVal, lablenm) {
		var params = {courseid:courseidVal};
		
		$.ajax({
			url : "/mobile/lms/depositEvent.do",
			method : "POST",
			cache: false ,
			data : params,
			success : function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			
					if(lablenm!="") {
						$("#"+lablenm).addClass(" on");
					}
					alert(data.sMsg);		//해당 자료가 보관함에 추가되었습니다.
				} else if(data.sCode == "2") { 
					if(lablenm!="") {
						$("#"+lablenm).removeClass(" on");
					}
					alert(data.sMsg); 		//해당 자료가 보관함에서 삭제되었습니다
				} else if(data.sCode == "3") {
					alert(data.sMsg); 		//Compliance 설정되어 보관함에 추가 하실 수 없습니다.
				} else if(data.sCode == "0") { // 계정이 없다
					alert(data.sMsg);		//로그인후 이용 할 수 있습니다.
				}
			
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}

	function fnSessionCall( popupVal ) {
		//세션 정보 끊김에 의한 특정 페이지 호출할 것
		if( popupVal == "Y" ) {
			opener.location.href = "/mobile/lms/common/session.do";
			top.close();
		}else{
			location.href = "/mobile/lms/common/session.do";
		}
		//하이브리스 특정 페이지 호출할 것
		
	}
	
	
	//회원등급 조회. 
	// 		- lablenm : 라벨id  		- rtnType : 'css' 스타일쉬트등록, 'alert' 안내창문구, 'rtnFn' 호출한곳의 함수호출(함수생성-빈 함수라도)
	function fnMemberGrade(lablenm, rtnType) {
		var params = { };
		
		$.ajax({
			url : "/mobile/lms/getItemMemberGrade.do",
			method : "POST",
			cache: false ,
			data : params,
			success: function(data, textStatus, jqXHR) {
				if(data.sCode == "1") { 			// 등급리턴
					if(rtnType == "css") {
						if(lablenm != "") { $("#"+lablenm).addClass(data.sMsg); }
					} else if(rtnType == "alert") {
						alert("회원등급 : " + data.sMsg);
					} else if(rtnType == "rtnFn") {
						fnRtnMemberGrade(data.cntMsg);
					}
					
				} else if(data.sCode == "2") { // 등급이 없다
					if(rtnType == "alert") { alert("회원등급 : " + data.sMsg); }
					
				} else if(data.sCode == "0") { // 계정이 없다
					if(rtnType == "alert") { alert(data.sMsg); }
					
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
	
	function dataMask(data,type) {	
		var regular = /[^0-9]/;
		var form = "";
		//이름일 경우 마스킹
		if(type == "name")
			{	
				var mask = "";
				for(var i=0;i<data.length - 2;i++)
					{
						mask += "*";
					}
				regular = /([가-힣])[가-힣]+([가-힣])/;
				form = "$1"+mask+"$2";
				data = data.replace(regular,form);
				return data;
			}
		//ABO번호일 경우 마스킹
		 else if(type == "uid")
			{
				regular = /([0-9]+)[0-9]{4}/;
				form = "$1****";
				data = data.replace(regular,form);
				return data;
			} 
	}
	function layerPopupOpenSnsUrl(e){
		layerPopupOpenEventTop(e);
		$("#pbLayerPopupUrl").select();
	}
	
	function layerPopupOpenEventTop(e){

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
			//var resultTop= Math.round(((windowH - targetH)/2)+scrollT); //레이어 팝업이 windowH보다 작을때는 세로의 중앙에 띄움
			var resultTop = targetTop - Math.round(targetH / 2); //클릭된 위치에 띄운다.
			$target.css({'display':'block','top':resultTop});
		}else{
			var resultTop= Math.round(scrollT+15);
			$target.css({'display':'block','top':resultTop}); //레이어 팝업이 windowH보다 클때는 위에서 15px띄운 위치에 뜸
		}
		
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

	//sns 공유하기
	$(document).on("click",".snsZone .share",function(){
		var visible =$(this).siblings('.detailSns').is(":visible");
		$('.detailSns').hide();
		var snsUrl = $(this).attr("data-url");
		$("#pbLayerPopupUrl").val(snsUrl);
		var courseid = $(this).attr("data-courseid");
		$("#snsCourseid").val(courseid);
		if(visible){
			$(this).siblings('.detailSns').hide();	
		}else{
			$(this).siblings('.detailSns').show();
		}
	});
	
	
	// kakao talk
	$(document).on("click","#snsKt",function(){
		event.preventDefault();
		var ktSnsType = "kakaotalk";
        execSnsLink(this, ktSnsType);
	});
	
	// kakao story
	$(document).on("click","#snsKs",function(){
		event.preventDefault();
		var ksSnsType = "kakaostory";
		execSnsLink(this, ksSnsType);
	});

	// band
	$(document).on("click","#snsBd",function(){
		event.preventDefault();
		var bdSnsType = "band";
		execSnsLink(this, bdSnsType);
	});

	// facebook
	$(document).on("click","#snsFb",function(){
		event.preventDefault();
		var fbSnsType = "facebook";
		execSnsLink(this, fbSnsType);
	});

    var execSnsLink = function(obj, snsType) {
        
        var courseid = $(obj).parent().siblings('.share').attr("data-courseid");
        var shareUrl = $(obj).parent().siblings('.share').attr("data-url");
        var shareTitle = $(obj).parent().siblings('.share').attr("data-title");
        var shareDescription = $(obj).parent().siblings('.share').attr("data-title");
        var imageurl = $(obj).parent().siblings('.share').attr("data-image");
        if(shareUrl != "" && shareUrl != undefined && shareUrl != null  && shareUrl.indexOf("lmsCourseView.do")>=0 ){
        	addSnsLog(courseid);
        }
        sendSns(snsType, shareUrl, shareTitle, shareDescription, imageurl);
    };
    
	var sendSns = function(sns, url, title, desc, imageurl) {
		
		var o;
		var _url = encodeURIComponent(url);
		var _title = encodeURIComponent(title);
		var _desc = encodeURIComponent(desc);
		var _br = encodeURIComponent('\r\n');

		switch (sns) {
			case 'kakaotalk':
				if( !confirm($.snsMsg.shareContent.disclaimer) ){
					break;
				}
				if (!navigator.userAgent.match(/android/i) && !navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
					alert($.snsMsg.shareContent.enableOnlyMobile );
					break;
				}

				var sendTalkLink = {};
				sendTalkLink.label = title + "\n" + desc;
				
				if(imageurl.length > 0) {
					sendTalkLink.image = {
						"src" : imageurl,
						"width" : 200,
						"height" : 200
					};
				}
				sendTalkLink.webLink =  {
					"text" : title,
					"url"  : url
				}
				Kakao.Link.sendTalkLink(sendTalkLink);
				break;

			case 'kakaostory':
				if( !confirm($.snsMsg.shareContent.disclaimer) ){
					break;
				}
				if (!navigator.userAgent.match(/android/i) && !navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
					alert($.snsMsg.shareContent.enableOnlyMobile );
					break;
				}
				
				var storySend = {};
				storySend.post = title + "\n" + desc + "\n" + url;
				storySend.appid = "www.abnkorea.co.kr";
				storySend.appver = "2.0";
				storySend.appname = "ABN KOREA";
				
				var userinfo = {};
				userinfo.title = title; 
				userinfo.desc = desc;

				if(imageurl.length > 0) {
					userinfo.imageurl = [imageurl];
				}
				userinfo.type = "article";

				storySend.urlinfo = JSON.stringify(userinfo);
				// 앱으로 안가서 수정한다.
				if(navigator.userAgent.indexOf("AMWAY") > -1){
					kakao.link("story").send(storySend);
					break;
				}else{				
					var storyParam =  {
						"text" : title,
						"url"  : url
					}
					Kakao.Story.open(storyParam);
				    break;
				}
			case 'band':
				if( !confirm($.snsMsg.shareContent.disclaimer) ){
					break;
				}
				if (!navigator.userAgent.match(/android/i) && !navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
					alert($.snsMsg.shareContent.enableOnlyMobile );
					break;
				}

				o = {
					param : 'create/post?text=' + _title + _br + _desc + _br + _url,
					a_store : 'itms-apps://itunes.apple.com/app/id542613198?mt=8',
					g_store : 'market://details?id=com.nhn.android.band',
					a_proto : 'bandapp://',
					g_proto : 'scheme=bandapp;package=com.nhn.android.band'
				};

				if (navigator.userAgent.match(/android/i)) {
					// Android
					setTimeout(function() { parent.location.href = 'intent://' + o.param + '#Intent;' + o.g_proto + ';end' }, 500);
				} else if (navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
					// Apple
					var openAt = new Date;
					 setTimeout(
					 	function() {
					 		if (new Date - openAt < 1500)
					 			parent.location.href = o.a_store;
					 	}, 1500);
					 parent.location.href = o.a_proto + o.param; 
				} else {
					alert($.snsMsg.shareContent.enableOnlyMobile );
				}
				break;

			case 'facebook':
				if( !confirm($.snsMsg.shareContent.disclaimer) ){
					break;
				}
					//window.open('http://m.facebook.com/sharer.php?u=' + _url);
				var faceobj = window.open("about:blank", 'facebookpop','toolbar=0, menubar=no');
				faceobj.location.href = 'http://m.facebook.com/sharer.php?u=' + _url;
					
				break;

			default:
			return false;
		}
	}
    
    
    var addSnsLog = function(courseid){
    	$.ajaxCall({
       		url: "/mobile/lms/common/lmsCommonSnsCountAjax.do"
       		, data: {courseid: courseid}
       		, dataType: "json"
       		, success: function( data, textStatus, jqXHR){
    			//alert(data.cnt)
       		}
       	});
    };

    //상단에 포커스 이동시키기
    var fnAnchor = function() {
    	$("#pbContent").attr("tabindex",-1).focus();
    }

    
    function chromeOpen(url){

    	url = url.replace("https:\/\/","").replace("http:\/\/","");
		o = {
				param : url ,
				a_store : 'http://itunes.apple.com/app/id535886823',
				g_store : 'market://details?id=com.android.chrome',
				a_proto : 'googlechrome://',
				g_proto : 'scheme=http;package=com.android.chrome'
			};

			if (navigator.userAgent.match(/android/i)) {
				// Android
				setTimeout(function() { parent.location.href = 'intent://' + o.param + '#Intent;' + o.g_proto + ';end' }, 500);
			} else if (navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
				// Apple
				var openAt = new Date;
				 setTimeout(
				 	function() {
				 		if (new Date - openAt < 2000)
				 			parent.location.href = o.a_store;
				 	}, 1500);
				 parent.location.href = o.a_proto + o.param; 
			}
    	
    	return;
    	
    	var os = ""; 
    	if(navigator.userAgent.toLocaleLowerCase().search("iphone") > -1){ 
    		os = "ios"; 
    	}else{ 
    		os = "android"; 
    	} 
    	
    	function executeAppOrGoStore2() { 
    		var openAt = new Date; 
    		 setTimeout( 
    		 	function() { 
    		 		if (new Date - openAt < 2000) 
    		 			goAppStoreOrPlayStore2(); 
    		 	}, 1500); 
    		 executeApp2(); 
    	} 
    	// 스토어 URL 정보는 각 패키지가 등록된 후에 확인 가능하다. 
    	function goAppStoreOrPlayStore2() { 
    		var storeURL =""; 
    		if (os == "ios") { 
    			storeURL = "http://itunes.apple.com/app/id535886823"; 
    		} else { 
    			storeURL = "https://play.google.com/store/apps/details?id=com.android.chrome"; 
    		} 
    		location.replace(storeURL); 
    	} 
    	function executeApp2() { 
    		var appUriScheme = "";
    		var url_iphone = url;
    		//url = encodeURIComponent(url);
    		if (os == "ios") { 
    			appUriScheme = "googlechrome://" + url_iphone;
    		} else { 
    			appUriScheme = "googlechrome://navigate?url=" + url;
    		} 
    		parent.location.href = appUriScheme; 
    	} 
    	executeAppOrGoStore2();
    }
    
    
    function openAmwayGo(url){

    	url = url.replace("https:\/\/","").replace("http:\/\/","");
		o = {
				param : url ,
				a_store : 'http://itunes.apple.com/app/id535886823',
				g_store : 'market://details?id=com.android.chrome',
				a_proto : 'googlechrome://',
				g_proto : 'scheme=http;package=com.android.chrome'
			};

			if (navigator.userAgent.match(/android/i)) {
				// Android
				setTimeout(function() { parent.location.href = 'intent://' + o.param + '#Intent;' + o.g_proto + ';end' }, 500);
			} else if (navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
				// Apple
				var openAt = new Date;
				 setTimeout(
				 	function() {
				 		if (new Date - openAt < 2000)
				 			parent.location.href = o.a_store;
				 	}, 1500);
				 parent.location.href = o.a_proto + o.param; 
			}
    	return;
    }
    
$(document).ready(function() {
	try {
		Kakao.init("0ce06e98940e1db27ef76fca8fff9e36");
	} catch(e) {}
	// 모바일 가로/세로 resize
	$(window).on("orientationchange", function(event){
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
});
