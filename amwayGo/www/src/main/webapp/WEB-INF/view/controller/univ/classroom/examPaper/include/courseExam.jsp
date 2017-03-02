<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<strong>※<spring:message code="필드:시험:문제"/>[
	<c:forEach var="x" begin="1" end="${itemSize}" varStatus="iX">
		<c:if test="${iX.first eq true }">
			<c:out value="${aoffn:toInt(questionCount) + x - 1}"/> ~
		</c:if>
		<c:if test="${iX.last eq true }">
			<c:out value="${aoffn:toInt(questionCount) + x - 1}"/>
		</c:if>
	</c:forEach>
]	
</strong>
<aof:text type="text" value="${courseExam.examTitle}"/>
