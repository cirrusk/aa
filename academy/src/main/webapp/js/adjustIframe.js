var iframeAdjustIdentity;
var iframeAdjustIntervalCount = 0;

var adjustIframe = function(){
	
	if ('localhost' != document.domain) {
		document.domain = "abnkorea.co.kr";
	}
	
	var lastHeight = 0;
	//var pbContent = $("#pbContent").height();
	var pbContent = $("#pbContent").outerHeight();
	var $frame = parent.$('#IframeComponent');
	
	//console.log("interval count " + iframeAdjustIntervalCount);
	if ( pbContent != lastHeight ) {
		$frame.css('height', (lastHeight = pbContent + 30) + 'px' );
	}
	iframeAdjustIntervalCount++;
	
	if(iframeAdjustIntervalCount >= 5){
		iframeAdjustIntervalCount = 0;
		clearInterval(iframeAdjustIdentity);
	}
	
}

/* adjust iframe height size at child-frame */
$(document).ready(function(){
	iframeAdjustIdentity = setInterval(adjustIframe,500);
});
$(document).mousedown(function(){
	clearInterval(iframeAdjustIdentity);
	iframeAdjustIdentity = setInterval(adjustIframe,500);
});

