<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_BOARD_TYPE_APPEAL"    value="${aoffn:code('CD.BOARD_TYPE.APPEAL')}"/>

<c:import url="/WEB-INF/view/include/session.jsp"/>
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

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_CATEGORY_TYPE_DEGREE = "<c:out value="${CD_CATEGORY_TYPE_DEGREE}"/>";

var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
	UI.inputComment("FormSrch");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/list.do"/>";
	
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/mypage/univ/course/group/bbs/${boardType}/create.do"/>";

};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
	var form = UT.getById(forSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearch.run();
};

/**
 * 검색조건 초기화
 */
doSearchReset = function() {
	FN.resetSearchForm(forSearch.config.formId);
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doList();
};

/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};

/**
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	UT.getById(forCreate.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	forCreate.run();
};

/**
 * 검색 학위 비학위 셀렉트 박스 변경시 2차검색셀렉트 박스 변경
 */
doSelectCategoryType = function(element) {
	var categoryType = element.value;
	var systemYearTerm = "<c:out value="${systemYearTerm}"/>";

	if(categoryType == CD_CATEGORY_TYPE_DEGREE){
		$("#yearTerm").show();
		$("#year").hide();
	}else {
		$("#year").show();
		$("#srchYearTerm").val(systemYearTerm).attr("selected", "selected");
		$("#yearTerm").hide();
	}
};

/**
 * 미답변 리스트 체크박스 선택시
 */
doChangeReply = function(element) {
	var form = UT.getById(forSearch.config.formId);
	form.elements["srchReplyOnlyCheckYn"].value = element.value;
	forSearch.run();
}

