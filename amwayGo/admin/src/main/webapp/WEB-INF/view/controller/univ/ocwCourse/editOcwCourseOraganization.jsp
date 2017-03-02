<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_WEEK_TYPE_LECTURE"         value="${aoffn:code('CD.COURSE_WEEK_TYPE.LECTURE')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_MIDEXAM"         value="${aoffn:code('CD.COURSE_WEEK_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_MIDHOMEWORK"     value="${aoffn:code('CD.COURSE_WEEK_TYPE.MIDHOMEWORK')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_FINALEXAM"       value="${aoffn:code('CD.COURSE_WEEK_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_FINALHOMEWORK"   value="${aoffn:code('CD.COURSE_WEEK_TYPE.FINALHOMEWORK')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ORGANIZATION" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ORGANIZATION')}"/>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COURSE_WEEK_TYPE_LECTURE = "<c:out value="${CD_COURSE_WEEK_TYPE_LECTURE}"/>";
var CD_COURSE_WEEK_TYPE_MIDEXAM = "<c:out value="${CD_COURSE_WEEK_TYPE_MIDEXAM}"/>";
var CD_COURSE_WEEK_TYPE_FINALEXAM = "<c:out value="${CD_COURSE_WEEK_TYPE_FINALEXAM}"/>";
var CD_COURSE_WEEK_TYPE_FINALHOMEWORK = "<c:out value="${CD_COURSE_WEEK_TYPE_FINALHOMEWORK}"/>";

var forListdata = null;
var forEdit = null;
var forEditOrganization = null;
var forInsert = null;
var forUpdate = null;
var forOcwContents = null;
var forOcwCommentPopup = null;
var forDeletelist = null;
var forPreview = null;
var forBrowseContents = null;
var forListContentsElement = null;
var forListMapping = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";

initPage = function() {
	// 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.tabs("#tabs");
	
	jQuery("#tab1").attr("class","ui-state-default ui-corner-top");
	jQuery("#tab2").attr("class","ui-state-default ui-corner-top ui-tabs-selected ui-state-active");
	
	// [3] upload
	swfu = UI.uploader.create(function() {
		forUpdate.run("continue");
	});
	
	doUpload();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/ocw/course/detail.do"/>";

	forOcwContents = $.action("ajax");
	forOcwContents.config.formId = "FormOcwContents";
	forOcwContents.config.url    = "<c:url value="/univ/ocw/course/organization/contents/edit/ajax.do"/>";
	forOcwContents.config.fn.complete = function() {};
	
	forEditOrganization = $.action();
	forEditOrganization.config.formId = "FormDetail";
	forEditOrganization.config.url    = "<c:url value="/univ/ocw/course/organization/edit.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"});
	forInsert.config.url             = "<c:url value="/univ/course/active/element/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:추가하시겠습니까"/>";
	forInsert.config.message.success = "<spring:message code="글:추가되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doEditOrganization({'ocwCourseActiveSeq' : '<c:out value="${param['ocwCourseActiveSeq']}" />',
			'courseActiveSeq' : '<c:out value="${param['courseActiveSeq']}" />'});
	};
	
	forUpdate = $.action("submit", {formId : "FormData"});
	forUpdate.config.url             = "<c:url value="/univ/course/active/element/insert.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doStartUpload;
	forUpdate.config.fn.complete     = function() {
		doEditOrganization({'ocwCourseActiveSeq' : '<c:out value="${param['ocwCourseActiveSeq']}" />',
			'courseActiveSeq' : '<c:out value="${param['courseActiveSeq']}" />'});
	};
	
	setValidate();
	
	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/univ/course/active/element/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forPreview = $.action("layer");
	forPreview.config.formId = "FormLearning";
	forPreview.config.url    = "<c:url value="/learning/simple/popup.do"/>";
	forPreview.config.options.title = "<spring:message code="글:콘텐츠:미리보기"/>";
	forPreview.config.options.width = 1006;
	forPreview.config.options.height = 800;
	forPreview.config.options.draggable = false;
	forPreview.config.options.titlebarHide = true;
	forPreview.config.options.backgroundOpacity = 0.9;
	
	forOcwCommentPopup = $.action("layer");
	forOcwCommentPopup.config.formId = "FormOcwComment";
	forOcwCommentPopup.config.url    = "<c:url value="/univ/ocw/course/comment/list/popup.do"/>";
	forOcwCommentPopup.config.options.title = "<spring:message code="글:콘텐츠:미리보기"/>";
	forOcwCommentPopup.config.options.width = 1006;
	forOcwCommentPopup.config.options.height = 800;
	forOcwCommentPopup.config.options.draggable = true;
	forOcwCommentPopup.config.options.titlebarHide = false;
	forOcwCommentPopup.config.options.backgroundOpacity = 0.9;
	
	forBrowseContents = $.action("layer");
	forBrowseContents.config.formId = "FormBrowseContents";
	forBrowseContents.config.url    = "<c:url value="/lcms/contents/list/popup.do"/>";
	forBrowseContents.config.options.title = "<spring:message code="글:콘텐츠:콘텐츠일괄매핑"/>";
	forBrowseContents.config.options.width = 800;
	forBrowseContents.config.options.height = 600;
	
	forListContentsElement = $.action("ajax");
	forListContentsElement.config.type = "json";
	forListContentsElement.config.formId = "FormListContentsElement";
	forListContentsElement.config.url    = "<c:url value="/lcms/contents/organization/list/json.do"/>";
	forListContentsElement.config.fn.complete = function(action, data) {
		if (data != null) {
			// lecuter 아닌것 카피.
			var $notlecture = jQuery(".notlecture").clone();
			var $listElement = jQuery("#listElement");
			$listElement.empty(); // 기존 데이타 클리어
			
			for (var i = 0; i < data.list.length; i++) {
				var html = UT.formatString(doGetHtmlTemplateWeek(), ({
					"activeElementTitle" : data.list[i].organization.title,
					"organizationSeq" : data.list[i].contentsOrganization.organizationSeq
				}));
				jQuery(html).appendTo($listElement);
			}
			
			// 기존 lecuter 아닌거 원래 위치에 삽입
			$notlecture.each(function() {
				var $this = jQuery(this);
				var sortOrder = parseInt($this.attr("sortOrder"), 10);
				
				$listElement.find(".week-type").each(function(index){
					if ((index+1) == sortOrder) {
						jQuery(this).insertBefore($this);
					}
				});
			});
			
		}
		
		var $form = jQuery("#" + forUpdate.config.formId);
		$form.find(":input[name='checkkeys']").each(function(index) {
			this.value = index;
		});
		$form.find(":input[name='sortOrders']").each(function(index) {
			this.value = index + 1;
		});
	};
	
	forListMapping = $.action();
	forListMapping.config.formId = "FormMappingContents";
	forListMapping.config.url    = "<c:url value="/univ/ocw/course/organization/mapper/edit.do"/>";
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};

/**
 * 구성정보로 이동
 */
doEditOrganization = function(mapPKs) {
	// 구성정보로 이동 form을 reset한다.
	UT.getById(forEditOrganization.config.formId).reset();
	// 구성정보로 이동 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEditOrganization.config.formId);
	// 구성정보로 이동
	forEditOrganization.run();
};

/**
 * 수정
 */
doUpdate = function() {
	forUpdate.run();
};

setValidate = function() {
	forUpdate.validator.set(function() {
		var form = UT.getById(forUpdate.config.formId);	
		
		// 주차 순서 체크
		if(typeof(form.elements["sortOrders"].length) != 'undefined') {
			for(var i = 0; i < form.elements["sortOrders"].length; i++){
				for(var j = i+1; j < form.elements["sortOrders"].length; j++){
					if(form.elements["sortOrders"][i].value == form.elements["sortOrders"][j].value) {
						$.alert({
							message : "<spring:message code="글:주차:주차순서가같습니다"/>"
						});
						return false;
					}
				}
			}
			return true;
		} else {
			return true;
		}
	});
};
/**
 * 과정구성요소 추가
 */
doInsert = function() {
	forInsert.run();
};
/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doDeletelist = function() { 
	forDeletelist.run();
};

/**
 * 목록삭제 완료
 */
doCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doEditOrganization({'ocwCourseActiveSeq' : '<c:out value="${param['ocwCourseActiveSeq']}" />',
					'courseActiveSeq' : '<c:out value="${param['courseActiveSeq']}" />'});
			}
		}
	});
};

