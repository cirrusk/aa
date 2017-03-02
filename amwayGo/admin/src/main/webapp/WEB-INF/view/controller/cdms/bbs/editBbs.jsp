<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
var swfu = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	<c:if test="${detailBoard.board.attachCount gt 0 or !empty detailBbs.bbs.attachList}">
	// uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "<c:out value="${detailBoard.board.attachSize}"/> MB",
				fileUploadLimit : <c:out value="${detailBoard.board.attachCount}"/>, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);
	</c:if>

	<c:if test="${detailBoard.board.editorYn eq 'Y' or detailBbs.bbs.htmlYn eq 'Y'}">
	// editor
	UI.editor.create("description");
	</c:if>
	
	<c:if test="${boardType eq 'dev'}">
	doSetProject(null, '<c:out value="${detailBbs.section.sectionIndex}"/>');
	</c:if>
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/bbs/${boardType}/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/cdms/bbs/update.do"/>";
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
	forDelete.config.url             = "<c:url value="/cdms/bbs/delete.do"/>";
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
		name : "bbsTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:내용"/>",
		name : "description",
		data : ["!null"]
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
		$form.find(":input[name='attachUploadInfo']").val(UI.uploader.getUploadedData(swfu, "uploader"));
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
 * 과정선택
 */
doBrowseProject = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProject";
	//action.config.url = "/cdms/project/list/popup.do";
	action.config.url = "/cdms/project/group/list/popup.do";
	action.config.parameters = "popupType=Group";
	action.config.options.width = 800;
	action.config.options.height = 600;
	action.config.options.title = "<spring:message code="글:CDMS:개발그룹"/>";
	action.run();
};
/**
 * 과정 선택
 */
