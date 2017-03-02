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
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/message/group/list/Iframe.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/message/group/list/Iframe.do"/>";
	
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
 * 멤버 선택
 */
doSelect = function(index) {
	var returnValue = null;	
	var form = UT.getById("FormData"); 
	returnValue = [];
	
	if($("input[name=checkkeys]:checked").length >0){
		if (form.elements["checkkeys"].length) {
			for (var i = 0; i < form.elements["checkkeys"].length; i++) {
				if (form.elements["checkkeys"][i].checked == true) {
					var values = {
						addressGroupSeq : form.elements["addressGroupSeqs"][i].value, 	
						name : form.elements["groupNames"][i].value
					};
					returnValue.push(values);
				}
			}		
			
		}else{
			
			var values = {
					addressGroupSeq : form.elements["addressGroupSeqs"].value, 	
					name : form.elements["groupNames"].value
				};
			returnValue.push(values);
		}
		
		if(returnValue.length > 0){
			parent.doCallBack(returnValue);
		}
	}else{
		$.alert({message : "<spring:message code="글:쪽지:발송대상그룹을선택하십시오"/>"});
		return false;
	}	
};
</script>
</head>

<body>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doAddReceiver"/>
		<div class="lybox search">
			<fieldset class="align-l">
				<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
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
		<input type="hidden" name="addressGroupSeq" value="<c:out value="${messageAddress.addressGroupSeq}"/>">
		<input type="hidden" name="callback" value="doAddReceiver"/>
	</form>
	
	<div class="vspace"></div>
	<div class="vspace"></div>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doAddReceiver"/>
		<table id="listTable" class="tbl-list">
			<colgroup>
				<col style="width: 50px" />
				<col style="width: auto" />
				<col style="width: 150px" />		
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
					<th><spring:message code="글:쪽지:그룹명" /></th>
					<th><spring:message code="글:쪽지:인원" /></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
						<td>
							<c:choose>
								<c:when test="${row.messageAddressGroup.memberCount > 0}">
									<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" >				
									<input type="hidden" name="addressGroupSeqs" value ="<c:out value="${row.messageAddressGroup.addressGroupSeq}"/>">
									<input type="hidden" name="groupNames" value ="<c:out value="${row.messageAddressGroup.groupName}"/>">	
								</c:when>
								<c:otherwise>
									-
								</c:otherwise>
							</c:choose>
						</td>
				        <td class="align-l"><c:out value="${row.messageAddressGroup.groupName }" /></td>
						<td>
							<input type="hidden" name="counts" value="<c:out value="${row.messageAddressGroup.memberCount }" />">
							<c:out value="${row.messageAddressGroup.memberCount }" />
						</td>
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

    <div class="lybox-btn">	
        <div class="lybox-btn-r">
			<a href="javascript:void(0)" onclick="doSelect()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>			
		</div>
	</div>

</body>
</html>