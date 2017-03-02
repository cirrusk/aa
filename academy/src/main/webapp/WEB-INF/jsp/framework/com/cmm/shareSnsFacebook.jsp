<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
    <head>
	    <meta charset="utf-8" />
	    <meta http-equiv="Cache-Control" content="no-cache">
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	    
		<meta property="og:site_name" 	content="${siteName}" />
	    <meta property="og:title" 		content="${title}" />
	    <meta property="og:url" 		content="${url}" />
	    <meta property="og:image" 		content="${image}" />
	    <meta property="og:description" content="${description}" />
	    
	    <script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
	    
	    <script type="text/javascript" >
    	$(document).ready(function(){
    		
    		//alert(location.href);
    		//var url = "http://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(location.href);
    		var url = "http://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent("http://localhost:8080/framework/com/shareSnsFacebook.do");
    		location.href = url;
    	});
	    </script>
	</head>
	<body>
		<font color="WHITE">
			siteName : ${siteName}<br/>
			title : ${title}<br/>
			url : ${url}<br/>
			image : ${image}<br/>
			description : ${description}<br/>	
		</font>
	</body>
</html>