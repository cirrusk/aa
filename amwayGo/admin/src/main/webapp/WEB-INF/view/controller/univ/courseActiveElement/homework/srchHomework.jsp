<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"   value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE" value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"  value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="referenceSeq" />
    <input type="hidden" name="referenceRate" />
	<input type="hidden" name="basicSupplementCd" />
	<input type="hidden" name="endDtime" /><!-- 보충과제 등록시에만 사용 -->
    
    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" 	value="<c:out value="${detail.courseHomework.homeworkSeq}"/>"/>
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="basicSupplementCd" value="<c:out value="${detail.courseHomework.basicSupplementCd}"/>"/>
    
    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDelete" id="FormDelete" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" 	value="<c:out value="${detail.courseHomework.homeworkSeq}"/>"/>
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="basicSupplementCd" value="<c:out value="${detail.courseHomework.basicSupplementCd}"/>"/>
	<input type="hidden" name="replaceYn" value="<c:out value="${detail.courseHomework.replaceYn}"/>"/>
	<input type="hidden" name="referenceSeq" 	value="<c:out value="${detail.courseHomework.referenceSeq}"/>"/>
	<c:choose>
		<c:when test="${examType eq 'middle'}">
			<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_MIDDLE}"/>"/> 
		</c:when>
		<c:when test="${examType eq 'final'}">
			<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_FINAL}"/>"/> 
		</c:when>
	</c:choose>
	<!-- 시험 대체 과제일시 사용 -->
	<c:if test="${detail.courseHomework.replaceYn eq 'Y' and detail.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		<c:forEach var="subRow" items="${elementList}" varStatus="j">
			<c:if test="${subRow.element.referenceSeq eq detail.courseHomework.homeworkSeq}">
		    	<input type="hidden" name="activeElementSeq" 	value="<c:out value="${subRow.element.activeElementSeq}"/>"/>
		    </c:if>
		</c:forEach>
	</c:if>
	
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

<!-- 템플릿팝업 호출용 -->
<form name="FormBrowseTemplate" id="FormBrowseTemplate" method="post" onsubmit="return false;">    
	<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	<input type="hidden" name="srchCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>    
	<input type="hidden" name="callback" value="doTemplateInsert"/>
</form>

<!-- 과제결과 이동용도 -->
<form name="FormResultList" id="FormResultList" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>
