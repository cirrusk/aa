<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_DEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>
<c:set var="CD_COURSE_TYPE_ALWAYS"   value="${aoffn:code('CD.COURSE_TYPE.ALWAYS')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch = null;
var forListdata = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
	// [3] comment 설정
	UI.inputComment("FormSrch");
};

/**
 * 설정
 */
doInitializeLocal = function() {
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/apply/underachieve/list.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/course/apply/underachieve/list.do"/>";
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

/*
 * 쪽지발송완료
 */
doCreateMemoComplete = function(){
	forListdata.run();
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
	
	<c:set var="srchKey">memberName=<spring:message code="필드:학습부진자:이름"/>,memberId=<spring:message code="필드:학습부진자:아이디"/></c:set>
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox">
			<ul class="list-bullet"><!-- list-bullet --> 
			    <li><spring:message code="필드:학습부진자:진도율"/></li><input type="text" name="srchProgressMeasure" style="width: 50px;" value="<c:out value="${condition.srchProgressMeasure }" />" /> %<spring:message code="글:학습부진자:이하"/>
			    <li><spring:message code="필드:학습부진자:온라인결석"/></li><input type="text" name="srchOnlineAbsenceTypeCnt" style="width: 50px;" value="<c:out value="${condition.srchOnlineAbsenceTypeCnt }" />" /><spring:message code="글:학습부진자:회이상"/>
			    <li><spring:message code="필드:학습부진자:과제제출"/></li>
			    <select name="srchHomeworkSubmitTypeCd">
			    	<option value=""><spring:message code="필드:선택"/></option>
			    	<aof:code type="option" codeGroup="SUBMIT_TYPE" selected="${condition.srchHomeworkSubmitTypeCd }" removeCodePrefix="true" ref="1" />
			    </select>
			    <li><spring:message code="필드:학습부진자:퀴즈응시"/></li>
			    <select name="srchQuizSubmitTypeCd">
			    	<option value=""><spring:message code="필드:선택"/></option>
			    	<aof:code type="option" codeGroup="SUBMIT_TYPE" selected="${condition.srchQuizSubmitTypeCd }" removeCodePrefix="true" />
			    </select>
			    <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS }">
			    <div class="vspace"></div>
			    <li><spring:message code="필드:학습부진자:팀프로젝트"/></li>
			   	<select name="srchTeamprojectSubmitTypeCd">
			   		<option value=""><spring:message code="필드:선택"/></option>
			   		<aof:code type="option" codeGroup="SUBMIT_TYPE" selected="${condition.srchTeamprojectSubmitTypeCd }" removeCodePrefix="true" ref="1" />
			   	</select>
			    <li><spring:message code="필드:학습부진자:오프라인결석"/></li><input type="text" name="srchOfflineAbsenceTypeCnt" style="width: 50px;" value="<c:out value="${condition.srchOfflineAbsenceTypeCnt }" />" /><spring:message code="글:학습부진자:회이상"/>
			    </c:if>
			    <c:if test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
			    <li><spring:message code="필드:학습부진자:중간고사"/></li>
			    <select name="srchMidExamSubmitTypeCd">
			    	<option value=""><spring:message code="필드:선택"/></option>
			    	<aof:code type="option" codeGroup="SUBMIT_TYPE" selected="${condition.srchMidExamSubmitTypeCd }" removeCodePrefix="true" />
			    </select>
			    <li><spring:message code="필드:학습부진자:기말고사"/></li>
			    <select name="srchFinalExamSubmitTypeCd">
			    	<option value=""><spring:message code="필드:선택"/></option>
			    	<aof:code type="option" codeGroup="SUBMIT_TYPE" selected="${condition.srchFinalExamSubmitTypeCd }" removeCodePrefix="true" />
			    </select>
			    </c:if>
			    <c:if test="${param['shortcutCategoryTypeCd'] ne CD_CATEGORY_TYPE_DEGREE}">
			    <li><spring:message code="필드:학습부진자:시험"/></li>
			    <select name="srchExamSubmitTypeCd">
			    	<option value=""><spring:message code="필드:선택"/></option>
			    	<aof:code type="option" codeGroup="SUBMIT_TYPE" selected="${condition.srchExamSubmitTypeCd }" removeCodePrefix="true" />
			    </select>
			    </c:if>
			</ul> 
		</div>
		<div class="vspace"></div>
		<div class="lybox">
			<fieldset>
			<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
			<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
			<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
			<input type="hidden" name="shortcutCourseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
			<input type="hidden" name="shortcutCategoryTypeCd" value="${param['shortcutCategoryTypeCd']}"/>
			<input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
			<input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>"/>
			<span>
				<input type="text" name="srchCategoryName" value="${condition.srchCategoryName }" style="width:200px;" />
				<span class="comment"><spring:message code="필드:콘텐츠:분류명"/></span>
			</span>
			<div class="vspace"></div>
			<select name="srchKey" class="select">
				<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
			</select>
			<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);" />
			<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="shortcutCourseActiveSeq" value="${param['shortcutCourseActiveSeq']}"/>
	</form>
	
	<c:import url="/WEB-INF/view/include/perpage.jsp">
		<c:param name="onchange" value="doSearch"/>
		<c:param name="selected" value="${condition.perPage}"/>
	</c:import>
	
	<form name="FormData" id="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
		<colgroup>
			<col style="width: 40px" />
			<col style="width: 50px" />
			<col style="width: 100px" />
			<col style="width: 100px" />
			<col style="width: 120px" />
			
			<col style="width: 150px" />
			<col style="width: 150px" />
			<col style="width: 90px" />
			<col style="width: 90px" />
			<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS }">
			<col style="width: 90px" />
			</c:if>
			<c:if test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
			<col style="width: 90px" />
			<col style="width: 90px" />
			</c:if>
			<c:if test="${param['shortcutCategoryTypeCd'] ne CD_CATEGORY_TYPE_DEGREE}">
			<col style="width: 90px" />
			</c:if>
		</colgroup>
		<thead>
			<tr>
				<th><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton', 'checkButtonTop');" /></th>
				<th><spring:message code="필드:번호" /></th>
				<th><span class="sort" sortid="2"><spring:message code="필드:학습부진자:이름" /></span></th>
				<th><span class="sort" sortid="3"><spring:message code="필드:학습부진자:아이디" /></span></th>
				<th><span class="sort" sortid="4"><spring:message code="필드:학습부진자:학과" /></span></th>
				<th><span class="sort" sortid="6"><spring:message code="필드:학습부진자:진도율" /></span></th>
				<th><spring:message code="필드:학습부진자:온라인" /></th>
				<th><spring:message code="필드:학습부진자:과제" /></th>
				<th><spring:message code="필드:학습부진자:퀴즈" /></th>
				<c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS }">
				<th><spring:message code="필드:학습부진자:팀플" /></th>
				<th><spring:message code="필드:학습부진자:오프라인" /></th>
				</c:if>
				<c:if test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
				<th><spring:message code="필드:학습부진자:중간고사" /></th>
				<th><spring:message code="필드:학습부진자:기말고사" /></th>
				</c:if>
				<c:if test="${param['shortcutCategoryTypeCd'] ne CD_CATEGORY_TYPE_DEGREE}">
				<th><spring:message code="필드:학습부진자:시험" /></th>
				</c:if>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
					<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
					<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />">
					<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />">
				</td>
		        <td><c:out value="${paginate.descIndex - i.index}"/></td>
				<td><c:out value="${row.member.memberName}" /></td>
		        <td><c:out value="${row.member.memberId}"/></td>
		        <td><c:out value="${row.category.categoryName }" /></td>
		        <td><aof:number value="${row.element.totalProgressMeasure}" pattern="#,###.#"/>%</td>
		        <td><c:out value="${row.element.onlineAttendTypeCnt }" />/<c:out value="${row.element.onlineAttendCnt }" /></td>
		        <td><c:out value="${row.applyElement.homeworkCount }" />/<c:out value="${row.summary.activeHomeworkCount }" /></td>
		        <td><c:out value="${row.applyElement.quizCount }" />/<c:out value="${row.summary.activeQuizCount }" /></td>
		        <c:if test="${param['shortcutCourseTypeCd'] ne CD_COURSE_TYPE_ALWAYS }">
		        <td><c:out value="${row.applyElement.teamprojectCount }" />/<c:out value="${row.summary.activeTeamProjectCount }" /></td>
		        <td><c:out value="${row.element.offlineAttendTypeCnt }" />/<c:out value="${row.element.offlineAttendCnt }" /></td>
		        </c:if>
		        <c:if test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
		        <td>
		        	<c:choose>
		        		<c:when test="${row.apply.middleExamScore != 0 }">
		        			<c:out value="${row.apply.middleExamScore }" />	
		        		</c:when>
		        		<c:otherwise>
		        			-
		        		</c:otherwise>
		        	</c:choose>
		        </td>
		        <td>
		        	<c:choose>
		        		<c:when test="${row.apply.finalExamScore != 0 }">
		        			<c:out value="${row.apply.finalExamScore }" />	
		        		</c:when>
		        		<c:otherwise>
		        			-
		        		</c:otherwise>
		        	</c:choose>
		        </td>
		        </c:if>
		        <c:if test="${param['shortcutCategoryTypeCd'] ne CD_CATEGORY_TYPE_DEGREE}">
		        <td>
		        	<c:choose>
		        		<c:when test="${row.apply.examScore != 0 }">
		        			<c:out value="${row.apply.examScore }" />
		        		</c:when>
		        		<c:otherwise>
		        			-
		        		</c:otherwise>
		        	</c:choose>
		        </td>
		        </c:if>
			</tr>
		</c:forEach>
		<c:if test="${empty paginate.itemList}">
			<tr>
				<c:choose>
					<c:when test="${param['shortcutCategoryTypeCd'] eq CD_CATEGORY_TYPE_DEGREE}">
						<td colspan="13" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</c:when>
					<c:otherwise>
						<td colspan="12" align="center"><spring:message code="글:데이터가없습니다" /></td>
					</c:otherwise>
				</c:choose>
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
			<a href="javascript:void(0)" onclick="FN.doMemoCreate('FormData','doCreateMemoComplete')" class="btn blue">
               	<span class="mid"><spring:message code="버튼:쪽지" /></span>
               </a>
			<a href="javascript:void(0)" onclick="FN.doCreateSms('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:SMS" /></span>
			</a>
			<a href="javascript:void(0)" onclick="FN.doCreateEmail('FormData','doCreateMemoComplete')" class="btn blue">
				<span class="mid"><spring:message code="버튼:이메일" /></span>
			</a>
			 --%>
		</div>
	</div>
	
</body>
</html>