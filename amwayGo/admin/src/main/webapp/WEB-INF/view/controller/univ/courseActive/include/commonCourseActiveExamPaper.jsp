<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"    value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"     value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<c:set var="itemCount" value="${aoffn:size(examPaperList) + aoffn:size(homeworkList)}"/>
<table id="listTable" class="tbl-list mt10">
    <colgroup>
        <col style="width: auto" />
        <col style="width: 200px" />
        <col style="width: 100px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:시험:시험제목" /></th>
            <th><spring:message code="필드:시험:진행기간" /></th>
            <th><spring:message code="필드:시험:시험시간" /></th>
            <th><spring:message code="필드:시험:대상인원" /></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${examPaperList}" varStatus="i">
            <tr>
                <td class="align-l">
                    <c:choose>
                        <c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
                            <c:choose>
                                <c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
                                    <span class="section-btn blue02"><spring:message code="필드:시험:중간고사" /></span>
                                </c:when>
                                <c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
                                    <span class="section-btn blue02"><spring:message code="필드:시험:기말고사" /></span>
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
                            <span class="section-btn green"><spring:message code="필드:시험:보충시험" /></span>
                        </c:when>
                    </c:choose>
                    <div class="vspace"></div>
                    <c:out value="${row.courseExamPaper.examPaperTitle}"/>
                </td>
                <td>
                    <aof:date datetime="${row.courseActiveExamPaper.startDtime}" />&nbsp;
                    <aof:date datetime="${row.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
                    <spring:message code="글:시험:부터" /> 
                    <div class="vspace"></div>
                    <aof:date datetime="${row.courseActiveExamPaper.endDtime}" />&nbsp;
                    <aof:date datetime="${row.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
                    <spring:message code="글:시험:까지" />
                </td>
                <td><c:out value="${row.courseActiveExamPaper.examTime}" />&nbsp;<spring:message code="글:분" /></td>
                <td>
                    <c:choose>
                        <c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
                            <c:out value="${row.courseActiveSummary.memberCount}"/>&nbsp;<spring:message code="글:명" />
                        </c:when>
                        <c:otherwise>
                            <c:out value="${row.courseActiveExamPaper.targetCount}"/>&nbsp;<spring:message code="글:명" />
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        <c:forEach var="row" items="${homeworkList}" varStatus="i">
            <tr>
                <td class="align-l">
                    <c:choose>
                        <c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
                            <c:choose>
                                <c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
                                    <span class="section-btn blue02"><spring:message code="필드:시험:중간고사" /><spring:message code="필드:시험:대체과제" /></span>
                                </c:when>
                                <c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
                                    <span class="section-btn blue02"><spring:message code="필드:시험:기말고사" /><spring:message code="필드:시험:대체과제" /></span>
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
                            <span class="section-btn green"><spring:message code="필드:시험:보충과제" /></span>
                        </c:when>
                    </c:choose>
                    <div class="vspace"></div>
                    <c:out value="${row.courseHomework.homeworkTitle}"/>
                </td>
                <td class="align-l">
                    <c:if test="${empty row.courseHomework.startDtime}">
                        <spring:message code="글:과제:제출기간설정이필요합니다" />
                    </c:if>
                    <c:if test="${not empty row.courseHomework.startDtime}">
                        <spring:message code="필드:과제:1차" />
                        : 
                        <aof:date datetime="${row.courseHomework.startDtime}"/>
                        ~
                        <aof:date datetime="${row.courseHomework.endDtime}"/>
                        <br/>
                        <spring:message code="필드:과제:2차" /> 
                        : 
                        <c:if test="${row.courseHomework.useYn eq 'Y'}">
                            <aof:date datetime="${row.courseHomework.start2Dtime}"/>
                            ~
                            <aof:date datetime="${row.courseHomework.end2Dtime}"/>
                        </c:if>
                        <c:if test="${row.courseHomework.useYn eq 'N'}">
                            <spring:message code="글:과제:해당없음" /> 
                        </c:if>
                    </c:if>
                </td>
                <td>
                -
                </td>
                <td>
                    <c:out value="${row.courseHomework.targetCount}"/>&nbsp;<spring:message code="글:명" /> 
                </td>
            </tr>
        </c:forEach>
        <c:if test="${itemCount eq 0}">
            <tr>
                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
</table>