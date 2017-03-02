<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="guide">
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
    doJson();
    doAdjustSize();
    
    jQuery(window).on("resize", function() {
        doAdjustSize();
    }); 
};
/**
 * 가이드 목록을 json 으로 가져온다
 */
doJson = function() {
    var action = $.action("ajax");
    action.config.type        = "json";
    action.config.url         = "<c:url value="/guide/json.do"/>";
    action.config.fn.complete = function(action, data) {
        if (data != null) {
            jsonData = data; // jsonData 전역변수
            var $tabs = jQuery("#tabs > ul");
            var $items = jQuery("#layout-left > .scroll-content");

            for (var type in jsonData) {
                $tabs.append(UT.formatString(template.tab, {"type": type}));
                var item = jsonData[type].item;
                if (typeof item === "object") {
                    var $ul = jQuery(template.guideItemSet).attr("id", type).appendTo($items);
                    for (var index = 0; index < item.length; index++) {
                        $ul.append(UT.formatString(template.guideItem, {"type": type, "id": item[index].id, "name": item[index].name}));
                    }
                }
            }
            searchTabIndex = doInitSearch(); // searchTabIndex 전역변수
            tabsUI = UI.tabs("#tabs").tabs({selected : 0}); // tabsUI 전역변수

            var scrollerId = "layout-left";
            scroller = jQuery.aosButtonScroller(scrollerId); // scroller 전역변수
        }
    };
    action.run();
};
/**
 * 크기 조절
 */
doAdjustSize = function() {
    var $body = jQuery(".layout-body");
    var $left = $body.find(".layout-left").hide();
    var $center = $body.find(".layout-center").hide();
    var h = $body.height();
    if (jQuery.browser.msie && parseInt(jQuery.browser.version) < 9) { // ie8, ie7
        var $head = jQuery(".layout-head");
        h -= ($head.height() + parseInt($head.css("padding-top"), 10) + parseInt($head.css("padding-bottom"), 10));
    }
    $left.height(h).show();
    $center.height(h).show();
    
    if (typeof scroller === "object") {
        scroller.height(h - 30); // 이전, 다음 크기보다 조금 크게 뺀다.
    }
};
/**
 * 탭선택
 */
doTab = function(id) {
    var $element = jQuery("#" + id);
    $element.siblings().hide();
    $element.show();
    if (typeof scroller === "object") {
        scroller.reset();
    }
};
/**
 * 검색
 */
doSearch = function() {
    var $element = jQuery("#search");
    $element.siblings().hide();
    $element.show();
    
    var $form = jQuery("#FormSrch");
    var keyword = $form.find(":input[name='keyword']").val().toLowerCase();

    tabsUI.tabs({"selected": searchTabIndex});
    var $ul = jQuery("#검색결과").empty();
    
    if (keyword.trim().length == 0) {
        return;
    }
    var searched = false;
    for (var type in jsonData) {
        var item = jsonData[type].item;
        if (typeof item === "object") {
            for (var index = 0; index < item.length; index++) {
                var values = item[index].id.toLowerCase() + " " + item[index].name.toLowerCase() + " " + item[index].keyword.toLowerCase();
                if (values.indexOf(keyword) > -1) {
                    $ul.append(UT.formatString(template.guideItem, {"type": type, "id": item[index].id, "name": item[index].name}));
                    searched = true;
                }
            }
        }
    }
    if (searched == false) {
        $ul.append(template.noSearch);
    }
    if (typeof scroller === "object") {
        scroller.reset();
    }
};
template = {
    // 탭 요소 탬플릿
    "tab" : "<li><a href='javascript:void(0)' onclick='doTab(\"{type}\");'>{type}</a></li>",
    // 가이드 요소 Set
    "guideItemSet" : "<ul></ul>",
    // 가이드 요소 템플릿
    "guideItem" : "<li class='guide-item'><a href='/guide/detail.do?type={type}&id={id}' target='layout-center'>{name}</a></li>",
    // 검색 결과 없음
    "noSearch" : "<li class='guide-item'>검색결과가 없습니다</li>"
}
/**
 * 검색 탭 & 검색 결과 요소 생성
 */
doInitSearch = function() {
    var type = "검색결과";
    var $tabs = jQuery("#tabs > ul");
    $tabs.append(UT.formatString(template.tab, {"type": type}));

    var $items = jQuery("#layout-left > .scroll-content");
    $items.append(jQuery(template.guideItemSet).attr("id", type).append(template.noSearch));
    return $tabs.find("li").length - 1;
};
</script>
<style type="text/css">
html, body {width:100%; height:100%; overflow:hidden; }
#layout {width:100%; height:100%;}
#layout .layout-head,
#layout .layout-body {width:100%; height:100%; padding:3px; vertical-align:top; position:relative;}
#layout .search {position:absolute; top:7px; right:10px;}
#layout .layout-head {height:auto;}
#layout .layout-left {width:250px; vertical-align:top; border-right:solid 1px #ccc; position:relative;}
#layout .layout-center {width:100%; vertical-align:top; border:none;}
#layout .layout-left .scroll-content {position:absolute; left:0; top:13px; width:250px;}
#layout .layout-left .scroll-top {position:absolute; left:0; top:0; z-index:10; width:248px; height:10px; line-height:12px; text-align:center; border:solid 1px #ccc; background-color:rgb(245, 245, 245);}
#layout .layout-left .scroll-bottom {position:absolute; left:0; bottom:0; z-index:10; width:248px; height:10px; line-height:12px; text-align:center; border:solid 1px #ccc; background-color:rgb(245, 245, 245);}

.ui-tabs-panel  {display:none !important;}
.guide-item {list-style:disc; margin-left:15px; font-size:13px;}
</style>
</head>
<body>

<table id="layout">
<tr>
    <td class="layout-head">
        <div id="tabs"> 
            <ul class="ui-widget-header-tab-custom"></ul>
        </div>
        <div class="search">
            <form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
                <input type="text" name="keyword" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);">
                <a href="javascript:void(0)" onclick="doSearch()" class="btn black"><span class="mid">찾기<span></a>
            </form>
        </div>
    </td>
</tr>
<tr>
    <td class="layout-body">
        <table>
        <tr>
            <td class="layout-left" id="layout-left">
                <div class="scroll-top"><a href="javascript:void(0)" title="이전">▲</a></div>
                <div class="scroll-content"></div>
                <div class="scroll-bottom"><a href="javascript:void(0)" title="다음">▼</a></div>
            </td>
            <td>
                <iframe class="layout-center" id="layout-center" name="layout-center" frameborder="no"></iframe>
            </td>
        </tr>
        </table>
    </td>
</tr>
</table>

</body>
</html>