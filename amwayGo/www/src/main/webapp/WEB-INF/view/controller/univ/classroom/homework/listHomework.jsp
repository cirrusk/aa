<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_ONOFF_TYPE_ON"               value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_ONOFF_TYPE_OFF"              value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>

<html decorator="classroom">
<head>
<title></title>
<script type="text/javascript">

var forListdata = null;
var forDetail = null;
var forCreateAnswerPopup = null;
var forDetailAnswerPopup = null;

initPage = function() {
    doInitializeLocal();
};

/**
 * 설정
 */
doInitializeLocal = function() {

    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/usr/classroom/homework/detail.do"/>";
    
    forCreateAnswerPopup = $.action("layer");
    forCreateAnswerPopup.config.formId         = "FormDetail";
    forCreateAnswerPopup.config.url            = "<c:url value="/usr/classroom/homework/create/answer/popup.do"/>";
    forCreateAnswerPopup.config.options.width  = 800;
    forCreateAnswerPopup.config.options.height = 500;
    forCreateAnswerPopup.config.options.title  = "<spring:message code="필드:과제응답:과제제출"/>";
    
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/classroom/homework/list.do"/>";
	
	forDetailAnswerPopup = $.action("layer");
	forDetailAnswerPopup.config.formId         = "FormDetail";
	forDetailAnswerPopup.config.url            = "<c:url value="/usr/classroom/homework/detail/answer/popup.do"/>";
	forDetailAnswerPopup.config.options.width  = 800;
	forDetailAnswerPopup.config.options.height = 500;
	forDetailAnswerPopup.config.options.title  = "<spring:message code="필드:과제응답:과제결과"/>";
 
    setValidate();
};

setValidate = function() {

};

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetail.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    // 상세화면 실행
    forDetail.run();
};

/**
 * 과제제출 팝업호출
 */
doHomeWorkSubmit = function(mapPKs){
    UT.getById(forCreateAnswerPopup.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forCreateAnswerPopup.config.formId);
	forCreateAnswerPopup.run();
};

/**
 * 과제제출 팝업종료
 */
doHomeWorkSubmitClose = function(){
	forListdata.run();
};

/**
 * 과제결과 팝업호출
 */
 doHomeWorkResult = function(mapPKs){
    UT.getById(forDetailAnswerPopup.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetailAnswerPopup.config.formId);
    forDetailAnswerPopup.run();
};

</script>
</head>

<body>

