<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:if test="${boardType eq 'teamproject'}">
    <c:set var="codeGroupBbsType" value="" scope="request"/>
</c:if>

<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forTeamProjectHome  = null;
var forMutualeval       = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/bbs/teamproject/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/bbs/teamproject/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/bbs/teamproject/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/univ/bbs/teamproject/create.do"/>";

	forTeamProjectHome = $.action();
    forTeamProjectHome.config.formId = "FormProjectTeamHome";
    forTeamProjectHome.config.url    = "<c:url value="/univ/teamproject/result/detail.do"/>";
    
    forMutualeval = $.action();
    forMutualeval.config.formId = "FormMutualeval";
    forMutualeval.config.url    = "<c:url value="/univ/teamproject/mutualeval/list.do"/>";
    
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
 * 비밀글 상세보기 화면을 호출하는 함수
 */
doSecretDetail = function(param){
	var sessionMemberSeq = "${ssMemberSeq}";
	if(param.regMemberSeq == sessionMemberSeq){
		var mapPKs= {'bbsSeq' : param.bbsSeq };
		doDetail(mapPKs);
	}else{
		$.alert({
			message : "<spring:message code="글:게시판:비밀글"/>"
		});
	}
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
 * 게시판설정화면을 호출하는 함수
 */
doEditBoard = function(mapPKs) {
	UT.getById(forEditBoard.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forEditBoard.config.formId);
	forEditBoard.run();
};

/**
 * 팀프로젝트 홈 이동
 */
doTeamProjectHome = function(mapPKs){
    UT.copyValueMapToForm(mapPKs, forTeamProjectHome.config.formId);
    forTeamProjectHome.run();
};

/**
 * 상호평가 이동
 */
doMutualeval = function(mapPKs){
	UT.getById(forMutualeval.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forMutualeval.config.formId);
    
    forMutualeval.run();
};

/**
 * 상호평가에서 게시글 수를 클릭후 넘어 올경우
 * srchKey or srchWord 변경될 경우  srchRegMemberSeq 값을 초기화한다.
 */
doInitRegMemberSeq = function(){
	$("input[name='srchRegMemberSeq']").val("");
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
<!--         <li class="ui-state-default ui-corner-top"> -->
<%--             <a onclick="doMutualeval({courseTeamProjectSeq :'<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>',courseTeamSeq :'<c:out value="${detail.courseTeamProjectTeam.courseTeamSeq}"/>'})"> --%>
<%--                 <spring:message code="필드:팀프로젝트:상호평가" /> --%>
<!--             </a> -->
<!--         </li> -->
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
                <c:import url="../../srchTeamProjectResult.jsp"/>
				<c:import url="srchBbs.jsp"/>
				<c:choose>
					<c:when test="${boardType eq 'free'}">
						<c:import url="/WEB-INF/view/include/perpage.jsp">
							<c:param name="onchange" value="doSearch"/>
							<c:param name="selected" value="${condition.perPage}"/>
						</c:import>		
					</c:when>
					<c:otherwise>
						<br/>
					</c:otherwise>
				</c:choose>
			
				<c:set var="flatModeYn" value="N"/>
				<c:if test="${condition.srchSearchYn eq 'Y'}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
				<c:if test="${!empty condition.orderby and condition.orderby ne 0}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
			
				<form id="FormData" name="FormData" method="post" onsubmit="return false;">
				<table id="listTable" class="tbl-list">
				<colgroup>
					<col style="width: 50px" />
					<c:if test="${!empty codeGroupBbsType}">
						<col style="width: 90px" />
					</c:if>
					<col style="width: 220px;" />
					<col style="width: 80px" />
					<col style="width: 120px" />
					<col style="width: 60px" />
				</colgroup>
				<thead>
					<tr>
						<th><spring:message code="필드:번호" /></th>
						<c:if test="${!empty codeGroupBbsType}">
							<c:choose>
								<c:when test="${boardType eq 'notice'}">
									<th><spring:message code="필드:게시판:구분" /></th>
								</c:when>
								<c:when test="${boardType eq 'faq'}">
									<th><spring:message code="필드:게시판:FAQ구분" /></th>
								</c:when>
								<c:when test="${boardType eq 'qna'}">
									<th><spring:message code="필드:게시판:구분" /></th>
								</c:when>
								<c:otherwise>
									<th><span class="sort" sortid="3"><spring:message code="필드:게시판:구분" /></span></th>
								</c:otherwise>
							</c:choose>	
						</c:if>
					
						<c:choose>
							<c:when test="${boardType eq 'notice'}">
								<th><spring:message code="필드:게시판:제목" /></th>
							</c:when>
							<c:when test="${boardType eq 'faq'}">
								<th><spring:message code="필드:게시판:제목" /></th>
							</c:when>
							<c:otherwise>
								<th><span class="sort" sortid="2"><spring:message code="필드:게시판:제목" /></span></th>
							</c:otherwise>
						</c:choose>
						
						<th><spring:message code="필드:등록자" /></th>
						
						<c:choose>
							<c:when test="${boardType eq 'notice'}">
								<th><spring:message code="필드:등록일" /></th>
							</c:when>
							<c:when test="${boardType eq 'faq'}">
								<th><spring:message code="필드:등록일" /></th>
							</c:when>							
							<c:otherwise>
								<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
							</c:otherwise>
						</c:choose>
								
						<th><spring:message code="필드:게시판:조회수" /></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${alwaysTopList}" varStatus="i">
					<tr>
				        <td><spring:message code="필드:게시판:공지" /></td>
				        <c:if test="${!empty codeGroupBbsType}">
				        	<td><aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/></td>
				        </c:if>
						<td class="align-l">
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
							</c:if>
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
					</tr>
				</c:forEach>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
				        <td><c:out value="${paginate.descIndex - i.index}"/></td>
				        <c:if test="${!empty codeGroupBbsType}">
					        <td>
					        	<c:if test="${row.bbs.groupLevel eq 1}">
					        		<aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/>
					        	</c:if>
					        </td>
				        </c:if>
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
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
					</tr>
				</c:forEach>
				<c:if test="${empty alwaysTopList and empty paginate.itemList}">
					<tr>
						<c:set var="colspan" value="5"/>
						<c:if test="${!empty codeGroupBbsType}">
							<c:set var="colspan" value="${colspan + 1}"/>
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
						<c:if test="${boardType ne 'notice' and boardType ne 'faq' and boardType ne 'resource'}">
							<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
						</c:if>
					</div>
				</div>
			
			</c:otherwise>
		</c:choose>
	
	</c:otherwise>
</c:choose>

</body>
</html>