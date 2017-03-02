<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="srchCourseActiveSeq" 		 value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="sortOrder" value="${sortOrderNum}"/>
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}"/>	
	<input type="hidden" name="activeElementSeq" />
	<input type="hidden" name="lessonSeq" />
	<input type="hidden" name="callback" value="doCreateAttendComplete"/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="srchCourseActiveSeq" 	value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="activeElementSeq" value="<c:out value="${condition.activeElementSeq}"/>"/>
	<input type="hidden" name="lessonSeq" value="<c:out value="${condition.lessonSeq}"/>"/>
	<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" 	value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="courseApplySeq" />
	<input type="hidden" name="memberName" />
	<input type="hidden" name="memberId" />
	<input type="hidden" name="categoryName" />
	<input type="hidden" name="attendTypeAttendCnt" />
	<input type="hidden" name="attendTypeAbsenceCnt" />
	<input type="hidden" name="attendTypePerceptionCnt" />
	<input type="hidden" name="attendTypeExcuseCnt" />	
</form>