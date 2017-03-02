<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:토론:제목"/>,regMemberName=<spring:message code="필드:토론:등록자"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search mt10">
		<fieldset>
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
            <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>" />
            <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>" />
            <input type="hidden" name="discussSeq" value="<c:out value="${param['discussSeq']}"/>" />
            <input type="hidden" name="discussStatus" value="<c:out value="${param['discussStatus']}"/>" />

			<select name="srchBbsTypeCd" class="select">
				<option value=""><spring:message code="필드:토론:의견구분"/></option>
				<aof:code type="option" codeGroup="DISCUSS_BBS_TYPE" selected="${condition.srchBbsTypeCd}"/>
			</select>
			
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>

			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
			
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  		value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchTargetRolegroup" value="<c:out value="${condition.srchTargetRolegroup}"/>" />
    
    <input type="hidden" name="discussSeq" value="<c:out value="${param['discussSeq']}"/>" />
    <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>" />
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>" />
    <input type="hidden" name="discussStatus" value="<c:out value="${param['discussStatus']}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  		value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchTargetRolegroup" value="<c:out value="${condition.srchTargetRolegroup}"/>" />
	<input type="hidden" name="bbsSeq" />
    
    <input type="hidden" name="discussSeq" value="<c:out value="${param['discussSeq']}"/>" />
    <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>" />
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>" />
    <input type="hidden" name="discussStatus" value="<c:out value="${param['discussStatus']}"/>" />
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    		value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        		value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        		value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        		value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       		value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchBbsTypeCd"  		value="<c:out value="${condition.srchBbsTypeCd}"/>" />
	<input type="hidden" name="srchTargetRolegroup" value="<c:out value="${condition.srchTargetRolegroup}"/>" />
	<input type="hidden" name="parentSeq" />
    
    <input type="hidden" name="discussSeq" value="<c:out value="${param['discussSeq']}"/>" />
    <input type="hidden" name="courseApplySeq" value="<c:out value="${param['courseApplySeq']}"/>" />
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>" />
    <input type="hidden" name="discussStatus" value="<c:out value="${param['discussStatus']}"/>" />
</form>
