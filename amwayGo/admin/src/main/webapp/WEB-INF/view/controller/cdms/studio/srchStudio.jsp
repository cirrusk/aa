<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">studioName=<spring:message code="필드:CDMS:스튜디오명"/>,memberName=<spring:message code="필드:CDMS:담당자"/></c:set>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox">
		<fieldset>
		<select name="srchKey" class="select">
			<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
		</select>
		<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
		<a href="javascript:void(0);" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
		</fieldset>
	</div>
</form>
<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="srchWord" value="<c:out value="${condition.srchWord}" />" />
	<input type="hidden" name="srchKey" value="<c:out value="${condition.srchKey}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="studioSeq" />
	<input type="hidden" name="srchWord" value="<c:out value="${condition.srchWord}" />" />
	<input type="hidden" name="srchKey" value="<c:out value="${condition.srchKey}"/>" />
</form>

<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSetMember"/>
	<input type="hidden" name="select" value="multiple"/>
</form>