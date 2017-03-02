<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     	= null;
var forListdata   	= null;
var forPlanLayer	= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	UI.inputComment("FormSrch");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/usr/univ/course/active/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/univ/course/active/list.do"/>";
	
	forPlanLayer = $.action("layer");
	forPlanLayer.config.formId      = "FormPlanLayer";
	forPlanLayer.config.url = "<c:url value="/usr/common/course/plan/detail/popup.do"/>";
	forPlanLayer.config.options.width = 1006;
	forPlanLayer.config.options.height = 800;
	forPlanLayer.config.options.draggable = false;
	forPlanLayer.config.options.titlebarHide = true;
	forPlanLayer.config.options.backgroundOpacity = 0.9;
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

doPlanLayer = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forPlanLayer.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPlanLayer.config.formId);
	// 상세화면 실행
	forPlanLayer.run();
};
</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:목록" /></c:param>
</c:import>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	</form>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	</form>
	<form name="FormPlanLayer" id="FormPlanLayer" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value=""/>
	</form>

	<table class="tbl-detail"><!-- tbl-detail -->
		<colgroup>
			<col style="width:15%;"/>
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:개설과목:수강년도학기"/></th>
				<td>
					<span><c:out value="${nowYearTerm.yearTermName }" /></span>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="vspace"></div>
	<form id="FormSrch" name="FormSrch" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		
	<div class="lybox">
		<fieldset>
			<input type="text" name="srchCategoryName" style="width:300px;" value="${condition.srchCategoryName }" />
			<div class="comment"><spring:message code="글:개설과목:분류명을입력하십시오"/></div>
		</fieldset>
		<fieldset>
			<input type="text" name="srchWord" style="width:300px;" value="${condition.srchWord }" />
			<div class="comment"><spring:message code="글:개설과목:과목명을입력하십시오"/></div>
			<a href="#" onclick="doSearch();" class="btn black"><span class="mid"><spring:message code="버튼:검색"/></span></a>
		</fieldset>
	</div>
	</form>
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	
	<table class="lecture-list">
	<colgroup>
		<col style="width:50%;" />
		<col style="width:25%;" />
		<col style="width:10%;" />
	</colgroup>
	<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<dl class="lecture-info">
					<dt><c:out value="${row.category.categoryString }" /></dt>
					<dd><c:out value="${row.courseActive.courseActiveTitle}"/><span><c:out value="${row.lecturer.profMemberName }" /></span></dd>
				</dl>
			</td>
			<td><aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row.courseActive.completeDivisionCd }" /> <div class="vspace"></div><c:out value="${row.courseActive.completeDivisionPoint }" /><spring:message code="필드:개설과목:학점"/></td>
			<td>
				<a href="#" onclick="doPlanLayer({'courseActiveSeq' : '<c:out value="${row.courseActive.courseActiveSeq}" />'})" class="btn gray"><span class="small"><spring:message code="버튼:개설과목:강의계획서" /></span></a><div class="vspace"></div>
			</td>
		</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
	        <tr>
	            <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
	        </tr>
	    </c:if>
	</tbody>
	</table>
	<c:import url="/WEB-INF/view/include/paging.jsp">
	    <c:param name="paginate" value="paginate"/>
	</c:import>
</body>
</html>