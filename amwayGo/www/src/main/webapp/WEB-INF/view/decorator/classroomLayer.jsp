<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %><%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<!doctype html>
<!--[if IE 7]><html lang="ko" class="old ie7"><![endif]-->
<!--[if IE 8]><html lang="ko" class="old ie8"><![endif]-->
<!--[if IE 9]><html lang="ko" class="modern ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="ko" class="modern">
<!--<![endif]--><head>
<title><c:out value="${aoffn:config('system.name')}"/></title>
<c:import url="/WEB-INF/view/include/meta.jsp"/>
<c:import url="/WEB-INF/view/include/css.jsp"/>
<c:import url="/WEB-INF/view/include/javascript.jsp"/>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/www/classroom.css" type="text/css"/>
<decorator:head />
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery(document).keydown(function(event) {
		UT.preventBackspace(event); // backspace 막기.
		UT.preventF5(event); // F5 막기.
	});
	Global.parameters = jQuery("#FormGlobalParameters").serialize(); // 공통파라미터
	
	initPage();
});
/**
 * 닫기
 */
doClose = function() {
	parent.doCloseLayer();	
};
</script>
</head>

<body onload="<decorator:getProperty property="body.onload" />">

<c:choose>
	<c:when test="${param['iconType'] eq 'HOMEWORKBASIC'}"><%-- 일반과제 --%>
		<c:set var="iconTypeClass" value="pop-header-task"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'HOMEWORKSUPLEMENT'}"><%-- 보충과제 --%>
		<c:set var="iconTypeClass" value="pop-header-sup-task"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'EXAM'}"><%-- 시험,퀴즈 --%>
		<c:set var="iconTypeClass" value="pop-header-test"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'TEAMPROJECT'}"><%-- 팀프로젝트 --%>
		<c:set var="iconTypeClass" value="pop-header-team"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'SURVEY'}"><%-- 설문 --%>
		<c:set var="iconTypeClass" value="pop-header-survey"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'DISCUSS'}"><%-- 토론 --%>
		<c:set var="iconTypeClass" value="pop-header-discussion"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'NOTICE'}"><%-- 공지사항 --%>
		<c:set var="iconTypeClass" value="pop-header-notice"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'QNA'}"><%-- QNA --%>
		<c:set var="iconTypeClass" value="pop-header-qna"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'ONE2ONE'}"><%-- 1대1 상담 --%>
		<c:set var="iconTypeClass" value="pop-header-mantoman"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'FREE'}"><%-- 자유게시판 --%>
		<c:set var="iconTypeClass" value="pop-header-board"/>
	</c:when>
	<c:when test="${param['iconType'] eq 'APPEAL'}"><%-- 성적이의 신청 --%>
		<c:set var="iconTypeClass" value="pop-header-result"/>
	</c:when>
	<c:otherwise><%-- 나머지 --%>
		<c:set var="iconTypeClass" value="pop-header-etc-board"/>
	</c:otherwise>
</c:choose>

<c:import url="/WEB-INF/view/include/header.jsp"/>

<div>

	<div>
		<div class="classroom" style="width: 100%;">
			<div class="pop-container">
				<div class="pop-header">
					<h3><span class="${iconTypeClass}"></span><decorator:title/></h3>
					<a href="javascript:void(0)" onclick="doClose()" class="close"><aof:img src="common/pop_close.gif" alt="버튼:닫기" /></a>
				</div>
				<div class="pop-content">
					<decorator:body/>
				</div>
			</div>
		</div>
	</div>
	<iframe name="hiddenframe" id="hiddenframe" height="0" width="0" style="display:none;"></iframe>

</div>
</body>
</html>