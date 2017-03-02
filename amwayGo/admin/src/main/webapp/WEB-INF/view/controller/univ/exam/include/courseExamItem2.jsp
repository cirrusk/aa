<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<div style="padding:5px 20px;">
	<span>
		<strong><spring:message code="필드:시험:문항유형"/></strong>
		<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${courseExamItem.examItemTypeCd}"/>
	</span>
	<%-- 
	<span style="margin-left:10px;">
		<strong><spring:message code="필드:시험:난이도"/></strong>
		<aof:code type="print" codeGroup="EXAM_ITEM_DIFFICULTY" selected="${courseExamItem.examItemDifficultyCd}"/>
	</span>
	<span style="margin-left:10px;">
		<strong><spring:message code="필드:시험:문제점수"/></strong>
		<c:out value="${courseExamItem.examItemScore}" /><spring:message code="글:시험:점"/>
	</span>
	
	<span style="margin-left:10px;">
		<strong><spring:message code="필드:시험:전체공개"/> : </strong>
		<aof:code type="print" codeGroup="YESNO" selected="${courseExam.openYn}" removeCodePrefix="true"></aof:code>
	</span>
	<c:if test="${itemSize eq 1}">
		<span style="margin-left:10px;">
			<strong><spring:message code="필드:시험:출제그룹"/></strong>
			<c:out value="${courseExam.groupKey}"/>
		</span>
	</c:if>
	--%>
</div>

<c:if test="${!empty courseExamItem.description}">
	<div style="padding:5px 20px;">
		<strong><spring:message code="필드:시험:문항해설"/></strong>
		<aof:text type="text" value="${courseExamItem.description}"/>
	</div>
</c:if>
<c:if test="${!empty courseExamItem.comment}">
	<div style="padding:5px 20px;">
		<strong><spring:message code="필드:시험:첨삭기준"/></strong>
		<aof:text type="text" value="${courseExamItem.comment}"/>
	</div>
</c:if>

<c:choose>
	<c:when test="${!empty courseExamAnswer}">
		<c:choose>
			<c:when test="${courseExamAnswer.takeScore eq 0}"><div class="answerIncorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore eq scorePerItem}"><div class="answerCorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore lt scorePerItem}"><div class="answerTriangle"></div></c:when>
		</c:choose>
	</c:when>
</c:choose>
