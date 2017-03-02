<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_TYPE_GENERAL"              value="${aoffn:code('CD.SURVEY_TYPE.GENERAL')}"/>
<c:set var="CD_SURVEY_SATISFY_TYPE_ESSAY_ANSWER" value="${aoffn:code('CD.SURVEY_SATISFY_TYPE.ESSAY_ANSWER')}"/>

<c:set var="srchKey">title=<spring:message code="필드:설문:설문제목"/></c:set>

<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
	<div class="lybox search">
		<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			
			<select name="srchSurveyTypeCd" onchange="dochage(this.value);">
				<option value=""><spring:message code="필드:설문:설문유형"/></option>
				<aof:code type="option" codeGroup="SURVEY_TYPE" selected="${condition.srchSurveyTypeCd}"/>
			</select>
			<select id="srchSurveyItemTypeCd" name="srchSurveyItemTypeCd">
				<option value=""><spring:message code="필드:설문:설문문항유형"/></option>
				<c:choose>
					<c:when test="${condition.srchSurveyTypeCd eq CD_SURVEY_TYPE_GENERAL}">
						<aof:code type="option" codeGroup="SURVEY_GENERAL_TYPE" selected="${condition.srchSurveyItemTypeCd}" />
					</c:when>
					<c:otherwise>
						<aof:code type="option" codeGroup="SURVEY_SATISFY_TYPE" selected="${condition.srchSurveyItemTypeCd}" except="${CD_SURVEY_SATISFY_TYPE_ESSAY_ANSWER}"/>
					</c:otherwise>
				</c:choose>
			</select>
			<select name="srchUseYn">
				<option value=""><spring:message code="필드:설문:사용여부"/></option>
				<aof:code type="option" codeGroup="YESNO" ref="2" selected="${condition.srchUseYn}" removeCodePrefix="true"/>
			</select>

			<select name="srchKey">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			<%--<a href="#" onclick="doSearchReset()" class="btn black"><span class="mid"><spring:message code="버튼:초기화" /></span></a> --%>
		</fieldset>
	</div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchUseYn"             value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchSurveyTypeCd"      value="<c:out value="${condition.srchSurveyTypeCd}"/>" />
	<input type="hidden" name="srchSurveyItemTypeCd"  value="<c:out value="${condition.srchSurveyItemTypeCd}"/>" />
</form>

<form name="FormDetail" id="FormDetail" method="post" onsubmit="return false;">
	<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
	<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
	<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
	<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	<input type="hidden" name="srchUseYn"             value="<c:out value="${condition.srchUseYn}"/>" />
	<input type="hidden" name="srchSurveyTypeCd"      value="<c:out value="${condition.srchSurveyTypeCd}"/>" />
	<input type="hidden" name="srchSurveyItemTypeCd"  value="<c:out value="${condition.srchSurveyItemTypeCd}"/>" />

	<input type="hidden" name="surveySeq" />
</form>
<script type="text/javascript">

dochage = function(me){
	if(me == "SURVEY_TYPE::GENERAL"){
		$("#srchSurveyItemTypeCd > option").remove();
		$("#srchSurveyItemTypeCd").append("<option value=''><spring:message code='필드:설문:설문문항유형'/></option>");
		num = new Array("<aof:code type='option' codeGroup='SURVEY_GENERAL_TYPE' selected='${condition.srchSurveyItemTypeCd}' />");
		for(var i=0; i<num.length; i++){
			$("#srchSurveyItemTypeCd").append(num[i]);
		}
	}else if(me == "SURVEY_TYPE::COURSESATISFY"){
		$("#srchSurveyItemTypeCd > option").remove();
		$("#srchSurveyItemTypeCd").append("<option value=''><spring:message code='필드:설문:설문문항유형'/></option>");
		num = new Array("<aof:code type='option' codeGroup='SURVEY_SATISFY_TYPE' selected='${condition.srchSurveyItemTypeCd}' except='${CD_SURVEY_SATISFY_TYPE_ESSAY_ANSWER}'/>");
		for(var i=0; i<num.length; i++){
			$("#srchSurveyItemTypeCd").append(num[i]);
		}
	}else if(me == "SURVEY_TYPE::PROFSATISFY"){
		$("#srchSurveyItemTypeCd > option").remove();
		$("#srchSurveyItemTypeCd").append("<option value=''><spring:message code='필드:설문:설문문항유형'/></option>");
		num = new Array("<aof:code type='option' codeGroup='SURVEY_SATISFY_TYPE' selected='${condition.srchSurveyItemTypeCd}' except='${CD_SURVEY_SATISFY_TYPE_ESSAY_ANSWER}'/>");
		for(var i=0; i<num.length; i++){
			$("#srchSurveyItemTypeCd").append(num[i]);
		}		
	}else{
		$("#srchSurveyItemTypeCd > option").remove();
		$("#srchSurveyItemTypeCd").append("<option value=''><spring:message code='필드:설문:설문문항유형'/></option>");
	}
};
</script>