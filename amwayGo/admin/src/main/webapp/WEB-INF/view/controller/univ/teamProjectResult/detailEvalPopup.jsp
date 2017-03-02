<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSaveEval = null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    UI.editor.create("comment");
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forSaveEval = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forSaveEval.config.url             = "<c:url value="/univ/teamproject/eval/save.do"/>";
    forSaveEval.config.target          = "hiddenframe";
    forSaveEval.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forSaveEval.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forSaveEval.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forSaveEval.config.fn.complete     = function() {
    	var par = $layer.dialog("option").parent;
        if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
            par["<c:out value="${param['callback']}"/>"].call(this);
        }
        $layer.dialog("close");
    };
};

doClose = function(){
    $layer.dialog("close");
};

/**
 * 평가 저장
 */
doSaveEval = function(){
	// editor 값 복사
    UI.editor.copyValue();
	forSaveEval.run();
};
</script>
<c:import url="/WEB-INF/view/include/upload.jsp"/>
<c:import url="/WEB-INF/view/include/editor.jsp"/>
</head>

<body>
<div class="lybox-title">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:출제정보" />
    </h4>
</div>
<table class="tbl-detail">
    <colgroup>
        <col style="width:140px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트주제" />
            </th>
            <td class="align-l">
                <c:out value="${detail.courseTeamProject.teamProjectTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:내용" />
            </th>
            <td class="align-l">
                <aof:text type="whiteTag" value="${detail.courseTeamProject.description}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:첨부파일" />
            </th>
            <td class="align-l">
                <c:forEach var="row" items="${detail.courseTeamProject.attachList}" varStatus="i">
                    <a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${row.attachSeq}"/>')"><c:out value="${row.realName}"/></a>
                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                </c:forEach>
            </td>
        </tr>
        <%--
        <tr>
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
        </tr>
         --%>
    </tbody>
</table>

<div class="lybox-title mt10">
    <h4 class="section-title">
    <spring:message code="필드:팀프로젝트:제출/평가정보" />
    </h4>
</div>
<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
<input type="hidden" name="courseTeamProjectSeq" value="<c:out value="${eval.answer.courseTeamprojectSeq}"/>"/>
<input type="hidden" name="courseTeamSeq" value="<c:out value="${eval.answer.courseTeamSeq}"/>"/>
<input type="hidden" name="activeElementSeq" value="<c:out value="${eval.courseActiveElement.activeElementSeq}"/>"/>

<table class="tbl-detail">
    <colgroup>
        <col style="width: 140px;" />
        <col/>
        <col style="width: 140px;" />
        <col style="width: 140px;" />
    </colgroup>
    <tbody>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:팀프로젝트소속팀"/>
            </th>
            <td colspan="3">
                <c:out value="${eval.projectTeam.teamTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:제출자"/>
            </th>
            <td>
                <c:out value="${eval.answer.memberName}"/>
            </td>
            <th>
                <spring:message code="필드:팀프로젝트:아이디"/>
            </th>
            <td>
                <c:out value="${eval.answer.memberId}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:제목"/>
            </th>
            <td colspan="3">
                <aof:text type="whiteTag" value="${eval.answer.homeworkAnswerTitle}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:내용"/>
            </th>
            <td colspan="3">
                <aof:text type="whiteTag" value="${eval.answer.description}"/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:첨부파일"/>
            </th>
            <td>
                <c:forEach var="row" items="${eval.answer.unviAttachList}" varStatus="i">
                    <a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
                    [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                </c:forEach>
            </td>
            <th>
                <spring:message code="필드:팀프로젝트:과제제출일"/>
            </th>
            <td>
                <c:choose>
                    <c:when test="${empty eval.answer.scoreDtime}">
                        -
                    </c:when>
                    <c:otherwise>
                        <aof:date datetime="${eval.answer.scoreDtime}"/>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:점수"/>
            </th>
            <td>
                <input type="text" name="homeworkScore" value="<c:out value="${eval.answer.homeworkScore}"/>" style="width: 40px;text-align: center;">
            </td>
            <th>
                <spring:message code="필드:팀프로젝트:과제채점일"/>
            </th>
            <td>
                <c:choose>
                    <c:when test="${empty eval.answer.sendDtime}">
                        -
                    </c:when>
                    <c:otherwise>
                        <aof:date datetime="${eval.answer.sendDtime}"/>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code="필드:팀프로젝트:내용"/>
            </th>
            <td colspan="3">
                <textarea name="comment" id="comment" style="width:98%; height:100px"><c:out value="${eval.answer.comment}"/></textarea>
            </td>
        </tr>
    </tbody>
</table>
</form>
<div class="lybox-btn">
    <div class="lybox-btn-l">
    </div>
    <div class="lybox-btn-r">
        <a href="javascript:void(0)" onclick="doSaveEval()" class="btn blue">
            <span class="mid"><spring:message code="버튼:저장" /></span>
        </a>
        <a href="javascript:void(0)" onclick="doClose()" class="btn black">
            <span class="mid"><spring:message code="버튼:닫기" /></span>
        </a>
    </div>
</div>
</body>
</html>