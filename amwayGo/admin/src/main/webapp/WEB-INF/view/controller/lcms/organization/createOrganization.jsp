<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_CONTENTS_TYPE_SCORM"      value="${aoffn:code('CD.CONTENTS_TYPE.SCORM')}"/>
<c:set var="CD_CONTENTS_TYPE_MOVIE"      value="${aoffn:code('CD.CONTENTS_TYPE.MOVIE')}"/>
<c:set var="CD_CONTENTS_TYPE_FLASH"      value="${aoffn:code('CD.CONTENTS_TYPE.FLASH')}"/>
<c:set var="CD_CONTENTS_TYPE_LINK"       value="${aoffn:code('CD.CONTENTS_TYPE.LINK')}"/>
<c:set var="CD_CONTENTS_TYPE_BROWSE"     value="${aoffn:code('CD.CONTENTS_TYPE.BROWSE')}"/>
<c:set var="CD_CONTENTS_SIZE_WIDTH"      value="${aoffn:code('CD.CONTENTS_SIZE.WIDTH')}"/>
<c:set var="CD_CONTENTS_SIZE_HEIGHT"     value="${aoffn:code('CD.CONTENTS_SIZE.HEIGHT')}"/>
<c:set var="CD_COMPLETION_TYPE_TIME"     value="${aoffn:code('CD.COMPLETION_TYPE.TIME')}"/>
<c:set var="CD_COMPLETION_TYPE_PROGRESS" value="${aoffn:code('CD.COMPLETION_TYPE.PROGRESS')}"/>

<aof:session key="roleGroups" var="ssRoleGroups"/>
<aof:session key="currentRolegroupSeq" var="ssCurrentRolegroupSeq"/>

<c:set var="accessFtpDir" value=""/>
<c:forEach var="row" items="${ssRoleGroups}" varStatus="i">
	<c:if test="${row.rolegroupSeq eq ssCurrentRolegroupSeq}">
		<c:set var="accessFtpDir" value="${row.accessFtpDir}"/>
	</c:if>
</c:forEach>

<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>

<html decorator="popup">
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CONTENTS_TYPE_SCORM = "<c:out value="${CD_CONTENTS_TYPE_SCORM}"/>";
var CD_CONTENTS_TYPE_MOVIE = "<c:out value="${CD_CONTENTS_TYPE_MOVIE}"/>";
var CD_CONTENTS_TYPE_FLASH = "<c:out value="${CD_CONTENTS_TYPE_FLASH}"/>";
var CD_CONTENTS_TYPE_LINK = "<c:out value="${CD_CONTENTS_TYPE_LINK}"/>";
var CD_CONTENTS_TYPE_BROWSE = "<c:out value="${CD_CONTENTS_TYPE_BROWSE}"/>";
var CD_COMPLETION_TYPE_TIME = "<c:out value="${CD_COMPLETION_TYPE_TIME}"/>";
var CD_COMPLETION_TYPE_PROGRESS = "<c:out value="${CD_COMPLETION_TYPE_PROGRESS}"/>";

