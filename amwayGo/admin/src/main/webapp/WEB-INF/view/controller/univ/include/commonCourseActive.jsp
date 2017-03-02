<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"   value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_CATEGORY_TYPE"        value="${aoffn:code('CD.CATEGORY_TYPE')}"/>
<c:set var="CD_CATEGORY_TYPE_ADDSEP" value="${CD_CATEGORY_TYPE}::"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<%
/*
- 학위 과목을 선택하여 상세 정보로 들어올 경우 학위과정 목록만 노출(shortcutCategoryTypeCd = CATEGORY_TYPE::DEGREE)
- 비학위 과목을 선택하여 개설 과목 상세 정보로 들어올 경우 비학위과정 목록만 노출(shortcutCategoryTypeCd = CATEGORY_TYPE::NONDEGREE)
*/
%>
<script type="text/javascript">
var forListShortcutData    = null;
initSubPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doSubInitializeLocal();
};

/**
 * 설정
 */
 doSubInitializeLocal = function() {
	forListShortcutData = $.action("ajax");
	forListShortcutData.config.type  = "html";
	forListShortcutData.config.formId = "FormActiveParam";
	forListShortcutData.config.url    = "<c:url value="/univ/courseactive/list/ajax.do"/>";
	forListShortcutData.config.containerId = "_shortcutCourseActiveSeq_";
	forListShortcutData.config.fn.complete = function(html) {
		$("#FormActiveParam input[name=shortcutCourseActiveSeq]").val("");
		$("#_shortcutCourseActiveSeq_").focus();
    };
};
/**
 * 목록보기
 */
doListShortcutCourseActive = function() {
	forListShortcutData.run();
};

/**
 * 개설과목 변경
 */
doChangeCourseActive = function(obj){
	var mapPKs = JSON.parse(obj);
	
	$("#FormActiveParam input[name=shortcutCourseTypeCd]").val(mapPKs.courseTypeCd);
	$("#FormActiveParam input[name=shortcutCourseActiveSeq]").val(mapPKs.courseActiveSeq);
	
	FN.doGoMenu('<c:url value="${appCurrentMenu.menu.url}"/>','<c:out value="${aoffn:encrypt(appCurrentMenu.menu.menuId)}"/>','<c:out value="${appCurrentMenu.menu.dependent}"/>','<c:out value="${appCurrentMenu.menu.urlTarget}"/>');
}

</script>

<%/*********** 학위 *********/ %>
<%// 중간고사 이의 신청 기간여부 %>
<c:set var="isMiddleExamDtime" value="false" scope="request"/>
<%// 기말고사 이의 신청 기간여부 %>
<c:set var="isFinalExamDtime" value="false" scope="request"/>
<%// 강의계획서 등록 기간여부 %>
<c:set var="isPlanRegDtime" value="false" scope="request"/>
<%// 성적 산출 기간 여부 %>
<c:set var="isGradeMakeDtime" value="false" scope="request"/>

<%/*********** 비학위(상시제) *********/ %>
<%// 학습기간(일)%>
<c:set var="studyDayOfCourseActive" value="0" scope="request"/>
<%// 복습기간(일) %>
<c:set var="resumeDayOfCourseActive" value="0" scope="request"/>
<%// 취소긴간(일) %>
<c:set var="cancelDayOfCourseActive" value="0" scope="request"/>

