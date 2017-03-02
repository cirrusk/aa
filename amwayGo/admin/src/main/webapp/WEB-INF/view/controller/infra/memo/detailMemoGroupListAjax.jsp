<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
	<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 250px" />	
			<col style="width: auto" />
			<col style="width: 250px" />		
		</colgroup>
		<thead>
			<tr>
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormDetailList','checkkeys','checkButton');" /></th>
				<th><spring:message code="필드:멤버:이름"/></th>
				<th><spring:message code="필드:이메일"/></th>
				<th><spring:message code="필드:아이디"/></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
					<input type="hidden" name="addressSeqs" value ="<c:out value="${row.memoAddress.addressSeq}"/>">
					<input type="hidden" name="memberNames" value ="<c:out value="${row.member.memberName}"/>">
					<input type="hidden" name="memberSeqs" value ="<c:out value="${row.memoAddress.memberSeq}"/>">
				</td>
		        <td><c:out value="${row.member.memberName}"/></td>
				<td><c:out value="${row.member.email}"/></td>
				<td><c:out value="${row.member.memberId}"/></td>
			</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
			<tr>
				<td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
		</tbody>
	</table>
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	<ul class="buttons">	
		<li class="left" id="checkButton" style="display:none;">
			<c:if test="${!empty paginate.itemList}">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
					<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
				</c:if>
			</c:if>
		</li>
		<li class="right">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsertMember()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:인원추가" /></span></a>
				<a href="javascript:void(0)" onclick="doCreateMemo()" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지:쪽지쓰기" /></span></a>
			</c:if>
				<a href="javascript:void(0)" onclick="doList()" class="btn blue"><span class="mid"><spring:message code="버튼:목록" /></span></a>
		</li>
	</ul>