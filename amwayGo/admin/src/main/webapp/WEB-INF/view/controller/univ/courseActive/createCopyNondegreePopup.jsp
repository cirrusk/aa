<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert   = null;
var forDetailElement = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
 // [2]datepicker
    UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forInsert = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsert.config.url             = "<c:url value="/univ/courseactive/copy/non/save.do"/>";
    forInsert.config.target          = "hiddenframe";
    forInsert.config.message.confirm = "<spring:message code="글:개설과목:신규개설과목을생성하시겠습니까?"/>"; 
    forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forInsert.config.fn.complete     = function(data) {
    	var map = {shortcutCourseActiveSeq: data, shortcutYearTerm : $("select[name=year]").val()};
    	$.alert({
            message : "<spring:message code="글:개설과목:신규개설과목이생성되었습니다."/>",
            button1 : {
                callback : function() {
                	var par = $layer.dialog("option").parent;
                    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
                        par["<c:out value="${param['callback']}"/>"].call(this,map);
                    }
                    $layer.dialog("close");
                }
            }
        });
    };
    
    forDetailElement = $.action("ajax");
    forDetailElement.config.formId      = "FormDetailElement";
    forDetailElement.config.type        = "html";
    forDetailElement.config.containerId = "elementArea";
    forDetailElement.config.url         = "<c:url value="/univ/courseactive/element/ajax.do"/>";
    forDetailElement.config.fn.complete = function() {};

    setValidate();

};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:구성정보"/>",
        name : "courseElementTypes",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:오픈기간"/>",
        name : "openStartDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:오픈기간"/>",
        name : "openEndDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:수강신청기간"/>",
        name : "applyStartDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:수강신청기간"/>",
        name : "applyEndDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:수강신청취소기간"/>",
        name : "cancelStartDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:수강신청기간"/>",
        name : "cancelEndDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:학습기간"/>",
        name : "studyStartDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:학습기간"/>",
        name : "studyEndDate",
        data : ["!null"]
    });

    forInsert.validator.set({
        title : "<spring:message code="필드:개설과목:복습기간"/>",
        name : "resumeEndDate",
        data : ["!null"]
    });
};

/**
 * 개설과목 구성정보 복사
 */
doInsert = function() {
    forInsert.run();
};

doClose = function(){
    $layer.dialog("close");
};

/**
 * 구성정보 상세
 */
doDetailElement = function(mapPKs){
	// form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailElement.config.formId);
	forDetailElement.run();
};
</script>
</head>

<body>
<form name="FormDetailElement" id="FormDetailElement" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"/>
    <input type="hidden" name="courseElementType"/>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${detailCourseActive.courseActive.courseTypeCd}"/>"/>
