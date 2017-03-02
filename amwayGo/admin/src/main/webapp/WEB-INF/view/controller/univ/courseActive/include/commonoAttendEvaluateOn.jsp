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
                    <h4 class="title"><spring:message code="필드:출석:결석허용횟수" /> / <spring:message code="필드:출석:감점정보" /></h4>
                </div>
                <!-- 항목 -->
                <table class="tbl-detail mt10">
                    <thead>
                        <colgroup>
                            <col style="width: 120px" />
                            <col/>
                            <col/>
                            <col/>
                        </colgroup>
                    </thead>
                    <tbody>
                        <tr>
                            <th class="align-c"><spring:message code="필드:출석:항목" /></th>
                            <th class="align-c"><spring:message code="필드:출석:감점" /></th>
                            <th class="align-c"><spring:message code="필드:출석:결석허용횟수" /></th>
                            <th class="align-c"><spring:message code="필드:출석:결석전환처리" /></th>
                        </tr>
                        
                        <c:forEach var="row" items="${list}" varStatus="i">
                            <tr>
                                <th class="align-c">
                                    <c:out value="${row.code.codeName}"/>
                                </th>
                                <td class="align-c">
                                    <c:out value="${empty row.attendEvaluate.minusScore ? 0:row.attendEvaluate.minusScore}"/><spring:message code="필드:출석:점" />
                                </td>
                                <td class="align-c">
                                    <c:if test="${row.code.code eq CD_ATTEND_TYPE_002}">
                                        <c:out value="${empty row.attendEvaluate.permissionCount ? 0:row.attendEvaluate.permissionCount}"/> <spring:message code="필드:출석:회" />
                                    </c:if>
                                    <c:if test="${row.code.code ne CD_ATTEND_TYPE_002}">
                                        -
                                    </c:if>
                                </td>
                                <td class="align-c">
                                    <c:if test="${row.code.code eq CD_ATTEND_TYPE_003}">
                                        <c:out value="${empty row.attendEvaluate.count ? 0:row.attendEvaluate.count}"/> <spring:message code="필드:출석:회" />
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