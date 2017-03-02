<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="menuProject" scope="request"/>
<c:set var="menuNotice" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/cdms/project/list.do'}"> <%-- 개발대상정보 메뉴를 찾는다 --%>
		<c:set var="menuProject" value="${row.menu}" scope="request"/>
	</c:if>
	<c:if test="${row.menu.url eq '/cdms/bbs/notice/list.do'}"> <%-- 공지사항 메뉴를 찾는다 --%>
		<c:set var="menuNotice" value="${row.menu}" scope="request"/>
	</c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearchProject = null;
var forListProject = null;
var forDetailProject = null;
var forDetailSection = null;
var forListNotice = null;
var forDetailNotice = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doSearchProject();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forSearchProject = $.action("ajax");
	forSearchProject.config.formId = "FormSrchProject";
	forSearchProject.config.url    = "<c:url value="/cdms/project/myproject/list.do"/>";
	forSearchProject.config.type   = "html";
	forSearchProject.config.containerId = "container-project"; 
	forSearchProject.config.fn.complete = function(action, data) {
	};

	forListProject = $.action("ajax");
	forListProject.config.formId = "FormListProject";
	forListProject.config.url    = "<c:url value="/cdms/project/myproject/list.do"/>";
	forListProject.config.type   = "html";
	forListProject.config.containerId = "container-project"; 
	forListProject.config.fn.complete = function(action, data) {
	};
	
	forDetailProject = $.action();
	forDetailProject.config.formId = "FormDetailProject";
	forDetailProject.config.url    = "<c:url value="/cdms/project/detail.do"/>";

	forDetailSection = $.action();
	forDetailSection.config.formId = "FormDetailSection";
	forDetailSection.config.url    = "<c:url value="/cdms/project/section/detail.do"/>";
	
	forListNotice = $.action();
	forListNotice.config.formId = "FormListNotice";
	forListNotice.config.url    = "<c:url value="/cdms/bbs/notice/list.do"/>";
	
	forDetailNotice = $.action();
	forDetailNotice.config.formId = "FormDetailNotice";
	forDetailNotice.config.url    = "<c:url value="/cdms/bbs/notice/detail.do"/>";

};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearchProject = function(rows) {
	var form = UT.getById(forSearchProject.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearchProject.run();
};
/**
 * 검색조건 초기화
 */
doSearchResetProject = function() {
	FN.resetSearchForm(forSearchProject.config.formId);
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPageProject = function(pageno) {
	var form = UT.getById(forListProject.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doListProject();
};
/**
 * 목록보기 가져오기 실행.
 */
doListProject = function() {
	forListProject.run();
};
/**
 * 상세보기 화면을 호출하는 함수
 */
doDetailProject = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetailProject.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailProject.config.formId);
	// 상세화면 실행
	forDetailProject.run();
};
/**
 * 작업진행 화면을 호출하는 함수
 */
doDetailSection = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetailSection.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailSection.config.formId);
	// 상세화면 실행
	forDetailSection.run();
};
/**
 * 공지사항 목록보기
 */
doListNotice = function() {
	forListNotice.run();
};
/**
 * 공지사항 상세보기 화면을 호출하는 함수
 */
doDetailNotice = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetailNotice.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailNotice.config.formId);
	// 상세화면 실행
	forDetailNotice.run();
};

/**
 * 개발그룹 찾기
 */
doBrowseProjectGroup = function() {
	var action = $.action("layer");
	action.config.formId = "FormBrowseProjectGroup";
	action.config.url    = "<c:url value="/cdms/project/group/list/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 500;
	action.config.options.title  = "<spring:message code="필드:CDMS:개발그룹"/>&nbsp;<spring:message code="버튼:선택"/>";
	action.run();
};

/**
 * 개발그룹 선택
 */
