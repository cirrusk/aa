<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
	    <input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
		<input type="hidden" name="srchReferenceSeq" value="${condition.srchReferenceSeq}"/>
		<input type="hidden" name="activeElementSeq" value="${detail.element.activeElementSeq}"/>
		<input type="hidden" name="courseTypeCd" value="<c:out value="${condition.courseTypeCd}"/>"/>
		<input type="hidden" name="organizationSeq" value="<c:out value="${param['organizationSeq']}"/>"/>
		<input type="hidden" name="itemSeq" value="<c:out value="${param['itemSeq']}"/>"/>
	    
	    <spring:message code="필드:교과목:학부"/> : 
		<input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>

		<select name="srchKey" class="select">
			<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
		</select>
		<input type="text" name="srchWord" value="${condition.srchWord}" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
		<a href="#" onclick="javascript:doSearch();" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
	</div> 
</form>

<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="referenceSeq" value="${condition.srchReferenceSeq}"/>
	<input type="hidden" name="courseTypeCd" value="<c:out value="${condition.courseTypeCd}"/>"/>
	<input type="hidden" name="organizationSeq" value="<c:out value="${param['organizationSeq']}"/>"/>
	<input type="hidden" name="itemSeq" value="<c:out value="${param['itemSeq']}"/>"/>
	<input type="hidden" name="courseApplySeq" />
	<input type="hidden" name="memberSeq" />
	<input type="hidden" name="learnerId" />
	<input type="hidden" name="memberName" />
</form>


