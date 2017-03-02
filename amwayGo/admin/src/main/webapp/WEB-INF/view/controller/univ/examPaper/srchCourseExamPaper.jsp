<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:시험:시험지제목"/>,description=<spring:message code="필드:시험:시험지설명"/></c:set>

<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
<aof:session key="memberSeq" var="memberSeq"/><!-- 교강사일 경우사용-->
<aof:session key="memberName" var="profMemberName"/><!-- 교강사일 경우사용-->

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			
			<span>
				<spring:message code="필드:멤버:교수명"/> : 
				<c:choose>
					<c:when test="${currentRoleCfString eq 'PROF'}"><!-- 교강사일때 -->
						<input type="hidden" name="srchProfSessionMemberSeq" value="<c:out value="${condition.srchProfSessionMemberSeq}"/>" />
						<input type="text" name="srchProfMemberName" readonly="readonly" value="${condition.srchProfMemberName}" style="color: red;">&nbsp;
					</c:when>
					<c:otherwise><!-- 관리자, 선임, 강사일때 -->
						<input type="hidden" name="srchProfMemberSeq" value="<c:out value="${condition.srchProfMemberSeq}"/>" />
						<input type="hidden" name="srchProfMemberName" value="<c:out value="${condition.srchProfMemberName}"/>" />
						<input type="text" id="srchProfMemberNamePrint" name="srchProfMemberNamePrint" style="width:220px;" value="<c:out value="${condition.srchProfMemberName}"/>">
						<div class="comment" id="profComment"><spring:message code="글:시험:교수명을입력후Enter를눌러주십시오"/></div>
					</c:otherwise>
				</c:choose>
			</span>
			
			<span>
				<spring:message code="필드:교과목:교과목명"/> : 
				<input type="hidden" name="srchCourseMasterSeq" value="${condition.srchCourseMasterSeq}">
				<input type="hidden" id="srchCourseTitle" name="srchCourseTitle" value="${condition.srchCourseTitle}">
				<input type="text" id="srchCourseTitlePrint" name="srchCourseTitlePrint" value="${condition.srchCourseTitle}" style="width:220px;">
				<div class="comment" id="courseComment"><spring:message code="글:시험:교과목명입력후Enter를눌러주십시오"/></div>
			</span>
			
			<div class="vspace"></div>
			<select name="srchExamPaperTypeCd">
				<option value=""><spring:message code="필드:시험:시험지구분"/></option>
				<aof:code type="option" codeGroup="EXAM_PAPER_TYPE" selected="${condition.srchExamPaperTypeCd}"/>
			</select>
			<select name="srchUseYn">
				<option value=""><spring:message code="필드:시험:사용여부"/></option>
				<aof:code type="option" codeGroup="YESNO" ref="2" selected="${condition.srchUseYn}"/>
			</select>
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
<%-- 					<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a> --%>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchExamPaperTypeCd"   value="<c:out value="${condition.srchExamPaperTypeCd}"/>" />
	<input type="hidden" name="srchUseYn"             value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchCourseMasterSeq"   value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
	<input type="hidden" name="srchCourseMasterTitle" value="<c:out value="${condition.srchCourseMasterTitle}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchExamPaperTypeCd"   value="<c:out value="${condition.srchExamPaperTypeCd}"/>" />
	<input type="hidden" name="srchUseYn"             value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchCourseMasterSeq"   value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
	<input type="hidden" name="srchCourseMasterTitle" value="<c:out value="${condition.srchCourseMasterTitle}"/>" />

	<input type="hidden" name="examPaperSeq" />
</form>

<form name="FormBrowseCourse" id="FormBrowseCourse" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSelectCourse"/>
</form>

<form name="FormBrowseProfessor" id="FormBrowseProfessor" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSelectProfessor"/>
	<input type="hidden" name="select" value="single"/>
</form>

<form name="FormPreview" id="FormPreview" method="post" onsubmit="return false;">
	<input type="hidden" name="examPaperSeq" />
	<input type="hidden" name="paperNumber" />
</form>
