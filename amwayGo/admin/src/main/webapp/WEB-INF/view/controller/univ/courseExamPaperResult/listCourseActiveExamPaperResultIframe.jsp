<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"      value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT" value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"    value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"     value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forDetailExamPaper = null;
var forDetailHomework  = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forDetailExamPaper = $.action();
    forDetailExamPaper.config.formId = "FormDetail";
    forDetailExamPaper.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/result/detail/iframe.do"/>";
    
    forDetailHomework = $.action();
    forDetailHomework.config.formId = "FormDetailHomework";
    forDetailHomework.config.url    = "<c:url value="/univ/course/homework/result/detail.do"/>";

    
};
/**
 * 상세보기 화면을 호출하는 함수 - 시험
 */
doDetailExamPaper = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetailExamPaper.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailExamPaper.config.formId);
    // 상세화면 실행
    forDetailExamPaper.run();
};
/**
 * 상세보기 화면을 호출하는 함수 - 과제
 */
doDetailHomework = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetailHomework.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailHomework.config.formId);
    // 상세화면 실행
    forDetailHomework.run();
};
/**
 * parent page 함수 호출
 */
doParentScript = function(examType) {
	parent.goActiveMenu(examType);
}; 
</script>
</head>

<body>
<c:set var="itemCount" value="${aoffn:size(examPaperList) + aoffn:size(homeworkList)}"/>
	

<div id="tabContainer">

<div style="display: none;">
	<c:import url="../include/commonCourseActive.jsp"></c:import>
</div>
 
<div class="lybox-title mt10">
	<div class="right">
		<c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
			<a href="#" class="btn gray" onclick="doParentScript('<c:out value="${examType}" />');"><span class="small"><spring:message code="버튼:설정" /></span></a>
		</c:if>
	</div>
