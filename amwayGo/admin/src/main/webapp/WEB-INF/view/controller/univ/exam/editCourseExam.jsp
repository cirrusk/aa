<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_EXAM_FILE_TYPE_IMAGE = "<c:out value="${CD_EXAM_FILE_TYPE_IMAGE}"/>";
var CD_EXAM_FILE_TYPE_VIDEO = "<c:out value="${CD_EXAM_FILE_TYPE_VIDEO}"/>";
var CD_EXAM_FILE_TYPE_AUDIO = "<c:out value="${CD_EXAM_FILE_TYPE_AUDIO}"/>";

var forUpdate   = null;
var forBrowseMaster = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. uploader
	swfu = UI.uploader.create(function() { // completeCallback
		forUpdate.run("continue");
	});	
	
	doChangeUploader();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/exam/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doStartUpload;
	forUpdate.config.fn.complete     = function() {
		$layer.dialog("close");
	};
	setValidate();

	forBrowseMaster = $.action("layer");
	forBrowseMaster.config.formId         = "FormBrowseCourse";
	forBrowseMaster.config.url            = "<c:url value="/univ/coursemaster/popup.do"/>";
	forBrowseMaster.config.options.width  = 700;
	forBrowseMaster.config.options.height = 500;
	forBrowseMaster.config.options.title  = "<spring:message code="필드:시험:교과목선택"/>";	
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		message : "<spring:message code="글:시험:교과목을선택하세요"/>",
		name : "courseMasterSeq",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:문항제목"/>",
		name : "examItemTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 1000
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:출제그룹"/>",
		name : "groupKey",
		data : ["!null","trim", "number"],
		check : {
			maxlength : 2
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:파일경로"/>",
		name : "filePath",
		data : ["!space"],
		check : {
			maxlength : 200
		}
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	forUpdate.run();
};
/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	if (UI.uploader.isAppendedFiles(swfu, "uploader-0") == true) {
		UI.uploader.runUpload(swfu);
		return false;
	} else {
		return true;
	}
};
/**
 * 파일업로드 완료 Callback
 */
doSuccessCallback = function(id, file) {
	var form = UT.getById(forUpdate.config.formId);
	var fileInfo = file.serverData.fileInfo;
	form.elements["filePath"].value = fileInfo.savePath + "/" + fileInfo.saveName;
};
/**
 * 파일삭제
 */
doDeleteFile = function(element) {
	var $file = jQuery(element).closest("div");
	$file.remove();
};
/**
 * 취소 : 레이어 닫기
 */
doCancel = function() {
	 $layer.dialog("close");
};
/**
 * 파일유형변경
 */
doChangeUploader = function(select) {
	var $select = null;
	if (typeof select === "object") {
		$select = jQuery(select);
	} else {
		$select = jQuery(".fileType");
	}
	$select.each(function() {
		var $this = jQuery(this);
		doChangeUploadType($this.siblings(".filePathType"));
	});
};
/**
 * 업로드유형변경 (업로드/파일경로)
 */
doChangeUploadType = function(select) {
	var $select = jQuery(select);
	var $uploader = $select.siblings(".uploader");
	var $fileType = $select.siblings(".fileType");
	var $filePath = $select.siblings(".filePath");

	var $oldFileType = $select.siblings(":input[name='oldFileType']");
	var $oldFilePathType = $select.siblings(":input[name='oldFilePathType']");
	var $oldFilePath = $select.siblings(":input[name='oldFilePath']");

	if ($select.val() == "upload") {
		var html = [];
		var value = "";
		if ($oldFilePathType.val() == "upload") {
			if ($oldFilePath.val() != "" && $fileType.val() == $oldFileType.val()) {
				if ($oldFileType.val() == CD_EXAM_FILE_TYPE_IMAGE) {
					html.push("<div onclick='doDeleteFile(this)' class='previousFile'>");
					html.push("<spring:message code="글:시험:이미지파일이업로드되어있습니다"/>");
					html.push("</div>");
				} else if ($oldFileType.val() == CD_EXAM_FILE_TYPE_VIDEO) {
					html.push("<div onclick='doDeleteFile(this)' class='previousFile'>");
					html.push("<spring:message code="글:시험:비디오파일이업로드되어있습니다"/>");
					html.push("</div>");
				} else if ($oldFileType.val() == CD_EXAM_FILE_TYPE_AUDIO) {
					html.push("<div onclick='doDeleteFile(this)' class='previousFile'>");
					html.push("<spring:message code="글:시험:오디오파일이업로드되어있습니다"/>");
					html.push("</div>");
				}
				value = $oldFilePath.val();
			}
		}
		$uploader.html(html.join(""));
		$filePath.hide().find("input").val(value);
		var upload = [];
		switch($fileType.val()) {
		case CD_EXAM_FILE_TYPE_IMAGE:
			upload.push({
				elementId : $uploader.attr("id"),
				postParams : {
					thumbnailWidth : 200,
					thumbnailHeight : 200,
					thumbnailCrop : "Y"
				},
				options : {
					uploadUrl : "<c:url value="/attach/image/save.do"/>",
					fileTypes : "*.jpg;*.gif",
					fileTypesDescription : "Image Files",
					fileSizeLimit : "10 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputHeight : 22, // default : 22
					immediatelyUpload : false,
					successCallback : function(id, file) {
						doSuccessCallback(id, file);
					}
				}
			});
			break;
		case CD_EXAM_FILE_TYPE_VIDEO:
			upload.push({
				elementId : $uploader.attr("id"),
				postParams : {},
				options : {
					uploadUrl : "<c:url value="/attach/media/save.do"/>",
					fileTypes : "*.wmv;*.mp4;*.mpeg;*.mpg;*.avi;",
					fileTypesDescription : "Video Files",
					fileSizeLimit : "100 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputHeight : 22, // default : 22
					immediatelyUpload : false,
					successCallback : function(id, file) {
						doSuccessCallback(id, file);
					}
				}
			});
			break;
		case CD_EXAM_FILE_TYPE_AUDIO:
			upload.push({
				elementId : $uploader.attr("id"),
				postParams : {},
				options : {
					uploadUrl : "<c:url value="/attach/media/save.do"/>",
					fileTypes : "*.mp3",
					fileTypesDescription : "Audio Files",
					fileSizeLimit : "100 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputHeight : 22, // default : 22
					immediatelyUpload : false,
					successCallback : function(id, file) {
						doSuccessCallback(id, file);
					}
				}
			});
			break;
		}
		swfu = UI.uploader.generate(swfu, upload);	
	} else {
		UI.uploader.removeUpload(swfu, $uploader.attr("id"));
		var val = "";
		if ($oldFilePathType.val() == "path") {
			val = $oldFilePath.val();
		}
		$filePath.show().find("input").val(val);
	}
};
/**
 * 마스터과정찾기
 */
 doBrowseCourseMaster = function() {
	forBrowseMaster.run();
};
/**
 * 과정 선택
 */
