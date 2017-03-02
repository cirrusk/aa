<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"               value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_LECTURE"         value="${aoffn:code('CD.COURSE_WEEK_TYPE.LECTURE')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_MIDEXAM"         value="${aoffn:code('CD.COURSE_WEEK_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_MIDHOMEWORK"     value="${aoffn:code('CD.COURSE_WEEK_TYPE.MIDHOMEWORK')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_FINALEXAM"       value="${aoffn:code('CD.COURSE_WEEK_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_WEEK_TYPE_FINALHOMEWORK"   value="${aoffn:code('CD.COURSE_WEEK_TYPE.FINALHOMEWORK')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ORGANIZATION" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ORGANIZATION')}"/>

<html decorator="<c:out value="${decorator}"/>">
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COURSE_TYPE_ALWAYS = "<c:out value="${CD_COURSE_TYPE_ALWAYS}"/>";
var CD_COURSE_WEEK_TYPE_LECTURE = "<c:out value="${CD_COURSE_WEEK_TYPE_LECTURE}"/>";
var CD_COURSE_WEEK_TYPE_MIDEXAM = "<c:out value="${CD_COURSE_WEEK_TYPE_MIDEXAM}"/>";
var CD_COURSE_WEEK_TYPE_FINALEXAM = "<c:out value="${CD_COURSE_WEEK_TYPE_FINALEXAM}"/>";
var CD_COURSE_WEEK_TYPE_FINALHOMEWORK = "<c:out value="${CD_COURSE_WEEK_TYPE_FINALHOMEWORK}"/>";

var forListData = null;
var forInsert = null;
var forUpdate = null;
var forBrowseContents = null; // 일괄(콘텐츠그룹)매핑 찾기(layer)
var forBrowseOrganization = null; // 단일(차시)매핑 찾기(layer)
var forPreview  = null;
var forListContentsElement = null;
var forListMapping = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] datepicker
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
	
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
	forListData = $.action();
	forListData.config.formId = "FormList";
	forListData.config.url    = "<c:url value="/univ/course/active/oraganization/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"});
	forInsert.config.url             = "<c:url value="/univ/course/active/element/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:추가하시겠습니까"/>";
	forInsert.config.message.success = "<spring:message code="글:추가되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};
	
	forUpdate = $.action("submit", {formId : "FormData"});
	forUpdate.config.url             = "<c:url value="/univ/course/active/element/insert.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doStartUpload;
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	//setValidate();
	
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
	forListMapping.config.url    = "<c:url value="/univ/course/active/oraganization/mapping/list.do"/>";

};

/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListData.run();
};

/**
 * 수정
 */
doUpdate = function() {
	forUpdate.run();
};

