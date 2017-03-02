<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_TYPE_PERIOD"   value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <div class="lybox search">
        <fieldset>
	        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	        <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
            <input type="hidden" name="srchCourseTypeCd"     value="<c:out value="${CD_COURSE_TYPE_PERIOD}"/>" />
            상태: <select name="srchCourseActiveStatusCd">
                <option value="ALL" <c:if test="${condition.srchCourseActiveStatusCd eq 'ALL' }">selected="selected"</c:if>><spring:message code="필드:교과목:전체"/></option>
                <aof:code type="option" codeGroup="COURSE_ACTIVE_STATUS" name="srchCourseActiveStatusCd" selected="${condition.srchCourseActiveStatusCd}"/>    
            </select>
            검색조건 : <select name="srchKey">
            	<option value="all" <c:if test="${condition.srchKey eq 'all'}">selected="selected"</c:if>>전체</option>
            	<option value="active" <c:if test="${condition.srchKey eq 'active'}">selected="selected"</c:if>>과정명</option>
                <option value="group" <c:if test="${condition.srchKey eq 'group'}">selected="selected"</c:if>>그룹방명</option>
            </select>            
	        <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(menuActiveList.menu.menuId)}"/>">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />

    <input type="hidden" name="srchYearTerm" value="<c:out value="${condition.srchYearTerm}"/>" />
    <input type="hidden" name="srchYear"     value="<c:out value="${condition.srchYear}"/>" />
    <input type="hidden" name="srchCourseActiveStatusCd"  value="<c:out value="${condition.srchCourseActiveStatusCd}"/>" />
    <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
    <input type="hidden" name="srchCourseTypeCd"   value="<c:out value="${condition.srchCourseTypeCd}"/>" />
    <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>

    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
    <input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(menuCourseActiveDetail.menu.menuId)}"/>">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
    
    <input type="hidden" name="srchYearTerm" value="<c:out value="${condition.srchYearTerm}"/>" />
    <input type="hidden" name="srchYear"     value="<c:out value="${condition.srchYear}"/>" />
    <input type="hidden" name="srchCourseActiveStatusCd"  value="<c:out value="${condition.srchCourseActiveStatusCd}"/>" />
    <input type="hidden" name="srchCourseTypeCd"   value="<c:out value="${condition.srchCourseTypeCd}"/>" />
    <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
    <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>
    
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="shortcutYearTerm"/>
    <input type="hidden" name="shortcutCourseActiveSeq"/>
    <input type="hidden" name="shortcutCategoryTypeCd"/>
    <input type="hidden" name="shortcutCourseTypeCd"/>
</form>

<form name="FormEdit" id="FormEdit" method="post" onsubmit="return false;">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
    
    <input type="hidden" name="srchYearTerm" value="<c:out value="${condition.srchYearTerm}"/>" />
    <input type="hidden" name="srchYear"     value="<c:out value="${condition.srchYear}"/>" />
    <input type="hidden" name="srchCourseActiveStatusCd"  value="<c:out value="${condition.srchCourseActiveStatusCd}"/>" />
    <input type="hidden" name="srchCourseTypeCd"   value="<c:out value="${condition.srchCourseTypeCd}"/>" />
    <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
    <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>
    
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="shortcutYearTerm"/>
    <input type="hidden" name="shortcutCourseActiveSeq"/>
    <input type="hidden" name="shortcutCategoryTypeCd"/>
    <input type="hidden" name="shortcutCourseTypeCd"/>
</form>

<form name="FormPeriodNumber" id="FormPeriodNumber" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseMasterSeq"/>
    <input type="hidden" name="callback" value="doPlan"/>
</form>

<form id="FormGoTab" name="FormGoTab" method="post" onsubmit="return false;">
    <input type="hidden" name="shortcutCourseActiveSeq"/>
    <input type="hidden" name="shortcutYearTerm"/>        
    <input type="hidden" name="shortcutCategoryTypeCd"/>
    <input type="hidden" name="shortcutCourseTypeCd"/>
</form>