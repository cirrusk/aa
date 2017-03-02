<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html>
<head>
<title></title>
<script type="text/javascript">
var action = null;
var forJoin     = null;

initPage = function() {
	// [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
	doInitializeLocal();

};
/**
 * 설정
 */
doInitializeLocal = function() {
	
};

setValidate = function() {
	if (!UT.getById("check1").checked){
		$.alert({message : "<spring:message code="글:로그인:이용약관및개인정보처리방침에동의해주세요"/>"});
		return false;
	}
	if (!UT.getById("check2").checked){
		$.alert({message : "<spring:message code="글:로그인:개인정보수집및이용에대한안내에동의해주세요"/>"});
		return false;
	}
	return true;
};

/**
 * 정보등록페이지 이동
 */
doJoin = function() {
	forJoin = $.action();
	forJoin.config.url = "<c:url value="/member/create/popup.do"/>";
	if (setValidate()){
		forJoin.run();			
	}
};

</script>
</head>
<body>
	
<div class="lybox"><spring:message code="글:로그인:이용약관"/></div>
<input type="checkbox"  id="check1" />

<div class="lybox"><spring:message code="글:로그인:개인정보수집"/></div>
<input type="checkbox"  id="check2" />

<div class="lybox-btn-r">
	<a href="javascript:void(0);" onclick="doJoin();" class="btn blue"><span class="mid"><spring:message code="버튼:멤버:회원가입"/></span></a>
</div>	
</body>
</html>