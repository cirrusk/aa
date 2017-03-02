<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_ALWAYS"           value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_BASIC"       value="${aoffn:code('CD.BASIC_SUPPLEMENT.BASIC')}"/>
<c:set var="CD_BASIC_SUPPLEMENT_SUPPLEMENT"  value="${aoffn:code('CD.BASIC_SUPPLEMENT.SUPPLEMENT')}"/>
<c:set var="CD_COURSE_ELEMENT_TYPE_HOMEWORK" value="${aoffn:code('CD.COURSE_ELEMENT_TYPE.HOMEWORK')}"/>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'HOMEWORK'}">
            <c:set var="menuActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_BASIC_SUPPLEMENT_SUPPLEMENT = "<c:out value="${CD_BASIC_SUPPLEMENT_SUPPLEMENT}"/>";

var forListdata              = null;
var forDetail                = null;
var forCreateHomework    	 = null;
var forUpdateRate            = null;
var forDeletelist            = null;
var forCreateTeamPopup       = null;
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
    forListdata.config.url    = "<c:url value="/univ/course/active/homework/list.do"/>";

    forDetail = $.action();
    forDetail.config.formId = "FormDetail";
    forDetail.config.url    = "<c:url value="/univ/course/active/homework/detail.do"/>";

    forCreateHomework = $.action();
    forCreateHomework.config.formId = "FormCreate";
    forCreateHomework.config.url    = "<c:url value="/univ/course/active/homework/create.do"/>";
    
    forUpdateRate = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forUpdateRate.config.url             = "<c:url value="/univ/course/active/homework/rate/updatelist.do"/>";
    forUpdateRate.config.target          = "hiddenframe";
    forUpdateRate.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
    forUpdateRate.config.message.success = "<spring:message code="글:저장되었습니다"/>";
    forUpdateRate.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateRate.config.fn.complete     = doList;
    
    forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/course/active/homework/deletelist.do"/>";
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
	forUpdateRate.validator.set(function(){
		var rateSum = 0;
		$("input[name=rates]").each(function(){
			rateSum = parseFloat(rateSum) + parseFloat($(this).val());
		});
        
        if(rateSum == 100){
            return true;
        } else {
            $.alert({message : "<spring:message code='글:과제:평가비율총합은100%이어야합니다.'/>",
                    button1 : {
                        callback : function() {
                            $("input[name=rates]").eq(0).focus();
                            }
                         }
                    });
            return false;
        }
	});
	
	forUpdateRate.validator.set({
        title : "<spring:message code="필드:과제:평가비율"/>",
        name : "rates",
        data : ["!null", "decimalnumber"],
        check : {
        	le : 100
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
 * 평가비율을 호출하는 함수
 */
doUpdateRate = function() {
    forUpdateRate.run();
};

/**
 * 과제 신규등록
 */
doCreateHomework = function() {
    forCreateHomework.run();
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
    	$.alert({message : "<spring:message code='글:과제:평가비율총합은100%이어야합니다.'/>"});
    }
};

/**
 * 보충과제 등록 페이지 호출
 */
doSupplementCreate = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forCreateHomework.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forCreateHomework.config.formId);
    // 보충과제 생성에 필요한 값 셋팅
    $form = $("#" + forCreateHomework.config.formId);
    $form.find(":input[name='basicSupplementCd']").val(CD_BASIC_SUPPLEMENT_SUPPLEMENT);
    // 상세화면 실행
    forCreateHomework.run();
};

/** 배점 비율 변경이 한번이라도 일어나면 저장 옆에 경고 문구 띄운다.*/
changeShow = function() {
	jQuery("#warning").show();
}
</script>
</head>

<body>
<c:set var="dateformat" value="${aoffn:config('format.date')}"/>
<c:set var="today" value="${aoffn:today()}"/>
<c:set var="appToday"><aof:date datetime="${today}" pattern="${aoffn:config('format.dbdatetime')}"/></c:set>

