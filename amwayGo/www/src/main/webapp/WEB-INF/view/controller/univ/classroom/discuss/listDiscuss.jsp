<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<!-- 오늘 날짜 가져오기 -->
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<html decorator="classroom-layer">
<head>
<title></title>
<script type="text/javascript">
var forDetail                = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/usr/classroom/discuss/detail.do"/>";

    setValidate();
};

setValidate = function() {};

/**
 * 상세보기 가져오기 실행.
 */
 doDetail = function(mapPKs) {
    UT.getById(forDetail.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    forDetail.run();
};

</script>
</head>

<body>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
    <input type="hidden" name="discussSeq"/>
    <input type="hidden" name="courseApplySeq"/>
</form>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <h4 class="section-title"><spring:message code="글:토론:토론목록" /></h4>
</div>

<div class="vspace"></div>

<table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 60px" />
        <col style="width: auto" />
        <col style="width: 180px" />
        <col style="width: 80px" />
        <col style="width: 180px" />
    </colgroup>
    <thead>
        <tr>
            <th><spring:message code="필드:번호" /></th>
            <th><spring:message code="필드:토론:토론주제" /></th>
            <th><spring:message code="필드:토론:토론기간" /></th>
            <th><spring:message code="필드:토론:상태" /></th>
            <th><spring:message code="필드:토론:내게시글" /> / <spring:message code="필드:토론:전체" /></th>
        </tr>
    </thead>
    <tbody>
   <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td><c:out value="${i.index + 1}"/></td>
            <td class="align-l">
                <a href="javascript:void(0)" onclick="doDetail({discussSeq : '<c:out value="${row.discuss.discussSeq}"/>',courseApplySeq : '<c:out value="${courseApply.courseApplySeq}"/>'})">
                    <c:out value="${row.discuss.discussTitle}"/>
                </a>
            </td>
            <td>
                <aof:date datetime="${row.discuss.startDtime}"/>
                ~
                <aof:date datetime="${row.discuss.endDtime}"/>
            </td>
            <%/** TODO : 코드*/ %>
            <td>
            	<c:choose>
            		<c:when test="${row.discuss.startDtime <= appToday and row.discuss.endDtime > appToday}">
            			<spring:message code="글:토론:진행중" />
            		</c:when>
            		<c:when test="${row.discuss.startDtime <= appToday and row.discuss.endDtime < appToday}">
            			<spring:message code="글:토론:종료" />
            		</c:when>
            		<c:otherwise>
            			<spring:message code="글:토론:대기" />
            		</c:otherwise>
            	</c:choose>
            </td>
            <td>
                <c:out value="${row.discuss.bbsMemberCount}"/><spring:message code="글:토론:개" /> / <c:out value="${row.discuss.bbsCount}"/><spring:message code="글:토론:개" />
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty itemList}">
        <tr>
            <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
        </tr>
    </c:if>
    </tbody>
    </table>
</body>
</html>