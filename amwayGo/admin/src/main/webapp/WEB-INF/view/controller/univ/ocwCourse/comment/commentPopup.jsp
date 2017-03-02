<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<c:import url="/WEB-INF/view/include/session.jsp"/>

<html>
<head>
<title></title>
<script type="text/javascript">
var forSearchComment   = null;
var forListdataComment = null;
var forEditComment     = null;
var forInsertComment   = null;
var forDeleteComment   = null;
var forUpdateAgreeComment = null;
var forUpdateDisagreeComment = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocalComment();

	doSearchComment();
};
/**
 * 설정
 */
doInitializeLocalComment = function() {

	forSearchComment = $.action("ajax");
	forSearchComment.config.formId      = "FormSrchComment";
	forSearchComment.config.type        = "html";
	forSearchComment.config.containerId = "boardComment";
	forSearchComment.config.url         = "<c:url value="/univ/ocw/course/comment/list/ajax.do"/>";
	forSearchComment.config.fn.complete = function() {};

	forListdataComment = $.action("ajax");
	forListdataComment.config.formId      = "FormListComment";
	forListdataComment.config.type        = "html";
	forListdataComment.config.containerId = "boardComment";
	forListdataComment.config.url         = "<c:url value="/univ/ocw/course/comment/list/ajax.do"/>";
	forListdataComment.config.fn.complete = function() {};
	
	forEditComment = $.action("layer");
	forEditComment.config.formId         = "FormEditComment";
	forEditComment.config.url            = "<c:url value="/univ/ocw/course/comment/edit/popup.do"/>";
	forEditComment.config.options.width  = 600;
	forEditComment.config.options.height = 270;
	forEditComment.config.options.title  = "<spring:message code="글:게시판:댓글수정"/>";
	
	forDeleteComment = $.action("submit");
	forDeleteComment.config.formId          = "FormDeleteComment"; 
	forDeleteComment.config.url             = "<c:url value="/univ/ocw/course/comment/delete.do"/>";
	forDeleteComment.config.target          = "hiddenframe";
	forDeleteComment.config.message.confirm = "<spring:message code="글:삭제하시겠습니까"/>"; 
	forDeleteComment.config.message.success = "<spring:message code="글:삭제되었습니다"/>";
	forDeleteComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forDeleteComment.config.fn.complete     = function() {
		doListComment();
	};

	forUpdateAgreeComment = $.action("submit");
	forUpdateAgreeComment.config.formId          = "FormUpdateComment"; 
	forUpdateAgreeComment.config.url             = "<c:url value="/univ/ocw/course/comment/agree/update.do"/>";
	forUpdateAgreeComment.config.target          = "hiddenframe";
	forUpdateAgreeComment.config.message.confirm = "<spring:message code="글:게시판:추천하시겠습니까"/>"; 
	forUpdateAgreeComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateAgreeComment.config.fn.complete     = doCompleteUpdateAgreeComment;

	forUpdateDisagreeComment = $.action("submit");
	forUpdateDisagreeComment.config.formId          = "FormUpdateComment"; 
	forUpdateDisagreeComment.config.url             = "<c:url value="/univ/ocw/course/comment/disagree/update.do"/>";
	forUpdateDisagreeComment.config.target          = "hiddenframe";
	forUpdateDisagreeComment.config.message.confirm = "<spring:message code="글:게시판:반대하시겠습니까"/>"; 
	forUpdateDisagreeComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateDisagreeComment.config.fn.complete     = doCompleteUpdateAgreeComment;
	
};
/**
 * 검색버튼을 클릭하였을 때 또는 목록갯수 셀렉트박스의 값을 변경 했을 때 호출되는 함수
 */
doSearchComment = function(rows) {
	var form = UT.getById(forSearchComment.config.formId);
	
	// 목록갯수 셀렉트박스의 값을 변경 했을 때
	if (rows != null && form.elements["perPage"] != null) {  
		form.elements["perPage"].value = rows;
	}
	forSearchComment.run();
};
/**
 * 목록페이지 이동. page navigator에서 호출되는 함수
 */
doPageComment = function(pageno) {
	var form = UT.getById(forListdataComment.config.formId);
	if(form.elements["currentPage"] != null && pageno != null) {
		form.elements["currentPage"].value = pageno;
	}
	doListComment();
};
/**
 * 목록보기 가져오기 실행.
 */
doListComment = function() {
	forListdataComment.run();
};
/**
 * 상세보기 화면을 호출하는 함수
 */
doEditComment = function(mapPKs) {
	UT.getById(forEditComment.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forEditComment.config.formId);
	forEditComment.run();
};
/**
 * 삭제
 */
doDeleteComment = function(mapPKs) {
	UT.getById(forDeleteComment.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forDeleteComment.config.formId);
	forDeleteComment.run();
};
/**
 * 추천
 */
doUpdateAgreeComment = function(mapPKs) {
	UT.getById(forUpdateAgreeComment.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forUpdateAgreeComment.config.formId);
	forUpdateAgreeComment.run();
};
/**
 * 반대
 */
doUpdateDisagreeComment = function(mapPKs) {
	UT.getById(forUpdateDisagreeComment.config.formId).reset();
	UT.copyValueMapToForm(mapPKs, forUpdateDisagreeComment.config.formId);
	forUpdateDisagreeComment.run();
};
/**
 * insert form 초기화
 */
 doInitializeComment = function() {
	forInsertComment = $.action("submit", {formId : "FormInsertComment"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forInsertComment.config.url      = "<c:url value="/univ/ocw/course/comment/insert.do"/>";
	forInsertComment.config.target          = "hiddenframe";
	forInsertComment.config.message.confirm = "<spring:message code="글:저장하시겠습니까"/>"; 
	forInsertComment.config.message.success = "<spring:message code="글:저장되었습니다"/>";
	forInsertComment.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forInsertComment.config.fn.complete     = function() {
		doListComment();
	};
	forInsertComment.validator.set({
		title : "<spring:message code="필드:게시판:내용"/>",
		name : "description",
		data : ["!null"]
	});

};
/**
 * 저장
 */
doInsertComment = function() {
	forInsertComment.run();
};
/**
 * 추천 반대 결과
 */
doCompleteUpdateAgreeComment = function(success) {
	forUpdateAgreeComment.waiting = false;
	forUpdateDisagreeComment.waiting = false;
	if (success == 9) {
		$.alert({
			message : "<spring:message code="글:게시판:이미참여하셨습니다"/>"
		});
	} else {
		doListComment();
	}
};
</script>
</head>
<body>
	<form name="FormSrchComment" id="FormSrchComment" method="post" onsubmit="return false;">
		<input type="hidden" name="currentPage"   value="0" />
		<input type="hidden" name="srchCommentTypeCd"    value="<c:out value="${param['srchCommentTypeCd']}"/>" />
		<input type="hidden" name="srchCourseActiveSeq"    value="<c:out value="${param['srchCourseActiveSeq']}"/>" />
		<input type="hidden" name="srchItemSeq"    value="<c:out value="${param['srchItemSeq']}"/>" />
	</form>
	
	<div id="boardComment"></div>
</body>
</html>

