<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
    
    <input type="hidden" name="srchActiveLecturerTypeCd" value="${condition.srchActiveLecturerTypeCd}"/>
	<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="${condition.shortcutCourseTypeCd}"/>
	
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchActiveLecturerTypeCd" value="${condition.srchActiveLecturerTypeCd}"/>
	<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="${condition.shortcutCourseTypeCd}"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchActiveLecturerTypeCd" value="${condition.srchActiveLecturerTypeCd}"/>
	<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="${condition.shortcutCourseTypeCd}"/>

	<input type="hidden" name="courseActiveProfSeq" />
</form>

<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doInsert"/>
	<input type="hidden" name="select" value="multiple"/>
	<input type="hidden" name="srchNotInCourseActiveSeq"/>
	<input type="hidden" name="srchActiveLecturerTypeCd"/>
</form>


<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
	<input type="hidden" name="activeLecturerTypeCd" value="<c:out value="${condition.srchActiveLecturerTypeCd}"/>" />
	<input type="hidden" name="shortcutCourseTypeCd" value="${condition.shortcutCourseTypeCd}"/>
</form>

