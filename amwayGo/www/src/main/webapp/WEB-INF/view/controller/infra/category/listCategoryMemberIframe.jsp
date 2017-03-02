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
	forSearch.config.url    = "<c:url value="/category/member/list/iframe.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/category/member/list/iframe.do"/>";
	
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
 * 학과선택
 */
doSelect = function(index) {
	var returnValue = null;
	var form = UT.getById("FormData"); 
	if (typeof index === "number") {
		if (form.elements["categorySeq"].length) {
			returnValue = {
				categorySeq : form.elements["categorySeq"][index].value,
				categoryName : form.elements["categoryName"][index].value 	
			};
		} else {
			returnValue = {
				categorySeq : form.elements["categorySeq"].value, 	
				categoryName : form.elements["categoryName"].value
			};
		}
	} else {
		returnValue = [];
		if (form.elements["checkkeys"].length) {
			for (var i = 0; i < form.elements["checkkeys"].length; i++) {
				if (form.elements["checkkeys"][i].checked == true) {
					var values = {	
						categorySeq : form.elements["categorySeq"][i].value, 	
						categoryName : form.elements["categoryName"][i].value
					};
					returnValue.push(values);
				}
			}
		} else {
			if (form.elements["checkkeys"].checked == true) {
				var values = {
					categorySeq : form.elements["categorySeq"].value, 	
					categoryName : form.elements["categoryName"].value
				};
				returnValue.push(values);
			}
		}
		
		if(returnValue.length == 0){
			$.alert({message : "<spring:message code="글:쪽지:발송대상학과를선택하십시오"/>"});
			return false;
		}
	}
	
	if (returnValue == null ) {
		$.alert({message : "<spring:message code="글:멤버:회원을선택하십시오"/>"});
	} else {
		parent.doCallBack(returnValue);
	}	
};
</script>
</head>

<body>
	<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset class="align-l">
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="select" value="<c:out value="${param['select']}"/>" />
				<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>" />

				<select name="srchStudentYear">
					<aof:code type="option" codeGroup="STUDENT_YEAR" selected="${condition.srchStudentYear }" removeCodePrefix="true" />
				</select>
				<input type="text" name="srchCategoryName" value="${condition.srchCategoryName }" />
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
		<input type="hidden" name="select"       value="<c:out value="${param['select']}"/>" />
		<input type="hidden" name="callback"     value="<c:out value="${param['callback']}"/>" />
	</form>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	

		<form id="FormData" name="FormData" method="post" onsubmit="return false;">
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 50px" />
			<col style="width: auto" />
			<col style="width: 150px" />
		</colgroup>
		<thead>
			<tr>
				<c:choose>
					<c:when test="${param['select'] eq 'single'}"><%-- 싱글 선택 --%>
						<th><spring:message code="필드:번호" /></th>
					</c:when>
					<c:otherwise><%-- 디폴트 멀티선택 --%>
						<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
					</c:otherwise>
				</c:choose>
				<th><spring:message code="필드:분류:학과" /></th>
				<th><spring:message code="필드:분류:대상인원" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<c:choose>
					<c:when test="${param['select'] eq 'single'}"><%-- 싱글 선택 --%>
						<td>
							<c:out value="${paginate.descIndex - i.index}"/>
				        	<input type="hidden" name="categorySeq" value="<c:out value="${row.category.categorySeq}" />">
				        	<input type="hidden" name="categoryName" value="<c:out value="${row.category.categoryName}" />">
				        	<input type="hidden" name="studentYear" value="<c:out value="${row.category.categoryMemberCount}" />">
				        </td>
					</c:when>
					<c:otherwise><%-- 디폴트 멀티선택 --%>
						<td>
							<c:choose>
								<c:when test="${row.category.categoryMemberCount > 0}">
									<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}" />"></td>
						        	<input type="hidden" name="categorySeq" value="<c:out value="${row.category.categorySeq}" />">
						        	<input type="hidden" name="categoryName" value="<c:out value="${row.category.categoryName}" />">
						        	<input type="hidden" name="studentYear" value="<c:out value="${row.category.categoryMemberCount}" />">
					        	</c:when>
						        <c:otherwise>
						        	-
						        </c:otherwise>	
				        	</c:choose>
				        </td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${param['select'] eq 'single'}"><%-- 싱글 선택 --%>
						<td>
							<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}" />)"><c:out value="${row.category.categoryName}" /></a>
				        </td>
					</c:when>
					<c:otherwise><%-- 디폴트 멀티선택 --%>
						<td class="align-l">
							<c:out value="${row.category.categoryString}" />
				        </td>
					</c:otherwise>
				</c:choose>
		        <td><c:out value="${row.category.categoryMemberCount}"/></td>
			</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
			<tr>
				<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
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