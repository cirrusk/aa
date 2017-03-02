<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="blank">
<head>
<title></title>
<style>
body {margin:0px;}
</style>
</head>
<body>
	<div id="noimage" style="text-align:center;vertical-align:middle;"><aof:img src="bg/noimage_doc_120x90.gif"/></div>
	<script type="text/javascript">
		try {
			if (parent != null && typeof parent.contentsHeight !== "undefined") {
				document.getElementById("noimage").style["lineHeight"] = parent.contentsHeight + "px";
			}
		} catch (e) {
		}
	</script>
</body>
</html>