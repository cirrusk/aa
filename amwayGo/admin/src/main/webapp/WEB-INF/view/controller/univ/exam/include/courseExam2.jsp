<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>

<c:if test="${itemSize gt 1}">
	<div style="padding:5px;">
		<span style="margin-left:10px;">
			<strong><spring:message code="필드:시험:출제그룹"/></strong>
			<c:out value="${courseExam.groupKey}"/>
		</span>
	</div>
</c:if>
<c:if test="${!empty courseExam.filePath or !empty courseExam.description}">
	<table class="exam">
	<tr>
		<c:if test="${!empty courseExam.filePath}">
			<td class="examItem">
				<c:choose>
					<c:when test="${courseExam.filePathType eq 'upload'}">
						<c:choose>
							<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
								<img src="<c:out value="${aoffn:config('upload.context.image')}${courseExam.filePath}.thumb.jpg"/>">
							</c:when>
							<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
								<a class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>">video</a>
							</c:when>
							<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
								<a class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>">audio</a>
							</c:when>
						</c:choose>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${courseExam.examexamFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
								<img src="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>" style="max-width:200px;max-height:200px;">
							</c:when>
							<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
								<a class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>">video</a>
							</c:when>
							<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
								<a class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>">audio</a>
							</c:when>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</td>
		</c:if>
		<c:if test="${!empty courseExam.description}">
			<td class="examExample">
				<div class="text"><aof:text type="text" value="${courseExam.description}"/></div>
			</td>
		</c:if>
	</tr>
	</table>
</c:if>
