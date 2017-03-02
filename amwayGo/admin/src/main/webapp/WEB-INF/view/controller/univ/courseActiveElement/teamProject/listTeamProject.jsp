<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_ELEMENT_TYPE_TEAMPROJECT" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.TEAMPROJECT')}"/>
<c:set var="CD_TEAM_PROJECT_STATUS_E" value="${aoffn:code('CD.TEAM_PROJECT_STATUS.E')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata              = null;
var forDetail                = null;
var forEdit                  = null;
var forCreateTeamProject     = null;
var forUpdateRate            = null;
var forDeletelist            = null;
var forCreateTeamPopup       = null;
var forDeatilTeamPopup       = null;
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
    forListdata.config.url    = "<c:url value="/univ/course/active/teamproject/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/active/teamproject/detail.do"/>";

    forCreateTeamProject = $.action();
    forCreateTeamProject.config.formId = "FormCreate";
    forCreateTeamProject.config.url    = "<c:url value="/univ/course/active/teamproject/create.do"/>";
    
    forUpdateRate = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateRate.config.url             = "<c:url value="/univ/course/active/teamproject/rate/updatelist.do"/>";
    forUpdateRate.config.target          = "hiddenframe";
    forUpdateRate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdateRate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateRate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateRate.config.fn.complete     = function() {};
    
    forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/course/active/teamproject/deletelist.do"/>";
    forDeletelist.config.target          = "hiddenframe";
    forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDeletelist.config.fn.complete     = doCompleteDeletelist;
    forDeletelist.validator.set({
        title : "<spring:message code="필드:삭제할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
    
   //팀구성 레이어 팝업을 띄운다.
    forCreateTeamPopup = $.action("layer");
    forCreateTeamPopup.config.formId         = "FormCreateProjectTeam";
    forCreateTeamPopup.config.url            = "<c:url value="/univ/course/active/teamproject/team/popup.do"/>";
    forCreateTeamPopup.config.options.width  = 780;
    forCreateTeamPopup.config.options.height = 550;
    forCreateTeamPopup.config.options.callback = doList;
    forCreateTeamPopup.config.options.title  = "<spring:message code="필드:팀프로젝트:팀프로젝트팀구성"/>";
    
    // 팀구성 조회
    forDeatilTeamPopup = $.action("layer");
    forDeatilTeamPopup.config.formId         = "FormDetailProjectTeam";
    forDeatilTeamPopup.config.url            = "<c:url value="/univ/course/active/teamproject/team/detail/popup.do"/>";
    forDeatilTeamPopup.config.options.width  = 780;
    forDeatilTeamPopup.config.options.height = 550;
    forDeatilTeamPopup.config.options.callback = doList;
    forDeatilTeamPopup.config.options.title  = "<spring:message code="필드:팀프로젝트:팀프로젝트팀구성"/>";
    
    setValidate();
};

setValidate = function() {
	
	forUpdateRate.validator.set({
        title : "<spring:message code="필드:팀프로젝트:평가비율"/>",
        name : "rates",
        data : ["!null","decimalnumber"]
    });
	
	forUpdateRate.validator.set(function(){
		var rateSum = 0;
		$("input[name=rates]").each(function(){
			rateSum = parseFloat(rateSum) + parseFloat($(this).val());
		});
        
        if(rateSum == 100){
            return true;
        } else {
            $.alert({message : "<spring:message code='글:토론:평가비율총합은100%이어야합니다.'/>",
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
 * 팀구성을 호출하는 함수
 */
doCreateProjectTeamMember = function() {
    forCreate.run();
};

/**
 * 평가비율을 호출하는 함수
 */
doUpdateRate = function() {
    forUpdateRate.run();
};

/**
 * 팀 생성을 호출하는 함수
 */
doCreateTeamProject = function() {
    forCreateTeamProject.run();
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
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
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
    	$.alert({message : "<spring:message code='글:팀프로젝트:평가비율총합은100%이어야합니다.'/>"});
    }
};

/**
 * 팀 구성 팝업
 */
doCreateTeam = function(mapPKs){
	 // 상세화면 form을 reset한다.
    UT.getById(forCreateTeamPopup.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forCreateTeamPopup.config.formId);
    // 상세화면 실행
	forCreateTeamPopup.run();
};

/**
 * 팀 구성 조회
 */
doDetailTeamMember = function(mapPKs){
	 // 상세화면 form을 reset한다.
    UT.getById(forDeatilTeamPopup.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDeatilTeamPopup.config.formId);
    // 상세화면 실행
    forDeatilTeamPopup.run();
};

/**
 * 팀프로젝트 상세
 */
doDetail = function(mapPKs){
   // 상세화면 form에 키값을 셋팅한다.
   UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
   // 상세화면 실행
   forDetail.run();
};

doTeamMessage = function(){
	$.alert({message : "<spring:message code='글:팀프로젝트:수강생이없어팀구성을할수없습니다.'/>"});
}

</script>
</head>

<body>
<c:import url="srchTeamProject.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Shortcut Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${teamProject.courseActiveSeq}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_TEAMPROJECT}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->


<div id="tabContainer">
    <!-- 평가기준 Start Area -->
    <%--<c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>--%>
    <!-- 평가기준 Start End -->
    
    <br/>
    
    <div class="lybox-title"><!-- lybox-title -->
        <h4 class="section-title"><spring:message code="필드:팀프로젝트:구성항목" /></h4>
        <div class="right">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <c:forEach var="row" items="${appMenuList}">
                    <c:choose>
                        <c:when test="${row.menu.cfString eq 'TEAMPROJECT'}">
                            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
                        </c:when>
                    </c:choose>
                </c:forEach>
                <a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>',
                                                                '<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>',
                                                                '<c:out value="${menuActiveDetail.menu.dependent}"/>',
                                                                '<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" >
                                                                <span class="small"><spring:message code="버튼:팀프로젝트:팀프로젝트결과" /></span>
                </a>
            </c:if>
        </div>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
    
    <table id="listTable" class="tbl-list">
    <colgroup>
        <col style="width: 40px" />
        <col style="width: 240px;" />
        <%--<col style="width: 240px" /> --%>
        
        <col style="width: 60px" />
        <col style="width: 100px" />
        <%--<col style="width: 70px" /> --%>
    </colgroup>
    <thead>
        <tr>
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
            <th><spring:message code="필드:팀프로젝트:팀프로젝트내용" /></th>
            <%--<th><spring:message code="필드:팀프로젝트:프로젝트기간" /></th> --%>
            <th><spring:message code="필드:팀프로젝트:상태" /></th>
            <th><spring:message code="필드:팀프로젝트:팀구성" /></th>
            <%-- <th><spring:message code="필드:팀프로젝트:평가비율" /></th>--%>
        </tr>
    </thead>
    <tbody>
    <c:set var="totalRate" value="0"></c:set>
    <c:set var="nonSavingData" value="0"></c:set>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td>
                <c:if test="${row.courseTeamProject.teamProjectStatusCd ne CD_TEAM_PROJECT_STATUS_E }">
                    <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')" >
                </c:if>
                <input type="hidden" name="courseTeamProjectSeqs" value="<c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>">
            </td>
            
            <td class="align-l">
                <a href="javascript:void(0)" onclick="doDetail({courseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>})">
					<c:choose>
						<c:when test="${fn:length(row.courseTeamProject.description) > 50}">
							<c:out value="${fn:substring(row.courseTeamProject.description,0,50)}"/>....
						</c:when>
						<c:otherwise>
							<c:out value="${row.courseTeamProject.description}"/>
						</c:otherwise> 
					</c:choose>                    
                </a>
            </td>
            <%--
            <td>
                <spring:message code="필드:팀프로젝트:진행기간" /> 
                : 
                <aof:date datetime="${row.courseTeamProject.startDtime}"/>
                ~
                <aof:date datetime="${row.courseTeamProject.endDtime}"/>
                <br/>
                <spring:message code="필드:팀프로젝트:과제제출" />
                :
                <aof:date datetime="${row.courseTeamProject.homeworkStartDtime}"/>
                ~
                <aof:date datetime="${row.courseTeamProject.homeworkEndDtime}"/>
            </td>
             --%>
            <td><aof:code type="print" codeGroup="TEAM_PROJECT_STATUS" selected="${row.courseTeamProject.teamProjectStatusCd}"/> </td>
            <td>
                <c:choose>
                    <c:when test="${row.courseTeamProject.projectTeamCount > 0}">
                        <a href="javascript:void(0)" onclick="doDetailTeamMember({courseActiveSeq: <c:out value="${row.courseTeamProject.courseActiveSeq}"/>,courseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>})">
                            <c:out value="${row.courseTeamProject.projectTeamCount}"/><spring:message code="필드:팀프로젝트:팀" />
                        </a>
                    </c:when>
                    <c:otherwise>
                    	<c:choose>
                    		<c:when test="${row.courseActiveSummary.memberCount > 0}">
                    			<a href="javascript:void(0)" onclick="doCreateTeam({courseActiveSeq: <c:out value="${row.courseTeamProject.courseActiveSeq}"/>,courseTeamProjectSeq : <c:out value="${row.courseTeamProject.courseTeamProjectSeq}"/>})" class="btn gray">
		                            <span class="small"><spring:message code="필드:팀프로젝트:팀구성" /></span>
		                        </a>
                    		</c:when>
                    		<c:otherwise>
                    			<a href="javascript:void(0)" onclick="doTeamMessage()" class="btn gray">
		                            <span class="small"><spring:message code="필드:팀프로젝트:팀구성" /></span>
		                        </a>
                    		</c:otherwise>
                    	</c:choose>
                    </c:otherwise>
                </c:choose>
            </td>
            <%--
            <td>
                <input type="text" name="rates" value="<c:out value="${row.courseTeamProject.rate}"/>" onkeyup="doRateSum()" style="width:40px;" maxlength="4"/>
            </td>
             --%>
             <input type="hidden" name="rates" value="100"/>
        </tr>
        <%--
        <c:set var="totalRate" value="${totalRate + row.courseTeamProject.rate}"></c:set>
        <c:if test="${row.courseTeamProject.rate > 0}">
            <c:set var="nonSavingData" value="${nonSavingData + 1}"></c:set>
        </c:if>
         --%>
    </c:forEach>
    <c:choose>
        <c:when test="${empty itemList}">
            <tr>
                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:when>
        <c:otherwise>
            <%--<tr>
                <td colspan="4" class="align-l">※ <spring:message code="글:팀프로젝트:평가비율총합은100%이어야합니다." /></td>
                <td><spring:message code="필드:팀프로젝트:합계" /></td>
                <td id="totalRate"><c:out value='${totalRate}'/>%</td>
            </tr>
             --%>
        </c:otherwise>
    </c:choose>
    </tbody>
    </table>
    </form>
    <div class="lybox-btn">
        <div class="lybox-btn-l" style="display: none;" id="checkButtonBottom">
            <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
        </div>
        <div class="lybox-btn-r">
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <%--<span id="warning" style="<c:if test="${nonSavingData > 0 || empty itemList}">display: none;</c:if>color: red;"><spring:message code="글:평가기준:저장되지않는데이터가존재합니다" /></span>
                 
                <c:if test="${not empty itemList}">
                    <a href="javascript:void(0)" onclick="doUpdateRate()" class="btn blue"><span class="mid"><spring:message code="필드:팀프로젝트:비율저장" /></span></a>
                </c:if>
                --%>
<%--                 <c:if test="${empty itemList}"> --%>
                	<a href="#" onclick="doCreateTeamProject()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
<%--                 </c:if> --%>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>