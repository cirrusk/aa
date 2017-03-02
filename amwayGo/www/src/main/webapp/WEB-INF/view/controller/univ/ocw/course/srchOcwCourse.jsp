<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">courseActiveTitle=<spring:message code="필드:개설과목:과목명"/>,offerName=<spring:message code="필드:OCW:제공자"/>,profMemberName=<spring:message code="필드:OCW:강사"/>,keyword=<spring:message code="필드:개설과목:키워드"/></c:set>

<form name="FormSrch" id="FormSrch" method="get" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
			
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>

			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn btn-green"><span class="mid"><spring:message code="버튼:검색" /><span></a>
		</fieldset>
	</div>
	
	<input type="hidden" name="categoryOcwDepth2Seq" value="<c:out value="${categoryOcwDepth2Seq}"/>">
	<input type="hidden" name="categoryOcwDepth3Seq" value="<c:out value="${categoryOcwDepth3Seq}"/>">
	<input type="hidden" name="srchCategorySeq" value="<c:out value="${srchCategorySeq}"/>">
	<input type="hidden" name="srchGroupOrder" value="<c:out value="${srchGroupOrder}"/>">
	<input type="hidden" name="currentMenuId" value="002">
</form>

<form name="FormList" id="FormList" method="get" onsubmit="return false;">
	<input type="hidden" name="currentPage"    		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       		value="<c:out value="${condition.srchWord}"/>" />
    
    <input type="hidden" name="categoryOcwDepth2Seq" value="<c:out value="${categoryOcwDepth2Seq}"/>">
	<input type="hidden" name="categoryOcwDepth3Seq" value="<c:out value="${categoryOcwDepth3Seq}"/>">
	<input type="hidden" name="srchCategorySeq" value="<c:out value="${srchCategorySeq}"/>">
	<input type="hidden" name="srchGroupOrder" value="<c:out value="${srchGroupOrder}"/>">
	<input type="hidden" name="currentMenuId" value="002">
</form>

<form name="FormDetail" id="FormDetail" method="get" onsubmit="return false;">
	<input type="hidden" name="currentPage"    		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="ocwCourseActiveSeq"  value="<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}"/>" />
	<input type="hidden" name="courseActiveSeq"  	value="<c:out value="${detail.courseActive.courseActiveSeq}"/>" />
    
    <input type="hidden" name="categoryOcwDepth2Seq" value="<c:out value="${categoryOcwDepth2Seq}"/>">
	<input type="hidden" name="categoryOcwDepth3Seq" value="<c:out value="${categoryOcwDepth3Seq}"/>">
	<input type="hidden" name="srchCategorySeq" value="<c:out value="${srchCategorySeq}"/>">
	<input type="hidden" name="srchGroupOrder" value="<c:out value="${srchGroupOrder}"/>">
	<input type="hidden" name="currentMenuId" value="002">
</form>

<form name="FormContentsItem" id="FormContentsItem" method="get" onsubmit="return false;">
	<input type="hidden" name="currentPage"    		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="ocwCourseActiveSeq"  value="<c:out value="${detail.ocwCourse.ocwCourseActiveSeq}"/>" />
	<input type="hidden" name="courseActiveSeq"  	value="<c:out value="${detail.courseActive.courseActiveSeq}"/>" />
	<input type="hidden" name="activeElementSeq"  	value="" />
	<input type="hidden" name="organizationSeq"  	value="" />
	<input type="hidden" name="itemSeq"  	value="" />
    
    <input type="hidden" name="categoryOcwDepth2Seq" value="<c:out value="${categoryOcwDepth2Seq}"/>">
	<input type="hidden" name="categoryOcwDepth3Seq" value="<c:out value="${categoryOcwDepth3Seq}"/>">
	<input type="hidden" name="srchCategorySeq" value="<c:out value="${srchCategorySeq}"/>">
	<input type="hidden" name="srchGroupOrder" value="<c:out value="${srchGroupOrder}"/>">
	<input type="hidden" name="currentMenuId" value="002">
</form>