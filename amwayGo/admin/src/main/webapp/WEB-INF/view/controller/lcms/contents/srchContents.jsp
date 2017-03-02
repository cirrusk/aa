<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:콘텐츠:콘텐츠그룹명"/>,description=<spring:message code="필드:콘텐츠:설명"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<span>
				<input type="text"   name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:300px;"/>
				<span class="comment"><spring:message code="필드:콘텐츠:분류명"/></span>
			</span>
			
			<div class="vspace"></div>
			<select name="srchStatusCd">
				<option value=""><spring:message code="필드:콘텐츠:상태"/></option>
				<aof:code type="option" codeGroup="CONTENTS_STATUS_TYPE" selected="${condition.srchStatusCd}"/>
			</select>
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" />
	<input type="hidden" name="srchStatusCd"     value="<c:out value="${condition.srchStatusCd}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" />
	<input type="hidden" name="srchStatusCd"     value="<c:out value="${condition.srchStatusCd}"/>" />

	<input type="hidden" name="contentsSeq" />
</form>

<form name="FormCreateOrg" id="FormCreateOrg" method="post" onsubmit="return false;">
	<input type="hidden" name="contentsSeq" />
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="contentsTypeCd" />
	<input type="hidden" name="title" />
</form>

<form name="FormItemList" id="FormItemList" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
</form>

<form name="FormOrgDetail" id="FormOrgDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(orgDetailMenuId)}"/>"/>
</form>

<form name="FormLearning" id="FormLearning" method="post" onsubmit="return false;">
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="itemSeq" />
	<input type="hidden" name="itemIdentifier" />
	<input type="hidden" name="courseId" />
	<input type="hidden" name="applyId" />
	<input type="hidden" name="width" />
	<input type="hidden" name="height" />
</form>
