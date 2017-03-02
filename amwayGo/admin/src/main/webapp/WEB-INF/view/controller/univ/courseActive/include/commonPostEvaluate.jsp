<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE_NOTICE"   value="${aoffn:code('CD.BOARD_TYPE.NOTICE')}"/>
<c:set var="CD_BOARD_TYPE_RESOURCE" value="${aoffn:code('CD.BOARD_TYPE.RESOURCE')}"/>
<c:set var="CD_BOARD_TYPE_APPEAL"   value="${aoffn:code('CD.BOARD_TYPE.APPEAL')}"/>
<c:set var="CD_BOARD_TYPE_ONE2ONE"  value="${aoffn:code('CD.BOARD_TYPE.ONE2ONE')}"/>

<c:if test="${aoffn:matchAntPathPattern('/**/element/popup.do', requestScope['javax.servlet.forward.servlet_path'])}">
<script type="text/javascript">
initPage = function() {
};
</script>
</c:if>
<c:set var="exceptEvaluateBoardType" value="${CD_BOARD_TYPE_NOTICE},${CD_BOARD_TYPE_RESOURCE},${CD_BOARD_TYPE_APPEAL},${CD_BOARD_TYPE_ONE2ONE}" scope="request"/>
<div class="lybox-title">
    <h4 class="section-title"><spring:message code="글:과정:참여대상게시판" /></h4>
</div>  
<table class="tbl-detail">
    <tr>
        <td>
            <c:forEach var="row" items="${boardList}" varStatus="iSub">
                <c:if test="${aoffn:contains(exceptEvaluateBoardType, row.board.boardTypeCd, ',') eq false}">
                    <c:out value="${row.board.boardTitle}"/>&nbsp;|
                </c:if>
            </c:forEach>
        </td>
    </tr>
</table>

<!-- 평가기준 등록 -->        
<div class="lybox-title mt20">
    <h4 class="section-title"><spring:message code="글:과정:평가기준" /></h4>
</div>
<table class="tbl-detail">
<colgroup>
    <col style="width: 80px" />
    <col style="width: auto" />
    <col style="width: 80px" />
</colgroup>
<thead>
    <tr>
        <th class="align-c"><spring:message code="필드:과정:등급분류"/></th>
        <th class="align-c"><spring:message code="필드:과정:게시글수"/></th>
        <th class="align-c"><spring:message code="필드:과정:배점"/></th>
    </tr>
</thead>
<tbody>
    <c:if test="${!empty listBoardPostEvaluate}">
        <c:forEach var="rowSub" items="${listBoardPostEvaluate}" varStatus="iSub">
            <tr>
                <c:choose>
                    <c:when test="${iSub.count eq 1}">
                        <th class="align-c"><spring:message code="글:과정:상"/></th>
                        <td style="padding-left:30px;">
                            <c:out value="${rowSub.coursePostEvaluate.fromCount}"/>
                            <spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
                        </td>
                        <td class="align-c">
                            <fmt:formatNumber value="${rowSub.coursePostEvaluate.score}" />
                        </td>
                    </c:when>
                    <c:when test="${iSub.count eq 2}">
                        <th class="align-c"><spring:message code="글:과정:중"/></th>
                        <td style="padding-left:30px;">
                            <c:out value="${rowSub.coursePostEvaluate.fromCount}"/>
                            <spring:message code="글:과정:부터"/>&nbsp;&nbsp;
                            <c:out value="${rowSub.coursePostEvaluate.toCount}"/>
                            <spring:message code="글:과정:까지"/>
                        </td>
                        <td class="align-c">
                            <fmt:formatNumber value="${rowSub.coursePostEvaluate.score}" />
                        </td>
                    </c:when>
                    <c:when test="${iSub.count eq 3}">
                        <th class="align-c"><spring:message code="글:과정:하"/></th>
                        <td style="padding-left:30px;">
                            <c:out value="${rowSub.coursePostEvaluate.toCount}"/>
                            <spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
                        </td>
                        <td class="align-c">
                            <fmt:formatNumber value="${rowSub.coursePostEvaluate.score}" />
                        </td>
                    </c:when>
                </c:choose>
            </tr>
        </c:forEach>
    </c:if>
    <c:if test="${empty listBoardPostEvaluate}">
        <c:forEach var="rowSub" begin="1" end="3" varStatus="iSub">
            <tr>
                <c:choose>
                    <c:when test="${rowSub eq 1}">
                        <th class="align-c"><spring:message code="글:과정:상"/></th>
                        <td style="padding-left:30px;">
                            0
                            <spring:message code="글:과정:이상"/> <spring:message code="글:과정:부터"/>
                        </td>
                        <td class="align-c">
                            0
                        </td>
                    </c:when>
                    <c:when test="${rowSub eq 2}">
                        <th class="align-c"><spring:message code="글:과정:중"/></th>
                        <td style="padding-left:30px;">
                            0
                            <spring:message code="글:과정:부터"/>&nbsp;&nbsp;
                            0
                            <spring:message code="글:과정:까지"/>
                        </td>
                        <td class="align-c">                                    
                            0
                        </td>
                    </c:when>
                    <c:when test="${rowSub eq 3}">
                        <th class="align-c"><spring:message code="글:과정:하"/></th>
                        <td style="padding-left:30px;">
                            0
                            <spring:message code="글:과정:이하"/> <spring:message code="글:과정:까지"/>
                        </td>
                        <td class="align-c">
                            0
                        </td>
                    </c:when>
                </c:choose>
            </tr>
        </c:forEach>
    </c:if>
</tbody>
</table>
