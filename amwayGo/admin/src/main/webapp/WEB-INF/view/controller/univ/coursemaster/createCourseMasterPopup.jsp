<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"            value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_TYPE_PERIOD"            value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_EVALUATE_METHOD_TYPE_ABSOLUTE" value="${aoffn:code('CD.EVALUATE_METHOD_TYPE.ABSOLUTE')}"/>
<c:set var="CD_EVALUATE_METHOD_TYPE_RELATIVE" value="${aoffn:code('CD.EVALUATE_METHOD_TYPE.RELATIVE')}"/>
<c:set var="CD_APPLY_TYPE_MANUAL"             value="${aoffn:code('CD.APPLY_TYPE.MANUAL')}"/>
<c:set var="CD_LIMIT_PROGRESS_TYPE_SEQUENCE"  value="${aoffn:code('CD.LIMIT_PROGRESS_TYPE.SEQUENCE')}"/>
<c:set var="CD_LIMIT_PROGRESS_TYPE_NONSEQUENCE"  value="${aoffn:code('CD.LIMIT_PROGRESS_TYPE.NONSEQUENCE')}"/>


<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_COURSE_TYPE_ALWAYS = "<c:out value="${CD_COURSE_TYPE_ALWAYS}"/>";
var CD_COURSE_TYPE_PERIOD = "<c:out value="${CD_COURSE_TYPE_PERIOD}"/>";
var CD_EVALUATE_METHOD_TYPE_ABSOLUTE = "<c:out value="${CD_EVALUATE_METHOD_TYPE_ABSOLUTE}"/>";

