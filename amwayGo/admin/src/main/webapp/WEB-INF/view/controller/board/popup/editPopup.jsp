<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_POPUP_INPUT_TYPE_TEXT"  value="${aoffn:code('CD.POPUP_INPUT_TYPE.TEXT')}"/>
<c:set var="CD_POPUP_INPUT_TYPE_IMAGE" value="${aoffn:code('CD.POPUP_INPUT_TYPE.IMAGE')}"/>
<c:set var="CD_POPUP_TEMPLATE_TYPE"    value="${aoffn:code('CD.POPUP_TEMPLATE_TYPE')}"/>
<c:set var="CD_POPUP_TEMPLATE_TYPE_A"  value="${aoffn:code('CD.POPUP_TEMPLATE_TYPE.A')}"/>
<c:set var="CD_POPUP_TYPE_WINDOW"      value="${aoffn:code('CD.POPUP_TYPE.WINDOW')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_POPUP_INPUT_TYPE_TEXT = "<c:out value="${CD_POPUP_INPUT_TYPE_TEXT}"/>";
var CD_POPUP_INPUT_TYPE_IMAGE = "<c:out value="${CD_POPUP_INPUT_TYPE_IMAGE}"/>";
var CD_POPUP_TEMPLATE_TYPE = "<c:out value="${CD_POPUP_TEMPLATE_TYPE}"/>";
var CD_POPUP_TEMPLATE_TYPE_A = "<c:out value="${CD_POPUP_TEMPLATE_TYPE_A}"/>";
var CD_POPUP_TYPE_WINDOW = "<c:out value="${CD_POPUP_TYPE_WINDOW}"/>";

var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
var swfu        = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2]datepicker
	UI.datepicker("#startDtime");
	UI.datepicker("#endDtime");

	var uploader = [];
	<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_TEXT}">
	uploader.push({
		elementId : "attachUploader",
		postParams : {
		},
		options : {
			uploadUrl : "<c:url value="/attach/file/save.do"/>",
			fileTypes : "*.*",
			fileTypesDescription : "All Files",
			fileSizeLimit : "10 MB",
			fileUploadLimit : 1, // default : 1, 0이면 제한없음.
			inputHeight : 20, // default : 20
			immediatelyUpload : true,
			successCallback : function(id, file) {
			}
		}
	});
	</c:if>
	<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_IMAGE}">
	uploader.push({
		elementId : "imageUploader",
		postParams : {
			thumbnailWidth : 120,
			thumbnailHeight : 120,
			thumbnailCrop : "Y"
		},
		options : {
			uploadUrl : "<c:url value="/attach/image/save.do"/>",
			buttonImageUrl : '<aof:img type="print" src="btn/photo_22x22.png"/>',
			buttonWidth: 23,
			inputWidth : 0,	
			fileTypes : "*.jpg;*.gif",
			fileTypesDescription : "Image Files",
			fileSizeLimit : "10 MB",
			immediatelyUpload : true,
			successCallback : function(id, file) {
				if (id == "imageUploader") {
					var form = UT.getById(forUpdate.config.formId);
					var fileInfo = file.serverData.fileInfo;
					form.elements["filePath"].value = fileInfo.savePath + "/" + fileInfo.saveName;
					
					var $photo = jQuery("#image-photo");
					$photo.attr("src", imageContext + form.elements["filePath"].value);
					$photo.siblings(".delete").show();
				}
			}
		}
	});
	</c:if>
	
	// uploader
	swfu = UI.uploader.create(function() {}, uploader);	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/popup/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/popup/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doSetUploadInfo;
	forUpdate.config.fn.complete     = function() {
		doList();
	};

	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/popup/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:제목"/>",
		name : "popupTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:내용"/>",
		name : "description",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forUpdate.config.formId);
			if ($form.find(":input[name='popupInputTypeCd']").val() === CD_POPUP_INPUT_TYPE_TEXT) {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:이미지"/>",
		name : "filePath",
		data : ["!null"],
		when : function() {
			var $form = jQuery("#" + forUpdate.config.formId);
			if ($form.find(":input[name='popupInputTypeCd']").val() === CD_POPUP_INPUT_TYPE_IMAGE) {
				return true;
			} else {
				return false;
			}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:게시기간"/>&nbsp;<spring:message code="필드:게시판:시작일"/>",
		name : "startDtime",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:게시기간"/>&nbsp;<spring:message code="필드:게시판:종료일"/>",
		name : "endDtime",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:게시기간"/>&nbsp;<spring:message code="필드:게시판:시작일"/>",
		name : "startDtime",
		check : {
			le : {name : "endDtime", title : "<spring:message code="필드:게시판:종료일"/>"}
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:팝업크기"/>&nbsp;<spring:message code="글:게시판:가로" />",
		name : "widthSize",
		data : ["!null", "number"],
		check : {
			maxlength : 4,
			ge : 300
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:팝업크기"/>&nbsp;<spring:message code="글:게시판:세로" />",
		name : "heightSize",
		data : ["!null", "number"],
		check : {
			maxlength : 4,
			ge : 300
		}
	});
};
/**
 * 저장
 */
doUpdate = function() { 
	// editor 값 복사
	UI.editor.copyValue();
	forUpdate.run();
};
/**
 * 삭제
 */
doDelete = function() { 
	forDelete.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	if (swfu != null) {
		var $form = jQuery("#" + forUpdate.config.formId);
		$form.find(":input[name='attachUploadInfo']").val(UI.uploader.getUploadedData(swfu, "attachUploader"));
	}
	return true;
};
/**
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
};
/**
 * 이미지 삭제
 */
 doDeletePhoto = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["filePath"].value = "";
	
	var $photo = jQuery("#image-photo");
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
};
/**
 * 템플릿 미리보기
 */
