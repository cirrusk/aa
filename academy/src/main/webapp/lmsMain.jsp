<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html lang="ko">
<head>
<!-- page common -->
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- //page common -->
<!-- page unique -->
<meta name="Description" content="설명들어감">
<meta http-equiv="Last-Modified" content="">
<!-- //page unique -->
<title>아카데미 - ABN Korea</title>
<!--[if lt IE 9]>
<script src="/_ui/desktop/common/js/html5.js"></script>
<script src="/_ui/desktop/common/js/ie.print.js"></script>
<![endif]-->
<link rel="stylesheet" href="/_ui/desktop/common/css/academy_default.css">
<script src="/_ui/desktop/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/desktop/common/js/pbCommon2.js"></script>
<script src="/_ui/desktop/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/desktop/common/js/pbLayerPopup.js"></script>
<script src="/_ui/desktop/common/js/owl.carousel.js"></script>
<script type="text/javascript">
var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
var eventer = window[eventMethod];
var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

// Listen to message from iFrame resize
eventer(messageEvent, function (e) {
	var $IframeComponent = $("#IframeComponent");
	try {
		var data = e.data;
		if(data && isNaN(data)) {
			eval(data);
		} else {
			$IframeComponent.css({ height: e.data });
		}
		
	} catch(e) {
		// iframe resize
		try {
			if ($IframeComponent.contents()) {
				var $bodyHeight = $IframeComponent.contents().find("#pbContent"); 
				if($bodyHeight) {
					$IframeComponent.height($bodyHeight.height());
				}
			}
		} catch(e) {}
	}
}, false);
</script>


</head>

<body>

<div id="pbSkipNavi"><a href="#pbContent">본문 바로가기</a><a href="#pbGnb">주메뉴 바로가기</a></div>
<div id="pbWrap">
	<!-- header area -->
	<header id="pbHeader">header include<a href="/">서브페이지</a></header>
	<!-- //header area -->
	<div id="pbContainer" class="academyMain">
	
		<!-- content area  -->
		<iframe id="IframeComponent" src="/lms/main.do" title="아카데미 아이프레임" style="width:960px; min-height:1500px; overflow-x: hidden; overflow-y: auto;" frameborder="1" marginwidth="0" marginheight="0" scrolling="no" ></iframe>

		<!-- //content area  -->
		
		<!-- aside area -->
		<aside id="pbAside">aside include</aside>
		<!-- //aside area -->
	</div><!-- //#pbContainer -->
	<!--footer include -->
	<footer id="pbFooter">footer include</footer>
	<!--//footer include -->
</div>

<div class="skipNaviReturn"><a href="#pbSkipNavi">페이지 맨 위로 이동</a></div>

</body>
</html>