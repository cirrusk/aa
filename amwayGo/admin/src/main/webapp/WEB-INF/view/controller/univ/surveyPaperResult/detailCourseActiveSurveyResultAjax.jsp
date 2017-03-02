<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_TYPE_GENERAL"              value="${aoffn:code('CD.SURVEY_TYPE.GENERAL')}"/>
<c:set var="CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER" value="${aoffn:code('CD.SURVEY_GENERAL_TYPE.ESSAY_ANSWER')}"/>

<html>
<head>
<title></title>
<style type="text/css">
.gray    {background-color:#cdcdcd;}
</style>
</head>

<body>
<c:set var="totalMemberCount" value="${courseActiveSurvey.totalMemberCount}" />
<c:set var="totalAnswerCount" value="${courseActiveSurvey.totalAnswerCount}" />
<c:set var="satisfyYn" value="Y" />
<c:if test="${detailSurvey.univSurvey.surveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
	<c:set var="satisfyYn" value="N" />
</c:if>
	<c:choose>
		<c:when test="${detailSurvey.univSurvey.surveyItemTypeCd ne CD_SURVEY_GENERAL_TYPE_ESSAY_ANSWER}">
			<table class="tbl-list">
				<colgroup>
					<col style="width: 40px" />
					<col style="width: auto" />
					<c:if test="${satisfyYn eq 'Y'}">
						<col style="width: 90px" />
					</c:if>
					<col style="width: 90px" />
					<col style="width: 90px" />
					<c:if test="${satisfyYn eq 'Y'}">
						<col style="width: 90px" />
					</c:if>
				</colgroup>
				<tr class="gray">
					<td colspan="2">
						<strong><spring:message code="필드:설문:항목" /></strong>
					</td>
					<c:if test="${satisfyYn eq 'Y'}">
						<td>
							<strong><spring:message code="필드:설문:점수" /></strong>
						</td>
					</c:if>
					<td>
						<strong><spring:message code="필드:설문:인원" /></strong>
					</td>
					<td>
						<strong><spring:message code="필드:설문:비율" />(%)</strong>
					</td>
					<c:if test="${satisfyYn eq 'Y'}">
						<td>
							<strong><spring:message code="필드:설문:점수" /></strong>
						</td>
					</c:if>
				</tr>
				<c:forEach var="row" items="${detailSurvey.listSurveyExample}" varStatus="i">
					<tr class="gray">
						<td>
							<c:out value="${i.count}" />
						</td>
						<td class="align-l">
							<c:out value="${row.univSurveyExample.surveyExampleTitle}" />
						</td>
						<c:choose>
							<c:when test="${i.count eq 1}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer1Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer1Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer1Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 2}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer2Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer2Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer2Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 3}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer3Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer3Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer3Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 4}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer4Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer4Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer4Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 5}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer5Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer5Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer5Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 6}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer6Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer6Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer6Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 7}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer7Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer7Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer7Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 8}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer8Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer8Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer8Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 9}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer9Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer9Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer9Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 10}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer10Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer10Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer10Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 11}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer11Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer11Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer11Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 12}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer12Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer12Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer12Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 13}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer13Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer13Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer13Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 14}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer14Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer14Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer14Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 15}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer15Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer15Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer15Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 16}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer16Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer16Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer16Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 17}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer17Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer17Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer17Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 18}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer18Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer18Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer18Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 19}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer19Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer19Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer19Count}" />
									</td>
								</c:if>
							</c:when>
							<c:when test="${i.count eq 20}">
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<c:out value="${row.univSurveyExample.measureScore}" />
									</td>
								</c:if>
								<td>
									<c:out value="${surveyResult.courseActiveSurveyAnswer.surveyAnswer20Count}" />
								</td>
								<td>
									<aof:number pattern="#.##" value="${aoffn:toDouble(surveyResult.courseActiveSurveyAnswer.surveyAnswer20Count/totalMemberCount)*100}" />%
								</td>
								<c:if test="${satisfyYn eq 'Y'}">
									<td>
										<aof:number value="${row.univSurveyExample.measureScore * surveyResult.courseActiveSurveyAnswer.surveyAnswer20Count}" />
									</td>
								</c:if>
							</c:when>
						</c:choose>
					</tr>
				</c:forEach>
			</table>
		</c:when>
		<c:otherwise>
			<table class="tbl-list">
				<colgroup>
					<col style="width: 40px" />
					<col style="width: auto" />
					<col style="width: 90px" />
					<col style="width: 90px" />
				</colgroup>
				<tr class="gray">
					<td colspan="4">
						<strong><spring:message code="필드:설문:주관식답변내용" /></strong>
					</td>
				</tr>
				<c:forEach var="row" items="${surveyResult}" varStatus="i">
					<tr  class="gray">
						<td>
							<c:out value="${i.count}" />
						</td>
						<td colspan="3" class="align-l">
							<c:out value="${row.courseActiveSurveyAnswer.regMemberName}" /> : <c:out value="${row.courseActiveSurveyAnswer.essayAnswer}" />
						</td>
					</tr>
				</c:forEach>
			</table>
		</c:otherwise>
	</c:choose>

</body>
</html>