doSelectCourse = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forUpdate.config.formId);
		form.elements["courseMasterSeq"].value = returnValue.courseMasterSeq != null ? returnValue.courseMasterSeq : ""; 
		form.elements["courseMasterTitle"].value = returnValue.courseTitle != null ? returnValue.courseTitle : ""; 
	}
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseExam.jsp"/>
	</div>

	<c:set var="filePathType">upload=<spring:message code="글:시험:업로드"/>,path=<spring:message code="필드:시험:파일경로"/></c:set>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="examSeq" value="<c:out value="${detail.courseExam.examSeq}"/>"/>
	<table class="detail">
	<colgroup>
		<col style="width: 100px" />
		<col style="width: auto" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:교과목선택"/></th>
			<td>
				<span id="selectCourseMaster">
					<input type="hidden" name="courseMasterSeq" value="<c:out value="${detail.courseExam.courseMasterSeq}"/>"/>
					<input type="text"   name="courseMasterTitle" value="<c:out value="${detail.courseMaster.courseTitle}"/>" style="width:330px;" readonly="readonly"/>
					<a href="javascript:void(0)" onclick="doBrowseCourseMaster()" class="btn gray"><span class="small"><spring:message code="버튼:시험:교과목선택"/></span></a>
				</span>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="align-l">
				<input type="checkbox" name="openYn" value="${detail.courseExam.openYn}" <c:if test="${detail.courseExam.openYn eq 'Y'}">checked</c:if> /><spring:message code="필드:시험:전체공개"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문항제목"/></th>
			<td><textarea name="title" style="width:90%; height:100%"><c:out value="${detail.courseExam.title}"/></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:출제그룹"/></th>
			<td><input type="text" name="groupKey" value="<c:out value="${detail.courseExam.groupKey}"/>" style="width:30px;"></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문항해설"/></th>
			<td><textarea name="description" style="width:90%; height:30px"><c:out value="${detail.courseExam.description}"/></textarea></td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문제파일"/></th>
			<td>
				<select name="examFileTypeCd" class="fileType" onchange="doChangeUploader(this)">
					<aof:code type="option" codeGroup="EXAM_FILE_TYPE" selected="${detail.courseExam.examFileTypeCd}"/>
				</select>
				<select name="filePathType" class="filePathType" onchange="doChangeUploadType(this)">
					<aof:code type="option" codeGroup="${filePathType}" selected="${detail.courseExam.filePathType}"/>
				</select>
				<input type="hidden" name="oldFileType" value="<c:out value="${detail.courseExam.examFileTypeCd}"/>">
				<input type="hidden" name="oldFilePathType" value="<c:out value="${detail.courseExam.filePathType}"/>">
				<input type="hidden" name="oldFilePath" value="<c:out value="${detail.courseExam.filePath}"/>">

				<div class="filePath"><c:out value="${aoffn:config('upload.context.exam')}"/>
					<input type="text" name="filePath" value="<c:out value="${detail.courseExam.filePath}"/>" style="width:60%;">
				</div>
				<div id="uploader-0" class="uploader"></div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:사용여부"/></th>
			<td><aof:code type="radio" name="useYn" codeGroup="YESNO" ref="2" selected="${detail.courseExam.useYn}" labelStyleClass="radioLabel"/></td>
		</tr>
	</tbody>
	</table>
	</form>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doCancel();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>