<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="iframe">
<head>
<title></title>
<script type="text/javascript">
var forDetail = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/project/member/detail/iframe.do"/>";
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
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq" />
		<input type="hidden" name="srchMemberSeq" value="${condition.srchMemberSeq }" />
		<input type="hidden" name="srchMemberCdmsTypeCd" value="${condition.srchMemberCdmsTypeCd }" />
	</form>

	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 60px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:CDMS:프로젝트명" /></th>
			<th><spring:message code="필드:CDMS:프로젝트기간" /></th>
			<th><spring:message code="필드:CDMS:참여그룹" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${listProjectMember}" varStatus="i">
		<tr>
	        <td><c:out value="${fn:length(listProjectMember) - i.index}"/></td>
			<td><a href="javascript:doDetail({'projectSeq' : '${row.projectMember.projectSeq}', 'srchMemberCdmsTypeCd' : '${row.projectMember.memberCdmsTypeCd}'});"><c:out value="${row.project.projectName}" /></a></td>
	        <td><aof:date datetime="${row.project.startDate}"/> ~ <aof:date datetime="${row.project.endDate}"/></td>
	        <td><aof:code type="print" codeGroup="CDMS_PROJECT_MEMBER_TYPE" selected="${row.projectMember.memberCdmsTypeCd}" /></td>
		</tr>
	</c:forEach>
	<c:if test="${empty listProjectMember}">
		<tr>
			<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
</body>
</html>