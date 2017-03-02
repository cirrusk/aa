<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forInsert = null;
var forStatusInsert =null;
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
	forSearch.config.url    = "<c:url value="/memo/group/member/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/memo/group/member/popup.do"/>";
	
	forInsert = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/memo/group/member/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.validator.set({
		title : "<spring:message code="글:쪽지:추가할대상자를선택"/>",
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
/*
 * 등록 완료시 부모 iframe 새로고침
 */
doCompleteInsert  = function(){
	var par = $layer.dialog("option").parent;
	
	if (typeof par["<c:out value="${param['callbackValue']}"/>"] === "function") {		
		par["<c:out value="${param['callbackValue']}"/>"].call(this);	
	}else{
		alert("error");
	}	

};
/*
 * 추가 인벤트
 */
doSelect = function(){
	forInsert.run();
}
</script>
</head>
<body>
	<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="addressGroupSeq" value="<c:out value="${memoAddress.addressGroupSeq}"/>">
	<input type="hidden" name="callbackValue" value="reSetList" id="callbackValue"/>
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
				<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>				
			</fieldset>
		</div>
	</form>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="addressGroupSeq" value="<c:out value="${memoAddress.addressGroupSeq}"/>">
		<input type="hidden" name="callbackValue" value="reSetList" id="callbackValue"/>
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">	
	<input type="hidden" name="addressGroupSeq" id="addressGroupSeq" value="<c:out value="${memoAddress.addressGroupSeq}"/>">
		<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width: 40px" />
				<col style="width: 40px" />
				<col style="width: 150px" />
				
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>					
					<th><spring:message code="필드:멤버:이름" /></th>
					<th><spring:message code="필드:멤버:아이디" /></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
					<td><input type="checkbox" name="checkkeys" value="<c:out value="${i.index}" />">
						<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">			        	
					</td>
					<td><aof:text type="text" value="${row.member.memberName}" /></td>
			        <td><c:out value="${row.member.memberId}"/></td>
				</tr>
			</c:forEach>
			
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
			</tbody>
		</table>
	</form>
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	<ul class="buttons">	
		<li class="right">
			<a href="javascript:void(0)" onclick="doSelect()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>			
		</li>
	</ul>
</body>
</html>