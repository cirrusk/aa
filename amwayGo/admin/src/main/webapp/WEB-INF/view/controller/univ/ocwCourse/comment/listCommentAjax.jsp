<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<form name="FormListComment" id="FormListComment" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"   value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"       value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"       value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchCommentTypeCd"    value="<c:out value="${condition.srchCommentTypeCd}"/>" />
	<input type="hidden" name="srchCourseActiveSeq"    value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
	<input type="hidden" name="srchItemSeq"    value="<c:out value="${condition.srchItemSeq}"/>" />
</form>

<form name="FormEditComment" id="FormEditComment" method="post" onsubmit="return false;">
	<input type="hidden" name="ocwCommentSeq" />
	<input type="hidden" name="callback" value="doListComment"/>
</form>

<form name="FormUpdateComment" id="FormUpdateComment" method="post" onsubmit="return false;">
	<input type="hidden" name="ocwCommentSeq" />
</form>

<form name="FormDeleteComment" id="FormDeleteComment" method="post" onsubmit="return false;">
	<input type="hidden" name="ocwCommentSeq" />
</form>

<div class="section-guide">

	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
	
		<div class="group-comment detail"> <!-- 사진이 없는 group-comment detail -->
			<div class="info">
      			<div class="float-l">
          			<span class="name">
          				<c:if test="${row.ocwComment.secretYn eq 'Y'}">
							[<spring:message code="필드:게시판:비밀글"/>]
						</c:if>
          				<c:out value="${row.ocwComment.regMemberName}"/>
         			</span>
          			<span class="date"><aof:date datetime="${row.ocwComment.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
      			</div>
      			<div class="float-r">
      				<span class="strong"><a href="javascript:void(0)" onclick="doUpdateAgreeComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});"><spring:message code="필드:게시판:추천"/></a></span>
					<span style="margin-right: 10px;"><c:out value="${row.ocwComment.agreeCount}" /></span>
					<span class="strong"><a href="javascript:void(0)" onclick="doUpdateDisagreeComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});"><spring:message code="필드:게시판:반대"/></a></span>
					<span style="margin-right: 15px;"><c:out value="${row.ocwComment.disagreeCount}" /></span>
          			<span class="like-area"></span>
          			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') or ssMemberSeq eq row.comment.regMemberSeq}">
          				<a class="btn black" href="javascript:void(0);" onclick="doEditComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});"><span class="small"><spring:message code="버튼:수정"/></span></a>
          			</c:if>
          			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') or ssMemberSeq eq row.comment.regMemberSeq}">
          				<a class="btn black" href="javascript:void(0);" onclick="doDeleteComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});"><span class="small"><spring:message code="버튼:삭제"/></span></a>
					</c:if>
      			</div>
  			</div>
  			<div class="desc"><aof:text type="text" value="${row.ocwComment.description}"/></div>
		</div>
	</c:forEach>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="doPageComment"/>
	</c:import>

	<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
		<div class="vspace"></div>
		<form id=FormInsertComment name="FormInsertComment" method="post" onsubmit="return false;">
			<input type="hidden" name="commentTypeCd"    value="<c:out value="${condition.srchCommentTypeCd}"/>" />
			<input type="hidden" name="courseActiveSeq"    value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
			<input type="hidden" name="itemSeq"    value="<c:out value="${condition.srchItemSeq}"/>" />
	
			<div class="group-comment"><!-- comment 등록 -->
				<table class="tbl-comment">
				<colgroup>
					<col style="width:auto;" />
					<col style="width:70px;" />
				</colgroup>
				<tbody>
				<tr>
					<td class="secret-comment">
						<input type="checkbox" name="secretYn" value="Y"/>
						<label for="secret-check"><spring:message code="필드:게시판:비밀글"/></label>
					</td>
				</tr>
				<tr>
					<td>	
						<textarea name="description" class="textarea-expand"></textarea>
					</td>	
					<td class="btn-area">
						<a href="javascript:void(0);" class="btn blue" onclick="doInsertComment()"><span class="mid"><spring:message code="버튼:등록"/></span></a>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
			
		</form>
	</c:if>

</div>

<script type="text/javascript">
doInitializeComment();
</script>