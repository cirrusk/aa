<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType"/>
<aof:code type="set" codeGroup="CDMS_OUTPUT" var="cdmsOutput"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata				= null;
var forDetailCdmsProject	= null;
var forListCdmsProject		= null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListCdmsProject = $.action();
	forListCdmsProject.config.formId = "FormList";
	forListCdmsProject.config.url    = "<c:url value="/cdms/project/member/list/iframe.do"/>";
	
	forDetailCdmsProject = $.action();
	forDetailCdmsProject.config.formId = "FormDetail";
	forDetailCdmsProject.config.url    = "<c:url value="/cdms/project/member/detail/iframe.do"/>";
	
	forListdata = $.action();
	forListdata.config.formId = "FormListComment";
	forListdata.config.url    = "<c:url value="/cdms/comment/process/list/iframe.do"/>";
	
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
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 목록보기
 */
doListCdmsProject = function() {
	forListCdmsProject.run();
};

/**
 * 작업히스토리 목록
 */
doDetailCdmsProject = function() {
	forDetailCdmsProject.run();
};
</script>
</head>
<body>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="srchMemberSeq" value="${condition.srchMemberSeq }" />
	</form>
	
	<form name="FormListComment" id="FormListComment" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		
		<input type="hidden" name="srchProjectSeq" value="${condition.srchProjectSeq }" />
		<input type="hidden" name="srchMemberSeq" value="${condition.srchMemberSeq }" />
		<input type="hidden" name="srchMemberCdmsTypeCd" value="${condition.srchMemberCdmsTypeCd }" />
		<input type="hidden" name="viewType" value="list" />
	</form>
	
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq" value="${condition.srchProjectSeq }" />
		<input type="hidden" name="srchMemberSeq" value="${condition.srchMemberSeq }" />
		<input type="hidden" name="srchMemberCdmsTypeCd" value="${condition.srchMemberCdmsTypeCd }" />
	</form>
	
	<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
	    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
	    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
	        <li class="ui-state-default ui-corner-top">
	            <a href="javascript:void(0);" onclick="doDetailCdmsProject();"><spring:message code="글:CDMS:프로젝트정보" /></a>
	        </li>
	        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
	            <a href="javascript:void(0);"><spring:message code="글:CDMS:작업히스토리" /></a>
	        </li>
	    </ul>
	</div>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width:50px" />
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:100px;" />
		<col style="width:100px;" />
		<col style="width:100px;" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:CDMS:개발단계" /></th>
			<th><spring:message code="필드:CDMS:산출물명" /></th>
			<th><spring:message code="필드:CDMS:주차" /></th>
			<th><spring:message code="필드:CDMS:작업결과" /></th>
			<th><spring:message code="필드:CDMS:처리일" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td class="cdms-section-color-<c:out value="${row.section.sectionIndex}"/>"><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><c:out value="${row.section.sectionName}"/></td>
			<td>
				<c:choose>
					<c:when test="${!empty menuProject}">
						<a href="javascript:void(0)" onclick="doDetailSection({
	   						'projectSeq' : '${row.comment.projectSeq}',
	   						'sectionIndex' : '${row.comment.sectionIndex}',
	   						'outputIndex' : '${row.comment.outputIndex}'
	   						})"><c:out value="${row.output.outputName}"/></a>
	  					</c:when>
	  					<c:otherwise>
						<c:out value="${row.output.outputName}"/>
	  					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:choose>
					<c:when test="${!empty row.comment.moduleIndex}">
						<c:out value="${row.comment.moduleIndex}"/><spring:message code="필드:CDMS:차시"/>
					</c:when>
					<c:otherwise>
						-
					</c:otherwise>
				</c:choose>
			</td>
			<td><aof:code type="print" codeGroup="CDMS_OUTPUT_STATUS" selected="${row.comment.outputStatusCd}"/></td>
			<td><aof:date datetime="${row.comment.regDtime}"/></td>
		</tr>
	</c:forEach>
	</tbody>
	</table>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<a href="#" onclick="doListCdmsProject();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
</body>
</html>