<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html decorator="popup">
<head>
<title></title>
<script type="text/javascript">
var forFilelist = null;
var forFilePorting = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	jQuery(".item").filter(":first").trigger("click");
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forFilelist = $.action("ajax");
	forFilelist.config.url = "<c:url value="/cdms/output/file/list/json.do"/>";
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
						html.push('<span class="dir-path-name" onclick="doSelectFile(this)">' + data.files[i].saveName + '</span>');
						html.push('</div>');
						html.push('<div id="dir-path-' + filepath.replace(/[\.\/\s]/g, "") + '" class="subfiles"></div>');
					} else {
						html.push('<div dir-path="' + filepath + '" class="file">');
						html.push('<aof:img src="icon/tree_child_icon.gif"/>');
						html.push('<span class="file-name" onclick="doSelectFile(this)">' + data.files[i].saveName + '</span>');
						html.push('</div>');
					}
				}
			} else {
				html.push('<div><spring:message code="글:CDMS:파일이없습니다" /></div>');
			}
			$files.html(html.join(""));
		}
	};
	
	forFilePorting = $.action("submit");
	forFilePorting.config.url = "<c:url value="/cdms/project/file/porting.do"/>";
	forFilePorting.config.formId = "FormOutputPorting";
	forFilePorting.config.target = "hiddenframe";
	forFilePorting.config.message.confirm = "<spring:message code="글:CDMS:포팅하시겠습니까"/>";
	forFilePorting.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forFilePorting.config.fn.complete = function(success) {
		if (success == "true") {
			$.alert({
				message : "<spring:message code="글:CDMS:포팅되었습니다"/>"
			});
		} else {
			$.alert({
				message : "<spring:message code="글:오류가발생하였습니다"/>"
			});
		}
	};
};
/**
 * 산출물 파일목록
 */
doOutputFile = function(element) {
	jQuery(".selected-output").removeClass("selected-output");
	var $element = jQuery(element);
	$element.addClass("selected-output");
	var dirPath = $element.attr("dir-path").split("/");
	var $root = jQuery("#root");
	
	$root.siblings(".subfiles").attr("id", "dir-path-" + dirPath.join("").replace(/[\.\/\s]/g,"")); // id에서는 . / 를 제거한다
	$root.attr("dir-path", dirPath.join("/")).find("a").trigger("click");
	
	var $form = jQuery("#" + forFilePorting.config.formId);
	$form.find(":input[name='filename']").val($element.attr("zip"));
};
/**
 * 파일목록
 */
doFilelist = function(element) {
	var $element = jQuery(element);
	var $parent = $element.parent("div");
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
	var $parent = $element.parent("div");
	
	$element.hide();
	$element.next("a").show();
	$parent.next("div").hide();
};
/**
 * 폴더 선택
 */
doSelectFile = function(element) {
	var $element = jQuery(element);
	var $parent = $element.parent("div");
	
	jQuery("#home").find(".selected").removeClass("selected");
	$parent.addClass("selected");
};
/**
 * 파일/폴더 포팅
 */
