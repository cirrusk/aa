<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forDeletelist = null;
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
	forSearch.config.url    = "<c:url value="/rolegroup/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/rolegroup/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/rolegroup/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/rolegroup/create.do"/>";

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/rolegroup/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
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
 * 목록에서 삭제할 때 호출되는 함수
 */
doDeletelist = function() { 
	forDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchRolegroup.jsp"/>

	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButtonTop" style="display:none;">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doCreate()"class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: 120px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:권한그룹:권한그룹명" /></span></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:권한그룹:상위권한그룹" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:권한그룹:권한구분" /></span></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
		</tr>
	</thead>
	<tbody>
	
	<%-- 롤그룹 시퀀스 10 이하는 무조건 변경 삭제 제한 (config.xxx.xml에 member.fixedRolegroupSeqs 설정값에 해당함)--%>
	<c:set var="fixedRolegroupSeq" value="${aoffn:config('member.fixedRolegroupSeq')}"/>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<c:set var="rolegroupSeq"><c:out value="${row.rolegroup.rolegroupSeq}"/></c:set><%-- toString --%>
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')"
				<c:if test="${fixedRolegroupSeq > row.rolegroup.rolegroupSeq || row.rolegroup.sonCount > 0}">style="display:none;"</c:if>
				>
				<input type="hidden" name="rolegroupSeqs" value="<c:out value="${row.rolegroup.rolegroupSeq}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><a href="javascript:doDetail({'rolegroupSeq' : '<c:out value="${row.rolegroup.rolegroupSeq}" />'});"><c:out value="${row.rolegroup.rolegroupName}" /></a></td>
	        <td class="align-l">
				<c:choose>
					<c:when test="${empty row.rolegroup.parentRolegroupName}">
						-
					</c:when>
					<c:otherwise>
						<c:out value="${row.rolegroup.parentRolegroupName}"/>
					</c:otherwise>
				</c:choose>
	        </td>
	        <td><aof:code type="print" codeGroup="ROLE" selected="${row.rolegroup.roleCd}"/></td>
			<td><aof:date datetime="${row.rolegroup.regDtime}"/></td>
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
	
	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButton" style="display:none;">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doCreate()"class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>
	
</body>
</html>