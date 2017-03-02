<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html decorator="ajax">
<body>
	
<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	<form id=FormInsertComment name="FormInsertComment" method="post" onsubmit="return false;">
		<input type="hidden" name="projectSeq"  value="<c:out value="${condition.srchProjectSeq}"/>" />
		<input type="hidden" name="sectionIndex"  value="<c:out value="${condition.srchSectionIndex}"/>" />
		<input type="hidden" name="outputIndex"   value="<c:out value="${condition.srchOutputIndex}"/>" />
		<input type="hidden" name="autoYn"      value="N" />
		
		<div class="group-comment">
			<table class="tbl-comment">
			<colgroup>
				<col style="width:60px" />
				<col style="width:auto" />
				<col style="width:75px" />
			</colgroup>
			<tr>
				<td>
					<div class="photo photo-40">
						<img src="${ssMemberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
					</div>
				</td>
				<td>
					<textarea name="description" style="width:100%; height:50px;"></textarea>
				</td>
				<td class="btn-area">
					<a href="javascript:void(0)" onclick="doInsertComment()" class="btn blue"><span class="mid"><spring:message code="버튼:등록"/></span></a>
				</td>
			</tr>
			</table>
		</div>
	</form>
</c:if>
	
<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
<div class="group-comment detail">
	<div class="thum">
		<c:set var="regMemberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
		<c:if test="${!empty row.member.photo}">
			<c:set var="regMemberPhoto" value ="${aoffn:config('upload.context.image')}${row.member.photo}.thumb.jpg"/>
		</c:if>
		<div class="photo photo-40">
			<img src="${regMemberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
		</div>
	</div>
	<div class="write">
		<div class="info">
			<div class="float-l">
				<span class="name"><c:out value="${row.member.memberName}"/>(<c:out value="${row.member.memberId}"/>)</span>
				<span class="date"><aof:date datetime="${row.comment.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
			</div>
			<c:if test="${row.comment.regMemberSeq eq ssMemberSeq and row.comment.autoYn ne 'Y'}">
				<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
					<div class="float-r">
						<a href="javascript:void(0)" onclick="doDeleteComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});" 
						   class="btn black"><span class="small"><spring:message code="버튼:삭제"/></span></a>
					</div>
				</c:if>
			</c:if>
		</div>
		<div class="desc">
			<aof:text type="text" value="${row.comment.description}"/>
		</div>
	</div>
</div>
</c:forEach>
<c:import url="/WEB-INF/view/include/paging.jsp">
	<c:param name="paginate" value="paginate"/>
	<c:param name="func" value="doPageComment"/>
</c:import>
	
</body>
</html>