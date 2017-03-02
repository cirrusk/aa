<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forSave       = null;
var forDuplicate  = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
	// [3]datepicker
	UI.datepicker(".datepicker",{ showOn: "both", buttonImage: '<aof:img type='print' src='common/calendar.gif'/>'});
};

/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/yearterm/list.do"/>";
	
	forSave = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forSave.config.url             = "<c:url value="/univ/yearterm/save.do"/>";
    forSave.config.target          = "hiddenframe";
    forSave.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forSave.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forSave.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forSave.config.fn.complete     = function() {
    	doSearch();
    };
    
    forDuplicate = $.action("ajax", {formId : "FormData"});
    forDuplicate.config.type   = "json";
    forDuplicate.config.url    = "<c:url value="/univ/yearterm/duplicate.do"/>";
    forDuplicate.config.fn.complete = function(action, data) {
    	
    	switch (data.duplicated) {
		case "admin": // 관리자
			 $.alert({
	                message : "<spring:message code="글:년도학기:관리자의중복된학습기간이있습니다."/>"
	            });
			break;
	    case "prof":  // 교강사
	    	 $.alert({
	                message : "<spring:message code="글:년도학기:교강사의중복된학습기간이있습니다."/>"
	            });
            break;
       case "user":    // 학습자
    	   $.alert({
               message : "<spring:message code="글:년도학기:학습자의중복된학습기간이있습니다."/>"
           });
    	    break;
   	    default:
   	    	forSave.run();
   	    	break;
		}
    };
    
    setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
/* 	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:관리자시스템오픈일"/>",
        name : "openAdminDate",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:교강사시스템오픈일"/>",
        name : "openProfDate",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:학습자시스템오픈일"/>",
        name : "openStudentDate",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:학습시작일"/>",
        name : "studyStartDate",
        data : ["!null"],
        check : {
            le : {name : "studyEndDate", title : "<spring:message code="필드:년도학기:학습종료일"/>"}
        }
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:학습종료일"/>",
        name : "studyEndDate",
        data : ["!null"]
    });

	//강의계획서
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:강의계획서입력시작일"/>",
        name : "planRegStartDtime",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:강의계획서입력시작일"/>",
        name : "planRegStartDtime",
        data : ["!null"],
        check : {
            le : {name : "planRegEndDtime", title : "<spring:message code="필드:년도학기:강의계획서입력종료일"/>"}
        }
    });
		
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:강의계획서입력종료일"/>",
        name : "planRegEndDtime",
        data : ["!null"]
    });	
	
	//중간고사 이의신청
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:중간고사이의신청시작일"/>",
        name : "middleExamUpdStartDtime",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:중간고사이의신청시작일"/>",
        name : "middleExamUpdStartDtime",
        data : ["!null"],
        check : {
            le : {name : "middleExamUpdEndDtime", title : "<spring:message code="필드:년도학기:중간고사이의신청종료일"/>"}
        }
    });
		
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:중간고사이의신청종료일"/>",
        name : "middleExamUpdEndDtime",
        data : ["!null"]
    });	
	
	
	//기말고사
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:기말고사이의신청시작일"/>",
        name : "finalExamUpdStartDtime",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:기말고사이의신청시작일"/>",
        name : "finalExamUpdStartDtime",
        data : ["!null"],
        check : {
            le : {name : "finalExamUpdEndDtime", title : "<spring:message code="필드:년도학기:기말고사이의신청종료일"/>"}
        }
    });
		
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:기말고사이의신청종료일"/>",
        name : "finalExamUpdEndDtime",
        data : ["!null"]
    });	

	//성적 산출기간
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:성적산출시작일"/>",
        name : "gradeMakeStartDtime",
        data : ["!null"]
    });
	
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:성적산출시작일"/>",
        name : "gradeMakeStartDtime",
        data : ["!null"],
        check : {
            le : {name : "gradeMakeEndDtime", title : "<spring:message code="필드:년도학기:성적산출종료일"/>"}
        }
    });
		
	forDuplicate.validator.set({
        title : "<spring:message code="필드:년도학기:성적산출종료일"/>",
        name : "gradeMakeEndDtime",
        data : ["!null"]
    }); */	
		
};