doPreviewTemplate = function() {
	var $form = jQuery("#" + forUpdate.config.formId);
	var template = $form.find(":input[name='popupTemplateTypeCd']").filter(":checked").val().replace(CD_POPUP_TEMPLATE_TYPE + "::", "");
	var width = $form.find(":input[name='widthSize']").val();
	var height = $form.find(":input[name='heightSize']").val();
	var popupTitle = $form.find(":input[name='popupTitle']").val();
	var url = "<c:url value="/common/popup/template"/>";
	var popupType = $form.find(":input[name='popupTypeCd']").filter(":checked").val();
	var areaSetting = $form.find(":input[name='areaSetting']").filter(":checked").val();
	var description = $form.find(":input[name='description']").val();
	var popupConfirmTypeCd = $form.find(":input[name='popupConfirmTypeCd']").val();

	var action = null;
	if (popupType == CD_POPUP_TYPE_WINDOW) {
		action = $.action("popup");
		action.config.options.position = areaSetting;
	} else {
		action = $.action("layer");
		if (areaSetting == "lefttop") {
			action.config.options.position = {of : jQuery(window), my : "left top", at : "left top"};
		} else if (areaSetting == "leftbottom") {
			action.config.options.position = {of : jQuery(window), my : "left bottom", at : "left bottom"};
		} else if (areaSetting == "righttop") {
			action.config.options.position = {of : jQuery(window), my : "right top", at : "right top"};
		} else if (areaSetting == "rightbottom") {
			action.config.options.position = {of : jQuery(window), my : "right bottom", at : "right bottom"};
		} else {
			action.config.options.position = {of : jQuery(window), my : "center", at : "center"};
		}
	}
	action.config.url = url + template + ".jsp"; 
	action.config.formId = "FormPreview";
	action.config.options.width = width;
	action.config.options.height = height;
	action.config.options.title = popupTitle;
	
	var param = {
		"popupTitle" : popupTitle,
		"description" : description,
		"popupConfirmTypeCd" : popupConfirmTypeCd
	};
	UT.copyValueMapToForm(param, action.config.formId);
	action.run();
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchPopup.jsp"/>
	</div>

	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="popupSeq" value="<c:out value="${detail.popup.popupSeq}"/>"/>
	<input type="hidden" name="popupTypeCd" value="<c:out value="${detail.popup.popupTypeCd}"/>"/>
	<input type="hidden" name="popupInputTypeCd" value="<c:out value="${detail.popup.popupInputTypeCd}"/>"/>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:게시판:입력방식"/></th>
			<td>
				<aof:code type="print" codeGroup="POPUP_INPUT_TYPE" selected="${detail.popup.popupInputTypeCd}"/>
				/
				<aof:code type="print" codeGroup="POPUP_TYPE" selected="${detail.popup.popupTypeCd}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:제목"/><span class="star">*</span></th>
			<td><input type="text" name="popupTitle" value="<c:out value="${detail.popup.popupTitle}"/>" style="width:365px;"></td>
		</tr>
		<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_TEXT}">
			<tr>
				<th><spring:message code="필드:게시판:내용"/><span class="star">*</span></th>
				<td><textarea name="description" id="description" style="width:98%; height:100px"><c:out value="${detail.popup.description}"/></textarea></td>
			</tr>
			<tr>
				<th><spring:message code="필드:게시판:첨부파일"/></th>
				<td>
					<input type="hidden" name="attachUploadInfo"/>
					<input type="hidden" name="attachDeleteInfo">
					<div id="attachUploader" class="uploader">
						<c:if test="${!empty detail.popup.attachList}">
							<c:forEach var="row" items="${detail.popup.attachList}" varStatus="i">
								<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
									<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
								</div>
							</c:forEach>
						</c:if>
					</div>
					<span class="vbom">10MB</span>
				</td>
			</tr>
		</c:if>
		<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_IMAGE}">
			<tr>
				<th><spring:message code="필드:게시판:이미지"/><span class="star">*</span></th>
				<td>
					<input type="hidden" name="filePath" value="<c:out value="${detail.popup.filePath}"/>">
					<c:choose>
						<c:when test="${!empty detail.popup.filePath}">
							<c:set var="imagePhoto" value ="${aoffn:config('upload.context.image')}${detail.popup.filePath}.thumb.jpg"/>
						</c:when>
						<c:otherwise>
							<c:set var="imagePhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
						</c:otherwise>
					</c:choose>
					<div class="photo photo-120" style="margin:0;">
						<img src="<c:out value="${imagePhoto}"/>" id="image-photo">
						<div id="imageUploader" class="uploader"></div>
						<div class="delete" 
						     style="display:<c:out value="${empty detail.popup.filePath ? 'none' : ''}"/>;" 
						     onclick="doDeletePhoto()" title="<spring:message code="버튼:삭제"/>"></div>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:게시판:URL"/></th>
				<td><input type="text" name="url" value="<c:out value="${detail.popup.url}"/>" style="width:365px;"></td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:게시판:게시기간"/><span class="star">*</span></th>
			<td>
				<input type="text" name="startDtime" id="startDtime" style="width:80px;text-align:center;" value="<aof:date datetime="${detail.popup.startDtime}"/>" readonly="readonly" />
				~
				<input type="text" name="endDtime" id="endDtime" style="width:80px;text-align:center;" value="<aof:date datetime="${detail.popup.endDtime}"/>" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:팝업크기"/><span class="star">*</span></th>
			<td>
				<spring:message code="글:게시판:가로"/>(<spring:message code="글:게시판:픽셀"/>) :
				<input type="text" name="widthSize" value="<c:out value="${detail.popup.widthSize}"/>" class="align-c" style="width:50px;">
				/
				<spring:message code="글:게시판:세로"/>(<spring:message code="글:게시판:픽셀"/>) :
				<input type="text" name="heightSize" value="<c:out value="${detail.popup.heightSize}"/>" class="align-c" style="width:50px;" >
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:영역설정"/></th>
			<td>
				<input type="radio" name="areaSetting" value="lefttop" <c:out value="${detail.popup.areaSetting eq 'lefttop' ? 'checked' : ''}"/>> <lable>LT</lable>
				<input type="radio" name="areaSetting" value="leftbottom" <c:out value="${detail.popup.areaSetting eq 'leftbottom' ? 'checked' : ''}"/>> <lable>LB</lable>
				<input type="radio" name="areaSetting" value="righttop" <c:out value="${detail.popup.areaSetting eq 'righttop' ? 'checked' : ''}"/>> <lable>RT</lable>
				<input type="radio" name="areaSetting" value="rightbottom" <c:out value="${detail.popup.areaSetting eq 'rightbottom' ? 'checked' : ''}"/>> <lable>RB</lable>
				<input type="radio" name="areaSetting" value="center" <c:out value="${detail.popup.areaSetting eq 'center' ? 'checked' : ''}"/>> <lable>C</lable>
			</td>
		</tr>
		<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_TEXT}">
			<tr>
				<th><spring:message code="필드:게시판:템플릿설정"/></th>
				<td>
					<aof:code type="radio" codeGroup="POPUP_TEMPLATE_TYPE" name="popupTemplateTypeCd" selected="${detail.popup.popupTemplateTypeCd}"/>
					<a href="#" onclick="doPreviewTemplate();" class="btn gray"><span class="small"><spring:message code="버튼:미리보기"/></span></a>
				</td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:게시판:사용여부"/></th>
			<td><aof:code type="radio" codeGroup="YESNO" name="useYn" removeCodePrefix="true" selected="${detail.popup.useYn}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:확인메시지"/></th>
			<td>
				<select name="popupConfirmTypeCd">
					<aof:code type="option" codeGroup="POPUP_CONFIRM_TYPE" selected="${detail.popup.popupConfirmTypeCd}"/>
				</select>
			</td>
		</tr>
	</tbody>
	</table>
	</form>

	<form id="FormPreview" name="FormPreview" method="post" onsubmit="return false;">
		<input type="hidden" name="popupTitle" value=""/>
		<input type="hidden" name="description" value=""/>
		<input type="hidden" name="popupConfirmTypeCd" value=""/>
	</form>
	
	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="popupSeq" value="<c:out value="${detail.popup.popupSeq}"/>"/>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>