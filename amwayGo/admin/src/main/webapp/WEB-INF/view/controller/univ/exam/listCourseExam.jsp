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
var forBrowseMaster = null;
var forExcel = null;
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
	forSearch.config.url    = "<c:url value="/univ/exam/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exam/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/exam/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormDetail";
	forCreate.config.url    = "<c:url value="/univ/exam/create.do"/>";

	forBrowseMaster = $.action("layer");
	forBrowseMaster.config.formId         = "FormBrowseCourse";
	forBrowseMaster.config.url            = "<c:url value="/univ/coursemaster/popup.do"/>";
	forBrowseMaster.config.options.width  = 700;
	forBrowseMaster.config.options.height = 500;
	forBrowseMaster.config.options.title  = "<spring:message code="필드:시험:교과목선택"/>";
	
	
// 	forExcel = $.action("layer");
// 	forExcel.config.formId         = "FormData";
// 	forExcel.config.url            = "<c:url value="/univ/exam/excel/popup.do"/>";
// 	forExcel.config.options.width  = 550;
// 	forExcel.config.options.height = 550;
// 	forExcel.config.options.title  = "<spring:message code="필드:시험:Excel문제등록"/>";
// 	forExcel.config.options.scrolling  = "yes";
// 	forExcel.config.callback=reSetList;
	
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
	
	$("#srchCourseTitle").val($("#srchCourseTitlePrint").val());

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
 * 마스터과정찾기
 */
 doBrowseCourseMaster = function() {
	forBrowseMaster.run();
};
/**
 * 과정 선택
 */
doSelectCourse = function(returnValue) {
	if (returnValue != null) {
		var form = UT.getById(forSearch.config.formId);
		form.elements["srchCourseMasterSeq"].value = returnValue.courseMasterSeq != null ? returnValue.courseMasterSeq : ""; 
		form.elements["srchCourseMasterTitle"].value = returnValue.courseTitle != null ? returnValue.courseTitle : ""; 
	}
};
/*
 * 엑셀 문제 추가
 */
doExcelCreate = function(){
	alert("준비중");
// 	forExcel.run();
};
/*
 * 엑셀 문제 추가후 고침
 */
reSetList= function(){
	doPage(1);
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
<style type="text/css">
.sub {border-top:1px #d1d1d1 dotted; border-bottom:none;}
</style>
</head>
<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<c:import url="srchCourseExam.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 60px"/>
			<col style="width: 200px"/>
			<col style="width: 200px"/>
			<col style="width: 100px"/>
			<col style="width: 80px"/>
			<col style="width: 80px"/>
			<col style="width: 100px"/>
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:시험:문제제목" /></th>
				<th><spring:message code="필드:시험:교과목" /></th>
				<th><spring:message code="필드:등록자" /></th>
				<th><spring:message code="필드:시험:활용수" /></th>
				<th><spring:message code="필드:시험:사용여부" /></th>
				<th><spring:message code="필드:등록일" /></th>
			</tr>
		</thead>
		<tbody>
			<c:set var="setExamSeq" value=""/>
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<c:if test="${row.courseExam.examCount gt 1 and setExamSeq ne row.courseExam.examSeq}">
					<tr>
						<td class="sub">※</td>
						<td class="align-l sub">
							<a href="javascript:doDetail({'examSeq' : '${row.courseExam.examSeq}'});">
							<spring:message code="필드:시험:세트문제"/>(<c:out value="${row.courseExam.examCount}"/>)<br>
							<c:out value="${row.courseExam.courseExamTitle}" /></a>
						</td>
						<td class="align-l sub"><c:out value="${row.courseMaster.courseTitle}"/></td>
						<td class="sub"><c:out value="${row.courseExam.regfMemberName}" /></td>
						<td class="sub"><c:out value="${row.courseExam.useCount}"/></td>
						<td class="sub"><aof:code type="print" codeGroup="YESNO" ref="2" selected="${row.courseExam.useYn}"/></td>
						<td class="sub"><aof:date datetime="${row.courseExam.regDtime}"/></td>
						<c:set var="setExamSeq" value="${row.courseExam.examSeq}"/>
					</tr>
				</c:if>
				<c:choose>
					<c:when test="${row.courseExam.examCount gt 1 and setExamSeq eq row.courseExam.examSeq}">
						<tr>
							<td class="sub"><c:out value="${paginate.descIndex - i.index}"/></td>
							<td colspan="8" class="align-l sub">
								[<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${row.courseExamItem.examItemTypeCd}"/>]<br>
								<c:out value="${row.courseExamItem.courseExamItemTitle}" />
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<td><c:out value="${paginate.descIndex - i.index}"/></td>
							<td class="align-l">
								<a href="javascript:doDetail({'examSeq' : '${row.courseExam.examSeq}'});">
								[<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${row.courseExamItem.examItemTypeCd}"/>]<br>
								<c:out value="${row.courseExamItem.examItemTitle}" /></a>
							</td>
							<td class="align-l sub"><c:out value="${row.courseMaster.courseTitle}"/></td>
							<td><c:out value="${row.courseExam.regMemberName}" /></td>
							<td><c:out value="${row.courseExam.useCount}"/></td>
							<td><aof:code type="print" codeGroup="YESNO" ref="2" selected="${row.courseExam.useYn}" removeCodePrefix="true"/></td>
							<td><aof:date datetime="${row.courseExam.regDtime}"/></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	<%-- 			<a href="#" onclick="doExcelCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:과정:Excel문제등록" /></span></a> --%>
				<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
			</c:if>
		</div>
	</div>

</body>
</html>