<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:set var="codeGroupBbsType" value="" scope="request"/>
<c:choose>
	<c:when test="${boardType eq 'notice'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_NOTICE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'resource'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_RESOURCE" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'qna'}">
		<c:set var="codeGroupBbsType" value="BBS_TYPE_QNA" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'one2one'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'free'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
	<c:when test="${boardType eq 'appeal'}">
		<c:set var="codeGroupBbsType" value="" scope="request"/>
	</c:when>
</c:choose>

<c:set var="exceptEvaluateBoardType" value="notice,resource,appeal,one2one" scope="request"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     = null;
var forListdata   = null;
var forDetail     = null;
var forCreate     = null;
var forEditBoard  = null;
var forUpdatelist = null;
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
	forSearch.config.url    = "<c:url value="/univ/course/bbs/${boardType}/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/bbs/${boardType}/list.do"/>";
	
	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/course/bbs/${boardType}/detail.do"/>";

	forCreate = $.action();
	forCreate.config.formId = "FormCreate";
	forCreate.config.url    = "<c:url value="/univ/course/bbs/${boardType}/create.do"/>";

	forEditBoard = $.action("layer");
	forEditBoard.config.formId = "FormEditBoard";
	forEditBoard.config.url    = "<c:url value="/univ/course/board/edit/popup.do"/>";
	forEditBoard.config.options.width = 400;
	forEditBoard.config.options.height = 420;
	forEditBoard.config.options.title = "<spring:message code="글:게시판:게시판설정"/>";

	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/univ/course/bbs/updatelist.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:적용하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;
	forUpdatelist.validator.set({
		message : "<spring:message code="글:게시판:변경된데이터가없습니다"/>",
		name : "checkkeys",
		data : ["!null"]
	});
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
 * 게시판설정화면을 호출하는 함수
 */
doEditBoard = function(mapPKs) {
	UT.getById(forEditBoard.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forEditBoard.config.formId);
	forEditBoard.run();
};
/**
 * 목록에서 수정할 때 호출되는 함수
 */
doUpdatelist = function() { 
	forUpdatelist.run();
};
/**
 * 목록삭제 완료
 */
