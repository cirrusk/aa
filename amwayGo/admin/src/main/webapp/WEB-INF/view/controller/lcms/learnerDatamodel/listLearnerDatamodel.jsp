<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forBrowseMember = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2]. datepicker
	UI.datepicker("#srchStartUpdDate");
	UI.datepicker("#srchEndUpdDate");
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action("normal", {formId : "FormSrch"});
	forSearch.config.url    = "<c:url value="/lcms/learner/datamodel/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/lcms/learner/datamodel/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/lcms/learner/datamodel/detail.do"/>";

	forBrowseMember = $.action("layer");
	forBrowseMember.config.formId = "FormBrowseMember";
	forBrowseMember.config.url    = "/member/all/list/popup.do";
	forBrowseMember.config.options.width = 700;
	forBrowseMember.config.options.height = 500;
	forBrowseMember.config.options.title = "<spring:message code="필드:콘텐츠:학습자선택"/>";

	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forSearch.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습기간시작일"/>",
		name : "srchStartUpdDate",
		check : {
			date : "<c:out value="${aoffn:config('format.date')}"/>"
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습기간종료일"/>",
		name : "srchEndUpdDate",
		check : {
			date : "<c:out value="${aoffn:config('format.date')}"/>"
		}
	});
	forSearch.validator.set({
		title : "<spring:message code="필드:콘텐츠:학습기간시작일"/>",
		name : "srchStartUpdDate",
		check : {
			le : {name : "srchEndUpdDate", title : "<spring:message code="필드:콘텐츠:학습기간종료일"/>"}
		}
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
 * 학습자찾기
 */
 doBrowseMember = function() {
	forBrowseMember.run();	
}
/**
 * 분류세팅
 */
doSetMember = function(returnValue) {
	if (typeof returnValue === "object") {
		var form = UT.getById(forSearch.config.formId);
		form.elements["srchLearnerId"].value = returnValue.memberSeq;
		form.elements["srchLearnerName"].value = returnValue.memberName;
	}
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchLearnerDatamodel.jsp"/>

	<c:choose>
		<c:when test="${condition.srchYn eq 'Y'}">
		
			<c:import url="/WEB-INF/view/include/perpage.jsp">
				<c:param name="onchange" value="doSearch"/>
				<c:param name="selected" value="${condition.perPage}"/>
			</c:import>
			<form id="FormData" name="FormData" method="post" onsubmit="return false;">
			<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width: 50px" />
				<col style="width: 80px" />
				<col style="width: auto" />
				<col style="width: auto" />
				<col style="width: 90px" />
				<col style="width: 70px" />
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="필드:번호" /></th>
					<th><spring:message code="필드:콘텐츠:학습자" /></th>
					<th><spring:message code="필드:콘텐츠:주차제목" /></th>
					<th><spring:message code="필드:콘텐츠:교시제목" /></th>
					<th><spring:message code="필드:콘텐츠:최종학습일" /></th>
					<th><spring:message code="필드:상세보기" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
			        <td><c:out value="${paginate.descIndex - i.index}"/></td>
					<td><c:out value="${row.learnerDatamodel.learnerName}" /></td>
					<td class="align-l"><c:out value="${row.organization.title}"/></td>
					<td class="align-l"><c:out value="${row.item.title}"/></td>
					<td><aof:date datetime="${row.learnerDatamodel.updDtime}"/></td>
					<td>
						<a href="javascript:void(0)"
						   onclick="doDetail({
						'learnerId' : '${row.learnerDatamodel.learnerId}',
						'courseActiveSeq' : '${row.learnerDatamodel.courseActiveSeq}',
						'courseApplySeq' : '${row.learnerDatamodel.courseApplySeq}',
						'organizationSeq' : '${row.learnerDatamodel.organizationSeq}',
						'itemSeq' : '${row.learnerDatamodel.itemSeq}'
						})" class="btn gray"><span class="small"><spring:message code="버튼:보기" /></span></a>
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
		</c:when>
		<c:otherwise>
			<div class="vspace"></div>
			<div class="lybox align-c">
				<spring:message code="글:검색조건을확인하신후검색버튼을클릭하십시오"/>
			</div>
		</c:otherwise>
	</c:choose>
	
</body>
</html>