/**
 * 강 미리보기
 */
doPreview = function(mapPKs) {
	// 미리보기화면 form을 reset한다.
	UT.getById(forPreview.config.formId).reset();
	// 미리보기화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPreview.config.formId);
	// 미리보기화면 실행
	if(forPreview.config.popupWindow != null) { // 팝업윈도우가 이미 존재하면 닫고, 다시 띄운다.
		forPreview.config.popupWindow.close();
		forPreview.config.popupWindow = null;
		setTimeout("forPreview.run()", 1000); // 윈도우가 close 되도록 1초만 쉬었다가
	} else {
		forPreview.run();
	}
};

/**
 * 주차 종류 선택
 */
var elementData;
doWeekTypeSelect = function(element) {
	var $element = jQuery(element);
	if(element.value != CD_COURSE_WEEK_TYPE_LECTURE) {
		$element.siblings(":input[name='activeElementTitles']").attr("readonly", true).addClass("disabled");
	} else {
		$element.siblings(":input[name='activeElementTitles']").attr("readonly", false).removeClass("disabled");
	}
	var count = 0; 
	var weekType = jQuery("#listElement").find("table").find("tr").find(":input[name='courseWeekTypeCds']");
	weekType.each(function(){
		if(element.value == CD_COURSE_WEEK_TYPE_MIDEXAM || element.value == CD_COURSE_WEEK_TYPE_MIDHOMEWORK || element.value == CD_COURSE_WEEK_TYPE_FINALEXAM || element.value == CD_COURSE_WEEK_TYPE_FINALHOMEWORK){
			if(element.value.indexOf("MID") != -1 && this.value.indexOf("MID") != -1 || element.value.indexOf("FINAL") != -1 && this.value.indexOf("FINAL") != -1){
				count++;
			}
		}
	});
	if(count > 1){
		$.alert({
			message : "<spring:message code="글:주차:이미등록되어있습니다"/>"
		});
		$element.val(elementData);
		return;
	}
};

