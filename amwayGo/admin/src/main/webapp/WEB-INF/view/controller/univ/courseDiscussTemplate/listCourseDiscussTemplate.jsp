<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>
<aof:session key="memberSeq" var="memberSeq"/><!-- 선임 경우사용-->
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
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
	doAutoCourseMasterComplete();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/discuss/template/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/discuss/template/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/discuss/template/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/univ/course/discuss/template/create.do"/>";
	
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
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	// 등록화면 form을 reset한다.
	UT.getById(forCreate.config.formId).reset();
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	// 등록화면 실행
	forCreate.run();
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
 * 강사 자동완성
 */
doAutoProfComplete = function() {
	
	var form = UT.getById(forSearch.config.formId);
	UI.autoCompleteByEnter(form.elements["srchProfMemberNamePrint"], function(response, value) { // source callback
		var param = [];
		param.push("srchWord=" + value);
	<c:if test="${(currentRoleCfString eq 'ASSIST' or currentRoleCfString eq 'TUTOR') and empty condition.srchProfMemberSeq}">
		param.push("srchAssistMemberSeq=<c:out value="${memberSeq}"/>");
	</c:if>

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
			}
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

/**
 * 교과목 자동완성
 */
doAutoCourseMasterComplete = function() {
	var form = UT.getById(forSearch.config.formId);
	UI.autoCompleteByEnter(form.elements["srchCourseTitlePrint"], function(response, value) { // source callback
		var param = [];
		param.push("srchWord=" + value);

		var action = $.action("ajax");
		action.config.type        = "json";
		action.config.url         = "<c:url value="/univ/coursemaster/like/title/list/json.do"/>";
		action.config.parameters  = param.join("&");
		action.config.fn.complete = function(action, data) {
			if (data != null && data.list != null) {
				var items = [];
				for (var i = 0, len = data.list.length; i < len; i++) {
					var master = data.list[i];
					var label = master.courseTitle;
					items.push({
						"courseTitle" : master.courseTitle,
						"label" : label,
						"value" : master.courseMasterSeq
					});
				}
				response(items);
			};
		};
		action.run();
	}, function(item) { // select callback
		if (item == null) {
			form.elements["srchCourseTitle"].value = "";
			form.elements["srchCourseMasterSeq"].value = "";
		}else{
			form.elements["srchCourseTitle"].value = item.courseTitle;
			form.elements["srchCourseTitlePrint"].value = item.courseTitle;
			form.elements["srchCourseMasterSeq"].value = item.value;
		}
	});		
};

</script>
</head>

<body>
	
	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>
	
	<c:import url="srchCourseDiscussTemplate.jsp"/>

	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 60px" />
		<col style="width: auto" />
		<col style="width: auto" />
		<col style="width: 120px" />
		<col style="width: 100px" />
		<col style="width: 120px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:토론:토론주제" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:교과목:교과목" /></span></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:템플릿:담당교수" /></span></th>
			<th><spring:message code="필드:템플릿:사용여부" /></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:등록일" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l"><a href="javascript:doDetail({'templateSeq' : '<c:out value="${row.discussTemplate.templateSeq}" />'});"><c:out value="${row.discussTemplate.templateTitle}" /></a></td>
	        <td class="align-l">
	        	<c:out value="${row.courseMaster.courseTitle}" />
	        </td>
	        <td>
	        	<c:out value="${row.member.memberName}" />
	        </td>
	        <td>
	        	<aof:code type="print" codeGroup="USEYN" removeCodePrefix="true" selected="${row.discussTemplate.useYn}"></aof:code>
	        </td>
			<td><aof:date datetime="${row.discussTemplate.regDtime}"/></td>
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
 
 	<div class="lybox-btn-r">
 		<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
			<a href="#" href="javascript:void(0)" onclick="doDeletelist()" style="display:none;" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
		</c:if>
		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
			<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
		</c:if>
	</div>
	
</body>
</html>