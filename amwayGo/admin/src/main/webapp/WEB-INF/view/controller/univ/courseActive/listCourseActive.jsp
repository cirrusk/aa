<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_COURSE_TYPE_PERIOD"            value="${aoffn:code('CD.COURSE_TYPE.PERIOD')}"/>
<c:set var="CD_COURSE_TYPE_ALWAYS"            value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"          value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_ACTIVE_STATUS_INACTIVE" value="${aoffn:code('CD.COURSE_ACTIVE_STATUS.INACTIVE')}"/>

<c:forEach var="row" items="${appMenuList}">
    <c:choose>
        <c:when test="${row.menu.cfString eq 'ACTIVEHOME'}">
            <c:set var="menuActiveHomeDetail" value="${row}" scope="request"/>
        </c:when>
        <c:when test="${row.menu.url eq '/univ/courseactive/detail.do'}">
			<c:set var="menuCourseActiveDetail" value="${row}" scope="request"/>
        </c:when>
    </c:choose>
</c:forEach>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCopyPopup  = null;
var forNewNondegreePopup = null;
initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
 // [2] sorting 설정
    FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action();
    forSearch.config.formId = "FormSrch";
    forSearch.config.url    = "<c:url value="${requestScope['javax.servlet.forward.servlet_path']}"/>";

    forListdata = $.action();
    forListdata.config.formId = "FormList";
    forListdata.config.url    = "<c:url value="${requestScope['javax.servlet.forward.servlet_path']}"/>";

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/courseactive/detail.do"/>";
	
	forCopyPopup = $.action("layer");
    forCopyPopup.config.formId = "FormData";
    forCopyPopup.config.url    = "<c:url value="/univ/courseactive/copylist/popup.do"/>";
    forCopyPopup.config.options.width = 980;
    forCopyPopup.config.options.height = 500;
    forCopyPopup.config.options.title = "<spring:message code="필드:개설과목:개설과목구성정보복사"/>";
    
    forNewNondegreePopup = $.action("layer");
    forNewNondegreePopup.config.formId = "FormData";
    forNewNondegreePopup.config.url    = "<c:url value="/univ/courseactive/copylist/non/popup.do"/>";
    forNewNondegreePopup.config.options.width = 980;
    forNewNondegreePopup.config.options.height = 530;
    forNewNondegreePopup.config.options.title = "<spring:message code="필드:개설과목:신규개설과목생성"/>";
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

/**
 * 상세보기 화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};

/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPage = function(pageno) {
    var form = UT.getById(forListdata.config.formId);
    if(form.elements["currentPage"] != null && pageno != null) {
        form.elements["currentPage"].value = pageno;
    }
    doList();
};
/**
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
};

/**
 * 학위과정의 개설과목 생성
 */
doCreateCourseActive = function(){
    if($("input[name=checkkeys]:checked").length > 0){
        forCopyPopup.run();
    } else {
         $.alert({
                message : "<spring:message code="글:교과목:교과목을선택하십시오."/>",
                button1 : {
                    callback : function() {
                    	$("input[name=checkkeys]").eq(0).focus();
                    }
                }
            });
    }
};

/**
 * 비학위과정의 기수 신규 생성
 */
 
 doCreateNondegree = function(){
	
	if($("input[name=checkkeys]:checked").length > 0){
		forNewNondegreePopup.run();
    } else {
         $.alert({
                message : "<spring:message code="글:교과목:교과목을선택하십시오."/>",
                button1 : {
                    callback : function() {
                    	$("input[name=checkkeys]").eq(0).focus();
                    }
                }
            });
    }
}

/**
 * 교과목 구성정보의 상세 정보 페이지 이동
 */