/**
 * 주차 종류 변경확인
 */
doWeekTypeCheck = function(element) {
	var $element = jQuery(element);
	// 기존값으로 되돌리기
	elementData = element.value;
	
	if($element.siblings(":input[name='referenceSeqs']").val() > 0) {
		$.alert({
			message : "<spring:message code="글:주차:이미맵핑되어있습니다삭제후맵핑해주세요"/>"
		});
		$element.siblings("#weekDeletes$element").focus();
		return;
	}
};

/*
 * 주차 삭제
 */
doWeekClear = function(element){
	var $element = jQuery(element);
	$element.siblings(":input[name='activeElementTitles']").val("");
	$element.siblings(":input[name='referenceSeqs']").val("");
};
/**
 * 주차 일괄매핑 팝업
 */
doBrowseContents = function(){
	forBrowseContents.run();
};
/**
 * 주차 일괄매핑 선택 & 주차 목록 가져오기 
 */
doSelectContents = function(returnValue) {
	var form = UT.getById(forListMapping.config.formId);
	form.elements["contentsSeq"].value = returnValue.contentsSeq;
	forListMapping.run();
	/*
	if (returnValue.contentsSeq != "") {
		var $form = jQuery("#" + forListContentsElement.config.formId);
		$form.find(":input[name='contentsSeq']").val(returnValue.contentsSeq);
		forListContentsElement.run();
	}
	*/
};
/**
 * 주차 단일 매핑 팝업
 */
