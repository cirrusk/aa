<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>

<div class="question-body">
<table class="exam">
<tr>
	<c:if test="${!empty courseExamItem.filePath}">
		<td class="examItem">
		<c:choose>
				<c:when test="${courseExamItem.filePathType eq 'upload'}">
					<c:choose>
						<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
							<img src="<c:out value="${aoffn:config('upload.context.image')}${courseExamItem.filePath}.thumb.jpg"/>">
						</c:when>
						<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
							<a class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>">video</a>
						</c:when>
						<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
							<a class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>">audio</a>
						</c:when>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
<%-- 							<img src="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>" style="max-width:200px;max-height:200px;"> --%>
							<img src="<c:out value="${courseExamItem.filePath}"/>" style="max-width:200px;max-height:200px;">
						</c:when>
						<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
<%-- 							<a class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>">video</a> --%>
							<a class="video" href="<c:out value="${courseExamItem.filePath}"/>">video</a>
						</c:when>
						<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
<%-- 							<a class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>">audio</a> --%>
							<a class="audio" href="<c:out value="${courseExamItem.filePath}"/>">audio</a>
						</c:when>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</td>
	</c:if>
	
	<td class="examExample <c:out value="${alignType}"/>">

	<c:choose>
		<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_004}">
			<c:if test="${!empty courseExamAnswer}">
				<div class="text">
					<strong><spring:message code="필드:시험:응답"/></strong> : <aof:text type="text" value="${courseExamAnswer.shortAnswer}"/>
				</div>
			</c:if>
			<div class="text">
				<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
				<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
				<input type="hidden" name="correctAnswers" class="notedit" value="<c:out value="${aoffn:encrypt(courseExamItem.correctAnswer)}"/>">
				<input type="hidden" name="similarAnswers" class="notedit" value="<c:out value="${aoffn:encrypt(courseExamItem.similarAnswer)}"/>">
				<input type="hidden" name="choiceAnswers" class="notedit">
				<input type="text" name="shortAnswers" class="input" style="width: 75%" value="<c:out value="${courseExamAnswer.shortAnswer}"/>">
				<input type="hidden" name="essayAnswers" class="notedit">
				<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
				<input type="hidden" name="attachKeys" class="notedit">
				<input type="hidden" name="attachUploadInfos"/>
				<input type="hidden" name="attachDeleteInfos"/>
			</div>
		</c:when>
		<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_005}">
			<c:if test="${!empty courseExamAnswer}">
				<div class="text">
					<strong><spring:message code="필드:시험:응답"/></strong> : <aof:text type="text" value="${courseExamAnswer.essayAnswer}"/>
				</div>
			</c:if>
			<div class="text">
				<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
				<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
				<input type="hidden" name="correctAnswers" class="notedit">
				<input type="hidden" name="similarAnswers" class="notedit">
				<input type="hidden" name="choiceAnswers" class="notedit">
				<input type="hidden" name="shortAnswers" class="notedit">
				<textarea name="essayAnswers" class="input" style="width:90%;height:50px;"><c:out value="${courseExamAnswer.essayAnswer}"/></textarea>
				<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
				<input type="hidden" name="attachKeys" class="notedit">
				<input type="hidden" name="attachUploadInfos"/>
				<input type="hidden" name="attachDeleteInfos">
			</div>
		</c:when>

		<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_006}">
			<c:if test="${!empty courseExamAnswer}">
				<div class="text">
					<strong><spring:message code="필드:시험:첨부파일"/></strong> : 
					<c:forEach var="row" items="${courseExamAnswer.attachList}" varStatus="i">
						<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					</c:forEach>
				</div>
			</c:if>
			<div class="text">
				<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
				<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
				<input type="hidden" name="correctAnswers" value="<c:out value="${aoffn:encrypt(corrects)}"/>">
				<input type="hidden" name="similarAnswers" class="notedit">
				<input type="hidden" name="choiceAnswers" value="<c:out value="${courseExamAnswer.choiceAnswer}"/>">
				<input type="hidden" name="shortAnswers" class="notedit">
				<input type="hidden" name="essayAnswers" class="notedit">
				<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
				<input type="hidden" name="attachKeys" class="notedit" value="<c:out value="${courseExamAnswer.attachKey}"/>">
				<input type="hidden" name="attachUploadInfos" value=""/>
				<input type="hidden" name="attachDeleteInfos" value="">
				<div id="uploader-<c:out value="${questionCount}"/>" class="uploader">
					<c:if test="${!empty courseExamAnswer.attachKey and !empty courseExamAnswer.attachList}">
						<c:forEach var="row" items="${courseExamAnswer.attachList}" varStatus="i">
							<div href="javascript:void(0)" onclick="doDeleteFile(this, '<c:out value="${row.attachSeq}"/>')" class="previousFile">
								<c:out value="${row.realName}"/>[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
							</div>
						</c:forEach>
					</c:if>
				</div>
			</div>
		</c:when>

		<c:otherwise>
			<c:set var="corrects" value=""/>
			<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
				<c:if test="${rowSub.courseExamExample.correctYn eq 'Y'}">
					<c:if test="${fn:length(corrects) gt 0}">
						<c:set var="corrects" value="${corrects},"/>
					</c:if>
					<c:set var="corrects" value="${corrects}${rowSub.courseExamExample.examExampleSeq}"/>
				</c:if>
			</c:forEach>

			<input type="hidden" name="examItemTypeCds" class="notedit" value="<c:out value="${courseExamItem.examItemTypeCd}"/>">
			<input type="hidden" name="examAnswerSeqs" class="notedit" value="<c:out value="${courseExamAnswer.examAnswerSeq}"/>">
			<input type="hidden" name="correctAnswers" value="<c:out value="${aoffn:encrypt(corrects)}"/>">
			<input type="hidden" name="similarAnswers" class="notedit">
			<input type="hidden" name="choiceAnswers" value="<c:out value="${courseExamAnswer.choiceAnswer}"/>">
			<input type="hidden" name="shortAnswers" class="notedit">
			<input type="hidden" name="essayAnswers" class="notedit">
			<input type="hidden" name="examItemScores" class="notedit" value="<c:out value="${courseExamItem.examItemScore}"/>">
			<input type="hidden" name="attachKeys" class="notedit" >
			<input type="hidden" name="attachUploadInfos" value=""/>
			<input type="hidden" name="attachDeleteInfos" value="">
			
			<c:set var="input" value="radio"/>
			<c:if test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_002}">
				<c:set var="input" value="checkbox"/>
			</c:if>
			
			<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
				<div class="example  <c:if test="${rowSub.courseExamExample.correctYn eq 'Y'}"> correct </c:if> ">
						<c:choose>
							<c:when test="${!empty courseExamAnswer and input eq 'radio'}">
								<input type="radio" name="choice-<c:out value="${courseExamAnswer.examAnswerSeq}"/>" value="<c:out value="${rowSub.courseExamExample.examExampleSeq}"/>" 
									class="sel_radio" onclick="doChoice(this)"
									<c:out value="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSub.courseExamExample.examExampleSeq, ',') eq true ? ' checked ' : ''}"/>									
								>
							</c:when>
							<c:when test="${!empty courseExamAnswer and input eq 'checkbox'}">
								<input type="checkbox" name="choice-<c:out value="${courseExamAnswer.examAnswerSeq}"/>" value="<c:out value="${rowSub.courseExamExample.examExampleSeq}"/>" 
									class="choice" onclick="doChoice(this)"
									<c:out value="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSub.courseExamExample.examExampleSeq, ',') eq true ? ' checked ' : ''}"/>
								>
							</c:when>
						</c:choose>
				
					<label class="<c:out value="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSub.courseExamExample.examExampleSeq, ',') eq true ? ' checked ' : ''}"/>"
					><spring:message code="글:시험:${iSub.count}"/></label>
		
					<aof:text type="text" value="${rowSub.courseExamExample.examItemExampleTitle}"/>
		
					<c:if test="${!empty rowSub.courseExamExample.filePath}">
						<br>
						<c:choose>
							<c:when test="${rowSub.courseExamExample.filePathType eq 'upload'}">
								<c:choose>
									<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
										<img src="<c:out value="${aoffn:config('upload.context.image')}${rowSub.courseExamExample.filePath}.thumb.jpg"/>">
									</c:when>
									<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
										<a class="video" href="<c:out value="${aoffn:config('upload.context.media')}${rowSub.courseExamExample.filePath}"/>">video</a>
									</c:when>
									<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
										<a class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${rowSub.courseExamExample.filePath}"/>">audio</a>
									</c:when>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
										<img src="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>" style="max-width:200px;max-height:200px;">
									</c:when>
									<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
										<a class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>">video</a>
									</c:when>
									<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
										<a class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>">audio</a>
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
</table>
</div>
