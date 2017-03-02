<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_001"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.001')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_003"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_007"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.007')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_V"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.V')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_EXAM_FILE_TYPE_IMAGE = "<c:out value="${CD_EXAM_FILE_TYPE_IMAGE}"/>";
var CD_EXAM_FILE_TYPE_VIDEO = "<c:out value="${CD_EXAM_FILE_TYPE_VIDEO}"/>";
var CD_EXAM_FILE_TYPE_AUDIO = "<c:out value="${CD_EXAM_FILE_TYPE_AUDIO}"/>";
var CD_EXAM_ITEM_TYPE_001 = "<c:out value="${CD_EXAM_ITEM_TYPE_001}"/>";
var CD_EXAM_ITEM_TYPE_002 = "<c:out value="${CD_EXAM_ITEM_TYPE_002}"/>";
var CD_EXAM_ITEM_TYPE_003 = "<c:out value="${CD_EXAM_ITEM_TYPE_003}"/>";
var CD_EXAM_ITEM_TYPE_004 = "<c:out value="${CD_EXAM_ITEM_TYPE_004}"/>";
var CD_EXAM_ITEM_TYPE_005 = "<c:out value="${CD_EXAM_ITEM_TYPE_005}"/>";
var CD_EXAM_ITEM_TYPE_006 = "<c:out value="${CD_EXAM_ITEM_TYPE_006}"/>";
var CD_EXAM_ITEM_TYPE_007 = "<c:out value="${CD_EXAM_ITEM_TYPE_007}"/>";

var forUpdate   = null;
var forBrowseMaster = null;
var forBrowseProfessor = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. uploader
	swfu = UI.uploader.create(function() { // completeCallback
		forUpdate.run("continue");
	});	

	doChangeItemType();
	doChangeExampleCount();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/exam/item/update.do"/>";
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
	
	forBrowseProfessor = $.action("layer");
	forBrowseProfessor.config.formId         = "FormBrowseProfessor";
	forBrowseProfessor.config.url            = "<c:url value="/member/prof/list/popup.do"/>";
	forBrowseProfessor.config.options.width  = 700;
	forBrowseProfessor.config.options.height = 500;
	forBrowseProfessor.config.options.title  = "<spring:message code="글:시험:교수선택"/>";
	
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
		title : "<spring:message code="필드:시험:문제점수"/>",
		name : "examItemScore",
		data : ["!null","trim", "decimalnumber"],
		check : {
			le : 100
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
		title : "<spring:message code="필드:시험:난이도"/>",
		name : "examItemDifficultyCd",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:첨삭기준"/>",
		name : "examItemComment",
		check : {
			maxlength : 1000
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:문항유형"/>",
		name : "examItemTypeCd",
		data : ["!null","trim"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:보기"/>",
		name : "examExampleTitles",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		},
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_001 || examItemType == CD_EXAM_ITEM_TYPE_002) ? true : false;
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:정답"/>",
		name : "correctAnswerRadio",
		data : ["!null","trim"],
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_001 || examItemType == CD_EXAM_ITEM_TYPE_003) ? true : false;
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:정답"/>",
		name : "correctAnswerCheckbox",
		data : ["!null","trim"],
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_002) ? true : false;
		}
	});
	/*
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:정답"/>",
		name : "correctAnswer",
		data : ["!null","trim"],
		check : {
			maxlength : 1000
		},
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_004) ? true : false;
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:유사정답"/>",
		name : "similarAnswer",
		check : {
			maxlength : 1000
		},
		when : function() {
			var form = UT.getById(forUpdate.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_004) ? true : false;
		}
	});
	*/
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:파일경로"/>",
		name : "examItemFilePath",
		data : ["!space"],
		check : {
			maxlength : 200
		}
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:시험:파일경로"/>",
		name : "examExampleFilePaths",
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
	var isAppendedFiles = false;
	for (var i = 0; i <= 5; i++) {
		if (UI.uploader.isAppendedFiles(swfu, "uploader-" + i) == true) {
			isAppendedFiles = true;
			break;
		}
	}
	if (isAppendedFiles == true) {
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
	var ids = id.split("-");
	if (ids.length == 2) {
		var index = parseInt(ids[1], 10);
		if (index == 0) {
			form.elements["examItemFilePath"].value = fileInfo.savePath + "/" + fileInfo.saveName;
		} else {
			form.elements["examExampleFilePaths"][index - 1].value = fileInfo.savePath + "/" + fileInfo.saveName;
		}
	}
};
/**
 * 문항유형 변경
 */
