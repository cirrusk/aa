<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_REPLY_TYPE_1"   value="${aoffn:code('CD.BOARD_REPLY_TYPE.1')}"/>
<c:set var="CD_BOARD_REPLY_TYPE_99"  value="${aoffn:code('CD.BOARD_REPLY_TYPE.99')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">

var forListdata    = null;
var forCreateReply = null;
var forListReply   = null;
var forUpdate   = null;

initPage = function() {

	doInitializeLocal();

	<c:if test="${detailBoard.board.commentYn eq 'Y'}">
	initPageComment();
	</c:if>
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/bbs/result/${boardType}/list.do"/>";

	forCreateReply = $.action();
	forCreateReply.config.formId = "FormCreate";
	forCreateReply.config.url    = "<c:url value="/univ/course/bbs/${boardType}/create.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/bbs/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
};

/**
 * 목록보기
 */
doList = function() {
	
	forListdata.run();
	
};

/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	
	UT.getById(forEdit.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	forEdit.run();
	
};

/**
 * 답변화면을 호출하는 함수
 */
doReply = function(mapPKs) {
	
	UT.getById(forCreateReply.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forCreateReply.config.formId);
	forCreateReply.run();
	
};

/**
 * 답변글 목록
 */
doListReply = function() {
	
	if (jQuery("#" + forListReply.config.formId).length > 0) {
		forListReply.run();
	}
	
};

/**
 * 저장
 */
doUpdate = function() { 

	UI.editor.copyValue();
	forUpdate.run();
	
};

</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"/>

<div style="display:none;">
	<c:import url="srchCourseBbsResult.jsp"/>
</div>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 참여결과 Tab Area Start -->
<c:import url="commonCourseBbsResuitElement.jsp">
    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
    <c:param name="selectedElementTypeCd" value="${condition.srchBoardSeq}"/>
</c:import>

<div class="vspace"></div>

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
				
				<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
				
				<table class="tbl-detail">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<c:if test="${!empty codeGroupBbsType and detailBbs.bbs.groupLevel eq 1}">
						<tr>
							<th><spring:message code="필드:게시판:구분"/></th>
							<td>
								<aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${detailBbs.bbs.bbsTypeCd}"/>
							</td>
						</tr>
					</c:if>
					<tr>
						<th><spring:message code="필드:게시판:제목"/></th>
						<td>
							<c:if test="${detailBbs.bbs.alwaysTopYn eq 'Y'}">[<spring:message code="필드:게시판:공지" />]</c:if>
							<c:if test="${detailBbs.bbs.secretYn eq 'Y'}">[<spring:message code="필드:게시판:비밀글" />]</c:if>
							<c:out value="${detailBbs.bbs.bbsTitle}"/>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:게시판:내용"/></th>
						<td>
							<c:choose>
								<c:when test="${detailBbs.bbs.htmlYn eq 'Y'}">
									<aof:text type="whiteTag" value="${detailBbs.bbs.description}"/>
								</c:when>
								<c:otherwise>
									<aof:text type="text" value="${detailBbs.bbs.description}"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<c:if test="${!empty detailBbs.bbs.attachList}">
						<tr>
							<th><spring:message code="필드:게시판:첨부파일"/></th>
							<td>
								<c:forEach var="row" items="${detailBbs.bbs.attachList}" varStatus="i">
									<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
									[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
								</c:forEach>
							</td>
						</tr>
					</c:if>
					<tr>
						<th><spring:message code="필드:게시판:평가대상"/></th>
						<td>
							<input type="hidden" name="boardSeq" value="<c:out value="${detailBoard.board.boardSeq}"/>"/>
							<input type="hidden" name="bbsSeq" value="<c:out value="${detailBbs.bbs.bbsSeq}"/>">
							<input type="hidden" name="oldEvaluateYn" value="<c:out value="${detailBbs.bbs.evaluateYn}"/>">
							<select name="evaluateYn" class="select">
								<aof:code type="option" name="evaluateYn" codeGroup="YESNO" selected="${detailBbs.bbs.evaluateYn}" removeCodePrefix="true"/>
							</select>
						</td>
					</tr>
				</tbody>
				</table>
				
				</form>
			
				<div class="lybox-btn">	
					<div class="lybox-btn-r">
						<%-- 게시판설정이 답글1 이면, 원글이 level 이 1인 글, 현재 답변수가 0 인 글에 대해서 답변가능--%>
						<%-- 게시판설정이 답글 무제한 이면, 원글이 level 이 1인 글에 대해서 답변가능--%>
						<%-- 원글이 최상위 글이면 답변 불가능--%>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="#" onclick="doUpdate();"
								class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
						<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
					</div>
				</div>
			
				<c:if test="${detailBoard.board.commentYn eq 'Y'}">
					<c:import url="/WEB-INF/view/controller/board/comment/comment.jsp">
						<c:param name="srchBbsSeq" value="${detailBbs.bbs.bbsSeq}"/>
					</c:import>
				</c:if>
			
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

</body>
</html>