doPortingOutputFile = function() {
	var $form = jQuery("#" + forFilePorting.config.formId);
	var sel = $form.find(":input[name='portingOption']").filter(":checked").val();
	var path = jQuery("#root").attr("dir-path");
	if (sel === "select") {
		var $selected = jQuery(".root-subfiles").find(".selected");
		if ($selected.length > 0) {
			path = $selected.attr("dir-path");
			
		} else {
			$.alert({
				message : "<spring:message code="글:CDMS:파일또는폴더를선택하십시오"/>"
			});
			return;
		}
	}
	$form.find(":input[name='filepath']").val(path);
	
	forFilePorting.run();
};
</script>
<style type="text/css">
.selected-output {border:solid 1px #b1cff5; background-color:#f7f7f7; }
.subfiles {line-height:20px; padding-left:20px; white-space:nowrap; word-wrap:normal; display:none; }
.subfiles .dir-path {padding:2px 0;}
.subfiles .file {padding:2px 0 2px 3px; }
.subfiles .file-name {cursor:pointer;}
.subfiles .dir-path-name {cursor:pointer; }
.subfiles .selected {border:solid 1px #b1cff5; background-color:#f7f7f7;}
</style>
</head>

<body>

	<table class="tbl-layout">
	<colgroup>
		<col style="width:235px" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
	<tr>
		<td class="first">
			<div class="lybox-nobg scroll-y" style="height:530px;">
				<c:forEach var="row" items="${listSection}" varStatus="i">
					<div class="strong">
						<c:choose>
							<c:when test="${!empty row.section.sectionName}"><c:out value="${row.section.sectionName}"/></c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose>
					</div>
					<ul class="list-bullet" style="padding-left:20px;">
						<c:forEach var="rowSub" items="${listOutput}" varStatus="iSub">
							<c:if test="${row.section.sectionIndex eq rowSub.output.sectionIndex}">
								<c:set var="dirPath" value="${rootPath}/${rowSub.output.sectionIndex}/${rowSub.output.outputIndex}"/>
								
								<li class="item block cursor-pointer" dir-path="<c:out value="${dirPath}"/>" onclick="doOutputFile(this)" 
									zip="<c:out value="project${rowSub.output.projectSeq}-section${rowSub.output.sectionIndex}-output${rowSub.output.outputIndex}.zip"/>">
									<span class="cdms-list-style">
										<c:choose>
											<c:when test="${!empty rowSub.output.outputCd}"><c:out value="${rowSub.output.outputName}"/></c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose>
									</span>
								</li>
								
								<c:if test="${rowSub.output.moduleYn eq 'Y'}">
									<ul class="list-bullet" style="padding-left:20px;">
										<c:set var="moduleCount" value="${detailProject.project.moduleCount}"/>
										<c:forEach var="rowModule" begin="1" end="${moduleCount}" step="1" varStatus="iModule">
											<c:set var="selected" value=""/>
											<c:if test="${moduleIndex eq rowModule}">
												<c:set var="selected" value="selected-output"/>
											</c:if>
											<c:set var="dirPath" value="${rootPath}/${rowSub.output.sectionIndex}/${rowSub.output.outputIndex}/module${rowModule}"/>
											<li class="module block cursor-pointer" dir-path="<c:out value="${dirPath}"/>" onclick="doOutputFile(this)" 
												zip="<c:out value="project${rowSub.output.projectSeq}-section${rowSub.output.sectionIndex}-output${rowSub.output.outputIndex}-module${rowModule}.zip"/>"
											><c:out value="${rowModule}"/><spring:message code="필드:CDMS:차시"/></li>
										</c:forEach>
									</ul>
								</c:if>
							</c:if>
						</c:forEach>
					</ul>
				</c:forEach>
		
				<c:if test="${empty listSection}">
					<div><spring:message code="글:데이터가없습니다" /></div>
				</c:if>
			</div>
		</td>
		<td>
			<div class="lybox-nobg scroll-y" style="height:435px;">
				<div id="home">
					<div id="root" class="selected" style="display:none;">
						<a href="javascript:void(0)" onclick="doFilelist(this)" class="file-list"><aof:img src="icon/tree_folder_branch_closed.gif"/></a>
					</div>
					<div class="subfiles root-subfiles" style="padding-left:0;"></div>
				</div>
			</div>
			<div class="lybox-btn lybox-nobg mt10" style="padding:0;">
				<div class="lybox-btn-l">
					<form name="FormOutputPorting" id="FormOutputPorting" method="post" onsubmit="return false;">
						<input type="hidden" name="filepath"/>
						<span><spring:message code="필드:CDMS:파일명"/></span>
						<input type="text" name="filename" style="margin-left:5px; width:150px; height:16px; line-height:16px;" readonly="readonly"/>
						<div class="vspace"></div>
						<div class="options"><input type="radio" name="portingOption" value="select" checked="checked"> <label><spring:message code="글:CDMS:선택된파일또는폴더포팅"/></label></div>
						<div class="options"><input type="radio" name="portingOption" value="root"> <label><spring:message code="글:CDMS:루트폴더포팅"/></label></div>
					</form>
				</div>
				<div class="lybox-btn-r">
					<a href="javascript:void(0)" onclick="doPortingOutputFile()" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:LCMS포팅" /></span></a>
				</div>
			</div>
		</td>
	</tr>
	</table>
	
</body>
</html>