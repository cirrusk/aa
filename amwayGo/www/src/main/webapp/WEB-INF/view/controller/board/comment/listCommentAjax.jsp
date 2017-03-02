<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:import url="/WEB-INF/view/include/session.jsp"/>

<form name="FormListComment" id="FormListComment" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"   value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"       value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"       value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchBbsSeq"    value="<c:out value="${condition.srchBbsSeq}"/>" />
	<input type="hidden" name="parentResizingYn"  		value="<c:out value="${param['parentResizingYn']}"/>" />
</form>

<form name="FormEditComment" id="FormEditComment" method="post" onsubmit="return false;">
	<input type="hidden" name="commentSeq" />
	<input type="hidden" name="callback" value="doListComment"/>
	<input type="hidden" name="parentResizingYn"  		value="<c:out value="${param['parentResizingYn']}"/>" />
</form>

<form name="FormUpdateComment" id="FormUpdateComment" method="post" onsubmit="return false;">
	<input type="hidden" name="commentSeq" />
</form>

<form name="FormDeleteComment" id="FormDeleteComment" method="post" onsubmit="return false;">
	<input type="hidden" name="commentSeq" />
	<input type="hidden" name="bbsSeq" value="<c:out value="${condition.srchBbsSeq}"/>" />
	<input type="hidden" name="parentResizingYn"  		value="<c:out value="${param['parentResizingYn']}"/>" />
</form>

<div class="section-guide">

	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">

		<div class="group-comment detail"> <!-- 사진이 없는 group-comment detail -->
	  		<div class="info">
      			<div class="float-l">
          			<span class="name">
          				<c:if test="${row.comment.secretYn eq 'Y'}">
          					[<spring:message code="필드:게시판:비밀글"/>]
          				</c:if>
          				<c:out value="${row.comment.regMemberName}"/>
          			</span>
          			<span class="date"><aof:date datetime="${row.comment.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
      			</div>
      			<div class="float-r">
          			<span class="like-area"></span>
          			<c:if test="${ssMemberSeq eq row.comment.regMemberSeq}">
   						<a class="btn black" href="#" onclick="doEditComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});"><span class="small"><spring:message code="버튼:수정"/></span></a>
          			</c:if>
          			<c:if test="${ssMemberSeq eq row.comment.regMemberSeq}">
          				<a class="btn black" href="#" onclick="doDeleteComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});"><span class="small">삭제</span></a>
          			</c:if>
      			</div>
  			</div>
  			<div class="desc">
  				<c:if test="${row.comment.secretYn eq 'Y'}">
					<c:if test="${param['bbsRegMemberSeq'] eq ssMemberSeq or row.comment.regMemberSeq eq ssMemberSeq}">
						<aof:text type="text" value="${row.comment.description}"/>	
					</c:if>
  				</c:if>
  				<c:if test="${row.comment.secretYn ne 'Y'}">
  					<aof:text type="text" value="${row.comment.description}"/>	
  				</c:if>
  			</div>
		</div><!-- //사진이 없는 group-comment detail -->

	</c:forEach>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="doPageComment"/>
	</c:import>

	<div class="vspace"></div>
	<form id=FormInsertComment name="FormInsertComment" method="post" onsubmit="return false;">
		<input type="hidden" name="bbsSeq"  value="<c:out value="${condition.srchBbsSeq}"/>" />
		<input type="hidden" name="parentResizingYn"  		value="<c:out value="${param['parentResizingYn']}"/>" />

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
	            	<a href="#" class="btn blue" onclick="doInsertComment()"><span class="mid"><spring:message code="버튼:등록"/></span></a>
	            </td>
			</tr>
			</tbody>
			</table>
		</div><!-- //comment 등록 -->
	</form>

</div>

<script type="text/javascript">
	doInitializeComment();
</script>