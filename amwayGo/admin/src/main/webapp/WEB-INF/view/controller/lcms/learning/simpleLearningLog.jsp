<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="learning">
<head>
<title></title>
<script type="text/javascript">
var $console = null;
var SUB = {
	initPage : function() {
		$console = jQuery("#console");
		setTimeout(function() {
			self.parent.SUB.doStart();
		}, 100);
	},
	/**
	 * 로깅
	 */
	doLogging : function(log) {
		if (typeof log === "object") {
			if (typeof log.message === "string") {
				jQuery("<div>" + log.message.replaceAll("\n", "<br>") + "</div>").appendTo($console);
				$console.scrollTop($console.get(0).scrollHeight);
			}
		}
	},
	/**
	 * 로그 지우기
	 */
	doClearConsole : function() {
		$console.empty();
	}
}
</script>
<style type="text/css">
body {background-color:#727272; color:#ffffff;}
</style>
</head>
<body>

	<div id="console" class="scroll-y" style="height:193px; padding:5px 2px !important;">
	</div>

</body>
</html>