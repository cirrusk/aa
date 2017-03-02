<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_APPLY_STATUS_001"     value="${aoffn:code('CD.APPLY_STATUS.001')}"/>
<c:set var="CD_APPLY_STATUS_002"     value="${aoffn:code('CD.APPLY_STATUS.002')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch     		= null;
var forListdata   		= null;
var forDetailPopup		= null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
	UI.inputComment("FormSrch");
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/member/detail/course/apply/list/iframe.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/member/detail/course/apply/list/iframe.do"/>";
	
	forDetailPopup = $.action("layer", {formId : "FormDetail"});
	forDetailPopup.config.url = "<c:url value="/univ/course/apply/completion/popup.do"/>";
	forDetailPopup.config.options.width  = 700;
	forDetailPopup.config.options.height = 550;
	forDetailPopup.config.options.position = "middle";
	forDetailPopup.config.options.title  = "<spring:message code="글:성적관리:개인별세부성적"/>";
	
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
 * 성적 조회팝업
 */
 doDetailPopup = function(mapPKs) {
	if(mapPKs.type == "ING"){
		$.alert({
			message : "<spring:message code="글:수강:취득한성적정보가없습니다"/>"
		});
		return;
	} else {
		// 상세화면 form을 reset한다.
		UT.getById(forDetailPopup.config.formId).reset();
		// 상세화면 form에 키값을 셋팅한다.
		UT.copyValueMapToForm(mapPKs, forDetailPopup.config.formId);
		// 상세화면 실행
		forDetailPopup.run();	
	}
};

/**
 * 학습자 개설과목 강의실 이동 
 */
doMonitoring = function(courseActiveSeq, courseApplySeq) {
	// JSON형식으로 데이터를 넣으면 member.getExtendData(map)에 값이 담긴다. {"extendData" : [{"name":"observerYn", "value":"Y"},{"name":"memberSeq", "value":"2"}]}
	var extendData = '{"extendData" : [{"name":"observerYn", "value":"Y"}]}';
	document.getElementById("extendData").value = extendData;
	
	var action = $.action("ajax");
	action.config.formId      = "FormMemberLogin";
	action.config.url         = "<c:url value="/common/access/signature.do"/>";
	action.config.type        = "json";
	action.config.fn.complete = function(action, data) {
		if (data.signature !== "") {
			var action2 = $.action();
			action2.config.formId = "FormMemberLogin";
			action2.config.url    = "<c:out value="${aoffn:config('domain.www')}"/>" + "<c:url value="/security/login"/>";
			action2.config.target = "_blank";
			var form = UT.getById(action2.config.formId); 
			form.elements["j_username"].value = data.signature;
			form.elements["j_password"].value = data.password;
			form.elements["j_rolegroup"].value = "2";
			form.elements["courseActiveSeq"].value = courseActiveSeq;
			form.elements["courseApplySeq"].value = courseApplySeq;
			action2.run();
		}
	};
	action.run();
};


</script>
</head>