doSetProjectGroup = function(returnValue) {
	if (returnValue != null) {
		doRemoveProjectGroup(); // 기존 등록된 것 삭제
		
		jQuery("#srchProjectGroupName").val(returnValue.groupName);
		jQuery("#srchProjectGroupSeq").val(returnValue.projectGroupSeq);
	}
};

/**
 * 개발그룹삭제
 */
doRemoveProjectGroup = function() {
	jQuery("#srchProjectGroupName").val("");
	jQuery("#srchProjectGroupSeq").val("");
};
</script>
</head>
<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	</c:import>

	<form name="FormDetailProject" id="FormDetailProject" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq" />
		<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(menuProject.menuId)}"/>"/>
	</form>

	<form name="FormDetailSection" id="FormDetailSection" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq" />
		<input type="hidden" name="sectionIndex" />
		<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(menuProject.menuId)}"/>"/>
	</form>

	<form name="FormListNotice" id="FormListNotice" method="post" onsubmit="return false;">
		<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(menuNotice.menuId)}"/>"/>
	</form>

	<form name="FormDetailNotice" id="FormDetailNotice" method="post" onsubmit="return false;">
		<input type="hidden" name="bbsSeq" />
		<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(menuNotice.menuId)}"/>"/>
	</form>
	
	<form name="FormBrowseProjectGroup" id="FormBrowseProjectGroup" method="post" onsubmit="return false;">
		<input type="hidden" name="callback" value="doSetProjectGroup"/>
	</form>

	<c:if test="${!empty menuNotice}">
		<div class="lybox-tbl">
			<h4 class="title"><c:out value="${menuNotice.menuName}"/></h4>
			<div class="right">
				<a href="#" onclick="doListNotice()" class="btn gray"><span class="small"><spring:message code="버튼:더보기" /></span></a>
			</div>
		</div>

		<table class="tbl-list">
		<colgroup>
			<col style="width:auto;" />
			<c:if test="${!empty paginateNotice.itemList}">
				<col style="width:120px;" />
				<col style="width:120px;" />
			</c:if>
		</colgroup>
		<tbody>
		<c:forEach var="row" items="${paginateNotice.itemList}" varStatus="i">
			<tr>
				<td class="align-l">
					<a href="#" onclick="doDetailNotice({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
					<c:if test="${row.bbs.attachCount gt 0}">
						<aof:img src="icon/ico_file.gif"/>
					</c:if>
				</td>
				<td><c:out value="${row.bbs.regMemberName}"/></td>
				<td><aof:date datetime="${row.bbs.regDtime}"/></td>
			</tr>
		</c:forEach>
		<c:if test="${empty paginateNotice.itemList}">
			<tr>
				<td class="align-c"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
		</tbody>
		</table>
	</c:if>

	<div class="lybox mt10">
		<form name="FormSrchProject" id="FormSrchProject" method="post" onsubmit="return false;">
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="4" />
			<input type="hidden" name="orderby"     value="0" />
			
			<spring:message code="필드:CDMS:개발그룹" />
			<input type="text" id="srchProjectGroupName" name="srchProjectGroupName" readonly="readonly" />
			<input type="hidden" id="srchProjectGroupSeq" name="srchProjectGroupSeq" />
			<a href="javascript:void(0)" onclick="doBrowseProjectGroup()" class="btn black"><span class="mid"><spring:message code="버튼:선택" /></span></a>
			<div class="vspace"></div>
			<select name="srchProjectTypeCd">
				<option value=""><spring:message code="필드:CDMS:개발구분" /></option>
				<aof:code type="option" codeGroup="CDMS_PROJECT_TYPE"/>
			</select>
			<input type="hidden" name="srchKey" value="projectName" />
			<input type="text" name="srchWord" value="" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearchProject);"/>
			<a href="javascript:void(0)" onclick="doSearchProject()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			<a href="javascript:void(0)" onclick="doSearchResetProject()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
		</form>
	</div>
			
	<div id="container-project"></div>
</body>
</html>