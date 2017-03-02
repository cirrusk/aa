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

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/zipcode/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/zipcode/list/popup.do"/>";
	
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
 * 우편번호(주소) 선택
 */
doSelect = function(index) {
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		var form = UT.getById(forListdata.config.formId);
		if (form.elements["zipcode"].length) {
			var returnValue = {zipcode : form.elements["zipcode"][index].value, addr1 : form.elements["address"][index].value};
			par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
		} else {
			var returnValue = {zipcode : form.elements["zipcode"].value, addr1 : form.elements["address"].value};
			par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
		}
	}
	$layer.dialog("close");
};
</script>
</head>

<body>

	<c:import url="srchZipcodePopup.jsp"/>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 120px" />
		<col style="width: auto" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:우편번호:우편번호" /></span></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:우편번호:주소" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td>
	        	<c:out value="${paginate.ascIndex + i.index}"/>
	        	<c:set var="viewAddress" value="${row.zipcode.sido} ${row.zipcode.gugun} ${row.zipcode.dong} ${row.zipcode.ri} ${row.zipcode.bldg} ${row.zipcode.bunji}"/>
	        	<c:set var="returnAddress" value="${row.zipcode.sido} ${row.zipcode.gugun} ${row.zipcode.dong} ${row.zipcode.ri} ${row.zipcode.bldg}"/>
	        	<input type="hidden" name="zipcode" value="<c:out value="${row.zipcode.zipcode}"/>" />
	        	<input type="hidden" name="address" value="<c:out value="${returnAddress}"/>" />
	        </td>
	        <td><a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>)"><c:out value="${row.zipcode.zipcode}"/></a></td>
			<td><a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>)"><c:out value="${viewAddress}" /></a></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="3" align="center">
				<c:choose>
					<c:when test="${empty condition.srchWord}"><spring:message code="글:우편번호:동또는리를입력하십시오" /></c:when>
					<c:otherwise><spring:message code="글:데이터가없습니다" /></c:otherwise>
				</c:choose>
			</td>
		</tr>
	</c:if>
	</table>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

</body>
</html>