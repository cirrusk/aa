<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	//FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/agreement/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/agreement/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/agreement/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/agreement/create.do"/>";

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
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};
/**
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forCreate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	// 등록화면 실행
	forCreate.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>
	
	<div class="lybox-btn-r">
		<li class="right">
                <a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
		</li>
	</div>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	        <fieldset>
		        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
		        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	        </fieldset>
	</form>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	</form>
	
	<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       value="<c:out value="${condition.srchWord}"/>" />
	</form>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage"    value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"        value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"        value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"        value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"       value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="agreementSeq"  value="<c:out value="${condition.agreementSeq}"/>" />
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 80px" />
		<col style="width: 300px" />
		<col style="width: 80px" />
		<col style="width: 60px" />
		<col style="width: 80px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th>No.</th>
			<th>약관 타입</th>
			<th>약관 제목</th>
			<th>필수 여부</th>
			<th>버전</th>
			<th>등록자</th>
			<th>등록일시</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td><c:out value="${paginate.descIndex - i.index}"/></td>
	        <td><c:out value="${row.agreement.agreementCodeName}"/></td>
			<td>
				<a href="#" onclick="doDetail({'agreementSeq' : '${row.agreement.agreementSeq}'});"><c:out value="${row.agreement.agreementTitle}"/></a>
			</td>
	        <td>
				<c:if test="${row.agreement.agreementChek == 1}">	        
	        		필수
	        	</c:if>
	        	<c:if test="${row.agreement.agreementChek == 2}">	        
	        		선택
	        	</c:if>
	        </td>
			<td><c:out value="${row.agreement.agreementVersion}"/></td>
			<td><c:out value="${row.agreement.agreementMemberName}"/></td>
			<td><aof:date datetime="${row.agreement.agreementDtime}"/></td>
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
    
    <div class="lybox-btn">
        <div class="lybox-btn-l" id="checkButton" style="display: none;">
                <a href="#" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
        </div>
        <div class="lybox-btn-r">
                <a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
        </div>
    </div>
	
</body>
</html>