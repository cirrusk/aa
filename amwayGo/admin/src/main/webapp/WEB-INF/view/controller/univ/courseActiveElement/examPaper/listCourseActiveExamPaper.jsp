<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
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

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'EXAM'}">
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

var forListdata        = null;
var forDetailExamPaper = null;
var forDetailHomework  = null;
var forCreateExamPaper = null;
var forCreateHomework  = null;
var forDeletelist 	   = null;
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
    forListdata.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/list.do"/>";

    forDetailExamPaper = $.action();
    forDetailExamPaper.config.formId = "FormDetail";
    forDetailExamPaper.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/detail.do"/>";
    
    forDetailHomework = $.action();
    forDetailHomework.config.formId = "FormDetailHomework";
    forDetailHomework.config.url    = "<c:url value="/univ/course/active/${examType}/homework/detail.do"/>";

    forCreateExamPaper = $.action();
    forCreateExamPaper.config.formId = "FormCreate";
    forCreateExamPaper.config.url    = "<c:url value="/univ/course/active/${examType}/exampaper/create.do"/>";
    
    forCreateHomework = $.action();
    forCreateHomework.config.formId = "FormCreateHomework";
    forCreateHomework.config.url    = "<c:url value="/univ/course/active/${examType}/homework/create.do"/>";
    
    
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
};
/**
 * 상세보기 화면을 호출하는 함수 - 시험
 */
doDetailExamPaper = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetailExamPaper.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailExamPaper.config.formId);
    // 상세화면 실행
    forDetailExamPaper.run();
};
/**
 * 상세보기 화면을 호출하는 함수 - 과제
 */
doDetailHomework = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forDetailHomework.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetailHomework.config.formId);
    // 상세화면 실행
    forDetailHomework.run();
};
/**
 * 시험 신규등록
 */
doCreateExamPaper = function() {
    forCreateExamPaper.run();
};
/**
 * 과제 신규등록
 */
doCreateHomework = function() {
    forCreateHomework.run();
};
/**
 * 목록에서 삭제할 때 호출되는 함수 - 현재 다중 삭제 아님 시험은 1개 고정이며 보충은 기간이 지나야 생성 가능하므로 다중삭제 불가능
 */
