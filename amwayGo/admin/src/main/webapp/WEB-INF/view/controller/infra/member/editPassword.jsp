<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
var forUpdate = null;
var forUpdateInfo = null;
initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();
	
	// 학사데이터 여부
	<c:if test="${!empty detail.member.migLastTime}">
		$("#infoForm").show();
		$("#passwordForm").hide();
	</c:if>
};
/**
 * 설정
 */
doInitializeLocal = function() {
	
	forUpdate = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdate.config.url             = "<c:url value="/mypage/password/update.do"/>";
	forUpdate.config.target          = "hiddenframe";
	forUpdate.config.message.confirm = "<spring:message code="글:멤버:비밀번호를변경하시겠습니까"/>"; 
	forUpdate.config.message.waiting = "<spring:message code="글:멤버:비밀번호를변경처리중입니다"/>";
	forUpdate.config.fn.complete     = doCompleteUpdate;
	
	forUpdateInfo = $.action("submit", {formId : "FormUpdate"}); // validator를 사용하는 action은 formId를 생성시 setting한다
	forUpdateInfo.config.url             = "<c:url value="/member/user/update.do"/>";
	forUpdateInfo.config.target          = "hiddenframe";
	forUpdateInfo.config.message.confirm = "<spring:message code="글:변경하시겠습니까"/>"; 
	forUpdateInfo.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forUpdateInfo.config.fn.complete     = doCompleteUpdateInfo;
	
	setValidate();
	
};
setValidate = function() {
	forUpdate.validator.set({
		title : "<spring:message code="필드:멤버:비밀번호"/>",
		name : "password",
		data : ["!null", "!space"],
		check : {
			maxlength : 30,
			minlength : 6,
			regex :"(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}"
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
	form.elements["nowPassword"].value = "";
	form.elements["password"].value = "";
	form.elements["verifyPassword"].value = "";
};

/**
 * 수정완료
 */
doCompleteUpdate = function(success) {
	if(success > 0){
		$.alert({
			message : "<spring:message code="글:멤버:비밀번호가변경되었습니다"/>",
			button1 : {
				callback : function() {
					self.location.href = "<c:url value="${aoffn:config('system.startPage')}"/>";
				}
			}
		});		
	} else {
		$.alert({
			message : "<spring:message code="글:멤버:현재비밀번호가일치하지않습니다"/>",
			button1 : {
				callback : function() {
					
				}
			}
		});
	}
};

/**
 * 수정
 */
doUpdateInfo = function() { 
	var form = UT.getById(forUpdateInfo.config.formId);
	form.elements["updateType"].value = "modify";
	
	forUpdateInfo.run();
};

/**
 * 수정완료
 */
doCompleteUpdateInfo = function(success) {
	$.alert({
		message : "<spring:message code="글:변경되었습니다"/>",
		button1 : {
			callback : function() {
				self.location.href = "<c:url value="${aoffn:config('system.startPage')}"/>";
			}
		}
	});		
};
</script>
</head>
<body>	
	<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
		<input type="hidden" name="memberSeq" value="<c:out value="${member.memberSeq }" />" />
		<input type="hidden" name="updateType" />
<%-- 		
	<div class="section-password" id="infoForm" style="display: none;">
		<p class="description">회원님은 학사에서 정보를 제공 받고 있습니다.<br />비밀번호 변경은 학사시스템에서 수정하시기 바랍니다.</p>
		<div class="lybox-btn-c">
			<a href="javascript:void(0)" class="btn black"><span class="mid">학사시스템이동하기</span></a>
		</div>
	</div>
	<div id="passwordForm">
		<p class="content-notice">현재 비밀번호를 입력 한 후 새로 사용 할 비밀번호를 입력하시기 바랍니다.ex) abcd123!@</p>
		<div class="section-password">
			<dl>
				<dt><label for="now-pw"><spring:message code="필드:멤버:현재비밀번호" /></label></dt>
				<dd><input type="password" id="now-pw" name="nowPassword" maxlength="200" /></dd>
			</dl>
			<dl class="change-pw">
				<dt><label for="new-pw"><spring:message code="필드:멤버:새비밀번호" /></label></dt>
				<dd><input type="password" id="new-pw" name="password" maxlength="200" /></dd>
				<dt><label for="check-pw"><spring:message code="필드:멤버:새비밀번호확인" /></label></dt>
				<dd><input type="password" id="check-pw" name="verifyPassword" maxlength="200" /></dd>
			</dl>
			<div class="lybox-btn-c">
				<a href="javascript:void(0)" onclick="doUpdate()" class="btn black"><span class="mid"><spring:message code="버튼:확인" /></span></a>
				<a href="javascript:void(0)" onclick="doReset()" class="btn black"><span class="mid"><spring:message code="버튼:다시입력" /></span></a>
			<c:if test="${updateType eq 'modify' }">
				<a href="javascript:void(0)" onclick="doUpdateInfo()" class="btn black"><span class="mid"><spring:message code="버튼:멤버:3개월후변경" /></span></a>
			</c:if>
			</div>
		</div>
	</div> --%>
	</form>
</body>
</html>