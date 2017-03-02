<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:choose>
	<c:when test="${boardType eq 'qna'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_QNA" scope="request"/>
	</c:when>
</c:choose>

<html decorator="classroom-layer">
<head>
<title><c:out value="${detailBoard.board.boardTitle}"/></title>
<script type="text/javascript">

var forListdata = null;
var forInsert   = null;
var swfu = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	<c:if test="${detailBoard.board.attachCount gt 0}">
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

	<c:if test="${detailBoard.board.editorYn eq 'Y'}">
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
	forListdata.config.url    = "<c:url value="/usr/classroom/course/bbs/${boardType}/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/usr/classroom/course/bbs/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.before       = doSetUploadInfo;
	forInsert.config.fn.complete     = function() {
		doList();
	};

	setValidate();

};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:제목"/>",
		name : "bbsTitle",
		data : ["!null"],
		check : {
			maxlength : 200
		}
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:게시판:내용"/>",
		name : "description",
		data : ["!null"]
	});

};

/**
 * 저장
 */
doInsert = function() { 
	// editor 값 복사
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
 * 팝업노출 클릭
 */
doClickPopupYn = function() {
	var $form = jQuery("#" + forInsert.config.formId);
	var $popupYn = $form.find(":input[name='popupYn']").filter(":checked");
	var $secretYn = $form.find(":input[name='secretYn']").filter(":checked");
	if ($popupYn.val() == "Y" && $secretYn.val() == "Y") { // 팝업노출이면서 비밀글은 할수 없다.
		$secretYn.attr("checked", false);
		jQuery.alert({
			message : "<spring:message code="글:게시판:팝업노출을위해비밀글이해제되었습니다"/>"
		});
	}
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

<c:set var="replyYn"    value="N"/> <%-- 답변등록 여부 --%>
<c:set var="parentSeq"  value="0"/>
<c:set var="groupSeq"   value=""/>
<c:set var="groupLevel" value="1"/>
<c:if test="${!empty detailParentBbs}">
	<c:set var="replyYn"    value="Y"/>
	<c:set var="parentSeq"  value="${detailParentBbs.bbs.bbsSeq}"/>
	<c:set var="groupSeq"   value="${detailParentBbs.bbs.groupSeq}"/>
	<c:set var="groupLevel" value="${detailParentBbs.bbs.groupLevel + 1}"/>
</c:if>

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
			
				<c:if test="${replyYn eq 'Y'}">
					<div class="lybox-title">
						<h4 class="section-title"><spring:message code="글:게시판:원게시글"/></h4>
					</div>
					<table class="tbl-detail">
					<colgroup>
						<col style="width:120px" />
						<col/>
					</colgroup>
					<tbody>
						<c:if test="${!empty codeGroupBbsType}">
							<tr>
								<th><spring:message code="필드:게시판:구분"/></th>
								<td>
									<aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${detailParentBbs.bbs.bbsTypeCd}"/>
								</td>
							</tr>
						</c:if>
						<tr>
							<th><spring:message code="필드:게시판:제목"/></th>
							<td>
								<c:if test="${detailParentBbs.bbs.alwaysTopYn eq 'Y'}">[<spring:message code="필드:게시판:공지" />]</c:if>
								<c:if test="${detailParentBbs.bbs.secretYn eq 'Y'}">[<spring:message code="필드:게시판:비밀글" />]</c:if>
								<c:out value="${detailParentBbs.bbs.bbsTitle}"/>
							</td>
						</tr>
						<tr>
							<th><spring:message code="필드:게시판:내용"/></th>
							<td>
								<c:choose>
									<c:when test="${detailParentBbs.bbs.htmlYn eq 'Y'}">
										<aof:text type="whiteTag" value="${detailParentBbs.bbs.description}"/>
									</c:when>
									<c:otherwise>
										<aof:text type="text" value="${detailParentBbs.bbs.description}"/>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<c:if test="${!empty detailParentBbs.bbs.attachList}">
							<tr>
								<th><spring:message code="필드:게시판:첨부파일"/></th>
								<td>
									<c:forEach var="row" items="${detailParentBbs.bbs.attachList}" varStatus="i">
										<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
										[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
									</c:forEach>
								</td>
							</tr>
						</c:if>
					</tbody>
					</table>
				</c:if>
				
				<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
				<input type="hidden" name="boardSeq"   value="<c:out value="${detailBoard.board.boardSeq}"/>"/>
				<input type="hidden" name="parentSeq"  value="<c:out value="${parentSeq}"/>"/>
				<input type="hidden" name="groupSeq"   value="<c:out value="${groupSeq}"/>"/>
				<input type="hidden" name="groupLevel" value="<c:out value="${groupLevel}"/>"/>
				<input type="hidden" name="boardType"  value="<c:out value="${boardType}"/>"/>
				<input type="hidden" name="evaluateYn" value="N"/>
				
				<input type="hidden" name="srchBoardSeq" 	value="<c:out value="${param['srchBoardSeq']}"/>"/>
				<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>"/>
    			<input type="hidden" name="courseApplySeq" 	value="<c:out value="${param['courseApplySeq']}"/>"/>
				<input type="hidden" name="parentRegMemberSeq"    value="<c:out value="${detailParentBbs.bbs.regMemberSeq}"/>"/>
				
				<c:if test="${replyYn eq 'Y'}">
					<div class="vspace"></div>
					<div class="lybox-title">
						<h4 class="section-title"><spring:message code="글:게시판:답변등록"/></h4>
					</div>
				</c:if>
				<table class="tbl-detail">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<c:choose>
						<c:when test="${replyYn eq 'Y'}">
							<input type="hidden" name="bbsTypeCd" value=""/>
						</c:when>
						<c:otherwise>
							<c:if test="${!empty codeGroupBbsType}">
								<tr>
									<th><spring:message code="필드:게시판:구분"/></th>
									<td>
										<select name="bbsTypeCd">
											<aof:code type="option" codeGroup="${codeGroupBbsType}" />
										</select>
									</td>
								</tr>
							</c:if>
						</c:otherwise>
					</c:choose>
					<tr>
						<th><spring:message code="필드:게시판:제목"/></th>
						<td>
							<input type="text" name="bbsTitle" style="width:350px;">
							<input type="hidden" name="alwaysTopYn" value="N"/>
							
							<c:choose>
								<c:when test="${detailBoard.board.secretYn eq 'Y'}">
									<input type="checkbox" name="secretYn" value="Y" <c:if test="${param['parentSecretYn'] eq 'Y'}">checked="checked"</c:if> <c:if test="${boardType eq 'notice'}">onclick="doClickPopupYn()"</c:if>/>
									<spring:message code="필드:게시판:비밀글"/>
								</c:when>
								<c:otherwise>
									<input type="checkbox" name="secretYn" value="N" style="display:none;"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:게시판:내용"/></th>
						<td>
							<input type="hidden" name="htmlYn" value="<c:out value="${detailBoard.board.editorYn}"/>">
							<input type="hidden" name="editorPhotoInfo">
							<textarea name="description" id="description" style="width:98%; height:300px"></textarea>
						</td>
					</tr>
					<c:if test="${detailBoard.board.attachCount gt 0}">
						<tr>
							<th><spring:message code="필드:게시판:첨부파일"/></th>
							<td>
								<input type="hidden" name="attachUploadInfo"/>
								<div id="uploader" class="uploader"></div>
								<span class="vbom"><c:out value="${detailBoard.board.attachSize}"/>MB</span>
							</td>
						</tr>
					</c:if>
					<c:choose>
						<c:when test="${boardType eq 'notice'}"> <%-- 공지사항 --%>
							<tr>
								<th><spring:message code="필드:게시판:팝업노출"/></th>
								<td><aof:code type="radio" name="popupYn" codeGroup="YESNO" selected="N" onclick="doClickPopupYn()" removeCodePrefix="true"/></td>
							</tr>
						</c:when>
						<c:otherwise>
							<input type="hidden" name="popupYn" value="N"/>
						</c:otherwise>
					</c:choose>
				</tbody>
				</table>
				</form>
			
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
					</div>
				</div>
			
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
	
</body>
</html>