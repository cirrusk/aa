<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:code type="setlist" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType" except="pm"/>

<html decorator="popup">
<head>
<title></title>
<script type="text/javascript">
var forFilelist = null;
var forFileDelete = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	jQuery(".selected-output").trigger("click");
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
	
	forFileDelete = $.action("ajax");
	forFileDelete.config.formId = "FormOutputDelete";
	forFileDelete.config.url = "<c:url value="/cdms/output/file/delete/json.do"/>";
	forFileDelete.config.type = "json";
	forFileDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forFileDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>";
	forFileDelete.config.fn.complete = function(action, data) {
		if (data.success == 0) {
			$.alert({
				message : "<spring:message code="글:오류가발생하였습니다"/>"
			});
		}
		if (data.deleteOption == "root") {
			jQuery(".selected-output").trigger("click");
		} else {
			jQuery("#file-home").find(".selected").closest(".subfiles").siblings(".dir-path").find(".file-list").trigger("click"); // 파일목록 
		}
	};	
	
	swfu = UI.uploader.create(function() {  // completeCallback
			var $file = jQuery("#file-home").find(".selected").find(".file-list");
			if ($file.length > 0) {
				$file.trigger("click"); // 파일목록 
			} else {
				jQuery(".selected-output").trigger("click");
			}
			UI.uploader.cancelUpload(swfu, "uploader"); // 업로드파일 지우기
		},
		[{
			elementId : "uploader",
			options : {
				uploadUrl : "<c:url value="/attach/cdms/output/file/upload/json/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All File",
				fileSizeLimit : "100 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputWidth : 160, // default : 300
				inputHeight : 20, // default : 20
				immediatelyUpload : false,
				successCallback : function(id, file) {}
			}
		}]
	);	
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
	
	jQuery("#file-home").find(".selected").removeClass("selected");
	$parent.addClass("selected");
};
/**
 * 파일업로드
 */
doUploadOutputFile = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader") == false) {
		$.alert({
			message : "<spring:message code="글:CDMS:파일을선택하십시오"/>"
		});
		return;
	} else {
		var $form = jQuery("#FormOutputUpload");
		var folder = $form.find(":input[name='folder']").filter(":checked").val();
		var path = jQuery("#root").attr("dir-path");
		if (folder === "select") {
			var $selected = jQuery("#file-home").find(".selected");
			if ($selected.length > 0) {
				path = $selected.attr("dir-path");
			} else {
				$.alert({
					message : "<spring:message code="글:CDMS:폴더를선택하십시오"/>"
				});
				return;
			}
		}
		postParams = {
			currentMenuId : $form.find(":input[name='currentMenuId']").val(),
			unzipYn : $form.find(":input[name='unzipYn']").filter(":checked").length > 0 ? "Y" : "N",
			filepath : path  
		};
		UI.uploader.setPostParams(swfu, "uploader", postParams);
		UI.uploader.runUpload(swfu, "uploader");
	}
};
/**
 * 파일/폴더 삭제
 */
