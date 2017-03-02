<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE"    value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_MOOC"      value="${aoffn:code('CD.CATEGORY_TYPE.MOOC')}"/>

<c:choose>
    <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_NONDEGREE}">
        <%// 비학위 분류 %>
        <c:set var="categoryUrlPath" value="/non"/>
    </c:when>
    <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_MOOC}">
        <%// MOOC 분류 %>
        <c:set var="categoryUrlPath" value="/mooc"/>
    </c:when>
    <c:otherwise>
        <%// 학위 분류 %>
        <c:set var="categoryUrlPath" value=""/>
    </c:otherwise>
</c:choose>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/coursemaster${categoryUrlPath}/list.do"/>";

    forEdit = $.action();
    forEdit.config.formId = "FormDetail";
    forEdit.config.url    = "<c:url value="/univ/coursemaster/edit.do"/>";
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
    // 수정화면 form을 reset한다.
    UT.getById(forEdit.config.formId).reset();
    // 수정화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
    // 수정화면 실행
    forEdit.run();
};

</script>
</head>

<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
    </c:import>

    <div style="display:none;">
        <c:import url="srchCourseMaster.jsp"/>
    </div>
    
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th><spring:message code="필드:교과목:교과목명"/></th>
            <td>
                <c:out value="${detail.courseMaster.courseTitle}"></c:out>
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:교과목:분류"/></th>
            <td>
                <c:out value="${detail.category.categoryString}"/>
            </td>
        </tr>
        <c:if test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
        <tr>
            <th><spring:message code="필드:교과목:이수구분"/></th>
            <td>
               <aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${detail.courseMaster.completeDivisionCd}"></aof:code>
            </td>
        </tr>
        </c:if>
        <tr>
            <th><spring:message code="필드:교과목:교과목소개"/></th>
            <td>
                <aof:text type="whiteTag" value="${detail.courseMaster.introduction}"/>
            </td>
        </tr>
        <%--
        <tr>
            <th><spring:message code="필드:교과목:교과목목표"/></th>
            <td>
               <aof:text type="whiteTag" value="${detail.courseMaster.goal}"/>
            </td>
        </tr>
         --%>
        <tr>
            <th><spring:message code="필드:교과목:상태"/></th>
            <td>
               <aof:code type="print" codeGroup="COURSE_STATUS" selected="${detail.courseMaster.courseStatusCd}"></aof:code>
            </td>
        </tr>
        <%--
        <tr>
            <th><spring:message code="필드:교과목:최초동기화일자"/></th>
            <td>
               <aof:date datetime="${detail.courseMaster.updDtime}" pattern="${aoffn:config('format.datetime')}"/>
            </td>
        </tr>
         --%>
    </tbody>
    </table>
    
    <div class="lybox-btn"> 
	    <div class="lybox-btn-r">
 <%--            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') and detail.category.categoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
                <% /** TODO : 코드*/ 
	               //비학위만 수정가능
	            %>
                <a href="#" onclick="doEdit({'courseMasterSeq' : '<c:out value="${detail.courseMaster.courseMasterSeq}"/>'});" class="btn blue">
                    <span class="mid"><spring:message code="버튼:수정"/></span>
                </a>
            </c:if> --%>
	        <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
	    </div>
	</div>

    <div class="clear"><br></div>
</body>
</html>