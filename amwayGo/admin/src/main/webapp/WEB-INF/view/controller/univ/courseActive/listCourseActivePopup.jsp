<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

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
    forSearch.config.url    = "<c:url value="/univ/courseactive/list/popup.do"/>";
    
    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/courseactive/list/popup.do"/>";
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
    if (typeof par["<c:out value="${param['reloadCallback']}"/>"] === "function") {
        par["<c:out value="${param['reloadCallback']}"/>"].call(this,mapPKs);
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
            <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
            <input type="hidden" name="reloadCallback" value="${param['reloadCallback']}"/>
            <input type="hidden" name="rowIdx"     value="<c:out value="${param['rowIdx']}"/>" />
            <c:choose>
                <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                    <select name="srchYearTerm">
                        <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
                    </select>
                </c:when>
                <c:otherwise>
                    <select name="srchYear">
                        <c:import url="/WEB-INF/view/controller/univ/include/yearInc.jsp"></c:import>
                    </select>
                </c:otherwise>
            </c:choose>
            <spring:message code="필드:교과목:학부"/> : 
            <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;"/>
            <div class="vspace"></div>
            <select name="srchCourseActiveStatusCd">
                <option value="ALL" <c:if test="${condition.srchCourseActiveStatusCd eq 'ALL' }">selected="selected"</c:if>><spring:message code="필드:교과목:전체"/></option>
                <aof:code type="option" codeGroup="COURSE_ACTIVE_STATUS" name="srchCourseActiveStatusCd" selected="${condition.srchCourseActiveStatusCd}"/>    
            </select>
            
           
            <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
            <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
	</form>
	
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
        <input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(menuActiveList.menu.menuId)}"/>">
        <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
        <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
        <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
        <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
        <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
    
        <input type="hidden" name="srchYearTerm" value="<c:out value="${condition.srchYearTerm}"/>" />
        <input type="hidden" name="srchYear"     value="<c:out value="${condition.srchYear}"/>" />
        <input type="hidden" name="srchCourseActiveStatusCd"  value="<c:out value="${condition.srchCourseActiveStatusCd}"/>" />
        <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
        <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>
    
        <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
        <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
        <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
        <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
        <input type="hidden" name="reloadCallback" value="<c:out value="${param['reloadCallback']}"/>"/>
        <input type="hidden" name="rowIdx"     value="<c:out value="${param['rowIdx']}"/>" />
	</form>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="reloadCallback" value="<c:out value="${param['reloadCallback']}"/>"/>
    <input type="hidden" name="rowIdx"     value="<c:out value="${param['rowIdx']}"/>" />
    <table id="listTable" class="tbl-list mt10">
    <colgroup>
        <col style="width: 50px" />
        <col style="width: auto" />
        <col style="width: 110px" />
        <col style="width: 60px" />
        <col style="width: 80px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:개설과목:교과목" /></span></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:개설과목:과목분류" /></span></th>
            <th><span class="sort" sortid="3"><spring:message code="필드:개설과목:상태" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:등록일" /></span></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr>
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td class="align-l">
                    <c:set var="yearTermName">
                            <c:out value="${row.courseActive.year}"/><spring:message code="필드:개설과목:년도" />
                            <aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/>
                    </c:set>
                   <c:choose>
                        <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                        	<c:set var="yearTermName"><c:out value="${row.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/></c:set>
                            <a href="#" onclick="doSelect({rowIdx: '${param['rowIdx']}','courseActiveSeq' : '${row.courseActive.courseActiveSeq}','yearTerm' : '${row.courseActive.yearTerm}','yearTermName' : '${yearTermName}','categoryString' : '<c:out value="${row.category.categoryString}"/>','courseMasterSeq' : '<c:out value="${row.courseActive.courseMasterSeq}"/>','courseActiveTitle': '<c:out value="${row.courseActive.courseActiveTitle}"/>'});">
                            [<c:out value="${yearTermName}"/>]
                            <c:out value="${row.courseActive.courseActiveTitle}"/>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" onclick="doSelect({'courseActiveSeq' : '${row.courseActive.courseActiveSeq}','yearTermName' : '${yearTermName}','categoryString' : '<c:out value="${row.category.categoryString}"/>','courseActiveTitle': '<c:out value="${row.courseActive.courseActiveTitle}"/>'});">
                            <%--     [<c:out value="${row.courseActive.periodNumber}"/><spring:message code="필드:개설과목:기" />]--%>
                                <c:out value="${row.courseActive.courseActiveTitle}"/><br/>
                            </a>
                            <spring:message code="필드:개설과목:학습기간" />
                            :
                            <aof:date datetime="${row.courseActive.studyStartDate}"></aof:date>
                            ~
                            <aof:date datetime="${row.courseActive.studyEndDate}"></aof:date>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:out value="${row.category.categoryName}"/>
                </td>
                <td><aof:code type="print" codeGroup="COURSE_ACTIVE_STATUS" defaultSelected="${row.courseActive.courseActiveStatusCd}"></aof:code></td>
                <td><aof:date datetime="${row.courseActive.regDtime}"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
            <tr>
                <td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
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