/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearch = function(rows) {
	var form = UT.getById(forSearch.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearch.run();
};

/** 학습일자 중복검사 후 저장*/
doCreate = function() {
	forSave.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:목록" /></c:param>
	</c:import>

	<%-- <c:import url="srchYearTerm.jsp"/> --%>

    <c:set var="headerYear" value="${fn:substring(condition.srchYearTerm,0,4)}"/>
    <c:set var="headerTerm" value="${fn:substring(condition.srchYearTerm,4,6)}"/>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="yearTerm" value="${condition.srchYearTerm}"/>
	<input type="hidden" name="defaultYn" value="${detail.univYearTerm.defaultYn}"/>
	<input type="hidden" name="yearTermName" value="${detail.univYearTerm.yearTermName}"/>
	
	<table id="listTable" class="tbl-list mt10">
	<colgroup>
		<col style="width: 80px" />
		<col style="width: 160px" />
	</colgroup>
	<thead>
	   <%-- <tr>
            <th colspan="7" class="align-l">
                <c:out value="${detail.univYearTerm.yearTermName}"/>
            </th>
        </tr>
		<tr>
			<th><spring:message code="필드:년도학기:구분"/></th>
			<th><spring:message code="필드:년도학기:시스템오픈"/></th>
			<th><spring:message code="필드:년도학기:학습기간"/></th>
            
            <th><spring:message code="필드:년도학기:강의계획서입력기간"/></th>
            <th><spring:message code="필드:년도학기:중간고사이의신청기간"/></th>
            <th><spring:message code="필드:년도학기:기말고사이의신청기간"/></th>
            
            <th><spring:message code="필드:년도학기:성적산출기간"/></th>
		</tr> --%>
	</thead>
	<tbody>
		<%-- <tr>
		    <td><spring:message code="필드:년도학기:관리자" /></td>
	        <td>
	           <input type="text" name="openAdminDate" id="openAdminDate" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.openAdminDate}"/>" readonly="readonly">
	           ~
	        </td>
	        <td rowspan="3">
	           <input type="text" name="studyStartDate" id="studyStartDate" class="datepicker"  value="<aof:date datetime="${detail.univYearTerm.studyStartDate}"/>" readonly="readonly">
              <br/>~
               <input type="text" name="studyEndDate" id="studyEndDate" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.studyEndDate}"/>" readonly="readonly">
            </td>
            <td rowspan="3">
               <input type="text" name="planRegStartDtime" id="planRegStartDtime" class="datepicker"  value="<aof:date datetime="${detail.univYearTerm.planRegStartDtime}"/>" readonly="readonly">
              <br/>~
               <input type="text" name="planRegEndDtime" id="planRegEndDtime" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.planRegEndDtime}"/>" readonly="readonly">
            </td>
            <td rowspan="3">
               <input type="text" name="middleExamUpdStartDtime" id="middleExamUpdStartDtime" class="datepicker"  value="<aof:date datetime="${detail.univYearTerm.middleExamUpdStartDtime}"/>" readonly="readonly">
              <br/>~
               <input type="text" name="middleExamUpdEndDtime" id="middleExamUpdEndDtime" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.middleExamUpdEndDtime}"/>" readonly="readonly">
            </td>
            <td rowspan="3">
               <input type="text" name="finalExamUpdStartDtime" id="finalExamUpdStartDtime" class="datepicker"  value="<aof:date datetime="${detail.univYearTerm.finalExamUpdStartDtime}"/>" readonly="readonly">
              <br/>~
               <input type="text" name="finalExamUpdEndDtime" id="finalExamUpdEndDtime" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.finalExamUpdEndDtime}"/>" readonly="readonly">
            </td>
            <td rowspan="3">
               <input type="text" name="gradeMakeStartDtime" id="gradeMakeStartDtime" class="datepicker"  value="<aof:date datetime="${detail.univYearTerm.gradeMakeStartDtime}"/>" readonly="readonly">
              <br/>~
               <input type="text" name="gradeMakeEndDtime" id="gradeMakeEndDtime" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.gradeMakeEndDtime}"/>" readonly="readonly">
            </td>
        </tr>
        <tr>
            <td><spring:message code="필드:년도학기:교강사" /></td>
            <td>
                <input type="text" name="openProfDate" id="openProfDate" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.openProfDate}"/>" readonly="readonly">
                ~
            </td>
        </tr>
        <tr>
            <td><spring:message code="필드:년도학기:학습자" /></td>
            <td>
                <input type="text" name="openStudentDate" id="openStudentDate" class="datepicker" value="<aof:date datetime="${detail.univYearTerm.openStudentDate}"/>" readonly="readonly">
                ~
            </td>
        </tr> --%>
        <tr>
        	<td>대회여부</td>
        	<td>
				<aof:code type="radio" codeGroup="YESNO" name="competitionYn" defaultSelected="N" selected="${detail.univYearTerm.competitionYn}" removeCodePrefix="true"/>
			</td>
        </tr>
    </tbody>
	</table>
	</form>

    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
            </c:if>
        </div>
    </div>
</body>
</html>