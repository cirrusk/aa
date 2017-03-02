<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;

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
	forSearch.config.url    = "<c:url value="/usr/memo/send/groupdetail/popup.do"/>";
	forSearch.config.fn.complete = function() {
		doParentResize();
	};

	forListdata = $.action();
	forListdata.config.formId = "FormSrch";
	forListdata.config.url    = "<c:url value="/usr/memo/send/groupdetail/popup.do"/>";
	forListdata.config.fn.complete = function() {
		doParentResize();
	};
	
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
 * parent의 iframe 리사이즈 
doParentResize = function() {
	parent.onLoadIframe("frame-memo-receive");
};
*/

</script>
</head>

<body>

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" 	     value="1" />
		<input type="hidden" name="perPage"     	     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     		 value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="messageSendSeq"     value="<c:out value="${param['messageSendSeq']}"/>" />
		<input type="hidden" name="receiveMemberNames" value="<c:out value="${param['receiveMemberNames']}"/>" />
		<input type="hidden" name="messageSendDtime"   value="<c:out value="${param['messageSendDtime']}"/>" />
		<input type="hidden" name="description"     	 value="<c:out value="${param['description']}"/>" />
		<input type="hidden" name="readCount"     	 value="<c:out value="${param['readCount']}"/>" />		
	</form>
		
	<form id="FormDetail" name="FormData" method="post" onsubmit="return false;">
		<table class="tbl-detail">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 80px" />
			<col style="width: 120px" />
			<col style="width: 40px" />
		</colgroup>
		<thead>
			<tr>
				<th class="align-c"><spring:message code="필드:쪽지:받은사람" /></th>
				<th class="align-c"><spring:message code="필드:쪽지:전송일시" /></th>
				<th class="align-c"><spring:message code="필드:쪽지:쪽지내용" /></th>
				<th class="align-c"><spring:message code="필드:쪽지:쪽지확인" /></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="align-c"><c:out value="${param['receiveMemberNames']}"/></td>
				<td class="align-c"><aof:date datetime="${messageSend.messageSend.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
				<td class="align-l"><c:out value="${messageSend.messageSend.description}"/></td>
				<td class="align-c"><c:out value="${param['readCount']}"/></td>
			</tr>
		</tbody>
		</table>	
	</form>
	
	<div class="vspace"></div>
	<div class="vspace"></div>
		
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 80px" />
		<col style="width: 70px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:쪽지:받은사람" /></th>
			<th><spring:message code="필드:쪽지:아이디" /></th>
			<th><spring:message code="필드:쪽지:전송일시" /></th>
			<th><spring:message code="필드:쪽지:쪽지확인" /></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
		        <td><c:out value="${paginate.descIndex - i.index}"/></td>
		        <td><c:out value="${row.receiveMember.memberName}"/></td>
		        <td><c:out value="${row.receiveMember.memberId}"/></td>
		        <td><aof:date datetime="${row.messageSend.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
		        <td><aof:date datetime="${row.messageReceive.readDtime}" pattern="${aoffn:config('format.datetime')}"/></td>		        
			</tr>
		</c:forEach>
		<c:if test="${empty alwaysTopList and empty paginate.itemList}">
			<tr>
				<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
	</tbody>
	</table>
	</form>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
		
</body>
</html>