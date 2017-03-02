<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<head>
<title></title>
<script type="text/javascript">

var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forApplyList  = null;

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
	forSearch.config.url    = "<c:url value="/univ/course/discuss/result/bbs/list/iframe.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/discuss/result/bbs/list/iframe.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/discuss/result/bbs/detail/iframe.do"/>";

	forApplyList = $.action();
	forApplyList.config.formId = "FormApplyList";
	forApplyList.config.url    = "<c:url value="/univ/course/discuss/result/apply/list/iframe.do"/>";
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
 * 토론자목록 가져오기 실행.
 */
doApplyList = function() {
	forApplyList.run();
}

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};

</script>
</head>

<body>

<c:import url="srchDiscussBbs.jsp"/>

<div class="vspace"></div>

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<table id="listTable" class="tbl-list">
<colgroup>
	<col style="width: 50px" />
	<col style="width: 90px" />
	<col style="width: auto" />
	<col style="width: 110px" />
	<col style="width: 80px" />
	<col style="width: 80px" />
	<col style="width: 60px" />
</colgroup>
<thead>
	<tr>
		<th><spring:message code="필드:번호" /></th>
		<th><spring:message code="필드:토론:의견구분" /></th>
		<th><spring:message code="필드:게시판:제목" /></th>
		<th><spring:message code="필드:토론:평가대상여부" /></th>
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
		<td><aof:code type="print" codeGroup="YESNO" removeCodePrefix="true" selected="${row.bbs.evaluateYn}"/></td>
		<td><c:out value="${row.bbs.regMemberName}"/></td>
		<td><aof:date datetime="${row.bbs.regDtime}"/></td>
		<td><c:out value="${row.bbs.viewCount}"/></td>
	</tr>
</c:forEach>
<c:if test="${empty paginate.itemList}">
	<tr>
		<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
	</tr>
</c:if>
</table>
</form>

<c:import url="/WEB-INF/view/include/paging.jsp">
	<c:param name="paginate" value="paginate"/>
</c:import>

<c:if test="${not empty condition.srchRegMemberSeq}">
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<a href="#" onclick="doApplyList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
</c:if>
</body>
</html>