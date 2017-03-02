<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_REPLY_TYPE_1"   value="${aoffn:code('CD.BOARD_REPLY_TYPE.1')}"/>
<c:set var="CD_BOARD_REPLY_TYPE_99"  value="${aoffn:code('CD.BOARD_REPLY_TYPE.99')}"/>

<html>
<head>
<title></title>

<script type="text/javascript">

var forListdata    = null;
var forUpdate   = null;
var forListReply   = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	<c:if test="${detailBoard.board.commentYn eq 'Y'}">
	initPageComment();
	</c:if>
	
	doListReply();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/discuss/result/bbs/list/iframe.do"/>";
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/discuss/bbs/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	forListReply = $.action("ajax");
	forListReply.config.formId      = "FormReplyList";
	forListReply.config.type        = "html";
	forListReply.config.containerId = "replyList";
	forListReply.config.url         = "<c:url value="/univ/course/discuss/result/reply/list/ajax.do"/>";
	forListReply.config.fn.complete = function() {};
	
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
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
 *
 * 답변글 목록
 */
doListReply = function() {
	if (jQuery("#" + forListReply.config.formId).length > 0) {
		forListReply.run();
	}
};
</script>
</head>

<body>
	
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
					<c:import url="srchDiscussBbs.jsp"/>
				</div>

				<table class="tbl-detail">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:토론:의견구분"/></th>
						<td>
							<aof:code type="print" codeGroup="DISCUSS_BBS_TYPE" selected="${detailBbs.bbs.bbsTypeCd}"/>
						</td>
					</tr>
					<tr>
						<th>
							<spring:message code="필드:게시판:제목"/>
						</th>
						<td>
							<c:if test="${detailBbs.bbs.alwaysTopYn eq 'Y'}">[<spring:message code="필드:게시판:공지" />]</c:if>
							<c:if test="${detailBbs.bbs.secretYn eq 'Y'}">[<spring:message code="필드:게시판:비밀글" />]</c:if>
							<c:out value="${detailBbs.bbs.bbsTitle}"/>
						</td>
					</tr>
					<tr>
						<th>
							<spring:message code="필드:토론:등록자"/>
						</th>
						<td>
							<c:out value="${detailBbs.bbs.regMemberName}"/>
							(<c:out value="${detailBbs.bbs.regMemberId}"/>)
						</td>
					</tr>
					<tr>
						<th>
							<spring:message code="필드:게시판:내용"/>
						</th>
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
								<c:if test="${empty detailBbs.bbs.attachList}">
									<spring:message code="글:토론:없음"/>
								</c:if>
							</td>
						</tr>
					</c:if>
					<tr>
						<th>
							<spring:message code="필드:토론:평가대상여부"/>
						</th>
						<td>
							<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
								<input type="hidden" name="boardSeq" value="<c:out value="${detailBoard.board.boardSeq}"/>"/>
								<input type="hidden" name="bbsSeq" value="<c:out value="${detailBbs.bbs.bbsSeq}"/>"/>
				                <input type="hidden" name="discussSeq" value="<c:out value="${detailBbs.bbs.discussSeq}"/>" />
								
								<select name="evaluateYn">
									<aof:code type="option" codeGroup="YESNO" removeCodePrefix="true" selected="${detailBbs.bbs.evaluateYn}"/>
								</select>
							</form>
						</td>
					</tr>
				</tbody>
				</table>
			
				<div class="lybox-btn">	
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
						</c:if>
						<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
					</div>
				</div>
			
				<c:if test="${detailBoard.board.commentYn eq 'Y'}">
					<c:import url="/WEB-INF/view/controller/board/comment/comment.jsp">
						<c:param name="srchBbsSeq" value="${detailBbs.bbs.bbsSeq}"/>
					</c:import>
				</c:if>
				
				<%-- 
				게시판설정이 답글1, 게시판설정이 답글 무제한 일 때,
				현재글 level 이 1인 글이면 현재 답변수가 1 이상일 경우와
				현재글 level 이 1 이상인 경우
				 --%>
				<c:if test="${(detailBoard.board.replyTypeCd eq CD_BOARD_REPLY_TYPE_1 or detailBoard.board.replyTypeCd eq CD_BOARD_REPLY_TYPE_99)
					and ((detailBbs.bbs.groupLevel eq 1 and detailBbs.bbs.replyCount gt 0) or (detailBbs.bbs.groupLevel gt 1)) }">
					<form name="FormReplyList" id="FormReplyList" method="post" onsubmit="return false;">
						<input type="hidden" name="currentPage"  value="0" /> <%-- 1 or 0(전체) --%>
						<input type="hidden" name="perPage"      value="10" />
						<input type="hidden" name="bbsSeq"       value="<c:out value="${detailBbs.bbs.parentSeq eq 0 ? detailBbs.bbs.bbsSeq : detailBbs.bbs.parentSeq}"/>"/>
                        
                        <input type="hidden" name="discussSeq" value="<c:out value="${bbs.discussSeq}"/>" />
                        <input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>" />
                        
					</form>
					<div id="replyList"></div>
				</c:if>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

</body>
</html>