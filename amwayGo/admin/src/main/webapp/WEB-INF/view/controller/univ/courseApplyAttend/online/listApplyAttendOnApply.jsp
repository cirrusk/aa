<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="iframe">
<head>
<title></title>
<script type="text/javascript">
var forSearch            = null;
var forCalculation       = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
	
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/online/attend/result/apply/list/iframe.do"/>";
	
	forCalculation = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forCalculation.config.url             = "<c:url value="/univ/course/online/attend/result/calculation.do"/>";
	forCalculation.config.target          = "hiddenframe";
	forCalculation.config.message.confirm = "<spring:message code="글:출석결과:점수산출하시겠습니까"/>"; 
	forCalculation.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forCalculation.config.fn.complete     = doCompleteCalculation;
	
	forDetailLayer = $.action("layer");
	forDetailLayer.config.formId         = "FormBrowseMember";
	forDetailLayer.config.url            = "<c:url value="/univ/course/online/attend/result/apply/detail/popup.do"/>";
	forDetailLayer.config.options.width  = 900;
	forDetailLayer.config.options.height = 700;
	forDetailLayer.config.options.title  = "<spring:message code="필드:출석결과:학습결과전체"/>";
	forDetailLayer.config.options.callback  = doList;
	
};

/**
 * 점수산출
 */
doCalculation = function(){
	forCalculation.run();
};

/**
 * 점수산출 완료
 */
doCompleteCalculation = function(){
	$.alert({
		message : "<spring:message code="글:출석결과:점수산출이완료되었습니다"/>",
		button1 : {
			callback : function() {
				doList();
			}
		}
	});
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
	FN.doMemoCreate("FormData", doList);
};

</script>
</head>

<body>
	<aof:session key="currentRoleCfString" var="currentRoleCfString"/><!-- 권한 가져오기 -->

	<c:import url="srchApplyAttendOn.jsp"/>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: 50px" />
		<col style="width: 9%" />
		<col style="width: 9%" />
		<col style="width: 12%" />
        
		<col style="width: 10%" />
		<col style="width: 10%" />
		<col style="width: 10%" />
		<col style="width: 50px" />
		<col style="width: 50px" />
        
		<col style="width: 50px" />
		<col style="width: 8%" />
		<col/>
	</colgroup>
	<thead>
		<tr>
			<th rowspan="2"><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th rowspan="2"><spring:message code="필드:번호" /></th>
			<th rowspan="2"><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th rowspan="2"><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th rowspan="2"><span class="sort" sortid="3"><spring:message code="필드:멤버:학과" /></span></th>
			<th rowspan="2">
				<spring:message code="필드:출석결과:총학습횟수" />
				<div class="vspace"></div>
				(<spring:message code="필드:출석결과:회" />)
			</th>
			<th rowspan="2">
				<spring:message code="필드:출석결과:총학습시간" />
				<div class="vspace"></div>
				(<spring:message code="필드:출석결과:시분초" />)
			</th>
			<th rowspan="2">
				<spring:message code="필드:출석결과:평균진도율" />
				<div class="vspace"></div>
				(%)
			</th>
			<th colspan="3"><spring:message code="필드:출석결과:출결" /></th>
			<th rowspan="2">
				<spring:message code="필드:출석결과:출결점수" />
				<div class="vspace"></div>
				(<spring:message code="필드:출석결과:점" />)
			</th>
			<th rowspan="2"><spring:message code="필드:출석결과:상세" /></th>
		</tr>
		<tr>
			<th><spring:message code="필드:출석결과:출석" /></th>
			<th><spring:message code="필드:출석결과:지각" /></th>
			<th><spring:message code="필드:출석결과:결석" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
			<td>
				<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
				<input type="hidden" name="courseApplySeq" value="<c:out value="${row.applyAttend.courseApplySeq}" />">
				<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
				<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
				<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
			</td>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
	        <td><c:out value="${row.member.memberName}"/></td>
	        <td><c:out value="${row.member.memberId}"/></td>
	        <td><c:out value="${row.cate.categoryName}"/></td>
	        <td><c:out value="${row.applyAttend.attempt}"/></td>
	        <td>
	        	<c:choose>
					<c:when test="${0 < row.applyAttend.sessionTime}">
						<c:set var="hh" value="${aoffn:toInt(row.applyAttend.sessionTime / (60 * 60 * 1000))}"/>
						<c:set var="mm" value="${aoffn:toInt(row.applyAttend.sessionTime % (60 * 60 * 1000) / (60 * 1000))}"/>
						<c:set var="ss" value="${aoffn:toInt(row.applyAttend.sessionTime % (60 * 1000) / 1000 )}"/>
						<c:choose>
							<c:when test="${10 <= hh}">
								<c:out value="${hh}"/>:
							</c:when>
							<c:otherwise>
								0<c:out value="${hh}"/>:
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${10 <= mm}">
								<c:out value="${mm}"/>:
							</c:when>
							<c:otherwise>
								0<c:out value="${mm}"/>:
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${10 <= ss}">
								<c:out value="${ss}"/>
							</c:when>
							<c:otherwise>
								0<c:out value="${ss}"/>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						00:00:00
					</c:otherwise>
				</c:choose>
	        </td>
	        <td><aof:number value="${row.applyAttend.progressMeasure * 100}" pattern="#,###.#"/>%</td>
	        <td><c:out value="${row.applyAttend.attendTypeAttendCnt}"/></td>
	        <td><c:out value="${row.applyAttend.attendTypePerceptionCnt}"/></td>
	        <td><c:out value="${row.applyAttend.attendTypeAbsenceCnt}"/></td>
	        <td>
	        	<c:if test="${row.applyAttend.attendScore < 0}">
	        		0
	        	</c:if>
	        	<c:if test="${row.applyAttend.attendScore >= 0}">
	        		<c:out value="${row.applyAttend.attendScore}"/>
	        	</c:if>
	        </td>
	       <!--  <td></td> -->
	        <td>
	        	<a href="javascript:void(0)" onclick="doDetailLayer({'courseApplySeq' : '${row.applyAttend.courseApplySeq}','memberSeq' : '${row.member.memberSeq}', 'memberName' : '${row.member.memberName}'})" class="btn gray"><span class="small"><spring:message code="버튼:보기" /></span></a>
	        </td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="13" align="center"><spring:message code="글:데이터가없습니다" /></td>
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
			</c:if>
		</div>
	</div>
</body>
</html>