<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/>,organization=<spring:message code="필드:멤버:소속"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox">
		<fieldset>
		<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />

		<div class="vspace"></div>
		<c:if test="${memberType eq 'admin' or memberType eq 'prof'}">
			<select name="srchMemberStatusCd" class="select">
				<option value=""><spring:message code="필드:멤버:계정상태"/></option>
				<aof:code type="option" codeGroup="MEMBER_STATUS" selected="${condition.srchMemberStatusCd}" />
			</select>
		</c:if>
		
		<c:if test="${memberType eq 'user' }">
			<%-- <select name="srchMemberEmsTypeCd" class="select">
				<option value=""><spring:message code="필드:멤버:회원구분"/></option>
				<aof:code type="option" codeGroup="MEMBER_EMP_TYPE" selected="${condition.srchMemberEmsTypeCd}" />
			</select>--%>
<%-- 			<select name="srchPosition" class="select">
				<option value=""><spring:message code="필드:멤버:직급"/></option>
				<aof:code type="option" codeGroup="POSITION" selected="${condition.srchPosition}" />
			</select> --%>
			
		</c:if>
		
		<c:if test="${memberType eq 'cdms' }">
			<select name="srchCdmsTaskTypeCd" class="select">
				<option value=""><spring:message code="필드:멤버:업무"/></option>
				<aof:code type="option" codeGroup="CDMS_TASK" selected="${condition.srchCdmsTaskTypeCd}" />
			</select>
		</c:if>
		<select name="srchKey" class="select">
			<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
		</select>
		<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
		<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	
	<input type="hidden" name="srchMemberStatusCd"		value="<c:out value="${condition.srchMemberStatusCd}"/>" />
	<input type="hidden" name="srchMemberEmsTypeCd"		value="<c:out value="${condition.srchMemberEmsTypeCd}"/>" />
	<input type="hidden" name="srchStudentStatusCd"		value="<c:out value="${condition.srchStudentStatusCd}"/>" />
	<input type="hidden" name="srchCdmsTaskTypeCd"		value="<c:out value="${condition.srchCdmsTaskTypeCd}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	
	<input type="hidden" name="srchMemberStatusCd"		value="<c:out value="${condition.srchMemberStatusCd}"/>" />
	<input type="hidden" name="srchMemberEmsTypeCd"		value="<c:out value="${condition.srchMemberEmsTypeCd}"/>" />
	<input type="hidden" name="srchStudentStatusCd"		value="<c:out value="${condition.srchStudentStatusCd}"/>" />
	<input type="hidden" name="srchCdmsTaskTypeCd"		value="<c:out value="${condition.srchCdmsTaskTypeCd}"/>" />

	<input type="hidden" name="memberSeq" />
</form>

<form name="FormSMS" id="FormSMS" method="post" onsubmit="return false;">
</form>

<form name="FormUploadExcel" id="FormUploadExcel" method="post" onsubmit="return false;">
    <input type="hidden" name="callback" value="doSearch"/>
</form>