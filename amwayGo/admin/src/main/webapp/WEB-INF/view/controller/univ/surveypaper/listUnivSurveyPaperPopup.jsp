<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     	= null;
var forListdata   	= null;
var forPreviewPopup = null;
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
	forSearch.config.url    = "<c:url value="/univ/surveypaper/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/surveypaper/list/popup.do"/>";
	
	forPreviewPopup = $.action("popup");
	forPreviewPopup.config.formId         = "FormPreviewPopup";
	forPreviewPopup.config.url            = "<c:url value="/univ/surveypaper/preview/popup.do"/>";
	forPreviewPopup.config.options.width  = 700;
	forPreviewPopup.config.options.height = 500;
	
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
 * 선택
 */
doSelect = function(index) {
	var returnValue = {
		code : 'survey',
		surveyPaperSeq : '',
		surveyPaperTitle : ''
	};
	jQuery("#FormData :input[name=surveyPaperSeqs]").each(function(i) {
		if (i == index) {
			returnValue.surveyPaperSeq = this.value;
		}
	});
	jQuery("#FormData :input[name=surveyPaperTitles]").each(function(i) {
		if (i == index) {
			returnValue.surveyPaperTitle = this.value;
		}
	});
	
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
	}
	$layer.dialog("close");
};
/**
 * 설문지 미리보기
 */
 doSurveyPaperPopup = function(mapPKs) {
	 // 팝업화면 form을 reset한다.
    UT.getById(forPreviewPopup.config.formId).reset();
    // 팝업화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forPreviewPopup.config.formId);
    // 팝업화면 실행
	forPreviewPopup.run();
}; 
</script>
</head>

<body>

	<c:set var="srchKey">title=<spring:message code="필드:설문:설문지제목"/>,description=<spring:message code="필드:설문:설문지설명"/></c:set>

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchUseYn"   value="<c:out value="${condition.srchUseYn}"/>" default="<c:out value="${condition.srchUseYn}"/>"/>
				<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>"/>

				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
				<%--
				<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
				 --%>
			</fieldset>
		</div>
	</form>
	
	<div class="vspace"></div>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchSurveyPaperTypeCd"  value="<c:out value="${condition.srchSurveyPaperTypeCd}"/>" />
		<input type="hidden" name="srchUseYn"   value="<c:out value="${condition.srchUseYn}"/>" />
		<input type="hidden" name="callback"    value="<c:out value="${param['callback']}"/>"/>
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 50px" />
		<col style="width: auto" />
		<col style="width: 100px" />
		<col style="width: 100px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:설문:설문지제목" /></span></th>
			<th><spring:message code="필드:설문:문항수" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
			<th><spring:message code="필드:설문:매핑" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l">
				<a href="javascript:void(0)" onclick="doSurveyPaperPopup({'surveyPaperSeq' : <c:out value="${row.univSurveyPaper.surveyPaperSeq}" />});"><c:out value="${row.univSurveyPaper.surveyPaperTitle}" /></a>
			</td>
			<td>
				<c:out value="${row.univSurveyPaper.surveyCount}" />
			</td>
			<td>
				<aof:date datetime="${row.univSurveyPaper.regDtime}" />
			</td>
			<td>
				<input type="hidden" name="surveyPaperSeqs" value="<c:out value="${row.univSurveyPaper.surveyPaperSeq}" />">
				<input type="hidden" name="surveyPaperTitles" value="<c:out value="${row.univSurveyPaper.surveyPaperTitle}" />">
				<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>);" class="btn gray"><span class="small"><spring:message code="필드:선택" /></span></a>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</tbody>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
	<form name="FormPreviewPopup" id="FormPreviewPopup" method="post" onsubmit="return false;">    
		<input type="hidden" name="surveyPaperSeq" />   
	</form>
	
</body>
</html>