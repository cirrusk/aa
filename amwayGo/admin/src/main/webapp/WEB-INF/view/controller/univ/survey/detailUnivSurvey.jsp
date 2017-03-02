<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_TYPE_GENERAL" value="${aoffn:code('CD.SURVEY_TYPE.GENERAL')}"/>

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
	forListdata.config.url    = "<c:url value="/univ/survey/list.do"/>";

	forEdit = $.action();
	forEdit.config.formId = "FormDetail";
	forEdit.config.url    = "<c:url value="/univ/survey/edit.do"/>";
	
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
<style type="text/css">
.ul {list-style:none; clear:both;}
.li {float:left; line-height:23px;}
</style>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:상세정보" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchUnivSurvey.jsp"/>
	</div>

	<div class="modify">
		<strong><spring:message code="필드:수정자"/></strong>
		<span><c:out value="${detail.univSurvey.updMemberName}"/></span>
		<strong><spring:message code="필드:수정일시"/></strong>
		<span class="date"><aof:date datetime="${detail.univSurvey.updDtime}" pattern="${aoffn:config('format.datetime')}"/></span>
	</div>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:설문:설문유형"/></th>
			<td><aof:code type="print" codeGroup="SURVEY_TYPE" selected="${detail.univSurvey.surveyTypeCd}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문제목"/></th>
			<td><c:out value="${detail.univSurvey.surveyTitle}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문문항유형"/></th>
			<td>
				<c:choose>
					<c:when test="${detail.univSurvey.surveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
						<aof:code type="print" codeGroup="SURVEY_GENERAL_TYPE" selected="${detail.univSurvey.surveyItemTypeCd}"/>
					</c:when>
					<c:otherwise>
						<aof:code type="print" codeGroup="SURVEY_SATISFY_TYPE" selected="${detail.univSurvey.surveyItemTypeCd}"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:if test="${!empty detail.listSurveyExample}">
		<tr>
			<th><spring:message code="필드:설문:설문"/><spring:message code="필드:설문:보기"/></th>
			<td>
				<c:forEach var="row" items="${detail.listSurveyExample}" varStatus="i">
					<ul class="ul">
						<li class="li"><c:out value="${i.count}"/>.</li>
						<li class="li"><c:out value="${row.univSurveyExample.surveyExampleTitle}"/></li>
					</ul>
				</c:forEach>
			</td>
		</tr>
		</c:if>
		<tr>
			<th><spring:message code="필드:설문:사용여부"/></th>
			<td><aof:code type="print" codeGroup="YESNO" ref="2" selected="${detail.univSurvey.useYn}" removeCodePrefix="true"/></td>
		</tr>
	</tbody>
	</table>
	
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${detail.univSurvey.useCount gt 0}">
				<span class="comment"><spring:message code="글:설문:활용중인데이터는수정및삭제를할수없습니다"/></span>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U') and detail.univSurvey.useCount eq 0}">
				<a href="#" onclick="doEdit({'surveySeq' : '<c:out value="${detail.univSurvey.surveySeq}"/>'});"
					class="btn blue"><span class="mid"><spring:message code="버튼:수정"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:목록"/></span></a>
		</div>
	</div>

</body>
</html>