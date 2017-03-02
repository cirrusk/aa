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
var forListdata			= null;
var forListCdmsComment	= null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/member/list/iframe.do"/>";
	
	forListCdmsComment = $.action();
	forListCdmsComment.config.formId = "FormListComment";
	forListCdmsComment.config.url    = "<c:url value="/cdms/comment/process/list/iframe.do"/>";
	
};

/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};

/**
 * 작업히스토리 목록
 */
doListComment = function() {
	forListCdmsComment.run();
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
		
		<input type="hidden" name="srchProjectSeq" value="${detailProject.project.projectSeq }" />
		<input type="hidden" name="srchMemberSeq" value="${condition.srchMemberSeq }" />
		<input type="hidden" name="srchMemberCdmsTypeCd" value="${condition.srchMemberCdmsTypeCd }" />
		<input type="hidden" name="viewType" value="list" />
	</form>

	<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
	    style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
	    <ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
	        <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active">
	            <a href="javascript:void(0);"><spring:message code="글:CDMS:프로젝트정보" /></a>
	        </li>
	        <li class="ui-state-default ui-corner-top">
	            <a href="javascript:void(0);" onclick="doListComment();"><spring:message code="글:CDMS:작업히스토리" /></a>
	        </li>
	    </ul>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width:10%;" />
		<col style="width:10%;" />
		<col style="width:auto%;" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:프로젝트명"/></th>
			<td colspan="2"><c:out value="${detailProject.project.projectName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:수행년도"/></th>
			<td colspan="2"><c:out value="${detailProject.project.year}"/>&nbsp;<spring:message code="글:년"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발구분"/></th>
			<td colspan="2"><aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${detailProject.project.projectTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발기간"/></th>
			<td colspan="2"><aof:date datetime="${detailProject.project.startDate}"/> ~ <aof:date datetime="${detailProject.project.endDate}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:차시수"/></th>
			<td colspan="2"><c:out value="${detailProject.project.moduleCount}"/><span style="margin:0 5px;"><spring:message code="글:CDMS:차시"/></span></td>
		</tr>
	<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
		<tr>
			<th><c:out value="${row.codeName}"/></th>
			<td colspan="2">
			<c:forEach var="rowSub" items="${listProjectCompany}" varStatus="iSub">
				<c:if test="${row.code eq rowSub.projectCompany.companyTypeCd}">
					<c:out value="${rowSub.company.companyName}"/>
				</c:if>
			</c:forEach>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty cdmsCompanyType }">
		<tr>
			<th><spring:message code="필드:CDMS:발주사"/></th>
			<td colspan="2">
			-
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발사"/></th>
			<td colspan="2">
			-
			</td>
		</tr>
	</c:if>
	<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
		<tr>
			<c:if test="${i.index == 0 }">
			<th rowspan="<c:out value="${fn:length(cdmsMemberType) }" />"><spring:message code="필드:CDMS:참여인력"/></th>
			</c:if>
			<td>
				<c:out value="${row.codeName}"/><spring:message code="글:CDMS:그룹"/>
			</td>
			<td>
				<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
					<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
						<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
						<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
							<c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)
						</c:if>
					</c:if>
				</c:forEach>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty cdmsMemberType }">
		<tr>
			<th rowspan="<c:out value="${fn:length(cdmsMemberType) }" />"><spring:message code="필드:CDMS:참여인력"/></th>
			<td>
				-
			</td>
		</tr>
	</c:if>
	</tbody>
	</table>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
</body>
</html>