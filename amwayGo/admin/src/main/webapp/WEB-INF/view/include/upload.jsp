<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/3rdparty/swfupload/swfobject.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/3rdparty/swfupload/swfupload.js"></script>
<script type="text/javascript" src="<c:out value="${appDomainWeb}"/>/js/lib/jquery.aos.swfu.min.js"></script>
<script type="text/javascript">
var uploaderDefaultOption = {
	fileLimitType : "<c:out value="${aoffn:config('upload.fileLimitType')}"/>",
	file : {
		buttonImageUrl : '<aof:img type="print" src="btn/upload_61x22.png"/>',
		deleteIconUrl : "<aof:img type="print" src="common/x_01.gif"/>",
		buttonWidth : 61,
		buttonHeight : 22
	},
	photo : {
		buttonImageUrl : '<aof:img type="print" src="btn/photo_22x22.png"/>',
		deleteIconUrl : "<aof:img type="print" src="common/x_01.gif"/>",
		buttonWidth : 23,
		buttonHeight : 22
	}
};
</script>