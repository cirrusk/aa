<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"            value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_COURSE_TYPE_ALWAYS"            value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"          value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE"       value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>
<c:set var="CD_COURSE_ACTIVE_STATUS_INACTIVE" value="${aoffn:code('CD.COURSE_ACTIVE_STATUS.INACTIVE')}"/>

<c:choose>
    <c:when test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
        <%// 학위 분류 %>
        <c:set var="categoryUrlPath" value=""/>
    </c:when>
    <c:when test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_NONDEGREE}">
        <%// 비학위 분류 %>
        <c:set var="categoryUrlPath" value="/non"/>
    </c:when>
    <c:otherwise>
        <%// MOOC 분류 %>
        <c:set var="categoryUrlPath" value="/mooc"/>
    </c:otherwise>
</c:choose>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata    = null;
var forPopdata    = null;
var forEdit        = null;
var forNewPeriodNumberPopup = null;
var forCopyPopup    = null;
var imageContext = "<c:out value="${aoffn:config('upload.context.image')}"/>";
var imageBlank = "<aof:img type="print" src="bg/bg_white.png"/>";
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
	UI.originalOfThumbnail("timetable");
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="/univ/courseactive${categoryUrlPath}/list.do"/>";
    
    forEdit = $.action();
    forEdit.config.formId = "FormEdit";
    forEdit.config.url    = "<c:url value="/univ/courseactive/edit.do"/>";

    forNewPeriodNumberPopup = $.action("layer");
    forNewPeriodNumberPopup.config.formId = "FormCopyElement";
    forNewPeriodNumberPopup.config.url    = "<c:url value="/univ/courseactive/copy/non/popup.do"/>";
    forNewPeriodNumberPopup.config.options.width = 980;
    forNewPeriodNumberPopup.config.options.height = 630;
    forNewPeriodNumberPopup.config.options.title = "<spring:message code="필드:개설과목:신규개설과목생성"/>";
    
    forCopyPopup = $.action("layer");
    forCopyPopup.config.formId = "FormCopyElement";
    forCopyPopup.config.url    = "<c:url value="/univ/courseactive/copy/popup.do"/>";
    forCopyPopup.config.options.width = 980;
    forCopyPopup.config.options.height = 600;
    forCopyPopup.config.options.title = "<spring:message code="필드:개설과목:개설과목구성정보복사"/>";
    
    forPopdata = $.action("layer");
    forPopdata.config.formId = "FormBrowsePopup";
	forPopdata.config.url = "<c:url value="/agreement/popup.do"/>";
	forPopdata.config.options.width = 700;
	forPopdata.config.options.height = 400;
};

/**
 * 수정화면을 호출하는 함수
 */
doEdit = function(mapPKs) {
    // 수정화면 form을 reset한다.
    UT.getById(forEdit.config.formId).reset();
    // 수정화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forEdit.config.formId);
    // 수정화면 실행
    forEdit.run();
};

/**
 * 목록보기
 */
doList = function() {
    forListdata.run();
};

/**
 * 비학위과정의 기수 신규 생성
 */
doCreatePeriodNumber = function(mapPKs){
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forNewPeriodNumberPopup.config.formId);
    // 실행
    forNewPeriodNumberPopup.run();
};


/**
 * 학위과정의 구성정보 복사
 */
doCopyCourseActive = function(mapPKs){
    // form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forCopyPopup.config.formId);
    // 실행
    forCopyPopup.run();
};

/**
 * 교과목 구성정보 > 강의계획서로 메뉴 이동
 */
doPlan = function(mapPKs){
	var forPlan = $.action();
	    forPlan.config.formId = "FormGoTab";
	    forPlan.config.url = "<c:url value="/univ/course/active/plan/detail.do"/>";
	    
	    // form에 키값을 셋팅한다.
	    UT.copyValueMapToForm(mapPKs, forPlan.config.formId);
	    forPlan.run();
};

doPopup = function(mapPKs) {
	// 등록화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forPopdata.config.formId);
	// 등록화면 실행
	forPopdata.run();
};
</script>
</head>

