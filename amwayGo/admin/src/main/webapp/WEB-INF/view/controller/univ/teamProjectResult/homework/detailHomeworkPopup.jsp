<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
};

doClose = function(){
	$layer.dialog("close");
}
</script>
</head>

<body>
<c:choose>
    <c:when test="${empty homework}">
        <div class="lybox align-c mt10"><spring:message code="글:팀프로젝트:제출된과제물이없습니다." /></div>
        <div class="lybox-btn">
            <div class="lybox-btn-l">
            </div>
            <div class="lybox-btn-r">
                <a href="javascript:void(0)" onclick="doClose()" class="btn blue">
                    <span class="mid"><spring:message code="버튼:닫기" /></span>
                </a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <table id="listTable" class="tbl-list">
            <colgroup>
                <col style="width: 140px;" />
                <col/>
            </colgroup>
            <tbody>
            <table class="tbl-detail">
                <colgroup>
                    <col style="width:120px" />
                    <col/>
                </colgroup>
                <tbody>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:제목"/>
                        </th>
                        <td>
                            <c:out value="${homework.answer.homeworkAnswerTitle}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:작성자"/>
                        </th>
                        <td>
                            <c:out value="${homework.answer.memberName}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:내용"/>
                        </th>
                        <td>
                            <aof:text type="whiteTag" value="${homework.answer.description}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <spring:message code="필드:팀프로젝트:첨부파일"/>
                        </th>
                        <td>
                            <c:forEach var="row" items="${homework.answer.unviAttachList}" varStatus="i">
                                <a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
                                [<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
                            </c:forEach>
                        </td>
                    </tr>
                </tbody>
                </table>
            </tbody>
        </table>
        <div class="lybox-btn">
            <div class="lybox-btn-l">
            </div>
            <div class="lybox-btn-r">
                <a href="javascript:void(0)" onclick="doClose()" class="btn blue">
                    <span class="mid"><spring:message code="버튼:닫기" /></span>
                </a>
            </div>
        </div>
    </c:otherwise>
</c:choose>
</body>
</html>