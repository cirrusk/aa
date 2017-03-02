<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

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
	
	<table class="tbl-detail">
	<colgroup>
		<col style="width:75px" />
		<col style="width:275px;"/>
		<col style="width:75px" />
		<col style="width:auto;"/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:CDMS:과정명"/></th>
			<td colspan="3">
				<c:out value="${detailStudioWork.project.projectName}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:스튜디오"/></th>
			<td><c:out value="${detailStudio.studio.studioName}"/></td>
			<th><spring:message code="필드:CDMS:촬영구분"/></td>
			<td><aof:code type="print" codeGroup="CDMS_SHOOTING" selected="${detailStudioWork.studioWork.shootingCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:일자"/></th>
			<td><aof:date datetime="${detailStudioWork.studioWork.startDtime}"/></td>
			<th><spring:message code="필드:CDMS:시간"/></th>
			<td>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.startDtime}" pattern="HH : mm"/></span>
				<span style="margin-right:5px;">~</span>
				<span style="margin-right:5px;"><aof:date datetime="${detailStudioWork.studioWork.endDtime}" pattern="HH : mm"/></span>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:첨부파일"/></td>
			<td colspan="3">
				<c:forEach var="row" items="${detailStudioWork.studioWork.attachList}" varStatus="i">
					<c:if test="${row.attachType eq 'input'}">
						<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:메모"/></td>
			<td style="vertical-align:top; *position:relative; *border:none;">
				<div class="scroll-y" style="height:140px;"><aof:text type="text" value="${detailStudioWork.studioWork.memo}"/></div>
			</td>
			<c:choose>
				<c:when test="${!empty detailStudioWork.studioWork.cancelDtime}">
					<th><spring:message code="필드:CDMS:취소사유"/></th>
					<td style="vertical-align:top; *position:relative; *border-top:none;">
						<div class="scroll-y" style="height:100px;"><aof:text type="text" value="${detailStudioWork.studioWork.cancelMemo}"/></div>
						<div>
							<strong><spring:message code="필드:CDMS:취소자"/></strong>
							- <c:out value="${detailStudioWork.cancelMember.memberName}"/>
						</div> 
						<div>
							<strong><spring:message code="필드:CDMS:예약취소"/></strong> 
							- <aof:code type="print" codeGroup="CDMS_STUDIO_CANCEL_TYPE" selected="${detailStudioWork.studioWork.studioCancelTypeCd}"/>
						</div>
					</td>
				</c:when>
				<c:otherwise>
					<th>&nbsp;</th>
					<td>&nbsp;</td>
				</c:otherwise>
			</c:choose>
		</tr>
		<tr>
			<th><spring:message code="필드:CDMS:예약자"/></td>
			<td colspan="3"><c:out value="${detailStudioWork.regMember.memberName}"/></td>
		</tr>
	</tbody>
	</table>

</body>
</html>