doDeleteOutputFile = function() {
	var $form = jQuery("#" + forFileDelete.config.formId);
	var del = $form.find(":input[name='deleteOption']").filter(":checked").val();
	var path = jQuery("#root").attr("dir-path");
	if (del === "select") {
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
	forFileDelete.run();
	
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
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
								<c:set var="selected" value=""/>
								<c:if test="${rowSub.output.sectionIndex eq detailOutput.output.sectionIndex 
								    and rowSub.output.outputIndex eq detailOutput.output.outputIndex and empty moduleIndex}">
									<c:set var="selected" value="selected-output"/>
								</c:if>
								<c:set var="dirPath" value="${rootPath}/${rowSub.output.sectionIndex}/${rowSub.output.outputIndex}"/>
								<li class="item <c:out value="${selected}"/>" dir-path="<c:out value="${dirPath}"/>" style="display:block;" 
									<c:if test="${rowSub.output.sectionIndex eq detailOutput.output.sectionIndex
									    and rowSub.output.outputIndex eq detailOutput.output.outputIndex and empty moduleIndex}">
										onclick="doOutputFile(this)"
									</c:if>
								>
									<c:choose>
										<c:when test="${!empty rowSub.output.outputCd}"><c:out value="${rowSub.output.outputName}"/></c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</li>
								
								<%-- 차시모듈을 선택했을 경우 --%>
								<c:if test="${rowSub.output.sectionIndex eq detailOutput.output.sectionIndex 
								    and rowSub.output.outputIndex eq detailOutput.output.outputIndex and rowSub.output.moduleYn eq 'Y' and !empty moduleIndex}">
									<ul class="list-bullet" style="padding-left:20px;">
										<c:set var="moduleCount" value="${detailProject.project.moduleCount}"/>
										<c:forEach var="rowModule" begin="1" end="${moduleCount}" step="1" varStatus="iModule">
											<c:set var="selected" value=""/>
											<c:if test="${moduleIndex eq rowModule}">
												<c:set var="selected" value="selected-output"/>
											</c:if>
											<c:set var="dirPath" value="${rootPath}/${rowSub.output.sectionIndex}/${rowSub.output.outputIndex}/module${rowModule}"/>
											<li class="module <c:out value="${selected}"/>" dir-path="<c:out value="${dirPath}"/>" style="display:block;" 
												<c:if test="${moduleIndex eq rowModule}">
													onclick="doOutputFile(this)"
												</c:if>
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
			<div class="lybox-nobg scroll-y" style="height:350px;">
				<div id="file-home">
					<div id="root" class="selected dir-path" style="display:none;">
						<a href="javascript:void(0)" onclick="doFilelist(this)" class="file-list"><aof:img src="icon/tree_folder_branch_closed.gif"/></a>
					</div>
					<div class="subfiles root-subfiles" style="padding-left:0;"></div>
				</div>
			</div>

			<div class="lybox-btn lybox-nobg mt10" style="padding:0;">
				<div class="lybox-btn-l">
					<div id="uploader" class="uploader"></div>
					<form name="FormOutputUpload" id="FormOutputUpload" method="post" onsubmit="return false;">
						<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(appCurrentMenu.menu.menuId)}"/>"/>
						<div class="vspace"></div>
						<div class="options"><input type="checkbox" name="unzipYn" value="Y"> <label><spring:message code="글:CDMS:압축풀기" />(<spring:message code="글:CDMS:zip파일인경우" />)</label></div>
						<div class="options"><input type="radio" name="folder" value="root" checked="checked"> <label><spring:message code="글:CDMS:루트폴더에파일업로드"/></label></div>
						<div class="options"><input type="radio" name="folder" value="select"> <label><spring:message code="글:CDMS:선택된폴더에파일업로드"/></label></div>
					</form>
				</div>
				<div class="lybox-btn-r">
					<a href="javascript:void(0)" onclick="doUploadOutputFile()" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:업로드" /></span></a>
				</div>
			</div>

			<div class="lybox-btn lybox-nobg mt10" style="padding:0;">
				<div class="lybox-btn-l">
					<form name="FormOutputDelete" id="FormOutputDelete" method="post" onsubmit="return false;">
						<input type="hidden" name="filepath"/>
						<div class="options"><input type="radio" name="deleteOption" value="select" checked="checked"> <label><spring:message code="글:CDMS:선택된파일또는폴더삭제"/></label></div>
						<div class="options"><input type="radio" name="deleteOption" value="root"> <label><spring:message code="글:CDMS:루트폴더삭제"/>(<spring:message code="글:CDMS:전체삭제"/>)</label></div>
					</form>
				</div>
				<div class="lybox-btn-r">
					<a href="javascript:void(0)" onclick="doDeleteOutputFile()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
				</div>
			</div>
		</td>
	</tr>
	</tbody>
	</table>
	
</body>
</html>