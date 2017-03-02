<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<aof:code type="set" codeGroup="CDMS_PROJECT_MEMBER_TYPE" var="cdmsMemberType"/>
<aof:code type="set" codeGroup="CDMS_OUTPUT_STATUS" var="cdmsStatus"/>
<c:set var="menuProject" scope="request"/>
<c:forEach var="row" items="${appMenuList}">
	<c:if test="${row.menu.url eq '/cdms/project/list.do'}"> <%-- 개발대상 메뉴를 찾는다 --%>
		<c:set var="menuProject" value="${row.menu}" scope="request"/>
	</c:if>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forListComment = null;
var forDetailSection = null;
var cdmsStatus = {};
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	doListComment();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/cdms/project/process/list.do"/>";

	forListComment = $.action("ajax");
	forListComment.config.formId = "FormSrchComment";
	forListComment.config.url    = "<c:url value="/cdms/comment/process/list.do"/>";
	forListComment.config.type   = "html";
	forListComment.config.containerId = "containerComment"; 
	forListComment.config.fn.complete = function(action, data) {};
	
	forDetailSection = $.action();
	forDetailSection.config.formId = "FormDetailSection2";
	forDetailSection.config.url    = "<c:url value="/cdms/project/section/detail.do"/>";
	
	<c:forEach var="row" items="${cdmsStatus}" varStatus="i">
	cdmsStatus["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
	</c:forEach>
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 댓글 목록 가져오기
 */
doListComment = function() {
	forListComment.run();
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPageComment = function(pageno) {
	var form = UT.getById(forListComment.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doListComment();
};
/**
 * 보기 형식 변경
 */
doChangeViewType = function(element) {
	var form = UT.getById(forListComment.config.formId);
	var prevViewType = form.elements["viewType"].value;
	if (prevViewType != element.value) {
		form.elements["viewType"].value = element.value;
		doListComment();
	}
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
</script>
<style type="text/css">
.cdms-section-color-1  {background-color:#7a7a7a !important; color:#ffffff !important;}
.cdms-section-color-2  {background-color:#ffa004 !important; color:#ffffff !important;}
.cdms-section-color-3  {background-color:#70ad08 !important; color:#ffffff !important;}
.cdms-section-color-4  {background-color:#12a5bd !important; color:#ffffff !important;}
.cdms-section-color-5  {background-color:#3147cb !important; color:#ffffff !important;}
.cdms-section-color-6  {background-color:#8841d7 !important; color:#ffffff !important;}
.cdms-section-color-7  {background-color:#db4daa !important; color:#ffffff !important;}
.cdms-section-color-8  {background-color:#e5100d !important; color:#ffffff !important;}
.cdms-section-color-9  {background-color:#3186de !important; color:#ffffff !important;}
.cdms-section-color-10 {background-color:#f15d17 !important; color:#ffffff !important;}
.section-point {display:inline-block; *display:inline; *zoom:1; width:13px; height:13px; margin-left:5px; vertical-align:middle; border-radius:7px; -moz-border-radius:7px; -webkit-border-radius:7px; }
</style>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchProject.jsp"/>
		<form name="FormSrchComment" id="FormSrchComment" method="post" onsubmit="return false;">
			<input type="hidden" name="currentPage"   value="1" />
			<input type="hidden" name="perPage"       value="10" />
			<input type="hidden" name="srchProjectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/>
			<input type="hidden" name="viewType" value="list" />
		</form>
		<form name="FormDetailSection2" id="FormDetailSection2" method="post" onsubmit="return false;">
			<input type="hidden" name="projectSeq" />
			<input type="hidden" name="sectionIndex" />
			<input type="hidden" name="outputIndex" />
			<input type="hidden" name="currentMenuId"  value="<c:out value="${aoffn:encrypt(menuProject.menuId)}"/>"/>
		</form>
	</div>

	<div class="lybox-tbl">
		<h4 class="title"><c:out value="${detailProject.project.projectName}"/></h4>
		<div class="right">
			<form name="FormSrchCommentTemp" id="FormSrchCommentTemp" method="post" onsubmit="return false;">
				<input type="radio" name="viewType" value="list" checked="checked" onclick="doChangeViewType(this)" class="input-radio"> <label><spring:message code="글:CDMS:목록보기" /></label>
				<input type="radio" name="viewType" value="calendar" onclick="doChangeViewType(this)" class="input-radio"> <label><spring:message code="글:CDMS:캘린더보기" /></label>
			</form>
		</div>
	</div>

	<table class="tbl-detail mt10">
	<colgroup>
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:auto" />
		<col style="width:auto" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:현진행단계" /></th>
			<td class="align-c">
				<c:choose>
					<c:when test="${!empty currentSection}">
						<c:out value="${currentSection.section.sectionName}"/>
					</c:when>
					<c:otherwise>
						-
					</c:otherwise>
				</c:choose>
			</td>
			<th><spring:message code="필드:CDMS:최종작업" /></th>
			<td class="align-c">
				<c:choose>
					<c:when test="${!empty lastProcess}">
						<span style="margin-right:3px;"><c:out value="${lastProcess.output.outputName}"/></span> 
						<c:if test="${!empty lastProcess.comment.moduleIndex}">
							<span style="margin-right:3px;"><c:out value="${lastProcess.comment.moduleIndex}"/><spring:message code="필드:CDMS:차시"/></span>
						</c:if>
						<span><aof:code type="print" codeGroup="CDMS_OUTPUT_STATUS" selected="${lastProcess.comment.outputStatusCd}"/></span>
					</c:when>
					<c:otherwise>
						-
					</c:otherwise>
				</c:choose>
			</td>
			<th><spring:message code="필드:CDMS:공정등록" /><spring:message code="필드:CDMS:산출물" /></th>
			<td class="align-c">
				<c:out value="${countCompletedOutput}"/> / <c:out value="${countTotalOutput}"/>
			</td>
			<th><spring:message code="필드:CDMS:전체진척률" /></th>
			<td class="align-c">
				<c:set var="averageProgressRate" value="${aoffn:trimDouble(countCompletedOutput / countTotalOutput * 100)}"/>
				<c:choose>
					<c:when test="${empty averageProgressRate}">
						<c:set var="averageProgressRate" value="0"/>
					</c:when>
					<c:otherwise>
						<c:set var="averageProgressRate"><aof:number value="${averageProgressRate}" pattern="##.##"/></c:set>
					</c:otherwise>
				</c:choose>
				<c:out value="${averageProgressRate}"/> %
			</td>
		</tr>
	</tbody>
	</table>
		
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:forEach var="row" items="${listSection}" varStatus="i">
				<span class="section-point cdms-section-color-<c:out value="${row.section.sectionIndex}"/>">&nbsp;</span>
				<span><c:out value="${row.section.sectionName}"/></span>
			</c:forEach>
		</div>
	</div>

	<div id="containerComment"></div>

</body>
</html>