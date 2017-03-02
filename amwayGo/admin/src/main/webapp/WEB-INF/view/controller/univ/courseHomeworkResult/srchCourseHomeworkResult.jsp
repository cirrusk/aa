<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" 			value="<c:out value="${detail.courseHomework.homeworkSeq}"/>"/>
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormMember" id="FormMember" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" 			value="<c:out value="${detail.courseHomework.homeworkSeq}"/>"/>
    <input type="hidden" name="srchBasicSupplementCd" 	value="<c:out value="${detail.courseHomework.basicSupplementCd}"/>"/>
    <input type="hidden" name="basicSupplementCd" 		value="<c:out value="${detail.courseHomework.basicSupplementCd}"/>"/>
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${detail.courseHomework.courseActiveSeq}"/>"/>
	<input type="hidden" name="rate" 					value="<c:out value="${detail.courseHomework.rate}"/>"/>
	<input type="hidden" name="rate2" 					value="<c:out value="${detail.courseHomework.rate2}"/>"/>
	<input type="hidden" name="replaceYn" 				value="<c:out value="${detail.courseHomework.replaceYn}"/>"/>
	<input type="hidden" name="middleFinalTypeCd" 		value="<c:out value="${detail.courseHomework.middleFinalTypeCd}"/>"/>
	<input type="hidden" name="useYn" 					value="<c:out value="${detail.courseHomework.useYn}"/>"/>
	<input type="hidden" name="openYn" 					value="<c:out value="${detail.courseHomework.openYn}"/>"/>
	<input type="hidden" name="onoffCd" 				value="<c:out value="${detail.courseHomework.onoffCd}"/>"/>
	<input type="hidden" name="startDtime" 				value="<c:out value="${detail.courseHomework.startDtime}"/>"/>
	<input type="hidden" name="endDtime" 				value="<c:out value="${detail.courseHomework.endDtime}"/>"/>
	<input type="hidden" name="start2Dtime" 			value="<c:out value="${detail.courseHomework.start2Dtime}"/>"/>
	<input type="hidden" name="end2Dtime" 				value="<c:out value="${detail.courseHomework.end2Dtime}"/>"/>
	<input type="hidden" name="activeElementSeq" 		value="<c:out value="${detail.courseHomework.activeElementSeq}"/>"/>
	<input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>