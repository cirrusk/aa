<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:choose>
	<c:when test="${boardType eq 'notice' or boardType eq 'ocwnotice'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_NOTICE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'resource'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_RESOURCE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'qna' or boardType eq 'ocwcontact'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_QNA" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'faq' or boardType eq 'ocwfaq'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_FAQ" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'free'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'staff'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_STAFF" scope="request"/>
	</c:when>
</c:choose>

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
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/system/bbs/${boardType}/list.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/system/bbs/update.do"/>";
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
	forDelete.config.url             = "<c:url value="/system/bbs/delete.do"/>";
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
	<c:if test="${boardType eq 'staff'}"> <%-- 교직원게시판 --%>
	forUpdate.validator.set({
		title : "<spring:message code="필드:게시판:대상자"/>",
		name : "targetRolegroup",
		data : ["!null"]
	});
	</c:if>
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
					<c:choose>
						<c:when test="${empty codeGroupBbsType or replyYn eq 'Y'}">
							<input type="hidden" name="bbsTypeCd" value=""/>
						</c:when>
						<c:otherwise>
							<tr>
								<th><spring:message code="필드:게시판:구분"/></th>
								<td>
									<select name="bbsTypeCd">
										<aof:code type="option" codeGroup="${codeGroupBbsType}" selected="${detailBbs.bbs.bbsTypeCd}"/>
									</select>
								</td>
							</tr>
						</c:otherwise>
					</c:choose>
					<tr>
						<th>
							<c:choose>
								<c:when test="${boardType eq 'faq'}">
									<spring:message code="필드:게시판:질문"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:게시판:제목"/>
								</c:otherwise>
							</c:choose>
							<span class="star">*</span>
						</th>
						<td>
							<input type="text" name="bbsTitle" style="width:350px;" value="<c:out value="${detailBbs.bbs.bbsTitle}"/>">
							<c:choose>
								<c:when test="${replyYn eq 'Y'}">
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
					<c:if test="${boardType eq 'staff'}"> <%-- 교직원게시판 --%>
						<c:choose>
							<c:when test="${replyYn eq 'Y'}">
								<input type="hidden" name="targetRolegroup" value="<c:out value="${detailBbs.bbs.targetRolegroup}"/>"/>
							</c:when>
							<c:otherwise>
								<tr>
									<th><spring:message code="필드:게시판:대상자"/><span class="star">*</span></th>
									<td>
										<aof:code type="checkbox" name="targetRolegroup" codeGroup="BBS_TARGET_ROLEGROUP" selected="${detailBbs.bbs.targetRolegroup}" />
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</c:if>
					<tr>
						<th>
							<c:choose>
								<c:when test="${boardType eq 'faq'}">
									<spring:message code="필드:게시판:답변"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:게시판:내용"/>
								</c:otherwise>
							</c:choose>
							<span class="star">*</span>
						</th>
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
					<input type="hidden" name="bbsSeq" value="<c:out value="${detailBbs.bbs.bbsSeq}"/>"/>
					<input type="hidden" name="boardSeq" value="<c:out value="${detailBoard.board.boardSeq}"/>"/>
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