</form>

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseTypeCd" value="<c:out value="${detailCourseActive.courseActive.courseTypeCd}"/>"/>
    <input type="hidden" name="sourceCourseActiveSeqs" value="<c:out value="${detailCourseActive.courseActive.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseMasterSeqs" value="<c:out value="${detailCourseActive.courseActive.courseMasterSeq}"/>"/>
    <table class="tbl-layout"><!-- table-layout -->
        <colgroup>
            <col style="width:25%;">
            <col style="width:auto;"><!-- IE7 버그로 50% 으로 지정하면 우측 라인이 잘림, auto 로 설정 -->
        </colgroup>
        <tbody>
            <tr>
                <td colspan="2">
                    <table class="tbl-detail-row">
                        <colgroup>
                            <col style="width:15%;">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th><spring:message code="필드:개설과목:선택정보"/></th>
                                <td colspan="2" style="text-align: left;">
                               		<%-- <c:if test="${detailCourseActive.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
                                		<c:out value="${detailCourseActive.courseActive.periodNumber}"/>
                                    	<spring:message code="필드:개설과목:기"/>&nbsp;
                                	</c:if>
                                	--%>
                                    <c:out value="${detailCourseActive.courseActive.courseActiveTitle}"/>
                                </td>
                            </tr>
                            <tr>
                                <th rowspan="6"><spring:message code="필드:개설과목:생성정보"/></th>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: left;">
                                    <c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>
                                    <select name="year">
                                        <c:forEach var="yearRow" items="${years}" varStatus="i">
                                            <option value="<c:out value='${yearRow}'/>" <c:if test="${yearRow eq appTodayYYYY}">selected="selected"</c:if>>
                                                <c:out value='${yearRow}'/><spring:message code="필드:년도학기:년"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <%--
                                    <c:if test="${detailCourseActive.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
                                    	<input type="text" name="periodNumber" value="<c:out value="${detailCourseActive.courseActive.periodNumber}"/>" style="width: 40px;text-align: center;">
                                    	<spring:message code="필드:개설과목:기"/>&nbsp;
                                    </c:if>
                                     --%>
                                    <input type="text" name="courseActiveTitle" value="<c:out value="${detailCourseActive.courseActive.courseActiveTitle}"/>" style="width: 60%;">
                                </td>
                            </tr>
                            <c:choose>
                            	<c:when test="${detailCourseActive.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
                            		<!-- 기수제 -->
                            		<tr>
		                                <th>
		                                    <spring:message code="필드:개설과목:수강신청기간"/>
		                                </th>
		                                <th>
		                                    <spring:message code="필드:개설과목:수강신청취소기간"/>
		                                </th>
		                            </tr>
		                            <tr>
		                                <td>
		                                    <input type="text" name="applyStartDate" id="applyStartDate" class="datepicker" readonly="readonly">
		                                    ~
		                                    <input type="text" name="applyEndDate" id="applyEndDate" class="datepicker" readonly="readonly">
		                                </td>
		                                <td>
		                                    <input type="text" name="cancelStartDate" id="cancelStartDate" class="datepicker" readonly="readonly">
		                                      ~
		                                    <input type="text" name="cancelEndDate" id="cancelEndDate" class="datepicker" readonly="readonly">
		                                </td>
		                            </tr>
		                            <tr>
		                                <th>
		                                    <spring:message code="필드:개설과목:학습기간"/>
		                                </th>
		                                <th>
		                                    <spring:message code="필드:개설과목:복습기간"/>
		                                </th>
		                            </tr>
		                            <tr>
		                                <td>
		                                    <input type="text" name="studyStartDate" id="openStartDate" class="datepicker" readonly="readonly">
		                                    ~
		                                    <input type="text" name="studyEndDate" id="openEndDate" class="datepicker" readonly="readonly">
		                                </td>
		                                <td>
		                                    <spring:message code="글:개설과목:학습종료일부터"/>
		                                    ~
		                                    <input type="text" name="resumeEndDate" id="resumeEndDate" class="datepicker" readonly="readonly">
		                                </td>
		                            </tr>
                            	</c:when>
                            	<c:otherwise>
                            		<!-- 상시제 -->
                            		<tr>
		                                <th colspan="2">
		                                    <spring:message code="필드:개설과목:오픈기간"/>
		                                </th>
		                            </tr>
		                            <tr>
		                                <td colspan="2">
		                                	<input type="text" name="openStartDate" id="openStartDate" class="datepicker" readonly="readonly">
							                  ~
							                <input type="text" name="openEndDate" id="openEndDate" class="datepicker" readonly="readonly">
		                                </td>
		                            </tr>
                            	</c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="first" style="height:300px;"><!-- height:300px -->
                    <div class="scroll-y mt10" style="height:300px;">
                        <table class="tbl-detail-row">
                            <colgroup>
                                <col style="width:45%;">
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','courseElementTypes');" /></th>
                                    <th><spring:message code="필드:개설과목:구성정보"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="elementRow" items="${elements}" varStatus="i">
                                    <tr>
                                        <td><input type="checkbox" name="courseElementTypes" value="<c:out value="${elementRow.code}"/>" onclick="FN.onClickCheckbox(this)"></td>
                                        <td>
                                            <a href="javascript:void(0)" onclick="doDetailElement({courseActiveSeq: '<c:out value="${detailCourseActive.courseActive.courseActiveSeq}"/>', courseElementType: '<c:out value="${elementRow.code}"/>'})"><c:out value="${elementRow.codeName}"/></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </td>
                <td style="height:300px;"><!-- 컨텐츠 우 --><!-- height:300px -->
                    <div id="elementArea" class="scroll-y mt10" style="height:300px;">
                        <!-- 구성정보 Ajax Page -->
                        <c:import url="include/commonCourseActivePlan.jsp"/>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>

    <div class="lybox-btn"><!-- lybox-btn -->
        <div class="lybox-btn-r"><a href="javascript:void(0)" onclick="doInsert()" class="btn blue"><span class="mid"><spring:message code="버튼:개설과목:복사"/></span></a></div>
    </div>
    
</form>
</body>
</html>