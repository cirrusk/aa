<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_OCW" value="${aoffn:code('CD.CATEGORY_TYPE.OCW')}"/>

<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_OCW = "<c:out value="${CD_CATEGORY_TYPE_OCW}"/>";

var forListdata = null;
var forUpdate   = null;
var forProfLayer   = null;
var forDetail   = null;
var forEditOrganization   = null;
var swfu1 = null;
var swfu2 = null;
var swfu3 = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="common/blank.gif"/>";

initPage = function() {
	// 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	UI.tabs("#tabs");
	
	//카테고리 select 설정
    BrowseCategory.create({
        "categoryTypeCd" : CD_CATEGORY_TYPE_OCW,
        "callback" : "doSetCategorySeq",
        "selectedSeq" : "<c:out value="${detail.courseActive.categoryOrganizationSeq}"/>",
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
						var form = UT.getById(forUpdate.config.formId);
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
							var form = UT.getById(forUpdate.config.formId);
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
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/ocw/course/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.before       = doSetUploadInfo;
	forUpdate.config.fn.complete     = function() {
		doDetail({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />'});
	};
	
	forProfLayer = $.action("layer");
	forProfLayer.config.formId         = "FormBrowseProf";
	forProfLayer.config.url            = "<c:url value="/member/prof/list/popup.do"/>";
	forProfLayer.config.options.width  = 700;
	forProfLayer.config.options.height = 500;
	forProfLayer.config.options.title  = "<spring:message code="필드:멤버:교수선택"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/ocw/course/detail.do"/>";
	
	forEditOrganization = $.action();
	forEditOrganization.config.formId = "FormDetail";
	forEditOrganization.config.url    = "<c:url value="/univ/ocw/course/organization/edit.do"/>";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:과목명"/>",
		name : "courseActiveTitle",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:교과목분류"/>",
		name : "categoryOrganizationSeq",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:과목소개"/>",
		name : "introduction",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:강사"/>",
		name : "profMemberSeq",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:제공자"/>",
		name : "offerName",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:제공자"/>",
		name : "offerName",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
		title : "<spring:message code="필드:개설과목:운영기간"/>",
		name : "studyStartDate",
		data : ["!null"]
	});
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:개설과목:운영기간"/>",
        name : "studyEndDate",
        data : ["!null"],
        when : function() {
			var form = UT.getById(forUpdate.config.formId);
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
doUpdate = function() { 
	forUpdate.run();
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
		var form = UT.getById(forUpdate.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
};

/**
 * 분류정보 세팅
 */
doSetCategorySeq = function(seq) {
    var form = UT.getById(forUpdate.config.formId);
    form.elements["categoryOrganizationSeq"].value = (typeof seq === "undefined" || seq == null ? "" : seq);
};

/**
 * 제한없음 클릭시
 */
doClickLimitOpenYn = function(){
	var form = UT.getById(forUpdate.config.formId);

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
	var $form = jQuery("#"+forUpdate.config.formId);
	$form.find(":input[name='profMemberSeq']").val(returnValue.memberSeq);
	$form.find(":input[name='profMemberName']").val(returnValue.memberName);
};

/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["attachUploadInfoFile"].value = UI.uploader.getUploadedData(swfu1, "uploader_file");
	return true;
};

/**
 * 사진 삭제
 */
doDeletePhoto = function(index) {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["photo"+index].value = "";
	
	var $photo = jQuery("#ocw-photo"+index);
	$photo.attr("src", imageBlank);
	$photo.siblings(".delete").hide();
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
		<c:param name="suffix"></c:param>
	</c:import>
	
	<div id="tabs"> 
		<ul class="ui-widget-header-tab-custom">
			<li id="tab1"><a href="javascript:void(0)" 
				onclick="javascript:doDetail({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />'});"><spring:message code="글:상세정보" /></a>
			</li>
			<li id="tab2"><a href="javascript:void(0)" 
				onclick="javascript:doEditOrganization({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />',
														'courseActiveSeq' : '<c:out value="${detail.courseActive.courseActiveSeq}" />'});"><spring:message code="필드:개설과목:구성정보" /></a>
			</li>
		</ul>
	</div>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" 	value="<c:out value="${detail.courseActive.courseActiveSeq}"/>"/>
	<input type="hidden" name="courseMasterSeq" 	value="<c:out value="${detail.courseActive.courseMasterSeq}"/>"/>
	<input type="hidden" name="ocwCourseActiveSeq" value="<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}"/>"/>
	<input type="hidden" name="courseActiveProfSeq" value="<c:out value="${detail.ocwCourse.courseActiveProfSeq}"/>"/>
	<input type="hidden" name="categoryOrganizationSeq" value="<c:out value="${detail.courseActive.categoryOrganizationSeq}"/>"/>
	<input type="hidden" name="photo1" value="<c:out value="${detail.ocwCourse.photo1}"/>"/>
	<input type="hidden" name="photo2" value="<c:out value="${detail.ocwCourse.photo2}"/>"/>
	
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
				<input type="text" name="courseActiveTitle" style="width:300px;" value="<c:out value="${detail.courseActive.courseActiveTitle}"/>">
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
				<textarea name="introduction" id="introduction" style="width:99%; height:200px"><c:out value="${detail.courseActive.introduction}"/></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:강사"/><span class="star">*</span></th>
			<td colspan="3">
				<input type="hidden" name="profMemberSeq" value="<c:out value="${detail.ocwCourse.profMemberSeq}"/>"/>
				<input type="text" name="profMemberName" value="<c:out value="${detail.ocwCourse.profMemberName}"/>" style="width:150px;" readonly="readonly"> <a href="#" onclick="doProfLayer()" class="btn gray"><span class="small"><spring:message code="필드:멤버:교수선택"/></span></a>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:제공자"/><span class="star">*</span></th>
			<td>
				<input type="text" name="offerName" style="width:100px;" value="<c:out value="${detail.ocwCourse.offerName}"/>">
			</td>
			<th><spring:message code="필드:개설과목:출저"/></th>
			<td>
				<input type="text" name="source" style="width:250px;" value="<c:out value="${detail.ocwCourse.source}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:보조자료"/></th>
			<td>
				<input type="hidden" name="attachUploadInfoFile"/>
				<input type="hidden" name="attachDeleteInfoFile">
				<div id="uploader_file" class="uploader">
					<c:if test="${!empty detail.ocwCourse.attachFileList}">
						<c:forEach var="row" items="${detail.ocwCourse.attachFileList}" varStatus="i">
							<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
								<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
							</div>
						</c:forEach>
					</c:if>
				</div>
				<span class="vbom">10 MB</span>
			</td>
			<th><spring:message code="필드:개설과목:참고서적"/></th>
			<td>
				<input type="text" name="referenceBook" style="width:250px;" value="<c:out value="${detail.ocwCourse.referenceBook}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:대표이미지"/>1</th>
			<td>
				<div class="photo photo-120">
					<c:choose>
						<c:when test="${!empty detail.ocwCourse.photo1}">
							<c:set var="ocwPhoto1" value ="${aoffn:config('upload.context.image')}${detail.ocwCourse.photo1}.thumb.jpg"/>
						</c:when>
						<c:otherwise>
							<c:set var="ocwPhoto1"><aof:img type="print" src="common/blank.gif"/></c:set>
						</c:otherwise>
					</c:choose>
					<img src="${ocwPhoto1}" id="ocw-photo1" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader_img1" class="uploader"></div>
					<div class="delete" 
					     style="display:<c:out value="${empty detail.ocwCourse.photo1 ? 'none' : ''}"/>;" 
					     onclick="doDeletePhoto(1)" title="<spring:message code="버튼:삭제"/>"></div>
				</div>
				<spring:message code="필드:개설과목:대표이미지"/>1 : 236px x 216px
			</td>
			<th><spring:message code="필드:개설과목:대표이미지"/>2</th>
			<td>
				<c:choose>
					<c:when test="${!empty detail.ocwCourse.photo2}">
						<c:set var="ocwPhoto2" value ="${aoffn:config('upload.context.image')}${detail.ocwCourse.photo2}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="ocwPhoto2"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-120">
					<img src="${ocwPhoto2}" id="ocw-photo2" title="<spring:message code="필드:멤버:사진"/>">
					<div id="uploader_img2" class="uploader"></div>
					<div class="delete" 
					     style="display:<c:out value="${empty detail.ocwCourse.photo2 ? 'none' : ''}"/>;" 
					     onclick="doDeletePhoto(2)" title="<spring:message code="버튼:삭제"/>"></div>
				</div>
				<spring:message code="필드:개설과목:대표이미지"/>2 : 180px x 94px
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:키워드"/></th>
			<td colspan="3">
				<input type="text" name="keyword" style="width:400px;" value="<c:out value="${detail.ocwCourse.keyword}"/>"> <spring:message code="글:개설과목:구분자콤마"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:개설과목:운영기간"/></th>
			<td colspan="3">
				<input type="text" name="studyStartDate" id="studyStartDate" class="datepicker" value="<aof:date datetime="${detail.courseActive.studyStartDate}"/>" readonly="readonly">
				<span id="studyEndDateSpan">
				~
				<input type="text" name="studyEndDate" id="studyEndDate" class="datepicker" value="<aof:date datetime="${detail.courseActive.studyEndDate}"/>" readonly="readonly">
				</span>
				
				<input type="checkbox" name="limitOpenYn" value="Y" onclick="doClickLimitOpenYn()" <c:if test="${detail.ocwCourse.limitOpenYn eq 'Y'}">checked="checked"</c:if>/> <spring:message code="글:개설과목:제한없음"/>
			</td>
		</tr>
		<tr>
            <th><spring:message code="필드:개설과목:상태"/></th>
            <td colspan="3"><aof:code type="radio" name="courseActiveStatusCd" codeGroup="COURSE_ACTIVE_STATUS" selected="${detail.courseActive.courseActiveStatusCd}" ></aof:code></td>
        </tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn-r">
		<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
		<a href="#" class="btn blue" onclick="javascript:doDetail({'ocwCourseActiveSeq' : '<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}" />'});"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	</div>
	
</body>
</html>