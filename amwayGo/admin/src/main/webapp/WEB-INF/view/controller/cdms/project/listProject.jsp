<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forDetailSection = null;
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
	forSearch.config.url    = "<c:url value="/cdms/project/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/project/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/cdms/project/create.do"/>";

	forDetailSection = $.action();
	forDetailSection.config.formId = "FormDetailSection";
	forDetailSection.config.url    = "<c:url value="/cdms/project/section/detail.do"/>";
	
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
/**
 * 작업진행 화면을 호출하는 함수
 */
doDetailSection = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetailSection.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailSection.config.formId);
	// 상세화면 실행
	forDetailSection.run();
};
/**
 * 개발대상 복사 완료
 */
doCompleteCopylist = function(success) {
	$.alert({
		message : "<spring:message code="글:CDMS:X건의데이터가복사되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
};

/**
 * 개발그룹 찾기
 */
doBrowseProjectGroup = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProjectGroup";
	action.config.url    = "<c:url value="/cdms/project/group/list/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 500;
	action.config.options.title  = "<spring:message code="필드:CDMS:개발그룹"/>&nbsp;<spring:message code="버튼:선택"/>";
	action.run();
};

/**
 * 개발그룹 선택
 */
doSetProjectGroup = function(returnValue) {
	if (returnValue != null) {
		doRemoveProjectGroup(); // 기존 등록된 것 삭제
		
		jQuery("#srchProjectGroupName").val(returnValue.groupName);
		jQuery("#srchProjectGroupSeq").val(returnValue.projectGroupSeq);
	}
};

/**
 * 개발그룹삭제
 */
doRemoveProjectGroup = function() {
	jQuery("#srchProjectGroupName").val("");
	jQuery("#srchProjectGroupSeq").val("");
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchProject.jsp"/>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: 80px" />
		<col style="width: auto" />
		<col style="width: 150px" />
		<col style="width: 60px" />
		<col style="width: 60px" />
		<col style="width: 80px" />
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
			<th><spring:message code="필드:바로가기" /></th>
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
				<div class="strong"><c:out value="${row.project.projectName}" /></div>
				
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
			<td>
				<a href="javascript:void(0)" 
				   onclick="doDetail({'projectSeq' : '${row.project.projectSeq}'});" 
				   class="btn gray"><span class="small"><spring:message code="버튼:상세보기" /></span></a>

				<c:set var="memberYn" value="N"/>
				<c:forEach var="rowSub" items="${row.listProjectMember}" varStatus="iSub">
					<c:if test="${ssMemberSeq eq rowSub.member.memberSeq}">
						<c:set var="memberYn" value="Y"/>
					</c:if>	
				</c:forEach>
				<%-- 총괄PM --%>
				<c:forEach var="rowSub" items="${row.listProjectGroupMember}" varStatus="iSub">
					<c:if test="${ssMemberSeq eq rowSub.member.memberSeq}">
						<c:set var="memberYn" value="Y"/>
					</c:if>	
				</c:forEach>
				
				<c:choose>
					<c:when test="${memberYn eq 'Y'}">
						<div class="vspace"></div>
						<a href="javascript:void(0)" 
						   onclick="doDetailSection({
						   'projectSeq' : '${row.project.projectSeq}',
						   'sectionIndex' : '${!empty currentSection and !empty currentSection.sectionIndex ? currentSection.sectionIndex : ''}',
						   'outputIndex' : '${!empty currentOutput and !empty currentOutput.outputIndex ? currentOutput.outputIndex : ''}'
						   })" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:작업진행" /></span></a>
					</c:when>
					<c:otherwise>
						&nbsp;
					</c:otherwise>
				</c:choose>
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
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>