<div class="align-r" style="height:30px; margin-top:-35px;">
	<form name="FormActiveParam" id="FormActiveParam" method="post" onsubmit="return false;">
        <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
		<c:choose>
			<c:when test="${ssCurrentRoleCfString eq 'PROF'}">
				<!-- 교강사일 경우 -->
				<select name="shortcutYearTerm" onchange="doListShortcutCourseActive()">
                    <c:choose>
                        <c:when test="${CD_CATEGORY_TYPE_DEGREE eq param['shortcutCategoryTypeCd']}">
                            <!-- 학위 -->
                            <c:forEach var="row" items="${comboListYearTerm}" varStatus="i">
                                <option value="<c:out value='${row.yearTerm.yearTerm}'/>" 
                                    <c:if test="${row.yearTerm.yearTerm eq param['shortcutYearTerm']}">
                                        selected="selected"
                                        <c:set var="isMiddleExamDtime" value="${row.yearTerm.isMiddleExamDtime}" scope="request"/>
                                        <c:set var="isFinalExamDtime" value="${row.yearTerm.isFinalExamDtime}" scope="request"/>
                                        <c:set var="isPlanRegDtime" value="${row.yearTerm.isPlanRegDtime}" scope="request"/>
                                        <c:set var="isGradeMakeDtime" value="${row.yearTerm.isGradeMakeDtime}" scope="request"/>
                                    </c:if>>
                                    <c:out value='${row.yearTerm.yearTermName}'/>
                                </option>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- 비학위 -->
                            <c:forEach var="row" items="${comboListYearTerm}" varStatus="i">
                                <option value="<c:out value='${row.yearTerm.year}'/>" 
                                    <c:if test="${row.yearTerm.year eq param['shortcutYearTerm']}"> selected="selected"</c:if>>
                                    <c:out value='${row.yearTerm.year}'/><spring:message code="필드:개설과목:년" />
                                </option>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
				</select>
				
				<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
				<input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
				
				<select name="_shortcutCourseActiveSeq_" id="_shortcutCourseActiveSeq_" onchange="doChangeCourseActive(this.value)">
					<c:forEach var="row" items="${comboListCourseActive}" varStatus="i">
                        <c:choose>
                        <c:when test="${CD_CATEGORY_TYPE_DEGREE eq param['shortcutCategoryTypeCd']}">
                            <!-- 학위 -->
                            <option value='{"courseActiveSeq" : "<c:out value='${row.courseActive.courseActiveSeq}'/>","courseTypeCd": "<c:out value='${row.courseActive.courseTypeCd}'/>"}' <c:out value="${param['shortcutCourseActiveSeq'] eq row.courseActive.courseActiveSeq ? 'selected' : ''}"/>>
                            [<c:out value="${row.yearTerm.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.yearTerm.term}" removeCodePrefix="true"/>] <c:out value="${row.courseActive.courseActiveTitle}"/>
                            </option>
                        </c:when>
                        <c:otherwise>
                            <!-- 비학위 or Mooc-->
                            <option value='{"courseActiveSeq" : "<c:out value='${row.courseActive.courseActiveSeq}'/>","courseTypeCd": "<c:out value='${row.courseActive.courseTypeCd}'/>"}' 
	                            	<c:if test="${param['shortcutCourseActiveSeq'] eq row.courseActive.courseActiveSeq}">
	                        		 selected='selected'
	                        		<c:set var="studyDayOfCourseActive" value="${row.courseActive.studyDay}" scope="request"/>
									<c:set var="resumeDayOfCourseActive" value="${row.courseActive.resumeDay}" scope="request"/>
									<c:set var="cancelDayOfCourseActive" value="${row.courseActive.cancelDay}" scope="request"/>
	                        		</c:if>>
	                            <%--
	                            <c:if test="${row.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
	                            	[<c:out value='${row.courseActive.periodNumber}'/><spring:message code="필드:개설과목:기" />]
	                            </c:if>
	                             --%> 
	                            <c:out value="${row.courseActive.courseActiveTitle}"/>
                            </option>
                        </c:otherwise>
                    </c:choose>
                    </c:forEach>
				</select>
			</c:when>
			<c:otherwise>
				<!-- 교수이외의 경우 -->
				<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
				<input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
                <input type="hidden" name="shortcutCourseTypeCd" 	 value="<c:out value="${comboDeatilCourseActive.courseActive.courseTypeCd}"/>"/>
                
                <c:choose>
                      <c:when test="${CD_CATEGORY_TYPE_DEGREE eq param['shortcutCategoryTypeCd']}">
		                	<c:set var="isMiddleExamDtime" value="${comboYearTerm.univYearTerm.isMiddleExamDtime}" scope="request"/>
		                	<c:set var="isFinalExamDtime" value="${comboYearTerm.univYearTerm.isFinalExamDtime}" scope="request"/>
		                	<c:set var="isPlanRegDtime" value="${comboYearTerm.univYearTerm.isPlanRegDtime}" scope="request"/>
		                	<c:set var="isGradeMakeDtime" value="${comboYearTerm.univYearTerm.isGradeMakeDtime}" scope="request"/>
                      </c:when>
                      <c:otherwise>
                      		<c:set var="studyDayOfCourseActive" value="${comboDeatilCourseActive.courseActive.studyDay}" scope="request"/>
							<c:set var="resumeDayOfCourseActive" value="${comboDeatilCourseActive.courseActive.resumeDay}" scope="request"/>
							<c:set var="cancelDayOfCourseActive" value="${comboDeatilCourseActive.courseActive.cancelDay}" scope="request"/>
                      </c:otherwise>
                </c:choose>
                <strong>
                [<c:out value='${comboDeatilCourseActive.category.categoryString}'/>]
                [<c:out value='${comboDeatilCourseActive.courseActive.year}'/><spring:message code="필드:개설과목:년도" />
                
                <c:choose>
                    <c:when test="${CD_CATEGORY_TYPE_DEGREE eq comboDeatilCourseActive.category.categoryTypeCd}">
                        - <aof:code type="print" codeGroup="TERM_TYPE" selected="${comboDeatilCourseActive.courseActive.term}" removeCodePrefix="true"/>&nbsp;    
                    </c:when>
                    <c:when test="${CD_CATEGORY_TYPE_DEGREE ne comboDeatilCourseActive.category.categoryTypeCd && not empty comboDeatilCourseActive.courseActive.periodNumber}">
                        <%--
                        <c:if test="${comboDeatilCourseActive.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
                        - <c:out value='${comboDeatilCourseActive.courseActive.periodNumber}'/><spring:message code="필드:개설과목:기" />
                        </c:if>
                        
                         <aof:code type="print" codeGroup="COURSE_TYPE" selected="${comboDeatilCourseActive.courseActive.courseTypeCd}"/>
                         --%>
                         -
                    </c:when>
                </c:choose>
                <c:out value='${comboDeatilCourseActive.courseActive.courseActiveTitle}'/>]
                </strong>
			</c:otherwise>
		</c:choose>
	</form>
</div>
<script type="text/javascript">
initSubPage();
</script>