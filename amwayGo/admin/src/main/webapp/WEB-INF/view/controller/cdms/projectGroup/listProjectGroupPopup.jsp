<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail	  = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/cdms/project/group/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/group/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/project/list/popup.do"/>";
	
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
 * 개발그룹 선택
 */
doSelect = function(returnValue) {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
	}
	$layer.dialog("close");
};

/*
 * 단위개발보기
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

	<c:set var="srchKey">groupName=<spring:message code="필드:CDMS:개발그룹명"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>" />
				
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
				<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
			</fieldset>
		</div>
	</form>

	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="callback"     value="<c:out value="${param['callback']}"/>" />
	</form>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq" />
		<input type="hidden" name="callback" value="doSetProject">
	</form>
	
	<div class="vspace"></div>
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width:50px" />
		<col style="width:auto" />
		<col style="width:100px" />
		<col style="width:auto" />
		<col style="width:60px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:CDMS:개발그룹명" /></th>
			<th><spring:message code="필드:CDMS:단위개발수" /></th>
			<th><spring:message code="필드:CDMS:총괄PM" /></th>
			<th><spring:message code="필드:선택" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><c:out value="${row.projectGroup.groupName}" /></td>
			<td><c:out value="${row.projectGroup.projectCount}" /></td>
			<td><c:out value="${row.pmMember.memberName}" />(<c:out value="${row.pmMember.memberId}" />)</td>
			<td>
				<c:choose>
					<c:when test="${param['popupType'] eq 'Group' }">
						<a href="javascript:void(0)" onclick="doDetail({'projectGroupSeq' : '${row.projectGroup.projectGroupSeq}'});" class="btn gray">
						<span class="small"><spring:message code="버튼:선택" /></span>
						</a>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doSelect({'projectGroupSeq' : '${row.projectGroup.projectGroupSeq}', 'groupName' : '${row.projectGroup.groupName}'});" class="btn gray">
							<span class="small"><spring:message code="버튼:선택" /></span>
						</a>
					</c:otherwise>
				</c:choose>
				
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

</body>
</html>