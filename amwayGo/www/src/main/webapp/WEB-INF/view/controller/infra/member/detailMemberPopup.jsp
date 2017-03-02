<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="memberType" />
<c:choose>
	<c:when test="${empty detail.admin.memberSeq }">
		<c:set var="memberType" value="user" />
	</c:when>
	<c:when test="${!empty detail.admin.profTypeCd }">
		<c:set var="memberType" value="prof" />
	</c:when>
	<c:when test="${!empty detail.admin.cdmsTaskTypeCd }">
		<c:set var="memberType" value="cdms" />
	</c:when>
	<c:otherwise>
		<c:set var="memberType" value="admin" />
	</c:otherwise>
</c:choose>

<html>
<head>
<title></title>
<script type="text/javascript">
var forDetail     = null;
var forListCourseActive   = null;
var forListCourseApply    = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] tab
	UI.tabs("#tabs").show();
	
	doDetail();
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.target = "frame-member";
	forDetail.config.url    = "<c:url value="/member/${memberType}/detail/iframe.do"/>";
	
	forListCourseActive = $.action();
	forListCourseActive.config.formId = "FormCourseData";
	forListCourseActive.config.url = "<c:url value="/member/detail/course/active/list/iframe.do"/>";
	forListCourseActive.config.target = "frame-active";
	
	forListCourseApply = $.action();
	forListCourseApply.config.formId = "FormCourseData";
	forListCourseApply.config.target = "frame-apply";
	forListCourseApply.config.url    = "<c:url value="/member/detail/course/apply/list/iframe.do"/>";
	
	
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function() {
	forDetail.run();
};

/**
 * 운영과목정보 목록
 */
doCourseActiveList = function(){
	forListCourseActive.run();
};

/**
 * 수강이력 목록
 */
doProfHistoryList = function(){
	forListCourseApply.run();
};

/**
 * 컨텐츠개발 목록
 */
doCdmsHistoryList = function(){
	
};
</script>
</head>
<body>
<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="memberSeq" value="${detail.member.memberSeq }" />
</form>

<form name="FormCourseData" id="FormCourseData" method="post" onsubmit="return false;">
	<input type="hidden" name="srchMemberSeq" value="<c:out value="${detail.member.memberSeq}"/>" />
	<input type="hidden" name="srchMemberId" value="<c:out value="${detail.member.memberId}"/>" />
</form>

<div id="tabs" style="display:none;">
	<ul class="ui-widget-header-tab-custom">
		<li><a href="#tabContainer1" onclick="doDetail()"><spring:message code="필드:멤버:기본정보"/></a></li>
	</ul>
	<div id="tabContainer1" style="padding:0;">
		<iframe id="frame-member" name="frame-member" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
	</div>
</div>	
</body>
</html>