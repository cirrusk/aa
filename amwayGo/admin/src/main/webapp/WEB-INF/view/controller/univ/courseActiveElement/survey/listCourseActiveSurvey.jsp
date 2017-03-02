<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"         value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_SURVEY" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.SURVEY')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'SURVEY'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata     = null;
var forDetail 		= null;
var forCreate 		= null;
var forDeletelist 	= null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forListdata = $.action();
    forListdata.config.formId = "FormData";
    forListdata.config.url    = "<c:url value="/univ/course/active/survey/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/active/survey/detail.do"/>";
    
    forCreate = $.action();
    forCreate.config.formId = "FormCreate";
    forCreate.config.url    = "<c:url value="/univ/course/active/survey/create.do"/>";
    
	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/course/active/survey/deletelist.do"/>";
    forDeletelist.config.target          = "hiddenframe";
    forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDeletelist.config.fn.complete     = doCompleteDeletelist;
    forDeletelist.validator.set({
        title : "<spring:message code="필드:삭제할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
    
    
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
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
 * 신규등록
 */
doCreate = function() {
	forCreate.run();
};
/**
 * 목록에서 삭제할 때 호출되는 함수
 */
doDeletelist = function() {
	forDeletelist.run();
};
/**
 * 목록삭제 완료
 */
doCompleteDeletelist = function(success) {
    $.alert({
        message : "<spring:message code="글:X건의데이터가삭제되었습니다"/>".format({0:success}),
        button1 : {
            callback : function() {
                doList();
            }
        }
    });
};
</script>
</head>

<body>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title">
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->

<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_SURVEY}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">
    <!-- 평가기준 Start Area -->
    <%--<c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>--%>
    <!-- 평가기준 Start End -->
    
 <c:import url="srchCourseActiveSurvey.jsp" />
 
    <div class="lybox-title mt10">
        <h4 class="section-title"><spring:message code="필드:설문:구성항목" /></h4>
        <div class="right">
        	<c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
                <a href="javascript:void(0);" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" ><span class="small"><spring:message code="버튼:설문:설문결과" /></span></a>
            </c:if>
        </div>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 40px" />
	        <col style="width: auto" />
	        <col style="width: 300px" />
			<c:if test="${courseType eq 'period'}">
	        	<col style="width: 100px" />
        	</c:if>
	    </colgroup>
	    <thead>
	        <tr>
	            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
	            <th><spring:message code="필드:설문:설문제목" /></th>
	            <c:choose>
	            	<c:when test="${courseType eq 'period'}">
			            <th><spring:message code="필드:설문:시작기간" />|<spring:message code="필드:설문:종료기간" /></th>
	            	</c:when>
	            	<c:otherwise>
			            <th><spring:message code="필드:설문:시작일" />|<spring:message code="필드:설문:종료일" /></th>
	            	</c:otherwise>
            	</c:choose>
	            <c:if test="${courseType eq 'period'}">
	            	<th><spring:message code="필드:설문:상태" /></th>
	            </c:if>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:set var="index" 	   value="0"/>
	    	<c:forEach var="row" items="${surveyList}" varStatus="i">
		    	<tr>
		    		<td>
		    			<c:choose>
	            			<c:when test="${courseType eq 'period'}">
				                <input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
				                
				                <c:set var="index" value="${index + 1}"/>
	            			</c:when>
	            			<c:otherwise>
			    				<c:if test="${row.courseActiveSurvey.totalAnswerCount eq 0}">
					                <input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
					                
					                <c:set var="index" value="${index + 1}"/>
				                </c:if>
	            			</c:otherwise>
            			</c:choose>
		                <input type="hidden" name="courseActiveSurveySeqs" value="<c:out value="${row.courseActiveSurvey.courseActiveSurveySeq}"/>">
		                <input type="hidden" name="surveyPaperSeqs" value="<c:out value="${row.courseActiveSurvey.surveyPaperSeq}"/>">
		                <input type="hidden" name="surveySubjectSeqs" value="<c:out value="${row.surveySubject.surveySubjectSeq}"/>">
		            </td>
		            <td class="align-l">
		                <a href="javascript:doDetail({'courseActiveSurveySeq' : '<c:out value="${row.courseActiveSurvey.courseActiveSurveySeq}" />'});">
		                <c:out value="${row.surveySubject.surveyTitle}"/>
	                </a>
		            </td>
		            <td>
		            	<c:choose>
	            			<c:when test="${courseType eq 'period'}">
				                <aof:date datetime="${row.surveySubject.startDtime}" /> ~
				                <aof:date datetime="${row.surveySubject.endDtime}" />
	            			</c:when>
	            			<c:otherwise>
	            				<spring:message code="글:수강시작"/><c:out value="${row.surveySubject.startDay}" /><spring:message code="글:일부터"/> ~
	            				<c:out value="${row.surveySubject.endDay}" /><spring:message code="글:일까지"/>
	            			</c:otherwise>
            			</c:choose>
		            </td>
		            <c:if test="${courseType eq 'period'}">
			            <td>
			            	<c:choose>
			            		<c:when test="${appToday ge row.surveySubject.startDtime and appToday le row.surveySubject.endDtime}">
			            			<spring:message code="글:설문:진행중" />
			            		</c:when>
			            		<c:when test="${appToday gt row.surveySubject.endDtime}">
			            			<spring:message code="글:설문:종료" />
			            		</c:when>
			            		<c:when test="${appToday lt row.surveySubject.startDtime}">
			            			<spring:message code="글:설문:진행전" />
			            		</c:when>
			            	</c:choose>
			            </td>
		            </c:if>
		    	</tr>
	    	</c:forEach>
	        <c:if test="${empty surveyList}">
	            <tr>
	            	<c:choose>
		            	<c:when test="${courseType eq 'period'}">
			                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
		            	</c:when>
		            	<c:otherwise>
			                <td colspan="3" align="center"><spring:message code="글:데이터가없습니다" /></td>
		            	</c:otherwise>
	            	</c:choose>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l" style="display: none;" id="checkButtonBottom">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
            	<a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
            </c:if>
        </div>
        <div class="lybox-btn-r">
   			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
           		<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
       		</c:if>
        </div>
    </div>
    
</div>
</body>
</html>