doGoMenuOfTab = function(mapPKs) {
	var menuUrl = null;
	switch(mapPKs.code) {
	case "MIDEXAM": // 중간고사
		menuUrl = "<c:out value="${appSystemDomain}"/><c:url value="/univ/course/active/middle/exampaper/list.do"/>";
		break;
	case "FINALEXAM": // 기말고사
		menuUrl = "<c:out value="${appSystemDomain}"/><c:url value="/univ/course/active/final/exampaper/list.do"/>";
		break;
	case "HOMEWORK": // 과제
		menuUrl = "<c:out value="${appSystemDomain}"/><c:url value="/univ/course/active/homework/list.do"/>";
		break;
	case "DISCUSS": // 토론
		menuUrl = "<c:out value="${appSystemDomain}"/><c:url value="/univ/course/active/discuss/list.do"/>";
		break;
	case "EXAM": // 시험
		menuUrl = "<c:out value="${appSystemDomain}"/><c:url value="/univ/course/active/exampaper/list.do"/>";
		break;
	case "QUIZ": // 쿼즈
		menuUrl = "<c:out value="${appSystemDomain}"/><c:url value="/univ/course/active/quiz/list.do"/>";
		break;
	case "TEAMPROJECT": // 팀프로젝트
		menuUrl = "<c:url value="/univ/course/active/teamproject/list.do"/>";
		break;
	}
	var menuId = '<c:out value="${aoffn:encrypt(menuActiveHomeDetail.menu.menuId)}"/>';
	var menudependent = '<c:out value="${menuActiveHomeDetail.menu.dependent}"/>';
	var urlTarget = '<c:out value="${menuActiveHomeDetail.menu.urlTarget}"/>';
	// form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, menudependent);
	
	FN.doGoMenu(menuUrl,menuId,menudependent,urlTarget);
};
</script>
</head>