doCompleteUpdatelist = function(success) {
	$.alert({
		message : "<spring:message code="글:X건의데이터가적용되었습니다"/>".format({0:success}),
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
};
/**
 * 평가대상여부 변경
 */
doChangeEvaluateYn = function(element) {
	var $element = jQuery(element);
	var $oldEvaluateYn = $element.siblings(":input[name='oldEvaluateYns']");
	var $checkkeys = $element.siblings(":input[name='checkkeys']");
	$checkkeys.attr("checked", $element.val() != $oldEvaluateYn.val());
};
</script>
</head>

<body>

<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
	<c:param name="suffix"><spring:message code="글:목록" /></c:param>
</c:import>
<c:import url="../include/commonCourseActive.jsp"></c:import>

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
					<c:if test="${boardType eq 'ask'}">
					<col style="width: 20px" />
					</c:if>
					<col style="width: 50px" />
					<%--
					<c:if test="${!empty codeGroupBbsType}">
						<col style="width: 90px" />
					</c:if>
					 --%>
					<col style="width: 250px;" />
					<col style="width: 80px" />
					<col style="width: 90px" />
					<col style="width: 60px" />
					<c:if test="${boardType eq 'ask'}">
					<col style="width: 120px" />
					</c:if>
					<%--
					<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
						<col style="width: 80px" />
					</c:if>
					 --%>
				</colgroup>
				<thead>
					<tr>
						<c:if test="${boardType eq 'ask'}">
						<th rowspan="2">
							<input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
						</c:if>
						<th><spring:message code="필드:번호" /></th>
						<%--
						<c:if test="${!empty codeGroupBbsType}">
							<th><span class="sort" sortid="3"><spring:message code="필드:게시판:구분" /></span></th>
						</c:if>
						 --%>
						<th><span class="sort" sortid="2"><spring:message code="필드:게시판:제목" /></span></th>
						<th><spring:message code="필드:등록자" /></th>
						<th><span class="sort" sortid="1"><spring:message code="필드:등록일" /></span></th>
						<th><spring:message code="필드:게시판:조회수" /></th>
						<c:if test="${boardType eq 'ask'}">
						<th>교강사 공개여부</th>
						</c:if>
						<%--<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
							<th><spring:message code="필드:게시판:평가대상" /></th>
						</c:if>
						 --%>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="row" items="${alwaysTopList}" varStatus="i">
					<tr>
				        <td><spring:message code="필드:게시판:공지" /></td>
<%-- 				        <c:if test="${!empty codeGroupBbsType}">
				        	<td><aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/></td>
				        </c:if> --%>
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
						<%--
						<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
							<td>&nbsp;</td>
						</c:if>
						 --%>
					</tr>
				</c:forEach>
				<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
					<tr>
						<c:if test="${boardType eq 'ask'}">
						<td>
							<c:if test="${row.bbs.profViewYn ne 'Y'}">
							<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
							</c:if>
							<input type="hidden" name="boardSeqs" value="<c:out value="${detailBoard.board.boardSeq}"/>">
                            <input type="hidden" name="bbsSeqs" value="<c:out value="${row.bbs.bbsSeq}"/>">	
							
						</td>
						</c:if>
				        <td><c:out value="${paginate.descIndex - i.index}"/></td>
				        <%--
				        <c:if test="${!empty codeGroupBbsType}">
					        <td>
					        	<c:if test="${row.bbs.groupLevel eq 1}">
					        		<aof:code type="print" codeGroup="${codeGroupBbsType}" selected="${row.bbs.bbsTypeCd}"/>
					        	</c:if>
					        </td>
				        </c:if>
				         --%>
				        <c:if test="${flatModeYn eq 'N'}">
							<c:set var="padding" value="${(row.bbs.groupLevel - 1) * 15}"/>
						</c:if>
						<td class="align-l" style="padding-left:<c:out value="${padding}"/>px;">
							<c:if test="${row.bbs.groupLevel gt 1}">
								re:
							</c:if>
							<c:if test="${row.bbs.secretYn eq 'Y'}">
								[<spring:message code="필드:게시판:비밀글" />]
							</c:if>
<%-- 							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});">
								<c:choose>
									<c:when test="${fn:length(row.bbs.description) > 50}">
										<c:out value="${fn:substring(row.bbs.description,0,50)}"/>....
									</c:when>
									<c:otherwise>
										<c:out value="${row.bbs.description}"/>
									</c:otherwise> 
								</c:choose>	
							</a> --%>
							<a href="#" onclick="doDetail({'bbsSeq' : '${row.bbs.bbsSeq}'});"><c:out value="${row.bbs.bbsTitle}" /></a>
							<c:if test="${row.bbs.attachCount gt 0}">
								<aof:img src="icon/ico_file.gif"/>
							</c:if>
						</td>
						<td><c:out value="${row.bbs.regMemberName}"/></td>
						<td><aof:date datetime="${row.bbs.regDtime}"/></td>
						<td><c:out value="${row.bbs.viewCount}"/></td>
						<c:if test="${boardType eq 'ask'}">
						<td><c:out value="${row.bbs.profViewYn}"/></td>
						</c:if>
						<%--
						<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
							<td>
								<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" style="display:none;">
								<input type="hidden" name="boardSeqs" value="<c:out value="${detailBoard.board.boardSeq}"/>">
                                <input type="hidden" name="bbsSeqs" value="<c:out value="${row.bbs.bbsSeq}"/>">
								<input type="hidden" name="oldEvaluateYns" value="<c:out value="${row.bbs.evaluateYn}"/>">
								<select name="evaluateYns" class="select" onchange="doChangeEvaluateYn(this)">
									<aof:code type="option" codeGroup="YESNO" selected="${row.bbs.evaluateYn}" removeCodePrefix="true"/>
								</select>
							</td>
						</c:if>
						 --%>
					</tr>
				</c:forEach>
				<c:if test="${empty alwaysTopList and empty paginate.itemList}">
					<tr>
						<c:set var="colspan" value="5"/>
						<c:if test="${boardType eq 'ask'}">
							<c:set var="colspan" value="${colspan + 2}"/>
						</c:if>
						<%--
						<c:if test="${!empty codeGroupBbsType}">
							<c:set var="colspan" value="${colspan + 1}"/>
						</c:if>
						 --%>
						<%--
						<c:if test="${aoffn:contains(exceptEvaluateBoardType, boardType, ',') eq false}">
							<c:set var="colspan" value="${colspan + 1}"/>
						</c:if>
						 --%>
						<td colspan="<c:out value="${colspan}"/>" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</tr>
				</c:if>
				</table>
				</form>
			
				<c:import url="/WEB-INF/view/include/paging.jsp">
					<c:param name="paginate" value="paginate"/>
				</c:import>
			
				<div class="lybox-btn">
					<%--
					<div class="lybox-btn-l">
						<a href="#" 
						   onclick="doEditBoard({'boardSeq' : '<c:out value="${detailBoard.board.boardSeq}"/>'})" 
						   class="btn blue"><span class="mid"><spring:message code="버튼:게시판:설정확인" /></span></a>
					</div>
					 --%>
					<div class="lybox-btn-r">
						<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
							<a href="#" onclick="doCreate()" class="btn blue"><span class="mid"><spring:message code="버튼:신규등록" /></span></a>
						</c:if>
						
						<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
							<a href="#" onclick="doUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:적용" /></span></a>
						</c:if>
						
					</div>
				</div>
			
			</c:otherwise>
		</c:choose>
	
	</c:otherwise>
</c:choose>


</body>
</html>