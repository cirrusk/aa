$(document).ready(function() {
	Kakao.init("f73d3eeff8e184ca3710f53d0e084a2f");
});

function sharing(url, title, sns, content, imageUrl) {
	
	//$("#metaTitle").attr("content", title);
	//$("#metaContent").attr("content", content);
	//$("#metaUrl").attr("content", url);
	//$("#imageUrl").attr("content", imageUrl);
	
	if(sns == "facebook"){
		
		/*
		$("meta[property='og\\:title']").attr("content", title);
		$("meta[property='og\\:description']").attr("content", content);
		$("meta[property='og\\:image']").attr("content", imageUrl);
		
		//var shareUrl = "http://www.facebook.com/sharer/sharer.php?u="+encodeURIComponent(url);
		//var shareUrl = "http://m.facebook.com/sharer.php?u=" + url;
		var shareUrl = "/framework/com/shareSnsFacebook.do?url="+encodeURIComponent(url)
					+ "&title=" + encodeURIComponent(title)
					+ "&image=" + encodeURIComponent(imageUrl)
					+ "&description=" + encodeURIComponent(content);

		window.open(shareUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,width=600,height=600');
		return false;
		*/

		var shareUrl = "http://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(url);
		window.open(shareUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,width=600,height=600');
		return false;
		
	}else if(sns == "band"){
		
		var shareUrl  =  "http://band.us/plugin/share?body="+encodeURIComponent(content)+"&route="+encodeURIComponent(url);
		window.open(shareUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,widt=600,height=600');
		return false;
		
	}else if(sns == "kakaoStory"){
//		console.log(url);
//		
//		var shareUrl = "https://story.kakao.com/share?url="+encodeURIComponent('www.naver.com');
//		window.open(shareUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,width=600,height=600'); return false;
		
		 Kakao.Story.share({
		        url: url,
		        text: content
		      });
		
	}
//	else{
//		Kakao.Link.createTalkLinkButton({
//		      container: '#snsKt',
//		      label: content,
//		      image: {
//		        src: 'http://dn.api1.kage.kakao.co.kr/14/dn/btqaWmFftyx/tBbQPH764Maw2R6IBhXd6K/o.jpg',
//		        width: '300',
//		        height: '200'
//		      },
//		      webButton: {
//		    	  text: 'abnKorea',
//		          url: url // 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
//		      }
//		    })
//	}

}