doSetProject = function(returnValue, selectedSectionIndex) {
	var form = UT.getById(forUpdate.config.formId);	
	if (returnValue != null) {
		form.elements["projectSeq"].value = returnValue.projectSeq;
		form.elements["projectName"].value = returnValue.projectName;
	}

	// 개발단계
	var action = $.action("ajax");
	action.config.url    = "<c:url value="/cdms/section/list.do"/>";
	action.config.type   = "json";
	action.config.parameters = "projectSeq=" + form.elements["projectSeq"].value;
	action.config.fn.complete = function(action, data) {
		var $section = jQuery(form.elements["sectionIndex"]);
		$section.empty();
		var html = [];
		html.push("<option value=''></option>");
		if (data != null && data.listSection != null) {
			for (var i = 0; i < data.listSection.length; i++) {
				html.push("<option value='" + data.listSection[i].section.sectionIndex + "'");
				if (data.listSection[i].section.sectionIndex == selectedSectionIndex) {
					html.push(" selected ");
				}
				html.push(">" + data.listSection[i].section.sectionName + "</option>");
			}
		}
		$section.html(html.join(""));
	};
	action.run();
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

<c:set var="replyYn" value="N"/> <%-- 답변등록 여부 --%>
<c:if test="${detailBbs.bbs.groupLevel gt 1}">
	<c:set var="replyYn" value="Y"/>
</c:if>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:수정" /></c:param>
</c:import>
	
<c:choose>
	<c:when test="${empty detailBoard}"> <%-- 생성되지 않은 게시판 --%>
		<div class="lybox align-c">
			<spring:message code="글:게시판:생성되지않은게시판입니다" />
		</div>
	</c:when>
	<c:otherwise>

		<c:choose>
			<c:when test="${detailBoard.board.useYn ne 'Y'}"> <%-- 사용하지 않는 게시판 --%>
				<div class="lybox align-c">
					<spring:message code="글:게시판:사용하지않는게시판입니다" />
				</div>
			</c:when>
			<c:otherwise>

				<div style="display:none;">
					<c:import url="srchBbs.jsp"/>
				</div>
			
				<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
				<input type="hidden" name="boardSeq" value="<c:out value="${detailBoard.board.boardSeq}"/>"/>
				<input type="hidden" name="bbsSeq" value="<c:out value="${detailBbs.bbs.bbsSeq}"/>"/>
				<table class="tbl-detail">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:게시판:제목"/><span class="star">*</span></th>
						<td>
							<input type="text" name="bbsTitle" style="width:350px;" value="<c:out value="${detailBbs.bbs.bbsTitle}"/>">
							<c:choose>
								<c:when test="${replyYn eq 'Y' or boardType ne 'notice'}">
									<input type="hidden" name="alwaysTopYn" value="N"/>
								</c:when>
								<c:otherwise>
									<input type="checkbox" name="alwaysTopYn" value="Y" <c:out value="${detailBbs.bbs.alwaysTopYn eq 'Y' ? 'checked' : ''}"/>/>
									<spring:message code="필드:게시판:최상위"/>
								</c:otherwise>
							</c:choose>

							<c:choose>
								<c:when test="${detailBoard.board.secretYn eq 'Y'}">
									<input type="checkbox" name="secretYn" value="Y" <c:out value="${detailBbs.bbs.secretYn eq 'Y' ? 'checked' : ''}"/>/>
									<spring:message code="필드:게시판:비밀글"/>
								</c:when>
								<c:otherwise>
									<input type="hidden" name="secretYn" value="<c:out value="${detailBbs.bbs.secretYn}"/>"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<c:if test="${boardType eq 'dev'}">
						<tr>
							<th><spring:message code="필드:CDMS:과정명"/></th>
							<td>
								<input type="hidden" name="projectSeq" value="<c:out value="${detailBbs.project.projectSeq}"/>">
								<input type="text" name="projectName"  value="<c:out value="${detailBbs.project.projectName}"/>" style="width:345px;" readonly="readonly">
								<a href="javascript:void(0)" onclick="doBrowseProject()" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:과정선택"/></span></a>
							</td>
						</tr>
						<tr>
							<th><spring:message code="필드:CDMS:개발단계"/></th>
							<td>
								<select name="sectionIndex">
									<option value=""></option>
								</select>
							</td>
						</tr>
					</c:if>
					<tr>
						<th><spring:message code="필드:게시판:내용"/><span class="star">*</span></th>
						<td>
							<input type="hidden" name="htmlYn" value="<c:out value="${detailBbs.bbs.htmlYn}"/>">
							<input type="hidden" name="editorPhotoInfo">
							<textarea name="description" id="description" style="width:98%; height:300px"><c:out value="${detailBbs.bbs.description}"/></textarea>
						</td>
					</tr>
					<c:if test="${detailBoard.board.attachCount gt 0 or !empty detailBbs.bbs.attachList}">
						<tr>
							<th><spring:message code="필드:게시판:첨부파일"/></th>
							<td>
								<input type="hidden" name="attachUploadInfo"/>
								<input type="hidden" name="attachDeleteInfo">
								<div id="uploader" class="uploader">
									<c:if test="${!empty detailBbs.bbs.attachList}">
										<c:forEach var="row" items="${detailBbs.bbs.attachList}" varStatus="i">
											<div onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
												<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
											</div>
										</c:forEach>
									</c:if>
								</div>
								<span class="vbom"><c:out value="${detailBoard.board.attachSize}"/>MB</span>
							</td>
						</tr>
					</c:if>
				</tbody>
				</table>
				</form>
			
				<form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
					<input type="hidden" name="boardSeq" value="<c:out value="${detailBoard.board.boardSeq}"/>"/>
					<input type="hidden" name="bbsSeq" value="<c:out value="${detailBbs.bbs.bbsSeq}"/>"/>
				</form>
			
				<div class="lybox-btn">
					<div class="lybox-btn-l">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
							<c:choose>
								<c:when test="${detailBbs.bbs.replyCount gt 0}">
									<div class="comment"><spring:message code="글:게시판:답변글이존재하여삭제할수없습니다"/></div>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
								</c:otherwise>
							</c:choose>
						</c:if>
					</div>
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
						<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
					</div>
				</div>
			
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
	
</body>
</html>
