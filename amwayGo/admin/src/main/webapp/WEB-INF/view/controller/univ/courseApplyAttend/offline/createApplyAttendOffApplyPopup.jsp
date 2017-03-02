<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_ONOFF_TYPE_OFF"  value="${aoffn:code('CD.ONOFF_TYPE.OFF')}"/>
<c:set var="CD_ATTEND_TYPE_001" value="${aoffn:code('CD.ATTEND_TYPE.001')}"/>
<c:set var="CD_ATTEND_TYPE_002" value="${aoffn:code('CD.ATTEND_TYPE.002')}"/>
<c:set var="CD_ATTEND_TYPE_003" value="${aoffn:code('CD.ATTEND_TYPE.003')}"/>
<c:set var="CD_ATTEND_TYPE_004" value="${aoffn:code('CD.ATTEND_TYPE.004')}"/>
<c:set var="CD_ATTEND_TYPE_005" value="${aoffn:code('CD.ATTEND_TYPE.005')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearch       	= null;
var forUpdatelist       = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// [2] sorting 설정
	FN.doSortList("listTable", "<c:out value="${condition.orderby}"/>", "FormList", doSearch);
};
	
doInitializeLocal = function() {
	
	forSearch = $.action();
	forSearch.config.formId = "FormList";
	forSearch.config.url    = "<c:url value="/univ/course/active/offline/attend/result/regist/create/popup.do"/>";
	
	forUpdatelist = $.action("submit", {formId : "FormData"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdatelist.config.url             = "<c:url value="/univ/course/active/offline/attend/result/regist/update.do"/>";
	forUpdatelist.config.target          = "hiddenframe";
	forUpdatelist.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forUpdatelist.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdatelist.config.fn.complete     = doCompleteUpdatelist;

};

/**
 * 정렬및 출력개수 수정시 사용
 */
doSearch = function(rows) {
	forSearch.run();
}; 

/**
 * 출석저장
 */
doUpdatelist = function(){
	forUpdatelist.run();
};
 
/**
 * 닫기
 */
doCancel = function(){
 $layer.dialog("close");
}; 

/**
 * 등록완료후
 */
doCompleteUpdatelist = function(){
	$.alert({
		message : "<spring:message code="글:저장되었습니다"/>",
		button1 : {
			callback : function() {
				var par = $layer.dialog("option").parent;
				if (typeof par["<c:out value="${param['callback']}"/>"] === "function") {
					par["<c:out value="${param['callback']}"/>"].call(this);
				}
				$layer.dialog("close");
			}
		}
	});		
}; 

/**
 * 체크된 대상 상태값 일괄변경
 */
doChageAttendType = function(codeValue){
	$("#FormData input[name=checkkeys]").each(function(index) {
		if (this.checked == true) {
			$("#FormData input[name='attendTypeCdList["+index+"]']").each(function(subIndex) {
				if($("#FormData input[name='attendTypeCdList["+index+"]']").eq(subIndex).val() == codeValue){
					$("#FormData input[name='attendTypeCdList["+index+"]']").eq(subIndex).attr("checked",true);
				}		
			});
		}
	});
};

</script>
</head>

<body>

	<!-- 검색화면 -->
	<c:import url="srchApplyAttendOff.jsp"/>

	<form id="FormData" name="FormData" method="post" onsubmit="return false;">
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${condition.srchCourseActiveSeq}"/>"/>
	<input type="hidden" name="activeElementSeq" value="<c:out value="${condition.activeElementSeq}"/>"/>
	<input type="hidden" name="lessonSeq" value="<c:out value="${condition.lessonSeq}"/>"/>
	<input type="hidden" name="OnoffCd" value="<c:out value="${CD_ONOFF_TYPE_OFF}"/>"/>
	<input type="hidden" name="callback" value="doCreateAttendComplete"/>
	
	<div class="vspace"></div>
	
	<aof:code type="set" var="codeGroupAttendType" codeGroup="ATTEND_TYPE" except="${CD_ATTEND_TYPE_004}"/>

	<table id="listTable" class="tbl-list">
	<colgroup>
		<col style="width: 10px" />
		<col style="width: 20px" />
		<col style="width: 30px" />
		<col style="width: 30px" />
		<col style="width: 50px" />
		<c:forEach var="row" items="${codeGroupAttendType}" varStatus="i">
			<col style="width: 30px" />
		</c:forEach>
	</colgroup>
	<thead>
		<tr>
			<th rowspan="2"><input type="checkbox" name="checkall" onclick="FN.toggleCheckbox('FormData','checkkeys','checkButton','checkButtonTop');" /></th>
			<th rowspan="2"><spring:message code="필드:번호" /></th>
			<th rowspan="2"><span class="sort" sortid="1"><spring:message code="필드:멤버:이름" /></span></th>
			<th rowspan="2"><span class="sort" sortid="2"><spring:message code="필드:멤버:아이디" /></span></th>
			<th rowspan="2"><span class="sort" sortid="3"><spring:message code="필드:멤버:학과" /></span></th>
			<th colspan="<c:out value="${fn:length(codeGroupAttendType)}"/>"><spring:message code="필드:오프라인출석결과:출석정보" /></th>
		</tr>
		<tr>
			<c:forEach var="row" items="${codeGroupAttendType}" varStatus="i">
				<th><c:out value="${row.codeName}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="row" items="${itemList}" varStatus="i">
			<tr>
				<td>
					<input type="checkbox" name="checkkeys" value="<c:out value="${i.index}"/>" onclick="FN.onClickCheckbox(this, 'checkButton', 'checkButtonTop')">
					<input type="hidden" name="courseApplySeqs" value="<c:out value="${row.applyAttend.courseApplySeq}" />">
					<input type="hidden" name="memberSeqs" value="<c:out value="${row.member.memberSeq}" />">
					<input type="hidden" name="courseApplyAttendSeqs" value="<c:out value="${row.applyAttend.courseApplyAttendSeq}" />">
				</td>
				<td><c:out value="${i.index + 1}"/></td>
		        <td><c:out value="${row.member.memberName}"/></td>
		        <td><c:out value="${row.member.memberId}"/></td>
		        <td><c:out value="${row.cate.categoryName}"/></td>
				<c:forEach var="rowSub" items="${codeGroupAttendType}" varStatus="iSub">
					<td>
						<input type="radio" name="attendTypeCdList[<c:out value="${i.index}"/>]" value="<c:out value="${rowSub.code}"/>" <c:if test="${row.applyAttend.attendTypeCd eq rowSub.code}">checked</c:if> />
					</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-l">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doChageAttendType('<c:out value="${CD_ATTEND_TYPE_001}"/>');" class="btn blue"><span class="mid"><spring:message code="버튼:오프라인출석결과:출석" /></span></a>
				<a href="javascript:void(0)" onclick="doChageAttendType('<c:out value="${CD_ATTEND_TYPE_002}"/>');" class="btn blue"><span class="mid"><spring:message code="버튼:오프라인출석결과:지각" /></span></a>
				<a href="javascript:void(0)" onclick="doChageAttendType('<c:out value="${CD_ATTEND_TYPE_003}"/>');" class="btn blue"><span class="mid"><spring:message code="버튼:오프라인출석결과:결석" /></span></a>
				<a href="javascript:void(0)" onclick="doChageAttendType('<c:out value="${CD_ATTEND_TYPE_005}"/>');" class="btn blue"><span class="mid"><spring:message code="버튼:오프라인출석결과:공결" /></span></a>
			</c:if>
		</div>
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doUpdatelist()" class="btn blue"><span class="mid"><spring:message code="버튼:저장" /></span></a>
			</c:if>
			<a href="javascript:void(0)" onclick="doCancel()" class="btn blue"><span class="mid"><spring:message code="버튼:취소" /></span></a>
		</div>
	</div>
</body>
</html>