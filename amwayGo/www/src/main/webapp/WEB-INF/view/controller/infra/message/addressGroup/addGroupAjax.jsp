<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
<input type="hidden" name="callback" value="doAddReceiver"/>
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
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
		<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: auto" />
		<col style="width: 120px" />		
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
			<th><spring:message code="글:쪽지:그룹명" /></th>
			<th><spring:message code="글:쪽지:인원" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<c:choose>
					<c:when test="${row.messageAddressGroup.memberCount > 0}">
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" >				
						<input type="hidden" name="addressGroupSeqs" value ="<c:out value="${row.messageAddressGroup.addressGroupSeq}"/>">
						<input type="hidden" name="groupNames" value ="<c:out value="${row.messageAddressGroup.groupName}"/>">	
					</c:when>
					<c:otherwise>
						-
					</c:otherwise>
				</c:choose>
				
			</td>
	        <td><c:out value="${row.messageAddressGroup.groupName }" /></td>
			<td>
				<input type="hidden" name="counts" value="<c:out value="${row.messageAddressGroup.memberCount }" />">
				<c:out value="${row.messageAddressGroup.memberCount }" />
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
		<a href="javascript:void(0)" onclick="doSelectGroup()" class="btn blue"><span class="mid"><spring:message code="버튼:추가" /></span></a>			
	</li>
</ul>