<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var forCourseLayer   = null;
var forSubDetail   = null;
var forProfLayer   = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
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
	// editor
	UI.editor.create("templateDescription");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/teamproject/template/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/course/teamproject/template/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = function() {
		doList();
	};
	
	forCourseLayer = $.action("layer");
	forCourseLayer.config.formId         = "FormBrowseCourse";
	forCourseLayer.config.url            = "<c:url value="/univ/coursemaster/popup.do"/>";
	forCourseLayer.config.options.width  = 700;
	forCourseLayer.config.options.height = 500;
	forCourseLayer.config.options.title  = "<spring:message code="필드:교과목:교과목선택"/>";
	
	forProfLayer = $.action("layer");
	forProfLayer.config.formId         = "FormBrowseProf";
	forProfLayer.config.url            = "<c:url value="/member/prof/list/popup.do"/>";
	forProfLayer.config.options.width  = 700;
	forProfLayer.config.options.height = 500;
	forProfLayer.config.options.title  = "<spring:message code="글:권한그룹:구성원추가"/>";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:교과목:교과목선택"/>",
		name : "courseMasterSeq",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:멤버:교수선택"/>",
		name : "profMemberSeq",
		data : ["!null"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:팀프로젝트:팀프로젝트제목"/>",
		name : "templateTitle",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:팀프로젝트:팀프로젝트내용"/>",
		name : "templateDescription",
		data : ["!null"]
	});
};
/**
 * 저장
 */
doInsert = function() { 
	UI.editor.copyValue();
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
 * 교과목 선택 레이어 팝업 호출
 */
doCourseLayer = function(){
	forCourseLayer.run();
}

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
 * 교과목 검색 팝업 리턴값 셋팅
 */
doCourseMasterInsert = function(returnValue) {
	var $form = jQuery("#"+forInsert.config.formId);
	$form.find(":input[name='courseMasterSeq']").val(returnValue.courseMasterSeq);
	$form.find(":input[name='courseTitle']").val(returnValue.courseTitle);
}

/**
 * 교강사 검색 팝업 리턴값 셋팅
 */
doProfInsert = function(returnValue) {
	var $form = jQuery("#"+forInsert.config.formId);
	$form.find(":input[name='profMemberSeq']").val(returnValue.memberSeq);
	$form.find(":input[name='profMemberName']").val(returnValue.memberName);
}

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>
	
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
	<aof:session key="memberSeq" var="memberSeq"/><!-- 교강사일 경우사용-->
	<aof:session key="memberName" var="profMemberName"/><!-- 교강사일 경우사용-->

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseTeamProjectTemplate.jsp"/>
	</div>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="useYn" value="Y"><!-- 사용여부는 기본값 Y로 들어간다. -->
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:교과목:교과목선택"/><span class="star">*</span></th>
			<td>
				<input type="hidden" name="courseMasterSeq" value="">
				<input type="text" name="courseTitle" value="" style="width:150px;" readonly="readonly"> <a href="#" onclick="doCourseLayer()" class="btn gray"><span class="small"><spring:message code="버튼:교과목:교과목선택"/></span></a>	
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:교수선택"/><span class="star">*</span></th>
			<td>
				<c:if test="${currentRoleCfString ne 'PROF'}"><!-- 관리자, 선임, 강사 -->
					<input type="hidden" name="profMemberSeq" value=""/>
					<input type="text" name="profMemberName" value="" style="width:150px;" readonly="readonly"> <a href="#" onclick="doProfLayer()" class="btn gray"><span class="small"><spring:message code="필드:멤버:교수선택"/></span></a>
					<input type="checkbox" name="openYn" value="Y"> <spring:message code="필드:템플릿:전체공개"/>
				</c:if>
				<c:if test="${currentRoleCfString eq 'PROF'}">
					<input type="hidden" name="profMemberSeq" value="${memberSeq}"/>
					<input type="text" name="profMemberName" value="${profMemberName}" style="width:150px;" readonly="readonly">
					<input type="checkbox" name="openYn" value="Y"> <spring:message code="필드:템플릿:전체공개"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:팀프로젝트:팀프로젝트제목"/><span class="star">*</span></th>
			<td>
				<input type="text" name="templateTitle" value="" style="width:350px;">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:첨부파일"/></th>
			<td>
				<input type="hidden" name="attachUploadInfo"/>
				<div id="uploader" class="uploader"></div>
				<span class="vbom">10 MB</span>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<textarea name="templateDescription" id="templateDescription" style="width:99%; height:200px"></textarea>
			</td>
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