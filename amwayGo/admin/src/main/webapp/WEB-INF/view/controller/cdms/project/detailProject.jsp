<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<c:set var="CD_CDMS_PROJECT_MEMBER_TYPE_PM"        value="${aoffn:code('CD.CDMS_PROJECT_MEMBER_TYPE.PM')}"/>
<c:set var="CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM"  value="${aoffn:code('CD.CDMS_PROJECT_GROUP_MEMBER_TYPE.PM')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_COMPANY_TYPE" var="cdmsCompanyType"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType"/>
<aof:code type="set" codeGroup="CDMS_OUTPUT" var="cdmsOutput"/>

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
	forListdata.config.url    = "<c:url value="/cdms/project/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/cdms/project/edit.do"/>";
	
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
/**
 * 담당자조회
 */
doDetailCharge = function() {
	var action = $.action("layer");
	action.config.formId = "FormCharge";
	action.config.url    = "<c:url value="/cdms/charge/detail/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 590;
	action.config.options.title  = "<spring:message code="글:CDMS:담당자상세조회"/>";
	action.run();
};

/**
 * 
 */
doCopy = function() {
	var action = $.action("layer");
	action.config.formId = "FormCopy";
	action.config.url    = "<c:url value="/cdms/project/copy/popup.do"/>";
	action.config.options.width  = 700;
	action.config.options.height = 300;
	action.config.options.title  = "<spring:message code="글:CDMS:개발대상복사"/>";
	action.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProject.jsp"/>
		<form name="FormCharge" id="FormCharge" method="post" onsubmit="return false;">
			<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
		</form>
		<form name="FormCopy" id="FormCopy" method="post" onsubmit="return false;">
			<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
		</form>
	</div>

	<c:set var="pmYn" value="N"/>
	<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
		<c:if test="${ssMemberSeq eq rowSub.member.memberSeq and rowSub.projectMember.memberCdmsTypeCd eq CD_CDMS_PROJECT_MEMBER_TYPE_PM}">
			<c:set var="pmYn" value="Y"/>
		</c:if>	
	</c:forEach>
	<%-- 총괄PM --%>
	<c:forEach var="rowSub" items="${listProjectGroupMember}" varStatus="iSub">
		<c:if test="${ssMemberSeq eq rowSub.member.memberSeq and rowSub.projectMember.memberCdmsTypeCd eq CD_CDMS_PROJECT_GROUP_MEMBER_TYPE_PM}">
			<c:set var="pmYn" value="Y"/>
		</c:if>	
	</c:forEach>

	<div class="lybox-tbl">
		<h4 class="title"><c:out value="${detailProject.project.projectName}"/></h4>
		<div class="right">
			<a href="javascript:void(0)" onclick="doCopy()" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:개발대상복사" /></span></a>
			<a href="javascript:void(0)" onclick="doDetailCharge();" class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:담당자조회"/></span></a>
			
			<%-- pm 이거나 생성자이면 수정가능 --%>
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and (ssMemberSeq eq detailProject.project.regMemberSeq or pmYn eq 'Y')}">
				<a href="#" onclick="doEdit({'projectSeq' : '<c:out value="${detailProject.project.projectSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<table class="tbl-layout">
	<colgroup>
		<col style="width:45%;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody>
		<tr>
			<td class="first">
				<div class="lybox-title mt10">
					<h4 class="section-title"><spring:message code="글:CDMS:기본정보"/></h4>
				</div>

				<table class="tbl-detail">
				<colgroup>
					<col style="width:100px" />
					<col/>
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="필드:CDMS:개발년도"/></th>
						<td><c:out value="${detailProject.project.year}"/>&nbsp;<spring:message code="글:년"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발구분"/></th>
						<td><aof:code type="print" codeGroup="CDMS_PROJECT_TYPE" selected="${detailProject.project.projectTypeCd}"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발기간"/></th>
						<td><aof:date datetime="${detailProject.project.startDate}"/> ~ <aof:date datetime="${detailProject.project.endDate}"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:차시수"/></th>
						<td><c:out value="${detailProject.project.moduleCount}"/><span style="margin:0 5px;"><spring:message code="글:CDMS:차시"/></span></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:참여업체"/></th>
						<td>
							<c:forEach var="row" items="${cdmsCompanyType}" varStatus="i">
								<div class="clear strong"><c:out value="${row.codeName}"/> : </div>
								<ul class="list-bullet">
									<c:forEach var="rowSub" items="${listProjectCompany}" varStatus="iSub">
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
								<c:forEach var="rowSub" items="${listProjectMember}" varStatus="iSub">
									<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
										<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
										<c:if test="${row.code eq rowSub.projectMember.memberCdmsTypeCd}">
											<c:if test="${!empty rowSub.member.photo}">
												<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${rowSub.member.photo}.thumb.jpg"/>
											</c:if>
											<div style="padding:0 0 5px 20px;">
												<div class="photo photo-40">
													<img src="${memberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
												</div>
												<span><c:out value="${rowSub.member.memberName}"/>(<c:out value="${rowSub.member.memberId}"/>)</span>
											</div>
										</c:if>
									</c:if>
								</c:forEach>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:개발그룹"/></th>
						<td><c:out value="${detailProject.projectGroup.groupName}"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:CDMS:종료여부"/></th>
						<td><aof:code type="print" codeGroup="YESNO" selected="${detailProject.project.completeYn}" removeCodePrefix="true"/></td>
					</tr>
				</tbody>
				</table>
				
			</td>
			<td>
				<div class="lybox-title mt10">
					<h4 class="section-title"><spring:message code="글:CDMS:개발단계및산출물정보"/></h4>
				</div>

				<table class="tbl-detail">
				<colgroup>
					<col style="width:auto;"/>
					<col style="width:200px;"/>
					<col style="width:100px;"/>
					<col style="width:50px;"/>
				</colgroup>
				<thead>
				<tr>
					<th class="align-c"><spring:message code="필드:CDMS:개발단계"/></th>
					<th class="align-c"><spring:message code="필드:CDMS:산출물"/></th>
					<th class="align-c"><spring:message code="필드:CDMS:마감일"/></th>
					<th class="align-c"><spring:message code="필드:CDMS:차시"/></th>
				</tr>
				</thead>
				<c:if test="${empty listSection}">
					<tbody>
					<tr>
						<td class="align-c" colspan="4"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
					</tbody>
				</c:if>
				</table>

				<table class="tbl-detail" style="border-top:none;">
				<colgroup>
					<col style="width:auto;"/>
					<col style="width:350px;"/>
				</colgroup>
				<tbody>
				<c:forEach var="row" items="${listSection}" varStatus="i">
					<tr>
						<th><c:out value="${row.section.sectionName}"/></th>
						<td style="padding:0;">
						<c:forEach var="rowSub" items="${listOutput}" varStatus="iSub">
							<c:if test="${row.section.sectionIndex eq rowSub.output.sectionIndex}">
								<table>
								<colgroup>
									<col style="width:200px;"/>
									<col style="width:100px;"/>
									<col style="width:50px;"/>
								</colgroup>
								<tbody>
								<tr>
									<td class="align-c" style="border:none;"><c:out value="${rowSub.output.outputName}"/></td>
									<td class="align-c" style="border:none;"><aof:date datetime="${rowSub.output.endDate}"/></td>
									<td class="align-c" style="border:none;">
										<c:choose>
											<c:when test="${rowSub.output.moduleYn eq 'Y'}">
												<div class="icon-check" style="cursor:default" title="<spring:message code="필드:CDMS:차시"/>"></div>		
											</c:when>
											<c:otherwise>
												-
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								</tbody>
								</table>
							</c:if>
						</c:forEach>
						</td>
					</tr>
				</c:forEach>
				</tbody>
				</table>
			</td>
		</tr>
	</tbody>
	</table>
	
</body>
</html>