<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">organizationTitle=<spring:message code="필드:콘텐츠:주차제목"/>,itemTitle=<spring:message code="필드:콘텐츠:교시제목"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="srchYn"      value="Y" default="Y"/>
			<input type="hidden" name="srchLearnerId"       value="<c:out value="${condition.srchLearnerId}"/>" />
			
			<strong><spring:message code="필드:콘텐츠:학습자"/></strong>
			<input type="text" name="srchLearnerName" value="<c:out value="${condition.srchLearnerName}"/>" style="width:80px;text-align:center;" readonly="readonly"/>
			<a href="javascript:void(0)" onclick="doBrowseMember()" class="btn gray"><span class="small"><spring:message code="버튼:콘텐츠:학습자선택"/></span></a>

			<strong><spring:message code="필드:콘텐츠:학습기간"/></strong>
			<input type="text" name="srchStartUpdDate" value="<aof:date datetime="${condition.srchStartUpdDate}"/>" id="srchStartUpdDate" style="width:80px;text-align:center;" readonly="readonly"/>
			~
			<input type="text" name="srchEndUpdDate" value="<aof:date datetime="${condition.srchEndUpdDate}"/>" id="srchEndUpdDate" style="width:80px;text-align:center;" readonly="readonly"/>
			
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
	<input type="hidden" name="srchYn"      value="Y" />
	<input type="hidden" name="srchLearnerId"    value="<c:out value="${condition.srchLearnerId}"/>" />
	<input type="hidden" name="srchLearnerName"  value="<c:out value="${condition.srchLearnerName}"/>" />
	<input type="hidden" name="srchStartUpdDate" value="<aof:date datetime="${condition.srchStartUpdDate}"/>" />
	<input type="hidden" name="srchEndUpdDate"   value="<aof:date datetime="${condition.srchEndUpdDate}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchYn"      value="Y" />
	<input type="hidden" name="srchLearnerId"    value="<c:out value="${condition.srchLearnerId}"/>" />
	<input type="hidden" name="srchLearnerName"  value="<c:out value="${condition.srchLearnerName}"/>" />
	<input type="hidden" name="srchStartUpdDate" value="<aof:date datetime="${condition.srchStartUpdDate}"/>" />
	<input type="hidden" name="srchEndUpdDate"   value="<aof:date datetime="${condition.srchEndUpdDate}"/>" />

	<input type="hidden" name="learnerId" />
	<input type="hidden" name="courseActiveSeq" />
	<input type="hidden" name="courseApplySeq" />
	<input type="hidden" name="organizationSeq" />
	<input type="hidden" name="itemSeq" />
</form>

<form name="FormBrowseMember" id="FormBrowseMember" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSetMember"/>
	<input type="hidden" name="select" value="single"/>
</form>