<c:import url="srchHomework.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div id="tabContainer">

    <div class="lybox-title">
        <h4 class="section-title"><spring:message code="필드:과제응답:과제목록"/></h4>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <table id="listTable" class="tbl-list">
	    <colgroup>
	        <col style="width: 50px" />
	        <col style="width: auto" />
	        <col style="width: 300px" />
	        <col style="width: 100px" />
	        <col style="width: 100px" />
	        <col style="width: 100px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><spring:message code="필드:과제:과제제목" /></th>
	            <th><spring:message code="필드:과제:제출기간" /></th>
	            <th><spring:message code="필드:과제응답:상태" /></th>
	            <th><spring:message code="필드:과제응답:제출여부" /></th>
	            <th><spring:message code="필드:과제응답:결과조회" /></th>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:forEach var="row" items="${itemList}" varStatus="i">
		    	<tr>
		    		<td>
		                <c:out value="${index + 1}" />
		                <input type="hidden" name="homeworkSeqs" value="<c:out value="${row.courseHomework.homeworkSeq}"/>">
		                <input type="hidden" name="basicSupplementCds" value="<c:out value="${row.courseHomework.basicSupplementCd}"/>">
		                <c:set var="index" 	   value="${index + 1}"/>
		            </td>
		            <td class="align-l">
		            	<c:choose>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<span class="section-btn blue02"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
		            		</c:when>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            			<span class="section-btn green"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
		            		</c:when>
		            	</c:choose>
		            	<div class="vspace"></div>
		                <a href="javascript:doDetail({'homeworkSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />', 'onoffCd' : '<c:out value="${row.courseHomework.onoffCd}" />' });">
		                	<c:out value="${row.courseHomework.homeworkTitle}"/>
		                </a>
		            </td>
		            <td class="align-l">
		                <spring:message code="필드:과제:1차" />
		                : 
		                <aof:date datetime="${row.courseHomework.startDtime}"/>
		                ~
		                <aof:date datetime="${row.courseHomework.endDtime}"/>
		                <div class="vspace"></div>
		                <spring:message code="필드:과제:2차" /> 
		                : 
		                <c:if test="${row.courseHomework.useYn eq 'Y'}">
			                <aof:date datetime="${row.courseHomework.start2Dtime}"/>
			                ~
			                <aof:date datetime="${row.courseHomework.end2Dtime}"/>
		                </c:if>
		                <c:if test="${row.courseHomework.useYn eq 'N'}">
			                <spring:message code="글:과제:해당없음" /> 
		                </c:if>
		            </td>
		            <td>
		            	<aof:code type="print" codeGroup="HOMEWORK_STATUS" removeCodePrefix="true" selected="${row.courseHomework.homeworkStatus}"/>
		            </td>
	                <td>
		            	<c:choose>
		            		<c:when test="${row.courseHomework.homeworkStatus eq 'D' and row.answer.homeworkAnswerSeq == 0 and row.courseHomework.onoffCd eq CD_ONOFF_TYPE_ON}">
		            			<a href="#" onclick="javascript:doHomeWorkSubmit({'homeworkSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />', 
		            				'openYn' : '<c:out value="${row.courseHomework.openYn}" />', 'useYn' : '<c:out value="${row.courseHomework.useYn}" />', 'homeworkAnswerSeq' : '' });" class="btn black">
		            				<span class="small"><spring:message code="버튼:과제응답:제출" /></span>
		            			</a>
		            		</c:when>
		            		<c:when test="${row.courseHomework.homeworkStatus eq 'D' and row.answer.homeworkAnswerSeq == 0 and row.courseHomework.onoffCd eq CD_ONOFF_TYPE_OFF}">
		            			-
		            		</c:when>
		            		<c:when test="${row.answer.scoreDtime > 0}">
		            			<aof:code type="print" codeGroup="HOMEWORK_SCORE_STATUS" removeCodePrefix="true" selected="E"/>
		            		</c:when>
		            		<c:when test="${row.courseHomework.homeworkStatus eq 'D'and row.answer.homeworkAnswerSeq > 0}">
		            			<aof:code type="print" codeGroup="HOMEWORK_SCORE_STATUS" removeCodePrefix="true" selected="R"/>
		            		</c:when>
		            		<c:when test="${row.courseHomework.homeworkStatus eq 'R'}">
		            			<aof:code type="print" codeGroup="HOMEWORK_SCORE_STATUS" removeCodePrefix="true" selected="N"/>
		            		</c:when>
		            		<c:when test="${row.courseHomework.homeworkStatus eq 'E' and row.answer.homeworkAnswerSeq == 0}">
		            		<aof:code type="print" codeGroup="HOMEWORK_SCORE_STATUS" removeCodePrefix="true" selected="N"/>
		            		</c:when>
		            		<c:when test="${row.courseHomework.homeworkStatus eq 'E' and row.answer.homeworkAnswerSeq > 0 and row.answer.scoreDtime == 0}">
		            			<aof:code type="print" codeGroup="HOMEWORK_SCORE_STATUS" removeCodePrefix="true" selected="R"/>
		            		</c:when>			            			            				            		
		            	</c:choose>
		            </td>
		            <td>
			            <c:if test="${row.answer.homeworkAnswerSeq > 0 and row.answer.scoreDtime > 0}">
			            	<c:choose>
			            		<c:when test="${row.courseHomework.openYn eq 'Y' and row.answer.scoreDtime > 0}">
			            			<a href="#" onclick="javascript:doHomeWorkResult({ 'homeworkAnswerSeq' : '${row.answer.homeworkAnswerSeq}', 'onoffCd' : '<c:out value="${row.courseHomework.onoffCd}" />' });" class="btn black">
			            				<span class="small"><spring:message code="버튼:과제응답:보기" /></span>
			     					</a>
			            		</c:when>
			            		<c:otherwise>
			            			<spring:message code="필드:과제응답:비공개" />
			            		</c:otherwise>
			            	</c:choose>
			            </c:if>	
		            </td>
		    	</tr>
	    	</c:forEach>
	        <c:if test="${empty itemList}">
	            <tr>
	                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>

</div>
</body>
</html>