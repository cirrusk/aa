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
	//FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/memo/member/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/memo/member/list/popup.do"/>";
	
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
	if (typeof index === "number") {
		if (form.elements["memberSeq"].length) {
			returnValue = {
				memberSeq : form.elements["memberSeq"][index].value, 	
				memberId : form.elements["memberId"][index].value, 	
				memberName : form.elements["memberName"][index].value, 	
				nickname : form.elements["nickname"][index].value 	
			};
		} else {
			returnValue = {
				memberSeq : form.elements["memberSeq"].value, 	
				memberId : form.elements["memberId"].value, 	
				memberName : form.elements["memberName"].value, 	
				nickname : form.elements["nickname"].value 	
			};
		}
	} else {
		returnValue = [];
		if (form.elements["checkkeys"].length) {
			for (var i = 0; i < form.elements["checkkeys"].length; i++) {
				if (form.elements["checkkeys"][i].checked == true) {
					var values = {
						memberSeq : form.elements["memberSeq"][i].value, 	
						memberId : form.elements["memberId"][i].value, 	
						memberName : form.elements["memberName"][i].value, 	
						nickname : form.elements["nickname"][i].value 	
					};
					returnValue.push(values);
				}
			}
		} else {
			if (form.elements["checkkeys"].checked == true) {
				var values = {
					memberSeq : form.elements["memberSeq"].value, 	
					memberId : form.elements["memberId"].value, 	
					memberName : form.elements["memberName"].value, 	
					nickname : form.elements["nickname"].value 	
				};
				returnValue.push(values);
			}
		}
	}
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
	}
	$layer.dialog("close");
};
</script>
</head>
<body>
	<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchNotInRolegroupSeq"    value="<c:out value="${condition.srchNotInRolegroupSeq}"/>" default="<c:out value="${condition.srchNotInRolegroupSeq}"/>"/>
				<input type="hidden" name="srchNotInCourseActiveSeq" value="<c:out value="${condition.srchNotInCourseActiveSeq}"/>" default="<c:out value="${condition.srchNotInCourseActiveSeq}"/>"/>
				<input type="hidden" name="select" value="<c:out value="${param['select']}"/>" />
				<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>" />
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchNotInRolegroupSeq"    value="<c:out value="${condition.srchNotInRolegroupSeq}"/>" />
		<input type="hidden" name="srchNotInCourseActiveSeq" value="<c:out value="${condition.srchNotInCourseActiveSeq}"/>" />
		<input type="hidden" name="select" value="<c:out value="${param['select']}"/>" />
		<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>" />
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<c:if test="${param['select'] eq 'multiple'}">
			<col style="width: 40px" />
		</c:if>
		<col style="width: 40px" />
		<col style="width: 150px" />
		<col style="width: 150px" />
	</colgroup>
	<thead>
		<tr>
			<c:if test="${param['select'] eq 'multiple'}">
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
			</c:if>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:멤버:이름" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<c:if test="${param['select'] eq 'multiple'}">
				<td><input type="checkbox" name="checkkeys" value="<c:out value="${i.index}" />"></td>
			</c:if>
	        <td><c:out value="${paginate.descIndex - i.index}"/>
	        	<input type="hidden" name="memberSeq" value="<c:out value="${row.member.memberSeq}" />">
	        	<input type="hidden" name="memberId" value="<c:out value="${row.member.memberId}" />">
	        	<input type="hidden" name="memberName" value="<c:out value="${row.member.memberName}" />">
	        	<input type="hidden" name="nickname" value="<c:out value="${row.member.nickname}" />">
	        </td>
			<td>
				<c:if test="${param['select'] eq 'multiple'}">
					<aof:text type="text" value="${row.member.memberName}" />
				</c:if>
				<c:if test="${param['select'] ne 'multiple'}">
					<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}" />)"><aof:text type="text" value="${row.member.memberName}" /></a>
				</c:if>
			</td>
	        <td><c:out value="${row.member.memberId}"/></td>
		</tr>
	</c:forEach>
	
	<c:if test="${empty paginate.itemList}">
		<tr>
			<c:if test="${param['select'] eq 'multiple'}">
				<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</c:if>
			<c:if test="${param['select'] ne 'multiple'}">
				<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</c:if>
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
			<c:if test="${!empty paginate.itemList and param['select'] eq 'multiple'}">
				<a href="javascript:void(0)" onclick="doSelect()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>
			</c:if>
		</li>
	</ul>

</body>
</html>