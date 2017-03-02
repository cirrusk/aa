<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>

	<!-- 과제 리스트 -->
	<c:forEach var="row" items="${homeworkList}" varStatus="i">
		<!-- 정렬 데이트 셋팅 -->
		<c:choose>
			<c:when test="${row.courseHomework.homeworkStatus eq '1'}">
				<c:set var="date" value="${row.courseHomework.dDayCount}"/>
			</c:when>
			<c:when test="${row.courseHomework.homeworkStatus eq '2'}">
				<c:set var="date" value="888"/>
			</c:when>
			<c:when test="${row.courseHomework.homeworkStatus eq '3'}">
				<c:set var="date" value="999"/>
			</c:when>
		</c:choose>
	
		<div class="article sortable" type="1" date="<c:out value="${date}"/>"  id="homework_<c:out value="${row.courseHomework.homeworkSeq}"/>" <c:if test="${row.courseHomework.displayYn eq 'N'}">style="display: none;"</c:if>>
			<h3>
				<c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
					<span class="task"></span><spring:message code="필드:과제:일반과제"/>
				</c:if>
				<c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
					<span class="sup-task"></span><spring:message code="필드:과제:보충과제"/>
				</c:if>
			</h3>
			<c:choose>
				<c:when test="${row.courseHomework.homeworkStatus eq '1'}"><!-- 진행중 -->
					<c:set var="lengthCount" value="${fn:length(row.courseHomework.dDayCount)}"/>
					<c:if test="${lengthCount == 3}"><!-- 100일 이상시 -->
						<p class="d-day">D<span class="first"><c:out value="${fn:substring(row.courseHomework.dDayCount,0,1)}"/></span><span><c:out value="${fn:substring(row.courseHomework.dDayCount,1,2)}"/></span><span><c:out value="${fn:substring(row.courseHomework.dDayCount,2,3)}"/></span></p>
					</c:if>
					<c:if test="${lengthCount == 2}"><!-- 10일 이상시 -->
						<p class="d-day">D<span class="first"><c:out value="${fn:substring(row.courseHomework.dDayCount,0,1)}"/></span><span><c:out value="${fn:substring(row.courseHomework.dDayCount,1,2)}"/></span></p>
					</c:if>
					<c:if test="${lengthCount == 1}"><!-- 10일 이하시 -->
						<p class="d-day">D<span class="first">0</span><span><c:out value="${row.courseHomework.dDayCount}"/></span></p>
					</c:if>
				</c:when>
				<c:when test="${row.courseHomework.homeworkStatus eq '2'}"><!-- 대기중 -->
					<p class="com"><spring:message code="글:과정:대기" /></p>
				</c:when>
				<c:when test="${row.courseHomework.homeworkStatus eq '3'}"><!-- 종료 -->
					<p class="com"><spring:message code="글:과정:종료" /></p>
				</c:when>
			</c:choose>
			<div class="sub">
				<c:if test="${row.courseHomework.useYn eq 'Y'}"><!-- 2차 제출 사용시 -->
					<p>
						<aof:date datetime="${row.courseHomework.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/><br />
						<aof:date datetime="${row.courseHomework.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/><br />
						<span>(<spring:message code="글:과제:2차"/>)</span><aof:date datetime="${row.courseHomework.end2Dtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
						<p class="inform normal"><c:out value="${row.courseHomework.homeworkTitle}"/></p>
					</p>
				</c:if>
				<c:if test="${row.courseHomework.useYn ne 'Y'}">
					<p>
						<aof:date datetime="${row.courseHomework.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/><br />
						<aof:date datetime="${row.courseHomework.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
					</p>
					<p class="inform normal"><c:out value="${row.courseHomework.homeworkTitle}"/></p>
				</c:if>
				
				<!-- 보충과제가 등록 되면서 대상자일때 사용 -->
				<c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
					<a class="tap-task" href="javascript:void(0)" onclick="doChangeArticle('homework_<c:out value="${row.courseHomework.homeworkSeq}"/>','homework_<c:out value="${row.courseHomework.referenceSeq}"/>');"> <spring:message code="필드:과제:일반과제"/></a>
				</c:if>
				<c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC and row.courseHomework.displayYn eq 'N'}">
					<a class="tap-task sup" href="javascript:void(0)" onclick="doChangeArticle()"> <spring:message code="필드:과제:보충과제"/></a>
				</c:if>
				
				<c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
					<c:set var="iconType" value="HOMEWORKBASIC"/>
				</c:if>
				<c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
					<c:set var="iconType" value="HOMEWORKSUPLEMENT"/>
				</c:if>
				
				<c:choose>
					<c:when test="${row.courseHomework.homeworkStatus eq '1'}"><!-- 진행중 -->
						<a href="javascript:void(0)" class="thum active" onclick="doOpenHomeLayer('homework', {homeworkSeq : '<c:out value="${row.courseHomework.homeworkSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>',iconType : '<c:out value="${iconType}"/>'})">
							<span class="join"><spring:message code="글:과정:참여" /></span>
						</a>
					</c:when>
					<c:when test="${row.courseHomework.homeworkStatus eq '2'}"><!-- 대기중 -->
						<a href="javascript:void(0)" class="thum" onclick="doOpenHomeLayer('homework', {homeworkSeq : '<c:out value="${row.courseHomework.homeworkSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>',iconType : '<c:out value="${iconType}"/>'})"><span class="join"><spring:message code="글:과정:참여" /></span></a>
					</c:when>
					<c:when test="${row.courseHomework.homeworkStatus eq '3'}"><!-- 종료 -->
						<c:if test="${row.courseHomework.openYn eq 'Y'}">
							<a href="javascript:void(0)" class="thum active" onclick="doOpenHomeLayer('homework', {homeworkSeq : '<c:out value="${row.courseHomework.homeworkSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>',iconType : '<c:out value="${iconType}"/>'})"><span class="result"><spring:message code="글:과정:결과보기" /></span></a>
						</c:if>
						<c:if test="${row.courseHomework.openYn ne 'Y'}">
							<a href="javascript:void(0)" class="thum" onclick="doOpenHomeLayer('homework', {homeworkSeq : '<c:out value="${row.courseHomework.homeworkSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>',iconType : '<c:out value="${iconType}"/>'})"><span class="result"><spring:message code="글:과정:결과보기" /></span></a>
						</c:if>
					</c:when>
				</c:choose>
			</div>
			<div class="bg"></div>
		</div>
	</c:forEach>
	<!-- //토론 리스트 -->