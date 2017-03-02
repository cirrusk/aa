<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<div class="question-head"><c:out value="${questionCount}"/>. </div>
<div class="question-title"><aof:text type="text" value="${courseExamItem.examItemTitle}"/></div>
<c:choose>
	<c:when test="${!empty courseExamAnswer}">
		<c:choose>
			<c:when test="${courseExamAnswer.takeScore eq 0}"><div class="answerIncorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore eq scorePerItem}"><div class="answerCorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore lt scorePerItem}"><div class="answerTriangle"></div></c:when>
		</c:choose>
	</c:when>
</c:choose>
