<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_WEEK_TYPE_LECTURE"         value="${aoffn:code('CD.COURSE_WEEK_TYPE.LECTURE')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_ORGANIZATION" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.ORGANIZATION')}"/>

<form id="FormList" name="FormList" method="post" onsubmit="return false;">
</form>

<form name="FormInsert" id="FormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeqs" value="1"/>
	<input type="hidden" name="activeElementSeqs" />
	<input type="hidden" name="referenceSeqs" value=""/>
	<input type="hidden" name="oldReferenceSeqs" value=""/>
	<input type="hidden" name="activeElementTitles" value=""/>
	<input type="hidden" name="referenceTypeCds" value="<c:out value="${CD_COURSE_ELEMENT_TYPE_ORGANIZATION}"/>"/>
	<input type="hidden" name="startDtimes" />
	<input type="hidden" name="endDtimes" />
	<input type="hidden" name="sortOrders" />
	<input type="hidden" name="courseWeekTypeCds" value="<c:out value="${CD_COURSE_WEEK_TYPE_LECTURE}"/>" />
</form>
	
<form id="FormBrowse" name="FormBrowse" method="post" onsubmit="return false;">
	<input type="hidden" name="srchCourseMasterSeq" value="1"/>
	<input type="hidden" name="srchUseYn" value="Y"/>
</form>

<form id="FormListMapping" name="FormListMapping" method="post" onsubmit="return false;">
</form>

<form name="FormLearning" id="FormLearning" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="itemSeq" />
	<input type="hidden" name="itemIdentifier" />
	<input type="hidden" name="courseId" />
	<input type="hidden" name="applyId" />
	<input type="hidden" name="width" />
	<input type="hidden" name="height" />
</form>