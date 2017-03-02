<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:팀프로젝트정보" />
    </h4>
</div>
<table class="tbl-detail">
    <colgroup>
        <col style="width:140px" />
        <col/>
        <col style="width:140px" />
        <col style="width:300px" />
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트주제" />
            </th>
            <td class="align-l" colspan="3">
                <c:out value="${detail.courseTeamProject.teamProjectTitle}"/>
            </td>
            <%--
            <th>
                <spring:message code="필드:팀프로젝트:프로젝트기간" />
            </th>
            <td class="align-l">
                <spring:message code="필드:팀프로젝트:진행기간" /> 
                : 
                <aof:date datetime="${detail.courseTeamProject.startDtime}"/>
                ~
                <aof:date datetime="${detail.courseTeamProject.endDtime}"/>
                <br/>
                <spring:message code="필드:팀프로젝트:과제제출" />
                :
                <aof:date datetime="${detail.courseTeamProject.homeworkStartDtime}"/>
                ~
                <aof:date datetime="${detail.courseTeamProject.homeworkEndDtime}"/>
            </td>
            --%>
        </tr>
        
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀이름" />
            </th>
            <td colspan="3" class="align-l">
                <aof:text type="whiteTag" value="${detail.courseTeamProjectTeam.teamTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀장" />
            </th>
            <td colspan="3" class="align-l">
                <c:out value="${detail.member.memberName}"/>(<c:out value="${detail.member.memberId}"/>)
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀원" />
            </th>
            <td colspan="3" class="align-l">
                <c:forEach var="memberRow" items="${detail.teamMemberList}" varStatus="i">
                    <%/** TODO : 코드*/ %>
                    <c:if test="${memberRow.chiefYn ne 'Y'}">
                        <c:out value="${memberRow.teamMemberName}"/><c:if test="${!i.last}">, </c:if>
                    </c:if>
                </c:forEach>
                
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제물점수" />
            </th>
            <td colspan="3" class="align-l">
                <c:choose>
                    <c:when test="${empty detail.courseHomework.homeworkScore}">
                    -
                    </c:when>
                    <c:otherwise>
                        <c:out value="${detail.courseHomework.homeworkScore}"/>
                        <spring:message code="필드:팀프로젝트:점" />
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </tbody>
</table>
<div class="lybox-btn">
    <div class="lybox-btn-r">
        <a href="#" onclick="doTeamProjectHome({courseTeamProjectSeq  : '<c:out value="${detail.courseTeamProject.courseTeamProjectSeq}"/>'})" class="btn blue">
            <span class="mid"><spring:message code="버튼:팀프로젝트:팀프로젝트홈" /></span>
        </a>
    </div>
</div>