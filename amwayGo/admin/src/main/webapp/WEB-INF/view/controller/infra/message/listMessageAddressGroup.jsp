<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forAddressGroupListdata = null;
var forDetail     = null;
var forDeletelist = null;

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
	forSearch.config.url    = "<c:url value="/message/group/addressgroupList.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/message/group/list.do"/>";
	
	forAddressGroupListdata = $.action();
	forAddressGroupListdata.config.formId = "FormList";
	forAddressGroupListdata.config.url    = "<c:url value="/message/group/addressgroupList.do"/>";
		
	forCreateAddressGroup = $.action("layer");
	forCreateAddressGroup.config.formId = "FormData";
	forCreateAddressGroup.config.url = "<c:url value="/message/group/create/popup.do"/>";
	forCreateAddressGroup.config.options.width  = 500;
	forCreateAddressGroup.config.options.height = 150;
	forCreateAddressGroup.config.options.title  = "<spring:message code="글:주소록:그룹명등록" />";
	forCreateAddressGroup.config.options.callback = doCreateAddressGroupComplete;
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/message/group/detail.do"/>";
	
	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/message/group/deletelist.do"/>";
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
	doAddressGroupList();
};
/**
 * 주소록 전체 목록보기 가져오기 실행.
 */
doList = function() {
	
	var form = UT.getById(forListdata.config.formId);
	form.elements["currentPage"].value = 1;
	form.elements["perPage"].value = 10;
	form.elements["orderby"].value = 0;
	form.elements["srchWord"].value = '';
	
	forListdata.run();
};

/**
 * 주소록 그룹 목록보기 가져오기 실행.
 */
doAddressGroupList = function() {
	forAddressGroupListdata.run();
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
				doAddressGroupList();
			}
		}
	});
};

/**
 * 주소록 그룹생성 팝업호출
 */
doCreateAddressGroup = function(){
	forCreateAddressGroup.run();
};

/**
 * 주소록그룹생성 완료
 */
doCreateAddressGroupComplete = function() {
	forAddressGroupListdata.run();
};

/*
 * 발송완료 후 목록재호출
 */
doCreateMemoComplete = function(){
	doAddressGroupList();
};

</script>
</head>

<body>
	
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"/>
	
	<!-- 검색화면 -->
	<c:import url="srchMessageAddressGroup.jsp"/>

	<div class="vspace"></div>
	<div class="vspace"></div>
	 
    <div class="right">
		<c:import url="/WEB-INF/view/include/perpage.jsp">
			<c:param name="onchange" value="doSearch"/>
			<c:param name="selected" value="${condition.perPage}"/>
		</c:import>
    </div>

	<div class="lybox-btn-l">
		<a href="javascript:doList();"><spring:message code="필드:주소록:전체" /></a>|<a href="javascript:doAddressGroupList();"><strong><spring:message code="필드:주소록:그룹" /></strong></a>
	</div>	
		
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doCreateMemoComplete"/>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 60px" />
		<col style="width: auto" />
		<col style="width: 100px" />
		<col style="width: 100px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:주소록:이름" /></th>
			<th><spring:message code="필드:주소록:그룹인원" /></th>
			<th><spring:message code="필드:주소록:상세보기" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">			
				<input type="hidden" name="addressGroupSeqs" value ="<c:out value="${row.messageAddressGroup.addressGroupSeq}"/>">
				<input type="hidden" name="groupNames" value ="<c:out value="${row.messageAddressGroup.groupName}"/>">	
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><a href="javascript:doDetail({'addressGroupSeq' : '${row.messageAddressGroup.addressGroupSeq}'});"><c:out value="${row.messageAddressGroup.groupName}" /></a></td>
			<td><c:out value="${row.messageAddressGroup.memberCount}" /><spring:message code="글:주소록:명" /></td>
			<td><a href="javascript:doDetail({'addressGroupSeq' : '${row.messageAddressGroup.addressGroupSeq}'});">상세보기</a></td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일" /></span></a>
				<a href="#" onclick="doCreateAddressGroup()" class="btn blue"><span class="mid"><spring:message code="버튼:주소록:그룹등록" /></span></a>
			</c:if>
		</div>
	</div>
</body>
</html>