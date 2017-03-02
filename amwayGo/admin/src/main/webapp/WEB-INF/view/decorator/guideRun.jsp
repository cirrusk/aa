<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<!doctype html>
<!--[if IE 7]><html lang="ko" class="old ie7"><![endif]-->
<!--[if IE 8]><html lang="ko" class="old ie8"><![endif]-->
<!--[if IE 9]><html lang="ko" class="modern ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="ko" class="modern">
<!--<![endif]--><head>
<title><c:out value="${aoffn:config('system.name')}"/></title>
<c:import url="/WEB-INF/view/include/meta.jsp"/>
<c:import url="/WEB-INF/view/include/css.jsp"/>
<c:import url="/WEB-INF/view/include/javascript.jsp"/>
<decorator:head />
<script type="text/javascript">
jQuery(document).ready(function(){
    var index = "<c:out value="${param['index']}"/>";
    if (!isNaN(index)) {
        jQuery(".guide-info").hide();
        jQuery(".guide-code").hide();
        var $code = jQuery(".guide-code").eq(index).show();
        
        $code.find(".desc, .jsp, .xml, .java, .sql").hide(); // 실행시 화면에서 보여주지 않을 항목 
        $code.find(".html, .jsp-run").show();  // 보여줄 항목
        var $javascript = $code.find(".javascript").hide(); // javascript는 실행 시킨다.
        if ($javascript.length > 0) {
            eval($javascript.text());
        }
    }
});
</script>
<style type="text/css">
.guide-code .desc {font-weight:bold; margin-bottom:10px;}
.guide-code .html, 
.guide-code .jsp, 
.guide-code .jsp-run {border:solid 1px #ccc; padding:10px; margin-bottom:10px;}
.result-title {font-weight:bold; margin-bottom:10px;}
.guide-code a {color:#0000ff; font-weight:bold; text-decoration:underline;}
div {padding:5px;}
</style>
</head>
</head>
<body onload="<decorator:getProperty property="body.onload" />" style="overflow-x:hidden;">

<div style="padding:5px;">
    <c:import url="/WEB-INF/view/include/header.jsp"/>
    <div class="result-title">* 결과</div>
    <decorator:body />
    
    <iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;" title="hidden"></iframe>
</div>

</body>
</html>