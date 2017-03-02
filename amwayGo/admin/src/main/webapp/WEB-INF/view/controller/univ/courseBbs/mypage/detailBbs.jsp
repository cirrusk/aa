<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE"        value="${aoffn:code('CD.CATEGORY_TYPE')}"/>
<c:set var="CD_CATEGORY_TYPE_ADDSEP" value="${CD_CATEGORY_TYPE}::"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_BOARD_TYPE_APPEAL"    value="${aoffn:code('CD.BOARD_TYPE.APPEAL')}"/>
<c:set var="CD_BOARD_REPLY_TYPE_1"   value="${aoffn:code('CD.BOARD_REPLY_TYPE.1')}"/>
<c:set var="CD_BOARD_REPLY_TYPE_99"  value="${aoffn:code('CD.BOARD_REPLY_TYPE.99')}"/>

<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:choose>
	<c:when test="${boardType eq 'qna'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_QNA" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'notice'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_NOTICE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'appeal'}">
		<c:set var="codeGroupBbsType" value="${CD_BOARD_TYPE_APPEAL}" scope="request"/>
	</c:when>
</c:choose>

<%-- 게시글 과정 멀티등록 여부 체크 --%>
<c:set var="checkMultiRegYn" value="N" />
<c:forEach var="row" items="${detailCourseActiveBbs}" varStatus="i">
	<c:if test="${row.bbs.multiRegYn eq 'Y'}">
		<c:set var="checkMultiRegYn" value="Y" />		
	</c:if>	
</c:forEach>

<%-- 수강생 일련번호(성적상세 팝업호출용) --%>
<c:set var="checkCourseApplySeq" value="" />
<c:set var="checkCourseActiveSeq" value="" />
<c:set var="categoryType" value="" />
<c:if test="${checkMultiRegYn eq 'N'}">
	<c:forEach var="row" items="${detailCourseActiveBbs}" varStatus="i">
		<c:set var="checkCourseApplySeq">${row.bbs.courseApplySeq}</c:set>
		<c:set var="checkCourseActiveSeq">${row.courseActive.courseActiveSeq}</c:set>
		<c:set var="categoryType" value="${fn:toLowerCase(fn:replace(row.category.categoryTypeCd, CD_CATEGORY_TYPE_ADDSEP, '') )}" />
	</c:forEach>	
</c:if>	

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forEdit        = null;
var forCreateReply = null;
var forListReply   = null;
var forDetailPopup = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	doListReply();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/edit.do"/>";
	
	forCreateReply = $.action();
	forCreateReply.config.formId = "FormCreate";
	forCreateReply.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/create.do"/>";
	
	forListReply = $.action("ajax");
	forListReply.config.formId      = "FormReplyList";
	forListReply.config.type        = "html";
	forListReply.config.containerId = "replyList";
	forListReply.config.url         = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/reply/list/ajax.do"/>";
	forListReply.config.fn.complete = function() {};
	
	forDetailPopup = $.action("layer", {formId : "FormApplyDetail"});
	forDetailPopup.config.url = "<c:url value="/univ/course/apply/completion/${categoryType}/popup.do"/>";
	forDetailPopup.config.options.width  = 700;
	forDetailPopup.config.options.height = 550;
	forDetailPopup.config.options.position = "middle";
	forDetailPopup.config.options.title  = "<spring:message code="글:성적관리:개인별세부성적"/>";
	
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
 * 수강생 성적 상세팝업
 */
doDetailCompletionPopup = function(mapPKs){
	UT.getById(forDetailPopup.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetailPopup.config.formId);
	
	forDetailPopup.run();
};