doBrowseOrganization = function(element){
	var $form = jQuery("#FormData");
	var $element = jQuery(element);
	var $text = $element.closest("table").find(":input[name=activeElementTitles]");
	var $browsing = jQuery("#browsing");
	var clazz = "selected";

	var $selected = $form.find("." + clazz);
	$selected.removeClass(clazz);
	
	var dialogOption = {
		title : "<spring:message code="글:콘텐츠:주차매핑"/>",
		width : 800,
		height : 600,
		resizable : false,
		draggable : true,
		modal : false,
		position : {
			of : jQuery(element), my : "right center", at : "left center"
		}, 
		close : function() {
			$text.removeClass(clazz);
		}
	};
	var $dialog = $browsing.dialog(dialogOption);

	$text.addClass(clazz);
	var iframe = UT.getById("browsing-iframe");
	if (typeof iframe.contentWindow.initPage !== "function") {
		var action = $.action();
		action.config.formId = "FormBrowseOrganization";
		action.config.url    = "<c:url value="/lcms/organization/list/iframe.do"/>";
		action.config.target = iframe.name;
		action.run();
	} 
};
/**
 * 주차 단일 매핑 선택
 */
doSelectOrganization = function(returnValue) {
	if (typeof returnValue === "object") {
		var $form = jQuery("#FormData");

		var exist = false;
		var $titles = $form.find(":input[name=activeElementTitles]").not(".selected");
		$titles.siblings(":input[name='referenceSeqs']").each(function() { 
			if (returnValue.organizationSeq == this.value) {
				exist = true;
				return false; // break
			}
	    });
		if (exist == true) {
			$.alert({message : "<spring:message code="글:주차:동일한데이터가이미존재합니다"/>"});	
		} else {
			var $selected = $form.find(":input[name=activeElementTitles]").filter(".selected");
			if ($selected.length > 0) {
				$selected.val(returnValue.title);
				$selected.siblings(":input[name='referenceSeqs']").val(returnValue.organizationSeq);
				UI.effectTransfer("browsing", $selected.attr("id"), "effectTransfer");
			}
		}
	}
};

/**
 * 주차 html
 */
doGetHtmlTemplateWeek = function() {
	var html = [];
	html.push("<div class='week-type'>");
	html.push("		<table class='tbl-detail'>");
	html.push("			<colgroup>");
	html.push("				<col style='width:7%;' />");
	html.push("				<col style='width:auto;' />");
	html.push("			</colgroup>");
	html.push("			<tbody>");
	html.push("			<tr>");
	html.push("				<th class='align-c' rowspan='2'>");
	html.push("					<input type='checkbox' name='checkkeys' onclick='FN.onClickCheckbox(this, \"checkButton\")' />");
	html.push("					<input type='hidden' name='courseActiveSeqs' />");
	html.push("					<input type='hidden' name='activeElementSeqs' />");
	html.push("					<input type='hidden' name='referenceTypeCds' />");
	html.push("				</th>");
	html.push("				<th>");
	html.push("					<div class='lybox-inner'>");
	html.push("						<input type='text' name='sortOrders' style='width:20px;' /><spring:message code='필드:주차:주차' />");
	html.push("						<a href='#' onclick='doBrowseElement(this)' class='btn black'><span class='small'><spring:message code='버튼:주차:주차매핑' /></span></a>");
	html.push("					</div>");
	html.push("				</th>");
	html.push("			</tr>");
	html.push("			<tr>");
	html.push("				<td>");
	html.push("					<select name='courseWeekTypeCds' onchange='doWeekTypeSelect(this)'>");
	html.push("						<aof:code type='option' codeGroup='COURSE_WEEK_TYPE' defaultSelected='" + CD_COURSE_WEEK_TYPE_LECTURE + "' />");
	html.push("					</select>");
	html.push("					<input type='text' name='activeElementTitles' style='width:70%;' value='{activeElementTitle}' />");
	html.push("					<a href='#' onclick='doWeekClear(this)'>x</a>");
	html.push("					<input type='hidden' name='referenceSeqs' style='width:30%;' value='{organizationSeq}' />");
	html.push("					<input type='hidden' name='oldReferenceSeqs' style='width:30%;' />");
	html.push("					<input type='text' name='startDtimes' id='startDtime' class='datepicker' style='width:80px;text-align:center;' readonly='readonly' />");
	html.push("					<spring:message code='글:주차:일부터' />");
	html.push("					<input type='text' name='endDtimes' id='endDtime' class='datepicker' style='width:80px;text-align:center;' readonly='readonly' />");
	html.push("					<spring:message code='글:주차:일까지' />");
	html.push("					<a href='#' onclick='doBrowseElement(this)' class='btn black'><span class='small'><spring:message code='버튼:주차:주차매핑' /></span></a>");
	html.push("				</td>");
	html.push("			</tr>");
	html.push("			</tbody>");
	html.push("		</table>");
	html.push("		<div class='clear'><br></div>");
	html.push("</div>");
	return html.join("");
};

