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
	<c:if test="${memberType eq 'prof' }">
		<li><a href="#tabContainer2" onclick="doCourseActiveList()"><spring:message code="필드:멤버:운영과목"/></a></li>
	</c:if>
	<c:if test="${memberType ne 'admin' }">
		<li><a href="#tabContainer3" onclick="doProfHistoryList()"><spring:message code="필드:멤버:수강이력"/></a></li>
	</c:if>
	<c:if test="${memberType eq 'cdms' }">
		<li><a href="#tabContainer4" onclick="doCdmsHistoryList();"><spring:message code="필드:멤버:콘텐츠개발"/></a></li>
	</c:if>
	</ul>
	<div id="tabContainer1" style="padding:0;">
		<iframe id="frame-member" name="frame-member" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
	</div>
<c:if test="${memberType eq 'prof' }">
	<div id="tabContainer2" style="padding:0;">
		<iframe id="frame-courseActive" name="frame-active" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
	</div>
</c:if>
<c:if test="${memberType ne 'admin' }">
	<div id="tabContainer3" style="padding:0;">
		<iframe id="frame-courseApply" name="frame-apply" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
	</div>
</c:if>
<c:if test="${memberType eq 'cdms' }">
	<div id="tabContainer4" style="padding:0;">
		<iframe id="frame-cdms" name="frame-cdms" frameborder="no" scrolling="no" style="width:100%;" onload="UT.noscrollIframe(this)"></iframe>
	</div>
</c:if>
</div>	
</body>
</html>