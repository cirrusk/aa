<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);

	// [3] datepicker
	UI.datepicker("#srchStartDate");
	UI.datepicker("#srchEndDate");
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/cdms/studio/work/result/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/studio/work/result/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/studio/work/result/detail.do"/>";

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
 * 검색조건 초기화
 */
doSearchReset = function() {
	FN.resetSearchForm(forSearch.config.formId);
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doList();
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
	forListdata.run();
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

/**
 * 개발그룹 찾기
 */
doBrowseProjectGroup = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProjectGroup";
	action.config.url    = "<c:url value="/cdms/project/group/list/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 500;
	action.config.options.title  = "<spring:message code="필드:CDMS:개발그룹"/>&nbsp;<spring:message code="버튼:선택"/>";
	action.run();
};

/**
 * 개발그룹 선택
 */
doSetProjectGroup = function(returnValue) {
	if (returnValue != null) {
		doRemoveProjectGroup(); // 기존 등록된 것 삭제
		
		jQuery("#srchProjectGroupName").val(returnValue.groupName);
		jQuery("#srchProjectGroupSeq").val(returnValue.projectGroupSeq);
	}
};

/**
 * 개발그룹삭제
 */
doRemoveProjectGroup = function() {
	jQuery("#srchProjectGroupName").val("");
	jQuery("#srchProjectGroupSeq").val("");
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchStudioWorkResult.jsp"/>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 50px" />
		<col style="width: auto" />
		<col style="width: 150px" />
		<col style="width: 160px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:CDMS:촬영구분" /> / <span class="sort" sortid="2"><spring:message code="필드:CDMS:과정명" /></span></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:CDMS:스튜디오" /></span></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:CDMS:촬영일시" /></span></th>
			<th><spring:message code="필드:CDMS:촬영결과" /><br><spring:message code="필드:CDMS:등록자" /></th>
			<th><spring:message code="필드:CDMS:촬영결과" /><br><spring:message code="필드:CDMS:등록일" /></th>
			<th><spring:message code="필드:CDMS:예약자" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l">
				<a href="#" onclick="doDetail({'workSeq' : '${row.studioWork.workSeq}'});"><aof:code type="print" codeGroup="CDMS_SHOOTING" selected="${row.studioWork.shootingCd}"/></a>
				<div><c:out value="${row.project.projectName}" /></div>
			</td>
			<td><c:out value="${row.studio.studioName}" /></td>
			<td>
				<span><aof:date datetime="${row.studioWork.startDtime}"/></span>
				<span><aof:date datetime="${row.studioWork.startDtime}" pattern="HH:mm"/></span>
				<span>~</span>
				<span><aof:date datetime="${row.studioWork.endDtime}" pattern="HH:mm"/></span>
			</td>
			<td><c:out value="${row.resultMember.memberName}" /></td>
			<td><aof:date datetime="${row.studioWork.resultDtime}"/></td>
			<td><c:out value="${row.regMember.memberName}"/></td>
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
	</c:import>

</body>
</html>