/**
 * 파일업로드
 */
doUpload = function() {
	jQuery("#listElement").find(".uploader").each(function(){
		var $uploader = jQuery(this);
		var upload = [];
		upload.push({
			elementId : $uploader.attr("id"),
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputWidth : 260,	
				immediatelyUpload : false,
				successCallback : function(id, file) {
					jQuery("#"+id).closest("tr").find("#attachUploadInfos").val(UI.uploader.getUploadedData(swfu, id));
				}
			}
		});
		
		swfu = UI.uploader.generate(swfu, upload);	
	});
};

/**
 * 파일업로드 시작
 */
doStartUpload = function() {
	var isAppendedFiles = false;
	var count = jQuery("#listElement").find(".uploader").length;
	var isAppendedFiles = false;
	for (var i = 0; i <= count; i++) {
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
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfos']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
};

/**
 * 강의 OCW 상세화면 호출
 */
doOcwContents = function(mapPKs) {
	// 강의 OCW 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forOcwContents.config.formId);
	
	var form = UT.getById(forOcwContents.config.formId);
	var key_id = form.elements["courseActiveSeq"].value + "_" + form.elements["activeElementSeq"].value + "_" + form.elements["organizationSeq"].value + "_" + form.elements["itemSeq"].value;
	
	forOcwContents.config.containerId = "div_" + key_id;
	
	jQuery("#viewOFF_" + key_id).show();
	jQuery("#viewON_" + key_id).hide();
	
	// 강의 OCW 상세화면 실행
	forOcwContents.run();
};

/**
 * ocw 학습요소 수정 및 등록
 */
doOcwContentsUpdate = function(key_id){
	var forOcwContentsUpdate = $.action("submit", {formId : "FormUpdate_"+key_id});
	forOcwContentsUpdate.config.url             = "<c:url value="/univ/ocw/course/organization/contents/update.do"/>";
	forOcwContentsUpdate.config.target          = "hiddenframe";
	forOcwContentsUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forOcwContentsUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forOcwContentsUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forOcwContentsUpdate.config.fn.complete     = function() {};
	forOcwContentsUpdate.run();
};

/**
 * 강의 OCW 상세화면 닫기
 */
doOcwContentsClose = function(key_id){
	jQuery("#div_"+ key_id).html("");
	jQuery("#viewOFF_" + key_id).hide();
	jQuery("#viewON_" + key_id).show();
};

doOcwCommentPopup = function(mapPKs) {
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forOcwCommentPopup.config.formId);
	// 상세화면 실행
	forOcwCommentPopup.run();
};

doSetSwfu = function(key_id){
	var swfu = UI.uploader.create(function() {}, // completeCallback
			[{
				elementId : "uploader_img_" + key_id,
				postParams : {
					thumbnailWidth : 180,
					thumbnailHeight : 94,
					thumbnailCrop : "Y"
				},
				options : {
					uploadUrl : "<c:url value="/attach/image/save.do"/>",
					buttonImageUrl : '<aof:img type="print" src="btn/photo_22x22.png"/>',
					buttonWidth: 23,
					inputWidth : 0,	
					fileTypes : "*.jpg;*.gif;*.png",
	                fileTypesDescription : "Image Files",
					fileSizeLimit : "10 MB",
					fileUploadLimit : 1, // default : 1, 0이면 제한없음.
					inputHeight : 20, // default : 20
					immediatelyUpload : true,
					successCallback : function(id, file) {
						if (id == "uploader_img_" + key_id) {
							var form = UT.getById('FormUpdate_' + key_id);
							var fileInfo = file.serverData.fileInfo;
							form.elements["photo"].value = fileInfo.savePath + "/" + fileInfo.saveName;
							
							var $photo = jQuery("#ocw-photo-" + key_id);
							$photo.attr("src", imageContext + form.elements["photo"].value);
							$photo.siblings(".delete").show();
						}
					}
				}
			}]
		);
};


