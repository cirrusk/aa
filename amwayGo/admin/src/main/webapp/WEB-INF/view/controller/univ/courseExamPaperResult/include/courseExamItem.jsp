<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_H"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.H')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_M"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.M')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_001"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.001')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_003"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>


<div class="question" id="question-<c:out value="${questionCount}"/>">
	<c:if test="${!empty courseExamAnswer}">
		<div class="input-hidden" style="display:none;">
			<input type="checkbox" name="checkkeys" value="<c:out value="${aoffn:toInt(questionCount) - 1}"/>" style="display:none;">
			<input type="hidden" name="examAnswerSeqs" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
			<input type="hidden" name="oldTakeScores" value="<c:out value="${aoffn:trimDouble(courseExamAnswer.takeScore)}"/>">
			<textarea name="oldComments" style="display:none;"><c:out value="${courseExamAnswer.comment}"/></textarea>
			<input type="hidden" name="changedTakeScores" value="N">
			<input type="hidden" name="changedComments" value="N">
		</div>
	
		<c:choose>
			<c:when test="${courseExamAnswer.takeScore eq 0}"><div class="answer-incorrect"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore eq scorePerItem}"><div class="answer-correct"></div></c:when>
			<c:when test="${courseExamAnswer.takeScore lt scorePerItem}"><div class="answer-triangle"></div></c:when>
		</c:choose>
	</c:if>

	<div class="question-head">
		<c:out value="${questionCount}"/>. 
	</div>
	<div class="question-title">
		<aof:text type="text" value="${courseExamItem.examItemTitle}"/>
		<span class="question-type">
			<strong><spring:message code="필드:시험:문항유형"/></strong>
			[<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${courseExamItem.examItemTypeCd}"/>]
		</span>
		<c:if test="${!empty courseExamAnswer}">
			<span class="take-score">
				<strong><spring:message code="필드:시험:획득점수"/></strong>
				<input type="text" name="takeScores" value="<c:out value="${aoffn:trimDouble(courseExamAnswer.takeScore)}"/>"
					class="<c:out value="${courseExamItem.examItemTypeCd}"/>" 
					onchange="doChangeScore(this)" style="width:50px;text-align:center;">
				<spring:message code="글:시험:점"/>
			</span>
		</c:if>	
	</div>
	
	<div class="question-body">
		<c:set var="alignType" value="vertical" scope="request"/>
		<c:if test="${courseExamItem.examItemAlignCd eq CD_EXAM_ITEM_ALIGN_H}">
			<c:set var="alignType" value="horizontal" scope="request"/>
		</c:if>
		<c:if test="${courseExamItem.examItemAlignCd eq CD_EXAM_ITEM_ALIGN_M}">
			<c:set var="alignType" value="2column" scope="request"/>
		</c:if>
		<c:set var="className" value="example-${alignType}"/>
		<c:set var="colSpan" value="1"/>
		
		<table class="<c:out value="${className}"/>">
		<tr>
			<c:if test="${!empty courseExamItem.filePath}">
				<c:set var="colSpan" value="${colSpan + 1}"/>
				
				<td class="question-item">
					<c:choose>
						<c:when test="${courseExamItem.filePathType eq 'upload'}">
							<c:choose>
								<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
									<div class="question-media" onclick="doShowMedia(this)">
										<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${courseExamItem.filePath}.thumb.jpg"/>">
									</div>
								</c:when>
								<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
									<div class="question-media media-padding-l" onclick="doShowMedia(this)">
										<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>" title="video"></div>
									</div>
								</c:when>
								<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
									<div class="question-media media-padding-l" onclick="doShowMedia(this)">
										<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>" title="audio"></div>
									</div>
								</c:when>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${courseExamItem.fileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
									<div class="question-media" onclick="doShowMedia(this)">
										<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>">
									</div>
								</c:when>
								<c:when test="${courseExamItem.fileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
									<div class="question-media media-padding-l" onclick="doShowMedia(this)">
										<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>" title="video"></div>
									</div>
								</c:when>
								<c:when test="${courseExamItem.fileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
									<div class="question-media media-padding-l" onclick="doShowMedia(this)">
										<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>" title="audio"></div>
									</div>
								</c:when>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</td>
			</c:if>
			
			<td class="question-example">
				<c:choose>
					<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_004}">
						<c:choose>
							<c:when test="${!empty courseExamAnswer}">
								<c:if test="${!empty courseExamItem.correctAnswer}">
									<div class="description">
										<strong>- <spring:message code="필드:시험:정답"/></strong>
										<div class="text"><c:out value="${courseExamItem.correctAnswer}"/></div>
									</div>
								</c:if>
								<c:if test="${!empty courseExamItem.similarAnswer}">
									<div class="description">
										<strong>- <spring:message code="필드:시험:유사정답"/></strong>
										<div class="text"><c:out value="${courseExamItem.similarAnswer}"/></div>
									</div>
								</c:if>
								<div class="description">
									<strong>- <spring:message code="필드:시험:응답"/></strong>
									<div class="text"><c:out value="${courseExamAnswer.shortAnswer}"/></div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="description"><spring:message code="글:시험:답을입력하십시오"/></div>	
							</c:otherwise>
						</c:choose>
						
					</c:when>
					<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_005}">
						<c:choose>
							<c:when test="${!empty courseExamAnswer}">
								<div class="description">
									<strong>- <spring:message code="필드:시험:응답"/></strong>
									<div class="text"><aof:text type="text" value="${courseExamAnswer.essayAnswer}" /></div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="description"><spring:message code="글:시험:서술하십시오"/></div>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_006}">
						<c:choose>
							<c:when test="${!empty courseExamAnswer}">
								<div class="description">
									<strong>- <spring:message code="필드:시험:첨부파일"/></strong>
									<div class="text">
										<c:if test="${!empty courseExamAnswer.attachList}">
											<c:forEach var="rowSubSub" items="${courseExamAnswer.attachList}" varStatus="iSubSub">
												<a href="javascript:void(0)" onclick="doAttachDownload('<c:out value="${rowSubSub.attachSeq}"/>')"><c:out value="${rowSubSub.realName}"/></a>
												[<c:out value="${aoffn:getFilesize(rowSubSub.fileSize)}"/>]
											</c:forEach>
										</c:if>
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="description">
									<fmt:message key="글:시험:X이하의파일을첨부하십시오">
										<fmt:param value="10M Byte"/>
									</fmt:message>
								</div>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>

						<c:forEach var="rowSubSub" items="${listCourseExamExample}" varStatus="iSubSub">
							<c:set var="selected" value=""/>
							<c:set var="correct" value=""/>
							<c:if test="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSubSub.courseExamExample.examExampleSeq, ',') eq true}">
								<c:set var="selected" value="answer-selected"/>
							</c:if>
							<c:if test="${rowSubSub.courseExamExample.correctYn eq 'Y'}">
								<c:set var="correct" value="example-correct"/>
							</c:if>
							<div class="<c:out value="${correct}"/> example-item <c:out value="${selected}"/>  example-item-<c:out value="${fn:length(listCourseExamExample)}"/>">
								<span class="number"><spring:message code="글:시험:${iSubSub.count}"/></span>
								<div><aof:text type="text" value="${rowSubSub.courseExamExample.examItemExampleTitle}"/></div>
								
								<c:if test="${!empty rowSubSub.courseExamExample.filePath}">
									<c:choose>
										<c:when test="${rowSubSub.courseExamExample.filePathType eq 'upload'}">
											<c:choose>
												<c:when test="${rowSubSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
													<div class="example-media" onclick="doShowMedia(this)">
														<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${rowSubSub.courseExamExample.filePath}.thumb.jpg"/>">
													</div>
												</c:when>
												<c:when test="${rowSubSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
													<div class="example-media media-padding-s" onclick="doShowMedia(this)">
														<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${rowSubSub.courseExamExample.filePath}"/>" title="video"></div>
													</div>
												</c:when>
												<c:when test="${rowSubSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
													<div class="example-media media-padding-s" onclick="doShowMedia(this)">
														<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${rowSubSub.courseExamExample.filePath}"/>" title="audio"></div>
													</div>
												</c:when>
											</c:choose>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${rowSubSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
													<div class="example-media" onclick="doShowMedia(this)">
														<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${rowSubSub.courseExamExample.filePath}"/>">
													</div>
												</c:when>
												<c:when test="${rowSubSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
													<div class="example-media media-padding-s" onclick="doShowMedia(this)">
														<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSubSub.courseExamExample.filePath}"/>" title="video"></div>
													</div>
												</c:when>
												<c:when test="${rowSubSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
													<div class="example-media media-padding-s" onclick="doShowMedia(this)">
														<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSubSub.courseExamExample.filePath}"/>" title="audio"></div>
													</div>
												</c:when>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</c:if>
							</div>
						</c:forEach>
									
					</c:otherwise>
				</c:choose>
		
			</td>
		</tr>
		<c:if test="${!empty courseExamAnswer}">
			<tr>
				<td class="description" colspan="<c:out value="${colSpan}"/>">
					<strong>- <spring:message code="필드:시험:첨삭"/></strong>
					<c:if test="${!empty courseExamItem.comment}">
						<div class="text" style="padding-bottom:2px; width:638px;">
							<strong><spring:message code="필드:시험:첨삭기준"/></strong>:
							<aof:text type="text" value="${courseExamItem.comment}"/>
						</div>
					</c:if>
					<div><textarea name="comments" style="width:638px; height:30px;" onchange="doChangeComment(this)"><c:out value="${courseExamAnswer.comment}"/></textarea></div>
				</td>
			</tr>
		</c:if>
		</table>
	
	</div>
</div>