doChangeItemType = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var $select = $form.find(":input[name='examItemTypeCd']");

	jQuery(".example").each(function(){
		var $this = jQuery(this); 
		if ($this.hasClass($select.val())) {
			$this.show();
		} else {
			$this.hide();
		}
	});
	
	switch($select.val()) {
	case CD_EXAM_ITEM_TYPE_003:
		jQuery("#examExample").show();
		break;
	case CD_EXAM_ITEM_TYPE_001:
		jQuery("#examExample").show();
		break;
	case CD_EXAM_ITEM_TYPE_002:
		jQuery("#examExample").show();
		doChangeExampleCount();
		break;
	case CD_EXAM_ITEM_TYPE_004:
		jQuery("#examExample").show();
		doChangeExampleCount(0);
		break;
	case CD_EXAM_ITEM_TYPE_005:
	case CD_EXAM_ITEM_TYPE_006:	
		jQuery("#examExample").hide();
		doChangeExampleCount(0);
		break;
	case CD_EXAM_ITEM_TYPE_007:
		doChangeExampleCount(4);
		jQuery("#examExample").show();
		break;
	}
	//doChangeUploader();
};
/**
 * 보기수 변경
 */
doChangeExampleCount = function(count) {
	if (typeof count !== "number") { 
		var $form = jQuery("#" + forUpdate.config.formId);
		var $select = $form.find(":input[name='examItemExampleCount']");
		count = $select.val();
		count = parseInt(count, 10);
		
	}

	jQuery("#examples").find("ul").each(function(index){
		var $this = jQuery(this);
		if (index < count) {
			$this.show();
			$this.find(":input[name='examExampleTitles']").attr("disabled", false);
			$this.find(".uploader").each(function(){
				var $uploader = jQuery(this);
				doChangeUploadType($uploader.siblings(".filePathType"));
			});
		} else {
			$this.hide();
			$this.find(":input[name='examExampleTitles']").attr("disabled", true);
			$this.find(".uploader").each(function(){
				var $uploader = jQuery(this);
				UI.uploader.removeUpload(swfu, $uploader.attr("id"));
			});
		}
	});
	UT.noscrollingIframe();
};
/**
 * 취소 : 레이어 닫기
 */
doCancel = function() {
	 $layer.dialog("close");
};
/**
 * 정답선택
 */
