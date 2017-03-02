<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
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
	forSearch.config.url    = "<c:url value="/univ/course/bbs/stat/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/bbs/stat/list.do"/>";
	
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
</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:목록" /></c:param>
</c:import>
<c:import url="srchBbsStat.jsp"></c:import>

<c:import url="/WEB-INF/view/include/perpage.jsp">
    <c:param name="onchange" value="doSearch"/>
    <c:param name="selected" value="${condition.perPage}"/>
</c:import>


 <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 40px;" />
        <col style="width: 140px;" />
        <col style="width: 220px;" />
        <col style="width: 70px" />
        <col style="width: 70px;" />
        <col style="width: 70px" />
        <col style="width: 70px;" />
    </colgroup>
    <thead>
        <tr>
            <th rowspan="2"><spring:message code="필드:번호" /></th>
            <th rowspan="2"><spring:message code="필드:게시판:이름" /></th>
            <th rowspan="2"><span class="sort" sortid="1"><spring:message code="필드:게시판:과정명" /></span></th>
            <th colspan="2"><spring:message code="필드:게시판:팀활동" /></th>
            <th colspan="2"><spring:message code="필드:게시판:자료사례공유" /></th>
        </tr>
        <tr>
        	<th><span class="sort" sortid="2"><spring:message code="필드:게시판:게시물수" /></span></th>
            <th><span class="sort" sortid="3"><spring:message code="필드:게시판:코멘트수" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:게시판:게시물수" /></span></th>
            <th><span class="sort" sortid="5"><spring:message code="필드:게시판:코멘트수" /></span></th>
        </tr>
    </thead>
    <tbody>
    	<c:set var="checkIndex" value="0"/>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr>
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td>
                    <c:out value="${row.member.memberName}"/><br/>
                    (<c:out value="${row.member.memberId}"/>)
                </td>
                <td class="align-l">
                   <c:out value="${row.courseActive.courseActiveTitle}"/>
                </td>
                <td>
                	<aof:number value="${row.bbs.teamBbsCount}" pattern="##,###"/>
                </td>
                <td>
                	<aof:number value="${row.bbs.teamCommentCount}" pattern="##,###"/>
                </td>
                <td>
                	<aof:number value="${row.bbs.freeBbsCount}" pattern="##,###"/>
                </td>
                <td>
                	<aof:number value="${row.bbs.freeCommentCount}" pattern="##,###"/>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
            <tr>
                <td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
    </table>
    </form>
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>
</body>
</html>