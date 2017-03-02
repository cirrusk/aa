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

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/menu/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/menu/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/menu/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/menu/create.do"/>";

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/menu/deletelist.do"/>";
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

	<c:import url="srchMenu.jsp"/>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l" id="checkButtonTop" style="display:none;">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>
	

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: 100px" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: 100px" />
        <col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:메뉴:메뉴아이디" /></th>
			<th><spring:message code="필드:메뉴:메뉴명" /></th>
			<th><spring:message code="필드:메뉴:url" /></th>
			<th><spring:message code="필드:등록일" /></th>
            <th><spring:message code="필드:메뉴:노출여부" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<c:set var="depth" value="${aoffn:toInt(fn:length(row.menu.menuId)/3)}"/>
		<tr <c:if test="${row.menu.displayYn eq 'Y'}">style="background: #e7effa"</c:if>>
			<td>
				<c:choose>
					<c:when test="${row.menu.mandatoryYn ne 'Y'}"><!-- 개발자가 DB에 직접 필수로 지정한 메뉴는 삭제 제한되게 처리하였다. -->
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
						<input type="hidden" name="menuSeqs" value="<c:out value="${row.menu.menuSeq}"/>">
					</c:when>
					<c:otherwise>
						<input type="hidden" name="menuSeqs" value="<c:out value="${row.menu.menuSeq}"/>">
					</c:otherwise>
				</c:choose>	
			</td>
	        <td><c:out value="${paginate.ascIndex + i.index}"/></td>
	        <td class="align-l"><c:out value="${row.menu.menuId}"/></td>
			<td class="align-l">
				<div style="padding-left:<c:out value="${(depth - 1) * 15}"/>px;">
					<a href="javascript:doDetail({'menuSeq' : '<c:out value="${row.menu.menuSeq}"/>'});"><c:out value="${row.menu.menuName}"/></a>
				</div>
			</td>
	        <td class="align-l"><c:out value="${row.menu.url}"/></td>
			<td><aof:date datetime="${row.menu.regDtime}"/></td>
            <td>
                <aof:code type="print" codeGroup="USEYN" selected="${row.menu.displayYn}" removeCodePrefix="true"></aof:code>
            </td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>