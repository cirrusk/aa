<%@page pageEncoding="UTF-8"%><%@include file="/WEB-INF/view/include/taglibs.jspf"%>
<html>
<head>
<title></title>
<script type="text/javascript">
var forDetail = null;

initPage = function() {
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url = "<c:url value="/infra/batch/detail.do"/>";
};
/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};
</script>
</head>

<body>
	
	<c:set var="runStatus">Y=<spring:message code="필드:배치:성공"/>,N=<spring:message code="필드:배치:실패"/></c:set>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록"/></c:param>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	
		<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width: 5%;" />
				<col style="width: auto;" />
				<col style="width: 10%;" />
				<col style="width: 20%" />
				<col style="width: 10%" />
				<col style="width: 10%" />
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="필드:번호"/></th>
					<th><spring:message code="필드:배치:작업명"/></th>
					<th><spring:message code="필드:배치:작업상태"/></th>
					<th><spring:message code="필드:배치:최근수행시간"/>(<spring:message code="필드:배치:상태"/>)</th>
					<th><spring:message code="필드:배치:최근소요시간"/></th>
					<th><spring:message code="필드:배치:총수행횟수"/></th>
				</tr>
			</thead>
			<tbody>
		
			<c:forEach var="row" items="${batchList}" varStatus="i">
				<tr>
					<td><c:out value="${i.index + 1}"/></td>
					<td class="align-l">
						<a href="javascript:void(0);" onclick="javascript:doDetail({'batchSeq' : '${row.batch.batchSeq}'});">
							<c:out value="${row.batch.batchName}"/>
						</a>
					</td>
					<td><aof:code type="print" codeGroup="BATCH_STATUS" selected="${row.batch.batchStatusCd}"/></td>
					<td><aof:date datetime="${row.batch.batchCompletetionDtime}" pattern="${aoffn:config('format.datetime')}"/> (<aof:code type="print" codeGroup="${runStatus}" selected="${row.batch.batchYn}"/>)</td>
					<td><c:out value="${row.batch.displayRunningTime}"/></td>
					<td><c:out value="${row.batch.batchCount}"/></td>
				</tr>
			</c:forEach>
			
			<c:if test="${empty batchList}">
				<tr>
					<td colspan="6" align="center"><spring:message code="글:데이터가없습니다"/></td>
				</tr>
			</c:if>
		
			</tbody>
		</table>
		
	</form>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="batchSeq"/>
	</form>

</body>
</html>
