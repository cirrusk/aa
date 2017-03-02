<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_ONOFF_TYPE_ON"                  value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"         value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"    value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"       value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"        value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>

<aof:session key="currentRoleCfString" var="currentRoleCfString"/>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata 		= null;
var forInsert   		= null;
var forScoreTarget   	= null;
var forBrowseExamPaper 	= null;
var forScoreTarget		= null;
var forBrowseTarget		= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	//datepicker
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>' });
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/course/active/${examType}/exampaper/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};
	
	forScoreTarget = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScoreTarget.config.url             = "<c:url value="/univ/course/active/${examType}/exampaper/target/score/count.do"/>";
	forScoreTarget.config.target          = "hiddenframe";
	forScoreTarget.config.fn.complete     = doCompleteScoreTarget;
	
	forBrowseExamPaper = $.action("layer");
	forBrowseExamPaper.config.formId         = "FormBrowseExamPaper";
	forBrowseExamPaper.config.url            = "<c:url value="/univ/exampaper/list/popup.do"/>";
	forBrowseExamPaper.config.options.width  = 700;
	forBrowseExamPaper.config.options.height = 500;
	forBrowseExamPaper.config.options.title  = "<spring:message code="글:시험:시험지매핑"/>";
	
	forBrowseTarget = $.action("layer");
	forBrowseTarget.config.formId         = "FormInsert";
	forBrowseTarget.config.url            = "<c:url value="/univ/course/active/exampaper/target/popup.do"/>";
	forBrowseTarget.config.options.width  = 900;
	forBrowseTarget.config.options.height = 580;
	forBrowseTarget.config.options.title  = "<spring:message code="글:시험:대상자보기"/>";
	
	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forInsert.validator.set(function(){
        var startDateTime = $("input[name=startDate]").val().replace(/-/gi,"") + $("select[name=startTime]").val();
        var endDateTime = $("input[name=endDate]").val().replace(/-/gi,"") + $("select[name=endTime]").val();
        
        if(startDateTime >= endDateTime){
            $.alert({message : "<spring:message code="글:시험:종료기간을시작기간보다큰값으로입력하십시오"/>"});
            return false;
        } else {
            return true;
        }
    });
	
	forInsert.validator.set({
		message : "<spring:message code="글:시험:시험지를선택하세요"/>",
		name : "examPaperSeq",
		data : ["!null"]
	});
	
	forInsert.validator.set({
        title : "<spring:message code="필드:시험:시작기간"/>",
        name : "startDate",
        data : ["!null"],
        check : {
            le : {name : "endDate", title : "<spring:message code="필드:시험:종료기간"/>"}
        }
    });
	
	forInsert.validator.set({
		message : "<spring:message code="필드:시험:배점비율"/>",
		name : "rate",
		data : ["!null", "number"],
		check : {
            le : 100
        }
	});
	
};
/**
 * 대상자 확인결과
 */
doCompleteScoreTarget = function(success) {
	jQuery("#applyCountText").val(success + " 명");
};

/**
 * 저장
 */
doInsert = function() {
	var startDate = $("input[name=startDate]").val();
	var startTime = $("select[name=startTime]").val();
	var endDate = $("input[name=endDate]").val();
    var endTime = $("select[name=endTime]").val();
	
    $("input[name=startDtime]").val(replaceAll(startDate)+startTime+'00');
    $("input[name=endDtime]").val(replaceAll(endDate)+endTime+'00');
    
	forInsert.run();
};
/**
 * 날짜형식변경
 */
replaceAll = function(str)
{
    return str.split("-").join("");
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 대상자 확인
 */
doScoreTarget = function() {
	jQuery("#limitScore").val(jQuery("#limitScorePrint").val());
	forScoreTarget.run();
};
/**
 * 대상자 확인결과
 */
doCompleteScoreTarget = function(success) {
	jQuery("#applyCountText").val(success + " 명");
};
/**
 * 대상자 팝업호출
 */
doBrowseTarget = function(){
	forBrowseTarget.run();
};
/**
 * 시험목록 보기 팝업
 */
doBrowseExamPaper = function() {
	var $form = jQuery("#FormInsert");
	var onOffCd = $form.find(":input[name='onOffCd']:checked").val();
	var courseMasterSeq = $form.find(":input[name='courseMasterSeq']").val();
	
	var $examForm = jQuery("#" + forBrowseExamPaper.config.formId);
	$examForm.find(":input[name='srchOnOffCd']").val(onOffCd);
	$examForm.find(":input[name='srchCourseMasterSeq']").val(courseMasterSeq);
	
	forBrowseExamPaper.run();
};
/**
 * 선택시험지 입력
 */
doSelect = function(returnValue) {
	var form = UT.getById(forInsert.config.formId);
	if (returnValue != null) {
		form.elements["examPaperSeq"].value = returnValue.examPaperSeq;
		form.elements["examPaperTitle"].value = returnValue.examPaperTitle;
	}
};
/**
 * onOff 선택시 시험지 팝업 파라미터 변경
 */
doChangeOnOffCd = function() {
	var $form = jQuery("#" + forInsert.config.formId);
	var onOffCd = $form.find(":input[name='onOffCd']").filter(":checked").val();
	
	var $examForm = jQuery("#" + forBrowseExamPaper.config.formId);
	$examForm.find(":input[name='srchOnOffCd']").val(onOffCd);
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

<c:choose>
	<c:when test="${examType eq 'middle'}">
		<c:import url="../include/commonCourseActiveElement.jsp">
		    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
		    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_MIDEXAM}"/>
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import url="../include/commonCourseActiveElement.jsp">
		    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
		    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_FINALEXAM}"/>
		</c:import>
	</c:otherwise>
