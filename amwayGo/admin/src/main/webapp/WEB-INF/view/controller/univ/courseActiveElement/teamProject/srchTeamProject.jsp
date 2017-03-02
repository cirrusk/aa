<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${teamProject.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${teamProject.courseActiveSeq}"/>"/>
    <input type="hidden" name="templateSeq"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${teamProject.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${teamProject.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseTeamProjectSeq"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormCreateProjectTeam" id="FormCreateProjectTeam" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseTeamProjectSeq"/>
</form>

<form name="FormDetailProjectTeam" id="FormDetailProjectTeam" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="callback" value="doList"/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${teamProject.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormBrowseTemplate" id="FormBrowseTemplate" method="post" onsubmit="return false;">
    <input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${teamProject.courseActiveSeq}"/>"/>
    <input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="callback" value="doDetailTemplate"/>
</form>