<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <div class="lybox search">
        <fieldset>
        <div class="vspace"></div>
        
        <select name="srchStartYearTerm" id="srchStartYearTerm">
            <c:forEach var="yearRow" begin="2006" end="${appTodayYYYY+1}">
                <c:set var="tempYear" value="${yearRow}${term1st}"/>
                <option value="${tempYear}" <c:if test="${tempYear eq condition.srchStartYearTerm}">selected="selected"</c:if>>${yearRow}<spring:message code="필드:년도학기:년"/></option>
            </c:forEach>
        </select>
        ~
        <select name="srchEndYearTerm" id="srchEndYearTerm">
            <c:forEach var="yearRow" begin="2006" end="${appTodayYYYY+1}">
                <c:set var="tempYear" value="${yearRow}${term4th}"/>
                <option value="${tempYear}" <c:if test="${tempYear eq condition.srchEndYearTerm}">selected="selected"</c:if>>${yearRow}<spring:message code="필드:년도학기:년"/></option>
            </c:forEach>
        </select>
        
        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
</form>