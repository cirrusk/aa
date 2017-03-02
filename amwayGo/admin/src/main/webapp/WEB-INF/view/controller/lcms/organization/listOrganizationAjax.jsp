<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSubSearch   = null;
var forSubListdata = null;
initSubPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSubSrch", doSubSearch);

};
/**
 * 설정
 */
doSubInitializeLocal = function() {

	forSubSearch = $.action("ajax");
	forSubSearch.config.formId = "FormSubSrch";
	forSubSearch.config.type = "html";
	forSubSearch.config.url    = "<c:url value="/lcms/organization/list/ajax.do"/>";
	forSubSearch.config.containerId = "browseOrgData";
	forSubSearch.config.fn.complete = function () {};

	forSubListdata = $.action("ajax");
	forSubListdata.config.formId = "FormSubList";
	forSubListdata.config.type = "html";
	forSubListdata.config.url    = "<c:url value="/lcms/organization/list/ajax.do"/>";
	forSubListdata.config.containerId = "browseOrgData";
	forSubListdata.config.fn.complete = function () {};

};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSubSearch = function(rows) {
	var form = UT.getById(forSubSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSubSearch.run();
};
/**
 * 검색조건 초기화
 */
doSubSearchReset = function() {
	FN.resetSearchForm(forSubSearch.config.formId);
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doSubPage = function(pageno) {
	var form = UT.getById(forSubListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doSubList();
};
/**
 * 목록보기 가져오기 실행.
 */
doSubList = function() {
	forSubListdata.run();
};
</script>
</head>

<body>

	<c:set var="srchKey">title=<spring:message code="필드:콘텐츠:주차제목"/></c:set>
	<form name="FormSubSrch" id="FormSubSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchNotInContentsSeq" value="<c:out value="${condition.srchNotInContentsSeq}"/>" />
				<select name="srchContentsTypeCd" class="select">
					<option value=""><spring:message code="필드:콘텐츠:구분"/></option>
					<aof:code type="option" codeGroup="CONTENTS_TYPE" selected="${condition.srchContentsTypeCd}"/>
				</select>
				<select name="srchKey" class="select">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSubSearch);"/>
				<a href="#" onclick="doSubSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
				<a href="#" onclick="doSubSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
			</fieldset>
		</div>
	</form>

	<form name="FormSubList" id="FormSubList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchNotInContentsSeq" value="<c:out value="${condition.srchNotInContentsSeq}"/>" />
		<input type="hidden" name="srchContentsTypeCd" value="<c:out value="${condition.srchContentsTypeCd}"/>" />
	</form>
				
	<div class="vspace"></div>
	<form id="FormSubData" name="FormSubData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width:40px" />
		<col style="width:50px" />
		<col style="width:auto" />
		<col style="width:80px" />
		<col style="width:80px" />
		<col style="width:100px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormSubData','checkkeys');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:콘텐츠:주차제목" /></span></th>
			<th><spring:message code="필드:콘텐츠:콘텐츠" /><br><spring:message code="필드:콘텐츠:소유자" /></th>
			<th><spring:message code="필드:등록자" /></th>
			<th><spring:message code="필드:콘텐츠:구분" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>">
				<input type="hidden" name="contentsSeqs" value="<c:out value="${condition.srchNotInContentsSeq}" />">
				<input type="hidden" name="organizationSeqs" value="<c:out value="${row.organization.organizationSeq}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><c:out value="${row.organization.title}" /></td>
	        <td><c:out value="${row.organization.memberName}"/></td>
	        <td><c:out value="${row.organization.regMemberName}"/></td>
			<td><aof:code type="print" codeGroup="CONTENTS_TYPE" selected="${row.organization.contentsTypeCd}"/></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="doSubPage"/>
	</c:import>

	<script type="text/javascript">
	initSubPage();
	<c:if test="${empty paginate.itemList}">
	doAppendOrgButton(false);
	</c:if>
	<c:if test="${!empty paginate.itemList}">
	doAppendOrgButton(true);
	</c:if>
	</script>

</body>
</html>