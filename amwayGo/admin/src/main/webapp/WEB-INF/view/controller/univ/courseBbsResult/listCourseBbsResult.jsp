<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">

var forSearch     = null;
var forListdata   = null;
var forDetail     = null;

initPage = function() {
	
	doInitializeLocal();

	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);

};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url = "<c:url value="/univ/course/bbs/result/${boardType}/list.do"/>";
	
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/bbs/result/${boardType}/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/bbs/result/${boardType}/detail.do"/>";

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
doDetail = function(mapPKs) {
	
	UT.getById(forDetail.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	forDetail.run();
	
};

</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp"></c:import>
		
	<div class="lybox-title"><!-- lybox-title -->
	    <div class="right">
	        <!-- 년도학기 / 개설과목 Shortcut Area Start -->
	        <c:import url="../include/commonCourseActive.jsp"></c:import>
	        <!-- 년도학기 / 개설과목 Shortcut Area End -->
	    </div>
	</div>
	
	<!-- 참여결과 Tab Area Start -->
	<c:import url="commonCourseBbsResuitElement.jsp">
	    <c:param name="courseActiveSeq" value="${param['shortcutCourseActiveSeq']}"></c:param>
	    <c:param name="selectedElementTypeCd" value="${condition.srchBoardSeq}"/>
	</c:import>
	
	<div class="vspace"></div>
	
	<c:import url="srchCourseBbsResult.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<c:set var="colspanCount" value="0"></c:set>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list">
		    <colgroup>
		        <col style="width: 50px" />
		        <col style="width: auto" />
		        <col style="width: 150px" />
		        <col style="width: 150px" />
		        <col style="width: 150px" />
		        <col style="width: 100px" />
		    </colgroup>
	    	<thead>
		        <tr>
		        	<th><spring:message code="필드:번호" /></th>
		            <th><span class="sort" sortid="2"><spring:message code="필드:참여결과:제목" /></th>
		            <th><spring:message code="필드:참여결과:평가대상여부" /></th>
		            <th><spring:message code="필드:참여결과:등록자" /></th>
		            <th><span class="sort" sortid="1"><spring:message code="필드:참여결과:등록일" /></th>
		            <th><spring:message code="필드:참여결과:조회수" /></th>
		        </tr>
	    	</thead>
	    	<tbody>
			
				<c:forEach var="row" items="${alwaysTopList}" varStatus="i">
					<tr>
				        <td><spring:message code="필드:게시판:공지" /></td>
						<td class="align-l">
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
							</c:if>
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.commentCount gt 0}">
								[<c:out value="${row.bbs.commentCount}" />]
							</c:if>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td> - </td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
					</tr>
				</c:forEach>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
				        <td><c:out value="${paginate.descIndex - i.index}"/></td>
						<td class="align-l" style="padding-left:<c:out value="${padding}"/>px;">
							<c:if test="${row.bbs.groupLevel gt 1}">
								re:
							</c:if>
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
							</c:if>
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.commentCount gt 0}">
								[<c:out value="${row.bbs.commentCount}" />]
							</c:if>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td>
							<aof:code type="print" codeGroup="YESNO" selected="${row.bbs.evaluateYn}" removeCodePrefix="true"/>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
					</tr>
				</c:forEach>
				<c:if test="${empty alwaysTopList and empty paginate.itemList}">
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
	
</body>
</html>