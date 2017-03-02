<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forDetail = null;
var forUpdateAddressGroup = null;
var forUpdate = null;
var forInsertMember = null;
var forDeletelist = null;
var forSubInsertlist = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/memo/address/group/group/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/usr/memo/address/group/detail.do"/>";	
	
	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/usr/memo/address/group/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="글:주소록:대상자를선택해주세요"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forUpdateAddressGroup = $.action("layer");
	forUpdateAddressGroup.config.formId = "FormUpdate";
	forUpdateAddressGroup.config.url = "<c:url value="/usr/memo/address/group/edit/popup.do"/>";
	forUpdateAddressGroup.config.options.width  = 500;
	forUpdateAddressGroup.config.options.height = 150;
	forUpdateAddressGroup.config.options.title  = "<spring:message code="글:주소록:그룹명수정" />";
	forUpdateAddressGroup.config.options.callback = doCompleteUpdate;
	
	
	forInsertMember = $.action("layer");
	forInsertMember.config.formId = "FormUpdate";
	forInsertMember.config.url = "<c:url value="/member/addressGroupMember/popup.do"/>";
	forInsertMember.config.options.width  = 700;
	forInsertMember.config.options.height = 600;
	forInsertMember.config.options.position = "middle";
	forInsertMember.config.options.title  = "<spring:message code="글:주소록:그룹원추가"/>";
	
	
	forSubInsertlist = $.action("submit", {formId : "FormUpdate"});
	forSubInsertlist.config.url             = "<c:url value="/message/group/member/insert.do"/>";
	forSubInsertlist.config.target          = "hiddenframe";
	forSubInsertlist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSubInsertlist.config.fn.complete     = doSubCompleteInsertlist;
	
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
	var form = UT.getById(forDetail.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	forDetail.run();
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * parent의 iframe 리사이즈 
 */
doParentResize = function() {
	parent.onLoadIframe("frame-memo-group");
};

/*
 * 인원추가 팝업창 
 */
doInsertMember = function(){
	forInsertMember.run();
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
				// 첫페이지로 이동
				doPage(1);
			}
		}
	});
};

doSubCompleteInsertlist = function(success) {
	$.alert({
		message : "<spring:message code="글:주소록:글:X명이그룹에추가되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				forDetail.run();
			}
		}
	});
}

/*
 * 주소록 그룹 수정
 */
doUpdate= function(){
	forUpdate.run();
};

/*
 * 주소록 그룹명 수정팝업호출
 */
doUpdateAddressGroup = function(){
	forUpdateAddressGroup.run();
};

/*
 * 수정후 새로고침
 */
doCompleteUpdate= function(){
	forDetail.run();
};

/*
 * 발송완료 후 상세페이지 호출
 */
doCreateMemoComplete = function(){
	forDetail.run();
};

</script>
</head>
<body>
	
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:주소록:그룹관리상세정보" /></c:param>
	</c:import>
		
	<div style="display:none;">
		<c:import url="srchMessageAddressGroup.jsp"/>
	</div>
	
	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">	
	<input type="hidden" name="addressGroupSeq" value="<c:out value="${detail.messageAddressGroup.addressGroupSeq}"/>" >
	<input type="hidden" name="srchAddressGroupSeq" value="<c:out value="${detail.messageAddressGroup.addressGroupSeq}"/>" >
	<input type="hidden" name="groupName" value="<c:out value="${detail.messageAddressGroup.groupName}"/>" >
	<input type="hidden" name="callback" value="doSubInsert"/>
	
	<div class="lybox">
		<fieldset class="align-l">
			<c:out value="${detail.messageAddressGroup.groupName}"/><span class="mid"></span>
			<a href="#" onclick="doUpdateAddressGroup()" class="btn gray"><span class="small"><spring:message code="버튼:주소록:그룹명수정" /></span></a>	
		</fieldset>
	</div>	
	</form>	
	
	<div class="vspace"></div>
	<div class="vspace"></div>
	
	<form name="FormData" id="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doCreateMemoComplete"/>
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="addressGroupSeq" value="<c:out value="${detail.messageAddressGroup.addressGroupSeq}"/>" >

		<div class="align-l"><spring:message code="글:주소록:문자/메일수신여부N선택한회원입니다." /></div>
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 60px" />
			<col style="width: 120px" />
			<col style="width: auto" />
			<col style="width: 180px" />
			<col style="width: 180px" />		
		</colgroup>
		<thead>
			<tr>
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:주소록:이름" /></th>
				<th><spring:message code="필드:주소록:소속" /></th>
				<th><spring:message code="필드:주소록:전화번호" /></th>
				<th><spring:message code="필드:주소록:이메일" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
					<input type="hidden" name="addressGroupSeqs" value="<c:out value="${row.messageAddress.addressGroupSeq}" />">
					<input type="hidden" name="memberSeqs" value="<c:out value="${row.messageAddress.memberSeq}" />">
					<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
					<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
				</td>
		        <td><c:out value="${paginate.descIndex - i.index}"/></td>
		        <td><c:out value="${row.member.memberName}" /></td>
				<td class="align-l"><c:out value="${row.category.categoryString}" /></td>
				<td>
					<c:choose>
						<c:when test="${row.member.smsYn eq 'Y'}">
							<c:out value="${row.member.phoneMobile}" />					
						</c:when>
						<c:otherwise>
							-
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${row.member.emailYn eq 'Y'}">
							<c:out value="${row.member.email}" />					
						</c:when>
						<c:otherwise>
							-
						</c:otherwise>
					</c:choose>
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
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${!empty paginate.itemList}">
				<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
				<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일" /></span></a>
				<a href="javascript:void(0)" onclick="doInsertMember()" class="btn blue"><span class="mid"><spring:message code="버튼:주소록:그룹원추가" /></span></a>
				<a href="javascript:void(0)" onclick="doList()" class="btn blue"><span class="mid"><spring:message code="버튼:목록" /></span></a>
		</div>
	</div>		
		
</body>
</html>