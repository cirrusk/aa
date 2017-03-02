<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ACTIVE_LECTURER_TYPE_PROF" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.PROF')}"/>

<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>

<html>
<head>
<title></title>

<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ACTIVE_LECTURER_TYPE_PROF = "<c:out value="${CD_ACTIVE_LECTURER_TYPE_PROF}"/>";

var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var profTypeCd = {};
<c:forEach var="row" items="${profTypeCode}" varStatus="i">
profTypeCd["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
</c:forEach>

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
	UI.inputComment("FormSrch");
	doAutoProfComplete();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/homework/template/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/homework/template/list/popup.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/homework/template/detail/popup.do"/>";
	
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

doSelect = function(index) {
	var returnValue = null;
	var form = UT.getById("FormData"); 
	if (form.elements["templateSeq"].length) {
		returnValue = {
			templateSeq : form.elements["templateSeq"][index].value,
			templateTitle : form.elements["templateTitle"][index].value, 	
			templateDescription : form.elements["templateDescription"][index].value
		};
	} else {
		returnValue = {
			templateSeq : form.elements["templateSeq"].value,
			templateTitle : form.elements["templateTitle"].value, 	
			templateDescription : form.elements["templateDescription"].value
		};
	}
	
	
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);	
	}
	$layer.dialog("close");
};

doAutoProfComplete = function() {
	
	var form = UT.getById(forSearch.config.formId);
	UI.autoCompleteByEnter(form.elements["srchProfMemberNamePrint"], function(response, value) { // source callback
		var param = [];
		param.push("srchWord=" + value);
		param.push("srchCourseActiveSeq=" + form.elements["srchCourseActiveSeq"].value);
		param.push("srchActiveLecturerType=" + CD_ACTIVE_LECTURER_TYPE_PROF);

		var action = $.action("ajax");
		action.config.type        = "json";
		action.config.url         = "<c:url value="/member/prof/like/name/list/json.do"/>";
		action.config.parameters  = param.join("&");
		action.config.fn.complete = function(action, data) {
			if (data != null && data.list != null) {
				var items = [];
				for (var i = 0, len = data.list.length; i < len; i++) {
					var member = data.list[i];
					var label = member.memberName;
					label += (member.profTypeCd != "" ? " - " + profTypeCd[member.profTypeCd] : "");
					label += (member.categoryName != "" ? " - " + categoryName : "");
					items.push({
						"name" : member.memberName,
						"label" : label,
						"value" : member.memberSeq
					});
				}
				response(items);
			};
		};
		action.run();
	}, function(item) { // select callback
		if (item == null) {
			form.elements["srchProfMemberName"].value = "";
			<c:if test="${currentRoleCfString eq 'PROF'}">
				form.elements["srchProfSessionMemberSeq"].value = "";
			</c:if>
			<c:if test="${currentRoleCfString ne 'PROF'}">
				form.elements["srchProfMemberSeq"].value = "";
			</c:if>
		} else {
			form.elements["srchProfMemberName"].value = item.name;
			form.elements["srchProfMemberNamePrint"].value = item.name;
			
			<c:if test="${currentRoleCfString eq 'PROF'}">
				form.elements["srchProfSessionMemberSeq"].value = item.value;
			</c:if>
			<c:if test="${currentRoleCfString ne 'PROF'}">
				form.elements["srchProfMemberSeq"].value = item.value;
			</c:if>
		};
	});		
};

</script>
</head>

<body>

	<c:import url="srchCourseHomeworkTemplatePopup.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 50px" />
		<col style="width: auto" />
		<col style="width: 90px" />
		<col style="width: 90px" />
		<col style="width: 100px" />
		<col style="width: 90px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:과제:과제제목" /></span></th>
			<th><spring:message code="필드:템플릿:공개여부" /></th>
			<th><spring:message code="필드:템플릿:담당교수" /></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:등록일" /></span></th>
			<th><spring:message code="필드:템플릿:매핑" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td>
	        	<c:out value="${paginate.descIndex - i.index}"/>
	        	<input type="hidden" name="templateSeq" value="<c:out value="${row.homeworkTemplate.templateSeq}" />">
	        	<input type="hidden" name="templateTitle" value="<c:out value="${row.homeworkTemplate.templateTitle}" />">
	        	<input type="hidden" name="templateDescription" value="<c:out value="${row.homeworkTemplate.templateDescription}" />">
	        </td>
			<td class="align-l"><a href="javascript:doDetail({'templateSeq' : '<c:out value="${row.homeworkTemplate.templateSeq}" />'});"><c:out value="${row.homeworkTemplate.templateTitle}" /></a></td>
	        <td>
	        	<aof:code type="print" codeGroup="OPEN_YN" removeCodePrefix="true" selected="${row.homeworkTemplate.openYn}"></aof:code>
	        </td>
	        <td>
	        	<c:out value="${row.member.memberName}" />
	        </td>
			<td><aof:date datetime="${row.homeworkTemplate.regDtime}"/></td>
			<td>
				<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}" />)" class="btn gray"><span class="small"><spring:message code="필드:선택" /></span></a>
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
	
</body>
</html>