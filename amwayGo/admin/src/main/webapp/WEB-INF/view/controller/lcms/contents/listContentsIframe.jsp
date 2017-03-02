<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html decorator="popup">
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forBrowseCategory = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	FN.layerPopupWrap("layer-popup-wrap", "0", "scroll-y");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/lcms/contents/list/iframe.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/lcms/contents/list/iframe.do"/>";
	
	forBrowseCategory = $.action("layer");
	forBrowseCategory.config.formId = "FormParameters";
	forBrowseCategory.config.url    = "/category/master/list/popup.do";
	forBrowseCategory.config.parameters = "callback=doSetCategory";
	forBrowseCategory.config.options.width = 500;
	forBrowseCategory.config.options.height = 370;
	forBrowseCategory.config.options.title = "<spring:message code="글:콘텐츠:분류선택"/>";

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
 * 분류찾기
 */
doBrowseCategory = function() {
	forBrowseCategory.run();	
}
/**
 * 분류세팅
 */
doSetCategory = function(returnValue) {
	if (typeof returnValue === "object") {
		var form = UT.getById(forSearch.config.formId);
		form.elements["srchCategorySeq"].value = returnValue.categorySeq;
		form.elements["srchCategoryName"].value = returnValue.categoryName;
	}
};
/**
 * 선택
 */
doSelect = function(seq, title) {
	var returnValue = {
		'code' : 'organization',
		'seq' : seq,
		'title' : title
	};
	parent.doSelect(returnValue);
	doClose();
};
/**
 * 닫기
 */
doClose = function() {
	parent.doClose('organization');
};
</script>
</head>

<body>

	<div class="align-l position-rel" style="height:30px; line-height:30px; background-color:#cdcdcd;">
		<span class="strong margin-l-10"><spring:message code="글:콘텐츠:매핑"/></span>
		<div class="icon-close" onclick="doClose()" title="<spring:message code="버튼:닫기" />"></div>
	</div>

	<c:set var="srchKey">title=<spring:message code="필드:콘텐츠:콘텐츠그룹명"/>,description=<spring:message code="필드:콘텐츠:설명"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchCategorySeq" value="<c:out value="${condition.srchCategorySeq}"/>" />
				<strong><spring:message code="필드:콘텐츠:분류"/></strong>
				<input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:300px;" readonly="readonly"/>
				<a href="javascript:void(0)" onclick="doBrowseCategory()" class="btn gray"><span class="small"><spring:message code="버튼:분류선택"/></span></a>
				
				<br>
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
		<input type="hidden" name="srchCategorySeq"  value="<c:out value="${condition.srchCategorySeq}"/>" />
		<input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" />
	</form>
	
	<div class="scroll-y" style="height:342px; padding:0 5px;">
		<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<table class="list margin-b-10">
			<colgroup>
				<col style="width: 50px" />
				<col style="width: 50px" />
				<col style="width: auto" />
				<col style="width: 100px" />
			</colgroup>
			<tbody>
			<tr>
				<th colspan="4" class="align-l" style="padding-left:10px;"><c:out value="${row.contents.title}" /></th>
			</tr>
			<c:if test="${!empty row.listOrganization}">
				<c:set var="weekCount" value="0"/>
				<c:set var="prevOrganizationSeq" value=""/>
				<c:forEach var="rowSub" items="${row.listOrganization}" varStatus="i">
					<c:if test="${prevOrganizationSeq ne rowSub.organization.organizationSeq}">
						<c:set var="weekCount" value="${weekCount + 1}"/>
						<tr>
							<td class="align-c">
								<a href="javascript:void(0)" 
									onclick="doSelect('<c:out value="${rowSub.organization.organizationSeq}" />','<c:out value="${rowSub.organization.title}" />');" 
									class="btn gray"><span class="small"><spring:message code="글:선택"/></span></a>
							</td>
							<td class="align-c"><strong><c:out value="${weekCount}"/><spring:message code="필드:콘텐츠:주차"/></strong></td>
							<td class="align-l"><strong><c:out value="${rowSub.organization.title}"/></strong></td>
							<td class="align-r"><strong><aof:code type="print" codeGroup="CONTENTS_TYPE" selected="${rowSub.organization.contentsTypeCd}"/></strong></td>
						</tr>
					</c:if>
					<%--
					<tr>
						<td>&nbsp;</td>
						<td class="align-c"><c:out value="${rowSub.item.sortOrder + 1}"/><spring:message code="필드:콘텐츠:교시"/></td>
						<td class="align-l"><c:out value="${rowSub.item.title}"/></td>
						<td>&nbsp;</td>
					</tr>
					 --%>
					<c:set var="prevOrganizationSeq" value="${rowSub.organization.organizationSeq}"/>
				</c:forEach>
			</c:if>
			</tbody>
			</table>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
			<table class="tbl-list">
			<tr>
				<td class="align-c"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
			</table>
		</c:if>
		</form>
	
		<c:import url="/WEB-INF/view/include/paging.jsp">
			<c:param name="paginate" value="paginate"/>
		</c:import>
	</div>

</body>
</html>