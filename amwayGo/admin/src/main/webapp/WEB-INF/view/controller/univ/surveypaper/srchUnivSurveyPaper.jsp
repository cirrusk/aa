<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">title=<spring:message code="필드:설문:설문지제목"/>,description=<spring:message code="필드:설문:설문지설명"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			
			<select name="srchSurveyPaperTypeCd">
				<option value=""><spring:message code="필드:설문:설문지구분"/></option>
				<aof:code type="option" codeGroup="SURVEY_PAPER_TYPE" selected="${condition.srchSurveyPaperTypeCd}"/>
			</select>
			<select name="srchUseYn">
				<option value=""><spring:message code="필드:설문:사용여부"/></option>
				<aof:code type="option" codeGroup="YESNO" ref="2" selected="${condition.srchUseYn}" removeCodePrefix="true"/>
			</select>
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
<%-- 			<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a> --%>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchSurveyPaperTypeCd"  value="<c:out value="${condition.srchSurveyPaperTypeCd}"/>" />
	<input type="hidden" name="srchUseYn"   value="<c:out value="${condition.srchUseYn}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchSurveyPaperTypeCd"  value="<c:out value="${condition.srchSurveyPaperTypeCd}"/>" />
	<input type="hidden" name="srchUseYn"         value="<c:out value="${condition.srchUseYn}"/>" />

	<input type="hidden" name="surveyPaperSeq" />
</form>
