<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_ON"             value="${aoffn:code('CD.ONOFF_TYPE.ON')}"/>
<c:set var="CD_ONOFF_TYPE_OFF"            value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>
<c:set var="CD_ACTIVE_LECTURER_TYPE_PROF" value="${aoffn:code('CD.ACTIVE_LECTURER_TYPE.PROF')}"/>


<aof:code type="set" var="profTypeCode" codeGroup="PROF_TYPE"/>
<aof:session key="currentRoleCfString" var="currentRoleCfString"/>

<html>
<head>
<title></title>
<script type="text/javascript">
<%-- 공통코드 --%>
var CD_ACTIVE_LECTURER_TYPE_PROF = "<c:out value="${CD_ACTIVE_LECTURER_TYPE_PROF}"/>";

var forSearch     		= null;
var forListdata   		= null;
var forExamPaperPopup 	= null;
var profTypeCd = {};
<c:forEach var="row" items="${profTypeCode}" varStatus="i">
profTypeCd["<c:out value="${row.code}"/>"] = "<c:out value="${row.codeName}"/>";
</c:forEach>
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormSrch", doSearch);
	
	UI.inputComment("FormSrch");
	doAutoProfComplete();
};
/**
 * 설정
 */
doInitializeLocal = function() {

	forSearch = $.action();
	forSearch.config.formId = "FormSrch";
	forSearch.config.url    = "<c:url value="/univ/exampaper/list/popup.do"/>";

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/exampaper/list/popup.do"/>";
	
	forExamPaperPopup = $.action("layer");
	forExamPaperPopup.config.formId = "FormExamPaper";
	forExamPaperPopup.config.url    = "<c:url value="/univ/exampaper/preview/popup.do"/>";
	forExamPaperPopup.config.options.width  = 750;
	forExamPaperPopup.config.options.height = 600;
	
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
 * 선택
 */
doSelect = function(index) {
	var returnValue = null;
	var form = UT.getById("FormData");
	if (form.elements["examPaperSeq"].length){
	returnValue = {
		code : '<c:out value="${condition.srchExamPaperTypeCd}"/>',
		examPaperSeq : form.elements["examPaperSeq"][index].value,
		examPaperTitle : form.elements["examPaperTitle"][index].value
		};
	} else {
	returnValue = {
		code : '<c:out value="${condition.srchExamPaperTypeCd}"/>',
		examPaperSeq : form.elements["examPaperSeq"].value,
		examPaperTitle : form.elements["examPaperTitle"].value
		};
	}
	var par = $layer.dialog("option").parent;
	if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
		par["<c:out value="${param['callback']}"/>"].call(this, returnValue);
	}
	$layer.dialog("close");
	
};
/**
 * 자동완성 검색
 */
doAutoProfComplete = function() {
	
	var form = UT.getById(forSearch.config.formId);
	UI.autoCompleteByEnter(form.elements["srchProfMemberNamePrint"], function(response, value) { // source callback
		var param = [];
		param.push("srchWord=" + value);
		param.push("srchCourseActiveSeq=" + form.elements["srchCourseActiveSeq"].value);
		param.push("srchActiveLecturerType=" + CD_ACTIVE_LECTURER_TYPE_PROF);

		var action = $.action("ajax");
		action.config.type        = "json";
		action.config.url         = "<c:url value="/member/prof/like/name/list/json.do"/>";
		action.config.parameters  = param.join("&");
		action.config.fn.complete = function(action, data) {
			if (data != null && data.list != null) {
				var items = [];
				for (var i = 0, len = data.list.length; i < len; i++) {
					var member = data.list[i];
					var label = member.memberName;
					label += (member.profTypeCd != "" ? " - " + profTypeCd[member.profTypeCd] : "");
					label += (member.categoryName != "" ? " - " + categoryName : "");
					items.push({
						"name" : member.memberName,
						"label" : label,
						"value" : member.memberSeq
					});
				}
				response(items);
			};
		};
		action.run();
	}, function(item) { // select callback
		form.elements["srchProfMemberName"].value = item.name;
		form.elements["srchProfMemberNamePrint"].value = item.name;
		<c:if test="${currentRoleCfString eq 'PROF'}">
			form.elements["srchProfSessionMemberSeq"].value = item.value;
		</c:if>
		<c:if test="${currentRoleCfString ne 'PROF'}">
			form.elements["srchProfMemberSeq"].value = item.value;
		</c:if>
		jQuery("#profComment").hide();
	});		
};
/**
 * 교수명 검색조건에 변경이 일어났을시에 값을 모두 초기화 시킨다.
 */
