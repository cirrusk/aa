<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchExamCount">multiple=<spring:message code="필드:시험:세트문제"/>,single=<spring:message code="필드:시험:단일문제"/></c:set>
<c:set var="srchKey">title=<spring:message code="필드:시험:문제제목"/></c:set>

<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->
<aof:session key="memberSeq" var="memberSeq"/><!-- 교강사일 경우사용-->
<aof:session key="memberName" var="profMemberName"/><!-- 교강사일 경우사용-->

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="srchOnOffCd" value="01" />		
			<%--
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
			 --%>
			<span>
				<spring:message code="필드:교과목:교과목명"/> : 
				<input type="hidden" name="srchCourseMasterSeq" value="${condition.srchCourseMasterSeq}">
				<input type="hidden" id="srchCourseTitle" name="srchCourseTitle" value="${condition.srchCourseTitle}">
				<input type="text" id="srchCourseTitlePrint" name="srchCourseTitlePrint" value="${condition.srchCourseTitle}" style="width:220px;">
				<div class="comment" id="courseComment"><spring:message code="글:시험:교과목명입력후Enter를눌러주십시오"/></div>
			</span>
			
			<div class="vspace"></div>
			<select name="srchExamItemTypeCd">
				<option value=""><spring:message code="필드:시험:문항유형"/></option>
				<aof:code type="option" codeGroup="EXAM_ITEM_TYPE" selected="${condition.srchExamItemTypeCd}"/>
			</select>
			<%--
			<select name="srchExamCount">
				<option value=""><spring:message code="필드:시험:문항유형"/></option>
				<aof:code type="option" codeGroup="${srchExamCount}" selected="${condition.srchExamCount}"/>
			</select>
			 --%>
			<select id="srchUseYn" name="srchUseYn">
				<option value=""><spring:message code="필드:시험:사용여부"/></option>
				<option value="Y" <c:if test="${condition.srchUseYn == 'Y'}"> selected</c:if>>사용</option>
				<option value="N" <c:if test="${condition.srchUseYn == 'N'}"> selected</c:if>>미사용</option>
				<%-- <aof:code type="option" codeGroup="YESNO" ref="2" selected="${condition.srchUseYn}"/> --%>
			</select>
			<input type="hidden" name="srchKey" value="title"/>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchExamCount"         value="<c:out value="${condition.srchExamCount}"/>" />
	<input type="hidden" name="srchExamItemTypeCd"        value="<c:out value="${condition.srchExamItemTypeCd}"/>" />
	<input type="hidden" name="srchUseYn"             value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchCourseMasterSeq"   value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
	<input type="hidden" name="srchCourseTitle" value="<c:out value="${condition.srchCourseTitle}"/>" />
	<input type="hidden" name="srchProfSessionMemberSeq" value="<c:out value="${condition.srchProfSessionMemberSeq}"/>" />
	<input type="hidden" name="srchProfMemberName" value="<c:out value="${condition.srchProfMemberName}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchExamCount"         value="<c:out value="${condition.srchExamCount}"/>" />
	<input type="hidden" name="srchExamItemTypeCd"        value="<c:out value="${condition.srchExamItemTypeCd}"/>" />
	<input type="hidden" name="srchUseYn"             value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchCourseMasterSeq"   value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
	<input type="hidden" name="srchCourseTitle" value="<c:out value="${condition.srchCourseTitle}"/>" />
	<input type="hidden" name="srchProfSessionMemberSeq" value="<c:out value="${condition.srchProfSessionMemberSeq}"/>" />
	<input type="hidden" name="srchProfMemberName" value="<c:out value="${condition.srchProfMemberName}"/>" />

	<input type="hidden" name="examSeq" />
</form>

<form name="FormLayer" id="FormLayer" method="post" onsubmit="return false;">
	<input type="hidden" name="examSeq" />
	<input type="hidden" name="examItemSeq" />
	<input type="hidden" name="decorator" value="iframe"/>
	<input type="hidden" name="confirm" value="true"/>
</form>

<form name="FormBrowseCourse" id="FormBrowseCourse" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSelectCourse"/>
</form>

<form name="FormBrowseProfessor" id="FormBrowseProfessor" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSelectProfessor"/>
	<input type="hidden" name="select" value="single"/>
</form>