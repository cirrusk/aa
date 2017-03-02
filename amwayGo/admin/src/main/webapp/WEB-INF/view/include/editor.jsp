<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<script type="text/javascript" src="/editor/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var editorGlobalVariables = {
	imageContext : "<c:out value="${aoffn:config('upload.context.image')}"/>",
	buttonImageUrl : "<aof:img type="print" src="btn/photo_22x22.png"/>",
	uploadUrl : "<c:url value="/attach/image/save.do"/>",
	skin : "/editor/smarteditor/SmartEditor2Skin.html"
};
</script>