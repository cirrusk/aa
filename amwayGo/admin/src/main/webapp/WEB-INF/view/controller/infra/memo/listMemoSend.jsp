<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forDeletelist = null;
var forReceiveGroupDetail = null;

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
	forSearch.config.url    = "<c:url value="/message/send/list/iframe.do"/>";
	forSearch.config.fn.complete = function() {
		doParentResize();
	};
	
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/message/send/list/iframe.do"/>";
	forListdata.config.fn.complete = function() {
		doParentResize();
	};
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/message/send/detail/iframe.do"/>";

	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forDeletelist.config.url             = "<c:url value="/message/sendmessage/deletelist.do"/>";
	forDeletelist.config.target          = "hiddenframe";
	forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeletelist.config.fn.complete     = doCompleteDeletelist;
	forDeletelist.validator.set({
		title : "<spring:message code="필드:삭제할데이터"/>",
		name : "checkkeys",
		data : ["!null"]
	});
	
	forReceiveGroupDetail = $.action("layer", {formId : "FormDetail"});
	forReceiveGroupDetail.config.url = "<c:url value="/message/send/groupdetail/popup.do"/>";
	forReceiveGroupDetail.config.options.width  = 800;
	forReceiveGroupDetail.config.options.height = 500;
	forReceiveGroupDetail.config.options.position = "middle";
	forReceiveGroupDetail.config.options.title  = "<spring:message code="글:쪽지:그룹쪽지확인"/>";
	
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
 * parent의 iframe 리사이즈 
 */
doParentResize = function() {
	parent.onLoadIframe("frame-memo-send");
};

/*
 * 쪽지발송완료
 */
doCreateMemoComplete = function(){
	forListdata.run();
};

//그룹발송정보 상세팝업
doGroupMessageSendDetail = function(mapPKs){
	// 상세화면 form을 reset한다.
	UT.getById("FormDetail").reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, "FormDetail");
	// 상세화면 실행
	forReceiveGroupDetail.run();
};
</script>
</head>

<body>

	<c:import url="srchMemoSend.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doCreateMemoComplete"/>
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 60px" />
		<col style="width: 120px" />
		<col style="width: 180px" />
		<col style="width: auto" />
		<col style="width: 180px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:쪽지:받은사람" /></th>
			<th><spring:message code="필드:쪽지:전송일시" /></th>
			<th><spring:message code="필드:쪽지:쪽지내용" /></th>
			<th><spring:message code="필드:쪽지:쪽지확인" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
				<input type="hidden" name="messageSendSeqs" value="<c:out value="${row.messageSend.messageSendSeq}" />">
				<c:choose>
					<c:when test="${row.messageSend.sendCount eq 1}">
						<input type="hidden" name="memberNames" value="<c:out value="${row.receiveMember.memberName}" />">
					</c:when>
					<c:otherwise>
						<input type="hidden" name="memberNames" value="${row.receiveMember.memberName} <spring:message code="글:쪽지:외" />" />
					</c:otherwise>
				</c:choose>														
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
	        <td>
				<c:choose>
					<c:when test="${row.messageSend.sendCount eq 1}">
						<c:out value="${row.receiveMember.memberName}"/>
					</c:when>
					<c:otherwise>
						<c:out value="${row.receiveMember.memberName}"/><spring:message code="글:쪽지:외" />
					</c:otherwise>
				</c:choose>
			</td>			        
			<td><aof:date datetime="${row.messageSend.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
			<td class="align-l">
				<c:choose>
					<c:when test="${row.messageSend.sendCount eq 1}">
						<a href="javascript:void(0)" onclick="doDetail({'messageSendSeq' : '${row.messageSend.messageSendSeq}',
																	    'receiveMemberNames' : '${row.receiveMember.memberName}'});">
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doDetail({'messageSendSeq' : '${row.messageSend.messageSendSeq}',
																		'receiveMemberNames' : '${row.receiveMember.memberName} <spring:message code="글:쪽지:외" />'});">
					</c:otherwise>
				</c:choose>	
							<div class="text-ellipsis">
								<c:out value="${row.messageSend.description }"></c:out>
								<c:if test="${row.messageSend.attachCount gt 0}">
									<aof:img src="icon/ico_file.gif"/>
								</c:if>	
							</div>
						</a>
			</td>			
			<td>
				<c:choose>
					<c:when test="${row.messageSend.sendCount eq 1}">
						<aof:date datetime="${row.messageReceive.readDtime}" pattern="${aoffn:config('format.datetime')}"/>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0)" onclick="doGroupMessageSendDetail({
															 	'messageSendSeq' : '<c:out value="${row.messageSend.messageSendSeq}" />' ,
																'receiveMemberNames' : '<c:out value="${row.receiveMember.memberName}" /> <spring:message code="글:쪽지:외" />' ,
																'readCount' : '<c:out value="${row.messageReceive.readCount }" />/<c:out value="${row.messageSend.sendCount }" />'
																});">
							<div class="text-ellipsis"><c:out value="${row.messageReceive.readCount }" />/<c:out value="${row.messageSend.sendCount }" /></div>
						</a>
					</c:otherwise>
				</c:choose>	
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty alwaysTopList and empty paginate.itemList}">
		<tr>
			<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
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
			</c:if>
		</div>
	</div>
	
</body>
</html>