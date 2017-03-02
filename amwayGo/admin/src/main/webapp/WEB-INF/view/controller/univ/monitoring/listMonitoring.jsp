<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch		= null;
var forListdata		= null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
 	// [2] sorting 설정
    FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
 
 	// [3]  
	UI.inputComment("FormSrch");
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action();
    forSearch.config.formId = "FormSrch";
    forSearch.config.url    = "<c:url value="/univ/course/active/monitoring/list.do"/>";

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/course/active/monitoring/list.do"/>";
    
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
 * 학습자 개설과목 강의실 이동 
 */
doMonitoring = function(courseActiveSeq) {
	// JSON형식으로 데이터를 넣으면 member.getExtendData(map)에 값이 담긴다. {"extendData" : [{"name":"observerYn", "value":"Y"},{"name":"memberSeq", "value":"2"}]}
	var extendData = '{"extendData" : [{"name":"observerYn", "value":"Y"}]}';
	document.getElementById("extendData").value = extendData;
	
	var action = $.action("ajax");
	action.config.formId      = "FormMemberLogin";
	action.config.url         = "<c:url value="/common/access/signature.do"/>";
	action.config.type        = "json";
	action.config.fn.complete = function(action, data) {
		if (data.signature !== "") {
			var action2 = $.action();
			action2.config.formId = "FormMemberLogin";
			action2.config.url    = "<c:out value="${aoffn:config('domain.www')}"/>" + "<c:url value="/security/login"/>";
			action2.config.target = "_blank";
			var form = UT.getById(action2.config.formId); 
			form.elements["j_username"].value = data.signature;
			form.elements["j_password"].value = data.password;
			form.elements["j_rolegroup"].value = "2";
			form.elements["courseActiveSeq"].value = courseActiveSeq;
			action2.run();
		}
	};
	action.run();
};
</script>
</head>

<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:목록" /></c:param>
    </c:import>
    
    <form name="FormMemberLogin" id="FormMemberLogin" method="post" onsubmit="return false;">
		<input type="hidden" name="j_username">
		<input type="hidden" name="j_password">
		<input type="hidden" name="j_rolegroup">
		<input type="hidden" name="j_extendData" id="extendData">
		<input type="hidden" name="courseActiveSeq">
		<input type="hidden" name="memberId" value="<c:out value="${ssMemberId }" />">
	</form>
	
    <form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox">
			<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<span>
				<input type="text" name="srchCategoryName" value="${condition.srchCategoryName }" style="width:200px;" />
				<span class="comment"><spring:message code="필드:콘텐츠:분류명"/></span>
			</span>
			<div class="vspace"></div>
			<select name="srchYearTerm">
                <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
            </select>
			<select name="srchCourseActiveStatusCd">
				<aof:code type="option" codeGroup="COURSE_ACTIVE_STATUS" selected="${condition.srchCourseActiveStatusCd }" />
			</select>
			<input type="hidden" name="srchKey" value="courseActiveTitle" />
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 50px" />
        <col style="width: auto" />
        <col style="width: 110px" />
        <col style="width: 110px" />
        <col style="width: 110px" />
        <col style="width: 110px" />
        <col style="width: 120px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:개설과목:교과목" /></span></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:개설과목:과목분류" /></span></th>
            <th><spring:message code="필드:개설과목:수강인원" /></th>
            <th><span class="sort" sortid="3"><spring:message code="필드:개설과목:상태" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:등록일" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:개설과목:모니터링" /></span></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr>
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td class="align-l">
                   <c:choose>
                        <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                            [<c:out value="${row.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/>]<br/>
                            <c:out value="${row.courseActive.courseActiveTitle}"/>
                            <br/>
                           <spring:message code="필드:개설과목:이수구분" /> : <aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row.courseActive.completeDivisionCd}"/>
                        </c:when>
                        <c:otherwise>
                            [<c:out value="${row.courseActive.periodNumber}"/><spring:message code="필드:개설과목:기" />]<br/>
                            <c:out value="${row.courseActive.courseActiveTitle}"/><br/>
                            <spring:message code="필드:개설과목:학습기간" />
                            :
                            <aof:date datetime="${row.courseActive.studyStartDate}"></aof:date>
                            ~
                            <aof:date datetime="${row.courseActive.studyEndDate}"></aof:date>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:out value="${row.category.categoryString}"/>
                </td>
                <td><c:out value="${row.courseActiveSummary.memberCount}"/></td>
                <td><aof:code type="print" codeGroup="COURSE_ACTIVE_STATUS" defaultSelected="${row.courseActive.courseActiveStatusCd}"></aof:code></td>
                <td><aof:date datetime="${row.courseActive.regDtime}"/></td>
                <td>
                	<a href="javascript:void(0)" onclick="doMonitoring('<c:out value="${row.courseActive.courseActiveSeq }" />')" class="btn blue"><span class="mid"><spring:message code="버튼:개설과목:모니터링" /></span></a>
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