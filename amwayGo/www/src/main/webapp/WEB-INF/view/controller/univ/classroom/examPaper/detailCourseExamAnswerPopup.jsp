<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_EXAM_FILE_TYPE_IMAGE" value="${aoffn:code('CD.EXAM_FILE_TYPE.IMAGE')}"/>
<c:set var="CD_EXAM_FILE_TYPE_VIDEO" value="${aoffn:code('CD.EXAM_FILE_TYPE.VIDEO')}"/>
<c:set var="CD_EXAM_FILE_TYPE_AUDIO" value="${aoffn:code('CD.EXAM_FILE_TYPE.AUDIO')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_002"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.002')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_004"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.004')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_005"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.005')}"/>
<c:set var="CD_EXAM_ITEM_TYPE_006"   value="${aoffn:code('CD.EXAM_ITEM_TYPE.006')}"/>
<c:set var="CD_SCORE_TYPE_003"       value="${aoffn:code('CD.SCORE_TYPE.003')}"/>
<c:set var="CD_EXAM_ITEM_ALIGN_H"    value="${aoffn:code('CD.EXAM_ITEM_ALIGN.H')}"/>

<c:set var="resultYn" value="N"/>
<c:if test="${!empty detailCourseApplyElement.courseApplyElement.scoreDtime and detailCourseApplyElement.courseApplyElement.completeYn eq 'Y'}">
	<c:set var="resultYn" value="Y"/>
</c:if>

<html decorator="learning">
<head>
<script type="text/javascript">
var SUB = {
	initPage : function() {
		// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
		SUB.doInitializeLocal();

	},
	/**
	 * 설정
	 */
	doInitializeLocal : function() {

	},
	/**
	 * 창 닫기
	 */
	doClose : function() {
		if ($layer != null) {
			$layer.dialog("close");
		}
	},
	/**
	 * 미디어 보이기
	 */
	doShowMedia : function(element) {
		var $element = jQuery(element).children().clone();
		var $overlay = jQuery(".section-overlay");
		var $section = jQuery(".section-media");
		var $sectionClose = jQuery("<div class='close'></div>");
		var $sectionMedia = jQuery("<div class='media'></div>");
		
		$section.empty();
		$section.append($sectionClose);
		$section.append($sectionMedia);
		
		var player = null;
		if ($element.hasClass("video")) {
			$sectionMedia.append($element);
			player = $element.media({width:400, height: 300, autoStart:false});	
		} else if ($element.hasClass("audio")) {
			$sectionMedia.append($element);
			player = $element.media({width:400, height: 30, autoStart:false});
		} else if ($element.hasClass("image")) {
			var $img = jQuery("<img class='image' src='" + $element.attr("src").replace(/.thumb.jpg$/,"") + "'>");
			$sectionMedia.append($img);
		}
		var $parentOverlay = $overlay.parent(); 
		$overlay.css({
			width : $parentOverlay.width() + "px",
			height : $parentOverlay.height() + "px"
		});
		$overlay.addClass("section-overlay-visible");
		$section.addClass("section-media-visible").position({of : $overlay, at : "center", my : "center"});
		$section.draggable({containment : "parent"});

		$sectionClose.on("click", function() {
			var object = $sectionMedia.find("object").get(0);
			if (typeof object === "object") {
				player.stop(object);
			}
			$section.empty();
			$section.removeClass("section-media-visible");
			$overlay.removeClass("section-overlay-visible");
		});
	}
};
</script>
<c:import url="/WEB-INF/view/include/mediaPlayer.jsp"/>
</head>

