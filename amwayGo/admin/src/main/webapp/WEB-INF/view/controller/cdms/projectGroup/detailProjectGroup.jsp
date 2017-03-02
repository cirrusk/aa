<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<aof:code type="set" codeGroup="CDMS_PROJECT_GROUP_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_GROUP_MEMBER_TYPE" var="cdmsMemberType"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
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
	forListdata.config.url    = "<c:url value="/cdms/project/group/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/cdms/project/group/edit.do"/>";
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProjectGroup.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.projectGroup.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.projectGroup.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width:100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:개발그룹명"/></th>
			<td><c:out value="${detail.projectGroup.groupName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:참여업체"/></th>
			<td>
				<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
					<div class="clear strong"><c:out value="${row.codeName}"/> : </div>
					<ul class="list-bullet">
						<c:forEach var="rowSub" items="${detail.listCompany}" varStatus="iSub">
							<c:if test="${row.code eq rowSub.projectCompany.companyTypeCd}">
								<li><c:out value="${rowSub.company.companyName}"/></li>
							</c:if>
						</c:forEach>
					</ul>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:참여인력"/></th>
			<td>
				<c:forEach var="row" items="${cdmsMemberType}" varStatus="i">
					<div class="clear strong"><c:out value="${row.codeName}"/> : </div>
					<ul class="list-bullet">
						<c:forEach var="rowSub" items="${detail.listMember}" varStatus="iSub">
							<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
							<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
								<c:if test="${!empty rowSub.member.photo}">
									<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${rowSub.member.photo}.thumb.jpg"/>
								</c:if>
								<li>
									<div class="photo photo-40">
										<img src="${memberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
									</div>
									<span><c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)</span>
								</li>
							</c:if>
						</c:forEach>
					</ul>
				</c:forEach>
			</td>
		</tr>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'projectGroupSeq' : '<c:out value="${detail.projectGroup.projectGroupSeq}"/>'});" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>		


	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="글:CDMS:단위개발정보"/></h4>
	</div>

	<table class="tbl-list">
	<colgroup>
		<col style="width: 50px" />
		<col style="width: 80px" />
		<col style="width: auto" />
		<col style="width: 150px" />
		<col style="width: 60px" />
		<col style="width: 60px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><spring:message code="필드:CDMS:개발구분" /></th>
			<th><spring:message code="필드:CDMS:과정명" /></th>
			<th><spring:message code="필드:CDMS:개발기간" /></th>
			<th><spring:message code="필드:CDMS:차시수" /></th>
			<th><spring:message code="필드:CDMS:상태" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${listProject}" varStatus="i">
		<tr>
	        <td><c:out value="${i.count}"/></td>
			<td><aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${row.project.projectTypeCd}"/></td>
			<td class="align-l">
				<div class="strong"><c:out value="${row.project.projectName}" /></div>
				
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
				
					<div>
						<span class="comment"><spring:message code="필드:CDMS:프로젝트단계" /> : </span>
						<span style="margin-right:10px;"><c:out value="${!empty currentSection and !empty currentSection.sectionName ? currentSection.sectionName : '-'}"/></span>
						<span class="comment"><spring:message code="필드:CDMS:공정단계" /> : </span>
						<span><c:out value="${!empty currentOutput and !empty currentOutput.outputName ? currentOutput.outputName : '-'}"/></span>
					</div>
				</c:if>
			</td>
			<td><aof:date datetime="${row.project.startDate}"/>~<aof:date datetime="${row.project.endDate}"/></td>
			<td><c:out value="${row.project.moduleCount}" /></td>
			<td>
				<c:choose>
					<c:when test="${row.project.completeYn eq 'Y'}"><spring:message code="글:CDMS:종료" /></c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${appToday ge row.project.startDate}">
								<spring:message code="글:CDMS:진행중" />
							</c:when>
							<c:otherwise>
								<spring:message code="글:CDMS:대기" />
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</c:forEach>	
	<c:if test="${empty listProject}">
		<tr>
			<td colspan="6" class="align-c"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
		
</body>
</html>