var profTypeCd = {};
<c:forEach var="row" items="${profTypeCode}" varStatus="i">
profTypeCd["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
</c:forEach>
var forStep1 = null;
var forStep2scorm = null;
var forStep2nonscorm = null;
var forStep2link = null;
var forStep3link = null;
var forStep2browse = null;
var forStep3nonscorm = null;
var forStep4nonscorm = null;
var forNonscormUnzip = null;
var forServerFile = null;
var forListdata = null;
var swfu = null;
var nextForm = null;
var accessFtpDirs = "<c:out value="${accessFtpDir}"/>".split(",");

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// uploader
	swfu = UI.uploader.create(function() { // completeCallback
			if (nextForm != null) {
				var contentsType = nextForm.elements["contentsTypeCd"].value;
				if (contentsType == CD_CONTENTS_TYPE_SCORM) {
					forStep2scorm.run("continue");
				} else {
					UT.copyValueFormToForm(forStep2nonscorm.config.formId, forStep3nonscorm.config.formId);
					forStep2nonscorm.run("continue");
				}
			}
		},
		[{
			elementId : "uploader1",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/contents/save.do"/>",
				fileTypes : "*.zip",
				fileTypesDescription : "Zip Files",
				fileSizeLimit : "2000 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : false,
				successCallback : function(id, file) {
					nextForm = UT.getById(forStep2scorm.config.formId);
					var fileInfo = file.serverData.fileInfo;
					nextForm.elements["filepath"].value = fileInfo.savePath + "/" + fileInfo.saveName;
				}
			}
		},
		{
			elementId : "uploader2",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/contents/save.do"/>",
				fileTypes : "*.zip;*.esz",
				fileTypesDescription : "Zip Files",
				fileSizeLimit : "2000 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : false,
				successCallback : function(id, file) {
					nextForm = UT.getById(forStep2nonscorm.config.formId);
					var fileInfo = file.serverData.fileInfo;
					nextForm.elements["filepath"].value = fileInfo.savePath + "/" + fileInfo.saveName;
				}
			}
		}]
	);	
	
	doNext(1);

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forStep1 = $.action("script", {formId : "FormStep1"});
	forStep1.config.fn.exec = function() {
		doNext(2);
	};

	forStep2scorm = $.action("submit", {formId : "FormStep2scorm"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forStep2scorm.config.url             = "<c:url value="/lcms/organization/insert.do"/>";
	forStep2scorm.config.target          = "hiddenframe";
	forStep2scorm.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forStep2scorm.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forStep2scorm.config.fn.before       = doStartUploadScorm;
	forStep2scorm.config.fn.complete     = doCompleteInsert;
	
	forStep2nonscorm = $.action("ajax", {formId : "FormStep2nonscorm"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forStep2nonscorm.config.url             = "<c:url value="/lcms/organization/unzipfile.do"/>";
	forStep2nonscorm.config.type = "json";
	forStep2nonscorm.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forStep2nonscorm.config.fn.before       = doStartUploadNonscorm;
	forStep2nonscorm.config.fn.complete     = function(action, data) {
		var $files = jQuery("#startfile-server");
		var html = "<ul class='filelist'>";
		if (data != null && data.files != null) {
			for (var i = 0; i < data.files.length; i++) {
				html += "<li onclick='doHighlight(this)'><input type='radio' name='startFile' value='" + data.files[i].saveName + "'><label>" + data.files[i].saveName + "</label></li>";
			}
		}
		html += "</ul>";
		$files.html(html);
		$files.show();
		UT.copyValueFormToForm(forStep2nonscorm.config.formId, forStep3nonscorm.config.formId);
		var form = UT.getById(forStep3nonscorm.config.formId);
		form.elements["filepath"].value = data.filepath;
		$files.find(":input[name='startFile']").each(function() {
			if (this.value == "index.html") {
				jQuery(this).closest("li").trigger("click");
			}
		});
		
		doNext(3);
	};
	
	forStep2link = $.action("script", {formId : "FormStep2link"});
	forStep2link.config.fn.exec = function() {
		doNext(3);
	};

	forStep3link = $.action("submit", {formId : "FormStep3link"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forStep3link.config.url             = "<c:url value="/lcms/organization/insert.do"/>";
	forStep3link.config.target          = "hiddenframe";
	forStep3link.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forStep3link.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forStep3link.config.fn.complete     = doCompleteInsert;

	forStep2browse = $.action("ajax", {formId : "FormStep2browse"});
	forStep2browse.config.type = "html";
	forStep2browse.config.url  = "<c:url value="/lcms/organization/list/ajax.do"/>";
	forStep2browse.config.containerId = "browseOrgData";
	forStep2browse.config.fn.complete = function () {
		doNext(2);
	};

	forStep3nonscorm = $.action("script", {formId : "FormStep3nonscorm"});
	forStep3nonscorm.config.fn.exec = function() {
		doNext(4);
	};
	
	forStep4nonscorm = $.action("submit", {formId : "FormStep4nonscorm"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forStep4nonscorm.config.url             = "<c:url value="/lcms/organization/insert.do"/>";
	forStep4nonscorm.config.target          = "hiddenframe";
	forStep4nonscorm.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forStep4nonscorm.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forStep4nonscorm.config.fn.complete     = doCompleteInsert;
	
	forServerFile = $.action("ajax");
	forServerFile.config.url = "<c:url value="/lcms/organization/serverfile.do"/>";
	forServerFile.config.type = "json";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {

	// 공통 1단계
	forStep1.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠구분"/>",
		name : "contentsTypeCd",
		data : ["!null"]
	});
	
	
	// 표준 2단계
	forStep2scorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:가로"/>)",
		name : "width",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forStep2scorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:세로"/>)",
		name : "height",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forStep2scorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠소유자"/>",
		name : "memberSeq",
		data : ["!null"]
	});
	forStep2scorm.validator.set({
		title : "<spring:message code="글:콘텐츠:서버파일"/>",
		name : "filename",
		data : ["!null"],
		when : function() { // fileType이 server 일때 filename is not null
			var form = UT.getById(forStep2scorm.config.formId);
			var fileType = UT.getCheckedValue(forStep2scorm.config.formId, "fileType", "");
			if (fileType == "server") {
				return true;
			}
			return false;
		}
	});
	forStep2scorm.validator.set(function() {
		var form = UT.getById(forStep2scorm.config.formId);
		var fileType = UT.getCheckedValue(forStep2scorm.config.formId, "fileType", "");
		if (fileType == "local" && UI.uploader.isAppendedFiles(swfu, "uploader1") == false) {
			$.alert({
				message : "<spring:message code="글:콘텐츠:파일을선택하십시오"/>"
			});
			return false;
		} else {
			return true;
		}
	});
	
	// 비표준 2단계
	forStep2nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:가로"/>)",
		name : "width",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forStep2nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:세로"/>)",
		name : "height",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forStep2nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠소유자"/>",
		name : "memberSeq",
		data : ["!null"]
	});
	forStep2nonscorm.validator.set({
		title : "<spring:message code="글:콘텐츠:서버파일"/>",
		name : "filename",
		data : ["!null"],
		when : function() { // fileType이 server 일때 filename is not null
			var form = UT.getById(forStep2nonscorm.config.formId);
			var fileType = UT.getCheckedValue(forStep2nonscorm.config.formId, "fileType", "");
			if (fileType == "server") {
				return true;
			}
			return false;
		}
	});
	forStep2nonscorm.validator.set(function() {
		var form = UT.getById(forStep2nonscorm.config.formId);
		var fileType = UT.getCheckedValue(forStep2nonscorm.config.formId, "fileType", "");
		if (fileType == "local" && UI.uploader.isAppendedFiles(swfu, "uploader2") == false) {
			$.alert({
				message : "<spring:message code="글:콘텐츠:파일을선택하십시오"/>"
			});
			return false;
		} else {
			return true;
		}
	});

	// 링크 2단계
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:주차제목"/>",
		name : "title",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:교시제목"/>",
		name : "itemTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습완료기준"/>",
		name : "completionThreshold",
		data : ["!null", "number"],
		check : {
			maxlength : 20,
			ge : 1
		}
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:가로"/>)",
		name : "width",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠크기"/>(<spring:message code="필드:콘텐츠:세로"/>)",
		name : "height",
		data : ["number"],
		check : {
			maxlength : 4
		}
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:콘텐츠소유자"/>",
		name : "memberSeq",
		data : ["!null"]
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:링크정보"/>",
		name : "linkType",
		data : ["!null"]
	});
	forStep2link.validator.set({
		title : "<spring:message code="필드:콘텐츠:링크정보"/>",
		name : "link",
		data : ["!null"]
	});

	// 비표준 3단계
	forStep3nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:주차제목"/>",
		name : "title",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forStep3nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:교시제목"/>",
		name : "itemTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forStep3nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습완료기준"/>",
		name : "completionThreshold",
		data : ["number"],
		check : {
			maxlength : 20,
			ge : 1
		}
	});
	forStep3nonscorm.validator.set({
		title : "<spring:message code="필드:콘텐츠:시작파일"/>",
		name : "startFile",
		data : ["!null"],
		notExistIsNull : true
	});

};
/**
 * 등록완료
 */
