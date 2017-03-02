<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
	    <input type="hidden" name="currentPage"  			value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"      			value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"      			value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchBasicSupplementCd" 	value="<c:out value="${condition.srchBasicSupplementCd}"/>"/>
	    <input type="hidden" name="courseActiveSeq" 		value="<c:out value="${homework.courseActiveSeq}" />">
		<input type="hidden" name="homeworkSeq" 			value="<c:out value="${homework.homeworkSeq}" />">
		<input type="hidden" name="basicSupplementCd" 		value="<c:out value="${homework.basicSupplementCd}"/>"/>
		<input type="hidden" name="middleFinalTypeCd" 		value="<c:out value="${homework.middleFinalTypeCd}"/>"/>
		<input type="hidden" name="replaceYn" 				value="<c:out value="${homework.replaceYn}"/>"/>
		<input type="hidden" name="rate2" 					value="<c:out value="${homework.rate2}"/>"/>
		<input type="hidden" name="activeElementSeq"		value="<c:out value="${homework.activeElementSeq}"/>"/>

	    <spring:message code="필드:과제:학부"/> : <input type="text" name="srchCategoryString" value="<c:out value="${condition.srchCategoryString}"/>" style="width:100px;">
	    <%-- &nbsp;&nbsp;
	    <spring:message code="필드:과제:학과"/> : <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;">
	    
	    <div class="vspace"></div>
	 --%> 
		<select name="srchKey" class="select">
			<aof:code type="option" codeGroup="${srchKey}"/>
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
	<input type="hidden" name="srchBasicSupplementCd" 	value="<c:out value="${condition.srchBasicSupplementCd}"/>"/>
	<input type="hidden" name="srchCategoryString" 		value="<c:out value="${condition.srchCategoryString}"/>"/>
	<input type="hidden" name="srchCategoryName" 		value="<c:out value="${condition.srchCategoryName}"/>"/>
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${homework.courseActiveSeq}" />">
	<input type="hidden" name="activeElementSeq"		value="<c:out value="${homework.activeElementSeq}"/>"/>
	<input type="hidden" name="homeworkSeq" 			value="<c:out value="${condition.homeworkSeq}"/>"/>
	<input type="hidden" name="basicSupplementCd" 		value="<c:out value="${homework.basicSupplementCd}"/>"/>
	<input type="hidden" name="middleFinalTypeCd" 		value="<c:out value="${homework.middleFinalTypeCd}"/>"/>
	<input type="hidden" name="replaceYn" 				value="<c:out value="${homework.replaceYn}"/>"/>
	<input type="hidden" name="rate2" 					value="<c:out value="${homework.rate2}"/>"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="homeworkSeq" 			value="<c:out value="${param['homeworkSeq']}"/>"/>
	<input type="hidden" name="courseActiveSeq" 		value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	<input type="hidden" name="activeElementSeq"		value="<c:out value="${homework.activeElementSeq}"/>"/>
    <input type="hidden" name="shortcutYearTerm" 		value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" 	value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    <input type="hidden" name="srchBasicSupplementCd" 	value="<c:out value="${param['basicSupplementCd']}"/>"/>
    <input type="hidden" name="basicSupplementCd" 		value="<c:out value="${param['basicSupplementCd']}"/>"/>
    <input type="hidden" name="courseApplySeq" />
</form>