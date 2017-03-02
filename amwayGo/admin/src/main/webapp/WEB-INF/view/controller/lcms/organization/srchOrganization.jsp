<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:콘텐츠:주차제목"/></c:set>
<c:set var="srchMethod">like=Like,equals=Equals</c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<select name="srchContentsTypeCd" class="select">
				<option value=""><spring:message code="필드:콘텐츠:구분"/></option>
				<aof:code type="option" codeGroup="CONTENTS_TYPE" selected="${condition.srchContentsTypeCd}"/>
			</select>
			<select name="srchMetadataElementSeq" class="select">
				<option value=""><spring:message code="필드:콘텐츠:메타데이터"/></option>
				<c:forEach var="row" items="${listMetadataElement}" varStatus="i">
					<option value="<c:out value="${row.metadataElement.metadataElementSeq}"/>"
						<c:out value="${row.metadataElement.metadataElementSeq eq condition.srchMetadataElementSeq ? 'selected' : ''}"/>
					><c:out value="${row.metadataElement.metadataName}"/></option>
				</c:forEach>
			</select>
			<select name="srchMethod" class="select">
				<aof:code type="option" codeGroup="${srchMethod}" selected="${condition.srchMethod}"/>
			</select>
			<input type="text" name="srchMetadataValue" value="<c:out value="${condition.srchMetadataValue}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			
			<div class="vspace"></div>
			<select name="srchKey" class="select">
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
	<input type="hidden" name="srchContentsTypeCd"     value="<c:out value="${condition.srchContentsTypeCd}"/>" />
	<input type="hidden" name="srchMetadataElementSeq" value="<c:out value="${condition.srchMetadataElementSeq}"/>" />
	<input type="hidden" name="srchMethod"             value="<c:out value="${condition.srchMethod}"/>" />
	<input type="hidden" name="srchMetadataValue"      value="<c:out value="${condition.srchMetadataValue}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchContentsTypeCd"     value="<c:out value="${condition.srchContentsTypeCd}"/>" />
	<input type="hidden" name="srchMetadataElementSeq" value="<c:out value="${condition.srchMetadataElementSeq}"/>" />
	<input type="hidden" name="srchMethod"             value="<c:out value="${condition.srchMethod}"/>" />
	<input type="hidden" name="srchMetadataValue"      value="<c:out value="${condition.srchMetadataValue}"/>" />

	<input type="hidden" name="organizationSeq" />
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchContentsTypeCd"     value="<c:out value="${condition.srchContentsTypeCd}"/>" />
	<input type="hidden" name="srchMetadataElementSeq" value="<c:out value="${condition.srchMetadataElementSeq}"/>" />
	<input type="hidden" name="srchMethod"             value="<c:out value="${condition.srchMethod}"/>" />
	<input type="hidden" name="srchMetadataValue"      value="<c:out value="${condition.srchMetadataValue}"/>" />

	<input type="hidden" name="organizationSeq" />
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

<form name="FormItemDetail" id="FormItemDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="itemSeq" />
</form>

<form name="FormEditMetadata" id="FormEditMetadata" method="post" onsubmit="return false;">
	<input type="hidden" name="referenceSeq" />
</form>

<form name="FormCreateItem" id="FormCreateItem" method="post" onsubmit="return false;">
	<input type="hidden" name="contentsSeq" />
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="contentsTypeCd" />
	<input type="hidden" name="title" />
</form>

<form name="FormContentsDetail" id="FormContentsDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="contentsSeq" />
	<input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(contentsDetailMenuId)}"/>"/>
</form>
