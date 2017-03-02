<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/meta.jsp"/>
<c:import url="/WEB-INF/view/include/javascript.jsp"/>
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/xcss/jquery/redmond/jquery-ui-1.8.23.custom.css" type="text/css"/>
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/www/guide-api.css" type="text/css"/>

<decorator:head />
<script type="text/javascript">
/**
 * 레이아웃 설정
 */
initLayout = function() {
	var $window = jQuery(window);
	var $head = jQuery(".section-head");
	var $footer = jQuery(".section-footer");
	var $left = jQuery(".section-left");
	var $right = jQuery(".section-right");

	UT.resetCssBorderWidth($left);
	UT.resetCssBorderWidth($right);
	UT.resetCssBorderWidth($head);
	UT.resetCssBorderWidth($footer);
	
	var hH = $window.height() - ($head.outerHeight() + $footer.outerHeight());
	var hL = hH;
	hL -= ($left.outerHeight() - $left.innerHeight());
	hL -= (parseInt($left.css("padding-top"), 10) + parseInt($left.css("padding-bottom"), 10));
	
	var hR = hH;
	hR -= ($right.outerHeight() - $right.innerHeight());
	hR -= (parseInt($right.css("padding-top"), 10) + parseInt($right.css("padding-bottom"), 10));
	
	$left.css({
		height : hL + "px",
		overflowX : "hidden",
		overflowY : "auto",
		position : "relative"
	});

	$right.css({
		height : hR + "px",
		overflowX : "hidden",
		overflowY : "auto",
		position : "relative"
	});
};
/**
 * 왼쪽영역
 */
displayLeft = function() {
	var $left = jQuery(".section-left");
	$left.empty();
	var html = [];
	for (var index in objectMenu.menus) {
		html = html.concat(displayMenu(objectMenu.menus[index], 1));
	}
	$left.append(html.join(""));
};
/**
 * 메뉴
 */
displayMenu = function(menu) {
	var html = [];
	var submenu = [];
	if (typeof menu.menus === "object") {
		for (var index in menu.menus) {
			submenu = submenu.concat(UT.formatString(templateMenu.menu3(), {menus : displayMenu(menu.menus[index])}));
		}
	}
	if (typeof menu.file === "string") {
		html.push(UT.formatString(templateMenu.menu2(), {name : menu.name, file : menu.file, onclick : "doDetail(this)", submenu : submenu.join("")}));
	} else {
		html.push(UT.formatString(templateMenu.menu1(), {name : menu.name, submenu : submenu.join("")}));
	}
	return html;
};
/**
 * html 템플릿
 */
templateMenu = {
	menu1 : function() { // file이 없는 경우
		var html = [];
		html.push("<div class='menu'>");
		html.push("<span>{name}</span>");
		html.push("{submenu}");
		html.push("</div>");
		return html.join("");
	},
	menu2 : function() { // file이 있는 경우
		var html = [];
		html.push("<div class='menu'>");
		html.push("<a href='javascript:void(0)' onclick='{onclick}' file='{file}'>{name}</a>");
		html.push("{submenu}");
		html.push("</div>");
		return html.join("");
	},
	menu3 : function() { // 서브메뉴가 있는 경우
		var html = [];
		html.push("<div class='submenu'>{menus}</div>");
		return html.join("");
	}
};
/**
 * 메뉴선택
 */
doSelectedMenu = function(element) {
	var $element = jQuery(element);
	jQuery(".section-left").find(".on").removeClass("on");
	$element.closest(".menu").addClass("on");
	
	var $breadcrumb = jQuery(".breadcrumb");
	$breadcrumb.html($element.text());
};
jQuery(document).ready(function(){
	initLayout();
	displayLeft();
	jQuery(window).on("resize", function() {
		initLayout();
	});	
	initPage();
	
	jQuery(".section-left").find("a:first").trigger("click");
});
</script>
</head>
<body>

	<table class="layout">
	<colgroup>
		<col style="width:220px;"/>
		<col style="width:auto;"/>
	</colgroup>
	<tbody>
	<tr>
		<td class="section-head" colspan="2"><decorator:title/></td>
	</tr>
	<tr>
		<td><div class="section-left"></div></td>
		<td>
			<decorator:body/>
		</td>
	</tr>
	<tr>
		<td class="section-footer" colspan="2">Copyright ⓒ <strong>4csoft.</strong> All Rights Reserved.</td>
	</tr>
	</tbody>
	</table>
	
</body>
</html>
