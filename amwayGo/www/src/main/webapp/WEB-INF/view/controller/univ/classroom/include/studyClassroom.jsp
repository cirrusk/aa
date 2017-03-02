<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<!-- 출석 인정 진도율 값 가져오기 -->
<aof:code type="set" var="attendProgressList" codeGroup="ATTEND_PROGRESS" selected="VALUE" />
<c:set var="attendProgress"/>
<c:forEach var="row" items="${attendProgressList}" varStatus="i">
	<c:set var="attendProgress" value="${row.codeName}"/>
</c:forEach>

<c:import url="/WEB-INF/view/include/session.jsp"/>

<form name="FormStudyClassroom" id="FormStudyClassroom" method="post" onsubmit="return false;">
	<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>">
	<input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}"/>">
</form>

<form name="FormLearning" id="FormLearning" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="itemSeq" />
	<input type="hidden" name="itemIdentifier" />
	<input type="hidden" name="courseId" />
	<input type="hidden" name="applyId" value="<c:out value="${param['courseApplySeq']}"/>"/>
	<input type="hidden" name="completionStatus"/>
</form>

<form name="FormTotalProgress" id="FormTotalProgress" method="post" onsubmit="return false;">
	<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>">
	<input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}"/>">
</form>

<h2 class="heading"><spring:message code="글:과정:온라인학습"/></h2>
<ul class="attend-mark">
	<li><spring:message code="글:과정:출석"/>  <aof:img src="icon/attend_icon.png" alt="글:과정:출석"/><span><spring:message code="글:과정:진도율"/> <c:out value=" ${attendProgress}"/>% <spring:message code="글:과정:이상수강완료한강의"/></span></li>
	<li class="small"><spring:message code="글:과정:결석"/> <aof:img src="icon/attend_not_icon.png" alt="글:과정:결석"/><span><spring:message code="글:과정:학습기간종료일까지"/></span></li>
	<li><spring:message code="글:과정:지각"/> <aof:img src="icon/attend_late_icon.png" alt="글:과정:지각"/><span><spring:message code="글:과정:수강을진행하였으나학습기간종료일까지진도율"/> <c:out value="${attendProgress}"/>% <spring:message code="글:과정:이하인강의"/></span></li>
	<li class="small">[<span>[<spring:message code="글:과정:수강전"/>]</span>] <span><spring:message code="글:과정:상태인강의"/></span></li>
</ul>

<div id="online-lecture">
</div>
