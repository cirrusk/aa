<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forEdit        = null;
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
	forListdata.config.url    = "<c:url value="/univ/course/teamproject/template/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/course/teamproject/template/edit.do"/>";
	
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

	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
	<aof:session key="memberSeq" var="memberSeq"/>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchCourseTeamProjectTemplate.jsp"/>
	</div>
	
	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.teamProjectTemplate.updMemberName}"/></span>
		&nbsp;
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.teamProjectTemplate.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 120px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:교과목:교과목"/></th>
			<td><c:out value="${detail.courseMaster.courseTitle}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:교수명"/></th>
			<td><c:out value="${detail.member.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:팀프로젝트:팀프로젝트제목"/></th>
			<td><c:out value="${detail.teamProjectTemplate.templateTitle}"/></td>
		</tr>
	<c:if test="${!empty detail.teamProjectTemplate.attachList}">
		<tr>
			<th><spring:message code="필드:게시판:첨부파일"/></th>
			<td>
				<c:forEach var="row" items="${detail.teamProjectTemplate.attachList}" varStatus="i">
					<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
					[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
				</c:forEach>
			</td>
		</tr>
	</c:if>
		<tr>
			<th><spring:message code="필드:팀프로젝트:팀프로젝트내용"/></th>
			<td><aof:text type="whiteTag" value="${detail.teamProjectTemplate.templateDescription}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:템플릿:사용여부"/></th>
			<td><aof:code type="print" codeGroup="USEYN" removeCodePrefix="true" selected="${detail.teamProjectTemplate.useYn}"></aof:code></td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">	
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<c:if test="${currentRoleCfString eq 'ADM'}"><!-- 관리자일시 -->
					<a href="#" onclick="doEdit({'templateSeq' : '<c:out value="${detail.teamProjectTemplate.templateSeq}"/>'});"
						class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
				</c:if>
				<c:if test="${currentRoleCfString eq 'PROF'}"><!-- 교강사일시 -->
					<c:if test="${detail.teamProjectTemplate.profMemberSeq eq memberSeq}">
						<a href="#" onclick="doEdit({'templateSeq' : '<c:out value="${detail.teamProjectTemplate.templateSeq}"/>'});"
							class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
					</c:if>
				</c:if>
				<c:if test="${currentRoleCfString eq 'ASSIST' or currentRoleCfString eq 'TUTOR'}"><!-- 선임, 강사일시 -->
					<c:if test="${(delUpYn eq 'Y') or (detail.teamProjectTemplate.regMemberSeq eq memberSeq)}">
						<a href="#" onclick="doEdit({'templateSeq' : '<c:out value="${detail.teamProjectTemplate.templateSeq}"/>'});"
							class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
					</c:if>
				</c:if>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
	
</body>
</html>