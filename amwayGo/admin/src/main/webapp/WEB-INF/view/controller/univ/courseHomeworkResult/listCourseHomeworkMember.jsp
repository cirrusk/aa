<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>

<html decorator="iframe">
<head>
<title></title>
<script type="text/javascript">

var forSearch     = null;
var forListdata   = null;
var forUpdateList = null;
var forDetailResultPopup = null;
var forCollectiveFileResponse = null;

initPage = function() {

	doInitializeLocal();
	
	doIframeReSize();

	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);

};

/**
 * 설정
 */
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/homework/member/list.do"/>";
	
	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/homework/member/list.do"/>";
	
	forUpdateList = $.action("submit", {formId : "FormData"});
	forUpdateList.config.url             = "<c:url value="/univ/course/homework/member/update/list.do"/>";
	forUpdateList.config.target          = "hiddenframe";
	forUpdateList.config.message.confirm = "<spring:message code="글:과제응답:저장하시겠습니까"/>";
	forUpdateList.config.message.success = "<spring:message code="글:과제응답:저장되었습니다"/>";
	forUpdateList.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateList.config.fn.complete     = doSubmitSuccess;
	
	forDetailResultPopup = $.action("layer");
	forDetailResultPopup.config.formId         = "FormDetail";
	forDetailResultPopup.config.url            = "<c:url value="/univ/course/homework/member/detail/popup.do"/>";
	forDetailResultPopup.config.options.width  = 800;
	forDetailResultPopup.config.options.height = 600;
	forDetailResultPopup.config.options.title  = "<spring:message code="필드:과제응답:과제결과"/>";
	
	forCollectiveFileResponse = $.action();
	forCollectiveFileResponse.config.formId = "FormDetail";
	forCollectiveFileResponse.config.url    = "<c:url value="/univ/course/homework/result/collective/file/response.do"/>";
	
	setValidate();
	
};

