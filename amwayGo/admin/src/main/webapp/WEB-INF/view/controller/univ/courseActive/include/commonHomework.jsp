<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_COURSE_TYPE_PERIOD"          value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<%-- Popup 과 Include 경우 스크립트 오류 방지 --%>
<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: auto" />
        <col style="width: 200px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:과제:과제제목" /></th>
            <th><spring:message code="필드:과제:제출기간" /></th>
            <th><spring:message code="필드:과제:평가비율" /></th>
        </tr>
    </thead>
    <tbody>
        <c:set var="totalRate" value="0"/>
        <c:set var="index"     value="0"/>
        <c:forEach var="row" items="${itemList}" varStatus="i">
            <tr>
                <td class="align-l">
                    <c:choose>
                        <c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
                            <span class="section-btn blue02"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
                        </c:when>
                        <c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
                            <span class="section-btn green"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
                        </c:when>
                    </c:choose>
                    <div class="vspace"></div>
                    <c:out value="${row.courseHomework.homeworkTitle}"/>
                </td>
                <td class="align-l">
                	<c:choose>
                		<c:when test="${not empty courseActive.courseTypeCd && courseActive.courseTypeCd ne CD_COURSE_TYPE_PERIOD}">
                			<span><spring:message code="글:수강시작" /></span> 
                			<c:out value="${row.courseHomework.startDay}" /> <spring:message code="글:일부터" /> 
                			~ 
                			<c:out value="${row.courseHomework.endDay}" /> <spring:message code="글:일까지" />
                		</c:when>
                		<c:otherwise>
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
                		</c:otherwise>
                	</c:choose>
                    <c:if test="${row.courseHomework.useYn eq 'N'}">
                        <spring:message code="글:과제:해당없음" /> 
                    </c:if>
                </td>
                <c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
                    <td rowspan="<c:out value="${row.courseHomework.referenceCount}"/>">
                        <c:out value="${row.courseHomework.rate}"/> %
                    </td>
                    <c:set var="totalRate" value="${totalRate + row.courseHomework.rate}"/>
                </c:if>
            </tr>
        </c:forEach>
        <c:choose>
            <c:when test="${empty itemList}">
                <tr>
                    <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="2" class="align-r" ><spring:message code="필드:과제:합계비율" /></td>
                    <td id="totalRate"><c:out value='${totalRate}'/>%</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>
