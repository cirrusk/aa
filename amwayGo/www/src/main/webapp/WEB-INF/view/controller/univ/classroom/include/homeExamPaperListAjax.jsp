<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"    value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"     value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>
<c:set var="CD_ONOFF_TYPE_ON"               value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>

<c:set var="appFormatDbDatetime" value="${aoffn:config('format.dbdatetime')}"/>
<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="yyyyMMdd"/></c:set>
	<c:forEach var="row" items="${detailExamPaper}" varStatus="i">
		<h3><span class="midterm"></span>
			<c:choose>
				<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
					<c:choose>
						<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
							<c:choose>
								<c:when test="${row.courseHomework.homeworkSeq gt 0}">
									<spring:message code="필드:시험:중간"/><spring:message code="필드:시험:대체과제"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:시험:중간고사"/>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
							<c:choose>
								<c:when test="${row.courseHomework.homeworkSeq gt 0}">
									<spring:message code="필드:시험:기말"/><spring:message code="필드:시험:대체과제"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:시험:기말고사"/>
								</c:otherwise>
							</c:choose>
						</c:when>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
							<c:choose>
								<c:when test="${row.courseHomework.homeworkSeq gt 0}">
									<spring:message code="필드:시험:보충과제"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:시험:보충시험"/>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
							<c:choose>
								<c:when test="${row.courseHomework.homeworkSeq gt 0}">
									<spring:message code="필드:시험:보충과제"/>
								</c:when>
								<c:otherwise>
									<spring:message code="필드:시험:보충시험"/>
								</c:otherwise>
							</c:choose>
						</c:when>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</h3>
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
				<c:set var="Dday" value="${endDtime - today}" />		
			</c:when>
			<c:when test="${today gt endDtime  or row.courseActiveExamPaper.completeCount gt 0}">
				<c:set var="possibleYn" value="N"/>
			</c:when>
		</c:choose>
		
		<c:choose>
			<c:when test="${possibleYn eq 'W'}">
				<p class="com"><spring:message code="필드:시험:대기"/></p>
			</c:when>
			<c:when test="${possibleYn eq 'Y'}">
					<c:if test="${today ge startDtime and today le endDtime}">
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
					</c:if>
			</c:when>
			<c:otherwise>
			<p class="com"><spring:message code="필드:시험:완료"/></p>
			</c:otherwise>
		</c:choose>
		
		<div class="sub">
			<c:set var="onOffTypeCd" value="OFF" />
			<c:if test="${row.courseActiveExamPaper.onOffCd eq CD_ONOFF_TYPE_ON}">
				<c:set var="onOffTypeCd" value="ON" />
			</c:if>
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
			<c:if test="${row.courseActiveExamPaper.onOffCd eq CD_ONOFF_TYPE_ON}">
				<c:choose>
					<c:when test="${possibleYn eq 'Y'}">
						<c:choose>
							<c:when test="${row.courseActiveExamPaper.completeCount eq 0}">
								<a href="javascript:void(0)" class="thum active" onclick="doExamPaperPopup({courseActiveExamPaperSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>',courseActiveSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveSeq}"/>',activeElementSeq : '<c:out value="${row.courseActiveExamPaper.activeElementSeq}"/>',targetNumber : '<c:out value="${targetNumber}"/>',resultYn : 'N',elementType : 'exam',onOffTypeCd : '<c:out value="${onOffTypeCd}"/>'})"><span class="enter"><spring:message code="필드:시험:응시"/></span></a>
							</c:when>
							<c:otherwise>
								<span class="thum"><span class="enter" style="cursor: default;"><spring:message code="필드:시험:응시"/></span></span>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<span class="thum"><span class="enter" style="cursor: default;"><spring:message code="필드:시험:응시"/></span></span>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:choose>
				<c:when test="${row.courseActiveExamPaper.openYn eq 'Y'}">
					<c:choose>
						<c:when test="${row.courseActiveExamPaper.scoredCount gt 0}">
							<a href="javascript:void(0)" class="thum active" onclick="doExamPaperPopup({courseActiveExamPaperSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>',courseActiveSeq : '<c:out value="${row.courseActiveExamPaper.courseActiveSeq}"/>',activeElementSeq : '<c:out value="${row.courseActiveExamPaper.activeElementSeq}"/>',targetNumber : '<c:out value="${targetNumber}"/>',resultYn : 'Y',elementType : 'exam',onOffTypeCd : '<c:out value="${onOffTypeCd}"/>'})"><span class="result"><spring:message code="필드:시험:결과보기"/></span></a>
						</c:when>
						<c:otherwise>
							<span class="thum"><span class="result" style="cursor: default;"><spring:message code="필드:시험:결과보기"/></span></span>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<span class="thum"><span class="result" style="cursor: default;"><spring:message code="필드:시험:결과보기"/></span></span>
				</c:otherwise>
			</c:choose>
			<c:if test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
				<c:choose>
					<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
						<a class="tap-task mid" href="javascript:void(0)" onclick="doChangeArticle('examPaper_<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>','examPaper_<c:out value="${row.courseActiveExamPaper.referenceSeq}"/>');">
							<spring:message code="필드:시험:중간고사"/>
						</a>
					</c:when>
					<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
						<a class="tap-task end" href="javascript:void(0)" onclick="doChangeArticle('examPaper_<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>','examPaper_<c:out value="${row.courseActiveExamPaper.referenceSeq}"/>');">
							<spring:message code="필드:시험:기말고사"/>
						</a>
					</c:when>
				</c:choose>
			</c:if>
			<c:if test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
				<c:choose>
					<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
						<c:if test="${midSupplementCount gt 0}">
							<a class="tap-task rep" href="javascript:void(0)" onclick="doChangeArticle()"> <spring:message code="필드:시험:보충"/></a>
						</c:if>
					</c:when>
					<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
						<c:if test="${finalSupplementCount gt 0}">
							<a class="tap-task rep" href="javascript:void(0)" onclick="doChangeArticle()"> <spring:message code="필드:시험:보충"/></a>
						</c:if>
					</c:when>
				</c:choose>
			</c:if>
		</div>
</c:forEach>		
