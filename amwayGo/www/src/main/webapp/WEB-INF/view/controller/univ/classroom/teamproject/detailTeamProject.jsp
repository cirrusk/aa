<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom-layer">
<head>
<title><spring:message code="필드:팀프로젝트:팀프로젝트" /></title>
<script type="text/javascript">
var forListBbsdata = null;
var forDetail      = null;
var forDetailPopup = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forListBbsdata = $.action();
	forListBbsdata.config.formId = "FormSrch";
	forListBbsdata.config.url    = "<c:url value="/usr/classroom/bbs/teamproject/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormDetailHomework";
    forDetail.config.url    = "<c:url value="/usr/classroom/teamproject/homework/detail.do"/>";
    
    forDetailPopup = $.action();
    forDetailPopup.config.formId = "FormDetailHomework";
    forDetailPopup.config.url    = "<c:url value="/usr/classroom/teamproject/homework/detail/popup.do"/>";

    forDetailPopup = $.action("layer");
    forDetailPopup.config.formId = "FormDetailHomework";
    forDetailPopup.config.url    = "<c:url value="/usr/classroom/teamproject/homework/detail/popup.do"/>";
    forDetailPopup.config.options.width = 600;
    forDetailPopup.config.options.height = 300;
    forDetailPopup.config.options.title = "<spring:message code="필드:팀프로젝트:과제물"/>";
    
    setValidate();
};

setValidate = function() {};

/**
 * 과제물상세보기 가져오기 실행.
 */
 doDetailHomework = function(mapPKs) {
    UT.getById(forDetail.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    forDetail.run();
};

/**
 * 다른 팀의 과제물 상세보기 팝업
 */
doDetailHomeworkPopup = function(mapPKs) {
    UT.getById(forDetailPopup.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetailPopup.config.formId);
    forDetailPopup.run();
}; 
/**
 * 참여게시판 가져오기 실행.
 */
 doListBoard = function(mapPKs) {
    UT.getById(forListBbsdata.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forListBbsdata.config.formId);
    forListBbsdata.run();
};

/**
 * 첨부파일 다운로드
 */
doAttachDownload = function(attachSeq) {
    var action = $.action();
    action.config.formId = "FormParameters";
    action.config.url = "<c:url value="/attach/file/response.do"/>";
    jQuery("#" + action.config.formId).find(":input[name='attachSeq']").remove();
    jQuery("#" + action.config.formId).find(":input[name='module']").remove();
    var param = [];
    param.push("attachSeq=" + attachSeq);
    param.push("module=board");
    action.config.parameters = param.join("&");
    action.run();
};
</script>
</head>

<body>
<div style="display: none;">
    <c:import url="board/bbs/srchBbs.jsp"/>
    <c:import url="srchTeamProject.jsp"/>
</div>
<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:팀프로젝트정보" />
    </h4>
</div>
<table class="tbl-detail">
    <colgroup>
        <col style="width:140px" />
        <col style="width:200px" />
        <col style="width:120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트주제" />
            </th>
            <td colspan="3" class="align-l">
                <c:out value="${detail.courseTeamProject.teamProjectTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:내용" />
            </th>
            <td colspan="3" class="align-l">
                <aof:text type="whiteTag" value="${detail.courseTeamProject.description}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:첨부파일" />
            </th>
            <td colspan="3" class="align-l">
                <c:forEach var="row" items="${detail.courseTeamProject.attachList}" varStatus="i">
                    <a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                </c:forEach>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제평가비율" />
            </th>
            <td>
                <c:out value="${detail.courseTeamProject.rateHomework}"/>%
            </td>
            <th>
                <spring:message code="필드:팀프로젝트:과제평가비율" />
            </th>
            <td>
                <c:out value="${detail.courseTeamProject.rateRelation}"/>%
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:프로젝트기간" />
            </th>
            <td colspan="3" class="align-l">
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
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:과제물공개" />
            </th>
            <td colspan="3" class="align-l">
                <%/** TODO : 코드*/ %>
                <aof:code type="print" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseTeamProject.openYn}" removeCodePrefix="true"/>
            </td>
        </tr>
    </tbody>
