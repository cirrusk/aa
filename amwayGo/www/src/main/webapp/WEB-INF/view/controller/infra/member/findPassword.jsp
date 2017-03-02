<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html decorator="yodaLayer">
<head>
<title></title>
<script type="text/javascript">
var forSendEmail = null;

initPage = function() {
    // [1] 현재 페이지에서 실행할 action의 config 정보를 설정한다.
    doInitializeLocal();
    
};
/**
 * 설정
 */
doInitializeLocal = function() {
	forSendEmail = $.action("ajax", {formId : "FormFindPassword"});
	forSendEmail.config.type   = "json";
	forSendEmail.config.url    = "<c:url value="/member/find/password/sendmail.do"/>";
	forSendEmail.config.message.confirm = "<spring:message code="글:로그인:해당메일로발송하시겠습니까"/>";
	forSendEmail.config.message.waiting = "<spring:message code="글:처리중입니다"/>";
	forSendEmail.config.fn.complete     = function(action, data) {
		if (data != null) {
			if (data.success == true) {
	            $.alert({
	                message : "<spring:message code="글:로그인:메일이정상적으로발송되었습니다"/>",
	                button1 : {
	                    callback : function() {
	                        doClose();
	                    }
	                }
	            });
			} else {
				if (data.found == false) {
		            $.alert({
		                message : "<spring:message code="글:로그인:해당EMAIL가존재하지않습니다"/>",
		                button1 : {
		                    callback : function() {
		                        doClose();
		                    }
		                }
		            });
				} else {
		            $.alert({
		                message : "<spring:message code="글:로그인:메일이발송되지않았습니다"/>",
		                button1 : {
		                    callback : function() {
		                        doClose();
		                    }
		                }
		            });
				}
			}
		}
	};
	setValidate();
};
setValidate = function() {
	forSendEmail.validator.set({
        title : "E-Mail ID",
        name : "email",
        data : ["!null", "!space", "email"]
    });
};
doFind = function() {
	forSendEmail.run();
};
/**
 * 닫기
 */
doClose = function() {
    $layer.dialog("close");
};
</script>
</head>

<body>
<h3 class="content-title"><spring:message code="글:로그인:비밀번호찾기"/></h3>

<form id="FormFindPassword" name="FormFindPassword" method="post" onsubmit="return false;">
    <input type="hidden" name="link" value="<c:out value="${aoffn:config('system.domain')}"/><c:url value="/common/security.jsp?param=findPw"/>">
    <textarea name="message" style="display:none">
&lt;div>
비밀번호를 변경하려면 다음 링크를 클릭하세요. 5분 이내에 변경 가능합니다.
&lt;/div>
&lt;div>
#LINK#
&lt;/div>
    </textarea>
    
    <table class="tbl-detail">
		<colgroup>
			<col style="width:20%" />
			<col  />
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code="필드:멤버:이메일개인"/></th>
				<td>
					<input type="text" name="email" style="width:250px;">
				</td>
			</tr>
		</tbody>
	</table>
	<spring:message code="글:로그인:등록된이메일주소확인후해당주소로비밀번호초기화메일을발송합니다"/>
    <div class="lybox-btn-r">
		<a href="javascript:void(0);" onclick="doFind();" class="btn blue"><span class="mid"><spring:message code="버튼:로그인:보내기"/></span></a>
	</div>
</form>
</body>
</html>