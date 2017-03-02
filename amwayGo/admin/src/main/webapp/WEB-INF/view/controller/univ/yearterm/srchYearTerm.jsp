<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <div class="lybox search">
        <fieldset>
        <div class="vspace"></div>
        
        <!-- 년도학기 Select Include Area Start -->
        <select name="srchYearTerm">
            <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
        </select>
        <!-- 년도학기 Select Include Area End -->
        
        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
</form>