<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<script type="text/javascript">
var forInsertComment   = null;
var swfu = null;
initPageCommentAjax = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeComment();

	// uploader
	swfu = UI.uploader.create(function() {}, // completeCallback
		[{
			elementId : "uploader",
			postParams : {},
			options : {
				uploadUrl : "<c:url value="/attach/file/save.do"/>",
				//fileTypes : "*.*",
				fileTypes : "*.jpg;*.gif",
				fileTypesDescription : "All Files",
				fileSizeLimit : "20 MB",
				fileUploadLimit : 1, // default : 1, 0이면 제한없음.
				inputHeight : 20, // default : 20
				immediatelyUpload : true,
				successCallback : function(id, file) {}
			}
		}]
	);
	
};

/**
 * insert form 초기화
 */
 doInitializeComment = function() {
	forInsertComment = $.action("submit", {formId : "FormInsertComment"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsertComment.config.url      = "<c:url value="/comment/insert.do"/>";
	forInsertComment.config.target          = "hiddenframe";
	forInsertComment.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsertComment.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsertComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsertComment.config.fn.before       = doSetUploadInfo;
	forInsertComment.config.fn.complete     = function() {
		doListComment();
	};
 	forInsertComment.validator.set({
		title : "<spring:message code="필드:게시판:내용"/>",
		name : "description",
		data : ["!null"]
	});

};
/**
 * 파일정보 저장
 */
doSetUploadInfo = function() {
	if (swfu != null) {
		var form = UT.getById(forInsertComment.config.formId);
		form.elements["attachUploadInfo"].value = UI.uploader.getUploadedData(swfu, "uploader");
	}
	return true;
};

/**
 * 파일삭제
 */
doDeleteFile = function(element, seq) {
	var $element = jQuery(element);
	var $file = $element.closest("div");
	var $uploader = $element.closest(".uploader");
	var $attachDeleteInfo = $uploader.siblings(":input[name='attachDeleteInfo']");
	var seqs = $attachDeleteInfo.val() == "" ? [] : $attachDeleteInfo.val().split(","); 
	seqs.push(seq);
	$attachDeleteInfo.val(seqs.join(","));
	$file.remove();
};

/**
 * 저장
 */
doInsertComment = function() {
	forInsertComment.run();
};
</script>

<form name="FormListComment" id="FormListComment" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage"   value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"       value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"       value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchBbsSeq"    value="<c:out value="${condition.srchBbsSeq}"/>" />
</form>

<form name="FormEditComment" id="FormEditComment" method="post" onsubmit="return false;">
	<input type="hidden" name="commentSeq" />
	<input type="hidden" name="callback" value="doListComment"/>
</form>

<form name="FormUpdateComment" id="FormUpdateComment" method="post" onsubmit="return false;">
	<input type="hidden" name="commentSeq" />
</form>

<form name="FormDeleteComment" id="FormDeleteComment" method="post" onsubmit="return false;">
	<input type="hidden" name="bbsSeq" value="<c:out value="${condition.srchBbsSeq}"/>" />
	<input type="hidden" name="commentSeq" />
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
          			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') or ssMemberSeq eq row.comment.regMemberSeq}">
          				<a class="btn black" href="#" onclick="doEditComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});"><span class="small"><spring:message code="버튼:수정"/></span></a>
          			</c:if>
          			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') or ssMemberSeq eq row.comment.regMemberSeq}">
          				<a class="btn black" href="#" onclick="doDeleteComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});"><span class="small"><spring:message code="버튼:삭제"/></span></a>
					</c:if>
      			</div>
  			</div>
  			<div class="desc"><aof:text type="text" value="${row.comment.description}"/></div>
		</div><!-- //사진이 없는 group-comment detail -->	

<!-- 
				<div style="padding:3px 0;">
					<span class="strong"><a href="javascript:void(0)" onclick="doUpdateAgreeComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});"><spring:message code="필드:게시판:추천"/></a></span>
					<span><c:out value="${row.comment.agreeCount}" /></span>
				</div>
				<div style="padding:3px 0;">
					<span class="strong"><a href="javascript:void(0)" onclick="doUpdateDisagreeComment({'commentSeq' : '<c:out value="${row.comment.commentSeq}"/>'});"><spring:message code="필드:게시판:반대"/></a></span>
					<span><c:out value="${row.comment.disagreeCount}" /></span>
				</div>
 -->

	</c:forEach>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
		<c:param name="func" value="doPageComment"/>
	</c:import>

	<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
		<div class="vspace"></div>
		<form id=FormInsertComment name="FormInsertComment" method="post" onsubmit="return false;">
			<input type="hidden" name="bbsSeq"  value="<c:out value="${condition.srchBbsSeq}"/>" />
	
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
						<label for="secret-check">[<spring:message code="필드:게시판:비밀글"/>]</label>&nbsp;&nbsp;&nbsp;
						
						<label for="secret-check"><spring:message code="필드:게시판:첨부파일"/></label>
						<input type="hidden" name="attachUploadInfo"/>
						<div id="uploader" class="uploader"></div>
						<span class="vbom">20MB</span>
					</td>			
				</tr>
<%-- 				<tr>
				<th><spring:message code="필드:게시판:첨부파일"/></th>

				</tr>	 --%>			
				<tr>
					<td>
						<input type="hidden" name="htmlYn" value="Y" />
						<input type="hidden" name="editorPhotoInfo" />
						<textarea id="description" name="description" class="textarea-expand"></textarea>
					</td>	
					<td class="btn-area">
						<a href="#" class="btn blue" onclick="doInsertComment()"><span class="mid"><spring:message code="버튼:등록"/></span></a>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
			
		</form>
	</c:if>

</div>

