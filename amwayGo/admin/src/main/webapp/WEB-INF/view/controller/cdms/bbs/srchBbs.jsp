<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:게시판:제목"/>,description=<spring:message code="필드:게시판:내용"/>,regMemberName=<spring:message code="필드:등록자"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />

			<c:if test="${boardType eq 'dev'}">
				<strong><spring:message code="필드:CDMS:과정명" /></strong>
				<input type="hidden" name="srchProjectSeq" value="<c:out value="${condition.srchProjectSeq}"/>" />
				<input type="text" name="srchProjectName"  value="<c:out value="${condition.srchProjectName}"/>" style="width:345px;" readonly="readonly" />
				<a href="javascript:void(0)" onclick="doBrowseProject()" class="btn gray"><span class="small"><spring:message code="버튼:CDMS:과정선택" /><span></a>
		
				<div class="vspace"></div>
			</c:if>
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
			<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProjectSeq"   value="<c:out value="${condition.srchProjectSeq}"/>" />
	<input type="hidden" name="srchProjectName"  value="<c:out value="${condition.srchProjectName}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProjectSeq"   value="<c:out value="${condition.srchProjectSeq}"/>" />
	<input type="hidden" name="srchProjectName"  value="<c:out value="${condition.srchProjectName}"/>" />

	<input type="hidden" name="bbsSeq" />
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"    value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"        value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"        value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"        value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"       value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProjectSeq"   value="<c:out value="${condition.srchProjectSeq}"/>" />
	<input type="hidden" name="srchProjectName"  value="<c:out value="${condition.srchProjectName}"/>" />

	<input type="hidden" name="parentSeq"/>
</form>

<form id="FormBrowseProject" name="FormBrowseProject" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSetProject">
</form>
