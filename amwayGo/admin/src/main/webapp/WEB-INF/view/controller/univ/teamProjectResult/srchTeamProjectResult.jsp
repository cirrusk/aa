<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<form name="FormTeamProjectResult" id="FormTeamProjectResult" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormProjectTeamHome" id="FormProjectTeamHome" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormMutualeval" id="FormMutualeval" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormEvalPopup" id="FormEvalPopup" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="callback" value="doProjectResult"/>
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormPersonEvalPopup" id="FormPersonEvalPopup" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="mutualMemberSeq"/>
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormMessage" id="FormMessage" method="post" onsubmit="return false;">
    <input type="hidden" name="checkkeys">
    <input type="hidden" name="memberSeqs">
    <input type="hidden" name="memberNames">
    <input type="hidden" name="phoneMobiles">
</form>

<form name="FormFileDownload" id="FormFileDownload" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseActiveSeq"/>
</form>