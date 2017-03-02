<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ACTIVE_LECTURER_TYPE_PROF"   value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.PROF')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_ASSIST" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.ASSIST')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_TUTOR"  value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.TUTOR')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ACTIVE_LECTURER_TYPE_PROF = "<c:out value="${CD_ACTIVE_LECTURER_TYPE_PROF}"/>";

var forSub           = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	doSub({'srchActiveLecturerTypeCd' : CD_ACTIVE_LECTURER_TYPE_PROF});
	
	UI.tabs("#tabs");
};
	
doInitializeLocal = function() {
	forSub = $.action();
	forSub.config.formId = "FormSub";
	forSub.config.url    = "<c:url value="/univ/course/active/lecturer/list/iframe.do"/>";
	forSub.config.target = "listFrame";
	forSub.config.fn.complete = function() {};
}

doSub = function(mapPKs, tabs){
	UT.copyValueMapToForm(mapPKs, forSub.config.formId);
	forSub.run();
}

/**
 * 접근권한 설정에서 늘어난 사이즈 강제로 줄이기
 */
doParentNoscrollIframe = function(){
	UT.noscrollingIframe('listFrame', 610);
}

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

 	<c:import url="../include/commonCourseActive.jsp"></c:import>
 	
	<c:import url="../courseActiveElement/include/commonCourseActiveElement.jsp">
	    <%-- <c:param name="courseActiveSeq" value="${teamProject.courseActiveSeq}"></c:param> --%>
	    <c:param name="selectedElementTypeCd" value="${CD_ACTIVE_LECTURER_TYPE_PROF}"/>
	</c:import>
	
	<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
		<input type="hidden" name="srchActiveLecturerTypeCd" />
		<input type="hidden" name="srchCourseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
		<input type="hidden" name="shortcutCourseTypeCd" value="${param['shortcutCourseTypeCd']}"/>
	</form>

	<div id="tabs"> 
<%-- 		<ul class="ui-widget-header-tab-custom">
			<li><a href="#listFrame" 
				onclick="doSub({
					'srchActiveLecturerTypeCd' : '<c:out value="${CD_ACTIVE_LECTURER_TYPE_PROF}"/>'
				},0);"><spring:message code="필드:교강사권한관리:과정담당자"/></a>
			</li>
			<li><a href="#listFrame" 
				onclick="doSub({
					'srchActiveLecturerTypeCd' : '<c:out value="${CD_ACTIVE_LECTURER_TYPE_ASSIST}"/>'
				},1);"><spring:message code="필드:교강사권한관리:선임"/></a>
			</li>
			<li><a href="#listFrame" 
				onclick="doSub({
					'srchActiveLecturerTypeCd' : '<c:out value="${CD_ACTIVE_LECTURER_TYPE_TUTOR}"/>'
				},2);"><spring:message code="필드:교강사권한관리:강사"/></a>
			</li>
		</ul> --%>
		<iframe id="listFrame" name="listFrame" frameborder="no" scrolling="no" style="padding:0px; width:100%; height: 600px " onload="UT.noscrollIframe(this)"></iframe>
	</div>
	
</body>
</html>