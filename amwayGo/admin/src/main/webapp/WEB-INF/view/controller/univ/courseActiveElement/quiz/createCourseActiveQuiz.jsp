<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"       value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_TYPE_PERIOD"       value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_LIMIT_STANDARD_YES"       value="${aoffn:code('CD.LIMIT_STANDARD.YES')}"/>
<c:set var="CD_LIMIT_STANDARD_NO"        value="${aoffn:code('CD.LIMIT_STANDARD.NO')}"/>
<c:set var="CD_ONOFF_TYPE_ON"            value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_QUIZ" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.QUIZ')}"/>
<c:set var="CD_MIDDLE_FINAL_TYPE_QUIZ"   value="${aoffn:code('CD.MIDDLE_FINAL_TYPE.QUIZ')}"/>

<aof:session key="currentRoleCfString" var="currentRoleCfString"/>

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
var CD_LIMIT_STANDARD_YES = "<c:out value="${CD_LIMIT_STANDARD_YES}"/>";

var forListdata 		= null;
var forInsert   		= null;
var forBrowseQuiz 		= null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	<c:if test="${courseType eq 'period'}">
		//datepicker
		UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>' });
	</c:if>
	
	showLimitProgress();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/active/quiz/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/course/active/quiz/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = function() {
		doList();
	};
	
	forBrowseQuiz = $.action("layer");
	forBrowseQuiz.config.formId         = "FormBrowseExamPaper";
	forBrowseQuiz.config.url            = "<c:url value="/univ/exampaper/list/popup.do"/>";
	forBrowseQuiz.config.options.width  = 700;
	forBrowseQuiz.config.options.height = 500;
	forBrowseQuiz.config.options.title  = "<spring:message code="글:시험:시험지매핑"/>";
	
	setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		message : "<spring:message code="글:퀴즈:퀴즈를선택하세요"/>",
		name : "examPaperSeq",
		data : ["!null"]
	});
	
	forInsert.validator.set({
        title : "<spring:message code="필드:퀴즈:시작기간"/>",
        name : "startDate",
        data : ["!null"],
        check : {
            le : {name : "endDate", title : "<spring:message code="필드:퀴즈:종료기간"/>"}
        },
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "period" ? true : false;
		}
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:퀴즈:종료기간"/>",
        name : "endDate",
        data : ["!null"],
        check : {
            gt : {name : "startDate", title : "<spring:message code="필드:퀴즈:시작기간"/>"}
        },
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "period" ? true : false;
		}
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:퀴즈:시작일"/>",
        name : "startDay",
        data : ["!null","number"],
        check : {
            le : {name : "endDay", title : "<spring:message code="필드:퀴즈:종료일"/>"}
        },
        when : function() {
			var courseType = '<c:out value="${courseType}" />';
			return courseType == "always" ? true : false;
		}
    });
	
	forInsert.validator.set({
        title : "<spring:message code="필드:퀴즈:종료일"/>",
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
	
	forInsert.validator.set({
		title : "<spring:message code="필드:퀴즈:응시시간"/>",
		name : "examTime",
		data : ["!null", "number"],
		check : {
            maxlength : 3
        }
	});
	
	forInsert.validator.set({
		title : "<spring:message code="필드:퀴즈:진도율" />",
		name : "limitProgress",
		data : ["!null","number"],
		check : {
			le : 100
		},
		when : function() {
			var limitStandardCd = UT.getCheckedValue(forInsert.config.formId, "limitStandardCd", "");
			return limitStandardCd == CD_LIMIT_STANDARD_YES ? true : false;
		}
	});
	
};
/**
 * 저장
 */
doInsert = function() {
var courseType = '<c:out value="${courseType}"/>';
	
	if (courseType == 'period') {
		var startDate = $("input[name=startDate]").val();
		var startTime = $("select[name=startTime]").val();
		var endDate = $("input[name=endDate]").val();
	    var endTime = $("select[name=endTime]").val();
		
	    $("input[name=startDtime]").val(replaceAll(startDate)+startTime+'00');
	    $("input[name=endDtime]").val(replaceAll(endDate)+endTime+'00');
	}
    
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
 * 시험목록 보기 팝업
 */
 doBrowseQuiz = function() {
	forBrowseQuiz.run();
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
 * 제한 기준 변경
 */
showLimitProgress = function(element) {
	var $form = jQuery("#" + forInsert.config.formId);
	var limitStandardCd = $form.find(":input[name='limitStandardCd']").val();
	if (limitStandardCd == CD_LIMIT_STANDARD_YES) {
		jQuery("#limitArea").show(); 
	} else {
		jQuery("#limitArea").hide(); 
	}
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
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_QUIZ}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">
    
<c:import url="srchCourseActiveQuiz.jsp" />
 
<div class="vspace"></div>

<div id="tabContainer">

	<div class="lybox-title">
	    <h4 class="section-title">
    		<spring:message code="글:퀴즈:퀴즈등록" />
	    </h4>
	</div>
	
	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	    <input type="hidden" name="courseActiveSeq" value="<c:out value="${courseActiveExamPaper.courseActiveSeq}"/>"/>
	    <input type="hidden" name="profMemberSeq"   value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
	    <input type="hidden" name="courseMasterSeq" value="<c:out value="${courseActive.courseActive.courseMasterSeq}"/>"/>
	    <input type="hidden" name="middleFinalTypeCd" value="<c:out value="${CD_MIDDLE_FINAL_TYPE_QUIZ}"/>"/>
	    <input type="hidden" name="onOffCd" value="<c:out value="${CD_ONOFF_TYPE_ON}"/>"/>
	    <input type="hidden" name="startDtime"/>
	    <input type="hidden" name="endDtime"/>
    	<input type="hidden" name="rate" value="0"/>
	    
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	
	    <table class="tbl-detail mt10">
	    <colgroup>
	        <col style="width: 140px" />
	        <col/>
	    </colgroup>
	    <tbody>
	        <tr>
	            <th>
	                <spring:message code="필드:퀴즈:퀴즈제목"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<a href="#" onclick="doBrowseQuiz();" class="pop-call-btn" title="<spring:message code="글:퀴즈:퀴즈팝업"/>" >&nbsp;</a>
	                <input type="text" name="examPaperTitle" style="width:350px;" readonly="readonly" >
	                <input type="hidden" name="examPaperSeq">
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:퀴즈:응시기간"/> <span class="star">*</span>
	            </th>
	            <td>
	                <c:choose>
	            		<c:when test="${courseType eq 'period'}">
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
	            		</c:when>
	            		<c:otherwise>
	            			<spring:message code="글:수강시작"/><input type="text" name="startDay" id="startDay" class="align-r" style="width: 50px;"><spring:message code="글:일부터"/> ~
	            			<input type="text" name="endDay" id="endDay" class="align-r" style="width: 50px;"><spring:message code="글:일까지"/>
	            			(<spring:message code="글:이과정은"/><c:out value="${studyDayOfCourseActive}"/><spring:message code="글:일과정입니다"/>)
	            			<input type="hidden" name="studyDayOfCourseActive" value="<c:out value="${studyDayOfCourseActive}"/>"/>
	            		</c:otherwise>
	            	</c:choose>
	            </td>
	        </tr>
	        <tr>
	        	<th>
	                <spring:message code="필드:퀴즈:응시시간"/> <span class="star">*</span>
	            </th>
	            <td>
	            	<input type="text" name="examTime" id="examTime" class="align-r" style="width: 70px;">&nbsp;<spring:message code="글:분"/>
	            </td>
	        </tr>
	        <tr>
	        	<th>
	        		<spring:message code="필드:퀴즈:제한기준"/>
	        	</th>
	        	<td>
	        		<select name="limitStandardCd" onchange="showLimitProgress();">
	        			<aof:code type="option" codeGroup="LIMIT_STANDARD" defaultSelected="${CD_LIMIT_STANDARD_NO}"/>
	        		</select>
	        		<span id="limitArea" style="display: none;">
		        		<spring:message code="필드:퀴즈:진도율"/>&nbsp;
		        		<input type="text" name="limitProgress" class="align-r" style="width: 70px;">&nbsp; %<spring:message code="글:퀴즈:이상"/>
	        		</span>
	        	</td>
	        </tr>
	        <tr>
	        	<th>
	                <spring:message code="필드:퀴즈:재응시기준점수"/>
	            </th>
	            <td>
	            	<input type="text" name="retakeScore" class="align-r" style="width: 70px;">&nbsp;<spring:message code="글:퀴즈:점"/>
	            </td>
	        </tr>
	        <tr>
	        	<th>
	                <spring:message code="필드:퀴즈:재응시가능횟수"/>
	            </th>
	            <td>
	            	<input type="text" name="retakeCount" class="align-r" style="width: 70px;">&nbsp;<spring:message code="글:퀴즈:회"/>
	            </td>
	        </tr>
	        <tr>
	            <th>
	                <spring:message code="필드:퀴즈:성적공개여부"/> <span class="star">*</span>
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