<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:게시판:제목"/>,description=<spring:message code="필드:게시판:내용"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
	    <input type="hidden" name="currentPage"  			value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"      			value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
		
		<input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <input type="hidden" name="srchBoardSeq"  			value="<c:out value="${condition.srchBoardSeq}"/>" />
		<input type="hidden" name="srchBbsTypeCd"  			value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	
		<select name="srchKey" class="select">
			<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
		</select>
		<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
		<a href="#" onclick="javascript:doSearch();" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
	</div> 
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  			value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      			value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      			value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     			value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBoardSeq"  			value="<c:out value="${condition.srchBoardSeq}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  			value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="shortcutYearTerm"        value="<c:out value="${param['shortcutYearTerm']}"/>" />
	<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	<input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  			value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      			value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      			value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     			value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  			value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchBoardSeq"  			value="<c:out value="${condition.srchBoardSeq}"/>" />
	<input type="hidden" name="bbsSeq"/>
	<input type="hidden" name="shortcutYearTerm"        value="<c:out value="${param['shortcutYearTerm']}"/>" />
	<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
	<input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>