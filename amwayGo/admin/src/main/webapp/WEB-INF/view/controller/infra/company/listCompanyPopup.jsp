<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
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
	forSearch.config.url    = "<c:url value="/company/${companyType}/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/company/${companyType}/list/popup.do"/>";
	
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
 * 소속 선택
 */
doSelect = function(index) {
	var returnValue = null;
	var form = UT.getById("FormData"); 
	if (typeof index === "number") {
		if (form.elements["companySeq"].length) {
			returnValue = {
				companySeq : form.elements["companySeq"][index].value, 	
				companyName : form.elements["companyName"][index].value
			};
		} else {
			returnValue = {
				companySeq : form.elements["companySeq"].value, 	
				companyName : form.elements["companyName"].value
			};
		}
	}
	if (returnValue == null) {
		$.alert({message : "<spring:message code="글:소속:소속을선택하십시오"/>"});
	} else {
		var par = $layer.dialog("option").parent;
		if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
			par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
		}
		$layer.dialog("close");
	}		
};
</script>
</head>

<body>

	<c:set var="srchKey">companyName=<spring:message code="필드:소속:회사명"/></c:set>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>" />
				<input type="hidden" name="srchKey"    value="companyName" />
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:450px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>" />
	</form>

	<div class="scroll-y" style="height:395px;">
		<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: auto" />
			<col style="width: 80px" />
			<col style="width: 80px" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><span class="sort" sortid="2"><spring:message code="필드:소속:회사명" /></span></th>
				<th><span class="sort" sortid="3"><spring:message code="필드:소속:소속인원" /></span></th>
				<th><span class="sort" sortid="3"><spring:message code="필드:소속:선택" /></span></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
		        <td>
		        	<c:out value="${paginate.descIndex - i.index}"/>
		        	<input type="hidden" name="companySeq" value="<c:out value="${row.company.companySeq}" />">
		        	<input type="hidden" name="companyName" value="<c:out value="${row.company.companyName}" />">
		        </td>
				<td class="align-l">
					<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}" />)"><c:out value="${row.company.companyName}" /></a>
				</td>
		        <td><c:out value="${row.company.memberCount}"/></td>
		        <td><a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}" />)" class="btn gray"><span class="small"><spring:message code="버튼:선택"/></span></a></td>
			</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
			<tr>
				<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
		</table>
		</form>
		
		<c:import url="/WEB-INF/view/include/paging.jsp">
			<c:param name="paginate" value="paginate"/>
		</c:import>
	</div>
	
</body>
</html>