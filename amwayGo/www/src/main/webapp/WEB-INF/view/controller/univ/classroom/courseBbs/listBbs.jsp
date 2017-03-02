<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="classroom-layer">

<c:import url="/WEB-INF/view/include/session.jsp"/>
<c:choose>
	<c:when test="${boardType eq 'qna'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_QNA" scope="request"/>
	</c:when>
</c:choose>

<head>
<title><c:out value="${detailBoard.board.boardTitle}"/></title>
<script type="text/javascript">

var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;

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
	forSearch.config.url    = "<c:url value="/usr/classroom/course/bbs/${boardType}/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/usr/classroom/course/bbs/${boardType}/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/usr/classroom/course/bbs/${boardType}/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/usr/classroom/course/bbs/${boardType}/create.do"/>";

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
 * 검색조건 초기화
 */
doSearchReset = function() {
	FN.resetSearchForm(forSearch.config.formId);
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

/**
 * 등록화면을 호출하는 함수
 */
doCreate = function(mapPKs) {
	UT.getById(forCreate.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forCreate.config.formId);
	forCreate.run();
};

/**
 * 비밀글 조회 검사
 */
doDetailAccessCheck = function(param){

	var ssMemberSeq = "<c:out value="${ssMemberSeq}" />";
	var bbsRegMember = $("#regMember_" + param.bbsSeq).val();
	var parentRegMember = $("#regMember_" + param.prentSeq).val();
	
	if(bbsRegMember == ssMemberSeq || parentRegMember == ssMemberSeq){
		doDetail({'bbsSeq' : param.bbsSeq});
	}else{
		$.alert({
			message : "<spring:message code="글:게시판:비밀글은원글등록자또는게시글등록자만조회가가능합니다"/>"
		});
		return;
	}
	
};

/**
 * 이의신청기간 검사
 */
doCreateAppeal = function(){
	
	"<c:set var='dateformat' value='${aoffn:config(\"format.date\")}'/>";
	"<c:set var='today' value='${aoffn:today()}'/>";
	"<c:set var='appToday'><aof:date datetime='${today}' pattern='${aoffn:config(\"format.dbdatetime\")}'/></c:set>";

	var nowDate = "<c:out value="${appToday}"/>";
	var middleStartDtime = "<c:out value="${yearTerm.univYearTerm.middleExamUpdStartDtime}"/>";
	var middleEndDtime = "<c:out value="${yearTerm.univYearTerm.middleExamUpdEndDtime}"/>";
	var finalStartDtime = "<c:out value="${yearTerm.univYearTerm.finalExamUpdStartDtime}"/>";
	var finalEndDtime = "<c:out value="${yearTerm.univYearTerm.finalExamUpdEndDtime}"/>";
	
	if(middleStartDtime != null && "" !=  middleStartDtime 	&&
		middleEndDtime != null && "" !=  middleEndDtime 	&&	
		finalStartDtime != null && "" !=  finalStartDtime 	&&
		finalEndDtime != null && "" !=  finalEndDtime){
		if((middleStartDtime <= nowDate && middleEndDtime >= nowDate) || (finalStartDtime <= nowDate && finalStartDtime >= nowDate)){
			doCreate();
		}else{
			$.alert({
				message : "<spring:message code="글:게시판:성적이의신청기간이아닙니다"/>"
			});
			return;
		};
	}else{
		$.alert({
			message : "<spring:message code="글:게시판:성적이의신청기간이아닙니다"/>"
		});
		return;
	};
	
};

</script>
</head>

<body>

<c:choose>
	<c:when test="${empty detailBoard}"> <%-- 생성되지 않은 게시판 --%>
		<div class="lybox align-c">
			<spring:message code="글:게시판:생성되지않은게시판입니다" />
		</div>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${detailBoard.board.useYn ne 'Y'}"> <%-- 사용하지 않는 게시판 --%>
				<div class="lybox align-c">
					<spring:message code="글:게시판:사용하지않는게시판입니다" />
				</div>
			</c:when>
			<c:otherwise>
				
				<c:import url="srchBbs.jsp"/>
			
				<c:import url="/WEB-INF/view/include/perpage.jsp">
					<c:param name="onchange" value="doSearch"/>
					<c:param name="selected" value="${condition.perPage}"/>
				</c:import>
			
				<c:set var="flatModeYn" value="N"/>
				<c:if test="${condition.srchSearchYn eq 'Y'}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
				<c:if test="${!empty condition.orderby and condition.orderby ne 0}">
					<c:set var="flatModeYn" value="Y"/>
				</c:if>
			
				<form id="FormData" name="FormData" method="post" onsubmit="return false;">
				<table id="listTable" class="tbl-list">
				<colgroup>
					<col style="width: 50px" />
					<c:if test="${!empty codeGroupBbsType}">
						<col style="width: 90px" />
					</c:if>
					<col style="width: auto" />
					<col style="width: 80px" />
					<col style="width: 85px" />
					<col style="width: 60px" />
				</colgroup>
				<thead>
					<tr>
						<th><spring:message code="필드:번호" /></th>
						<c:if test="${!empty codeGroupBbsType}">
							<th><spring:message code="필드:게시판:구분" /></th>
						</c:if>
						<th><span class="sort" sortid="2"><spring:message code="필드:게시판:제목" /></span></th>
						<th><spring:message code="필드:등록자" /></th>
						<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
						<th><spring:message code="필드:게시판:조회수" /></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${alwaysTopList}" varStatus="i">
					<tr>
				        <td><spring:message code="필드:게시판:공지" /></td>
				        <c:if test="${!empty codeGroupBbsType}">
				        	<td><aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/></td>
				        </c:if>
						<td class="align-l">
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
							</c:if>
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
					</tr>
				</c:forEach>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
				        <td>
				        	<c:out value="${paginate.descIndex - i.index}"/>
				        	<input type="hidden" id="regMember_<c:out value="${row.bbs.bbsSeq}" />" value="<c:out value="${row.bbs.regMemberSeq}" />" />
				        </td>
				        <c:if test="${!empty codeGroupBbsType}">
					        <td>
					        	<c:if test="${row.bbs.groupLevel eq 1}">
					        		<aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/>
					        	</c:if>
					        </td>
				        </c:if>
				        <c:if test="${flatModeYn eq 'N'}">
							<c:set var="padding" value="${(row.bbs.groupLevel - 1) * 15}"/>
						</c:if>
						<td class="align-l" style="padding-left:<c:out value="${padding}"/>px;">
							<c:if test="${row.bbs.groupLevel gt 1}">
								re:
							</c:if>
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
								<a href="#" onclick="doDetailAccessCheck ({'bbsSeq' : '${row.bbs.bbsSeq}', 'prentSeq' : '${row.bbs.parentSeq}' });"><c:out value="${row.bbs.bbsTitle}" /></a>
							</c:if>
							<c:if test="${row.bbs.secretYn ne 'Y'}">
								<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							</c:if>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
					</tr>
				</c:forEach>
				<c:if test="${empty alwaysTopList and empty paginate.itemList}">
					<tr>
						<c:set var="colspan" value="5"/>
						<c:if test="${!empty codeGroupBbsType}">
							<c:set var="colspan" value="${colspan + 1}"/>
						</c:if>
						<td colspan="<c:out value="${colspan}"/>" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</table>
				</form>
			
				<c:import url="/WEB-INF/view/include/paging.jsp">
					<c:param name="paginate" value="paginate"/>
				</c:import>
			
				<div class="lybox-btn">
					<div class="lybox-btn-r">
						<c:choose>
							<c:when test="${boardType eq 'free' or boardType eq 'qna' or boardType eq 'one2one' or boardType eq 'dynamic'}">
								<a href="#" onclick="doCreate();" class="btn blue"><span class="mid"><spring:message code="버튼:등록" /></span></a>
							</c:when>
							<c:when test="${boardType eq 'appeal'}">
								<c:if test="${!empty yearTerm}">
									<a href="#" onclick="doCreateAppeal();" class="btn blue"><span class="mid"><spring:message code="버튼:등록" /></span></a>
								</c:if>
							</c:when>
						</c:choose>
					</div>
				</div>
			
			</c:otherwise>
		</c:choose>
	
	</c:otherwise>
</c:choose>

</body>
</html>