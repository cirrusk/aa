<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">courseActiveTitle=<spring:message code="필드:개설과목:과목명"/>,profMemberName=<spring:message code="필드:개설과목:강사"/>,offerName=<spring:message code="필드:개설과목:제공자"/>,keyword=<spring:message code="필드:개설과목:키워드"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
        <fieldset>
	        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	        <spring:message code="필드:교과목:분류명"/> : 
            <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;"/>
            <div class="vspace"></div>
            <select name="srchCourseActiveStatusCd">
                <option value="ALL" <c:if test="${condition.srchCourseActiveStatusCd eq 'ALL' }">selected="selected"</c:if>><spring:message code="필드:교과목:전체"/></option>
                <aof:code type="option" codeGroup="COURSE_ACTIVE_STATUS" name="srchCourseActiveStatusCd" selected="${condition.srchCourseActiveStatusCd}"/>    
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
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" 		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="ocwCourseActiveSeq"  value="" />
	<input type="hidden" name="courseActiveSeq"  value="" />
</form>