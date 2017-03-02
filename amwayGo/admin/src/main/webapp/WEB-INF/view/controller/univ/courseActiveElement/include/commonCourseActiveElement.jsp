<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"               value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"             value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_PLAN"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.PLAN')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ORGANIZATION" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ORGANIZATION')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EVALUATE"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EVALUATE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_EXAM"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.EXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_OFFLINE"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.OFFLINE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS"      value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_QUIZ"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.QUIZ')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK"     value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_JOIN"         value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.JOIN')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ONLINE"       value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ONLINE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_SURVEY"       value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.SURVEY')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_TUTOR"  		 value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TUTOR')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_BOARD"  		 value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.BOARD')}"/>

<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COURSE_ELEMENT_TYPE_PLAN = "<c:out value="${CD_COURSE_ELEMENT_TYPE_PLAN}"/>";
var CD_COURSE_ELEMENT_TYPE_ORGANIZATION = "<c:out value="${CD_COURSE_ELEMENT_TYPE_ORGANIZATION}"/>";
var CD_COURSE_ELEMENT_TYPE_EVALUATE = "<c:out value="${CD_COURSE_ELEMENT_TYPE_EVALUATE}"/>";
var CD_COURSE_ELEMENT_TYPE_TEAMPROJECT = "<c:out value="${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}"/>";
var CD_COURSE_ELEMENT_TYPE_OFFLINE = "<c:out value="${CD_COURSE_ELEMENT_TYPE_OFFLINE}"/>";
var CD_COURSE_ELEMENT_TYPE_DISCUSS = "<c:out value="${CD_COURSE_ELEMENT_TYPE_DISCUSS}"/>";
var CD_COURSE_ELEMENT_TYPE_QUIZ = "<c:out value="${CD_COURSE_ELEMENT_TYPE_QUIZ}"/>";
var CD_COURSE_ELEMENT_TYPE_HOMEWORK = "<c:out value="${CD_COURSE_ELEMENT_TYPE_HOMEWORK}"/>";
var CD_COURSE_ELEMENT_TYPE_JOIN = "<c:out value="${CD_COURSE_ELEMENT_TYPE_JOIN}"/>";
var CD_COURSE_ELEMENT_TYPE_ONLINE = "<c:out value="${CD_COURSE_ELEMENT_TYPE_ONLINE}"/>";
var CD_COURSE_ELEMENT_TYPE_SURVEY = "<c:out value="${CD_COURSE_ELEMENT_TYPE_SURVEY}"/>";
var CD_COURSE_ELEMENT_TYPE_EXAM = "<c:out value="${CD_COURSE_ELEMENT_TYPE_EXAM}"/>";
var CD_COURSE_ELEMENT_TYPE_MIDEXAM = "<c:out value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM}"/>";
var CD_COURSE_ELEMENT_TYPE_FINALEXAM = "<c:out value="${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/>";
var CD_COURSE_ELEMENT_TYPE_TUTOR = "<c:out value="${CD_COURSE_ELEMENT_TYPE_TUTOR}"/>";
var CD_COURSE_ELEMENT_TYPE_BOARD = "<c:out value="${CD_COURSE_ELEMENT_TYPE_BOARD}"/>";


doGoTab = function(code) {
	var action = $.action();
	action.config.formId = "FormGoTab";
	switch(code) {
	case CD_COURSE_ELEMENT_TYPE_TEAMPROJECT: // 팀활동
		action.config.url = "<c:url value="/univ/course/active/teamproject/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_SURVEY: // 설문
		action.config.url = "<c:url value="/univ/course/active/survey/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_TUTOR: // 강사구성
		action.config.url = "<c:url value="/univ/course/active/lecturer/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_BOARD: // 게시판 설정
		action.config.url = "<c:url value="/univ/course/board/list.do"/>";
		break;		
	case CD_COURSE_ELEMENT_TYPE_PLAN: // 강의계획서
		action.config.url = "<c:url value="/univ/course/active/plan/detail.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_EVALUATE: // 평가기준
		action.config.url = "<c:url value="/univ/course/active/evaluate/edit.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_ONLINE: // 온라인출석
		action.config.url = "<c:url value="/univ/course/active/online/edit.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_ORGANIZATION: // 주차
		action.config.url = "<c:url value="/univ/course/active/oraganization/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_MIDEXAM: // 중간고사
		action.config.url = "<c:url value="/univ/course/active/middle/exampaper/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_FINALEXAM: // 기말고사
		action.config.url = "<c:url value="/univ/course/active/final/exampaper/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_HOMEWORK: // 과제
		action.config.url = "<c:url value="/univ/course/active/homework/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_DISCUSS: // 토론
		action.config.url = "<c:url value="/univ/course/active/discuss/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_QUIZ: // 퀴즈
		action.config.url = "<c:url value="/univ/course/active/quiz/list.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_JOIN: // 참여
		action.config.url = "<c:url value="/univ/course/active/join/edit.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_OFFLINE: // 오프라인출석
		action.config.url = "<c:url value="/univ/course/active/offline/edit.do"/>";
		break;
	case CD_COURSE_ELEMENT_TYPE_EXAM: // 시험
		action.config.url = "<c:url value="/univ/course/active/exampaper/list.do"/>";
		break;
	}
	action.run();
};
</script>
<%// 학위와 비학위일때의 교과목 구성항목이 다르다. %>
<c:choose>
    <c:when test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
        <c:set var="codeExcept"><c:out value="${CD_COURSE_ELEMENT_TYPE_EXAM}"/></c:set>
    </c:when>
    <c:otherwise>
    	<c:choose>
    		<c:when test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_PERIOD}">
    			<c:set var="codeExcept"><c:out value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM},${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/></c:set>
    		</c:when>
    		<c:otherwise>
				<c:set var="codeExcept"><c:out value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM},${CD_COURSE_ELEMENT_TYPE_FINALEXAM},${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT},${CD_COURSE_ELEMENT_TYPE_OFFLINE}"/></c:set>    		
    		</c:otherwise>
    	</c:choose>
    </c:otherwise>
</c:choose>

<aof:code type="set" var="elementType" codeGroup="COURSE_ELEMENT_TYPE" except="${codeExcept}"/>
<div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all"
	style="width: 100%; border-top-color: currentColor; border-right-color: currentColor; border-bottom-color: currentColor; border-left-color: currentColor; border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: none; border-right-style: none; border-bottom-style: none; border-left-style: none;">
	<form id="FormGoTab" name="FormGoTab" method="post" onsubmit="return false;">
        <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
        <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>        
        <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
        <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>
	<ul class="ui-widget-header-tab-custom ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
		<c:forEach var="row" items="${elementType}" varStatus="i">
			<li class="ui-state-default ui-corner-top <c:out value="${row.code eq param['selectedElementTypeCd'] ? 'ui-tabs-selected ui-state-active' : ''}"/>"
			><a onclick="doGoTab('<c:out value="${row.code}"/>');"><c:out value="${row.codeName}"/></a></li>
		</c:forEach>
	</ul>
</div>