<body>

	<form name="FormMemberLogin" id="FormMemberLogin" method="post" onsubmit="return false;">
		<input type="hidden" name="j_username">
		<input type="hidden" name="j_password">
		<input type="hidden" name="j_rolegroup">
		<input type="hidden" name="j_extendData" id="extendData">
		<input type="hidden" name="courseActiveSeq">
		<input type="hidden" name="courseApplySeq">
		<input type="hidden" name="memberId" value="<c:out value="${param['memberId'] }" />">
	</form>
	
	<form id="FormDetail" name="FormDetail" method="post" onsubmit="return false;">
		<input type="hidden" name="courseApplySeq" />
		<input type="hidden" name="courseActiveSeq" />
	</form>
	
	<c:set var="srchKey">title=<spring:message code="필드:수강:교과목명"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset class="align-l">
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchMemberSeq"     value="<c:out value="${condition.srchMemberSeq}"/>" />
				<select name="srchKey" style="display: none;">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<span>
					<input type="text" name="srchCategoryName" value="<c:out value="${condition.srchCategoryName}"/>" style="width:300px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
					<span class="comment"><spring:message code="필드:수강:교과목분류"/></span>
				</span>
				<div class="vspace"></div>
				<span>
					<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:500px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
					<span class="comment"><spring:message code="필드:수강:교과목명"/></span>
				</span>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	<div class="vspace"></div>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
	</form>
	
	<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 50px" />
			<col style="width: auto" />
			<col style="width: 200px" />
			<col style="width: 100px" />
			<col style="width: 100px" />
			<col style="width: 100px" />
			<col style="width: 100px" />
			<!-- 
			<col style="width: 150px" />
			 -->
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:번호" /></th>
				<th><span class="sort" sortid="1"><spring:message code="필드:수강:교과목명" /></span></th>
				<th><span class="sort" sortid="2"><spring:message code="필드:수강:교과목분류" /></span></th>
				<th><spring:message code="필드:수강:담당교수" /></th>
				<th><spring:message code="필드:수강:학점수료여부" /></th>
				<th><spring:message code="필드:수강:성적총점" /></th>
				<th><spring:message code="필드:수강:세부성적" /></th>
				<!-- 
				<th><spring:message code="필드:수강:강의실" /></th>
				 -->
			</tr>
		</thead>
		<tbody>
		<c:set var="today"><aof:date datetime="${aoffn:today()}" pattern="${aoffn:config('format.dbdatetimeStart')}"/></c:set>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<td>
					<c:out value="${paginate.descIndex - i.index}"/>
		        </td>
		        <td><c:out value="${row.active.courseActiveTitle }" /></td>
		        <td><c:out value="${row.category.categoryString }" /></td>
		        <td><c:out value="${row.lecturer.profMemberName }" /></td>
		        <td>
		        	<c:choose>
		        		<c:when test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE }">
		        			<c:choose>
        						<c:when test="${row.active.studyStartDate <= today and row.active.studyEndDate >= today }">
									<spring:message code="글:수강:수강중" />		        						
        						</c:when>
        						<c:otherwise>
        							<c:out value="${row.apply.gradeLevelCd }" />
        						</c:otherwise>
        					</c:choose>
		        		</c:when>
		        		<c:otherwise>
		        			<c:choose>
		        				<c:when test="${row.apply.applyStatusCd eq CD_APPLY_STATUS_001 }">
		        					<spring:message code="글:수강:수강대기" />
		        				</c:when>
		        				<c:when test="${row.apply.applyStatusCd eq CD_APPLY_STATUS_002 }">
		        					<c:choose>
		        						<c:when test="${row.active.studyStartDate <= today and row.active.studyEndDate >= today }">
											<spring:message code="글:수강:수강중" />		        						
		        						</c:when>
		        						<c:otherwise>
		        							<aof:code type="print" codeGroup="COMPLETE_YN" selected="${row.apply.completionYn }" removeCodePrefix="true" />
		        						</c:otherwise>
		        					</c:choose>
		        				</c:when>
		        				<c:otherwise>
		        					<spring:message code="글:수강:수강취소" />
		        				</c:otherwise>
		        			</c:choose>
		        		</c:otherwise>
		        	</c:choose>
		        </td>
		        <td>
		        	<c:choose>
		        		<c:when test="${row.category.categoryTypeCd eq CD_CATEGORY_TYPE_DEGREE }">
		        			<c:choose>
				        		<c:when test="${empty row.apply.gradeLevelCd or row.apply.applyStatusCd ne CD_APPLY_STATUS_002 or (row.active.studyStartDate <= today and row.active.studyEndDate >= today) }">
				        			-
				        		</c:when>
				        		<c:otherwise>
				        			<c:out value="${row.apply.gradeLevelCd }" />
				        		</c:otherwise>
				        	</c:choose>
		        		</c:when>
		        		<c:otherwise>
		        			<c:choose>
				        		<c:when test="${row.apply.finalScore < 0 or row.apply.applyStatusCd ne CD_APPLY_STATUS_002 or (row.active.studyStartDate <= today and row.active.studyEndDate >= today) }">
				        			-
				        		</c:when>
				        		<c:otherwise>
				        			<c:out value="${row.apply.finalScore }" />
				        		</c:otherwise>
				        	</c:choose>
		        		</c:otherwise>
		        	</c:choose>
		        </td>
		        <td>
		        	<c:choose>
		        		<c:when test="${row.active.studyStartDate <= today and row.active.studyEndDate >= today }">
							<a href="javascript:void(0)" onclick="doDetailPopup({'type' : 'ING', 'courseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq }" />', 'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq }"/>'})" class="btn gray"><span class="mid"><spring:message code="버튼:수강:조회"/></span></a>		        		
		        		</c:when>
		        		<c:otherwise>
		        			<a href="javascript:void(0)" onclick="doDetailPopup({'type' : 'END', 'courseActiveSeq' : '<c:out value="${row.apply.courseActiveSeq }" />', 'courseApplySeq' : '<c:out value="${row.apply.courseApplySeq }"/>'})" class="btn black"><span class="mid"><spring:message code="버튼:수강:조회"/></span></a>
		        		</c:otherwise>
		        	</c:choose>
		        </td>
		        <!-- 
		        <td>
		        	<a href="javascript:void(0)" onclick="doMonitoring('<c:out value="${row.apply.courseActiveSeq }" />','<c:out value="${row.apply.courseApplySeq }" />')" class="btn black"><span class="mid"><spring:message code="버튼:수강:강의실이동"/></span></a>
		        </td>
		         -->
			</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
			<tr>
				<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
		</tbody>
	</table>
	
	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>

</body>
</html>