</div>
    
 <c:import url="srchCourseActiveExamPaperResult.jsp" />
 
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 50px" />
	        <col style="width: auto" />
	        <col style="width: 200px" />
	        <col style="width: 80px" />
	        <col style="width: 200px" />
	        <col style="width: 100px" />
	        <col style="width: 80px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><spring:message code="필드:시험:시험제목" /></th>
	            <th><spring:message code="필드:시험:진행기간" /></th>
	            <th><spring:message code="필드:시험:구분" /></th>
	            <th>
	            	<spring:message code="필드:시험:응시" />(<spring:message code="필드:시험:채점" />)|<spring:message code="필드:시험:미응시" />|<spring:message code="필드:시험:대상자" />
	            </th>
	            <th><spring:message code="필드:시험:상태" /></th>
	            <th><spring:message code="필드:시험:평가비율" /></th>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:set var="index" 	   value="0"/>
	    	<c:forEach var="row" items="${examPaperList}" varStatus="i">
		    	<tr>
		    		<c:set var="index" value="${index + 1}"/>
	    			<c:choose>
		            	<c:when test="${itemCount gt 1 and index eq 1}">
		            		<td rowspan="2">
		    				<c:out value="${index}"></c:out>
		            		</td>
		            	</c:when>
		            	<c:when test="${itemCount eq 1 and index eq 1}">
		            		<td>
		            		<c:out value="${index}"></c:out>
		            		</td>
		            	</c:when>
		            	<c:otherwise>
		            	</c:otherwise>
	            	</c:choose>
		            <td class="align-l">
		            	<c:choose>
		            		<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<c:choose>
		            				<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:중간고사" /></span>
		            				</c:when>
		            				<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:기말고사" /></span>
		            				</c:when>
		            			</c:choose>
		            		</c:when>
		            		<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            			<span class="section-btn green"><spring:message code="필드:시험:보충시험" /></span>
		            		</c:when>
		            	</c:choose>
		            	<div class="vspace"></div>
		                <a href="javascript:doDetailExamPaper({'courseActiveExamPaperSeq' : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}" />'});"><c:out value="${row.courseExamPaper.examPaperTitle}"/></a>
		            </td>
		            <td>
		                <aof:date datetime="${row.courseActiveExamPaper.startDtime}" />&nbsp;
					    <aof:date datetime="${row.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
		                <spring:message code="글:시험:부터" /> 
		                <div class="vspace"></div>
		                <aof:date datetime="${row.courseActiveExamPaper.endDtime}" />&nbsp;
					    <aof:date datetime="${row.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
					    <spring:message code="글:시험:까지" />
		            </td>
		            <td><aof:code name="onOffCd" type="print" codeGroup="ONOFF_TYPE" selected="${row.courseActiveExamPaper.onOffCd}" /></td>
		            <td>
		            	<c:choose>
		            		<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<c:out value="${row.courseActiveExamPaper.answerCount}" />
		            			(<c:out value="${row.courseActiveExamPaper.scoredCount}" />)&nbsp;&nbsp;|&nbsp;&nbsp;
		            			<c:out value="${row.courseActiveSummary.memberCount - row.courseActiveExamPaper.answerCount}"/>&nbsp;&nbsp;|&nbsp;&nbsp;
		            			<c:out value="${row.courseActiveSummary.memberCount}" />
		            		</c:when>
		            		<c:otherwise>
		            			<c:out value="${row.courseActiveExamPaper.answerCount}" />
		            			(<c:out value="${row.courseActiveExamPaper.scoredCount}" />)&nbsp;&nbsp;|&nbsp;&nbsp;
		            			<c:out value="${row.courseActiveExamPaper.targetCount - row.courseActiveExamPaper.answerCount}"/>&nbsp;&nbsp;|&nbsp;&nbsp;
		            			<c:out value="${row.courseActiveExamPaper.targetCount}"/>
		            		</c:otherwise>
		            	</c:choose>
		            </td>
		            <td>
		            	<c:choose>
		            		<c:when test="${appToday ge row.courseActiveExamPaper.startDtime and appToday le row.courseActiveExamPaper.endDtime}">
		            			<spring:message code="글:시험:진행중" />
		            		</c:when>
		            		<c:when test="${appToday gt row.courseActiveExamPaper.endDtime}">
		            			<spring:message code="글:시험:종료" />
		            		</c:when>
		            		<c:when test="${appToday lt row.courseActiveExamPaper.startDtime}">
		            			<spring:message code="글:시험:진행전" />
		            		</c:when>
		            	</c:choose>
		            </td>
		            <c:choose>
		            	<c:when test="${itemCount gt 1 and index eq 1}">
		            		<td rowspan="2">
		            		100%
		            		</td>
		            	</c:when>
		            	<c:when test="${itemCount eq 1 and index eq 1}">
		            		<td>
		            		100%
		            		</td>
		            	</c:when>
		            	<c:otherwise>
		            	</c:otherwise>
		            </c:choose>
		    	</tr>
	    	</c:forEach>
	    	<c:forEach var="row" items="${homeworkList}" varStatus="i">
	    		<tr>
	    			<c:set var="index" value="${index + 1}"/>
	    			<c:choose>
		            	<c:when test="${itemCount gt 1 and index eq 1}">
		            		<td rowspan="2">
		    				<c:out value="${index}"></c:out>
		            		</td>
		            	</c:when>
		            	<c:when test="${itemCount eq 1 and index eq 1}">
		            		<td>
		            		<c:out value="${index}"></c:out>
		            		</td>
		            	</c:when>
		            	<c:otherwise>
		            	</c:otherwise>
	            	</c:choose>
	    			<td class="align-l">
	    				<c:choose>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<c:choose>
		            				<c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:중간고사" /><spring:message code="필드:시험:대체과제" /></span>
		            				</c:when>
		            				<c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:기말고사" /><spring:message code="필드:시험:대체과제" /></span>
		            				</c:when>
		            			</c:choose>
		            		</c:when>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            			<span class="section-btn green"><spring:message code="필드:시험:보충과제" /></span>
		            		</c:when>
		            	</c:choose>
		            	<div class="vspace"></div>
		                <a href="javascript:void(0);" onclick="doDetailHomework({'homeworkSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />'});"><c:out value="${row.courseHomework.homeworkTitle}"/></a>
	    			</td>
	    			<td class="align-l">
		                <spring:message code="필드:과제:1차" />
		                : 
		                <aof:date datetime="${row.courseHomework.startDtime}"/>
		                ~
		                <aof:date datetime="${row.courseHomework.endDtime}"/>
		                <br/>
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
		            	<aof:code name="onOffCd" type="print" codeGroup="ONOFF_TYPE" selected="${row.courseHomework.onoffCd}" />
		            </td>
		            <td>
		            	<c:out value="${row.courseHomework.answerSubmitCount}"/>&nbsp;
	            		(<c:out value="${row.courseHomework.answerScoreCount}"/>)&nbsp;
	            		|&nbsp;
	            		<c:out value="${row.summary.memberCount - row.courseHomework.answerSubmitCount}"/>&nbsp;
	            		|&nbsp;
	            		<c:out value="${row.summary.memberCount}"/>
	            		
		            </td>
		            <td>
		            	<c:choose>
		            		<c:when test="${appToday ge row.courseHomework.startDtime and appToday le row.courseHomework.endDtime}">
		            			<spring:message code="글:시험:진행중" />
		            		</c:when>
		            		<c:when test="${appToday gt row.courseHomework.endDtime}">
		            			<spring:message code="글:시험:종료" />
		            		</c:when>
		            		<c:when test="${appToday lt row.courseHomework.startDtime}">
		            			<spring:message code="글:시험:진행전" />
		            		</c:when>
		            	</c:choose>
		            </td>
		            	<c:choose>
		            	<c:when test="${itemCount gt 1 and index eq 1}">
		            		<td rowspan="2">
		            		100%
		            		</td>
		            	</c:when>
		            	<c:when test="${itemCount eq 1 and index eq 1}">
		            		<td>
		            		100%
		            		</td>
		            	</c:when>
		            	<c:otherwise>
		            	</c:otherwise>
		            </c:choose>
	    		</tr>
	    	</c:forEach>
	        <c:if test="${itemCount eq 0}">
	            <tr>
	                <td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
    
</div>
</body>
</html>