<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">

var forListdata = null;
var forDetail = null;
var forCreateAnswerPopup = null;
var forDetailAnswerPopup = null;
var forSurveyPaperPopup = null;
var forExamPaperPopup = null;
initPage = function() {
    doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forSurveyPaperPopup = $.action("popup");
	forSurveyPaperPopup.config.formId         = "FormSurveyPaper";
	forSurveyPaperPopup.config.url            = "<c:url value="/usr/classroom/surveypaper/detail/popup.do"/>";
	forSurveyPaperPopup.config.options.width  = 700;
	forSurveyPaperPopup.config.options.height = 500;
	
	forExamPaperPopup = $.action("layer");
	forExamPaperPopup.config.formId         = "FormExamPaper";
	forExamPaperPopup.config.url            = "<c:url value="/usr/classroom/exampaper/detail/layer.do"/>";
	forExamPaperPopup.config.options.width  = 800;
	forExamPaperPopup.config.options.height = 700;
	
};

/**
 * 설문지 팝업
 */
doSurveyPaperPopup = function(mapPKs) {
	 // 팝업화면 form을 reset한다.
    UT.getById(forSurveyPaperPopup.config.formId).reset();
    // 팝업화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forSurveyPaperPopup.config.formId);
    // 팝업화면 실행
	forSurveyPaperPopup.run();
};

/**
 * 시험 팝업
 */
doExamPaperPopup = function(mapPKs) {
	 // 팝업화면 form을 reset한다.
    UT.getById(forExamPaperPopup.config.formId).reset();
    // 팝업화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forExamPaperPopup.config.formId);
    
    forExamPaperPopup.run();
} 
</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div id="tabContainer">

test list

: <c:out value="${param['courseApplySeq']}"/>
<br>
<a href="#" onclick="doSurveyPaperPopup({'courseActiveSurveySeq' : '2'})">test</a>
<a href="#" onclick="doExamPaperPopup({'courseActiveExamPaperSeq' : '30', 'activeElementSeq' : '213'})">exam</a>

<form name="FormSurveyPaper" id="FormSurveyPaper" method="post" onsubmit="return false;">    
	<input type="hidden" name="courseActiveSurveySeq" />   
	<input type="hidden" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>" /> 
	<input type="hidden" name="callback" value="doSelect"/>
</form>
<form name="FormExamPaper" id="FormExamPaper" method="post" onsubmit="return false;">    
	<input type="hidden" name="courseActiveExamPaperSeq" />   
	<input type="text" name="courseApplySeq" value="<c:out value="${courseApply.courseApplySeq}"/>" /> 
	<input type="text" name="courseActiveSeq" value="<c:out value="${courseActive.courseActiveSeq}"/>" /> 
	<input type="hidden" name="activeElementSeq" value=""/>
	<input type="hidden" name="isIE" value="ie"/>
</form>

</div>
</body>
</html>