doCompleteInsert = function(result) {
	if (result == "1") {
		jQuery.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doClose();
				}
			}
		});
	} else {
		jQuery.alert({
			message : "<spring:message code="글:콘텐츠:데이터형식이정확하지않아오류가발생하였습니다"/>",
			button1 : {
				callback : function() {
					doClose();
				}
			}
		});
	}
};
/**
 * 파일업로드 시작
 */
doStartUploadScorm = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader1") == true) {
		UI.uploader.runUpload(swfu, "uploader1");
		return false;
	} else {
		return true;
	}
};
/**
 * 파일업로드 시작
 */
doStartUploadNonscorm = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader2") == true) {
		UI.uploader.runUpload(swfu, "uploader2");
		return false;
	} else {
		return true;
	}
};
/**
 * 닫기
 */
doClose = function() {
	$layer.dialog("option").parent.doRefresh();
	$layer.dialog("close");
};
/**
 * 1단계 실행
 */
doStep1 = function() {
	forStep1.run();
	var contentsType = UT.getCheckedValue(forStep1.config.formId, "contentsTypeCd", "");
	var formId = "";
	if (contentsType == CD_CONTENTS_TYPE_LINK) {
		formId = forStep2link.config.formId;
		UT.copyValueFormToForm(forStep1.config.formId, formId);
	} else if (contentsType == CD_CONTENTS_TYPE_BROWSE) {
		formId = forStep2browse.config.formId;
		UT.copyValueFormToForm(forStep1.config.formId, formId);
		doStep2browse();
	} else if (contentsType == CD_CONTENTS_TYPE_SCORM) {
		formId = forStep2scorm.config.formId;
		UT.copyValueFormToForm(forStep1.config.formId, formId);
	} else {
		formId = forStep2nonscorm.config.formId;
		UT.copyValueFormToForm(forStep1.config.formId, formId);
	}

	UI.inputComment(formId, "auto-comment");
	
	doAutoComplete(formId);
	
};
/**
 * 2단계(scorm) 실행
 */
doStep2scorm = function() {
	forStep2scorm.run();
};
/**
 * 2단계(scorm) 실행
 */
doStep2nonscorm = function() {
	var form = UT.getById(forStep2nonscorm.config.formId);
	var contentsType = form.elements["contentsTypeCd"].value;
	if (contentsType == CD_CONTENTS_TYPE_MOVIE) {
		jQuery("#completionType").hide();
		form.elements["indexHtml"].value = UT.getById("FormData").elements["movieIndexHtml"].value;
	} else if (contentsType == CD_CONTENTS_TYPE_FLASH) {
		jQuery("#completionType").hide();
		form.elements["indexHtml"].value = UT.getById("FormData").elements["flashIndexHtml"].value;
	} else {
		form.elements["indexHtml"].value = "";
	}
	forStep2nonscorm.run();
};
/**
 * 2단계(link) 실행
 */
doStep2link = function() {
	var form = UT.getById(forStep2link.config.formId);
	var linkType = UT.getCheckedValue(forStep2link.config.formId, "linkType", "");
	if (linkType == "url") {
		form.elements["indexHtml"].value = UT.getById("FormData").elements["linkUrlIndexHtml"].value;
	} else {
		form.elements["indexHtml"].value = UT.getById("FormData").elements["linkTagIndexHtml"].value;
	}
	forStep2link.run();
	UT.copyValueFormToForm(forStep2link.config.formId, forStep3link.config.formId);
};
/**
 * 3단계(link) 실행
 */
doStep3link = function() {
	forStep3link.run();
};
/**
 * 2단계(browse) 실행
 */
doStep2browse = function() {
	forStep2browse.run();
};
/**
 * 3단계(nonscorm) 실행
 */
doStep3nonscorm = function() { 
	forStep3nonscorm.run();
	UT.copyValueFormToForm(forStep3nonscorm.config.formId, forStep4nonscorm.config.formId);
};
/**
 * 4단계(nonscorm) 실행
 */
doStep4nonscorm = function() { 
	forStep4nonscorm.run();
};
/**
 * 단계(화면)이동
 */
doNext = function(step) {
	var $step = null;
	switch(step) {
	case 1:
		$step = jQuery("#step1");
		break;
	case 2:
		var contentsType = UT.getCheckedValue(forStep1.config.formId, "contentsTypeCd", "");
		if (contentsType == CD_CONTENTS_TYPE_BROWSE) {
			$step = jQuery("#step" + step + "-browse");
		} else if (contentsType == CD_CONTENTS_TYPE_LINK) {
			$step = jQuery("#step" + step + "-link");
		} else if (contentsType == CD_CONTENTS_TYPE_SCORM) {
			$step = jQuery("#step" + step + "-scorm");
		} else {
			$step = jQuery("#step" + step + "-nonscorm");
		}
		break;
	case 3:
		var contentsType = UT.getCheckedValue(forStep1.config.formId, "contentsTypeCd", "");
		if (contentsType == CD_CONTENTS_TYPE_LINK) {
			$step = jQuery("#step" + step + "-link");
		} else {
			$step = jQuery("#step" + step + "-nonscorm");
		}
		break;
	case 4:
		$step = jQuery("#step" + step + "-nonscorm");
		break;
	}
	$step.siblings().each(function() {
		$(this).hide();
	});
	$step.show();
};
/**
 * 파일 선택 
 */
doFileType = function(filetype, contents) {
	var $fileType = jQuery("#fileType-" + filetype.value + "-" + contents);
	$fileType.siblings().each(function() {
		$(this).hide();
	});
	$fileType.show();

	// 파일업로더 초기화
	UI.uploader.cancelUpload(swfu, "uploader1");
	UI.uploader.cancelUpload(swfu, "uploader2");
	
	// 서버파일목록 초기화
	jQuery("#fileType-server-" + contents).html("");
	
	if (filetype.value == "server") {
		doGetServerFile(contents);
	} 
};
/**
 * 서버파일목록 가져오기
 */
