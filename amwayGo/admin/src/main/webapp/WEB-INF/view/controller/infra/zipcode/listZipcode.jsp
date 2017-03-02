<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html decorator="ajax">
<head>
<title></title>
<script type="text/javascript">
</script>
</head>

<body>

	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 80px" />
		<col style="width: auto" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:우편번호:우편번호" /></th>
			<th><spring:message code="필드:우편번호:주소" /></th>
		</tr>
	</thead>
	<tbody>
	<c:choose>
		<c:when test="${condition.srchType eq 'new'}">
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
			        <td>
			        	<c:set var="viewAddress" value="${row.zipcode.sido} ${row.zipcode.sigungu} ${row.zipcode.street} ${row.zipcode.building}"/>
			        	<c:set var="returnAddress" value="${row.zipcode.sido} ${row.zipcode.sigungu} ${row.zipcode.street} ${row.zipcode.building}"/>
			        	<input type="hidden" name="zipcode" value="<c:out value="${row.zipcode.zipcode}"/>" />
			        	<input type="hidden" name="address" value="<c:out value="${returnAddress}"/>" />
			        	<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>)"><c:out value="${fn:substring(row.zipcode.zipcode, 0, 3)}"/>-<c:out value="${fn:substring(row.zipcode.zipcode, 3, 6)}"/></a>
			        </td>
					<td class="align-l"><a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>)"><c:out value="${viewAddress}" /></a></td>
				</tr>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="2" align="center">
						<spring:message code="글:데이터가없습니다" />
					</td>
				</tr>
			</c:if>
		</c:when>
		<c:otherwise>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
			        <td>
			        	<c:set var="viewAddress" value="${row.zipcode.sido} ${row.zipcode.gugun} ${row.zipcode.dong} ${row.zipcode.ri} ${row.zipcode.bldg} ${row.zipcode.bunji}"/>
			        	<c:set var="returnAddress" value="${row.zipcode.sido} ${row.zipcode.gugun} ${row.zipcode.dong} ${row.zipcode.ri} ${row.zipcode.bldg}"/>
			        	<input type="hidden" name="zipcode" value="<c:out value="${row.zipcode.zipcode}"/>" />
			        	<input type="hidden" name="address" value="<c:out value="${returnAddress}"/>" />
			        	<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>)"><c:out value="${fn:substring(row.zipcode.zipcode, 0, 3)}"/>-<c:out value="${fn:substring(row.zipcode.zipcode, 3, 6)}"/></a>
			        </td>
					<td class="align-l"><a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>)"><c:out value="${viewAddress}" /></a></td>
				</tr>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="2" align="center">
						<spring:message code="글:데이터가없습니다" />
					</td>
				</tr>
			</c:if>
		</c:otherwise>
	</c:choose>
	</table>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

</body>
</html>