<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>
<c:set var="srchKey">title=<spring:message code="필드:게시판:제목"/>,description=<spring:message code="필드:게시판:내용"/>,regMemberName=<spring:message code="필드:등록자"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset class="align-l">
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="srchReplyOnlyCheckYn" value="${condition.srchReplyOnlyCheckYn}" />
			
			<select name="srchCategoryTypeCd" class="select" onchange="doSelectCategoryType(this);">
				<aof:code type="option" codeGroup="CATEGORY_TYPE" selected="${condition.srchCategoryTypeCd}"/>
			</select>

		    <c:choose>
                <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
					<span id="yearTerm">
	                    <select id="srchYearTerm" name="srchYearTerm">
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
	                    </select>
                    </span>
			        <span id="year" style="display: none;">              
	                    <select id="srchYear" name="srchYear">
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearInc.jsp"></c:import>
	                    </select>
                    </span>
                </c:when>
                <c:otherwise>
					<span id="yearTerm" style="display: none;">
	                    <select name="srchYearTerm">
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearTermInc.jsp"></c:import>
	                    </select>
                    </span>
			        <span id="year" >              
	                    <select name="srchYear">
	                        <c:import url="/WEB-INF/view/controller/univ/include/yearInc.jsp"></c:import>
	                    </select>
                    </span>
                </c:otherwise>
            </c:choose>
            
			<span>
				<input type="text" name="srchCourseTitle" value="${condition.srchCourseTitle}" style="width:220px;">
				<span class="comment"><spring:message code="필드:교과목:교과목명"/></span>
			</span>
			
			<div class="vspace"></div>
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchReplyOnlyCheckYn" value="${condition.srchReplyOnlyCheckYn}" />
	
	<input type="hidden" name="srchCategoryTypeCd"  value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
	<input type="hidden" name="srchYearTerm"  value="<c:out value="${condition.srchYearTerm}"/>" />
	<input type="hidden" name="srchYear"  value="<c:out value="${condition.srchYear}"/>" />
	<input type="hidden" name="srchCourseTitle"  value="<c:out value="${condition.srchCourseTitle}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchReplyOnlyCheckYn" value="${condition.srchReplyOnlyCheckYn}" />
	
	<input type="hidden" name="srchCategoryTypeCd"  value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
	<input type="hidden" name="srchYearTerm"  value="<c:out value="${condition.srchYearTerm}"/>" />
	<input type="hidden" name="srchYear"  value="<c:out value="${condition.srchYear}"/>" />
	<input type="hidden" name="srchCourseTitle"  value="<c:out value="${condition.srchCourseTitle}"/>" />
	
	<input type="hidden" name="bbsSeq"/>
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchReplyOnlyCheckYn" value="${condition.srchReplyOnlyCheckYn}" />
	
	<input type="hidden" name="parentSeq" />
	<input type="hidden" name="parentSecretYn" />
	
	<input type="hidden" name="srchCategoryTypeCd"  value="<c:out value="${condition.srchCategoryTypeCd}"/>" />
	<input type="hidden" name="srchYearTerm"  value="<c:out value="${condition.srchYearTerm}"/>" />
	<input type="hidden" name="srchYear"  value="<c:out value="${condition.srchYear}"/>" />
	<input type="hidden" name="srchCourseTitle"  value="<c:out value="${condition.srchCourseTitle}"/>" />
</form>

<form name="FormEditBoard" id="FormEditBoard" method="post" onsubmit="return false;">
	<input type="hidden" name="boardSeq" value=""/>
	<input type="hidden" name="callback" value="doList"/>
</form>

<form name="FormApplyDetail" id="FormApplyDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="courseApplySeq"/>
	<input type="hidden" name="courseActiveSeq"/>
</form>	