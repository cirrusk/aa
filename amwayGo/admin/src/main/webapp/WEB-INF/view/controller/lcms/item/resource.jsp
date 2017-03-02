<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forFilelist = null;
var forFileDetail = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	var href = "<c:out value="${detail.itemResource.href}"/>".split("/");
	
	var filepath = [];
	if (href.length >= 4) { <%-- 2012/02/08/bEdkVdHXkKzSGQlxcXeh/..... 이므로 --%>
		for (var x = 0; x < 4; x++) {
			filepath.push(href[x]);
		}		
	}
	if (filepath.length == 4) {
		var $home = jQuery("#home");
		$home.find(".subfiles").attr("id", "dir-path-" + filepath.join("").replace(/[\.\/\s]/g,"")); // id에서는 . / 를 제거한다
		$home.find(".root").attr("dir-path", filepath.join("/")).find("a").trigger("click");
	}
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forFilelist = $.action("ajax");
	forFilelist.config.url = "<c:url value="/lcms/resource/list.do"/>";
	forFilelist.config.type = "json";
	forFilelist.config.fn.complete = function(action, data) {
		if (data != null && data.files != null) {
			var $files = jQuery("#dir-path-" + data.filepath.replace(/[\.\/\s]/g,""));
			var html = [];
			if (data.files.length > 0) {
				for (var i = 0; i < data.files.length; i++) {
					var filepath = data.filepath + "/" + data.files[i].saveName;
					if (data.files[i].directory == true) {
						html.push('<div dir-path="' + filepath + '" class="dir-path">');
						html.push('<a href="javascript:void(0)" onclick="doHide(this)" style="display:none;"><aof:img src="icon/tree_folder_branch_opened.gif"/></a>');
						html.push('<a href="javascript:void(0)" onclick="doFilelist(this)" class="file-list"><aof:img src="icon/tree_folder_branch_closed.gif"/></a>');
						html.push('<aof:img src="icon/tree_parent_closed_icon.gif"/>');
						html.push('<a href="javascript:void(0)" onclick="doDetail(this)" class="file-detail">' + data.files[i].saveName + '</a>');
						html.push('</div>');
						html.push('<div id="dir-path-' + filepath.replace(/[\.\/\s]/g, "") + '" class="subfiles"></div>');
					} else {
						html.push('<div dir-path="' + filepath + '" class="file">');
						html.push('<aof:img src="icon/tree_child_icon.gif"/>');
						html.push('<a href="javascript:void(0)" onclick="doDetail(this)" class="file-detail">' + data.files[i].saveName + '</a>');
						html.push('</div>');
					}
				}
			} else {
				var path = data.filepath.split("/");
				if (path.length == 4) {
					html.push('<div><spring:message code="글:데이터가없습니다" /></div>');
				}
			}
			$files.html(html.join(""));
		}
	};

	forFileDetail = $.action();
	forFileDetail.config.formId = "FormItemResource";
	forFileDetail.config.target = "resource";
	forFileDetail.config.url  = "<c:url value="/lcms/resource/detail/iframe.do"/>";
};
/**
 * 파일목록
 */
doFilelist = function(element) {
	var $element = jQuery(element);
	var $parent = jQuery(element).parent("div");
	forFilelist.config.parameters = "filepath=" + $parent.attr("dir-path");
	forFilelist.run();

	$element.hide();
	$element.prev("a").show();
	$parent.next("div").show();
};
/**
 * 하위 트리 접기
 */
doHide = function(element) {
	var $element = jQuery(element);
	var $parent = jQuery(element).parent("div");
	
	$element.hide();
	$element.next("a").show();
	$parent.next("div").hide();
};
/**
 * 파일 상세정보
 */
doDetail = function(element) {
	var $element = jQuery(element);
	var $parent = $element.parent("div");
	var form = UT.getById(forFileDetail.config.formId);
	form.elements["hrefOriginal"].value = $parent.attr("dir-path");
	form.elements["encoding"].value = UT.getCheckedValue("FormExtra", "encoding", "");
	forFileDetail.run();

	jQuery("#home").find(".highlight").removeClass("highlight");
	$parent.addClass("highlight");
};
/**
 * 현재 선택된것 리프레쉬
 */
