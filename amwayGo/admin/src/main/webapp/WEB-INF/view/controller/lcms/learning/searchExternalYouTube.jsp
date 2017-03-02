<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<html decorator="learning">
<head>
<title></title>
<script type="text/javascript" src="http://swfobject.googlecode.com/svn/trunk/swfobject/swfobject.js"></script>
<script type="text/javascript">
var SUB = {
	srchWords : "<c:out value="${param['srchWord']}"/>".split(","),
	index : 1,
	perPage : 4,
	/**
	 * 페이지 시작
	 */
	initPage : function() {
		if (SUB.srchWords.length == 0 || SUB.srchWords[0] == "") {
			jQuery("#warning").show().siblings().hide();
			return;
		}
		SUB.search();
	},
	search : function() {
		Global.parameters = "";
		var words = [];
		for (var index in SUB.srchWords) {
			words.push(SUB.srchWords[index].trim());
		}
		
		var api = "http://gdata.youtube.com/feeds/api/videos"; 
		var param = [];
		param.push("q=" + words.join("+"));
		param.push("start-index=" + SUB.index);
		param.push("max-results=" + SUB.perPage);
		param.push("v=2");
		param.push("orderby=viewCount");
		param.push("alt=json-in-script");
		param.push("callback=?");
		
		var action = $.action("ajax");
		action.config.type = "json";
		action.config.asynchronous = true;
		action.config.url  = api + "?" + param.join("&");
		action.config.fn.complete = function(action, data) {
			SUB.searchResult(data);
		};
		action.run();
	},
	searchResult : function(data) {
		if (typeof data === "object") {
			var feed = data.feed;
			var totalCount = feed.openSearch$totalResults.$t;
			var $srchData = jQuery("#srchData");
			var entries = feed.entry || [];
			if (totalCount == 0 || (SUB.index == 1 && entries.length == 0)) {
				jQuery("#nodata").show().siblings().hide();
				return;
			}
			for (var i = 0; i < entries.length; i++) {
				var entry = entries[i];
				var title = entry.title.$t;
				var playerUrl = entries[i].media$group.media$content[0].url;
				var html = [];
				html.push("<li class='new-entry'>");
				html.push("<div id='video-" + SUB.index + "' index='" + SUB.index + "'  url='" + playerUrl + "'></div>");
				html.push("</li>");
				$srchData.append(jQuery(html.join("")));
				SUB.index++;
			}
			var $video = $srchData.find(".new-entry");
			if ($video.length > 0) {
				$video.each(function() {
					var $item = jQuery(this).find("div");
					swfobject.embedSWF($item.attr("url") + "&rel=1&border=0&fs=1&autoplay=0", $item.attr("id"), "200", "150", "9.0.0", false, false, {allowfullscreen: "true"});
				});
				$video.removeClass("new-entry");
			}
			$srchData.show().siblings().hide();
			if (totalCount > SUB.index && entries.length == SUB.perPage) {
				jQuery("#moreData").show();
			} else {
				jQuery("#moreData").hide();
			}
		}
	}
};
</script>
<style type="text/css">
body {background-color:#727272; color:#ffffff;}
#srchData li {list-style:none; float:left; width:240px; height:160px; text-align:center; }
.more {cursor:pointer; color:#fff !important; }
</style>
</head>
<body>
<div class="scroll-y" style="height:187px; padding:5px 2px 5px 3px !important;">
	<div id="warning" style="display:none;"><spring:message code="글:검색어를입력하십시오"/></div>
	<div id="nodata" style="display:none;"><spring:message code="글:데이터가없습니다"/></div>
	<ul id="srchData" style="display:none;"></ul>
	<div id="moreData" style="clear:both; text-align:center; display:none;">
		<a class="more" 
		   onclick="SUB.search();"
		   title="<spring:message code="버튼:더보기"/>"><spring:message code="버튼:더보기"/></a>
	</div>
</div>
</body>
</html>