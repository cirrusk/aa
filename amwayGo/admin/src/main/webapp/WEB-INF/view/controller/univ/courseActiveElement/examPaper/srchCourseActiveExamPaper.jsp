<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON"          value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC" value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_EXAM_PAPER_TYPE_EXAM"   value="${aoffn:code('CD.EXAM_PAPER_TYPE.EXAM')}"/>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="referenceSeq" />
    
	<input type="hidden" name="basicSupplementCd" value="<c:out value="${CD_BASIC_SUPPLEMENT_BASIC}"/>"/>
	<input type="hidden" name="endDtime" /><!-- 보충과제 등록시에만 사용 -->
    
    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<!-- 대체과제용 -->
<form name="FormCreateHomework" id="FormCreateHomework" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="referenceSeq" />
    <input type="hidden" name="referenceType" />
    <input type="hidden" name="ReplaceYn" value="Y"/>
    
	<input type="hidden" name="basicSupplementCd" value="<c:out value="${CD_BASIC_SUPPLEMENT_BASIC}"/>"/>
	<input type="hidden" name="endDtime" /><!-- 보충과제 등록시에만 사용 -->
	
	<input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="courseActiveExamPaperSeq" />
    
    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<!-- 대체과제용 -->
<form name="FormDetailHomework" id="FormDetailHomework" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="homeworkSeq" />
    
    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormBrowseExamPaper" id="FormBrowseExamPaper" method="post" onsubmit="return false;">    
	<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>    
	<input type="hidden" name="srchExamPaperTypeCd" value="<c:out value="${CD_EXAM_PAPER_TYPE_EXAM}"/>"/>    
	<input type="hidden" name="srchOnOffCd" value="<c:out value="${CD_ONOFF_TYPE_ON}"/>"/>
	<input type="hidden" name="srchUseYn" value="Y"/>
	<input type="hidden" name="callback" value="doSelect"/>
</form>