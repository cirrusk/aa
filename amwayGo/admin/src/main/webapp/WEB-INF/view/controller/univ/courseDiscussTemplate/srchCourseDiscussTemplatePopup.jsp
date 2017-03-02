<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">templateTitle=<spring:message code="필드:토론:토론주제"/>,templateDescription=<spring:message code="필드:토론:토론내용"/></c:set>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->

	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>" />
				<input type="hidden" name="popupFirstYn" value="N" />
				<span>
					<spring:message code="필드:멤버:교수명"/> : 
					<c:if test="${currentRoleCfString ne 'ADM'}">
						<input type="hidden" name="srchProfSessionMemberSeq" value="${condition.srchProfSessionMemberSeq}" />
						<input type="text" name="srchProfMemberName" value="${condition.srchProfMemberName}" readonly="readonly">&nbsp;
					</c:if>
					<c:if test="${currentRoleCfString eq 'ADM'}">
						<input type="hidden" name="srchProfMemberSeq" value="${condition.srchProfMemberSeq}" />
						<input type="hidden" name="srchProfMemberName" value="${condition.srchProfMemberName}">
						<input type="text" id="srchProfMemberNamePrint" name="srchProfMemberNamePrint" style="width:220px;" value="<c:out value="${condition.srchProfMemberName}"/>">
						<div class="comment" id="profComment"><spring:message code="글:템플릿:교수명을입력후Enter를눌러주십시오"/></div>&nbsp;
					</c:if>
				</span>
				<spring:message code="필드:교과목:교과목명"/> : 
					<input type="hidden" name="srchCourseMasterSeq" value="${condition.srchCourseMasterSeq}" />
					<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}" />
					<input type="text" name="srchCourseTitle" value="${condition.srchCourseTitle}" readonly="readonly" onkeyup="UT.callFunctionByEnter(event, doSearch);">
				<div class="vspace"></div>
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
		<input type="hidden" name="srchProfMemberSeq" 	value="<c:out value="${condition.srchProfMemberSeq}"/>" />
		<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
		<input type="hidden" name="srchProfSessionMemberSeq" value="${condition.srchProfSessionMemberSeq}" />
		<input type="hidden" name="popupFirstYn" value="N" />
		
		<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>" />
		
	</form>

	<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     		value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    		value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchProfMemberName"  value="<c:out value="${condition.srchProfMemberName}"/>" />
		<input type="hidden" name="srchCourseTitle"    	value="<c:out value="${condition.srchCourseTitle}"/>" />
		<input type="hidden" name="srchProfMemberSeq" 	value="<c:out value="${condition.srchProfMemberSeq}"/>" />
		<input type="hidden" name="srchCourseMasterSeq" value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
		<input type="hidden" name="srchProfSessionMemberSeq" value="${condition.srchProfSessionMemberSeq}" />
		<input type="hidden" name="popupFirstYn" value="N" />
		
		<input type="hidden" name="callback" value="<c:out value="${param['callback']}"/>" />
		<input type="hidden" name="templateSeq" />
	</form>