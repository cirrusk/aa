<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<!-- 오늘 날짜 가져오기 -->
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="discussStatus" value=""/><!-- 토론 상태값(DB에 없음) 대기, 진행, 종료 -->
<c:choose>
	<c:when test="${detail.discuss.startDtime <= appToday and detail.discuss.endDtime > appToday}">
		<c:set var="discussStatus" value="PROGRESS"/>
	</c:when>
	<c:when test="${detail.discuss.startDtime <= appToday and detail.discuss.endDtime < appToday}">
		<c:set var="discussStatus" value="FINISH"/>
	</c:when>
	<c:otherwise>
		<c:set var="discussStatus" value="WAIT"/>
	</c:otherwise>
</c:choose>


<html decorator="classroom-layer">
<head>
<title><spring:message code="필드:개설과목:토론"/></title>
<script type="text/javascript">

var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forEditBoard  = null;

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
	forSearch.config.url    = "<c:url value="/usr/classroom/bbs/discuss/list/iframe.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/classroom/bbs/discuss/list/iframe.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/usr/classroom/bbs/discuss/detail/iframe.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/usr/classroom/bbs/discuss/create/iframe.do"/>";

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

</script>
</head>

<body>

<c:import url="./detailDiscussImport.jsp"/>

<div class="vspace"></div>

<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="글:토론:토론게시글목록" />
    </h4>
</div>

<c:import url="srchDiscussBbs.jsp"/>

<c:import url="/WEB-INF/view/include/perpage.jsp">
	<c:param name="onchange" value="doSearch"/>
	<c:param name="selected" value="${condition.perPage}"/>
</c:import>		

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<table id="listTable" class="tbl-list">
<colgroup>
	<col style="width: 50px" />
	<col style="width: 90px" />
	<col style="width: auto" />
	<col style="width: 100px" />
	<col style="width: 100px" />
	<col style="width: 60px" />
</colgroup>
<thead>
	<tr>
		<th><spring:message code="필드:번호" /></th>
		<th><spring:message code="필드:토론:의견구분" /></th>
		<th><spring:message code="필드:게시판:제목" /></th>
		<th><spring:message code="필드:등록자" /></th>
		<th><spring:message code="필드:등록일" /></th>
		<th><spring:message code="필드:게시판:조회수" /></th>
	</tr>
</thead>
<tbody>
<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
	<tr>
        <td><c:out value="${paginate.descIndex - i.index}"/></td>
	    <td><aof:code type="print" codeGroup="DISCUSS_BBS_TYPE" selected="${row.bbs.bbsTypeCd}"/></td>
        <c:if test="${flatModeYn eq 'N'}">
			<c:set var="padding" value="${(row.bbs.groupLevel - 1) * 15}"/>
		</c:if>
		<td class="align-l" style="padding-left:<c:out value="${padding}"/>px;">
			<c:if test="${row.bbs.groupLevel gt 1}">
				re:
			</c:if>
			<c:choose>
				<c:when test="${row.bbs.secretYn eq 'Y'}">
					[<spring:message code="필드:게시판:비밀글" />]
					<a href="#" onclick="doSecretDetail({'bbsSeq' : '${row.bbs.bbsSeq}', 'regMemberSeq' : '${row.bbs.regMemberSeq}' });"><c:out value="${row.bbs.bbsTitle}" /></a>
				</c:when>
				<c:otherwise>
					<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
				</c:otherwise>
			</c:choose>
			<c:if test="${row.bbs.commentCount gt 0}">
				[<c:out value="${row.bbs.commentCount}"/>]
			</c:if>
			<c:if test="${row.bbs.attachCount gt 0}">
				<aof:img src="icon/ico_file.gif"/>
			</c:if>
		</td>
		<td><c:out value="${row.bbs.regMemberName}"/></td>
		<td><aof:date datetime="${row.bbs.regDtime}"/></td>
		<td><c:out value="${row.bbs.viewCount}"/></td>
	</tr>
</c:forEach>
<c:if test="${empty paginate.itemList}">
	<tr>
		<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
	</tr>
</c:if>
</table>
</form>

<c:import url="/WEB-INF/view/include/paging.jsp">
	<c:param name="paginate" value="paginate"/>
</c:import>

<div class="lybox-btn">
	<div class="lybox-btn-r">
		<c:if test="${discussStatus eq 'PROGRESS'}">
			<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:등록" /></span></a>
		</c:if>
	</div>
</div>

</body>
</html>