<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forUpdatelist = null;
var forDeletelist = null;
var forEditMember = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);

	// [3]  
	UI.inputComment("FormSrch");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/lcms/contents/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/lcms/contents/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/lcms/contents/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/lcms/contents/create.do"/>";

	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/lcms/contents/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:변경하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	forUpdatelist.validator.set({
		title : "<spring:message code="필드:변경할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/lcms/contents/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

	forEditMember = $.action("layer", {formId : "FormData"});
	forEditMember.config.url    = "<c:url value="/lcms/contents/member/edit/popup.do"/>";
	forEditMember.config.options.width = 400;
	forEditMember.config.options.height = 300;
	forEditMember.config.options.title = "<spring:message code="글:콘텐츠:콘텐츠소유자변경"/>";
	forEditMember.validator.set({
		title : "<spring:message code="필드:변경할데이터"/>",
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
 * 목록에서 수정할 때 호출되는 함수
 */
doUpdatelist = function(returnValue) { 
	if (typeof returnValue === "object") {
		var form = UT.getById(forUpdatelist.config.formId);
		form.elements["memberSeq"].value = returnValue.memberSeq;
		forUpdatelist.run();
	}
};
/**
 * 목록변경 완료
 */
doCompleteUpdatelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가변경되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
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
/**
 * 소유자변경
 */
doEditMember = function() {
	forEditMember.run();	
}
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchContents.jsp"/>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="memberSeq">
	<input type="hidden" name="callback" value="doUpdatelist">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 70px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:콘텐츠:콘텐츠그룹명" /></span></th>
			<th><spring:message code="필드:콘텐츠:분류" /></th>
			<th><spring:message code="필드:콘텐츠:콘텐츠" /><br><spring:message code="필드:콘텐츠:소유자" /></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:콘텐츠:상태" /></span></th>
			<th><spring:message code="필드:등록자" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
			<th><spring:message code="필드:상세보기" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
				<input type="hidden" name="contentsSeqs" value="<c:out value="${row.contents.contentsSeq}" />">
				<input type="hidden" name="categorySeqs" value="<c:out value="${row.contents.categorySeq}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><c:out value="${row.contents.title}" /></td>
			<td class="align-l"><c:out value="${row.contents.categoryString}"/></td>
			<td><c:out value="${row.contents.memberName}" /></td>
			<td><aof:code type="print" codeGroup="CONTENTS_STATUS_TYPE" selected="${row.contents.statusCd}"/></td>
			<td><c:out value="${row.contents.regMemberName}" /></td>
			<td><aof:date datetime="${row.contents.regDtime}"/></td>
			<td>
				<a href="javascript:void(0)"
				   onclick="doDetail({'contentsSeq' : '${row.contents.contentsSeq}'});"
				   class="btn gray"><span class="small"><spring:message code="버튼:보기" /></span></a>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="9" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButton" style="display:none;">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEditMember()" class="btn blue"><span class="mid"><spring:message code="글:콘텐츠:콘텐츠소유자변경" /></span></a>
			</c:if>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>