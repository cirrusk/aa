<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_MIDEXAM"    value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.MIDEXAM')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_FINALEXAM"  value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.FINALEXAM')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"         value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"    value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_MIDDLE"       value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.MIDDLE')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_FINAL"        value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.FINAL')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>
<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata 		= null;
var forupdate 		   	= null;
var forBrowseExamPaper 	= null;
var forScoreTarget		= null;
var forBrowseTarget		= null;
var forDelete			= null;
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

	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/active/${examType}/exampaper/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/univ/course/active/${examType}/exampaper/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	forScoreTarget = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forScoreTarget.config.url             = "<c:url value="/univ/course/active/exampaper/target/score/updatecount.do"/>";
	forScoreTarget.config.target          = "hiddenframe";
	forScoreTarget.config.message.confirm = "<spring:message code="글:과제:대상자를재설정하시겠습니까"/>"; 
	forScoreTarget.config.fn.complete     = doCompleteScoreTarget;
	
	forBrowseExamPaper = $.action("layer");
	forBrowseExamPaper.config.formId         = "FormBrowseExamPaper";
	forBrowseExamPaper.config.url            = "<c:url value="/univ/exampaper/list/popup.do"/>";
	forBrowseExamPaper.config.options.width  = 700;
	forBrowseExamPaper.config.options.height = 500;
	forBrowseExamPaper.config.options.title  = "<spring:message code="글:시험:시험지매핑"/>";
	
	forBrowseTarget = $.action("layer");
	forBrowseTarget.config.formId         = "FormUpdate";
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
	
	forUpdate.validator.set(function(){
        var startDateTime = $("input[name=startDate]").val().replace(/-/gi,"") + $("select[name=startTime]").val();
        var endDateTime = $("input[name=endDate]").val().replace(/-/gi,"") + $("select[name=endTime]").val();
        
        if(startDateTime >= endDateTime){
            $.alert({message : "<spring:message code="글:시험:종료기간을시작기간보다큰값으로입력하십시오"/>"});
            return false;
        } else {
            return true;
        }
    });
	
	forUpdate.validator.set({
		message : "<spring:message code="필드:시험:시험시간"/>",
		name : "examTime",
		data : ["!null", "number"],
		check : {
            maxlength : 3
        }
	});
	
	forUpdate.validator.set({
		message : "<spring:message code="필드:시험:배점비율"/>",
		name : "rate",
		data : ["!null", "number"],
		check : {
            le : 100
        }
	});

};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정
 */