<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:목록" /></c:param>
    </c:import>
    
    <c:import url="srchCourseActive.jsp"/>
    
    <c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>

    <%// 목록에서 구성정보 바로가기위해 추가(Form 충돌로 인한 list페이지에 추가함)%>
    <form name="FormActiveParam" id="FormActiveParam" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutCourseActiveSeq"/>
	    <input type="hidden" name="shortcutYearTerm"/>        
	    <input type="hidden" name="shortcutCategoryTypeCd"/>
	    <input type="hidden" name="shortcutCourseTypeCd"/>
	</form>

    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="callback" value="doList"/>
    <input type="hidden" name="srchCategoryTypeCd" value="<c:out value="${condition.srchCategoryTypeCd}"/>">
    <input type="hidden" name="srchCourseTypeCd" value="<c:out value="${condition.srchCourseTypeCd}"/>">
    <input type="hidden" name="yearTerm" value="<c:out value="${condition.srchYearTerm}"/>">
    <table id="listTable" class="tbl-list">
    <colgroup>
        <%--<col style="width: 3%" />--%>
        <col style="width: 40px;" />
        <col style="width: 220px;" />
        <col style="width: 80px;" />
        <%--
        <col style="width: 12%" />
        <col style="width: 10%" />
         
        <col style="width: 15%" />
        --%>
        <col style="width: 80px" />
        <col style="width: 60px;" />
        <col style="width: 70px;" />
    </colgroup>
    <thead>
        <tr>
        	<%--
            <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys');" /></th>
             --%>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:개설과목:교과목" /></span></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:개설과목:과목분류" /></span></th>
            <%--
            <th>
            	<c:if test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
	                <spring:message code="필드:개설과목:중간고사" /><br/>
	                <spring:message code="필드:개설과목:기말고사" />
                </c:if>
            	<c:if test="${condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
	                <spring:message code="필드:개설과목:시험" />
                </c:if>
            </th>
            <th>
                <spring:message code="필드:개설과목:퀴즈" /><br/>
                <spring:message code="필드:개설과목:토론" />
            </th>
             --%>
             <%--
            <th>
            	  
                <spring:message code="필드:개설과목:과제" />
                
                <c:if test="${condition.srchCourseTypeCd ne CD_COURSE_TYPE_ALWAYS}">
	                <spring:message code="필드:개설과목:팀프로젝트" />
                </c:if>
            </th>
            --%>
            <th><spring:message code="필드:개설과목:수강인원" /></th>
            <th><span class="sort" sortid="3"><spring:message code="필드:개설과목:상태" /></span></th>
            <th><span class="sort" sortid="4"><spring:message code="필드:등록일" /></span></th>
        </tr>
    </thead>
    <tbody>
    	<c:set var="checkIndex" value="0"/>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
            <tr>
            	<%--
                <td>
                     <c:set var="appToday"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdatetimeStart')}"/></c:set>
                      <%// 체크박스 나올수 있는 조건
                       // - 학위 일경우 => 수강생이 없고 운영상대가 대기일 경우
                       // - 비학위 일경우 => 수강생이 없을 경우
                       %>
                       <c:set var="isShowCheckbox" value="false"/>
                   		<c:choose>
                   			<c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                   				<c:if test="${row.courseActiveSummary.memberCount < 1 && row.courseActive.courseActiveStatusCd eq CD_COURSE_ACTIVE_STATUS_INACTIVE}">
                   					<c:set var="isShowCheckbox" value="true"/>
                   				</c:if>
                   			</c:when>
                   			<c:otherwise>
                   				<c:set var="isShowCheckbox" value="true"/>
                   			</c:otherwise>
                   		</c:choose>	
                    <c:if test="${isShowCheckbox == true}">
                        <input type="checkbox" name="checkkeys" value="<c:out value="${checkIndex}"/>" onclick="FN.onClickCheckbox(this)">
                        <input type="hidden" name="courseMasterSeqs" value="<c:out value="${row.courseActive.courseMasterSeq}"/>">
                        <input type="hidden" name="courseActiveSeqs" value="<c:out value="${row.courseActive.courseActiveSeq}"/>">
                        <input type="hidden" name="courseActiveTitles" value="<c:out value="${row.courseActive.courseActiveTitle}"/>">
                        <c:set var="checkIndex" value="${checkIndex+1}"/>
                    </c:if>
                </td>
                 --%>
                <input type="hidden" name="courseMasterSeqs" value="<c:out value="${row.courseActive.courseMasterSeq}"/>">
                <input type="hidden" name="courseActiveSeqs" value="<c:out value="${row.courseActive.courseActiveSeq}"/>">
                <input type="hidden" name="courseActiveTitles" value="<c:out value="${row.courseActive.courseActiveTitle}"/>">
                <td><c:out value="${paginate.descIndex - i.index}"/></td>
                <td class="align-l">
                   <c:choose>
                        <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                            <a href="#" onclick="doDetail({'courseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutYearTerm' : '${row.courseActive.yearTerm}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}'});">
                            [<c:out value="${row.courseActive.year}"/>-<aof:code type="print" codeGroup="TERM_TYPE" selected="${row.courseActive.term}" removeCodePrefix="true"/>]<br/>
                            <c:out value="${row.courseActive.courseActiveTitle}"/>
                            </a>
                            <br/>
                           <spring:message code="필드:개설과목:이수구분" /> : <aof:code type="print" codeGroup="COMPLETE_DIVISION" selected="${row.courseActive.completeDivisionCd}"/>
                        </c:when>
                        <c:otherwise>
                        	<a href="#" onclick="doDetail({'courseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutYearTerm' : '${row.courseActive.year}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}'});">
                        	[<c:out value="${row.courseMaster.courseTitle}"/>]<br/>
                            	<%--
                            	[<aof:code type="print" codeGroup="COURSE_TYPE" selected="${row.courseActive.courseTypeCd}"/>
                                
                                <c:if test="${row.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
                                	- <c:out value="${row.courseActive.periodNumber}"/><spring:message code="필드:개설과목:기" />
                               	</c:if>]<br/>
                               	 --%>
                                <c:out value="${row.courseActive.courseActiveTitle}"/><br/>
                            </a>
                            <spring:message code="필드:개설과목:학습기간" />
                            :
                            <c:choose>
                            	<c:when test="${row.courseActive.courseTypeCd eq CD_COURSE_TYPE_PERIOD}">
		                            <aof:date datetime="${row.courseActive.studyStartDate}"></aof:date>
		                            ~
		                            <aof:date datetime="${row.courseActive.studyEndDate}"></aof:date>
                            	</c:when>
                            	<c:otherwise>
		                            <spring:message code="필드:개설과목:학습시작일로부터"/>
				                 	~
				                    <c:out value="${row.courseActive.studyDay}"/>
				                    <spring:message code="필드:개설과목:일간"/>
                            	</c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:out value="${row.category.categoryName}"/>
                </td>
                <%--
                <td>
                	<c:if test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                		<c:set var="_shortcutYearTerm_" value="${row.courseActive.yearTerm}"/>
                		
                		<a href="#" onclick="doGoMenuOfTab({code :'MIDEXAM','shortcutYearTerm' : '${_shortcutYearTerm_}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
                			<spring:message code="필드:개설과목:중간고사출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeMiddleCount}"/>
                		</a>
		                <br/>
		                <a href="#" onclick="doGoMenuOfTab({code :'FINALEXAM','shortcutYearTerm' : '${_shortcutYearTerm_}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
                    		<spring:message code="필드:개설과목:기말고사출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeFinalCount}"/>
                    	</a>
	                </c:if>
	            	<c:if test="${condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
	            		<c:set var="_shortcutYearTerm_" value="${row.courseActive.year}"/>
	            		
	            		<a href="#" onclick="doGoMenuOfTab({code :'EXAM','shortcutYearTerm' : '${row.courseActive.year}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
		                	<spring:message code="필드:개설과목:시험출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeExamCount}"/>
		                </a>
	                </c:if>
                </td>
                <td>
                	<a href="#" onclick="doGoMenuOfTab({code :'QUIZ','shortcutYearTerm' : '${_shortcutYearTerm_}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
                    	<spring:message code="필드:개설과목:퀴즈출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeQuizCount}"/>
                    </a>
                    <br/>
                    <a href="#" onclick="doGoMenuOfTab({code :'DISCUSS','shortcutYearTerm' : '${_shortcutYearTerm_}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
                    	<spring:message code="필드:개설과목:토론출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeDiscussCount}"/>
                    </a>
                </td>
                 --%>
                 <%--
                <td>
                	
                	<a href="#" onclick="doGoMenuOfTab({code :'HOMEWORK','shortcutYearTerm' : '${_shortcutYearTerm_}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
                    	<spring:message code="필드:개설과목:과제출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeHomeworkCount}"/>
                    </a>
                    
                    <c:if test="${condition.srchCourseTypeCd ne CD_COURSE_TYPE_ALWAYS}">
	                    <a href="#" onclick="doGoMenuOfTab({code :'TEAMPROJECT','shortcutYearTerm' : '${_shortcutYearTerm_}','shortcutCourseActiveSeq' : '${row.courseActive.courseActiveSeq}','shortcutCategoryTypeCd' : '${row.category.categoryTypeCd}',shortcutCourseTypeCd : '${row.courseActive.courseTypeCd}'})">
	                    	<spring:message code="필드:개설과목:팀프로젝트출제" /> &nbsp;<c:out value="${row.courseActiveSummary.activeTeamProjectCount}"/>
	                    </a>
                    </c:if>
                </td>
                 --%>
                <td><c:out value="${row.courseActiveSummary.memberCount}"/></td>
                <td><aof:code type="print" codeGroup="COURSE_ACTIVE_STATUS" defaultSelected="${row.courseActive.courseActiveStatusCd}"></aof:code></td>
                <td><aof:date datetime="${row.courseActive.regDtime}"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
            <tr>
                <td colspan="6" align="center"><spring:message code="글:데이터가없습니다" /></td>
            </tr>
        </c:if>
    </tbody>
    </table>
    </form>
    
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>
    
    <div class="lybox-btn">
        <div class="lybox-btn-l">
        </div>
        <div class="lybox-btn-r">
        	<%-- 
           <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') && not empty paginate.itemList}">
                <%/** TODO : 코드*/ %>
                <c:choose>
                    <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                        <a href="javascript:void(0)" onclick="doCreateCourseActive()" class="btn blue"><span class="mid"><spring:message code="버튼:개설과목:교과목구성정보복사" /></span></a>
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:void(0)" onclick="doCreateNondegree()" class="btn blue"><span class="mid"><spring:message code="버튼:개설과목:신규개설과목생성" /></span></a>
                    </c:otherwise>
                </c:choose>
            </c:if>
            --%>
        </div>
    </div>
</body>
</html>