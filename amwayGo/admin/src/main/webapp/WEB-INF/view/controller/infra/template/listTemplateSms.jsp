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
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/template/sms/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/template/sms/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/template/sms/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/template/sms/create.do"/>";

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

	<c:import url="srchTemplate.jsp"/>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 50px" />
		<col style="width: 300px" />
		<col style="width: auto" />
		<col style="width: 90px" />
		<col style="width: 90px" />
		<col style="width: 90px" />
		<col style="width: 90px" />
		<col style="width: 120px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:템플릿:제목" /></th>
			<th><spring:message code="필드:템플릿:내용" /></th>
			<th><spring:message code="필드:템플릿:구분" /></th>
			<th><spring:message code="필드:템플릿:사용여부" /></th>
			<th><spring:message code="필드:템플릿:기본템플릿적용여부" /></th>
			<th><spring:message code="필드:등록자" /></th>
			<th><spring:message code="필드:등록일" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l">
				<a href="#" onclick="doDetail({'templateSeq' : '${row.template.templateSeq}'});"><c:out value="${row.template.templateTitle}" /></a>
			</td>
			<td class="align-l ellipsis">
				<c:out value="${row.template.templateContent1}" /><c:out value="${row.template.templateContent2}" /><c:out value="${row.template.templateContent3}" />
			</td>
			<td><aof:code type="print" codeGroup="SMS_TYPE" selected="${row.template.smsTypeCd}" /></td>
			<td><aof:code type="print" codeGroup="YESNO" removeCodePrefix="true" ref="2" selected="${row.template.useYn}" /></td>
			<td><aof:code type="print" codeGroup="YESNO" removeCodePrefix="true" ref="2" selected="${row.template.basicUseYn}" /></td>
			<td><c:out value="${row.template.regMemberName}"/></td>
			<td><aof:date datetime="${row.template.regDtime}"/></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="8" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>