setValidate = function() {
	var courseTypeCd = "<c:out value="${param['shortcutCourseTypeCd']}"/>";
	var start = "startDtimes";
	var end = "endDtimes";
	
	if(courseTypeCd == CD_COURSE_TYPE_ALWAYS){
		start = "startDays";
		end = "endDays";
	}
	
	forUpdate.validator.set(function() {
		var form = UT.getById(forUpdate.config.formId);	
		// 주차기간 체크
		if(typeof(form.elements["referenceSeqs"]) != 'undefined' ) {
			if(typeof(form.elements["referenceSeqs"].length) != 'undefined') {
				for(var i = 0; i < form.elements["referenceSeqs"].length; i++){
					if(form.elements["referenceSeqs"][i].value != "" && form.elements["referenceSeqs"][i].value > 0) {
						if(form.elements[start][i].value == "" || form.elements[end][i].value == "") {
							$.alert({
								message : "<spring:message code="글:주차:주차기간을설정해주세요"/>"
							});
							return false;
						} else {
							if(form.elements[start][i].value > form.elements[end][i].value){
								$.alert({
									message : "<spring:message code="글:주차:시작일이종료일체크"/>"
								});
								return false;
							}
						}
					}
				}
			} else {
				if(form.elements["referenceSeqs"].value != "" && form.elements["referenceSeqs"].value > 0) {
					if(form.elements[start].value == "" || form.elements[end].value == "") {
						$.alert({
							message : "<spring:message code="글:주차:주차기간을설정해주세요"/>"
						});
						return false;
					} else {
						if(form.elements[start].value > form.elements[end].value){
							$.alert({
								message : "<spring:message code="글:주차:시작일이종료일체크"/>"
							});
							return false;
						}
					}
				}
			}
			
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
		} else {
			return false;
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
				doList();
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
	$element.siblings(":input[name='referenceSeqs']").val("0");
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
				jQuery("#browsing").dialog("close");
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
	//html.push("						<a href='#' onclick='doBrowseElement(this)' class='btn black'><span class='small'><spring:message code='버튼:주차:주차매핑' /></span></a>");
	html.push("					</div>");
	html.push("				</th>");
	
	html.push("				<th>");
	html.push("				<th style='text-align: right;'>강사명 <input type='text' name='lectureNames'/>' style='width: 80px;'/></th>");
	html.push("				</th>");
	
	html.push("			</tr>");
	html.push("			<tr>");
	html.push("				<td colspan='2'>");
	//html.push("					<select name='courseWeekTypeCds' onchange='doWeekTypeSelect(this)'>");
	//html.push("						<aof:code type='option' codeGroup='COURSE_WEEK_TYPE' defaultSelected='" + CD_COURSE_WEEK_TYPE_LECTURE + "' />");
	//html.push("					</select>");
	html.push("					<input type='hidden' name='courseWeekTypeCds' value='"+CD_COURSE_WEEK_TYPE_LECTURE+"'/>");
	html.push("					<input type='text' name='activeElementTitles' style='width:70%;' value='{activeElementTitle}' />");
	html.push("					<a href='#' onclick='doWeekClear(this)'>x</a>");
	html.push("					<input type='hidden' name='referenceSeqs' style='width:30%;' value='{organizationSeq}' />");
	html.push("					<input type='hidden' name='oldReferenceSeqs' style='width:30%;' />");
	//html.push("					<input type='text' name='startDtimes' id='startDtime' class='datepicker' style='width:80px;text-align:center;' readonly='readonly' />");
	//html.push("					<spring:message code='글:주차:일부터' />");
	//html.push("					<input type='text' name='endDtimes' id='endDtime' class='datepicker' style='width:80px;text-align:center;' readonly='readonly' />");
	//html.push("					<spring:message code='글:주차:일까지' />");
	//html.push("					<a href='#' onclick='doBrowseElement(this)' class='btn black'><span class='small'><spring:message code='버튼:주차:주차매핑' /></span></a>");
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
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>

<style type="text/css">
.selected {background-color:yellow;}
.effectTransfer {background-color:#FFFF6C;}
</style>
</head>
<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="../../include/commonCourseActive.jsp"></c:import>

	<c:set var="elementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_ORGANIZATION}"/>
	<c:import url="../include/commonCourseActiveElement.jsp">
		<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>
	<%--
	<c:import url="../include/commonCourseActiveEvaluate.jsp">
		<c:param name="selectedElementTypeCd" value="${elementTypeCd}"/>
	</c:import>
	--%>
	<form id="FormList" name="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		
		<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    	<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeqs" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="activeElementSeqs" />
		<input type="hidden" name="referenceSeqs" value=""/>
		<input type="hidden" name="oldReferenceSeqs" value=""/>
		<input type="hidden" name="activeElementTitles" value=""/>
		<input type="hidden" name="referenceTypeCds" value="<c:out value="${CD_COURSE_ELEMENT_TYPE_ORGANIZATION}"/>"/>
		<input type="hidden" name="startDtimes" />
		<input type="hidden" name="endDtimes" />
		<input type="hidden" name="startDays" />
		<input type="hidden" name="endDays" />
		<input type="hidden" name="sortOrders" />
		<input type="hidden" name="courseWeekTypeCds" value="<c:out value="${CD_COURSE_WEEK_TYPE_LECTURE}"/>" />
		
		<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    	<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
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
		
		<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    	<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>

	<div class="lybox-title mt10">
		<h4 class="section-title"><spring:message code="필드:주차:구성항목" /></h4>
	</div>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	<c:set var="itemCount" value="0" />
	<div id="listElement">
	<c:forEach var="row" items="${list}" varStatus="i">
		<div class="week-type <c:out value="${row.element.courseWeekTypeCd ne CD_COURSE_WEEK_TYPE_LECTURE ? 'notlecture' : ''}"/>" sortOrder="${row.element.sortOrder}">
		<table class="tbl-detail"><!-- tbl-detail-row -->
			<colgroup>
				<col style="width:40px;" />
				<col style="width:auto;" />
				<col style="width:150px;" />
			</colgroup>
			<tbody>
				<tr>
					<th class="align-c" rowspan="2">
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
						<input type="hidden" name="courseActiveSeqs" value="<c:out value="${row.element.courseActiveSeq }" />" />
						<input type="hidden" name="activeElementSeqs" value="<c:out value="${row.element.activeElementSeq }" />" />
						<input type="hidden" name="referenceTypeCds" value="<c:out value="${row.element.referenceTypeCd }" />" />
					</th>
					<th>
						<div class="lybox-inner">
							<input type="text" name="sortOrders" style="width:20px;text-align: center;" value="<c:out value="${row.element.sortOrder }" />" />
							<spring:message code="필드:주차:주차" />
							<%-- <a href="javascript:void(0)" onclick="doBrowseOrganization(this)" class="btn black"><span class="small"><spring:message code="버튼:주차:주차매핑" /></span></a>--%>
						</div>
					</th>
					<th style="text-align: right;border-left: 0px;">
						강사명 <input type="text" name="lectureNames" value="<c:out value="${row.element.lectureName}"/>" style="width: 80px;text-align: center;"/>
					</th>
				</tr>
				<tr>
					<td colspan="2">
						<%--
						<select name="courseWeekTypeCds" onchange="doWeekTypeSelect(this)" onclick="doWeekTypeCheck(this)">
							<aof:code type="option" codeGroup="COURSE_WEEK_TYPE" selected="${row.element.courseWeekTypeCd }" defaultSelected="${CD_COURSE_WEEK_TYPE_LECTURE}" />
						</select>
						 --%>
						 
						<input type="hidden" name="courseWeekTypeCds" value="COURSE_WEEK_TYPE::LECTURE"/>
						<input type="text" name="activeElementTitles" id="activeElementTitles-<c:out value="${i.index}"/>" style="width:70%;" value="<c:out value="${row.element.activeElementTitle }" />" <c:if test="${row.element.courseWeekTypeCd ne CD_COURSE_WEEK_TYPE_LECTURE }"> readonly="readonly" </c:if> />
						<a href="javascript:void(0)" onclick="doWeekClear(this)" id="weekDeletes">x</a>
						
						<input type="hidden" name="referenceSeqs" style="width:30%;" value="<c:out value="${row.element.referenceSeq }" />" />
						<input type="hidden" name="oldReferenceSeqs" style="width:30%;" value="<c:out value="${row.element.referenceSeq }" />" />
						<%--
						<c:choose>
							<c:when test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
								<input type="text" name="startDays" value="<c:out value="${row.element.startDay }"/>" style="width: 25px" maxlength="3" />
								<spring:message code="글:주차:일부터" />
								<input type="text" name="endDays" value="<c:out value="${row.element.endDay }"/>" style="width: 25px" maxlength="3" />
								<spring:message code="글:주차:일까지" />
							</c:when>
							<c:otherwise>
								<input type="text" name="startDtimes" id="startDtime<c:out value="${i.index}"/>" value="<aof:date datetime="${row.element.startDtime}"/>" class="datepicker" style="width:80px;text-align:center;" readonly="readonly" />
								<spring:message code="글:주차:일부터" />
								<input type="text" name="endDtimes" id="endDtime<c:out value="${i.index}"/>" value="<aof:date datetime="${row.element.endDtime}"/>" class="datepicker" style="width:80px;text-align:center;" readonly="readonly" />
								<spring:message code="글:주차:일까지" />
							</c:otherwise>
						</c:choose>
						 --%>
					</td>
				</tr>
			</tbody>
		</table>
		<c:if test="${row.element.courseWeekTypeCd eq CD_COURSE_WEEK_TYPE_LECTURE and !empty row.element.referenceSeq and !empty row.element.itemList }">
		<table id="itemTable" class="tbl-detail-row add">
			<colgroup>
				<col style="width:12%;" />
				<col style="width:auto;" />
				<col style="width:33%;" />
				<col style="width:11%;" />
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="필드:주차:교시강" /></th>
					<th><spring:message code="필드:주차:교시강제목" /></th>
					<th><spring:message code="필드:주차:학습보조자료" /></th>
					<th><spring:message code="필드:주차:미리보기" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row1" items="${row.element.itemList}" varStatus="i">
				<tr>
					<td><c:out value="${row1.item.sortOrder+1 }" /><spring:message code="필드:주차:교시" /></td>
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
					<td><a href="javascript:void(0)" onclick="doPreview({'organizationSeq' : '<c:out value="${row1.item.organizationSeq}"/>'
						,'itemSeq' : '${row1.item.itemSeq}'
						,'itemIdentifier' : '${row1.item.identifier}'
						,'courseId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
						,'applyId' : '-1' <%-- 관리자의 디버깅모드 미리보기 --%>
						});" class="btn gray"><span class="small"><spring:message code="버튼:미리보기" /></span></a></td>
				</tr>
				<c:set var="itemCount" value="${itemCount + 1 }" />
			</c:forEach>
			</tbody>
		</table>
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
			<%--<a href="javascript:void(0)" onclick="doBrowseContents()" class="btn blue"><span class="mid"><spring:message code="버튼:주차:일괄매핑" /></span></a> --%>
			<a href="javascript:void(0)" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:주차:주차추가" /></span></a>
			<a href="javascript:void(0)" onclick="doUpdate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
		</div>
	</div>
	
</body>
</html>