/**
 * 사진 삭제
 */
doDeletePhoto = function(key_id) {
	var form = UT.getById('FormUpdate_' + key_id);
	form.elements["photo"].value = "";
	
	var $photo = jQuery("#ocw-photo-" + key_id);
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
};

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"></c:param>
	</c:import>
	
	<div id="tabs"> 
		<ul class="ui-widget-header-tab-custom">
			<li id="tab1"><a href="javascript:void(0)" 
				onclick="javascript:doDetail({'ocwCourseActiveSeq' : '<c:out value="${param['ocwCourseActiveSeq']}" />'});"><spring:message code="글:상세정보" /></a>
			</li>
			<li id="tab2"><a href="javascript:void(0)" 
				onclick="javascript:doEditOrganization({'ocwCourseActiveSeq' : '<c:out value="${param['ocwCourseActiveSeq']}" />',
														'courseActiveSeq' : '<c:out value="${param['courseActiveSeq']}" />'});"><spring:message code="필드:개설과목:구성정보" /></a>
			</li>
		</ul>
	</div>
	
	<div style="display:none;">
		<c:import url="srchOcwCourse.jsp"/>
	</div>
	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeqs" value="${param['courseActiveSeq']}"/>
		<input type="hidden" name="activeElementSeqs" />
		<input type="hidden" name="referenceSeqs" value=""/>
		<input type="hidden" name="oldReferenceSeqs" value=""/>
		<input type="hidden" name="activeElementTitles" value=""/>
		<input type="hidden" name="referenceTypeCds" value="<c:out value="${CD_COURSE_ELEMENT_TYPE_ORGANIZATION}"/>"/>
		<input type="hidden" name="startDtimes" />
		<input type="hidden" name="endDtimes" />
		<input type="hidden" name="sortOrders" />
		<input type="hidden" name="courseWeekTypeCds" value="<c:out value="${CD_COURSE_WEEK_TYPE_LECTURE}"/>" />
		
	</form>
	
	<form name="FormOcwContents" id="FormOcwContents" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value=""/>
		<input type="hidden" name="activeElementSeq" value=""/>
		<input type="hidden" name="organizationSeq" value=""/>
		<input type="hidden" name="itemSeq" value=""/>
	</form>
	
	<form name="FormOcwComment" id="FormOcwComment" method="post" onsubmit="return false;">
		<input type="hidden" name="srchCommentTypeCd" value="ORGANIZATION"/>
		<input type="hidden" name="parentResizingYn" value="Y"/>
		<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${param['courseActiveSeq']}" />"/>
		<input type="hidden" name="srchItemSeq" value=""/>
	</form>
		
	<form id="FormBrowseContents" name="FormBrowseContents" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doSelectContents" />
	</form>

	<form id="FormListContentsElement" name="FormListContentsElement" method="post" onsubmit="return false;">
		<input type="hidden" name="contentsSeq"/>
	</form>

	<form id="FormBrowseOrganization" name="FormBrowseOrganization" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doSelectOrganization" />
	</form>
	
	<form name="FormLearning" id="FormLearning" method="post" onsubmit="return false;">
		<input type="hidden" name="organizationSeq" />
		<input type="hidden" name="itemSeq" />
		<input type="hidden" name="itemIdentifier" />
		<input type="hidden" name="courseId" />
		<input type="hidden" name="applyId" />
	</form>
	
	<form id="FormMappingContents" name="FormMappingContents" method="post" onsubmit="return false;">
		<input type="hidden" name="contentsSeq"/>
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>"/>
	</form>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	
	<c:set var="itemCount" value="0" />
	<div id="listElement">
	<c:forEach var="row" items="${list}" varStatus="i">
		<div class="week-type <c:out value="${row.element.courseWeekTypeCd ne CD_COURSE_WEEK_TYPE_LECTURE ? 'notlecture' : ''}"/>" sortOrder="${row.element.sortOrder}">
		<table class="tbl-detail"><!-- tbl-detail-row -->
			<colgroup>
				<col style="width:40px;" />
				<col style="width:auto;" />
			</colgroup>
			<tbody>
				<tr>
					<th class="align-c" rowspan="2">
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
						<input type="hidden" name="courseActiveSeqs" value="<c:out value="${row.element.courseActiveSeq}" />" />
						<input type="hidden" name="activeElementSeqs" value="<c:out value="${row.element.activeElementSeq}" />" />
						<input type="hidden" name="referenceTypeCds" value="<c:out value="${row.element.referenceTypeCd}" />" />
						<input type="hidden" name="startDtimes" value="<c:out value="${row.element.startDtime}" />" />
						<input type="hidden" name="endDtimes" value="<c:out value="${row.element.endDtime}" />" />
					</th>
					<th>
						<div class="lybox-inner">
							<input type="text" name="sortOrders" style="width:20px;" value="<c:out value="${row.element.sortOrder}" />" /><spring:message code="필드:주차:차시" />
							<a href="javascript:void(0)" onclick="doBrowseOrganization(this)" class="btn black"><span class="small"><spring:message code="버튼:주차:차시매핑" /></span></a>
						</div>
					</th>
				</tr>
				<tr>
					<td>
						<input type="hidden" name="courseWeekTypeCds" value="<c:out value="${CD_COURSE_WEEK_TYPE_LECTURE}"/>">
						<input type="text" name="activeElementTitles" id="activeElementTitles-<c:out value="${i.index}"/>" style="width:50%;" value="<c:out value="${row.element.activeElementTitle}" />" <c:if test="${row.element.courseWeekTypeCd ne CD_COURSE_WEEK_TYPE_LECTURE }"> readonly="readonly" </c:if> />
						<a href="javascript:void(0)" onclick="doWeekClear(this)" id="weekDeletes">x</a>
						<input type="hidden" name="referenceSeqs" style="width:30%;" value="<c:out value="${row.element.referenceSeq}" />" />
						<input type="hidden" name="oldReferenceSeqs" style="width:30%;" value="<c:out value="${row.element.referenceSeq}" />" />
					</td>
				</tr>
			</tbody>
		</table>
		<c:if test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_LECTURE and !empty row.element.referenceSeq and !empty row.element.itemList}">
			<c:forEach var="row1" items="${row.element.itemList}" varStatus="i">
				<table id="itemTable" class="tbl-detail-row add">
					<colgroup>
						<col style="width:70px;" />
						<col style="width:auto;" />
						<col style="width:33%;" />
						<col style="width:11%;" />
						<col style="width:11%;" />
					</colgroup>
					<thead>
						<tr>
							<th><spring:message code="필드:주차:강" /></th>
							<th><spring:message code="필드:주차:교시강제목" /></th>
							<th><spring:message code="필드:주차:학습보조자료" /></th>
							<th><spring:message code="필드:주차:댓글" /></th>
							<th><spring:message code="필드:주차:미리보기" /></th>
						</tr>
					</thead>
					<tbody>
					<tr>
						<td>
							<c:set var="key_id"><c:out value="${row.element.courseActiveSeq}"/>_<c:out value="${row.element.activeElementSeq}" />_<c:out value="${row1.item.organizationSeq}"/>_<c:out value="${row1.item.itemSeq}"/></c:set>
							<c:out value="${row1.item.sortOrder+1 }" /><spring:message code="필드:주차:강" /> <br/>
							<span id="viewON_<c:out value="${key_id}"/>" style="font-weight: bold;">
								<a href="javascript:void(0)" 
								   onclick="javascript:doOcwContents({'courseActiveSeq' : '<c:out value="${row.element.courseActiveSeq}"/>',
								   									  'activeElementSeq' : '<c:out value="${row.element.activeElementSeq}" />',
																	  'organizationSeq' : '<c:out value="${row1.item.organizationSeq}"/>',
																	  'itemSeq' : '<c:out value="${row1.item.itemSeq}"/>'
																	});">
									<spring:message code="버튼:주차:설정" />▼
								</a>
							</span>
							<span id="viewOFF_<c:out value="${key_id}"/>" style="font-weight: bold; display: none;">
								<a href="javascript:void(0)" onclick="javascript:doOcwContentsClose('<c:out value="${key_id}"/>');">
									<spring:message code="버튼:주차:설정" />▲
								</a>
							</span>
						</td>
						<td class="align-l"><input type="text" style="width:300px;" value="<c:out value="${row1.item.title }"/>" readonly="readonly" /></td>
						<td class="align-l">
							<input type="hidden" name="organizationItemSeqs" value="<c:out value="${row1.activeItem.organizationItemSeq }" />" />
							<input type="hidden" name="activeSeqs" value="<c:out value="${row.element.courseActiveSeq }" />" />
							<input type="hidden" name="elementSeqs" value="<c:out value="${row.element.activeElementSeq }" />" />
							<input type="hidden" name="organizationSeqs" value="<c:out value="${row1.item.organizationSeq }" />" />
							<input type="hidden" name="itemSeqs" value="<c:out value="${row1.item.itemSeq }" />" />
							<input type="hidden" name="attachUploadInfos" id="attachUploadInfos" />
							<input type="hidden" name="attachDeleteInfos" id="attachDeleteInfos" />
							<div id="uploader-<c:out value="${itemCount}"/>" class="uploader">
								<c:if test="${!empty row1.activeItem.attachList}">
									<c:forEach var="row" items="${row1.activeItem.attachList}" varStatus="i">
										<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
											<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
										</div>
									</c:forEach>
								</c:if>
							</div>
							<c:if test="${!empty row1.activeItem.attachList}">
								<c:forEach var="row" items="${row1.activeItem.attachList}" varStatus="i">
									<div class="vspace"></div>
									<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/><aof:img src="icon/ico_file.gif"/></a>
								</c:forEach>
							</c:if>
							
						</td>
						<td>
							<a href="javascript:void(0)" onclick="doOcwCommentPopup({'srchItemSeq' : '${row1.item.itemSeq}'});" class="btn gray"><span class="small"><spring:message code="버튼:주차:댓글보기" /></span></a>
						</td>
						<td><a href="javascript:void(0)" onclick="doPreview({'organizationSeq' : '<c:out value="${row1.item.organizationSeq}"/>'
							,'itemSeq' : '${row1.item.itemSeq}'
							,'itemIdentifier' : '${row1.item.identifier}'
							,'courseId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
							,'applyId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
							});" class="btn gray"><span class="small"><spring:message code="버튼:미리보기" /></span></a></td>
					</tr>
					</tbody>
				</table>
				
				<c:set var="itemCount" value="${itemCount + 1 }" />
				
				<div id="div_<c:out value="${key_id}"/>"></div>
			</c:forEach>
		</c:if>
		<div class="vspace"></div>
		</div>
	</c:forEach>
	<c:if test="${empty list}">
		<table class="tbl-detail"><!-- tbl-detail-row -->
			<colgroup>
				<col style="width:40px;" />
				<col style="width:auto;" />
			</colgroup>
			<tbody>
				<tr>
					<td colspan="2" class="align-c">
						<spring:message code="글:데이터가없습니다" />
					</td>	
				</tr>
			</tbody>
		</table>
	</c:if>
	</div>
	</form>

	<div id="browsing" class="browsing" style="display:none;">
		<iframe id="browsing-iframe" name="browsing-iframe" src="about:blank" frameborder="no" scrolling="no" style="width:100%; height:95%;"></iframe>
	</div>

	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButton" style="display:none;">
			<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
		</div>
		<div class="lybox-btn-r">
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
			<a href="javascript:void(0)" onclick="doBrowseContents()" class="btn blue"><span class="mid"><spring:message code="버튼:주차:일괄매핑" /></span></a>
			<a href="javascript:void(0)" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:주차:차시추가" /></span></a>
			<a href="javascript:void(0)" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>	
		</c:if>
		<a href="#" class="btn blue" onclick="doList();"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
</body>
</html>