doGetServerFile = function(contents, dir) {
	forServerFile.config.fn.complete = function(action, data) {
		var $files = jQuery("#fileType-server-" + contents);
		var html = [];
		html.push("<ul class='filelist'>");
		if (typeof dir === "string") {
			var dirs = dir.split("/");
			dirs.pop();
			html.push("<li class='folder' onclick='doGetServerFile(\"" + contents+ "\"");
			if (dirs.length > 0) {
				html.push(",\"" + dirs.join("/") + "\"");
			}
			html.push(")'>..</li>");
		}
		if (data != null && data.dirs != null) {
			for (var i = 0; i < data.dirs.length; i++) {
				var matched = false;
				if (typeof dir === "string") {
					matched = true;
				} else {
					if (accessFtpDirs != null && accessFtpDirs.length > 0) {
						for (var j = 0; j < accessFtpDirs.length; j++) {
							if (accessFtpDirs[j] == data.dirs[i].saveName) {
								matched = true;
							}
						}
					}
				}
				if (matched == true) {
					html.push("<li class='folder' onclick='doGetServerFile(\"" + contents+ "\"");
					html.push(typeof dir === "string" ? ",\"" + dir + "/" + data.dirs[i].saveName + "\"" : ",\"" + data.dirs[i].saveName + "\"");
					html.push(")'>" + data.dirs[i].saveName + "</li>");
				}
			}
		}
		if (data != null && data.files != null) {
			for (var i = 0; i < data.files.length; i++) {
				html.push("<li onclick='doHighlight(this)'><input type='radio' name='filename' value='");
				if (typeof dir === "string") {
					html.push(dir + "/");
				}
				html.push(data.files[i].saveName + "'> <label>" + data.files[i].saveName + "</label></li>");
			}
		}
		html.push("</ul>");
		$files.html(html.join(""));
	};
	if (typeof dir === "string") {
		forServerFile.config.parameters = "dir=" + dir;
	} else {
		forServerFile.config.parameters = "";
	}
	forServerFile.run();
};
/**
 * 파일 선택하기
 */
doHighlight = function(element) {
	var $element = jQuery(element);
	$element.addClass("highlight");
	$element.siblings().each(function() {
		$(this).removeClass("highlight");
	});
	$element.find("input").attr("checked", "true");
};
/**
 * 기존 등록되어있는 콘텐츠 추가
 */
