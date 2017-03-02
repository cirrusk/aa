<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<!-- cs_rolgroup 의 참조문자열로 분기 처리 -->
<c:choose>
	<c:when test="${empty condition.srchCfString}">
		<c:set var="cfString" value="user"/> 
	</c:when>
	<c:otherwise>
		<c:set var="cfString" value="${condition.srchCfString}"/>
	</c:otherwise>
</c:choose>

<script type="text/javascript">
var forSubSearch     = null;
var forSubListdata   = null;
var forSubDetail     = null;
var forSubCreate     = null;
var forSubInsertlist = null;
var forSubDeletelist = null;
initSubPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doSubInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listSubTable", "<c:out value="${condition.orderby}"/>", "SubFormSrch", doSubSearch);
};
/**
 * 설정
 */
doSubInitializeLocal = function() {
	forSubSearch = $.action("ajax");
	forSubSearch.config.formId      = "SubFormSrch";
	forSubSearch.config.type        = "html";
	forSubSearch.config.containerId = "tabContainer";
	forSubSearch.config.url         = "<c:url value="/rolegroup/member/list/ajax.do"/>";
	forSubSearch.config.fn.complete = function() {};
	
	forSubListdata = $.action("ajax");
	forSubListdata.config.formId      = "SubFormList";
	forSubListdata.config.type        = "html";
	forSubListdata.config.containerId = "tabContainer";
	forSubListdata.config.url         = "<c:url value="/rolegroup/member/list/ajax.do"/>";
	forSubListdata.config.fn.complete = function() {};
	
	forSubDetail = $.action("ajax");
	forSubDetail.config.formId      = "SubFormDetail";
	forSubDetail.config.type        = "html";
	forSubDetail.config.containerId = "containerRight";
	forSubDetail.config.url         = "<c:url value="/member/all/detail/ajax.do"/>";
	forSubDetail.config.fn.complete = function() {};
	
	forSubCreate = $.action("layer");
	forSubCreate.config.formId         = "FormBrowseMember";
	forSubCreate.config.url            = "<c:url value="/member/all/list/popup.do"/>";
	forSubCreate.config.options.width  = 700;
	forSubCreate.config.options.height = 500;
	forSubCreate.config.options.title  = "<spring:message code="글:권한그룹:구성원추가"/>";

	forSubInsertlist = $.action("submit", {formId : "SubFormInsert"});
	forSubInsertlist.config.url             = "<c:url value="/rolegroup/member/insertlist.do"/>";
	forSubInsertlist.config.target          = "hiddenframe";
	forSubInsertlist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubInsertlist.config.fn.complete     = doSubCompleteInsertlist;
	
	forSubDeletelist = $.action("submit", {formId : "SubFormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forSubDeletelist.config.url             = "<c:url value="/rolegroup/member/deletelist.do"/>";
	forSubDeletelist.config.target          = "hiddenframe";
	forSubDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forSubDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubDeletelist.config.fn.complete     = doSubCompleteDeletelist;
	forSubDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSubSearch = function(rows) {
	var form = UT.getById(forSubSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSubSearch.run();
};
/**
 * 검색조건 초기화
 */
doSubSearchReset = function() {
	FN.resetSearchForm(forSubSearch.config.formId);
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doSubPage = function(pageno) {
	var form = UT.getById(forSubListdata.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doSubList();
};
/**
 * 목록보기 가져오기 실행.
 */
doSubList = function() {
	forSubListdata.run();
};
/**
 * 상세보기 화면을 호출하는 함수
 */
doSubDetail = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forSubDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forSubDetail.config.formId);
	// 상세화면 실행
	forSubDetail.run();
};
/**
 * 등록화면을 호출하는 함수
 */
doSubCreate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forSubCreate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forSubCreate.config.formId);
	// 등록화면 실행
	forSubCreate.run();
};
/**
 * 멤버추가
 */
doSubInsert = function(returnValue) {
	if (returnValue != null && returnValue.length) {
		var $form = jQuery("#" + forSubInsertlist.config.formId);
		for (var index in returnValue) {
			jQuery("<input type='hidden' name='memberSeqs' value='" + returnValue[index].memberSeq + "'>").appendTo($form);
		}
		forSubInsertlist.run();
	}
};
/**
 * 멤버추가 완료
 */
 doSubCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가추가되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doSubList();
			}
		}
	});
};
/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doSubDeletelist = function() { 
	forSubDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doSubCompleteDeletelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doSubList();
			}
		}
	});
};
/**
 * 소속찾기
 */
doBrowseCompany = function() {
	FN.doOpenCompanyPopup({url:"<c:url value="/company/list/popup.do"/>", title: "<spring:message code="필드:멤버:소속"/>", callback:"doSetCompany"});
};
/**
 * 소속 선택
 */
doSetCompany = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forSubSearch.config.formId);	
		form.elements["srchCompanySeq"].value = returnValue.companySeq;
		form.elements["srchCompanyName"].value = returnValue.companyName;
	}
};
</script>
</head>

<body>

	<table>
	<colgroup>
		<col style="width: 60%" />
		<col style="width: 20px" />
		<col style="width: 40%" />
	</colgroup>
	<tr>
		<td id="containerLeft" style="vertical-align:top;">
			<c:import url="srchRolegroupMemberAjax.jsp"/>
			
			<c:import url="/WEB-INF/view/include/perpage.jsp">
				<c:param name="onchange" value="doSubSearch"/>
				<c:param name="selected" value="${condition.perPage}"/>
			</c:import>
			
			<form id="SubFormData" name="SubFormData" method="post" onsubmit="return false;">
			<table id="listSubTable" class="tbl-list">
			<colgroup>
				<col style="width: 40px" />
				<col style="width: 40px" />
				<col style="width: 80px" />
				<col style="width: 140px" />
				<col style="width: 140px" />
				<col style="width: 50px" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('SubFormData','checkkeys','checkButton', 'checkButtonTop');" /></th>
					<th><spring:message code="필드:번호" /></th>
					<th><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
					<th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
					<th><span class="sort" sortid="3"><spring:message code="필드:멤버:이메일" /></span></th>
					<th><spring:message code="필드:멤버:상태" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
					<td>
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
						<input type="hidden" name="rolegroupSeqs" value="<c:out value="${row.rolegroupMember.rolegroupSeq}" />">
						<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
					</td>
			        <td><c:out value="${paginate.descIndex - i.index}"/></td>
					<td><a href="javascript:doSubDetail({'memberSeq' : '${row.member.memberSeq}'});"><c:out value="${row.member.memberName}" /></a></td>
			        <td><c:out value="${row.member.memberId}"/></td>
			        <td><c:out value="${row.member.email}"/></td>
			        <td><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${row.member.memberStatusCd}"/></td>
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
				<c:param name="func" value="doSubPage"/>
			</c:import>
			
			<div class="lybox-btn">
				<div class="lybox-btn-l" id="checkButton" style="display:none;">
					<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
						<a href="javascript:void(0)" onclick="doSubDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
					</c:if>
				</div>
				<div class="lybox-btn-r">
					<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
						<a href="javascript:void(0)" onclick="doSubCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
					</c:if>
				</div>
			</div>
			
			<script type="text/javascript">
			initSubPage();
			</script>
		</td>
		<td></td>
		<td id="containerRight" style="vertical-align:top;"></td>
	</tr>
	</table>
	
</body>
</html>