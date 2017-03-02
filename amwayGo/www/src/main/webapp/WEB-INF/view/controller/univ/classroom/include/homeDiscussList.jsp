<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
	<!-- 토론 리스트 -->
	<c:forEach var="row" items="${discussList}" varStatus="i">
		<!-- 정렬 데이트 셋팅 -->
		<c:choose>
			<c:when test="${row.discuss.discussStatus eq '1'}">
				<c:set var="date" value="${row.discuss.dDayCount}"/>
			</c:when>
			<c:when test="${row.discuss.discussStatus eq '2'}">
				<c:set var="date" value="888"/>
			</c:when>
			<c:when test="${row.discuss.discussStatus eq '3'}">
				<c:set var="date" value="999"/>
			</c:when>
		</c:choose>
	
		<div class="article sortable" type="1" date="<c:out value="${date}"/>" id="discuss_<c:out value="${row.discuss.discussSeq}"/>">
			<h3><span class="discussion"></span><spring:message code="필드:개설과목:토론"/></h3>
			<c:choose>
				<c:when test="${row.discuss.discussStatus eq '1'}"><!-- 진행중 -->
					<c:set var="lengthCount" value="${fn:length(row.discuss.dDayCount)}"/>
					<c:if test="${lengthCount == 3}"><!-- 100일 이상시 -->
						<p class="d-day">D<span class="first"><c:out value="${fn:substring(row.discuss.dDayCount,0,1)}"/></span><span><c:out value="${fn:substring(row.discuss.dDayCount,1,2)}"/></span><span><c:out value="${fn:substring(row.discuss.dDayCount,2,3)}"/></span></p>
					</c:if>
					<c:if test="${lengthCount == 2}"><!-- 10일 이상시 -->
						<p class="d-day">D<span class="first"><c:out value="${fn:substring(row.discuss.dDayCount,0,1)}"/></span><span><c:out value="${fn:substring(row.discuss.dDayCount,1,2)}"/></span></p>
					</c:if>
					<c:if test="${lengthCount == 1}"><!-- 10일 이하시 -->
						<p class="d-day">D<span class="first">0</span><span><c:out value="${row.discuss.dDayCount}"/></span></p>
					</c:if>
				</c:when>
				<c:when test="${row.discuss.discussStatus eq '2'}"><!-- 대기중 -->
					<p class="com"><spring:message code="글:토론:대기" /></p>
				</c:when>
				<c:when test="${row.discuss.discussStatus eq '3'}"><!-- 종료 -->
					<p class="com"><spring:message code="글:토론:종료" /></p>
				</c:when>
			</c:choose>
			<div class="sub">
				<p>
					<aof:date datetime="${row.discuss.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/><br />
					<aof:date datetime="${row.discuss.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
				</p>
				<p class="inform"><c:out value="${row.discuss.discussTitle}"/><br/><spring:message code="필드:토론:내게시글" /> : <c:out value="${row.discuss.bbsMemberCount}"/><spring:message code="글:토론:개" /></p>
				
				<c:choose>
					<c:when test="${row.discuss.discussStatus eq '1'}"><!-- 진행중 -->
						<a href="javascript:void(0)" class="thum active" onclick="doOpenHomeLayer('discuss', {discussSeq : '<c:out value="${row.discuss.discussSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>'})">
							<span class="join"><spring:message code="글:과정:참여" /></span>
						</a>
					</c:when>
					<c:when test="${row.discuss.discussStatus eq '2'}"><!-- 대기중 -->
						<a href="javascript:void(0)" class="thum" onclick="doOpenHomeLayer('discuss', {discussSeq : '<c:out value="${row.discuss.discussSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>'})"><span class="join"><spring:message code="글:과정:참여" /></span></a>
					</c:when>
					<c:when test="${row.discuss.discussStatus eq '3'}"><!-- 종료 -->
						<a href="javascript:void(0)" class="thum active" onclick="doOpenHomeLayer('discuss', {discussSeq : '<c:out value="${row.discuss.discussSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>'})"><span class="result"><spring:message code="글:과정:결과보기" /></span></a>
					</c:when>
				</c:choose>
			</div>
			<div class="bg"></div>
		</div>
	</c:forEach>
	<!-- //토론 리스트 -->
	