<body>
    <form id="FormGoTab" name="FormGoTab" method="post" onsubmit="return false;">
        <input type="hidden" name="shortcutCourseActiveSeq"/>
        <input type="hidden" name="shortcutYearTerm"/>        
        <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${detail.category.categoryTypeCd}"/>"/>
        <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${detail.courseActive.courseTypeCd}"/>"/>
    </form>
    
    <form name="FormBrowsePopup" id="FormBrowsePopup" method="post" onsubmit="return false;">
		<input type="hidden" name="agreementSeq" value=""/>
	</form>
    
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
    
    <div style="display:none;">
        <c:import url="srchCourseActive.jsp"/>
    </div>
	<c:import url="../include/commonCourseActive.jsp">
        <c:param name="shortcutCourseActiveSeq" value="${detail.courseActive.courseActiveSeq}"></c:param>
        <c:param name="shortcutYearTerm" value="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE ? detail.courseActive.yearTerm: detail.courseActive.year}"></c:param>
        <c:param name="shortcutCategoryTypeCd" value="${detail.category.categoryTypeCd}"></c:param>
        <c:param name="shortcutCourseTypeCd" value="${detail.courseActive.courseTypeCd}"></c:param>
    </c:import>
    
    <form id="FormCopyElement" name="FormCopyElement" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveTitle" value="<c:out value="${detail.courseActive.courseActiveTitle}"/>">
    <input type="hidden" name="courseMasterSeq" value="<c:out value="${detail.courseActive.courseMasterSeq}"/>"/>
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${detail.courseActive.courseActiveSeq}"/>"/>
    <input type="hidden" name="yearTerm" value="<c:out value="${detail.courseActive.yearTerm}"/>"/>
    <input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${detail.category.categoryTypeCd}"/>"/>
    <input type="hidden" name="srchCourseTypeCd" value="<c:out value="${detail.courseActive.courseTypeCd}"/>"/>
    <input type="hidden" name="callback" value="doPlan">
    <table class="tbl-detail">
        <colgroup>
            <col style="width:120px" />
            <col/>
        </colgroup>
        <tbody>
            <tr>
                <th><spring:message code="필드:개설과목:교과목명"/></th>
                <td>
                    <c:choose>
                        <c:when test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                            [<c:out value="${detail.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${detail.courseActive.term}" removeCodePrefix="true"/>]
                            <c:out value="${detail.courseActive.courseActiveTitle}"/>
                        </c:when>
                        <c:otherwise>
                        	<c:if test="${detail.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
                       			<%--[<c:out value="${detail.courseActive.periodNumber}"/><spring:message code="필드:개설과목:기" />] --%>
                       		</c:if>
                            <c:out value="${detail.courseActive.courseActiveTitle}"/><br/>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th><spring:message code="필드:개설과목:과목분류"/></th>
                <td>
                    <c:out value="${detail.category.categoryString}"/>
                </td>
            </tr>
            <%-- 
            <tr>
                <th><spring:message code="필드:개설과목:학위구분"/></th>
                <td>
                    <aof:code type="print" codeGroup="CATEGORY_TYPE" selected="${detail.category.categoryTypeCd}"></aof:code>
                </td>
            </tr>
            --%>
            <% /** TODO : 소개*/ %>
            <c:choose>
                <c:when test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                    <tr>
                        <th><spring:message code="필드:개설과목:이수구분"/></th>
                        <td>
                           <aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${detail.courseActive.completeDivisionCd}"/>
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <tr>
                        <th><spring:message code="필드:개설과목:교과목소개"/></th>
                        <td>
                           <aof:text type="whiteTag" value="${detail.courseActive.introduction}"></aof:text>
                        </td>
                    </tr>
                    <%--
                    <tr>
                        <th><spring:message code="필드:개설과목:교과목목표"/></th>
                        <td>
                           <aof:text type="whiteTag" value="${detail.courseActive.goal}"></aof:text>
                        </td>
                    </tr>
                     --%>
                </c:otherwise>
            </c:choose>
            
            <c:choose>
                <c:when test="${detail.courseActive.courseTypeCd eq CD_COURSE_TYPE_ALWAYS}">
                    <tr>
		                 <th><spring:message code="필드:개설과목:오픈기간"/></th>
		                 <td>
		                    <aof:date datetime="${detail.courseActive.openStartDate}"/>
		                    ~
		                    <aof:date datetime="${detail.courseActive.openEndDate}"/>
		                 </td>
		             </tr>
		             <tr>
		                 <th><spring:message code="필드:개설과목:학습기간"/></th>
		                 <td>
		                    <c:out value="${detail.courseActive.studyDay}"/>
		                    <spring:message code="필드:개설과목:일간"/>
		                 </td>
		             </tr>
		             <tr>
		                 <th><spring:message code="필드:개설과목:수강취소기간"/></th>
		                 <td>
		                    <c:out value="${detail.courseActive.cancelDay}"/>
		                    <spring:message code="필드:개설과목:일간"/>
		                 </td>
		             </tr>
		             <tr>
		                 <th><spring:message code="필드:개설과목:복습기간"/></th>
		                 <td>
		                 	<spring:message code="필드:개설과목:학습종료일부터"/>
		                 	~
		                    <c:out value="${detail.courseActive.resumeDay}"/>
		                    <spring:message code="필드:개설과목:일간"/>
		                 </td>
		             </tr>
                </c:when>
                <c:otherwise>
		             <tr>
		                 <th><spring:message code="필드:개설과목:학습기간"/></th>
		                 <td>
		                    <aof:date datetime="${detail.courseActive.studyStartDate}"/>
		                    ~
		                    <aof:date datetime="${detail.courseActive.studyEndDate}"/>
		                    (<c:out value="${detail.courseActive.workDay1}"/>박 <c:out value="${detail.courseActive.workDay2}"/>일)
		                 </td>
		             </tr>
                </c:otherwise>
            </c:choose>
            <%--
            <tr>
	            <th><spring:message code="필드:개설과목:별첨"/></th>
	            <td>
	            	<c:forEach var="row" items="${detail.courseActive.attachList}" varStatus="i">
						<a href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(row.attachSeq, pageContext.request)}"/>')"><c:out value="${row.realName}"/></a>
						[<c:out value="${aoffn:getFilesize(row.fileSize)}"/>]
					</c:forEach>
	            </td>
	        </tr>
	         --%>
