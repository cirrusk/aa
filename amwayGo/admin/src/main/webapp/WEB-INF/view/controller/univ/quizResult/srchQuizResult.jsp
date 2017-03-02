<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">title=<spring:message code="필드:퀴즈:제목"/>,memberName=<spring:message code="필드:퀴즈:출제자"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <div class="lybox search">
        <fieldset>
	        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
            
            <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
		    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
		    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    
    		<select name="srchKey"  class="select">
	            <aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
	        </select>
	        <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="examItemSeq"/>
	<input type="hidden" name="courseActiveSeq"/>
	<input type="hidden" name="courseActiveProfSeq"/>
	<input type="hidden" name="quizDtime"/>
	<input type="hidden" name="count"/>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(menuActiveList.menu.menuId)}"/>">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />

    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>
