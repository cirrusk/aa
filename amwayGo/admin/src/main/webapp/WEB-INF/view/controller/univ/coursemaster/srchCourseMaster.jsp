<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <div class="lybox search">
        <fieldset>
	        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	        <input type="hidden" name="srchCategoryOrganizationSeq" value="<c:out value="${condition.srchCategoryOrganizationSeq}"/>" />
	        <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
	        
	        <%--
	        <spring:message code="필드:교과목:학부"/> : 
            <input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;"/>
	             --%>
	        <input type="radio" name="srchCourseStatusCd" value="" <c:if test="${empty condition.srchCourseStatusCd}">checked="checked"</c:if>>
	        <label for="srchCourseStatusCd"><spring:message code="필드:교과목:전체"/></label>
	        <aof:code type="radio" codeGroup="COURSE_STATUS" name="srchCourseStatusCd" selected="${condition.srchCourseStatusCd}"/>
	       <div class="vspace"></div>
	        <%// 학위일 경우 %>
            <c:if test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
		        <select name="srchCompleteDivisionCd"  class="select">
		            <option value=""><spring:message code="필드:교과목:전체"/></option>
		            <aof:code type="option" codeGroup="COMPLETE_DIVISION" selected="${condition.srchCompleteDivisionCd}"/>
		        </select>
	        </c:if>
	        <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
    <input type="hidden" name="currentPage"  value="1" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />

    <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>
    <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
    <input type="hidden" name="srchCompleteDivisionCd"   value="<c:out value="${condition.srchCompleteDivisionCd}"/>" />
    <input type="hidden" name="srchCourseStatusCd" value="<c:out value="${condition.srchCourseStatusCd}"/>" />
    <input type="hidden" name="srchCategoryOrganizationSeq" value="<c:out value="${condition.srchCategoryOrganizationSeq}"/>" />
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
    
    <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>
    <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
    <input type="hidden" name="srchCompleteDivisionCd"   value="<c:out value="${condition.srchCompleteDivisionCd}"/>" />
    <input type="hidden" name="srchCourseStatusCd" value="<c:out value="${condition.srchCourseStatusCd}"/>" />
    <input type="hidden" name="srchCategoryOrganizationSeq" value="<c:out value="${condition.srchCategoryOrganizationSeq}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
    <input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />

    <input type="hidden" name="courseMasterSeq"/>
    <input type="hidden" name="srchCompleteDivisionCd"   value="<c:out value="${condition.srchCompleteDivisionCd}"/>" />
    <input type="hidden" name="srchCourseStatusCd" value="<c:out value="${condition.srchCourseStatusCd}"/>" />
    <input type="hidden" name="srchCategoryOrganizationSeq" value="<c:out value="${condition.srchCategoryOrganizationSeq}"/>" />
    <input type="hidden" name="srchCategoryTypeCd"   value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
    <input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>"/>
</form>