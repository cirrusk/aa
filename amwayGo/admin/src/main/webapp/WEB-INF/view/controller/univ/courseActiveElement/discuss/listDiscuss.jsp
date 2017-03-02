<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"          value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_DISCUSS" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.DISCUSS')}"/>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'DISCUSS'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata          = null;
var forDetail            = null;
var forCreateDiscuss     = null;
var forUpdateRate 		 = null;
var forDeletelist		 = null;

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
    forListdata.config.url    = "<c:url value="/univ/course/active/discuss/list.do"/>";
	
    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/active/discuss/detail.do"/>";

    forCreateDiscuss = $.action();
    forCreateDiscuss.config.formId = "FormCreate";
    forCreateDiscuss.config.url    = "<c:url value="/univ/course/active/discuss/create.do"/>";
    
    forUpdateRate = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateRate.config.url             = "<c:url value="/univ/course/active/discuss/rate/updatelist.do"/>";
    forUpdateRate.config.target          = "hiddenframe";
    forUpdateRate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdateRate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateRate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateRate.config.fn.complete     = function() {
    	doList();
    };
    
    forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/course/active/discuss/deletelist.do"/>";
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


setValidate = function() {
    
	forUpdateRate.validator.set({
        title : "<spring:message code="필드:토론:평가비율"/>",
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
 * 토론 신규등록
 */
doCreateDiscuss = function() {
	forCreateDiscuss.run();
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
 * 평가비율을 호출하는 함수
 */
doUpdateRate = function() {
    forUpdateRate.run();
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
    	$.alert({message : "<spring:message code='글:토론:평가비율총합은100%이어야합니다.'/>"});
    }
}

/**
 * 평가기준 변경확인
 */
doChangeShow = function() {
	jQuery("#warning").show();
};

</script>
</head>

<body>

<c:import url="srchDiscuss.jsp"></c:import>
<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>

<div class="lybox-title"><!-- lybox-title -->
    <div class="right">
        <!-- 년도학기 / 개설과목 Select Area Start -->
        <c:import url="../../include/commonCourseActive.jsp"></c:import>
        <!-- 년도학기 / 개설과목 Select Area End -->
    </div>
</div>

<!-- 교과목 구성정보 Tab Area Start -->
<c:import url="../include/commonCourseActiveElement.jsp">
    <c:param name="courseActiveSeq" value="${courseDiscuss.courseActiveSeq}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_DISCUSS}"/>
</c:import>
<!-- 교과목 구성정보 Tab Area End -->


<div id="tabContainer">
    <!-- 평가기준 Start Area -->
    <c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>
    <!-- 평가기준 Start End -->
    
    <div class="vspace"></div>
    <div class="vspace"></div>
    
    <div class="lybox-title"><!-- lybox-title -->
        <h4 class="section-title"><spring:message code="필드:토론:구성항목" /></h4>
        <div class="right">
            <c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
                <a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');"><span class="small"><spring:message code="버튼:토론:토론결과" /></span></a>
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
        <col style="width: auto" />
        <col style="width: 220px" />
        <col style="width: 100px" />
    </colgroup>
    <thead>
        <tr>
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
            <th><spring:message code="필드:토론:토론주제" /></th>
            <th><spring:message code="필드:토론:토론기간" /></th>
            <th><spring:message code="필드:토론:평가비율" /></th>
        </tr>
    </thead>
    <tbody>
    <c:set var="totalRate" value="0"></c:set>
    <c:forEach var="row" items="${itemList}" varStatus="i">
        <tr>
            <td>
                <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
                <input type="hidden" name="discussSeqs" value="<c:out value="${row.discuss.discussSeq}" />">
            </td>
            <td class="align-l">
           	 	<a href="javascript:void(0)" onclick="doDetail({'discussSeq' : '${row.discuss.discussSeq}', 'referenceSeq' : '${row.discuss.discussSeq}'});">
           	 		<div class="text-ellipsis">
           	 			<c:out value="${row.discuss.discussTitle}"/>
           	 		</div>
           	 	</a>
            </td>
            <td>
            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	            	<c:if test="${empty row.discuss.startDtime}">
	            		<spring:message code="글:토론:토론기간설정이필요합니다" />
	            	</c:if>
	            	<c:if test="${not empty row.discuss.startDtime}">
	            		<aof:date datetime="${row.discuss.startDtime}"/>
		                ~
		                <aof:date datetime="${row.discuss.endDtime}"/>
	            	</c:if>
	            </c:if>
	            <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
			        <span><spring:message code="글:수강시작" /></span> <c:out value="${row.discuss.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${row.discuss.endDay}" /> <spring:message code="글:일까지" />
	            </c:if>
            </td>
            <td>
                <input type="text" class="align-r" name="rates" value="<c:out value="${row.discuss.rate}"/>" onkeyup="doRateSum()" onchange="doChangeShow();" style="width:40px;" maxlength="4"/>
            </td>
        </tr>
        <c:set var="totalRate" value="${totalRate + row.discuss.rate}"></c:set>
    </c:forEach>
    <c:choose>
        <c:when test="${empty itemList}">
            <tr>
                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="2" class="align-l">※ <spring:message code="글:토론:평가비율총합은100%이어야합니다." /></td>
                <td><spring:message code="필드:토론:합계비율" /></td>
                <td id="totalRate"><c:out value='${totalRate}'/>%</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </table>
    </form>
    <div class="lybox-btn">
        <div class="lybox-btn-l" style="display: none;" id="checkButtonBottom">
            <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
        </div>
        <div class="lybox-btn-r">
        	<span id="warning" style="display: none; color: red;"><spring:message code="글:평가기준:저장되지않는데이터가존재합니다" /></span>
            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                <c:if test="${not empty itemList}">
                    <a href="javascript:void(0)" onclick="doUpdateRate()" class="btn blue"><span class="mid"><spring:message code="버튼:토론:비율저장" /></span></a>
                </c:if>
                <a href="#" onclick="doCreateDiscuss()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>