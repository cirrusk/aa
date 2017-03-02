<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forCreate     = null;
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
	forSearch.config.url    = "<c:url value="/univ/course/apply/member/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/apply/member/popup.do"/>";

	forCreate = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forCreate.config.url             = "<c:url value="/univ/course/apply/insertlist.do"/>";
	forCreate.config.target          = "hiddenframe";
	forCreate.config.message.confirm = "<spring:message code="글:등록하시겠습니까"/>";
	forCreate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forCreate.config.fn.complete     = function(){
		var par = $layer.dialog("option").parent;
        if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
            par["<c:out value="${param['callback']}"/>"].call(this);
        }
        $layer.dialog("close");
	};
	forCreate.validator.set({
        title : "<spring:message code="필드:수강신청:등록할대상자"/>",
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
 * 수강 등록
 */
doAddCourseApply = function(){
	forCreate.run();
}
</script>
</head>

<body>
    <form name="FormList" id="FormList" method="post" onsubmit="return false;">
        <input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
        <input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
        <input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
        <input type="hidden" name="srchMemberEmsTypeCd"    value="<c:out value="${condition.srchMemberEmsTypeCd}"/>" />
        <input type="hidden" name="srchCategoryName"    value="<c:out value="${condition.srchCategoryName}"/>" />
        
        <input type="hidden" name="srchCourseActiveSeq"  value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
        <input type="hidden" name="srchYearTerm"         value="<c:out value="${condition.srchYearTerm}"/>" />
        <input type="hidden" name="srchApplyKindCd"      value="<c:out value="${condition.srchApplyKindCd}"/>" />
        <input type="hidden" name="callback"     value="<c:out value="${param['callback']}"/>" />
    </form>
    <c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>

    <form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
        <div class="lybox">
            <fieldset>
            <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
            <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
            <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
            <input type="hidden" name="srchCourseActiveSeq"  value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
            <input type="hidden" name="srchYearTerm"         value="<c:out value="${condition.srchYearTerm}"/>" />
            <input type="hidden" name="srchApplyKindCd"      value="<c:out value="${condition.srchApplyKindCd}"/>" />
            <input type="hidden" name="callback"     value="<c:out value="${param['callback']}"/>" />
            
            <%--
            <spring:message code="필드:교과목:학부"/> : 
            <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;"/>
            
            <select name="srchMemberEmsTypeCd" class="select">
                <option value="ALL"><spring:message code="필드:전체"/></option>
                <aof:code type="option" codeGroup="MEMBER_EMP_TYPE" selected="${condition.srchMemberEmsTypeCd}" />
            </select>
             
            <br/>
            --%> 
            <select name="srchKey" class="select">
                <aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
            </select>
            <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
            <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
            </fieldset>
        </div>
    </form>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 60px" />
		<col style="width: 100px" />
        
		<col style="width: 200px" />
		<col/>
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton', 'checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:멤버:학과" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
				<input type="hidden" name="memberSeqs" value="<c:out value="${row.apply.memberSeq}" />">
                <input type="hidden" name="courseActiveSeqs" value="<c:out value="${row.apply.courseActiveSeq}" />">
                <input type="hidden" name="applyKindCds" value="<c:out value="${row.apply.applyKindCd}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><c:out value="${row.member.memberName}" /></td>
	        <td><c:out value="${row.member.memberId}"/></td>
	        <td>
                <c:out value="${row.category.categoryName}" />
	        </td>
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
		</div>
		<div class="lybox-btn-r" id="checkButton" style="display:none;">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="#" onclick="doAddCourseApply()" class="btn blue">
                    <span class="mid"><spring:message code="버튼:등록" /></span>
                </a>
			</c:if>
		</div>
	</div>
	
</body>
</html>