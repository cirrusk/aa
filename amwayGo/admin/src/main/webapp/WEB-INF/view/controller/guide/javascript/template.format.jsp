<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        동적으로 html을 append
    </div>

    <div class="guide-desc">
        동적으로 html을 append 할 때는 template를 만들어 사용한다.
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
        template와 UT.formatString 을 이용한다.
    </div>

    <div class="html">
<div id="target">여기에 append 됩니다</div>
<a href="javascript:void(0)" onclick="doTest()" class="btn blue"><span class="mid">클릭</span></a>
    </div>

    <div class="javascript">
doTest = function() {
    var $target = jQuery("#target");
    $target.empty(); // 영역을 비운다.
    $target.append(jQuery(UT.formatString(template.title, {"mainTitle": "메인 타이틀입니다.", "subTitle": "서브 타이틀입니다"})));
    $target.append(jQuery(UT.formatString(template.description(), {"name": "이름입니다", "address": "주소입니다"})));
};
template = {
    "title" : "&lt;h2>&lt;span>{mainTitle}&lt;/span>-&lt;span>{subTitle}&lt;/span>&lt;/h2>", // 간단한 경우에는 string 형식으로.
    "description" : function() { // 복잡한 경우에는 function으로.
        var html = [];
        html.push("&lt;ul>");
        html.push("&lt;li>{name}&lt;/li>");
        html.push("&lt;li>{address}&lt;/li>");
        html.push("&lt;/ul>");
        return html.join("");
    }
};
    </div>

</div>

</body>
</html>