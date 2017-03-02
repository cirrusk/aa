<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<!-- 목록 호출용 -->
<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<!-- 등록페이지 호출용 -->
<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${discuss.courseActiveSeq}"/>"/>
    <input type="hidden" name="postType" value="discuss"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<!-- 상세페이지 호출 -->
<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${discuss.courseActiveSeq}"/>"/>
    
	<input type="hidden" name="discussSeq"/>
    <input type="hidden" name="postType" value="discuss"/>
    <input type="hidden" name="referenceSeq"/>
    
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>
