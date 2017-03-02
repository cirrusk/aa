<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"    value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_TEAM_PROJECT_STATUS_D" value="${aoffn:code('CD.TEAM_PROJECT_STATUS.D')}"/>
<c:set var="CD_TEAM_PROJECT_STATUS_R" value="${aoffn:code('CD.TEAM_PROJECT_STATUS.R')}"/>
<c:set var="CD_BOARD_TYPE"            value="${aoffn:code('CD.BOARD_TYPE')}"/>
<c:set var="CD_BOARD_TYPE_ADDSEP"     value="${CD_BOARD_TYPE}::"/>

<form name="FormHome" id="FormHome" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
</form>

<!-- 토론 폼 -->
<form name="FormDiscussDetail" id="FormDiscussDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
	<input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}"/>">
	<input type="hidden" name="discussSeq" value=""/>
	<input type="hidden" name="iconType" value="DISCUSS"/>
</form>

<!-- 과제 폼 -->
<form name="FormHomeworkDetail" id="FormHomeworkDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${_CLASS_courseActiveSeq}"/>"/>
	<input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>">
	<input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}"/>">
	<input type="hidden" name="homeworkSeq" value=""/>
	<input type="hidden" name="iconType" value="TEAMPROJECT"/>
</form>

<!-- 팀프로젝트 폼 -->
<form name="FormDetailTeam" id="FormDetailTeam" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="courseApplySeq"/>
    <input type="hidden" name="iconType" value="TEAMPROJECT"/>
</form>

<!-- 시험 폼 -->
<form name="FormExamPaper" id="FormExamPaper" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveExamPaperSeq"/>
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>"/>
    <input type="hidden" name="activeElementSeq"/>
    <input type="hidden" name="targetNumber"/>
    <input type="hidden" name="iconType" value="EXAM"/>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}" />"/>
</form>

<!-- 설문 폼 -->
<form name="FormSurveyPaper" id="FormSurveyPaper" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSurveySeq"/>
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>"/>
    <input type="hidden" name="iconType" value="SURVEY"/>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${_CLASS_courseTypeCd}" />"/>
</form>

