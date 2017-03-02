<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">templateTitle=<spring:message code="필드:토론:토론주제"/>,templateDescription=<spring:message code="필드:토론:토론내용"/></c:set>
	
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
						<input type="text" name="srchProfMemberName" readonly="readonly" value="${condition.srchProfMemberName}" >&nbsp;
					</c:when>
					<c:otherwise><!-- 관리자, 선임, 강사일때 -->
							<input type="hidden" name="srchProfMemberSeq" value="<c:out value="${condition.srchProfMemberSeq}"/>" />
							<input type="hidden" name="srchProfMemberName" value="<c:out value="${condition.srchProfMemberName}"/>" />
							<input type="text"   id="srchProfMemberNamePrint" name="srchProfMemberNamePrint" style="width:220px;" value="<c:out value="${condition.srchProfMemberName}"/>">
							<div class="comment" id="profComment"><spring:message code="글:템플릿:교수명을입력후Enter를눌러주십시오"/></div>
					</c:otherwise>
				</c:choose>
			</span>
			<span>
				<spring:message code="필드:교과목:교과목명"/> : 
					<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${condition.srchCourseMasterSeq}"/>">
					<input type="hidden" id="srchCourseTitle" name="srchCourseTitle" value="${condition.srchCourseTitle}">
					<input type="text" id="srchCourseTitlePrint" name="srchCourseTitlePrint" value="${condition.srchCourseTitle}" style="width:220px;">
					<div class="comment" id="courseComment"><spring:message code="글:템플릿:교과목명입력후Enter를눌러주십시오"/></div>
			</span>
				
			<div class="vspace"></div>
			<select name="srchUseYn">
				<option value=""><spring:message code="필드:템플릿:사용여부"/></option>
				<aof:code type="option" codeGroup="USEYN" removeCodePrefix="true" selected="${condition.srchUseYn}"></aof:code>
			</select>
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProfMemberName"  value="<c:out value="${condition.srchProfMemberName}"/>" />
	<input type="hidden" name="srchCourseTitle"    	value="<c:out value="${condition.srchCourseTitle}"/>" />
	<input type="hidden" name="srchUseYn"    		value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchProfMemberSeq" 	value="<c:out value="${condition.srchProfMemberSeq}"/>" />
	<input type="hidden" name="srchProfSessionMemberSeq" value="<c:out value="${condition.srchProfSessionMemberSeq}"/>" />
	<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${condition.srchCourseMasterSeq}"/>">
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProfMemberName"  value="<c:out value="${condition.srchProfMemberName}"/>" />
	<input type="hidden" name="srchCourseTitle"    	value="<c:out value="${condition.srchCourseTitle}"/>" />
	<input type="hidden" name="srchUseYn"    		value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchProfMemberSeq" 	value="<c:out value="${condition.srchProfMemberSeq}"/>" />
	<input type="hidden" name="srchProfSessionMemberSeq" value="<c:out value="${condition.srchProfSessionMemberSeq}"/>" />
	<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${condition.srchCourseMasterSeq}"/>">

	<input type="hidden" name="templateSeq" />
</form>

<!-- 교과목 검색 폼 -->
<form name="FormBrowseCourse" id="FormBrowseCourse" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doCourseMasterInsert"/>
	<input type="hidden" name="select" value="single"/>
</form>

<!-- 교수검색 검색 폼 -->	
<form name="FormBrowseProf" id="FormBrowseProf" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doProfInsert"/>
	<input type="hidden" name="select" value="single"/>
	<c:if test="${currentRoleCfString eq 'ASSIST' or currentRoleCfString eq 'TUTOR'}">
		<input type="hidden" name="srchAssistMemberSeq" value="${memberSeq}"/><!-- 선임일때 해당 선임를 사용하는 강사만 출력되게 하기위한 변수 -->
	</c:if>
</form>