<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<strong><c:out value="${questionCount}"/>. </strong>
<aof:text type="text" value="${courseExamItem.examItemTitle}"/>
<c:choose>
	<c:when test="${!empty courseExamAnswer}">
		<c:choose>
			<c:when test="${courseExamAnswer.takeScore eq 0}"><div class="answerIncorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore eq scorePerItem}"><div class="answerCorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore lt scorePerItem}"><div class="answerTriangle"></div></c:when>
		</c:choose>
	</c:when>
</c:choose>
