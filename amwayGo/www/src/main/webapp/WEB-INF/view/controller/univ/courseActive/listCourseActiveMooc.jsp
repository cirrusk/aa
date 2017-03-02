<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdate')}"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     	= null;
var forListdata   	= null;
var forPlan			= null;
var forInsert  = null;
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
	forSearch.config.url    = "<c:url value="/usr/univ/course/active/non/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/univ/course/active/non/list.do"/>";
	
	forPlan = $.action("layer");
	forPlan.config.formId = "FormDetail";
	forPlan.config.url    = "<c:url value="/usr/course/plan/popup.do"/>";
	forPlan.config.options.width = 700;
	forPlan.config.options.height = 480;
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/usr/course/apply/non/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:개설과목:수강신청하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:개설과목:수강신청되었습니다마이페이지에서확인하시기바랍니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:개설과목:수강신청중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};
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

/**
 * 강의계획서 팝업
 */
doPlan = function() {
	forPlan.run();
};

/**
 * 비학위과정 수강신청
 */
doApplyRequest = function(mapPKs, flag) {
	if(flag == "WAIT") {
		$.alert({message : "<spring:message code="글:개설과목:수강신청기간이아닙니다"/>"});
		return;
	} else {
		// 등록 form을 reset한다.
		UT.getById(forInsert.config.formId).reset();
		// 등록 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, forInsert.config.formId);
		// 등록 실행
		forInsert.run();		
	}
};

/**
 * 비학위과정 수강신청완료
 */
doApplyComplete = function() {
	$.alert({message : "<spring:message code="글:개설과목:이미수강신청된과목입니다"/>"});
	return;
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
	
	<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
		<input type="hidden" name="courseMasterSeq" />
		<input type="hidden" name="courseActiveSeq" />
	</form>

	<table class="tbl-detail"><!-- tbl-detail -->
		<colgroup>
			<col style="width:15%;"/>
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:개설과목:수강년도"/></th>
				<td>
					<span><c:out value="${condition.srchYear }" /></span>
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
					<dd>
						<c:if test="${row.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD }">
							[<c:out value="${row.courseActive.periodNumber }" /><spring:message code="필드:개설과목:기" />]
						</c:if>
						<c:out value="${row.courseActive.courseActiveTitle}"/><span><aof:code type="print" codeGroup="COURSE_TYPE" selected="${row.courseActive.courseTypeCd }" /></span><span><c:out value="${row.lecturer.profMemberName }" /></span>
					</dd>
					<dd>
						<spring:message code="필드:개설과목:학습기간" />
						<c:choose>
							<c:when test="${row.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
								<aof:date datetime="${row.courseActive.studyStartDate }" /> ~ <aof:date datetime="${row.courseActive.studyEndDate }" />
							</c:when>
							<c:otherwise>
								<c:out value="${row.courseActive.studyDay }" /><spring:message code="글:개설과목:일" />
							</c:otherwise>
						</c:choose>
					</dd>
				</dl>
			</td>
			<td>
				<spring:message code="필드:개설과목:신청기간" /> <aof:date datetime="${row.courseActive.applyStartDate }" /> ~ <aof:date datetime="${row.courseActive.applyEndDate }" />
			</td>
			<td>
				<a href="#" onclick="doPlan();" class="btn black"><span class="small"><spring:message code="버튼:개설과목:강의계획서" /></span></a><div class="vspace"></div>
				<div class="vspace"></div>
				<!-- 수강신청기간에 따른 버튼 변경 -->
				<c:choose>
					<c:when test="${row.courseActive.applyCount > 0 }">
						<a href="#" onclick="doApplyComplete();" class="btn gray"><span class="small"><spring:message code="버튼:개설과목:신청완료" /></span></a><div class="vspace"></div>	
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${row.courseActive.applyEndDate < today}">
								<span class="small"><spring:message code="버튼:개설과목:신청마감" /></span>							
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${row.courseActive.applyStartDate > row.courseActive.studyStartDate}">
										<a href="#" onclick="doApplyRequest({'courseMasterSeq' : '${row.courseActive.courseMasterSeq}', 'courseActiveSeq' : '${row.courseActive.courseActiveSeq }'},'WAIT');" class="btn blue"><span class="small"><spring:message code="버튼:개설과목:수강신청" /></span></a><div class="vspace"></div>									
									</c:when>
									<c:otherwise>
										<a href="#" onclick="doApplyRequest({'courseMasterSeq' : '${row.courseActive.courseMasterSeq}', 'courseActiveSeq' : '${row.courseActive.courseActiveSeq }'},'ING');" class="btn blue"><span class="small"><spring:message code="버튼:개설과목:수강신청" /></span></a><div class="vspace"></div>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
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