<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>

<c:if test="${itemSize gt 1 and courseExam.examSeq ne prevExamSeq}">
	<c:set var="prevExamSeq" value="${courseExam.examSeq}" scope="request"/>
	<div class="question">
		<div class="question-head">※</div>
		<div class="question-title">
			<spring:message code="필드:시험:문제"/>[
				<c:forEach var="x" begin="1" end="${itemSize}" varStatus="iX">
					<c:if test="${iX.first eq true }">
						<c:out value="${aoffn:toInt(questionCount) + x - 1}"/> ~
					</c:if>
					<c:if test="${iX.last eq true }">
						<c:out value="${aoffn:toInt(questionCount) + x - 1}"/>
					</c:if>
				</c:forEach>
			]	
			<aof:text type="text" value="${courseExam.examTitle}"/>
		</div>
		<div class="question-body" style="margin-bottom:5px;">
			<table>
			<tr>
				<c:if test="${!empty courseExam.filePath}">
					<td class="question-item">
						<c:choose>
							<c:when test="${courseExam.filePathType eq 'upload'}">
								<c:choose>
									<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
										<div class="question-media" onclick="doShowMedia(this)">
											<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${courseExam.filePath}.thumb.jpg"/>">
										</div>
									</c:when>
									<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
										<div class="question-media media-padding-l" onclick="doShowMedia(this)">
											<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>" title="video"></div>
										</div>
									</c:when>
									<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
										<div class="question-media media-padding-l" onclick="doShowMedia(this)">
											<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>" title="audio"></div>
										</div>
									</c:when>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
										<div class="question-media" onclick="doShowMedia(this)">
											<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>">
										</div>
									</c:when>
									<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
										<div class="question-media media-padding-l" onclick="doShowMedia(this)">
											<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>" title="video"></div>
										</div>
									</c:when>
									<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
										<div class="question-media media-padding-l" onclick="doShowMedia(this)">
											<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>" title="audio"></div>
										</div>
									</c:when>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</td>
				</c:if>
				<td class="question-example">
					<aof:text type="text" value="${courseExam.description}"/>
				</td>
			</tr>
			</table>
		</div>
		
	</div>
</c:if>