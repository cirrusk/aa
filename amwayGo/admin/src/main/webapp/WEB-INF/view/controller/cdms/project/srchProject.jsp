<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">projectName=<spring:message code="필드:CDMS:과정명"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<spring:message code="필드:CDMS:개발그룹" />
			<input type="text" id="srchProjectGroupName" name="srchProjectGroupName" readonly="readonly" value="${condition.srchProjectGroupName }" />
			<input type="hidden" id="srchProjectGroupSeq" name="srchProjectGroupSeq" value="${condition.srchProjectGroupSeq }" />
			<a href="javascript:void(0)" onclick="doBrowseProjectGroup()" class="btn black"><span class="mid"><spring:message code="버튼:선택" /></span></a>
			<div class="vspace"></div>
			<select name="srchProjectTypeCd">
				<option value=""><spring:message code="필드:CDMS:개발구분" /></option>
				<aof:code type="option" codeGroup="CDMS_PROJECT_TYPE" selected="${condition.srchProjectTypeCd}"/>
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
	<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	<input type="hidden" name="srchProjectGroupName" value="<c:out value="${condition.srchProjectGroupName}"/>" />
	<input type="hidden" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	<input type="hidden" name="srchProjectGroupName" value="<c:out value="${condition.srchProjectGroupName}"/>" />
	<input type="hidden" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq}"/>" />
	
	<input type="hidden" name="projectSeq" />
</form>

<form name="FormDetailSection" id="FormDetailSection" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	<input type="hidden" name="srchProjectGroupName" value="<c:out value="${condition.srchProjectGroupName}"/>" />
	<input type="hidden" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq}"/>" />

	<input type="hidden" name="projectSeq" value="<c:out value="${detailProject.project.projectSeq}"/>"/> <%-- 해당페이지 refresh 하기 위해 값 셋팅 --%>
	<input type="hidden" name="sectionIndex" value="<c:out value="${currentSectionIndex}"/>"/> <%-- 해당페이지 refresh 하기 위해 값 셋팅 --%>
	<input type="hidden" name="outputIndex"  value="<c:out value="${currentOutputIndex}"/>"/> <%-- 해당페이지 refresh 하기 위해 값 셋팅 --%>
</form>

<form name="FormDetailProcess" id="FormDetailProcess" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchProjectTypeCd" value="<c:out value="${condition.srchProjectTypeCd}"/>" />
	<input type="hidden" name="srchProjectGroupName" value="<c:out value="${condition.srchProjectGroupName}"/>" />
	<input type="hidden" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq}"/>" />

	<input type="hidden" name="projectSeq"/>
</form>
<form name="FormBrowseProjectGroup" id="FormBrowseProjectGroup" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSetProjectGroup"/>
</form>