</table>
<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:팀구성정보" />
    </h4>
</div>
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 60px" />
        <col/>
        <col style="width: 100px" />
        <col style="width: 80px" />
        
        <col style="width: 100px" />
        <col style="width: 120px" />
        <col style="width: 80px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><spring:message code="필드:팀프로젝트:팀명" /></th>
            <th><spring:message code="필드:팀프로젝트:팀장" /></th>
            <th><spring:message code="필드:팀프로젝트:팀원(명)" /></th>
            <th><spring:message code="필드:팀프로젝트:과제물" /></th>
            <th><spring:message code="필드:팀프로젝트:과제제출일" /></th>
            <th><spring:message code="필드:팀프로젝트:게시글수" /></th>
            <th><spring:message code="필드:팀프로젝트:참여" /></th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="row" items="${teamList}" varStatus="i">
        <tr>
            <td>
                <c:out value="${i.count}"/>
            </td>
            <td class="align-l">
                <c:out value="${row.courseTeamProjectTeam.teamTitle}"/>
            </td>
            <td>
                <c:out value="${row.member.memberName}"/>
            </td>
            <td>
                <c:out value="${row.courseTeamProjectTeam.memberCount}"/>
                <spring:message code="필드:팀프로젝트:명" />
            </td>
            <td>
                <c:choose>
                    <c:when test="${row.courseTeamProjectTeam.myCourseTeamSeq == row.courseTeamProjectTeam.courseTeamSeq}">
                        <a href="#" onclick="doDetailHomework({courseTeamProjectSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamProjectSeq}"/>',
                                                               courseTeamSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>',
                                                               courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>'})" class="btn gray">
                            <span class="mid"><spring:message code="버튼:팀프로젝트:보기" /></span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${detail.courseTeamProject.openYn eq 'Y' && not empty row.courseHomeworkAnswer.sendDtime}">
                                <a href="#" onclick="doDetailHomeworkPopup({courseTeamProjectSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamProjectSeq}"/>',
                                                                       courseTeamSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>',
                                                                       courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>'})" class="btn gray">
                                    <span class="mid"><spring:message code="버튼:팀프로젝트:보기" /></span>
                                </a>
                            </c:when>
                            <c:when test="${detail.courseTeamProject.openYn eq 'Y' && empty row.courseHomeworkAnswer.sendDtime}">
                                <spring:message code="필드:팀프로젝트:미제출" />
                            </c:when>
                            <c:otherwise>
                                <spring:message code="필드:팀프로젝트:비공개" />
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:choose>
                    <c:when test="${empty row.courseHomeworkAnswer.sendDtime}">
                        <spring:message code="필드:팀프로젝트:미제출" />
                    </c:when>
                    <c:otherwise>
                        <aof:date datetime="${row.courseHomeworkAnswer.sendDtime}"></aof:date>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:out value="${row.courseActiveBbs.bbsCount}"/>
            </td>
            <td>
                <c:choose>
                    <c:when test="${row.courseTeamProjectTeam.myCourseTeamSeq == row.courseTeamProjectTeam.courseTeamSeq}">
                        <a href="#" onclick="doListBoard({courseTeamProjectSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamProjectSeq}"/>',
                                                         courseTeamSeq : '<c:out value="${row.courseTeamProjectTeam.courseTeamSeq}"/>',
                                                         courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>'})" class="btn gray">
                            <span class="mid"><spring:message code="버튼:팀프로젝트:입장" /></span>
                        </a>
                    </c:when>
                    <c:otherwise>
                    -
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        
    </c:forEach>
    <c:if test="${empty teamList}">
        <tr>
            <td colspan="8" align="center"><spring:message code="글:데이터가없습니다" /></td>
        </tr>
    </c:if>
    </tbody>
    </table>
</body>
</html>