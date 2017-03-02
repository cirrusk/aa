<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="srchKey">projectName=<spring:message code="필드:CDMS:과정명"/>,studioName=<spring:message code="필드:CDMS:스튜디오"/>,regMemberName=<spring:message code="필드:CDMS:예약자"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			
			<strong><spring:message code="필드:CDMS:기간"/></strong>
			<input type="text" name="srchStartDate" id="srchStartDate" value="<aof:date datetime="${condition.srchStartDate}"/>" style="width:80px;text-align:center;" readonly="readonly">
			~
			<input type="text" name="srchEndDate" id="srchEndDate" value="<aof:date datetime="${condition.srchEndDate}"/>" style="width:80px;text-align:center;" readonly="readonly">
			
			<strong><spring:message code="필드:CDMS:스튜디오"/></strong>
			<select name="srchStudioSeq" style="width: 100px;">
				<option value=""></option>
				<c:forEach var="row" items="${listStudio}" varStatus="i">
					<option value="<c:out value="${row.studio.studioSeq}"/>"
						<c:out value="${row.studio.studioSeq eq condition.srchStudioSeq ? 'selected' : ''}"/>
					><c:out value="${row.studio.studioName}"/></option>
				</c:forEach>
			</select>
			<div class="vspace"></div>
			
			<spring:message code="필드:CDMS:개발그룹" />
			<input type="text" id="srchProjectGroupName" name="srchProjectGroupName" readonly="readonly" value="<c:out value="${condition.srchProjectGroupName }" />" />
			<input type="hidden" id="srchProjectGroupSeq" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq }" />" />
			<a href="javascript:void(0)" onclick="doBrowseProjectGroup()" class="btn black"><span class="mid"><spring:message code="버튼:선택" /></span></a>
			<div class="vspace"></div>
			
			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="javascript:void(0)" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchStartDate"  value="<aof:date datetime="${condition.srchStartDate}"/>" />
	<input type="hidden" name="srchEndDate"    value="<aof:date datetime="${condition.srchEndDate}"/>" />
	<input type="hidden" name="srchStudioSeq"  value="<c:out value="${condition.srchStudioSeq}"/>" />
	<input type="hidden" name="srchProjectGroupName" value="<c:out value="${condition.srchProjectGroupName }" />" />
	<input type="hidden" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq }" />" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchStartDate"  value="<aof:date datetime="${condition.srchStartDate}"/>" />
	<input type="hidden" name="srchEndDate"    value="<aof:date datetime="${condition.srchEndDate}"/>" />
	<input type="hidden" name="srchStudioSeq"  value="<c:out value="${condition.srchStudioSeq}"/>" />
	<input type="hidden" name="srchProjectGroupName" value="<c:out value="${condition.srchProjectGroupName }" />" />
	<input type="hidden" name="srchProjectGroupSeq" value="<c:out value="${condition.srchProjectGroupSeq }" />" />

	<input type="hidden" name="workSeq" />
</form>

<form name="FormBrowseProjectGroup" id="FormBrowseProjectGroup" method="post" onsubmit="return false;">
	<input type="hidden" name="callback" value="doSetProjectGroup"/>
</form>
