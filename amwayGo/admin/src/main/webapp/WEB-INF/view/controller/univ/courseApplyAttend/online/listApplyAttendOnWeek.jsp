<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forDetail            = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
	
doInitializeLocal = function() {
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/online/attend/result/week/detail/iframe.do"/>";
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetail.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    // 상세화면 실행
    forDetail.run();
};

</script>
</head>

<body>
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="srchCourseActiveSeq" value="${activeElement.courseActiveSeq}"/>
		<input type="hidden" name="courseTypeCd" value="<c:out value="${activeElement.courseTypeCd}"/>"/>
		<input type="hidden" name="srchReferenceSeq" value=""/>
		<input type="hidden" name="activeElementSeq" value=""/>
		<input type="hidden" name="organizationSeq" value=""/>
		<input type="hidden" name="itemSeq" value=""/>
	</form>
	
	<div class="vspace"></div>
	
	<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 50px;" />
			<col style="width: auto;" />
			<col style="width: 100px;" />
			<col style="width: auto;" />
			<col style="width: 150px;" />
			<col style="width: 150px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:출석결과:주차" /></th>
				<th><spring:message code="필드:출석결과:주차제목" /></th>
				<th><spring:message code="필드:출석결과:교시강" /></th>
				<th><spring:message code="필드:출석결과:교시강제목" /></th>
				<th>
					<spring:message code="필드:출석결과:평균학습시간" />
				 	<div class="vspace"></div>
				 	(<spring:message code="필드:출석결과:시분초" />)
				 </th>
				<th><spring:message code="필드:출석결과:평균진도율" /> (%)</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${itemList}" varStatus="i">
			<tr>
				<td rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
					<c:out value="${row.element.sortOrder}"/> <spring:message code="필드:출석결과:주차" />
				</td>
				<td class="align-l" rowspan="<c:out value="${fn:length(row.itemResultList)}"/>">
					<a href="javascript:doDetail({'srchReferenceSeq' : '<c:out value="${row.element.referenceSeq}" />','activeElementSeq' : '<c:out value="${row.element.activeElementSeq}" />','organizationSeq' : '<c:out value="${row.itemResultList[0].learnerDatamodel.organizationSeq}" />','itemSeq' : '<c:out value="${row.itemResultList[0].learnerDatamodel.itemSeq}" />'});">
						<c:out value="${row.element.activeElementTitle}"/>
					</a>
				</td>
				<c:if test="${fn:length(row.itemResultList) eq 0}">
					<td colspan="4">-</td>
				</c:if>
				<c:forEach var="rowSub" items="${row.itemResultList}" varStatus="j"><!-- 강 리스트 -->
					<c:if test="${j.count ne 1}">
					<tr>
					</c:if>				
						<td><c:out value="${rowSub.item.sortOrder+1}"/></td>
						<td class="align-l"><c:out value="${rowSub.item.title}"/></td>
						<td>
							<c:choose>
								<c:when test="${0 < rowSub.learnerDatamodel.sessionTime}">
									<c:set var="hh" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime / (60 * 60 * 1000))}"/>
									<c:set var="mm" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
									<c:set var="ss" value="${aoffn:toInt(rowSub.learnerDatamodel.sessionTime % (60 * 1000) / 1000 )}"/>
									<c:choose>
										<c:when test="${10 <= hh}">
											<c:out value="${hh}"/>:
										</c:when>
										<c:otherwise>
											0<c:out value="${hh}"/>:
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${10 <= mm}">
											<c:out value="${mm}"/>:
										</c:when>
										<c:otherwise>
											0<c:out value="${mm}"/>:
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${10 <= ss}">
											<c:out value="${ss}"/>
										</c:when>
										<c:otherwise>
											0<c:out value="${ss}"/>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									00:00:00
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<aof:number value="${rowSub.learnerDatamodel.progressMeasure * 100}" pattern="#,###.#"/>%
						</td>
					</tr>
				</c:forEach>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>