</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:목록" /></c:param>
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
				
				<c:import url="srchBbs.jsp"/>
				
				<div class="vspace"></div>
				<div class="vspace"></div>
							
				<c:import url="/WEB-INF/view/include/perpage.jsp">
					<c:param name="onchange" value="doSearch"/>
					<c:param name="selected" value="${condition.perPage}"/>
				</c:import>
				
				<c:set var="flatModeYn" value="N"/>
				<c:if test="${condition.srchSearchYn eq 'Y'}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
				<c:if test="${!empty condition.orderby and condition.orderby ne 0}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
			
				<form id="FormData" name="FormData" method="post" onsubmit="return false;">
				<div class="lybox-btn-l">
					<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
						<input type="radio" name="replyOnlyCheckYn" value="N" onclick="doChangeReply(this)" <c:if test="${condition.srchReplyOnlyCheckYn eq 'N'}">checked="checked"</c:if>>전체
						<input type="radio" name="replyOnlyCheckYn" value="Y" onclick="doChangeReply(this)" <c:if test="${condition.srchReplyOnlyCheckYn eq 'Y'}">checked="checked"</c:if>>미답변
					</c:if>
				</div>
				<table id="listTable" class="tbl-list">
				<colgroup>
					<col style="width: 50px" />
					<col style="width: auto" />
					<col style="width: 120px" />
					<col style="width: 120px" />
					<!-- 과목공지 사항 -->
					<c:if test="${codeGroupBbsType eq 'BBS_TYPE_NOTICE'}">
						<col style="width: 120px" />
					</c:if>
					<!-- 성적이의 신청 -->
					<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
						<col style="width: 120px" />	
						<col style="width: 120px" />
					</c:if>
				</colgroup>
				<thead>
					<tr>
						<th><spring:message code="필드:번호" /></th>
						<th><span class="sort" sortid="1"><spring:message code="필드:게시판:제목" /></span></th>
						<th><spring:message code="필드:등록자" /></th>
						<th><span class="sort" sortid="2"><spring:message code="필드:등록일" /></span></th>
						<!-- 과목공지사항 -->
						<c:if test="${codeGroupBbsType eq 'BBS_TYPE_NOTICE'}">
							<th><spring:message code="필드:게시판:조회수" /></th>
						</c:if>
						<!-- 성적이의 신청 -->
						<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
							<th><spring:message code="필드:게시판:조회수" /></th>							
							<th><spring:message code="필드:게시판:답변여부" /></th>
						</c:if>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${alwaysTopList}" varStatus="i">
						<tr>
					        <td><spring:message code="필드:게시판:공지" /></td>
							<td class="align-l">
								<c:if test="${row.bbs.secretYn eq 'Y'}">
									[<spring:message code="필드:게시판:비밀글" />]
								</c:if>
								<c:if test="${row.bbs.groupLevel eq 1}">
									<c:out value="${row.courseActive.courseActiveTitle}" />
									<c:if test="${row.bbs.bbsCount gt 1}" >
										<spring:message code="글:게시판:외" /> <c:out value="${row.bbs.bbsCount - 1}" />
									</c:if>
									<br/>
								</c:if>
								<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
								<c:if test="${row.bbs.attachCount gt 0}">
									<aof:img src="icon/ico_file.gif"/>
								</c:if>
							</td>
							<td><c:out value="${row.bbs.regMemberName}"/></td>
							<td><aof:date datetime="${row.bbs.regDtime}"/></td>
							<c:if test="${codeGroupBbsType eq 'BBS_TYPE_NOTICE'}">
								<td><c:out value="${row.bbs.viewCount}"/></td>
							</c:if>
							<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
								<td><c:out value="${row.bbs.viewCount}"/></td>
								<c:choose>
									<c:when test="${row.bbs.replyCount eq 0}">
										<td><spring:message code="글:게시판:답변" /></td>
									</c:when>
									<c:otherwise>
										<td><spring:message code="글:게시판:미답변" /></td>
									</c:otherwise>
								</c:choose>
							</c:if>
						</tr>
				</c:forEach>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
				        <td><c:out value="${paginate.descIndex - i.index}"/></td>
				        <c:if test="${flatModeYn eq 'N'}">
							<c:set var="padding" value="${(row.bbs.groupLevel - 1) * 15}"/>
						</c:if>
						<td class="align-l" style="padding-left:<c:out value="${padding}"/>px;">
							<c:if test="${row.bbs.groupLevel gt 1}">
								re:
							</c:if>
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
							</c:if>
							<c:if test="${row.bbs.groupLevel eq 1}">
									<c:choose>
										<c:when test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
												[<c:out value="${row.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/>]
												<c:out value="${row.courseActive.courseActiveTitle}" />
										</c:when>
										<c:otherwise>
											[<c:out value="${row.courseActive.year}"/>]
											<c:out value="${row.courseActive.courseActiveTitle}" />	
										</c:otherwise>
									</c:choose>
								<c:if test="${row.bbs.bbsCount gt 1}" >
									<spring:message code="글:게시판:외" /> <c:out value="${row.bbs.bbsCount - 1}" />
								</c:if>
								<br/>
							</c:if>
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<!-- 과목공지사항 -->
						<c:if test="${codeGroupBbsType eq 'BBS_TYPE_NOTICE'}">
							<td><c:out value="${row.bbs.viewCount}"/></td>
						</c:if>
						<!-- 성적이의 신청 -->
						<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
							<td><c:out value="${row.bbs.viewCount}"/></td>
							<c:choose>
								<c:when test="${row.bbs.replyCount eq 0}">
									<td><spring:message code="글:게시판:미답변" /></td>
								</c:when>
								<c:otherwise>
									<td><spring:message code="글:게시판:답변" /></td>
								</c:otherwise>
							</c:choose>
						</c:if>
					</tr>
				</c:forEach>
				<c:if test="${empty alwaysTopList and empty paginate.itemList}">
					<tr>
						<c:set var="colspan" value="4"/>
						<c:if test="${codeGroupBbsType eq 'BBS_TYPE_NOTICE'}">
							<c:set var="colspan" value="${colspan + 1}"/>
						</c:if>
						<c:if test="${codeGroupBbsType eq CD_BOARD_TYPE_APPEAL}">
							<c:set var="colspan" value="${colspan + 2}"/>
						</c:if>
						<td colspan="<c:out value="${colspan}"/>" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</table>
				</form>
			
				<c:import url="/WEB-INF/view/include/paging.jsp">
					<c:param name="paginate" value="paginate"/>
				</c:import>
			
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
							<c:choose>
								<c:when test="${boardType eq 'notice'}">
									<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>	
								</c:when>
								<c:otherwise>
								</c:otherwise>													
							</c:choose>
						</c:if>
					</div>
				</div>
			
			</c:otherwise>
		</c:choose>
	
	</c:otherwise>
</c:choose>

</body>
</html>