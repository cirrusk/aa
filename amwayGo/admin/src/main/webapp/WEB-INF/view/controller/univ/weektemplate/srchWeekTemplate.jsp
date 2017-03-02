<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="calculationYn" value="N"><!-- 계산여부 -->
    <div class="lybox search">
        <fieldset>
        <div class="vspace"></div>
        
        <!-- 년도학기 Select Include Area Start -->
        <select name="srchYearTerm">
            <c:import url="../include/yearTermInc.jsp"></c:import>
        </select>
        <!-- 년도학기 Select Include Area End -->
        
        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
        </fieldset>
    </div>
    
    <div style="font-weight: bold; margin-bottom: 5px; margin-left: 3px;">
		<spring:message code="필드:년도학기:학습기간"/> : <aof:date datetime="${detail.univYearTerm.studyStartDate}"/> ~ <aof:date datetime="${detail.univYearTerm.studyEndDate}"/>
	</div>

	<div class="lybox search">
	    <fieldset>
	    <div class="vspace"></div>
	    <spring:message code="필드:주차템플릿:개강일"/>&nbsp;
	    <input type="text" name="studyStartDate" id="studyStartDate" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.studyStartDate}"/>" readonly="readonly">
	     ~ <input type="text" name="dayCount" id="dayCount" value="7" size="5" class="align-r" class="align-r">
	    <spring:message code="글:주차템플릿:일간격으로"/>&nbsp;
	   
	    <c:if test="${paginate.totalCount eq 0}">
	    	<input type="text" name="weekCount" id="weekCount" value="15" size="5" class="align-r"><!-- 기본값은 15주차 고정 -->
	    	<spring:message code="필드:주차템플릿:주차"/>&nbsp;
	    	<a href="#" onclick="doCalculationList()" class="btn black"><span class="mid"><spring:message code="버튼:주차템플릿:일괄생성"/></span></a>
	    </c:if>
	    <c:if test="${paginate.totalCount ne 0}">
	    	<input type="text" name="weekCount" id="weekCount" value="<c:out value="${paginate.totalCount}"/>" size="5" class="align-r">
	    	<spring:message code="필드:주차템플릿:주차"/>&nbsp;
	    	<a href="#" onclick="doCalculationList()" class="btn black"><span class="mid"><spring:message code="버튼:주차템플릿:재생성"/></span></a>
	    </c:if>
	    </fieldset>
	</div>
	
	<div style="margin-bottom: 5px; color: red;"><spring:message code="글:주차템플릿:주차를설정하지않으면학사DB연동할수없습니다.주차를생성하시고학사DB를연동하시기바랍니다."/></div>
</form>
