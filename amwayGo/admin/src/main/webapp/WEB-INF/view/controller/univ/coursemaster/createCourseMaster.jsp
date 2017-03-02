<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_STATUS_001"       value="${aoffn:code('CD.COURSE_STATUS.001')}"/>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>

<c:choose>
    <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_NONDEGREE}">
        <%// 비학위 분류 %>
        <c:set var="selectedSeq" value="2"/>
        <c:set var="categoryUrlPath" value="/non"/>
    </c:when>
    <c:otherwise>
        <%// MOOC 분류 %>
        <c:set var="selectedSeq" value="4"/>
        <c:set var="categoryUrlPath" value="/mooc"/>
    </c:otherwise>
</c:choose>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    UI.editor.create("introduction");
    
    //UI.editor.create("goal");
    
    //카테고리 select 설정
    BrowseCategory.create({
        "categoryTypeCd" : "<c:out value="${condition.srchCategoryTypeCd}"/>",
        "callback" : "doSetCategorySeq",
        "selectedSeq" : "<c:out value="${selectedSeq}"/>",
        "appendToId" : "categoryStep",
        "selectOption" : "regist"
    });
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/coursemaster${categoryUrlPath}/list.do"/>";
    
    forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsert.config.url             = "<c:url value="/univ/coursemaster/insert.do"/>";
    forInsert.config.target          = "hiddenframe";
    forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forInsert.config.fn.complete     = function() {
        doList();
    };

    setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:교과목명"/>",
        name : "courseTitle",
        data : ["!null"],
        check : {
            maxlength : 600
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:교과목소개"/>",
        name : "introduction",
        data : ["!null"]
    });
    <%--
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:교과목목표"/>",
        name : "goal",
        data : ["!null"]
    });
    --%>

};
/**
 * 저장
 */
doInsert = function() {
	// editor 값 복사
    UI.editor.copyValue();
    forInsert.run();
};
/**
 * 목록보기
 */
doList = function() {
    forListdata.run();
};

/**
 * 분류정보 세팅
 */
doSetCategorySeq = function(seq) {
    var form = UT.getById(forInsert.config.formId);
    form.elements["categoryOrganizationSeq"].value = (typeof seq === "undefined" || seq == null ? "" : seq);
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
    </c:import>

    <div style="display:none;">
        <c:import url="srchCourseMaster.jsp"/>
    </div>

    <form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
    <input type="hidden" name="categoryOrganizationSeq"/>
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th><spring:message code="필드:교과목:교과목명"/><span class="star">*</span></th>
            <td>
                <input type="text" name="courseTitle" style="width:350px;">
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:교과목:분류"/><span class="star">*</span></th>
            <td>
                <div id="categoryStep"></div>
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:교과목:교과목소개"/><span class="star">*</span></th>
            <td>
                <textarea name="introduction" id="introduction" style="width:100%; height:100px"></textarea>
            </td>
        </tr>
        <%--
        <tr>
            <th><spring:message code="필드:교과목:교과목목표"/><span class="star">*</span></th>
            <td>
                <textarea name="goal" id="goal" style="width:100%; height:100px"><c:out value="${detail.courseMaster.goal}"/></textarea>
            </td>
        </tr>
         --%>
        <tr>
            <th><spring:message code="필드:교과목:상태"/><span class="star">*</span></th>
            <td>
               <aof:code type="radio" name="courseStatusCd" codeGroup="COURSE_STATUS" defaultSelected="${CD_COURSE_STATUS_001}"/>
            </td>
        </tr>
    </tbody>
    </table>
    </form>

    <div class="lybox-btn">
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>