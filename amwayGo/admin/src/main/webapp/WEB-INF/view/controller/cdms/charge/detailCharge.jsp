<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE"         value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE')}"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP"  value="${CD_CDMS_PROJECT_MEMBER_TYPE}::"/>
<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_PM"      value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.PM')}"/>

<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType" except="${CD_CDMS_PROJECT_MEMBER_TYPE_PM}"/>

<html decorator="popup">
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

};
</script>
</head>

<body>

	<c:set var="sizeCdmsMemberType" value="${fn:length(cdmsMemberType)}"/>
	<c:set var="widthColumn" value="140"/> <%-- 공정자/검수자 컬럼 가로 크기 --%>
	<c:set var="moduleCount" value="${detailProject.project.moduleCount}"/>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width:auto;"/>
		<col style="width:200px;"/>
		<c:forEach var="row" begin="1" end="${sizeCdmsMemberType}" varStatus="i">
			<col style="width:<c:out value="${widthColumn}"/>px;"/>
		</c:forEach>
	</colgroup>
	<thead>
	<tr>
		<th class="align-c"><spring:message code="필드:CDMS:개발단계"/></th>
		<th class="align-c"><spring:message code="필드:CDMS:산출물"/></th>
		<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
			<th class="align-c"><c:out value="${row.codeName}"/></th>
		</c:forEach>
	</tr>
	</thead>
	<c:if test="${empty listSection}">
		<tbody>
		<tr>
			<td class="align-c" colspan="${sizeCdmsMemberType + 2}"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
		</tbody>
	</c:if>
	</table>
	
	<table class="tbl-detail" style="border-top:none;">
	<colgroup>
		<col style="width:auto;"/>
		<col style="width:${sizeCdmsMemberType * widthColumn + 200}px;"/>
	</colgroup>
	<tbody>
	<c:forEach var="row" items="${listSection}" varStatus="i">
		<tr>
			<th>
				<c:choose>
					<c:when test="${!empty row.section.sectionName}"><c:out value="${row.section.sectionName}"/></c:when>
					<c:otherwise>-</c:otherwise>
				</c:choose>
			</th>
			<td style="padding:0;">
				<c:forEach var="rowSub" items="${listOutput}" varStatus="iSub">
					<c:if test="${row.section.sectionIndex eq rowSub.output.sectionIndex}">
						<table>
						<colgroup>
							<col style="width:200px;"/>
							<c:forEach var="row" begin="1" end="${sizeCdmsMemberType}" varStatus="i">
								<col style="width:<c:out value="${widthColumn}"/>px;"/>
							</c:forEach>
						</colgroup>
						<tbody>
							<tr class="columns cdms-module-0 cdms-module-${rowSub.output.moduleYn}">
								<td class="align-l" style="border:none;">
									<c:choose>
										<c:when test="${!empty rowSub.output.outputCd}"><c:out value="${rowSub.output.outputName}"/></c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</td>
								<c:forEach var="rowSubSub" items="${cdmsMemberType}" varStatus="iSubSub">
									<td class="align-c column-code cdms-<c:out value="${fn:substringAfter(rowSubSub.code, CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP)}"/>" style="border:none;">
										<c:set var="matchedCharge" value=""/> 
										<c:forEach var="rowSubSubSub" items="${listCharge}" varStatus="iSubSubSub">
											<c:if test="${rowSub.output.sectionIndex eq rowSubSubSub.charge.sectionIndex 
											and rowSub.output.outputIndex eq rowSubSubSub.charge.outputIndex
											and 0 eq rowSubSubSub.charge.moduleIndex
											and rowSubSub.code eq rowSubSubSub.charge.memberCdmsTypeCd}">
												<c:set var="matchedCharge" value="${rowSubSubSub}"/>
											</c:if>
										</c:forEach>
										<c:choose>
											<c:when test="${!empty matchedCharge}">
												<div class="input-text"><c:out value="${matchedCharge.member.memberName}"/>&nbsp;(<c:out value="${matchedCharge.member.memberId}"/>)</div>
											</c:when>
											<c:otherwise>
												<div class="input-text">-</div>
											</c:otherwise>
										</c:choose>
									</td>
								</c:forEach>
							</tr>
								
							<c:if test="${rowSub.output.moduleYn eq 'Y'}">
								<c:forEach var="rowModule" begin="1" end="${moduleCount}" step="1" varStatus="iModule">
									<tr class="columns cdms-module-<c:out value="${rowModule}"/>">
										<td class="align-l" style="border:none; padding-left:30px;">
											<c:out value="${rowModule}"/><spring:message code="필드:CDMS:차시"/>
										</td>
										<c:forEach var="rowSubSub" items="${cdmsMemberType}" varStatus="iSubSub">
											<td class="align-c column-code cdms-<c:out value="${fn:substringAfter(rowSubSub.code, CD_CDMS_PROJECT_MEMBER_TYPE_ADDSEP)}"/>" style="border:none;">
												<c:set var="matchedModuleCharge" value=""/> 
												<c:forEach var="rowSubSubSub" items="${listCharge}" varStatus="iSubSubSub">
													<c:if test="${rowSub.output.sectionIndex eq rowSubSubSub.charge.sectionIndex 
													and rowSub.output.outputIndex eq rowSubSubSub.charge.outputIndex
													and rowModule eq rowSubSubSub.charge.moduleIndex
													and rowSubSub.code eq rowSubSubSub.charge.memberCdmsTypeCd}">
														<c:set var="matchedModuleCharge" value="${rowSubSubSub}"/>
													</c:if>
												</c:forEach>
												<c:choose>
													<c:when test="${!empty matchedModuleCharge}">
														<div class="input-text"><c:out value="${matchedModuleCharge.member.memberName}"/>&nbsp;(<c:out value="${matchedModuleCharge.member.memberId}"/>)</div>
													</c:when>
													<c:otherwise>
														<div class="input-text">-</div>
													</c:otherwise>
												</c:choose>
											</td>
										</c:forEach>
									</tr>
								</c:forEach>
							</c:if>
						</tbody>
						</table>
					</c:if>
				</c:forEach>
			</td>
		</tr>
	</c:forEach>
	</tbody>
	</table>

	<div class="mt20"></div>
</body>
</html>