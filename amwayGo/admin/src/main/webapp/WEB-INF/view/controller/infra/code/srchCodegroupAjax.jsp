<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="SubFormList" id="SubFormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchCodeGroup" value="<c:out value="${condition.srchCodeGroup}"/>" />
</form>

<form name="SubFormDetail" id="SubFormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSubList"/>
	<input type="hidden" name="codeGroup" />
	<input type="hidden" name="code" />
</form>

<form name="SubFormInsert" id="SubFormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="srchCodeGroup" value="<c:out value="${condition.srchCodeGroup}"/>" />
</form>

<form name="FormBrowseCode" id="FormBrowseCode" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSubList" id="callback"/>
	<input type="hidden" name="select" value="multiple"/>
	<input type="hidden" name="srchCodeGroup" value="${condition.srchCodeGroup}"/>
</form>