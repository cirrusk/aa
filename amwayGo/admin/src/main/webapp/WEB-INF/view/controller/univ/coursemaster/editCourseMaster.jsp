<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>

<c:choose>
    <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_NONDEGREE}">
        <%// 비학위 분류 %>
        <c:set var="categoryUrlPath" value="/non"/>
    </c:when>
    <c:otherwise>
        <%// MOOC 분류 %>
        <c:set var="categoryUrlPath" value="/mooc"/>
    </c:otherwise>
</c:choose>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forUpdate   = null;
var forDelete   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    UI.editor.create("introduction");
    
    //UI.editor.create("goal");
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/coursemaster${categoryUrlPath}/list.do"/>";

    forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdate.config.url             = "<c:url value="/univ/coursemaster/update.do"/>";
    forUpdate.config.target          = "hiddenframe";
    forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdate.config.fn.complete     = function() {
        doList();
    };
    
    forDelete = $.action("submit");
    forDelete.config.formId          = "FormDelete"; 
    forDelete.config.url             = "<c:url value="/univ/coursemaster/delete.do"/>";
    forDelete.config.target          = "hiddenframe";
    forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
    forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDelete.config.fn.complete     = function() {
        doList();
    };
    
    setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
    forUpdate.validator.set({
        title : "<spring:message code="필드:교과목:교과목명"/>",
        name : "courseTitle",
        data : ["!null"],
        check : {
            maxlength : 600
        }
    });
};

/**
 * 저장
 */
doUpdate = function() { 
    // editor 값 복사
    UI.editor.copyValue();
    forUpdate.run();
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

/**
 * 삭제
 */
doDelete = function() { 
    forDelete.run();
};

/**
 * 분류정보 세팅
 */
doSetCategorySeq = function(seq) {
    var form = UT.getById(forUpdate.config.formId);
    form.elements["categoryOrganizationSeq"].value = (typeof seq === "undefined" || seq == null ? "" : seq);
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>

    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
    </c:import>

    <div style="display:none;">
        <c:import url="srchCourseMaster.jsp"/>
    </div>
    <form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${detail.courseMaster.courseMasterSeq}"/>"/>
    <input type="hidden" name="categoryOrganizationSeq" value="<c:out value="${detail.courseMaster.categoryOrganizationSeq}"/>"/>
    <input type="hidden" name="oldCategoryOrganizationSeq" value="<c:out value="${detail.courseMaster.categoryOrganizationSeq}"/>"/>
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th><spring:message code="필드:교과목:교과목명"/><span class="star">*</span></th>
            <td>
                <input type="text" name="courseTitle" style="width:350px;" value="<c:out value="${detail.courseMaster.courseTitle}"/>">
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:교과목:분류"/></th>
            <td>
                <c:out value="${detail.category.categoryString}"/>
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:교과목:교과목소개"/><span class="star">*</span></th>
            <td>
                <textarea name="introduction" id="introduction" style="width:100%; height:100px"><c:out value="${detail.courseMaster.introduction}"/></textarea>
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
               <aof:code type="radio" name="courseStatusCd" codeGroup="COURSE_STATUS" selected="${detail.courseMaster.courseStatusCd}"></aof:code>
            </td>
        </tr>
    </tbody>
    </table>
    </form>
    
    <form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
        <input type="hidden" name="courseMasterSeq" value="<c:out value="${detail.courseMaster.courseMasterSeq}"/>"/>
        <input type="hidden" name="categoryOrganizationSeq" value="<c:out value="${detail.courseMaster.categoryOrganizationSeq}"/>"/>
    </form>
                
    <div class="lybox-btn">
        <div class="lybox-btn-l">
            <c:choose>
                <c:when test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') && detail.courseMaster.useCount < 1}">
                    <a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
                </c:when>
                <c:otherwise>
                   *  <spring:message code="글:교과목:개설교과목활용수가0개인교과목만삭제가능합니다."/>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
                <a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
            </c:if>
            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>

    <div class="clear"><br></div>
</body>
</html>