/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	
	forUpdateList.validator.set({
        title : "<spring:message code="필드:과제:취득점수점"/>",
        name : "homeworkScores",
        data : ["!null","decimalnumber"],
        check : {
        	le : 100,
        	gt : -1
        }
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
 * 아이프레임 사이즈 조절
 */
doIframeReSize = function() {
	
	$(top.document).find("#memberIframe").css("height", $("body").prop("scrollHeight") + 20);

};

/**
 * 취득점수 저장
 */
doUpdateList = function() {
	
	forUpdateList.run();

};

/**
 * 취득점수 저장 콜백
 */
doSubmitSuccess = function() {
	
	doList();

};

/**
 * 과제결과 상세 팝업 호출
 */
doHomeWorkResultDetail = function(mapPKs) {
	
    UT.getById(forDetailResultPopup.config.formId).reset();
    UT.copyValueMapToForm(mapPKs, forDetailResultPopup.config.formId);
	forDetailResultPopup.run();

};

/**
 * 데이터 수정여부 표시
 */
doModifyData = function(type) {
	
	$("#modifyNotification").css("display","");
	
};

/**
 * 일괄 다운로드 실행.
 */
doCollectiveFile = function() {
	
	forCollectiveFileResponse.run();

};


</script>
</head>

<body>

<c:import url="srchCourseHomeworkMember.jsp"></c:import>
<c:import url="/WEB-INF/view/include/upload.jsp"></c:import>

<c:import url="/WEB-INF/view/include/perpage.jsp">
	<c:param name="onchange" value="doSearch"/>
	<c:param name="selected" value="${condition.perPage}"/>
</c:import>

<form id="FormData" name="FormData" method="post" onsubmit="return false;">
<input type="hidden" name="courseActiveSeq" 	value="<c:out value="${homework.courseActiveSeq}" />">
<input type="hidden" name="homeworkSeq" 		value="<c:out value="${homework.homeworkSeq}" />">
<input type="hidden" name="basicSupplementCd" 	value="<c:out value="${homework.basicSupplementCd}"/>"/>
<input type="hidden" name="middleFinalTypeCd" 	value="<c:out value="${homework.middleFinalTypeCd}"/>"/>
<input type="hidden" name="replaceYn" 			value="<c:out value="${homework.replaceYn}"/>"/>
<input type="hidden" name="rate2" 				value="<c:out value="${homework.rate2}"/>"/>
<input type="hidden" name="profMemberSeq"		value="<c:out value="${appCourseActiveLecturer.profMemberSeq}"/>"/>
<input type="hidden" name="activeElementSeq"	value="<c:out value="${homework.activeElementSeq}"/>"/>
	<table id="listTable" class="tbl-list">
	    <colgroup>
	        <col style="width: 3%" />
	        <col style="width: 4%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 10%" />
	        <col style="width: 7%" />
	        <col style="width: 6%" />		        
	    </colgroup>
	    <thead>
			<tr>
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton');" /></th>
				<th><spring:message code="필드:번호" /></th>
				<th><span class="sort" sortid="1"><spring:message code="필드:과제:이름" /></th>
				<th><span class="sort" sortid="2"><spring:message code="필드:과제:아이디" /></th>
				<th><span class="sort" sortid="3"><spring:message code="필드:과제:학과" /></th>
				<th><span class="sort" sortid="4"><spring:message code="필드:과제응답:제출일" /></th>
				<th><span class="sort" sortid="5"><spring:message code="필드:과제응답:제출차수" /></th>
				<th><span class="sort" sortid="6"><spring:message code="필드:과제:취득점수점" /></th>
				<th><span class="sort" sortid="7"><spring:message code="필드:과제:환산점수점" /></th>
				<th><span class="sort" sortid="8"><spring:message code="필드:과제응답:채점일" /></th>
				<th><spring:message code="필드:과제:첨부파일" /></th>
				<th><spring:message code="필드:과제:상세" /></th>
			</tr>
		</thead>
		<tbody>		
			<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" 		value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton')">
					<input type="hidden" name="memberSeqs" 			value="<c:out value="${row.member.memberSeq}"/>" />
					<input type="hidden" name="memberNames" 		value="<c:out value="${row.member.memberName}"/>" />
					<input type="hidden" name="phoneMobiles" 		value="<c:out value="${row.member.phoneMobile}"/>" />
					<c:if test="${!empty row.answer.sendDtime}">
						<input type="hidden" name="homeworkAnswerSeqs" value="<c:out value="${row.answer.homeworkAnswerSeq}" />">	
						<input type="hidden" name="courseApplySeqs" value="<c:out value="${row.apply.courseApplySeq}" />">
						<input type="hidden" name="sendDtimes" value="<c:out value="${row.answer.sendDtime}" />">
						<input type="hidden" name="openYns" value="<c:out value="${homework.openYn}" />">
					</c:if>
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
				<td>
					<c:choose>
						<c:when test="${!empty row.answer.sendDtime}">
							<aof:date datetime="${row.answer.sendDtime}" pattern="${aoffn:config('format.dateTime')}"/>
						</c:when>
						<c:otherwise>
							<spring:message code="필드:과제응답:미제출" />
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${!empty row.answer.sendDtime}">
							<span><c:out value="${row.answer.sendDegree}"/>차</span>
						</c:when>
						<c:otherwise>
							<spring:message code="필드:과제응답:미제출" />
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${!empty row.answer.scoreDtime && !empty row.answer.sendDtime}">
							<input type="hidden" name="oldHomeworkScores" 				value="<c:out value="${row.answer.homeworkScore}"/>"/>
							<input type="text" name="homeworkScores" size="6" style="text-align: center;" value="${row.answer.homeworkScore}" onchange="javascript:doModifyData();" />
						</c:when>
						<c:when test="${empty row.answer.scoreDtime && !empty row.answer.sendDtime}">
							<input type="hidden" name="oldHomeworkScores" 				value="<c:out value="${row.answer.homeworkScore}"/>"/>
							<input type="text" name="homeworkScores" size="6" style="text-align: center;" value="0" onchange="javascript:doModifyData();" />
						</c:when>						
						<c:otherwise>
							<input type="text" name="homeworkScores" size="6" style="text-align: center;" value="0" disabled="disabled" />
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:out value="${row.answer.scaledScore}"/>
				</td>
				<td>
					<c:choose>
						<c:when test="${!empty row.answer.scoreDtime and !empty row.answer.sendDtime}">
							<aof:date datetime="${row.answer.scoreDtime}" pattern="${aoffn:config('format.date')}"/>
						</c:when>
						<c:when test="${!empty row.answer.scoreDtime and empty row.answer.sendDtime}">
							<aof:date datetime="${row.answer.scoreDtime}" pattern="${aoffn:config('format.date')}"/>
						</c:when>						
						<c:when test="${empty row.answer.scoreDtime and !empty row.answer.sendDtime}">
							<spring:message code="필드:과제응답:채점중" />
						</c:when>
						<c:otherwise>
							<spring:message code="필드:과제응답:미제출" />
						</c:otherwise>
					</c:choose>
				</td>
				<td>	
					<c:if test="${!empty row.answer.unviAttachList}">
						<c:forEach var="rowAttach" items="${row.answer.unviAttachList}" varStatus="i">
							<a class="btn black" href="javascript:void(0)" onclick="FN.doAttachDownload('<c:out value="${aoffn:encryptSecure(rowAttach.attachSeq, pageContext.request)}"/>', '${row.member.memberId}_${row.member.memberName}_${rowAttach.realName}')">
								<span class="small"><spring:message code="버튼:과제:다운" /></span>
							</a>
						</c:forEach>
					</c:if>
				</td>
				<td>
				<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
					<c:if test="${row.answer.homeworkAnswerSeq gt 0}">
						<a href="#" onclick="javascript:doHomeWorkResultDetail({ 'courseApplySeq' : '${row.apply.courseApplySeq}', 'homeworkSeq' : '${homework.homeworkSeq}' });" class="btn black">
          					<span class="small"><spring:message code="버튼:과제응답:보기" /></span>
   						</a>
					</c:if>
				</c:if>
				<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
					<c:if test="${row.answer.homeworkAnswerSeq == 0}">
						<a href="#" onclick="javascript:doHomeWorkResultDetail({ 'courseApplySeq' : '${row.apply.courseApplySeq}', 'homeworkSeq' : '${homework.homeworkSeq}' });" class="btn black">
          					<span class="small"><spring:message code="버튼:과제응답:보기" /></span>
   						</a>
					</c:if>
				</c:if>
				</td>																							
			</tr>
			</c:forEach>
			<c:if test="${empty paginate.itemList}">
				<tr>
					<td colspan="12" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
		<span id="modifyNotification" style="display: none; color: red;"><spring:message code="글:과제:저장되지않은데이터가존재합니다" /></span>
		<a href="#" onclick="doCollectiveFile();" class="btn blue"><span class="mid"><spring:message code="버튼:과제:일괄다운로드" /></span></a>		
		<%--
		<a href="#" onclick="FN.doMemoCreate('FormData');" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
		<a href="#" onclick="FN.doCreateSms('FormData');" class="btn blue"><span class="mid"><spring:message code="버튼:SMS"/></span></a>
		<a href="#" onclick="FN.doCreateEmail('FormData');" class="btn blue"><span class="mid"><spring:message code="버튼:이메일"/></span></a>
		 --%>		
		<c:if test="${!empty paginate.itemList and aoffn:accessible(appCurrentMenu.rolegroupMenu, 'U')}">
			<a href="#" onclick="javascript:doUpdateList();" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
		</c:if>
	</div>
</div>
	
</body>
</html>