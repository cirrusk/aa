<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ATTEND_TYPE_001" value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002" value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003" value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>
<c:set var="CD_ATTEND_TYPE_005" value="${aoffn:code('CD.ATTEND_TYPE.005')}"/>

<c:set var="rowSpanCount" value="3" />
<c:choose>
	<c:when test="${empty listElement}">
		<c:set var="rowSpanCount" value="1" />
	</c:when>
	<c:otherwise>
		<c:if test="${empty applyMember}">
			<c:set var="rowSpanCount" value="2" />
		</c:if>
	</c:otherwise>	
</c:choose>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch       = null;
var forCreateAttend = null;
var forExcelDown  	= null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
};
	
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/course/active/offline/attend/result/regist/list/iframe.do"/>";
	
	forCreateAttend = $.action("layer", {formId : "FormCreate"});
	forCreateAttend.config.url = "<c:url value="/univ/course/active/offline/attend/result/regist/create/popup.do"/>";
	forCreateAttend.config.options.width  = 800;
	forCreateAttend.config.options.height = 600;
	forCreateAttend.config.options.position = "middle";
	forCreateAttend.config.options.title  = "<spring:message code="버튼:오프라인출석결과:출석부입력"/>";
		
	forExcelDown = $.action();
	forExcelDown.config.formId = "FormSrch";
	forExcelDown.config.target = "hiddenframe";
	forExcelDown.config.url    = "<c:url value="/univ/course/active/offline/attend/result/regist/excel.do"/>";
	
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

/**
 * 셀렉트박스로 검색변경
 */
doSelect = function(selectValue){
	var form = UT.getById(forSearch.config.formId);
	form.elements["sortOrder"].value = selectValue.value;
	forSearch.run();
};

/**
 * 주차 회별 출석설정팝업
 */
doCreate = function(mapPKs){
	// 상세화면 form을 reset한다.
	UT.getById(forCreateAttend.config.formId).reset();
	// 상세화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forCreateAttend.config.formId);
	// 상세화면 실행
	forCreateAttend.run();
};

/**
 * 엑셀다운로드
 */
doExcelDown = function(){
	forExcelDown.run();
};

/**
 * 발송완료 후 목록재호출
 */
doCreateMemoComplete = function(){
	doList();
};

/*
 * 출석정보 등록완료 후 목록재호출
 */
doCreateAttendComplete = function(){
	doList();
};

</script>
</head>

