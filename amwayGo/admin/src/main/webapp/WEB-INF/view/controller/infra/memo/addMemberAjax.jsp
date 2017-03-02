<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="srchKey">memberName=<spring:message code="필드:멤버:이름"/>,memberId=<spring:message code="필드:멤버:아이디"/></c:set>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
<input type="hidden" name="callback" value="doAddReceiver"/>
<input type="hidden" name="addGroupSeq" value="<c:out value="${add.addGroupSeq}"/>">	
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
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
	<input type="hidden" name="addressGroupSeq" value="<c:out value="${messageAddress.addressGroupSeq}"/>">
	<input type="hidden" name="callback" value="doAddReceiver"/>
</form>

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="callback" value="doAddReceiver"/>	
<input type="hidden" name="addressGroupSeq" id="addressGroupSeq" value="<c:out value="${messageAddress.addressGroupSeq}"/>">
	<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 200px" />
			<col style="width: auto;" />
			<col style="width: 200px" />
			<col style="width: 200px" />
		</colgroup>
		<thead>
			<tr>
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>					
				<th><spring:message code="필드:멤버:이름" /></th>
				<th><spring:message code="필드:멤버:아이디" /></th>
				<th><spring:message code="필드:멤버:아이디" /></th>
				<th><spring:message code="필드:멤버:아이디" /></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<td><input type="checkbox" name="checkkeys" value="<c:out value="${i.index}" />">
					<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
					<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">			        	
				</td>
				<td><aof:text type="text" value="${row.member.memberName}" /></td>
		        <td><c:out value="${row.member.memberId}"/></td>
		        <td><c:out value="${row.member.memberEmsTypeCd}"/></td>
		        <td><c:out value="${row.member.organizationString}"/></td>
			</tr>
		</c:forEach>			
		<c:if test="${empty paginate.itemList}">
			<tr>
				<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
		</tbody>
	</table>
</form>
<c:import url="/WEB-INF/view/include/paging.jsp">
	<c:param name="paginate" value="paginate"/>
</c:import>
<ul class="buttons">	
	<li class="right">
		<a href="javascript:void(0)" onclick="doSelectMember()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>			
	</li>
</ul>