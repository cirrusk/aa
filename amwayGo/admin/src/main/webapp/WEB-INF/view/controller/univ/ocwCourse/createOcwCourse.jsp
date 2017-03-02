<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_OCW"         value="${aoffn:code('CD.CATEGORY_TYPE.OCW')}"/>
<c:set var="CD_COURSE_ACTIVE_STATUS_OPEN" value="${aoffn:code('CD.COURSE_ACTIVE_STATUS.OPEN')}"/>

<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_OCW = "<c:out value="${CD_CATEGORY_TYPE_OCW}"/>";

var forListdata = null;
var forInsert   = null;
var forProfLayer   = null;
var forCourseActivePopup = null;
var swfu1 = null;
var swfu2 = null;
var swfu3 = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";

initPage = function() {
	// 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	//카테고리 select 설정
    BrowseCategory.create({
        "categoryTypeCd" : CD_CATEGORY_TYPE_OCW,
        "callback" : "doSetCategorySeq",
        "selectedSeq" : "3",
        "appendToId" : "categoryStep",
        "selectOption" : "regist"
    });
    
	// uploader
	swfu1 = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader_file",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);
	swfu2 = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader_img1",
			postParams : {
				thumbnailWidth : 236,
				thumbnailHeight : 216,
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
					if (id == "uploader_img1") {
						var form = UT.getById(forInsert.config.formId);
						var fileInfo = file.serverData.fileInfo;
						form.elements["photo1"].value = fileInfo.savePath + "/" + fileInfo.saveName;
						
						var $photo = jQuery("#ocw-photo1");
						$photo.attr("src", imageContext + form.elements["photo1"].value);
						$photo.siblings(".delete").show();
					}
				}
			}
		}]
	);
	swfu3 = UI.uploader.create(function() {}, // completeCallback
			[{
				elementId : "uploader_img2",
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
						if (id == "uploader_img2") {
							var form = UT.getById(forInsert.config.formId);
							var fileInfo = file.serverData.fileInfo;
							form.elements["photo2"].value = fileInfo.savePath + "/" + fileInfo.saveName;
							
							var $photo = jQuery("#ocw-photo2");
							$photo.attr("src", imageContext + form.elements["photo2"].value);
							$photo.siblings(".delete").show();
						}
					}
				}
			}]
		);
	
	
    // datepicker
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/ocw/course/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = function(success) {
		
		var splitValue = success.split(",");
		doEditOrganization({'ocwCourseActiveSeq' : splitValue[0],
			'courseActiveSeq' : splitValue[1]});
	};
	
	forProfLayer = $.action("layer");
	forProfLayer.config.formId         = "FormBrowseProf";
	forProfLayer.config.url            = "<c:url value="/member/prof/list/popup.do"/>";
	forProfLayer.config.options.width  = 700;
	forProfLayer.config.options.height = 500;
	forProfLayer.config.options.title  = "<spring:message code="필드:멤버:교수선택"/>";
	
	forEditOrganization = $.action();
	forEditOrganization.config.formId = "FormDetail";
	forEditOrganization.config.url    = "<c:url value="/univ/ocw/course/organization/edit.do"/>";
	
	forCourseActivePopup = $.action("layer");
    forCourseActivePopup.config.formId = "FormInsert";
    forCourseActivePopup.config.url    = "<c:url value="/univ/courseactive/list/popup.do"/>";
    forCourseActivePopup.config.options.width = 650;
    forCourseActivePopup.config.options.height = 450;
    forCourseActivePopup.config.options.title = "<spring:message code="필드:개설과목:개설과목"/>";
    
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:과목명"/>",
		name : "courseActiveTitle",
		data : ["!null"]
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:교과목분류"/>",
		name : "categoryOrganizationSeq",
		data : ["!null"]
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:과목소개"/>",
		name : "introduction",
		data : ["!null"]
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:강사"/>",
		name : "profMemberSeq",
		data : ["!null"]
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:제공자"/>",
		name : "offerName",
		data : ["!null"]
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:제공자"/>",
		name : "offerName",
		data : ["!null"]
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:개설과목:운영기간"/>",
		name : "studyStartDate",
		data : ["!null"]
	});
	
	forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:운영기간"/>",
        name : "studyEndDate",
        data : ["!null"],
        when : function() {
			var form = UT.getById(forInsert.config.formId);
			if (form.elements["limitOpenYn"].checked == false) {
				return true;
			} else {
				return false;
			}
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
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	if (swfu != null) {
		var form = UT.getById(forInsert.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
};

/**
 * 분류정보 세팅
 */
doSetCategorySeq = function(seq) {
    var form = UT.getById(forInsert.config.formId);
    form.elements["categoryOrganizationSeq"].value = (typeof seq === "undefined" || seq == null ? "" : seq);
};

/**
 * 제한없음 클릭시
 */
doClickLimitOpenYn = function(){
	var form = UT.getById(forInsert.config.formId);

	if(form.elements["limitOpenYn"].checked == true){
		jQuery("#studyEndDateSpan").hide();
	}else{
		jQuery("#studyEndDateSpan").show();
	}
};

/**
 * 등록화면을 호출하는 함수
 */
doProfLayer = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forProfLayer.config.formId).reset();
	// 등록화면 실행
	forProfLayer.run();
};

/**
 * 교강사 검색 팝업 리턴값 셋팅
 */
doProfInsert = function(returnValue) {
	var $form = jQuery("#"+forInsert.config.formId);
	$form.find(":input[name='profMemberSeq']").val(returnValue.memberSeq);
	$form.find(":input[name='profMemberName']").val(returnValue.memberName);
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	var form = UT.getById(forInsert.config.formId);
	form.elements["attachUploadInfoFile"].value = UI.uploader.getUploadedData(swfu1, "uploader_file");
	return true;
};

