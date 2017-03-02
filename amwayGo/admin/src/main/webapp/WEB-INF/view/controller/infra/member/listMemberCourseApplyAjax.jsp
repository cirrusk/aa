<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: auto" />
		<col style="width: 200px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
		<col style="width: 100px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:과정:과정제목"/></th>
			<th><spring:message code="필드:과정:학습기간"/></th>
			<th><spring:message code="필드:과정:상태"/></th>
			<th><spring:message code="필드:과정:복습기간"/></th>
			<th><spring:message code="필드:과정:수료여부"/></th>
			<th><spring:message code="필드:등록일" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td align="left">
				<c:if test="${row.courseActive.courseTypeCd eq 'period'}">
					[<c:out value="${row.courseActive.year}" /><spring:message code="글:과정:년"/> - <c:out value="${row.courseActive.periodNumber}" /> <spring:message code="글:과정:기"/>]
				</c:if>
				<aof:text type="text" value="${row.courseActive.title}" />
			</td>
			<td>
				<aof:date datetime="${row.courseApply.studyStartDate}"/>~<aof:date datetime="${row.courseApply.studyEndDate}"/>
			</td>
			<td><aof:code type="print" codeGroup="COURSE_APPLY_STATUS" selected="${row.courseApply.applyStatusCd}"/></td>
			<td>
				<c:if test="${row.courseApply.resumeEndDate eq 'Y' }">
					<spring:message code="필드:과정:제한없음" />
				</c:if>
				<c:if test="${row.courseApply.resumeEndDate ne 'Y' }">
					<aof:date datetime="${row.courseApply.resumeEndDate}"/>
				</c:if>
			</td>
			<td><aof:code type="print" codeGroup="COURSE_COMPLETION_YESNO" selected="${row.courseApply.completionYn}"/></td>
			<td><aof:date datetime="${row.courseApply.applyStatusDtime}"/></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
</table>
<c:import url="/WEB-INF/view/include/paging.jsp">
	<c:param name="paginate" value="paginate"/>
</c:import>	