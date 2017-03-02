<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" 		value="<c:out value="${homework.homeworkSeq}"/>"/>
	<input type="hidden" name="courseActiveSeq" 	value="<c:out value="${homework.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseApplySeq" 		value="<c:out value="${homework.courseApplySeq}"/>"/>
	<input type="hidden" name="memberSeq" 			value="<c:out value="${homework.memberSeq}"/>"/>
	<input type="hidden" name="homeworkAnswerSeq" 	value=""/>
	<input type="hidden" name="openYn" 				value=""/>
	<input type="hidden" name="useYn" 				value=""/>
	<input type="hidden" name="onoffCd" 			value=""/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" 	value="<c:out value="${homework.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseApplySeq" 		value="<c:out value="${homework.courseApplySeq}"/>"/>
	<input type="hidden" name="memberSeq" 			value="<c:out value="${homework.memberSeq}"/>"/>
</form>
