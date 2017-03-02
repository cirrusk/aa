<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>

<c:set var="appFormatDbDatetime" value="${aoffn:config('format.dbdatetime')}"/>
<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="yyyyMMdd"/></c:set>

<c:forEach var="row" items="${detailSurveyPaper}" varStatus="i">
	<!-- 		날짜 표시 세팅 -->
	<c:set var="startDtime" value="0"/>
	<c:set var="endDtime" value="0"/>
	<c:set var="startDtime"><aof:date datetime="${row.surveySubject.startDtime}" pattern="yyyyMMdd" /></c:set>
	<c:set var="endDtime"><aof:date datetime="${row.surveySubject.endDtime}" pattern="yyyyMMdd" /></c:set>
	<!-- 		D-day 세팅 -->
	<c:set var="possibleYn" value="W"/>
	<c:set var="Dday" value="0"/>
	<c:choose>
		<c:when test="${today ge startDtime and today le endDtime}">
			<c:set var="possibleYn" value="Y"/>
			<c:set var="Dday" value="${row.courseActiveSurvey.dDayCount}" />		
		</c:when>
		<c:when test="${today gt endDtime}">
			<c:set var="possibleYn" value="N"/>
		</c:when>
	</c:choose>
	
	<!-- 	소트용 데이트 입력 -->
	<c:set var="date" value="0" />
	<c:choose>
		<c:when test="${possibleYn eq 'W'}">
			<c:set var="date" value="888" />
		</c:when>
		<c:when test="${possibleYn eq 'N'}">
			<c:set var="date" value="999" />
		</c:when>
		<c:when test="${possibleYn eq 'Y'}">
			<c:set var="date" value="${Dday}" />
		</c:when>
	</c:choose>
	
	<!-- 	div박스 그리기시작 -->
	<div class="article sortable" type="6" date="${date}" id="surveyPaper_<c:out value="${row.courseActiveSurvey.courseActiveSurveySeq}"/>" >
		<h3><span class="survey"></span><spring:message code="필드:설문:설문"/></h3>
		<c:set var="lengthCount" value="0"/>
		<c:choose>
			<c:when test="${Dday ge 0 and Dday lt 10}">
				<c:set var="lengthCount" value="1"/>
			</c:when>
			<c:when test="${Dday ge 10 and Dday lt 100}">
				<c:set var="lengthCount" value="2"/>
			</c:when>
			<c:when test="${Dday ge 100}">
				<c:set var="lengthCount" value="3"/>
			</c:when>
		</c:choose>
		<c:choose>
			<c:when test="${possibleYn eq 'W' and row.courseActiveSurvey.completeCount eq 0}">
				<p class="com"><spring:message code="필드:설문:대기"/></p>
			</c:when>
			<c:when test="${possibleYn eq 'Y' and row.courseActiveSurvey.completeCount eq 0}">
				<c:if test="${lengthCount == 3}"><!-- 100일 이상시 -->
					<p class="d-day">D<span class="first"><c:out value="${fn:substring(Dday,0,1)}"/></span><span><c:out value="${fn:substring(Dday,1,2)}"/></span><span><c:out value="${fn:substring(Dday,2,3)}"/></span></p>
				</c:if>
				<c:if test="${lengthCount == 2}"><!-- 10일 이상시 -->
					<p class="d-day">D<span class="first"><c:out value="${fn:substring(Dday,0,1)}"/></span><span><c:out value="${fn:substring(Dday,1,2)}"/></span></p>
				</c:if>
				<c:if test="${lengthCount == 1}"><!-- 10일 이하시 -->
					<p class="d-day">D<span class="first">0</span><span><c:out value="${Dday}"/></span></p>
				</c:if>
			</c:when>
			<c:otherwise>
				<p class="com"><spring:message code="필드:설문:완료"/></p>
			</c:otherwise>
		</c:choose>
		<div class="sub">
			<p class="top">
				<span><aof:date datetime="${row.surveySubject.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/></span> <br/>
				<span><aof:date datetime="${row.surveySubject.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/></span> <br />
			</p>
			<p class="inform">
				<c:out value="${row.surveyPaper.surveyPaperTitle}" />
			</p>
			<c:choose>
				<c:when test="${row.courseActiveSurvey.completeCount eq 0 and possibleYn eq 'Y'}">
					<a href="javascript:void(0)" class="thum active" onclick="doSurveyPaperPopup({'courseActiveSurveySeq' : '<c:out value="${row.courseActiveSurvey.courseActiveSurveySeq}"/>',courseActiveSeq : '<c:out value="${row.courseActiveSurvey.courseActiveSeq}"/>'})">
						<span class="join"><spring:message code="필드:설문:참여"/></span>
					</a>
				</c:when>
				<c:otherwise>
					<span class="thum">
						<span class="join" style="cursor: default;">
							<spring:message code="필드:설문:참여"/>
						</span>
					</span>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="bg"></div>
		<c:if test="${row.surveySubject.mandatoryYn eq 'Y'}">
			<div class="must"><spring:message code="필드:설문:필수"/></div>
		</c:if>
		<c:if test="${row.courseActiveSurvey.completeCount gt 0 or possibleYn eq 'N'}">
			<div class="overlay"></div>
		</c:if>
	</div>
</c:forEach>