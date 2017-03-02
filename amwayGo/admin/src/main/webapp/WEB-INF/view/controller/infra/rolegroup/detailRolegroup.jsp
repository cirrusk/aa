<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ROLE_USR" value="${aoffn:code('CD.ROLE.USR')}"/>

<c:set var="fixedRolegroupSeq" value="${aoffn:config('member.fixedRolegroupSeq')}"/>
<c:set var="rolegroupSeq"><c:out value="${detail.rolegroup.rolegroupSeq}"/></c:set><%-- toString --%>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata      = null;
var forEdit          = null;
var forSub           = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	//학습자그룹에서 하위메뉴가 생성되었을때는 멤버와 메뉴 설정을 별도로 표시 하지 않는다.
	<c:if test="${detail.rolegroup.cfString ne 'user'}">
		doSub({'srchParentSeq' : '<c:out value="${detail.rolegroup.parentSeq}"/>'
			,'srchRolegroupSeq' : '<c:out value="${detail.rolegroup.rolegroupSeq}"/>'
			,'srchCfString' : '<c:out value="${detail.rolegroup.cfString}"/>'});
		
		UI.tabs("#tabs");
	</c:if>

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/rolegroup/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/rolegroup/edit.do"/>";
	
	forSub = $.action("ajax");
	forSub.config.formId      = "FormSub";
	forSub.config.type        = "html";
	forSub.config.containerId = "tabContainer";
	forSub.config.fn.complete = function() {};
	
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
 * 
 */
doSub = function(mapPKs, tab) {
	UT.copyValueMapToForm(mapPKs, forSub.config.formId);
	
	switch (tab) {
	case 1:
		forSub.config.url = "<c:url value="/rolegroup/member/list/ajax.do"/>";
		break;
	case 2:
		forSub.config.url = "<c:url value="/rolegroup/menu/list/ajax.do"/>";
		break;
	default:
		forSub.config.url = "<c:url value="/rolegroup/member/list/ajax.do"/>";
		break;
	}
	forSub.run();
};
/**
 * 롤그룹메뉴 새로고침
 */
doRolegroupMenuRefresh = function() {
	UI.tabs("#tabs").tabs("select", 1);
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchRolegroup.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<c:out value="${detail.rolegroup.updMemberName}"/>
		&nbsp;
		<strong><spring:message code="필드:수정일시"/></strong>
		<aof:date datetime="${detail.rolegroup.updDtime}" pattern="${aoffn:config('format.datetime')}"/>
	</div>
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:권한그룹:권한그룹명"/></th>
			<td><c:out value="${detail.rolegroup.rolegroupName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:권한그룹:상위권한그룹"/></th>
			<td>
				<c:choose>
					<c:when test="${empty detail.rolegroup.parentRolegroupName}">
						-
					</c:when>
					<c:otherwise>
						<c:out value="${detail.rolegroup.parentRolegroupName}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:if test="${!empty detail.rolegroup.accessFtpDir}">
			<tr>
				<th><spring:message code="필드:권한그룹:FTP디렉토리"/></td>
				<td>
					<c:set var="accessFtpDirs" value="${aoffn:toList(detail.rolegroup.accessFtpDir, ',')}"/>
					<c:forEach var="row" items="${accessFtpDirs}">
						<c:out value="${row}"/><br>
					</c:forEach>
				</td>
			</tr>
		</c:if>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${(fixedRolegroupSeq < detail.rolegroup.rolegroupSeq) and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'rolegroupSeq' : '<c:out value="${detail.rolegroup.rolegroupSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

	<div class="clear"></div>

	<!-- 학습자그룹일시 멤버와 메뉴 설정을 별도로 표시 하지 않는다. -->
	<c:if test="${detail.rolegroup.roleCd ne CD_ROLE_USR}">
		
		<div id="tabs"> 
			<ul class="ui-widget-header-tab-custom">
				<li><a href="#tabContainer" 
					onclick="doSub({
						'srchParentSeq' : '<c:out value="${detail.rolegroup.parentSeq}"/>',
						'srchRolegroupSeq' : '<c:out value="${detail.rolegroup.rolegroupSeq}"/>',
						'srchCfString' : '<c:out value="${detail.rolegroup.cfString}"/>'
					}, 1);"><spring:message code="필드:권한그룹:구성원"/></a>
				</li>
<%-- 				<li><a href="#tabContainer" 
					onclick="doSub({
						'srchParentSeq' : '<c:out value="${detail.rolegroup.parentSeq}"/>',
						'srchGroupOrder' : '<c:out value="${detail.rolegroup.groupOrder}"/>',
						'srchRolegroupSeq' : '<c:out value="${detail.rolegroup.rolegroupSeq}"/>'
					}, 2);"><spring:message code="필드:권한그룹:메뉴"/></a>
				</li> --%>
			</ul>
			<div id="tabContainer"></div>
		</div>
	</c:if>
</body>
</html>