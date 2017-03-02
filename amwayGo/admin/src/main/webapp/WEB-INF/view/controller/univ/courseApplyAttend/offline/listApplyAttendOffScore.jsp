<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch       = null;
var forDetail		= null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
	
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/active/offline/attend/result/Score/list/iframe.do"/>";

	forDetail = $.action("layer", {formId : "FormDetail"});
	forDetail.config.url            = "<c:url value="/univ/course/active/offline/attend/result/Score/detail/popup.do"/>";
	forDetail.config.options.width  = 800;
	forDetail.config.options.height = 600;
	forDetail.config.options.position = "middle";
	forDetail.config.options.title  = "<spring:message code="글:오프라인출석결과:오프라인수업출석현황"/>";

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
	forSearch.run();
}; 

doDetail = function(mapPKs){
	// 상세화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 상세화면 실행
	forDetail.run();
};

/*
 * 발송완료 후 목록재호출
 */
doCreateMemoComplete = function(){
	doList();
};

</script>
</head>

<body>
	
	<!-- 검색화면 -->
	<c:import url="srchApplyAttendOff.jsp"/>
		
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="callback" value="doCreateMemoComplete"/>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 10px" />
		<col style="width: 20px" />
		<col style="width: 30px" />
		<col style="width: 30px" />
		<col style="width: 50px" />
		<col style="width: 20px" />
		<col style="width: 20px" />
		<col style="width: 20px" />
		<col style="width: 20px" />
		<col style="width: 20px" />
		<col style="width: 20px" />
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th><span class="sort" sortid="3"><spring:message code="필드:멤버:학과" /></span></th>
			<th><spring:message code="필드:오프라인출석결과:출석" /></th>
			<th><spring:message code="필드:오프라인출석결과:지각" /></th>
			<th><spring:message code="필드:오프라인출석결과:결석" /></th>
			<th><spring:message code="필드:오프라인출석결과:공결" /></th>
			<th><spring:message code="필드:오프라인출석결과:점수" /></th>
			<th><spring:message code="필드:오프라인출석결과:상세" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
				<input type="hidden" name="courseApplySeq" value="<c:out value="${row.applyAttend.courseApplySeq}" />">
				<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
				<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
				<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
			</td>
	        <td><c:out value="${i.index + 1}"/></td>
	        <td><c:out value="${row.member.memberName}"/></td>
	        <td><c:out value="${row.member.memberId}"/></td>
	        <td><c:out value="${row.cate.categoryName}"/></td>
	        <td><c:out value="${row.applyAttend.attendTypeAttendCnt}"/></td>
	        <td><c:out value="${row.applyAttend.attendTypePerceptionCnt}"/></td>
	       	<td><c:out value="${row.applyAttend.attendTypeAbsenceCnt}"/></td>
	       	<td><c:out value="${row.applyAttend.attendTypeExcuseCnt}"/></td>
	        <td>
	        	<c:if test="${row.applyAttend.attendScore < 0}">
	        		0
	        	</c:if>
	        	<c:if test="${row.applyAttend.attendScore >= 0}">
	        		<c:out value="${row.applyAttend.attendScore}"/>
	        	</c:if>
	        </td>
			<td><a href="javascript:void(0)" onclick="doDetail({'courseApplySeq' : '${row.applyAttend.courseApplySeq}' ,
	       														'memberName' : '${row.member.memberName}' , 
																'memberId' : '${row.member.memberId}' ,
																'categoryName' : '${row.cate.categoryName}' ,
																'attendTypeAttendCnt' : '${row.applyAttend.attendTypeAttendCnt}' ,
																'attendTypeAbsenceCnt' : '${row.applyAttend.attendTypeAbsenceCnt}' ,
																'attendTypePerceptionCnt' : '${row.applyAttend.attendTypePerceptionCnt}' ,
																'attendTypeExcuseCnt' : '${row.applyAttend.attendTypeExcuseCnt}'});" class="btn black">
								<span class="small"><spring:message code="버튼:오프라인출석결과:보기" /></span>
							</a>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty itemList}">
		<tr>
			<td colspan="11" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
	</form>
		
	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<%--
				<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:쪽지" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:SMS" /></span></a>
				<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue"><span class="mid"><spring:message code="버튼:이메일" /></span></a>
				 --%>
			</c:if>
		</div>
	</div>

</body>
</html>