<%-- 	        <th><spring:message code="필드:개설과목:시간표"/></th>
            <td>
            	<c:choose>
            		<c:when test="${empty timeTable}">
            			<div class="photo cphoto-120">
	            			<aof:img src="common/blank.gif"/>
	            		</div>
            		</c:when>
            		<c:otherwise>
            			<img class="timetable" src="data:image/${imagType};base64,${timeTable}" style="max-width: 400px;">
            		</c:otherwise>
            	</c:choose>
            </td>
            <tr> --%>
           <%--  <th>모듈별 <spring:message code="필드:개설과목:시간표"/></th> --%>
<%--            <td>
             	<table class="tbl-detail">
            		<colgroup>
			            <col style="width:330px" />
			            <col style="width:330px" />
			        </colgroup>
			        <tbody>
			        	<tr>
			        		<td>
			        			<c:choose>
									<c:when test="${!empty detail.courseActive.timetable1}">
										<c:set var="timetable" value ="${aoffn:config('upload.context.image')}${detail.courseActive.timetable1}"/>
										 <img src="${timetable}" class="timetable" title="<spring:message code="필드:개설과목:시간표"/>"  style="max-width: 330px;">
									</c:when>
									<c:otherwise>
										<c:set var="timetable"><aof:img type="print" src="common/blank.gif"/></c:set>
										<div class="photo cphoto-120">
					            			<aof:img src="common/blank.gif"/>
					            		</div>
									</c:otherwise>
								</c:choose>
			        		</td>
			        		
			        		<td>
			        			<c:choose>
									<c:when test="${!empty detail.courseActive.timetable2}">
										<c:set var="timetable" value ="${aoffn:config('upload.context.image')}${detail.courseActive.timetable2}"/>
										 <img src="${timetable}" class="timetable" title="<spring:message code="필드:개설과목:시간표"/>"  style="max-width: 330px;">
									</c:when>
									<c:otherwise>
										<c:set var="timetable"><aof:img type="print" src="common/blank.gif"/></c:set>
										<div class="photo cphoto-120">
					            			<aof:img src="common/blank.gif"/>
					            		</div>
									</c:otherwise>
								</c:choose>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td class="align-c">
			        			Module - 1
			        		</td>
			        		<td class="align-c">
			        			Module - 2
			        		</td>
			        	</tr>
			        	<tr>
			        		<td>
			        			<c:choose>
									<c:when test="${!empty detail.courseActive.timetable3}">
										<c:set var="timetable" value ="${aoffn:config('upload.context.image')}${detail.courseActive.timetable3}"/>
										 <img src="${timetable}" class="timetable" title="<spring:message code="필드:개설과목:시간표"/>"  style="max-width: 330px;">
									</c:when>
									<c:otherwise>
										<c:set var="timetable"><aof:img type="print" src="common/blank.gif"/></c:set>
										<div class="photo cphoto-120">
					            			<aof:img src="common/blank.gif"/>
					            		</div>
									</c:otherwise>
								</c:choose>
			        		</td>
			        		<td>
			        			<c:choose>
									<c:when test="${!empty detail.courseActive.timetable4}">
										<c:set var="timetable" value ="${aoffn:config('upload.context.image')}${detail.courseActive.timetable4}"/>
										 <img src="${timetable}" class="timetable" title="<spring:message code="필드:개설과목:시간표"/>"  style="max-width: 330px;">
									</c:when>
									<c:otherwise>
										<c:set var="timetable"><aof:img type="print" src="common/blank.gif"/></c:set>
										<div class="photo cphoto-120">
					            			<aof:img src="common/blank.gif"/>
					            		</div>
									</c:otherwise>
								</c:choose>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td class="align-c">
			        			Module - 3
			        		</td>
			        		<td class="align-c">
			        			Module - 4
			        		</td>
			        	</tr>
			        	<tr>
			        		<td>
			        			<c:choose>
									<c:when test="${!empty detail.courseActive.timetable5}">
										<c:set var="timetable" value ="${aoffn:config('upload.context.image')}${detail.courseActive.timetable5}"/>
										 <img src="${timetable}" class="timetable" title="<spring:message code="필드:개설과목:시간표"/>"  style="max-width: 330px;">
									</c:when>
									<c:otherwise>
										<c:set var="timetable"><aof:img type="print" src="common/blank.gif"/></c:set>
										<div class="photo cphoto-120">
					            			<aof:img src="common/blank.gif"/>
					            		</div>
									</c:otherwise>
								</c:choose>
			        		</td>
			        		<td>
			        			<c:choose>
									<c:when test="${!empty detail.courseActive.timetable6}">
										<c:set var="timetable" value ="${aoffn:config('upload.context.image')}${detail.courseActive.timetable6}"/>
										 <img src="${timetable}" class="timetable" title="<spring:message code="필드:개설과목:시간표"/>"  style="max-width: 330px;">
									</c:when>
									<c:otherwise>
										<c:set var="timetable"><aof:img type="print" src="common/blank.gif"/></c:set>
										<div class="photo cphoto-120 ">
					            			<aof:img src="common/blank.gif"/>
					            		</div>
									</c:otherwise>
								</c:choose>
			        		</td>
			        	</tr>
			        	<tr>
			        		<td class="align-c">
			        			Module - 5
			        		</td>
			        		<td class="align-c">
			        			Module - 6
			        		</td>
			        	</tr>
			        </tbody>
            	</table> 
            </td>--%>
	        <tr>
	            <th>그룹방 이름</th>
	            <td>
	            	<c:out value="${detail.courseActive.courseGroupTitle}"/>
	            </td>
	        </tr>
	        <tr>
	            <th>약관 선택</th>
	            <td>
	            	<c:if test="${!empty detail.courseActive.agreementSeq1}">
	            		<a href="#" onclick="doPopup({'agreementSeq': '${detail.courseActive.agreementSeq1}'});"><c:out value="${detail.courseActive.agreementTilte1}" /></a><br/>
	            	</c:if>
	            	<c:if test="${!empty detail.courseActive.agreementSeq2}">
	            		<a href="#" onclick="doPopup({'agreementSeq': '${detail.courseActive.agreementSeq2}'});"><c:out value="${detail.courseActive.agreementTilte2}" /></a><br/>
	            	</c:if>
	            	<c:if test="${!empty detail.courseActive.agreementSeq3}">
	            		<a href="#" onclick="doPopup({'agreementSeq': '${detail.courseActive.agreementSeq3}'});"><c:out value="${detail.courseActive.agreementTilte3}" /></a>
	            	</c:if>
	            </td>
	        </tr>
	        <tr>
	            <th>정보 폐기 기간</th>
	            <td>
	            	운영 기간 시작일부터 <c:out value="${detail.courseActive.expireStartDate}"/>년 뒤 폐기
	            </td>
	        </tr>   
	        <tr>
	            <th>썸네일</th>
	            <td>
 				<c:choose>
					<c:when test="${!empty detail.courseActive.thumNail}">
						<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${detail.courseActive.thumNail}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="memberPhoto"><aof:img type="print" src="bg/bg_white.png"/></c:set>
					</c:otherwise>
				</c:choose> 
	               <%-- <a href="javascript:void(0)" onclick="javascript:void(0)" class="btn black" id="uploader"><span class="mid"><spring:message code="버튼:찾아보기" />찾아보기</span></a> --%>
					<div class="photo photo-60">
 						<img src="<c:out value="${memberPhoto}"/>" id="member-photo" title="썸네일">
					</div>	               
	            </td>
	        </tr>              
            <tr>
                <th><spring:message code="필드:개설과목:상태"/></th>
                <td><aof:code type="print" codeGroup="COURSE_ACTIVE_STATUS" defaultSelected="${detail.courseActive.courseActiveStatusCd}"></aof:code></td>
            </tr>
        </tbody>
    </table>
    </form>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
        		<%// 수강생이 있을 경우 수정 불가%>
                <c:choose>
                    <%--
                    <c:when test="${detail.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE && detail.courseActiveSummary.memberCount < 1 && detail.courseActive.courseActiveStatusCd eq CD_COURSE_ACTIVE_STATUS_INACTIVE}">
                        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                            <a href="javascript:void(0)" onclick="doCopyCourseActive()" class="btn blue">
                                <span class="mid"><spring:message code="버튼:개설과목:교과목구성정보복사" /></span>
                            </a>
                        </c:if>
                    </c:when>
                     --%>
                    <c:when test="${detail.category.categoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
                       <%--
                        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
                            <a href="javascript:void(0)"  onclick="doCreatePeriodNumber({'courseActiveSeq' : '<c:out value="${detail.courseActive.courseActiveSeq}"/>','courseMasterSeq' : <c:out value="${detail.courseActive.courseMasterSeq}"/>});" class="btn blue">
                            	<span class="mid"><spring:message code="버튼:개설과목:신규개설과목생성" /></span>
                           	</a>
                        </c:if>
                         --%>
                        <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
	                        <a href="#" onclick="doEdit({'courseActiveSeq' : '${detail.courseActive.courseActiveSeq}','shortcutYearTerm' : '${detail.courseActive.year}','shortcutCourseActiveSeq' : '${detail.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${detail.category.categoryTypeCd}'});" class="btn blue">
	                            <span class="mid"><spring:message code="버튼:개설과목:수정" /></span>
	                        </a>
                        </c:if>
                    </c:when>
                </c:choose>
            <a href="#" onclick="doList()" class="btn blue"><span class="mid"><spring:message code="버튼:목록" /></span></a>
        </div>
    </div>
</body>
</html>