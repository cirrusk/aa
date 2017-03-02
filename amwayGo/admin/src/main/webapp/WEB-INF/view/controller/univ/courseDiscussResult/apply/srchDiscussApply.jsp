<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
	    <input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${condition.courseActiveSeq}"/>"/>
		<input type="hidden" name="activeElementSeq" value="${condition.activeElementSeq}"/>
		<input type="hidden" name="discussSeq" value="<c:out value="${condition.discussSeq}"/>"/>
		<input type="hidden" name="courseTypeCd" value="${condition.courseTypeCd}"/>
	    
	    <spring:message code="필드:교과목:학부"/> : 
		<input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:100px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>

		<select name="srchKey" class="select">
			<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
		</select>
		<input type="text" name="srchWord" value="${condition.srchWord}" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
		<a href="#" onclick="javascript:doSearch();" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
	</div> 
</form>

<form name="FormBbsList" id="FormBbsList" method="post" onsubmit="return false;">
	<input type="hidden" name="applyCurrentPage"  		value="<c:out value="${condition.currentPage}"/>" /> <%-- 1 or 0(전체) --%>
	<input type="hidden" name="applyCerPage"      		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="applyOrderby"      		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="applySrchCategoryName"   value="<c:out value="${condition.srchCategoryName}"/>" />
	<input type="hidden" name="applySrchKey"      		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="applySrchWord"      		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="courseActiveSeq" value="${condition.courseActiveSeq}"/>
	<input type="hidden" name="discussSeq" value="${condition.discussSeq}"/>
	<input type="hidden" name="activeElementSeq" value="${condition.activeElementSeq}"/>
	<input type="hidden" name="srchRegMemberSeq" value=""/>
	<input type="hidden" name="courseTypeCd" value="${condition.courseTypeCd}"/>
</form>