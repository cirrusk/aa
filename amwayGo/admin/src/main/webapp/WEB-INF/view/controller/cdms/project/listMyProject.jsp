<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<aof:code type="set" codeGroup="CDMS_PROJECT_COMPANY_TYPE" var="cdmsCompanyType"/>
<c:set var="menuProject" scope="request"/>
<c:set var="menuNotice" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/cdms/project/list.do'}"> <%-- 개발대상정보 메뉴를 찾는다 --%>
		<c:set var="menuProject" value="${row.menu}" scope="request"/>
	</c:if>
	<c:if test="${row.menu.url eq '/cdms/board/notice/list.do'}"> <%-- 공지사항 메뉴를 찾는다 --%>
		<c:set var="menuNotice" value="${row.menu}" scope="request"/>
	</c:if>
</c:forEach>

<html decorator="ajax">
<body>

	<form name="FormListProject" id="FormListProject" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	</form>

	<c:forEach var="row" items="${paginageMyProject.itemList}" varStatus="i">

		<div class="lybox-tbl">
			<h4 class="title"><c:out value="${row.project.projectName}" /></h4>
			<c:if test="${!empty menuProject}">
				<div class="right">
					<a href="javascript:void(0)" onclick="doDetailProject({'projectSeq' : '${row.project.projectSeq}'});" class="btn black"><span class="small"><spring:message code="버튼:상세보기" /></span></a>
				</div>
			</c:if>
		</div>

		<table class="tbl-detail">
		<colgroup>
			<col style="width:100px;" />
			<col style="width:auto;" />
		</colgroup>
		<tr>
			<th><spring:message code="필드:CDMS:개발년도"/></th>
			<td><c:out value="${row.project.year}"/>&nbsp;<spring:message code="글:년"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발구분"/></th>
			<td><aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${row.project.projectTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발기간"/></th>
			<td><aof:date datetime="${row.project.startDate}"/> ~ <aof:date datetime="${row.project.endDate}"/></td>
		</tr>
		<c:forEach var="rowSub" items="${cdmsCompanyType}" varStatus="iSub">
			<tr>
				<th><c:out value="${rowSub.codeName}"/></th>
				<td>
					<c:forEach var="rowSubSub" items="${row.listCompany}" varStatus="iSubSub">
						<c:if test="${rowSub.code eq rowSubSub.projectCompany.companyTypeCd}">
							<span><c:out value="${rowSubSub.company.companyName}"/></span>
						</c:if>
					</c:forEach>
				</td>
			</tr>
		</c:forEach>

		<tr>
			<th><spring:message code="필드:CDMS:진척률"/></th>
			<td>
				<c:set var="averageProgressRate" value="${aoffn:trimDouble(row.project.countCompletedOutput / row.project.countTotalOutput * 100)}"/>
				<c:choose>
					<c:when test="${empty averageProgressRate}">
						<c:set var="averageProgressRate" value="0"/>
					</c:when>
					<c:otherwise>
						<c:set var="averageProgressRate"><aof:number value="${averageProgressRate}" pattern="##.##"/></c:set>
					</c:otherwise>
				</c:choose>
				<span class="rate-total"><div class="rate-bar" style="width:<c:out value="${averageProgressRate}"/>%;"></div></span>
				<span class="strong"><c:out value="${averageProgressRate}"/>%</span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:개발단계"/></th>
			<td style="padding-bottom:5px;">
				<ul class="cdms-section-list">
					<c:forEach var="rowSub" items="${row.listSection}" varStatus="iSub">
						<c:set var="currentSection" value=""/>
						<c:set var="currentOutput" value=""/>
						<c:if test="${appToday ge row.project.startDate}">
							<c:set var="currentSection" value="${row.currentSection}"/>
							<c:set var="currentOutput" value="${row.currentOutput}"/>
							<c:if test="${!empty row.project.currentOutputIndex and !empty row.currentOutput}">
								<c:if test="${row.currentOutput.completeYn eq 'Y' and appToday ge row.currentOutput.endDate}">
									<c:if test="${!empty row.nextSection}">
										<c:set var="currentSection" value="${row.nextSection}"/>
									</c:if>
									<c:if test="${!empty row.nextOutput}">
										<c:set var="currentOutput" value="${row.nextOutput}"/>
									</c:if>
								</c:if>
							</c:if>
						</c:if>
						
						<c:set var="onclickDetailSection" value=""/>
						<c:if test="${!empty menuProject}">
							<c:set var="onclickDetailSection">
								onclick="doDetailSection({
								'projectSeq' : '${!empty currentSection and !empty currentSection.projectSeq ? currentSection.projectSeq : row.project.projectSeq}', 
								'sectionIndex' : '${!empty currentSection and !empty currentSection.sectionIndex ? currentSection.sectionIndex : row.project.currentSectionIndex}'})"
							</c:set>
	   					</c:if>
						<li class="section <c:out value="${!empty currentSection and rowSub.section.sectionIndex eq currentSection.sectionIndex ? 'selected' : ''}"/>" 
							<c:out value="${onclickDetailSection}" escapeXml="false"/>
		   				><c:out value="${rowSub.section.sectionName}"/></li>
					</c:forEach>
				</ul>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:새소식"/></th>
			<td>
				<c:forEach var="rowSub" items="${row.listComment}" varStatus="iSub">
					<div class="text-list">
						<c:choose>
							<c:when test="${!empty menuProject}">
								<a href="javascript:void(0)" onclick="doDetailSection({
			   						'projectSeq' : '${rowSub.comment.projectSeq}',
			   						'sectionIndex' : '${rowSub.comment.sectionIndex}'})"><aof:text type="text" value="${rowSub.comment.description}"/></a>
							</c:when>
							<c:otherwise>
								<aof:text type="text" value="${rowSub.comment.description}"/>
							</c:otherwise>
						</c:choose>
						<div class="right"><aof:date datetime="${rowSub.comment.updDtime}"/></div>
					</div>
				</c:forEach>
			</td>
		</tr>
		</table>
	</c:forEach>
	<c:if test="${empty paginageMyProject.itemList}">
		<table class="tbl-detail">
		<tr>
			<td class="align-c"><spring:message code="글:CDMS:참여된과정개발정보가없습니다" /></td>
		</tr>
		</table>
	</c:if>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginageMyProject"/>
		<c:param name="func" value="doPageProject"/>
	</c:import>

</body>
</html>