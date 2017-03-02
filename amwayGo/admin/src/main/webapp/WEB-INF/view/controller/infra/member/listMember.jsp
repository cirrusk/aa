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
var forExcelDown  = null;
var forMemoCreate = null;
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
	forSearch.config.url    = "<c:url value="/member/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/list.do"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/member/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/member/create.do"/>";

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
	forExcelDown.config.url    = "<c:url value="/member/excel/list.do"/>";
	
	forMemoCreate = $.action("layer", {formId : "FormData"});
	forMemoCreate.config.url = "<c:url value="/memo/group/send/popup.do"/>";
	forMemoCreate.config.options.width  = 500;
	forMemoCreate.config.options.height = 350;
	forMemoCreate.config.options.position = "middle";
	forMemoCreate.config.options.title  = "<spring:message code="글:쪽지:쪽지쓰기"/>";
	forMemoCreate.validator.set({
		title : "<spring:message code="글:쪽지:쪽지를발송할대상자를"/>",
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
		var form = UT.getById(forSearch.config.formId);	
		form.elements["srchCompanySeq"].value = returnValue.companySeq;
		form.elements["srchCompanyName"].value = returnValue.companyName;
	}
};
/**
 * 목록데이타 엑셀로 다운로드
 */
doExcelDown = function() {
	forExcelDown.run();
};
/*
 * 쪽지쓰기 팝업
 */
doCreateMemo = function(){
	var resultCount =$("input[name=checkkeys]").size();
	if(resultCount >0){
		forMemoCreate.run();
	}else{
		$.alert({
			message : "<spring:message code="글:쪽지:쪽지를발송할대상자를선택하십시오"/>",
			button1 : {
				callback : function() {
					return false;
				}
			}
		});
	}

};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchMember.jsp"/>

	<ul class="buttonsTop">
		<li class="left" id="checkButtonTop" style="display:none;">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</li>
		<li class="right">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'R')}">
				<a href="javascript:void(0)" onclick="doExcelDown()" class="btn blue"><span class="mid"><spring:message code="버튼:엑셀" /></span></a>
			</c:if>		
			<%--
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreateMemo()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지쓰기" /></span></a>
				<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
			 --%>
		</li>
	</ul>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 40px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
		<col style="width: auto" />
		<col style="width: 120px" />
		<col style="width: 50px" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton', 'checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:멤버:이름" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:멤버:닉네임" /></span></th>
			<th><span class="sort" sortid="6"><spring:message code="필드:멤버:소속" /></span></th>
			<th><spring:message code="필드:멤버:업무" /></th>
			<th><spring:message code="필드:멤버:상태" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
				<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
				<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><a href="javascript:doDetail({'memberSeq' : '${row.member.memberSeq}'});"><c:out value="${row.member.memberName}" /></a></td>
	        <td><c:out value="${row.member.memberId}"/></td>
	        <td><c:out value="${row.member.nickname}"/></td>
	        <td class="align-l"><c:out value="${row.company.companyName}"/></td>
	        <td><aof:code type="print" codeGroup="TASK" selected="${row.member.taskCd}"/></td>
	        <td><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${row.member.statusCd}"/></td>
			<td><aof:date datetime="${row.member.regDtime}"/></td>
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

	<ul class="buttons">	
		<li class="left" id="checkButton" style="display:none;">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</li>
		<li class="right">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'R')}">
				<a href="javascript:void(0)" onclick="doExcelDown()" class="btn blue"><span class="mid"><spring:message code="버튼:엑셀" /></span></a>
				
			</c:if>		
			<%--
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doCreateMemo()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지쓰기" /></span></a>
				<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
			 --%>
		</li>
	</ul>
	
</body>
</html>