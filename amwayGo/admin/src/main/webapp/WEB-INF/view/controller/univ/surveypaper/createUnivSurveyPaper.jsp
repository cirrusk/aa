<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_SURVEY_PAPER_TYPE_GENERAL" value="${aoffn:code('CD.SURVEY_PAPER_TYPE.GENERAL')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forListdata = null;
var forInsert   = null;
var forDetail = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {

	forListdata = $.action();
	forListdata.config.formId = "FormList";
	forListdata.config.url    = "<c:url value="/univ/surveypaper/list.do"/>";
	
	forInsert = $.action("submit", {formId : "FormInsert"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsert.config.url             = "<c:url value="/univ/surveypaper/insert.do"/>";
	forInsert.config.target          = "hiddenframe";
	forInsert.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsert.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsert.config.fn.complete     = doCompleteInsert;

	forDetail = $.action();
	forDetail.config.formId = "FormDetail";
	forDetail.config.url    = "<c:url value="/univ/surveypaper/detail.do"/>";
	
	setValidate();
};
/**
 * 데이터 유효성 검사
 */
setValidate = function() {
	forInsert.validator.set({
		title : "<spring:message code="필드:설문:설문지구분"/>",
		name : "surveyPaperTypeCd",
		data : ["!null","trim"]
	});
	forInsert.validator.set({
		title : "<spring:message code="필드:설문:설문지제목" />",
		name : "surveyPaperTitle",
		data : ["!null","trim"],
		check : {
			maxlength : 200
		}
	});
};
/**
 * 저장
 */
doInsert = function() { 
	forInsert.run();
};
/**
 * 저장완료
 */
 doCompleteInsert = function(result) {
	result = result.replaceAll("&#034;", '"');
	result = jQuery.parseJSON(result);
	if (result.success == 1) {
		$.alert({
			message : "<spring:message code="글:저장되었습니다"/>",
			button1 : {
				callback : function() {
					doDetail({'surveyPaperSeq' : result.surveyPaperSeq});
				}
			}
		});
	} else {
		$.alert({
			message : "<spring:message code="글:저장되지않았습니다"/>"
		});
	}
};
/**
 * 목록보기
 */
doList = function() {
	forListdata.run();
};
/**
 * 수정화면을 호출하는 함수
 */
doDetail = function(mapPKs) {
	// 수정화면 form을 reset한다.
	UT.getById(forDetail.config.formId).reset();
	// 수정화면 form에 키값을 셋팅한다.
	UT.copyValueMapToForm(mapPKs, forDetail.config.formId);
	// 수정화면 실행
	forDetail.run();
};
</script>
</head>

<body>

	<c:import url="/WEB-INF/view/include/breadcrumb.jsp">
		<c:param name="suffix"><spring:message code="글:신규등록" /></c:param>
	</c:import>

	<div style="display:none;">
		<c:import url="srchUnivSurveyPaper.jsp"/>
	</div>

	<form id="FormInsert" name="FormInsert" method="post" onsubmit="return false;">
	<table class="tbl-detail">
	<colgroup>
		<col style="width: 100px" />
		<col/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:설문:설문지구분"/></th>
			<td>
				<select name="surveyPaperTypeCd">
					<aof:code type="option" codeGroup="SURVEY_PAPER_TYPE" defaultSelected="${CD_SURVEY_PAPER_TYPE_GENERAL}" />
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문지제목" /></th>
			<td>
				<input type="text" name="surveyPaperTitle" style="width:65%;">
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:설문:설문지설명"/></th>
			<td><textarea name="description" style="width:90%;height:30px;"></textarea></td>
		</tr>
	</tbody>
	</table>
	</form>

	<div class="lybox-btn">
		<div class="lybox-btn-r">
			<c:if test="${aoffn:accessible(appCurrentMenu.rolegroupMenu, 'C')}">
				<a href="javascript:void(0)" onclick="doInsert();" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
			</c:if>
			<a href="#" onclick="doList();" class="btn blue"><span class="mid"><spring:message code="버튼:취소"/></span></a>
		</div>
	</div>

</body>
</html>