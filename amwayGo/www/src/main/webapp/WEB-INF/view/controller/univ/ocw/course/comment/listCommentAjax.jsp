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

	<form id=FormInsertComment name="FormInsertComment" method="post" onsubmit="return false;">
		<input type="hidden" name="commentTypeCd"    value="<c:out value="${condition.srchCommentTypeCd}"/>" />
		<input type="hidden" name="courseActiveSeq"    value="<c:out value="${condition.srchCourseActiveSeq}"/>" />
		<input type="hidden" name="itemSeq"    value="<c:out value="${condition.srchItemSeq}"/>" />
		<input type="hidden" name="secretYn"    value="N" />
	
		<c:if test="${not empty ssMemberSeq}">
			<div class="group-comment">
				<div class="desc">
					<textarea name="description" ></textarea>
					<a href="javascript:void(0);" class="btn com" onclick="doInsertComment()"><span class="mid"><spring:message code="버튼:등록"/></span></a>
				</div>
			</div>
		</c:if>
		<c:if test="${empty ssMemberSeq}">
			<div class="group-comment">
				<div class="desc">
					<textarea name="description" readonly="readonly"><spring:message code="글:로그인:로그인이필요합니다"/></textarea>
					<a href="javascript:void(0);" class="btn com" onclick="doLoginAlert()"><span class="mid"><spring:message code="버튼:등록"/></span></a>
				</div>
			</div>
		</c:if>
	</form>
	<div class="vspace"></div>

	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
	
		<div class="group-comment bg">
			<div class="info">
				<div class="float-l">
					<span class="name"><c:out value="${row.ocwComment.regMemberName}"/></span>
					<span class="date"><aof:date datetime="${row.ocwComment.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
				</div>
				<div class="float-r">
				<c:if test="${empty ssMemberSeq}">
					<span class="like-area"><span class="like" onclick="doLoginAlert();" style="cursor: pointer;"><spring:message code="필드:게시판:추천"/> <strong><c:out value="${row.ocwComment.agreeCount}" /></strong></span>
					<span class="like-area"><span class="like"  onclick="doLoginAlert();" style="cursor: pointer;"><spring:message code="필드:게시판:반대"/> <strong><c:out value="${row.ocwComment.disagreeCount}" /></strong></span>
				</c:if>
				<c:if test="${not empty ssMemberSeq}">
					<span class="like-area"><span class="like" onclick="doUpdateAgreeComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});" style="cursor: pointer;"><spring:message code="필드:게시판:추천"/> <strong><c:out value="${row.ocwComment.agreeCount}" /></strong></span>
					<span class="like-area"><span class="like"  onclick="doUpdateDisagreeComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});" style="cursor: pointer;"><spring:message code="필드:게시판:반대"/> <strong><c:out value="${row.ocwComment.disagreeCount}" /></strong></span>
				</c:if>
				</span>
					<span class="edit">
						<c:if test="${ssMemberSeq eq row.ocwComment.regMemberSeq}">
							<a class="btn gray" href="javascript:void(0);" onclick="doEditComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});"><span class="small"><spring:message code="버튼:수정"/></span></a>
							<a class="btn black" href="javascript:void(0);" onclick="doDeleteComment({'ocwCommentSeq' : '<c:out value="${row.ocwComment.ocwCommentSeq}"/>'});"><span class="small"><spring:message code="버튼:삭제"/></span></a>
						</c:if>
					</span>
				</div>
			</div>
			<div class="desc"><aof:text type="text" value="${row.ocwComment.description}"/></div>
		</div>
	</c:forEach>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="doPageComment"/>
	</c:import>

</div>

<script type="text/javascript">
doInitializeComment();
</script>