<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"         value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_SURVEY" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.SURVEY')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

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
	forListdata.config.url    = "<c:url value="/univ/course/active/survey/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/course/active/survey/edit.do"/>";
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

<c:set var="madatoryCd">Y=<spring:message code="글:설문:필수"/>,N=<spring:message code="글:설문:필수아님"/></c:set>
<c:set var="accessPlace">calssroom=<spring:message code="글:설문:강의실"/>,gradeReview=<spring:message code="글:설문:성적조회"/></c:set>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
<c:import url="srchCourseActiveSurvey.jsp" />

<div class="lybox-title">
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->

<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_SURVEY}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">


<div class="vspace"></div>

	<div class="lybox-title">
	    <h4 class="section-title">
    		<spring:message code="글:설문:설문조회" />
	    </h4>
	</div>
	
	 <table class="tbl-detail">
	 <colgroup>
	     <col style="width: 140px" />
	     <col/>
	 </colgroup>
	 <tbody>
	     <tr>
	         <th><spring:message code="필드:설문:설문제목"/></th>
	         <td>
	             <c:out value="${detail.surveySubject.surveyTitle}"/>
	         </td>
	     </tr>
	     <tr>
	         <th><spring:message code="필드:설문:설문기간"/></th>
	         <td>
	         	<c:choose>
            		<c:when test="${courseType eq 'period'}">
			         	<aof:date datetime="${detail.surveySubject.startDtime}" />&nbsp;
					    <aof:date datetime="${detail.surveySubject.startDtime}" pattern="HH:mm:ss"/>
		                <spring:message code="글:설문:부터" /> ~
		                <aof:date datetime="${detail.surveySubject.endDtime}" />&nbsp;
					    <aof:date datetime="${detail.surveySubject.endDtime}" pattern="HH:mm:ss"/>
					    <spring:message code="글:설문:까지" />
            		</c:when>
            		<c:otherwise>
            			<spring:message code="글:수강시작"/><c:out value="${detail.surveySubject.startDay}" /><spring:message code="글:일부터"/> ~
           				<c:out value="${detail.surveySubject.endDay}" /><spring:message code="글:일까지"/>
            		</c:otherwise>
           		</c:choose>
	         </td>
	     </tr>
	      <tr>
	        	<th>
	        		<spring:message code="필드:설문:필수여부"/>
	        	</th>
	        	<td>
        			<aof:code type="print" codeGroup="${madatoryCd}" selected="${detail.surveySubject.mandatoryYn}"/>
	        	</td>
	        </tr>
	        <tr>
	        	<th>
	        		<spring:message code="필드:설문:사용여부"/>
	        	</th>
	        	<td>
        			<aof:code type="print" codeGroup="OPEN_YN" selected="${detail.surveySubject.useYn}" removeCodePrefix="true"/>
	        	</td>
	        </tr>
	        <tr>
	        	<th>
	        		<spring:message code="필드:설문:접근메뉴"/>
	        	</th>
	        	<td>
        			<aof:code type="print" codeGroup="${accessPlace}" selected="${detail.surveySubject.accessMenu}" />
	      		</td>
	        </tr>
	 </tbody>
	 </table>
	 
	 <c:choose>
	 	<c:when test="${courseType eq 'period'}">
		    <div class="lybox-btn">
		    	<%--
		    	<div class="lybox-btn-l">
		    		<c:if test="${detail.surveySubject.startDtime lt appToday}">
			    		<font color="gray" class="comment"><spring:message code="글:설문:설문기간시작후내용수정이불가능합니다"/></font>
		    		</c:if>
		    	</div>
		    	 --%>
		        <div class="lybox-btn-r">
		            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
		                <a href="javascript:void(0)" onclick="doEdit({'courseActiveSurveySeq' : '<c:out value="${detail.courseActiveSurvey.courseActiveSurveySeq}"/>'});" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
		            </c:if>
		            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		        </div>
		    </div>
	 	</c:when>
	 	<c:otherwise>
		    <div class="lybox-btn">
		    	<%--
		    	<div class="lybox-btn-l">
		    		<c:if test="${detail.courseActiveSurvey.totalAnswerCount gt 0}">
			    		<font color="gray" class="comment"><spring:message code="글:설문:설문기간시작후내용수정이불가능합니다"/></font>
		    		</c:if>
		    	</div>
		    	 --%>
		        <div class="lybox-btn-r">
		            <c:if test="${(aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U'))}">
		                <a href="javascript:void(0)" onclick="doEdit({'courseActiveSurveySeq' : '<c:out value="${detail.courseActiveSurvey.courseActiveSurveySeq}"/>'});" class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
		            </c:if>
		            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		        </div>
		    </div>
	 	</c:otherwise>
	 </c:choose>
	  </div>
	</body>
</html>