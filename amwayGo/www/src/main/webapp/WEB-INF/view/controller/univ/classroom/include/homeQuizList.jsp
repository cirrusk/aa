<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>


<c:set var="appFormatDbDatetime" value="${aoffn:config('format.dbdatetime')}"/>
<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="yyyyMMdd"/></c:set>

<c:forEach var="row" items="${quizList}" varStatus="i">
	<!-- 		날짜 표시 세팅 -->
	<c:set var="startDtime" value="0"/>
	<c:set var="endDtime" value="0"/>
	<c:set var="startDtime"><aof:date datetime="${row.courseActiveExamPaper.startDtime}" pattern="yyyyMMdd" /></c:set>
	<c:set var="endDtime"><aof:date datetime="${row.courseActiveExamPaper.endDtime}" pattern="yyyyMMdd" /></c:set>
	
	<!-- 		D-day 세팅 -->
	<c:set var="possibleYn" value="W"/>
	<c:set var="Dday" value="0"/>
	<c:choose>
		<c:when test="${today ge startDtime and today le endDtime and row.courseActiveExamPaper.completeCount eq 0}">
			<c:set var="possibleYn" value="Y"/>
			<c:set var="Dday" value="${row.courseActiveExamPaper.dDayCount}" />		
		</c:when>
		<c:when test="${today gt endDtime or row.courseActiveExamPaper.completeCount gt 0}">
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
	<div class="article sortable" type="7" date="${date}" id="quiz_<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>" >
		<h3><span class="quiz"></span><spring:message code="필드:퀴즈:퀴즈"/></h3>
		<c:choose>
			<c:when test="${possibleYn eq 'W'}">
				<p class="com"><spring:message code="필드:퀴즈:대기"/></p>
			</c:when>
			<c:when test="${possibleYn eq 'Y'}">
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
			<p class="com"><spring:message code="필드:퀴즈:완료"/></p>
			</c:otherwise>
		</c:choose>
		
		<div class="sub">
			<c:choose>
				<c:when test="${possibleYn eq 'N'}">
					<p class="top"><span class="timer"></span></p>
				</c:when>
				<c:otherwise>
					<p class="top"><span class="timer"><c:out value="${row.courseActiveExamPaper.examTime}" /><spring:message code="글:분"/></span></p>
				</c:otherwise>
			</c:choose>
			<p class="inform">
				<aof:date datetime="${row.courseActiveExamPaper.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/><br/>
				<aof:date datetime="${row.courseActiveExamPaper.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
			</p>
		<c:choose>
			<c:when test="${possibleYn eq 'Y'}">
				<c:choose>
					<c:when test="${row.courseActiveExamPaper.completeCount eq 0}">
						<a href="javascript:void(0)" class="thum active" onclick="doExamPaperPopup({courseActiveExamPaperSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>',courseActiveSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveSeq}"/>',activeElementSeq : '<c:out value="${row.courseActiveExamPaper.activeElementSeq}"/>',targetNumber : 'quiz_<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>',resultYn : 'N',elementType : 'quiz',onOffTypeCd : 'ON'})"><span class="enter"><spring:message code="필드:퀴즈:응시"/></span></a>
					</c:when>
					<c:otherwise>
						<span class="thum"><span class="enter" style="cursor: default;"><spring:message code="필드:퀴즈:응시"/></span></span>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<span class="thum"><span class="enter" style="cursor: default;"><spring:message code="필드:퀴즈:응시"/></span></span>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${row.courseActiveExamPaper.openYn eq 'Y'}">
				<c:choose>
					<c:when test="${row.courseActiveExamPaper.scoredCount gt 0}">
						<a href="javascript:void(0)" class="thum active" onclick="doExamPaperPopup({courseActiveExamPaperSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>',courseActiveSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveSeq}"/>',activeElementSeq : '<c:out value="${row.courseActiveExamPaper.activeElementSeq}"/>',targetNumber : 'quiz_<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>',resultYn : 'Y',elementType : 'quiz',onOffTypeCd : 'ON'})"><span class="result"><spring:message code="필드:퀴즈:결과보기"/></span></a>
					</c:when>
					<c:otherwise>
						<span class="thum"><span class="result" style="cursor: default;"><spring:message code="필드:퀴즈:결과보기"/></span></span>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<span class="thum"><span class="result" style="cursor: default;"><spring:message code="필드:퀴즈:결과보기"/></span></span>
			</c:otherwise>
		</c:choose>
		</div>
		<div class="bg"></div>
	</div>		
</c:forEach>
