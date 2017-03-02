<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forDeletelist = null;
var forCreate     = null;
var forCopyPopup = null;
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
    forDetail.config.url    = "<c:url value="/univ/coursemaster/detail.do"/>";
    
    forDeletelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
    forDeletelist.config.url             = "<c:url value="/univ/coursemaster/deletelist.do"/>";
    forDeletelist.config.target          = "hiddenframe";
    forDeletelist.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
    forDeletelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forDeletelist.config.fn.complete     = doCompleteDeletelist;
    forDeletelist.validator.set({
        title : "<spring:message code="필드:삭제할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
    
    forCreate = $.action();
    forCreate.config.formId = "FormCreate";
    forCreate.config.url    = "<c:url value="/univ/coursemaster/create.do"/>";

    forCopyPopup = $.action("layer");
    forCopyPopup.config.formId = "FormData";
    forCopyPopup.config.url    = "<c:url value="/univ/coursemaster/copy/popup.do"/>";
    forCopyPopup.config.options.width = 470;
    forCopyPopup.config.options.height = 480;
    forCopyPopup.config.options.title = "<spring:message code="필드:교과목:개설과목생성"/>";
    
    setValidate();
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
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
 * 목록보기 가져오기 실행.
 */
doList = function() {
    forListdata.run();
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
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
    // 등록화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
    // 등록화면 실행
    forCreate.run();
};

/**
 * 개설과목 생성
 */
doCreateCourseActive = function(mapPKs){
	if($("input[name=checkkeys]:checked").length > 0){
		forCopyPopup.run();
	} else {
		 $.alert({
		        message : "<spring:message code="글:교과목:교과목을선택하십시오."/>",
		        button1 : {
		            callback : function() {}
		        }
		    });
	}
	
};
</script>
</head>

<body>
    <c:import url="/WEB-INF/view/include/breadcrumb.jsp">
        <c:param name="suffix"><spring:message code="글:목록" /></c:param>
    </c:import>

    <c:import url="srchCourseMaster.jsp"/>

    <c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>
    
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
    <input type="hidden" name="callback" value="doList"/>
    <table id="listTable" class="tbl-list">
    <colgroup>
        <%// 비학위 혹은 MOOC일 경우 %>
        <c:if test="${condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
            <col style="width: 40px" />
        </c:if>
        <col style="width: 50px" />
        <col style="width: auto" />
        <%// 학위일 경우 %>
        <c:if test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
            <col style="width: 80px" />
        </c:if>
        <col style="width: 100px" />
        <col style="width: 140px" />
        <col style="width: 90px" />
        <col style="width: 80px" />
    </colgroup>
    <thead>
        <tr>
            <%// 비학위 혹은 MOOC일 경우 %>
            <c:if test="${condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
                <th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
            </c:if>
            <th><spring:message code="필드:번호" /></th>
            <th><span class="sort" sortid="2"><spring:message code="필드:교과목:교과목명" /></span></th>
            <%// 학위일 경우 %>
            <c:if test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
                <th><span class="sort" sortid="3"><spring:message code="필드:교과목:이수구분" /></span></th>
            </c:if>
            <th><span class="sort" sortid="4"><spring:message code="필드:교과목:상태" /></span></th>
            <th><span class="sort" sortid="5"><spring:message code="필드:교과목:개설교과목활용수" /></span></th>
            <th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
            <th><spring:message code="필드:교과목:상세보기" /></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${paginate.itemList}" varStatus="i">
	        <tr>
	           <%// 비학위 혹은 MOOC일 경우 %>
	            <c:if test="${condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
	                <td>
	                   <input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
	                   <input type="hidden" name="courseMasterSeqs" value="<c:out value="${row.courseMaster.courseMasterSeq}"/>">
                   </td>
	            </c:if>
	            <td><c:out value="${paginate.descIndex - i.index}"/></td>
	            <td class="align-l">
	               <c:out value="${row.category.categoryString}"/><br/>
	               <c:out value="${row.courseMaster.courseTitle}"/>
               </td>
               <%// 학위일 경우 %>
                <c:if test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
	            <td><aof:code type="print" codeGroup="COMPLETE_DIVISION" defaultSelected="${row.courseMaster.completeDivisionCd}"></aof:code></td>
	            </c:if>
	            <td><aof:code type="print" codeGroup="COURSE_STATUS" defaultSelected="${row.courseMaster.courseStatusCd}"></aof:code></td>
	            <td><c:out value="${row.courseMaster.useCount}"/></td>
	            <td><aof:date datetime="${row.courseMaster.regDtime}"/></td>
	            <td>
	               <a href="javascript:doDetail({'courseMasterSeq' : '<c:out value="${row.courseMaster.courseMasterSeq}"/>'});" class="btn gray">
	                   <span class="small"><spring:message code="버튼:상세보기" /></span>
                   </a>
                </td>
	        </tr>
        </c:forEach>
        <c:if test="${empty paginate.itemList}">
	        <tr>
	            <td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
	        </tr>
	    </c:if>
    </tbody>
    </table>
    </form>
    
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>

    <div id="checkMsg" class="comment" style="display: none;">
            ※ <spring:message code="글:교과목:개설교과목활용수가0개인교과목만삭제가능합니다."/>
    </div>
<%--     <div class="lybox-btn">
	    <div class="lybox-btn-l" id="checkButton" style="display:none;">
	       <c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'D') && condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
                <a href="javascript:void(0)" onclick="doDeletelist()" class="btn blue"><span class="mid"><spring:message code="버튼:삭제" /></span></a>
            </c:if>
	    </div>
	    <div class="lybox-btn-r">
	       <c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C') && condition.srchCategoryTypeCd ne CD_CATEGORY_TYPE_DEGREE}">
	            <a href="javascript:void(0)" onclick="doCreateCourseActive()" class="btn blue"><span class="mid"><spring:message code="버튼:교과목:개설과목생성" /></span></a>
	            <a href="javascript:void(0)" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
	        </c:if>
	    </div>
	</div> --%>
</body>
</html>