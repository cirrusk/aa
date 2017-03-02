<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:set var="cdmsStudioComplete">Y=<spring:message code="글:CDMS:완료"/>,N=<spring:message code="글:CDMS:미완료"/></c:set>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forEdit     = null;
var forDetail   = null;
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
	forListdata.config.url    = "<c:url value="/cdms/studio/work/result/list.do"/>";

	forEdit = $.action("layer");
	forEdit.config.formId = "FormEdit";
	forEdit.config.url    = "<c:url value="/cdms/studio/work/result/edit.do"/>";
	forEdit.config.options.width  = 700;
	forEdit.config.options.height = 450;
	forEdit.config.options.title  = "<spring:message code="글:CDMS:촬영결과"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/cdms/studio/work/result/detail.do"/>";

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
/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};
/**
 * 새로고침
 */
doRefresh = function() {
	doDetail({
		'workSeq' : '<c:out value="${detailStudioWork.studioWork.workSeq}"/>'
	});
};
</script>
</head>

<body>

	<c:set var="chargeYn" value="N"/>
	<c:forEach var="row" items="${detailStudio.listStudioMember}" varStatus="i">
		<c:if test="${ssMemberSeq eq row.member.memberSeq }">
			<c:set var="chargeYn" value="Y"/>
		</c:if>
	</c:forEach>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>
	
	<div style="display:none;">
		<c:import url="srchStudioWorkResult.jsp"/>
		<form name="FormEdit" id="FormEdit" method="post" onsubmit="return false;">
			<input type="hidden" name="workSeq" />
			<input type="hidden" name="callback" value="doRefresh"/>
		</form>		
	</div>
	
	<div class="lybox-title">
		<h4 class="section-title"><spring:message code="글:CDMS:예약정보"/></h4>
	</div>
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width:75px" />
		<col style="width:auto;"/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:예약자"/></td>
			<td><c:out value="${detailStudioWork.regMember.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:예약일"/></td>
			<td><aof:date datetime="${detailStudioWork.studioWork.regDtime}"/></td>
		</tr>
		<c:if test="${!empty detailStudioWork.project.projectName}">
			<tr>
				<th><spring:message code="필드:CDMS:과정명"/></th>
				<td><c:out value="${detailStudioWork.project.projectName}"/></td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:CDMS:촬영구분"/></td>
			<td><aof:code type="print" codeGroup="CDMS_SHOOTING" selected="${detailStudioWork.studioWork.shootingCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:스튜디오"/></th>
			<td><c:out value="${detailStudio.studio.studioName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:시간"/></th>
			<td>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.startDtime}"/></span>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.startDtime}" pattern="HH : mm"/></span>
				<span style="margin-right:5px;">~</span>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.endDtime}" pattern="HH : mm"/></span>
			</td>
		</tr>
		<c:if test="${ssMemberSeq eq detailStudioWork.studioWork.regMemberSeq or chargeYn eq 'Y'}">
			<c:if test="${!empty detailStudioWork.studioWork.attachList}">
				<tr>
					<th><spring:message code="필드:CDMS:첨부파일"/></td>
					<td>
						<c:forEach var="row" items="${detailStudioWork.studioWork.attachList}" varStatus="i">
							<c:if test="${row.attachType eq 'input'}">
								<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
								[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
							</c:if>
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:if test="${!empty detailStudioWork.studioWork.memo}">
				<tr>
					<th><spring:message code="필드:CDMS:메모"/></td>
					<td><aof:text type="text" value="${detailStudioWork.studioWork.memo}"/></td>
				</tr>
			</c:if>
		</c:if>
				
		<tr>
			<th><spring:message code="필드:CDMS:완료여부"/></td>
			<td><aof:code type="print" codeGroup="${cdmsStudioComplete}" selected="${detailStudioWork.studioWork.completeYn}"/></td>
		</tr>
	</tbody>
	</table>

	<c:if test="${ssMemberSeq eq detailStudioWork.studioWork.regMemberSeq or chargeYn eq 'Y'}">
		<c:if test="${!empty detailStudioWork.studioWork.cancelDtime}">

			<div class="lybox-title mt10">
				<h4 class="section-title"><spring:message code="글:CDMS:취소정보"/></h4>
			</div>

			<table class="tbl-detail">
			<colgroup>
				<col style="width:75px" />
				<col style="width:auto;"/>
			</colgroup>
			<tbody>
			<tr>
				<th><spring:message code="필드:CDMS:취소자"/></th>
				<td><c:out value="${detailStudioWork.cancelMember.memberName}"/></td>
			</tr>
			<tr>
				<th><spring:message code="필드:CDMS:취소일"/></th>
				<td><aof:date datetime="${detailStudioWork.studioWork.cancelDtime}"/></td>
			</tr>
			<tr>
				<th><spring:message code="필드:CDMS:취소구분"/></th>
				<td><aof:code type="print" codeGroup="CDMS_STUDIO_CANCEL_TYPE" selected="${detailStudioWork.studioWork.studioCancelTypeCd}"/></td>
			</tr>
			<tr>
				<th><spring:message code="필드:CDMS:취소사유"/></th>
				<td><aof:text type="text" value="${detailStudioWork.studioWork.cancelMemo}"/></td>
			</tr>
			</tbody>
			</table>
		</c:if>

		<c:if test="${!empty detailStudioWork.studioWork.resultDtime}">
			<div class="lybox-title mt10">
				<h4 class="section-title"><spring:message code="글:CDMS:촬영결과정보"/></h4>
			</div>

			<table class="tbl-detail">
			<colgroup>
				<col style="width:75px" />
				<col style="width:auto;"/>
			</colgroup>
			<tbody>
			<tr>
				<th><spring:message code="필드:CDMS:등록자"/></th>
				<td><c:out value="${detailStudioWork.resultMember.memberName}"/></td>
			</tr>
			<tr>
				<th><spring:message code="필드:CDMS:등록일"/></th>
				<td><aof:date datetime="${detailStudioWork.studioWork.resultDtime}"/></td>
			</tr>
			<tr>
				<th><spring:message code="필드:CDMS:파일"/></td>
				<td>
					<c:forEach var="row" items="${detailStudioWork.studioWork.attachList}" varStatus="i">
						<c:if test="${row.attachType eq 'output'}"> <%-- 촬영결과 파일 --%>
							<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
							[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
						</c:if>
					</c:forEach>
				</td>
			</tr>
			<c:if test="${!empty detailStudioWork.studioWork.resultMemo}">
				<tr>
					<th><spring:message code="필드:CDMS:메모"/></td>
					<td><aof:text type="text" value="${detailStudioWork.studioWork.resultMemo}"/></td>
				</tr>
			</c:if>
			</tbody>
			</table>
		</c:if>
		
	</c:if>
	
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and chargeYn eq 'Y' and empty detailStudioWork.studioWork.cancelDtime}">
				<a href="#" onclick="doEdit({'workSeq' : '<c:out value="${detailStudioWork.studioWork.workSeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:CDMS:촬영결과등록"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

</body>
</html>