var forInsert   = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
    // [2]datepicker
    UI.datepicker("#studyStartDate,#studyEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    <%--
    UI.datepicker("#cancelStartDate,#cancelEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    
    UI.datepicker("#openStartDate,#openEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    
    UI.datepicker("#studyEndDate,#resumeEndDate",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
    --%>
    
};
/**
 * 설정
 */
doInitializeLocal = function() {

    forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forInsert.config.url             = "<c:url value="/univ/coursemaster/copy/insert.do"/>";
    forInsert.config.target          = "hiddenframe";
    forInsert.config.message.confirm = "<spring:message code="글:교과목:생성하시겠습니까?"/>"; 
    forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forInsert.config.fn.complete     = function() {
    	$.alert({
            message : "<spring:message code="글:교과목:생성되었습니다.개설과목관리에서확인하시기바랍니다."/>",
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
/*     forInsert.validator.set({
        title : "<spring:message code="필드:교과목:주차갯수"/>",
        name : "weekCount",
        data : ["!null"],
        check : {
            maxlength : 3
        }
    }); */
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:학습기간"/>",
        name : "studyStartDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:학습기간"/>",
        name : "studyDay",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_ALWAYS) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:학습기간"/>",
        name : "expireStartDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:학습기간"/>",
        name : "expireStartDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    <%--
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:수강신청기간"/>",
        name : "applyStartDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:수강신청기간"/>",
        name : "applyEndDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:수강취소기간"/>",
        name : "cancelStartDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:수강신청기간"/>",
        name : "cancelEndDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:수강신청기간"/>",
        name : "cancelDay",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd != CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:오픈기간"/>",
        name : "openStartDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:오픈기간"/>",
        name : "openEndDate",
        data : ["!null"]
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:복습기간"/>",
        name : "resumeEndDate",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd == CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
    
    forInsert.validator.set({
        title : "<spring:message code="필드:교과목:복습기간"/>",
        name : "resumeDay",
        data : ["!null"],
        when : function() {
            var courseTypeCd = $("input[name=courseTypeCd]").val();
            if (courseTypeCd != CD_COURSE_TYPE_PERIOD) {
                return true;
            } else {
                return false;
            }
        }
    });
	--%>
};
/**
 * 저장
 */
doInsert = function() {
    forInsert.run();
};

doClose = function(){
    $layer.dialog("close");
};

/**
 * 과정유형에따른 변경
 * - 학습기간 혹은 일간 입력 
 * - 성적평가방법
 */
doChangeCourseType = function(obj) {
	if($(obj).val() == CD_COURSE_TYPE_ALWAYS){
		$(".courseTypePeriodArea").hide();
        $(".courseTypeAlwaysArea").show();
        
        $("input:radio[name='evaluateMethodTypeCd']").removeAttr("checked");
        $("input:radio[name='evaluateMethodTypeCd']:radio[value='" + CD_EVALUATE_METHOD_TYPE_ABSOLUTE + "']").attr("checked", true);
        $("input:radio[name='evaluateMethodTypeCd']:radio[value='" + CD_EVALUATE_METHOD_TYPE_RELATIVE + "']").attr("disabled", true);
	} else {
		$(".courseTypePeriodArea").show();
        $(".courseTypeAlwaysArea").hide();
        $("input:radio[name='evaluateMethodTypeCd']:radio[value='" + CD_EVALUATE_METHOD_TYPE_RELATIVE + "']").attr("disabled", false);
	}
	
	// 학습일정 input 초기화
	$("#studyFormTable input").val("");
};
</script>
</head>

<body>
<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <input type="hidden" name="courseMasterSeqs" value="<c:out value="${row.courseMasterSeq}"/>"/>
    </c:forEach>
    <input type="hidden" name="courseTypeCd" value="<c:out value="${CD_COURSE_TYPE_PERIOD}"/>"/>
    <input type="hidden" name="evaluateMethodTypeCd" value="<c:out value="${CD_EVALUATE_METHOD_TYPE_ABSOLUTE}"/>"/>
    <input type="hidden" name="limitProgressTypeCd" value="<c:out value="${CD_LIMIT_PROGRESS_TYPE_NONSEQUENCE}"/>"/>
    
    <div class="lybox-title">
        <h4 class="section-title"><spring:message code="필드:교과목:구성정보" /></h4>
    </div>
    <table class="tbl-detail">
    <colgroup>
        <col style="width: 120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr>
            <th><spring:message code="필드:교과목:학습기간"/><span class="star">*</span></th>
            <td>
                <span class="courseTypePeriodArea">
                <input type="text" name="studyStartDate" id="studyStartDate" class="datepicker">
                  ~
                <input type="text" name="studyEndDate" id="studyEndDate" class="datepicker">
                </span>
                
                <span style="display: none;" class="courseTypeAlwaysArea">
                <input type="text" name="studyDay" style="width: 40px;text-align: center;">
                <spring:message code="필드:교과목:일간"/>
                </span>
            </td>
        </tr>
        <tr>
            <th>과정 이름</th>
            <td>
                <input type="text" name=courseActiveTitle id="courseActiveTitle" >
            </td>
        </tr>
        <tr>
            <th>약관 선택</th>
            <td>
                <input type="hidden" name="agreementSeq" id="agreementSeq" >
            </td>
        </tr>
        <tr>
            <th>정보 폐기 기간</th>
            <td>
            	운영 기간 시작일부터 <input type="text" name="expireStartDate" id="expireStartDate" style="width: 10%;"/> 년 뒤 폐기
            </td>
        </tr>   
        <tr>
            <th>썸네일</th>
            <td>
                <input type="hidden" name="agreementSeq" id="agreementSeq" >
            </td>
        </tr>                
<%--         <tr>
            <th><spring:message code="필드:교과목:운영년도"/><span class="star">*</span></th>
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
        <tr> --%>
        <%-- 
        </tr>
            <th><spring:message code="필드:교과목:과정유형"/><span class="star">*</span></th>
            <td>
                <aof:code type="radio" name="courseTypeCd" codeGroup="COURSE_TYPE" onclick="doChangeCourseType(this)" defaultSelected="${CD_COURSE_TYPE_PERIOD}" />
            </td>
        </tr>
        
        <tr>
            <th><spring:message code="필드:교과목:주차갯수"/><span class="star">*</span></th>
            <td>
                <input type="text" name="weekCount" style="width: 40px;text-align: center;" maxlength="3">
                <spring:message code="필드:교과목:주차"/>
            </td>
        <tr>
        
        <tr>
            <th><spring:message code="필드:교과목:과정승인유형"/><span class="star">*</span></th>
            <td>
                <aof:code type="radio" name="applyTypeCd" codeGroup="APPLY_TYPE" defaultSelected="${CD_APPLY_TYPE_MANUAL}" />
            </td>
        <tr>
        
        <tr>
            <th><spring:message code="필드:교과목:인재개발대회여부"/><span class="star">*</span></th>
            <td>
                <aof:code type="radio" name="competitionYn" codeGroup="YESNO" defaultSelected="N" removeCodePrefix="true"/>
            </td>
        <tr> 
        <tr>
            <th><spring:message code="필드:교과목:성적평가방법"/><span class="star">*</span></th>
            <td>
                <aof:code type="radio" name="evaluateMethodTypeCd" codeGroup="EVALUATE_METHOD_TYPE" defaultSelected="${CD_EVALUATE_METHOD_TYPE_ABSOLUTE}" />
            </td>
        <tr>
        <tr>
            <th><spring:message code="필드:교과목:진도율제한구분"/><span class="star">*</span></th>
            <td>
                <aof:code type="radio" name="limitProgressTypeCd" codeGroup="LIMIT_PROGRESS_TYPE" defaultSelected="${CD_LIMIT_PROGRESS_TYPE_SEQUENCE}" />
            </td>
        <tr>
        --%>
    </tbody>
    </table>
<%--    
    <div class="lybox-title mt10">
        <h4 class="section-title"><spring:message code="필드:교과목:학습일정" /></h4>
    </div>
    <table class="tbl-detail" id="studyFormTable">
    <colgroup>
        <col style="width: 120px" />
        <col/>
    </colgroup>
    <tbody>
        <tr class="courseTypePeriodArea">
            <th><spring:message code="필드:교과목:수강신청기간"/><span class="star">*</span></th>
            <td>
                <input type="text" name="applyStartDate" id="applyStartDate" class="datepicker" readonly="readonly">
                  ~
                <input type="text" name="applyEndDate" id="applyEndDate" class="datepicker" readonly="readonly">
            </td>
        <tr>
        </tr>
            <th><spring:message code="필드:교과목:수강취소기간"/><span class="star">*</span></th>
            <td>
            	<span class="courseTypePeriodArea">
	                <input type="text" name="cancelStartDate" id="cancelStartDate" class="datepicker" readonly="readonly">
	                  ~
	                <input type="text" name="cancelEndDate" id="cancelEndDate" class="datepicker" readonly="readonly">
                </span>
                
                <span style="display: none;" class="courseTypeAlwaysArea">
	                <input type="text" name="cancelDay" style="width: 40px;text-align: center;">
	                <spring:message code="필드:교과목:일간"/>
                </span>
            </td>
        </tr>
        <tr>
            <th><spring:message code="필드:교과목:오픈기간"/><span class="star">*</span></th>
            <td>
                <input type="text" name="openStartDate" id="openStartDate" class="datepicker" readonly="readonly">
                  ~
                <input type="text" name="openEndDate" id="openEndDate" class="datepicker" readonly="readonly">
            </td>
        <tr>
        </tr>
            <th><spring:message code="필드:교과목:복습기간"/><span class="star">*</span></th>
            <td>
	            <span class="courseTypePeriodArea">
	                <spring:message code="글:교과목:학습종료일부터"/>
	                ~
	                <input type="text" name="resumeEndDate" id="resumeEndDate" class="datepicker" readonly="readonly">
                </span>
                
                <span style="display: none;" class="courseTypeAlwaysArea">
	                <input type="text" name="resumeDay" style="width: 40px;text-align: center;">
	                <spring:message code="필드:교과목:일간"/>
                </span>
            </td>
        </tr>
    </tbody>
    --%>
    </table>
    </form>

    <div class="lybox-btn">
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
            </c:if>
            <a href="#" onclick="doClose();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
        </div>
    </div>
</body>
</html>