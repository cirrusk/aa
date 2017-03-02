<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ATTEND_TYPE_002" value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003" value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<table class="tbl-layout">
    <tbody>
        <tr>
            <td class="first">
                <div class="lybox-tbl">
                    <h4 class="title"><spring:message code="글:오프라인출석결과:주차별수업횟수"/></h4>
                </div>                       
                <table class="tbl-detail-row">
                    <tbody>
                        <tr>
                            <c:set var="rowCnt" value="1"/>
                            <c:set var="maxColCnt" value="${fn:length(listElement)}"/>
                            <c:set var="cellCnt" value="${maxColCnt < 5 ? 5*2 : (maxColCnt*2)+(5-((maxColCnt*2)%5))}"/>
                            <c:set var="lessonCnt" value="0"/>
                            <c:forEach var="elementRow" begin="1" end="${cellCnt}" varStatus="i">
                                <c:if test="${i.first || (rowCnt*5)+1 == i.count}">
                                    <tr>
                                </c:if>
                                <c:choose>
                                    <c:when test="${rowCnt == 1 || rowCnt%2 > 0}">
                                        <th>
                                            <c:choose>
                                                <c:when test="${i.count < 6 && i.count-(lessonCnt*5) <= maxColCnt}">
                                                    <c:out value="${i.count}"/><spring:message code="글:주"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${i.count-(lessonCnt*5) <= maxColCnt}">
                                                        <c:out value="${i.count-(lessonCnt*5)}"/><spring:message code="글:주"/>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </th>
                                        <c:if test="${i.count == rowCnt*5}">
                                            <c:set var="lessonCnt" value="${lessonCnt+1}"/>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <td>
                                            <c:if test="${i.count-(lessonCnt*5) <= maxColCnt && i.count-(lessonCnt*5) <= maxColCnt}">
                                                <c:out value="${listElement[(i.count-1)-(lessonCnt*5)].element.offlineLessonCount}"/>
                                            </c:if>
                                        </td>
                                    </c:otherwise>
                                    
                                </c:choose>
                                 <c:if test="${i.count == rowCnt*5}">
                                    </tr>
                                    <c:set var="rowCnt" value="${rowCnt+1}"/>
                                </c:if>
                            </c:forEach>
                    </tbody>
                </table>
                <!-- 항목 -->
            </td>
        </tr>
    </tbody>
</table>

<table class="tbl-layout mt10">
    <tbody>
        <tr>
            <td class="first">
                <div class="lybox-tbl">
                    <h4 class="title"><spring:message code="필드:출석:결석허용횟수" /> / <spring:message code="필드:출석:감점정보" /></h4>
                </div>
                <!-- 항목 -->
                <table class="tbl-detail-row">
                    <thead>
                        <colgroup>
                            <col style="width: 25%" />
                            <col style="width: 25%" />
                            <col style="width: 25%" />
                            <col/>
                        </colgroup>
                    </thead>
                    <tbody>
                        <tr>
                            <th class="align-c"><spring:message code="필드:출석:항목" /></th>
                            <th class="align-c"><spring:message code="필드:출석:결석허용횟수" /></th>
                            <th class="align-c"><spring:message code="필드:출석:감점" /></th>
                            <th class="align-c"><spring:message code="필드:출석:결석전환처리" /></th>
                        </tr>
                        
                        <c:forEach var="row" items="${list}" varStatus="i">
                            <tr>
                                <th class="align-c">
                                    <c:out value="${row.code.codeName}"/>
                                </th>
                                <td class="align-c">
                                    <c:if test="${row.code.code eq CD_ATTEND_TYPE_002}">
                                        <c:out value="${empty row.attendEvaluate.permissionCount ? 0:row.attendEvaluate.permissionCount}"/><spring:message code="필드:출석:회" />
                                    </c:if>
                                    <c:if test="${row.code.code ne CD_ATTEND_TYPE_002}">
                                        -
                                    </c:if>
                                </td>                                       
                                <td class="align-c">
                                    <fmt:formatNumber value="${empty row.attendEvaluate.minusScore ? 0:row.attendEvaluate.minusScore}" /><spring:message code="필드:출석:점" />
                                </td>
                                <td class="align-c">
                                    <c:if test="${row.code.code eq CD_ATTEND_TYPE_003}">
                                        <c:out value="${empty row.attendEvaluate.count ? 0:row.attendEvaluate.count}"/><spring:message code="필드:출석:회" />
                                    </c:if>
                                    <c:if test="${row.code.code ne CD_ATTEND_TYPE_003}">
                                        -
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <!-- 항목 -->
            </td>
        </tr>
    </tbody>
</table>