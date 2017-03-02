<%@page pageEncoding="UTF-8"%><%@include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="iframe">
<head>
<title></title>
<script type="text/javascript">
var forSearch = null;

initPage = function() {
	//datepicker
	UI.datepicker("#srchStarDate,#srchEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/infra/batch/history/list.do"/>";
};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
	var form = UT.getById(forSearch.config.formId);
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearch.run();
};
/**
 * 로그 출력
 */
doDisplayLog = function(seq) {
	$(".logClass").hide();
	$("#log_" + seq).show();
};
</script>
</head>

<body>

	<c:set var="runStatus">Y=<spring:message code="필드:배치:성공"/>,N=<spring:message code="필드:배치:실패"/></c:set>
	<c:import url="srchBatchHistory.jsp"></c:import>
	
	<div class="vspace"></div>
	<div class="vspace"></div>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	
		<div style="height: 300px; overflow-y: scroll;">
			<table id="listTable" class="tbl-list">
				<colgroup>
					<col style="width: 5%;" />
					<col style="width: auto;" />
					<col style="width: 20%;" />
					<col style="width: 20%" />
				</colgroup>
				<thead>
					<tr>
						<th><spring:message code="필드:번호"/></th>
						<th><spring:message code="필드:배치:작업시간"/></th>
						<th><spring:message code="필드:배치:지속시간"/></th>
						<th><spring:message code="필드:배치:상태"/></th>
					</tr>
				</thead>
				<tbody>
				
				<c:forEach var="row" items="${batchHistoryList}" varStatus="i">
					<tr>
						<td><c:out value="${i.index + 1}"/></td>
						<td><a href="#" onclick="javascript:doDisplayLog('<c:out value="${i.index + 1}"/>'); return false;" ><aof:date datetime="${row.history.batchStartDtime}" pattern="${aoffn:config('format.datetime')}"/></a></td>
						<td><c:out value="${row.history.displayRunningTime}"/></td>
						<td><aof:code type="print" codeGroup="${runStatus}" selected="${row.history.batchYn}"/></td>
					</tr>
				</c:forEach>
				
				<c:if test="${empty batchHistoryList}">
					<tr>
						<td colspan="4" align="center"><spring:message code="글:데이터가없습니다"/></td>
					</tr>
				</c:if>
			
				</tbody>
			</table>
		</div>
		
	</form>

	<div class="vspace"></div>
	<div class="vspace"></div>
	
	<c:forEach var="row" items="${batchHistoryList}" varStatus="i">
		<textarea class="logClass" id="log_<c:out value="${i.index + 1}"/>" disabled="disabled" style="display:none; width: 99%; height: 200px;"><aof:text type="whiteTag" value="${row.history.batchLog}"/></textarea>	
	</c:forEach>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="batchSeq"/>
	</form>

</body>
</html>
