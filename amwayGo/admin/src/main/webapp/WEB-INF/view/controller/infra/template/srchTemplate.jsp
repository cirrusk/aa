<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:게시판:제목"/>,description=<spring:message code="필드:게시판:내용"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset class="align-l">
			<input type="hidden" name="currentPage"  value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
			
			<div>
				<strong><spring:message code="필드:템플릿:템플릿타입" />:</strong>
				<select name="srchMessageTemplateType" class="select">
					<option value=""><spring:message code="필드:전체" /></option>
					<aof:code type="option" codeGroup="MESSAGE_TEMPLATE_TYPE" selected="${condition.srchMessageTemplateType}" />
				</select>
			</div>
			<div>
			<strong><spring:message code="필드:템플릿:사용여부" />:</strong>
			<select name="srchUseYn" class="select">
				<option value=""><spring:message code="필드:전체" /></option>
				<aof:code type="option" codeGroup="YESNO" selected="${condition.srchUseYn}" ref="2" />
			</select>
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
			</div>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchMessageTemplateType"     value="<c:out value="${condition.srchMessageTemplateType}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchMessageTemplateType"     value="<c:out value="${condition.srchMessageTemplateType}"/>" />
	
	<input type="hidden" name="templateSeq" />
</form>

<form name="FormCreate" id="FormCreate" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchMessageTemplateType"     value="<c:out value="${condition.srchMessageTemplateType}"/>" />
</form>
