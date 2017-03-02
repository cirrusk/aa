$(document).ready(function() {
	try {
		Kakao.init("f73d3eeff8e184ca3710f53d0e084a2f");
	} catch(e) {}
	// 모바일 가로/세로 resize
	$(window).on("orientationchange", function(event){
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
});


//function sharing(url, title, sns, content) {
//	
//	$("#metaTitle").attr("title", title);
//	$("#metaContent").attr("title", content);
//	$("#metaUrl").attr("title", url);
//
//	sendSns(sns, url, title, content);
//};

//var sendSns = function(sns, url, title, desc) {
//	alert($.snsMsg.shareContent.disclaimer);
//	
//	var o;
//	var _url = encodeURIComponent(url);
//	var _title = encodeURIComponent(title);
//	var _desc = encodeURIComponent(desc);
//	var _br = encodeURIComponent('\r\n');
//
//	switch (sns) {
//		case 'kakaotalk':
//			
//			if (!navigator.userAgent.match(/android/i) && !navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
//				alert($.snsMsg.shareContent.enableOnlyMobile );
//				break;
//			}
//
//			var sendTalkLink = {};
//			sendTalkLink.label = title + "\n" + desc;
//			
//			sendTalkLink.webLink =  {
//				"text" : "웹사이트에서 자세히 보기",
//				"url"  : url
//			}
//			Kakao.Link.sendTalkLink(sendTalkLink);
//			break;
//
//		case 'kakaostory':
//			
//			if (!navigator.userAgent.match(/android/i) && !navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
//				alert($.snsMsg.shareContent.enableOnlyMobile );
//				break;
//			}
//			
//			var storySend = {};
//			storySend.post = title + "\n" + desc + "\n" + url;
//			storySend.appid = "www.abnkorea.co.kr";
//			storySend.appver = "2.0";
//			storySend.appname = "ABN KOREA";
//			
//			var userinfo = {};
//			userinfo.title = title; 
//			userinfo.desc = desc;
//
//			userinfo.type = "article";
//
//			storySend.urlinfo = JSON.stringify(userinfo);
//			kakao.link("story").send(storySend);
//		    break;
//		case 'band':
//			
//			if (!navigator.userAgent.match(/android/i) && !navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
//				alert($.snsMsg.shareContent.enableOnlyMobile );
//				break;
//			}
//
//			o = {
//				param : 'create/post?text=' + _title + _br + _desc + _br + _url,
//				a_store : 'itms-apps://itunes.apple.com/app/id542613198?mt=8',
//				g_store : 'market://details?id=com.nhn.android.band',
//				a_proto : 'bandapp://',
//				g_proto : 'scheme=bandapp;package=com.nhn.android.band'
//			};
//
//			if (navigator.userAgent.match(/android/i)) {
//				// Android
//				setTimeout(function() { parent.location.href = 'intent://' + o.param + '#Intent;' + o.g_proto + ';end' }, 500);
//			} else if (navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)) {
//				// Apple
//				var openAt = new Date;
//				 setTimeout(
//				 	function() {
//				 		if (new Date - openAt < 4000)
//				 			parent.location.href = o.a_store;
//				 	}, 1500);
//				 parent.location.href = o.a_proto + o.param; 
//			} else {
//				alert($.snsMsg.shareContent.enableOnlyMobile );
//			}
//			break;
//
//		case 'facebook':
//			
//				window.open('http://m.facebook.com/sharer.php?u=' + _url);
//				
//			break;
//
//		default:
//		return false;
//	}
//}

function sharing(url, title, sns, content) {
	$("#metaTitle").attr("title", title);
	$("#metaContent").attr("title", content);
	$("#metaUrl").attr("title", url);
	var imgUrl = location.host;
	
	if(sns == "facebook"){
		
		var shareUrl = "http://m.facebook.com/sharer/sharer.php?u="+encodeURIComponent(url);
		window.open(shareUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,width=600,height=600'); 
		
		return false;
		
	}else if(sns == "band"){
		
		var shareUrl  =  "http://band.us/plugin/share?body="+encodeURIComponent(content)+"&route="+encodeURIComponent(url);
		window.open(shareUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,widt=600,height=600'); return false;
		
	}else if(sns == "kakaostory"){
		 Kakao.Story.open({
	        url: url,
	        text: content,
			urlInfo: {
				title: '암웨이',
				desc: '암웨이 예약',
				name: '암웨이 코리아',
				images: ['http://'+imgUrl+'/images/amwSig.jpg']
			}
	      });
//		console.log("@@@@@@@@@@@@@@@@@@@");
//		Kakao.Story.open({
//		    url: 'http://my.share.url.com',
//		    text: '공유할 텍스트입니다',
//		});

		
	}else{
		Kakao.Link.createTalkLinkButton({
		      container: '#snsKt',
		      label: content,
		      image: {
		        src: 'http://'+imgUrl+'/images/amwSig.jpg',
		        width: '300',
		        height: '200'
		      },
		      webButton: {
		    	  text: 'abnKorea',
		          url: url // 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
		      }
		    })
	}

}