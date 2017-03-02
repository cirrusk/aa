<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<html decorator="popup">
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
	forSearch.config.url    = "<c:url value="/cdms/project/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/list/popup.do"/>";
	
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
 * 개발과정 선택
 */
doSelect = function(index) {
	var returnValue = null;
	var form = UT.getById("FormData"); 
	if (typeof index === "number") {
		if (form.elements["projectSeq"].length) {
			returnValue = {
				projectSeq : form.elements["projectSeq"][index].value, 	
				projectName : form.elements["projectName"][index].value
			};
		} else {
			returnValue = {
				projectSeq : form.elements["projectSeq"].value, 	
				projectName : form.elements["projectName"].value
			};
		}
	}
	if (returnValue == null) {
		$.alert({message : "<spring:message code="글:CDMS:과정을선택하십시오"/>"});
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

	<c:set var="srchKey">projectName=<spring:message code="필드:CDMS:과정명"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>" />
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

	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>" />
		<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	</form>

	<div class="vspace"></div>
	<div class="scroll-y" style="height:495px;">
		<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width:50px" />
			<col style="width:80px" />
			<col style="width:auto" />
			<col style="width:150px" />
			<col style="width:60px" />
			<col style="width:60px" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><span class="sort" sortid="3"><spring:message code="필드:CDMS:개발구분" /></span></th>
				<th><span class="sort" sortid="2"><spring:message code="필드:CDMS:과정명" /></span></th>
				<th><span class="sort" sortid="4"><spring:message code="필드:CDMS:개발기간" /></span></th>
				<th><spring:message code="필드:CDMS:차시수" /></th>
				<th><spring:message code="필드:CDMS:상태" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
		        <td>
		        	<c:out value="${paginate.descIndex - i.index}"/>
		        	<input type="hidden" name="projectSeq" value="<c:out value="${row.project.projectSeq}" />">
		        	<input type="hidden" name="projectName" value="<c:out value="${row.project.projectName}" />">
		        </td>
				<td><aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${row.project.projectTypeCd}"/></td>
				<td class="align-l">
					<div><a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}" />)"><c:out value="${row.project.projectName}" /></a></div>
					
					<c:set var="currentSection" value=""/>
					<c:set var="currentOutput" value=""/>
					<c:if test="${appToday ge row.project.startDate}">
						<c:set var="currentSection" value="${row.currentSection}"/>
						<c:set var="currentOutput" value="${row.currentOutput}"/>
						<c:if test="${!empty row.project.currentOutputIndex and !empty row.currentOutput}">
							<c:if test="${row.currentOutput.completeYn eq 'Y' and appToday ge row.currentOutput.endDate}">
								<c:if test="${!empty row.nextSection}">
									<c:set var="currentSection" value="${row.nextSection}"/>
								</c:if>
								<c:if test="${!empty row.nextOutput}">
									<c:set var="currentOutput" value="${row.nextOutput}"/>
								</c:if>
							</c:if>
						</c:if>
					
						<div>
							<span class="comment"><spring:message code="필드:CDMS:프로젝트단계" /> : </span>
							<span style="margin-right:10px;"><c:out value="${!empty currentSection and !empty currentSection.sectionName ? currentSection.sectionName : '-'}"/></span>
							<span class="comment"><spring:message code="필드:CDMS:공정단계" /> : </span>
							<span><c:out value="${!empty currentOutput and !empty currentOutput.outputName ? currentOutput.outputName : '-'}"/></span>
						</div>
					</c:if>
				</td>
				<td><aof:date datetime="${row.project.startDate}"/>~<aof:date datetime="${row.project.endDate}"/></td>
				<td><c:out value="${row.project.moduleCount}" /></td>
				<td>
					<c:choose>
						<c:when test="${row.project.completeYn eq 'Y'}"><spring:message code="글:CDMS:종료" /></c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${appToday ge row.project.startDate}">
									<spring:message code="글:CDMS:진행중" />
								</c:when>
								<c:otherwise>
									<spring:message code="글:CDMS:대기" />
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</td>
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
		</c:import>
	</div>
	
</body>
</html>