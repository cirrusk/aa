<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/theme/eclipse.css">
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/theme/midnight.css">
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/theme/solarized.css">
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/addon/display/fullscreen.css">
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/lib/codemirror.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/mode/htmlmixed/htmlmixed.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/mode/javascript/javascript.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/mode/xml/xml.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/mode/css/css.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/mode/sql/sql.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/mode/clike/clike.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/addon/selection/active-line.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/addon/edit/matchbrackets.js"></script>
<script src="<c:out value="${appDomainWeb}"/>/js/3rdparty/codemirror/addon/display/fullscreen.js"></script>
<style type="text/css">
.CodeMirror {border:1px solid black; font-size:12px; line-height:1.2em;}
.cm-tab {
    background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAMCAYAAAAkuj5RAAAAAXNSR0IArs4c6QAAAGFJREFUSMft1LsRQFAQheHPowAKoACx3IgEKtaEHujDjORSgWTH/ZOdnZOcM/sgk/kFFWY0qV8foQwS4MKBCS3qR6ixBJvElOobYAtivseIE120FaowJPN75GMu8j/LfMwNjh4HUpwg4LUAAAAASUVORK5CYII=);
    background-position: right;
    background-repeat: no-repeat;
}
</style>
