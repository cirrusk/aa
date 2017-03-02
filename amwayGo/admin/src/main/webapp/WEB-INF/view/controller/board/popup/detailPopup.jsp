<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_POPUP_INPUT_TYPE_TEXT"  value="${aoffn:code('CD.POPUP_INPUT_TYPE.TEXT')}"/>
<c:set var="CD_POPUP_INPUT_TYPE_IMAGE" value="${aoffn:code('CD.POPUP_INPUT_TYPE.IMAGE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/popup/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/popup/edit.do"/>";
	
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forEdit.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
	// 수정화면 실행
	forEdit.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchPopup.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.popup.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.popup.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:게시판:입력방식"/></th>
			<td>
				<aof:code type="print" codeGroup="POPUP_INPUT_TYPE" selected="${detail.popup.popupInputTypeCd}"/>
				/
				<aof:code type="print" codeGroup="POPUP_TYPE" selected="${detail.popup.popupTypeCd}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:제목"/></th>
			<td><c:out value="${detail.popup.popupTitle}"/></td>
		</tr>
		<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_TEXT}">
			<tr>
				<th><spring:message code="필드:게시판:내용"/></th>
				<td><aof:text type="text" value="${detail.popup.description}"/></td>
			</tr>
		</c:if>
		<c:if test="${!empty detail.popup.attachList}">
			<tr>
				<th><spring:message code="필드:게시판:첨부파일"/></th>
				<td>
					<c:forEach var="row" items="${detail.popup.attachList}" varStatus="i">
						<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					</c:forEach>
				</td>
			</tr>
		</c:if>
		<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_IMAGE}">
			<tr>
				<th><spring:message code="필드:게시판:이미지"/></th>
				<td>
					<c:choose>
						<c:when test="${!empty detail.popup.filePath}">
							<c:set var="imagePhoto" value ="${aoffn:config('upload.context.image')}${detail.popup.filePath}.thumb.jpg"/>
						</c:when>
						<c:otherwise>
							<c:set var="imagePhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
						</c:otherwise>
					</c:choose>
					<div class="photo photo-120" style="margin:0;">
						<img src="${imagePhoto}">
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:게시판:URL"/></th>
				<td><c:out value="${detail.popup.url}"/></td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:게시판:게시기간"/></th>
			<td><aof:date datetime="${detail.popup.startDtime}"/> ~ <aof:date datetime="${detail.popup.endDtime}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:팝업크기"/></th>
			<td>
				<spring:message code="글:게시판:가로"/> : <c:out value="${detail.popup.widthSize}"/> <spring:message code="글:게시판:픽셀"/>
				/
				<spring:message code="글:게시판:세로"/> : <c:out value="${detail.popup.heightSize}"/> <spring:message code="글:게시판:픽셀"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:영역설정"/></th>
			<td>
				<c:choose>
					<c:when test="${detail.popup.areaSetting eq 'lefttop'}">LT</c:when>
					<c:when test="${detail.popup.areaSetting eq 'leftbottom'}">LT</c:when>
					<c:when test="${detail.popup.areaSetting eq 'righttop'}">RT</c:when>
					<c:when test="${detail.popup.areaSetting eq 'rightbottom'}">RT</c:when>
					<c:otherwise>C</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:if test="${detail.popup.popupInputTypeCd eq CD_POPUP_INPUT_TYPE_TEXT}">
			<tr>
				<th><spring:message code="필드:게시판:템플릿설정"/></th>
				<td>
					<aof:code type="print" codeGroup="POPUP_TEMPLATE_TYPE" selected="${detail.popup.popupTemplateTypeCd}"/>
				</td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:게시판:사용여부"/></th>
			<td><aof:code type="print" codeGroup="YESNO" selected="${detail.popup.useYn}" /></td>
		</tr>
		<tr>
			<th><spring:message code="필드:게시판:확인메시지"/></th>
			<td><aof:code type="print" codeGroup="POPUP_CONFIRM_TYPE" selected="${detail.popup.popupConfirmTypeCd}" /></td>
		</tr>
		<tr>
			<th><spring:message code="필드:등록일"/></th>
			<td><aof:date datetime="${detail.popup.regDtime}"/></td>
		</tr>
	</tbody>
	</table>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
				<a href="#" onclick="doEdit({'popupSeq' : '<c:out value="${detail.popup.popupSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>
</body>
</html>