<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_BOARD_TYPE"        value="${aoffn:code('CD.BOARD_TYPE')}"/>
<c:set var="CD_BOARD_TYPE_ADDSEP" value="${CD_BOARD_TYPE}::"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_BOARD_TYPE_ADDSEP = "<c:out value="${CD_BOARD_TYPE_ADDSEP}"/>";

var forSearch     = null;
var forBbsList    = null;

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
	forSearch.config.url = "<c:url value="/univ/course/bbs/result/member/list.do"/>";

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
 * 학습자 참여결과 게시판 데이터 가공
 */
doBbsEvaluateDataParser = function(id, seq, dataString) {
	
	var splitBoardData = dataString.split("#");
	
	if(splitBoardData != null){
		for(var i = 0; i < splitBoardData.length; i++){
			var splitData = splitBoardData[i].split("__");
			var boardSeq = splitData[0];
			var boardTypeCd = splitData[1];
			var evaluateYesCount = splitData[2];
			var evaluateNoCount = splitData[3];
			var key = id + "_" + boardTypeCd.replace(CD_BOARD_TYPE_ADDSEP, "");
			var innerHtml = "<a href=\"#\" onclick=\"javascript:doBbsList({ 'srchBoardSeq' : '" + boardSeq + "', 'srchRegMemberSeq' : '" + seq + "' }, '" 
					+ boardTypeCd.replace(CD_BOARD_TYPE_ADDSEP, "").toLowerCase() + "');\">" + evaluateYesCount + " / " + (Number(evaluateYesCount) + Number(evaluateNoCount)) + "</a>";
			
			$("#"+ key).empty();
			$("#"+ key).append(innerHtml);
		}
	}

};

/**
 * 상세보기 화면을 호출하는 함수
 */
doBbsList = function(mapPKs, urlType) {
	
	forBbsList = $.action();
	forBbsList.config.formId = "FormList";
	"<c:set var='actionType' value='" + urlType + "' scope='request'/>";
	forBbsList.config.url = "<c:url value="/univ/course/bbs/result/${actionType}/list.do"/>";

	UT.getById(forBbsList.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forBbsList.config.formId);
	forBbsList.run();

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
	    <c:param name="selectedElementTypeCd" value="0"/>
	</c:import>
	
	<div class="vspace"></div>
	
	<c:import url="srchCourseBbsResultMember.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<c:set var="colspanCount" value="0"></c:set>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	    <input type="hidden" name="shortcutYearTerm" value="<c:out value="${param['shortcutYearTerm']}"/>"/>
	    <input type="hidden" name="shortcutCourseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
	    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
	    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
	    
	    <table id="listTable" class="tbl-list">
		    <colgroup>
		        <col style="width: 50px" />
		        <col style="width: 50px" />
		        <col style="width: auto" />
		        <col style="width: 150px" />
		        <col style="width: 150px" />
		        
    			<!-- Board Area  -->
				<c:forEach var="boardRow" items="${boardList}" varStatus="i">
					<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardRow.board.boardTypeCd, ',') eq false and boardRow.board.joinYn eq 'Y'}">
						<col style="width: 150px" />
					</c:if>
				</c:forEach>		        
		        
		        <col style="width: 100px" />
		    </colgroup>
	    	<thead>
		        <tr>
		        	<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
		        	<th><spring:message code="필드:번호" /></th>
		            <th><span class="sort" sortid="1"><spring:message code="필드:참여결과:이름" /></th>
		            <th><span class="sort" sortid="2"><spring:message code="필드:참여결과:학과" /></th>
		            <th><span class="sort" sortid="3"><spring:message code="필드:참여결과:아이디" /></th>
		            
	    			<!-- Board Area  -->
					<c:forEach var="boardRow" items="${boardList}" varStatus="i">
						<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardRow.board.boardTypeCd, ',') eq false and boardRow.board.joinYn eq 'Y'}">
							<th><c:out value="${boardRow.board.boardTitle}"/></th>
							<c:set var="colspanCount" value="${colspanCount + 1}"></c:set>
						</c:if>
					</c:forEach>
		            
		            <th><spring:message code="필드:참여결과:취득점수점" /></th>
		        </tr>
	    	</thead>
	    	<tbody>
	    	
	    	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
				<tr>
					<td>
						<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
						<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}"/>" />
						<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}"/>" />
						<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}"/>" />
	    			</td>
	    			<td>
						<c:out value="${paginate.descIndex - i.index}"/>
					</td>
					<td>
						<c:out value="${row.member.memberName}"/>
					</td>
					<td>
						<c:out value="${row.member.memberId}"/>
					</td>
					<td>
						<c:out value="${row.category.categoryName}"/>
					</td>
	    			
	    			<!-- Board Area  -->
					<c:forEach var="boardRow" items="${boardList}" varStatus="i">
						<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardRow.board.boardTypeCd, ',') eq false and boardRow.board.joinYn eq 'Y'}">
							<td id="<c:out value="${row.member.memberId}"/>_<c:out value="${fn:replace(boardRow.board.boardTypeCd, CD_BOARD_TYPE_ADDSEP, '')}"/>">
							 - 
							</td>
						</c:if>
					</c:forEach>
					
					<td>
						<c:out value="${row.bbsScore}"/>
					</td>
	    		</tr>
	    		<script>doBbsEvaluateDataParser('<c:out value="${row.member.memberId}"/>', '<c:out value="${row.member.memberSeq}"/>', '<c:out value="${row.bbsEvaluateData}"/>');</script>
	    	</c:forEach>		

			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="<c:out value="${colspanCount + 6}"/>" align="center"><spring:message code="글:데이터가없습니다" /></td>
				</tr>
			</c:if>
	 		</tbody>
    	</table>
    </form>
    
    <c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<%--
			<a href="#" onclick="FN.doMemoCreate('FormData');" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
			<a href="#" onclick="FN.doCreateSms('FormData');" class="btn blue"><span class="mid"><spring:message code="버튼:SMS"/></span></a>
			<a href="#" onclick="FN.doCreateEmail('FormData');" class="btn blue"><span class="mid"><spring:message code="버튼:이메일"/></span></a>
			 --%>		
		</div>
	</div>
	
</body>
</html>