removeSrchProf = function(){
	var form = UT.getById(forSearch.config.formId);
	form.elements["srchProfMemberName"].value = "";
	form.elements["srchProfMemberSeq"].value = "";
};
/**
 * 시험지 미리보기
 */
doPreviewExamPaper = function(mapPKs) {
	// 상세화면 form을 reset한다.
    UT.getById(forExamPaperPopup.config.formId).reset();
    // 상세화면 form에 키값을 셋팅한다.
    UT.copyValueMapToForm(mapPKs, forExamPaperPopup.config.formId);
    // 상세화면 실행
    forExamPaperPopup.run();
} 
</script>
</head>

<body>
	<form name="FormExamPaper" id="FormExamPaper" method="post" onsubmit="return false;">
		<input type="hidden" name="examPaperSeq" />
	</form>
	<c:set var="srchKey">title=<spring:message code="필드:시험:시험지제목"/>,description=<spring:message code="필드:시험:시험지설명"/></c:set>
	
	<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
		<div class="lybox search">
			<fieldset>
				<input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
				<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
				<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
				<input type="hidden" name="srchExamPaperTypeCd"   value="<c:out value="${condition.srchExamPaperTypeCd}"/>" />
				<input type="hidden" name="callback"   value="<c:out value="${param['callback']}"/>"/>
				<input type="hidden" name="popupFirstYn" value="N" />
				
				<spring:message code="필드:시험:교수명"/> : 
					<c:if test="${currentRoleCfString ne 'ADM'}">
						<input type="hidden" name="srchProfSessionMemberSeq" value="${condition.srchProfSessionMemberSeq}" />
						<input type="text" name="srchProfMemberName" value="${condition.srchProfMemberName}" readonly="readonly">&nbsp;
					</c:if>
					<c:if test="${currentRoleCfString eq 'ADM'}">
						<span>
							<input type="hidden" name="srchProfMemberSeq" value="${condition.srchProfMemberSeq}" />
							<input type="hidden" name="srchProfMemberName" value="${condition.srchProfMemberName}">
							<input type="text" id="srchProfMemberNamePrint" name="srchProfMemberNamePrint" style="width:220px;" value="<c:out value="${condition.srchProfMemberName}"/>" onchange="removeSrchProf()">
							<div class="comment" id="profComment"><spring:message code="글:시험:교수명을입력하십시오"/></div>&nbsp;
						</span>
					</c:if>
				<spring:message code="필드:시험:교과목명"/> : 
					<input type="hidden" name="srchCourseMasterSeq" value="${condition.srchCourseMasterSeq}" />
					<input type="hidden" name="srchCourseActiveSeq" value="${condition.srchCourseActiveSeq}" />
					<input type="text" name="srchCourseTitle" value="${condition.srchCourseTitle}" readonly="readonly" onkeyup="UT.callFunctionByEnter(event, doSearch);">
				<div class="vspace"></div>
				
				<select name="srchKey">
					<aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
				</select>
				<input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
				<a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /></span></a>
			</fieldset>
		</div>
	</form>
	
	<div class="vspace"></div>
	
	<form name="FormList" id="FormList" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage" value="<c:out value="${condition.currentPage}"/>" />
		<input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
		<input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
		<input type="hidden" name="srchKey"     value="<c:out value="${condition.srchKey}"/>" />
		<input type="hidden" name="srchWord"    value="<c:out value="${condition.srchWord}"/>" />
		<input type="hidden" name="srchOnOffCd"        value="<c:out value="${condition.srchOnOffCd}"/>" />
		<input type="hidden" name="callback"   value="<c:out value="${param['callback']}"/>"/>
		<input type="hidden" name="srchExamPaperTypeCd"   value="<c:out value="${condition.srchExamPaperTypeCd}"/>" />
		<input type="hidden" name="srchCourseMasterSeq"   value="<c:out value="${condition.srchCourseMasterSeq}"/>" />
		<input type="hidden" name="srchProfMemberSeq" 	value="<c:out value="${condition.srchProfMemberSeq}"/>" />
		<input type="hidden" name="srchProfSessionMemberSeq" value="${condition.srchProfSessionMemberSeq}" />
		<input type="hidden" name="popupFirstYn" value="N" />
	</form>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 40px" />
		<col style="width: auto" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th><spring:message code="필드:번호" /></th>
			<th><span class="sort" sortid="2"><spring:message code="필드:시험:시험지제목" /></span></th>
			<th><spring:message code="필드:시험:문항수" /></th>
			<th><spring:message code="필드:시험:공개여부" /></th>
			<th><spring:message code="필드:등록자" /></th>
			<th><span class="sort" sortid="4"><spring:message code="필드:등록일" /></span></th>
			<th><spring:message code="필드:시험:매핑" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="row" items="${paginate.itemList}" varStatus="i">
		<tr>
	        <td><c:out value="${paginate.descIndex - i.index}"/></td>
			<td class="align-l">
				<c:choose>
					<c:when test="${row.courseExamPaper.onOffCd eq CD_ONOFF_TYPE_ON}">
						<c:choose>
							<c:when test="${row.courseExamPaper.randomYn eq 'N'}">
								<a href="javascript:void(0)" onclick="doPreviewExamPaper({'examPaperSeq' : '<c:out value="${row.courseExamPaper.examPaperSeq}"/>'});"><c:out value="${row.courseExamPaper.examPaperTitle}" /></a>
							</c:when>
							<c:otherwise>
								<c:out value="${row.courseExamPaper.examPaperTitle}" />
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${row.courseExamPaper.onOffCd eq CD_ONOFF_TYPE_OFF}">
						<c:out value="${row.courseExamPaper.examPaperTitle}" />
					</c:when>
				</c:choose>
			</td>
			<td>
				<c:out value="${row.courseExamPaper.examCount}" /><spring:message code="필드:시험:문항" />
			</td>
			<td>
				<aof:code type="print" codeGroup="OPEN_YN" removeCodePrefix="true" selected="${row.courseExamPaper.openYn}"></aof:code>
			</td>
			<td>
				<c:out value="${row.courseExamPaper.regMemberName}" />
			</td>
			<td>
				<aof:date datetime="${row.courseExamPaper.regDtime}"/>
			</td>
			<td>
				<input type="hidden" name="examPaperSeq" value="<c:out value="${row.courseExamPaper.examPaperSeq}" />">
				<input type="hidden" name="examPaperTitle" value="<c:out value="${row.courseExamPaper.examPaperTitle}" />">
				<a href="javascript:void(0)" onclick="doSelect(<c:out value="${i.index}"/>);" class="btn gray"><span class="small"><spring:message code="필드:선택" /></span></a>
			</td>
		</tr>
	</c:forEach>
	<c:if test="${empty paginate.itemList}">
		<tr>
			<td colspan="7" align="center"><spring:message code="글:데이터가없습니다" /></td>
		</tr>
	</c:if>
	</table>
	</form>

	<c:import url="/WEB-INF/view/include/paging.jsp">
		<c:param name="paginate" value="paginate"/>
	</c:import>
	
</body>
</html>