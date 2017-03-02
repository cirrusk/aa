<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="iframe">
<head>
<title></title>
<script type="text/javascript">
var forSearch            = null;
var forBbsListdata       = null;
var forUpdateTakeScore		 = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
	
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/discuss/result/apply/list/iframe.do"/>";
	
	forBbsListdata = $.action();
	forBbsListdata.config.formId = "FormBbsList";
	forBbsListdata.config.url    = "<c:url value="/univ/course/discuss/result/bbs/list/iframe.do"/>";
	
	forUpdateTakeScore = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdateTakeScore.config.url             = "<c:url value="/univ/course/discuss/result/apply/list/takescore/update.do"/>";
	forUpdateTakeScore.config.target          = "hiddenframe";
    forUpdateTakeScore.config.message.confirm = "<spring:message code="글:토론:채점하시겠습니까"/>"; 
    forUpdateTakeScore.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
    forUpdateTakeScore.config.fn.complete     = doCompleteUpdateTakeScore;
    forUpdateTakeScore.validator.set({
        title : "<spring:message code="글:토론:채점할데이터"/>",
        name : "checkkeys",
        data : ["!null"]
    });
};

/**
 * 채점 요청
 */
doUpdateTakeScore = function() {
	forUpdateTakeScore.run();
};

/**
 * 채점 완료후
 */
 doCompleteUpdateTakeScore = function(success) {
    $.alert({
        message : "<spring:message code="글:과제:X건의학습자가채점되었습니다"/>".format({0:success}),
        button1 : {
            callback : function() {
                doList();
            }
        }
    });
};

/**
 * 게시글 리스트
 */
doBbsListdata = function(){
	forCalculation.run();
};

/**
 * 대상자 정보 필터링 검색결과 출력
 */
 doBbsListdata = function(mapPKs) {
	UT.getById(forBbsListdata.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forBbsListdata.config.formId);
	forBbsListdata.run();
};
 
 /**
  * 목록보기 가져오기 실행.
  */
 doList = function() {
	 forSearch.run();
 };
 
 /**
  * 정렬및 출력개수 수정시 사용
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
 	var form = UT.getById(forSearch.config.formId);
 	if(form.elements["currentPage"] != null && pageno != null) {
 		form.elements["currentPage"].value = pageno;
 	}
 	doList();
 };
 
doDetailLayer = function(mapPKs) {
	// 학습결과(전체)화면 form을 reset한다.
	UT.getById(forDetailLayer.config.formId).reset();
	// 학습결과(전체)화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetailLayer.config.formId);
	// 학습결과(전체)화면 실행
	forDetailLayer.run();
};

doMemoCreate = function(){
	alert("sdfsdfs");
	FN.doMemoCreate("FormData", doList);
};

</script>
</head>

<body>
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->

	<c:import url="srchDiscussApply.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="${condition.courseActiveSeq}"/>
	<input type="hidden" name="activeElementSeq" value="${condition.activeElementSeq}"/>
	<input type="hidden" name="discussSeq" value="${condition.discussSeq}"/>
	<input type="hidden" name="courseTypeCd" value="${condition.courseTypeCd}"/>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: 15%" />
		<col style="width: 15%" />
		<col style="width: auto" />
		<col style="width: 9%" />
		<col style="width: 10%" />
		<col style="width: 10%" />
		<col style="width: 10%" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:멤버:학과" /></span></th>
			<th><spring:message code="필드:토론:평가" /> / <spring:message code="필드:토론:게시" /></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:토론:취득점수" /></span></th>
			<th><span class="sort" sortid="5"><spring:message code="필드:토론:채점일" /></span></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
				<input type="hidden" name="courseApplySeqs" value="<c:out value="${row.discuss.courseApplySeq}" />">
				<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
				<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
				<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
				<input type="hidden" name="startDtimes" value="<c:out value="${row.discuss.startDtime}" />">
				<input type="hidden" name="endDtimes" value="<c:out value="${row.discuss.endDtime}" />">
			</td>
			<td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td><c:out value="${row.member.memberName}"/></td>
		    <td><c:out value="${row.member.memberId}"/></td>
		    <td><c:out value="${row.cate.categoryName}"/></td>
		    <td><a href="#" onclick="doBbsListdata({'srchRegMemberSeq' : '${row.member.memberSeq}'});"><c:out value="${row.discuss.evaluateCount}"/> / <c:out value="${row.discuss.bbsMemberCount}"/></a></td>
		    <td><c:out value="${row.applyElement.takeScore}"/></td>
		    <td><aof:date datetime="${row.applyElement.scoreDtime}"/></td>
	    </tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="8" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<%--
				<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일" /></span></a>
				 --%>
				<a href="javascript:void(0)" onclick="doUpdateTakeScore();" class="btn blue"><span class="mid"><spring:message code="버튼:토론:채점하기" /></span></a>
			</c:if>
		</div>
	</div>
</body>
</html>