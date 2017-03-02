<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<form name="FormBbs" id="FormBbs" method="post" onsubmit="return false;">
	<input type="hidden" name="srchBoardSeq"/>
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
	<input type="hidden" name="iconType" value=""/>
</form>

<h2 class="heading"><spring:message code="메뉴:강의실:과정게시판"/></h2>
<div class="lecture-board" id="content-bbs">

</div>
