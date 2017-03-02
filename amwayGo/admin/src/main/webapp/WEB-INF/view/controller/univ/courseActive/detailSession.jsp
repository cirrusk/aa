<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html decorator="popupAsk">
<head>
<link rel="stylesheet" href="<c:out value="${appDomainWeb}"/>/common/css/admin/common_exam.css" type="text/css"/>
<title></title>
<script type="text/javascript">
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forDetail = $.action();
	forDetail.config.formId = "FormList";
	forDetail.config.url    = "<c:url value="/univ/course/active/session/detail.do"/>";
	
	forList = $.action();
	forList.config.formId = "FormList";
	forList.config.url    = "<c:url value="/univ/course/active/session/list.do"/>";
	
	forAdminBbsList = $.action();
	forAdminBbsList.config.formId = "FormList";
	forAdminBbsList.config.url    = "<c:url value="/univ/course/bbs/ask/listAdmin.do"/>";
	
	forAllBbsList = $.action();
	forAllBbsList.config.formId = "FormList";
	forAllBbsList.config.url    = "<c:url value="/univ/course/bbs/ask/listAll.do"/>";
	
	forCelebrateList = $.action();
	forCelebrateList.config.formId = "FormDetail";
	forCelebrateList.config.url    = "<c:url value="/univ/course/bbs/celebrate/list.do"/>";
	
	forPollList = $.action();
	forPollList.config.formId = "FormList";
	forPollList.config.url    = "<c:url value="/univ/course/active/quiz/answer/session/list.do"/>";
	
	
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
};

/**
 * 상세보기 화면을 호출하는 함수
 */
doList = function() {

	forList.run();
};

/**
 * 질문하기(강사)
 */
doAdminBbsList = function() {

	forAdminBbsList.run();
};

/**
 * 질문하기(강사)
 */
 doAllBbsList = function() {

	forAllBbsList.run();
};

/**
 * 축하하기 목록
 */
doCelebrateList = function() {

	 forCelebrateList.run();
};

/**
 * 온라인폴 목록
 */
doPollList = function() {
	forPollList.run();
};


</script>
</head>

<body>
	<div class="bg">
	<div class="wrapper">
	<!-- header -->
	<div id="header">
		<h1 class="logo"><a href="javascript:void(0);" onclick="doList();"><aof:img src="common/logo_t.png"/></a></h1>
				<h2 class="tit">메뉴선택</h2>
	</div>
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	
	    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
		<input type="hidden" name="srchClassificationCode"  value="<c:out value="${param['srchClassificationCode']}"/>" />
		<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	</form>
	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	
	    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
		<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
		<input type="hidden" name="classificationCode"  value="<c:out value="${param['srchClassificationCode']}"/>" />
	</form>
	<div class="menuWrap">
		<a href="javascript:void(0);" onclick="doAdminBbsList();">질문하기 (선택된 질문 보기)</a>
	 	<br/>
	 	<a href="javascript:void(0);" onclick="doAllBbsList();">질문하기 (전체보기)</a>
	 	<br/>
	 	<a href="javascript:void(0);" onclick="doPollList();">Online Poll</a>
	 	<br/>
	 	<a href="javascript:void(0);" onclick="doCelebrateList();">축하메세지</a>
	 	<br/>
 	</div>
 	
	</div>
	</div>
	
</body>
</html>