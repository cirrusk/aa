<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_GROUP_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_GROUP_MEMBER_TYPE" var="cdmsMemberType"/>

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
	forDetail.config.url    = "<c:url value="/cdms/project/group/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/cdms/project/group/create.do"/>";

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

	<c:import url="srchProjectGroup.jsp"/>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width:50px" />
		<col style="width:auto" />
		<col style="width:100px" />
		<c:forEach var="rowSub" items="${cdmsCompanyType}" varStatus="iSub">
			<col style="width:auto" />
		</c:forEach>
		<c:forEach var="rowSub" items="${cdmsMemberType}" varStatus="iSub">
			<col style="width:auto" />
		</c:forEach>
		<col style="width:80px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:CDMS:개발그룹명" /></th>
			<th><spring:message code="필드:CDMS:단위개발수" /></th>
			<c:forEach var="rowSub" items="${cdmsCompanyType}" varStatus="iSub">
				<th><c:out value="${rowSub.codeName}"/></th>
			</c:forEach>
			<c:forEach var="rowSub" items="${cdmsMemberType}" varStatus="iSub">
				<th><c:out value="${rowSub.codeName}"/></th>
			</c:forEach>
			<th><spring:message code="필드:바로가기" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><c:out value="${row.projectGroup.groupName}" /></td>
			<td><c:out value="${row.projectGroup.projectCount}" /></td>
			<c:forEach var="rowSub" items="${cdmsCompanyType}" varStatus="iSub">
				<td class="align-l">
					<ul class="list-bullet">
						<c:forEach var="rowSubSub" items="${row.listCompany}" varStatus="iSubSub">
							<c:if test="${rowSub.code eq rowSubSub.projectCompany.companyTypeCd}">
								<li><c:out value="${rowSubSub.company.companyName}"/></li>
							</c:if>
						</c:forEach>
					</ul>
				</td>
			</c:forEach>
			<c:forEach var="rowSub" items="${cdmsMemberType}" varStatus="iSub">
				<td class="align-l">
					<ul class="list-bullet">
						<c:forEach var="rowSubSub" items="${row.listMember}" varStatus="iSubSub">
							<c:if test="${rowSub.code eq rowSubSub.projectMember.memberCdmsTypeCd}">
								<li><c:out value="${rowSubSub.member.memberName}"/>(<c:out value="${rowSubSub.member.memberId}"/>)</li>
							</c:if>
						</c:forEach>
					</ul>
				</td>
			</c:forEach>
			<td>
				<a href="javascript:void(0)" 
				   onclick="doDetail({'projectGroupSeq' : '${row.projectGroup.projectGroupSeq}'});" 
				   class="btn gray"><span class="small"><spring:message code="버튼:상세보기" /></span></a>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="<c:out value="${fn:length(cdmsCompanyType) + fn:length(cdmsMemberType) + 4}"/>" class="aling-c"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
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