<c:import url="srchHomework.jsp"></c:import>
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
    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
    <c:param name="selectedElementTypeCd" value="${CD_COURSE_ELEMENT_TYPE_HOMEWORK}"/>
</c:import>
<!--  교과목 구성정보 Tab Area End -->

<div id="tabContainer">
    <!-- 평가기준 Start Area -->
    <c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>
    <!-- 평가기준 Start End -->
    
    <br/>
    
    <div class="lybox-title"><!-- lybox-title -->
        <h4 class="section-title"><spring:message code="필드:과제:구성항목" /></h4>
        <div class="right">
            <c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
                <a href="#" class="btn gray" onclick="FN.doGoMenu('<c:url value="${menuActiveDetail.menu.url}"/>','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" ><span class="small"><spring:message code="버튼:과제:과제결과" /></span></a>
            </c:if>
        </div>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    <input type="hidden" name="replaceYn" value="N"/>
	    
	    <table id="listTable" class="tbl-list">
	    <colgroup>
	        <col style="width: 40px" />
	        <col style="width: auto" />
	        <col style="width: 200px" />
	        <col style="width: 100px" />
	        <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	        	<col style="width: 100px" />
	        </c:if>
	        <col style="width: 100px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
	            <th><spring:message code="필드:과제:과제제목" /></th>
	            <th><spring:message code="필드:과제:제출기간" /></th>
	            <th><spring:message code="필드:과제:대상인원" /></th>
	            <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
	            	<th><spring:message code="필드:과제:미응시자" /></th>
	            </c:if>
	            <th><spring:message code="필드:과제:평가비율" /></th>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:set var="totalRate" value="0"/>
	    	<c:set var="index" 	   value="0"/>
	    	<c:forEach var="row" items="${itemList}" varStatus="i">
		    	<tr>
		    		<td>
		    			<!-- 제출이 된 사용자가 있으면 삭제에 제한이 걸린다. -->
		    			<c:if test="${row.courseHomework.answerSubmitCount eq 0}">
			                <input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
			                <input type="hidden" name="homeworkSeqs" value="<c:out value="${row.courseHomework.homeworkSeq}"/>">
			                <input type="hidden" name="referenceSeqs" value="<c:out value="${row.courseHomework.referenceSeq}"/>">
			                <input type="hidden" name="basicSupplementCds" value="<c:out value="${row.courseHomework.basicSupplementCd}"/>">
			                
			                <c:set var="index" 	   value="${index + 1}"/>
		                </c:if>
		                <c:choose>
							<c:when test="${row.courseHomework.referenceCount eq 1}">
								<input type="hidden" name="supplementSeqs" value=""/>
							</c:when>
							<c:when test="${row.courseHomework.referenceCount ne 1 && row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
								<input type="hidden" name="supplementSeqs" value="<c:out value="${row.courseHomework.homeworkSeq}"/>"/>
							</c:when>
						</c:choose>
		            </td>
		            <td class="align-l">
		            	<c:choose>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<span class="section-btn blue02"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
		            		</c:when>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            			<span class="section-btn green"><aof:code type="print" codeGroup="BASIC_SUPPLEMENT" selected="${row.courseHomework.basicSupplementCd}"/></span>
		            		</c:when>
		            	</c:choose>
		            	<div class="vspace"></div>
		                <a href="javascript:doDetail({'homeworkSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />'});"><c:out value="${row.courseHomework.homeworkTitle}"/></a>
		            </td>
		            <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		            	<td class="align-l">
			            	<c:if test="${empty row.courseHomework.startDtime}">
			            		<spring:message code="글:과제:제출기간설정이필요합니다" />
			            	</c:if>
			            	<c:if test="${not empty row.courseHomework.startDtime}">
			            		<spring:message code="필드:과제:1차" />
				                : 
				                <aof:date datetime="${row.courseHomework.startDtime}"/>
				                ~
				                <aof:date datetime="${row.courseHomework.endDtime}"/>
				                <br/>
				                <spring:message code="필드:과제:2차" /> 
				                : 
				                <c:if test="${row.courseHomework.useYn eq 'Y'}">
					                <aof:date datetime="${row.courseHomework.start2Dtime}"/>
					                ~
					                <aof:date datetime="${row.courseHomework.end2Dtime}"/>
				                </c:if>
				                <c:if test="${row.courseHomework.useYn eq 'N'}">
					                <spring:message code="글:과제:해당없음" /> 
				                </c:if>
			            	</c:if>
		           		</td>
		            </c:if>
		            <c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
			           	<td>
			           		<span><spring:message code="글:수강시작" /></span> <c:out value="${row.courseHomework.startDay}" /> <spring:message code="글:일부터" /> ~ <c:out value="${row.courseHomework.endDay}" /> <spring:message code="글:일까지" />
			        	</td>
			        </c:if>
		            <td>
		            	<c:out value="${row.courseHomework.targetCount}"/>&nbsp;<spring:message code="글:명" /> 
		            </td>
		            <c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
				            <td rowspan="<c:out value="${row.courseHomework.referenceCount}"/>">
			            		<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
					            	<c:if test="${row.courseHomework.supplementUseYn eq 'Y' && row.courseHomework.referenceCount eq 1}"><!-- 보충과제 버튼 : 최종 제출일이 지난후 가능, 보충과제는 하나이상은 불가능 -->
					            		<a href="#" onclick="doSupplementCreate({'referenceSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />',
					            												 'referenceRate' : '<c:out value="${row.courseHomework.rate}"/>',
					            												 'endDtime' : '<c:out value="${row.courseHomework.useYn eq 'Y' ? row.courseHomework.end2Dtime : row.courseHomework.endDtime}" />'});" 
					            					class="btn gray">
					            					<span class="small">
					            						<spring:message code="버튼:과제:보충과제"/>
					            					</span>
					            		</a>
					            	</c:if>
				            	</c:if>
				            </td>
			            </c:if>
			            <td rowspan="<c:out value="${row.courseHomework.referenceCount}"/>">
			            	<input type="hidden" name="rateHomeworkSeqs" value="<c:out value="${row.courseHomework.homeworkSeq}"/>">
			                <input type="text" name="rates" value="<c:out value="${row.courseHomework.rate}"/>" onchange="changeShow()" onkeyup="doRateSum()" style="width:40px;" maxlength="4" class="align-r"/> %
			            </td>
			            <c:set var="totalRate" value="${totalRate + row.courseHomework.rate}"/>
		            </c:if>
		    	</tr>
	    	</c:forEach>
	    	<c:choose>
		        <c:when test="${empty itemList}">
		            <tr>
		            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		                	<td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
		                </c:if>
		            	<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		                	<td colspan="5" align="center"><spring:message code="글:데이터가없습니다" /></td>
		                </c:if>
		            </tr>
		        </c:when>
		        <c:otherwise>
		            <tr>
		            	<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS}">
		                	<td colspan="4" class="align-l" style="font-weight: bold;">※ <spring:message code="글:과제:평가비율총합은100%이어야합니다." /></td>
		                </c:if>
		            	<c:if test="${param['shortcutCourseTypeCd'] eq CD_COURSE_TYPE_ALWAYS}">
		                	<td colspan="3" class="align-l" style="font-weight: bold;">※ <spring:message code="글:과제:평가비율총합은100%이어야합니다." /></td>
		                </c:if>
		                <td><spring:message code="필드:과제:합계비율" /></td>
		                <td id="totalRate"><c:out value='${totalRate}'/>%</td>
		            </tr>
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
                <c:if test="${not empty itemList}">
                	<span id="warning" style="display: none; color: red;"><spring:message code="글:과제:저장되지않은데이터가존재합니다" /></span>
                    <a href="javascript:void(0)" onclick="doUpdateRate()" class="btn blue"><span class="mid"><spring:message code="버튼:과제:비율저장" /></span></a>
                </c:if>
                <a href="#" onclick="doCreateHomework()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>