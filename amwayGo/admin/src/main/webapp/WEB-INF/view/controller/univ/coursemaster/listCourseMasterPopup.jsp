<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
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
    forSearch.config.url    = "<c:url value="/univ/coursemaster/popup.do"/>";
    
    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/coursemaster/popup.do"/>";
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

/** 교과목 선택*/
doSelect = function(mapPKs){
	var par = $layer.dialog("option").parent;
    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
        par["<c:out value="${param['callback']}"/>"].call(this,mapPKs);
    }
    $layer.dialog("close");
};

</script>
</head>

<body>
    <form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	    <div class="lybox search">
	        <fieldset>
	            <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	            <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	            <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	            <input type="hidden" name="callback"        value="${param['callback']}"/>
	            <%--
                <spring:message code="필드:교과목:학부"/> : 
                <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;"/>
	             
                <input type="radio" name="srchCourseStatusCd" value="" <c:if test="${empty condition.srchCourseStatusCd}">checked="checked"</c:if>>
                --%>
	            <label for="srchCourseStatusCd">상태</label>
	            <aof:code type="radio" codeGroup="COURSE_STATUS" name="srchCourseStatusCd" selected="${condition.srchCourseStatusCd}"/>
	            
                <div class="vspace"></div>
                <%--
                <select name="srchCompleteDivisionCd"  class="select">
                    <option value=""><spring:message code="필드:교과목:전체"/></option>
                    <aof:code type="option" codeGroup="COMPLETE_DIVISION" selected="${condition.srchCompleteDivisionCd}"/>
                </select>
                 --%>
	            <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	            <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
	        </fieldset>
	    </div>
	</form>
	
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	    <input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	    <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	    <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	    <input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	    
	    <input type="hidden" name="srchCompleteDivisionCd"   value="<c:out value="${condition.srchCompleteDivisionCd}"/>" />
	    <input type="hidden" name="srchCourseStatusCd" value="<c:out value="${condition.srchCourseStatusCd}"/>" />
	    <input type="hidden" name="srchCategoryOrganizationSeq" value="<c:out value="${condition.srchCategoryOrganizationSeq}"/>" />
	    <input type="hidden" name="callback" value="${param['callback']}"/>
	</form>
    
    <c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>
    
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 50px" />
        <col style="width: 200px;" />
        <col style="width: 160px" />
        <col style="width: 60px" />
        <col style="width: 80px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:교과목:교과목명" /></span></th>
            <th><spring:message code="필드:교과목:교과목그룹" /></th>
            <th><span class="sort" sortid="5"><spring:message code="필드:교과목:활용수" /></span></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr>
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td class="align-l">
                    <a href="javascript:doSelect({'courseMasterSeq' : '${row.courseMaster.courseMasterSeq}','courseTitle' : '${row.courseMaster.courseTitle}', 'categoryTypeCd' : '${row.category.categoryTypeCd}'});">
                        <c:out value="${row.courseMaster.courseTitle}"/>
                    </a>
                </td>
                <td><c:out value="${row.category.categoryString}"/></td>
                <td><c:out value="${row.courseMaster.useCount}"/></td>
                <td><aof:date datetime="${row.courseMaster.regDtime}"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
            <tr>
                <td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
    </table>
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>
</body>
</html>