doChangeCorrectYn = function(element) {
	
	if (element.type == "checkbox") {
		if (element.checked == true) {
			jQuery(element).siblings(" :input[name='examExampleCorrectYns']").val("Y");
		} else {
			jQuery(element).siblings(" :input[name='examExampleCorrectYns']").val("N");
		}
	} else if (element.type == "radio") {
		
		if (element.checked == true) {
			var index = parseInt(element.value, 10);
			jQuery("#" + forUpdate.config.formId + " :input[name='examExampleCorrectYns']").each(function(i) {
				this.value = (i == (index - 1)) ? "Y" : "N";
			});
		} else {
			jQuery("#" + forUpdate.config.formId + " :input[name='examExampleCorrectYns']").each(function() {
				this.value = "N";
			});
		}
	}
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
/**
 * 파일 삭제
 */
doDeleteFile = function(element) {
	var $file = jQuery(element).closest("div");
	$file.remove();
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<style type="text/css">
.ul {list-style:none; clear:both;}
.ulhead, .lihead {text-align:center; background-color:#f7f7f7;}
.li {float:left; text-align:center; line-height:23px;}
.column1 {width:40px;}
.column2 {width:342px;}
.column3 {width:405px;padding-top:1px;}
.column4 {width:60px;}
</style>
</head>

<body>

	<form name="FormBrowseCourse" id="FormBrowseCourse" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doSelectCourse"/>
	</form>

	<c:set var="filePathType">upload=<spring:message code="글:시험:업로드"/>,path=<spring:message code="필드:시험:파일경로"/></c:set>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="examSeq" value="<c:out value="${detail.courseExamItem.examSeq}"/>"/>
	<input type="hidden" name="examItemSeq" value="<c:out value="${detail.courseExamItem.examItemSeq}"/>"/>
	<input type="hidden" name="examItemSortOrder" value="<c:out value="${detail.courseExamItem.sortOrder}"/>"/>
	<input type="hidden" name="courseMasterSeq" value="<c:out value="${detailExam.courseExam.courseMasterSeq}"/>"/>
	<input type="hidden" name="useYn" value="<c:out value="${detailExam.courseExam.useYn}"/>"/>
	
	<input type="hidden" name="examItemScore" style="width:30px;" value="1">
	<input type="hidden" name="examItemDifficultyCd" style="width:30px;" value="EXAM_ITEM_DIFFICULTY::003">
	<input type="hidden" name="openYn" value="Y"/>
	
	<table class="tbl-detail">
	
	<colgroup>
		<col style="width: 90px" />
		<col/>
		<col style="width: 90px" />
		<col style="width: 130px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:문항제목"/></th>
			<td colspan="3" style="border-right:none;"><textarea name="examItemTitle" style="width:90%; height:100%"><c:out value="${detail.courseExamItem.examItemTitle}"/></textarea></td>
			<%--
			<th><spring:message code="필드:시험:문제점수"/></th>
			<td><input type="text" name="examItemScore" style="width:30px;" value="${detail.courseExamItem.examItemScore}"></td>
			 --%>
		</tr>
		<%--
		<tr>
			<th><spring:message code="필드:시험:문항해설"/></th>
			<td style="border-right:none;"><textarea name="examItemDescription" style="width:90%; height:100%"><c:out value="${detail.courseExamItem.description}"/></textarea></td>
			<c:choose>
				<c:when test="${detailExam.courseExam.examCount gt 1}">
					<td style="border-left:none;border-right:none;">&nbsp;</td>
					<td style="border-left:none;">&nbsp;</td>
				</c:when>
				<c:otherwise>
					<th><spring:message code="필드:시험:출제그룹"/></th>
					<td><input type="text" name="groupKey" value="<c:out value="${detailExam.courseExam.groupKey}"/>" style="width:30px;"></td>
				</c:otherwise>
			</c:choose>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:첨삭기준"/></th>
			<td><textarea name="examItemComment" style="width:90%; height:100%"><c:out value="${detail.courseExamItem.comment}"/></textarea></td>
			<th><spring:message code="필드:시험:난이도"/></th>
			<td>
				<select name="examItemDifficultyCd">
					<aof:code type="option" codeGroup="EXAM_ITEM_DIFFICULTY" selected="${detail.courseExamItem.examItemDifficultyCd}"/>
				</select>
			</td>
		</tr>
		 --%>
		 
		<tr>
			<%--
			<th><spring:message code="필드:시험:문항파일"/></th>
			<td>
				<select name="examItemFileTypeCd" class="fileType" onchange="doChangeUploader(this)">
					<aof:code type="option" codeGroup="EXAM_FILE_TYPE" selected="${detail.courseExamItem.examFileTypeCd}"/>
				</select>
				<select name="examItemFilePathType" class="filePathType" onchange="doChangeUploadType(this)">
					<aof:code type="option" codeGroup="${filePathType}" selected="${detail.courseExamItem.filePathType}"/>
				</select>
				<input type="hidden" name="oldFileType" value="<c:out value="${detail.courseExamItem.examFileTypeCd}"/>">
				<input type="hidden" name="oldFilePathType" value="<c:out value="${detail.courseExamItem.filePathType}"/>">
				<input type="hidden" name="oldFilePath" value="<c:out value="${detail.courseExamItem.filePath}"/>">

				<div class="filePath">
					<input type="text" name="examItemFilePath" value="<c:out value="${detail.courseExamItem.filePath}"/>" style="width:60%;">
				</div>
				<div id="uploader-0" class="uploader"></div>
			</td>
			 --%>
			<th><spring:message code="필드:시험:문항유형"/></th>
			<td colspan="3">
				<input type="hidden" name="examItemTypeCd" value="<c:out value="${detail.courseExamItem.examItemTypeCd}"/>"/>
				<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${detail.courseExamItem.examItemTypeCd}"/>
			</td>
		</tr>
		<tr id="examExample">
			<td colspan="4">
				<ul class="ul">
					<li id="selectCount" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_007}"/>" style="line-height:25px;float:left;">
						<spring:message code="필드:시험:보기수"/>&nbsp;&nbsp;
						<select name="examItemExampleCount" onchange="doChangeExampleCount()" style="width:50px;" disabled="disabled">
							<aof:code type="option" codeGroup="2=2,3=3,4=4,5=5" selected="${aoffn:size(detail.listCourseExamExample)}"/>
						</select>
					</li>
					 
					<%-- 
					<li class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003}"/>" style="line-height:25px;float:left;padding-left: 5px;">
						<select name="examItemAlignCd">
							<aof:code type="option" codeGroup="EXAM_ITEM_ALIGN" defaultSelected="${CD_EXAM_ITEM_ALIGN_V}" selected="${detail.courseExamItem.examItemAlignCd}"/>
						</select>
					</li>
					
					<li style="line-height:25px;float:left;padding-left: 5px;">
						<input type="checkbox" name="openYn" value="Y"  <c:if test="${detailExam.courseExam.openYn eq 'Y'}">checked=checked</c:if> /><spring:message code="필드:시험:전체공개"/>
					</li>
					--%>
				</ul>
				<ul class="ul">
					<li class="li column1 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003} ${CD_EXAM_ITEM_TYPE_007}"/>"><spring:message code="필드:시험:정답"/></li>
					<li class="li column2 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003} ${CD_EXAM_ITEM_TYPE_007}"/>"><spring:message code="필드:시험:보기"/></li>
					<%--<li class="li column3 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>"><spring:message code="필드:시험:보기파일"/></li> --%>
				</ul>
				<ul class="ul">
					<li class="li column4 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>"><spring:message code="필드:시험:정답"/></li>
					<li class="li column2 align-l example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>">
						<input type="text" name="correctAnswer" value="<c:out value="${detail.courseExamItem.correctAnswer}"/>" style="width:320px;">
					</li>
				</ul>
				<ul class="ul">
					<li class="li column4 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>"><spring:message code="필드:시험:유사정답"/></li>
					<li class="li column2 align-l example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>">
						<input type="text" name="similarAnswer" value="<c:out value="${detail.courseExamItem.similarAnswer}"/>" style="width:320px;">
						<div class="comment"><spring:message code="글:시험:콤마를구분자로이용하여입력하십시오"/></div>
					</li>
				</ul>

				<div id="examples">
				
					<c:set var="sortOrder" value="0" />
					<c:forEach var="row" items="${detail.listCourseExamExample}" varStatus="i">
						<input type="hidden" name="examExampleSeqs" value="<c:out value="${row.courseExamExample.examExampleSeq}"/>"/>
						<ul class="ul">
							<li class="li column1 example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003} ${CD_EXAM_ITEM_TYPE_007}"/>">
								<input type="radio" name="correctAnswerRadio" value="<c:out value="${i.count}"/>"  
									onclick="doChangeCorrectYn(this)" 
									class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_007}"/> _space_ <c:if test="${i.count eq 1 or i.count eq 2}"><c:out value="${CD_EXAM_ITEM_TYPE_003}"/></c:if>"
									<c:if test="${(detail.courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_001 or detail.courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_003 or detail.courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_007)  
										and row.courseExamExample.correctYn eq 'Y'}">checked="checked"</c:if>
									>
									
								<input type="checkbox" name="correctAnswerCheckbox" value="<c:out value="${i.count}"/>" 
									onclick="doChangeCorrectYn(this)" 
									class="example <c:out value="${CD_EXAM_ITEM_TYPE_002}"/>"
									<c:if test="${detail.courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_002 and row.courseExamExample.correctYn eq 'Y'}">checked="checked"</c:if>
									>
								<input type="hidden" name="examExampleCorrectYns" value="<c:out value="${row.courseExamExample.correctYn}"/>"/>
								<input type="hidden" name="examExampleSortOrders" value="<c:out value="${i.count}"/>">
							</li>
							<li class="li column2 align-l example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003} ${CD_EXAM_ITEM_TYPE_007}"/>">
								<textarea name="examExampleTitles" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_007}"/> _space_ <c:if test="${i.count eq 1 or i.count eq 2}"><c:out value="${CD_EXAM_ITEM_TYPE_003}"/></c:if>" 
									style="width:90%; height:35px;"><c:out value="${row.courseExamExample.examItemExampleTitle}"/></textarea>
							</li>
							<%--
							<li class="li column3 align-l <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>">
								<select name="examExampleFileTypeCds"  class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/> fileType" onchange="doChangeUploader(this)">
									<aof:code type="option" codeGroup="EXAM_FILE_TYPE" selected="${row.courseExamExample.examFileTypeCd}"/>
								</select>
								<select name="examExampleFilePathTypes" class="filePathType" onchange="doChangeUploadType(this)">
									<aof:code type="option" codeGroup="${filePathType}" selected="${row.courseExamExample.filePathType}"/>
								</select>
								<input type="hidden" name="oldFileType" value="<c:out value="${row.courseExamExample.examFileTypeCd}"/>">
								<input type="hidden" name="oldFilePathType" value="<c:out value="${row.courseExamExample.filePathType}"/>">
								<input type="hidden" name="oldFilePath" value="<c:out value="${row.courseExamExample.filePath}"/>">
				
								<div class="filePath"><c:out value="${aoffn:config('upload.context.exam')}"/>
									<input type="text" name="examExampleFilePaths" value="<c:out value="${row.courseExamExample.filePath}"/>" style="width:60%;">
								</div>
								<div id="uploader-<c:out value="${i.count}"/>" class="uploader"></div>
							</li>
							 --%>
						</ul>
						<c:set var="sortOrder" value="${sortOrder + 1}" />
					</c:forEach>
					
					<c:forEach var="row" begin="${aoffn:size(detail.listCourseExamExample) + 1}" end="5" varStatus="i">
						<input type="hidden" name="examExampleSeqs" value=""/>
						<ul class="ul">
							<li class="li column1 example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003} ${CD_EXAM_ITEM_TYPE_007}"/>">
								<input type="radio" name="correctAnswerRadio" value="<c:out value="${i.count}"/>"  
									onclick="doChangeCorrectYn(this)" 
									class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_007}"/> _space_ <c:if test="${row eq 1 or row eq 2}"><c:out value="${CD_EXAM_ITEM_TYPE_003}"/></c:if>">
								
								<input type="checkbox" name="correctAnswerCheckbox" value="<c:out value="${i.count}"/>"
									onclick="doChangeCorrectYn(this)" 
									class="example <c:out value="${CD_EXAM_ITEM_TYPE_002}"/>">
								<input type="hidden" name="examExampleCorrectYns" value="N"/>
								<input type="hidden" name="examExampleSortOrders" value="<c:out value="${sortOrder + i.count}"/>">
							</li>
							<li class="li column2 align-l example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003} ${CD_EXAM_ITEM_TYPE_007}"/>">
								<textarea name="examExampleTitles" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_007}"/>" style="width:90%; height:35px;"></textarea>
								<c:if test="${row eq 1}"><span class="example <c:out value="${CD_EXAM_ITEM_TYPE_003}"/>">O</span></c:if>
								<c:if test="${row eq 2}"><span class="example <c:out value="${CD_EXAM_ITEM_TYPE_003}"/>">X</span></c:if>
							</li>
							<%--
							<li class="li column3 align-l example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>"> 
								<select name="examExampleFileTypeCds"  class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/> fileType"
									onchange="doChangeUploader(this)">
									<aof:code type="option" codeGroup="EXAM_FILE_TYPE" defaultSelected="${CD_EXAM_FILE_TYPE_IMAGE}"/>
								</select>
								<select name="examExampleFilePathTypes" class="filePathType" onchange="doChangeUploadType(this)">
									<aof:code type="option" codeGroup="${filePathType}" defaultSelected="upload"/>
								</select>
								<div class="filePath"><c:out value="${aoffn:config('upload.context.exam')}"/><input type="text" name="examExampleFilePaths" style="width:60%;"></div>
								<div id="uploader-<c:out value="${row}"/>" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/> uploader"></div>
							</li>
							 --%>
						</ul>
					</c:forEach>
				</div>
			</td>
		</tr>
	</tbody>
	</table>	
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doCancel();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>