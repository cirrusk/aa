<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/usr/member/password/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:멤버:비밀번호를변경하시겠습니까"/>"; 
	forUpdate.config.message.success = "<spring:message code="글:멤버:비밀번호가변경되었습니다"/>";
	forUpdate.config.message.waiting = "<spring:message code="글:멤버:비밀번호를변경처리중입니다"/>";
	forUpdate.config.fn.complete     = doCompleteInsert;
	
	setValidate();
	
};
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:비밀번호"/>",
		name : "password",
		data : ["!null", "!space"],
		check : {
			maxlength : 30,
			minlength : 6
		}
	});
	forUpdate.validator.set({
		message : "<spring:message code="글:멤버:비밀번호가일치하지않습니다"/>",
		name : "password",
		check : {
			eq : {name : "verifyPassword", title : ""}
		}
	});

};
/**
 * 수정
 */
doUpdate = function() { 
	forUpdate.run();
};

/**
 * 비밀번호 리셋
 */
doReset = function() {
	var form = UT.getById(forUpdate.config.formId);
	form.elements["password"].value = "";
	form.elements["verifyPassword"].value = "";
};

/*
 * 등록 완료시 부모 iframe 새로고침
 */
doCompleteInsert  = function(){
	$layer.dialog("close");	
};


</script>
</head>
<body>	
	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="memberSeq" value="<c:out value="${member.memberSeq }" />" />
		
		<h3 class="content-title"><spring:message code="글:멤버:비밀번호변경" /></h3>
		<p class="content-notice"><spring:message code="글:멤버:새로사용할비밀번호를입력하시기바랍니다" /></p>
		<div class="section-password">
			<dl>
				<dt><label for="new-pw"><spring:message code="필드:멤버:새비밀번호" /></label></dt>
				<dd><input type="password" name="password" maxlength="200"></dd>
				<dt><label for="check-pw"><spring:message code="필드:멤버:새비밀번호확인" /></label></dt>
				<dd><input type="password" name="verifyPassword" maxlength="200"></dd>
			</dl>
			<div class="lybox-btn-c">
				<a href="#" onclick="doUpdate()" class="btn black"><span class="mid"><spring:message code="버튼:확인" /></span></a>
				<a href="#" onclick="doReset()" class="btn black"><span class="mid"><spring:message code="버튼:다시입력" /></span></a>
			</div>
		</div>
	</form>
</body>
</html>