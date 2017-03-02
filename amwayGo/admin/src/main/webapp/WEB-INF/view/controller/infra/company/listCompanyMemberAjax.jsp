<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
</head>

<body>
	
	<form name="SubFormList" id="SubFormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchCompanySeq" value="<c:out value="${condition.srchCompanySeq}"/>" />
	</form>
	
	<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
	<table id="subListTable" class="tbl-list">
	<colgroup>
		<col style="width: 60px" />
		<col style="width: 180px" />
		<col style="width: 180px" />
		<col style="width: 180px" />
		<col style="width: auto" />
		<col style="width: 70px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:멤버:사용자명" /></th>
			<th><spring:message code="필드:멤버:아이디" /></th>
			<th><spring:message code="필드:멤버:업무" /></th>
			<th><spring:message code="필드:멤버:이메일" /></th>
			<th><spring:message code="필드:멤버:상태" /></th>
			<th><spring:message code="필드:등록일" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><c:out value="${row.member.memberName}" /></td>
	        <td><c:out value="${row.member.memberId}"/></td>
	        <td><aof:code type="print" codeGroup="CDMS_TASK" selected="${row.admin.cdmsTaskTypeCd }" /> </td>
	        <td><c:out value="${row.member.email}"/></td>
	        <td><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${row.member.memberStatusCd}"/></td>
			<td><aof:date datetime="${row.member.regDtime}"/></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="SUB.doPage"/>
	</c:import>

	<script type="text/javascript">
	// 목록 sorting 설정
	FN.doSortList("subListTable", "<c:out value="${condition.orderby}"/>", "SubFormSrch", SUB.doSearch);
	</script>

</body>
</html>