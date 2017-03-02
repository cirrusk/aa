<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_REPLY_TYPE_1"   value="${aoffn:code('CD.BOARD_REPLY_TYPE.1')}"/>
<c:set var="CD_BOARD_REPLY_TYPE_99"  value="${aoffn:code('CD.BOARD_REPLY_TYPE.99')}"/>

<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:choose>
    <c:when test="${boardType eq 'teamproject'}">
        <c:set var="codeGroupBbsType" value="" scope="request"/>
    </c:when>
</c:choose>

<html decorator="classroom">
<head>
<title></title>

<script type="text/javascript">

var forListdata    = null;
var forEdit        = null;
var forCreateReply = null;
var forListReply   = null;
var forTeamProjectHome  = null;
var forDelete   = null;
var forMutualeval       = null;
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
	forListdata.config.url    = "<c:url value="/univ/bbs/teamproject/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/bbs/teamproject/edit.do"/>";
	
	forCreateReply = $.action();
	forCreateReply.config.formId = "FormCreate";
	forCreateReply.config.url    = "<c:url value="/univ/bbs/teamproject/create.do"/>";
	
	forListReply = $.action("ajax");
	forListReply.config.formId      = "FormReplyList";
	forListReply.config.type        = "html";
	forListReply.config.containerId = "replyList";
	forListReply.config.url         = "<c:url value="/univ/bbs/teamproject/reply/list/ajax.do"/>";
	forListReply.config.fn.complete = function() {};
	
	forTeamProjectHome = $.action();
	forTeamProjectHome.config.formId = "FormProjectTeamHome";
	forTeamProjectHome.config.url    = "<c:url value="/univ/teamproject/result/detail.do"/>";
	
	forDelete = $.action("submit");
    forDelete.config.formId          = "FormDelete"; 
    forDelete.config.url             = "<c:url value="/univ/bbs/teamproject/delete.do"/>";
    forDelete.config.target          = "hiddenframe";
    forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
    forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDelete.config.fn.complete     = function() {
        doList();
    };
    
    forMutualeval = $.action();
    forMutualeval.config.formId = "FormMutualeval";
    forMutualeval.config.url    = "<c:url value="/univ/teamproject/mutualeval/list.do"/>";
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
 *
 * 답변글 목록
 */
doListReply = function() {
	if (jQuery("#" + forListReply.config.formId).length > 0) {
		forListReply.run();
	}
};

/**
 * 팀프로젝트 홈 이동
 */
doTeamProjectHome = function(mapPKs){
    UT.copyValueMapToForm(mapPKs, forTeamProjectHome.config.formId);
    forTeamProjectHome.run();
};

/**
 * 삭제
 */
doDelete = function() { 
    forDelete.run();
};

/**
 * 상호평가 이동
 */
doMutualeval = function(mapPKs){
	UT.getById(forMutualeval.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forMutualeval.config.formId);
    
    forMutualeval.run();
};
</script>
</head>

<body>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 팀 프로젝트 팀 정보 Start -->
<c:import url="../../include/commonTeamProject.jsp"></c:import>
<!-- 팀 프로젝트 팀 정보 End -->

<div class="lybox-title"><!-- lybox-title -->
    <h4 class="section-title"><spring:message code="필드:팀프로젝트:팀프로젝트참여정보" /></h4>
</div>

<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
            <a href="#"><spring:message code="필드:팀프로젝트:게시판" /></a>
        </li>
        <li class="ui-state-default ui-corner-top">
            <a onclick="doMutualeval({courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>', courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})">
                <spring:message code="필드:팀프로젝트:상호평가" />
            </a>
        </li>
    </ul>
</div>	
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
                    <c:import url="../../srchTeamProjectResult.jsp"/>
				</div>

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
						<th>
							<c:choose>
								<c:when test="${boardType eq 'faq'}"> <%-- FAQ --%>
									<spring:message code="필드:게시판:질문"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:게시판:제목"/>
								</c:otherwise>
							</c:choose>
						</th>
						<td>
							<c:if test="${detailBbs.bbs.alwaysTopYn eq 'Y'}">[<spring:message code="필드:게시판:공지" />]</c:if>
							<c:if test="${detailBbs.bbs.secretYn eq 'Y'}">[<spring:message code="필드:게시판:비밀글" />]</c:if>
							<c:out value="${detailBbs.bbs.bbsTitle}"/>
						</td>
					</tr>
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
							<th><spring:message code="필드:게시판:다운로드가능여부"/></th>
							<td>
								<aof:code type="print" name="downloadYn" codeGroup="YESNO" selected="${detailBbs.bbs.downloadYn}" removeCodePrefix="true"/>
					            </span>
							</td>
						</tr>
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
				</tbody>
				</table>
			
                <form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
                    <input type="hidden" name="bbsSeq" value="<c:out value="${detailBbs.bbs.bbsSeq}"/>"/>
                    <input type="hidden" name="boardSeq" value="<c:out value="${detailBbs.bbs.boardSeq}"/>"/>
                    <input type="hidden" name="courseTeamProjectSeq" value="<c:out value="${bbs.courseTeamProjectSeq}"/>" />
                    <input type="hidden" name="courseTeamSeq" value="<c:out value="${bbs.courseTeamSeq}"/>" />
                </form>
				<div class="lybox-btn">	
					<div class="lybox-btn-r">
						<c:if test="${detailBbs.bbs.regMemberSeq eq ssMemberSeq}">
							<c:if test="${boardType ne 'notice' and boardType ne 'faq' and boardType ne 'resource'}">
								<a href="#" onclick="doEdit({'bbsSeq' : '<c:out value="${detailBbs.bbs.bbsSeq}"/>'});"
									class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
							</c:if>
						</c:if>
                        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') || ssCurrentRoleCfString eq 'PROF'}">
                            <a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
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
                        
                        <input type="hidden" name="courseTeamProjectSeq" value="<c:out value="${bbs.courseTeamProjectSeq}"/>" />
                        <input type="hidden" name="courseTeamSeq" value="<c:out value="${bbs.courseTeamSeq}"/>" />
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