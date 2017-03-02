<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"       value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_QUIZ" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.QUIZ')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'QUIZ'}">
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
    forListdata.config.url    = "<c:url value="/univ/course/active/quiz/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/active/quiz/detail.do"/>";
    
    forCreate = $.action();
    forCreate.config.formId = "FormCreate";
    forCreate.config.url    = "<c:url value="/univ/course/active/quiz/create.do"/>";
    
    forUpdateRate = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateRate.config.url             = "<c:url value="/univ/course/active/quiz/rate/update.do"/>";
    forUpdateRate.config.target          = "hiddenframe";
    forUpdateRate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdateRate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateRate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateRate.config.fn.complete     = function() {
		doList();
	};
	
	forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/course/active/quiz/deletelist.do"/>";
    forDeletelist.config.target          = "hiddenframe";
    forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDeletelist.config.fn.complete     = doCompleteDeletelist;
    forDeletelist.validator.set({
        title : "<spring:message code="필드:삭제할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
    
    
    setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forUpdateRate.validator.set(function(){
		var rateSum = 0;
		$("input[name=rates]").each(function(){
			rateSum = parseFloat(rateSum) + parseFloat($(this).val());
		});
        
        if(rateSum == 100){
            return true;
        } else {
            $.alert({message : "<spring:message code='글:과제:평가비율총합은100%이어야합니다.'/>",
                    button1 : {
                        callback : function() {
                            $("input[name=rates]").eq(0).focus();
                            }
                         }
                    });
            return false;
        }
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
 * 평가비율을 호출하는 함수
 */
doUpdateRate = function() {
    forUpdateRate.run();
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
/**
 * 평가비율 합 계산
 */
doRateSum = function(obj){
	var rateSum = 0;
    $("input[name=rates]").each(function(){
    	if($.isNumeric($(this).val())){
    		rateSum = parseFloat(rateSum) + parseFloat($(this).val());	
    	}
       
    });
    
    $("#totalRate").html(rateSum.toFixed(1) +"%");
    
    if(rateSum > 100){
    	$.alert({message : "<spring:message code='글:퀴즈:평가비율총합은100%이어야합니다'/>"});
    }
};
/** 배점 비율 변경이 한번이라도 일어나면 저장 옆에 경고 문구 띄운다.*/
changeShow = function() {
	jQuery("#warning").show();
}
</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
</c:import>
	
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
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_QUIZ}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">
    <!-- 평가기준 Start Area -->
    <c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>
    <!-- 평가기준 Start End -->
    
 <c:import url="srchCourseActiveQuiz.jsp" />
 
 <div class="mt10"></div>
 
    <div class="lybox-title">
        <h4 class="section-title"><spring:message code="필드:퀴즈:구성항목" /></h4>
        <div class="right">
            <c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
                <a href="javascript:void(0);" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" ><span class="small"><spring:message code="버튼:퀴즈:퀴즈결과" /></span></a>
            </c:if>
        </div>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 40px" />
	        <col style="width: auto" />
	        <col style="width: 300px" />
	        <col style="width: 100px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
	            <th><spring:message code="필드:퀴즈:퀴즈제목" /></th>
	            <c:choose>
	            	<c:when test="${courseType eq 'period'}">
			            <th><spring:message code="필드:퀴즈:응시기간" /></th>
	            	</c:when>
	            	<c:otherwise>
	            		<th><spring:message code="필드:퀴즈:시작일" />|<spring:message code="필드:퀴즈:종료일" /></th>
	            	</c:otherwise>
            	</c:choose>
	            <th><spring:message code="필드:퀴즈:평가비율" /></th>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:set var="totalRate" value="0"/>
	    	<c:set var="index" 	   value="0"/>
	    	<c:forEach var="row" items="${quizList}" varStatus="i">
		    	<tr>
		    		<td>
		    			<c:choose>
	            			<c:when test="${courseType eq 'period'}">
			    				<c:if test="${row.courseActiveExamPaper.startDtime gt appToday}">
					                <input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
					                <input type="hidden" name="examPaperSeqs" value="<c:out value="${row.courseActiveExamPaper.examPaperSeq}"/>">
					                
					                <c:set var="index" value="${index + 1}"/>
				                </c:if>
	            			</c:when>
	            			<c:otherwise>
			    				<c:if test="${row.courseActiveExamPaper.answerCount eq 0}">
					                <input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
					                <input type="hidden" name="examPaperSeqs" value="<c:out value="${row.courseActiveExamPaper.examPaperSeq}"/>">
					                
					                <c:set var="index" value="${index + 1}"/>
				                </c:if>
	            			</c:otherwise>
            			</c:choose>
		                <input type="hidden" name="courseActiveExamPaperSeqs" value="<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>">
		                <input type="hidden" name="middleFinalTypeCds" value="<c:out value="${row.courseActiveExamPaper.middleFinalTypeCd}"/>">
		            </td>
		            <td class="align-l">
		                <a href="javascript:doDetail({'courseActiveExamPaperSeq' : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}" />'});"><c:out value="${row.courseExamPaper.examPaperTitle}"/></a>
		            </td>
		            <td>
		                <c:choose>
	            			<c:when test="${courseType eq 'period'}">
				                <aof:date datetime="${row.courseActiveExamPaper.startDtime}" /> ~
				                <aof:date datetime="${row.courseActiveExamPaper.endDtime}" />
	            			</c:when>
	            			<c:otherwise>
	            				<spring:message code="글:수강시작"/><c:out value="${row.courseActiveExamPaper.startDay}" /><spring:message code="글:일부터"/> ~
	            				<c:out value="${row.courseActiveExamPaper.endDay}" /><spring:message code="글:일까지"/>
	            			</c:otherwise>
            			</c:choose>
		            </td>
		            <td>
		            	<input type="hidden" name="rateHomeworkSeqs" value="<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>">
		                <input type="text" name="rates" value="<aof:number value="${row.courseActiveExamPaper.rate}" pattern="##" />" onchange="changeShow()" onkeyup="doRateSum()" style="width:40px;" maxlength="4" class="align-r"/> %
		                <c:set var="totalRate" value="${totalRate + row.courseActiveExamPaper.rate}"/>
		            </td>
		    	</tr>
	    	</c:forEach>
	        <c:if test="${empty quizList}">
	            <tr>
	                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
           		<c:if test="${!empty quizList}">
		    		<span id="warning" style="display: none; color: red;"><spring:message code="글:과제:저장되지않은데이터가존재합니다" /></span>
		    		<a href="javascript:void(0)" onclick="doUpdateRate()" class="btn blue"><span class="mid"><spring:message code="버튼:과제:비율저장" /></span></a>
           		</c:if>
           		<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
       		</c:if>
        </div>
    </div>
    
</div>
</body>
</html>