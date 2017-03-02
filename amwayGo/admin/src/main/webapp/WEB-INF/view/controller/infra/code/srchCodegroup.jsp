<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">codeName=<spring:message code="필드:코드:그룹코드명"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord"  value="<c:out value="${condition.srchWord}"/>" onkeydown="UT.callFunctionByEnter(event,doSearch)" style="width:200px;"/>
            <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
		</fieldset>
	</div>
</form>

<!-- 검색 및 리스트 -->
<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
</form>

<!--  상세 보기 -->
<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />

	<input type="hidden" name="codeGroup" />
	<input type="hidden" name="code" />
</form>

<!-- 그룹의 하위 코드 -->
<form name="FormSub" id="FormSub" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSubList" id="callback"/>
	<input type="hidden" name="srchCodeGroup" />
</form>