<body>
	
	<!-- 검색화면 -->
	<c:import url="srchApplyAttendOff.jsp"/>
		
	<div class="align-r">
		<select name="srchSortElement" class="select" onchange="doSelect(this);">
			<option value="3" <c:if test="${sortOrderNum eq 3}">selected</c:if>> 1 ~ 3 주차</option>
			<option value="6" <c:if test="${sortOrderNum eq 6}">selected</c:if>>4 ~ 6 주차</option>
			<option value="9" <c:if test="${sortOrderNum eq 9}">selected</c:if>>7 ~ 9 주차</option>
			<option value="12" <c:if test="${sortOrderNum eq 12}">selected</c:if>>10 ~ 12 주차</option>
			<option value="15" <c:if test="${sortOrderNum eq 15}">selected</c:if>>13 ~ 15 주차</option>
		</select>
	</div>
	
	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="${condition.srchCourseActiveSeq}"/>
	<input type="hidden" name="callback" value="doCreateMemoComplete"/>
	
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 25px" />
		<col style="width: 50px" />
		<col style="width: 100px" />
		<col style="width: 100px" />
		<col style="width: 150px" />
		<c:if test="${!empty listElement }">
			<c:forEach var="row" items="${listElement}" varStatus="i">
				<c:set var="subNum" value="${row.element.offlineLessonCount}"></c:set>
					<c:forEach begin="1" end="${subNum}" step="1" varStatus="j">
						<col style="width: 6%" />
					</c:forEach>
			</c:forEach>
		</c:if>
		<c:if test="${empty listElement }">
			<c:forEach begin="1" end="3" step="1" varStatus="j">
				<col style="width: 12%" />
			</c:forEach>
		</c:if>
	</colgroup>
	<thead>
		<tr>
			<th rowspan="${rowSpanCount}"><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th rowspan="${rowSpanCount}"><spring:message code="필드:번호" /></th>
			<th rowspan="${rowSpanCount}"><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th rowspan="${rowSpanCount}"><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th rowspan="${rowSpanCount}"><span class="sort" sortid="3"><spring:message code="필드:멤버:학과" /></span></th>
			<c:if test="${!empty listElement }">
				<c:forEach var="row" items="${listElement}" varStatus="i">
				<c:set var="subNum" value="${row.element.offlineLessonCount}"></c:set>
					<th colspan="${subNum}">
						<c:out value="${row.element.sortOrder}"/><spring:message code="글:오프라인출석결과:주" />
					</th>
				</c:forEach>
			</c:if>
			<c:if test="${empty listElement }">
			<c:set var="startOrder" value="${sortOrderNum - 3}"></c:set>
				<c:forEach begin="1" end="3" step="1" varStatus="i">
					<th rowspan="${rowSpanCount}">
						<c:out value="${startOrder + i.index}"/><spring:message code="글:오프라인출석결과:주" />
					</th>
				</c:forEach>				
			</c:if>
		</tr>
		<c:if test="${!empty listElement }">
			<tr>
				<c:forEach var="row" items="${listElement}" varStatus="i">
					<c:set var="subNum" value="${row.element.offlineLessonCount}"></c:set>
					<c:forEach begin="1" end="${subNum}" step="1" varStatus="j">
						<th>
							<c:out value="${j.index}"/><spring:message code="글:오프라인출석결과:회" />
						</th> 
					</c:forEach>
				</c:forEach>
			</tr>
			<c:if test="${!empty applyMember}" >
				<tr>
					<c:forEach var="row" items="${listElement}" varStatus="i">
						<c:set var="subNum" value="${row.element.offlineLessonCount}"></c:set>
						<c:forEach begin="1" end="${subNum}" step="1" varStatus="j">
							<th>
								<input type="hidden" name="activeElementSeq" value="${row.element.activeElementSeq}" />
								<input type="hidden" name="lessonSeq" value="${j.index}" />
								<a href="javascript:void(0)" onclick="doCreate({'activeElementSeq' : '<c:out value="${row.element.activeElementSeq}" />' ,
																					   'lessonSeq' : '<c:out value="${j.index}" />'});" class="btn blue">
									<span class="mid"><spring:message code="버튼:오프라인출석결과:설정" /></span>
								</a>							
							</th> 
						</c:forEach>
					</c:forEach>
				</tr>
			</c:if>
		</c:if>
	</thead>
	<tbody>
	<c:if test="${!empty listElement}" >
		<c:forEach var="row" items="${applyMember}" varStatus="i">
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')" />
					<input type="hidden" name="courseApplySeq" value="<c:out value="${row.applyAttend.courseApplySeq}" />" />
					<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />" />
					<input type="hidden" name="memberNames" value="<c:out value="${row.member.memberName}" />" />
					<input type="hidden" name="phoneMobiles" value="<c:out value="${row.member.phoneMobile}" />" />
				</td>
		        <td><c:out value="${i.index + 1}"/></td>
		        <td><c:out value="${row.member.memberName}"/></td>
		        <td><c:out value="${row.member.memberId}"/></td>
		        <td><c:out value="${row.cate.categoryName}"/></td>
		       <!-- 출석 데이터영역 시작 -->	        
		       <c:forEach var="subrow" items="${listElement}" varStatus="i">
					<c:set var="subNum" value="${subrow.element.offlineLessonCount}"></c:set>
					<c:forEach begin="1" end="${subNum}" step="1" varStatus="j">
						<td>
						<!-- 주차별, 회수별, 수강생별 출석정보셋팅 -->
						<c:set var="offlineLessonKey"  value="${subrow.element.activeElementSeq}_${j.index}_${row.applyAttend.courseApplySeq}"/>
							<c:choose>
								<c:when test="${applyAttendHash[offlineLessonKey] eq CD_ATTEND_TYPE_001}">
									<aof:img src="icon/attend.png" align="absmiddle" alt="필드:오프라인출석결과:출석" />
								</c:when>
								<c:when test="${applyAttendHash[offlineLessonKey] eq CD_ATTEND_TYPE_002}">
									<aof:img src="icon/absence.png" align="absmiddle" alt="필드:오프라인출석결과:결석"/>
								</c:when>
								<c:when test="${applyAttendHash[offlineLessonKey] eq CD_ATTEND_TYPE_003}">
									<aof:img src="icon/perception.png" align="absmiddle" alt="필드:오프라인출석결과:지각"/>
								</c:when>
								<c:when test="${applyAttendHash[offlineLessonKey] eq CD_ATTEND_TYPE_005}">
									<aof:img src="icon/excuse.png" align="absmiddle" alt="필드:오프라인출석결과:공결"/>
								</c:when>
								<c:otherwise>
									-
								</c:otherwise>
							</c:choose>
							<input type="hidden" name="activeElementSeq" value="${subrow.element.activeElementSeq}" />
							<input type="hidden" name="lessonSeq" value="${j.index}" />
							<input type="hidden" name="courseApplySeq" value="${row.applyAttend.courseApplySeq}" />
						</td> 
					</c:forEach>
				</c:forEach>
				<!-- 출석 데이터영역 끝 -->	        
			</tr>
		</c:forEach>
		<c:if test="${empty applyMember}">
			<c:set var="subNum" value="5" />
			<c:forEach var="row" items="${listElement}" varStatus="i">
				<c:choose>
					<c:when test="${empty row.element.offlineLessonCount}" >
						<c:set var="subNum" value="${subNum + 1}" />
					</c:when>
					<c:otherwise>
						<c:set var="subNum" value="${subNum + row.element.offlineLessonCount}" />
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<tr>
				<td colspan="${subNum}" align="center"><spring:message code="글:데이터가없습니다" /></td>
			</tr>
		</c:if>
	</c:if>
	<c:if test="${empty listElement}">
		<tr>
			<td colspan="8" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</tbody>
	</table>
	</form>
	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<aof:img src="icon/attend.png" align="absmiddle" alt="필드:오프라인출석결과:출석"/> : <spring:message code="필드:오프라인출석결과:출석" />&nbsp;&nbsp;
			<aof:img src="icon/absence.png" align="absmiddle" alt="필드:오프라인출석결과:결석"/> : <spring:message code="필드:오프라인출석결과:결석" />&nbsp;&nbsp;
			<aof:img src="icon/perception.png" align="absmiddle" alt="필드:오프라인출석결과:지각"/> : <spring:message code="필드:오프라인출석결과:지각" />&nbsp;&nbsp;
			<aof:img src="icon/excuse.png" align="absmiddle" alt="필드:오프라인출석결과:공결"/> : <spring:message code="필드:오프라인출석결과:공결" />
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doExcelDown()" class="btn blue"><span class="mid"><spring:message code="버튼:오프라인출석결과:출석부출력" /></span></a>
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