doDeletelist = function() {
	
	var $form = jQuery("#FormData");
	var $checkKey = $form.find(":input[name='checkkeys']").filter(":checked");
	var deleteTypeCd = $checkKey.siblings(":input[name='deleteTypeCd']").val();
	var elementSeq = $checkKey.siblings(":input[name='activeElementSeq']").val();
	var deleteActiveElementSeq = null;
	var map = {};
	
	if (typeof elementSeq !== "undefined") {
		deleteActiveElementSeq = elementSeq;
	} else {
		deleteActiveElementSeq = '';
	}
	
	if (deleteTypeCd == 'exam') {
		map = {
			courseActiveExamPaperSeq : $checkKey.siblings(":input[name='courseActiveExamPaperSeq']").val(), 	
			middleFinalTypeCd : $checkKey.siblings(":input[name='middleFinalTypeCd']").val(), 	
			basicSupplementCd : $checkKey.siblings(":input[name='basicSupplementCd']").val(),
			examPaperSeq : $checkKey.siblings(":input[name='examPaperSeq']").val(),
			activeElementSeq : deleteActiveElementSeq
		};
	} else if (deleteTypeCd == 'homework') {
		map = {
				homeworkSeq : $checkKey.siblings(":input[name='homeworkSeq']").val(), 	
				middleFinalTypeCd : $checkKey.siblings(":input[name='middleFinalTypeCd']").val(), 	
				basicSupplementCd : $checkKey.siblings(":input[name='basicSupplementCd']").val(),
				activeElementSeq : deleteActiveElementSeq
			};
	} 
	UT.copyValueMapToForm(map, "FormDelete");
	
	forDeletelist = $.action("submit", {formId : "FormDelete"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	if (deleteTypeCd == 'exam') {
	    forDeletelist.config.url             = "<c:url value="/univ/course/active/${examType}/exampaper/delete.do"/>";
	} else if (deleteTypeCd == 'homework') {
	    forDeletelist.config.url             = "<c:url value="/univ/course/active/homework/delete.do"/>";
	}
    forDeletelist.config.target          = "hiddenframe";
    forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDeletelist.config.fn.complete     = doCompleteDeletelist;
    forDeletelist.validator.set({
        title : "<spring:message code="필드:삭제할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
    
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
 * 보충시험 등록
 */
doCreateSupplementExamPaper = function(mapPKs) {
    // 상세화면 form을 reset한다.
    UT.getById(forCreateExamPaper.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forCreateExamPaper.config.formId);
    // 보충과제 생성에 필요한 값 셋팅
    $form = $("#" + forCreateExamPaper.config.formId);
    
    $form.find(":input[name='basicSupplementCd']").val(CD_BASIC_SUPPLEMENT_SUPPLEMENT);
    // 상세화면 실행
    forCreateExamPaper.run();
};
/**
 * 보충과제 등록
 */
doCreateSupplementHomework = function(mapPKs) {
	
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
</script>
</head>

<body>
<c:set var="itemCount" value="${aoffn:size(examPaperList) + aoffn:size(homeworkList)}"/>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
</c:import>
	
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
    <!-- 평가기준 Start Area -->
    <c:import url="../include/commonCourseActiveEvaluate.jsp"></c:import>
    <!-- 평가기준 Start End -->
    
 <c:import url="srchCourseActiveExamPaper.jsp" />
 
    <div class="lybox-title mt10">
        <h4 class="section-title"><spring:message code="필드:시험:구성항목" /></h4>
        <div class="right">
        	<c:if test="${aoffn:accessible(menuActiveDetail.rolegroupMenu, 'R')}">
                <c:choose>
                	<c:when test="${examType eq 'middle'}">
		                <a href="javascript:void(0);" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/exampaper/middle/result/list.do"/>?examType=${examType}','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" ><span class="small"><spring:message code="버튼:시험:시험결과" /></span></a>
                	</c:when>
                	<c:when test="${examType eq 'final'}">
		                <a href="javascript:void(0);" class="btn gray" onclick="FN.doGoMenu('<c:url value="/univ/course/active/exampaper/final/result/list.do"/>?examType=${examType}','<c:out value="${aoffn:encrypt(menuActiveDetail.menu.menuId)}"/>','<c:out value="${menuActiveDetail.menu.dependent}"/>','<c:out value="${menuActiveDetail.menu.urlTarget}"/>');" ><span class="small"><spring:message code="버튼:시험:시험결과" /></span></a>
                	</c:when>
               	</c:choose>
            </c:if>
        </div>
    </div>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 40px" />
	        <col style="width: auto" />
	        <col style="width: 200px" />
	        <col style="width: 100px" />
	        <col style="width: 100px" />
	        <col style="width: 100px" />
	    </colgroup>
	    <thead>
	        <tr>
	            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButtonBottom');" /></th>
	            <th><spring:message code="필드:시험:시험제목" /></th>
	            <th><spring:message code="필드:시험:진행기간" /></th>
	            <th><spring:message code="필드:시험:시험시간" /></th>
	            <th><spring:message code="필드:시험:대상인원" /></th>
	            <c:choose>
	            	<c:when test="${itemCount lt 2}">
			            <th><spring:message code="필드:시험:미응시자" /></th>
	            	</c:when>
	            	<c:otherwise>
			            <th><spring:message code="필드:시험:평가비율" /></th>
	            	</c:otherwise>
	            </c:choose>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:set var="index" 	   value="0"/>
	    	<c:forEach var="row" items="${examPaperList}" varStatus="i">
		    	<tr>
		    		<td>
	    				<c:if test="${row.courseActiveExamPaper.startDtime gt appToday}">
			                <input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
			                <input type="hidden" name="courseActiveExamPaperSeq" value="<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>">
			                <input type="hidden" name="basicSupplementCd" value="<c:out value="${row.courseActiveExamPaper.basicSupplementCd}"/>">
			                <input type="hidden" name="middleFinalTypeCd" value="<c:out value="${row.courseActiveExamPaper.middleFinalTypeCd}"/>">
			                <input type="hidden" name="examPaperSeq" value="<c:out value="${row.courseActiveExamPaper.examPaperSeq}"/>">
			                <input type="hidden" name="deleteTypeCd" value="exam" />
			                
			                <c:if test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
								<c:forEach var="subRow" items="${elementList}" varStatus="j">
									<c:if test="${subRow.element.referenceSeq eq row.courseActiveExamPaper.courseActiveExamPaperSeq}">
								    	<input type="hidden" name="activeElementSeq" 	value="<c:out value="${subRow.element.activeElementSeq}"/>"/>
								    </c:if>
								</c:forEach>
							</c:if>
			                
			                <c:set var="index" value="${index + 1}"/>
		                </c:if>
		            </td>
		            <td class="align-l">
		            	<c:choose>
		            		<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<c:choose>
		            				<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:중간고사" /></span>
		            				</c:when>
		            				<c:when test="${row.courseActiveExamPaper.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:기말고사" /></span>
		            				</c:when>
		            			</c:choose>
		            		</c:when>
		            		<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            			<span class="section-btn green"><spring:message code="필드:시험:보충시험" /></span>
		            		</c:when>
		            	</c:choose>
		            	<div class="vspace"></div>
		                <a href="javascript:doDetailExamPaper({'courseActiveExamPaperSeq' : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}" />'});"><c:out value="${row.courseExamPaper.examPaperTitle}"/></a>
		            </td>
		            <td>
		                <aof:date datetime="${row.courseActiveExamPaper.startDtime}" />&nbsp;
					    <aof:date datetime="${row.courseActiveExamPaper.startDtime}" pattern="HH:mm:ss"/>
		                <spring:message code="글:시험:부터" /> 
		                <div class="vspace"></div>
		                <aof:date datetime="${row.courseActiveExamPaper.endDtime}" />&nbsp;
					    <aof:date datetime="${row.courseActiveExamPaper.endDtime}" pattern="HH:mm:ss"/>
					    <spring:message code="글:시험:까지" />
		            </td>
		            <td><c:out value="${row.courseActiveExamPaper.examTime}" />&nbsp;<spring:message code="글:분" /></td>
		            <td>
		            	<c:choose>
		            		<c:when test="${row.courseActiveExamPaper.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<c:out value="${row.courseActiveSummary.memberCount}"/>&nbsp;<spring:message code="글:명" />
		            		</c:when>
		            		<c:otherwise>
		            			<c:out value="${row.courseActiveExamPaper.targetCount}"/>&nbsp;<spring:message code="글:명" />
		            		</c:otherwise>
		            	</c:choose>
		            </td>
		            <td>
			            <c:choose>
			            	<c:when test="${itemCount eq 1}">
			            		<c:if test="${row.courseActiveExamPaper.endDtime le appToday}">
			            			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
					            		<a href="#" onclick="doCreateSupplementExamPaper({'referenceSeq' : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>', 'endDtime' : '<c:out value="${row.courseActiveExamPaper.endDtime}"/>'})" class="btn gray">
					            			<span class="small"><spring:message code="버튼:시험:보충시험"/></span>
					            		</a>
					            		<div class="vspace"></div>
					            		<a href="#" onclick="doCreateSupplementHomework({'referenceSeq' : '<c:out value="${row.courseActiveExamPaper.courseActiveExamPaperSeq}"/>', 'referenceType' : 'EXAM' , 'endDtime' : '<c:out value="${row.courseActiveExamPaper.endDtime}"/>'})" class="btn gray">
					            			<span class="small"><spring:message code="버튼:시험:보충과제"/></span>
					            		</a>
				            		</c:if>
			            		</c:if>
			            	</c:when>
			            	<c:otherwise>
			            		100%
			            	</c:otherwise>
			            </c:choose>
		            </td>
		    	</tr>
	    	</c:forEach>
	    	<c:forEach var="row" items="${homeworkList}" varStatus="i">
	    		<tr>
	    			<td>
	    				<c:if test="${row.courseHomework.startDtime gt appToday}">
			    			<input type="checkbox" name="checkkeys" value="<c:out value="${index}"/>" onclick="FN.onClickCheckbox(this, 'checkButtonBottom')">
			    			<input type="hidden" name="homeworkSeq" value="<c:out value="${row.courseHomework.homeworkSeq}"/>">
			    			<input type="hidden" name="basicSupplementCd" value="<c:out value="${row.courseHomework.basicSupplementCd}"/>">
			    			<input type="hidden" name="middleFinalTypeCd" value="<c:out value="${row.courseHomework.middleFinalTypeCd}"/>">
			                <input type="hidden" name="deleteTypeCd" value="homework" />
			                
			                <c:if test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
								<c:forEach var="subRow" items="${elementList}" varStatus="j">
									<c:if test="${subRow.element.referenceSeq eq row.courseHomework.homeworkSeq}">
								    	<input type="hidden" name="activeElementSeq" 	value="<c:out value="${subRow.element.activeElementSeq}"/>"/>
								    </c:if>
								</c:forEach>
							</c:if>
			    			
			    			<c:set var="index" value="${index + 1}"/>
			    		</c:if>
	    			</td>
	    			<td class="align-l">
	    				<c:choose>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_BASIC}">
		            			<c:choose>
		            				<c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_MIDDLE}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:중간고사" /><spring:message code="필드:시험:대체과제" /></span>
		            				</c:when>
		            				<c:when test="${row.courseHomework.middleFinalTypeCd eq CD_MIDDLE_FINAL_TYPE_FINAL}">
		            					<span class="section-btn blue02"><spring:message code="필드:시험:기말고사" /><spring:message code="필드:시험:대체과제" /></span>
		            				</c:when>
		            			</c:choose>
		            		</c:when>
		            		<c:when test="${row.courseHomework.basicSupplementCd eq CD_BASIC_SUPPLEMENT_SUPPLEMENT}">
		            			<span class="section-btn green"><spring:message code="필드:시험:보충과제" /></span>
		            		</c:when>
		            	</c:choose>
		            	<div class="vspace"></div>
		                <a href="javascript:doDetailHomework({'homeworkSeq' : '<c:out value="${row.courseHomework.homeworkSeq}" />'});"><c:out value="${row.courseHomework.homeworkTitle}"/></a>
	    			</td>
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
		            <td>
		            -
		            </td>
		            <td>
		            	<c:out value="${row.courseHomework.targetCount}"/>&nbsp;<spring:message code="글:명" /> 
		            </td>
		            <td>
		            	<c:choose>
			            	<c:when test="${itemCount eq 1}">
			            		<c:if test="${row.courseHomework.endDtime le appToday}">
			            			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
					            		<a href="#" onclick="doCreateSupplementHomework({'referenceSeq' : '<c:out value="${row.courseHomework.homeworkSeq}"/>', 'referenceType' : 'HOMEWORK', 'endDtime' : '<c:out value="${row.courseHomework.endDtime}"/>'})" class="btn gray">
					            			<span class="small"><spring:message code="버튼:시험:보충과제"/></span>
					            		</a>
				            		</c:if>
			            		</c:if>
			            	</c:when>
			            	<c:otherwise>
			            		100%
			            	</c:otherwise>
			            </c:choose>
		            </td>
	    		</tr>
	    	</c:forEach>
	        <c:if test="${itemCount eq 0}">
	            <tr>
	                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
   	<c:choose>
	    <c:when test="${itemCount eq 0}">
		    <div class="lybox-btn">
		        <div class="lybox-btn-r">
		            <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
	                    <a href="javascript:void(0)" onclick="doCreateHomework()" class="btn blue"><span class="mid"><spring:message code="버튼:시험:대체과제등록" /></span></a>
		                <a href="javascript:void(0)" onclick="doCreateExamPaper()" class="btn blue">
		                	<span class="mid">
		                		<c:choose>
		                			<c:when test="${examType eq 'middle'}">
				                		<spring:message code="버튼:시험:중간고사등록" />
		                			</c:when>
		                			<c:otherwise>
		                				<spring:message code="버튼:시험:기말고사등록" />
		                			</c:otherwise>
		                		</c:choose>
	                		</span>
                		</a>
		            </c:if>
		        </div>
		    </div>
	    </c:when>
	    <c:otherwise>
	    	<div class="lybox-btn">
		        <div class="lybox-btn-l" style="display: none;" id="checkButtonBottom">
		            <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
		        </div>
		    </div>
	    </c:otherwise>
    </c:choose>
    
    <form id="FormDelete" name="FormDelete" method="post" onsubmit="return false;">
    	<input type="hidden" name="homeworkSeq">
    	<input type="hidden" name="courseActiveExamPaperSeq">
    	<input type="hidden" name="examPaperSeq">
    	<input type="hidden" name="basicSupplementCd">
    	<input type="hidden" name="middleFinalTypeCd">
    	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>">
    	<input type="hidden" name="activeElementSeq" >
    	<input type="hidden" name="replaceYn" value="Y">
    	
    </form>
    
</div>
</body>
</html>