doRefresh = function() {
	var $element = jQuery("#home").find(".highlight");
	$element.find(".file-detail").trigger("click");
	$element.find(".file-list").trigger("click");
};


/**
 * 리소스 다운로드
 */
doResourceDown = function() {
	var downPath = $("#rootPath").attr("dir-path");
	
	if(downPath != null && downPath != ""){
		var parameters = [];
		parameters.push("downPath=" + downPath);
		
		var action = null;
		action = $.action("ajax");
		action.config.formEmpty = true;
		action.config.type = "json";
		action.config.url = "<c:url value="/lcms/create/resource/file/response.do"/>";
		action.config.parameters = parameters.join("&");
		action.config.message.confirm = "<spring:message code="글:콘텐츠:리소스를다운로드하시겠습니까"/>";
		action.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
		action.config.fn.complete     = function(action, data) {
			if(data.fileFullPath != null && data.fileFullPath != ""){
				var fileParameters = [];
				fileParameters.push("fileFullName=resource");
				fileParameters.push("fileFullPath=" + data.fileFullPath);
				
				var fileAction = null;
				fileAction = $.action();
				fileAction.config.formId = "FormParameters";
				fileAction.config.url = "<c:url value="/lcms/resource/file/response.do"/>";
				fileAction.config.parameters = fileParameters.join("&");
				fileAction.run();
			}
		};
		action.run();
	}
};

</script>
<style type="text/css">
.root {padding-left:10px;}
.subfiles {line-height:20px; padding-left:20px !important; }
.subfiles .dir-path, .subfiles .file {padding:1px 0;}
.highlight {border:solid 1px #000000; background-color:#b1cff5;}
</style>
</head>

<body>

	<form id="FormItemResource" name="FormItemResource" method="post" onsubmit="return false;">
		<input type="hidden" name="resourceSeq" value="<c:out value="${detail.itemResource.resourceSeq}"/>"/>
		<input type="hidden" name="hrefOriginal" value=""/>
		<input type="hidden" name="encoding" value=""/>
	</form>

	<table>
	<colgroup>
	<col style="width:30%;"/>
	<col style="width:10px;"/>
	<col style="width:auto;"/>
	</colgroup>
	<thead>
	<tr>
		<td class="align-l">
			<div class="lybox-title">
				<h4 class="section-title"><spring:message code="글:콘텐츠:파일목록"/></h4>
			</div>
		</td>
		<td></td>
		<td class="align-l" style="position:relative;">
			<div class="lybox-title">
				<h4 class="section-title"><spring:message code="글:콘텐츠:파일상세정보"/></h4>
			</div>

			<div style="position:absolute; top:0px; right:0px;">
				<form id="FormExtra" name="FormExtra" method="post" onsubmit="return false;">
					<input type="radio" name="encoding" value="utf-8" checked="checked" class="radio"> <label>utf-8</label>
					<input type="radio" name="encoding" value="euc-kr" class="radio"> <label>euc-kr</label>
					<a class="btn gray" href="javascript:void(0)" onclick="doResourceDown();"><span class="small"><spring:message code="버튼:콘텐츠:리소스다운로드"/></span></a>
				</form>
			</div>
		</td>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td>
			<div class="scroll-xy align-l" style="width:230px; height:510px; border:solid 1px gray; background-color:#ffffff; padding:1px; ">
				<div id="home">
					<div class="root" id="rootPath">
						<a href="javascript:void(0)" onclick="doFilelist(this)" class="file-detail" style="display:none;"><aof:img src="icon/tree_folder_branch_closed.gif"/></a>
						<a href="javascript:void(0)" onclick="doDetail(this)" class="file-detail">ROOT</a>
					</div>
					<div class="subfiles" style="padding-left:10px !important;"></div>
				</div>
			</div>
		</td>
		<td style="border:none;"></td>
		<td>
			<div class="scroll-xy align-l" style="height:510px; border:solid 1px gray; vertical-align:top; padding:0px;">
				<iframe name="resource" id="resource" frameborder="no" style="width:100%; height:500px;"></iframe>
			</div>
		</td>
	</tr>
	</tbody>
	</table>


</body>
</html>