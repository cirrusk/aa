<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:게시판:제목"/>,description=<spring:message code="필드:게시판:내용"/>,regMemberName=<spring:message code="필드:등록자"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
			<%--
			<c:if test="${!empty codeGroupBbsType}">
				<select name="srchBbsTypeCd" class="select">
					<option value=""><spring:message code="필드:게시판:구분"/></option>
					<aof:code type="option" codeGroup="${codeGroupBbsType}" selected="${condition.srchBbsTypeCd}"/>
				</select>
			</c:if>
			 --%>
			 <c:if test="${comboDeatilCourseActive.courseActive.competitionYn eq 'Y'}">
			<%--  <select name="srchClassificationCode" class="select">
			 	<option value="">세션값</option>
			 	<c:forEach var="row" items="${sessionList.itemList}" varStatus="i">
			 		<option value="${row.session.sessionCode}">
			 			<c:out value="${row.session.sessionName}"></c:out>
		 			</option>
			 	</c:forEach>
			 	<!-- ${row.session.sessionName} -->
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select> --%>
			 </c:if>
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
			<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
			
			<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
			<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
			<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
			<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
			<input type="hidden" name="srchClassificationCode" value="<c:out value="${condition.srchClassificationCode}"/>"/>
			
			<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  value="<c:out value="${condition.srchBbsTypeCd}"/>" />

	<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	<input type="hidden" name="srchClassificationCode" value="<c:out value="${condition.srchClassificationCode}"/>"/>
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchClassificationCode" value="<c:out value="${condition.srchClassificationCode}"/>"/>
	<input type="hidden" name="bbsSeq"/>
	
	<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	
	<input type="hidden" name="parentSeq" />
	<input type="hidden" name="parentSecretYn" />
	<input type="hidden" name="srchClassificationCode" value="<c:out value="${condition.srchClassificationCode}"/>"/>
	<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
	<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	<input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>

<form name="FormEditBoard" id="FormEditBoard" method="post" onsubmit="return false;">
	<input type="hidden" name="boardSeq" value=""/>
	<input type="hidden" name="callback" value="doList"/>
</form>

<form name="FormApplyDetail" id="FormApplyDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="courseApplySeq"/>
	<input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>	