<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_MEMBER_EMP_TYPE_003" value="${aoffn:code('CD.MEMBER_EMP_TYPE.003')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forDeletelist = null;
var forExcelDown  = null;
var forUploadPopup = null;

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
	forSearch.config.url    = "<c:url value="/member/user/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/user/list.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/member/user/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/member/user/create.do"/>";

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/member/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});

	forExcelDown = $.action();
	forExcelDown.config.formId = "FormList";
	forExcelDown.config.url    = "<c:url value="/member/user/excel.do"/>";
	
	forUploadPopup = $.action("layer");
    forUploadPopup.config.formId         = "FormUploadExcel";
    forUploadPopup.config.url            = "<c:url value="/member/user/upload/popup.do"/>";
    forUploadPopup.config.options.title  = "<spring:message code="필드:멤버:회원등록"/>";
    forUploadPopup.config.options.width  = 600;
    forUploadPopup.config.options.height = 140;
	
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
/**
 * 목록데이타 엑셀로 다운로드
 */
doExcelDown = function() {
	forExcelDown.run();
};

/*
 * 쪽지발송완료
 */
doCreateMemoComplete = function(){
	forListdata.run();
};

/**
 * 엑셀 업로드
 */
doUploadExcel = function(){
    forUploadPopup.run();
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchMember.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 40px" />
		<col style="width: 120px" />
		<col style="width: 180px" />
		<col style="width: 140px" />
<!-- 		<col style="width: 140px" />
		<col style="width: 80px" /> -->
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton', 'checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th><span class="sort" sortid="2">ABO</span></th>
			<th><span class="sort" sortid="3">핀레벨</span></th>
<%-- 			<th><spring:message code="필드:멤버:회사" /></th>
			<th><spring:message code="필드:멤버:직급" /></th> --%>
			<%-- <th><span class="sort" sortid="4"><spring:message code="필드:멤버:회원구분" /></span></th>--%>
			<th><spring:message code="필드:멤버:계정상태" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
				<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
				<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
				<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><a href="javascript:doDetail({'memberSeq' : '${row.member.memberSeq}'});"><c:out value="${row.member.memberName}" /></a></td>
	        <td><c:out value="${row.member.memberId}"/></td>
<%-- 	        <td><c:out value="${row.member.organizationString }" /></td>
	        <td><c:out value="${row.member.companyName}" /></td> --%>
	        <td><aof:code type="print" codeGroup="POSITION" selected="${row.member.pinName}"/></td>
	        <%-- <td><aof:code type="print" codeGroup="MEMBER_EMP_TYPE" selected="${row.member.memberEmsTypeCd}"/></td>--%>
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
	</c:import>

	<div class="lybox-btn">	
		<div class="lybox-btn-l" id="checkButton" style="display:none;">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<%--
			<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue">
               	<span class="mid"><spring:message code="버튼:쪽지" /></span>
               </a>
			<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:SMS" /></span>
			</a>
			<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:이메일" /></span>
			</a>
			 --%>
<%-- 			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
            </c:if> --%>
                <a href="javascript:void(0)" onclick="doUploadExcel()" class="btn blue"><span class="mid"><spring:message code="버튼:엑셀:일괄등록" /></span></a>
		</div>
	</div>
	
</body>
</html>