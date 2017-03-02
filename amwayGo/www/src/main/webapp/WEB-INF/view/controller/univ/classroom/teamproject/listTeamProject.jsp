<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_TEAM_PROJECT_STATUS_D" value="${aoffn:code('CD.TEAM_PROJECT_STATUS.D')}"/>

<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">
var forDetail                = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
    forDetail = $.action();
    forDetail.config.formId = "FormDetailTeam";
    forDetail.config.url    = "<c:url value="/usr/classroom/teamproject/detail.do"/>";

    setValidate();
};

setValidate = function() {};

/**
 * 상세보기 가져오기 실행.
 */
 doDetail = function(mapPKs) {
    UT.getById(forDetail.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    forDetail.run();
};

</script>
</head>

<body>
<div style="display: none;">
    <c:import url="srchTeamProject.jsp"></c:import>
</div>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 60px" />
        <col style="width: auto" />
        <col style="width: 250px" />
        
        <col style="width: 60px" />
        <col style="width: 100px" />
        <col style="width: 70px" />
    </colgroup>
    <thead>
        <tr>
            <th rowspan="2"><spring:message code="필드:번호" /></th>
            <th rowspan="2"><spring:message code="필드:팀프로젝트:팀프로젝트주제" /></th>
            <th rowspan="2"><spring:message code="필드:팀프로젝트:프로젝트기간" /></th>
            <th rowspan="2"><spring:message code="필드:팀프로젝트:상태" /></th>
            <th colspan="2"><spring:message code="필드:팀프로젝트:참여여부" /></th>
        </tr>
        <tr>
            <th><spring:message code="필드:팀프로젝트:과제" /></th>
            <th><spring:message code="필드:팀프로젝트:게시판" /></th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td>
                <c:out value="${i.count}"/>
            </td>
            <td class="align-l">
                <%/** TODO : 코드*/ %>
                <c:choose>
                    <c:when test="${row.courseTeamProject.teamProjectStatusCd eq CD_TEAM_PROJECT_STATUS_D}">
                        <a href="javascript:void(0)" onclick="doDetail({courseTeamProjectSeq : '<c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>',courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>'})">
                            <c:out value="${row.courseTeamProject.teamProjectTitle}"/>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${row.courseTeamProject.teamProjectTitle}"/>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <spring:message code="필드:팀프로젝트:진행기간" /> 
                : 
                <aof:date datetime="${row.courseTeamProject.startDtime}"/>
                ~
                <aof:date datetime="${row.courseTeamProject.endDtime}"/>
                <br/>
                <spring:message code="필드:팀프로젝트:과제제출" />
                :
                <aof:date datetime="${row.courseTeamProject.homeworkStartDtime}"/>
                ~
                <aof:date datetime="${row.courseTeamProject.homeworkEndDtime}"/>
            </td>
            <%/** TODO : 코드*/ %>
            <td><aof:code type="print" codeGroup="TEAM_PROJECT_STATUS" selected="${row.courseTeamProject.teamProjectStatusCd}"/> </td>
            <td>
                <c:choose>
                    <c:when test="${row.courseHomeworkAnswer.homeworkCount > 0}">
                        <spring:message code="필드:팀프로젝트:제출" />
                    </c:when>
                    <c:otherwise>
                        <spring:message code="필드:팀프로젝트:미제출" />
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:choose>
                    <c:when test="${row.courseActiveBbs.bbsCount > 0}">
                        <spring:message code="필드:팀프로젝트:참여" />
                    </c:when>
                    <c:otherwise>
                        <spring:message code="필드:팀프로젝트:미참여" />
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty itemList}">
        <tr>
            <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
        </tr>
    </c:if>
    </tbody>
    </table>
</body>
</html>