doAppendOrg = function() {
	var action = $.action("submit", {formId : "FormSubData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	action.config.url             = "<c:url value="/lcms/contents/organization/insertlist.do"/>";
	action.config.target          = "hiddenframe";
	action.config.message.confirm = "<spring:message code="글:추가하시겠습니까"/>"; 
	action.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	action.config.fn.complete     = function(success) {
		$.alert({
			message : "<spring:message code="글:X건의데이터가추가되었습니다"/>".format({0:success}),
			button1 : {
				callback : function() {
					doSubList();
				}
			}
		});
	};
	action.validator.set({
		title : "<spring:message code="필드:추가할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	action.run();
};
/**
 * 검색된 데이타가 없을 때 ajax에서 호출됨.
 */
doAppendOrgButton = function(show) {
	if (show == true) {
		jQuery("#appendButton").show();
	} else {
		jQuery("#appendButton").hide();
	}
};
/**
 * 링크콘텐츠 라디오 버튼 변경시 호출됨
 */
doChangeLink = function(type) {
	var linkForm = UT.getById(forStep2link.config.formId); 
	if (type.value == 'url') {
		jQuery(linkForm.elements["width"]).attr("disabled",false);
		jQuery(linkForm.elements["height"]).attr("disabled",false);
		jQuery("#helpUrl").show();
		jQuery("#helpTag").hide();
	} else {
		jQuery(linkForm.elements["width"]).attr("disabled",true);
		jQuery(linkForm.elements["height"]).attr("disabled",true);
		jQuery("#helpTag").show();
		jQuery("#helpUrl").hide();
	}
};
/**
 * 자동완성
 */
doAutoComplete = function(formId) {
	var form = UT.getById(formId);
	UI.autoCompleteByEnter(form.elements["memberName"], function(response, value) { // source callback
		var param = [];
		param.push("srchWord=" + value);

		var action = $.action("ajax");
		action.config.type        = "json";
		action.config.url         = "<c:url value="/member/prof/like/name/list/json.do"/>";
		action.config.parameters  = param.join("&");
		action.config.fn.complete = function(action, data) {
			if (data != null && data.list != null) {
				var items = [];
				for (var i = 0, len = data.list.length; i < len; i++) {
					var member = data.list[i];
					var label = member.memberName;
					label += (member.profTypeCd != "" ? " - " + profTypeCd[member.profTypeCd] : "");
					label += (member.categoryName != "" ? " - " + categoryName : "");
					items.push({
						"name" : member.memberName,
						"label" : label,
						"value" : member.memberSeq
					});
				}
				response(items);
			}
		};
		action.run();
	}, function(item) { // select callback
		if (item == null) {
			form.elements["memberName"].value = "";
			form.elements["memberSeq"].value = "";
		} else {
			form.elements["memberName"].value = item.name;
			form.elements["memberSeq"].value = item.value;
		}
	});		
};

var oldCompletionThreshold = "";
/**
 * 학습완료기준 진도체크 구분 변경시
 */
doChangeCompletionType = function(val, type){
	
	var type_id = "";
	if(type == 'link'){
		type_id = "_link";
	};
	
	if(val.value == CD_COMPLETION_TYPE_TIME){
		jQuery("#completionThreshold" + type_id).val(oldCompletionThreshold);
		jQuery("#second_text_id" + type_id).show();
		jQuery("#second_text2_id" + type_id).hide();
	}else{
		oldCompletionThreshold = jQuery("#completionThreshold").val();
		jQuery("#completionThreshold" + type_id).val("100");
		jQuery("#second_text_id" + type_id).hide();
		jQuery("#second_text2_id" + type_id).show();
	}
};

doCompletionThresholdCheck = function(type){
	
	var type_id = "";
	if(type == 'link'){
		type_id = "_link";
	};
	
	if(jQuery("#completionType" + type_id).val() == CD_COMPLETION_TYPE_PROGRESS){
		if(jQuery("#completionThreshold" + type_id).val() > 100){
			$.alert({
				message : "<spring:message code="글:콘텐츠:진도율은100%이하로등록가능합니다"/>"
			});
			jQuery("#completionThreshold" + type_id).val("100");
		};
	};
};

</script>
<style>
.highlight {border:solid 1px #000000; background-color:#b1cff5;}
.filelist {line-height:20px;}
.folder {padding-left:18px; line-height:20px; cursor:pointer; background: url(<aof:img type="print" src="icon/folder.gif"/>) no-repeat; background-position:center left; }
</style>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<div>
		<div id="step1">
			
			<h3 class="content-title">
				<c:if test="${empty detail.organizationSeq}">
					<spring:message code="글:콘텐츠:1단계"/> - <spring:message code="글:콘텐츠:주차콘텐츠구분선택"/>
				</c:if>
				<c:if test="${!empty detail.organizationSeq}">
					<spring:message code="글:콘텐츠:1단계"/> - <spring:message code="글:콘텐츠:교시콘텐츠구분선택"/>
				</c:if>
			</h3>
	
			<form id="FormStep1" name="FormStep1" method="post" onsubmit="return false;">			
			<input type="hidden" name="contentsSeq"     value="<c:out value="${detail.contentsSeq}"/>"/>
			<input type="hidden" name="organizationSeq" value="<c:out value="${detail.organizationSeq}"/>"/>
			
			<aof:code type="set" var="contentsType" codeGroup="CONTENTS_TYPE" />
			<div class="lybox-title">
				<h4 class="section-title"><spring:message code="글:콘텐츠:표준"/></h4>
			</div>
			<table class="tbl-detail">
			<colgroup>
				<col style="width: 120px" />
				<col/>
				<col style="width: 30px" />
			</colgroup>
			<tbody>
				<c:forEach var="row" items="${contentsType}" varStatus="i">
					<c:if test="${i.first}">
						<tr>
							<td colspan="2" style="height:30px;"><c:out value="${row.description}"/></td>
							<td>
								<input type="radio" name="contentsTypeCd" value="<c:out value="${row.code}"/>" checked="checked"
									<c:if test="${!empty detail.contentsTypeCd and detail.contentsTypeCd ne row.code}">
										disabled="disabled"
									</c:if>
								>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
			</table>

			<div class="vspace"></div>
			<div class="lybox-title">
				<h4 class="section-title"><spring:message code="글:콘텐츠:비표준"/></h4>
			</div>
			<table class="tbl-detail">
			<colgroup>
				<col style="width: 130px;" />
				<col/>
				<col style="width: 30px" />
			</colgroup>
			<tbody>
				<c:forEach var="row" items="${contentsType}" varStatus="i">
					<c:if test="${i.first ne true and row.code ne CD_CONTENTS_TYPE_BROWSE}">
						<tr>
							<th style="height:35px;"><c:out value="${row.codeName}"/></th>
							<td><c:out value="${row.description}"/></td>
							<td>
								<input type="radio" name="contentsTypeCd" value="<c:out value="${row.code}"/>"
									<c:if test="${!empty detail.contentsTypeCd}">
										<c:choose> 
											<c:when test="${detail.contentsTypeCd eq row.code}">checked</c:when>
											<c:otherwise>disabled="disabled"</c:otherwise>
										</c:choose>
									</c:if>
								>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
			</table>
			
			<c:if test="${!empty detail.contentsSeq and empty detail.contentsTypeCd}">

				<div class="vspace"></div>
				<div class="lybox-title">
					<h4 class="section-title"><spring:message code="글:콘텐츠:검색"/></h4>
				</div>
				<table class="tbl-detail">
				<col style="width: 120px" />
				<col/>
				<col style="width: 30px" />
				<tbody>
						<tr>
							<td colspan="2" style="height:30px;"><spring:message code="글:콘텐츠:주차관리에서등록한데이터를검색하여추가하기"/></td>
							<td><input type="radio" name="contentsTypeCd" value="<c:out value="${CD_CONTENTS_TYPE_BROWSE}"/>"></td>
						</tr>
				</tbody>
				</table>
			</c:if>
			
			</form>
			
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-r">
							<a href="#" onclick="doStep1();" class="btn blue"><span class="mid"><spring:message code="버튼:다음"/></span></a>
					</div>
				</div>
			</c:if>
			
		</div>
			
<%-- 표준 --%>
		<div id="step2-scorm" style="display:none">
			
			<h3 class="content-title">
				<spring:message code="글:콘텐츠:2단계"/> - <spring:message code="글:콘텐츠:파일선택"/>
			</h3>
			
			<form id="FormStep2scorm" name="FormStep2scorm" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq"/>
			<input type="hidden" name="organizationSeq"/>
			<input type="hidden" name="contentsTypeCd"/>
			<textarea name="indexHtml" style="display:none;"></textarea>
			<input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
			
			<table class="tbl-detail">
			<colgroup>
				<col style="width: 100px" />
				<col/>
			</colgroup>
			<tbody>
				<c:if test="${empty detail.organizationSeq}">
					<tr>
						<th><spring:message code="필드:콘텐츠:콘텐츠크기"/></th>
						<td>
							<spring:message code="필드:콘텐츠:가로"/>
							<input type="text" name="width" value="<aof:code type="print" codeGroup="CONTENTS_SIZE" selected="${CD_CONTENTS_SIZE_WIDTH}"/>" 
								class="align-c" style="width:50px;"/> px &nbsp;&nbsp;
							<spring:message code="필드:콘텐츠:세로"/>
							<input type="text" name="height" value="<aof:code type="print" codeGroup="CONTENTS_SIZE" selected="${CD_CONTENTS_SIZE_HEIGHT}"/>"
								class="align-c" style="width:50px;"/> px
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
						<td>
							<input type="hidden" name="memberSeq">
							<input type="text" name="memberName" style="width: 250px;">
							<div class="auto-comment"><spring:message code="글:콘텐츠:이름을입력후Enter키를누르십시오"/></div>
						</td>
					</tr>
				</c:if>
				<tr>
					<th rowspan="2"><spring:message code="필드:콘텐츠:파일구분"/></th>
					<td>
						<input type="radio" name="fileType" value="local" onclick="doFileType(this,'scorm')" checked="checked"> <label><spring:message code="글:콘텐츠:업로드"/></label>
						<input type="radio" name="fileType" value="server" onclick="doFileType(this,'scorm')"> <label><spring:message code="글:콘텐츠:서버파일"/></label>
					</td>
				</tr>
				<tr>
					<td>
						<div id="fileType-local-scorm">
							<input type="hidden" name="filepath">
							<div id="uploader1" class="uploader"></div>
						</div>
						<div id="fileType-server-scorm" class="scroll-y" style="display:none; height:280px;"></div>
					</td>
				</tr>
			</tbody>
			</table>
			</form>
	
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<a href="#" onclick="doNext(1);" class="btn blue"><span class="mid"><spring:message code="버튼:이전"/></span></a>
					</div>
					<div class="lybox-btn-r">
						<a href="#" onclick="doStep2scorm();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</div>
				</div>
			</c:if>
		</div>
<%-- // 표준 --%>

<%-- 비표준(일반, 동영상, 플레시) --%>
		<div id="step2-nonscorm" style="display:none">
			
			<h3 class="content-title">
				<spring:message code="글:콘텐츠:2단계"/> - <spring:message code="글:콘텐츠:파일선택"/>
			</h3>
			
			<form id="FormStep2nonscorm" name="FormStep2nonscorm" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq"/>
			<input type="hidden" name="organizationSeq"/>
			<input type="hidden" name="contentsTypeCd"/>
			<textarea name="indexHtml" style="display:none;"></textarea>
            <input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
            
			<table class="tbl-detail">
			<colgroup>
				<col style="width: 100px" />
				<col/>
			</colgroup>
			<tbody>
				<c:if test="${empty detail.organizationSeq}">
					<tr>
						<th><spring:message code="필드:콘텐츠:콘텐츠크기"/></th>
						<td>
							<spring:message code="필드:콘텐츠:가로"/>
							<input type="text" name="width" value="<aof:code type="print" codeGroup="CONTENTS_SIZE" selected="${CD_CONTENTS_SIZE_WIDTH}"/>" 
								class="align-c" style="width:50px;"/> px &nbsp;&nbsp;
							<spring:message code="필드:콘텐츠:세로"/>
							<input type="text" name="height" value="<aof:code type="print" codeGroup="CONTENTS_SIZE" selected="${CD_CONTENTS_SIZE_HEIGHT}"/>"
								class="align-c" style="width:50px;"/> px
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
						<td>
							<input type="hidden" name="memberSeq">
							<input type="text" name="memberName" style="width: 250px;">
							<div class="auto-comment"><spring:message code="글:콘텐츠:이름을입력후Enter키를누르십시오"/></div>
						</td>
					</tr>
				</c:if>
				<tr>
					<th rowspan="2"><spring:message code="필드:콘텐츠:파일구분"/></th>
					<td>
						<input type="radio" name="fileType" value="local" onclick="doFileType(this,'nonscorm')" checked="checked"> <label><spring:message code="글:콘텐츠:업로드"/></label>
						<input type="radio" name="fileType" value="server" onclick="doFileType(this,'nonscorm')"> <label><spring:message code="글:콘텐츠:서버파일"/></label>
						<a href="javascript:void(0)" onclick="doGetServerFile('nonscorm')" id="refreshServerFile-nonscorm" style="display:none"><spring:message code="버튼:새로고침"/></a>
					</td>
				</tr>
				<tr>
					<td>
						<div id="fileType-local-nonscorm">
							<input type="hidden" name="filepath">
							<div id="uploader2" class="uploader"></div>
						</div>
						<div id="fileType-server-nonscorm" class="scroll-y" style="display:none;height:280px;"></div>
					</td>
				</tr>
			</tbody>
			</table>
			</form>
	
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<a href="#" onclick="doNext(1);" class="btn blue"><span class="mid"><spring:message code="버튼:이전"/></span></a>
					</div>
					<div class="lybox-btn-r">
						<a href="#" onclick="doStep2nonscorm();" class="btn blue"><span class="mid"><spring:message code="버튼:다음"/></span></a>
					</div>
				</div>
			</c:if>
		</div>
		
		<div id="step3-nonscorm" style="display:none">

			<h3 class="content-title">
				<c:if test="${empty detail.organizationSeq}">
					<spring:message code="글:콘텐츠:3단계"/> - <spring:message code="글:콘텐츠:주차정보입력"/>
				</c:if>
				<c:if test="${!empty detail.organizationSeq}">
					<spring:message code="글:콘텐츠:3단계"/> - <spring:message code="글:콘텐츠:교시정보입력"/>
				</c:if>
			</h3>

			<form id="FormStep3nonscorm" name="FormStep3nonscorm" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq"/>
			<input type="hidden" name="organizationSeq"/>
			<input type="hidden" name="contentsTypeCd"/>
			<input type="hidden" name="filepath"/>
			<input type="hidden" name="indexHtml"/>
			<input type="hidden" name="width"/>
			<input type="hidden" name="height"/>
			<input type="hidden" name="memberSeq"/>
            <input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
            
			<table class="tbl-detail">
			<colgroup>
				<col style="width: 100px" />
				<col/>
			</colgroup>
			<tbody>
				<c:if test="${empty detail.organizationSeq}">
					<tr>
						<th><spring:message code="필드:콘텐츠:주차제목"/></th>
						<td><input type="text" name="title" style="width:90%;"></td>
					</tr>
				</c:if>
				<tr>
					<th><spring:message code="필드:콘텐츠:교시제목"/></th>
					<td><input type="text" name="itemTitle" style="width:90%;"></td>
				</tr>
				<tr>
					<th><spring:message code="필드:콘텐츠:학습완료기준"/></th>
					<td>
						<select id="completionType" name="completionType" onchange="doChangeCompletionType(this);">
							<aof:code type="option" codeGroup="COMPLETION_TYPE" selected="${row.item.completionType}"/>
						</select>
						<input type="text" id="completionThreshold" name="completionThreshold" class="align-c" style="width:50px;" onkeyup="doCompletionThresholdCheck()"> 
						<span id="second_text_id"><spring:message code="글:콘텐츠:초"/></span>
						<span id="second_text2_id" style="display: none;">%</span>
					</td>
				</tr>
				<tr>
					<th><spring:message code="필드:콘텐츠:시작파일"/></th>
					<td style="*position:relative;">
						<div id="startfile-server" class="scroll-y" style="display:none; height:250px;"></div>
					</td>
				</tr>
			</tbody>
			</table>
			</form>
			
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<a href="javascript:void(0)" onclick="doNext(2);" class="btn blue"><span class="mid"><spring:message code="버튼:이전"/></span></a>
					</div>
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doStep3nonscorm();" class="btn blue"><span class="mid"><spring:message code="버튼:다음"/></span></a>
					</div>
				</div>
			</c:if>
			
		</div>
		
		<div id="step4-nonscorm" style="display:none">

			<h3 class="content-title">
				<spring:message code="글:콘텐츠:4단계"/> - <spring:message code="글:콘텐츠:메타데이터등록"/>
			</h3>

			<form id="FormStep4nonscorm" name="FormStep4nonscorm" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq"/>
			<input type="hidden" name="organizationSeq"/>
			<input type="hidden" name="contentsTypeCd"/>
			<input type="hidden" name="filepath"/>
			<input type="hidden" name="indexHtml"/>
			<input type="hidden" name="width"/>
			<input type="hidden" name="height"/>
			<input type="hidden" name="memberSeq"/>
			<input type="hidden" name="title"/>
			<input type="hidden" name="itemTitle"/>
			<input type="hidden" name="completionThreshold"/>
			<input type="hidden" name="completionType"/>
			<input type="hidden" name="startFile"/>
            <input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
            
			<table class="tbl-detail">
			<colgroup>
				<col style="width:50px" />
				<col style="width:150px" />
				<col/>
			</colgroup>
			<thead>
				<tr>
					<th class="align-c"><spring:message code="필드:번호"/></th>
					<th class="align-c"><spring:message code="필드:콘텐츠:데이터주제"/></th>
					<th class="align-c"><spring:message code="필드:콘텐츠:데이터값"/></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="row" items="${listMetadataElement}" varStatus="i">
					<tr>
						<td class="align-c"><c:out value="${i.count}"/></td>
						<td class="align-c"><c:out value="${row.metadataElement.metadataName}"/></td>
						<td class="align-c">
							<input type="hidden" name="metadataElementSeqs" value="<c:out value="${row.metadataElement.metadataElementSeq}"/>">
							<input type="hidden" name="metadataPaths" value="<c:out value="${row.metadataElement.metadataPath}"/>">
							<input type="text" name="metadataValues" style="width:90%">
						</td>
					</tr>
				</c:forEach>
			</tbody>
			</table>
			</form>
			
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doStep4nonscorm();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</div>
				</div>
			</c:if>
			
		</div>	
<%-- // 비표준(일반, 동영상, 플레시) --%>	
	
	
<%-- 비표준(링크) --%>
		<div id="step2-link" style="display:none">

			<h3 class="content-title">
				<spring:message code="글:콘텐츠:2단계"/> - <spring:message code="글:콘텐츠:정보입력"/>
			</h3>

			<form id="FormStep2link" name="FormStep2link" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq" value="<c:out value="${detail.contentsSeq}"/>"/>
			<input type="hidden" name="organizationSeq" value="<c:out value="${detail.organizationSeq}"/>"/>
			<input type="hidden" name="contentsTypeCd"/>
			<textarea name="indexHtml" style="display:none;"></textarea>
			<input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>

			<table class="tbl-detail">
			<colgroup>
				<col style="width: 100px" />
				<col/>
			</colgroup>
			<tbody>
				<c:if test="${empty detail.organizationSeq}">
					<tr>
						<th><spring:message code="필드:콘텐츠:주차제목"/></th>
						<td><input type="text" name="title" style="width:90%;"></td>
					</tr>
				</c:if>
				<c:if test="${!empty detail.organizationSeq}">
					<input type="hidden" name="title" value="${detail.title}">
				</c:if>
				<tr>
					<th><spring:message code="필드:콘텐츠:교시제목"/></th>
					<td><input type="text" name="itemTitle" style="width:90%;"></td>
				</tr>
				<tr>
					<th><spring:message code="필드:콘텐츠:학습완료기준"/></th>
					<td>
						<select id="completionType_link"  name="completionType" onchange="doChangeCompletionType(this, 'link');">
							<aof:code type="option" codeGroup="COMPLETION_TYPE" selected="${row.item.completionType}"/>
						</select>
						<input type="text" id="completionThreshold_link" name="completionThreshold" class="align-c" style="width:50px;" onkeyup="doCompletionThresholdCheck('link')"> 
						<span id="second_text_id_link"><spring:message code="글:콘텐츠:초"/></span>
						<span id="second_text2_id_link" style="display: none;">%</span>
					</td>
				</tr>
				<c:if test="${empty detail.organizationSeq}">
					<tr>
						<th><spring:message code="필드:콘텐츠:콘텐츠크기"/></th>
						<td>
							<spring:message code="필드:콘텐츠:가로"/>
							<input type="text" name="width" value="<aof:code type="print" codeGroup="CONTENTS_SIZE" selected="${CD_CONTENTS_SIZE_WIDTH}"/>" 
								class="align-c" style="width:50px;"/> px &nbsp;&nbsp;
							<spring:message code="필드:콘텐츠:세로"/>
							<input type="text" name="height" value="<aof:code type="print" codeGroup="CONTENTS_SIZE" selected="${CD_CONTENTS_SIZE_HEIGHT}"/>"
								class="align-c" style="width:50px;"/> px
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:콘텐츠:콘텐츠소유자"/></th>
						<td>
							<input type="hidden" name="memberSeq">
							<input type="text" name="memberName" style="width: 250px;">
							<div class="auto-comment"><spring:message code="글:콘텐츠:이름을입력후Enter키를누르십시오"/></div>
						</td>
					</tr>
				</c:if>
				<tr>
					<th><spring:message code="필드:콘텐츠:링크정보"/></th>
					<td>
						<input type="radio" name="linkType" value="url" checked="checked" onclick="doChangeLink(this)"/> <label><spring:message code="글:콘텐츠:동영상URL"/></label>
						<input type="radio" name="linkType" value="tag" onclick="doChangeLink(this)"/> <label><spring:message code="글:콘텐츠:TAG"/></label>
						<textarea name="link" style="width:90%;height:40px;"></textarea>
						<div class="comment" id="helpUrl"><spring:message code="글:콘텐츠:동영상URL도움말"/></div>
						<div class="comment" id="helpTag" style="display:none;"><spring:message code="글:콘텐츠:TAG도움말"/></div>
					</td>
				</tr>
			</tbody>
			</table>
			</form>
	
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<a href="javascript:void(0)" onclick="doNext(1);" class="btn blue"><span class="mid"><spring:message code="버튼:이전"/></span></a>
					</div>
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doStep2link();" class="btn blue"><span class="mid"><spring:message code="버튼:다음"/></span></a>
					</div>
				</div>
			</c:if>
	
		</div>
		
		<div id="step3-link" style="display:none">

			<h3 class="content-title">
				<spring:message code="글:콘텐츠:3단계"/> - <spring:message code="글:콘텐츠:메타데이터등록"/>
			</h3>

			<form id="FormStep3link" name="FormStep3link" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq"/>
			<input type="hidden" name="organizationSeq"/>
			<input type="hidden" name="contentsTypeCd"/>
			<input type="hidden" name="indexHtml"/>
			<input type="hidden" name="title"/>
			<input type="hidden" name="itemTitle"/>
			<input type="hidden" name="completionThreshold"/>
			<input type="hidden" name="completionType"/>
			<input type="hidden" name="width"/>
			<input type="hidden" name="height"/>
			<input type="hidden" name="memberSeq"/>
			<input type="hidden" name="linkType"/>
			<input type="hidden" name="link"/>
			<input type="hidden" name="aofNote" value="<c:out value="${aoffn:encryptSecure(ssMemberSeq, pageContext.request)}"/>"/>
			
			<table class="tbl-detail">
			<colgroup>
				<col style="width:50px" />
				<col style="width:150px" />
				<col/>
			</colgroup>
			<thead>
				<tr>
					<th class="align-c"><spring:message code="필드:번호"/></th>
					<th class="align-c"><spring:message code="필드:콘텐츠:데이터주제"/></th>
					<th class="align-c"><spring:message code="필드:콘텐츠:데이터값"/></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="row" items="${listMetadataElement}" varStatus="i">
					<tr>
						<td class="align-c"><c:out value="${i.count}"/></td>
						<td class="align-c"><c:out value="${row.metadataElement.metadataName}"/></td>
						<td class="align-c">
							<input type="hidden" name="metadataElementSeqs" value="<c:out value="${row.metadataElement.metadataElementSeq}"/>">
							<input type="hidden" name="metadataPaths" value="<c:out value="${row.metadataElement.metadataPath}"/>">
							<input type="text" name="metadataValues" style="width:90%">
						</td>
					</tr>
				</c:forEach>
			</tbody>
			</table>
			</form>
			
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doStep3link();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
					</div>
				</div>
			</c:if>
			
		</div>		
<%--// 비표준(링크) --%>

<%-- 차시검색 --%>	
		<div id="step2-browse" style="display:none">
	
			<h3 class="content-title">
				<spring:message code="글:콘텐츠:2단계"/> - <spring:message code="글:콘텐츠:주차검색"/>
			</h3>
	
			<form id="FormStep2browse" name="FormStep2browse" method="post" onsubmit="return false;">
			<input type="hidden" name="contentsSeq" value="<c:out value="${detail.contentsSeq}"/>"/>
			<input type="hidden" name="srchNotInContentsSeq" value="<c:out value="${detail.contentsSeq}"/>"/>
			<input type="hidden" name="organizationSeq" value="<c:out value="${detail.organizationSeq}"/>"/>
			</form>
						
			<div id="browseOrgData"></div>
	
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<a href="javascript:void(0)" onclick="doNext(1);" class="btn blue"><span class="mid"><spring:message code="버튼:이전"/></span></a>
					</div>
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doAppendOrg();" class="btn blue" id="appendButton"><span class="mid"><spring:message code="버튼:추가"/></span></a>
					</div>
				</div>
			</c:if>
		</div>
<%-- // 차시검색 --%>
	</div>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<textarea name="movieIndexHtml" style="display:none;">
&lt;html>
&lt;head>
&lt;script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/jquery/jquery-1.7.2.min.js"></script>
&lt;script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/lib/jquery.aos.player.min.js"></script>
&lt;link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/xcss/aos/player/aos.player.css" type="text/css" />
&lt;script type="text/javascript"> 
	jQuery(document).ready(function() {
		doStartNonScormPlayer("##REPLACE##");
	});
&lt;/script>
&lt;style>
body {margin:0px}
&lt;/style>
&lt;/head>
&lt;body>
&lt;/body>
&lt;/html>
		</textarea>
		<textarea name="flashIndexHtml" style="display:none;">
&lt;html>
&lt;head>
&lt;script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/jquery/jquery-1.7.2.min.js"></script>
&lt;script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/lib/jquery.aos.player.min.js"></script>
&lt;link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/xcss/aos/player/aos.player.css" type="text/css" />
&lt;script type="text/javascript"> 
	jQuery(document).ready(function() {
		doStartNonScormPlayerFlash("##REPLACE##");
	});
&lt;/script>
&lt;style>
body {margin:0px}
&lt;/style>
&lt;/head>
&lt;body>
&lt;/body>
&lt;/html>
		</textarea>
		<textarea name="linkUrlIndexHtml" style="display:none;">
&lt;html>
&lt;head>
&lt;script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/jquery/jquery-1.7.2.min.js"></script>
&lt;script type="text/javascript" src="<c:out value="${aoffn:config('domain.web')}"/>/js/lib/jquery.aos.player.min.js"></script>
&lt;link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/css/aos/player/aos.player.css" type="text/css" />
&lt;script type="text/javascript"> 
	jQuery(document).ready(function() {
		doStartNonScormPlayer("##REPLACE##");
	});
&lt;/script>
&lt;style>
body {margin:0px}
&lt;/style>
&lt;/head>
&lt;body>
&lt;/body>
&lt;/html>
		</textarea>
		<textarea name="linkTagIndexHtml" style="display:none;">
&lt;html>
&lt;head>
&lt;style>
body {margin:0px}
&lt;/style>
&lt;/head>
&lt;body>
##REPLACE##
&lt;/body>
&lt;/html>
		</textarea>
	</form>

</body>
</html>