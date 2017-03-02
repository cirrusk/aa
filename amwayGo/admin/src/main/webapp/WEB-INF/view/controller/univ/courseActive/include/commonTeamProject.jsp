<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: auto" />
        <col style="width: 220px" />
        <col style="width: 60px" />
        <col style="width: 100px" />
        <%--<col style="width: 70px" /> --%>
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:팀프로젝트:프로젝트제목" /></th>
            <th><spring:message code="필드:팀프로젝트:프로젝트기간" /></th>
            <th><spring:message code="필드:팀프로젝트:상태" /></th>
            <th><spring:message code="필드:팀프로젝트:팀구성" /></th>
            <%--<th><spring:message code="필드:팀프로젝트:평가비율" /></th> --%>
        </tr>
    </thead>
    <tbody>
    <c:set var="totalRate" value="0"></c:set>
    <c:set var="nonSavingData" value="0"></c:set>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td class="align-l">
                <c:out value="${row.courseTeamProject.teamProjectTitle}"/>
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
            
            <td><aof:code type="print" codeGroup="TEAM_PROJECT_STATUS" selected="${row.courseTeamProject.teamProjectStatusCd}"/> </td>
            <td>
                <c:choose>
                    <c:when test="${row.courseTeamProject.projectTeamCount > 0}">
                        <c:out value="${row.courseTeamProject.projectTeamCount}"/><spring:message code="필드:팀프로젝트:팀" />
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </td>
            <%--
            <td>
                <c:out value="${row.courseTeamProject.rate}"/>%
            </td>
             --%>
        </tr>
        <c:set var="totalRate" value="${totalRate + row.courseTeamProject.rate}"></c:set>
        <c:if test="${row.courseTeamProject.rate > 0}">
            <c:set var="nonSavingData" value="${nonSavingData + 1}"></c:set>
        </c:if>
    </c:forEach>
    <c:choose>
        <c:when test="${empty itemList}">
            <tr>
                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="3" class="align-l">※ <spring:message code="글:팀프로젝트:평가비율총합은100%이어야합니다." /></td>
                <td><spring:message code="필드:팀프로젝트:합계" /></td>
                <td id="totalRate"><c:out value='${totalRate}'/>%</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
    </table>