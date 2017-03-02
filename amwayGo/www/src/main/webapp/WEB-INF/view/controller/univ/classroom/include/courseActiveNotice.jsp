<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:set var="srchKey">title=<spring:message code="필드:게시판:제목"/>,description=<spring:message code="필드:게시판:내용"/></c:set>
<div style="display: none;">
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"     value="<c:out value="${condition.srchCourseActiveSeq}"/>"/>
    <input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${condition.srchCourseActiveSeq}"/>"/>
    <input type="hidden" name="srchBoardSeq"        value="<c:out value="${param['srchBoardSeq']}"/>"/>
    <input type="hidden" name="courseApplySeq"      value="<c:out value="${param['courseApplySeq']}"/>"/>
</form>
</div>
<c:forEach var="row" items="${alwaysTopList}" varStatus="i">
    <li>[<spring:message code="필드:게시판:공지" />]<c:out value="${row.bbs.bbsTitle}" /><span class="date"><aof:date datetime="${row.bbs.regDtime}"/></span></li>
</c:forEach>
<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
    <li>[<spring:message code="필드:게시판:공지" />]<c:out value="${row.bbs.bbsTitle}" /><span class="date"><aof:date datetime="${row.bbs.regDtime}"/></span></li>
</c:forEach>