</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
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
			
				<div class="modify">
					<strong><spring:message code="필드:수정자"/></strong>
					<span><c:out value="${detailBbs.bbs.updMemberName}"/></span>
					<strong><spring:message code="필드:수정일시"/></strong>
					<span class="date"><aof:date datetime="${detailBbs.bbs.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
				</div>
				<table class="tbl-detail">
				<colgroup>
					<col style="width:120px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:게시판:제목"/></th>
						<td>
							<c:if test="${detailBbs.bbs.alwaysTopYn eq 'Y'}">[<spring:message code="필드:게시판:공지" />]</c:if>
							<c:if test="${detailBbs.bbs.secretYn eq 'Y'}">[<spring:message code="필드:게시판:비밀글" />]</c:if>
							<c:out value="${detailBbs.bbs.bbsTitle}"/>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:교과목:교과목명"/></th>
						<c:set var="courseActives" value=""></c:set>
						<c:forEach var="row" items="${detailCourseActiveBbs}" varStatus="i">
							<c:if test="${i.first eq true}">
								<c:choose>
									<c:when test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
										<c:set var="courseActives">[<c:out value="${row.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/>]<c:out value="${row.courseActive.courseActiveTitle}" /></c:set>
									</c:when>
									<c:otherwise>
										<c:set var="courseActives">[<c:out value="${row.courseActive.year}"/>]<c:out value="${row.courseActive.courseActiveTitle}" /></c:set>
									</c:otherwise>
								</c:choose>
							</c:if>
							<c:if test="${i.first ne true}">
								<c:choose>
									<c:when test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
										<c:set var="courseActives">${courseActives},[<c:out value="${row.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/>]<c:out value="${row.courseActive.courseActiveTitle}" /></c:set>
									</c:when>
									<c:otherwise>
										<c:set var="courseActives">${courseActives},[<c:out value="${row.courseActive.year}"/>]<c:out value="${row.courseActive.courseActiveTitle}" /></c:set>
									</c:otherwise>
								</c:choose>	
							</c:if>		
						</c:forEach>
						<td>
							<c:out value="${courseActives}" />
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
					<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
						<c:if test="${checkCourseApplySeq ne '' and checkCourseActiveSeq ne ''}">
							<tr>
								<th><spring:message code="필드:게시판:성적상세정보"/></th>
								<td>
									<a href="#" onclick="doDetailCompletionPopup({'courseApplySeq' : '<c:out value="${checkCourseApplySeq}"/>', 'courseActiveSeq' : '<c:out value="${checkCourseActiveSeq}"/>' });" class="btn black"><span class="small"><spring:message code="버튼:보기" /></span></a>				
								</td>
							</tr>
						</c:if>
					</c:if>
				</tbody>
				</table>
			
				<div class="lybox-btn">	
					<div class="lybox-btn-r">
						<%-- 게시글이 멀티로 등록되었을 경우 답변 불가능 --%>
						<%-- 게시판설정이 답글1 이면, 원글이 level 이 1인 글, 현재 답변수가 0 인 글에 대해서 답변가능--%>
						<%-- 게시판설정이 답글 무제한 이면, 원글이 level 이 1인 글에 대해서 답변가능--%>
						<%-- 원글이 최상위 글이면 답변 불가능--%>
						<c:if test="${fn:length(detailCourseActiveBbs) eq 1 and checkMultiRegYn eq 'N'}" >
							<c:if test="${(detailBoard.board.replyTypeCd eq CD_BOARD_REPLY_TYPE_1 and detailBbs.bbs.groupLevel eq 1 and detailBbs.bbs.replyCount eq 0)
								or (detailBoard.board.replyTypeCd eq CD_BOARD_REPLY_TYPE_99 and detailBbs.bbs.groupLevel eq 1)}">
								<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') and detailBbs.bbs.alwaysTopYn ne 'Y'}">
									<a href="#" onclick="doReply({'parentSeq' : '<c:out value="${detailBbs.bbs.bbsSeq}"/>', 'parentSecretYn' : '<c:out value="${detailBbs.bbs.secretYn}"/>' });" class="btn blue"><span class="mid"><spring:message code="버튼:답변"/></span></a>
								</c:if>
							</c:if>
						</c:if>
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="#" onclick="doEdit({'bbsSeq' : '<c:out value="${detailBbs.bbs.bbsSeq}"/>'});"
								class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
						</c:if>
						<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
					</div>
				</div>
				
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

</body>
</html>