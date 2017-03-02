<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE" value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.MULTIPLE_CHOICE')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER"    value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.ESSAY_ANSWER')}"/>

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
/**
 * 닫기
 */
doClose = function() {
	window.close();
}
</script>
<link rel="stylesheet" href="<c:out value="${aoffn:config('domain.web')}"/>/common/css/admin/learning.css" type="text/css"/>
</head>

<body>

<div class="learning" style="height:740px; padding:0;">
	<input type="hidden" name="questionCount"    value="<c:out value="${aoffn:size(listElement)}"/>">
	<c:set var="questionNumber" value="-1" />
	
	<div class="section-contents">
		<div class="data scroller" style="padding:3px;margin-bottom:10px;">
			<div class="question-title">
				<h4><c:out value="${detail.surveyPaper.surveyPaperTitle}" /></h4>
			</div>
			<c:forEach var="row" items="${listElement}" varStatus="i">
				<div class="question">
					<input type="hidden" name="surveySeqs"  value="<c:out value="${row.univSurvey.surveySeq}"/>">
					<div class="question-head"><c:out value="${i.count}" />.</div>
					<div class="question-title"><c:out value="${row.univSurvey.surveyTitle}" /></div>
					<div class="question-body">
						<c:set var="input" value="radio"/>
						<c:if test="${row.univSurvey.surveyItemTypeCd eq CD_SURVEY_GENERAL_TYPE_MULTIPLE_CHOICE}">
							<c:set var="input" value="checkbox"/>
						</c:if>
					
						<table class="example-vertical">
							<c:choose>
								<c:when test="${row.univSurvey.surveyItemTypeCd ne CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER}">
									<c:forEach var="rowSub" items="${row.listSurveyExample}" varStatus="iSub">
										<tr>
											<td class="question-example">
												<div class="example-item">
													<c:choose>
														<c:when test="${input eq 'radio'}">
															<input type="radio" name="choice-<c:out value="${questionNumber}"/>" value="<c:out value="${iSub.count}"/>" 
																class="choice" onclick="doChoice(this)">
														</c:when>
														<c:when test="${input eq 'checkbox'}">
															<input type="checkbox" name="choice-<c:out value="${questionNumber}"/>" value="<c:out value="${iSub.count}"/>" 
																class="choice" onclick="doChoice(this)">
														</c:when>
													</c:choose>
													<spring:message code="글:설문:${iSub.count}" /><aof:text type="text" value="${rowSub.univSurveyExample.surveyExampleTitle}"/>
												</div>
											</td>
										<tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="question-example">
											<div class="description">
												<textarea name="essayAnswers" class="input" style="width:98%;height:50px;"></textarea>
											</div>
										</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</table>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>
<div class="lybox-btn">
	<div class="lybox-btn-c">
		<a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:닫기"/></span></a>
	</div>
</div>
</body>
</html>