<body>

	<div class="learning" style="height:738px;">
		<div class="pop-header">
			<h3><span class="pop-header-test"></span><c:out value="${detailExamPaper.courseExamPaper.examPaperTitle}"/></h3>
			<a href="javascript:void(0)" onclick="SUB.doClose()" class="close"><aof:img src="common/pop_close.gif" alt="버튼:닫기" /></a>
		</div>

		<div class="section-contents">
			<div class="data scroller" style="width:725px; height:701px;">
				<table width="100%" class="edit-table tbl-detail" style="margin-bottom:10px;">
				<colgroup>
					<col style="width:80px" />
					<col style="width:auto" />
					<col style="width:80px" />
					<col style="width:auto" />
					<col style="width:80px" />
					<col style="width:auto" />
					<col style="width:80px" />
					<col style="width:auto" />
				</colgroup>
				<tbody>
					<c:set var="sumScore" value="0"/>
					<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
						<c:set var="sumScore" value="${sumScore + row.courseExamAnswer.takeScore}"/>
					</c:forEach>
					<tr>
						<th><spring:message code="필드:시험:시험지설명"/></th>
						<td colspan="7"><aof:text type="text" value="${detailExamPaper.courseExamPaper.description}"/></td>
					</tr>
					<tr>
						<th><spring:message code="필드:시험:총점"/></th>
						<td>
							<c:choose>
								<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
									<c:out value="${detailExamPaper.courseExamPaper.examPaperScore}"/>
								</c:when>
								<c:otherwise>
									<c:out value="${detailExamPaper.courseExamPaper.score * aoffn:size(listExamAnswer)}"/>
								</c:otherwise>
							</c:choose>
						</td>
						<th><spring:message code="필드:시험:문항수"/></th>
						<td><c:out value="${aoffn:size(listExamAnswer)}"/></td>
						<th><spring:message code="필드:시험:문항당점수"/></th>
						<td>
							<c:choose>
								<c:when test="${detailExamPaper.courseExamPaper.scoreTypeCd eq CD_SCORE_TYPE_003}">
									<c:choose>
										<c:when test="${aoffn:size(listExamAnswer) gt 0}">
											<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.examPaperScore / aoffn:size(listExamAnswer)}"/>
										</c:when>
										<c:otherwise><c:set var="scorePerItem" value="0"/></c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:set var="scorePerItem" value="${detailExamPaper.courseExamPaper.score}"/>
								</c:otherwise>
							</c:choose>
							<c:out value="${aoffn:trimDouble(scorePerItem)}"/>							
						</td>
						<c:set var="sumScore" value="0"/>
						<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
							<c:set var="sumScore" value="${sumScore + row.courseExamAnswer.takeScore}"/>
						</c:forEach>
						<th><spring:message code="필드:시험:획득점수"/></th>
						<td><c:out value="${aoffn:trimDouble(sumScore)}"/></td>
					</tr>
				</tbody>
				</table>
			
				<c:set var="questionCount" value="1"/>
				<c:set var="prevExamSeq" value=""/>
			
				<c:forEach var="row" items="${listExamAnswer}" varStatus="i">
					<c:set var="itemIndex"             value="${i.index}"                  />
					<c:set var="itemSize"              value="${row.courseExam.examCount}" />
					<c:set var="courseExam"            value="${row.courseExam}"           />
					<c:set var="courseExamItem"        value="${row.courseExamItem}"       />
					<c:set var="courseExamAnswer"      value="${row.courseExamAnswer}"     />
					<c:set var="listCourseExamExample" value="${row.listCourseExamExample}"/>

					<c:if test="${itemSize gt 1 and courseExam.examSeq ne prevExamSeq}">
						<c:set var="prevExamSeq" value="${courseExam.examSeq}" />
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
															<div class="question-media" onclick="SUB.doShowMedia(this)">
																<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${courseExam.filePath}.thumb.jpg"/>">
															</div>
														</c:when>
														<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
															<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>" title="video"></div>
															</div>
														</c:when>
														<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
															<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExam.filePath}"/>" title="audio"></div>
															</div>
														</c:when>
													</c:choose>
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
															<div class="question-media" onclick="SUB.doShowMedia(this)">
																<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>">
															</div>
														</c:when>
														<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
															<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
																<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExam.filePath}"/>" title="video"></div>
															</div>
														</c:when>
														<c:when test="${courseExam.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
															<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
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

					<div class="question" id="question-<c:out value="${i.count}"/>">
					
						<c:choose>
							<c:when test="${courseExamAnswer.takeScore eq 0}"><div class="answer-incorrect"></div></c:when>
							<c:when test="${courseExamAnswer.takeScore eq scorePerItem}"><div class="answer-correct"></div></c:when>
							<c:when test="${courseExamAnswer.takeScore lt scorePerItem}"><div class="answer-triangle"></div></c:when>
						</c:choose>
						
						<div class="question-head">
							<c:out value="${questionCount}"/>. 
						</div>
						<div class="question-title">
							<aof:text type="text" value="${courseExamItem.examItemTitle}"/>
							<span class="question-type">
								[<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" ref="1" selected="${courseExamItem.examItemTypeCd}"/>]
							</span>
							<span class="take-score">- <c:out value="${aoffn:trimDouble(courseExamAnswer.takeScore)}"/><spring:message code="글:시험:점"/></span>
						</div>
						
						<div class="question-body">
							<c:set var="alignType" value="vertical" scope="request"/>
							<c:if test="${courseExamItem.examItemAlignCd eq CD_EXAM_ITEM_ALIGN_H}">
								<c:set var="alignType" value="2column" scope="request"/>
							</c:if>
							<c:set var="className" value="example-${alignType}-s"/>
							
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
														<div class="question-media" onclick="SUB.doShowMedia(this)">
															<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${courseExamItem.filePath}.thumb.jpg"/>">
														</div>
													</c:when>
													<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
														<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
															<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>" title="video"></div>
														</div>
													</c:when>
													<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
														<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
															<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${courseExamItem.filePath}"/>" title="audio"></div>
														</div>
													</c:when>
												</c:choose>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
														<div class="question-media" onclick="SUB.doShowMedia(this)">
															<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>">
														</div>
													</c:when>
													<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
														<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
															<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${courseExamItem.filePath}"/>" title="video"></div>
														</div>
													</c:when>
													<c:when test="${courseExamItem.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
														<div class="question-media media-padding-l" onclick="SUB.doShowMedia(this)">
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
											<li class="description">
												<strong>- <spring:message code="필드:시험:응답"/></strong>
												<div class="text"><c:out value="${courseExamAnswer.shortAnswer}"/></div>
											</li>
										</c:when>
										<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_005}">
											<li class="description">
												<strong>- <spring:message code="필드:시험:응답"/></strong>
												<div class="text"><aof:text type="text" value="${courseExamAnswer.essayAnswer}" /></div>
											</li>
										</c:when>
										<c:when test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_006}">
											<li class="description">
												<strong>- <spring:message code="필드:시험:첨부파일"/></strong>
												<div class="text">
													<c:if test="${!empty courseExamAnswer.attachKey and !empty courseExamAnswer.attachList}">
														<c:forEach var="rowSub" items="${courseExamAnswer.attachList}" varStatus="iSub">
															<c:out value="${rowSub.realName}"/>
														</c:forEach>
													</c:if>
												</div>
											</li>
										</c:when>
										<c:otherwise>
											<c:set var="input" value="radio"/>
											<c:if test="${courseExamItem.examItemTypeCd eq CD_EXAM_ITEM_TYPE_002}">
												<c:set var="input" value="checkbox"/>
											</c:if>
												
											<c:forEach var="rowSub" items="${listCourseExamExample}" varStatus="iSub">
												<c:set var="selected" value=""/>
												<c:if test="${!empty courseExamAnswer and aoffn:contains(courseExamAnswer.choiceAnswer, rowSub.courseExamExample.examExampleSeq, ',') eq true}">
													<c:set var="selected" value="answer-selected"/>
												</c:if>
												<li class="example-item <c:out value="${selected}"/> example-item-<c:out value="${fn:length(listCourseExamExample)}"/>">
													<span class="number"><spring:message code="글:시험:${iSub.count}"/></span>
													<div><aof:text type="text" value="${rowSub.courseExamExample.examItemExampleTitle}"/></div>
													
													<c:if test="${!empty rowSub.courseExamExample.filePath}">
														<c:choose>
															<c:when test="${rowSub.courseExamExample.filePathType eq 'upload'}">
																<c:choose>
																	<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																		<div class="example-media" onclick="SUB.doShowMedia(this)">
																			<img class="image" src="<c:out value="${aoffn:config('upload.context.image')}${rowSub.courseExamExample.filePath}.thumb.jpg"/>">
																		</div>
																	</c:when>
																	<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																		<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																			<div class="video" href="<c:out value="${aoffn:config('upload.context.media')}${rowSub.courseExamExample.filePath}"/>" title="video"></div>
																		</div>
																	</c:when>
																	<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																		<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																			<div class="audio" href="<c:out value="${aoffn:config('upload.context.media')}${rowSub.courseExamExample.filePath}"/>" title="audio"></div>
																		</div>
																	</c:when>
																</c:choose>
															</c:when>
															<c:otherwise>
																<c:choose>
																	<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_IMAGE}">
																		<div class="example-media" onclick="SUB.doShowMedia(this)">
																			<img class="image" src="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>">
																		</div>
																	</c:when>
																	<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_VIDEO}">
																		<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																			<div class="video" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>" title="video"></div>
																		</div>
																	</c:when>
																	<c:when test="${rowSub.courseExamExample.examFileTypeCd eq CD_EXAM_FILE_TYPE_AUDIO}">
																		<div class="example-media media-padding-s" onclick="SUB.doShowMedia(this)">
																			<div class="audio" href="<c:out value="${aoffn:config('upload.context.exam')}${rowSub.courseExamExample.filePath}"/>" title="audio"></div>
																		</div>
																	</c:when>
																</c:choose>
															</c:otherwise>
														</c:choose>
													</c:if>
												</li>
											</c:forEach>
														
										</c:otherwise>
									</c:choose>
							
								</td>
							</tr>
							<c:if test="${!empty courseExamItem.description}">
								<tr>
									<td class="description" colspan="<c:out value="${colSpan}"/>">
										<strong>- <spring:message code="필드:시험:문제해설"/></strong>
										<div class="text"><aof:text type="text" value="${courseExamItem.description}"/></div>
									</td>
								</tr>
							</c:if>
							<c:if test="${!empty courseExamAnswer.comment}">
								<tr>
									<td class="description" colspan="<c:out value="${colSpan}"/>">
										<strong>- <spring:message code="필드:시험:첨삭"/></strong>
										<div class="text highlight"><aof:text type="text" value="${courseExamAnswer.comment}"/></div>
									</td>
								</tr>
							</c:if>
							</table>
						
							<c:set var="questionCount" value="${aoffn:toInt(questionCount) + 1}"/>
						</div>
					</div>
					
					<div class="question-space"></div>
				</c:forEach>

			</div>

			<div class="section-overlay">
			</div>
			<div class="section-media">
			</div>

		</div>
		
	</div>

</body>
</html>