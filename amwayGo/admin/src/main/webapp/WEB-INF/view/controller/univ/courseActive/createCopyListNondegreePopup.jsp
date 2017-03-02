<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD" value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forInsert   = null;
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
    forInsert.config.fn.complete     = function() {
    	$.alert({
            message : "<spring:message code="글:개설과목:신규개설과목이생성되었습니다."/>",
            button1 : {
                callback : function() {
                	var par = $layer.dialog("option").parent;
                    if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
                        par["<c:out value="${param['callback']}"/>"].call(this);
                    }
                    $layer.dialog("close");
                }
            }
        });
    };

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

</script>
</head>

<body>
<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="courseTypeCd" value="<c:out value="${condition.srchCourseTypeCd}"/>"/>
<c:forEach var="row" items="${itemList}" varStatus="i">
    <input type="hidden" name="sourceCourseActiveSeqs" value="<c:out value="${row.courseActiveSeq}"/>"/>
    <input type="hidden" name="courseMasterSeqs" value="<c:out value="${row.courseMasterSeq}"/>"/>
</c:forEach>
<div class="component-info" style="width:950px;"><!-- component-info -->
    <div class="lybox-title">
        <h4 class="section-title"><spring:message code="필드:개설과목:구성정보선택"/></h4>
    </div>
    <table class="tbl-detail-row"><!-- tbl-detail-row -->
        <colgroup>
            <col style="width:12%;">
            <col style="width:auto;">
        </colgroup>
        <tbody>
            <c:set var="closeTr" value="0"/>
            <c:forEach var="elementRow" items="${elements}" varStatus="i">
                <c:if test="${i.first || i.index%4 == 0}">
                <tr>
                <c:set var="closeTr" value="${closeTr+1}"/>
                </c:if>
                    <th><c:out value="${elementRow.codeName}"/></th>
                    <td><input type="checkbox" name="courseElementTypes" value="<c:out value="${elementRow.code}"/>"></td>
                <c:if test="${i.index == ((closeTr*3)+closeTr)-1}">
                </tr>
                </c:if>
            </c:forEach>
            <c:set var="thRow" value="${4-(fn:length(elements)%4)}"></c:set>
            <c:if test="${thRow < 4}">
	            <c:forEach begin="1" end="${thRow}" varStatus="i">
	            	<th>
		            </th>
		            <td>
		            </td>
	            </c:forEach>
            </c:if>
            </tr>
        </tbody>
    </table>
    <!-- //타이틀 박스 -->

    <div class="lybox-title mt10">
        <h4 class="section-title"><spring:message code="필드:개설과목:선택정보"/></h4>
    </div>
    <table class="tbl-detail"><!-- tbl-2column -->
        <colgroup>
            <col style="width:20%;">
            <col>
        </colgroup>
        <tbody>
        <tr>
            <th>
                <spring:message code="필드:개설과목:년도" />*
            </th>
            <td>
                <c:set var="appTodayYYYY"><aof:date datetime="${aoffn:today()}" pattern="yyyy"/></c:set>
                <select name="year">
                    <c:forEach var="yearRow" items="${years}" varStatus="i">
                        <option value="<c:out value='${yearRow}'/>" <c:if test="${yearRow eq appTodayYYYY}">selected="selected"</c:if>>
                            <c:out value='${yearRow}'/><spring:message code="필드:년도학기:년"/>
                        </option>
                    </c:forEach>
                </select>
            </td>
        </tr>
        <c:choose>
       		<c:when test="${condition.srchCourseTypeCd eq CD_COURSE_TYPE_PERIOD}">
	           	<tr>
		            <th>
		                <spring:message code="필드:개설과목:수강신청기간" />*
		            </th>
		            <td>
		            	<input type="text" name="applyStartDate" id="applyStartDate" class="datepicker" readonly="readonly">
		                ~
		                <input type="text" name="applyEndDate" id="applyEndDate" class="datepicker" readonly="readonly">
		            </td>
		        </tr>
		        <tr>
		            <th>
		                <spring:message code="필드:개설과목:수강신청취소기간" />*
		            </th>
		            <td>
		            	<input type="text" name="cancelStartDate" id="cancelStartDate" class="datepicker" readonly="readonly">
			            ~
			            <input type="text" name="cancelEndDate" id="cancelEndDate" class="datepicker" readonly="readonly">
		            </td>
		        </tr>
		        <tr>
		            <th>
		                <spring:message code="필드:개설과목:학습기간" />*
		            </th>
		            <td>
		            	<input type="text" name="studyStartDate" id="openStartDate" class="datepicker" readonly="readonly">
              			~
                		<input type="text" name="studyEndDate" id="openEndDate" class="datepicker" readonly="readonly">
		            </td>
		        </tr>
		        <tr>
		            <th>
		                <spring:message code="필드:개설과목:복습기간" />*
		            </th>
		            <td>
		               <spring:message code="글:개설과목:학습종료일부터"/>
		                ~
		               <input type="text" name="resumeEndDate" id="resumeEndDate" class="datepicker" readonly="readonly">
		            </td>
		        </tr>
       		</c:when>
       		<c:otherwise>
       			<tr>
		            <th><spring:message code="필드:개설과목:오픈기간"/><span class="star">*</span></th>
		            <td>
		                <input type="text" name="openStartDate" id="openStartDate" class="datepicker" readonly="readonly">
		                  ~
		                <input type="text" name="openEndDate" id="openEndDate" class="datepicker" readonly="readonly">
		            </td>
		        <tr>
       		</c:otherwise>
       	</c:choose>
        </tbody>
    </table>
</div>
<div class="lybox-btn" id="buttonArea"><!-- lybox-btn -->
    <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
        <div class="lybox-btn-r">
            <a href="javascript:void(0)" onclick="doInsert()" class="btn blue">
                <span class="mid"><spring:message code="버튼:개설과목:개설과목생성"/></span>
            </a>
        </div>
    </c:if>
</div>
</form>
</body>
</html>