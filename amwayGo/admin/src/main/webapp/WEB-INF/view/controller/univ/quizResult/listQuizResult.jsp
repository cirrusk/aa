<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<head>

<title></title>
<script type="text/javascript">
var forSearch       = null;
var forListdata     = null;
var forDetail 		= null;
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
    forSearch.config.url    = "<c:url value="/univ/course/active/quiz/answer/list.do"/>";
    
	forListdata = $.action();
    forListdata.config.formId = "FormData";
    forListdata.config.url    = "<c:url value="/univ/course/active/quiz/answer/list.do"/>";

    forDetail = $.action("ajax");
    forDetail.config.formId      = "FormDetail";
    forDetail.config.type        = "html";
    forDetail.config.url         = "<c:url value="/univ/course/active/quiz/answer/detail/ajax.do"/>";
	forDetail.config.fn.complete = function() {
		
	};
	
	forDetailPopup = $.action();
	forDetailPopup.config.formId         = "FormDetail";
	forDetailPopup.config.url            = "<c:url value="/univ/course/active/quiz/answer/detail/popup.do"/>";
	forDetailPopup.config.target = "_blank";
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
 * 상세보기 화면을 호출하는 함수 
 */
var timeout = null;
doDetail = function(mapPKs) {
	clearTimeout(timeout);
	
    forDetail.config.containerId = "container-"+ mapPKs.examItemSeq;
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
    // 상세화면 실행
    forDetail.run();
    
    $(".containerExample, .loading").hide();
    $("#loading-"+mapPKs.examItemSeq).show();
    $("#"+mapPKs.examItemSeq).show();
    
    timeout = setInterval('doClearTrigger()', 5000);
    
};


doDetailPopup = function(mapPKs) {
	
	UT.getById(forDetailPopup.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetailPopup.config.formId);
	forDetailPopup.run();
};

/**
 * 퀴즈 결과 상세 트리거
 */
doClearTrigger = function() {
	
    // 상세화면 실행
    forDetail.run();
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
 	<!-- 년도학기 / 개설과목 Shortcut Area Start -->
    <c:import url="../include/commonCourseActive.jsp"></c:import>
    <!-- 년도학기 / 개설과목 Shortcut Area End -->
 	
 	<c:import url="srchQuizResult.jsp" />
 
 	<c:import url="/WEB-INF/view/include/perpage.jsp">
        <c:param name="onchange" value="doSearch"/>
        <c:param name="selected" value="${condition.perPage}"/>
    </c:import>
    <form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <table id="listTable" class="tbl-list mt10">
	    <colgroup>
	        <col style="width: 50px" />
	        <col style="width: 350px" />
	        <col style="width: 80px" />
	        <col style="width: 80px" />
<!-- 	        <col style="width: 80px" /> -->
	    </colgroup>
	    <thead>
	        <tr>
	            <th><spring:message code="필드:번호" /></th>
	            <th><span class="sort" sortid="1"><spring:message code="필드:퀴즈:제목" /></span></th>
	            <th><span class="sort" sortid="2"><spring:message code="필드:퀴즈:퀴즈유형" /></span></th>
	            <th><span class="sort" sortid="3"><spring:message code="필드:퀴즈:출제자" /></span></th>
<%-- 	            <th><span class="sort" sortid="4"><spring:message code="필드:퀴즈:일시" /></span></th> --%>
	        </tr>
	    </thead>
	    <tbody>
	    	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
	    		<tr>
	    			<td>
	    				<c:out value="${paginate.descIndex - i.index}"/>
    				</td>
	                <td class="align-l">
	                	<a href="javascript:doDetailPopup({'courseActiveSeq':'<c:out value="${row.courseQuizAnswer.courseActiveSeq}"/>','examItemSeq' : '<c:out value="${row.courseQuizAnswer.examItemSeq}"/>','courseActiveProfSeq':'<c:out value="${row.courseQuizAnswer.courseActiveProfSeq}"/>','quizDtime':'<c:out value="${row.courseQuizAnswer.quizDtime}"/>','count':'<c:out value="${paginate.descIndex - i.index}"/>'});">
	                		<c:out value="${row.courseExamItem.examItemTitle}"/>
	                	</a>
	                	<aof:img src="common/loading.gif" style="display:none;" styleClass="loading" id="loading-${row.courseQuizAnswer.examItemSeq}"/>
	                </td>
	                <td>
	                	<aof:code type="print" codeGroup="EXAM_ITEM_TYPE" selected="${row.courseExamItem.examItemTypeCd}"></aof:code>
	                </td>
	                <td>
	                	<c:out value="${row.member.memberName}"/>
	                </td>
<!-- 	                <td> -->
<%-- 	                	<aof:date datetime="${row.courseQuizAnswer.quizDtime}"/> --%>
<!-- 	                </td> -->
	    		</tr>
	    		<tr id="<c:out value="${row.courseQuizAnswer.examItemSeq}"/>" style="display: none;" class="containerExample">
	    			<td colspan="4" id="container-<c:out value="${row.courseQuizAnswer.examItemSeq}"/>">
	    			</td>
	    		</tr>
	    	</c:forEach>
	        <c:if test="${empty paginate.itemList}">
	            <tr>
	                <td colspan="4" align="center"><spring:message code="글:데이터가없습니다" /></td>
	            </tr>
	        </c:if>
	 	</tbody>
    </table>
    </form>
    
    <c:import url="/WEB-INF/view/include/paging.jsp">
        <c:param name="paginate" value="paginate"/>
    </c:import>
    
</div>
</body>
</html>