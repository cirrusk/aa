<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
</head>

<body>
	<table class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 200px;" />
			<col style="width: 40px" />
			<col style="width: 40px" />
		</colgroup>
		<thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><spring:message code="필드:퀴즈:제목" /></th>
	            <th><spring:message code="필드:퀴즈:답변수" /></th>
	            <th><spring:message code="필드:퀴즈:비율" /></th>
	        </tr>
	    </thead>
		<tbody>
			<c:forEach var="row" items="${itemList}" varStatus="i">
				<tr>
					<tr>
		    			<td>
		    				<c:out value="${i.count}"/>
	    				</td>
		                <td class="align-l">
		                	<c:out value="${row.courseExamExample.examItemExampleTitle}"/>
		                </td>
		                <td>
		                	<c:out value="${row.courseQuizAnswer.answerCount}"/>
		                </td>
		                <td>
		                	<aof:number value="${(row.courseQuizAnswer.answerCount*100)/row.courseQuizAnswer.memberCount}" pattern="###.##"/>%
		                </td>
		    		</tr>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>