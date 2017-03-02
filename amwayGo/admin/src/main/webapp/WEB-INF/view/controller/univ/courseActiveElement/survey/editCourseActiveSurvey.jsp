<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"         value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_TYPE_PERIOD"         value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_LIMIT_STANDARD_NO"          value="${aoffn:code('CD.LIMIT_STANDARD.NO')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_SURVEY" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.SURVEY')}"/>

<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:set var="courseType" value="period" />
<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
	<c:set var="courseType" value="always" />
</c:if>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COURSE_TYPE_PERIOD = "<c:out value="${CD_COURSE_TYPE_PERIOD}"/>";
var CD_LIMIT_STANDARD_NO = "<c:out value="${CD_LIMIT_STANDARD_NO}"/>";

var forListdata 			= null;
var forupdate 		   		= null;
var forDelete				= null;
var forBrowseSurveyPaper 	= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	<c:if test="${courseType eq 'period'}">
		//datepicker
		UI.datepicker("#startDate,#endDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>' });
	</c:if>
	
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/survey/list.do"/>";

	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/univ/course/active/survey/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdate.config.fn.complete     = function() {
		doList();
	};
	
	forDelete = $.action("submit");
	forDelete.config.formId          = "FormDelete"; 
	forDelete.config.url             = "<c:url value="/univ/course/active/survey/delete.do"/>";
	forDelete.config.target          = "hiddenframe";
	forDelete.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDelete.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDelete.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDelete.config.fn.complete     = function() {
		doList();
	};
	
	forBrowseSurveyPaper = $.action("layer");
	forBrowseSurveyPaper.config.formId         = "FormBrowseSurveyPaper";
	forBrowseSurveyPaper.config.url            = "<c:url value="/univ/surveypaper/list/popup.do"/>";
	forBrowseSurveyPaper.config.options.width  = 700;
	forBrowseSurveyPaper.config.options.height = 500;
	forBrowseSurveyPaper.config.options.title  = "<spring:message code="글:설문:설문지매핑"/>";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:설문:시작기간"/>",
        name : "startDate",
        data : ["!null"],
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "period" ? true : false;
		}
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:설문:종료기간"/>",
        name : "endDate",
        data : ["!null"],
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "period" ? true : false;
		}
    });
	
	forUpdate.validator.set(function(){
		var courseType = '<c:out value="${courseType}" />';
		if(courseType == "period"){
			var startDtime = $("input[name=startDate]").val()+$("select[name=startTime]").val();
			var endDtime = $("input[name=endDate]").val()+$("select[name=endTime]").val();
			
			if(startDtime >= endDtime) {
				 $.alert({message : "<spring:message code="글:설문:종료기간을시작기간보다큰값으로입력하십시오"/>"});
				return false;
			} else {
				return true;
			}
		} else {
			return false;
		}
	});
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:시험:시작일"/>",
        name : "startDay",
        data : ["!null","number"],
        check : {
            le : {name : "endDay", title : "<spring:message code="필드:시험:종료일"/>"}
        },
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "always" ? true : false;
		}
    });
	
	forUpdate.validator.set({
        title : "<spring:message code="필드:시험:종료일"/>",
        name : "endDay",
        data : ["!null","number"],
        check : {
            le : {name : "studyDayOfCourseActive", title : "<spring:message code="글:총학습일수"/>"}
        },
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "always" ? true : false;
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
	var courseType = $("input[name=shortcutCourseTypeCd]").val();
	if (courseType == CD_COURSE_TYPE_PERIOD) {
		var startDate = $("input[name=startDate]").val();
		var startTime = $("select[name=startTime]").val();
		var endDate = $("input[name=endDate]").val();
	    var endTime = $("select[name=endTime]").val();
	    
	    $("input[name=startDtime]").val(replaceAll(startDate)+startTime+'00');
	    $("input[name=endDtime]").val(replaceAll(endDate)+endTime+'00');
	}
    
    var $form = jQuery("#" + forUpdate.config.formId);
    var limitStandardCd = $form.find(":input[name='limitStandardCd']").val();
	if (limitStandardCd == CD_LIMIT_STANDARD_NO) { 
		$form.find(":input[name='limitProgress']").val(0);
	} 
    
    forUpdate.run();
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
doBrowseSurveyPaper = function() {
	 forBrowseSurveyPaper.run();
};
/**
 * 선택시험지 입력
 */
doSelect = function(returnValue) {
	var form = UT.getById(forUpdate.config.formId);
	if (returnValue != null) {
		form.elements["surveyPaperSeq"].value = returnValue.surveyPaperSeq;
		form.elements["surveyPaperTitle"].value = returnValue.surveyPaperTitle;
	}
};
</script>
</head>

<body>

<c:set var="madatoryCd">Y=<spring:message code="글:설문:필수"/>,N=<spring:message code="글:설문:필수아님"/></c:set>
<c:set var="accessPlace">calssroom=<spring:message code="글:설문:강의실"/>,gradeReview=<spring:message code="글:설문:성적조회"/></c:set>

<c:import url="srchCourseActiveSurvey.jsp"></c:import>
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

	<div class="lybox-title">
	    <h4 class="section-title">
    		<spring:message code="글:설문:설문수정" />
	    </h4>
	</div>
	
	<form id="FormUpdate" name="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActiveSurvey.courseActiveSeq}"/>"/>
		<input type="hidden" name="courseActiveSurveySeq" value="<c:out value="${detail.courseActiveSurvey.courseActiveSurveySeq}"/>"/>
		<input type="hidden" name="surveySubjectSeq" value="<c:out value="${detail.surveySubject.surveySubjectSeq}"/>"/>
		
		<input type="hidden" name="startDtime"/>
	    <input type="hidden" name="endDtime"/>
	    <input type="hidden" name="accessMenu" value="calssroom"/>
	    
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
		<table class="tbl-detail">
		<colgroup>
		    <col style="width: 140px" />
		    <col/>
		</colgroup>
		<tbody>
		    <tr>
	            <th>
	                <spring:message code="필드:설문:설문제목"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<a href="#" onclick="doBrowseSurveyPaper();" class="pop-call-btn" title="<spring:message code="글:설문:설문팝업"/>" >&nbsp;</a>
	                <input type="text" name="surveyPaperTitle" style="width:350px;" value="${detail.surveySubject.surveyTitle}">
	                <input type="hidden" name="surveyPaperSeq" value="${detail.courseActiveSurvey.surveyPaperSeq}">
	                <input type="hidden" name="oldSurveyPaperSeq" value="${detail.courseActiveSurvey.surveyPaperSeq}">
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:설문:설문기간"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<c:choose>
	            		<c:when test="${courseType eq 'period'}">
			                <input type="text" name="startDate" id="startDate" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.surveySubject.startDtime}"/>">&nbsp;
			                <select name="startTime">
			                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.surveySubject.startDtime,8,12)}"/>
			                </select>
			                <spring:message code="글:분"/>
			                ~
			                <input type="text" name="endDate" id="endDate" class="datepicker" readonly="readonly" style="width: 70px;" value="<aof:date datetime="${detail.surveySubject.endDtime}"/>">&nbsp;
			                <select name="endTime">
			                    <aof:code type="option" codeGroup="TIME" removeCodePrefix="true" selected="${fn:substring(detail.surveySubject.endDtime,8,12)}"/>
			                </select>
			                <spring:message code="글:분"/>
	            		</c:when>
	            		<c:otherwise>
	            			<spring:message code="글:수강시작"/><input type="text" name="startDay" id="startDay" class="align-r" style="width: 50px;" value="${detail.surveySubject.startDay}"><spring:message code="글:일부터"/> ~
	            			<input type="text" name="endDay" id="endDay" class="align-r" style="width: 50px;" value="${detail.surveySubject.endDay}"><spring:message code="글:일까지"/>
	            			(<spring:message code="글:이과정은"/><c:out value="${studyDayOfCourseActive}"/><spring:message code="글:일과정입니다"/>)
	            			<input type="hidden" name="studyDayOfCourseActive" value="<c:out value="${studyDayOfCourseActive}"/>"/>
	            		</c:otherwise>
            		</c:choose>
	            </td>
	        </tr>
	        <tr>
	        	<th>
	        		<spring:message code="필드:설문:필수여부"/>
	        	</th>
	        	<td>
        			<aof:code type="radio" name="mandatoryYn" codeGroup="${madatoryCd}" selected="${detail.surveySubject.mandatoryYn}"/>
	        	</td>
	        </tr>
	        <tr>
	        	<th>
	        		<spring:message code="필드:설문:사용여부"/>
	        	</th>
	        	<td>
        			<aof:code type="radio" name="useYn" codeGroup="OPEN_YN" selected="${detail.surveySubject.useYn}" removeCodePrefix="true"/>
	        	</td>
	        </tr>
	        <%--
	        <tr>
	        	<th>
	        		<spring:message code="필드:설문:접근메뉴"/>
	        	</th>
	        	<td>
	        		<select name="accessMenu">
	        			<aof:code type="option" codeGroup="${accessPlace}" selected="${detail.surveySubject.accessMenu}" />
	        		</select>
	      		</td>
	        </tr>
	         --%>
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
		<input type="hidden" name="courseActiveSurveySeq" 	value="<c:out value="${detail.courseActiveSurvey.courseActiveSurveySeq}"/>"/>
		<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
		<input type="hidden" name="surveyPaperSeq" value="<c:out value="${detail.courseActiveSurvey.surveyPaperSeq}"/>"/>
		<input type="hidden" name="surveySubjectSeq" value="<c:out value="${detail.surveySubject.surveySubjectSeq}"/>"/>
		
	    <input type="hidden" name="shortcutYearTerm" 		 value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	</form>

	</body>
</html>