doUpdate = function() {
	var startDate = $("input[name=startDate]").val();
	var startTime = $("select[name=startTime]").val();
	var endDate = $("input[name=endDate]").val();
    var endTime = $("select[name=endTime]").val();
    
    $("input[name=startDtime]").val(replaceAll(startDate)+startTime+'00');
    $("input[name=endDtime]").val(replaceAll(endDate)+endTime+'00');
    
    forUpdate.run();
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
 * 삭제
 */
 doDelete = function() {
	 forDelete.run();
}; 
/**
 * 날짜형식변경
 */
replaceAll = function(str)
{
    return str.split("-").join("");
};
/**
 * 시험목록 보기 팝업
 */
doBrowseExamPaper = function() {
	var $form = jQuery("#FormUpdate");
	var onOffCd = $form.find(":input[name='onOffCd']").val();
	var courseMasterSeq = $form.find(":input[name='courseMasterSeq']").val();
	
	var $examForm = jQuery("#" + forBrowseExamPaper.config.formId);
	$examForm.find(":input[name='srchOnOffCd']").val(onOffCd);
	$examForm.find(":input[name='srchCourseMasterSeq']").val(courseMasterSeq);
	
	forBrowseExamPaper.run();
};
/**
 * 시험지 정보 넣기
 */
doSelect = function(returnValue) {
	var form = UT.getById(forUpdate.config.formId);
	if (returnValue != null) {
		form.elements["examPaperSeq"].value = returnValue.examPaperSeq;
		form.elements["examPaperTitle"].value = returnValue.examPaperTitle;
	}
};
</script>
</head>

<body>

<c:import url="srchCourseActiveExamPaper.jsp"></c:import>
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

	<div class="lybox-title">
	    <h4 class="section-title">
	    	<c:choose>
	    		<c:when test="${examType eq 'middle'}">
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="필드:시험:중간고사" /><spring:message code="글:시험:수정" />
			    	</c:if>
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="글:시험:보충" /><spring:message code="필드:시험:중간고사" /><spring:message code="글:시험:수정" />
			    	</c:if>
	    		</c:when>
	    		<c:otherwise>
	    			<c:if test="${courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="필드:시험:기말고사" /><spring:message code="글:시험:수정" />
			    	</c:if>
			    	<c:if test="${courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			    		<spring:message code="글:시험:보충" /><spring:message code="필드:시험:기말고사" /><spring:message code="글:시험:수정" />
			    	</c:if>
	    		</c:otherwise>
	    	</c:choose>
	    </h4>
	</div>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveExamPaperSeq" value="<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>"/>
		<input type="hidden" name="referenceSeq" 	value="<c:out value="${detail.courseActiveExamPaper.referenceSeq}"/>"/>
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActiveExamPaper.courseActiveSeq}"/>"/>
		<input type="hidden" name="courseMasterSeq" value="<c:out value="${detail.courseActiveExamPaper.courseMasterSeq}"/>"/>
		<input type="hidden" name="profMemberSeq"   value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
		<input type="hidden" name="basicSupplementCd" value="<c:out value="${detail.courseActiveExamPaper.basicSupplementCd}"/>"/>
		<input type="hidden" name="middleFinalTypeCd" value="${examType eq 'middle' ? CD_MIDDLE_FINAL_TYPE_MIDDLE : CD_MIDDLE_FINAL_TYPE_FINAL}"/>
		<input type="hidden" name="editYn" value="Y"/>
		<c:if test="${detail.courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
			<input type="hidden" name="rate" value="100"/>
		</c:if>
		
		
		<input type="hidden" name="startDtime"/>
	    <input type="hidden" name="endDtime"/>
	    
		<table class="tbl-detail">
		<colgroup>
		    <col style="width: 140px" />
		    <col/>
		</colgroup>
		<tbody>
		    <tr>
		        <th><spring:message code="필드:시험:온오프라인"/></th>
		        <td>
		            <aof:code name="onOffCd" type="print" codeGroup="ONOFF_TYPE" selected="${detail.courseActiveExamPaper.onOffCd}" />
		            <input type="hidden" name="onOffCd" value="<c:out value="${detail.courseActiveExamPaper.onOffCd}"/>"/>
		        </td>
		    </tr>
		    <tr>
		        <th><spring:message code="필드:시험:대상자"/></th>
		        <td>
		            <c:if test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		           		<input type="text"   name="limitScorePrint" id="limitScorePrint" value="" size="6" class="align-r"> 
		           		<input type="hidden" name="limitScore"      id="limitScore"      value="" size="6" class="align-r"> 
		           		<spring:message code="글:시험:점이하"/>&nbsp;
		           		<a onclick="doScoreTarget();" class="btn gray"><span class="small"><spring:message code="버튼:확인"/></span></a>
		           		<div class="vspace"></div>
		                <c:out value="${targetCount}"/> <spring:message code="글:명"/> / <input type="text" id="applyCountText" value="<c:out value="${detail.courseActiveExamPaper.targetCount}"/> 명" disabled="disabled" size="6" class="align-r"> 
		            	&nbsp;
		            	<a href="#" onclick="doBrowseTarget();" class="btn gray"><span class="small"><spring:message code="버튼:과제:대상자수정"/></span></a>
		            </c:if>
		            <c:if test="${detail.courseActiveExamPaper.basicSupplementCd ne CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            	<c:out value="${detail.courseActiveExamPaper.targetCount}"/> <spring:message code="글:명"/>
		            </c:if>
		        </td>
		    </tr>
		    <c:if test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		    	<tr>
		    		<th><spring:message code="필드:시험:주차매핑"/></th>
		    		<td>
		    			<c:set var="oldElementSeq" />
		    			<select name="activeElementSeq">
			           		<option value=""><spring:message code="글:시험:사용안함"/></option>
			           		<c:forEach var="row" items="${elementList}" varStatus="j">
			           			<option value="${row.element.activeElementSeq}" <c:if test="${row.element.referenceSeq eq detail.courseActiveExamPaper.courseActiveExamPaperSeq}"> selected="selected"</c:if> ><c:out value="${row.element.sortOrder}" /><spring:message code="글:시험:주차"/></option>
			           			<c:if test="${row.element.referenceSeq eq detail.courseActiveExamPaper.courseActiveExamPaperSeq}">
			           				<c:set var="oldElementSeq" value="${row.element.activeElementSeq}"/>
			           			</c:if>
		           		</c:forEach>
		           	</select>
		           	<input type="hidden" name="oldActiveElementSeq" value="${oldElementSeq}">
		    		</td>
		    	</tr>
		    </c:if>
		    <c:if test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
	        	<tr>
	        		<th>
		                <spring:message code="필드:시험:배점비율"/>
		            </th>
		            <td>
		            	<input type="text" name="rate" class="align-r" style="width:70px;" value="${detail.courseActiveExamPaper.rate}" >
		            </td>
	        	</tr>
	        </c:if>
		    <tr>
		        <th><spring:message code="필드:시험:시험제목"/></th>
		        <td>
		           	<a href="#" onclick="doBrowseExamPaper();" class="pop-call-btn" title="<spring:message code="글:시험:시험지팝업"/>" >&nbsp;</a>
		               <input type="text" name="examPaperTitle" style="width:350px;" readonly="readonly" value="${detail.courseExamPaper.examPaperTitle}">
		               <input type="hidden" name="examPaperSeq" value="${detail.courseActiveExamPaper.examPaperSeq}">
		               <input type="hidden" name="oldExamPaperSeq" value="${detail.courseActiveExamPaper.examPaperSeq}">
	           </td>
		    </tr>
		    <tr>
		        <th><spring:message code="필드:시험:시험기간"/></th>
		        <td>
		        	<input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseActiveExamPaper.startDtime}"/>">&nbsp;
	                <select name="startTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseActiveExamPaper.startDtime,8,12)}"/>
	                </select>
	                <spring:message code="글:분"/>
	                ~
	                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.courseActiveExamPaper.endDtime}"/>">&nbsp;
	                <select name="endTime">
	                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.courseActiveExamPaper.endDtime,8,12)}"/>
	                </select>
	                <spring:message code="글:분"/>
		        </td>
		    </tr>
		    <tr>
		    	<th><spring:message code="필드:시험:시험시간"/></th>
		    	<td>
		    		<input type="text" name="examTime" value="<c:out value="${detail.courseActiveExamPaper.examTime}" />">&nbsp;<spring:message code="글:분" />
		    	</td>
		    </tr>
		    <tr>
		    	<th><spring:message code="필드:시험:성적공개여부"/></th>
		    	<td>
		    		
	               <aof:code type="radio" codeGroup="OPEN_YN" name="openYn" selected="${detail.courseActiveExamPaper.openYn}" removeCodePrefix="true"/>
		    	</td>
		    </tr>
		</tbody>
		</table>
	</form>
	 
	    <div class="lybox-btn">
	    	<div class="lybox-btn-l">
	    		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D')}">
					<a href="javascript:void(0)" onclick="doDelete();" class="btn blue"><span class="mid"><spring:message code="버튼:삭제"/></span></a>
				</c:if>
			</div>
	        <div class="lybox-btn-r">
	            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	                <a href="javascript:void(0)" onclick="doUpdate();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
	            </c:if>
	            <a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
	        </div>
	    </div>
	    
	  </div>
	  
	<form name="FormDelete" id="FormDelete" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveExamPaperSeq" 	value="<c:out value="${detail.courseActiveExamPaper.courseActiveExamPaperSeq}"/>"/>
		<input type="hidden" name="examPaperSeq" 	value="<c:out value="${detail.courseActiveExamPaper.examPaperSeq}"/>"/>
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="basicSupplementCd" value="<c:out value="${detail.courseActiveExamPaper.basicSupplementCd}"/>"/>
		<c:choose>
			<c:when test="${examType eq 'middle'}">
				<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_MIDDLE}"/>"/> 
			</c:when>
			<c:when test="${examType eq 'final'}">
				<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_FINAL}"/>"/> 
			</c:when>
		</c:choose>
		<c:if test="${detail.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
			<c:forEach var="subRow" items="${elementList}" varStatus="j">
				<c:if test="${subRow.element.referenceSeq eq detail.courseActiveExamPaper.courseActiveExamPaperSeq}">
			    	<input type="hidden" name="activeElementSeq" 	value="<c:out value="${oldElementSeq}"/>"/>
			    </c:if>
			</c:forEach>
		</c:if>
		
	    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>

	</body>
</html>