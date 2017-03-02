<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE"     value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_001"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.001')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_003"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"       value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>
<c:set var="CD_EXAM_ITEM_DIFFICULTY_003" value="${aoffn:code('CD.EXAM_ITEM_DIFFICULTY.003')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_V"        value="${aoffn:code('CD.EXAM_ITEM_ALIGN.V')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_EXAM_ITEM_TYPE_001 = "<c:out value="${CD_EXAM_ITEM_TYPE_001}"/>";
var CD_EXAM_ITEM_TYPE_002 = "<c:out value="${CD_EXAM_ITEM_TYPE_002}"/>";
var CD_EXAM_ITEM_TYPE_003 = "<c:out value="${CD_EXAM_ITEM_TYPE_003}"/>";
var CD_EXAM_ITEM_TYPE_004 = "<c:out value="${CD_EXAM_ITEM_TYPE_004}"/>";
var CD_EXAM_ITEM_TYPE_005 = "<c:out value="${CD_EXAM_ITEM_TYPE_005}"/>";
var CD_EXAM_ITEM_TYPE_006 = "<c:out value="${CD_EXAM_ITEM_TYPE_006}"/>";

var forListdata = null;
var forInsert   = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. uploader
	swfu = UI.uploader.create(function() { // completeCallback
		forInsert.run("continue");
	});	

	doChangeItemType();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exam/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/exam/item/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doStartUpload;
	forInsert.config.fn.complete     = function() {
		$layer.dialog("close");
	};

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:문항제목"/>",
		name : "examItemTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 1000
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:난이도"/>",
		name : "examItemDifficultyCd",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:첨삭기준"/>",
		name : "examItemComment",
		check : {
			maxlength : 1000
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:문항유형"/>",
		name : "examItemTypeCd",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:보기"/>",
		name : "examExampleTitles",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:정답"/>",
		name : "correctAnswerRadio",
		data : ["!null","trim"],
		when : function() {
			var form = UT.getById(forInsert.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_001 || examItemType == CD_EXAM_ITEM_TYPE_003) ? true : false;
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:정답"/>",
		name : "correctAnswerCheckbox",
		data : ["!null","trim"],
		when : function() {
			var form = UT.getById(forInsert.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_002) ? true : false;
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:정답"/>",
		name : "correctAnswer",
		data : ["!null","trim"],
		check : {
			maxlength : 1000
		},
		when : function() {
			var form = UT.getById(forInsert.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_004) ? true : false;
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:유사정답"/>",
		name : "similarAnswer",
		check : {
			maxlength : 1000
		},
		when : function() {
			var form = UT.getById(forInsert.config.formId);
			var examItemType = form.elements["examItemTypeCd"].value;
			return (examItemType == CD_EXAM_ITEM_TYPE_004) ? true : false;
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:시험:파일경로"/>",
		name : "examItemFilePath",
		data : ["!space"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
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
doInsert = function() { 
	forInsert.run();
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
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
	var form = UT.getById(forInsert.config.formId);
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
	var $form = jQuery("#" + forInsert.config.formId);
	var $select = $form.find(":input[name='examItemTypeCd']");

	jQuery(".example").each(function(){
		var $this = jQuery(this); 
		if ($this.hasClass($select.val())) {
			$this.show();
		} else {
			$this.hide();
		}
		if (typeof $this.attr("checked") !== "undefined") {
			$this.attr("checked", false);	
		}
	});
	
	switch($select.val()) {
	case CD_EXAM_ITEM_TYPE_003:
		$form.find(":input[name='exampleCount']").val("2");
		$form.find(":input[name='examExampleTitles']").each(function(index) {
			if (index == 0) {
				this.value = "O";
			} else if (index == 1) {
				this.value = "X";
			} else {
				this.value = "";
			}
		});
		jQuery("#examExample").show();
		doChangeExampleCount(2);
		break;
	case CD_EXAM_ITEM_TYPE_001:
	case CD_EXAM_ITEM_TYPE_002:
		$form.find(":input[name='exampleCount']").val("5");
		doChangeExampleCount(5);
		jQuery("#examExample").show();
		break;
	case CD_EXAM_ITEM_TYPE_004:
		$form.find(":input[name='exampleCount']").val("0");
		jQuery("#examExample").show();
		doChangeExampleCount(0);
		break;
	case CD_EXAM_ITEM_TYPE_005:
	case CD_EXAM_ITEM_TYPE_006:	
		$form.find(":input[name='exampleCount']").val("0");
		jQuery("#examExample").hide();
		doChangeExampleCount(0);
		break;
	}
	doChangeUploader();
};
/**
 * 보기수 변경
 */
doChangeExampleCount = function(count) {
	if (typeof count !== "number") { 
		var $form = jQuery("#" + forInsert.config.formId);
		var $select = $form.find(":input[name='exampleCount']");
		count = $select.val();
		count = parseInt(count, 10);
	}

	jQuery("#examples").find("ul").each(function(index){
		var $this = jQuery(this);
		if (index < count) {
			$this.show();
			$this.find(":input").attr("disabled", false);
			$this.find(".uploader").each(function(){
				var $uploader = jQuery(this);
				doChangeUploadType($uploader.siblings(".filePathType"));
			});
		} else {
			$this.hide();
			$this.find(":input").attr("disabled", true);
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
			jQuery("#" + forInsert.config.formId + " :input[name='examExampleCorrectYns']").each(function(i) {
				this.value = (i == (index - 1)) ? "Y" : "N";
			});
		} else {
			jQuery("#" + forInsert.config.formId + " :input[name='examExampleCorrectYns']").each(function() {
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
	if ($select.val() == "upload") {
		$uploader.html("");
		$filePath.hide().find("input").val("");
		var upload = [];
		switch($fileType.val()) {
		case "image":
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
		case "video":
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
		case "audio":
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
		$filePath.show().find("input").val("");
	}
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

	<c:set var="filePathType">upload=<spring:message code="글:시험:업로드"/>,path=<spring:message code="필드:시험:파일경로"/></c:set>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="examSeq" value="<c:out value="${courseExam.examSeq}"/>">
	<input type="hidden" name="examItemSortOrder" value="<c:out value="${courseExam.examItemSortOrder}"/>">
	<table class="detail">
	<colgroup>
		<col style="width: 90px" />
		<col/>
		<col style="width: 90px" />
		<col style="width: 200px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:시험:문항제목"/></th>
			<td style="border-right:none;"><textarea name="examItemTitle" style="width:90%; height:100%"></textarea></td>
			<td style="border-left:none;border-right:none;">&nbsp;</td>
			<td style="border-left:none;">&nbsp;</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문항해설"/></th>
			<td style="border-right:none;"><textarea name="examItemDescription" style="width:90%; height:100%"></textarea></td>
			<td style="border-left:none;border-right:none;">&nbsp;</td>
			<td style="border-left:none;">&nbsp;</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:첨삭기준"/></th>
			<td><textarea name="examItemComment" style="width:90%; height:100%"></textarea></td>
			<th><spring:message code="필드:시험:난이도"/></th>
			<td>
				<select name="examItemDifficultyCd">
					<aof:code type="option" codeGroup="EXAM_ITEM_DIFFICULTY" defaultSelected="${CD_EXAM_ITEM_DIFFICULTY_003}"/>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:시험:문항파일"/></th>
			<td>
				<select name="examItemFileTypeCd" class="fileType" onchange="doChangeUploader(this)">
					<aof:code type="option" codeGroup="EXAM_FILE_TYPE" defaultSelected="${CD_EXAM_FILE_TYPE_IMAGE}"/>
				</select>
				<select name="examItemFilePathType" class="filePathType" onchange="doChangeUploadType(this)">
					<aof:code type="option" codeGroup="${filePathType}" defaultSelected="upload"/>
				</select>
				<div class="filePath"><c:out value="${aoffn:config('upload.context.exam')}"/><input type="text" name="examItemFilePath" style="width:60%;"></div>
				<div id="uploader-0" class="uploader"></div>
			</td>
			<th><spring:message code="필드:시험:문항유형"/></th>
			<td>
				<select name="examItemTypeCd" onchange="doChangeItemType(this)">
					<aof:code type="option" codeGroup="EXAM_ITEM_TYPE" defaultSelected="${CD_EXAM_ITEM_TYPE_001}" />
				</select>
			</td>
		</tr>
		<tr id="examExample">
			<td colspan="4">
				<ul class="ul">
					<li id="selectCount" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>" style="line-height:25px;float:left;">
						<spring:message code="필드:시험:보기수"/>&nbsp;&nbsp;
						<select name="exampleCount" onchange="doChangeExampleCount()" style="width:50px;">
							<aof:code type="option" codeGroup="2=2,3=3,4=4,5=5" defaultSelected="5"/>
						</select>
					</li>
					<li class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003}"/>">
						<select name="examItemAlignCd">
							<aof:code type="option" codeGroup="EXAM_ITEM_ALIGN" defaultSelected="${CD_EXAM_ITEM_ALIGN_V}" selected="${courseExam.examItemAlignCd}"/>
						</select>
					</li>
				</ul>
				<ul class="ul">
					<li class="li column1 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003}"/>"><spring:message code="필드:시험:정답"/></li>
					<li class="li column2 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003}"/>"><spring:message code="필드:시험:보기"/></li>
					<li class="li column3 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>"><spring:message code="필드:시험:보기파일"/></li>
				</ul>
				<ul class="ul">
					<li class="li column4 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>"><spring:message code="필드:시험:정답"/></li>
					<li class="li column2 textLeft example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>">
						<input type="text" name="correctAnswer" style="width:320px;">
					</li>
				</ul>
				<ul class="ul">
					<li class="li column4 lihead example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>"><spring:message code="필드:시험:유사정답"/></li>
					<li class="li column2 textLeft example <c:out value="${CD_EXAM_ITEM_TYPE_004}"/>">
						<input type="text" name="similarAnswer" style="width:320px;">
						<div class="comment"><spring:message code="글:시험:콤마를구분자로이용하여입력하십시오"/></div>
					</li>
				</ul>
				<div id="examples">
					<c:forEach var="row" begin="1" end="5" step="1" varStatus="i">
						<ul class="ul">
							<li class="li column1 example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003}"/>">
								<input type="radio" name="correctAnswerRadio" value="<c:out value="${i.count}"/>"  
									onclick="doChangeCorrectYn(this)" 
									class="example <c:out value="${CD_EXAM_ITEM_TYPE_001}"/> _space_ <c:if test="${row eq 1 or row eq 2}"><c:out value="${CD_EXAM_ITEM_TYPE_003}"/></c:if>">
								<input type="checkbox" name="correctAnswerCheckbox" value="<c:out value="${i.count}"/>"
									onclick="doChangeCorrectYn(this)" 
									class="example <c:out value="${CD_EXAM_ITEM_TYPE_002}"/>">
								<input type="hidden" name="examExampleCorrectYns" value="N"/>
								<input type="hidden" name="examExampleSortOrders" value="<c:out value="${i.count}"/>">
							</li>
							<li class="li column2 textLeft example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002} ${CD_EXAM_ITEM_TYPE_003}"/>">
								<textarea name="examExampleTitles" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>" style="width:90%; height:35px;"></textarea>
								<c:if test="${row eq 1}"><span class="example <c:out value="${CD_EXAM_ITEM_TYPE_003}"/>">O</span></c:if>
								<c:if test="${row eq 2}"><span class="example <c:out value="${CD_EXAM_ITEM_TYPE_003}"/>">X</span></c:if>
							</li>
							<li class="li column3 textLeft example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/>"> 
								<select name="examExampleFileTypeCds"  class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/> fileType" onchange="doChangeUploader(this)">
									<aof:code type="option" codeGroup="EXAM_FILE_TYPE" defaultSelected="image"/>
								</select>
								<select name="examExampleFilePathTypes" class="filePathType" onchange="doChangeUploadType(this)">
									<aof:code type="option" codeGroup="${filePathType}" defaultSelected="upload" />
								</select>
								<div class="filePath"><c:out value="${aoffn:config('upload.context.exam')}"/><input type="text" name="examExampleFilePaths" style="width:60%;"></div>
								<div id="uploader-<c:out value="${row}"/>" class="example <c:out value="${CD_EXAM_ITEM_TYPE_001} ${CD_EXAM_ITEM_TYPE_002}"/> uploader"></div>
							</li>
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
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doCancel();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>
	
</body>
</html>