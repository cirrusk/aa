<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forSelect = null;
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
	forSearch.config.url    = "<c:url value="/univ/survey/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/survey/list/popup.do"/>";

	forSelect = $.action("script", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forSelect.validator.set({
		title : "<spring:message code="필드:추가할데이터"/>",
		name : "checkkeys",
		data : [ "!null" ]
	});
	
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
 * 다중 선택
 */
doSelectMultiple = function() {
	if (forSelect.validator.isValid() == false) {
		return;
	}
	var form = UT.getById("FormData");
	if (typeof form.elements["checkkeys"] === "undefined") {
		return;
	}
	var	returnValue = [];
	if (form.elements["checkkeys"].length) {
		for ( var i = 0; i < form.elements["checkkeys"].length; i++) {
			if (form.elements["checkkeys"][i].checked == true) {
				var values = {
					surveySeq : form.elements["surveySeq"][i].value
				};
				returnValue.push(values);
			}
		}
	} else {
		if (form.elements["checkkeys"].checked == true) {
			var values = {
				surveySeq : form.elements["surveySeq"].value
			};
			returnValue.push(values);
		}
	}
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
	}
	$layer.dialog("close");
};
</script>
</head>

<body>

	<c:set var="srchKey">title=<spring:message code="필드:설문:설문제목"/></c:set>
		
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchUseYn"               value="<c:out value="${condition.srchUseYn}"/>" default="<c:out value="${condition.srchUseYn}"/>"/>
				<input type="hidden" name="srchSurveyTypeCd"        value="<c:out value="${condition.srchSurveyTypeCd}"/>" default="<c:out value="${condition.srchSurveyTypeCd}"/>"/>
				<input type="hidden" name="srchNotInSurveyPaperSeq" value="<c:out value="${condition.srchNotInSurveyPaperSeq}" />" default="<c:out value="${condition.srchNotInSurveyPaperSeq}"/>"/>
				<input type="hidden" name="callback"                value="<c:out value="${param['callback']}" />"/>
				
				<select name="srchSurveyItemTypeCd">
					<option value=""><spring:message code="필드:설문:설문문항유형"/></option>
					<c:choose>
						<c:when test="${condition.srchSurveyTypeCd eq 'GENERAL'}">
							<aof:code type="option" codeGroup="SURVEY_GENERAL_TYPE" selected="${condition.srchSurveyItemTypeCd}"/>
						</c:when>
						<c:otherwise>
							<aof:code type="option" codeGroup="SURVEY_SATISFY_TYPE" selected="${condition.srchSurveyItemTypeCd}"/>
						</c:otherwise>
					</c:choose>
				</select>
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
<%-- 				<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a> --%>
			</fieldset>
		</div>
	</form>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchUseYn"               value="<c:out value="${condition.srchUseYn}"/>" />
		<input type="hidden" name="srchNotInSurveyPaperSeq" value="<c:out value="${condition.srchNotInSurveyPaperSeq}" />"/>
		<input type="hidden" name="srchSurveyTypeCd"        value="<c:out value="${condition.srchSurveyTypeCd}"/>" />
		<input type="hidden" name="srchSurveyItemTypeCd"    value="<c:out value="${condition.srchSurveyItemTypeCd}"/>" />
		<input type="hidden" name="callback"                value="<c:out value="${param['callback']}" />"/>
	</form>

	<div class="scroll-y" style="height:350px;">
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 40px" />
		<col style="width: auto" />
		<col style="width: 100px" />
		<col style="width: 70px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:설문:설문제목" /></span></th>
			<th><spring:message code="필드:설문:설문문항유형" /></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:설문:설문지" />&nbsp;&nbsp;<br><spring:message code="필드:설문:활용수" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}" />">
				<input type="hidden" name="surveySeq" value="<c:out value="${row.univSurvey.surveySeq}" />"> 
				<input type="hidden" name="surveyTitle" value="<c:out value="${row.univSurvey.surveyTitle}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><c:out value="${row.univSurvey.surveyTitle}"/></td>
	        <td>
				<c:choose>
					<c:when test="${row.univSurvey.surveyTypeCd eq 'SURVEY_TYPE::GENERAL'}">
						<aof:code type="print" codeGroup="SURVEY_GENERAL_TYPE" selected="${row.univSurvey.surveyItemTypeCd}"/>
					</c:when>
					<c:otherwise>
						<aof:code type="print" codeGroup="SURVEY_SATISFY_TYPE" selected="${row.univSurvey.surveyItemTypeCd}"/>
					</c:otherwise>
				</c:choose>
	        </td>
			<td><c:out value="${row.univSurvey.useCount}"/></td>
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
	</div>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doSelectMultiple()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>