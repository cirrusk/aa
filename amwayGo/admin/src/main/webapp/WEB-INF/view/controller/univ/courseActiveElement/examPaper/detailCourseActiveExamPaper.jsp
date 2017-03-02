<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"         value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"    value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit        = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/edit.do"/>";
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면으로 이동
 */
doEdit = function(mapPKs) {
	UT.getById(forEdit.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	forEdit.run();
};
</script>
</head>

<body>

<c:import url="srchCourseActiveExamPaper.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title">
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->

<c:choose>
	<c:when test="${examType eq 'middle'}">
		<c:import url="../include/commonCourseActiveElement.jsp">
		    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
		    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM}"/>
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import url="../include/commonCourseActiveElement.jsp">
		    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
		    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/>
		</c:import>
	</c:otherwise>
</c:choose>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">

	<div class="lybox-title">
	    <h4 class="section-title">
	    	<c:choose>
	    		<c:when test="${examType eq 'middle'}">
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="필드:시험:중간고사" /><spring:message code="글:시험:조회" />
			    	</c:if>
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="글:시험:보충" /><spring:message code="필드:시험:중간고사" /><spring:message code="글:시험:조회" />
			    	</c:if>
	    		</c:when>
	    		<c:otherwise>
	    			<c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="필드:시험:기말고사" /><spring:message code="글:시험:조회" />
			    	</c:if>
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="글:시험:보충" /><spring:message code="필드:시험:기말고사" /><spring:message code="글:시험:조회" />
			    	</c:if>
	    		</c:otherwise>
	    	</c:choose>
	    </h4>
	</div>
	
	 <table class="tbl-detail">
	 <colgroup>
	     <col style="width: 140px" />
	     <col/>
	 </colgroup>
	 <tbody>
	     <tr>
	         <th><spring:message code="필드:시험:온오프라인"/></th>
	         <td>
	             <aof:code name="onOffCd" type="print" codeGroup="ONOFF_TYPE" selected="${detail.courseActiveExamPaper.onOffCd}" />
	         </td>
	     </tr>
	     <tr>
	         <th><spring:message code="필드:시험:대상자"/></th>
	         <td>
	             <c:out value="${detail.courseActiveExamPaper.targetCount}"/>&nbsp;<spring:message code="글:명"/>
	         </td>
	     </tr>
	     <c:if test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
	     	<tr>
	     		<th><spring:message code="필드:시험:주차매핑"/></th>
	     		<td>
	     			<c:set var="elementCount" value="0" />
	     			<c:forEach var="row" items="${elementList}" varStatus="i">
	     				<c:if test="${row.element.referenceSeq eq detail.courseActiveExamPaper.courseActiveExamPaperSeq}">
	     					<c:out value="${row.element.sortOrder}" /><spring:message code="글:시험:주차"/>
		     				<c:set var="elementCount" value="${elementCount + 1}" />
	     				</c:if>
	     			</c:forEach>
	     			<c:if test="${elementCount eq 0}">
	     				<spring:message code="글:시험:사용안함"/>
	     			</c:if>
	     		</td>
	     	</tr>
	     </c:if>
	     <c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	        	<tr>
	        		<th>
		                <spring:message code="필드:시험:배점비율"/>
		            </th>
		            <td>
		            	<c:out value="${detail.courseActiveExamPaper.rate}"/> %
		            </td>
	        	</tr>
	        </c:if>
	     <tr>
	         <th><spring:message code="필드:시험:시험제목"/></th>
	         <td>
	             <c:out value="${detail.courseExamPaper.examPaperTitle}"/>
	         </td>
	     </tr>
	     <tr>
	         <th><spring:message code="필드:시험:시험기간"/></th>
	         <td>
	         	<aof:date datetime="${detail.courseActiveExamPaper.startDtime}" />&nbsp;
			    <aof:date datetime="${detail.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
                <spring:message code="글:시험:부터" /> ~
                <aof:date datetime="${detail.courseActiveExamPaper.endDtime}" />&nbsp;
			    <aof:date datetime="${detail.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
			    <spring:message code="글:시험:까지" />
	         </td>
	     </tr>
	     <tr>
	     	<th><spring:message code="필드:시험:시험시간"/></th>
	     	<td>
	     		<c:out value="${detail.courseActiveExamPaper.examTime}" />&nbsp;<spring:message code="글:분" />
	     	</td>
	     </tr>
	     <tr>
	     	<th><spring:message code="필드:시험:성적공개여부"/></th>
	     	<td>
	     		
                <aof:code type="print" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseActiveExamPaper.openYn}" removeCodePrefix="true"/>
	     	</td>
	     </tr>
	 </tbody>
	 </table>
	 
	    <div class="lybox-btn">
	    	<div class="lybox-btn-l">
	    		<c:if test="${detail.courseActiveExamPaper.startDtime lt appToday}">
		    		<font color="gray" class="comment"><spring:message code="글:시험:시험기간시작후내용수정이불가능합니다"/></font>
	    		</c:if>
	    	</div>
	        <div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and (detail.courseActiveExamPaper.startDtime gt appToday or empty detail.courseActiveExamPaper.startDtime)}">
	                <a href="javascript:void(0)" onclick="doEdit({'courseActiveExamPaperSeq' : '<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>'});" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
	            </c:if>
	            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
	        </div>
	    </div>
	  </div>
	</body>
</html>