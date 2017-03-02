<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:set var="menuProject" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/cdms/project/list.do'}"> <%-- 개발대상 메뉴를 찾는다 --%>
		<c:set var="menuProject" value="${row.menu}" scope="request"/>
	</c:if>
</c:forEach>

<html decorator="ajax">
<body>

<c:choose>
	<c:when test="${param['viewType'] eq 'list'}">
		<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width:50px" />
			<col style="width:80px;" />
			<col style="width:auto" />
			<col style="width:auto" />
			<col style="width:70px;" />
			<col style="width:auto" />
			<col style="width:80px;" />
			<col style="width:80px;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><spring:message code="필드:CDMS:작업내용" /></th>
				<th><spring:message code="필드:CDMS:개발단계" /></th>
				<th><spring:message code="필드:CDMS:산출물" /></th>
				<th><spring:message code="필드:CDMS:차시" /></th>
				<th><spring:message code="필드:CDMS:참여자" /></th>
				<th><spring:message code="필드:CDMS:처리일자" /></th>
				<th><spring:message code="필드:CDMS:마감일정" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
		        <td class="cdms-section-color-<c:out value="${row.section.sectionIndex}"/>"><c:out value="${paginate.descIndex - i.index}"/></td>
				<td><aof:code type="print" codeGroup="CDMS_OUTPUT_STATUS" selected="${row.comment.outputStatusCd}"/></td>
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
				<td><c:out value="${row.member.memberName}"/>(<c:out value="${row.member.memberId}"/>)</td>
				<td><aof:date datetime="${row.comment.regDtime}"/></td>
				<td>
					<c:set var="dateFormat"><c:out value="${aoffn:config('format.date')}"/></c:set>
					<c:set var="endDate"><aof:date datetime="${row.output.endDate}" pattern="${dateFormat}"/></c:set>
					<c:set var="regDate"><aof:date datetime="${row.comment.regDtime}" pattern="${dateFormat}"/></c:set>
					<c:set var="diffDate" value="${aoffn:diffDate(endDate, regDate, dateFormat)}"/>
					<c:choose>
						<c:when test="${diffDate le 0}">
							<spring:message code="글:CDMS:준수" />
						</c:when>
						<c:otherwise>
							 <spring:message code="글:CDMS:미준수" />(<c:out value="${diffDate}"/>)
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
		</tbody>
		</table>
		
		<c:import url="/WEB-INF/view/include/paging.jsp">
			<c:param name="paginate" value="paginate"/>
			<c:param name="func" value="doPageComment"/>
		</c:import>
	</c:when>
	<c:when test="${param['viewType'] eq 'calendar'}">
		<table class="tbl-detail">
		<colgroup>
			<col style="width:50px" />
			<col style="width:auto" />
			<col style="width:auto" />
			<col style="width:100px;" />
			<col style="width:150px;" />
			<col style="width:70px;" />
		</colgroup>
		<thead>
			<tr>
				<th class="align-c"><spring:message code="필드:CDMS:일자" /></th>
				<th class="align-c"><spring:message code="필드:CDMS:등록일정" /></th>
				<th class="align-c"><spring:message code="필드:CDMS:산출물" /></th>
				<th class="align-c"><spring:message code="필드:CDMS:작업내용" /></th>
				<th class="align-c"><spring:message code="필드:CDMS:참여자" /></th>
				<th class="align-c"><spring:message code="필드:CDMS:차시" /></th>
			</tr>
		</thead>
		<tbody>
			<c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdatetimeStart')}"/></c:set>
			<c:set var="prevMonth" value="0"/>
			<c:set var="startedSection"/>
			<c:forEach var="row" items="${listDate}" varStatus="i">
				<c:set var="date"><aof:date datetime="${row}" pattern="${aoffn:config('format.dbdatetimeStart')}"/></c:set>
				<c:set var="month"><aof:date datetime="${row}" pattern="M"/></c:set>
				<c:set var="dataStartSection" value="${mapStartSection[date]}"/>
				<c:set var="dataStartOutput" value="${mapStartOutput[date]}"/>
				<c:set var="dataEndOutput" value="${mapEndOutput[date]}"/>
				<c:set var="dataEndSection" value="${mapEndSection[date]}"/>
				<c:set var="styleClass" value=""/>
				<c:set var="dataProcess" value="${mapProcess[date]}"/>

				<c:if test="${appToday eq date}">
					<c:set var="styleClass" value="${styleClass} cdms-today"/>
				</c:if>
				<c:if test="${!empty dataStartSection}">
					<c:set var="startedSection" value="${dataStartSection}"/>
				</c:if>
				<c:if test="${!empty startedSection}">
					<c:set var="styleClass"><c:out value="${styleClass}"/> cdms-section-color-<c:out value="${startedSection.section.sectionIndex}"/></c:set>
				</c:if>
				
				<c:if test="${month ne prevMonth}">
					<tr>
						<th class="align-c" colspan="6"><c:out value="${month}"/><spring:message code="글:월"/></th>
					</tr>
				</c:if>

				<c:set var="rowSpan" value=""/>
				<c:if test="${!empty dataProcess}">
					<c:set var="rowSpan" value="rowspan=${fn:length(dataProcess)}"/>
				</c:if>

				<tr>
					<th class="align-c <c:out value="${styleClass}"/>" <c:out value="${rowSpan}"/>><aof:date datetime="${row}" pattern="d"/></th>
					<td <c:out value="${rowSpan}"/> style="padding:3px 3px 3px 10px;">
						<c:if test="${!empty dataStartSection}">
							<div style="font-weight:bold;"><c:out value="${dataStartSection.section.sectionName }"/><spring:message code="글:CDMS:시작일"/></div>
						</c:if>
						<c:if test="${!empty dataStartOutput}">
							<div style="padding-left:20px;">- <c:out value="${dataStartOutput.output.outputName }"/><spring:message code="글:CDMS:시작일"/></div>
						</c:if>
						<c:if test="${!empty dataEndOutput}">
							<div style="padding-left:20px;">- <c:out value="${dataEndOutput.output.outputName }"/><spring:message code="글:CDMS:종료일"/></div>
						</c:if>
						<c:if test="${!empty dataEndSection}">
							<div style="font-weight:bold;"><c:out value="${dataEndSection.section.sectionName }"/><spring:message code="글:CDMS:종료일"/></div>
						</c:if>
					</td>
					
					<c:choose>
						<c:when test="${!empty dataProcess}">
							<c:forEach var="rowSub" items="${dataProcess}" varStatus="iSub">
								<td>
									<c:choose>
										<c:when test="${!empty menuProject}">
											<a href="javascript:void(0)" onclick="doDetailSection({
						   						'projectSeq' : '${rowSub.comment.projectSeq}',
						   						'sectionIndex' : '${rowSub.comment.sectionIndex}',
						   						'outputIndex' : '${rowSub.comment.outputIndex}'
						   						})"><c:out value="${rowSub.output.outputName}"/></a>
					   					</c:when>
					   					<c:otherwise>
											<c:out value="${rowSub.output.outputName}"/>
					   					</c:otherwise>
									</c:choose>
								</td>
								<td class="align-c"><aof:code type="print" codeGroup="CDMS_OUTPUT_STATUS" selected="${rowSub.comment.outputStatusCd}"/></td>
								<td><c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)</td>										
								<td class="align-c">
									<c:choose>
										<c:when test="${!empty rowSub.comment.moduleIndex}">
											<c:out value="${rowSub.comment.moduleIndex}"/><spring:message code="필드:CDMS:차시"/>
										</c:when>
										<c:otherwise>
											-
										</c:otherwise>
									</c:choose>
								</td>										
								<c:if test="${iSub.last eq false}">
									</tr>
									<tr>
								</c:if>
							</c:forEach>

						</c:when>
						<c:otherwise>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</c:otherwise>
					</c:choose>
				</tr>
				<c:set var="prevMonth"><aof:date datetime="${row}" pattern="M"/></c:set>
			</c:forEach>
		</tbody>
		</table>
		
	</c:when>
</c:choose>
	
</body>
</html>