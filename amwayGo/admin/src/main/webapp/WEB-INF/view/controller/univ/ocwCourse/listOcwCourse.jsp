<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
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
    forSearch.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";
    
    forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/ocw/course/list.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/ocw/course/detail.do"/>";
	
	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/univ/ocw/course/create.do"/>";
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
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};

/**
 * 등록화면을 호출하는 함수
 */
doCreate = function() {
	forCreate.run();
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
	
	<c:import url="srchOcwCourse.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="callback" value="doList"/>
    <input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${condition.srchCategoryTypeCd}"/>">
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 50px" />
        <col style="width: *" />
        <col style="width: 110px" />
        <col style="width: 110px" />
        <col style="width: 100px" />
        <col style="width: 110px" />
        <col style="width: 120px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:개설과목:과목명" /></span></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:개설과목:제공자" /></span></th>
            <th><span class="sort" sortid="3"><spring:message code="필드:등록자" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:개설과목:상태" /></span></th>
            <th><span class="sort" sortid="5"><spring:message code="필드:등록일" /></span></th>
            <th><spring:message code="필드:개설과목:상세보기" /></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
           <tr>
	        	<td><c:out value="${paginate.descIndex - i.index}"/></td>
	        	<td class="align-l">
	        		<c:out value="${row.cate.categoryString}"/><br />
	        		<c:out value="${row.courseActive.courseActiveTitle}"/> | <c:out value="${row.ocwCourse.elementCount}"/> <spring:message code="글:과정:강" /> | <c:out value="${row.ocwCourse.profMemberName}"/>
	        	</td>
	        	<td><c:out value="${row.ocwCourse.offerName}"/></td>
	        	<td><c:out value="${row.ocwCourse.regMemberName}"/></td>
	        	<td><aof:code type="print" codeGroup="COURSE_ACTIVE_STATUS" defaultSelected="${row.courseActive.courseActiveStatusCd}"></aof:code></td>
                <td><aof:date datetime="${row.courseActive.regDtime}"/></td>
                <td><a href="#" onclick="javascript:doDetail({'ocwCourseActiveSeq' : '<c:out value="${row.ocwCourse.ocwCourseActiveSeq}" />'});" class="btn gray"><span class="small"><spring:message code="필드:개설과목:보기"/></span></a></td>
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
    
    <div class="lybox-btn">
        <div class="lybox-btn-r">
            <a href="javascript:void(0)" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
        </div>
    </div>
    
</body>
</html>