</c:choose>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">

	 <c:import url="srchCourseActiveExamPaper.jsp" />

	<div class="lybox-title">
	    <h4 class="section-title">
	    	<c:choose>
	    		<c:when test="${examType eq 'middle'}">
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="필드:시험:중간고사" /><spring:message code="글:시험:등록" />
			    	</c:if>
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="글:시험:보충" /><spring:message code="필드:시험:중간고사" /><spring:message code="글:시험:등록" />
			    	</c:if>
	    		</c:when>
	    		<c:otherwise>
	    			<c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="필드:시험:기말고사" /><spring:message code="글:시험:등록" />
			    	</c:if>
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="글:시험:보충" /><spring:message code="필드:시험:기말고사" /><spring:message code="글:시험:등록" />
			    	</c:if>
	    		</c:otherwise>
	    	</c:choose>
	    </h4>
	</div>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${courseActiveExamPaper.courseActiveSeq}"/>"/>
	    <input type="hidden" name="referenceSeq" 	value="<c:out value="${courseActiveExamPaper.referenceSeq}"/>"/>
	    <input type="hidden" name="profMemberSeq"   value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
	    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	    <input type="hidden" name="basicSupplementCd" value="${courseActiveExamPaper.basicSupplementCd}"/>
	    <input type="hidden" name="editYn" value="N"/>
	    <input type="hidden" name="startDtime"/>
	    <input type="hidden" name="endDtime"/>
	    <input type="hidden" name="middleFinalTypeCd" value="${examType eq 'middle' ? CD_MIDDLE_FINAL_TYPE_MIDDLE : CD_MIDDLE_FINAL_TYPE_FINAL}"/>
	    <c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	    	<input type="hidden" name="rate" value="100"/>
	    </c:if>
	    
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	    <table class="tbl-detail">
	    <colgroup>
	        <col style="width: 140px" />
	        <col/>
	    </colgroup>
	    <tbody>
	        <tr>
	            <th>
	                <spring:message code="필드:시험:온오프라인"/> <span class="star">*</span>
	            </th>
	            <td>
	                <aof:code name="onOffCd" type="radio" codeGroup="ONOFF_TYPE" defaultSelected="${CD_ONOFF_TYPE_ON}" onclick="doChangeOnOffCd();"/>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:시험:대상자"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	            		<input type="text" name="limitScore" value="0" size="6" class="align-r"> 
	            		<spring:message code="글:시험:점이하"/>&nbsp;
	            		<a onclick="doScoreTarget();" class="btn gray"><span class="small"><spring:message code="버튼:확인"/></span></a>
	            		<div class="vspace"></div>
		                <c:out value="${applyCount}"/> <spring:message code="글:명"/> / <input type="text" id="applyCountText" value="<c:out value="${nonSubmitCount}"/> 명" disabled="disabled" size="6" class="align-r"> 
		            	&nbsp;
		            	<a href="#" onclick="doBrowseTarget();" class="btn gray"><span class="small"><spring:message code="버튼:시험:대상자보기"/></span></a>
		            </c:if>
		            <c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            	<c:out value="${applyCount}"/> <spring:message code="글:명"/>
		            </c:if>
	            </td>
	        </tr>
	        <c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		        <tr>
		        	<th>
		                <spring:message code="필드:시험:주차매핑"/>
		            </th>
		            <td>
		            	<select name="activeElementSeq">
		            		<option value=""><spring:message code="글:시험:사용안함"/></option>
		            		<c:forEach var="subRow" items="${elementList}" varStatus="j">
		            			<option value="${subRow.element.activeElementSeq}"><c:out value="${subRow.element.sortOrder}" /><spring:message code="글:시험:주차"/></option>
		            		</c:forEach>
		            	</select>
		            </td>
		        </tr>
	        </c:if>
	        <c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	        	<tr>
	        		<th>
		                <spring:message code="필드:시험:배점비율"/>
		            </th>
		            <td>
		            	<input type="text" name="rate" class="align-r" style="width:70px;" >
		            </td>
	        	</tr>
	        </c:if>
	        <tr>
	            <th>
	                <spring:message code="필드:시험:시험제목"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<a href="#" onclick="doBrowseExamPaper();" class="pop-call-btn" title="<spring:message code="글:시험:시험지팝업"/>" >&nbsp;</a>
	                <input type="text" name="examPaperTitle" style="width:350px;" readonly="readonly" >
	                <input type="hidden" name="examPaperSeq">
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:시험:시험기간"/> <span class="star">*</span>
	            </th>
	            <td>
	                <input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;">&nbsp;
	                <select name="startTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
	                </select>
	                <spring:message code="글:분"/>
	                ~
	                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;">&nbsp;
	                <select name="endTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true"/>
	                </select>
	                <spring:message code="글:분"/>
	            </td>
	        </tr>
	        <tr>
	        	<th>
	                <spring:message code="필드:시험:시험시간"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<input type="text" name="examTime" id="examTime" class="align-r" style="width: 70px;">&nbsp;<spring:message code="글:분"/>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:시험:성적공개여부"/> <span class="star">*</span>
	            </th>
	            <td>
	                
	                <aof:code type="radio" codeGroup="OPEN_YN" name="openYn" defaultSelected="Y" removeCodePrefix="true"/>
	            </td>
	        </tr>
	    </tbody>
	    </table>
	    </form>
	    <div class="lybox-btn">
	        <div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	                <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
	            </c:if>
	            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	        </div>
	    </div>
	  </div>
	</body>
</html>