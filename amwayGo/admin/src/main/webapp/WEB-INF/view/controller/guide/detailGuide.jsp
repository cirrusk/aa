<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="guide">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/codeMirror.jsp"/>
<script type="text/javascript">
var forGuide = null;
var forGuideRun = null;
var codeClass = ["java", "javascript", "html", "css", "jsp", "xml", "sql"];
initPage = function() {
    doInitializeLocal();
    
    doGuide();
};
/**
 * 설정
 */
doInitializeLocal = function() {
    forGuide = $.action("ajax");
    forGuide.config.url         = "<c:url value="/guide/${param['type']}/${param['id']}.do"/>";
    forGuide.config.type        = "html";
    forGuide.config.containerId = "hiddenContainer"; 
    forGuide.config.fn.complete = function(action, data) {
        var $data = jQuery("#" + forGuide.config.containerId).hide();

        var $cont = jQuery("#visibleContainer").show();
        
        var $contInfo = $cont.find(".cont-info").empty();
        var $contCode = $cont.find(".cont-code").empty();
        
        var $guideInfo = $data.find(".guide-info");
        var $guideCode = $data.find(".guide-code");
        
        if ($guideInfo.length > 0) {
            $contInfo.html($guideInfo.html());
        }

        if ($guideCode.length > 0) {
            var $div = jQuery("<div>");
            $div.appendTo($contCode);
            
            $guideCode.each(function(index) {
                var $this = jQuery(this);
                
                $div.append(jQuery(UT.formatString(template.guideDesc, {"index": (index + 1), "desc": $this.find(".desc").html()})));
                
                for (var i = 0; i < codeClass.length; i++) {
                    doMakeCodeEditor($this, codeClass[i], $div, index);
                }
                if ($this.hasClass("runnable")) {
                    $div.append(jQuery(UT.formatString(template.guideRun, {"index": index})))
                }
            });
        }
    };
    
    forGuideRun = $.action("layer");
    forGuideRun.config.url = forGuide.config.url;
    forGuideRun.config.options.width = 800;
    forGuideRun.config.options.height = 600;
    forGuideRun.config.options.title = "Run";
    
};
/**
 * 가이드 상세 데이타 
 */
doGuide = function() {
    forGuide.run();
};
/**
 * 가이드 상세 데이타 
 */
doGuideRun = function(index) {
    var param = [];
    param.push("type=run");
    param.push("index=" + index);
    
    forGuideRun.config.parameters = param.join("&");
    forGuideRun.run();
};
/**
 * 코드 에디터 생성
 */
doMakeCodeEditor = function($object, className, $target, index) {
    var $code = $object.find("." + className);
    if ($code.length > 0) {
        var id = className + "-" + index;
        $target.append(jQuery(UT.formatString(template.guideCode, {"name": className, "id": id, "code": $code.html()})));
        var mode = "htmlmixed";
        switch(className) {
        case "java": 
            mode = "text/x-java"; 
            break;
        case "javascript": 
            mode = "javascript"; 
            break;
        case "xml": 
            mode = "xml"; 
            break;
        case "html": 
        case "jsp": 
            mode = "text/html"; 
            break;
        case "css": 
            mode = "text/css"; 
            break;
        case "sql": 
            mode = "text/x-sql"; 
            break;
        default:
            mode = "htmlmixed"; 
            break;
        }
        UI.codeMirror(id, {mode: mode, readOnly : true, theme: "solarized dark", styleActiveLine: false});
    }
};
template = {
    // 가이드 소항목 설명 탬플릿
    "guideDesc" : "<div class='guide-desc'><div class='index'>{index}.</div>{desc}</div>",
    
    // 코드 에디터 탬플릿
    "guideCode" : "<div class='guide-code'>@ {name}<textarea id='{id}'>{code}</textarea></div>",
   
    // 가이드 RUN 탬플릿
    "guideRun" : "<div class='guide-run'><a href='javascript:void(0)' onclick='doGuideRun({index})'>Run</a></div>"

}
</script>
<style type="text/css">
.CodeMirror {height:auto;}
.CodeMirror-scroll {overflow-y:auto; overflow-x:auto;}
.cont-info .guide-title {font-size:18px; font-weight:bold;}
.cont-info .guide-desc {margin-bottom:10px;}
.cont-code .guide-desc {font-weight:bold; padding:0 30px 0 20px; position:relative;}
.cont-code .guide-desc .index {position:absolute; left:0; top:0; font-size:11px; }
.cont-code .guide-code {padding:0 30px 0 20px;}
.cont-code .guide-run {text-align:right; padding-right:30px;}
.cont-code .guide-run a {color:#0000ff; font-weight:bold; text-decoration:underline;}
body {padding:0 5px;}

.red {color:#ff0000;}
.blue {color:#0000ff;}
</style>
</head>
<body>

<div id="hiddenContainer" style="display:none;"></div>

<div id="visibleContainer">
    <div class="cont-info"></div>
    
    <div class="cont-code"></div>
</div>

</body>
</html>