<div id="content-home">
	<div class="article">
		<h3><span class="online"></span><spring:message code="글:과정:온라인학습"/></h3>
		<div class="sub img">
			<c:if test="${applyTotalProgress.element.studyStartYn eq 'Y'}"><!-- 학습이 가능한 강의가 있는경우 -->
				<a href="#" onclick="doNowFirstStudy();" class="icon" ><aof:img src="icon/icon_article_study.gif" alt="학습하기" /></a>
			</c:if>
			<c:if test="${applyTotalProgress.element.studyStartYn ne 'Y'}"><!-- 모든 강의가 학습기간 이전인 경우 -->
				<a href="#" onclick="doNotStudyAlert();" class="icon" ><aof:img src="icon/icon_article_study.gif" alt="학습하기" /></a>
			</c:if>
			<p class="info">
				<c:if test="${not empty applyTotalProgress}">
					<span><spring:message code="글:총"/></span>
					<span><c:out value="${weekTotalCount}"/><spring:message code="글:과정:주차"/></span>
					<c:out value="${onlineItemCount}"/><spring:message code="글:과정:강"/>
					<br /><spring:message code="글:과정:학습횟수"/> : <span id="attemptTotal"><c:out value="${applyTotalProgress.element.attemptTotal}"/></span><spring:message code="글:과정:회"/>
				</c:if>
				<c:if test="${empty applyTotalProgress}">
					<span><spring:message code="글:총"/></span> <c:out value="${weekTotalCount}"/><span><spring:message code="글:과정:주차"/></span> <c:out value="${onlineItemCount}"/><spring:message code="글:과정:강"/>
					<br /><spring:message code="글:과정:학습횟수"/> : <span id="attemptTotal">0</span><spring:message code="글:과정:회"/>
				</c:if>
			</p>
		</div>
		<div class="bg"></div>
	</div>
	<c:if test="${_CLASS_courseTypeCd ne CD_COURSE_TYPE_ALWAYS}">
		<div class="article">
			<h3><span class="offline"></span><spring:message code="글:출석:오프라인출석"/></h3>
			<div class="sub img">
				<a href="javascript:void(0)" class="icon" style="cursor: default;"><aof:img src="icon/icon_article_off.gif" alt="" /></a>
				<p class="info">
					<span><spring:message code="글:과정:총수업횟수"/></span> <c:out value="${offlineLessonCount}"/><spring:message code="글:과정:회"/><br />
					<c:choose>
						<c:when test="${empty applyAttendOff}">
							<span><spring:message code="글:과정:출석"/></span> 0<spring:message code="글:과정:회"/>, 
							<span><spring:message code="글:과정:결석"/></span> 0<spring:message code="글:과정:회"/>,
							<span><spring:message code="글:과정:지각"/></span> 0<spring:message code="글:과정:회"/>
							<%-- <spring:message code="글:과정:공강"/> 0<spring:message code="글:과정:회"/> --%>
						</c:when>
						<c:otherwise>
							<span><spring:message code="글:과정:출석"/></span> <c:out value="${applyAttendOff.applyAttend.attendTypeAbsenceCnt}"/><spring:message code="글:과정:회"/>, 
							<span><spring:message code="글:과정:결석"/></span> <c:out value="${applyAttendOff.applyAttend.attendTypeAbsenceCnt}"/><spring:message code="글:과정:회"/>,
							<span><spring:message code="글:과정:지각"/></span> <c:out value="${applyAttendOff.applyAttend.attendTypePerceptionCnt}"/><spring:message code="글:과정:회"/>
							<%-- <spring:message code="글:과정:공강"/> <c:out value="${applyAttendOff.applyAttend.attendTypeExcuseCnt}"/><spring:message code="글:과정:회"/> --%>						
						</c:otherwise>
					</c:choose>
			</div>
			<div class="bg"></div>
		</div>
	</c:if>
	<div class="article">
		<h3><span class="notice"></span><spring:message code="필드:강의실:공지사항"/></h3>
		<div class="sub" style="overflow-y: auto;height: 162px;margin-top: 2px;">
			<ul class="notice">
				<c:import url="./include/courseActiveNotice.jsp"/>
			</ul>
            <c:forEach var="row" items="${_CLASS_boardInfo.itemList}" varStatus="i">
                <c:set var="boardType" value="${fn:toLowerCase(fn:replace(row.board.boardTypeCd, CD_BOARD_TYPE_ADDSEP, '') )}"/>
                <c:if test="${boardType eq 'notice'}">
                    <a href="javascript:void(0)" 
                       onclick="doGoNoticeMore(
                           '<c:url value="/usr/classroom/course/bbs/${boardType}/list.do"/>',
                           '${row.board.boardSeq}',
                           'NOTICE'
                       );"  title="글:강의실:공지사항더보기" class="more"><spring:message code="글:강의실:더보기"/></a>
                </c:if>
            </c:forEach>
		</div>
		<div class="bg"></div>
        <c:if test="${empty alwaysTopList && empty paginate.itemList}"><div class="overlay"></div></c:if>
	</div>
	
	<!-- 새소식 -->
	<div id="bbs-news">
	</div>
	
	<!-- 과제 리스트 -->
	<c:import url="./include/homeHomeworkList.jsp"/>
	
	<!-- 중간고사 -->
	<c:import url="./include/homeExamPaperList.jsp"/>
	
	<!-- 시험 -->
	<c:import url="./include/homeExamPaperNonDegreeList.jsp"/>
	
	<!-- 설문 -->
	<c:import url="./include/homeSurveyPaperList.jsp"/>
	
	<!-- 퀴즈 -->
	<c:import url="./include/homeQuizList.jsp"/>
	
	<!-- 토론 리스트 -->
	<c:import url="./include/homeDiscussList.jsp"/>
	
	<!-- 팀프로젝트 -->
    <c:forEach var="row" items="${teamProject}" varStatus="i">
        <!-- 정렬 데이트 셋팅 대기-888,종료-999로 할 것-->
        <c:choose>
            <c:when test="${row.courseTeamProject.teamProjectStatusCd eq CD_TEAM_PROJECT_STATUS_D}">
                <c:set var="date" value="${row.courseTeamProject.dDayCount}"/>
            </c:when>
            <c:when test="${row.courseTeamProject.teamProjectStatusCd eq CD_TEAM_PROJECT_STATUS_R}">
                <c:set var="date" value="888"/>
            </c:when>
            <c:otherwise>
                <c:set var="date" value="999"/>
            </c:otherwise>
        </c:choose>
    	<div class="article sortable" type="1" date="<c:out value="${date}"/>">
    		<h3><span class="team"></span><spring:message code="필드:강의실:팀프로젝트"/></h3>
    		<p class="com">
                <aof:code type="print" codeGroup="TEAM_PROJECT_STATUS" selected="${row.courseTeamProject.teamProjectStatusCd}"/>
            </p>
    		<div class="sub">
    			<p>
                    <aof:date datetime="${row.courseTeamProject.startDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
                    <br />
                    <aof:date datetime="${row.courseTeamProject.endDtime}" pattern="yyyy년 MM월 dd일 HH시 mm분"/>
                </p>
    			<p class="inform normal">
                <c:out value="${row.courseTeamProject.teamProjectTitle}"/>
                </p>
    			<a href="javascript:void(0)" onclick="doDetailTeamProject({courseTeamProjectSeq : '<c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>',courseApplySeq : '<c:out value="${param['courseApplySeq']}"/>'})" class="thum <c:if test="${row.courseActiveBbs.bbsCount > 0}">active</c:if>">
                    <span class="join">
                        <c:choose>
                            <c:when test="${row.courseActiveBbs.bbsCount > 0}">
                                <spring:message code="필드:팀프로젝트:참여" />
                            </c:when>
                            <c:otherwise>
                                <spring:message code="필드:팀프로젝트:미참여" />
                            </c:otherwise>
                        </c:choose>
                    </span>
                </a>
    		</div>
    		<div class="bg"></div>
    	</div>
    </c:forEach>
	<!-- <div class="article">
		<h3><span class="team"></span>팀프로젝트</h3>
		<p class="d-day">D<span class="first">2</span><span>9</span></p>
		<div class="sub">
			<p>2014.12.01  09시30분<br />2014.12.29  11시59분</p>
			<p class="inform">팀프로젝트 명칭</p>
			<a href="#" class="thum active"><span class="join">참여</span></a>
		</div>
		<div class="bg"></div>
	</div> -->
	<!-- //팀프로젝트 -->
</div>