<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
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
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/teamproject/template/update.do"/>";
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
	forDelete.config.url             = "<c:url value="/univ/course/teamproject/template/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
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
	forUpdate.validator.set({
		title : "<spring:message code="필드:교과목:교과목선택"/>",
		name : "courseMasterSeq",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:교수선택"/>",
		name : "profMemberSeq",
		data : ["!null"]
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:팀프로젝트:팀프로젝트제목"/>",
		name : "templateTitle",
		data : ["!null"],
		check : {
			maxlength : 100
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:팀프로젝트:팀프로젝트내용"/>",
		name : "templateDescription",
		data : ["!null"]
	});
};

/**
 * 저장
 */
doUpdate = function() { 
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
		var form = UT.getById(forUpdate.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
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
	var $form = jQuery("#"+forUpdate.config.formId);
	$form.find(":input[name='courseMasterSeq']").val(returnValue.courseMasterSeq);
	$form.find(":input[name='courseTitle']").val(returnValue.courseTitle);
}

/**
 * 교강사 검색 팝업 리턴값 셋팅
 */
doProfInsert = function(returnValue) {
	var $form = jQuery("#"+forUpdate.config.formId);
	$form.find(":input[name='profMemberSeq']").val(returnValue.memberSeq);
	$form.find(":input[name='profMemberName']").val(returnValue.memberName);
}

</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:수정" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseTeamProjectTemplate.jsp"/>
	</div>
	
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
	
	<!-- 삭제폼 -->
	<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="templateSeq" value="<c:out value="${detail.teamProjectTemplate.templateSeq}"/>"/>
	</form>
				
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
	<input type="hidden" name="templateSeq" value="<c:out value="${detail.teamProjectTemplate.templateSeq}"/>">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:교과목:교과목선택"/><span class="star">*</span></th>
			<td>
				<input type="hidden" name="courseMasterSeq" value="<c:out value="${detail.teamProjectTemplate.courseMasterSeq}"/>">
				<input type="text" name="courseTitle" value="<c:out value="${detail.courseMaster.courseTitle}"/>" style="width:150px;" readonly="readonly"> <a href="#" onclick="doCourseLayer()" class="btn gray"><span class="small"><spring:message code="버튼:교과목:교과목선택"/></span></a>	
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:교수선택"/><span class="star">*</span></th>
			<td>
				<input type="hidden" name="profMemberSeq" value="<c:out value="${detail.teamProjectTemplate.profMemberSeq}"/>"/>
				<input type="text" name="profMemberName" value="<c:out value="${detail.member.memberName}"/>" style="width:150px;" readonly="readonly"> 
				
				<c:if test="${currentRoleCfString ne 'PROF'}"><!-- 관리자 -->
					<a href="#" onclick="doProfLayer()" class="btn gray"><span class="small"><spring:message code="필드:멤버:교수선택"/></span></a>
				</c:if>
				<c:if test="${currentRoleCfString eq 'PROF'}">
					<c:if test="${empty condition.srchProfMemberSeq}"><!-- 선임 -->
						<a href="#" onclick="doProfLayer()" class="btn gray"><span class="small"><spring:message code="필드:멤버:교수선택"/></span></a>
					</c:if>
				</c:if>
				<input type="checkbox" name="openYn" value="Y" <c:if test="${detail.teamProjectTemplate.openYn eq 'Y'}">checked="checked"</c:if>> <spring:message code="필드:템플릿:전체공개"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:팀프로젝트:팀프로젝트제목"/><span class="star">*</span></th>
			<td>
				<input type="text" name="templateTitle" style="width:350px;" value="<c:out value="${detail.teamProjectTemplate.templateTitle}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:첨부파일"/></th>
			<td>
				<input type="hidden" name="attachUploadInfo"/>
				<input type="hidden" name="attachDeleteInfo">
				<div id="uploader" class="uploader">
					<c:if test="${!empty detail.teamProjectTemplate.attachList}">
						<c:forEach var="row" items="${detail.teamProjectTemplate.attachList}" varStatus="i">
							<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
								<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
							</div>
						</c:forEach>
					</c:if>
				</div>
				<span class="vbom">10 MB</span>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<textarea name="templateDescription" id="templateDescription" style="width:99%; height:200px"><c:out value="${detail.teamProjectTemplate.templateDescription}"/></textarea>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:사용여부"/><span class="star">*</span></th>
			<td>
				<aof:code name="useYn" type="radio" removeCodePrefix="true" codeGroup="USEYN" selected="${detail.teamProjectTemplate.useYn}"></aof:code>
			</td>
		</tr>
	</tbody>
	</table>
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