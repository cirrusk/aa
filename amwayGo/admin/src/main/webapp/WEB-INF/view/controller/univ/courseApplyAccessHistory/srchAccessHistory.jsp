<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset class="align-l">
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="srchYn" value="Y" default="Y"/>

			<select name="srchCategoryTypeCd" class="select" onchange="doSelectCategoryType(this);">
			    <option value=""><spring:message code="필드:개설과목:학위구분"/></option>
				<aof:code type="option" codeGroup="CATEGORY_TYPE" selected="${condition.srchCategoryTypeCd}"/>
			</select>			
			
		    <c:choose>
                <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
					<span id="yearTerm">
	                    <select id="srchYearTerm" name="srchYearTerm">
	                    	<option value=""><spring:message code="필드:년도학기:구분"/></option>
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
	                    </select>
                    </span>
			        <span id="year" style="display: none;">              
	                    <select id="srchYear" name="srchYear">
	                    	<option value=""><spring:message code="필드:년도학기:구분"/></option>
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearInc.jsp"></c:import>
	                    </select>
                    </span>
                </c:when>
                <c:otherwise>
					<span id="yearTerm" style="display: none;">
	                    <select id="srchYearTerm" name="srchYearTerm">
	                    	<option value=""><spring:message code="필드:년도학기:구분"/></option>
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
	                    </select>
                    </span>
			        <span id="year" >              
	                    <select id="srchYear" name="srchYear">
							<option value=""><spring:message code="필드:년도학기:구분"/></option>
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearInc.jsp"></c:import>
	                    </select>
                    </span>
                </c:otherwise>
            </c:choose>
            
			<div class="vspace"></div>
			
			<div>
				<span>
				<spring:message code="필드:모니터링:대상기간"/> : 
					<input type="text" name="srchStartRegDate" id="srchStartRegDate" value="<aof:date datetime="${condition.srchStartRegDate}"/>" class="datepicker" readonly="readonly">
		                ~
		            <input type="text" name="srchEndRegDate" id="srchEndRegDate" value="<aof:date datetime="${condition.srchEndRegDate}"/>" class="datepicker" readonly="readonly">
				</span>
			</div>

			<div class="vspace"></div>
			
			<span>
				<input type="text" name="srchCourseTitle" value="${condition.srchCourseTitle}" style="width:220px;" onkeyup="UT.callFunctionByEnter(event, doSearch);">
				<span class="comment"><spring:message code="필드:교과목:교과목명"/></span>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
			</span>
			
		</fieldset>
	</div>
</form>
