<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>

<form name="SubFormSrch" id="SubFormSrch" method="post" onsubmit="return false;">
	<input type="hidden" name="srchCfString"  			value="<c:out value="${condition.srchCfString}"/>"/>
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="srchRolegroupSeq" value="<c:out value="${condition.srchRolegroupSeq}"/>" />
			<div class="vspace"></div>
			<select name="srchMemberStatusCd">
				<option value=""><spring:message code="필드:멤버:상태"/></option>
				<aof:code type="option" codeGroup="MEMBER_STATUS" selected="${condition.srchMemberStatusCd}"/>
			</select>
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSubSearch);"/>
			<a href="#" onclick="doSubSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			<a href="#" onclick="doSubSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
		</fieldset>
	</div>
</form>

<form name="SubFormList" id="SubFormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" 			value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     			value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     			value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     			value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    			value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchRolegroupSeq" 		value="<c:out value="${condition.srchRolegroupSeq}"/>" />
	<input type="hidden" name="srchMemberStatusCd"     	value="<c:out value="${condition.srchMemberStatusCd}"/>" />
	<input type="hidden" name="srchCompanySeq"   		value="<c:out value="${condition.srchCompanySeq}"/>"/>
	<input type="hidden" name="srchCompanyName"  		value="<c:out value="${condition.srchCompanyName}"/>"/>
	<input type="hidden" name="srchCfString"  			value="<c:out value="${condition.srchCfString}"/>"/>
</form>

<form name="SubFormDetail" id="SubFormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="memberSeq" />
</form>

<form name="SubFormInsert" id="SubFormInsert" method="post" onsubmit="return false;">
	<input type="hidden" name="rolegroupSeq" value="<c:out value="${condition.srchRolegroupSeq}"/>" />
</form>

<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSubInsert"/>
	<input type="hidden" name="select" value="multiple"/>
	<input type="hidden" name="srchNotInRolegroupSeq" value="${condition.srchRolegroupSeq}"/>
</form>