/**
 * 사진 삭제
 */
doDeletePhoto = function(index) {
	var form = UT.getById(forInsert.config.formId);
	form.elements["photo"+index].value = "";
	
	var $photo = jQuery("#ocw-photo"+index);
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
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

doCourseActivePopup = function(){
	forCourseActivePopup.run();
};

doCopyCourseActive = function(mapPKs){
	
	var form = UT.getById(forInsert.config.formId);
	form.elements["courseActiveTitle"].value = mapPKs.courseActiveTitle;
	form.elements["sourceCourseActiveSeq"].value = mapPKs.courseActiveSeq;
	
	jQuery("#copySpan").show();
	jQuery("#copySpanText").html("["+ mapPKs.yearTermName + "] " + mapPKs.courseActiveTitle);
};

doCopyCancel= function(){
	jQuery("#copySpan").hide();
	jQuery("#sourceCourseActiveSeq").val("");
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
</head>

<body>
	<div style="display:none;">
		<c:import url="srchOcwCourse.jsp"/>
	</div>

	<form name="FormBrowseProf" id="FormBrowseProf" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doProfInsert"/>
		<input type="hidden" name="select" value="single"/>
	</form>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="categoryOrganizationSeq"/>
	<input type="hidden" name="reloadCallback" value="doCopyCourseActive">
	<input type="hidden" name="sourceCourseActiveSeq" id="sourceCourseActiveSeq" value="">
	<input type="hidden" name="photo1"/>
	<input type="hidden" name="photo2"/>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:개설과목:과목명"/><span class="star">*</span></th>
			<td colspan="3">
				<input type="text" name="courseActiveTitle" style="width:300px;">
				<a href="#" onclick="doCourseActivePopup()" class="btn gray"><span class="small"><spring:message code="필드:개설과목:개설과목가져오기"/></span></a>
				<span id="copySpan" style="display: none;">복사대상 : <span id="copySpanText"></span>
					<a href="#" onclick="doCopyCancel();" class="btn gray"><span class="small"><spring:message code="버튼:취소"/></span></a>
				</span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:교과목분류"/><span class="star">*</span></th>
			<td colspan="3">
				<div id="categoryStep"></div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:과목소개"/><span class="star">*</span></th>
			<td colspan="3">
				<textarea name="introduction" id="introduction" style="width:99%; height:200px"></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:강사"/><span class="star">*</span></th>
			<td colspan="3">
				<c:if test="${currentRoleCfString ne 'PROF'}">
					<input type="hidden" name="profMemberSeq" value=""/>
					<input type="text" name="profMemberName" value="" style="width:150px;" readonly="readonly"> <a href="#" onclick="doProfLayer()" class="btn gray"><span class="small"><spring:message code="필드:멤버:교수선택"/></span></a>
				</c:if>
				<c:if test="${currentRoleCfString eq 'PROF'}">
					<input type="hidden" name="profMemberSeq" value="${memberSeq}"/>
					<input type="text" name="profMemberName" value="${profMemberName}" style="width:150px;" readonly="readonly">
				</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:제공자"/><span class="star">*</span></th>
			<td>
				<input type="text" name="offerName" style="width:100px;">
			</td>
			<th><spring:message code="필드:개설과목:출저"/></th>
			<td>
				<input type="text" name="source" style="width:250px;">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:보조자료"/></th>
			<td>
				<input type="hidden" name="attachUploadInfoFile"/>
				<div id="uploader_file" class="uploader"></div>
				<span class="vbom">10 MB</span>
			</td>
			<th><spring:message code="필드:개설과목:참고서적"/></th>
			<td>
				<input type="text" name="referenceBook" style="width:250px;">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:대표이미지"/>1</th>
			<td>
				<div class="photo photo-120">
					<img src="${memberPhoto}" id="ocw-photo1" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader_img1" class="uploader"></div>
					<div class="delete" 
					     style="display:none;" 
					     onclick="doDeletePhoto(1)" title="<spring:message code="버튼:삭제"/>"></div>
				</div>
				<spring:message code="필드:개설과목:대표이미지"/>1 : 236px x 216px
			</td>
			<th><spring:message code="필드:개설과목:대표이미지"/>2</th>
			<td>
				<div class="photo photo-120">
					<img src="${memberPhoto}" id="ocw-photo2" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader_img2" class="uploader"></div>
					<div class="delete" 
					     style="display:none;" 
					     onclick="doDeletePhoto(2)" title="<spring:message code="버튼:삭제"/>"></div>
				</div>
				<spring:message code="필드:개설과목:대표이미지"/>2 : 180 x 94px
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:키워드"/></th>
			<td colspan="3">
				<input type="text" name="keyword" style="width:400px;"> <spring:message code="글:개설과목:구분자콤마"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:운영기간"/></th>
			<td colspan="3">
				<input type="text" name="studyStartDate" id="studyStartDate" class="datepicker" value="" readonly="readonly">
				<span id="studyEndDateSpan">
				~
				<input type="text" name="studyEndDate" id="studyEndDate" class="datepicker" value="" readonly="readonly">
				</span>
				
				<input type="checkbox" name="limitOpenYn" value="Y" onclick="doClickLimitOpenYn()"/> <spring:message code="글:개설과목:제한없음"/>
			</td>
		</tr>
		<tr>
            <th><spring:message code="필드:개설과목:상태"/></th>
            <td colspan="3"><aof:code type="radio" name="courseActiveStatusCd" codeGroup="COURSE_ACTIVE_STATUS" selected="${CD_COURSE_ACTIVE_STATUS_OPEN}"/></td>
        </tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn-r">
		<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
		<a href="#" class="btn blue" onclick="doList();"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	</div>
	
</body>
</html>