<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<c:set var="menuProject" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/cdms/project/list.do'}"> <%-- 개발대상정보 메뉴를 찾는다 --%>
		<c:set var="menuProject" value="${row.menu}" scope="request"/>
	</c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch   = null;
var forListdata = null;
var forDetail   = null;
var forUpdatelist = null;
var forProjectFile = null;
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
	forSearch.config.url    = "<c:url value="/cdms/project/data/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/data/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/project/detail.do"/>";

	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/cdms/project/data/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:CDMS:상태를변경하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	forUpdatelist.validator.set({
		title : "<spring:message code="글:CDMS:변경할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

	forProjectFile = $.action("layer");
	forProjectFile.config.formId = "FormProjectFile";
	forProjectFile.config.url    = "<c:url value="/cdms/project/file/detail.do"/>";
	forProjectFile.config.options.width  = 600;
	forProjectFile.config.options.height = 600;
	forProjectFile.config.options.title  = "<spring:message code="글:CDMS:LCMS포팅"/>";
	
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
 * 목록에서 변경할 때 호출되는 함수
 */
doUpdatelist = function() { 
	forUpdatelist.run();
};
/**
 * 목록변경 완료
 */
doCompleteUpdatelist = function(success) {
	$.alert({
		message : "<spring:message code="글:CDMS:X건의데이터가변경되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
};
/**
 * 상태변경
 */
doChangeCompleteYn = function(element) {
	var $element = jQuery(element);
	if ($element.val() == $element.siblings(":input[name='oldCompleteYns']").val() ) {
		$element.closest("tr").find(":input[name='checkkeys']").attr("checked", false);
	} else {
		$element.closest("tr").find(":input[name='checkkeys']").attr("checked", true);
	}
};
/**
 * 파일 상세 화면
 */
doProjectFile = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forProjectFile.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forProjectFile.config.formId);
	// 상세화면 실행
	forProjectFile.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:set var="cdmsCompleteYn">Y=<spring:message code="글:CDMS:종료"/>,N=<spring:message code="글:CDMS:진행중"/></c:set>
	<c:set var="srchKey">projectName=<spring:message code="필드:CDMS:과정명"/></c:set>

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<select name="srchProjectTypeCd">
					<option value=""><spring:message code="필드:CDMS:개발구분" /></option>
					<aof:code type="option" codeGroup="CDMS_PROJECT_TYPE" selected="${condition.srchProjectTypeCd}"/>
				</select>
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
				<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
			</fieldset>
		</div>
	</form>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	</form>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	
		<input type="hidden" name="projectSeq" />
		<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(menuProject.menuId)}"/>"/>
	</form>

	<form name="FormProjectFile" id="FormProjectFile" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq" />
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: 80px" />
		<col style="width: auto" />
		<col style="width: 150px" />
		<col style="width: 60px" />
		<col style="width: 70px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:CDMS:개발구분" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:CDMS:과정명" /></span></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:CDMS:개발기간" /></span></th>
			<th><spring:message code="필드:CDMS:차시수" /></th>
			<th><spring:message code="필드:CDMS:상태" /></th>
			<th><spring:message code="필드:CDMS:작업진행" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this)">
				<input type="hidden" name="projectSeqs" value="<c:out value="${row.project.projectSeq}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${row.project.projectTypeCd}"/></td>
			<td class="align-l">
				<c:choose>
					<c:when test="${!empty menuProject}">
						<a href="javascript:void(0)" onclick="doDetail({'projectSeq' : '${row.project.projectSeq}'});"><c:out value="${row.project.projectName}" /></a>
					</c:when>
					<c:otherwise>
						<c:out value="${row.project.projectName}" />
					</c:otherwise>
				</c:choose>
			</td>
			<td><aof:date datetime="${row.project.startDate}"/>~<aof:date datetime="${row.project.endDate}"/></td>
			<td><c:out value="${row.project.moduleCount}" /></td>
			<td>
				<input type="hidden" name="oldCompleteYns" value="<c:out value="${row.project.completeYn}" />">
				<select name="completeYns" onchange="doChangeCompleteYn(this)">
					<aof:code type="option" codeGroup="${cdmsCompleteYn}" selected="${row.project.completeYn}"/>
				</select>
			</td>
			<td style="vertical-align:middle">
				<a href="javascript:void(0)" onclick="doProjectFile({'projectSeq' : '${row.project.projectSeq}'})" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:LCMS포팅" /></span></a>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="8" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="javascript:void(0)" onclick="doUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:상태변경" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>